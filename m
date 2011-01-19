From: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Subject: [RFC 5/8] IB/srp: add safety valve for large SG tables without HW
 support
Date: Tue, 18 Jan 2011 23:27:19 -0500
Message-ID: <1295411242-26148-6-git-send-email-dillowda@ornl.gov>
References: <1295411242-26148-1-git-send-email-dillowda@ornl.gov>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <1295411242-26148-1-git-send-email-dillowda-1Heg1YXhbW8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Most targets don't support indirect tables that do not fit in the
command, but FMR failures are exceedingly rare. Allow these targets to
reap the benefits of the large tables but fail in a manner that lets the
user know that the data didn't make it there.

This could/should be merged with the next patch, but broken out
separately for discussion. Not sure failing with HOST_BUSY is the right
thing to do -- what if there is a persistent FMR failure? panic() seems
a bit too strong, but there is no way to recover unless FMR starts working
again. Hence the danger in not having full target support for the spec.
---
 drivers/infiniband/ulp/srp/ib_srp.c |   33 +++++++++++++++++++++++++++++++++
 drivers/infiniband/ulp/srp/ib_srp.h |    1 +
 2 files changed, 34 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 9ce129a..df4c3b9 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -61,6 +61,7 @@ MODULE_LICENSE("Dual BSD/GPL");
 
 static unsigned int srp_sg_tablesize;
 static unsigned int cmd_sg_entries;
+static bool allow_ext_sg;
 static int topspin_workarounds = 1;
 
 module_param(srp_sg_tablesize, uint, 0444);
@@ -70,6 +71,10 @@ module_param(cmd_sg_entries, uint, 0444);
 MODULE_PARM_DESC(cmd_sg_entries,
 		 "Default number of gather/scatter entries in the SRP command (default is 12, max 255)");
 
+module_param(allow_ext_sg, bool, 0444);
+MODULE_PARM_DESC(allow_ext_sg,
+		  "Default behavior when there are more than cmd_sg_entries S/G entries after mapping; fails the request when false (default false)");
+
 module_param(topspin_workarounds, int, 0444);
 MODULE_PARM_DESC(topspin_workarounds,
 		 "Enable workarounds for Topspin/Cisco SRP target bugs if != 0");
@@ -885,6 +890,13 @@ backtrack:
 		goto map_complete;
 	}
 
+	if (unlikely(target->cmd_sg_cnt < state.ndesc &&
+						!target->allow_ext_sg)) {
+		shost_printk(KERN_ERR, target->scsi_host,
+			     "Could not fit S/G list into SRP_CMD\n");
+		return -EIO;
+	}
+
 	table_len = state.ndesc * sizeof (struct srp_direct_buf);
 
 	fmt = SRP_DATA_DESC_INDIRECT;
@@ -1759,6 +1771,14 @@ static ssize_t show_cmd_sg_entries(struct device *dev,
 	return sprintf(buf, "%u\n", target->cmd_sg_cnt);
 }
 
+static ssize_t show_allow_ext_sg(struct device *dev,
+				 struct device_attribute *attr, char *buf)
+{
+	struct srp_target_port *target = host_to_target(class_to_shost(dev));
+
+	return sprintf(buf, "%s\n", target->allow_ext_sg ? "true" : "false");
+}
+
 static DEVICE_ATTR(id_ext,	    S_IRUGO, show_id_ext,	   NULL);
 static DEVICE_ATTR(ioc_guid,	    S_IRUGO, show_ioc_guid,	   NULL);
 static DEVICE_ATTR(service_id,	    S_IRUGO, show_service_id,	   NULL);
@@ -1770,6 +1790,7 @@ static DEVICE_ATTR(zero_req_lim,    S_IRUGO, show_zero_req_lim,	   NULL);
 static DEVICE_ATTR(local_ib_port,   S_IRUGO, show_local_ib_port,   NULL);
 static DEVICE_ATTR(local_ib_device, S_IRUGO, show_local_ib_device, NULL);
 static DEVICE_ATTR(cmd_sg_entries,  S_IRUGO, show_cmd_sg_entries,  NULL);
+static DEVICE_ATTR(allow_ext_sg,    S_IRUGO, show_allow_ext_sg,    NULL);
 
 static struct device_attribute *srp_host_attrs[] = {
 	&dev_attr_id_ext,
@@ -1783,6 +1804,7 @@ static struct device_attribute *srp_host_attrs[] = {
 	&dev_attr_local_ib_port,
 	&dev_attr_local_ib_device,
 	&dev_attr_cmd_sg_entries,
+	&dev_attr_allow_ext_sg,
 	NULL
 };
 
@@ -1868,6 +1890,7 @@ enum {
 	SRP_OPT_IO_CLASS	= 1 << 7,
 	SRP_OPT_INITIATOR_EXT	= 1 << 8,
 	SRP_OPT_CMD_SG_ENTRIES	= 1 << 9,
+	SRP_OPT_ALLOW_EXT_SG	= 1 << 10,
 	SRP_OPT_ALL		= (SRP_OPT_ID_EXT	|
 				   SRP_OPT_IOC_GUID	|
 				   SRP_OPT_DGID		|
@@ -1886,6 +1909,7 @@ static const match_table_t srp_opt_tokens = {
 	{ SRP_OPT_IO_CLASS,		"io_class=%x"		},
 	{ SRP_OPT_INITIATOR_EXT,	"initiator_ext=%s"	},
 	{ SRP_OPT_CMD_SG_ENTRIES,	"cmd_sg_entries=%u"	},
+	{ SRP_OPT_ALLOW_EXT_SG,		"allow_ext_sg=%u"	},
 	{ SRP_OPT_ERR,			NULL 			}
 };
 
@@ -2021,6 +2045,14 @@ static int srp_parse_options(const char *buf, struct srp_target_port *target)
 			target->cmd_sg_cnt = token;
 			break;
 
+		case SRP_OPT_ALLOW_EXT_SG:
+			if (match_int(args, &token)) {
+				printk(KERN_WARNING PFX "bad allow_ext_sg parameter '%s'\n", p);
+				goto out;
+			}
+			target->allow_ext_sg = !!token;
+			break;
+
 		default:
 			printk(KERN_WARNING PFX "unknown parameter or missing value "
 			       "'%s' in target creation request\n", p);
@@ -2070,6 +2102,7 @@ static ssize_t srp_create_target(struct device *dev,
 	target->lkey		= host->srp_dev->mr->lkey;
 	target->rkey		= host->srp_dev->mr->rkey;
 	target->cmd_sg_cnt	= cmd_sg_entries;
+	target->allow_ext_sg	= allow_ext_sg;
 
 	ret = srp_parse_options(buf, target);
 	if (ret)
diff --git a/drivers/infiniband/ulp/srp/ib_srp.h b/drivers/infiniband/ulp/srp/ib_srp.h
index b43b5e7..dd7c9fe 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.h
+++ b/drivers/infiniband/ulp/srp/ib_srp.h
@@ -137,6 +137,7 @@ struct srp_target_port {
 	enum srp_target_state	state;
 	unsigned int		max_iu_len;
 	unsigned int		cmd_sg_cnt;
+	bool			allow_ext_sg;
 
 	/* Everything above this point is used in the hot path of
 	 * command processing. Try to keep them packed into cachelines.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
