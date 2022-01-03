import pyodbc


def connect_db():
    """
    Connects to the database and returns the connection object.
    :param db_name: Database name.
    :return: Connection object.
    """
    conn = pyodbc.connect('Driver={SQL Server};'
                          'Server=-----------;'
                          'Database=------------;'
                          'Trusted_Connection=yes;')
    return conn
