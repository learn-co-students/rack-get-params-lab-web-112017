class Application

  @@items = ["Apples","Carrots","Pears"]
  @@cart = []

  def call(env)
    resp = Rack::Response.new
    req = Rack::Request.new(env)

    if req.path.match(/items/)
      @@items.each do |item|
        resp.write "#{item}\n"
      end

    elsif req.path.match(/search/)
      search_term = req.params["q"]
      resp.write handle_search(search_term)

    elsif req.path.match(/cart/)
      if @@cart.length == 0
        resp.write "Your cart is empty"
      else
        resp.write @@cart.map { |e| "#{e}\n" }.join
      end

    elsif req.path.match(/add/)
      items = req.params["item"]
      resp.write add_items_to_cart(items)

    else
      resp.write "Path Not Found"
    end

    resp.finish
  end

  def add_items_to_cart(items)
    if @@items.include?(items)
      @@cart << items
      return "added #{items}"
    else
      return "We don't have that item"
    end
  end

  def handle_search(search_term)
    if @@items.include?(search_term)
      return "#{search_term} is one of our items"
    else
      return "Couldn't find #{search_term}"
    end
  end
end
