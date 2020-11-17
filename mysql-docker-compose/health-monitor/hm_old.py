import argparse
import configparser
from pathlib import Path

import os
import subprocess
import requests
import time
import mysql.connector
from mysql.connector import Error


def create_connection(host, database, user, password):
    try:
        conn = mysql.connector.connect(host=host, database=database, user=user, password=password)
        if conn.is_connected():
            print('Success')
            db_Info = conn.get_server_info()
            print(db_Info)
    except Error as e:
        print(e)
        conn = None
    finally:
        return conn


def insert_log_entry(conn, tbl_name, result):
    c = get_cursor(conn)
    # Insert a row of data
    print(result)
    host = result[0]
    present = result[2]
    note = f'time: {result[1]}, note: {result[3]}'
    record = f"(0, '{host}', {present}, '{note}')"
    c.execute(f"INSERT INTO {tbl_name} VALUES {record}")


    # id int not null auto_increment primary key, name varchar(30), present boolean not null, note varchar(255)
    # (0, ), name varchar(30), present boolean not null, note varchar(255)
    # print(result)
    # c.execute(f"INSERT INTO {tbl_name} VALUES (0, 'wp.pl', 1, 'jest ok')")

    # Save (commit) the changes
    conn.commit()


def close_connection(conn):
    if conn:
        if (conn.is_connected()):
            print('disconnecting')
            conn.close()


def check_host_presence(cmd, condition):
    print('condition', condition)
    try:
        if cmd.startswith('GET') or cmd.startswith('POST'):
            req = cmd.split()
            if req[0].lower() == 'get':
                r = requests.get(req[1])
            elif req[0].lower() == 'post':
                if len(req) == 3:
                    r = requests.post(req[1], data=req[2].replace('--data', ''))
                else:
                    r = requests.post(req[1], data={'x': 123})
            out = str(r.status_code)
            # print(r.url)
            # print(r.headers)
            # print(r.text)
            x = out == condition
            print(out, x)
        else:
            out = subprocess.getoutput(cmd)
        # out = sh.grep(sh.ping('-c', '2', host), '-Eo', condition)
        # out = out.strip('\r\n')
        # ping = Popen(['ping', '-c', '2', host], stdout=PIPE)
        # grep_result = Popen(['grep', '-Eo', pass_condition], stdin=ping.stdout, stdout=PIPE, stderr=PIPE)
        # ping.stdout.close()
        # out, err = grep_result.communicate()
        # out = out.decode('utf8')
        out = [True, ''] if out == condition else [False, out]
    except subprocess.CalledProcessError as cpe:
        # except ErrorReturnCode_2 as cpe:
        out = [False, cpe]
    return out


def get_cursor(conn):
    return conn.cursor()


def get_content(conn, tbl_name):
    c = get_cursor(conn)
    c.execute(f'SELECT * FROM {tbl_name}')
    return c.fetchall()


def parse_args():
    parser = argparse.ArgumentParser()
    parser.add_argument("--config", help="name of logs table", action="store", default="config")
    parser.add_argument("--targets", help="list of hosts to verify stored in file", action="store")
    args = parser.parse_args()
    cfg_file = args.config
    tgts_file = None
    if args.targets:
        tgts_file = args.targets
    return cfg_file, tgts_file


if __name__ == '__main__':
    cfg_file, targets_file = parse_args()
    if not targets_file:
        print(f'Target file was not provided. Please provide path to config file. Exiting...')
        exit(1)
    config = configparser.ConfigParser()
    targets_file_path = Path(targets_file)
    config_file_path = Path(cfg_file)
    print('config_file_path:', config_file_path)
    if not config_file_path.exists():
        print(f'Config file {config_file_path} does not exist. Please provide path to config file. Exiting...')
        exit(1)
    config.read(config_file_path)

    if not targets_file_path.exists():
        print(f'Targets file {targets_file_path} does not exist. Please provide proper path to file with targets to verify.')
        exit(1)
    db_name = config['db']['name']
    tbl_name = config['table']['name']
    print('db_name', db_name)
    print('tbl_name', tbl_name)


    with open(targets_file_path, 'r') as target_file:
        targets = target_file.readlines()
        targets = [item.strip('\n') for item in targets]
        # print('targets', targets)
        hosts_verification = targets

        host = os.environ['MYSQL_DB_HOST']
        db = os.environ['MYSQL_DB_NAME']
        username = os.environ['MYSQL_DB_USER']
        passw = os.environ['MYSQL_DB_PASSWORD']
        print(f'details: {host}, {db}, {username}, {passw}')
        conn = create_connection(host=host, database=db, user=username, password=passw)
        conn = True
        if conn:
            for host_line in hosts_verification:
                host, cmd, pass_condition = host_line.split(';')
                pass_condition = pass_condition.strip('\r\n')
                host_present, error_msg = check_host_presence(cmd, pass_condition)
                host_info = [1, ''] if host_present else [0, error_msg]
                result = [host, str(time.strftime("%Y-%m-%d %H:%M:%S", time.gmtime())), *host_info]
                print(result)
                insert_log_entry(conn, tbl_name, result=result)

            print(get_content(conn, tbl_name))
            close_connection(conn)
        else:
            print('Exiting - as connection was failure')
            exit(1)
    #
    # # o = subprocess.getoutput('curl -X GET "http://httpbin.org/hidden-basic-auth/u123/p123" -H  "accept: application/json"')
    # # print(o)
