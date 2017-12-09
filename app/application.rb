class Application
  @@cart = []
  @@items = ["Apples","Carrots","Pears"]

  def self.cart
    @@cart
  end

  def self.items
    @@items
  end

  def call(env)
    resp = Rack::Response.new
    req = Rack::Request.new(env)

    if req.path.match(/items/)
      @@items.each do |item|
        resp.write "#{item}\n"
      end
    elsif req.path.match(/cart/)
      case Application.cart.length
      when 0
        resp.write "Your cart is empty"
      else
        Application.cart.each do |item|
          resp.write "#{item}\n"
        end
      end
    elsif req.path.match(/add/)
      item_search = req.params["item"]
       if Application.items.include?(item_search)
         Application.cart << item_search
         resp.write "added #{item_search}"
       else
         resp.write "We don't have that item"
       end
    elsif req.path.match(/search/)
      search_term = req.params["q"]
      resp.write handle_search(search_term)
    else
      resp.write "Path Not Found"
    end

    resp.finish
  end

  def handle_search(search_term)
    if @@items.include?(search_term)
      return "#{search_term} is one of our items"
    else
      return "Couldn't find #{search_term}"
    end
  end
end
