From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH 09/11] RDMA/cxgb4: Set fence flag for inv-local-stag work
	requests.
Date: Thu, 20 May 2010 16:58:10 -0500
Message-ID: <20100520215810.32394.63870.stgit@build.ogc.int>
References: <20100520215727.32394.90669.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100520215727.32394.90669.stgit-T4OLL4TyM9aNDNWfRnPdfg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---

 drivers/infiniband/hw/cxgb4/qp.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/qp.c b/drivers/infiniband/hw/cxgb4/qp.c
index 83a01dc..9fb52fa 100644
--- a/drivers/infiniband/hw/cxgb4/qp.c
+++ b/drivers/infiniband/hw/cxgb4/qp.c
@@ -588,6 +588,8 @@ int c4iw_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 			err = build_fastreg(wqe, wr, &len16);
 			break;
 		case IB_WR_LOCAL_INV:
+			if (wr->send_flags & IB_SEND_FENCE)
+				fw_flags |= FW_RI_LOCAL_FENCE_FLAG;
 			fw_opcode = FW_RI_INV_LSTAG_WR;
 			swsqe->opcode = FW_RI_LOCAL_INV;
 			err = build_inv_stag(wqe, wr, &len16);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
