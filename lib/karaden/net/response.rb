module Karaden
  module Net
    class Response < ResponseInterface
      ERRORS = {
        Karaden::Exception::BadRequestException::STATUS_CODE => Karaden::Exception::BadRequestException,
        Karaden::Exception::UnauthorizedException::STATUS_CODE => Karaden::Exception::UnauthorizedException,
        Karaden::Exception::NotFoundException::STATUS_CODE => Karaden::Exception::NotFoundException,
        Karaden::Exception::ForbiddenException::STATUS_CODE => Karaden::Exception::ForbiddenException,
        Karaden::Exception::UnprocessableEntityException::STATUS_CODE => Karaden::Exception::UnprocessableEntityException,
        Karaden::Exception::TooManyRequestsException::STATUS_CODE => Karaden::Exception::TooManyRequestsException
      }.freeze

      def initialize(response, request_options)
        @error = nil
        @object = nil
        super()
        interpret(response, request_options)
      end

      def error()
        @error
      end

      def object()
        @object
      end

      def error?()
        !@error.nil?
      end

      protected

      def handle_error(code, headers, body, error)
        clazz = ERRORS[code]
        object = if clazz
                   clazz.new
                 else
                   UnknownErrorException.new
                 end
        object.headers = headers
        object.body = body
        object.error = error
        object
      end

      def interpret(response, request_options)
        code = response.code.to_i
        body = response.body
        headers = response.response.each_header.to_h
        contents = JSON.parse(response.body)
        @object = Karaden::Utility.convert_to_karaden_object(contents, request_options)
        if code < 200 || code >= 400
          @error = if @object.is_a?(Karaden::Model::Error)
                     handle_error(code, headers, body, @object)
                   else
                     Karaden::Exception::UnexpectedValueException.new
                   end
          @error.code = code
          @error.headers = headers
          @error.body = body
        end
      rescue StandardError => _e
        @error = Karaden::Exception::UnexpectedValueException.new
        @error.code = code
        @error.headers = headers
        @error.body = body
      end
    end
  end
end
