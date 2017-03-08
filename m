From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 09/26] IB/ocrdma: Improve another size determination in
 ocrdma_mq_cq_handler()
Date: Wed, 8 Mar 2017 14:00:56 +0100
Message-ID: <62b28436-076d-588d-49c7-da2a69239fe5@users.sourceforge.net>
References: <fc421509-4069-da8a-b308-60b49ea91ada@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <fc421509-4069-da8a-b308-60b49ea91ada@users.sourceforge.net>
Sender: kernel-janitors-owner@vger.kernel.org
To: linux-rdma@vger.kernel.org, Devesh Sharma <devesh.sharma@avagotech.com>, Doug Ledford <dledford@redhat.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Sean Hefty <sean.hefty@intel.com>, Selvin Xavier <selvin.xavier@avagotech.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Tue, 7 Mar 2017 20:20:45 +0100

Replace the specification of a data structure by a pointer dereference
as the parameter for the operator "sizeof" to make the corresponding size
determination a bit safer according to the Linux coding style convention.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/infiniband/hw/ocrdma/ocrdma_hw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
index 0628600bee56..7d1e1caa90de 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
@@ -890,7 +890,7 @@ static int ocrdma_mq_cq_handler(struct ocrdma_dev *dev, u16 cq_id)
 			ocrdma_process_acqe(dev, cqe);
 		else if (cqe->valid_ae_cmpl_cons & OCRDMA_MCQE_CMPL_MASK)
 			ocrdma_process_mcqe(dev, cqe);
-		memset(cqe, 0, sizeof(struct ocrdma_mcqe));
+		memset(cqe, 0, sizeof(*cqe));
 		ocrdma_mcq_inc_tail(dev);
 	}
 	ocrdma_ring_cq_db(dev, dev->mq.cq.id, true, false, cqe_popped);
-- 
2.12.0

