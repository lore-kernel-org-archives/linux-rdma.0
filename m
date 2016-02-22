From: Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [libibverbs] libibverbs: Modify ibv_asyncwatch to accept the monitored device
Date: Mon, 22 Feb 2016 16:45:04 +0200
Message-ID: <1456152304-16924-1-git-send-email-eranbe@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Moshe Lazer <moshel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The current code always monitors the first device found. This patch
allows to specify the monitored device by a command line argument.

Signed-off-by: Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Moshe Lazer <moshel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 examples/asyncwatch.c | 54 ++++++++++++++++++++++++++++++++++++++++++++++-----
 man/ibv_asyncwatch.1  | 14 +++++++++++++
 2 files changed, 63 insertions(+), 5 deletions(-)

diff --git a/examples/asyncwatch.c b/examples/asyncwatch.c
index da7ebd4..a77c1c8 100644
--- a/examples/asyncwatch.c
+++ b/examples/asyncwatch.c
@@ -37,6 +37,8 @@
 #include <stdio.h>
 #include <endian.h>
 #include <byteswap.h>
+#include <getopt.h>
+#include <string.h>
 
 #include <infiniband/verbs.h>
 
@@ -76,35 +78,77 @@ static const char *event_name_str(enum ibv_event_type event_type)
 	}
 }
 
+static void usage(const char *argv0)
+{
+	printf("Usage:\n");
+	printf("  %s            start an asyncwatch process\n", argv0);
+	printf("\n");
+	printf("Options:\n");
+	printf("  -d, --ib-dev=<dev>     use IB device <dev> (default first device found)\n");
+	printf("  -h, --help             print a help text and exit\n");
+}
+
 int main(int argc, char *argv[])
 {
 	struct ibv_device **dev_list;
 	struct ibv_context *context;
 	struct ibv_async_event event;
+	char   *ib_devname = NULL;
+	int i = 0;
 
 	/* Force line-buffering in case stdout is redirected */
 	setvbuf(stdout, NULL, _IOLBF, 0);
 
+	while (1) {
+		int ret = 1;
+		int c;
+		static struct option long_options[] = {
+			{ .name = "ib-dev",    .has_arg = 1, .val = 'd' },
+			{ .name = "help",      .has_arg = 0, .val = 'h' },
+			{ 0 }
+		};
+
+		c = getopt_long(argc, argv, "d:h", long_options, NULL);
+		if (c == -1)
+			break;
+		switch (c) {
+		case 'd':
+			ib_devname = strdupa(optarg);
+			break;
+		case 'h':
+			ret = 0;
+		default:
+			usage(argv[0]);
+			return ret;
+		}
+	}
 	dev_list = ibv_get_device_list(NULL);
 	if (!dev_list) {
 		perror("Failed to get IB devices list");
 		return 1;
 	}
+	if (ib_devname) {
+		for (; dev_list[i]; ++i) {
+			if (!strcmp(ibv_get_device_name(dev_list[i]), ib_devname))
+				break;
+		}
+	}
 
-	if (!*dev_list) {
-		fprintf(stderr, "No IB devices found\n");
+	if (!dev_list[i]) {
+		fprintf(stderr, "IB device %s not found\n",
+			ib_devname ? ib_devname : "");
 		return 1;
 	}
 
-	context = ibv_open_device(*dev_list);
+	context = ibv_open_device(dev_list[i]);
 	if (!context) {
 		fprintf(stderr, "Couldn't get context for %s\n",
-			ibv_get_device_name(*dev_list));
+			ibv_get_device_name(dev_list[i]));
 		return 1;
 	}
 
 	printf("%s: async event FD %d\n",
-	       ibv_get_device_name(*dev_list), context->async_fd);
+	       ibv_get_device_name(dev_list[i]), context->async_fd);
 
 	while (1) {
 		if (ibv_get_async_event(context, &event))
diff --git a/man/ibv_asyncwatch.1 b/man/ibv_asyncwatch.1
index ece25f8..09f9f65 100644
--- a/man/ibv_asyncwatch.1
+++ b/man/ibv_asyncwatch.1
@@ -5,12 +5,26 @@ ibv_asyncwatch \- display asynchronous events
 
 .SH SYNOPSIS
 .B ibv_asyncwatch
+[\-d device] [-h]
 
 .SH DESCRIPTION
 .PP
 Display asynchronous events forwarded to userspace for an RDMA device.
 
+.SH OPTIONS
+
+.PP
+.TP
+\fB\-d\fR, \fB\-\-ib\-dev\fR=\fIDEVICE\fR
+use IB device \fIDEVICE\fR (default first device found)
+.TP
+\fB\-h\fR, \fB\-\-help\fR=\fIDEVICE\fR
+Print a help text and exit.
+
 .SH AUTHORS
 .TP
 Roland Dreier
 .RI < rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org >
+.TP
+Eran Ben Elisha
+.RI < eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org >
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
