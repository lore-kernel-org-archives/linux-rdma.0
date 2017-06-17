From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 1/2] IB/rdmavt: Setting of QP timeout can overflow
 jiffies computation
Date: Sat, 17 Jun 2017 10:37:26 -0700
Message-ID: <20170617173723.17658.85726.stgit@scvm10.sc.intel.com>
References: <20170617173620.17658.5173.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170617173620.17658.5173.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Current computation of qp->timeout_jiffies in rvt_modify_qp() will cause
overflow due to the fact that the input to the function usecs_to_jiffies
is only 32-bit ( unsigned int). Overflow will occur when attr->timeout is
equal to or greater than 30. The consequence is unnecessarily excessive
retry and thus degradation of the system performance.

This patch fixes the problem by limiting the input to 5-bit and calling
usecs_to_jiffies() before multiplying the scaling factor.

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/sw/rdmavt/qp.c |    4 +---
 include/rdma/rdmavt_qp.h          |   14 ++++++++++++++
 2 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/sw/rdmavt/qp.c b/drivers/infiniband/sw/rdmavt/qp.c
index 2ce0928..17b2eb0 100644
--- a/drivers/infiniband/sw/rdmavt/qp.c
+++ b/drivers/infiniband/sw/rdmavt/qp.c
@@ -1284,9 +1284,7 @@ int rvt_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 
 	if (attr_mask & IB_QP_TIMEOUT) {
 		qp->timeout = attr->timeout;
-		qp->timeout_jiffies =
-			usecs_to_jiffies((4096UL * (1UL << qp->timeout)) /
-				1000UL);
+		qp->timeout_jiffies = rvt_timeout_to_jiffies(qp->timeout);
 	}
 
 	if (attr_mask & IB_QP_QKEY)
diff --git a/include/rdma/rdmavt_qp.h b/include/rdma/rdmavt_qp.h
index 13f43b3..07e2fff 100644
--- a/include/rdma/rdmavt_qp.h
+++ b/include/rdma/rdmavt_qp.h
@@ -647,6 +647,20 @@ static inline u32 rvt_div_mtu(struct rvt_qp *qp, u32 len)
 	return len >> qp->log_pmtu;
 }
 
+/**
+ * rvt_timeout_to_jiffies - Convert a ULP timeout input into jiffies
+ * @timeout - timeout input(0 - 31).
+ *
+ * Return a timeout value in jiffies.
+ */
+static inline unsigned long rvt_timeout_to_jiffies(u8 timeout)
+{
+	if (timeout > 31)
+		timeout = 31;
+
+	return usecs_to_jiffies(1U << timeout) * 4096UL / 1000UL;
+}
+
 extern const int  ib_rvt_state_ops[];
 
 struct rvt_dev_info;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
