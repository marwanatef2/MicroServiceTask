from pymysql import NULL
from db import addCustomertoDB, fetchCustomerfromDB

def addCustomer(customer):
    if 'email' not in customer:
        return {'success': False, 'msg': 'Email can not be empty'}
    customerId = addCustomertoDB(customer)
    return {'success': True, 'msg': 'Customer added successfully', 'customerId': customerId}

def getCustomer(id):
    customer = fetchCustomerfromDB(id)
    if not customer:
        return {'success': False, 'msg': 'No customer with the given ID'}
    return {'success': True, 'customer': customer}