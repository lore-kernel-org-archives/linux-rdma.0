From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 15/21] IB/hfi1: Use global defines for upper bits in opcode
Date: Tue, 12 Apr 2016 11:29:20 -0700
Message-ID: <20160412182909.27049.76434.stgit@scvm10.sc.intel.com>
References: <20160412174746.24485.92280.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160412174746.24485.92280.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The awkward coding for setting the allowed_ops field
was tripping an smatch warning.

This patch uses the more appropriate defines from include/rdma
to avoid the issue.

As part of the patch remove a mask that was duplicated
in rdmavt include files and use that mask as appropriate.

Fixes: 8bea6b1cfe6f ("IB/rdmavt: Add create queue pair functionality")
Reported-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/sw/rdmavt/qp.c |    6 +++---
 drivers/staging/rdma/hfi1/verbs.c |    2 +-
 drivers/staging/rdma/hfi1/verbs.h |    3 ---
 3 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/sw/rdmavt/qp.c b/drivers/infiniband/sw/rdmavt/qp.c
index a9e3bcc..0f12c21 100644
--- a/drivers/infiniband/sw/rdmavt/qp.c
+++ b/drivers/infiniband/sw/rdmavt/qp.c
@@ -829,13 +829,13 @@ struct ib_qp *rvt_create_qp(struct ib_pd *ibpd,
 	case IB_QPT_SMI:
 	case IB_QPT_GSI:
 	case IB_QPT_UD:
-		qp->allowed_ops = IB_OPCODE_UD_SEND_ONLY & RVT_OPCODE_QP_MASK;
+		qp->allowed_ops = IB_OPCODE_UD;
 		break;
 	case IB_QPT_RC:
-		qp->allowed_ops = IB_OPCODE_RC_SEND_ONLY & RVT_OPCODE_QP_MASK;
+		qp->allowed_ops = IB_OPCODE_RC;
 		break;
 	case IB_QPT_UC:
-		qp->allowed_ops = IB_OPCODE_UC_SEND_ONLY & RVT_OPCODE_QP_MASK;
+		qp->allowed_ops = IB_OPCODE_UC;
 		break;
 	default:
 		ret = ERR_PTR(-EINVAL);
diff --git a/drivers/staging/rdma/hfi1/verbs.c b/drivers/staging/rdma/hfi1/verbs.c
index c56c0cb..9cdc85f 100644
--- a/drivers/staging/rdma/hfi1/verbs.c
+++ b/drivers/staging/rdma/hfi1/verbs.c
@@ -545,7 +545,7 @@ static inline int qp_ok(int opcode, struct hfi1_packet *packet)
 
 	if (!(ib_rvt_state_ops[packet->qp->state] & RVT_PROCESS_RECV_OK))
 		goto dropit;
-	if (((opcode & OPCODE_QP_MASK) == packet->qp->allowed_ops) ||
+	if (((opcode & RVT_OPCODE_QP_MASK) == packet->qp->allowed_ops) ||
 	    (opcode == IB_OPCODE_CNP))
 		return 1;
 dropit:
diff --git a/drivers/staging/rdma/hfi1/verbs.h b/drivers/staging/rdma/hfi1/verbs.h
index 2ba1373..3ee2239 100644
--- a/drivers/staging/rdma/hfi1/verbs.h
+++ b/drivers/staging/rdma/hfi1/verbs.h
@@ -335,9 +335,6 @@ int hfi1_process_mad(struct ib_device *ibdev, int mad_flags, u8 port,
 #endif
 #define PSN_MODIFY_MASK 0xFFFFFF
 
-/* Number of bits to pay attention to in the opcode for checking qp type */
-#define OPCODE_QP_MASK 0xE0
-
 /*
  * Compare the lower 24 bits of the msn values.
  * Returns an integer <, ==, or > than zero.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
