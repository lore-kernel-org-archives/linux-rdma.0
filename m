From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 25/27] IB/hfi1: Add rvt_rnr_tbl_to_usec function
Date: Wed, 08 Feb 2017 05:28:19 -0800
Message-ID: <20170208132818.16442.38634.stgit@scvm10.sc.intel.com>
References: <20170208132142.16442.69329.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170208132142.16442.69329.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Return usec from an index into ib_rvt_rnr_table.

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/sw/rdmavt/qp.c |   11 +++++++++++
 include/rdma/rdmavt_qp.h          |    1 +
 2 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/sw/rdmavt/qp.c b/drivers/infiniband/sw/rdmavt/qp.c
index db4315f..0b97598 100644
--- a/drivers/infiniband/sw/rdmavt/qp.c
+++ b/drivers/infiniband/sw/rdmavt/qp.c
@@ -1954,6 +1954,17 @@ void rvt_rc_error(struct rvt_qp *qp, enum ib_wc_status err)
 }
 EXPORT_SYMBOL(rvt_rc_error);
 
+/*
+ *  rvt_rnr_tbl_to_usec - return index into ib_rvt_rnr_table
+ *  @index - the index
+ *  return usec from an index into ib_rvt_rnr_table
+ */
+unsigned long rvt_rnr_tbl_to_usec(u32 index)
+{
+	return ib_rvt_rnr_table[(index & RVT_AETH_CREDIT_MASK)];
+}
+EXPORT_SYMBOL(rvt_rnr_tbl_to_usec);
+
 static inline unsigned long rvt_aeth_to_usec(u32 aeth)
 {
 	return ib_rvt_rnr_table[(aeth >> RVT_AETH_CREDIT_SHIFT) &
diff --git a/include/rdma/rdmavt_qp.h b/include/rdma/rdmavt_qp.h
index 2f91fae..9767549 100644
--- a/include/rdma/rdmavt_qp.h
+++ b/include/rdma/rdmavt_qp.h
@@ -653,6 +653,7 @@ static inline u32 rvt_div_mtu(struct rvt_qp *qp, u32 len)
 void rvt_comm_est(struct rvt_qp *qp);
 int rvt_error_qp(struct rvt_qp *qp, enum ib_wc_status err);
 void rvt_rc_error(struct rvt_qp *qp, enum ib_wc_status err);
+unsigned long rvt_rnr_tbl_to_usec(u32 index);
 enum hrtimer_restart rvt_rc_rnr_retry(struct hrtimer *t);
 void rvt_add_rnr_timer(struct rvt_qp *qp, u32 aeth);
 void rvt_del_timers_sync(struct rvt_qp *qp);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
