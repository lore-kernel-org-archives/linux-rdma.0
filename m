From: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Subject: [PATCH v2 01/14] IB/srpt: Make it safe to use RCU for srpt_device.rch_list
Date: Tue, 16 Jan 2018 16:14:05 -0800
Message-ID: <20180117001418.7852-2-bart.vanassche@wdc.com>
References: <20180117001418.7852-1-bart.vanassche@wdc.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180117001418.7852-1-bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The next patch will iterate over rch_list from a context from which
it is not allowed to block. Hence make rch_list RCU-safe.

Signed-off-by: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c | 13 ++++++++++---
 drivers/infiniband/ulp/srpt/ib_srpt.h |  2 ++
 2 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index d78f60dcc2ba..4dd15378bc7c 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -1906,7 +1906,7 @@ static void srpt_free_ch(struct kref *kref)
 {
 	struct srpt_rdma_ch *ch = container_of(kref, struct srpt_rdma_ch, kref);
 
-	kfree(ch);
+	kfree_rcu(ch, rcu);
 }
 
 static void srpt_release_channel_work(struct work_struct *w)
@@ -1945,11 +1945,17 @@ static void srpt_release_channel_work(struct work_struct *w)
 			     srp_max_req_size, DMA_FROM_DEVICE);
 
 	mutex_lock(&sdev->mutex);
-	list_del_init(&ch->list);
+	list_del_rcu(&ch->list);
 	if (ch->release_done)
 		complete(ch->release_done);
 	mutex_unlock(&sdev->mutex);
 
+	synchronize_rcu();
+
+	mutex_lock(&sdev->mutex);
+	INIT_LIST_HEAD(&ch->list);
+	mutex_unlock(&sdev->mutex);
+
 	wake_up(&sdev->ch_releaseQ);
 
 	kref_put(&ch->kref, srpt_free_ch);
@@ -2064,6 +2070,7 @@ static int srpt_cm_req_recv(struct ib_cm_id *cm_id,
 		goto reject;
 	}
 
+	init_rcu_head(&ch->rcu);
 	kref_init(&ch->kref);
 	ch->zw_cqe.done = srpt_zerolength_write_done;
 	INIT_WORK(&ch->release_work, srpt_release_channel_work);
@@ -2190,7 +2197,7 @@ static int srpt_cm_req_recv(struct ib_cm_id *cm_id,
 	}
 
 	mutex_lock(&sdev->mutex);
-	list_add_tail(&ch->list, &sdev->rch_list);
+	list_add_tail_rcu(&ch->list, &sdev->rch_list);
 	mutex_unlock(&sdev->mutex);
 
 	goto out;
diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.h b/drivers/infiniband/ulp/srpt/ib_srpt.h
index 11ce8c94a051..0ab59c60f2ef 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.h
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.h
@@ -244,6 +244,7 @@ enum rdma_ch_state {
  * @qp:            IB queue pair used for communicating over this channel.
  * @cq:            IB completion queue for this channel.
  * @zw_cqe:	   Zero-length write CQE.
+ * @rcu:           RCU head.
  * @kref:	   kref for this channel.
  * @rq_size:       IB receive queue size.
  * @max_rsp_size:  Maximum size of an RSP response message in bytes.
@@ -276,6 +277,7 @@ struct srpt_rdma_ch {
 	struct ib_qp		*qp;
 	struct ib_cq		*cq;
 	struct ib_cqe		zw_cqe;
+	struct rcu_head		rcu;
 	struct kref		kref;
 	int			rq_size;
 	u32			max_rsp_size;
-- 
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
