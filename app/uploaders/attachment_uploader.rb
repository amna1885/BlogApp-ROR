# frozen_string_literal: true

class AttachmentUploader < CarrierWave::Uploader::Base
  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  # include CarrierWave::MiniMagick
  include Cloudinary::CarrierWave

  # Choose what kind of storage to use for this uploader:
  # storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "attachments/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def extension_whitelist
    %w[jpg jpeg gif png pdf]
  end

  def self.upload(file)
    Cloudinary.config do |config|
      config.cloud_name = 'dvv93vh8p'
      config.api_key = '274658269941387'
      config.api_secret = 'Oa3ISWmOCXDzHm5iK4yqBR1Qy5M'
    end
    response = Cloudinary::Uploader.upload(file,
                                           public_id: "attachments/#{SecureRandom.uuid}/#{file.original_filename}")
    response['public_id']
  end

  def self.url(public_id)
    "https://res.cloudinary.com/#{Cloudinary.config.cloud_name}/image/upload/#{public_id}"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url(*args)
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded:
  # process scale: [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:
  # version :thumb do
  #   process resize_to_fit: [50, 50]
  # end

  # Add an allowlist of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  # def extension_allowlist
  #   %w(jpg jpeg gif png)
  # end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  def filename
    "attachment_#{SecureRandom.uuid}.#{file.extension}" if original_filename
  end
end
