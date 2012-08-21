From: Sridhar Samudrala <sri-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: RE: [PATCH 5/7] librdmacm/rspreload: Do not block connect when
 supporting fork
Date: Tue, 21 Aug 2012 10:43:42 -0700
Message-ID: <1345571022.31684.13.camel@oc1677441337.ibm.com>
References: <1828884A29C6694DAF28B7E6B8A8237346A8997B@ORSMSX101.amr.corp.intel.com>
	 <1345250413.1128.36.camel@oc1677441337.ibm.com>
	 <1828884A29C6694DAF28B7E6B8A8237346A8A1CF@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-yeVayIN3JYKQg0jt91bt"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237346A8A1CF-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

--=-yeVayIN3JYKQg0jt91bt
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

On Mon, 2012-08-20 at 20:22 +0000, Hefty, Sean wrote:
> > I just updated the repository and noticed that we are falling back to
> > normal sockets even with preload.
> > After some debugging, found a couple of issuse. See inline.
> 
> Thanks for the report.
> 
> I've pushed a patch to the repository to address those issues, along with one other problem that I was able to hit.  If the connection is nonblocking, then fork_active() can be called before the connection has completed, which can result in getpeername() failing.
> 
> I'm still not able to reproduce the hang that you were seeing, but I can reproduce the problem where the throughput strongly favors the first process to connect over a second process.  I'm looking into that.

I am seeing another hang with 2 clients doing bi-directional traffic to a server.
I am consistently seeing this hang with the attached test programs.

You can start the server using
  tcp_server -d -e

and run 2 clients
  tcp_client -h <server-ip> -n 10000 -d -e

Can you try it out with your IB setup? If you don't see this hang, then it is possible
that the issues i am seeing are RoCE specific.

Thanks
Sridhar

--=-yeVayIN3JYKQg0jt91bt
Content-Disposition: attachment; filename="tcp_client.c"
Content-Type: text/x-csrc; name="tcp_client.c"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

#include <sys/types.h>
#include <sys/socket.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <getopt.h>
#include <netdb.h>

char big_buf[65536];
char *addr = NULL;
unsigned short port = 12345;
int msg_len = 16384;
int echo = 0;
int debug = 0;
unsigned int nmsgs = 0xffffffff;

usage(char *argv0)
{
	printf("Usage:%s -h <hostip> -p <port> [-n <num-msgs>] [-l <msg-length>] [-e] [-d]\n",
		 argv0);
	exit(1);
}

main(int argc, char **argv)
{
	int c_sk, c, i = 0;
	int optval;
	socklen_t optlen;
	struct addrinfo *ai;
	struct addrinfo hints;
	struct sockaddr_storage remote, local;
	socklen_t remote_len, local_len;
	char port_string[10];
	char remote_addr[200];
	char remote_port[10];
	char local_addr[200];
	char local_port[10];
	int nbytes_rcv, nbytes_snd;

        /* Parse the arguments.  */
	while (1) {
		c = getopt(argc, argv, "h:p:l:n:ed");
		if (c == -1)
			break;

		switch(c) {
                case 'h':
                        addr = optarg;
                        break;
                case 'p':
                        port = atoi(optarg);
                        break;
                case 'l':
                        msg_len = atoi(optarg);
                        break;
                case 'n':
                        nmsgs = atoi(optarg);
                        break;
                case 'e':
                        echo = 1;
                        break;
                case 'd':
                        debug = 1;
                        break;
                default:
                        usage(argv[0]);
			break;
		}
	}

	if (addr == NULL)
		usage(argv[0]);

	if (msg_len > 65536) {
		printf("Maximum message size supported is 65536\n");
		exit(1);
	}

	sprintf(port_string, "%d", port);	
	memset(&hints, '\0', sizeof(hints));
	hints.ai_flags = AI_ADDRCONFIG | AI_NUMERICSERV | AI_NUMERICHOST;
	hints.ai_socktype = SOCK_STREAM;

	int e = getaddrinfo(addr, port_string, &hints, &ai);	
	if (e != 0)
		error (EXIT_FAILURE, 0, "getaddrinfo: %s", gai_strerror(e));

	c_sk = socket(ai->ai_family, ai->ai_socktype, ai->ai_protocol);
	if (-1 == c_sk) {
		perror("socket(c_sk)");
		exit(1);
	}

	optval = 1;
	optlen = sizeof(optval);
	if (setsockopt(c_sk, SOL_SOCKET, SO_KEEPALIVE, &optval, optlen) != 0) {
		perror("setsockopt(c_sk, SO_KEEPALIVE)");
		exit(1);
	}

	if (connect(c_sk, ai->ai_addr, ai->ai_addrlen) != 0) {
		perror("connect(c_sk)");
		exit(1);
	}

	local_len = sizeof(local);
	e = getsockname(c_sk, (struct sockaddr *)&local, &local_len);
	if (e != 0) {
		printf("getsockname failed with error :%d\n", e);
		exit(1);
	}

	e = getnameinfo((struct sockaddr *)&local, local_len,
			local_addr, sizeof(local_addr), local_port,
			sizeof(local_port), NI_NUMERICHOST|NI_NUMERICSERV);
	if (e != 0)
		error (EXIT_FAILURE, 0, "getnameinfo: %s", gai_strerror(e));

	e = getnameinfo((struct sockaddr *)ai->ai_addr, ai->ai_addrlen,
			remote_addr, sizeof(remote_addr), remote_port,
			sizeof(remote_port), NI_NUMERICHOST|NI_NUMERICSERV);
	if (e != 0)
		error (EXIT_FAILURE, 0, "getnameinfo: %s", gai_strerror(e));

	printf("Sending %u messages of size %d to %s:%s\n",
		nmsgs, msg_len, addr, port_string);

	nbytes_rcv = 0;
	nbytes_snd = 0;
	while (nmsgs--) {
		if (send(c_sk, big_buf, msg_len, 0) != msg_len) {
			perror("send(c_sk)");
			exit(1);
		}
		nbytes_snd += msg_len;
		if (debug)
			printf("[%8d] %6d bytes total:%d [%s]:%s -> [%s]:%s\n",
				++i, msg_len, nbytes_snd, local_addr,
				local_port, remote_addr, remote_port);

		if (!echo)
			continue;

		if (recv(c_sk, big_buf, msg_len, MSG_WAITALL) != msg_len) {
			perror("recv(c_sk)");
			exit(1);
		}
		nbytes_rcv += msg_len;
		if (debug)
			printf("[%8d] %6d bytes total:%d [%s]:%s <- [%s]:%s\n",
				i, msg_len, nbytes_rcv, local_addr, local_port,
				remote_addr, remote_port);
	}

	close(c_sk);
}

--=-yeVayIN3JYKQg0jt91bt
Content-Disposition: attachment; filename="tcp_server.c"
Content-Type: text/x-csrc; name="tcp_server.c"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

#include <sys/types.h>
#include <sys/socket.h>
#include <stdio.h>
#include <stdlib.h>
#include <getopt.h>
#include <signal.h>
#include <string.h>
#include <linux/tcp.h>
#include <linux/socket.h>
#include <netdb.h>

char big_buf[65536];
unsigned short port = 12345;
int echo = 0;
int debug = 0;

usage(char *argv0)
{
	printf("Usage:%s [-p <port>] [-e] [-d]\n", argv0);
	exit(1);
}

void on_sigchld(int sig)
{
	pid_t pid;

	pid = wait(NULL);
	if (pid != -1)
		printf("Child %d exited\n", pid);
	signal(SIGCHLD, on_sigchld);
}

main(int argc, char **argv)
{
	int l_sk, a_sk;
	int optval;
	socklen_t optlen;
	int len, c, i = 0;
	pid_t pid;
	struct addrinfo *ai;
	struct addrinfo hints;
	struct sockaddr_storage remote, local;
	socklen_t remote_len, local_len;
	char port_string[10];
	char remote_addr[200];
	char remote_port[10];
	char local_addr[200];
	char local_port[10];
	int nbytes_rcv;
	int nbytes_snd;

        /* Parse the arguments.  */
	while (1) {
		c = getopt(argc, argv, "p:ed");
		if (c == -1)
			break;

		switch(c) {
                case 'p':
                        port = atoi(optarg);
                        break;
                case 'e':
                        echo = 1;
                        break;
                case 'd':
                        debug = 1;
                        break;
                default:
                        usage(argv[0]);
			break;
		}
	}

	signal(SIGCHLD, on_sigchld);

	sprintf(port_string, "%d", port);	
	memset(&hints, '\0', sizeof(hints));
	hints.ai_flags = AI_PASSIVE | AI_ADDRCONFIG | AI_NUMERICSERV;
	hints.ai_socktype = SOCK_STREAM;
	hints.ai_family = AF_INET;

	int e = getaddrinfo(NULL, port_string, &hints, &ai);	
	if (e != 0)
		error (EXIT_FAILURE, 0, "getaddrinfo: %s", gai_strerror(e));

	l_sk = socket(ai->ai_family, ai->ai_socktype, ai->ai_protocol);
	if (-1 == l_sk) {
		perror("socket(l_sk)");
		exit(1);
	}

	optval = 1;
	optlen = sizeof(optval);
	if (setsockopt(l_sk, SOL_SOCKET, SO_REUSEADDR, &optval, optlen) != 0) {
		perror("setsockopt(l_sk, SO_REUSEADDR)");
		exit(1);
	}

	if (bind(l_sk, ai->ai_addr, ai->ai_addrlen) != 0) {
		perror("bind(l_sk)");
		exit(1);
	}

	if (listen(l_sk, 3) != 0) {
		perror("listen(l_sk)");
		exit(1);
	}

	e = getnameinfo((struct sockaddr *)ai->ai_addr, ai->ai_addrlen,
			local_addr, sizeof(local_addr), local_port,
			sizeof(local_port), NI_NUMERICHOST|NI_NUMERICSERV);
	if (e != 0)
		error (EXIT_FAILURE, 0, "getnameinfo: %s", gai_strerror(e));

	printf("Listening on [%s]:%s\n", local_addr, local_port);

accept:
	remote_len = sizeof(remote);
	a_sk = accept(l_sk, (struct sockaddr *)&remote, &remote_len);
	if (a_sk == -1) {
		perror("accept(l_sk)");
		exit(1);
	}

	e = getnameinfo((struct sockaddr *)&remote, remote_len, remote_addr,
			sizeof(remote_addr), remote_port, sizeof(remote_port),
			NI_NUMERICHOST|NI_NUMERICSERV);
	if (e != 0)
		error (EXIT_FAILURE, 0, "getnameinfo: %s", gai_strerror(e));

	pid = fork();
	if (pid == -1) {
		perror("fork");
		exit(1);
	}

	if (pid != 0) {
		/* parent */
		printf("Got a connection request from %s:%s, Child %d forked\n",
		 remote_addr, remote_port, pid); 
		close(a_sk);
		goto accept;
	}

	/* child */
	close(l_sk);
	nbytes_rcv = 0;
	nbytes_snd = 0;
	while (1) {
		len = recv(a_sk, big_buf, sizeof(big_buf), 0);
		if (len == -1) {
			perror("recv(a_sk)");
			exit(1);
		}
		if (len == 0)
			break;
		nbytes_rcv += len;

		if (debug)
			printf("[%8d] %6d bytes total:%d [%s]:%s <- [%s]:%s\n",
			 	++i, len, nbytes_rcv, local_addr, local_port, 
				remote_addr, remote_port);

		if (!echo)
			continue;

		len = send(a_sk, big_buf, len, 0);
		if (len == -1) {
			perror("send(a_sk)");
			exit(1);
		}
		nbytes_snd += len;
		if (debug)
			printf("[%8d] %6d bytes total:%d [%s]:%s -> [%s]:%s\n",
				i, len, nbytes_snd, local_addr, local_port, 
				remote_addr, remote_port);
	} 
	close(a_sk);
}

--=-yeVayIN3JYKQg0jt91bt--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
