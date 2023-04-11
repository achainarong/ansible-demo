- hosts: all
  vars:
    APPWRITE_ID: APPWRITE_ID
    BACKUP_FILENAME: BACKUP_FILENAME
  tasks:
    - name: Copy backupfile
      copy:
        src: {{ BACKUP_FILENAME }} 
        dest: /backups/{{ BACKUP_FILENAME }}
    - name: Copy restore
      copy:
        src: appwrite/restore.sh
        dest: /scripts/restore.sh
    - name: run script
      shell: sh /scripts/restore.sh /backups/{{ BACKUP_FILENAME }} {{ APPWRITE_ID }} 

