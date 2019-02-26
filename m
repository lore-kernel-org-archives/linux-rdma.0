From: Dennis Dalessandro <dennis.dalessandro@intel.com>
Subject: [PATCH for-next 1/3] IB/rdmavt: Fix loopback send with invalidate
 ordering
Date: Tue, 26 Feb 2019 08:45:16 -0800
Message-ID: <20190226164508.31476.45134.stgit@scvm10.sc.intel.com>
References: <20190226164333.31476.43732.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20190226164333.31476.43732.stgit@scvm10.sc.intel.com>
Sender: stable-owner@vger.kernel.org
To: jgg@ziepe.ca, dledford@redhat.com
Cc: linux-rdma@vger.kernel.org, "Michael J. Ruhl" <michael.j.ruhl@intel.com>, Mike Marciniszyn <mike.marciniszyn@intel.com>, stable@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Mike Marciniszyn <mike.marciniszyn@intel.com>

The IBTA spec notes:

o9-5.2.1: For any HCA which supports SEND with Invalidate, upon receiving
an IETH, the Invalidate operation must not take place until after
the normal transport header validation checks have been successfully
completed.

The rdmavt loopback code does the validation after the invalidate.

Fix by relocating the operation specific logic for all SEND variants
until after the validity checks.

Cc: <stable@vger.kernel.org> #v4.20+
Reviewed-by: Michael J. Ruhl <michael.j.ruhl@intel.com>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
---
 drivers/infiniband/sw/rdmavt/qp.c |   26 ++++++++++++++++----------
 1 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/drivers/infiniband/sw/rdmavt/qp.c b/drivers/infiniband/sw/rdmavt/qp.c
index 72664f0..3373658 100644
--- a/drivers/infiniband/sw/rdmavt/qp.c
+++ b/drivers/infiniband/sw/rdmavt/qp.c
@@ -2898,18 +2898,8 @@ void rvt_ruc_loopback(struct rvt_qp *sqp)
 		goto send_comp;
 
 	case IB_WR_SEND_WITH_INV:
-		if (!rvt_invalidate_rkey(qp, wqe->wr.ex.invalidate_rkey)) {
-			wc.wc_flags = IB_WC_WITH_INVALIDATE;
-			wc.ex.invalidate_rkey = wqe->wr.ex.invalidate_rkey;
-		}
-		goto send;
-
 	case IB_WR_SEND_WITH_IMM:
-		wc.wc_flags = IB_WC_WITH_IMM;
-		wc.ex.imm_data = wqe->wr.ex.imm_data;
-		/* FALLTHROUGH */
 	case IB_WR_SEND:
-send:
 		ret = rvt_get_rwqe(qp, false);
 		if (ret < 0)
 			goto op_err;
@@ -2917,6 +2907,22 @@ void rvt_ruc_loopback(struct rvt_qp *sqp)
 			goto rnr_nak;
 		if (wqe->length > qp->r_len)
 			goto inv_err;
+		switch (wqe->wr.opcode) {
+		case IB_WR_SEND_WITH_INV:
+			if (!rvt_invalidate_rkey(qp,
+						 wqe->wr.ex.invalidate_rkey)) {
+				wc.wc_flags = IB_WC_WITH_INVALIDATE;
+				wc.ex.invalidate_rkey =
+					wqe->wr.ex.invalidate_rkey;
+			}
+			break;
+		case IB_WR_SEND_WITH_IMM:
+			wc.wc_flags = IB_WC_WITH_IMM;
+			wc.ex.imm_data = wqe->wr.ex.imm_data;
+			break;
+		default:
+			break;
+		}
 		break;
 
 	case IB_WR_RDMA_WRITE_WITH_IMM:
