require 'spec_helper'

describe "Gauges API" do

  before :each do
    @accept_format = {"Accept" => "application/json"}
  end

  describe "GET /api/v1/gauges" do
    it "returns all the gauges in valid geo_json" do
      file_path = File.expand_path('../../data/gauge_geojson', __FILE__)
      mock_gauges = File.read(file_path)
      Gauge.stub(:all_gauges_in_geojson).and_return(JSON.parse(mock_gauges))

      get "/api/v1/gauges", {}, @accept_format

      expect(response.status).to eq 200

      body = JSON.parse(response.body)

      gauge_names = body.map {|gauge| gauge["properties"]["title"]}
      expect(gauge_names).to match_array(["foo", "bar"])

      gauge_types = body.map {|gauge| gauge["geometry"]["type"]}
      expect(gauge_types).to match_array(["Point", "Point"])

      coords = body.map {|gauge| gauge["geometry"]["coordinates"]}
      expect(coords).to match_array([ ["10.0","100.0"], ["-107.316","39.54"] ])

      marker_colors = body.map {|gauge| gauge["properties"]["marker-color"]}
      expect(marker_colors).to match_array(["#fc4353", "#fc4353"])

      marker_sizes = body.map {|gauge| gauge["properties"]["marker-size"]}
      expect(marker_sizes).to match_array(["large", "large"])

      marker_symbols = body.map {|gauge| gauge["properties"]["marker-symbol"]}
      expect(marker_symbols).to match_array(["monument", "monument"])
    end
  end

end
