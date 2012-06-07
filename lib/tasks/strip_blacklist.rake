desc 'Remove blacklisted tags from existing picture entries'
task :strip_blacklist => :environment do
	puts "Processing... please wait."
	Picture.all.each do |picture|
		tags = picture.tag_list
		# Remove blacklisted tags
		tags = Menu.remove_blacklist(tags)
		# Remove any non-alphabetic characters
		tags.each do |tag|
			tag.gsub!(/[^a-z]/, '')
		end
		# Update the tags
		picture.save
		puts "Updated ##{picture.id}: #{picture.name}"
	end
	puts "Done."
end