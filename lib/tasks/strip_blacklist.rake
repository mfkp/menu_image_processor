desc 'Remove blacklisted tags from existing picture entries'
task :strip_blacklist => :environment do
	pictures = Picture.find(:all)
	tags_blacklist = ['a', 'al', 'and', 'e', 'in', 'le', 'n', 'of', 'on', 'the', 'with']
	pictures.each do |picture|
		tags = picture.tag_list
		# Remove blacklisted tags
		tags_blacklist.each do |word|
			if tags.include? word
				tags.delete(word)
			end
		# Remove any non-alphabetic characters
		tags.reject! { |t| t = /[^a-z]/ }
		# Update the tags
		picture.update_attribute(:tag_list, tags.join(', '))
		puts 'Updated ' + picture.name
	end
end