From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 3/6] IB/rdmavt: Annotate rvt_reset_qp()
Date: Fri, 3 Jun 2016 12:09:16 -0700
Message-ID: <cc801b9e-589a-d301-7d54-cbb6067fae7b@sandisk.com>
References: <86c06ca1-753c-6b45-3f65-f9a19f7693cf@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <86c06ca1-753c-6b45-3f65-f9a19f7693cf-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This patch avoids that sparse reports the following warning:

rdmavt/qp.c:507:17: warning: context imbalance in 'rvt_reset_qp' - unexpected unlock

Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/sw/rdmavt/qp.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/infiniband/sw/rdmavt/qp.c b/drivers/infiniband/sw/rdmavt/qp.c
index 5fa4d4d..7de5134 100644
--- a/drivers/infiniband/sw/rdmavt/qp.c
+++ b/drivers/infiniband/sw/rdmavt/qp.c
@@ -502,6 +502,12 @@ static void rvt_remove_qp(struct rvt_dev_info *rdi, struct rvt_qp *qp)
  */
 static void rvt_reset_qp(struct rvt_dev_info *rdi, struct rvt_qp *qp,
 		  enum ib_qp_type type)
+	__releases(&qp->s_lock)
+	__releases(&qp->s_hlock)
+	__releases(&qp->r_lock)
+	__acquires(&qp->r_lock)
+	__acquires(&qp->s_hlock)
+	__acquires(&qp->s_lock)
 {
 	if (qp->state != IB_QPS_RESET) {
 		qp->state = IB_QPS_RESET;
-- 
2.8.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
