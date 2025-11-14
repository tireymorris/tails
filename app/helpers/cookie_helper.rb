module CookieHelper
  def set_cookie_value(name, value, options = {})
    cookie_parts = ["#{name}=#{Rack::Utils.escape(value)}"]
    cookie_parts << "path=#{options[:path] || '/'}"
    cookie_parts << 'HttpOnly' if options[:httponly]
    cookie_parts << 'Secure' if options[:secure]

    existing = response['Set-Cookie']
    new_cookie = cookie_parts.join('; ')

    response['Set-Cookie'] = if existing
                               [existing, new_cookie].flatten.join("\n")
                             else
                               new_cookie
                             end
  end

  def delete_cookie_value(name)
    cookie_parts = ["#{name}=", 'path=/', 'max-age=0', 'expires=Thu, 01 Jan 1970 00:00:00 GMT']

    existing = response['Set-Cookie']
    new_cookie = cookie_parts.join('; ')

    response['Set-Cookie'] = if existing
                               [existing, new_cookie].flatten.join("\n")
                             else
                               new_cookie
                             end
  end
end
