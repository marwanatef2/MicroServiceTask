from db import addCustomertoDB

def addCustomer(customer):
    if 'email' not in customer:
        return {'success': False, 'msg': 'Email can not be empty'}
    addCustomertoDB(customer)
    return {'success': True, 'msg': 'Customer added successfully'}