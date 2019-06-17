From: Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH trivial] IB/hfi1: Spelling s/statisfied/satisfied/
Date: Mon, 17 Jun 2019 16:01:38 +0200
Message-ID: <20190617140138.734-1-geert+renesas@glider.be>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Marciniszyn <mike.marciniszyn@intel.com>, Dennis Dalessandro <dennis.dalessandro@intel.com>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, Jiri Kosina <trivial@kernel.org>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert+renesas@glider.be>
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 drivers/infiniband/hw/hfi1/tid_rdma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/hfi1/tid_rdma.c b/drivers/infiniband/hw/hfi1/tid_rdma.c
index 6fb93032fbefcb7e..24f30ff6b5fbc868 100644
--- a/drivers/infiniband/hw/hfi1/tid_rdma.c
+++ b/drivers/infiniband/hw/hfi1/tid_rdma.c
@@ -477,7 +477,7 @@ static struct rvt_qp *first_qp(struct hfi1_ctxtdata *rcd,
  * Must hold the qp s_lock and the exp_lock.
  *
  * Return:
- * false if either of the conditions below are statisfied:
+ * false if either of the conditions below are satisfied:
  * 1. The list is empty or
  * 2. The indicated qp is at the head of the list and the
  *    HFI1_S_WAIT_TID_SPACE bit is set in qp->s_flags.
-- 
2.17.1
