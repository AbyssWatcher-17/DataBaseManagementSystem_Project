import tkinter as tk
from tkinter import messagebox

import tksheet
# from searchPage_app import SearchPage
# from addPage_app import AddPage
# from updatePage_app import UpdatePage
from database import connect_db

# !! Queries that are sent to DB are open for any SQL injection !! #

# TODO LIST:
# 1.) Now we assume first records are PKs, there could be 2 PKs in one table.
# 2.) Some alignment to MainApp is needed.
# 3.) If a new sheet is opened with the same combobox selection, the old sheet should be closed.
# 4.) Due to circular imports, we need to import the pages in the mainApp.py file.

#%% MainApp Class
class MainApp(tk.Tk):
    """
    Main application class
    """

    def __init__(self, *args, **kwargs):
        tk.Tk.__init__(self, *args, **kwargs)
        self.title("Thesis Database")
        self.geometry("800x600")
        self.resizable(False, False)
        self.container = tk.Frame(self)
        self.container.pack(side="top", fill="both", expand=True)
        self.container.grid_rowconfigure(0, weight=1)
        self.container.grid_columnconfigure(0, weight=1)
        self.frames = {}
        for F in (StartPage, SearchPage, AddThesis, UpdatePage):
            frame = F(self.container, self)
            self.frames[F] = frame
            frame.grid(row=0, column=0, sticky="nsew")
        self.show_frame(StartPage)

    def show_frame(self, cont):
        """
        Shows the frame
        :param cont: frame to show
        """
        frame = self.frames[cont]
        frame.tkraise()

# %% StartPage Class
class StartPage(tk.Frame):
    """
    Start page
    """

    def __init__(self, parent, controller):
        tk.Frame.__init__(self, parent)
        label = tk.Label(self, text="Welcome to the thesis database", font=("Arial", 20))
        label.pack(pady=10, padx=10)
        button1 = tk.Button(self, text="Search", command=lambda: controller.show_frame(SearchPage))
        button1.pack()
        button2 = tk.Button(self, text="Add", command=lambda: controller.show_frame(AddThesis))
        button2.pack()
        button3 = tk.Button(self, text="Update", command=lambda: controller.show_frame(UpdatePage))
        button3.pack()

# %% UpdatePage Class
class UpdatePage(tk.Frame):
    """
    Update page
    """

    def __init__(self, parent, controller):
        # Create a decent design for the update page.
        self.tables = ['Institute', 'Person', 'Subject Topics', 'Thesis', 'University']
        tk.Frame.__init__(self, parent)
        label = tk.Label(self, text="Update record", font=("Arial", 20))
        label.pack(pady=10, padx=10)
        button1 = tk.Button(self, text="Back", command=lambda: controller.show_frame(StartPage))
        button1.pack()

        # There should be a drop down menu for the tables, with the option to select a table.

        self.table_var = tk.StringVar()
        self.table_var.set(self.tables[0])
        self.show_tables()

    def show_tables(self):
        """
        :return:
        """
        # Disable button2.
        # self.button2.config(state="disabled")

        # If user clicks on one of the Tables, destroy the combobox and show the records.
        self.combo = tk.ttk.Combobox(self, values=self.tables,
                                     textvariable=tk.StringVar(value='Select a table'))
        self.combo.pack()
        self.combo.bind("<<ComboboxSelected>>", self.show_records)

    def show_records(self, event):
        """
        :param event:
        :return:
        """
        # Get the table name from the combobox.
        table_name = self.combo.get()
        # Get the records from the table.
        con = connect_db()
        cur = con.cursor()
        cur.execute("SELECT * FROM {}".format(table_name))
        records = cur.fetchall()
        # Create a list of the column names.
        col_names = [i[0] for i in cur.description]
        # Create a dataframe from the records.

        # Create a sheet from the dataframe.
        sheet = tksheet.Sheet(self, data=records, headers=col_names,
                              width=700, height=200)
        sheet.pack()

        # Create a button to update the record. This button should be placed right below the sheet.
        self.button2 = tk.Button(self, text="Update Row", command=lambda: self.update_record(table_name, sheet))
        self.button2.pack()
        self.button2.place(x=200, y=300)
        # Same button but for Deleting.
        self.button3 = tk.Button(self, text="Delete Row", command=lambda: self.delete_record(table_name, sheet))
        self.button3.pack()
        self.button3.place(x=310, y=300)
        # Same button but for Adding new records.
        self.button4 = tk.Button(self, text="Add New Record", command=lambda: self.add_record(table_name, sheet))
        self.button4.pack()
        self.button4.place(x=420, y=300)

    def add_record(self, table_name, sheet):
        """
        :param table_name:
        :param sheet:
        :return:
        """
        # Get the header names from the sheet.
        header_names = sheet.MT.my_hdrs

        # Create a new window to update the record.
        self.add_window = tk.Toplevel()

        # This window will have as many as the number of headers.
        for i in range(len(header_names)):
            # Create a label for each header.
            label = tk.Label(self.add_window, text=header_names[i])
            label.grid(row=i, column=0)
            # Create a text box for each header.
            text_box = tk.Entry(self.add_window)
            text_box.grid(row=i, column=1)

        # Create a button to update the record.
        self.button_add = tk.Button(self.add_window, text="Add",
                                 command=lambda: self.add_record_in_db(table_name, sheet))
        self.button_add.grid(row=i + 1, column=1)

    def add_record_in_db(self, table_name, sheet):
        """
        :param table_name:
        :param sheet:
        :return:
        """
        # Get the header names from the sheet.
        header_names = sheet.MT.my_hdrs

        # Get the values from the text boxes.
        values = []
        for i in range(len(header_names)):
            values.append(self.add_window.grid_slaves(row=i, column=1)[0].get())

        # Insert the values into the database.
        try:
            con = connect_db()
            cur = con.cursor()
            cur.execute("INSERT INTO {} VALUES {}".format(table_name, tuple(values)))
            con.commit()
            self.add_window.destroy()
            self.show_records(None)
            # If inserted, show the message.
            tk.messagebox.showinfo("Success", "Record added successfully.")
        except Exception as e:
            print('Values are not inserted into the database.', e)

    def delete_record(self, table_name, sheet):
        """
        :param table_name:
        :param sheet:
        :return:
        """
        # PK is enough to delete a record.
        # Open a new window to get the PK.
        first_column = sheet.MT.my_hdrs[0]

        self.delete_window = tk.Toplevel()
        self.delete_window.title("Delete Record")
        self.delete_window.geometry("300x100")
        label = tk.Label(self.delete_window, text="Enter the PK of the record you want to delete")
        label.pack()

        # Create a textbox to enter the PK.
        self.textbox = tk.Entry(self.delete_window)
        self.textbox.pack()
        self.textbox.place(x=100, y=50)
        # Create a button to delete the record.
        self.button5 = tk.Button(self.delete_window, text="Delete", command=lambda: \
            self.delete_record_from_db(table_name, first_column))

    def delete_record_from_db(self, table_name, first_column):
        # Get the PK from the textbox.
        pk = self.textbox.get()
        # Delete the record from the database.
        con = connect_db()
        cur = con.cursor()
        cur.execute("DELETE FROM {} WHERE {} = {}".format(table_name, first_column, pk))
        con.commit()
        self.delete_window.destroy()
        # Refresh the sheet.
        self.show_records(None)

    def update_record(self, table_name, sheet):
        """
        :param table_name:
        :param sheet:
        :return:
        """
        # Get the header names from the sheet.
        header_names = sheet.MT.my_hdrs

        # Create a new window to update the record.
        self.update_window = tk.Toplevel()

        # This window will have as many as the number of headers.
        for i in range(len(header_names)):
            # Create a label for each header.
            label = tk.Label(self.update_window, text=header_names[i])
            label.grid(row=i, column=0)
            # Create a text box for each header.
            text_box = tk.Entry(self.update_window)
            text_box.grid(row=i, column=1)

        # Create a button to update the record.
        self.button5 = tk.Button(self.update_window, text="Update",
                                 command=lambda: self.update_record_in_db(table_name, sheet))
        self.button5.grid(row=i + 1, column=1)

    def update_record_in_db(self, table_name, sheet):
        """
        :param table_name:
        :param sheet:
        :return:
        """
        # TODO: FIX.
        ##################################################################
        ### !!!!! HERE WE ASSUME FIRST HEADER IS THE PRIMARY KEY !!!!! ###
        ##################################################################
        # Get the header names from the sheet.
        header_names = sheet.MT.my_hdrs
        ID = header_names[0]
        del header_names[0]
        # Get the values from the text boxes.
        values = {}
        for i in range(len(header_names)):
            values[header_names[i]] = self.update_window.grid_slaves(row=i + 1, column=1)[0].get()

        try:
            # Update the record in the database.
            con = connect_db()
            cur = con.cursor()
            cur.execute("UPDATE {} SET {} WHERE {} = {}".format(table_name,
                                                                ", ".join(["{} = '{}'".format(i, j) for i, j in
                                                                           zip(header_names, values)]),
                                                                ID, values[0]))
            con.commit()
            self.update_window.destroy()
            self.show_records(None)
            # Update success message.
            messagebox.showinfo("Success", "Record updated successfully.")
        except Exception as e:
            messagebox.showerror("Error", "Could not update the record.\n{}".format(e))

        con.commit()
        self.update_window.destroy()

    def delete_record(self):
        """

        :return:
        """

# %% AddThesis Class.
class AddThesis(tk.Frame):
    """
    Add page
    """

    def __init__(self, parent, controller):

        tk.Frame.__init__(self, parent)

        # Create a form for the user to enter the details of the thesis.
        # To get the required details, we need to get the details from the database.
        conn = connect_db()
        cur = conn.cursor()
        cur.execute("SELECT * FROM Thesis")
        self.thesis_columns = [i[0] for i in cur.description]

        label = tk.Label(self, text="Add New Thesis to the Database", font=("Arial", 20))
        label.pack(pady=10, padx=10)

        button1 = tk.Button(self, text="Back", command=lambda: controller.show_frame(StartPage))
        button1.place(x=372, y=55 + len(self.thesis_columns) * 30)
        # Create a box for the user to enter the details of the thesis, not Combobox.
        # Add column names as the headers.
        self.thesis_details = {}

        # For each column, create a Label and a textbox. Label should be on the left, textbox on the right.
        for idx, column in enumerate(self.thesis_columns):
            if column == 'Thesis_no':
                continue
            label = tk.Label(self, text=column)
            label.place(x=200, y=55 + idx * 30)

            # Create a textbox.
            textbox = tk.Entry(self)
            textbox.place(x=375, y=55 + idx * 30)
            self.thesis_details[column] = textbox

        # Create a button to submit the details, this should be on the bottom right.
        button_submit = tk.Button(self, text="Submit", command=lambda: self.submit_thesis(self.thesis_details,
                                                                                          self.thesis_columns))
        button_submit.place(x=450, y=55 + len(self.thesis_columns) * 30)

    def submit_thesis(self, thesis_details, thesis_columns):
        # Get user inputs from the textboxes.
        # Insert the details into the database.

        inputs = {}
        for column in thesis_columns:
            if column == 'Thesis_no':
                continue
            inputs[column] = thesis_details[column].get()

        # The columns which endswith ID in it should be integers, if not, display an error box and return.
        for column in inputs:
            if column.endswith('ID') and not inputs[column].isdigit():
                messagebox.showerror("Error", "Please enter a valid ID")
                return

        try:
            conn = connect_db()
            cur = conn.cursor()

            # The attributes are below:
            # ['Title', 'Abstract', 'Author', 'Year', 'Type', 'InstituteName', 'UniversityName',
            #  'Number_of_pages', 'Language_of_the_thesis_text', 'Submission_date', 'Supervisior_ID',
            #  'Supervisior_Person_ID', 'Co_Supervisior_ID', 'Co_Supervisior_Person_ID', 'SubjectName', 'Keyword']
            cur.execute("INSERT INTO Thesis VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)",
                        (inputs['Title'], inputs['Abstract'], inputs['Author'], inputs['Year'],
                         inputs['Type'], inputs['InstituteName'], inputs['UniversityName'], inputs['Number_of_pages'],
                         inputs['Language_of_the_thesis_text'], inputs['Submission_date'], inputs['Supervisior_ID'],
                         inputs['Supervisior_Person_ID'], inputs['Co_Supervisior_ID'],
                         inputs['Co_Supervisior_Person_ID'],
                         inputs['SubjectName'], inputs['Keyword']))

            conn.commit()
            cur.close()
            conn.close()
            messagebox.showinfo("Success", "Thesis added successfully.")
        except Exception as e:
            messagebox.showerror("Error", "Error adding thesis.\n" + str(e))

    def submit_details(self):
        """
        :return:
        """
        # Get the details from the textboxes.
        # Insert the details into the database.
        # Display the details in the database.
        pass

        # Create a button to add the thesis to the database.
        button2 = tk.Button(self, text="Add", command=lambda: self.add_thesis())
        button2.pack()

    def add_thesis(self):
        """

        :return:
        """

# %% SearchPage Class
class SearchPage(tk.Frame):
    """
    Search page
    """

    def __init__(self, parent, controller):
        tk.Frame.__init__(self, parent)

        label = tk.Label(self, text="Search the database", font=("Arial", 20))
        label.pack(pady=10, padx=10)
        button1 = tk.Button(self, text="Back", command=lambda: controller.show_frame(StartPage))
        button1.pack()

        search_label = tk.Label(self, text="Search by:", font=("Arial", 15))
        search_label.pack(pady=10, padx=10)

        search_by_list = ["Thesis_no", "Title", "Abstract", "Author", "Year", "Type", "InstituteName", "UniversityName",
                          "Number_of_pages", "Language_of_the_thesis_text", "Submission_date", "Supervisior_ID",
                          "Supervisior_Person_ID", "Co_Supervisior_ID", "Co_Supervisior_Person_ID", "SubjectName",
                          "Keyword"]
        search_by = tk.StringVar()
        search_by.set(search_by_list[0])
        search_by_menu = tk.OptionMenu(self, search_by, *search_by_list)
        search_by_menu.pack(pady=10, padx=10)
        search_entry = tk.Entry(self)
        search_entry.pack(pady=10, padx=10)

        # When user clicks on the search button, the search function is called and the results are displayed in a
        # tkinter separate window.
        search_button = tk.Button(self, text="Search", command=lambda: self.search(search_by.get(), search_entry.get()))
        search_button.pack(pady=10, padx=10)

    def search(self, search_by, search_entry):
        """
        Search the database for the given search_by and search_entry.
        :param search_by:
        :param search_entry:
        :return:
        """
        # Create a separate window for the results
        results_window = tk.Toplevel()
        results_window.title("Search results")
        results_window.geometry("500x200")

        # Get the results from the database
        results, columns = self.search_thesis(search_by, search_entry)

        # If no results are found, display a message box and close the window.
        if len(results) == 0:
            messagebox.showinfo("No results found", "No results found")
            results_window.destroy()
            return

        # Display the results using tksheet.
        sheet = tksheet.Sheet(results_window, data=results, headers=columns)
        sheet.pack(fill=tk.BOTH, expand=True)

    def search_thesis(self, search_type, search_value):
        """
        :param search_type:
        :param search_value:
        :return:
        """
        conn = connect_db()
        c = conn.cursor()
        # We need to consider the first letter of the search_value and add starts with to the search_type in query.
        # TODO: search_value can be empty, -- len(search_value) == 0 --
        search_value = search_value.lower()
        c.execute("SELECT * FROM Thesis WHERE " + search_type + " LIKE '" + search_value + "%'")

        thesis_details_list = []

        # Get column names
        column_names = [description[0] for description in c.description]

        for thesis in c.fetchall():
            thesis_details_list.append(list(thesis))

        return thesis_details_list, column_names
