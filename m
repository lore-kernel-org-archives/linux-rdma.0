From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH rdma-core 3/5] srp_daemon: Add command-line option -j
Date: Mon, 15 May 2017 15:47:25 -0700
Message-ID: <20170515224733.29586-4-bart.vanassche@sandisk.com>
References: <20170515224733.29586-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170515224733.29586-1-bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This command-line option is used in a later patch to avoid having
to start a shell script from a udev rule.

Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
---
 srp_daemon/srp_daemon.1.in | 15 +++++++++++----
 srp_daemon/srp_daemon.c    | 16 +++++++++++++++-
 2 files changed, 26 insertions(+), 5 deletions(-)

diff --git a/srp_daemon/srp_daemon.1.in b/srp_daemon/srp_daemon.1.in
index 02e1f2df..82dc3241 100644
--- a/srp_daemon/srp_daemon.1.in
+++ b/srp_daemon/srp_daemon.1.in
@@ -5,7 +5,7 @@
 srp_daemon \- Discovers SRP targets in an InfiniBand Fabric
 
 .SH SYNOPSIS
-.B srp_daemon\fR [\fB-vVcaeon\fR] [\fB-d \fIumad-device\fR | \fB-i \fIinfiniband-device\fR [\fB-p \fIport-num\fR]] [\fB-t \fItimeout(ms)\fR] [\fB-r \fIretries\fR] [\fB-R \fIrescan-time\fR] [\fB-f \fIrules-file\fR]
+.B srp_daemon\fR [\fB-vVcaeon\fR] [\fB-d \fIumad-device\fR | \fB-i \fIinfiniband-device\fR [\fB-p \fIport-num\fR] | \fB-j \fIdev:port\fR] [\fB-t \fItimeout(ms)\fR] [\fB-r \fIretries\fR] [\fB-R \fIrescan-time\fR] [\fB-f \fIrules-file\fR]
 
 
 .SH DESCRIPTION
@@ -41,13 +41,20 @@ Print more verbose output
 Print even more verbose output (debug mode)
 .TP
 \fB\-i\fR \fIinfiniband-device\fR
-Work on \fIinfiniband-device\fR. This option should not be used with -d.
+Work on \fIinfiniband-device\fR. This option should not be used with -d nor
+with -j.
 .TP
 \fB\-p\fR \fIport-num\fR
-Work on port \fIport-num\fR (default 1). This option must be used with -i and should not be used with -d.
+Work on port \fIport-num\fR (default 1). This option must be used with -i and
+should not be used with -d nor with -j.
+.TP
+\fB\-j\fR \fIdev:port\fR
+Work on port number \fIport\fR of InfiniBand device \fIdev\fR. This option
+should not be used with -d, -i nor with -p.
 .TP
 \fB\-d\fR \fIumad-device\fR
-Use device file \fIumad-device\fR (default /dev/infiniband/umad0) This option should not be used with -i or -p.
+Use device file \fIumad-device\fR (default /dev/infiniband/umad0) This option
+should not be used with -i, -p nor with -j.
 .TP
 \fB\-c\fR
 Generate output suitable for piping directly to a
diff --git a/srp_daemon/srp_daemon.c b/srp_daemon/srp_daemon.c
index 9011fe5e..c0e8d23d 100644
--- a/srp_daemon/srp_daemon.c
+++ b/srp_daemon/srp_daemon.c
@@ -226,6 +226,7 @@ static void usage(const char *argv0)
 	fprintf(stderr, "-d <umad device>	use umad Device \n");
 	fprintf(stderr, "-i <infiniband device>	use InfiniBand device \n");
 	fprintf(stderr, "-p <port_num>		use Port num \n");
+	fprintf(stderr, "-j <dev>:<port_num>	use the IB dev / port_num combination \n");
 	fprintf(stderr, "-R <rescan time>	perform complete Rescan every <rescan time> seconds\n");
 	fprintf(stderr, "-T <retry timeout>	Retries to connect to existing target after Timeout of <retry timeout> seconds\n");
 	fprintf(stderr, "-l <tl_retry timeout>	Transport retry count before failing IO. should be in range [2..7], (default 2)\n");
@@ -1623,7 +1624,7 @@ static int get_config(struct config_t *conf, int argc, char *argv[])
 	while (1) {
 		int c;
 
-		c = getopt(argc, argv, "caveod:i:p:t:r:R:T:l:Vhnf:");
+		c = getopt(argc, argv, "caveod:i:j:p:t:r:R:T:l:Vhnf:");
 		if (c == -1)
 			break;
 
@@ -1645,6 +1646,19 @@ static int get_config(struct config_t *conf, int argc, char *argv[])
 				return -1;
 			}
 			break;
+		case 'j': {
+			char dev[32];
+			int port_num;
+
+			if (sscanf(optarg, "%31[^:]:%d", dev, &port_num) != 2) {
+				pr_err("Bad dev:port specification %s\n",
+				       optarg);
+				return -1;
+			}
+			conf->dev_name = strdup(dev);
+			conf->port_num = port_num;
+			}
+			break;
 		case 'c':
 			++conf->cmd;
 			break;
-- 
2.12.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
