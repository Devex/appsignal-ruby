describe Appsignal::Hooks::NetHttpHook do
  before :all do
    start_agent
  end

  context "with Net::HTTP instrumentation enabled" do
    its(:dependencies_present?) { should be_true }

    it "should instrument a http request" do
      Appsignal::Transaction.create('uuid', Appsignal::Transaction::HTTP_REQUEST, 'test')
      expect( Appsignal::Transaction.current ).to receive(:start_event)
        .at_least(:once)
      expect( Appsignal::Transaction.current ).to receive(:finish_event)
        .at_least(:once)
        .with("request.net_http", "GET http://www.google.com", nil, 0)

      stub_request(:any, 'http://www.google.com/')

      Net::HTTP.get_response(URI.parse('http://www.google.com'))
    end

    it "should instrument a https request" do
      Appsignal::Transaction.create('uuid', Appsignal::Transaction::HTTP_REQUEST, 'test')
      expect( Appsignal::Transaction.current ).to receive(:start_event)
        .at_least(:once)
      expect( Appsignal::Transaction.current ).to receive(:finish_event)
        .at_least(:once)
        .with("request.net_http", "GET https://www.google.com", nil, 0)

      stub_request(:any, 'https://www.google.com/')

      uri = URI.parse('https://www.google.com')
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.get(uri.request_uri)
    end
  end

  context "with Net::HTTP instrumentation disabled" do
    before { Appsignal.config.config_hash[:instrument_net_http] = false }
    after { Appsignal.config.config_hash[:instrument_net_http] = true }

    its(:dependencies_present?) { should be_false }
  end
end
