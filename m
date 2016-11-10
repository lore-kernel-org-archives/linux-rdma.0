From: Henry Orosco <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] i40iw: Query device accounts for internal rsrc
Date: Wed,  9 Nov 2016 21:30:28 -0600
Message-ID: <20161110033028.16356-1-henry.orosco@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Henry Orosco <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Some resources are consumed internally and not available to the user.
After hw is initialized, figure out how many resources are consumed
and subtract those numbers from the initial max device capability in
i40iw_query_device().

Signed-off-by: Henry Orosco <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/i40iw/i40iw.h       |  4 ++++
 drivers/infiniband/hw/i40iw/i40iw_hw.c    |  2 +-
 drivers/infiniband/hw/i40iw/i40iw_main.c  | 15 +++++++++++++++
 drivers/infiniband/hw/i40iw/i40iw_user.h  |  3 ++-
 drivers/infiniband/hw/i40iw/i40iw_verbs.c |  8 ++++----
 5 files changed, 26 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/i40iw/i40iw.h b/drivers/infiniband/hw/i40iw/i40iw.h
index 8ec09e4..22af66a 100644
--- a/drivers/infiniband/hw/i40iw/i40iw.h
+++ b/drivers/infiniband/hw/i40iw/i40iw.h
@@ -297,6 +297,10 @@ struct i40iw_device {
 	u32 mr_stagmask;
 	u32 mpa_version;
 	bool dcb;
+	u32 used_pds;
+	u32 used_cqs;
+	u32 used_mrs;
+	u32 used_qps;
 };
 
 struct i40iw_ib_device {
diff --git a/drivers/infiniband/hw/i40iw/i40iw_hw.c b/drivers/infiniband/hw/i40iw/i40iw_hw.c
index 0c92a40..886b8c8 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_hw.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_hw.c
@@ -62,7 +62,7 @@ u32 i40iw_initialize_hw_resources(struct i40iw_device *iwdev)
 	max_mr = iwdev->sc_dev.hmc_info->hmc_obj[I40IW_HMC_IW_MR].cnt;
 	arp_table_size = iwdev->sc_dev.hmc_info->hmc_obj[I40IW_HMC_IW_ARP].cnt;
 	iwdev->max_cqe = 0xFFFFF;
-	num_pds = max_qp * 4;
+	num_pds = I40IW_MAX_PDS;
 	resources_size = sizeof(struct i40iw_arp_entry) * arp_table_size;
 	resources_size += sizeof(unsigned long) * BITS_TO_LONGS(max_qp);
 	resources_size += sizeof(unsigned long) * BITS_TO_LONGS(max_mr);
diff --git a/drivers/infiniband/hw/i40iw/i40iw_main.c b/drivers/infiniband/hw/i40iw/i40iw_main.c
index 078d784..ba45b16 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_main.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_main.c
@@ -1540,6 +1540,20 @@ static enum i40iw_status_code i40iw_setup_init_state(struct i40iw_handler *hdl,
 }
 
 /**
+ * i40iw_get_used_rsrc - determine resources used internally
+ * @iwdev: iwarp device
+ *
+ * Called after internal allocations
+ */
+static void i40iw_get_used_rsrc(struct i40iw_device *iwdev)
+{
+	iwdev->used_pds = find_next_zero_bit(iwdev->allocated_pds, iwdev->max_pd, 0);
+	iwdev->used_qps = find_next_zero_bit(iwdev->allocated_qps, iwdev->max_qp, 0);
+	iwdev->used_cqs = find_next_zero_bit(iwdev->allocated_cqs, iwdev->max_cq, 0);
+	iwdev->used_mrs = find_next_zero_bit(iwdev->allocated_mrs, iwdev->max_mr, 0);
+}
+
+/**
  * i40iw_open - client interface operation open for iwarp/uda device
  * @ldev: lan device information
  * @client: iwarp client information, provided during registration
@@ -1611,6 +1625,7 @@ static int i40iw_open(struct i40e_info *ldev, struct i40e_client *client)
 		status = i40iw_initialize_hw_resources(iwdev);
 		if (status)
 			break;
+		i40iw_get_used_rsrc(iwdev);
 		dev->ccq_ops->ccq_arm(dev->ccq);
 		status = i40iw_hmc_init_pble(&iwdev->sc_dev, iwdev->pble_rsrc);
 		if (status)
diff --git a/drivers/infiniband/hw/i40iw/i40iw_user.h b/drivers/infiniband/hw/i40iw/i40iw_user.h
index e65c2baa..66263fc 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_user.h
+++ b/drivers/infiniband/hw/i40iw/i40iw_user.h
@@ -76,7 +76,8 @@ enum i40iw_device_capabilities_const {
 	I40IW_MAX_ORD_SIZE =			127,
 	I40IW_MAX_WQ_ENTRIES =			2048,
 	I40IW_Q2_BUFFER_SIZE =			(248 + 100),
-	I40IW_QP_CTX_SIZE =			248
+	I40IW_QP_CTX_SIZE =			248,
+	I40IW_MAX_PDS = 			32768
 };
 
 #define i40iw_handle void *
diff --git a/drivers/infiniband/hw/i40iw/i40iw_verbs.c b/drivers/infiniband/hw/i40iw/i40iw_verbs.c
index 6329c97..bfea715 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_verbs.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_verbs.c
@@ -67,13 +67,13 @@ static int i40iw_query_device(struct ib_device *ibdev,
 	props->vendor_part_id = iwdev->ldev->pcidev->device;
 	props->hw_ver = (u32)iwdev->sc_dev.hw_rev;
 	props->max_mr_size = I40IW_MAX_OUTBOUND_MESSAGE_SIZE;
-	props->max_qp = iwdev->max_qp;
+	props->max_qp = iwdev->max_qp - iwdev->used_qps;
 	props->max_qp_wr = (I40IW_MAX_WQ_ENTRIES >> 2) - 1;
 	props->max_sge = I40IW_MAX_WQ_FRAGMENT_COUNT;
-	props->max_cq = iwdev->max_cq;
+	props->max_cq = iwdev->max_cq - iwdev->used_cqs;
 	props->max_cqe = iwdev->max_cqe;
-	props->max_mr = iwdev->max_mr;
-	props->max_pd = iwdev->max_pd;
+	props->max_mr = iwdev->max_mr - iwdev->used_mrs;
+	props->max_pd = iwdev->max_pd - iwdev->used_pds;
 	props->max_sge_rd = I40IW_MAX_SGE_RD;
 	props->max_qp_rd_atom = I40IW_MAX_IRD_SIZE;
 	props->max_qp_init_rd_atom = props->max_qp_rd_atom;
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
