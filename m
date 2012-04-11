From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [RFC] [PATCH 2/4] rsocket: Add example program that uses rsocket
Date: Wed, 11 Apr 2012 18:29:28 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373451ACEAB@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

rstream provides an example that uses either rsocket or socket
APIs.  The latter allows rstream to be used to verify rsocket
behavior compared to socket.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 Makefile.am        |    5 
 examples/rstream.c |  570 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 man/rstream.1      |   60 +++++
 3 files changed, 634 insertions(+), 1 deletions(-)
 create mode 100644 examples/rstream.c
 create mode 100644 man/rstream.1

diff --git a/Makefile.am b/Makefile.am
index ea64f7a..15423f4 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -21,7 +21,7 @@ src_librdmacm_la_DEPENDENCIES =  $(srcdir)/src/librdmacm.map
 
 bin_PROGRAMS = examples/ucmatose examples/rping examples/udaddy examples/mckey \
 	       examples/rdma_client examples/rdma_server examples/rdma_xclient \
-	       examples/rdma_xserver
+	       examples/rdma_xserver examples/rstream
 examples_ucmatose_SOURCES = examples/cmatose.c examples/common.c
 examples_ucmatose_LDADD = $(top_builddir)/src/librdmacm.la
 examples_rping_SOURCES = examples/rping.c
@@ -38,6 +38,8 @@ examples_rdma_xclient_SOURCES = examples/rdma_xclient.c
 examples_rdma_xclient_LDADD = $(top_builddir)/src/librdmacm.la
 examples_rdma_xserver_SOURCES = examples/rdma_xserver.c
 examples_rdma_xserver_LDADD = $(top_builddir)/src/librdmacm.la
+examples_rstream_SOURCES = examples/rstream.c
+examples_rstream_LDADD = $(top_builddir)/src/librdmacm.la
 
 librdmacmincludedir = $(includedir)/rdma
 infinibandincludedir = $(includedir)/infiniband
@@ -107,6 +109,7 @@ man_MANS = \
 	man/rdma_client.1 \
 	man/rdma_xserver.1 \
 	man/rdma_xclient.1 \
+	man/rstream.1 \
 	man/rdma_cm.7
 
 EXTRA_DIST = src/cma.h src/indexer.h src/librdmacm.map \
diff --git a/examples/rstream.c b/examples/rstream.c
new file mode 100644
index 0000000..8aa089d
--- /dev/null
+++ b/examples/rstream.c
@@ -0,0 +1,570 @@
+/*
+ * Copyright (c) 2011-2012 Intel Corporation.  All rights reserved.
+ *
+ * This software is available to you under the OpenIB.org BSD license
+ * below:
+ *
+ *     Redistribution and use in source and binary forms, with or
+ *     without modification, are permitted provided that the following
+ *     conditions are met:
+ *
+ *      - Redistributions of source code must retain the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer.
+ *
+ *      - Redistributions in binary form must reproduce the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer in the documentation and/or other materials
+ *        provided with the distribution.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AWV
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ */
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <strings.h>
+#include <errno.h>
+#include <getopt.h>
+#include <sys/types.h>
+#include <sys/socket.h>
+#include <sys/time.h>
+#include <netdb.h>
+#include <fcntl.h>
+#include <unistd.h>
+#include <netinet/in.h>
+#include <netinet/tcp.h>
+
+#include <rdma/rdma_cma.h>
+#include <rdma/rsocket.h>
+
+static int test_size[] = {
+	64,
+	4096,
+	65536,
+	1048576
+};
+#define TEST_CNT (sizeof test_size / sizeof test_size[0])
+
+static int use_rs = 1;
+static int use_async;
+static int verify;
+static int flags;
+static int no_delay;
+static int custom;
+static int iterations = 1;
+static int transfer_size = 1000;
+static int transfer_count = 1000;
+static char test_name[9] = "custom";
+static char *port = "7471";
+static char *dst_addr;
+static char *src_addr;
+static struct timeval start, end;
+static void *buf;
+
+#define rs_socket(f,t,p)  use_rs ? rsocket(f,t,p)  : socket(f,t,p)
+#define rs_bind(s,a,l)    use_rs ? rbind(s,a,l)    : bind(s,a,l)
+#define rs_listen(s,b)    use_rs ? rlisten(s,b)    : listen(s,b)
+#define rs_connect(s,a,l) use_rs ? rconnect(s,a,l) : connect(s,a,l)
+#define rs_accept(s,a,l)  use_rs ? raccept(s,a,l)  : accept(s,a,l)
+#define rs_shutdown(s,h)  use_rs ? rshutdown(s,h)  : shutdown(s,h)
+#define rs_close(s)       use_rs ? rclose(s)       : close(s)
+#define rs_recv(s,b,l,f)  use_rs ? rrecv(s,b,l,f)  : recv(s,b,l,f)
+#define rs_send(s,b,l,f)  use_rs ? rsend(s,b,l,f)  : send(s,b,l,f)
+#define rs_poll(f,n,t)	  use_rs ? rpoll(f,n,t)	   : poll(f,n,t)
+#define rs_fcntl(s,c,p)   use_rs ? rfcntl(s,c,p)   : fcntl(s,c,p)
+#define rs_setsockopt(s,l,n,v,ol) \
+	use_rs ? rsetsockopt(s,l,n,v,ol) : setsockopt(s,l,n,v,ol)
+#define rs_getsockopt(s,l,n,v,ol) \
+	use_rs ? rgetsockopt(s,l,n,v,ol) : getsockopt(s,l,n,v,ol)
+
+static void size_str(char *str, long long size)
+{
+	if (size >= (1 << 30))
+		sprintf(str, "%lldg", size / (1 << 30));
+	else if (size >= (1 << 20))
+		sprintf(str, "%lldm", size / (1 << 20));
+	else if (size >= (1 << 10))
+		sprintf(str, "%lldk", size / (1 << 10));
+	else
+		sprintf(str, "%lld", size);
+}
+
+static void cnt_str(char *str, long long cnt)
+{
+	if (cnt >= 1000000000)
+		sprintf(str, "%lldb", cnt / 1000000000);
+	else if (cnt >= 1000000)
+		sprintf(str, "%lldm", cnt / 1000000);
+	else if (cnt >= 1000)
+		sprintf(str, "%lldk", cnt / 1000);
+	else
+		sprintf(str, "%lld", cnt);
+}
+
+static void show_perf(void)
+{
+	char str[32];
+	float usec;
+	long long bytes;
+
+	usec = (end.tv_sec - start.tv_sec) * 1000000 + (end.tv_usec - start.tv_usec);
+	bytes = (long long) iterations * transfer_count * transfer_size * 2;
+
+	/* name size transfers iterations bytes seconds Gb/sec usec/xfer */
+	printf("%s\t", test_name);
+	size_str(str, transfer_size);
+	printf("%s\t", str);
+	cnt_str(str, transfer_count);
+	printf("%s\t", str);
+	cnt_str(str, iterations);
+	printf("%s\t", str);
+	size_str(str, bytes);
+	printf("%s\t", str);
+	printf("%.2fs \t%.2f \t%.2f\n",
+		usec / 1000000., (bytes * 8) / (1000. * usec),
+		(usec / iterations) / (transfer_count * 2));
+}
+
+static int size_to_count(int size)
+{
+	if (size >= 1000000)
+		return 100;
+	else if (size >= 100000)
+		return 1000;
+	else if (size >= 10000)
+		return 10000;
+	else if (size >= 1000)
+		return 100000;
+	else
+		return 1000000;
+}
+
+static void init_latency_test(int size)
+{
+	size_str(test_name, size);
+	sprintf(test_name, "%s_lat", test_name);
+	no_delay = 1;
+	flags |= MSG_DONTWAIT;
+	transfer_count = 1;
+	transfer_size = size;
+	iterations = size_to_count(transfer_size);
+}
+
+static void init_bandwidth_test(int size)
+{
+	size_str(test_name, size);
+	sprintf(test_name, "%s_bw", test_name);
+	no_delay = 1;
+	flags |= MSG_DONTWAIT;
+	iterations = 1;
+	transfer_size = size;
+	transfer_count = size_to_count(transfer_size);
+}
+
+static void format_buf(void *buf, int size)
+{
+	uint8_t *array = buf;
+	static uint8_t data;
+	int i;
+
+	for (i = 0; i < size; i++)
+		array[i] = data++;
+}
+
+static int verify_buf(void *buf, int size)
+{
+	static long long total_bytes;
+	uint8_t *array = buf;
+	static uint8_t data;
+	int i;
+
+	for (i = 0; i < size; i++, total_bytes++) {
+		if (array[i] != data++) {
+			printf("data verification failed byte %lld\n", total_bytes);
+			return -1;
+		}
+	}
+	return 0;
+}
+
+static int send_xfer(int rs, int size)
+{
+	struct pollfd fds;
+	int offset, ret;
+
+	if (verify)
+		format_buf(buf, size);
+
+	if (use_async) {
+		fds.fd = rs;
+		fds.events = POLLOUT;
+	}
+
+	for (offset = 0; offset < size; ) {
+		if (use_async) {
+			ret = rs_poll(&fds, 1, -1);
+			if (ret != 1)
+				return ret;
+		}
+
+		ret = rs_send(rs, buf + offset, size - offset, flags);
+		if (ret > 0) {
+			offset += ret;
+		} else if (errno != EWOULDBLOCK && errno != EAGAIN) {
+			perror("rsend");
+			return ret;
+		}
+	}
+
+	return 0;
+}
+
+static int recv_xfer(int rs, int size)
+{
+	struct pollfd fds;
+	int offset, ret;
+
+	if (use_async) {
+		fds.fd = rs;
+		fds.events = POLLIN;
+	}
+
+	for (offset = 0; offset < size; ) {
+		if (use_async) {
+			ret = rs_poll(&fds, 1, -1);
+			if (ret != 1)
+				return ret;
+		}
+
+		ret = rs_recv(rs, buf + offset, size - offset, flags);
+		if (ret > 0) {
+			offset += ret;
+		} else if (errno != EWOULDBLOCK && errno != EAGAIN) {
+			perror("rrecv");
+			return ret;
+		}
+	}
+
+	if (verify) {
+		ret = verify_buf(buf, size);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
+static int sync_test(int rs)
+{
+	int ret;
+
+	ret = dst_addr ? send_xfer(rs, 4) : recv_xfer(rs, 4);
+	if (ret)
+		return ret;
+
+	return dst_addr ? recv_xfer(rs, 4) : send_xfer(rs, 4);
+}
+
+static int run_test(int rs)
+{
+	int ret, i, t;
+
+	ret = sync_test(rs);
+	if (ret)
+		goto out;
+
+	gettimeofday(&start, NULL);
+	for (i = 0; i < iterations; i++) {
+		for (t = 0; t < transfer_count; t++) {
+			ret = dst_addr ? send_xfer(rs, transfer_size) :
+					 recv_xfer(rs, transfer_size);
+			if (ret)
+				goto out;
+		}
+
+		for (t = 0; t < transfer_count; t++) {
+			ret = dst_addr ? recv_xfer(rs, transfer_size) :
+					 send_xfer(rs, transfer_size);
+			if (ret)
+				goto out;
+		}
+	}
+	gettimeofday(&end, NULL);
+	show_perf();
+	ret = 0;
+
+out:
+	return ret;
+}
+
+static void set_options(int rs)
+{
+	int val, optname, ret;
+	long long bytes;
+	socklen_t size;
+
+	bytes = transfer_size * transfer_count * iterations;
+	for (optname = SO_SNDBUF; ; optname = SO_RCVBUF) {
+		size = sizeof val;
+		ret = rs_getsockopt(rs, SOL_SOCKET, optname, (void *) &val, &size);
+		if (ret)
+			break;
+
+		if (val < bytes) {
+			size = sizeof val;
+			val = ((val << 2) > bytes) ? bytes : (val << 2);
+			rs_setsockopt(rs, SOL_SOCKET, optname, (void *) &val, size);
+		}
+
+		if (optname == SO_RCVBUF)
+			break;
+	}
+
+	if (no_delay) {
+		rs_setsockopt(rs, IPPROTO_TCP, TCP_NODELAY,
+			      (void *) &no_delay, sizeof(no_delay));
+	}
+
+	if (flags & MSG_DONTWAIT) {
+		rs_fcntl(rs, F_SETFL, O_NONBLOCK);
+	}
+}
+
+static int server_connect(void)
+{
+	struct pollfd fds;
+	struct addrinfo hints, *res;
+	int rs, lrs, ret;
+
+	memset(&hints, 0, sizeof hints);
+	hints.ai_flags = RAI_PASSIVE;
+ 	ret = getaddrinfo(src_addr, port, &hints, &res);
+	if (ret) {
+		perror("getaddrinfo");
+		return ret;
+	}
+
+	lrs = rs_socket(res->ai_family, res->ai_socktype, res->ai_protocol);
+	if (lrs < 0) {
+		perror("rsocket");
+		rs = lrs;
+		goto free;
+	}
+
+	set_options(lrs);
+	rs = 1;
+	rs = rs_setsockopt(lrs, SOL_SOCKET, SO_REUSEADDR, &rs, sizeof rs);
+	if (rs) {
+		perror("rsetsockopt SO_REUSEADDR");
+		goto close;
+	}
+
+	rs = rs_bind(lrs, res->ai_addr, res->ai_addrlen);
+	if (rs) {
+		perror("rbind");
+		goto close;
+	}
+
+	rs = rs_listen(lrs, 1);
+	if (rs) {
+		perror("rlisten");
+		goto close;
+	}
+
+	do {
+		if (use_async) {
+			fds.fd = lrs;
+			fds.events = POLLIN;
+
+			ret = rs_poll(&fds, 1, -1);
+			if (ret != 1) {
+				perror("rpoll");
+				goto close;
+			}
+		}
+
+		rs = rs_accept(lrs, NULL, 0);
+	} while (rs < 0 && (errno == EAGAIN || errno == EWOULDBLOCK));
+	if (rs < 0)
+		perror("raccept");
+
+	set_options(rs);
+close:
+	rs_close(lrs);
+free:
+	freeaddrinfo(res);
+	return rs;
+}
+
+static int client_connect(void)
+{
+	struct addrinfo *res;
+	struct pollfd fds;
+	int ret, rs;
+
+ 	ret = getaddrinfo(dst_addr, port, NULL, &res);
+	if (ret) {
+		perror("getaddrinfo");
+		return ret;
+	}
+
+	rs = rs_socket(res->ai_family, res->ai_socktype, res->ai_protocol);
+	if (rs < 0) {
+		perror("rsocket");
+		goto free;
+	}
+
+	set_options(rs);
+	/* TODO: bind client to src_addr */
+
+	ret = rs_connect(rs, res->ai_addr, res->ai_addrlen);
+	if (ret && (errno != EINPROGRESS)) {
+		perror("rconnect");
+		rs_close(rs);
+		rs = ret;
+	}
+
+	if (errno == EINPROGRESS) {
+		fds.fd = rs;
+		fds.events = POLLOUT;
+		do {
+			ret = rs_poll(&fds, 1, -1);
+		} while (!ret);
+	}
+
+free:
+	freeaddrinfo(res);
+	return rs;
+}
+
+static int run(void)
+{
+	int i, rs, ret = 0;
+
+	buf = malloc(!custom ? test_size[TEST_CNT - 1] : transfer_size);
+	if (!buf) {
+		perror("malloc");
+		return -1;
+	}
+
+	rs = dst_addr ? client_connect() : server_connect();
+	if (rs < 0) {
+		ret = rs;
+		goto free;
+	}
+
+	printf("name \tbytes \txfers \titers \ttotal \ttime \tGb/sec \tusec/xfer\n");
+	if (!custom) {
+		for (i = 0; i < TEST_CNT; i++) {
+			init_latency_test(test_size[i]);
+			run_test(rs);
+			init_bandwidth_test(test_size[i]);
+			run_test(rs);
+		}
+	} else {
+		ret = run_test(rs);
+	}
+
+	rs_shutdown(rs, SHUT_RDWR);
+	rs_close(rs);
+free:
+	free(buf);
+	return ret;
+}
+
+static int set_test_opt(char *optarg)
+{
+	if (strlen(optarg) == 1) {
+		switch (optarg[0]) {
+		case 's':
+			use_rs = 0;
+			break;
+		case 'a':
+			use_async = 1;
+			break;
+		case 'n':
+			flags |= MSG_DONTWAIT;
+			no_delay = 1;
+			break;
+		case 'v':
+			verify = 1;
+			break;
+		default:
+			return -1;
+		}
+	} else {
+		if (!strncasecmp("socket", optarg, 6)) {
+			use_rs = 0;
+		} else if (!strncasecmp("async", optarg, 5)) {
+			use_async = 1;
+		} else if (!strncasecmp("nonblock", optarg, 8)) {
+			flags |= MSG_DONTWAIT;
+			no_delay = 1;
+		} else if (!strncasecmp("verify", optarg, 6)) {
+			verify = 1;
+		} else {
+			return -1;
+		}
+	}
+	return 0;
+}
+
+int main(int argc, char **argv)
+{
+	int op, ret;
+
+	while ((op = getopt(argc, argv, "s:b:I:C:S:p:T:")) != -1) {
+		switch (op) {
+		case 's':
+			dst_addr = optarg;
+			break;
+		case 'b':
+			src_addr = optarg;
+			break;
+		case 'I':
+			custom = 1;
+			iterations = atoi(optarg);
+			break;
+		case 'C':
+			custom = 1;
+			transfer_count = atoi(optarg);
+			break;
+		case 'S':
+			custom = 1;
+			transfer_size = atoi(optarg);
+			break;
+		case 'p':
+			port = optarg;
+			break;
+		case 'T':
+			if (!set_test_opt(optarg))
+				break;
+			/* invalid option - fall through */
+		default:
+			printf("usage: %s\n", argv[0]);
+			printf("\t[-s server_address]\n");
+			printf("\t[-b bind_address]\n");
+			printf("\t[-I iterations]\n");
+			printf("\t[-C transfer_count]\n");
+			printf("\t[-S transfer_size]\n");
+			printf("\t[-p port_number]\n");
+			printf("\t[-T test_option]\n");
+			printf("\t    s|sockets - use standard tcp/ip sockets\n");
+			printf("\t    a|async - asynchronous operation\n");
+			printf("\t    n|nonblocking - use nonblocking calls\n");
+			printf("\t    v|verify - verify data\n");
+			exit(1);
+		}
+	}
+
+	ret = run();
+	return ret;
+}
diff --git a/man/rstream.1 b/man/rstream.1
new file mode 100644
index 0000000..701db3a
--- /dev/null
+++ b/man/rstream.1
@@ -0,0 +1,60 @@
+.TH "RSTREAM" 1 "2011-11-16" "librdmacm" "librdmacm" librdmacm
+.SH NAME
+rstream \- streaming over RDMA ping-pong test.
+.SH SYNOPSIS
+.sp
+.nf
+\fIrstream\fR [-s server_address] [-b bind_address]
+			[-I iterations] [-C transfer_count]
+			[-S transfer_size] [-p server_port] [-T test_option]
+.fi
+.SH "DESCRIPTION"
+Uses the streaming over RDMA protocol (rsocket) to connect and exchange
+data between a client and server application.
+.SH "OPTIONS"
+.TP
+\-s server_address
+The network name or IP address of the server system listening for
+connections.  The used name or address must route over an RDMA device.
+This option must be specified by the client.
+.TP
+\-b bind_address
+The local network address to bind to.
+.TP
+\-I iterations
+The number of times that the specified number of messages will be
+exchanged between the client and server.  (default 1000)
+.TP
+\-C transfer_count
+The number of messages to transfer from the client to the server and
+back again on each iteration.  (default 1)
+.TP
+\-S transfer_size
+The size of each send transfer, in bytes.  (default 1000)
+.TP
+\-p server_port
+The server's port number.
+.TP
+\-T test_option
+Specifies test parameters.  Available options are:
+.P
+s | socket  - uses standard socket calls to transfer data
+.P
+a | async - uses asynchronous operation (e.g. select / poll)
+.P
+n | nonblocking - uses non-blocking calls
+.P
+v | verify - verifies data transfers
+.SH "NOTES"
+Basic usage is to start rstream on a server system, then run
+rstream -s server_name on a client system.  By default, rstream
+will run a series of latency and bandwidth performance tests.
+Specifying a different iterations, transfer_count, or transfer_size
+will run a user customized test using default values where none
+have been specified.
+.P
+Because this test maps RDMA resources to userspace, users must ensure
+that they have available system resources and permissions.  See the
+libibverbs README file for additional details.
+.SH "SEE ALSO"
+rdma_cm(7)


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
