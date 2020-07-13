import platform
import os

session = 'JG14_190621'

session = 'JG14_190621'

# load calss and set folder depending on platform
if platform.system() == 'Linux':
    # Linux
    os.chdir("/home/max/ExpanDrive/Google Drive/3.1 Code Repository/1.4-klausbergerlab-sync/")
    from sync_class import Sync
    folder = "/home/max/ExpanDrive/Google Drive/3 Projekte/Masterarbeit Laborarbeit Neuroscience/1 Data Analysis"+'/'+session
elif platform.system() == 'Windows':
    # windows
    os.chdir(r"C:\Users\User\Google Drive\3.1 Code Repository\1.4-klausbergerlab-sync")
    from sync_class import Sync
    folder = r"C:/Users/User/Google Drive/3 Projekte/Masterarbeit Laborarbeit Neuroscience/1 Data Analysis"+ r"/" + session
    

snyc_obj = Sync()