class MenusController < ApplicationController
  # GET /menus
  # GET /menus.json
  def index
    @menus = Menu.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @menus }
    end
  end

  # GET /menus/1
  # GET /menus/1.json
  def show
    @menu = Menu.find(params[:id])
    @workbook = @menu.to_array

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @menu }
    end
  end

  # GET /menus/new
  # GET /menus/new.json
  def new
    @menu = Menu.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @menu }
    end
  end

  # GET /menus/1/edit
  def edit
    @menu = Menu.find(params[:id])
  end

  # POST /menus
  # POST /menus.json
  def create
    @menu = Menu.new
    @menu.name = params[:menu][:name]
    @menu.path = params[:menu][:spreadsheet].original_filename.gsub(/\s/, '_')
    file = File.join("#{Rails.public_path}/uploads", @menu.path)

    require 'fileutils'
    tmp = params[:menu][:spreadsheet].tempfile
    #FileUtils.mv tmp.path, file


    #if File.extname(file) == '.xlsx'
    # # rubyXL gem
    #  arr = RubyXL::Parser.parse(tmp.path, :skip_filename_check => true).worksheets[0].extract_data
    #else
    #  # sheets gem
    #  arr = Sheets::Base.new(tmp.path, :format => :xls).to_array
    #end

    arr = @menu.to_array(:tmp_path => tmp.path)

    arr.each do |row|
      if row[2].present?
        keywords = Menu.remove_blacklist(row[2].downcase.gsub(/[^a-z ]/, '').gsub(/s\b/, '').split(/\b\W*/))
        exact = Picture.tagged_with(keywords)
        if (exact.present?)
          row[8] = exact.first.path
        end
      end
    end

    #if File.extname(file) == '.xlsx'
    #  workbook = RubyXL::Parser.parse(tmp.path, :skip_filename_check => true)
    #  arr.each do |row|
    #    index = arr.index(row)
    #    begin
    #      workbook.worksheets[0][index][8].change_content(row[8])
    #    rescue NoMethodError
    #      workbook.worksheets[0].add_cell(index, 8, row[8])
    #    end
    #  end
    #  workbook.write("#{Rails.public_path}/uploads/#{@menu.path}")
    #else
    #  workbook = Sheets::Base.new(arr)
    #  File.open("#{Rails.public_path}/uploads/#{@menu.path}", 'w') do |f|
    #    f.puts workbook.to_xls
    #    f.close
    #  end
    #end

    @menu.write_workbook(arr, :tmp_path => tmp.path)

    respond_to do |format|
      if @menu.save
        format.html { redirect_to @menu, :notice => 'Menu was successfully created.' }
        format.json { render :json => @menu, :status => :created, :location => @menu }
      else
        format.html { render :action => "new" }
        format.json { render :json => @menu.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /menus/1
  # PUT /menus/1.json
  def update
    @menu = Menu.find(params[:id])

    respond_to do |format|
      if @menu.update_attributes(params[:menu])
        format.html { redirect_to @menu, :notice => 'Menu was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @menu.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /menus/1
  # DELETE /menus/1.json
  def destroy
    @menu = Menu.find(params[:id])
    @menu.destroy

    respond_to do |format|
      format.html { redirect_to menus_url }
      format.json { head :no_content }
    end
  end

  # GET /menus/1/rows/13
  def edit_row
    @menu = Menu.find(params[:id])
    workbook = @menu.to_array
    @row = workbook[params[:number].to_i]
    @index = params[:number]

    @keywords = Menu.remove_blacklist(@row[2].downcase.gsub(/[^a-z ]/, '').gsub(/s\b/, '').strip.split(/\b\W*/))
    @exact = Picture.tagged_with(@keywords)
    # Close matches will be more useful if we sort by number of matches
    @close = Picture.tagged_with(@keywords, :any => true).sort_by { |o| -(@keywords & o.tag_list).length }
    @maybe = Picture.tagged_with(@keywords, :any => true, :wild => true)

    @maybe = @maybe - @close - @exact
    @close = @close - @exact

    respond_to do |format|
      format.html { render :action => "edit_row" }
    end
  end

  # POST /menus/1/rows/13
  def update_row
    @menu = Menu.find(params[:id])
    picture = Picture.find(params[:picture_id])
    #if File.extname(@menu.path) == '.xlsx'
    #  arr = RubyXL::Parser.parse(File.join("#{Rails.public_path}/uploads", @menu.path)).worksheets[0].extract_data
    #else
    #  arr = Sheets::Base.new(File.join("#{Rails.public_path}/uploads", @menu.path), :format => :xls).to_array
    #end
    arr = @menu.to_array
    #add new tags
    #taglist = arr[params[:number].to_i][2].sub(/\..*/, '').gsub(/_/, ' ').downcase.gsub(/\d/, '').gsub(/s\b/, '').strip.split(' ')
    taglist = Menu.remove_blacklist(arr[params[:number].to_i][2].downcase.gsub(/[^a-z ]/, '').gsub(/s\b/, '').strip.split(/\b\W*/))
    taglist.each do |tag|
      picture.tag_list.push tag
    end
    picture.tag_list.uniq!
    picture.save

    #set new image path
    arr[params[:number].to_i][8] = picture.path
    #if File.extname(@menu.path) == '.xlsx'
    #  workbook = RubyXL::Parser.parse(File.join("#{Rails.public_path}/uploads", @menu.path))
    #  arr.each do |row|
    #    index = arr.index(row)
    #    begin
    #      workbook.worksheets[0][index][8].change_content(row[8])
    #    rescue NoMethodError
    #      workbook.worksheets[0].add_cell(index, 8, row[8])
    #    end
    #  end
    #  workbook.write("#{Rails.public_path}/uploads/#{@menu.path}")
    #else
    #  workbook = Sheets::Base.new(arr)
    #  File.open("#{Rails.public_path}/uploads/#{@menu.path}", 'w') do |f|
    #    f.puts workbook.to_xls
    #    f.close
    #  end
    #end

    @menu.write_workbook(arr)

    respond_to do |format|
      format.html { redirect_to @menu }
    end
  end

  def download
    foldername = "#{Rails.public_path}/menus/menu#{Time.now.to_i.to_s}/"
    FileUtils.mkdir foldername
    menu = Menu.find(params[:id])
    #if File.extname(menu.path) == '.xlsx'
    #  arr = RubyXL::Parser.parse(File.join("#{Rails.public_path}/uploads", menu.path)).worksheets[0].extract_data
    #else
    #  arr = Sheets::Base.new("#{Rails.public_path}/uploads/"+ menu.path).to_array
    #end

    arr = menu.to_array

    #copy all the images and fix the image paths
    arr.each_with_index do |row, index|
      if index > 0 && row[8].present?
        if Picture.find_by_path(row[8]).present?
          FileUtils.cp "#{Rails.root}/app/assets/images/menu_items/" + row[8], foldername
        end
        row[8] = row[8].match(/([^\/]*)$/)[0] #just strips off the directories after it's copied
      end
    end

    #write the excel file
    #if File.extname(menu.path) == '.xlsx'
    #  workbook = RubyXL::Parser.parse(File.join("#{Rails.public_path}/uploads", menu.path))
    #  arr.each do |row|
    #    index = arr.index(row)
    #    begin
    #      workbook.worksheets[0][index][8].change_content(row[8])
    #    rescue NoMethodError
    #      workbook.worksheets[0].add_cell(index, 8, row[8])
    #    end
    #  end
    #  workbook.write(File.join(foldername, menu.path))
    #else
    #  workbook = Sheets::Base.new(arr)
    #  File.open(foldername + menu.path, 'w') do |f|
    #    f.puts workbook.to_xls
    #    f.close
    #  end
    #end

    menu.write_workbook(arr, :folder_name => foldername)

    #zip it up
    # Remove the trailing .xls or .xlsx (planned) from the file name - this creates issues with the portal.
    archive = File.join("#{Rails.public_path}/menus/",File.basename(menu.path.gsub(/(.xls|.xlsx)\b/, '')))+'.zip'
    FileUtils.rm archive, :force=>true
    Zip::ZipFile.open(archive, 'w') do |zipfile|
      Dir["#{foldername}/**/**"].reject{|f|f==archive}.each do |file|
        zipfile.add(file.sub(foldername+'/',''),file)
      end
    end

    respond_to do |format|
      format.html { send_file(archive, :filename => menu.path.gsub(/(.xls|.xlsx)\b/, '') + ".zip", :type => 'application/zip') }
    end
  end
end