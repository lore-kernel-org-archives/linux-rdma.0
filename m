From: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Subject: [RFC 3/8] IB/srp: allow sg_tablesize to be set for each target
Date: Tue, 18 Jan 2011 23:27:17 -0500
Message-ID: <1295411242-26148-4-git-send-email-dillowda@ornl.gov>
References: <1295411242-26148-1-git-send-email-dillowda@ornl.gov>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <1295411242-26148-1-git-send-email-dillowda-1Heg1YXhbW8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Different configurations of target software allow differing max sizes of
the command IU. Allowing this to be changed per-target allows all
targets on an initiator to get an optimal setting.

We deprecate srp_sg_tablesize and replace it with cmd_sg_entries in
preparation for allowing more indirect descriptors than can fit in the
IU.
---
topspin_workarounds could become a bool here as well as a cleanup

 drivers/infiniband/ulp/srp/ib_srp.c |   81 ++++++++++++++++++++++++----------
 drivers/infiniband/ulp/srp/ib_srp.h |    2 +
 2 files changed, 59 insertions(+), 24 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 060e6a8..6f8ee0c 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -59,14 +59,16 @@ MODULE_DESCRIPTION("InfiniBand SCSI RDMA Protocol initiator "
 		   "v" DRV_VERSION " (" DRV_RELDATE ")");
 MODULE_LICENSE("Dual BSD/GPL");
 
-static int srp_sg_tablesize = SRP_DEF_SG_TABLESIZE;
-static int srp_max_iu_len;
+static unsigned int srp_sg_tablesize;
+static unsigned int cmd_sg_entries;
+static int topspin_workarounds = 1;
 
-module_param(srp_sg_tablesize, int, 0444);
-MODULE_PARM_DESC(srp_sg_tablesize,
-		 "Max number of gather/scatter entries per I/O (default is 12, max 255)");
+module_param(srp_sg_tablesize, uint, 0444);
+MODULE_PARM_DESC(srp_sg_tablesize, "Deprecated name for cmd_sg_entries");
 
-static int topspin_workarounds = 1;
+module_param(cmd_sg_entries, uint, 0444);
+MODULE_PARM_DESC(cmd_sg_entries,
+		 "Default number of gather/scatter entries in the SRP command (default is 12, max 255)");
 
 module_param(topspin_workarounds, int, 0444);
 MODULE_PARM_DESC(topspin_workarounds,
@@ -364,7 +366,7 @@ static int srp_send_req(struct srp_target_port *target)
 
 	req->priv.opcode     	= SRP_LOGIN_REQ;
 	req->priv.tag        	= 0;
-	req->priv.req_it_iu_len = cpu_to_be32(srp_max_iu_len);
+	req->priv.req_it_iu_len = cpu_to_be32(target->max_iu_len);
 	req->priv.req_buf_fmt 	= cpu_to_be16(SRP_BUF_FORMAT_DIRECT |
 					      SRP_BUF_FORMAT_INDIRECT);
 	/*
@@ -1125,7 +1127,7 @@ static int srp_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *scmnd)
 	spin_unlock_irqrestore(&target->lock, flags);
 
 	dev = target->srp_host->srp_dev->dev;
-	ib_dma_sync_single_for_cpu(dev, iu->dma, srp_max_iu_len,
+	ib_dma_sync_single_for_cpu(dev, iu->dma, target->max_iu_len,
 				   DMA_TO_DEVICE);
 
 	scmnd->result        = 0;
@@ -1149,7 +1151,7 @@ static int srp_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *scmnd)
 		goto err_iu;
 	}
 
-	ib_dma_sync_single_for_device(dev, iu->dma, srp_max_iu_len,
+	ib_dma_sync_single_for_device(dev, iu->dma, target->max_iu_len,
 				      DMA_TO_DEVICE);
 
 	if (srp_post_send(target, iu, len)) {
@@ -1189,7 +1191,7 @@ static int srp_alloc_iu_bufs(struct srp_target_port *target)
 
 	for (i = 0; i < SRP_SQ_SIZE; ++i) {
 		target->tx_ring[i] = srp_alloc_iu(target->srp_host,
-						  srp_max_iu_len,
+						  target->max_iu_len,
 						  GFP_KERNEL, DMA_TO_DEVICE);
 		if (!target->tx_ring[i])
 			goto err;
@@ -1645,6 +1647,14 @@ static ssize_t show_local_ib_device(struct device *dev,
 	return sprintf(buf, "%s\n", target->srp_host->srp_dev->dev->name);
 }
 
+static ssize_t show_cmd_sg_entries(struct device *dev,
+				   struct device_attribute *attr, char *buf)
+{
+	struct srp_target_port *target = host_to_target(class_to_shost(dev));
+
+	return sprintf(buf, "%u\n", target->cmd_sg_cnt);
+}
+
 static DEVICE_ATTR(id_ext,	    S_IRUGO, show_id_ext,	   NULL);
 static DEVICE_ATTR(ioc_guid,	    S_IRUGO, show_ioc_guid,	   NULL);
 static DEVICE_ATTR(service_id,	    S_IRUGO, show_service_id,	   NULL);
@@ -1655,6 +1665,7 @@ static DEVICE_ATTR(req_lim,         S_IRUGO, show_req_lim,         NULL);
 static DEVICE_ATTR(zero_req_lim,    S_IRUGO, show_zero_req_lim,	   NULL);
 static DEVICE_ATTR(local_ib_port,   S_IRUGO, show_local_ib_port,   NULL);
 static DEVICE_ATTR(local_ib_device, S_IRUGO, show_local_ib_device, NULL);
+static DEVICE_ATTR(cmd_sg_entries,  S_IRUGO, show_cmd_sg_entries,  NULL);
 
 static struct device_attribute *srp_host_attrs[] = {
 	&dev_attr_id_ext,
@@ -1667,6 +1678,7 @@ static struct device_attribute *srp_host_attrs[] = {
 	&dev_attr_zero_req_lim,
 	&dev_attr_local_ib_port,
 	&dev_attr_local_ib_device,
+	&dev_attr_cmd_sg_entries,
 	NULL
 };
 
@@ -1679,6 +1691,7 @@ static struct scsi_host_template srp_template = {
 	.eh_abort_handler		= srp_abort,
 	.eh_device_reset_handler	= srp_reset_device,
 	.eh_host_reset_handler		= srp_reset_host,
+	.sg_tablesize			= SRP_DEF_SG_TABLESIZE,
 	.can_queue			= SRP_CMD_SQ_SIZE,
 	.this_id			= -1,
 	.cmd_per_lun			= SRP_CMD_SQ_SIZE,
@@ -1750,6 +1763,7 @@ enum {
 	SRP_OPT_MAX_CMD_PER_LUN	= 1 << 6,
 	SRP_OPT_IO_CLASS	= 1 << 7,
 	SRP_OPT_INITIATOR_EXT	= 1 << 8,
+	SRP_OPT_CMD_SG_ENTRIES	= 1 << 9,
 	SRP_OPT_ALL		= (SRP_OPT_ID_EXT	|
 				   SRP_OPT_IOC_GUID	|
 				   SRP_OPT_DGID		|
@@ -1767,6 +1781,7 @@ static const match_table_t srp_opt_tokens = {
 	{ SRP_OPT_MAX_CMD_PER_LUN,	"max_cmd_per_lun=%d" 	},
 	{ SRP_OPT_IO_CLASS,		"io_class=%x"		},
 	{ SRP_OPT_INITIATOR_EXT,	"initiator_ext=%s"	},
+	{ SRP_OPT_CMD_SG_ENTRIES,	"cmd_sg_entries=%u"	},
 	{ SRP_OPT_ERR,			NULL 			}
 };
 
@@ -1894,6 +1909,14 @@ static int srp_parse_options(const char *buf, struct srp_target_port *target)
 			kfree(p);
 			break;
 
+		case SRP_OPT_CMD_SG_ENTRIES:
+			if (match_int(args, &token) || token < 1 || token > 255) {
+				printk(KERN_WARNING PFX "bad max cmd_sg_entries parameter '%s'\n", p);
+				goto out;
+			}
+			target->cmd_sg_cnt = token;
+			break;
+
 		default:
 			printk(KERN_WARNING PFX "unknown parameter or missing value "
 			       "'%s' in target creation request\n", p);
@@ -1932,17 +1955,18 @@ static ssize_t srp_create_target(struct device *dev,
 	if (!target_host)
 		return -ENOMEM;
 
-	target_host->transportt = ib_srp_transport_template;
+	target_host->transportt  = ib_srp_transport_template;
 	target_host->max_lun     = SRP_MAX_LUN;
 	target_host->max_cmd_len = sizeof ((struct srp_cmd *) (void *) 0L)->cdb;
 
 	target = host_to_target(target_host);
 
-	target->io_class   = SRP_REV16A_IB_IO_CLASS;
-	target->scsi_host  = target_host;
-	target->srp_host   = host;
-	target->lkey	   = host->srp_dev->mr->lkey;
-	target->rkey	   = host->srp_dev->mr->rkey;
+	target->io_class	= SRP_REV16A_IB_IO_CLASS;
+	target->scsi_host	= target_host;
+	target->srp_host	= host;
+	target->lkey		= host->srp_dev->mr->lkey;
+	target->rkey		= host->srp_dev->mr->rkey;
+	target->cmd_sg_cnt	= cmd_sg_entries;
 
 	spin_lock_init(&target->lock);
 	INIT_LIST_HEAD(&target->free_tx);
@@ -1956,6 +1980,11 @@ static ssize_t srp_create_target(struct device *dev,
 	if (ret)
 		goto err;
 
+	target_host->sg_tablesize = target->cmd_sg_cnt;
+	target->max_iu_len = sizeof (struct srp_cmd) +
+			     sizeof (struct srp_indirect_buf) +
+			     target->cmd_sg_cnt * sizeof (struct srp_direct_buf);
+
 	ib_query_gid(host->srp_dev->dev, host->port, 0, &target->path.sgid);
 
 	shost_printk(KERN_DEBUG, target->scsi_host, PFX
@@ -2217,9 +2246,18 @@ static int __init srp_init_module(void)
 
 	BUILD_BUG_ON(FIELD_SIZEOF(struct ib_wc, wr_id) < sizeof(void *));
 
-	if (srp_sg_tablesize > 255) {
-		printk(KERN_WARNING PFX "Clamping srp_sg_tablesize to 255\n");
-		srp_sg_tablesize = 255;
+	if (srp_sg_tablesize) {
+		printk(KERN_WARNING PFX "srp_sg_tablesize is deprecated, please use cmd_sg_entries\n");
+		if (!cmd_sg_entries)
+			cmd_sg_entries = srp_sg_tablesize;
+	}
+
+	if (!cmd_sg_entries)
+		cmd_sg_entries = SRP_DEF_SG_TABLESIZE;
+
+	if (cmd_sg_entries > 255) {
+		printk(KERN_WARNING PFX "Clamping cmd_sg_entries to 255\n");
+		cmd_sg_entries = 255;
 	}
 
 	ib_srp_transport_template =
@@ -2227,11 +2265,6 @@ static int __init srp_init_module(void)
 	if (!ib_srp_transport_template)
 		return -ENOMEM;
 
-	srp_template.sg_tablesize = srp_sg_tablesize;
-	srp_max_iu_len = (sizeof (struct srp_cmd) +
-			  sizeof (struct srp_indirect_buf) +
-			  srp_sg_tablesize * 16);
-
 	ret = class_register(&srp_class);
 	if (ret) {
 		printk(KERN_ERR PFX "couldn't register class infiniband_srp\n");
diff --git a/drivers/infiniband/ulp/srp/ib_srp.h b/drivers/infiniband/ulp/srp/ib_srp.h
index 9dc6fc3..db39dbf 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.h
+++ b/drivers/infiniband/ulp/srp/ib_srp.h
@@ -130,6 +130,8 @@ struct srp_target_port {
 	u32			lkey;
 	u32			rkey;
 	enum srp_target_state	state;
+	unsigned int		max_iu_len;
+	unsigned int		cmd_sg_cnt;
 
 	/* Everything above this point is used in the hot path of
 	 * command processing. Try to keep them packed into cachelines.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
