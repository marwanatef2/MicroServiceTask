import pymysql
from os import getenv

connection = pymysql.connect(
        host=getenv('DB_SERVER'),
        user=getenv('DB_USER'),
        password=getenv('DB_PASSWORD'), 
        database=getenv('DB_DATABASE'),
        cursorclass=pymysql.cursors.DictCursor
    )

def addCustomertoDB(values):
    with connection.cursor() as cursor:
        sql = "INSERT INTO `user` (`email`, `firstName`, `lastName`, `phoneNo`) VALUES (%s,%s,%s,%s)"
        cursor.execute(sql, (values.get('email'), values.get('firstName'), values.get('lastName'), values.get('phoneNo')))
        customerId = cursor.lastrowid
        sql = "INSERT INTO `customer` (`address`, `user_id`) VALUES (%s, %s)"
        cursor.execute(sql, (values.get('address'), customerId))
    connection.commit()
    return customerId

def fetchCustomerfromDB(id):
    with connection.cursor() as cursor:
        sql = "SELECT email,firstName,lastName,phoneNo,address FROM customer INNER JOIN user ON customer.user_id = user.id WHERE user.id=%s"
        cursor.execute(sql, (id))
        customer = cursor.fetchone()
    return customer

def fetchAllCustomersfromDB():
    with connection.cursor() as cursor:
        sql = "SELECT user.id,email,firstName,lastName,phoneNo,address FROM customer INNER JOIN user ON customer.user_id = user.id"
        cursor.execute(sql)
        customers = cursor.fetchall()
    return customers
