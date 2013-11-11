require 'pelias'

namespace :geonames do

  GEONAMES_FILE = 'data/geonames/US.txt' # just us for now
  GEONAMES_ADMIN1_FILTER = 'NY' # just ny for now

  desc "setup index & mappings"
  task :setup do
    schema_file = File.read('schemas/geonames.json')
    schema_json = JSON.parse(schema_file)
    Pelias::Base::ES_CLIENT.indices.create(index: 'geonames', body: schema_json)
  end

  desc "populate geonames index"
  task :populate_features do
    File.open(GEONAMES_FILE) do |fp|
      fp.each do |line|
        arr = line.chomp.split("\t")
        next unless arr[10] == GEONAMES_ADMIN1_FILTER
        Pelias::Base::ES_CLIENT.index(index: 'geonames', type: 'feature',
          id: arr[0], body: {
            name: arr[1],
            alternate_names: arr[3],
            location: { lat: arr[4], lon: arr[5] },
            feature_class: arr[6],
            feature_code: arr[7],
            country_code: arr[8],
            admin1_code: arr[10],
            admin2_code: arr[11],
            admin3_code: arr[12],
            admin4_code: arr[13],
            population: arr[14],
            elevation: arr[15],
            dem: arr[16],
            timezone: arr[17],
            modification_date: arr[18]
          }
        )
      end
    end
  end

end
