class App < Sinatra::Base
	
	get '/feed/:feed_id/episode/:episode_id' do
		feed = open_resource("#{settings.pcp['library']}/atom_feeds/#{params[:feed_id]}")
		etag feed.meta['etag'].gsub(/"/, '') unless flash.has?(:notice) || flash.has?(:error)
		parsed_feed = Atom::Feed.parse(feed)
		@title = "#{settings.site['title']}: #{parsed_feed.entry(params[:episode_id]).title}"
		haml :'episodes/show',
			:layout => :'layouts/app',
			:locals => { :feed => parsed_feed, :episode => parsed_feed.entry(params[:episode_id])}
	end

	get '/feed/:feed_id/episode/:episode_id/edit' do
		authenticate!
		feed = open_resource("#{settings.pcp['library']}/atom_feeds/#{params[:feed_id]}")
		etag feed.meta['etag'].gsub(/"/, '')
		parsed_feed = Atom::Feed.parse(feed)
		@title = "#{settings.site['title']}: #{parsed_feed.entry(params[:episode_id]).title}"
		session[:return_to] = request.path_info
		haml :'episodes/edit',
			:layout => :'layouts/app',
			:locals => { :feed => parsed_feed, :episode => parsed_feed.entry(params[:episode_id])}
	end

	put '/episode/:id' do
		authenticate!
		prb = PodcastProducer::PRB.new(params[:id])
		prb.set_property(params[:property_name], params[:property_value]).save
		prb.synchronize
	end

	post '/feed/:feed_id/episode/:episode_id/comments' do
		comment = Comment.new(
			params[:comment].merge(
				:published => Time.now,
				:user_ip => request.ip,
				:user_agent => request.user_agent,
				:referrer => request.referrer,
				:episode_id => params[:episode_id],
				:permalink => "#{base_url}/feed/#{params[:feed_id]}/episode/#{params[:episode_id]}"
		))
		if !comment.spam? && comment.save
			flash[:notice] = t.flash.comment_success
			puts comment
		else
			flash[:error] = t.flash.comment_failed
		end
		redirect url("/feed/#{params[:feed_id]}")
	end

	get '/feed/:feed_id/episode/:episode_id/embed' do
		feed = open_resource("#{settings.pcp['library']}/atom_feeds/#{params[:feed_id]}")
		etag feed.meta['etag'].gsub(/"/, '')
		parsed_feed = Atom::Feed.parse(feed)
		@title = "#{settings.site['title']}: #{parsed_feed.entry(params[:episode_id]).title}"
		haml :'episodes/embed',
			:layout => :'layouts/embed',
			:locals => { :feed => parsed_feed, :episode => parsed_feed.entry(params[:episode_id])}
	end
	
end