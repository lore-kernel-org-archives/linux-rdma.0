From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 3/3] IB/srpt: Fix a race condition related to SRP login
Date: Thu, 31 Dec 2015 09:57:58 +0100
Message-ID: <5684EE16.8070701@sandisk.com>
References: <5684ED4B.2010303@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5684ED4B.2010303-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Since patch "IB/srpt: chain RDMA READ/WRITE requests" there are
two loops that process the command wait list. ch->cmd_wait_list
is accessed without locking which means that all code that
accesses this list must be serialized. Since processing of the
RTU event happens from another context than IB WC processing,
remove the wait list processing code from the RTU handler.

Fixes: commit a42d985bd5b2 ("ib_srpt: Initial SRP Target merge for v3.3-rc1").
Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index b42cf0d..48b27dc 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -2540,15 +2540,7 @@ static void srpt_cm_rtu_recv(struct ib_cm_id *cm_id)
 	BUG_ON(!ch);
 
 	if (srpt_test_and_set_ch_state(ch, CH_CONNECTING, CH_LIVE)) {
-		struct srpt_recv_ioctx *ioctx, *ioctx_tmp;
-
 		ret = srpt_ch_qp_rts(ch, ch->qp);
-
-		list_for_each_entry_safe(ioctx, ioctx_tmp, &ch->cmd_wait_list,
-					 wait_list) {
-			list_del(&ioctx->wait_list);
-			srpt_handle_new_iu(ch, ioctx, NULL);
-		}
 		if (ret)
 			srpt_close_ch(ch);
 	}
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
