from sqlalchemy import Column, Integer, String
from database.database import db

class User(db.Model):
  __tablename__ = 'users'

  id = Column(Integer, primary_key=True, autoincrement=True)
  name = Column(String(50), nullable=False)
  email = Column(String(50), nullable=False)
  password = Column(String(50), nullable=False)

  def __repr__(self):
    return f'<User:[id:{self.id}, name:{self.name}, email:{self.email}, password:{self.password}]>'
  
  def serialize(self):
    return {
      "id": self.id,
      "name": self.name,
      "email": self.email,
      "password": self.password}
  
class Task(db.Model):
  __tablename__ = 'tasks'

  id = Column(Integer, primary_key=True, autoincrement=True)
  text = Column(String(50), nullable=False)
  status = Column(String(50), nullable=False)

  def __repr__(self):
    return f'<Task:[id:{self.id}, text:{self.text}, status:{self.status}]>'
  
  def serialize(self):
    return {
      "id": self.id,
      "text": self.text,
      "status": self.status,
     }