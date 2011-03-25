require 'sinatra/base'

module Sinatra
	module SessionAuth
		
		module Helpers
		      def authenticated?
						session[:user]
		      end

		      def authenticate!
		        redirect '/login' unless authenticated?
		      end

		      def logout!
		        session[:user] = false
		      end
		
					def authenticate
						connection.bind_as(
							:base => base,
							:filter => "uid=#{params['username']}",
							:password => params['password']
						)
					end

					def connection
						Net::LDAP.new :host => settings.ldap['host'],
							:port => settings.ldap['port'],
							:encryption => :simple_tls
					end

					def base
						settings.ldap['host'].split('.').map { |s| "dc=#{s}" }.join(',')
					end
		end

		  def self.registered(app)
		      app.helpers SessionAuth::Helpers

		      app.get '/login' do
		        haml :'session/login', :layout => :'layouts/app'
		      end

		      app.post '/login' do
		        if authenticate
							session[:user] = params['username']
							session[:password] = params['password']
							flash[:notice] = "Welcome #{params['username']}"
		          redirect to '/'
		        else
		          session[:user] = false
							session[:password] = false
							flash[:error] = 'The username or password you entered is incorrect'
		          redirect to '/login'
		        end
		      end
		
					app.get '/logout' do
						logout!
						flash[:notice] = 'Successfully logged out'
						redirect to '/'
					end
					
				end
		
			private
			


	end
	register SessionAuth
end