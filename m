From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] infiniband-diags/ibqueryerrors: simplify
 node_type_to_print setup.
Date: Tue, 29 Sep 2009 17:49:58 +0200
Message-ID: <20090929154958.GC9465@me>
References: <20090923150923.a5281107.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20090923150923.a5281107.weiny2-i2BcT+NCU+M@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: OpenFabrics <general-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Siplify node_type_to_print setup.

Signed-off-by: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
---
 infiniband-diags/src/ibqueryerrors.c |   13 +++++--------
 1 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/infiniband-diags/src/ibqueryerrors.c b/infiniband-diags/src/ibqueryerrors.c
index 8a3c236..e67d338 100644
--- a/infiniband-diags/src/ibqueryerrors.c
+++ b/infiniband-diags/src/ibqueryerrors.c
@@ -64,12 +64,12 @@ char *node_guid_str = NULL;
 int sup_total = 0;
 enum MAD_FIELDS *suppressed_fields = NULL;
 char *dr_path = NULL;
+uint8_t node_type_to_print = 0;
 
-#define PRINT_ALL 0xFF /* all nodes default flag */
-uint8_t node_type_to_print = PRINT_ALL;
 #define PRINT_SWITCH 0x1
 #define PRINT_CA     0x2
 #define PRINT_ROUTER 0x4
+#define PRINT_ALL 0xFF /* all nodes default flag */
 
 static unsigned int get_max(unsigned int num)
 {
@@ -379,18 +379,12 @@ static int process_opt(void *context, int ch, char *optarg)
 		data_counters++;
 		break;
 	case 3:
-		if (node_type_to_print == PRINT_ALL)
-			node_type_to_print = 0;
 		node_type_to_print |= PRINT_SWITCH;
 		break;
 	case 4:
-		if (node_type_to_print == PRINT_ALL)
-			node_type_to_print = 0;
 		node_type_to_print |= PRINT_CA;
 		break;
 	case 5:
-		if (node_type_to_print == PRINT_ALL)
-			node_type_to_print = 0;
 		node_type_to_print |= PRINT_ROUTER;
 		break;
 	case 'G':
@@ -453,6 +447,9 @@ int main(int argc, char **argv)
 	argc -= optind;
 	argv += optind;
 
+	if (!node_type_to_print)
+		node_type_to_print = PRINT_ALL;
+
 	if (ibverbose)
 		ibnd_debug(1);
 
-- 
1.6.5.rc1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
