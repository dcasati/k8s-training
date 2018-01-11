import connexion
from swagger_server.models.inline_response200 import InlineResponse200
from datetime import date, datetime
from typing import List, Dict
from six import iteritems
from ..util import deserialize_date, deserialize_datetime
import pyodbc

def start_connection():
    """
    Start a ODBC Connection
       
    :rtype: pyodbc connection
    """

    # load the configuration and credentials
    with open("/etc/config/server", "r") as server_config_file:
        server = server_config_file.read().rstrip()

    with open("/etc/config/database", "r") as database_config_file:
        database = database_config_file.read().rstrip()

    # Secrets
    with open("/etc/secrets/username", "r") as username_secret_file:
        user = username_secret_file.read().rstrip()

    with open("/etc/secrets/password", "r") as password_secret_file:
        password = password_secret_file.read().rstrip()

    connection = pyodbc.connect(
        'DRIVER={ODBC Driver 13 for SQL Server}; \
        SERVER='+server+'; \
        PORT=1443; \
        UID='+user+'; \
        PWD='+ password + '; \
        DATABASE='+database)

    return connection

def user_username_get(username):
    """
    Get username
    
    param username: The format to return the response in json.
    :type username: str

    :rtype: InlineResponse200
    """
    cnxn = start_connection()
    cursor = cnxn.cursor()
    
    tsql = "SELECT \
                CustomerID, \
                FirstName, \
                LastName, \
                EmailAddress \
            FROM SalesLT.Customer \
            WHERE FirstName = '"+username+"';"

    api_response = []
    with cursor.execute(tsql):
        row = cursor.fetchone()
        while row is not None:
            data = InlineResponse200(
                row.CustomerID,
                row.FirstName,
                row.LastName,
                row.EmailAddress
            )
            api_response.append(data)
            row = cursor.fetchone()
    
    return api_response