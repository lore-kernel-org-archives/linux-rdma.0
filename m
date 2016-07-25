From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 09/28] IB/hfi1: Add support for extended memory management
Date: Mon, 25 Jul 2016 13:38:43 -0700
Message-ID: <20160725203842.4800.60710.stgit@scvm10.sc.intel.com>
References: <20160725203554.4800.37248.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160725203554.4800.37248.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jianxin Xiong <jianxin.xiong-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jianxin Xiong <jianxin.xiong-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Advertise and add the capability of handing all aspects of IBTA extended
memory management support in post send.

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jianxin Xiong <jianxin.xiong-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/qp.c    |   17 +++++++++++++++++
 drivers/infiniband/hw/hfi1/verbs.c |    6 ++++--
 2 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/qp.c b/drivers/infiniband/hw/hfi1/qp.c
index a8b3fc9..ad8ad33 100644
--- a/drivers/infiniband/hw/hfi1/qp.c
+++ b/drivers/infiniband/hw/hfi1/qp.c
@@ -157,6 +157,23 @@ const struct rvt_operation_params hfi1_post_parms[RVT_OPERATION_MAX] = {
 		       BIT(IB_QPT_UC) | BIT(IB_QPT_RC),
 },
 
+[IB_WR_REG_MR] = {
+	.length = sizeof(struct ib_reg_wr),
+	.qpt_support = BIT(IB_QPT_UC) | BIT(IB_QPT_RC),
+	.flags = RVT_OPERATION_LOCAL,
+},
+
+[IB_WR_LOCAL_INV] = {
+	.length = sizeof(struct ib_send_wr),
+	.qpt_support = BIT(IB_QPT_UC) | BIT(IB_QPT_RC),
+	.flags = RVT_OPERATION_LOCAL,
+},
+
+[IB_WR_SEND_WITH_INV] = {
+	.length = sizeof(struct ib_send_wr),
+	.qpt_support = BIT(IB_QPT_RC),
+},
+
 };
 
 static void flush_tx_list(struct rvt_qp *qp)
diff --git a/drivers/infiniband/hw/hfi1/verbs.c b/drivers/infiniband/hw/hfi1/verbs.c
index 57e0c0d..9578565 100644
--- a/drivers/infiniband/hw/hfi1/verbs.c
+++ b/drivers/infiniband/hw/hfi1/verbs.c
@@ -1305,13 +1305,15 @@ static void hfi1_fill_device_attr(struct hfi1_devdata *dd)
 	rdi->dparms.props.device_cap_flags = IB_DEVICE_BAD_PKEY_CNTR |
 			IB_DEVICE_BAD_QKEY_CNTR | IB_DEVICE_SHUTDOWN_PORT |
 			IB_DEVICE_SYS_IMAGE_GUID | IB_DEVICE_RC_RNR_NAK_GEN |
-			IB_DEVICE_PORT_ACTIVE_EVENT | IB_DEVICE_SRQ_RESIZE;
+			IB_DEVICE_PORT_ACTIVE_EVENT | IB_DEVICE_SRQ_RESIZE |
+			IB_DEVICE_MEM_MGT_EXTENSIONS;
 	rdi->dparms.props.page_size_cap = PAGE_SIZE;
 	rdi->dparms.props.vendor_id = dd->oui1 << 16 | dd->oui2 << 8 | dd->oui3;
 	rdi->dparms.props.vendor_part_id = dd->pcidev->device;
 	rdi->dparms.props.hw_ver = dd->minrev;
 	rdi->dparms.props.sys_image_guid = ib_hfi1_sys_image_guid;
-	rdi->dparms.props.max_mr_size = ~0ULL;
+	rdi->dparms.props.max_mr_size = U64_MAX;
+	rdi->dparms.props.max_fast_reg_page_list_len = UINT_MAX;
 	rdi->dparms.props.max_qp = hfi1_max_qps;
 	rdi->dparms.props.max_qp_wr = hfi1_max_qp_wrs;
 	rdi->dparms.props.max_sge = hfi1_max_sges;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
