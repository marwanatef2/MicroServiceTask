import pymysql
from os import getenv

connection = pymysql.connect(
        host=getenv('DB_SERVER'),
        user=getenv('DB_USER'),
        password=getenv('DB_PASSWORD'), 
        database=getenv('DB_DATABASE')
    )

def addCustomertoDB(values):
    with connection:
        with connection.cursor() as cursor:
            sql = "INSERT INTO `user` (`email`, `firstName`, `lastName`, `phoneNo`) VALUES (%s,%s,%s,%s)"
            cursor.execute(sql, (values.get('email'), values.get('firstName'), values.get('lastName'), values.get('phoneNo')))
            sql = "INSERT INTO `customer` (`address`, `user_id`) VALUES (%s, %s)"
            cursor.execute(sql, (values.get('address'), cursor.lastrowid))
        connection.commit()
