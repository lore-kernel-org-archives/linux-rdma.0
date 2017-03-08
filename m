From: SF Markus Elfring <elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Subject: [PATCH 03/26] IB/ocrdma: Improve size determinations in
 ocrdma_mbx_get_dcbx_config()
Date: Wed, 8 Mar 2017 13:45:43 +0100
Message-ID: <907034da-34ae-9e5b-6e56-3a2feb4924da@users.sourceforge.net>
References: <fc421509-4069-da8a-b308-60b49ea91ada@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <fc421509-4069-da8a-b308-60b49ea91ada-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Selvin Xavier <selvin.xavier-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Markus Elfring <elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Date: Tue, 7 Mar 2017 19:09:20 +0100

Replace the specification of data structures by references for variables
as the parameter for the operator "sizeof" to make the corresponding size
determinations a bit safer according to the Linux coding style convention.

Signed-off-by: Markus Elfring <elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
---
 drivers/infiniband/hw/ocrdma/ocrdma_hw.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
index d5a3127b6df8..85bebb887c5c 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
@@ -2901,9 +2901,8 @@ static int ocrdma_mbx_get_dcbx_config(struct ocrdma_dev *dev, u32 ptype,
 	struct pci_dev *pdev = dev->nic_info.pdev;
 	struct ocrdma_mqe_sge *mqe_sge = cmd.u.nonemb_req.sge;
 
-	memset(&cmd, 0, sizeof(struct ocrdma_mqe));
-	cmd.hdr.pyld_len = max_t (u32, sizeof(struct ocrdma_get_dcbx_cfg_rsp),
-					sizeof(struct ocrdma_get_dcbx_cfg_req));
+	memset(&cmd, 0, sizeof(cmd));
+	cmd.hdr.pyld_len = max_t(u32, sizeof(*rsp), sizeof(*req));
 	req = dma_alloc_coherent(&pdev->dev, cmd.hdr.pyld_len, &pa, GFP_KERNEL);
 	if (!req) {
 		status = -ENOMEM;
@@ -2915,8 +2914,7 @@ static int ocrdma_mbx_get_dcbx_config(struct ocrdma_dev *dev, u32 ptype,
 	mqe_sge->pa_lo = (u32) (pa & 0xFFFFFFFFUL);
 	mqe_sge->pa_hi = (u32) upper_32_bits(pa);
 	mqe_sge->len = cmd.hdr.pyld_len;
-
-	memset(req, 0, sizeof(struct ocrdma_get_dcbx_cfg_req));
+	memset(req, 0, sizeof(*req));
 	ocrdma_init_mch(&req->hdr, OCRDMA_CMD_GET_DCBX_CONFIG,
 			OCRDMA_SUBSYS_DCBX, cmd.hdr.pyld_len);
 	req->param_type = ptype;
@@ -2926,9 +2924,8 @@ static int ocrdma_mbx_get_dcbx_config(struct ocrdma_dev *dev, u32 ptype,
 		goto mbx_err;
 
 	rsp = (struct ocrdma_get_dcbx_cfg_rsp *)req;
-	ocrdma_le32_to_cpu(rsp, sizeof(struct ocrdma_get_dcbx_cfg_rsp));
-	memcpy(dcbxcfg, &rsp->cfg, sizeof(struct ocrdma_dcbx_cfg));
-
+	ocrdma_le32_to_cpu(rsp, sizeof(*rsp));
+	memcpy(dcbxcfg, &rsp->cfg, sizeof(*dcbxcfg));
 mbx_err:
 	dma_free_coherent(&pdev->dev, cmd.hdr.pyld_len, req, pa);
 mem_err:
-- 
2.12.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
