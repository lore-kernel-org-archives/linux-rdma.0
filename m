From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCHv9 06/12] ib_core: return link layer type of the port
Date: Fri, 6 Aug 2010 17:41:12 +0300
Message-ID: <20100806144112.GG20588@mtldesk30>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Kernel changes to return the port's link layer to userspace through the query
port verb.

Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
---
 drivers/infiniband/core/uverbs_cmd.c |    1 +
 include/rdma/ib_user_verbs.h         |    3 ++-
 2 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 6fcfbeb..41fe487 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -460,6 +460,7 @@ ssize_t ib_uverbs_query_port(struct ib_uverbs_file *file,
 	resp.active_width    = attr.active_width;
 	resp.active_speed    = attr.active_speed;
 	resp.phys_state      = attr.phys_state;
+	resp.link_layer	     = attr.link_layer;
 
 	if (copy_to_user((void __user *) (unsigned long) cmd.response,
 			 &resp, sizeof resp))
diff --git a/include/rdma/ib_user_verbs.h b/include/rdma/ib_user_verbs.h
index a17f771..fe5b051 100644
--- a/include/rdma/ib_user_verbs.h
+++ b/include/rdma/ib_user_verbs.h
@@ -205,7 +205,8 @@ struct ib_uverbs_query_port_resp {
 	__u8  active_width;
 	__u8  active_speed;
 	__u8  phys_state;
-	__u8  reserved[3];
+	__u8  link_layer;
+	__u8  reserved[2];
 };
 
 struct ib_uverbs_alloc_pd {
-- 
1.7.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
