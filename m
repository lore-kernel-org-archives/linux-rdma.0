From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 26/26] rdma/ucm: allow user space to specify AF_IB when joining multicast
Date: Thu, 1 Apr 2010 10:08:41 -0700
Message-ID: <9D903E76C4EA4CF48BF2548F2BC8D2EA@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
References: 
In-Reply-To: 
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Allow user space applications to join multicast groups using MGIDs
directly.  MGIDs may be passed using AF_IB addresses.  Since the
current multicast join command only supports addresses as large as
sockaddr_in6, define a new structure for joining addresses specified
using sockaddr_ib.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---

 drivers/infiniband/core/cma.c  |    8 ++++--
 drivers/infiniband/core/ucma.c |   55 ++++++++++++++++++++++++++++++++--------
 include/rdma/rdma_user_cm.h    |   12 ++++++++-
 3 files changed, 60 insertions(+), 15 deletions(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index e0bdb80..4adad37 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -2928,14 +2928,16 @@ static void cma_set_mgid(struct rdma_id_private *id_priv,
 								 0xFF10A01B)) {
 		/* IPv6 address is an SA assigned MGID. */
 		memcpy(mgid, &sin6->sin6_addr, sizeof *mgid);
+	} else if (addr->sa_family == AF_IB) {
+		memcpy(mgid, &((struct sockaddr_ib *) addr)->sib_addr, sizeof *mgid);
 	} else if ((addr->sa_family == AF_INET6)) {
 		ipv6_ib_mc_map(&sin6->sin6_addr, dev_addr->broadcast, mc_map);
-		if (id_priv->id.ps == RDMA_PS_UDP)
+		if (id_priv->id.ps == RDMA_PS_UDP || id_priv->id.ps == RDMA_PS_IB)
 			mc_map[7] = 0x01;	/* Use RDMA CM signature */
 		*mgid = *(union ib_gid *) (mc_map + 4);
 	} else {
 		ip_ib_mc_map(sin->sin_addr.s_addr, dev_addr->broadcast, mc_map);
-		if (id_priv->id.ps == RDMA_PS_UDP)
+		if (id_priv->id.ps == RDMA_PS_UDP || id_priv->id.ps == RDMA_PS_IB)
 			mc_map[7] = 0x01;	/* Use RDMA CM signature */
 		*mgid = *(union ib_gid *) (mc_map + 4);
 	}
@@ -2956,7 +2958,7 @@ static int cma_join_ib_multicast(struct rdma_id_private *id_priv,
 		return ret;
 
 	cma_set_mgid(id_priv, (struct sockaddr *) &mc->addr, &rec.mgid);
-	if (id_priv->id.ps == RDMA_PS_UDP)
+	if (id_priv->id.ps == RDMA_PS_UDP || id_priv->id.ps == RDMA_PS_IB)
 		rec.qkey = cpu_to_be32(RDMA_UDP_QKEY);
 	rdma_addr_get_sgid(dev_addr, &rec.port_gid);
 	rec.pkey = cpu_to_be16(ib_addr_get_pkey(dev_addr));
diff --git a/drivers/infiniband/core/ucma.c b/drivers/infiniband/core/ucma.c
index f735150..8cf0d70 100644
--- a/drivers/infiniband/core/ucma.c
+++ b/drivers/infiniband/core/ucma.c
@@ -1161,23 +1161,23 @@ static ssize_t ucma_notify(struct ucma_file *file, const char __user *inbuf,
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
 
@@ -1188,14 +1188,14 @@ static ssize_t ucma_join_ip_multicast(struct ucma_file *file,
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
@@ -1220,6 +1220,38 @@ err1:
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
@@ -1383,7 +1415,8 @@ static ssize_t (*ucma_cmd_table[])(struct ucma_file *file,
 	[RDMA_USER_CM_CMD_MIGRATE_ID]	 = ucma_migrate_id,
 	[RDMA_USER_CM_CMD_QUERY]	 = ucma_query,
 	[RDMA_USER_CM_CMD_BIND]		 = ucma_bind,
-	[RDMA_USER_CM_CMD_RESOLVE_ADDR]	 = ucma_resolve_addr
+	[RDMA_USER_CM_CMD_RESOLVE_ADDR]	 = ucma_resolve_addr,
+	[RDMA_USER_CM_CMD_JOIN_MCAST]	 = ucma_join_multicast
 };
 
 static ssize_t ucma_write(struct file *filp, const char __user *buf,
diff --git a/include/rdma/rdma_user_cm.h b/include/rdma/rdma_user_cm.h
index d488184..c699b4e 100644
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
@@ -242,6 +243,15 @@ struct rdma_ucm_join_ip_mcast {
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
