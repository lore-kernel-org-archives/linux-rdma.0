From: Sinan Kaya <okaya@codeaurora.org>
Subject: [PATCH v6] RDMA/qedr: eliminate duplicate barriers on weakly-ordered archs #2
Date: Thu, 22 Mar 2018 12:30:44 -0400
Message-ID: <1521736245-23662-1-git-send-email-okaya@codeaurora.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
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
 drivers/infiniband/hw/qedr/verbs.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/qedr/verbs.c b/drivers/infiniband/hw/qedr/verbs.c
index 53f00db..d1cf9a0 100644
--- a/drivers/infiniband/hw/qedr/verbs.c
+++ b/drivers/infiniband/hw/qedr/verbs.c
@@ -35,6 +35,7 @@
 #include <net/ipv6.h>
 #include <net/udp.h>
 #include <linux/iommu.h>
+#include <linux/io-64-nonatomic-hi-lo.h>
 
 #include <rdma/ib_verbs.h>
 #include <rdma/ib_user_verbs.h>
@@ -860,7 +861,7 @@ static void doorbell_cq(struct qedr_cq *cq, u32 cons, u8 flags)
 	wmb();
 	cq->db.data.agg_flags = flags;
 	cq->db.data.value = cpu_to_le32(cons);
-	writeq(cq->db.raw, cq->db_addr);
+	writeq_relaxed(cq->db.raw, cq->db_addr);
 
 	/* Make sure write would stick */
 	mmiowb();
@@ -3338,7 +3339,7 @@ int qedr_post_recv(struct ib_qp *ibqp, struct ib_recv_wr *wr,
 
 		qp->rq.db_data.data.value++;
 
-		writel(qp->rq.db_data.raw, qp->rq.db);
+		writel_relaxed(qp->rq.db_data.raw, qp->rq.db);
 
 		/* Make sure write sticks */
 		mmiowb();
-- 
2.7.4
