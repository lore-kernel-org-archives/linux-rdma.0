From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH 3/5] opensm: Add command line option for allow_both_pkeys
Date: Tue, 22 Nov 2011 15:23:45 -0500
Message-ID: <4ECC04D1.4060702@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 man/opensm.8.in |    6 ++++++
 opensm/main.c   |   11 ++++++++++-
 2 files changed, 16 insertions(+), 1 deletions(-)

diff --git a/man/opensm.8.in b/man/opensm.8.in
index 864ccee..45b1ee0 100644
--- a/man/opensm.8.in
+++ b/man/opensm.8.in
@@ -42,6 +42,7 @@ opensm \- InfiniBand subnet manager and administration (SM/SA)
 [\-L | \-\-log_limit <size in MB>] [\-e(rase_log_file)]
 [\-P(config) <partition config file> ]
 [\-N | \-\-no_part_enforce]
+[\-W | \-\-allow_both_pkeys]
 [\-Q | \-\-qos [\-Y | \-\-qos_policy_file <file name>]]
 [\-y | \-\-stay_on_fatal]
 [\-B | \-\-daemon]
@@ -331,6 +332,11 @@ configuring QoS policy via this file.
 \fB\-N\fR, \fB\-\-no_part_enforce\fR
 This option disables partition enforcement on switch external ports.
 .TP
+\fB\-W\fR, \fB\-\-allow_both_pkeys\fR
+This option indicates whether both full and limited membership on the
+same partition can be configured in the PKeyTable. Default is not
+to allow both pkeys.
+.TP
 \fB\-y\fR, \fB\-\-stay_on_fatal\fR
 This option will cause SM not to exit on fatal initialization
 issues: if SM discovers duplicated guids or a 12x link with
diff --git a/opensm/main.c b/opensm/main.c
index 5be36b6..f1cdaef 100644
--- a/opensm/main.c
+++ b/opensm/main.c
@@ -308,6 +308,10 @@ static void show_usage(void)
 	       OSM_DEFAULT_PARTITION_CONFIG_FILE "\'.\n\n");
 	printf("--no_part_enforce, -N\n"
 	       "          This option disables partition enforcement on switch external ports.\n\n");
+	printf("--allow_both_pkeys, -W\n"
+	       "          This option indicates whether both full and limited membership\n"
+	       "          on the same partition can be configured in the PKeyTable.\n"
+	       "          Default is not to allow both pkeys.\n\n");
 	printf("--qos, -Q\n" "          This option enables QoS setup.\n\n");
 	printf("--qos_policy_file, -Y <QoS-policy-file>\n"
 	       "          This option defines the optional QoS policy file.\n"
@@ -554,7 +558,7 @@ int main(int argc, char *argv[])
 	char *conf_template = NULL, *config_file = NULL;
 	uint32_t val;
 	const char *const short_option =
-	    "F:c:i:w:O:f:ed:D:g:l:L:s:t:a:u:m:X:R:zM:U:S:P:Y:ANBIQvVhoryxp:n:q:k:C:G:H:";
+	    "F:c:i:w:O:f:ed:D:g:l:L:s:t:a:u:m:X:R:zM:U:S:P:Y:ANWBIQvVhoryxp:n:q:k:C:G:H:";
 
 	/*
 	   In the array below, the 2nd parameter specifies the number
@@ -582,6 +586,7 @@ int main(int argc, char *argv[])
 		{"erase_log_file", 0, NULL, 'e'},
 		{"Pconfig", 1, NULL, 'P'},
 		{"no_part_enforce", 0, NULL, 'N'},
+		{"allow_both_pkeys", 0, NULL, 'W'},
 		{"qos", 0, NULL, 'Q'},
 		{"qos_policy_file", 1, NULL, 'Y'},
 		{"maxsmps", 1, NULL, 'n'},
@@ -855,6 +860,10 @@ int main(int argc, char *argv[])
 			opt.no_partition_enforcement = TRUE;
 			break;
 
+		case 'W':
+			opt.allow_both_pkeys = TRUE;
+			break;
+
 		case 'Q':
 			opt.qos = TRUE;
 			break;
-- 
1.7.6.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
