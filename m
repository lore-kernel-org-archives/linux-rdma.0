From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 1/3] IB/qib: fix UC MR refs for immediate operations
Date: Wed, 27 Jun 2012 18:33:05 -0400
Message-ID: <20120627223305.12508.70591.stgit@kop-dev-sles11-04.qlogic.org>
References: <20120627223257.12508.1491.stgit@kop-dev-sles11-04.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120627223257.12508.1491.stgit-hIFRcJ1SNwcXGO8/Qfapyjg/wwJxntczYPYVAmT7z5s@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

An MR reference leak exists handling UC RDMA writes with
immediate data by manipulating the reference counts as if the
operation had been a send.

This patch moves the last_imm label so that the RDMA write
operations with immediate data converge at the cq building code.
The copy/mr deref code is now done correctly prior to the branch
to last_imm.

Reviewed-by: Edward Mascarenhas <edward.mascarenhas-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib_uc.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_uc.c b/drivers/infiniband/hw/qib/qib_uc.c
index ce7387f..70b4cb7 100644
--- a/drivers/infiniband/hw/qib/qib_uc.c
+++ b/drivers/infiniband/hw/qib/qib_uc.c
@@ -403,7 +403,6 @@ send_last:
 		if (unlikely(wc.byte_len > qp->r_len))
 			goto rewind;
 		wc.opcode = IB_WC_RECV;
-last_imm:
 		qib_copy_sge(&qp->r_sge, data, tlen, 0);
 		while (qp->s_rdma_read_sge.num_sge) {
 			atomic_dec(&qp->s_rdma_read_sge.sge.mr->refcount);
@@ -411,6 +410,7 @@ last_imm:
 				qp->s_rdma_read_sge.sge =
 					*qp->s_rdma_read_sge.sg_list++;
 		}
+last_imm:
 		wc.wr_id = qp->r_wr_id;
 		wc.status = IB_WC_SUCCESS;
 		wc.qp = &qp->ibqp;
@@ -509,6 +509,12 @@ rdma_last_imm:
 		}
 		wc.byte_len = qp->r_len;
 		wc.opcode = IB_WC_RECV_RDMA_WITH_IMM;
+		qib_copy_sge(&qp->r_sge, data, tlen, 1);
+		while (qp->r_sge.num_sge) {
+			atomic_dec(&qp->r_sge.sge.mr->refcount);
+			if (--qp->r_sge.num_sge)
+				qp->r_sge.sge = *qp->r_sge.sg_list++;
+		}
 		goto last_imm;
 
 	case OP(RDMA_WRITE_LAST):


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
