class TweetsController < ApplicationController

    get '/tweets' do
        @tweets = Tweet.all
        if !logged_in?
            redirect '/login'
        end
        @user = current_user
        erb :'/tweets/index'
    end

    post '/tweets' do
        if !logged_in?
            redirect '/login'
        end

        if !params[:content].empty?
            @tweet = Tweet.create(content: params[:content], user_id: current_user.id)
            redirect "/tweets/#{@tweet.id}"
        end

        redirect "/tweets/new"
    end

    get '/tweets/new' do
        if logged_in?
            erb :'/tweets/new'
        else
            redirect '/login'
        end
    end

    get '/tweets/:id/edit' do
        if logged_in?
            @tweet = Tweet.find(params[:id])
            if current_user.id == @tweet.user.id
                erb :'/tweets/edit'
            else
                redirect '/tweets'
            end
        else 
            redirect '/login'
        end
    end

    get '/tweets/:id' do
        @tweet = Tweet.find(params[:id])
        if !logged_in?
            redirect :'/login'
        end
        erb :'/tweets/show'
    end

    patch '/tweets/:id' do
        @tweet = Tweet.find(params[:id])
        if params[:content].empty?
            redirect "/tweets/#{params[:id]}/edit"
        end
        @tweet.update(content: params[:content])

        redirect "/tweets/#{@tweet.id}"
    end

    delete '/tweets/:id' do
        @tweet = Tweet.find(params[:id])
        if logged_in? && current_user.id == @tweet.user.id
            @tweet.destroy
        end
        redirect "/tweets"
    end
end
