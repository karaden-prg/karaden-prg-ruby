module Karaden
  class Utility
    OBJECT_TYPES = {
      Karaden::Model::Error::OBJECT_NAME => Karaden::Model::Error,
      Karaden::Model::Collection::OBJECT_NAME => Karaden::Model::Collection,
      Karaden::Model::Message::OBJECT_NAME => Karaden::Model::Message
    }.freeze

    def self.convert_to_karaden_object(contents, request_options)
      clazz = OBJECT_TYPES[contents['object']] || Karaden::Model::KaradenObject
      construct_from(clazz, contents, request_options)
    end

    def self.construct_from(clazz, contents, request_options)
      object = clazz.new(contents['id'], request_options)
      contents.each_pair do |key, value|
        v = if value.is_a?(Array)
              convert_to_array(value, request_options)
            elsif value.is_a?(Hash)
              convert_to_karaden_object(value, request_options)
            else
              value
            end
        object.set_property(key, v)
      end
      object
    end

    def self.convert_to_array(contents, request_options)
      contents.map do |v|
        v.is_a?(Hash) ? convert_to_karaden_object(v, request_options) : v
      end
    end
  end
end
