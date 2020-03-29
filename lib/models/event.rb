class Event
    include Mongoid::Document
    include Mongoid::Attributes::Dynamic
    include Mongoid::Timestamps
    
    field :host, type: String
    field :port, type: String
    field :logs, type: Array, default: []
    field :geolocation, type: String
    field :country, type: String
    field :latitude, type: String
    field :longitude, type: String
end