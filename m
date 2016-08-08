From: Wei Yongjun <weiyj.lk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] IB/hfi1: Using kfree_rcu() to simplify the code
Date: Mon,  8 Aug 2016 09:50:18 +0000
Message-ID: <1470649818-30040-1-git-send-email-weiyj.lk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Wei Yongjun <weiyj.lk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The callback function of call_rcu() just calls a kfree(), so we
can use kfree_rcu() instead of call_rcu() + callback function.

Signed-off-by: Wei Yongjun <weiyj.lk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/mad.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

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
