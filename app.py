from flask import Flask, request
from businesslogic import addCustomer, getCustomer
from dotenv import load_dotenv

load_dotenv()

app = Flask(__name__)
base_url = '/api/customer/'

@app.route(base_url+'add', methods=['POST'])
def add_customer():
    customer = request.json
    return addCustomer(customer)

@app.route(base_url+'<int:id>', methods=['GET'])
def get_customer(id):
    return getCustomer(id)
