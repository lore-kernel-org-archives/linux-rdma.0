From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 1/3] IB/core: Add user MR re-registeration support
Date: Thu, 31 Jul 2014 11:01:28 +0300
Message-ID: <1406793690-3816-2-git-send-email-ogerlitz@mellanox.com>
References: <1406793690-3816-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1406793690-3816-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Memory re-registration is a feature that enables one to change
the attributes of a memory region registered by user-space,
including PD, translation (address and length) and access flags.

Add the required support in uverbs and the kernel verbs API.

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/uverbs.h      |    1 +
 drivers/infiniband/core/uverbs_cmd.c  |   93 +++++++++++++++++++++++++++++++++
 drivers/infiniband/core/uverbs_main.c |    1 +
 include/rdma/ib_verbs.h               |   10 +++-
 include/uapi/rdma/ib_user_verbs.h     |   16 ++++++
 5 files changed, 120 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/core/uverbs.h b/drivers/infiniband/core/uverbs.h
index a283274..643c08a 100644
--- a/drivers/infiniband/core/uverbs.h
+++ b/drivers/infiniband/core/uverbs.h
@@ -221,6 +221,7 @@ IB_UVERBS_DECLARE_CMD(query_port);
 IB_UVERBS_DECLARE_CMD(alloc_pd);
 IB_UVERBS_DECLARE_CMD(dealloc_pd);
 IB_UVERBS_DECLARE_CMD(reg_mr);
+IB_UVERBS_DECLARE_CMD(rereg_mr);
 IB_UVERBS_DECLARE_CMD(dereg_mr);
 IB_UVERBS_DECLARE_CMD(alloc_mw);
 IB_UVERBS_DECLARE_CMD(dealloc_mw);
diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index ea6203e..0600c50 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -1002,6 +1002,99 @@ err_free:
 	return ret;
 }
 
+ssize_t ib_uverbs_rereg_mr(struct ib_uverbs_file *file,
+			   const char __user *buf, int in_len,
+			   int out_len)
+{
+	struct ib_uverbs_rereg_mr      cmd;
+	struct ib_uverbs_rereg_mr_resp resp;
+	struct ib_udata              udata;
+	struct ib_pd                *pd = NULL;
+	struct ib_mr                *mr;
+	struct ib_pd		    *old_pd;
+	int                          ret;
+	struct ib_uobject	    *uobj;
+
+	if (out_len < sizeof(resp))
+		return -ENOSPC;
+
+	if (copy_from_user(&cmd, buf, sizeof(cmd)))
+		return -EFAULT;
+
+	INIT_UDATA(&udata, buf + sizeof(cmd),
+		   (unsigned long) cmd.response + sizeof(resp),
+		   in_len - sizeof(cmd), out_len - sizeof(resp));
+
+	if (cmd.flags & ~IB_MR_REREG_SUPPORTED || !cmd.flags)
+		return -EINVAL;
+
+	if ((cmd.flags & IB_MR_REREG_TRANS) &&
+	    (!cmd.start || !cmd.hca_va || 0 >= cmd.length ||
+	     (cmd.start & ~PAGE_MASK) != (cmd.hca_va & ~PAGE_MASK)))
+			return -EINVAL;
+
+	uobj = idr_write_uobj(&ib_uverbs_mr_idr, cmd.mr_handle,
+			      file->ucontext);
+
+	if (!uobj)
+		return -EINVAL;
+
+	mr = uobj->object;
+
+	if (cmd.flags & IB_MR_REREG_ACCESS) {
+		ret = ib_check_mr_access(cmd.access_flags);
+		if (ret)
+			goto put_uobjs;
+	}
+
+	if (cmd.flags & IB_MR_REREG_PD) {
+		pd = idr_read_pd(cmd.pd_handle, file->ucontext);
+		if (!pd) {
+			ret = -EINVAL;
+			goto put_uobjs;
+		}
+	}
+
+	if (atomic_read(&mr->usecnt)) {
+		ret = -EBUSY;
+		goto put_uobj_pd;
+	}
+
+	old_pd = mr->pd;
+	ret = mr->device->rereg_user_mr(mr, cmd.flags, cmd.start,
+					cmd.length, cmd.hca_va,
+					cmd.access_flags, pd, &udata);
+	if (!ret) {
+		if (cmd.flags & IB_MR_REREG_PD) {
+			atomic_inc(&pd->usecnt);
+			mr->pd = pd;
+			atomic_dec(&old_pd->usecnt);
+		}
+	} else {
+		goto put_uobj_pd;
+	}
+
+	memset(&resp, 0, sizeof(resp));
+	resp.lkey      = mr->lkey;
+	resp.rkey      = mr->rkey;
+
+	if (copy_to_user((void __user *)(unsigned long)cmd.response,
+			 &resp, sizeof(resp)))
+		ret = -EFAULT;
+	else
+		ret = in_len;
+
+put_uobj_pd:
+	if (cmd.flags & IB_MR_REREG_PD)
+		put_pd_read(pd);
+
+put_uobjs:
+
+	put_uobj_write(mr->uobject);
+
+	return ret;
+}
+
 ssize_t ib_uverbs_dereg_mr(struct ib_uverbs_file *file,
 			   const char __user *buf, int in_len,
 			   int out_len)
diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index 08219fb..c73b22a 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -87,6 +87,7 @@ static ssize_t (*uverbs_cmd_table[])(struct ib_uverbs_file *file,
 	[IB_USER_VERBS_CMD_ALLOC_PD]		= ib_uverbs_alloc_pd,
 	[IB_USER_VERBS_CMD_DEALLOC_PD]		= ib_uverbs_dealloc_pd,
 	[IB_USER_VERBS_CMD_REG_MR]		= ib_uverbs_reg_mr,
+	[IB_USER_VERBS_CMD_REREG_MR]		= ib_uverbs_rereg_mr,
 	[IB_USER_VERBS_CMD_DEREG_MR]		= ib_uverbs_dereg_mr,
 	[IB_USER_VERBS_CMD_ALLOC_MW]		= ib_uverbs_alloc_mw,
 	[IB_USER_VERBS_CMD_DEALLOC_MW]		= ib_uverbs_dealloc_mw,
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 7ccef34..ed44cc0 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1097,7 +1097,8 @@ struct ib_mr_attr {
 enum ib_mr_rereg_flags {
 	IB_MR_REREG_TRANS	= 1,
 	IB_MR_REREG_PD		= (1<<1),
-	IB_MR_REREG_ACCESS	= (1<<2)
+	IB_MR_REREG_ACCESS	= (1<<2),
+	IB_MR_REREG_SUPPORTED	= ((IB_MR_REREG_ACCESS << 1) - 1)
 };
 
 /**
@@ -1547,6 +1548,13 @@ struct ib_device {
 						  u64 virt_addr,
 						  int mr_access_flags,
 						  struct ib_udata *udata);
+	int			   (*rereg_user_mr)(struct ib_mr *mr,
+						    int flags,
+						    u64 start, u64 length,
+						    u64 virt_addr,
+						    int mr_access_flags,
+						    struct ib_pd *pd,
+						    struct ib_udata *udata);
 	int                        (*query_mr)(struct ib_mr *mr,
 					       struct ib_mr_attr *mr_attr);
 	int                        (*dereg_mr)(struct ib_mr *mr);
diff --git a/include/uapi/rdma/ib_user_verbs.h b/include/uapi/rdma/ib_user_verbs.h
index cbfdd4c..26daf55 100644
--- a/include/uapi/rdma/ib_user_verbs.h
+++ b/include/uapi/rdma/ib_user_verbs.h
@@ -276,6 +276,22 @@ struct ib_uverbs_reg_mr_resp {
 	__u32 rkey;
 };
 
+struct ib_uverbs_rereg_mr {
+	__u64 response;
+	__u32 mr_handle;
+	__u32 flags;
+	__u64 start;
+	__u64 length;
+	__u64 hca_va;
+	__u32 pd_handle;
+	__u32 access_flags;
+};
+
+struct ib_uverbs_rereg_mr_resp {
+	__u32 lkey;
+	__u32 rkey;
+};
+
 struct ib_uverbs_dereg_mr {
 	__u32 mr_handle;
 };
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
