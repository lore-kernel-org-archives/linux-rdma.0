From: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH rdma-core v2] ibverbs: remove unused ibv command declarations
Date: Sun, 5 Feb 2017 12:14:46 +0200
Message-ID: <1486289686-17903-1-git-send-email-Ram.Amrani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Remove the IBV command declarations ibv_cmd_query_gid and
ibv_cmd_query_pkey as they are not implemented.

Signed-off-by: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
---
 libibverbs/driver.h       | 4 ----
 libibverbs/libibverbs.map | 2 --
 2 files changed, 6 deletions(-)

diff --git a/libibverbs/driver.h b/libibverbs/driver.h
index 8ed2d30..5d29b14 100644
--- a/libibverbs/driver.h
+++ b/libibverbs/driver.h
@@ -123,10 +123,6 @@ int ibv_cmd_query_device_ex(struct ibv_context *context,
 int ibv_cmd_query_port(struct ibv_context *context, uint8_t port_num,
 		       struct ibv_port_attr *port_attr,
 		       struct ibv_query_port *cmd, size_t cmd_size);
-int ibv_cmd_query_gid(struct ibv_context *context, uint8_t port_num,
-		      int index, union ibv_gid *gid);
-int ibv_cmd_query_pkey(struct ibv_context *context, uint8_t port_num,
-		       int index, uint16_t *pkey);
 int ibv_cmd_alloc_pd(struct ibv_context *context, struct ibv_pd *pd,
 		     struct ibv_alloc_pd *cmd, size_t cmd_size,
 		     struct ibv_alloc_pd_resp *resp, size_t resp_size);
diff --git a/libibverbs/libibverbs.map b/libibverbs/libibverbs.map
index d510c86..656c21d 100644
--- a/libibverbs/libibverbs.map
+++ b/libibverbs/libibverbs.map
@@ -128,8 +128,6 @@ IBVERBS_PRIVATE_13 {
 		ibv_cmd_post_srq_recv;
 		ibv_cmd_query_device;
 		ibv_cmd_query_device_ex;
-		ibv_cmd_query_gid;
-		ibv_cmd_query_pkey;
 		ibv_cmd_query_port;
 		ibv_cmd_query_qp;
 		ibv_cmd_query_srq;
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
