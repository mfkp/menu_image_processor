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
    @workbook = Sheets::Base.new("#{Rails.public_path}/uploads/"+ @menu.path)
    # @workbook = Excelx.new("public/uploads/"+ @menu.path)
    # @workbook = RubyXL::Parser.parse("public/uploads/"+ @menu.path)

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

    # sheets gem
    arr = Sheets::Base.new(tmp.path, :format => :xls).to_array
    puts arr
    arr.each do |row|
      keywords = row[2].downcase.gsub(/s\b/, '').split(/\b\W*/)
      exact = Picture.tagged_with(keywords)
      if (exact.present?)
        row[8] = exact.first.path
      end
    end

    workbook = Sheets::Base.new(arr)
    File.open("#{Rails.public_path}/uploads/#{@menu.path}", 'w') do |f|
      f.puts workbook.to_xls
      f.close
    end

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
    workbook = Sheets::Base.new(File.join("#{Rails.public_path}/uploads", @menu.path), :format => :xls).to_array
    @row = workbook[params[:number].to_i]
    @index = params[:number]
    product_name = @row[2]

    keywords = product_name.downcase.gsub(/s\b/, '').split(/\b\W*/)
    @exact = Picture.tagged_with(keywords)
    @close = Picture.tagged_with(keywords, :any => true)
    @maybe = Picture.tagged_with(keywords, :any => true, :wild => true)

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
    arr = Sheets::Base.new(File.join("#{Rails.public_path}/uploads", @menu.path), :format => :xls).to_array

    #add new tags
    taglist = arr[params[:number].to_i][2].sub(/\..*/, '').gsub(/_/, ' ').downcase.gsub(/\d/, '').gsub(/s\b/, '').strip.split(' ')
    taglist.each do |tag|
      picture.tag_list.push tag
    end
    picture.tag_list.uniq!
    picture.save

    #set new image path
    arr[params[:number].to_i][8] = picture.path
    workbook = Sheets::Base.new(arr)
    File.open("#{Rails.public_path}/uploads/#{@menu.path}", 'w') do |f|
      f.puts workbook.to_xls
      f.close
    end

    respond_to do |format|
      format.html { redirect_to @menu }
    end
  end

  def download
    foldername = "#{Rails.public_path}/menus/menu#{Time.now.to_i.to_s}/"
    FileUtils.mkdir foldername
    menu = Menu.find(params[:id])
    arr = Sheets::Base.new("#{Rails.public_path}/uploads/"+ menu.path).to_array

    #copy all the images and fix the image paths
    arr.each_with_index do |row, index|
      if index > 0 && row[8].present?
        FileUtils.cp "#{Rails.root}/app/assets/images/menu_items/" + row[8], foldername
        row[8] = row[8].match(/([^\/]*)$/)[0] #just strips off the directories after it's copied
      end
    end

    #write the excel file
    workbook = Sheets::Base.new(arr)
    File.open(foldername + menu.path, 'w') do |f|
      f.puts workbook.to_xls
      f.close
    end

    #zip it up
    archive = File.join("#{Rails.public_path}/menus/",File.basename(menu.path))+'.zip'
    FileUtils.rm archive, :force=>true
    Zip::ZipFile.open(archive, 'w') do |zipfile|
      Dir["#{foldername}/**/**"].reject{|f|f==archive}.each do |file|
        zipfile.add(file.sub(foldername+'/',''),file)
      end
    end

    

    respond_to do |format|
      format.html { send_file(archive, :filename => menu.path + ".zip", :type => 'application/zip') }
    end
  end

end
