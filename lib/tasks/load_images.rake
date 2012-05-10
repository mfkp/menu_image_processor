desc "load images from menu_items directory and process them"
task :load_images => :environment do
	Dir.glob("app/assets/images/menu_items/**/").each do |dir|
		d = Dir.new(dir)
		puts ""
		puts "inside of #{d.path}"
		while (filename = d.read) do 
			if (File.file?(d.path + filename))
				formatted = filename.sub(/\..*/, '').gsub(/_/, ' ').downcase
				taglist = formatted.gsub(/\d/, '').gsub(/s\b/, '').strip.gsub(/ /, ', ')
				path = d.path.sub("app/assets/images/menu_items/","")
				if (Picture.find_by_path(path + filename).nil?)
					pic = Picture.new(:name => formatted, :path => path + filename)
					pic.tag_list = taglist
					pic.save
					puts "#{pic.id}: saved #{filename}"
				end
			end
		end
	end
end