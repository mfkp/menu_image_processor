class Menu < ActiveRecord::Base

  def self.remove_blacklist(keywords)
    # A collection of words to blacklist as tags
    tags_blacklist = ['a', 'al', 'and', 'e', 'in', 'le', 'n', 'of', 'on', 'the', 'with']
    tags_blacklist.each do |word|
      if keywords.include? word
        keywords.delete(word)
      end
    end
    return keywords
  end

end
