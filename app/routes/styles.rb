class App < Roda
  route 'styles' do |r|
    r.get do
      view('pages/styles')
    end
  end
end
