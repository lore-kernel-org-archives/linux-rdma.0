From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 2/2] IB/qib,
 IB/hfi1: Fix MR reference count leak on write with immediate
Date: Fri, 12 May 2017 09:02:00 -0700
Message-ID: <20170512160142.27868.22033.stgit@scvm10.sc.intel.com>
References: <20170512155936.27868.7128.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170512155936.27868.7128.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Stable <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tadeusz Struk <tadeusz.struk-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

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

Cc: Stable <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org> # 4.7+
Tested-by: Tadeusz Struk <tadeusz.struk-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/rc.c    |    5 ++++-
 drivers/infiniband/hw/qib/qib_rc.c |    4 +++-
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/rc.c b/drivers/infiniband/hw/hfi1/rc.c
index 069bdaf..1080778 100644
--- a/drivers/infiniband/hw/hfi1/rc.c
+++ b/drivers/infiniband/hw/hfi1/rc.c
@@ -2159,8 +2159,11 @@ void hfi1_rc_rcv(struct hfi1_packet *packet)
 		ret = hfi1_rvt_get_rwqe(qp, 1);
 		if (ret < 0)
 			goto nack_op_err;
-		if (!ret)
+		if (!ret) {
+			/* peer will send again */
+			rvt_put_ss(&qp->r_sge);
 			goto rnr_nak;
+		}
 		wc.ex.imm_data = ohdr->u.rc.imm_data;
 		wc.wc_flags = IB_WC_WITH_IMM;
 		goto send_last;
diff --git a/drivers/infiniband/hw/qib/qib_rc.c b/drivers/infiniband/hw/qib/qib_rc.c
index fc8b885..4ddbcac 100644
--- a/drivers/infiniband/hw/qib/qib_rc.c
+++ b/drivers/infiniband/hw/qib/qib_rc.c
@@ -1956,8 +1956,10 @@ void qib_rc_rcv(struct qib_ctxtdata *rcd, struct ib_header *hdr,
 		ret = qib_get_rwqe(qp, 1);
 		if (ret < 0)
 			goto nack_op_err;
-		if (!ret)
+		if (!ret) {
+			rvt_put_ss(&qp->r_sge);
 			goto rnr_nak;
+		}
 		wc.ex.imm_data = ohdr->u.rc.imm_data;
 		hdrsize += 4;
 		wc.wc_flags = IB_WC_WITH_IMM;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
