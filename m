From: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 27/28] bnxt_re: Set uverbs command mask
Date: Sun,  4 Dec 2016 22:38:31 -0800
Message-ID: <1480919912-1079-28-git-send-email-selvin.xavier@broadcom.com>
References: <1480919912-1079-1-git-send-email-selvin.xavier@broadcom.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1480919912-1079-1-git-send-email-selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Eddie Wai <eddie.wai-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Somnath Kotur <somnath.kotur-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Sriharsha Basavapatna <sriharsha.basavapatna-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This patch exports available uverbs command mask to the IB stack.
Also, populating some of the missing parameters in the ibdev structure
used for registration.

Signed-off-by: Eddie Wai <eddie.wai-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Signed-off-by: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Signed-off-by: Somnath Kotur <somnath.kotur-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Signed-off-by: Sriharsha Basavapatna <sriharsha.basavapatna-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Signed-off-by: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/bnxtre/bnxt_re_main.c | 36 +++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/drivers/infiniband/hw/bnxtre/bnxt_re_main.c b/drivers/infiniband/hw/bnxtre/bnxt_re_main.c
index 67b6a80..9f39600 100644
--- a/drivers/infiniband/hw/bnxtre/bnxt_re_main.c
+++ b/drivers/infiniband/hw/bnxtre/bnxt_re_main.c
@@ -36,6 +36,7 @@
 #include "bnxt_re.h"
 #include "bnxt_re_debugfs.h"
 #include "bnxt_re_ib_verbs.h"
+#include "bnxt_re_uverbs_abi.h"
 #include "bnxt.h"
 static char version[] =
 		BNXT_RE_DESC " v" ROCE_DRV_MODULE_VERSION "\n";
@@ -418,8 +419,42 @@ static int bnxt_re_register_ib(struct bnxt_re_dev *rdev)
 		strlen(BNXT_RE_DESC) + 5);
 	ibdev->phys_port_cnt = 1;
 
+	bnxt_qplib_get_guid(rdev->netdev->dev_addr, (u8 *)&ibdev->node_guid);
+
 	ibdev->num_comp_vectors	= 1;
 	ibdev->dma_device = &rdev->en_dev->pdev->dev;
+	ibdev->local_dma_lkey = BNXT_QPLIB_RSVD_LKEY;
+
+	/* User space */
+	ibdev->uverbs_abi_ver = BNXT_RE_ABI_VERSION;
+	ibdev->uverbs_cmd_mask =
+			(1ull << IB_USER_VERBS_CMD_GET_CONTEXT)		|
+			(1ull << IB_USER_VERBS_CMD_QUERY_DEVICE)	|
+			(1ull << IB_USER_VERBS_CMD_QUERY_PORT)		|
+			(1ull << IB_USER_VERBS_CMD_ALLOC_PD)		|
+			(1ull << IB_USER_VERBS_CMD_DEALLOC_PD)		|
+			(1ull << IB_USER_VERBS_CMD_REG_MR)		|
+			(1ull << IB_USER_VERBS_CMD_REREG_MR)		|
+			(1ull << IB_USER_VERBS_CMD_DEREG_MR)		|
+			(1ull << IB_USER_VERBS_CMD_CREATE_COMP_CHANNEL) |
+			(1ull << IB_USER_VERBS_CMD_CREATE_CQ)		|
+			(1ull << IB_USER_VERBS_CMD_RESIZE_CQ)		|
+			(1ull << IB_USER_VERBS_CMD_DESTROY_CQ)		|
+			(1ull << IB_USER_VERBS_CMD_CREATE_QP)		|
+			(1ull << IB_USER_VERBS_CMD_MODIFY_QP)		|
+			(1ull << IB_USER_VERBS_CMD_QUERY_QP)		|
+			(1ull << IB_USER_VERBS_CMD_DESTROY_QP)		|
+			(1ull << IB_USER_VERBS_CMD_CREATE_SRQ)		|
+			(1ull << IB_USER_VERBS_CMD_MODIFY_SRQ)		|
+			(1ull << IB_USER_VERBS_CMD_QUERY_SRQ)		|
+			(1ull << IB_USER_VERBS_CMD_DESTROY_SRQ)		|
+			(1ull << IB_USER_VERBS_CMD_CREATE_AH)		|
+			(1ull << IB_USER_VERBS_CMD_MODIFY_AH)		|
+			(1ull << IB_USER_VERBS_CMD_QUERY_AH)		|
+			(1ull << IB_USER_VERBS_CMD_DESTROY_AH);
+	/* POLL_CQ and REQ_NOTIFY_CQ is directly handled in libbnxt_re */
+
+	/* Kernel verbs */
 	ibdev->query_device		= bnxt_re_query_device;
 	ibdev->modify_device		= bnxt_re_modify_device;
 
@@ -1046,6 +1081,7 @@ static int bnxt_re_ib_reg(struct bnxt_re_dev *rdev)
 		pr_err("Failed to register with IB: %#x\n", rc);
 		goto fail;
 	}
+	dev_info(rdev_to_dev(rdev), "Device registered successfully");
 	for (i = 0; i < ARRAY_SIZE(bnxt_re_attributes); i++) {
 		rc = device_create_file(&rdev->ibdev.dev,
 					bnxt_re_attributes[i]);
-- 
2.5.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
