From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] RDMA/qib: Fix MR reference count leak on write with
 immediate
Date: Tue, 06 Jun 2017 11:02:44 -0400
Message-ID: <20170606150244.14663.71707.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stable-commits-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

commit 1feb40067cf04ae48d65f728d62ca255c9449178 upstream.

The handling of IB_RDMA_WRITE_ONLY_WITH_IMMEDIATE will leak a memory
reference when a buffer cannot be allocated for returning the immediate
data.

The issue is that the rkey validation has already occurred and the RNR
nak fails to release the reference that was fruitlessly gotten.  The
the peer will send the identical single packet request when its RNR
timer pops.

The fix is to release the held reference prior to the rnr nak exit.
This is the only sequence the requires both rkey validation and the
buffer allocation on the same packet.

[This backports the fix for pre-rdmavt based qib drivers]

Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org> # 3.10.x,3.16.x,4.1.x,4.4.x
Tested-by: Tadeusz Struk <tadeusz.struk-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib_rc.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/qib/qib_rc.c b/drivers/infiniband/hw/qib/qib_rc.c
index e6b7556..cbc4216 100644
--- a/drivers/infiniband/hw/qib/qib_rc.c
+++ b/drivers/infiniband/hw/qib/qib_rc.c
@@ -2088,8 +2088,10 @@ send_last:
 		ret = qib_get_rwqe(qp, 1);
 		if (ret < 0)
 			goto nack_op_err;
-		if (!ret)
+		if (!ret) {
+			qib_put_ss(&qp->r_sge);
 			goto rnr_nak;
+		}
 		wc.ex.imm_data = ohdr->u.rc.imm_data;
 		hdrsize += 4;
 		wc.wc_flags = IB_WC_WITH_IMM;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
