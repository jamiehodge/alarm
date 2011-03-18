class App < Sinatra::Base
	
	get '/feeds/:feed_id/episodes/:episode_id' do
		feed = Atom::Feed.with_uri("#{settings.pcp['library']}/atom_feeds/#{params[:feed_id]}")
		haml :'episodes/show',
			:layout => :'layouts/app',
			:locals => { :feed => feed, :episode => feed.entry(params[:episode_id])}
	end

	get '/feeds/:feed_id/episodes/:episode_id/edit' do
		authenticate!
		session[:return_to] = request.path_info
		feed = Atom::Feed.with_uri("#{settings.pcp['library']}/atom_feeds/#{params[:feed_id]}")
		haml :'episodes/edit',
			:layout => :'layouts/app',
			:locals => { :feed => feed, :episode => feed.entry(params[:episode_id])}
	end

	put '/episodes/:id' do
		authenticate!
		prb = PodcastProducer::PRB.new(params[:id])
		prb.set_property(params[:property_name], params[:property_value]).save
		prb.synchronize
	end

	post '/feeds/:feed_id/episodes/:episode_id/comments' do
		comment = Comment.new(
			params.merge(
				:published => Time.now,
				:user_ip => request.ip,
				:user_agent => request.user_agent,
				:referrer => request.referrer,
				:feed_id => params[:feed_id],
				:episode_id => params[:episode_id]
		))
		comment.save unless comment.spam?
		redirect request.referer 
	end
	
end