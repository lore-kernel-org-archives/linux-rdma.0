From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH v3 3/6] InfiniBand-ocrdma: Returning only value constants in
 ocrdma_qp_state_change()
Date: Thu, 14 Jan 2016 18:45:22 +0100
Message-ID: <5697DEB2.7000900@users.sourceforge.net>
References: <566ABCD9.1060404@users.sourceforge.net>
 <567EDED5.4040201@users.sourceforge.net>
 <5697D865.5010507@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <5697D865.5010507@users.sourceforge.net>
Sender: kernel-janitors-owner@vger.kernel.org
To: linux-rdma@vger.kernel.org, Devesh Sharma <devesh.sharma@avagotech.com>, Doug Ledford <dledford@redhat.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Mitesh Ahuja <mitesh.ahuja@avagotech.com>, Sean Hefty <sean.hefty@intel.com>, Selvin Xavier <selvin.xavier@avagotech.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
List-Id: linux-rdma@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Thu, 14 Jan 2016 17:54:45 +0100

Return zero at the end without using the local variable "status".

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/infiniband/hw/ocrdma/ocrdma_hw.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
index 159b1d5..3766927 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
@@ -2138,7 +2138,6 @@ int ocrdma_qp_state_change(struct ocrdma_qp *qp, enum ib_qp_state new_ib_state,
 			   enum ib_qp_state *old_ib_state)
 {
 	unsigned long flags;
-	int status = 0;
 	enum ocrdma_qp_state new_state;
 	new_state = get_ocrdma_qp_state(new_ib_state);
 
@@ -2163,7 +2162,7 @@ int ocrdma_qp_state_change(struct ocrdma_qp *qp, enum ib_qp_state new_ib_state,
 	qp->state = new_state;
 
 	spin_unlock_irqrestore(&qp->q_lock, flags);
-	return status;
+	return 0;
 }
 
 static u32 ocrdma_set_create_qp_mbx_access_flags(struct ocrdma_qp *qp)
-- 
2.6.3

