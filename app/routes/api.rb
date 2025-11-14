class App < Roda
  route 'api' do |r|
    r.on 'protected' do
      user = verify_jwt_token(cookies['jwt_token'])

      if user
        AppLogger.debug "API request authenticated for user #{user.id}"
        r.get 'profile' do
          { user: { id: user.id, email: user.email } }
        end
      else
        AppLogger.warn 'Unauthorized API request to protected endpoint'
        response.status = 401
        { error: 'Unauthorized' }
      end
    end
  end
end
