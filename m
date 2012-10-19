From: Kleber Sacilotto de Souza <klebers-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: [PATCH] IB: fix task hanging on error recovery
Date: Fri, 19 Oct 2012 18:58:16 -0300
Message-ID: <1350683896-3928-1-git-send-email-klebers@linux.vnet.ibm.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cascardo-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, brking-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, Kleber Sacilotto de Souza <klebers-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

During PCI error recovery, the calls to wait_for_completion() in the
infiniband core path can hang waiting for some tasks that will never
complete, since the hardware is nonfunctional.

INFO: task eehd:16029 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this
message.
eehd            D 0000000000000000  9664 16029   3093 0x00000080
Call Trace:
[c0000000af8430e0] [c0000000be05e200] 0xc0000000be05e200 (unreliable)
[c0000000af8432b0] [c000000000014070] .__switch_to+0x130/0x250
[c0000000af843360] [c000000000777c5c] .__schedule+0x40c/0x920
[c0000000af843600] [c000000000775a10] .schedule_timeout+0x210/0x260
[c0000000af8436e0] [c000000000777658] .wait_for_common+0xf8/0x210
[c0000000af8437c0] [d000000004113538] .ib_unregister_mad_agent+0x498/0x690 [ib_mad]
[c0000000af8438c0] [d0000000042c01f4] .ib_sa_remove_one+0xe4/0x180 [ib_sa]
[c0000000af843970] [d0000000040952e8] .ib_unregister_device+0x78/0x170 [ib_core]
[c0000000af843a10] [d000000004183290] .mlx4_ib_remove+0x40/0x1f0 [mlx4_ib]
[c0000000af843ab0] [d000000003f6ab54] .mlx4_remove_device+0xd4/0x110 [mlx4_core]
[c0000000af843b40] [d000000003f6abfc] .mlx4_unregister_device+0x6c/0xf0 [mlx4_core]
[c0000000af843be0] [d000000003f6f19c] .mlx4_remove_one+0x10c/0x3a0 [mlx4_core]
[c0000000af843c80] [d000000003f6f448] .mlx4_pci_err_detected+0x18/0x40 [mlx4_core]
[c0000000af843d00] [c000000000058a50] .eeh_report_error+0x70/0xe0
[c0000000af843d90] [c0000000003e4d94] .pci_walk_bus+0xa4/0x140
[c0000000af843e50] [c000000000058628] .handle_eeh_events+0x1f8/0x480
[c0000000af843f00] [c000000000058dfc] .eeh_event_handler+0x13c/0x1e0
[c0000000af843f90] [c00000000002031c] .kernel_thread+0x54/0x70

This patch fixes the issue by replacing the calls to
wait_for_completion() by wait_for_completion_timeout(), providing a
timeout of 5 seconds to wait for the normal completion of the task.

Signed-off-by: Kleber Sacilotto de Souza <klebers-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
---
 drivers/infiniband/core/addr.c        |    2 +-
 drivers/infiniband/core/cm.c          |    2 +-
 drivers/infiniband/core/cma.c         |    4 ++--
 drivers/infiniband/core/iwcm.c        |    2 +-
 drivers/infiniband/core/mad.c         |    4 ++--
 drivers/infiniband/core/mad_rmpp.c    |    2 +-
 drivers/infiniband/core/multicast.c   |    4 ++--
 drivers/infiniband/core/sa_query.c    |    2 +-
 drivers/infiniband/core/ucm.c         |    2 +-
 drivers/infiniband/core/ucma.c        |    2 +-
 drivers/infiniband/core/uverbs_main.c |    4 ++--
 11 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/infiniband/core/addr.c b/drivers/infiniband/core/addr.c
index eaec8d7..be42113 100644
--- a/drivers/infiniband/core/addr.c
+++ b/drivers/infiniband/core/addr.c
@@ -86,7 +86,7 @@ static inline void put_client(struct rdma_addr_client *client)
 void rdma_addr_unregister_client(struct rdma_addr_client *client)
 {
 	put_client(client);
-	wait_for_completion(&client->comp);
+	wait_for_completion_timeout(&client->comp, 5*HZ);
 }
 EXPORT_SYMBOL(rdma_addr_unregister_client);
 
diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
index 394fea2..062a90b 100644
--- a/drivers/infiniband/core/cm.c
+++ b/drivers/infiniband/core/cm.c
@@ -910,7 +910,7 @@ retest:
 
 	cm_free_id(cm_id->local_id);
 	cm_deref_id(cm_id_priv);
-	wait_for_completion(&cm_id_priv->comp);
+	wait_for_completion_timeout(&cm_id_priv->comp, 5*HZ);
 	while ((work = cm_dequeue_work(cm_id_priv)) != NULL)
 		cm_free_work(work);
 	kfree(cm_id_priv->compare_data);
diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index a7568c3..c85d078 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -944,7 +944,7 @@ void rdma_destroy_id(struct rdma_cm_id *id)
 
 	cma_release_port(id_priv);
 	cma_deref_id(id_priv);
-	wait_for_completion(&id_priv->comp);
+	wait_for_completion_timeout(&id_priv->comp, 5*HZ);
 
 	if (id_priv->internal_id)
 		cma_deref_id(id_priv->id.context);
@@ -3388,7 +3388,7 @@ static void cma_process_remove(struct cma_device *cma_dev)
 	mutex_unlock(&lock);
 
 	cma_deref_dev(cma_dev);
-	wait_for_completion(&cma_dev->comp);
+	wait_for_completion_timeout(&cma_dev->comp, 5*HZ);
 }
 
 static void cma_remove_one(struct ib_device *device)
diff --git a/drivers/infiniband/core/iwcm.c b/drivers/infiniband/core/iwcm.c
index 0bb99bb..7457195 100644
--- a/drivers/infiniband/core/iwcm.c
+++ b/drivers/infiniband/core/iwcm.c
@@ -399,7 +399,7 @@ void iw_destroy_cm_id(struct iw_cm_id *cm_id)
 
 	destroy_cm_id(cm_id);
 
-	wait_for_completion(&cm_id_priv->destroy_comp);
+	wait_for_completion_timeout(&cm_id_priv->destroy_comp, 5*HZ);
 
 	free_cm_id(cm_id_priv);
 }
diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c
index dc3fd1e..bf94a67 100644
--- a/drivers/infiniband/core/mad.c
+++ b/drivers/infiniband/core/mad.c
@@ -539,7 +539,7 @@ static void unregister_mad_agent(struct ib_mad_agent_private *mad_agent_priv)
 	ib_cancel_rmpp_recvs(mad_agent_priv);
 
 	deref_mad_agent(mad_agent_priv);
-	wait_for_completion(&mad_agent_priv->comp);
+	wait_for_completion_timeout(&mad_agent_priv->comp, 5*HZ);
 
 	kfree(mad_agent_priv->reg_req);
 	ib_dereg_mr(mad_agent_priv->agent.mr);
@@ -558,7 +558,7 @@ static void unregister_mad_snoop(struct ib_mad_snoop_private *mad_snoop_priv)
 	spin_unlock_irqrestore(&qp_info->snoop_lock, flags);
 
 	deref_snoop_agent(mad_snoop_priv);
-	wait_for_completion(&mad_snoop_priv->comp);
+	wait_for_completion_timeout(&mad_snoop_priv->comp, 5*HZ);
 
 	kfree(mad_snoop_priv);
 }
diff --git a/drivers/infiniband/core/mad_rmpp.c b/drivers/infiniband/core/mad_rmpp.c
index f37878c..562bf84 100644
--- a/drivers/infiniband/core/mad_rmpp.c
+++ b/drivers/infiniband/core/mad_rmpp.c
@@ -78,7 +78,7 @@ static inline void deref_rmpp_recv(struct mad_rmpp_recv *rmpp_recv)
 static void destroy_rmpp_recv(struct mad_rmpp_recv *rmpp_recv)
 {
 	deref_rmpp_recv(rmpp_recv);
-	wait_for_completion(&rmpp_recv->comp);
+	wait_for_completion_timeout(&rmpp_recv->comp, 5*HZ);
 	ib_destroy_ah(rmpp_recv->ah);
 	kfree(rmpp_recv);
 }
diff --git a/drivers/infiniband/core/multicast.c b/drivers/infiniband/core/multicast.c
index d2360a8..0cba0c6 100644
--- a/drivers/infiniband/core/multicast.c
+++ b/drivers/infiniband/core/multicast.c
@@ -684,7 +684,7 @@ void ib_sa_free_multicast(struct ib_sa_multicast *multicast)
 	}
 
 	deref_member(member);
-	wait_for_completion(&member->comp);
+	wait_for_completion_timeout(&member->comp, 5*HZ);
 	ib_sa_client_put(member->client);
 	kfree(member);
 }
@@ -862,7 +862,7 @@ static void mcast_remove_one(struct ib_device *device)
 		    IB_LINK_LAYER_INFINIBAND) {
 			port = &dev->port[i];
 			deref_port(port);
-			wait_for_completion(&port->comp);
+			wait_for_completion_timeout(&port->comp, 5*HZ);
 		}
 	}
 
diff --git a/drivers/infiniband/core/sa_query.c b/drivers/infiniband/core/sa_query.c
index a8905ab..25547fe 100644
--- a/drivers/infiniband/core/sa_query.c
+++ b/drivers/infiniband/core/sa_query.c
@@ -474,7 +474,7 @@ EXPORT_SYMBOL(ib_sa_register_client);
 void ib_sa_unregister_client(struct ib_sa_client *client)
 {
 	ib_sa_client_put(client);
-	wait_for_completion(&client->comp);
+	wait_for_completion_timeout(&client->comp, 5*HZ);
 }
 EXPORT_SYMBOL(ib_sa_unregister_client);
 
diff --git a/drivers/infiniband/core/ucm.c b/drivers/infiniband/core/ucm.c
index 49b15ac..6358941 100644
--- a/drivers/infiniband/core/ucm.c
+++ b/drivers/infiniband/core/ucm.c
@@ -550,7 +550,7 @@ static ssize_t ib_ucm_destroy_id(struct ib_ucm_file *file,
 		return PTR_ERR(ctx);
 
 	ib_ucm_ctx_put(ctx);
-	wait_for_completion(&ctx->comp);
+	wait_for_completion_timeout(&ctx->comp, 5*HZ);
 
 	/* No new events will be generated after destroying the cm_id. */
 	ib_destroy_cm_id(ctx->cm_id);
diff --git a/drivers/infiniband/core/ucma.c b/drivers/infiniband/core/ucma.c
index 2709ff5..4b4eb29 100644
--- a/drivers/infiniband/core/ucma.c
+++ b/drivers/infiniband/core/ucma.c
@@ -516,7 +516,7 @@ static ssize_t ucma_destroy_id(struct ucma_file *file, const char __user *inbuf,
 		return PTR_ERR(ctx);
 
 	ucma_put_ctx(ctx);
-	wait_for_completion(&ctx->comp);
+	wait_for_completion_timeout(&ctx->comp, 5*HZ);
 	resp.events_reported = ucma_free_ctx(ctx);
 
 	if (copy_to_user((void __user *)(unsigned long)cmd.response,
diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index 6f2ce6f..0824b92 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -819,7 +819,7 @@ err_cdev:
 
 err:
 	kref_put(&uverbs_dev->ref, ib_uverbs_release_dev);
-	wait_for_completion(&uverbs_dev->comp);
+	wait_for_completion_timeout(&uverbs_dev->comp, 5*HZ);
 	kfree(uverbs_dev);
 	return;
 }
@@ -841,7 +841,7 @@ static void ib_uverbs_remove_one(struct ib_device *device)
 		clear_bit(uverbs_dev->devnum - IB_UVERBS_MAX_DEVICES, overflow_map);
 
 	kref_put(&uverbs_dev->ref, ib_uverbs_release_dev);
-	wait_for_completion(&uverbs_dev->comp);
+	wait_for_completion_timeout(&uverbs_dev->comp, 5*HZ);
 	kfree(uverbs_dev);
 }
 
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
