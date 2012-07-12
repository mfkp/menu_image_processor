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

  def to_array(opts = {})
    if File.extname(path) == '.xlsx'
      if opts[:tmp_path].nil?
        arr = RubyXL::Parser.parse(File.join("#{Rails.public_path}/uploads", path)).worksheets[0].extract_data
      else
        # When a menu is being created, we need to pass in the tmp file path
        arr = RubyXL::Parser.parse(opts[:tmp_path], :skip_filename_check => true).worksheets[0].extract_data
      end
    else
      arr = Sheets::Base.new(opts[:tmp_path] || File.join("#{Rails.public_path}/uploads", path), :format => :xls).to_array
    end
    return arr
  end

  def write_workbook(arr, opts = {})
    file = opts[:tmp_path] || File.join("#{Rails.public_path}/uploads", path)

    # Write using RubyXL gem (.xlsx)
    if File.extname(path) == '.xlsx'
      if opts[:tmp_path].nil?
        workbook = RubyXL::Parser.parse(file)
      else
        workbook = RubyXL::Parser.parse(file, :skip_filename_check => true)
      end

      #Rails.logger = Logger.new(STDOUT)
      arr.each_with_index do |row, index|
        begin
          workbook.worksheets[0][index][8].change_content(row[8])
        rescue NoMethodError
          begin
            workbook.worksheets[0].add_cell(index, 8, row[8])
            #logger.debug(row[2].to_s + ' ' + index.to_s)
          # These errors are generally thrown when a nil value somehow
          # makes it way into the worksheet array. This is usually the
          # end of the file, so we can just break the loop.
          rescue TypeError, ArgumentError
            break
          end 
        end
      end

      workbook.write(File.join(opts[:folder_name] || "#{Rails.public_path}/uploads", path))
    # Write using the sheets gem (.xls)
    else
      workbook = Sheets::Base.new(arr)
      File.open(File.join(opts[:folder_name] || "#{Rails.public_path}/uploads", path), 'w') do |f|
        f.puts workbook.to_xls
        f.close
      end
    end
  end
end
