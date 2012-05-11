From: Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] RDMA/nes: Fix for the ORD value of the connecting peer
Date: Fri, 11 May 2012 10:46:16 -0500
Message-ID: <20120511154616.GA5940@TENIKOLO-MOBL>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, donald.e.wood-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Set ORD value of the connecting peer to be at least one in order to accommodate RDMA READ Request message.

Signed-off-by: Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Donald Wood <Donald.E.Wood-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/nes/nes_cm.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/hw/nes/nes_cm.c b/drivers/infiniband/hw/nes/nes_cm.c
index da2c67d..7cdcefd 100644
--- a/drivers/infiniband/hw/nes/nes_cm.c
+++ b/drivers/infiniband/hw/nes/nes_cm.c
@@ -3316,6 +3316,10 @@ int nes_connect(struct iw_cm_id *cm_id, struct iw_cm_conn_param *conn_param)
 
 	nesqp->private_data_len = conn_param->private_data_len;
 	nesqp->nesqp_context->ird_ord_sizes |= cpu_to_le32((u32)conn_param->ord);
+	/* space for rdma0 read msg */
+	if (conn_param->ord == 0)
+		nesqp->nesqp_context->ird_ord_sizes |= cpu_to_le32(1);
+
 	nes_debug(NES_DBG_CM, "requested ord = 0x%08X.\n", (u32)conn_param->ord);
 	nes_debug(NES_DBG_CM, "mpa private data len =%u\n",
 		  conn_param->private_data_len);
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
