From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [RFC] [PATCH 22/22 v2] [for 2.6.36] rdma/ucm: allow user space to specify AF_IB when joining multicast
Date: Thu, 25 Mar 2010 12:08:47 -0700
Message-ID: <9F947343A2BC48449BE7EB4BE5B11640@amr.corp.intel.com>
References: <2F3826558E79459EAD2A457A604221C1@amr.corp.intel.com> <48F1FC4C2F114E928EB38D690091185E@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <48F1FC4C2F114E928EB38D690091185E-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Allow user space applications to join multicast groups using MGIDs
directly.  MGIDs may be passed using AF_IB addresses.  Since the
current multicast join command only supports addresses as large as
sockaddr_in6, define a new structure for joining addresses specified
using sockaddr_ib.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
changes from v1:
Forgot to include the changes to the cma.c module to support
AF_IB as part of a join request.

 drivers/infiniband/core/cma.c  |    2 +
 drivers/infiniband/core/ucma.c |   55 ++++++++++++++++++++++++++++++++--------
 include/rdma/rdma_user_cm.h    |   12 ++++++++-
 3 files changed, 57 insertions(+), 12 deletions(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 9e9a473..42d51b5 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -2897,6 +2897,8 @@ static void cma_set_mgid(struct rdma_id_private *id_priv,
 								 0xFF10A01B)) {
 		/* IPv6 address is an SA assigned MGID. */
 		memcpy(mgid, &sin6->sin6_addr, sizeof *mgid);
+	} else if (addr->sa_family == AF_IB) {
+		memcpy(mgid, &((struct sockaddr_ib *) addr)->sib_addr, sizeof *mgid);
 	} else if ((addr->sa_family == AF_INET6)) {
 		ipv6_ib_mc_map(&sin6->sin6_addr, dev_addr->broadcast, mc_map);
 		if (id_priv->id.ps == RDMA_PS_UDP)
diff --git a/drivers/infiniband/core/ucma.c b/drivers/infiniband/core/ucma.c
index 2224a05..a9b917a 100644
--- a/drivers/infiniband/core/ucma.c
+++ b/drivers/infiniband/core/ucma.c
@@ -1139,23 +1139,23 @@ static ssize_t ucma_notify(struct ucma_file *file, const char __user *inbuf,
 	return ret;
 }
 
-static ssize_t ucma_join_ip_multicast(struct ucma_file *file,
-				      const char __user *inbuf,
-				      int in_len, int out_len)
+static ssize_t ucma_process_join(struct ucma_file *file,
+				 struct rdma_ucm_join_mcast *cmd,  int out_len)
 {
-	struct rdma_ucm_join_ip_mcast cmd;
 	struct rdma_ucm_create_id_resp resp;
 	struct ucma_context *ctx;
 	struct ucma_multicast *mc;
+	struct sockaddr *addr;
 	int ret;
 
 	if (out_len < sizeof(resp))
 		return -ENOSPC;
 
-	if (copy_from_user(&cmd, inbuf, sizeof(cmd)))
-		return -EFAULT;
+	addr = (struct sockaddr *) &cmd->addr;
+	if (cmd->reserved || !cmd->addr_size || (cmd->addr_size != rdma_addr_size(addr)))
+		return -EINVAL;
 
-	ctx = ucma_get_ctx(file, cmd.id);
+	ctx = ucma_get_ctx(file, cmd->id);
 	if (IS_ERR(ctx))
 		return PTR_ERR(ctx);
 
@@ -1166,14 +1166,14 @@ static ssize_t ucma_join_ip_multicast(struct ucma_file *file,
 		goto err1;
 	}
 
-	mc->uid = cmd.uid;
-	memcpy(&mc->addr, &cmd.addr, sizeof cmd.addr);
+	mc->uid = cmd->uid;
+	memcpy(&mc->addr, addr, cmd->addr_size);
 	ret = rdma_join_multicast(ctx->cm_id, (struct sockaddr *) &mc->addr, mc);
 	if (ret)
 		goto err2;
 
 	resp.id = mc->id;
-	if (copy_to_user((void __user *)(unsigned long)cmd.response,
+	if (copy_to_user((void __user *)(unsigned long) cmd->response,
 			 &resp, sizeof(resp))) {
 		ret = -EFAULT;
 		goto err3;
@@ -1198,6 +1198,38 @@ err1:
 	return ret;
 }
 
+static ssize_t ucma_join_ip_multicast(struct ucma_file *file,
+				      const char __user *inbuf,
+				      int in_len, int out_len)
+{
+	struct rdma_ucm_join_ip_mcast cmd;
+	struct rdma_ucm_join_mcast join_cmd;
+
+	if (copy_from_user(&cmd, inbuf, sizeof(cmd)))
+		return -EFAULT;
+
+	join_cmd.response = cmd.response;
+	join_cmd.uid = cmd.uid;
+	join_cmd.id = cmd.id;
+	join_cmd.addr_size = rdma_addr_size((struct sockaddr *) &cmd.addr);
+	join_cmd.reserved = 0;
+	memcpy(&join_cmd.addr, &cmd.addr, join_cmd.addr_size);
+
+	return ucma_process_join(file, &join_cmd, out_len);
+}
+
+static ssize_t ucma_join_multicast(struct ucma_file *file,
+				   const char __user *inbuf,
+				   int in_len, int out_len)
+{
+	struct rdma_ucm_join_mcast cmd;
+
+	if (copy_from_user(&cmd, inbuf, sizeof(cmd)))
+		return -EFAULT;
+
+	return ucma_process_join(file, &cmd, out_len);
+}
+
 static ssize_t ucma_leave_multicast(struct ucma_file *file,
 				    const char __user *inbuf,
 				    int in_len, int out_len)
@@ -1361,7 +1393,8 @@ static ssize_t (*ucma_cmd_table[])(struct ucma_file *file,
 	[RDMA_USER_CM_CMD_MIGRATE_ID]	= ucma_migrate_id,
 	[RDMA_USER_CM_CMD_QUERY]	= ucma_query,
 	[RDMA_USER_CM_CMD_BIND]		= ucma_bind,
-	[RDMA_USER_CM_CMD_RESOLVE_ADDR]	= ucma_resolve_addr
+	[RDMA_USER_CM_CMD_RESOLVE_ADDR]	= ucma_resolve_addr,
+	[RDMA_USER_CM_CMD_JOIN_MCAST]	= ucma_join_multicast
 };
 
 static ssize_t ucma_write(struct file *filp, const char __user *buf,
diff --git a/include/rdma/rdma_user_cm.h b/include/rdma/rdma_user_cm.h
index c546e18..9f14ca8 100644
--- a/include/rdma/rdma_user_cm.h
+++ b/include/rdma/rdma_user_cm.h
@@ -64,7 +64,8 @@ enum {
 	RDMA_USER_CM_CMD_MIGRATE_ID,
 	RDMA_USER_CM_CMD_QUERY,
 	RDMA_USER_CM_CMD_BIND,
-	RDMA_USER_CM_CMD_RESOLVE_ADDR
+	RDMA_USER_CM_CMD_RESOLVE_ADDR,
+	RDMA_USER_CM_CMD_JOIN_MCAST
 };
 
 /*
@@ -241,6 +242,15 @@ struct rdma_ucm_join_ip_mcast {
 	__u32 id;
 };
 
+struct rdma_ucm_join_mcast {
+	__u64 response;		/* rdma_ucma_create_id_resp */
+	__u64 uid;
+	__u32 id;
+	__u16 addr_size;
+	__u16 reserved;
+	struct sockaddr_storage addr;
+};
+
 struct rdma_ucm_get_event {
 	__u64 response;
 };



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
