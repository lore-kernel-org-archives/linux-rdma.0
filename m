From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 26/26 v2] rdma/ucm: allow user space to specify AF_IB when joining multicast
Date: Tue, 6 Apr 2010 17:49:23 -0700
Message-ID: <783281BEB0B348F1ABE7D9EF6E56E9C1@amr.corp.intel.com>
References: <9D903E76C4EA4CF48BF2548F2BC8D2EA@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <9D903E76C4EA4CF48BF2548F2BC8D2EA-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Allow user space applications to join multicast groups using MGIDs
directly.  MGIDs may be passed using AF_IB addresses.  Since the
current multicast join command only supports addresses as large as
sockaddr_in6, define a new structure for joining addresses specified
using sockaddr_ib.

Since port space IB allows the user to specify the qkey when
resolving a remote UD QP address, when joining the multicast
group use the qkey value, if one has been assigned.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
Changes from v1:
Restrict PS IB to using AF_IB multicast addresses.
Use the qkey stored with the rdma_cm_id if it has been set.

Note: specifying transport specific multicast parameters, such
as the qkey, are outside of this series.  This patch simply ensures
that the qkey for a multicast join is in sync with whatever value
the user specified for unicast operation.  Future support for transport
specific parameters can either be accomplished by extending
struct rdma_ucm_join_mcast or through a set_option command. 

 drivers/infiniband/core/cma.c  |   12 +++++++--
 drivers/infiniband/core/ucma.c |   55 ++++++++++++++++++++++++++++++++--------
 include/rdma/rdma_user_cm.h    |   12 ++++++++-
 3 files changed, 65 insertions(+), 14 deletions(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index a642325..a42dd94 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -2934,6 +2934,8 @@ static void cma_set_mgid(struct rdma_id_private *id_priv,
 								 0xFF10A01B)) {
 		/* IPv6 address is an SA assigned MGID. */
 		memcpy(mgid, &sin6->sin6_addr, sizeof *mgid);
+	} else if (addr->sa_family == AF_IB) {
+		memcpy(mgid, &((struct sockaddr_ib *) addr)->sib_addr, sizeof *mgid);
 	} else if ((addr->sa_family == AF_INET6)) {
 		ipv6_ib_mc_map(&sin6->sin6_addr, dev_addr->broadcast, mc_map);
 		if (id_priv->id.ps == RDMA_PS_UDP)
@@ -2961,9 +2963,12 @@ static int cma_join_ib_multicast(struct rdma_id_private *id_priv,
 	if (ret)
 		return ret;
 
+	ret = cma_set_qkey(id_priv, 0);
+	if (ret)
+		return ret;
+
 	cma_set_mgid(id_priv, (struct sockaddr *) &mc->addr, &rec.mgid);
-	if (id_priv->id.ps == RDMA_PS_UDP)
-		rec.qkey = cpu_to_be32(RDMA_UDP_QKEY);
+	rec.qkey = cpu_to_be32(id_priv->qkey);
 	rdma_addr_get_sgid(dev_addr, &rec.port_gid);
 	rec.pkey = cpu_to_be16(ib_addr_get_pkey(dev_addr));
 	rec.join_state = 1;
@@ -3000,6 +3005,9 @@ int rdma_join_multicast(struct rdma_cm_id *id, struct sockaddr *addr,
 	    !cma_comp(id_priv, CMA_ADDR_RESOLVED))
 		return -EINVAL;
 
+	if (id_priv->id.ps == RDMA_PS_IB && addr->sa_family != AF_IB)
+		return -EINVAL;
+
 	mc = kmalloc(sizeof *mc, GFP_KERNEL);
 	if (!mc)
 		return -ENOMEM;
diff --git a/drivers/infiniband/core/ucma.c b/drivers/infiniband/core/ucma.c
index da85dee..ab0e2f9 100644
--- a/drivers/infiniband/core/ucma.c
+++ b/drivers/infiniband/core/ucma.c
@@ -1166,23 +1166,23 @@ static ssize_t ucma_notify(struct ucma_file *file, const char __user *inbuf,
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
 
@@ -1193,14 +1193,14 @@ static ssize_t ucma_join_ip_multicast(struct ucma_file *file,
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
@@ -1225,6 +1225,38 @@ err1:
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
@@ -1388,7 +1420,8 @@ static ssize_t (*ucma_cmd_table[])(struct ucma_file *file,
 	[RDMA_USER_CM_CMD_MIGRATE_ID]	 = ucma_migrate_id,
 	[RDMA_USER_CM_CMD_QUERY]	 = ucma_query,
 	[RDMA_USER_CM_CMD_BIND]		 = ucma_bind,
-	[RDMA_USER_CM_CMD_RESOLVE_ADDR]	 = ucma_resolve_addr
+	[RDMA_USER_CM_CMD_RESOLVE_ADDR]	 = ucma_resolve_addr,
+	[RDMA_USER_CM_CMD_JOIN_MCAST]	 = ucma_join_multicast
 };
 
 static ssize_t ucma_write(struct file *filp, const char __user *buf,
diff --git a/include/rdma/rdma_user_cm.h b/include/rdma/rdma_user_cm.h
index 8b2e9fb..a35c2da 100644
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
