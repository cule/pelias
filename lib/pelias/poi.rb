module Pelias

  class Poi < Base

    SUGGEST_WEIGHT = 6

    attr_accessor :id
    attr_accessor :name
    attr_accessor :number
    attr_accessor :phone
    attr_accessor :website
    attr_accessor :category
    attr_accessor :center_point
    attr_accessor :center_shape
    attr_accessor :street_name
    attr_accessor :country_code
    attr_accessor :country_name
    attr_accessor :admin1_code
    attr_accessor :admin1_name
    # encompassing shape attributes
    attr_accessor :admin2_id
    attr_accessor :admin2_name
    attr_accessor :admin2_alternate_names
    attr_accessor :admin2_population
    attr_accessor :locality_id
    attr_accessor :locality_name
    attr_accessor :locality_alternate_names
    attr_accessor :locality_population
    attr_accessor :local_admin_id
    attr_accessor :local_admin_name
    attr_accessor :local_admin_alternate_names
    attr_accessor :local_admin_population
    attr_accessor :neighborhood_id
    attr_accessor :neighborhood_name
    attr_accessor :neighborhood_alternate_names
    attr_accessor :neighborhood_population

    def encompassing_shapes
      %w(admin2 local_admin locality neighborhood)
    end

    def suggest_weight
      (locality_name || local_admin_name) ? SUGGEST_WEIGHT : 0
    end

    def generate_suggestions
      input = "#{name}"
      output = "#{name}"
      if number && street_name
        input << " #{number} #{street_name}"
        output << " - #{number} #{street_name}"
      end
      if local_admin_name
        input << " #{local_admin_name}"
        output << " - #{local_admin_name}"
      elsif locality_name
        input << " #{locality_name}"
        output << " - #{locality_name}"
      end
      if admin1_abbr
        input << " #{admin1_abbr}"
        output << ", #{admin1_abbr}"
      elsif admin1_name
        input << " #{admin1_name}"
        output << ", #{admin1_name}"
      end
      {
        input: input,
        output: output,
        weight: suggest_weight,
        payload: {
          lat: lat,
          lon: lon,
          type: type,
          country_code: country_code,
          country_name: country_name,
          admin1_abbr: admin1_abbr,
          admin1_name: admin1_name,
          admin2_name: admin2_name,
          locality_name: locality_name,
          local_admin_name: local_admin_name
        }
      }
    end

    def self.street_level?
      true
    end

  end

end