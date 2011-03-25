class App < Sinatra::Base
	
	get '/feeds/:feed_id/episodes/:episode_id' do
		feed = open_resource("#{settings.pcp['library']}/atom_feeds/#{params[:feed_id]}")
		etag feed.meta['etag'].gsub(/"/, '') unless flash.has?(:notice) || flash.has?(:error)
		parsed_feed = Atom::Feed.parse(feed)
		haml :'episodes/show',
			:layout => :'layouts/app',
			:locals => { :feed => parsed_feed, :episode => parsed_feed.entry(params[:episode_id])}
	end

	get '/feeds/:feed_id/episodes/:episode_id/edit' do
		authenticate!
		feed = open_resource("#{settings.pcp['library']}/atom_feeds/#{params[:feed_id]}")
		etag feed.meta['etag'].gsub(/"/, '')
		parsed_feed = Atom::Feed.parse(feed)
		session[:return_to] = request.path_info
		haml :'episodes/edit',
			:layout => :'layouts/app',
			:locals => { :feed => parsed_feed, :episode => parsed_feed.entry(params[:episode_id])}
	end

	put '/episodes/:id' do
		authenticate!
		prb = PodcastProducer::PRB.new(params[:id])
		prb.set_property(params[:property_name], params[:property_value]).save
		prb.synchronize
	end

	post '/feeds/:feed_id/episodes/:episode_id/comments' do
		comment = Comment.new(
			params[:comment].merge(
				:published => Time.now,
				:user_ip => request.ip,
				:user_agent => request.user_agent,
				:referrer => request.referrer,
				:episode_id => params[:episode_id],
				:permalink => "#{base_url}/feeds/#{params[:feed_id]}/episodes/#{params[:episode_id]}"
		))
		if !comment.spam? && comment.save
			flash[:notice] = 'Thank you for your comments'
			puts comment
		else
			flash[:error] = 'Please resubmit your comments'
		end
		redirect "/feeds/#{params[:feed_id]}"
	end

	get '/feeds/:feed_id/episodes/:episode_id/embed' do
		feed = open_resource("#{settings.pcp['library']}/atom_feeds/#{params[:feed_id]}")
		etag feed.meta['etag'].gsub(/"/, '')
		parsed_feed = Atom::Feed.parse(feed)
		haml :'episodes/embed',
			:layout => :'layouts/embed',
			:locals => { :feed => parsed_feed, :episode => parsed_feed.entry(params[:episode_id])}
	end
	
end