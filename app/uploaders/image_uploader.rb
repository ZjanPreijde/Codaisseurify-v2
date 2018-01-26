class ImageUploader < CarrierWave::Uploader::Base
  include Cloudinary::CarrierWave

  version :thumb do
    eager
    resize_to_fit(100, 100)
    cloudinary_transformation :quality => 80
  end

  version :medium do
    eager
    resize_to_fit(300, 300)
    cloudinary_transformation :quality => 80
  end
  # version :pop-art do; end # How to do this?

end
