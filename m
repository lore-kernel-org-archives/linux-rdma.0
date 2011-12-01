From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: [PATCH 01/14] ib_srp: Introduce pr_fmt()
Date: Thu, 1 Dec 2011 19:55:47 +0100
Message-ID: <201112011955.47198.bvanassche@acm.org>
References: <201112011954.25811.bvanassche@acm.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201112011954.25811.bvanassche-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Make the logging code more a little more brief by replacing
printk(KERN_WARNING PFX ...) by pr_warn(...) and by replacing
printk(KERN_ERR PFX ...) by pr_err(...). Remove one trailing
space to avoid a checkpatch warning.

Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c |   40 ++++++++++++++++++----------------
 1 files changed, 21 insertions(+), 19 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 0bfa545..5093cc6 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -30,6 +30,8 @@
  * SOFTWARE.
  */
 
+#define pr_fmt(fmt) PFX fmt
+
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/slab.h>
@@ -165,7 +167,7 @@ static void srp_free_iu(struct srp_host *host, struct srp_iu *iu)
 
 static void srp_qp_event(struct ib_event *event, void *context)
 {
-	printk(KERN_ERR PFX "QP event %d\n", event->event);
+	pr_err("QP event %d\n", event->event);
 }
 
 static int srp_init_qp(struct srp_target_port *target,
@@ -1989,7 +1991,7 @@ static int srp_parse_options(const char *buf, struct srp_target_port *target)
 				goto out;
 			}
 			if (strlen(p) != 32) {
-				printk(KERN_WARNING PFX "bad dest GID parameter '%s'\n", p);
+				pr_warn("bad dest GID parameter '%s'\n", p);
 				kfree(p);
 				goto out;
 			}
@@ -2004,7 +2006,7 @@ static int srp_parse_options(const char *buf, struct srp_target_port *target)
 
 		case SRP_OPT_PKEY:
 			if (match_hex(args, &token)) {
-				printk(KERN_WARNING PFX "bad P_Key parameter '%s'\n", p);
+				pr_warn("bad P_Key parameter '%s'\n", p);
 				goto out;
 			}
 			target->path.pkey = cpu_to_be16(token);
@@ -2023,7 +2025,7 @@ static int srp_parse_options(const char *buf, struct srp_target_port *target)
 
 		case SRP_OPT_MAX_SECT:
 			if (match_int(args, &token)) {
-				printk(KERN_WARNING PFX "bad max sect parameter '%s'\n", p);
+				pr_warn("bad max sect parameter '%s'\n", p);
 				goto out;
 			}
 			target->scsi_host->max_sectors = token;
@@ -2031,7 +2033,7 @@ static int srp_parse_options(const char *buf, struct srp_target_port *target)
 
 		case SRP_OPT_MAX_CMD_PER_LUN:
 			if (match_int(args, &token)) {
-				printk(KERN_WARNING PFX "bad max cmd_per_lun parameter '%s'\n", p);
+				pr_warn("bad max cmd_per_lun parameter '%s'\n", p);
 				goto out;
 			}
 			target->scsi_host->cmd_per_lun = min(token, SRP_CMD_SQ_SIZE);
@@ -2039,12 +2041,12 @@ static int srp_parse_options(const char *buf, struct srp_target_port *target)
 
 		case SRP_OPT_IO_CLASS:
 			if (match_hex(args, &token)) {
-				printk(KERN_WARNING PFX "bad  IO class parameter '%s' \n", p);
+				pr_warn("bad  IO class parameter '%s'\n", p);
 				goto out;
 			}
 			if (token != SRP_REV10_IB_IO_CLASS &&
 			    token != SRP_REV16A_IB_IO_CLASS) {
-				printk(KERN_WARNING PFX "unknown IO class parameter value"
+				pr_warn("unknown IO class parameter value"
 				       " %x specified (use %x or %x).\n",
 				       token, SRP_REV10_IB_IO_CLASS, SRP_REV16A_IB_IO_CLASS);
 				goto out;
@@ -2064,7 +2066,7 @@ static int srp_parse_options(const char *buf, struct srp_target_port *target)
 
 		case SRP_OPT_CMD_SG_ENTRIES:
 			if (match_int(args, &token) || token < 1 || token > 255) {
-				printk(KERN_WARNING PFX "bad max cmd_sg_entries parameter '%s'\n", p);
+				pr_warn("bad max cmd_sg_entries parameter '%s'\n", p);
 				goto out;
 			}
 			target->cmd_sg_cnt = token;
@@ -2072,7 +2074,7 @@ static int srp_parse_options(const char *buf, struct srp_target_port *target)
 
 		case SRP_OPT_ALLOW_EXT_SG:
 			if (match_int(args, &token)) {
-				printk(KERN_WARNING PFX "bad allow_ext_sg parameter '%s'\n", p);
+				pr_warn("bad allow_ext_sg parameter '%s'\n", p);
 				goto out;
 			}
 			target->allow_ext_sg = !!token;
@@ -2081,14 +2083,14 @@ static int srp_parse_options(const char *buf, struct srp_target_port *target)
 		case SRP_OPT_SG_TABLESIZE:
 			if (match_int(args, &token) || token < 1 ||
 					token > SCSI_MAX_SG_CHAIN_SEGMENTS) {
-				printk(KERN_WARNING PFX "bad max sg_tablesize parameter '%s'\n", p);
+				pr_warn("bad max sg_tablesize parameter '%s'\n", p);
 				goto out;
 			}
 			target->sg_tablesize = token;
 			break;
 
 		default:
-			printk(KERN_WARNING PFX "unknown parameter or missing value "
+			pr_warn("unknown parameter or missing value "
 			       "'%s' in target creation request\n", p);
 			goto out;
 		}
@@ -2100,7 +2102,7 @@ static int srp_parse_options(const char *buf, struct srp_target_port *target)
 		for (i = 0; i < ARRAY_SIZE(srp_opt_tokens); ++i)
 			if ((srp_opt_tokens[i].token & SRP_OPT_ALL) &&
 			    !(srp_opt_tokens[i].token & opt_mask))
-				printk(KERN_WARNING PFX "target creation request is "
+				pr_warn("target creation request is "
 				       "missing parameter '%s'\n",
 				       srp_opt_tokens[i].pattern);
 
@@ -2149,7 +2151,7 @@ static ssize_t srp_create_target(struct device *dev,
 
 	if (!host->srp_dev->fmr_pool && !target->allow_ext_sg &&
 				target->cmd_sg_cnt < target->sg_tablesize) {
-		printk(KERN_WARNING PFX "No FMR pool and no external indirect descriptors, limiting sg_tablesize to cmd_sg_cnt\n");
+		pr_warn("No FMR pool and no external indirect descriptors, limiting sg_tablesize to cmd_sg_cnt\n");
 		target->sg_tablesize = target->cmd_sg_cnt;
 	}
 
@@ -2309,7 +2311,7 @@ static void srp_add_one(struct ib_device *device)
 		return;
 
 	if (ib_query_device(device, dev_attr)) {
-		printk(KERN_WARNING PFX "Query device failed for %s\n",
+		pr_warn("Query device failed for %s\n",
 		       device->name);
 		goto free_attr;
 	}
@@ -2459,7 +2461,7 @@ static int __init srp_init_module(void)
 	BUILD_BUG_ON(FIELD_SIZEOF(struct ib_wc, wr_id) < sizeof(void *));
 
 	if (srp_sg_tablesize) {
-		printk(KERN_WARNING PFX "srp_sg_tablesize is deprecated, please use cmd_sg_entries\n");
+		pr_warn("srp_sg_tablesize is deprecated, please use cmd_sg_entries\n");
 		if (!cmd_sg_entries)
 			cmd_sg_entries = srp_sg_tablesize;
 	}
@@ -2468,14 +2470,14 @@ static int __init srp_init_module(void)
 		cmd_sg_entries = SRP_DEF_SG_TABLESIZE;
 
 	if (cmd_sg_entries > 255) {
-		printk(KERN_WARNING PFX "Clamping cmd_sg_entries to 255\n");
+		pr_warn("Clamping cmd_sg_entries to 255\n");
 		cmd_sg_entries = 255;
 	}
 
 	if (!indirect_sg_entries)
 		indirect_sg_entries = cmd_sg_entries;
 	else if (indirect_sg_entries < cmd_sg_entries) {
-		printk(KERN_WARNING PFX "Bumping up indirect_sg_entries to match cmd_sg_entries (%u)\n", cmd_sg_entries);
+		pr_warn("Bumping up indirect_sg_entries to match cmd_sg_entries (%u)\n", cmd_sg_entries);
 		indirect_sg_entries = cmd_sg_entries;
 	}
 
@@ -2486,7 +2488,7 @@ static int __init srp_init_module(void)
 
 	ret = class_register(&srp_class);
 	if (ret) {
-		printk(KERN_ERR PFX "couldn't register class infiniband_srp\n");
+		pr_err("couldn't register class infiniband_srp\n");
 		srp_release_transport(ib_srp_transport_template);
 		return ret;
 	}
@@ -2495,7 +2497,7 @@ static int __init srp_init_module(void)
 
 	ret = ib_register_client(&srp_client);
 	if (ret) {
-		printk(KERN_ERR PFX "couldn't register IB client\n");
+		pr_err("couldn't register IB client\n");
 		srp_release_transport(ib_srp_transport_template);
 		ib_sa_unregister_client(&srp_sa_client);
 		class_unregister(&srp_class);
-- 
1.7.3.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
