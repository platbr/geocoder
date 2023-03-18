require 'geocoder/results/base'

module Geocoder::Result
  class ProxycheckIo < Base

    def address(format = :full)
      s = region_code.empty? ? "" : ", #{region_code}"
      "#{city}#{s} #{zip}, #{country_name}".sub(/^[ ,]*/, "")
    end

    def state
      @data['region']
    end

    def state_code
      @data['regioncode']
    end

    def country
      @data['country']
    end

    def postal_code
      @data['postcode']
    end

    def self.response_attributes
      [
        ['asn', ''],
        ['city', ''],
        ['risk', 0],
        ['type', ''],
        ['proxy', ''],
        ['region', ''],
        ['country', ''],
        ['isocode', ''],
        ['currency', {}],
        ['latitude', 0],
        ['longitude', 0],
        ['postcode', ''],
        ['provider', ''],
        ['timezone', ''],
        ['continent', ''],
        ['regioncode', ''],
        ['organisation', ''],
      ]
    end

    response_attributes.each do |attr, default|
      define_method attr do
        @data[attr] || default
      end
    end

    def metro_code
      Geocoder.log(:warn, "Proxycheck.io does not implement `metro_code` in api results.  Please discontinue use.")
      0 # no longer implemented by ipstack
    end
  end
end
