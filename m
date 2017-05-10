From: Dasaratharaman Chandramouli
        <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH rdma-next 4/4] IB/CM: Change sgid to IB GID when handling CM request
Date: Wed, 10 May 2017 19:23:18 -0400
Message-ID: <1494458598-6911-5-git-send-email-dasaratharaman.chandramouli@intel.com>
References: <1494458598-6911-1-git-send-email-dasaratharaman.chandramouli@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1494458598-6911-1-git-send-email-dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

IPoIB uses the sgid to compare it with its local_gid and will
reject a CM request if they don't match. Change OPA GID back to
IB gid so the comparison succeeds.

Reviewed-by: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dasaratharaman Chandramouli <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/core/cm.c | 29 +++++++++++++++++++++++++++--
 1 file changed, 27 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
index 2d0a550..4798572 100644
--- a/drivers/infiniband/core/cm.c
+++ b/drivers/infiniband/core/cm.c
@@ -1525,6 +1525,28 @@ static u16 cm_get_bth_pkey(struct cm_work *work)
 	return pkey;
 }
 
+static void cm_modify_sgid(struct cm_work *work,
+			   struct sa_path_rec *path)
+{
+	struct ib_device *dev = work->port->cm_dev->ib_device;
+	struct ib_gid_attr gid_attr;
+	u8 port_num = work->port->port_num;
+
+	if (rdma_cap_opa_ah(dev, port_num) &&
+	    (ib_is_opa_gid(&path->sgid))) {
+		union ib_gid sgid;
+
+		if (ib_get_cached_gid(dev, port_num, 0,
+				      &sgid, &gid_attr)) {
+			dev_warn(&dev->dev,
+				 "Error updating sgid in CM request\n");
+			return;
+		}
+
+		path->sgid = sgid;
+	}
+}
+
 static void cm_format_req_event(struct cm_work *work,
 				struct cm_id_private *cm_id_priv,
 				struct ib_cm_id *listen_id)
@@ -1538,10 +1560,13 @@ static void cm_format_req_event(struct cm_work *work,
 	param->bth_pkey = cm_get_bth_pkey(work);
 	param->port = cm_id_priv->av.port->port_num;
 	param->primary_path = &work->path[0];
-	if (req_msg->alt_local_lid)
+	cm_modify_sgid(work, param->primary_path);
+	if (cm_req_has_alt_path(req_msg)) {
 		param->alternate_path = &work->path[1];
-	else
+		cm_modify_sgid(work, param->alternate_path);
+	} else {
 		param->alternate_path = NULL;
+	}
 	param->remote_ca_guid = req_msg->local_ca_guid;
 	param->remote_qkey = be32_to_cpu(req_msg->local_qkey);
 	param->remote_qpn = be32_to_cpu(cm_req_get_local_qpn(req_msg));
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
