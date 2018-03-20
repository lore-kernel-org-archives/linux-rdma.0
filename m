From: Sinan Kaya <okaya@codeaurora.org>
Subject: [PATCH v4 6/6] RDMA/qedr: eliminate duplicate barriers on weakly-ordered archs #2
Date: Mon, 19 Mar 2018 22:47:48 -0400
Message-ID: <1521514068-8856-7-git-send-email-okaya@codeaurora.org>
References: <1521514068-8856-1-git-send-email-okaya@codeaurora.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1521514068-8856-1-git-send-email-okaya@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-rdma@vger.kernel.org, timur@codeaurora.org, sulrich@codeaurora.org
Cc: linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Sinan Kaya <okaya@codeaurora.org>, Michal Kalderon <Michal.Kalderon@cavium.com>, Ariel Elior <Ariel.Elior@cavium.com>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Code includes wmb() followed by writel() in multiple places. writel()
already has a barrier on some architectures like arm64.

This ends up CPU observing two barriers back to back before executing the
register write.

Since code already has an explicit barrier call, changing writel() to
writel_relaxed().

Signed-off-by: Sinan Kaya <okaya@codeaurora.org>
---
 drivers/infiniband/hw/qedr/verbs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/qedr/verbs.c b/drivers/infiniband/hw/qedr/verbs.c
index ccd55f4..db60360 100644
--- a/drivers/infiniband/hw/qedr/verbs.c
+++ b/drivers/infiniband/hw/qedr/verbs.c
@@ -860,7 +860,7 @@ static void doorbell_cq(struct qedr_cq *cq, u32 cons, u8 flags)
 	wmb();
 	cq->db.data.agg_flags = flags;
 	cq->db.data.value = cpu_to_le32(cons);
-	writeq(cq->db.raw, cq->db_addr);
+	writeq_relaxed(cq->db.raw, cq->db_addr);
 
 	/* Make sure write would stick */
 	mmiowb();
@@ -3338,7 +3338,7 @@ int qedr_post_recv(struct ib_qp *ibqp, struct ib_recv_wr *wr,
 
 		qp->rq.db_data.data.value++;
 
-		writel(qp->rq.db_data.raw, qp->rq.db);
+		writel_relaxed(qp->rq.db_data.raw, qp->rq.db);
 
 		/* Make sure write sticks */
 		mmiowb();
-- 
2.7.4
