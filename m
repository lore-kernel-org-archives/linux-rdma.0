From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 2/3] ibacm: change location of default configuration file
Date: Thu, 29 Jul 2010 11:07:18 -0700
Message-ID: <CF9C39F99A89134C9CF9C4CCB68B8DDF25A9272626@orsmsx501.amr.corp.intel.com>
References: <CF9C39F99A89134C9CF9C4CCB68B8DDF25A9272612@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CF9C39F99A89134C9CF9C4CCB68B8DDF25A9272612-osO9UTpF0USkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Move the default location of the configuration files from the
current directory to /etc/ibacm.  Change ib_acme to create the
files in this location, and modify ib_acm to use the files here
by default.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 linux/osd.h |    5 +++++
 src/acm.c   |   20 ++++++++++++++++----
 src/acme.c  |   56 ++++++++++++++++++++++++++++++++++++++++++++++----------
 3 files changed, 67 insertions(+), 14 deletions(-)

diff --git a/linux/osd.h b/linux/osd.h
index dc8bc1f..722e1b1 100644
--- a/linux/osd.h
+++ b/linux/osd.h
@@ -39,11 +39,16 @@
 #include <pthread.h>
 #include <sys/socket.h>
 #include <sys/types.h>
+#include <sys/stat.h>
 #include <malloc.h>
 #include <arpa/inet.h>
 #include <sys/time.h>
 #include <netinet/in.h>
 
+#define ACM_DEST_DIR "/etc/ibacm"
+#define ACM_ADDR_FILE "acm_addr.cfg"
+#define ACM_OPTS_FILE "acm_opts.cfg"
+
 #define LIB_DESTRUCTOR __attribute__((destructor))
 #define CDECL_FUNC
 
diff --git a/src/acm.c b/src/acm.c
index 8b09453..535a755 100644
--- a/src/acm.c
+++ b/src/acm.c
@@ -190,6 +190,8 @@ static struct acm_client client[FD_SETSIZE - 1];
 static FILE *flog;
 static lock_t log_lock;
 
+static char *opts_file = "/etc/ibacm/acm_opts.cfg";
+static char *addr_file = "/etc/ibacm/acm_addr.cfg";
 static char log_file[128] = "stdout";
 static int log_level = 0;
 static enum acm_addr_prot addr_prot = ACM_ADDR_PROT_ACM;
@@ -2197,7 +2199,7 @@ static int acm_assign_ep_names(struct acm_ep *ep)
 	acm_log(1, "device %s, port %d, pkey 0x%x\n",
 		dev_name, ep->port->port_num, ep->pkey);
 
-	if (!(f = fopen("acm_addr.cfg", "r"))) {
+	if (!(f = fopen(addr_file, "r"))) {
 		acm_log(0, "ERROR - unable to open acm_addr.cfg file\n");
 		return ACM_STATUS_ENODATA;
 	}
@@ -2536,7 +2538,7 @@ static void acm_set_options(void)
 	char s[120];
 	char opt[32], value[32];
 
-	if (!(f = fopen("acm_opts.cfg", "r")))
+	if (!(f = fopen(opts_file, "r")))
 		return;
 
 	while (fgets(s, sizeof s, f)) {
@@ -2637,7 +2639,11 @@ static void daemonize(void)
 static void show_usage(char *program)
 {
 	printf("usage: %s\n", program);
-	printf("   [-D] - run as a daemon\n");
+	printf("   [-D]             - run as a daemon\n");
+	printf("   [-A addr_file]   - address configuration file\n");
+	printf("                      (default %s/%s\n", ACM_DEST_DIR, ACM_ADDR_FILE);
+	printf("   [-O option_file] - option configuration file\n");
+	printf("                      (default %s/%s\n", ACM_DEST_DIR, ACM_OPTS_FILE);
 }
 
 int CDECL_FUNC main(int argc, char **argv)
@@ -2646,11 +2652,17 @@ int CDECL_FUNC main(int argc, char **argv)
 	int dev_cnt;
 	int op, i, daemon = 0;
 
-	while ((op = getopt(argc, argv, "D")) != -1) {
+	while ((op = getopt(argc, argv, "DA:O:")) != -1) {
 		switch (op) {
 		case 'D':
 			daemon = 1;
 			break;
+		case 'A':
+			addr_file = optarg;
+			break;
+		case 'O':
+			opts_file = optarg;
+			break;
 		default:
 			show_usage(argv[0]);
 			exit(1);
diff --git a/src/acme.c b/src/acme.c
index 5a5a09a..03e96ad 100644
--- a/src/acme.c
+++ b/src/acme.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2009 Intel Corporation.  All rights reserved.
+ * Copyright (c) 2009-2010 Intel Corporation.  All rights reserved.
  *
  * This software is available to you under the OpenIB.org BSD license
  * below:
@@ -39,6 +39,10 @@
 #include <infiniband/acm.h>
 #include "libacm.h"
 
+static char *dest_dir = ACM_DEST_DIR;
+static char *addr_file = ACM_ADDR_FILE;
+static char *opts_file = ACM_OPTS_FILE;
+
 static char *dest_addr;
 static char *src_addr;
 static char addr_type = 'i';
@@ -60,8 +64,12 @@ static void show_usage(char *program)
 	printf("   -d dest_addr     - format defined by -f option\n");
 	printf("   [-v]             - verify ACM response against SA query response\n");
 	printf("usage 2: %s\n", program);
-	printf("   -A               - generate local acm_addr.cfg configuration file\n");
-	printf("   -O               - generate local acm_ops.cfg options file\n");
+	printf("   -A [addr_file]   - generate local address configuration file\n");
+	printf("                      (default is %s)\n", ACM_ADDR_FILE);
+	printf("   -O [opt_file]    - generate local acm_opts.cfg options file\n");
+	printf("                      (default is %s)\n", ACM_OPTS_FILE);
+	printf("   -D dest_dir      - specify destination directory for output files\n");
+	printf("                      (default is %s)\n", ACM_DEST_DIR);
 }
 
 static void gen_opts_temp(FILE *f)
@@ -186,13 +194,23 @@ static void gen_opts_temp(FILE *f)
 	fprintf(f, "\n");
 }
 
+static int open_dir(void)
+{
+	mkdir(dest_dir, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
+	if (chdir(dest_dir)) {
+		printf("Failed to open directory %s: %s\n", dest_dir, strerror(errno));
+		return -1;
+	}
+	return 0;
+}
+
 static int gen_opts(void)
 {
 	FILE *f;
 
-	printf("Generating acm_opts.cfg\n");
-	if (!(f = fopen("acm_opts.cfg", "w"))) {
-		printf("Failed to open option configuration file\n");
+	printf("Generating %s/%s\n", dest_dir, opts_file);
+	if (open_dir() || !(f = fopen(opts_file, "w"))) {
+		printf("Failed to open option configuration file: %s\n", strerror(errno));
 		return -1;
 	}
 
@@ -325,9 +343,9 @@ static int gen_addr(void)
 	FILE *f;
 	int ret;
 
-	printf("Generating acm_addr.cfg\n");
-	if (!(f = fopen("acm_addr.cfg", "w"))) {
-		printf("Failed to open address configuration file\n");
+	printf("Generating %s/%s\n", dest_dir, addr_file);
+	if (open_dir() || !(f = fopen(addr_file, "w"))) {
+		printf("Failed to open address configuration file: %s\n", strerror(errno));
 		return -1;
 	}
 
@@ -493,6 +511,17 @@ static int resolve(char *program)
 	return ret;
 }
 
+char *opt_arg(int argc, char **argv)
+{
+	if (optarg)
+		return optarg;
+
+	if ((optind < argc) && (argv[optind][0] != '-'))
+		return argv[optind];
+
+	return NULL;
+}
+
 int CDECL_FUNC main(int argc, char **argv)
 {
 	int op, ret;
@@ -501,7 +530,7 @@ int CDECL_FUNC main(int argc, char **argv)
 	if (ret)
 		goto out;
 
-	while ((op = getopt(argc, argv, "f:s:d:vAO")) != -1) {
+	while ((op = getopt(argc, argv, "f:s:d:vA::O::D:")) != -1) {
 		switch (op) {
 		case 'f':
 			addr_type = optarg[0];
@@ -517,9 +546,16 @@ int CDECL_FUNC main(int argc, char **argv)
 			break;
 		case 'A':
 			make_addr = 1;
+			if (opt_arg(argc, argv))
+				addr_file = opt_arg(argc, argv);
 			break;
 		case 'O':
 			make_opts = 1;
+			if (opt_arg(argc, argv))
+				opts_file = opt_arg(argc, argv);
+			break;
+		case 'D':
+			dest_dir = optarg;
 			break;
 		default:
 			show_usage(argv[0]);


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
