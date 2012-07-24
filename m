From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 4/5] librdmacm/rstream: Add option to test fork support
Date: Tue, 24 Jul 2012 22:34:49 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237346A6D397@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

If the user specifies '-T f', rstream will process
connections in a child process.  The server continues
to run until all child processes have completed their
tests.

Fork support requires use of the librspreload library.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 examples/rstream.c |   36 ++++++++++++++++++++++++++++++------
 man/rstream.1      |    2 ++
 2 files changed, 32 insertions(+), 6 deletions(-)

diff --git a/examples/rstream.c b/examples/rstream.c
index 48e2771..befb7c6 100644
--- a/examples/rstream.c
+++ b/examples/rstream.c
@@ -36,6 +36,7 @@
 #include <sys/types.h>
 #include <sys/socket.h>
 #include <sys/time.h>
+#include <sys/wait.h>
 #include <netdb.h>
 #include <fcntl.h>
 #include <unistd.h>
@@ -84,6 +85,8 @@ static int verify;
 static int flags = MSG_DONTWAIT;
 static int poll_timeout = 0;
 static int custom;
+static int use_fork;
+static pid_t fork_pid;
 static enum rs_optimization optimization;
 static int size_option;
 static int iterations = 1;
@@ -463,7 +466,10 @@ static int server_connect(void)
 		perror("raccept");
 	}
 
-	set_options(rs);
+	if (use_fork)
+		fork_pid = fork();
+	if (!fork_pid)
+		set_options(rs);
 	return ret;
 }
 
@@ -546,20 +552,26 @@ static int run(void)
 		if (ret)
 			goto free;
 
-		for (i = 0; i < TEST_CNT; i++) {
+		for (i = 0; i < TEST_CNT && !fork_pid; i++) {
 			if (test_size[i].option > size_option)
 				continue;
 			init_latency_test(test_size[i].size);
 			run_test();
 		}
-		rs_shutdown(rs, SHUT_RDWR);
+		if (fork_pid)
+			wait(NULL);
+		else
+			rs_shutdown(rs, SHUT_RDWR);
 		rs_close(rs);
 
+		if (!dst_addr && use_fork && !fork_pid)
+			goto free;
+
 		optimization = opt_bandwidth;
 		ret = dst_addr ? client_connect() : server_connect();
 		if (ret)
 			goto free;
-		for (i = 0; i < TEST_CNT; i++) {
+		for (i = 0; i < TEST_CNT && !fork_pid; i++) {
 			if (test_size[i].option > size_option)
 				continue;
 			init_bandwidth_test(test_size[i].size);
@@ -570,10 +582,14 @@ static int run(void)
 		if (ret)
 			goto free;
 
-		ret = run_test();
+		if (!fork_pid)
+			ret = run_test();
 	}
 
-	rs_shutdown(rs, SHUT_RDWR);
+	if (fork_pid)
+		wait(NULL);
+	else
+		rs_shutdown(rs, SHUT_RDWR);
 	rs_close(rs);
 free:
 	free(buf);
@@ -593,6 +609,10 @@ static int set_test_opt(char *optarg)
 		case 'b':
 			flags &= ~MSG_DONTWAIT;
 			break;
+		case 'f':
+			use_fork = 1;
+			use_rs = 0;
+			break;
 		case 'n':
 			flags |= MSG_DONTWAIT;
 			break;
@@ -613,6 +633,9 @@ static int set_test_opt(char *optarg)
 			flags |= MSG_DONTWAIT;
 		} else if (!strncasecmp("verify", optarg, 6)) {
 			verify = 1;
+		} else if (!strncasecmp("fork", optarg, 4)) {
+			use_fork = 1;
+			use_rs = 0;
 		} else {
 			return -1;
 		}
@@ -671,6 +694,7 @@ int main(int argc, char **argv)
 			printf("\t    s|sockets - use standard tcp/ip sockets\n");
 			printf("\t    a|async - asynchronous operation (use poll)\n");
 			printf("\t    b|blocking - use blocking calls\n");
+			printf("\t    f|fork - fork server processing\n");
 			printf("\t    n|nonblocking - use nonblocking calls\n");
 			printf("\t    v|verify - verify data\n");
 			exit(1);
diff --git a/man/rstream.1 b/man/rstream.1
index ea87b95..29aa66b 100644
--- a/man/rstream.1
+++ b/man/rstream.1
@@ -48,6 +48,8 @@ a | async - uses asynchronous operation (e.g. select / poll)
 .P
 b | blocking - uses blocking calls
 .P
+f | fork - fork server processing (forces -T s option)
+.P
 n | nonblocking - uses non-blocking calls
 .P
 v | verify - verifies data transfers


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
