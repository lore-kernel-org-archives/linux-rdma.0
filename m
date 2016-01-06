From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v3 30/36] IB/rdmavt: Move SRQ data structure into rdmavt
Date: Wed, 06 Jan 2016 10:04:06 -0800
Message-ID: <20160106180404.8747.58155.stgit@scvm10.sc.intel.com>
References: <20160106174638.8747.47197.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160106174638.8747.47197.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Patch moves the srq data structure into rdmavt in preparation for
removal from qib and hfi1 which will follow in subsequent patches.

Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 include/rdma/rdma_vt.h |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/include/rdma/rdma_vt.h b/include/rdma/rdma_vt.h
index 36cced6..fcf3ec0 100644
--- a/include/rdma/rdma_vt.h
+++ b/include/rdma/rdma_vt.h
@@ -349,6 +349,14 @@ struct rvt_qp {
 		____cacheline_aligned_in_smp;
 };
 
+struct rvt_srq {
+	struct ib_srq ibsrq;
+	struct rvt_rq rq;
+	struct rvt_mmap_info *ip;
+	/* send signal when number of RWQEs < limit */
+	u32 limit;
+};
+
 /* End QP section */
 
 /*
@@ -485,6 +493,11 @@ static inline void rvt_get_mr(struct rvt_mregion *mr)
 	atomic_inc(&mr->refcount);
 }
 
+static inline struct rvt_srq *ibsrq_to_rvtsrq(struct ib_srq *ibsrq)
+{
+	return container_of(ibsrq, struct rvt_srq, ibsrq);
+}
+
 int rvt_register_device(struct rvt_dev_info *rvd);
 void rvt_unregister_device(struct rvt_dev_info *rvd);
 int rvt_check_ah(struct ib_device *ibdev, struct ib_ah_attr *ah_attr);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
