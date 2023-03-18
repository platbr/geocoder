require 'geocoder/lookups/base'
require 'geocoder/results/proxycheck_io'

module Geocoder::Lookup
  class ProxycheckIo < Base
    def name
      "Proxycheck.io"
    end

    private # ----------------------------------------------------------------

    def base_query_url(query)
      "#{protocol}://#{host}/v2/#{query.sanitized_text.gsub(/\s/, '')}?"
    end

    def query_url_params(query)
      {
        key: configuration.api_key,
        asn: 1,
        risk: 1
      }.merge(super)
    end

    def results(query) 
      # don't look up a loopback or private address, just return the stored result
      return [reserved_result(query.text)] if query.internal_ip_address?

      return [] unless doc = fetch_data(query)

      if doc['status'] == 'error'
        msg = doc['message']
        raise_error(Geocoder::Error, msg ) || Geocoder.log(:warn, "Proxycheck.io Geocoding API error: #{msg}")
        return []
      end
      [doc[query.text]]
    end

    def reserved_result(ip)
      {
        "ip"           => ip,
        "country_name" => "Reserved",
        "country_code" => "RD"
      }
    end

    def host
      configuration[:host] || "proxycheck.io"
    end
  end
end
