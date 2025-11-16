class App < Roda
  route 'guide' do |r|
    r.get do
      view('guide/index')
    end
  end
end
