

# App - Codaisseurify

#### Models - Basic Requirements

##### Generate the App

- Create a new Rails application called "Codaisseurify".
  - Make sure that the app uses PostgreSQL for the database.
  - It does not have turbolinks
  - Make sure that no test framework is installed by default when creating the app.

##### Models

- Create two models: `Song` and `Artist`.
- Define the relationship between them:
  - A song can only be linked to one artist.
  - An artist can have many songs.

##### Seeds

- Create some initial data adding some seeds to the database with some songs and artists.
- The seeds should reflect the association between every song and its artist.
- Use the Rails console to check that the database contains the data after seeding. Make the following checks:
  - Get the artist of the first song. Which command did you use?
  - Get all the songs for the first artist. Which command did you use?



*Create app Codaisseurify*, no testing (-T), postgresql as database, no turbolinks

```shell
$ rails new Codaisseurify -T --database=postgresql --skip-turbolinks  
$ cd Codaisseurify
$ rails server
>
```

(At this point the local git repository is also initiated, no need for `$ git init`)

*check* on : http://localhost:3000  -> Yay! You're on Rails! (shows Rails version, Ruby version)

```ruby
> Ctrl+C     to exit
```


Make sure there is always a database connection established when entering the Rails console.

*./config/application.rb*, add *console do* to existing code

```ruby
# config/application.rb

module Codaisseurify
  class Application < Rails::Application
    # Add next 3 lines
    console do
      ActiveRecord::Base.connection
    end
  end
end

```



*Create database*

```shell
$ rails db:create
Created database 'Codaisseurify_development'
Created database 'Codaisseurify_test'
```



*Create remote repository on github.com*

https://github.com/ZjanPreijde/Codaisseurify



*Update local repository, link it to remote repository and update remote repository*

```shell
$ git add . 
$ git commit -m "Created app Codaisseurify"
$ git remote add origin git@github.com:ZjanPreijde/Codaisseurify.git
$ git push origin master
```

***Commit changes regularly***

```shell
$ git add .
$ git commit -m "Meaningfull message"
```

*and push them to remote once in a while*

```shell
$ git push origin master
```

<u>Stumbled up on</u> :  (in another project)

When trying to link local repository to remote, I got the message :

```shell
$ git remote add origin git@github.com:ZjanPreijde/CodeDojo-TennisScore.git
fatal: remote origin already exists.
```

Apparently I had already done something, that made this impossible. 

Solved it by :

```shell
$ git remote set-url origin git@github.com:ZjanPreijde/CodeDojo-TennisScore.git
```



*Create home page*

```shell
$ rails generate controller Pages home
```

*./apps/controllers/pages_controller.rb* (is generated)

```ruby
class PagesController < ApplicationController
  def home
  end
end
```

*./config/routes.rb*  (is generated?)

```ruby
Rails.application.routes.draw do
  root to: 'pages#home'
end

```

* If Rspec is NOT set up as testing environment.
* Don know yet how Minitest tests and asserts. Check out later if necessary

*./spec/features/home_page_spec.rb*

```ruby
require 'test_helper'

class PageTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
```



- If Rspec IS set up as testing environment.

*spec/controllers/pages_controller_spec.rb* (is generated)

```ruby
# rspec spec/controllers/pages_controller_spec.rb
require 'rails_helper'

RSpec.describe PagesController, type: :controller do

  describe "GET #home" do
    it "returns http success" do
      get :home
      expect(response).to have_http_status(:success)
    end
  end

end
```
*spec/views/pages/home.html.erb_spec.rb*

```ruby
# rspec spec/views/pages/home.html.erb_spec.rb
require 'rails_helper'

RSpec.describe "pages/home.html.erb", type: :view do
  it "should return Rails default text" do
    visit root_url
    expect(page).to have_content "Pages#home"
  end
end
```


```shell
$ rspec
```

Unfortunately, this somehow does not work for me :-(   

```
Failure/Error: visit root_url
NoMethodError:
   undefined method `visit' for #<RSpec::ExampleGroups::PagesHomeHtml
```





*Generate models for Artist and Song, add relation to model Song* (through artist:references)

```shell
$ rails generate model Artist name:string image_url:string
Running via Spring preloader in process xxx
      invoke  active_record
      create    db/migrate/20180121174927_create_artists.rb
      create    app/models/artist.rb
      create    app/models/artist.rb
      invoke    rspec
      create      spec/models/artist_spec.rb
      invoke      factory_bot
      create        spec/factories/artists.rb


$ rails generate model Song title:string
RRunning via Spring preloader in process xxx
      invoke  active_record
      create    db/migrate/20180121175141_create_songs.rb
      create    app/models/song.rb
      invoke    rspec
      create      spec/models/song_spec.rb
      invoke      factory_bot
      create        spec/factories/songs.rb
1
$ rails db:migrate
```



If <u>relation</u> was <u>not defined</u> during model creation, it can be done after through a new migration :

*Define relation after model is created without reference*

```shell
$ rails generate migration AddArtistToSongs artist:references
Running via Spring preloader in process 28846
      invoke  active_record
      create    db/migrate/20180120150713_add_artist_to_song.rb
$ rails db:migrate
```

If relation pre-existed, this migration will generate an error 

```ruby
PG::DuplicateColumn: Error column "artist_id" of relation "song" already exists.
```

 Just delete the migration from ./db/migrate/, content has not been executed.



*Edit ./app/models/artist.rb*    (check colons, spaces and positions!)

```ruby
class Artist
	has_many :songs, dependent: :destroy
end
```



*Create seeds in ./db/seeds.rb*

```ruby
Song.destroy_all
Artist.destroy_all

# Seed artists, keep values
meatloaf = Artist.create!(name: "MeatLoaf", image_url: "")
redhot   = Artist.create!(name: "Red Hot Chili Peppers", image_url: "")
jay      =  Artist.create!(name: "Screamin'Jay Hawkins", image_url: "")

# Seed songs
Song.create!(title: "Paradise by the Dashboard Light", artist: meatloaf)
Song.create!(title: "Heaven Can Wait", artist: meatloaf)
Song.create!(title: "All Revved Up With No Place To Go", artist: meatloaf)

Song.create!(title: "Californication", artist: redhot)
Song.create!(title: "Under the Bridge", artist: redhot)
Song.create!(title: "Give It Away", artist: redhot)

Song.create!(title: "Californication", artist: jay)
Song.create!(title: "Under the Bridge", artist: jay)
Song.create!(title: "Give It Away", artist: jay)
```



*Run the seed*

```shell
$ rails db:seed
```



*Check in console*, always keep rails console running in a separate terminal

```shell
$ rails console
```

```ruby
> Artist.first
> Song.first
> Song.last.artist.name
```



------



#### Controllers & Views - Basic requirements

##### Artists Overview Page

Add an artists overview page that meets the following requirements:

- Visitors can see a list of all the artists.
- Each artist has one picture. It will be added to the app with an uploader. You will host this file in Cloudinary
- When clicking on the name of an artist, visitors are redirected to the artist show page.

#### Artist Show Page

Add a show page for every artist that meets the following requirements:

- Visitors can see a list of all the songs associated to the artist.
- Visitors can add a new song to the artist.
- Visitors can remove any song associated to the artist.
- Visitors can delete an artist, including all songs associated to that artist.

#### Model Tests

- Add some validations to the `Song` and `Artist` models. Write corresponding tests for it using RSpec, FactoryGirl. (use Faker if you have to).
- Write tests related to the association between the `Song` and `Artist` models.
- In short: each and every concept in your model is tested!

#### Deployment

- Configure app to be deployed
- Heroku is installed
- Cloudinary environment variable is set




<u>*Setup styling*</u>

*.Gemfile*

```ruby
# Use Bootstrap for styling
gem 'bootstrap-sass', '~> 3.3.6'

# Use jQuery for easier javascript
gem 'jquery-rails', '~> 4.3.1'
```

```shell
$ spring stop
$ bundle install
```

**!!** *Change extension of ./app/assets/stylesheets/application.css to .scss*

*./app/assets/stylesheets/application.scss*, pull Bootstrap into the app

```css
@import "bootstrap-sprockets";
@import "bootstrap";
```

*./app/assets/javascripts/application.js*, replace content with

```js
// application.js

//= require jquery
//= require bootstrap-sprockets
//= require jquery_ujs
//= require_tree .
```

*Restart rails server*

<u>Stumbled up on</u> :

- Don't forget to change the extension of application.css to .scss




<u>*Set up CarrierWave and Cloudinary*</u>

*.Gemfile*

```ruby
# Set up CarrierWave for image handling
gem 'carrierwave', '0.11.2'

# Set up Cloudinary for cloud storage
gem 'cloudinary', '1.2.3'
```

```shell
$ spring stop
$ bundle install
```

```shell
$ rails generate uploader image
```

*Edit ./apps/uploaders/image_uploader*, make it look like this

```ruby
class ImageUploader < CarrierWave::Uploader::Base
  include Cloudinary::CarrierWave
end
```



<u>*Setup Rspec testing*</u>

* default is Minitest

*.Gemfile*

```ruby
# For testing
group :development, :test do
  gem 'rspec-rails', '~> 3.5', '>= 3.5.2'
end

group :test do
  gem 'capybara', '~> 2.9', '>= 2.9.1'
  gem 'shoulda-matchers', '~> 3.1'
end

group :development, :test do
  gem 'factory_bot_rails'
  gem 'faker'
end
```

```shell
$ spring stop
$ bundle install
```

*Setup Rspec for application*

```shell
$ spring stop
$ rails generate rspec:install
$ rbenv rehash
$ rails db:migrate
$ rspec
```

*spec/support/factory_bot.rb* (create folder and file)

```ruby
# spec/support/factory_bot.rb

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
end

```

*spec/rails_helper.rb*, uncomment line

```ruby
# spec/rails_helper.rb

Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

```

When using Devise for user authentication :

*spec/support/devise.rb*, create file

```ruby
# spec/support/devise.rb

RSpec.configure do |config|
  config.include Devise::Test::ControllerHelpers, type: :controller
  config.include Devise::Test::ControllerHelpers, type: :view
  config.include Warden::Test::Helpers
end
```





<u>*Setup deployment*</u>

* Heroku is installed on local machine
* $ heroku auth:whoami   =>  YOUR_USER_NAME
* You must always be in the <u>master branch</u> when pushing code to Heroku

*.Gemfile*, top of file :

```ruby
source 'https://rubygems.org'
# Add next line
ruby '2.4.1'
```

*.Gemfile*

```ruby
# For deployment
gem 'rails_12factor', group: :production
```

```shell
$ spring stop
$ bundle install
```

*Set up Heroku app locally*

* Heroku needs an app-name

```shell
$ heroku create cfy-zjan-ii
```

App running at   https://cfy-zjan-ii.herokuapp.com/ 

<u>Stumbled up on</u> :

- Heroku does not know what to do before you define the app-name for current project.
- Only lowercase characters and dashes in app-name



If Cloudinary is set up ( Cloudinary environment variable is set):

*Config heroku to use content hosting service*

```shell
$ heroku config:set CLOUDINARY_URL=$CLOUDINARY_URL
```




*Create controllers for Artists and Songs*

```shell
$ rails generate controller Artists
$ rails generate controller Songs
```



*./apps/views/pages/home.html.erb*

```html
<div class="row">
  <div class="col-md-6 col-md-offset-3">
    <h1 class="text-center">Codaisseurify!</h1>
    <div class="col-md-12 text-center">
      Ready for a whole new Spotify?
    </div>
  </div>
</div>
```

*./config/routes.rb*, setup routing

```ruby
Rails.application.routes.draw do
  get 'pages/home'
  resources :artists
  resources :artists do
    resources :songs
end
```

*Push to github*

*Deploy to heroku*

```shell
$ git add .
$ git commit -m "Gems installed for styling, image uploading and hosting, testing, deployment. Home page set up"
$ git push origin master
$ git push heroku master
```

App on Heroku : https://cfy-zjan.herokuapp.com/

<u>Stumbled up on</u> : 

- Heroku deployment process : Warning: the running version of Bundler (1.15.2) is older than the version that created the lockfile (1.16.1). We suggest you upgrade to the latest version of Bundler by running `gem install bundler`.
- When generating a new Rails app, one of the messages is `Using bundler 1.16.1`
- What's happening? What is the running version of Bundler?





- [x] Local Home page is up
- [x] Push to github
- [x] Deploy to Heroku
- [x] Heroku Home page is up





*Create Artists Overview Page*

*./apps/models/artist.rb*

```
no change
```

*./app/views/artists/index.html.erb*

```erb
      <div class="panel-heading">
        <p><%= @artist.name %></p>
      </div>

      <div class="panel-body">
      <% @songs.each do |song| %>
        <div class="col-md-12">
          <p>
            <%= song.title %>
          </p>
        </div>
      <% end %>
      </div>
      <hr>
```

*./apps/controllers/artist_controller.rb*

```ruby
  def index
    @artists = Artist.all
  end
```



*Create Artist Show Page*

*./apps/models/artist.rb*

```
no change
```

*./apps/views/artists/show.html.erb*

```erb
      <div class="panel-heading">
        <p><%= @artist.name %></p>
      </div>

      <div class="panel-body">
      <% @songs.each do |song| %>
        <div class="col-md-12">
          <p>
            <%= song.title %>
          </p>
        </div>
      <% end %>
      </div>
```

*./apps/controllers/artist_controller.rb*

```ruby
  before_action :set_artist, only: %i[show edit update]

  def show
    @songs = @artist.songs
  end

private

  def set_artist
    @artist = Artist.find(params[:id])
  end

  def artist_params
    params
      .require(:artist)
      .permit(:name)
  end

```

