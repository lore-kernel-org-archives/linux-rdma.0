From: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Subject: [PATCH 09/28] IB/srpt: Make it safe to use RCU for srpt_device.rch_list
Date: Wed,  3 Jan 2018 13:39:19 -0800
Message-ID: <20180103213938.11664-10-bart.vanassche@wdc.com>
References: <20180103213938.11664-1-bart.vanassche@wdc.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180103213938.11664-1-bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The next patch will iterate over rch_list from a context from which
it is not allowed to block. Hence make rch_list RCU-safe.

Signed-off-by: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c | 5 +++--
 drivers/infiniband/ulp/srpt/ib_srpt.h | 2 ++
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index ebdd5a4f407b..d7143cf6a882 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -1852,7 +1852,7 @@ static void srpt_free_ch(struct kref *kref)
 {
 	struct srpt_rdma_ch *ch = container_of(kref, struct srpt_rdma_ch, kref);
 
-	kfree(ch);
+	kfree_rcu(ch, rcu);
 }
 
 static void srpt_release_channel_work(struct work_struct *w)
@@ -2016,6 +2016,7 @@ static int srpt_cm_req_recv(struct ib_cm_id *cm_id,
 		goto reject;
 	}
 
+	init_rcu_head(&ch->rcu);
 	kref_init(&ch->kref);
 	ch->zw_cqe.done = srpt_zerolength_write_done;
 	INIT_WORK(&ch->release_work, srpt_release_channel_work);
@@ -2144,7 +2145,7 @@ static int srpt_cm_req_recv(struct ib_cm_id *cm_id,
 	}
 
 	mutex_lock(&sdev->mutex);
-	list_add_tail(&ch->list, &sdev->rch_list);
+	list_add_tail_rcu(&ch->list, &sdev->rch_list);
 	mutex_unlock(&sdev->mutex);
 
 	goto out;
diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.h b/drivers/infiniband/ulp/srpt/ib_srpt.h
index 7fff73a5d1e6..d2c08ca2bd74 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.h
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.h
@@ -236,6 +236,7 @@ enum rdma_ch_state {
  * @cm_id:         IB CM ID associated with the channel.
  * @qp:            IB queue pair used for communicating over this channel.
  * @cq:            IB completion queue for this channel.
+ * @rcu:           RCU head.
  * @rq_size:       IB receive queue size.
  * @rsp_size	   IB response message size in bytes.
  * @sq_wr_avail:   number of work requests available in the send queue.
@@ -267,6 +268,7 @@ struct srpt_rdma_ch {
 	struct ib_qp		*qp;
 	struct ib_cq		*cq;
 	struct ib_cqe		zw_cqe;
+	struct rcu_head		rcu;
 	struct kref		kref;
 	int			rq_size;
 	u32			rsp_size;
-- 
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
