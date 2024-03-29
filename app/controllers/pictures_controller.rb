class PicturesController < ApplicationController
  # GET /pictures
  # GET /pictures.json
  def index
    @pictures = Picture.paginate(:page => params[:page], :per_page => 15).order('id DESC')

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @pictures }
    end
  end

  # GET /pictures/1
  # GET /pictures/1.json
  def show
    @picture = Picture.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @picture }
    end
  end

  # GET /pictures/new
  # GET /pictures/new.json
  def new
    @picture = Picture.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @picture }
    end
  end

  # GET /pictures/1/edit
  def edit
    @picture = Picture.find(params[:id])
  end

  # POST /pictures
  # POST /pictures.json
  def create
    @picture = Picture.new(params[:picture])

    respond_to do |format|
      if @picture.save
        format.html { redirect_to @picture, :notice => 'Picture was successfully created.' }
        format.json { render :json => @picture, :status => :created, :location => @picture }
      else
        format.html { render :action => "new" }
        format.json { render :json => @picture.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /pictures/1
  # PUT /pictures/1.json
  def update
    @picture = Picture.find(params[:id])

    respond_to do |format|
      if @picture.update_attributes(params[:picture])
        format.html { redirect_to @picture, :notice => 'Picture was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @picture.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /pictures/1
  # DELETE /pictures/1.json
  def destroy
    @picture = Picture.find(params[:id])
    @picture.destroy

    respond_to do |format|
      format.html { redirect_to pictures_url }
      format.json { head :no_content }
    end
  end

  # GET /pictures/search/keywords
  def search
    if params[:keywords].nil?
      render :action => "searchform"
      return
    end
    keywords = params[:keywords].gsub(/s\b/, '').split(/\b\W*/)
    @exact = Picture.tagged_with(keywords)
    @close = Picture.tagged_with(keywords, :any => true)
    @maybe = Picture.tagged_with(keywords, :any => true, :wild => true)

    @maybe = @maybe - @close - @exact
    @close = @close - @exact

    respond_to do |format|
      format.html { render :action => "search" }
    end
  end
end
