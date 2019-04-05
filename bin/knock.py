#!/usr/bin/env python3

import sys
import argparse


class Knocker(object):
    def __init__(self, args: list):
        self._parse_args(args)

    def _parse_args(self, args: list):
        description_text = 'Simple port-knocking client written in python3.' 
        parser = argparse.ArgumentParser(description=description_text)

        help_text = 'How many milliseconds to wait on hanging connection. Default is 200 ms.'
        parser.add_argument('-t', '--timeout', type=int, default=200, help=help_text)

        help_text = 'How many milliseconds to wait between each knock. Default is 200 ms.'
        parser.add_argument('-d', '--delay', type=int, default=200, help=help_text)

        parser.add_argument('-u', '--udp', help='Use UDP instead of TCP.', action='store_true')
        parser.add_argument('host', help='Hostname or IP address of the host to knock on. Supports IPv6.')
        parser.add_argument('ports', metavar='port', nargs='+', type=int, help='Port(s) to knock on.')

        args = parser.parse_args(args)
        self.timeout = args.timeout / 1000
        self.delay = args.delay / 1000
        self.use_udp = args.udp
        self.ports = args.ports

        self.address_family, self.socket_type, _, _, socket_address = socket.getaddrinfo(
                host=args.host,
                port=None,
                type=socket.SOCK_DGRAM if self.use_udp else socket.SOCK_STREAM,
                flags=socket.AI_ADDRCONFIG
            )[0]

        self.socket_address = list(socket_address)

    def knock(self):
        last_index = len(self.ports) - 1
        for i, port in enumerate(self.ports):
            socket_address = self.socket_address
            socket_address[1] = port
            socket_address = tuple(socket_address)

            s = socket.socket(self.address_family, self.socket_type)
            s.setblocking(False)

            if self.use_udp:
                s.sendto(b'', socket_address)
            else:
                s.connect_ex(socket_address)
                select.select([s], [s], [s], self.timeout)

            s.close()

            if self.delay and i != last_index:
                time.sleep(self.delay)


if __name__ == '__main__':
    Knocker(sys.argv[1:]).knock()

