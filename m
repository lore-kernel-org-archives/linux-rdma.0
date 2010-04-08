From: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH 4/4] opensm: add command line argument to dump PR file
Date: Thu, 08 Apr 2010 16:30:40 +0300
Message-ID: <4BBDDA80.9050808@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jim Schut <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Added command line argument to dump PathRecord
file and updated the man page.

Signed-off-by: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
---
 opensm/man/opensm.8.in |    8 +++++++-
 opensm/opensm/main.c   |    9 +++++++++
 2 files changed, 16 insertions(+), 1 deletions(-)

diff --git a/opensm/man/opensm.8.in b/opensm/man/opensm.8.in
index 7aca8f9..8d3ce97 100644
--- a/opensm/man/opensm.8.in
+++ b/opensm/man/opensm.8.in
@@ -1,4 +1,4 @@
-.TH OPENSM 8 "October 22, 2009" "OpenIB" "OpenIB Management"
+.TH OPENSM 8 "April 8, 2010" "OpenIB" "OpenIB Management"

 .SH NAME
 opensm \- InfiniBand subnet manager and administration (SM/SA)
@@ -28,6 +28,7 @@ opensm \- InfiniBand subnet manager and administration (SM/SA)
 [\-H | \-\-max_reverse_hops <max reverse hops allowed>]
 [\-X | \-\-guid_routing_order_file <path to file>]
 [\-m | \-\-ids_guid_file <path to file>]
+[\-\-dump_path_records]
 [\-o(nce)]
 [\-s(weep) <interval>]
 [\-t(imeout) <milliseconds>]
@@ -218,6 +219,11 @@ Set the order port guids will be routed for the MinHop
 and Up/Down routing algorithms to the guids provided in the
 given file (one to a line).
 .TP
+\fB\-\-dump_path_records\fR
+This option causes OpenSM to dump Path Records file.
+This file can be used by applications such as MPI to
+eliminate the need to query SA.
+.TP
 \fB\-o\fR, \fB\-\-once\fR
 This option causes OpenSM to configure the subnet
 once, then exit.  Ports remain in the ACTIVE state.
diff --git a/opensm/opensm/main.c b/opensm/opensm/main.c
index f9a33af..9d5c886 100644
--- a/opensm/opensm/main.c
+++ b/opensm/opensm/main.c
@@ -231,6 +231,10 @@ static void show_usage(void)
 	       "          Set the order port guids will be routed for the MinHop\n"
 	       "          and Up/Down routing algorithms to the guids provided in the\n"
 	       "          given file (one to a line)\n\n");
+	printf("--dump_path_records\n"
+	       "          This option causes OpenSM to dump Path Records file.\n"
+	       "          This file can be used by applications such as MPI to\n"
+	       "          eliminate the need to query SA.\n\n");
 	printf("--once, -o\n"
 	       "          This option causes OpenSM to configure the subnet\n"
 	       "          once, then exit.  Ports remain in the ACTIVE state.\n\n");
@@ -610,6 +614,7 @@ int main(int argc, char *argv[])
 		{"sm_sl", 1, NULL, 7},
 		{"retries", 1, NULL, 8},
 		{"log_prefix", 1, NULL, 9},
+		{"dump_path_records", 0, NULL, 10},
 		{NULL, 0, NULL, 0}	/* Required at the end of the array */
 	};

@@ -992,6 +997,10 @@ int main(int argc, char *argv[])
 			SET_STR_OPT(opt.log_prefix, optarg);
 			printf("Log prefix = %s\n", opt.log_prefix);
 			break;
+		case 10:
+			opt.path_rec_dump = TRUE;
+			printf(" Dumping Path Records file\n");
+			break;
 		case 'h':
 		case '?':
 		case ':':
-- 
1.5.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
