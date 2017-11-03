From: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Subject: [PATCH 1/5] IB/srpt: Post receive work requests after qp transition to INIT state
Date: Fri, 3 Nov 2017 16:20:52 -0700
Message-ID: <20171103232056.30614-2-bart.vanassche@wdc.com>
References: <20171103232056.30614-1-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171103232056.30614-1-bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Not all HCAs support posting receive work requests in the RESET
state. Postpone posting receive work requests until after the
transition to the INIT state.

Fixes: commit dea262094cdf ("IB/srpt: Change default behavior from using SRQ to using RC")
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 304855b9b537..98b1b80e476b 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -1687,10 +1687,6 @@ static int srpt_create_ch_ib(struct srpt_rdma_ch *ch)
 		goto err_destroy_cq;
 	}
 
-	if (!sdev->use_srq)
-		for (i = 0; i < ch->rq_size; i++)
-			srpt_post_recv(sdev, ch, ch->ioctx_recv_ring[i]);
-
 	atomic_set(&ch->sq_wr_avail, qp_init->cap.max_send_wr);
 
 	pr_debug("%s: max_cqe= %d max_sge= %d sq_size = %d cm_id= %p\n",
@@ -1701,6 +1697,10 @@ static int srpt_create_ch_ib(struct srpt_rdma_ch *ch)
 	if (ret)
 		goto err_destroy_qp;
 
+	if (!sdev->use_srq)
+		for (i = 0; i < ch->rq_size; i++)
+			srpt_post_recv(sdev, ch, ch->ioctx_recv_ring[i]);
+
 out:
 	kfree(qp_init);
 	return ret;
-- 
2.14.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
