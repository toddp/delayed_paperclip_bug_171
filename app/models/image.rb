class Image < ActiveRecord::Base
  #belongs_to :imageable, polymorphic: true
  #validates_associated :imageable
  validates_presence_of :attachment
  attr_accessible :image_type
  attr_accessor :rotate
  has_attached_file :attachment, 


  #styles: {
  #  thumb: '50x50#',
  #  square: '250x250#',
  #},
  # delegate to specific model for sizes
   #styles: Proc.new {|a| a.instance.imageable_type.constantize.image_styles},
   styles: 
    {
      original: {geometry: ''},
      thumb: {geometry: '50x50#'},
      square: {geometry: '250x250#'},
    },

   processors: [:rotator],

  convert_options: {
    original: " -quality 100",
    square: " -quality 60",
    thumb: " -quality 60"
  },

  path: ":class/:attachment/:id_timestamp/:basename/:style.:extension",
  s3_host_alias: ENV['PAPERCLIP_CLOUDFRONT_HOST'],
  url: ':s3_alias_url',
  default_url: '/assets/home_stuff.png',
  s3_protocol: ''


  validates_attachment_content_type :attachment, 
    content_type: %w(image/jpeg image/jpg image/png image/gif)
  validates_attachment_size :attachment, { in: 0..2.megabytes }
  process_in_background :attachment


end

module Paperclip
  class Rotator < Thumbnail

    def transformation_command
      if rotate_command
         rotate_command + super.join(' ')
      else
        super
      end
    end

    def rotate_command
      target = @attachment.instance
      if target.rotate.present?
        " -rotate #{target.rotate} "
        #" -flip "
      end
    end
  end
end

