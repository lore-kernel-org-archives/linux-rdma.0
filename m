From: Wei Yongjun <weiyj.lk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2] IB/hfi1: Using kfree_rcu() to simplify the code
Date: Wed, 10 Aug 2016 03:14:04 +0000
Message-ID: <1470798844-30421-1-git-send-email-weiyj.lk@gmail.com>
References: <1470649818-30040-1-git-send-email-weiyj.lk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1470649818-30040-1-git-send-email-weiyj.lk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Wei Yongjun <weiyj.lk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The callback function of call_rcu() just calls a kfree(), so we
can use kfree_rcu() instead of call_rcu() + callback function.

Signed-off-by: Wei Yongjun <weiyj.lk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/hfi.h  | 1 -
 drivers/infiniband/hw/hfi1/init.c | 2 +-
 drivers/infiniband/hw/hfi1/mad.c  | 9 +--------
 3 files changed, 2 insertions(+), 10 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/hfi.h b/drivers/infiniband/hw/hfi1/hfi.h
index 1000e0f..f41414e 100644
--- a/drivers/infiniband/hw/hfi1/hfi.h
+++ b/drivers/infiniband/hw/hfi1/hfi.h
@@ -1656,7 +1656,6 @@ struct cc_state *get_cc_state_protected(struct hfi1_pportdata *ppd)
 struct hfi1_devdata *hfi1_init_dd(struct pci_dev *,
 				  const struct pci_device_id *);
 void hfi1_free_devdata(struct hfi1_devdata *);
-void cc_state_reclaim(struct rcu_head *rcu);
 struct hfi1_devdata *hfi1_alloc_devdata(struct pci_dev *pdev, size_t extra);
 
 /* LED beaconing functions */
diff --git a/drivers/infiniband/hw/hfi1/init.c b/drivers/infiniband/hw/hfi1/init.c
index a358d23..b793545 100644
--- a/drivers/infiniband/hw/hfi1/init.c
+++ b/drivers/infiniband/hw/hfi1/init.c
@@ -1333,7 +1333,7 @@ static void cleanup_device_data(struct hfi1_devdata *dd)
 		spin_unlock(&ppd->cc_state_lock);
 
 		if (cc_state)
-			call_rcu(&cc_state->rcu, cc_state_reclaim);
+			kfree_rcu(cc_state, rcu);
 	}
 
 	free_credit_return(dd);
diff --git a/drivers/infiniband/hw/hfi1/mad.c b/drivers/infiniband/hw/hfi1/mad.c
index 1263abe..95c43e1 100644
--- a/drivers/infiniband/hw/hfi1/mad.c
+++ b/drivers/infiniband/hw/hfi1/mad.c
@@ -3398,7 +3398,7 @@ static void apply_cc_state(struct hfi1_pportdata *ppd)
 
 	spin_unlock(&ppd->cc_state_lock);
 
-	call_rcu(&old_cc_state->rcu, cc_state_reclaim);
+	kfree_rcu(old_cc_state, rcu);
 }
 
 static int __subn_set_opa_cong_setting(struct opa_smp *smp, u32 am, u8 *data,
@@ -3553,13 +3553,6 @@ static int __subn_get_opa_cc_table(struct opa_smp *smp, u32 am, u8 *data,
 	return reply((struct ib_mad_hdr *)smp);
 }
 
-void cc_state_reclaim(struct rcu_head *rcu)
-{
-	struct cc_state *cc_state = container_of(rcu, struct cc_state, rcu);
-
-	kfree(cc_state);
-}
-
 static int __subn_set_opa_cc_table(struct opa_smp *smp, u32 am, u8 *data,
 				   struct ib_device *ibdev, u8 port,
 				   u32 *resp_len)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
