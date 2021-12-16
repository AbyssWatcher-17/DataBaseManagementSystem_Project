import sqlite3


# TODO: Add a function to check if a thesis is already in the database.
# TODO: Add add/change/delete universities, new institutes functions.
# TODO: Add add/change/delete authors functions.
# TODO: Found theses after a search must be listed in an ordered fashion.
# TODO: User can select a thesis to see its all details in a carefully designed screen.

class Database(object):
    def __init__(self, db_name):
        self.conn = sqlite3.connect(db_name)
        self.cursor = self.conn.cursor()
        self.cursor.execute('CREATE TABLE IF NOT EXISTS thesis(id INTEGER PRIMARY KEY, title TEXT, '
                            'author TEXT, university TEXT, institute TEXT, year INTEGER, keywords TEXT, abstract TEXT)')
        self.conn.commit()

    def update_thesis(self, title, author, university, institute, year, keywords, abstract):
        self.cursor.execute('INSERT INTO thesis VALUES(NULL, ?, ?, ?, ?, ?, ?, ?)',
                            (title, author, university, institute, year, keywords, abstract))
        self.conn.commit()

    def update_thesis(self, id, title, author, university, institute, year, keywords, abstract):
        self.cursor.execute('UPDATE thesis SET title=?, author=?, university=?,'
                            ' institute=?, year=?, keywords=?, abstract=? WHERE id=?',
                            (title, author, university, institute, year, keywords, abstract, id))
        self.conn.commit()

    def delete_thesis(self, id):
        self.cursor.execute('DELETE FROM thesis WHERE id=?', (id,))
        self.conn.commit()

    def search_thesis(self, title, author, university, institute, year, keywords, abstract):
        self.cursor.execute(
            'SELECT * FROM thesis WHERE title=? OR author=? OR university=? OR institute=? OR year=? OR keywords=? OR abstract=?',
            (title, author, university, institute, year, keywords, abstract))
        return self.cursor.fetchall()

    def show(self):
        self.cursor.execute('SELECT * FROM thesis')
        return self.cursor.fetchall()
