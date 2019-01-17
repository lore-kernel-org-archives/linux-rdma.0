From: Dennis Dalessandro <dennis.dalessandro@intel.com>
Subject: [PATCH for-rc 7/7] IB/hfi1: Add limit test for RC/UC send via
 loopback
Date: Thu, 17 Jan 2019 12:42:16 -0800
Message-ID: <20190117204209.30826.62040.stgit@scvm10.sc.intel.com>
References: <20190117203920.30826.76720.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20190117203920.30826.76720.stgit@scvm10.sc.intel.com>
Sender: stable-owner@vger.kernel.org
To: jgg@ziepe.ca, dledford@redhat.com
Cc: linux-rdma@vger.kernel.org, "Michael J. Ruhl" <michael.j.ruhl@intel.com>, Mike Marciniszyn <mike.marciniszyn@intel.com>, stable@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Mike Marciniszyn <mike.marciniszyn@intel.com>

Fix potential memory corruption and panic in loopback for
IB_WR_SEND variants.

The code blindly assumes the posted length will fit in the
fetched rwqe, which is not a valid assumption.

Fix by adding a limit test, and triggering the appropriate
send completion and putting the QP in an error state.  This
mimics the handling for non-loopback QPs.

Fixes: 15703461533a ("IB/{hfi1, qib, rdmavt}: Move ruc_loopback to rdmavt")
Cc: <stable@vger.kernel.org> #v4.20+
Reviewed-by: Michael J. Ruhl <michael.j.ruhl@intel.com>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
---
 drivers/infiniband/sw/rdmavt/qp.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/sw/rdmavt/qp.c b/drivers/infiniband/sw/rdmavt/qp.c
index a1bd8cf..c6cc3e4 100644
--- a/drivers/infiniband/sw/rdmavt/qp.c
+++ b/drivers/infiniband/sw/rdmavt/qp.c
@@ -2910,6 +2910,8 @@ void rvt_ruc_loopback(struct rvt_qp *sqp)
 			goto op_err;
 		if (!ret)
 			goto rnr_nak;
+		if (wqe->length > qp->r_len)
+			goto inv_err;
 		break;
 
 	case IB_WR_RDMA_WRITE_WITH_IMM:
@@ -3078,7 +3080,10 @@ void rvt_ruc_loopback(struct rvt_qp *sqp)
 	goto err;
 
 inv_err:
-	send_status = IB_WC_REM_INV_REQ_ERR;
+	send_status =
+		sqp->ibqp.qp_type == IB_QPT_RC ?
+			IB_WC_REM_INV_REQ_ERR :
+			IB_WC_SUCCESS;
 	wc.status = IB_WC_LOC_QP_OP_ERR;
 	goto err;
 
