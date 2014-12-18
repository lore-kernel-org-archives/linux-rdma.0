From: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 03/14] RDMA/ocrdma: Move PD resource management to driver.
Date: Thu, 18 Dec 2014 14:12:57 +0530
Message-ID: <71b2fb29-aa60-4b5b-aa80-d41938e93bb7@CMEXHTCAS1.ad.emulex.com>
References: <1418892188-6623-1-git-send-email-devesh.sharma@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1418892188-6623-1-git-send-email-devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Mitesh Ahuja <mitesh.ahuja-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Selvin Xavier <selvin.xavier-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mitesh Ahuja <mitesh.ahuja-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>

Move PD allocation and deallocation from firmware to driver.
At driver load time all the PDs will be requested from firmware and
their management will be handled by driver to reduce mailbox commands
overhead at runtime.

Signed-off-by: Mitesh Ahuja <mitesh.ahuja-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Selvin Xavier <selvin.xavier-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/ocrdma/ocrdma.h       |   17 ++++
 drivers/infiniband/hw/ocrdma/ocrdma_hw.c    |  121 +++++++++++++++++++++++++++
 drivers/infiniband/hw/ocrdma/ocrdma_hw.h    |    2 +
 drivers/infiniband/hw/ocrdma/ocrdma_main.c  |    2 +
 drivers/infiniband/hw/ocrdma/ocrdma_sli.h   |   33 +++++++
 drivers/infiniband/hw/ocrdma/ocrdma_stats.c |   12 +++
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c |  114 +++++++++++++++++++++++++-
 7 files changed, 299 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma.h b/drivers/infiniband/hw/ocrdma/ocrdma.h
index b43456a..013cc7e 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma.h
+++ b/drivers/infiniband/hw/ocrdma/ocrdma.h
@@ -61,6 +61,7 @@ struct ocrdma_dev_attr {
 	u32 vendor_id;
 	u32 device_id;
 	u16 max_pd;
+	u16 max_dpp_pds;
 	u16 max_cq;
 	u16 max_cqe;
 	u16 max_qp;
@@ -171,6 +172,21 @@ struct ocrdma_stats {
 	struct ocrdma_dev *dev;
 };
 
+struct ocrdma_pd_resource_mgr {
+	u32 pd_norm_start;
+	u16 pd_norm_count;
+	u16 pd_norm_thrsh;
+	u16 max_normal_pd;
+	u32 pd_dpp_start;
+	u16 pd_dpp_count;
+	u16 pd_dpp_thrsh;
+	u16 max_dpp_pd;
+	u16 dpp_page_index;
+	unsigned long *pd_norm_bitmap;
+	unsigned long *pd_dpp_bitmap;
+	bool pd_prealloc_valid;
+};
+
 struct stats_mem {
 	struct ocrdma_mqe mqe;
 	void *va;
@@ -256,6 +272,7 @@ struct ocrdma_dev {
 	struct ocrdma_stats tx_dbg_stats;
 	struct ocrdma_stats rx_dbg_stats;
 	struct dentry *dir;
+	struct ocrdma_pd_resource_mgr *pd_mgr;
 };
 
 struct ocrdma_cq {
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
index 638bff1..1d47700 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
@@ -1050,6 +1050,9 @@ static void ocrdma_get_attr(struct ocrdma_dev *dev,
 	attr->max_pd =
 	    (rsp->max_pd_ca_ack_delay & OCRDMA_MBX_QUERY_CFG_MAX_PD_MASK) >>
 	    OCRDMA_MBX_QUERY_CFG_MAX_PD_SHIFT;
+	attr->max_dpp_pds =
+	   (rsp->max_dpp_pds_credits & OCRDMA_MBX_QUERY_CFG_MAX_DPP_PDS_MASK) >>
+	    OCRDMA_MBX_QUERY_CFG_MAX_DPP_PDS_OFFSET;
 	attr->max_qp =
 	    (rsp->qp_srq_cq_ird_ord & OCRDMA_MBX_QUERY_CFG_MAX_QP_MASK) >>
 	    OCRDMA_MBX_QUERY_CFG_MAX_QP_SHIFT;
@@ -1396,6 +1399,123 @@ int ocrdma_mbx_dealloc_pd(struct ocrdma_dev *dev, struct ocrdma_pd *pd)
 	return status;
 }
 
+
+static int ocrdma_mbx_alloc_pd_range(struct ocrdma_dev *dev)
+{
+	int status = -ENOMEM;
+	size_t pd_bitmap_size;
+	struct ocrdma_alloc_pd_range *cmd;
+	struct ocrdma_alloc_pd_range_rsp *rsp;
+
+	/* Pre allocate the DPP PDs */
+	cmd = ocrdma_init_emb_mqe(OCRDMA_CMD_ALLOC_PD_RANGE, sizeof(*cmd));
+	if (!cmd)
+		return -ENOMEM;
+	cmd->pd_count = dev->attr.max_dpp_pds;
+	cmd->enable_dpp_rsvd |= OCRDMA_ALLOC_PD_ENABLE_DPP;
+	status = ocrdma_mbx_cmd(dev, (struct ocrdma_mqe *)cmd);
+	if (status)
+		goto mbx_err;
+	rsp = (struct ocrdma_alloc_pd_range_rsp *)cmd;
+
+	if ((rsp->dpp_page_pdid & OCRDMA_ALLOC_PD_RSP_DPP) && rsp->pd_count) {
+		dev->pd_mgr->dpp_page_index = rsp->dpp_page_pdid >>
+				OCRDMA_ALLOC_PD_RSP_DPP_PAGE_SHIFT;
+		dev->pd_mgr->pd_dpp_start = rsp->dpp_page_pdid &
+				OCRDMA_ALLOC_PD_RNG_RSP_START_PDID_MASK;
+		dev->pd_mgr->max_dpp_pd = rsp->pd_count;
+		pd_bitmap_size = BITS_TO_LONGS(rsp->pd_count) * sizeof(long);
+		dev->pd_mgr->pd_dpp_bitmap = kzalloc(pd_bitmap_size,
+						     GFP_KERNEL);
+	}
+	kfree(cmd);
+
+	cmd = ocrdma_init_emb_mqe(OCRDMA_CMD_ALLOC_PD_RANGE, sizeof(*cmd));
+	if (!cmd)
+		return -ENOMEM;
+
+	cmd->pd_count = dev->attr.max_pd - dev->attr.max_dpp_pds;
+	status = ocrdma_mbx_cmd(dev, (struct ocrdma_mqe *)cmd);
+	if (status)
+		goto mbx_err;
+	rsp = (struct ocrdma_alloc_pd_range_rsp *)cmd;
+	if (rsp->pd_count) {
+		dev->pd_mgr->pd_norm_start = rsp->dpp_page_pdid &
+					OCRDMA_ALLOC_PD_RNG_RSP_START_PDID_MASK;
+		dev->pd_mgr->max_normal_pd = rsp->pd_count;
+		pd_bitmap_size = BITS_TO_LONGS(rsp->pd_count) * sizeof(long);
+		dev->pd_mgr->pd_norm_bitmap = kzalloc(pd_bitmap_size,
+						      GFP_KERNEL);
+	}
+
+	if (dev->pd_mgr->pd_norm_bitmap || dev->pd_mgr->pd_dpp_bitmap) {
+		/* Enable PD resource manager */
+		dev->pd_mgr->pd_prealloc_valid = true;
+	} else {
+		return -ENOMEM;
+	}
+mbx_err:
+	kfree(cmd);
+	return status;
+}
+
+static void ocrdma_mbx_dealloc_pd_range(struct ocrdma_dev *dev)
+{
+	struct ocrdma_dealloc_pd_range *cmd;
+
+	/* return normal PDs to firmware */
+	cmd = ocrdma_init_emb_mqe(OCRDMA_CMD_DEALLOC_PD_RANGE, sizeof(*cmd));
+	if (!cmd)
+		goto mbx_err;
+
+	if (dev->pd_mgr->max_normal_pd) {
+		cmd->start_pd_id = dev->pd_mgr->pd_norm_start;
+		cmd->pd_count = dev->pd_mgr->max_normal_pd;
+		ocrdma_mbx_cmd(dev, (struct ocrdma_mqe *)cmd);
+	}
+
+	if (dev->pd_mgr->max_dpp_pd) {
+		kfree(cmd);
+		/* return DPP PDs to firmware */
+		cmd = ocrdma_init_emb_mqe(OCRDMA_CMD_DEALLOC_PD_RANGE,
+					  sizeof(*cmd));
+		if (!cmd)
+			goto mbx_err;
+
+		cmd->start_pd_id = dev->pd_mgr->pd_dpp_start;
+		cmd->pd_count = dev->pd_mgr->max_dpp_pd;
+		ocrdma_mbx_cmd(dev, (struct ocrdma_mqe *)cmd);
+	}
+mbx_err:
+	kfree(cmd);
+	return;
+}
+
+void ocrdma_alloc_pd_pool(struct ocrdma_dev *dev)
+{
+	int status;
+	dev->pd_mgr = kzalloc(sizeof(struct ocrdma_pd_resource_mgr),
+			      GFP_KERNEL);
+	if (!dev->pd_mgr) {
+		pr_err("%s(%d)Memory allocation failure.\n", __func__, dev->id);
+		return;
+	}
+	status = ocrdma_mbx_alloc_pd_range(dev);
+	if (status) {
+		pr_err("%s(%d) Unable to initialize PD pool, using default.\n",
+			 __func__, dev->id);
+	}
+	return;
+}
+
+void ocrdma_free_pd_pool(struct ocrdma_dev *dev)
+{
+	ocrdma_mbx_dealloc_pd_range(dev);
+	kfree(dev->pd_mgr->pd_norm_bitmap);
+	kfree(dev->pd_mgr->pd_dpp_bitmap);
+	kfree(dev->pd_mgr);
+}
+
 static int ocrdma_build_q_conf(u32 *num_entries, int entry_size,
 			       int *num_pages, int *page_size)
 {
@@ -2915,6 +3035,7 @@ qpeq_err:
 
 void ocrdma_cleanup_hw(struct ocrdma_dev *dev)
 {
+	ocrdma_free_pd_pool(dev);
 	ocrdma_mbx_delete_ah_tbl(dev);
 
 	/* cleanup the eqs */
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_hw.h b/drivers/infiniband/hw/ocrdma/ocrdma_hw.h
index 6eed8f1..e905972 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_hw.h
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_hw.h
@@ -136,5 +136,7 @@ int ocrdma_get_irq(struct ocrdma_dev *dev, struct ocrdma_eq *eq);
 int ocrdma_mbx_rdma_stats(struct ocrdma_dev *, bool reset);
 char *port_speed_string(struct ocrdma_dev *dev);
 void ocrdma_init_service_level(struct ocrdma_dev *);
+void ocrdma_alloc_pd_pool(struct ocrdma_dev *dev);
+void ocrdma_free_pd_range(struct ocrdma_dev *dev);
 
 #endif				/* __OCRDMA_HW_H__ */
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_main.c b/drivers/infiniband/hw/ocrdma/ocrdma_main.c
index b0b2257..4ba4252 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_main.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_main.c
@@ -329,6 +329,8 @@ static int ocrdma_alloc_resources(struct ocrdma_dev *dev)
 	if (dev->stag_arr == NULL)
 		goto alloc_err;
 
+	ocrdma_alloc_pd_pool(dev);
+
 	spin_lock_init(&dev->av_tbl.lock);
 	spin_lock_init(&dev->flush_q_lock);
 	return 0;
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_sli.h b/drivers/infiniband/hw/ocrdma/ocrdma_sli.h
index 6ea8236..e252f1b 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_sli.h
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_sli.h
@@ -75,6 +75,8 @@ enum {
 	OCRDMA_CMD_DESTROY_RBQ = 26,
 
 	OCRDMA_CMD_GET_RDMA_STATS = 27,
+	OCRDMA_CMD_ALLOC_PD_RANGE = 28,
+	OCRDMA_CMD_DEALLOC_PD_RANGE = 29,
 
 	OCRDMA_CMD_MAX
 };
@@ -1297,6 +1299,37 @@ struct ocrdma_dealloc_pd_rsp {
 	struct ocrdma_mbx_rsp rsp;
 };
 
+struct ocrdma_alloc_pd_range {
+	struct ocrdma_mqe_hdr hdr;
+	struct ocrdma_mbx_hdr req;
+	u32 enable_dpp_rsvd;
+	u32 pd_count;
+};
+
+struct ocrdma_alloc_pd_range_rsp {
+	struct ocrdma_mqe_hdr hdr;
+	struct ocrdma_mbx_rsp rsp;
+	u32 dpp_page_pdid;
+	u32 pd_count;
+};
+
+enum {
+	OCRDMA_ALLOC_PD_RNG_RSP_START_PDID_MASK = 0xFFFF,
+};
+
+struct ocrdma_dealloc_pd_range {
+	struct ocrdma_mqe_hdr hdr;
+	struct ocrdma_mbx_hdr req;
+	u32 start_pd_id;
+	u32 pd_count;
+};
+
+struct ocrdma_dealloc_pd_range_rsp {
+	struct ocrdma_mqe_hdr hdr;
+	struct ocrdma_mbx_hdr req;
+	u32 rsvd;
+};
+
 enum {
 	OCRDMA_ADDR_CHECK_ENABLE	= 1,
 	OCRDMA_ADDR_CHECK_DISABLE	= 0
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_stats.c b/drivers/infiniband/hw/ocrdma/ocrdma_stats.c
index df48218..f0a3a59 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_stats.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_stats.c
@@ -489,6 +489,9 @@ static void ocrdma_update_stats(struct ocrdma_dev *dev)
 {
 	ulong now = jiffies, secs;
 	int status = 0;
+	struct ocrdma_rdma_stats_resp *rdma_stats =
+		      (struct ocrdma_rdma_stats_resp *)dev->stats_mem.va;
+	struct ocrdma_rsrc_stats *rsrc_stats = &rdma_stats->act_rsrc_stats;
 
 	secs = jiffies_to_msecs(now - dev->last_stats_time) / 1000U;
 	if (secs) {
@@ -497,6 +500,15 @@ static void ocrdma_update_stats(struct ocrdma_dev *dev)
 		if (status)
 			pr_err("%s: stats mbox failed with status = %d\n",
 			       __func__, status);
+		/* Update PD counters from PD resource manager */
+		if (dev->pd_mgr->pd_prealloc_valid) {
+			rsrc_stats->dpp_pds = dev->pd_mgr->pd_dpp_count;
+			rsrc_stats->non_dpp_pds = dev->pd_mgr->pd_norm_count;
+			/* Threshold stata*/
+			rsrc_stats = &rdma_stats->th_rsrc_stats;
+			rsrc_stats->dpp_pds = dev->pd_mgr->pd_dpp_thrsh;
+			rsrc_stats->non_dpp_pds = dev->pd_mgr->pd_norm_thrsh;
+		}
 		dev->last_stats_time = jiffies;
 	}
 }
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
index fb8d8c4..8681a24 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
@@ -253,6 +253,107 @@ static bool ocrdma_search_mmap(struct ocrdma_ucontext *uctx, u64 phy_addr,
 	return found;
 }
 
+
+static u16 _ocrdma_pd_mgr_get_bitmap(struct ocrdma_dev *dev, bool dpp_pool)
+{
+	u16 pd_bitmap_idx = 0;
+	const unsigned long *pd_bitmap;
+
+	if (dpp_pool) {
+		pd_bitmap = dev->pd_mgr->pd_dpp_bitmap;
+		pd_bitmap_idx = find_first_zero_bit(pd_bitmap,
+						    dev->pd_mgr->max_dpp_pd);
+		__set_bit(pd_bitmap_idx, dev->pd_mgr->pd_dpp_bitmap);
+		dev->pd_mgr->pd_dpp_count++;
+		if (dev->pd_mgr->pd_dpp_count > dev->pd_mgr->pd_dpp_thrsh)
+			dev->pd_mgr->pd_dpp_thrsh = dev->pd_mgr->pd_dpp_count;
+	} else {
+		pd_bitmap = dev->pd_mgr->pd_norm_bitmap;
+		pd_bitmap_idx = find_first_zero_bit(pd_bitmap,
+						    dev->pd_mgr->max_normal_pd);
+		__set_bit(pd_bitmap_idx, dev->pd_mgr->pd_norm_bitmap);
+		dev->pd_mgr->pd_norm_count++;
+		if (dev->pd_mgr->pd_norm_count > dev->pd_mgr->pd_norm_thrsh)
+			dev->pd_mgr->pd_norm_thrsh = dev->pd_mgr->pd_norm_count;
+	}
+	return pd_bitmap_idx;
+}
+
+static u8 _ocrdma_pd_mgr_put_bitmap(struct ocrdma_dev *dev, u16 pd_id,
+					bool dpp_pool)
+{
+	int status = 0;
+	u16 pd_count;
+	u16 pd_bit_index;
+
+	pd_count = dpp_pool ? dev->pd_mgr->pd_dpp_count :
+			      dev->pd_mgr->pd_norm_count;
+	if (pd_count == 0)
+		return -EINVAL;
+
+	if (dpp_pool) {
+		pd_bit_index = pd_id - dev->pd_mgr->pd_dpp_start;
+		if (pd_bit_index >= dev->pd_mgr->max_dpp_pd) {
+			status = -EINVAL;
+		} else {
+			__clear_bit(pd_bit_index, dev->pd_mgr->pd_dpp_bitmap);
+			dev->pd_mgr->pd_dpp_count--;
+		}
+	} else {
+		pd_bit_index = pd_id - dev->pd_mgr->pd_norm_start;
+		if (pd_bit_index >= dev->pd_mgr->max_normal_pd) {
+			status = -EINVAL;
+		} else {
+			__clear_bit(pd_bit_index, dev->pd_mgr->pd_norm_bitmap);
+			dev->pd_mgr->pd_norm_count--;
+		}
+	}
+	return status;
+}
+
+static u8 ocrdma_put_pd_num(struct ocrdma_dev *dev, u16 pd_id,
+				   bool dpp_pool)
+{
+	int status;
+
+	mutex_lock(&dev->dev_lock);
+	status = _ocrdma_pd_mgr_put_bitmap(dev, pd_id, dpp_pool);
+	mutex_unlock(&dev->dev_lock);
+	return status;
+}
+
+static int ocrdma_get_pd_num(struct ocrdma_dev *dev, struct ocrdma_pd *pd)
+{
+	u16 pd_idx = 0;
+	int status = 0;
+
+	mutex_lock(&dev->dev_lock);
+	if (pd->dpp_enabled) {
+		/* try allocating DPP PD, if not available then normal PD */
+		if (dev->pd_mgr->pd_dpp_count < dev->pd_mgr->max_dpp_pd) {
+			pd_idx = _ocrdma_pd_mgr_get_bitmap(dev, true);
+			pd->id = dev->pd_mgr->pd_dpp_start + pd_idx;
+			pd->dpp_page = dev->pd_mgr->dpp_page_index + pd_idx;
+		} else if (dev->pd_mgr->pd_norm_count <
+			   dev->pd_mgr->max_normal_pd) {
+			pd_idx = _ocrdma_pd_mgr_get_bitmap(dev, false);
+			pd->id = dev->pd_mgr->pd_norm_start + pd_idx;
+			pd->dpp_enabled = false;
+		} else {
+			status = -EINVAL;
+		}
+	} else {
+		if (dev->pd_mgr->pd_norm_count < dev->pd_mgr->max_normal_pd) {
+			pd_idx = _ocrdma_pd_mgr_get_bitmap(dev, false);
+			pd->id = dev->pd_mgr->pd_norm_start + pd_idx;
+		} else {
+			status = -EINVAL;
+		}
+	}
+	mutex_unlock(&dev->dev_lock);
+	return status;
+}
+
 static struct ocrdma_pd *_ocrdma_alloc_pd(struct ocrdma_dev *dev,
 					  struct ocrdma_ucontext *uctx,
 					  struct ib_udata *udata)
@@ -272,6 +373,11 @@ static struct ocrdma_pd *_ocrdma_alloc_pd(struct ocrdma_dev *dev,
 					   dev->attr.wqe_size) : 0;
 	}
 
+	if (dev->pd_mgr->pd_prealloc_valid) {
+		status = ocrdma_get_pd_num(dev, pd);
+		return (status == 0) ? pd : ERR_PTR(status);
+	}
+
 retry:
 	status = ocrdma_mbx_alloc_pd(dev, pd);
 	if (status) {
@@ -299,7 +405,11 @@ static int _ocrdma_dealloc_pd(struct ocrdma_dev *dev,
 {
 	int status = 0;
 
-	status = ocrdma_mbx_dealloc_pd(dev, pd);
+	if (dev->pd_mgr->pd_prealloc_valid)
+		status = ocrdma_put_pd_num(dev, pd->id, pd->dpp_enabled);
+	else
+		status = ocrdma_mbx_dealloc_pd(dev, pd);
+
 	kfree(pd);
 	return status;
 }
@@ -569,7 +679,7 @@ err:
 	if (is_uctx_pd) {
 		ocrdma_release_ucontext_pd(uctx);
 	} else {
-		status = ocrdma_mbx_dealloc_pd(dev, pd);
+		status = _ocrdma_dealloc_pd(dev, pd);
 		kfree(pd);
 	}
 exit:
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
