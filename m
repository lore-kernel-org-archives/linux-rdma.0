From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 4/5] staging/rdma/hfi1: add unique rnr timer
Date: Thu, 04 Feb 2016 10:59:27 -0800
Message-ID: <20160204185923.6973.30849.stgit@scvm10.sc.intel.com>
References: <20160204185718.6973.92668.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160204185718.6973.92668.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Add a new rnr timer to hfi1.

This allows for future optimizations having the
retry and rnr timers separate.

Reviewed-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/qp.c    |    2 +-
 drivers/staging/rdma/hfi1/rc.c    |    2 +-
 drivers/staging/rdma/hfi1/verbs.h |    2 ++
 3 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/qp.c b/drivers/staging/rdma/hfi1/qp.c
index 1a34e6e..e138d43 100644
--- a/drivers/staging/rdma/hfi1/qp.c
+++ b/drivers/staging/rdma/hfi1/qp.c
@@ -608,7 +608,7 @@ void *qp_priv_alloc(struct rvt_dev_info *rdi, struct rvt_qp *qp,
 		kfree(priv);
 		return ERR_PTR(-ENOMEM);
 	}
-
+	setup_timer(&priv->s_rnr_timer, hfi1_rc_rnr_retry, (unsigned long)qp);
 	return priv;
 }
 
diff --git a/drivers/staging/rdma/hfi1/rc.c b/drivers/staging/rdma/hfi1/rc.c
index 700d849..1ff19aa 100644
--- a/drivers/staging/rdma/hfi1/rc.c
+++ b/drivers/staging/rdma/hfi1/rc.c
@@ -164,7 +164,7 @@ static inline int hfi1_stop_rnr_timer(struct rvt_qp *qp)
  * hfi1_del_timers_sync - wait for any timeout routines to exit
  * @qp - the QP
  */
-static inline void hfi1_del_timers_sync(struct rvt_qp *qp)
+void hfi1_del_timers_sync(struct rvt_qp *qp)
 {
 	del_timer_sync(&qp->s_timer);
 }
diff --git a/drivers/staging/rdma/hfi1/verbs.h b/drivers/staging/rdma/hfi1/verbs.h
index 335e3a8..6294fa8 100644
--- a/drivers/staging/rdma/hfi1/verbs.h
+++ b/drivers/staging/rdma/hfi1/verbs.h
@@ -210,6 +210,7 @@ struct hfi1_qp_priv {
 	u8 s_sc;		     /* SC[0..4] for next packet */
 	u8 r_adefered;               /* number of acks defered */
 	struct iowait s_iowait;
+	struct timer_list s_rnr_timer;
 	struct rvt_qp *owner;
 };
 
@@ -403,6 +404,7 @@ u8 ah_to_sc(struct ib_device *ibdev, struct ib_ah_attr *ah_attr);
 struct ib_ah *hfi1_create_qp0_ah(struct hfi1_ibport *ibp, u16 dlid);
 
 void hfi1_rc_rnr_retry(unsigned long arg);
+void hfi1_del_timers_sync(struct rvt_qp *qp);
 
 void hfi1_rc_send_complete(struct rvt_qp *qp, struct hfi1_ib_header *hdr);
 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
