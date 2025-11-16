class App < Roda
  route 'guide' do |r|
    r.get do
      view('pages/guide')
    end
  end
end
