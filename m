From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [RFC] [PATCH 19/22] [for 2.6.36] rdma/ucm: name changes to indicate only IP addresses supported
Date: Tue, 23 Mar 2010 11:25:40 -0700
Message-ID: <24921D483E144F76B176F1D40D8AE1A2@amr.corp.intel.com>
References: <2F3826558E79459EAD2A457A604221C1@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <2F3826558E79459EAD2A457A604221C1-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Several commands into the RDMA CM from user space are
restricted to supporting addresses which fit into a sockaddr_in6
structure: bind address, resolve address, and join multicast.

With the addition of AF_IB, we need to support addresses
which are larger than sockaddr_in6.  This will be done by
adding new commands that exchange address information using
sockaddr_storage.  However, to support existing applications,
we maintain the current commands and structures, but rename
them to indicate that they only support IPv4 and v6 addresses.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---

 drivers/infiniband/core/ucma.c |   26 +++++++++++++-------------
 include/rdma/rdma_user_cm.h    |   12 ++++++------
 2 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/drivers/infiniband/core/ucma.c b/drivers/infiniband/core/ucma.c
index 1c2083e..950bd35 100644
--- a/drivers/infiniband/core/ucma.c
+++ b/drivers/infiniband/core/ucma.c
@@ -495,10 +495,10 @@ static ssize_t ucma_destroy_id(struct ucma_file *file, const char __user *inbuf,
 	return ret;
 }
 
-static ssize_t ucma_bind_addr(struct ucma_file *file, const char __user *inbuf,
+static ssize_t ucma_bind_ip(struct ucma_file *file, const char __user *inbuf,
 			      int in_len, int out_len)
 {
-	struct rdma_ucm_bind_addr cmd;
+	struct rdma_ucm_bind_ip cmd;
 	struct ucma_context *ctx;
 	int ret;
 
@@ -514,11 +514,11 @@ static ssize_t ucma_bind_addr(struct ucma_file *file, const char __user *inbuf,
 	return ret;
 }
 
-static ssize_t ucma_resolve_addr(struct ucma_file *file,
-				 const char __user *inbuf,
-				 int in_len, int out_len)
+static ssize_t ucma_resolve_ip(struct ucma_file *file,
+			       const char __user *inbuf,
+			       int in_len, int out_len)
 {
-	struct rdma_ucm_resolve_addr cmd;
+	struct rdma_ucm_resolve_ip cmd;
 	struct ucma_context *ctx;
 	int ret;
 
@@ -1088,11 +1088,11 @@ static ssize_t ucma_notify(struct ucma_file *file, const char __user *inbuf,
 	return ret;
 }
 
-static ssize_t ucma_join_multicast(struct ucma_file *file,
-				   const char __user *inbuf,
-				   int in_len, int out_len)
+static ssize_t ucma_join_ip_multicast(struct ucma_file *file,
+				      const char __user *inbuf,
+				      int in_len, int out_len)
 {
-	struct rdma_ucm_join_mcast cmd;
+	struct rdma_ucm_join_ip_mcast cmd;
 	struct rdma_ucm_create_id_resp resp;
 	struct ucma_context *ctx;
 	struct ucma_multicast *mc;
@@ -1291,8 +1291,8 @@ static ssize_t (*ucma_cmd_table[])(struct ucma_file *file,
 				   int in_len, int out_len) = {
 	[RDMA_USER_CM_CMD_CREATE_ID]	= ucma_create_id,
 	[RDMA_USER_CM_CMD_DESTROY_ID]	= ucma_destroy_id,
-	[RDMA_USER_CM_CMD_BIND_ADDR]	= ucma_bind_addr,
-	[RDMA_USER_CM_CMD_RESOLVE_ADDR]	= ucma_resolve_addr,
+	[RDMA_USER_CM_CMD_BIND_IP]	= ucma_bind_ip,
+	[RDMA_USER_CM_CMD_RESOLVE_IP]	= ucma_resolve_ip,
 	[RDMA_USER_CM_CMD_RESOLVE_ROUTE]= ucma_resolve_route,
 	[RDMA_USER_CM_CMD_QUERY_ROUTE]	= ucma_query_route,
 	[RDMA_USER_CM_CMD_CONNECT]	= ucma_connect,
@@ -1305,7 +1305,7 @@ static ssize_t (*ucma_cmd_table[])(struct ucma_file *file,
 	[RDMA_USER_CM_CMD_GET_OPTION]	= NULL,
 	[RDMA_USER_CM_CMD_SET_OPTION]	= ucma_set_option,
 	[RDMA_USER_CM_CMD_NOTIFY]	= ucma_notify,
-	[RDMA_USER_CM_CMD_JOIN_MCAST]	= ucma_join_multicast,
+	[RDMA_USER_CM_CMD_JOIN_IP_MCAST]= ucma_join_ip_multicast,
 	[RDMA_USER_CM_CMD_LEAVE_MCAST]	= ucma_leave_multicast,
 	[RDMA_USER_CM_CMD_MIGRATE_ID]	= ucma_migrate_id,
 	[RDMA_USER_CM_CMD_QUERY]	= ucma_query
diff --git a/include/rdma/rdma_user_cm.h b/include/rdma/rdma_user_cm.h
index 2534598..bbb724b 100644
--- a/include/rdma/rdma_user_cm.h
+++ b/include/rdma/rdma_user_cm.h
@@ -45,8 +45,8 @@
 enum {
 	RDMA_USER_CM_CMD_CREATE_ID,
 	RDMA_USER_CM_CMD_DESTROY_ID,
-	RDMA_USER_CM_CMD_BIND_ADDR,
-	RDMA_USER_CM_CMD_RESOLVE_ADDR,
+	RDMA_USER_CM_CMD_BIND_IP,
+	RDMA_USER_CM_CMD_RESOLVE_IP,
 	RDMA_USER_CM_CMD_RESOLVE_ROUTE,
 	RDMA_USER_CM_CMD_QUERY_ROUTE,
 	RDMA_USER_CM_CMD_CONNECT,
@@ -59,7 +59,7 @@ enum {
 	RDMA_USER_CM_CMD_GET_OPTION,
 	RDMA_USER_CM_CMD_SET_OPTION,
 	RDMA_USER_CM_CMD_NOTIFY,
-	RDMA_USER_CM_CMD_JOIN_MCAST,
+	RDMA_USER_CM_CMD_JOIN_IP_MCAST,
 	RDMA_USER_CM_CMD_LEAVE_MCAST,
 	RDMA_USER_CM_CMD_MIGRATE_ID,
 	RDMA_USER_CM_CMD_QUERY
@@ -95,13 +95,13 @@ struct rdma_ucm_destroy_id_resp {
 	__u32 events_reported;
 };
 
-struct rdma_ucm_bind_addr {
+struct rdma_ucm_bind_ip {
 	__u64 response;
 	struct sockaddr_in6 addr;
 	__u32 id;
 };
 
-struct rdma_ucm_resolve_addr {
+struct rdma_ucm_resolve_ip {
 	struct sockaddr_in6 src_addr;
 	struct sockaddr_in6 dst_addr;
 	__u32 id;
@@ -215,7 +215,7 @@ struct rdma_ucm_notify {
 	__u32 event;
 };
 
-struct rdma_ucm_join_mcast {
+struct rdma_ucm_join_ip_mcast {
 	__u64 response;		/* rdma_ucm_create_id_resp */
 	__u64 uid;
 	struct sockaddr_in6 addr;



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
