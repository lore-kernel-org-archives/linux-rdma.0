From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 24/26] rdma/ucm: allow user space to bind to AF_IB
Date: Thu, 1 Apr 2010 10:08:41 -0700
Message-ID: <11C3695D59984DD3A5385AB0B78AF0CA@amr.corp.intel.com>
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

Support user space binding to addresses using AF_IB.  Since
sockaddr_ib is larger than sockaddr_in6, we need to define
a larger structure when binding using AF_IB.  This time we
use sockaddr_storage to cover future cases.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---

 drivers/infiniband/core/ucma.c |   27 ++++++++++++++++++++++++++-
 include/rdma/rdma_user_cm.h    |   10 +++++++++-
 2 files changed, 35 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/ucma.c b/drivers/infiniband/core/ucma.c
index 6456502..aa50080 100644
--- a/drivers/infiniband/core/ucma.c
+++ b/drivers/infiniband/core/ucma.c
@@ -536,6 +536,30 @@ static ssize_t ucma_bind_ip(struct ucma_file *file, const char __user *inbuf,
 	return ret;
 }
 
+static ssize_t ucma_bind(struct ucma_file *file, const char __user *inbuf,
+			 int in_len, int out_len)
+{
+	struct rdma_ucm_bind cmd;
+	struct sockaddr *addr;
+	struct ucma_context *ctx;
+	int ret;
+
+	if (copy_from_user(&cmd, inbuf, sizeof(cmd)))
+		return -EFAULT;
+
+	addr = (struct sockaddr *) &cmd.addr;
+	if (cmd.reserved || !cmd.addr_size || (cmd.addr_size != rdma_addr_size(addr)))
+		return -EINVAL;
+
+	ctx = ucma_get_ctx(file, cmd.id);
+	if (IS_ERR(ctx))
+		return PTR_ERR(ctx);
+
+	ret = rdma_bind_addr(ctx->cm_id, addr);
+	ucma_put_ctx(ctx);
+	return ret;
+}
+
 static ssize_t ucma_resolve_ip(struct ucma_file *file,
 			       const char __user *inbuf,
 			       int in_len, int out_len)
@@ -1330,7 +1354,8 @@ static ssize_t (*ucma_cmd_table[])(struct ucma_file *file,
 	[RDMA_USER_CM_CMD_JOIN_IP_MCAST] = ucma_join_ip_multicast,
 	[RDMA_USER_CM_CMD_LEAVE_MCAST]	 = ucma_leave_multicast,
 	[RDMA_USER_CM_CMD_MIGRATE_ID]	 = ucma_migrate_id,
-	[RDMA_USER_CM_CMD_QUERY]	 = ucma_query
+	[RDMA_USER_CM_CMD_QUERY]	 = ucma_query,
+	[RDMA_USER_CM_CMD_BIND]		 = ucma_bind
 };
 
 static ssize_t ucma_write(struct file *filp, const char __user *buf,
diff --git a/include/rdma/rdma_user_cm.h b/include/rdma/rdma_user_cm.h
index c1e0ac9..375f2a9 100644
--- a/include/rdma/rdma_user_cm.h
+++ b/include/rdma/rdma_user_cm.h
@@ -62,7 +62,8 @@ enum {
 	RDMA_USER_CM_CMD_JOIN_IP_MCAST,
 	RDMA_USER_CM_CMD_LEAVE_MCAST,
 	RDMA_USER_CM_CMD_MIGRATE_ID,
-	RDMA_USER_CM_CMD_QUERY
+	RDMA_USER_CM_CMD_QUERY,
+	RDMA_USER_CM_CMD_BIND
 };
 
 /*
@@ -102,6 +103,13 @@ struct rdma_ucm_bind_ip {
 	__u32 id;
 };
 
+struct rdma_ucm_bind {
+	__u32 id;
+	__u16 addr_size;
+	__u16 reserved;
+	struct sockaddr_storage addr;
+};
+
 struct rdma_ucm_resolve_ip {
 	struct sockaddr_in6 src_addr;
 	struct sockaddr_in6 dst_addr;



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
