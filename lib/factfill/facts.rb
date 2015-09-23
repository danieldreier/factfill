require 'yaml'
require 'json'
require 'net/http'

module Factfill

  class Facts
    def self.submit(path)
      submit_dir(path) if File.directory?(path)
      submit_factfile(path) if File.file?(path)
    end

    private

    def self.submit_dir(path)
      Dir.glob(path + '/*.yaml') do |yaml_file|
        submit_factfile(yaml_file)
      end
    end

    def self.submit_factfile(filename)
      data = read_factfile(filename)
      certname = data['name']
      values = data['values']
      environment = data['values']['current_environment']

      payload = {"command" => "replace facts",
                    "version"=>4,"payload"=> {
                      "certname" => certname,
                      "environment" => environment,
                      "values" => values,
                      "producer_timestamp" => Time.now.strftime("%m-%d-%Y")
                      }
                    }
      host = 'localhost'

      post(host, payload.to_json)
    end

    def self.read_factfile(path)
      text = ""
      linenum = 0
      #path = "pl-lb01-stage.puppetlabs.com.yaml"
      File.open(path).each_line do |line|
          # skip first line
          text += line unless linenum == 0
          linenum += 1
      end
      return YAML.load(text)
    end

    def self.post(host, payload)
      resource = '/pdb/cmd/v1'
      port = 8080
      req = Net::HTTP::Post.new(resource, {
        'Content-Type' => 'application/json',
        'Accept'       => 'application/json',
      })
      req.body = payload
      response = Net::HTTP.new(host, port).start {|http| http.request(req) }
        puts "Response #{response.code} #{response.message}:
      #{response.body}"
    end

  end
end
