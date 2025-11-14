class App < Roda
  route 'dashboard' do |r|
    unless logged_in?
      flash[:error] = 'Please log in first'
      r.redirect '/auth/login'
    end

    r.get do
      view('dashboard/index')
    end
  end
end

