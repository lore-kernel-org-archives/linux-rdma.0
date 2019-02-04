From: Mike Marciniszyn <mike.marciniszyn@intel.com>
Subject: [PATCH] IB/{hfi1,qib}: Add limit test for RC/UC send via loopback
Date: Mon, 04 Feb 2019 07:36:42 -0800
Message-ID: <20190204153639.2555.41856.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: stable@vger.kernel.org
Cc: linux-rdma@vger.kernel.org, stable-commits@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Upstream commit 09ce351dff8e7636af0beb72cd4a86c3904a0500.

Fix potential memory corruption and panic in loopback for
IB_WR_SEND varaiants.

The code blindly assumes the posted length will fit in the
fetched rwqe, which is not a valid assumption.

Fix by adding a limit test, and triggering the appropriate
send completion and putting the QP in an error state.  This
mimics the handling for non-loopback QPs.

[ported to older kernels where the loopback was in each driver]

Cc: <stable@vger.kernel.org> #v4.9+
Fixes: 7724105686e7 ("IB/hfi1: add driver files")
Reviewed-by: Michael J. Ruhl <michael.j.ruhl@intel.com>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
---
 drivers/infiniband/hw/hfi1/ruc.c    |    7 ++++++-
 drivers/infiniband/hw/qib/qib_ruc.c |    7 ++++++-
 2 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/ruc.c b/drivers/infiniband/hw/hfi1/ruc.c
index 5f56f3c..62a3832 100644
--- a/drivers/infiniband/hw/hfi1/ruc.c
+++ b/drivers/infiniband/hw/hfi1/ruc.c
@@ -278,6 +278,8 @@ static void ruc_loopback(struct rvt_qp *sqp)
 			goto op_err;
 		if (!ret)
 			goto rnr_nak;
+		if (wqe->length > qp->r_len)
+			goto inv_err;
 		break;
 
 	case IB_WR_RDMA_WRITE_WITH_IMM:
@@ -445,7 +447,10 @@ static void ruc_loopback(struct rvt_qp *sqp)
 	goto err;
 
 inv_err:
-	send_status = IB_WC_REM_INV_REQ_ERR;
+	send_status =
+		sqp->ibqp.qp_type == IB_QPT_RC ?
+			IB_WC_REM_INV_REQ_ERR :
+			IB_WC_SUCCESS;
 	wc.status = IB_WC_LOC_QP_OP_ERR;
 	goto err;
 
diff --git a/drivers/infiniband/hw/qib/qib_ruc.c b/drivers/infiniband/hw/qib/qib_ruc.c
index f8a7de7..563f71e 100644
--- a/drivers/infiniband/hw/qib/qib_ruc.c
+++ b/drivers/infiniband/hw/qib/qib_ruc.c
@@ -274,6 +274,8 @@ static void qib_ruc_loopback(struct rvt_qp *sqp)
 			goto op_err;
 		if (!ret)
 			goto rnr_nak;
+		if (wqe->length > qp->r_len)
+			goto inv_err;
 		break;
 
 	case IB_WR_RDMA_WRITE_WITH_IMM:
@@ -434,7 +436,10 @@ static void qib_ruc_loopback(struct rvt_qp *sqp)
 	goto err;
 
 inv_err:
-	send_status = IB_WC_REM_INV_REQ_ERR;
+	send_status =
+		sqp->ibqp.qp_type == IB_QPT_RC ?
+			IB_WC_REM_INV_REQ_ERR :
+			IB_WC_SUCCESS;
 	wc.status = IB_WC_LOC_QP_OP_ERR;
 	goto err;
 
