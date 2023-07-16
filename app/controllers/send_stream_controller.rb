class SendStreamController < ApplicationController
  include ActionController::Live

  EXPECTED_RESPONSE = "Hello, World!"

  def broken
    # this emulates ActiveStorage when proxing file content via ActiveStorage::Blobs::ProxyController
    # - https://github.com/rails/rails/blob/main/activestorage/app/controllers/active_storage/blobs/proxy_controller.rb#L19
    response.headers["Content-Length"] = EXPECTED_RESPONSE.bytes.size

    send_stream(filename: "example.txt", disposition: params[:disposition], type: 'application/octet-stream') do |stream|
      # This can happen if the backing ActiveStorage file no longer exists inside of the storage provider (eg: AWS S3 Bucket)
      raise StandardError, "This will cause the stream to hang"
    end
  end

  def working_simulating_partial_write
    # this emulates ActiveStorage when proxing file content via ActiveStorage::Blobs::ProxyController
    # - https://github.com/rails/rails/blob/main/activestorage/app/controllers/active_storage/blobs/proxy_controller.rb#L19
    response.headers["Content-Length"] = EXPECTED_RESPONSE.bytes.size

    send_stream(filename: "example.txt", disposition: params[:disposition], type: 'application/octet-stream') do |stream|
      # This gets called inside of `response.stream.write`
      # - https://github.com/rails/rails/blob/main/actionpack/lib/action_controller/metal/live.rb#L178
      # which is called from ActiveStorage in `send_blob_stream`
      # - https://github.com/rails/rails/blob/main/activestorage/app/controllers/concerns/active_storage/streaming.rb#L62
      unless response.committed?
        response.delete_header "Content-Length"
      end

      # This is to show that exceptions after the first "write" will not cause an issue
      raise StandardError, "This seems to work"
    end
  end

  def working_with_partial_write
    # this emulates ActiveStorage when proxing file content via ActiveStorage::Blobs::ProxyController
    # - https://github.com/rails/rails/blob/main/activestorage/app/controllers/active_storage/blobs/proxy_controller.rb#L19
    response.headers["Content-Length"] = EXPECTED_RESPONSE.bytes.size

    send_stream(filename: "example.txt", disposition: params[:disposition], type: 'application/octet-stream') do |stream|
      stream.write EXPECTED_RESPONSE[0..2]

      # This is to show that exceptions after the first "write" will not cause an issue
      raise StandardError, "This seems to work"
    end
  end

  def working_with_full_write
    # this emulates ActiveStorage when proxing file content via ActiveStorage::Blobs::ProxyController
    # - https://github.com/rails/rails/blob/main/activestorage/app/controllers/active_storage/blobs/proxy_controller.rb#L19
    response.headers["Content-Length"] = EXPECTED_RESPONSE.bytes.size

    send_stream(filename: "example.txt", disposition: params[:disposition], type: 'application/octet-stream') do |stream|
      # This is the control case to show it fully working without an exception
      stream.write EXPECTED_RESPONSE
    end
  end
end
