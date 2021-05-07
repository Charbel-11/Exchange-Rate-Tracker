from app import create_app
from api.User import app_user
from api.Transaction import app_transaction
from api.UserTransaction import app_user_transaction
from api.features import app_features

app = create_app()


app.register_blueprint(app_user)
app.register_blueprint(app_transaction)
app.register_blueprint(app_user_transaction)
app.register_blueprint(app_features)