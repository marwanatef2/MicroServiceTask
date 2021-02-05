from flask import Flask, request
from businesslogic import addCustomer
from dotenv import load_dotenv

load_dotenv()

app = Flask(__name__)

@app.route('/api/customer/add', methods=['POST'])
def add_customer():
    customer = request.json
    return addCustomer(customer)
