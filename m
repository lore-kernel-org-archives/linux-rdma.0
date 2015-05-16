From: Selvin Xavier <selvin.xavier-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
Subject: [PATCH for-4.1 08/11] RDMA/ocrdma: Fail connection for MTU lesser than 512
Date: Sat, 16 May 2015 13:21:46 +0530
Message-ID: <1431762709-20740-9-git-send-email-selvin.xavier@avagotech.com>
References: <1431762709-20740-1-git-send-email-selvin.xavier@avagotech.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1431762709-20740-1-git-send-email-selvin.xavier-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Naga Irrinki <naga.irrinki-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>

HW currently restricts the IB MTU range between 512 and 4096.
Fail connection for MTUs lesser than 512.

Signed-off-by: Naga Irrinki <naga.irrinki-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
Signed-off-by: Selvin Xavier <selvin.xavier-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
---
 drivers/infiniband/hw/ocrdma/ocrdma_hw.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
index 4b77f34..319675c 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
@@ -2535,8 +2535,10 @@ static int ocrdma_set_qp_params(struct ocrdma_qp *qp,
 		cmd->flags |= OCRDMA_QP_PARA_DST_QPN_VALID;
 	}
 	if (attr_mask & IB_QP_PATH_MTU) {
-		if (attrs->path_mtu < IB_MTU_256 ||
+		if (attrs->path_mtu < IB_MTU_512 ||
 		    attrs->path_mtu > IB_MTU_4096) {
+			pr_err("ocrdma%d: IB MTU %d is not supported\n",
+			       dev->id, ib_mtu_enum_to_int(attrs->path_mtu));
 			status = -EINVAL;
 			goto pmtu_err;
 		}
-- 
2.2.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
