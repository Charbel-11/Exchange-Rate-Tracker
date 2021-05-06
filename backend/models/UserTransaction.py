from app import db, ma, bcrypt

class UserTransactions(db.Model):
    transaction_id = db.Column(db.Integer, db.ForeignKey('transaction.id'), primary_key=True)
    user1_name = db.Column(db.String(30), db.ForeignKey('user.user_name'))
    user2_name = db.Column(db.String(30), db.ForeignKey('user.user_name'))