From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH] IB/hfi1: Add missing break in switch statement
Date: Wed, 20 Feb 2019 19:02:33 -0600
Message-ID: <20190221010233.GA29228@embeddedor>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Kaike Wan <kaike.wan@intel.com>, Mike Marciniszyn <mike.marciniszyn@intel.com>, Dennis Dalessandro <dennis.dalessandro@intel.com>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, "Gustavo A. R. Silva" <gustavo@embeddedor.com>, Kees Cook <keescook@chromium.org>
List-Id: linux-rdma@vger.kernel.org

Fix the following warning by adding a missing break:

drivers/infiniband/hw/hfi1/tid_rdma.c: In function ‘hfi1_tid_rdma_wqe_interlock’:
drivers/infiniband/hw/hfi1/tid_rdma.c:3251:3: warning: this statement may fall through [-Wimplicit-fallthrough=]
   switch (prev->wr.opcode) {
   ^~~~~~
drivers/infiniband/hw/hfi1/tid_rdma.c:3259:2: note: here
  case IB_WR_RDMA_READ:
  ^~~~

Warning level 3 was used: -Wimplicit-fallthrough=3

This patch is part of the ongoing efforts to enable
-Wimplicit-fallthrough.

Fixes: c6c231175ccd ("IB/hfi1: Add interlock between TID RDMA WRITE and other requests")
Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/infiniband/hw/hfi1/tid_rdma.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/hw/hfi1/tid_rdma.c b/drivers/infiniband/hw/hfi1/tid_rdma.c
index bc2ff83026f7..fdda33aca77f 100644
--- a/drivers/infiniband/hw/hfi1/tid_rdma.c
+++ b/drivers/infiniband/hw/hfi1/tid_rdma.c
@@ -3256,6 +3256,7 @@ bool hfi1_tid_rdma_wqe_interlock(struct rvt_qp *qp, struct rvt_swqe *wqe)
 		default:
 			break;
 		}
+		break;
 	case IB_WR_RDMA_READ:
 		if (prev->wr.opcode != IB_WR_TID_RDMA_WRITE)
 			break;
-- 
2.20.1
