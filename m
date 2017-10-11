From: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Subject: [PATCH v2 32/45] RDMA/ocrdma: Suppress gcc 7 fall-through complaints
Date: Wed, 11 Oct 2017 10:49:14 -0700
Message-ID: <20171011174927.25113-33-bart.vanassche@wdc.com>
References: <20171011174927.25113-1-bart.vanassche@wdc.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171011174927.25113-1-bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>, Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Avoid that gcc 7 reports the following warning when building with
W=1:

warning: this statement may fall through [-Wimplicit-fallthrough=]

Signed-off-by: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Cc: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Cc: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
index 27d5e8d9f08d..3757f1b8cbfc 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
@@ -2247,6 +2247,7 @@ int ocrdma_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 		case IB_WR_SEND_WITH_IMM:
 			hdr->cw |= (OCRDMA_FLAG_IMM << OCRDMA_WQE_FLAGS_SHIFT);
 			hdr->immdt = ntohl(wr->ex.imm_data);
+			/* fall through */
 		case IB_WR_SEND:
 			hdr->cw |= (OCRDMA_SEND << OCRDMA_WQE_OPCODE_SHIFT);
 			ocrdma_build_send(qp, hdr, wr);
@@ -2260,6 +2261,7 @@ int ocrdma_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 		case IB_WR_RDMA_WRITE_WITH_IMM:
 			hdr->cw |= (OCRDMA_FLAG_IMM << OCRDMA_WQE_FLAGS_SHIFT);
 			hdr->immdt = ntohl(wr->ex.imm_data);
+			/* fall through */
 		case IB_WR_RDMA_WRITE:
 			hdr->cw |= (OCRDMA_WRITE << OCRDMA_WQE_OPCODE_SHIFT);
 			status = ocrdma_build_write(qp, hdr, wr);
-- 
2.14.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
