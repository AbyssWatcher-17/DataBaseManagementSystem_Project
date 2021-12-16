import sqlite3
import tkinter as tk

def connect_db(db_name):
    """
    Connects to the database
    :param db_name: name of the database
    :return: connection object
    """
    return sqlite3.connect(db_name)


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
        for F in (StartPage, SearchPage, AddPage, UpdatePage):
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
        button2 = tk.Button(self, text="Add", command=lambda: controller.show_frame(AddPage))
        button2.pack()
        button3 = tk.Button(self, text="Update", command=lambda: controller.show_frame(UpdatePage))
        button3.pack()

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
        button2 = tk.Button(self, text="Search", command=lambda: controller.show_frame(SearchPage))
        button2.pack()

class AddPage(tk.Frame):
    """
    Add page
    """
    def __init__(self, parent, controller):
        tk.Frame.__init__(self, parent)
        label = tk.Label(self, text="Add new record", font=("Arial", 20))
        label.pack(pady=10, padx=10)
        button1 = tk.Button(self, text="Back", command=lambda: controller.show_frame(StartPage))
        button1.pack()
        button2 = tk.Button(self, text="Add", command=lambda: controller.show_frame(AddPage))
        button2.pack()


class UpdatePage(tk.Frame):
    """
    Update page
    """
    def __init__(self, parent, controller):
        tk.Frame.__init__(self, parent)
        label = tk.Label(self, text="Update record", font=("Arial", 20))
        label.pack(pady=10, padx=10)
        button1 = tk.Button(self, text="Back", command=lambda: controller.show_frame(StartPage))
        button1.pack()
        button2 = tk.Button(self, text="Update", command=lambda: controller.show_frame(UpdatePage))
        button2.pack()


if __name__ == "__main__":
    app = MainApp()
    app.mainloop()
