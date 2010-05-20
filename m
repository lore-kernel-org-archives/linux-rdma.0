From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH 10/11] RDMA/cxgb4: Support IB_WR_READ_WITH_INV opcode.
Date: Thu, 20 May 2010 16:58:16 -0500
Message-ID: <20100520215815.32394.99621.stgit@build.ogc.int>
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

 drivers/infiniband/hw/cxgb4/qp.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/qp.c b/drivers/infiniband/hw/cxgb4/qp.c
index 9fb52fa..a41881b 100644
--- a/drivers/infiniband/hw/cxgb4/qp.c
+++ b/drivers/infiniband/hw/cxgb4/qp.c
@@ -572,9 +572,13 @@ int c4iw_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 			err = build_rdma_write(wqe, wr, &len16);
 			break;
 		case IB_WR_RDMA_READ:
+		case IB_WR_RDMA_READ_WITH_INV:
 			fw_opcode = FW_RI_RDMA_READ_WR;
 			swsqe->opcode = FW_RI_READ_REQ;
-			fw_flags = 0;
+			if (wr->opcode == IB_WR_RDMA_READ_WITH_INV)
+				fw_flags |= FW_RI_RDMA_READ_INVALIDATE;
+			else
+				fw_flags = 0;
 			err = build_rdma_read(wqe, wr, &len16);
 			if (err)
 				break;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
