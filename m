From: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v4 09/14] IB/cm: Expose BTH P_Key in CM and SIDR request events
Date: Thu, 30 Jul 2015 17:50:21 +0300
Message-ID: <1438267826-32155-10-git-send-email-haggaie@mellanox.com>
References: <1438267826-32155-1-git-send-email-haggaie@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1438267826-32155-1-git-send-email-haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The rdma_cm module will later use the P_Key from the BTH to de-mux
requests.

See discussion at:
  http://www.spinics.net/lists/netdev/msg336067.html

Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/cm.c | 20 ++++++++++++++++++++
 include/rdma/ib_cm.h         |  6 ++++++
 2 files changed, 26 insertions(+)

diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
index fa3d3e755127..d2b2c83f0076 100644
--- a/drivers/infiniband/core/cm.c
+++ b/drivers/infiniband/core/cm.c
@@ -1404,6 +1404,24 @@ static void cm_format_paths_from_req(struct cm_req_msg *req_msg,
 	}
 }
 
+static u16 cm_get_bth_pkey(struct cm_work *work)
+{
+	struct ib_device *ib_dev = work->port->cm_dev->ib_device;
+	u8 port_num = work->port->port_num;
+	u16 pkey_index = work->mad_recv_wc->wc->pkey_index;
+	u16 pkey;
+	int ret;
+
+	ret = ib_get_cached_pkey(ib_dev, port_num, pkey_index, &pkey);
+	if (ret) {
+		dev_warn_ratelimited(&ib_dev->dev, "ib_cm: Couldn't retrieve pkey for incoming request (port %d, pkey index %d). %d\n",
+				     port_num, pkey_index, ret);
+		return 0;
+	}
+
+	return pkey;
+}
+
 static void cm_format_req_event(struct cm_work *work,
 				struct cm_id_private *cm_id_priv,
 				struct ib_cm_id *listen_id)
@@ -1414,6 +1432,7 @@ static void cm_format_req_event(struct cm_work *work,
 	req_msg = (struct cm_req_msg *)work->mad_recv_wc->recv_buf.mad;
 	param = &work->cm_event.param.req_rcvd;
 	param->listen_id = listen_id;
+	param->bth_pkey = cm_get_bth_pkey(work);
 	param->port = cm_id_priv->av.port->port_num;
 	param->primary_path = &work->path[0];
 	if (req_msg->alt_local_lid)
@@ -3105,6 +3124,7 @@ static void cm_format_sidr_req_event(struct cm_work *work,
 	param->pkey = __be16_to_cpu(sidr_req_msg->pkey);
 	param->listen_id = listen_id;
 	param->service_id = sidr_req_msg->service_id;
+	param->bth_pkey = cm_get_bth_pkey(work);
 	param->port = work->port->port_num;
 	work->cm_event.private_data = &sidr_req_msg->private_data;
 }
diff --git a/include/rdma/ib_cm.h b/include/rdma/ib_cm.h
index 9cc496e1f2ad..e3f48632e237 100644
--- a/include/rdma/ib_cm.h
+++ b/include/rdma/ib_cm.h
@@ -113,6 +113,10 @@ struct ib_cm_id;
 
 struct ib_cm_req_event_param {
 	struct ib_cm_id		*listen_id;
+
+	/* P_Key that was used by the GMP's BTH header */
+	u16			bth_pkey;
+
 	u8			port;
 
 	struct ib_sa_path_rec	*primary_path;
@@ -224,6 +228,8 @@ struct ib_cm_apr_event_param {
 struct ib_cm_sidr_req_event_param {
 	struct ib_cm_id		*listen_id;
 	__be64			service_id;
+	/* P_Key that was used by the GMP's BTH header */
+	u16			bth_pkey;
 	u8			port;
 	u16			pkey;
 };
-- 
1.7.11.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
