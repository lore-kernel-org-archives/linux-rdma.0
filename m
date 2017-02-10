From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 3/8] IB/srp: Document locking conventions
Date: Fri, 10 Feb 2017 15:56:06 -0800
Message-ID: <20170210235611.3243-4-bart.vanassche@sandisk.com>
References: <20170210235611.3243-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170210235611.3243-1-bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Israel Rukshin <israelr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Use lockdep_assert_held() statements to verify at run-time
whether the proper locks are held.

Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Israel Rukshin <israelr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 511eb4b2e6e0..a43db9d6b399 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -40,6 +40,7 @@
 #include <linux/parser.h>
 #include <linux/random.h>
 #include <linux/jiffies.h>
+#include <linux/lockdep.h>
 #include <rdma/ib_cache.h>
 
 #include <linux/atomic.h>
@@ -1804,6 +1805,8 @@ static struct srp_iu *__srp_get_tx_iu(struct srp_rdma_ch *ch,
 	s32 rsv = (iu_type == SRP_IU_TSK_MGMT) ? 0 : SRP_TSK_MGMT_SQ_SIZE;
 	struct srp_iu *iu;
 
+	lockdep_assert_held(&ch->lock);
+
 	ib_process_cq_direct(ch->send_cq, -1);
 
 	if (list_empty(&ch->free_tx))
@@ -1834,6 +1837,8 @@ static void srp_send_done(struct ib_cq *cq, struct ib_wc *wc)
 		return;
 	}
 
+	lockdep_assert_held(&ch->lock);
+
 	list_add(&iu->list, &ch->free_tx);
 }
 
-- 
2.11.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
