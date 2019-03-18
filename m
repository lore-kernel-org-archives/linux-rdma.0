From: Dennis Dalessandro <dennis.dalessandro@intel.com>
Subject: [PATCH for-rc 2/5] IB/hfi1: Failed to drain send queue when QP is
 put into error state
Date: Mon, 18 Mar 2019 09:55:19 -0700
Message-ID: <20190318165514.23550.89083.stgit@scvm10.sc.intel.com>
References: <20190318165205.23550.97894.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20190318165205.23550.97894.stgit@scvm10.sc.intel.com>
Sender: stable-owner@vger.kernel.org
To: jgg@ziepe.ca, dledford@redhat.com
Cc: linux-rdma@vger.kernel.org, Mike Marciniszyn <mike.marciniszyn@intel.com>, Alex Estrin <alex.estrin@intel.com>, stable@vger.kernel.org, Kaike Wan <kaike.wan@intel.com>
List-Id: linux-rdma@vger.kernel.org

From: Kaike Wan <kaike.wan@intel.com>

When a QP is put into error state, all pending requests in the send
work queue should be drained. The following sequence of events could
lead to a failure, causing a request to hang:
(1) The QP builds a packet and tries to send through SDMA engine.
However, PIO engine is still busy. Consequently, this packet is put
on the QP's tx list and the QP is put on the PIO waiting list. The
field qp->s_flags is set with HFI1_S_WAIT_PIO_DRAIN;
(2) The QP is put into error state by the user application and
notify_error_qp() is called, which removes the QP from the PIO waiting
list and the packet from the QP's tx list. In addition, qp->s_flags
is cleared of RVT_S_ANY_WAIT_IO bits, which does not include
HFI1_S_WAIT_PIO_DRAIN bit;
(3) The hfi1_schdule_send() function is called to drain the QP's send
queue. Subsequently, hfi1_do_send() is called. Since the flag bit
HFI1_S_WAIT_PIO_DRAIN is set in qp->s_flags, hfi1_send_ok() fails.
As a result, hfi1_do_send() bails out without draining any request
from the send queue;
(4) The PIO engine completes the sending and tries to wake up any QP
on its waiting list. But the QP has been removed from the PIO waiting
list and therefore is kept in sleep forever.

The fix is to clear qp->s_flags of HFI1_S_ANY_WAIT_IO bits in step (2).
HFI1_S_ANY_WAIT_IO includes RVT_S_ANY_WAIT_IO and HFI1_S_WAIT_PIO_DRAIN.


Fixes: 2e2ba09e48b7 ("IB/rdmavt, IB/hfi1: Create device dependent s_flags")
Cc: <stable@vger.kernel.org> # 4.19.x+
Reviewed-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Reviewed-by: Alex Estrin <alex.estrin@intel.com>
Signed-off-by: Kaike Wan <kaike.wan@intel.com>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
---
 drivers/infiniband/hw/hfi1/qp.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/qp.c b/drivers/infiniband/hw/hfi1/qp.c
index 9b643c2..64889ed 100644
--- a/drivers/infiniband/hw/hfi1/qp.c
+++ b/drivers/infiniband/hw/hfi1/qp.c
@@ -898,7 +898,7 @@ void notify_error_qp(struct rvt_qp *qp)
 		if (!list_empty(&priv->s_iowait.list) &&
 		    !(qp->s_flags & RVT_S_BUSY) &&
 		    !(priv->s_flags & RVT_S_BUSY)) {
-			qp->s_flags &= ~RVT_S_ANY_WAIT_IO;
+			qp->s_flags &= ~HFI1_S_ANY_WAIT_IO;
 			list_del_init(&priv->s_iowait.list);
 			priv->s_iowait.lock = NULL;
 			rvt_put_qp(qp);
