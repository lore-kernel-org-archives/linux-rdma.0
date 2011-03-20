From: Tamir Ronen <tamirr-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] OpenSM Ignore invalid command line option -t 0
Date: Sun, 20 Mar 2011 09:16:03 +0200
Message-ID: <4D85A9B3.3080601@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


>From acc805cdf65e12e2cee9bfbf360a176c55a5949f Mon Sep 17 00:00:00 2001
From: Tamir Ronen <tamirr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Date: Thu, 17 Mar 2011 15:21:43 +0200
Subject: [PATCH] Ignore command line option -t 0

If the timeout specified in the command line option -t equals zero,
Print an error message and ignore it.
---
 opensm/main.c |   14 ++++++++++----
 1 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/opensm/main.c b/opensm/main.c
index 756fe6f..9d489f2 100644
--- a/opensm/main.c
+++ b/opensm/main.c
@@ -249,7 +249,7 @@ static void show_usage(void)
 	printf("--timeout, -t <milliseconds>\n"
 	       "          This option specifies the time in milliseconds\n"
 	       "          used for transaction timeouts.\n"
-	       "          Specifying -t 0 disables timeouts.\n"
+	       "          Specifying -t 0 is invalid.\n"
 	       "          Without -t, OpenSM defaults to a timeout value of\n"
 	       "          200 milliseconds.\n\n");
 	printf("--retries <number>\n"
@@ -746,9 +746,15 @@ int main(int argc, char *argv[])
 			break;
 
 		case 't':
-			opt.transaction_timeout = strtoul(optarg, NULL, 0);
-			printf(" Transaction timeout = %u\n",
-			       opt.transaction_timeout);
+			val = strtoul(optarg, NULL, 0);
+			if(val == 0)
+				fprintf(stderr,
+					"ERROR: timeout value 0 is invalid. Ignoring it.\n");
+			else {
+				opt.transaction_timeout = val;
+				printf(" Transaction timeout = %u\n",
+					   opt.transaction_timeout);
+			}
 			break;
 
 		case 'n':
-- 
1.5.5.6

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
