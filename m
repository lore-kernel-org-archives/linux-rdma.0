From: Dasaratharaman Chandramouli
        <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH rdma-next 1/6] IB/CM: Add braces when using sizeof
Date: Mon, 17 Apr 2017 16:56:25 -0400
Message-ID: <1492462590-64866-2-git-send-email-dasaratharaman.chandramouli@intel.com>
References: <1492462590-64866-1-git-send-email-dasaratharaman.chandramouli@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1492462590-64866-1-git-send-email-dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This patch adds braces around parameters to sizeof
as called out by checkpatch

Reviewed-by: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dasaratharaman Chandramouli <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/core/cm.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
index d35c2de..53661f34 100644
--- a/drivers/infiniband/core/cm.c
+++ b/drivers/infiniband/core/cm.c
@@ -1404,7 +1404,7 @@ static void cm_format_paths_from_req(struct cm_req_msg *req_msg,
 					    struct ib_sa_path_rec *primary_path,
 					    struct ib_sa_path_rec *alt_path)
 {
-	memset(primary_path, 0, sizeof *primary_path);
+	memset(primary_path, 0, sizeof(*primary_path));
 	primary_path->dgid = req_msg->primary_local_gid;
 	primary_path->sgid = req_msg->primary_remote_gid;
 	primary_path->dlid = req_msg->primary_local_lid;
@@ -1426,7 +1426,7 @@ static void cm_format_paths_from_req(struct cm_req_msg *req_msg,
 	primary_path->service_id = req_msg->service_id;
 
 	if (req_msg->alt_local_lid) {
-		memset(alt_path, 0, sizeof *alt_path);
+		memset(alt_path, 0, sizeof(*alt_path));
 		alt_path->dgid = req_msg->alt_local_gid;
 		alt_path->sgid = req_msg->alt_remote_gid;
 		alt_path->dlid = req_msg->alt_local_lid;
@@ -3712,7 +3712,7 @@ static void cm_recv_handler(struct ib_mad_agent *mad_agent,
 	atomic_long_inc(&port->counter_group[CM_RECV].
 			counter[attr_id - CM_ATTR_ID_OFFSET]);
 
-	work = kmalloc(sizeof *work + sizeof(struct ib_sa_path_rec) * paths,
+	work = kmalloc(sizeof(*work) + sizeof(struct ib_sa_path_rec) * paths,
 		       GFP_KERNEL);
 	if (!work) {
 		ib_free_recv_mad(mad_recv_wc);
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
