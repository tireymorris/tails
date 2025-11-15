class App < Roda
  route 'dashboard' do |r|
    require_login

    r.get do
      view('dashboard/index')
    end
  end
end
