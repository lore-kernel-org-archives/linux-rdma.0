From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next] IB/cm: Fix memory corruption in handling CM request
Date: Thu, 19 Oct 2017 08:40:30 +0300
Message-ID: <20171019054030.13280-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

In recent code, two path record entries are alwasy cleared while
allocated could be either one or two path record entries.
This leads to zero out of unallocated memory.

This fix initializes alternative path record only when alternative path
is set.

While we are at it, path record allocation doesn't check for OPA
alternative path, but rest of the code checks for OPA alternative path.
Path record allocation code doesn't check for OPA alternative LID.
This can further lead to memory corruption when only one path record is
allocated, but there is actually alternative OPA path record present in CM
request.

Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org> # v4.12+
Fixes: 9fdca4da4d8c ("IB/SA: Split struct sa_path_rec based on IB and ROCE specific fields")
Signed-off-by: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/core/cm.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
index 5927ee4e57ca..f6b159d79977 100644
--- a/drivers/infiniband/core/cm.c
+++ b/drivers/infiniband/core/cm.c
@@ -1573,7 +1573,7 @@ static void cm_format_req_event(struct cm_work *work,
 	param->bth_pkey = cm_get_bth_pkey(work);
 	param->port = cm_id_priv->av.port->port_num;
 	param->primary_path = &work->path[0];
-	if (req_msg->alt_local_lid)
+	if (cm_req_has_alt_path(req_msg))
 		param->alternate_path = &work->path[1];
 	else
 		param->alternate_path = NULL;
@@ -1854,7 +1854,8 @@ static int cm_req_handler(struct cm_work *work)
 	cm_process_routed_req(req_msg, work->mad_recv_wc->wc);

 	memset(&work->path[0], 0, sizeof(work->path[0]));
-	memset(&work->path[1], 0, sizeof(work->path[1]));
+	if (cm_req_has_alt_path(req_msg))
+		memset(&work->path[1], 0, sizeof(work->path[1]));
 	grh = rdma_ah_read_grh(&cm_id_priv->av.ah_attr);
 	ret = ib_get_cached_gid(work->port->cm_dev->ib_device,
 				work->port->port_num,
@@ -3816,14 +3817,16 @@ static void cm_recv_handler(struct ib_mad_agent *mad_agent,
 	struct cm_port *port = mad_agent->context;
 	struct cm_work *work;
 	enum ib_cm_event_type event;
+	bool alt_path = false;
 	u16 attr_id;
 	int paths = 0;
 	int going_down = 0;

 	switch (mad_recv_wc->recv_buf.mad->mad_hdr.attr_id) {
 	case CM_REQ_ATTR_ID:
-		paths = 1 + (((struct cm_req_msg *) mad_recv_wc->recv_buf.mad)->
-						    alt_local_lid != 0);
+		alt_path = cm_req_has_alt_path((struct cm_req_msg *)
+						mad_recv_wc->recv_buf.mad);
+		paths = 1 + (alt_path != 0);
 		event = IB_CM_REQ_RECEIVED;
 		break;
 	case CM_MRA_ATTR_ID:
--
2.14.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
