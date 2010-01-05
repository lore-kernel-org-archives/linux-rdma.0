From: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Subject: [PATCHv7 2/4] libibverbs: change kernel API to accept link layer
Date: Tue, 5 Jan 2010 12:34:02 +0200
Message-ID: <20100105103402.GM31480@mtls03>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Modify the code to allow passing the link layer of a port from kernel to user.
Update ibv_query_port.3 man page with the change.

Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
---
 include/infiniband/kern-abi.h |    3 ++-
 man/ibv_query_port.3          |    1 +
 src/cmd.c                     |    1 +
 3 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/include/infiniband/kern-abi.h b/include/infiniband/kern-abi.h
index 0db083a..619ea7e 100644
--- a/include/infiniband/kern-abi.h
+++ b/include/infiniband/kern-abi.h
@@ -223,7 +223,8 @@ struct ibv_query_port_resp {
 	__u8  active_width;
 	__u8  active_speed;
 	__u8  phys_state;
-	__u8  reserved[3];
+	__u8  link_layer;
+	__u8  reserved[2];
 };
 
 struct ibv_alloc_pd {
diff --git a/man/ibv_query_port.3 b/man/ibv_query_port.3
index 882470d..6d8b873 100644
--- a/man/ibv_query_port.3
+++ b/man/ibv_query_port.3
@@ -44,6 +44,7 @@ uint8_t                 init_type_reply;/* Type of initialization performed by S
 uint8_t                 active_width;   /* Currently active link width */
 uint8_t                 active_speed;   /* Currently active link speed */
 uint8_t                 phys_state;     /* Physical port state */
+uint8_t                 link_layer;     /* link layer protocol of the port */		 
 .in -8
 };
 .sp
diff --git a/src/cmd.c b/src/cmd.c
index cbd5288..39af833 100644
--- a/src/cmd.c
+++ b/src/cmd.c
@@ -196,6 +196,7 @@ int ibv_cmd_query_port(struct ibv_context *context, uint8_t port_num,
 	port_attr->active_width    = resp.active_width;
 	port_attr->active_speed    = resp.active_speed;
 	port_attr->phys_state      = resp.phys_state;
+	port_attr->link_layer      = resp.link_layer;
 
 	return 0;
 }
-- 
1.6.6

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
