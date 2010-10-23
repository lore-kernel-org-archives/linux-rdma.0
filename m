From: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] IB/qib: fix RDMA write with immediate
Date: Fri, 22 Oct 2010 17:10:22 -0700
Message-ID: <20101023001021.30700.54337.stgit@chromite.mv.qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The immediate word for RDMA_WRITE_ONLY_WITH_IMMEDIATE was being
extracted from the wrong location in the header.
Thanks to Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> for
finding this.

Signed-off-by: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
---

 drivers/infiniband/hw/qib/qib_rc.c |    5 ++++-
 drivers/infiniband/hw/qib/qib_uc.c |    6 ++++--
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_rc.c b/drivers/infiniband/hw/qib/qib_rc.c
index a093111..955fb71 100644
--- a/drivers/infiniband/hw/qib/qib_rc.c
+++ b/drivers/infiniband/hw/qib/qib_rc.c
@@ -2068,7 +2068,10 @@ send_last:
 			goto nack_op_err;
 		if (!ret)
 			goto rnr_nak;
-		goto send_last_imm;
+		wc.ex.imm_data = ohdr->u.rc.imm_data;
+		hdrsize += 4;
+		wc.wc_flags = IB_WC_WITH_IMM;
+		goto send_last;
 
 	case OP(RDMA_READ_REQUEST): {
 		struct qib_ack_entry *e;
diff --git a/drivers/infiniband/hw/qib/qib_uc.c b/drivers/infiniband/hw/qib/qib_uc.c
index b9c8b63..aecd512 100644
--- a/drivers/infiniband/hw/qib/qib_uc.c
+++ b/drivers/infiniband/hw/qib/qib_uc.c
@@ -457,8 +457,10 @@ rdma_first:
 		}
 		if (opcode == OP(RDMA_WRITE_ONLY))
 			goto rdma_last;
-		else if (opcode == OP(RDMA_WRITE_ONLY_WITH_IMMEDIATE))
+		if (opcode == OP(RDMA_WRITE_ONLY_WITH_IMMEDIATE)) {
+			wc.ex.imm_data = ohdr->u.rc.imm_data;
 			goto rdma_last_imm;
+		}
 		/* FALLTHROUGH */
 	case OP(RDMA_WRITE_MIDDLE):
 		/* Check for invalid length PMTU or posted rwqe len. */
@@ -471,8 +473,8 @@ rdma_first:
 		break;
 
 	case OP(RDMA_WRITE_LAST_WITH_IMMEDIATE):
-rdma_last_imm:
 		wc.ex.imm_data = ohdr->u.imm_data;
+rdma_last_imm:
 		hdrsize += 4;
 		wc.wc_flags = IB_WC_WITH_IMM;
 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
