class SeedHelper
  class << self

    def seed_all
      data = JSON.parse(File.read("#{Rails.root}/config/defaults.json"))

      data['tags'].each do |tag|
        Tag.create(name: tag["name"], short_name: tag["short_name"], context: tag["context"])
      end
    end
    
  end
end