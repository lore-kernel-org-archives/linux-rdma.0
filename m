From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 3/7] IB/srp: Fix srp_create_target() error handling
Date: Thu, 12 May 2016 10:48:48 -0700
Message-ID: <5734C200.6060404@sandisk.com>
References: <5734C181.2020003@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5734C181.2020003-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Avoid that the following kernel oops occurs if memory pool
allocation fails:

BUG: unable to handle kernel NULL pointer dereference at (null)
IP: [<ffffffffa048d0a0>] ib_drain_rq+0x0/0x20 [ib_core]
Call Trace:
 [<ffffffffa04af386>] srp_create_target+0xca6/0x13a9 [ib_srp]
 [<ffffffff813cc863>] dev_attr_store+0x13/0x20
 [<ffffffff81214b50>] sysfs_kf_write+0x40/0x50
 [<ffffffff81213f1c>] kernfs_fop_write+0x13c/0x180
 [<ffffffff81197683>] __vfs_write+0x23/0xf0
 [<ffffffff81198744>] vfs_write+0xa4/0x1a0
 [<ffffffff81199a44>] SyS_write+0x44/0xa0
 [<ffffffff8159e3e9>] entry_SYSCALL_64_fastpath+0x1c/0xac

Fixes: 1dc7b1f10dcb ("IB/srp: use the new CQ API")
Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Tested-by: Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org> # v4.5+
---
 drivers/infiniband/ulp/srp/ib_srp.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 74e3ec8..f4dc6f9 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -447,16 +447,16 @@ static struct srp_fr_pool *srp_alloc_fr_pool(struct srp_target_port *target)
 
 /**
  * srp_destroy_qp() - destroy an RDMA queue pair
- * @ch: SRP RDMA channel.
+ * @qp: RDMA queue pair.
  *
  * Drain the qp before destroying it.  This avoids that the receive
  * completion handler can access the queue pair while it is
  * being destroyed.
  */
-static void srp_destroy_qp(struct srp_rdma_ch *ch)
+static void srp_destroy_qp(struct ib_qp *qp)
 {
-	ib_drain_rq(ch->qp);
-	ib_destroy_qp(ch->qp);
+	ib_drain_rq(qp);
+	ib_destroy_qp(qp);
 }
 
 static int srp_create_ch_ib(struct srp_rdma_ch *ch)
@@ -529,7 +529,7 @@ static int srp_create_ch_ib(struct srp_rdma_ch *ch)
 	}
 
 	if (ch->qp)
-		srp_destroy_qp(ch);
+		srp_destroy_qp(ch->qp);
 	if (ch->recv_cq)
 		ib_free_cq(ch->recv_cq);
 	if (ch->send_cq)
@@ -553,7 +553,7 @@ static int srp_create_ch_ib(struct srp_rdma_ch *ch)
 	return 0;
 
 err_qp:
-	srp_destroy_qp(ch);
+	srp_destroy_qp(qp);
 
 err_send_cq:
 	ib_free_cq(send_cq);
@@ -596,7 +596,7 @@ static void srp_free_ch_ib(struct srp_target_port *target,
 			ib_destroy_fmr_pool(ch->fmr_pool);
 	}
 
-	srp_destroy_qp(ch);
+	srp_destroy_qp(ch->qp);
 	ib_free_cq(ch->send_cq);
 	ib_free_cq(ch->recv_cq);
 
-- 
2.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
