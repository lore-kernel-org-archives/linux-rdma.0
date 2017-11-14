From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 28/31] IB/cm: Fix avoid sleep while spin lock is held
Date: Tue, 14 Nov 2017 14:52:15 +0200
Message-ID: <20171114125218.20477-29-leon@kernel.org>
References: <20171114125218.20477-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171114125218.20477-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

In case of LAP are used for RoCE, it can lead to a problem of sleeping a
context while spin lock is held in below flow.

cm_lap_handler
	->spin_lock
	-> <..switch_case..>
	-> cm_init_av_for_response
		-> ib_init_ah_from_wc
			-> rdma_addr_find_l2_eth_by_grh
				wait_for_completion()

Therefore ah attribute initialization is done for incoming lap requests
outside of the lock context.

Signed-off-by: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/core/cm.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
index d12c50ee2b89..19fd1699dc52 100644
--- a/drivers/infiniband/core/cm.c
+++ b/drivers/infiniband/core/cm.c
@@ -3130,6 +3130,12 @@ static int cm_lap_handler(struct cm_work *work)
 	if (!cm_id_priv)
 		return -EINVAL;
 
+	ret = cm_init_av_for_response(work->port, work->mad_recv_wc->wc,
+				      work->mad_recv_wc->recv_buf.grh,
+				      &cm_id_priv->av);
+	if (ret)
+		goto deref;
+
 	param = &work->cm_event.param.lap_rcvd;
 	memset(&work->path[0], 0, sizeof(work->path[1]));
 	cm_path_set_rec_type(work->port->cm_dev->ib_device,
@@ -3176,11 +3182,6 @@ static int cm_lap_handler(struct cm_work *work)
 
 	cm_id_priv->id.lap_state = IB_CM_LAP_RCVD;
 	cm_id_priv->tid = lap_msg->hdr.tid;
-	ret = cm_init_av_for_response(work->port, work->mad_recv_wc->wc,
-				      work->mad_recv_wc->recv_buf.grh,
-				      &cm_id_priv->av);
-	if (ret)
-		goto unlock;
 	cm_init_av_by_path(param->alternate_path, &cm_id_priv->alt_av,
 			   cm_id_priv);
 	ret = atomic_inc_and_test(&cm_id_priv->work_count);
-- 
2.15.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
