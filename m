From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH 2.6.37 1/2] RDMA/cxgb4: Don't set completion flag for read
	requests.
Date: Fri, 17 Sep 2010 15:40:09 -0500
Message-ID: <20100917204009.25530.63174.stgit@build.ogc.int>
References: <20100917204004.25530.62611.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100917204004.25530.62611.stgit-T4OLL4TyM9aNDNWfRnPdfg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---

 drivers/infiniband/hw/cxgb4/qp.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/qp.c b/drivers/infiniband/hw/cxgb4/qp.c
index 44ad386..7097ec4 100644
--- a/drivers/infiniband/hw/cxgb4/qp.c
+++ b/drivers/infiniband/hw/cxgb4/qp.c
@@ -639,7 +639,7 @@ int c4iw_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 			fw_opcode = FW_RI_RDMA_READ_WR;
 			swsqe->opcode = FW_RI_READ_REQ;
 			if (wr->opcode == IB_WR_RDMA_READ_WITH_INV)
-				fw_flags |= FW_RI_RDMA_READ_INVALIDATE;
+				fw_flags = FW_RI_RDMA_READ_INVALIDATE;
 			else
 				fw_flags = 0;
 			err = build_rdma_read(wqe, wr, &len16);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
