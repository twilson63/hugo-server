require 'sinatra'
require 'crack'
require 'git'


class HugoClient < Sinatra::Default
  COOKBOOKS = "git://github.com/twilson63/hugo-cookbooks.git"


  get '/' do
    "Welcome to Hugo Client"
  end

  post '/deploy/:app' do
    dna = request.body.read 
    # refresh cookbook library
    g = Git.clone(COOKBOOKS, :name => "hugo-cookbooks", :path => "/chef-repo")
    g.pull
    File.open('/chef-repo/dna.json','w').write(dna)
    # execute chef-solo with json
    %x("chef-solo -c /chef-repo/config/solo.rb -j /chef-repo/dna.json")

  rescue
    "Go Away"

  end
end
