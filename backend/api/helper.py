import jwt
import datetime
import numpy as np
from sklearn.linear_model import LinearRegression

SECRET_KEY = "b'|\xe7\xbfU3`\xc4\xec\xa7\xa9zf:}\xb5\xc7\xb9\x139^3@Dv'"

def create_token(user_id):
    payload = {
        'exp': datetime.datetime.utcnow() + datetime.timedelta(days=4),
        'iat': datetime.datetime.utcnow(),
        'sub': user_id
    }
    return jwt.encode(
        payload,
        SECRET_KEY,
        algorithm='HS256'
    )

def extract_auth_token(authenticated_request):
    auth_header = authenticated_request.headers.get('Authorization')
    if auth_header and auth_header!="Bearer":
        return auth_header.split(" ")[1]
    else:
        return None

def decode_token(token):
    payload = jwt.decode(token, SECRET_KEY, 'HS256')
    return payload['sub']

def predict_rate(data):
    print(len(data))
    if(len(data) == 0):
        return 0
    X = np.array(data)[:,0].reshape(-1,1)
    y = np.array(data)[:,1].reshape(-1,1)
    to_predict_x= len(data)
    to_predict_x= np.array(to_predict_x).reshape(-1,1)
    regsr=LinearRegression()
    regsr.fit(X,y)
    predicted_y= regsr.predict(to_predict_x)
    predicted_y = predicted_y.tolist()
    return predicted_y[0][0]    