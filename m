From: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Subject: [RFC 6/8] IB/srp: add support for indirect tables that don't fit in
 SRP_CMD
Date: Tue, 18 Jan 2011 23:27:20 -0500
Message-ID: <1295411242-26148-7-git-send-email-dillowda@ornl.gov>
References: <1295411242-26148-1-git-send-email-dillowda@ornl.gov>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <1295411242-26148-1-git-send-email-dillowda-1Heg1YXhbW8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This allows us to guarantee the ability to submit up to 8 MB requests
based on the current value of SCSI_MAX_SG_CHAIN_SEGMENTS. While FMR will
usually condense the requests into 8 SG entries, it is imperative that
the target support external tables in case the FMR mapping fails or is
not supported.

If indirect_sg_entries is not specified in the modules options, then
the sg_tablesize for the target will default to cmd_sg_entries unless
overridden by the target options.
---
 drivers/infiniband/ulp/srp/ib_srp.c |   84 ++++++++++++++++++++++++++++++-----
 drivers/infiniband/ulp/srp/ib_srp.h |    4 ++
 2 files changed, 76 insertions(+), 12 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index df4c3b9..0121530 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -61,6 +61,7 @@ MODULE_LICENSE("Dual BSD/GPL");
 
 static unsigned int srp_sg_tablesize;
 static unsigned int cmd_sg_entries;
+static unsigned int indirect_sg_entries;
 static bool allow_ext_sg;
 static int topspin_workarounds = 1;
 
@@ -71,6 +72,10 @@ module_param(cmd_sg_entries, uint, 0444);
 MODULE_PARM_DESC(cmd_sg_entries,
 		 "Default number of gather/scatter entries in the SRP command (default is 12, max 255)");
 
+module_param(indirect_sg_entries, uint, 0444);
+MODULE_PARM_DESC(indirect_sg_entries,
+		 "Default max number of gather/scatter entries (default is 12, max is " __stringify(SCSI_MAX_SG_CHAIN_SEGMENTS) ")");
+
 module_param(allow_ext_sg, bool, 0444);
 MODULE_PARM_DESC(allow_ext_sg,
 		  "Default behavior when there are more than cmd_sg_entries S/G entries after mapping; fails the request when false (default false)");
@@ -451,12 +456,19 @@ static bool srp_change_state(struct srp_target_port *target,
 
 static void srp_free_req_data(struct srp_target_port *target)
 {
+	struct ib_device *ibdev = target->srp_host->srp_dev->dev;
 	struct srp_request *req;
 	int i;
 
 	for (i = 0, req = target->req_ring; i < SRP_CMD_SQ_SIZE; ++i, ++req) {
 		kfree(req->fmr_list);
 		kfree(req->map_page);
+		if (req->indirect_dma_addr) {
+			ib_dma_unmap_single(ibdev, req->indirect_dma_addr,
+					    target->indirect_size,
+					    DMA_TO_DEVICE);
+		}
+		kfree(req->indirect_desc);
 	}
 }
 
@@ -795,7 +807,6 @@ static int srp_map_data(struct scsi_cmnd *scmnd, struct srp_target_port *target,
 	struct ib_device *ibdev;
 	struct srp_map_state state;
 	struct srp_indirect_buf *indirect_hdr;
-	dma_addr_t indirect_addr;
 	u32 table_len;
 	u8 fmt;
 
@@ -846,8 +857,11 @@ static int srp_map_data(struct scsi_cmnd *scmnd, struct srp_target_port *target,
 	 */
 	indirect_hdr = (void *) cmd->add_data;
 
+	ib_dma_sync_single_for_cpu(ibdev, req->indirect_dma_addr,
+				   target->indirect_size, DMA_TO_DEVICE);
+
 	memset(&state, 0, sizeof(state));
-	state.desc	= indirect_hdr->desc_list;
+	state.desc	= req->indirect_desc;
 	state.pages	= req->map_page;
 	state.next_fmr	= req->fmr_list;
 
@@ -877,7 +891,11 @@ backtrack:
 	if (use_fmr == SRP_MAP_ALLOW_FMR && srp_map_finish_fmr(&state, target))
 		goto backtrack;
 
-	/* We've mapped the request, fill in the command buffer.
+	/* We've mapped the request, now pull as much of the indirect
+	 * descriptor table as we can into the command buffer. If this
+	 * target is not using an external indirect table, we are
+	 * guaranteed to fit into the command, as the SCSI layer won't
+	 * give us more S/G entries than we allow.
 	 */
 	req->nfmr = state.nfmr;
 	if (state.ndesc == 1) {
@@ -886,7 +904,7 @@ backtrack:
 		 */
 		struct srp_direct_buf *buf = (void *) cmd->add_data;
 
-		*buf = indirect_hdr->desc_list[0];
+		*buf = req->indirect_desc[0];
 		goto map_complete;
 	}
 
@@ -897,23 +915,28 @@ backtrack:
 		return -EIO;
 	}
 
+	count = min(state.ndesc, target->cmd_sg_cnt);
 	table_len = state.ndesc * sizeof (struct srp_direct_buf);
 
 	fmt = SRP_DATA_DESC_INDIRECT;
 	len = sizeof(struct srp_cmd) + sizeof (struct srp_indirect_buf);
-	len += table_len;
+	len += count * sizeof (struct srp_direct_buf);
 
-	indirect_addr = req->cmd->dma + sizeof *cmd + sizeof *indirect_hdr;
+	memcpy(indirect_hdr->desc_list, req->indirect_desc,
+	       count * sizeof (struct srp_direct_buf));
 
-	indirect_hdr->table_desc.va = cpu_to_be64(indirect_addr);
+	indirect_hdr->table_desc.va = cpu_to_be64(req->indirect_dma_addr);
 	indirect_hdr->table_desc.key = cpu_to_be32(target->rkey);
 	indirect_hdr->table_desc.len = cpu_to_be32(table_len);
 	indirect_hdr->len = cpu_to_be32(state.total_len);
 
 	if (scmnd->sc_data_direction == DMA_TO_DEVICE)
-		cmd->data_out_desc_cnt = state.ndesc;
+		cmd->data_out_desc_cnt = count;
 	else
-		cmd->data_in_desc_cnt = state.ndesc;
+		cmd->data_in_desc_cnt = count;
+
+	ib_dma_sync_single_for_device(ibdev, req->indirect_dma_addr, table_len,
+				      DMA_TO_DEVICE);
 
 map_complete:
 	if (scmnd->sc_data_direction == DMA_TO_DEVICE)
@@ -1891,6 +1914,7 @@ enum {
 	SRP_OPT_INITIATOR_EXT	= 1 << 8,
 	SRP_OPT_CMD_SG_ENTRIES	= 1 << 9,
 	SRP_OPT_ALLOW_EXT_SG	= 1 << 10,
+	SRP_OPT_SG_TABLESIZE	= 1 << 11,
 	SRP_OPT_ALL		= (SRP_OPT_ID_EXT	|
 				   SRP_OPT_IOC_GUID	|
 				   SRP_OPT_DGID		|
@@ -1910,6 +1934,7 @@ static const match_table_t srp_opt_tokens = {
 	{ SRP_OPT_INITIATOR_EXT,	"initiator_ext=%s"	},
 	{ SRP_OPT_CMD_SG_ENTRIES,	"cmd_sg_entries=%u"	},
 	{ SRP_OPT_ALLOW_EXT_SG,		"allow_ext_sg=%u"	},
+	{ SRP_OPT_SG_TABLESIZE,		"sg_tablesize=%u" 	},
 	{ SRP_OPT_ERR,			NULL 			}
 };
 
@@ -2053,6 +2078,15 @@ static int srp_parse_options(const char *buf, struct srp_target_port *target)
 			target->allow_ext_sg = !!token;
 			break;
 
+		case SRP_OPT_SG_TABLESIZE:
+			if (match_int(args, &token) || token < 1 ||
+					token > SCSI_MAX_SG_CHAIN_SEGMENTS) {
+				printk(KERN_WARNING PFX "bad max sg_tablesize parameter '%s'\n", p);
+				goto out;
+			}
+			target->sg_tablesize = token;
+			break;
+
 		default:
 			printk(KERN_WARNING PFX "unknown parameter or missing value "
 			       "'%s' in target creation request\n", p);
@@ -2083,6 +2117,8 @@ static ssize_t srp_create_target(struct device *dev,
 		container_of(dev, struct srp_host, dev);
 	struct Scsi_Host *target_host;
 	struct srp_target_port *target;
+	struct ib_device *ibdev = host->srp_dev->dev;
+	dma_addr_t dma_addr;
 	int i, ret;
 
 	target_host = scsi_host_alloc(&srp_template,
@@ -2102,13 +2138,22 @@ static ssize_t srp_create_target(struct device *dev,
 	target->lkey		= host->srp_dev->mr->lkey;
 	target->rkey		= host->srp_dev->mr->rkey;
 	target->cmd_sg_cnt	= cmd_sg_entries;
+	target->sg_tablesize	= indirect_sg_entries ? : cmd_sg_entries;
 	target->allow_ext_sg	= allow_ext_sg;
 
 	ret = srp_parse_options(buf, target);
 	if (ret)
 		goto err;
 
-	target_host->sg_tablesize = target->cmd_sg_cnt;
+	if (!host->srp_dev->fmr_pool && !target->allow_ext_sg &&
+				target->cmd_sg_cnt < target->sg_tablesize) {
+		printk(KERN_WARNING PFX "No FMR pool and no external indirect descriptors, limiting sg_tablesize to cmd_sg_cnt\n");
+		target->sg_tablesize = target->cmd_sg_cnt;
+	}
+
+	target_host->sg_tablesize = target->sg_tablesize;
+	target->indirect_size = target->sg_tablesize *
+				sizeof (struct srp_direct_buf);
 	target->max_iu_len = sizeof (struct srp_cmd) +
 			     sizeof (struct srp_indirect_buf) +
 			     target->cmd_sg_cnt * sizeof (struct srp_direct_buf);
@@ -2123,14 +2168,22 @@ static ssize_t srp_create_target(struct device *dev,
 					GFP_KERNEL);
 		req->map_page = kmalloc(SRP_FMR_SIZE * sizeof (void *),
 					GFP_KERNEL);
-		if (!req->fmr_list || !req->map_page)
+		req->indirect_desc = kmalloc(target->indirect_size, GFP_KERNEL);
+		if (!req->fmr_list || !req->map_page || !req->indirect_desc)
 			goto err_free_mem;
 
+		dma_addr = ib_dma_map_single(ibdev, req->indirect_desc,
+					     target->indirect_size,
+					     DMA_TO_DEVICE);
+		if (ib_dma_mapping_error(ibdev, dma_addr))
+			goto err_free_mem;
+
+		req->indirect_dma_addr = dma_addr;
 		req->index = i;
 		list_add_tail(&req->list, &target->free_reqs);
 	}
 
-	ib_query_gid(host->srp_dev->dev, host->port, 0, &target->path.sgid);
+	ib_query_gid(ibdev, host->port, 0, &target->path.sgid);
 
 	shost_printk(KERN_DEBUG, target->scsi_host, PFX
 		     "new target: id_ext %016llx ioc_guid %016llx pkey %04x "
@@ -2410,6 +2463,13 @@ static int __init srp_init_module(void)
 		cmd_sg_entries = 255;
 	}
 
+	if (!indirect_sg_entries)
+		indirect_sg_entries = cmd_sg_entries;
+	else if (indirect_sg_entries < cmd_sg_entries) {
+		printk(KERN_WARNING PFX "Bumping up indirect_sg_entries to match cmd_sg_entries (%u)\n", cmd_sg_entries);
+		indirect_sg_entries = cmd_sg_entries;
+	}
+
 	ib_srp_transport_template =
 		srp_attach_transport(&ib_srp_transport_functions);
 	if (!ib_srp_transport_template)
diff --git a/drivers/infiniband/ulp/srp/ib_srp.h b/drivers/infiniband/ulp/srp/ib_srp.h
index dd7c9fe..cf69621 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.h
+++ b/drivers/infiniband/ulp/srp/ib_srp.h
@@ -117,6 +117,8 @@ struct srp_request {
 	struct srp_iu	       *cmd;
 	struct ib_pool_fmr    **fmr_list;
 	u64		       *map_page;
+	struct srp_direct_buf  *indirect_desc;
+	dma_addr_t		indirect_dma_addr;
 	short			nfmr;
 	short			index;
 };
@@ -137,6 +139,7 @@ struct srp_target_port {
 	enum srp_target_state	state;
 	unsigned int		max_iu_len;
 	unsigned int		cmd_sg_cnt;
+	unsigned int		indirect_size;
 	bool			allow_ext_sg;
 
 	/* Everything above this point is used in the hot path of
@@ -152,6 +155,7 @@ struct srp_target_port {
 	struct Scsi_Host       *scsi_host;
 	char			target_name[32];
 	unsigned int		scsi_id;
+	unsigned int		sg_tablesize;
 
 	struct ib_sa_path_rec	path;
 	__be16			orig_dgid[8];
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
