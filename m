From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [RFC] [PATCH 21/22] [for 2.6.36] rdma/ucm: allow user space to pass AF_IB into resolve
Date: Tue, 23 Mar 2010 11:28:33 -0700
Message-ID: <B34ED100AF0C47E09FD9E72E5A43FD7D@amr.corp.intel.com>
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

Allow user space applications to call resolve_addr using
AF_IB.  To support sockaddr_ib, we need to define a new
structure capable of handling the larger address size.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---

 drivers/infiniband/core/ucma.c |   30 +++++++++++++++++++++++++++++-
 include/rdma/rdma_user_cm.h    |   13 ++++++++++++-
 2 files changed, 41 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/ucma.c b/drivers/infiniband/core/ucma.c
index e2d8dcf..2224a05 100644
--- a/drivers/infiniband/core/ucma.c
+++ b/drivers/infiniband/core/ucma.c
@@ -560,6 +560,33 @@ static ssize_t ucma_resolve_ip(struct ucma_file *file,
 	return ret;
 }
 
+static ssize_t ucma_resolve_addr(struct ucma_file *file,
+				 const char __user *inbuf,
+				 int in_len, int out_len)
+{
+	struct rdma_ucm_resolve_addr cmd;
+	struct sockaddr *src, *dst;
+	struct ucma_context *ctx;
+	int ret;
+
+	if (copy_from_user(&cmd, inbuf, sizeof(cmd)))
+		return -EFAULT;
+
+	src = (struct sockaddr *) &cmd.src_addr;
+	dst = (struct sockaddr *) &cmd.dst_addr;
+	if (cmd.reserved || (cmd.src_size && (cmd.src_size != rdma_addr_size(src))) ||
+	    !cmd.dst_size || (cmd.dst_size != rdma_addr_size(dst)))
+		return -EINVAL;
+
+	ctx = ucma_get_ctx(file, cmd.id);
+	if (IS_ERR(ctx))
+		return PTR_ERR(ctx);
+
+	ret = rdma_resolve_addr(ctx->cm_id, src, dst, cmd.timeout_ms);
+	ucma_put_ctx(ctx);
+	return ret;
+}
+
 static ssize_t ucma_resolve_route(struct ucma_file *file,
 				  const char __user *inbuf,
 				  int in_len, int out_len)
@@ -1333,7 +1360,8 @@ static ssize_t (*ucma_cmd_table[])(struct ucma_file *file,
 	[RDMA_USER_CM_CMD_LEAVE_MCAST]	= ucma_leave_multicast,
 	[RDMA_USER_CM_CMD_MIGRATE_ID]	= ucma_migrate_id,
 	[RDMA_USER_CM_CMD_QUERY]	= ucma_query,
-	[RDMA_USER_CM_CMD_BIND]		= ucma_bind
+	[RDMA_USER_CM_CMD_BIND]		= ucma_bind,
+	[RDMA_USER_CM_CMD_RESOLVE_ADDR]	= ucma_resolve_addr
 };
 
 static ssize_t ucma_write(struct file *filp, const char __user *buf,
diff --git a/include/rdma/rdma_user_cm.h b/include/rdma/rdma_user_cm.h
index 009b8da..c546e18 100644
--- a/include/rdma/rdma_user_cm.h
+++ b/include/rdma/rdma_user_cm.h
@@ -63,7 +63,8 @@ enum {
 	RDMA_USER_CM_CMD_LEAVE_MCAST,
 	RDMA_USER_CM_CMD_MIGRATE_ID,
 	RDMA_USER_CM_CMD_QUERY,
-	RDMA_USER_CM_CMD_BIND
+	RDMA_USER_CM_CMD_BIND,
+	RDMA_USER_CM_CMD_RESOLVE_ADDR
 };
 
 /*
@@ -116,6 +117,16 @@ struct rdma_ucm_resolve_ip {
 	__u32 timeout_ms;
 };
 
+struct rdma_ucm_resolve_addr {
+	__u32 id;
+	__u32 timeout_ms;
+	__u16 src_size;
+	__u16 dst_size;
+	__u32 reserved;
+	struct sockaddr_storage src_addr;
+	struct sockaddr_storage dst_addr;
+};
+
 struct rdma_ucm_resolve_route {
 	__u32 id;
 	__u32 timeout_ms;



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
