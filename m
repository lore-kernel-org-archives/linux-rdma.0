From: Sinan Kaya <okaya@codeaurora.org>
Subject: [PATCH 3/7] RDMA/qedr: eliminate duplicate barriers on weakly-ordered archs
Date: Tue, 13 Mar 2018 23:20:24 -0400
Message-ID: <1520997629-17361-3-git-send-email-okaya@codeaurora.org>
References: <1520997629-17361-1-git-send-email-okaya@codeaurora.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1520997629-17361-1-git-send-email-okaya@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: netdev@vger.kernel.org, timur@codeaurora.org, sulrich@codeaurora.org
Cc: linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Sinan Kaya <okaya@codeaurora.org>, Michal Kalderon <Michal.Kalderon@cavium.com>, Ariel Elior <Ariel.Elior@cavium.com>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
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
index 53f00db..ccd55f4 100644
--- a/drivers/infiniband/hw/qedr/verbs.c
+++ b/drivers/infiniband/hw/qedr/verbs.c
@@ -1870,7 +1870,7 @@ static int qedr_update_qp_state(struct qedr_dev *dev,
 
 			if (rdma_protocol_roce(&dev->ibdev, 1)) {
 				wmb();
-				writel(qp->rq.db_data.raw, qp->rq.db);
+				writel_relaxed(qp->rq.db_data.raw, qp->rq.db);
 				/* Make sure write takes effect */
 				mmiowb();
 			}
@@ -3247,7 +3247,7 @@ int qedr_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 	 * redundant doorbell.
 	 */
 	wmb();
-	writel(qp->sq.db_data.raw, qp->sq.db);
+	writel_relaxed(qp->sq.db_data.raw, qp->sq.db);
 
 	/* Make sure write sticks */
 	mmiowb();
-- 
2.7.4
