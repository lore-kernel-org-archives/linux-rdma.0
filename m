From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v1 libibverbs 2/2] Add MR re-registeration
Date: Tue,  4 Nov 2014 16:59:39 +0200
Message-ID: <1415113179-6699-3-git-send-email-matanb@mellanox.com>
References: <1415113179-6699-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1415113179-6699-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Memory re-registeration is a feature that enables one to change
the attributes of a memory region, including PD, translation
(address and length) and access flags.

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 include/infiniband/driver.h   |  5 ++++
 include/infiniband/kern-abi.h | 20 ++++++++++++++++
 include/infiniband/verbs.h    |  9 ++++++-
 src/cmd.c                     | 29 +++++++++++++++++++++++
 src/libibverbs.map            |  1 +
 src/verbs.c                   | 55 +++++++++++++++++++++++++++++++++++++++++++
 6 files changed, 118 insertions(+), 1 deletion(-)

diff --git a/include/infiniband/driver.h b/include/infiniband/driver.h
index 5cc092b..4aa2a03 100644
--- a/include/infiniband/driver.h
+++ b/include/infiniband/driver.h
@@ -128,6 +128,11 @@ int ibv_cmd_reg_mr(struct ibv_pd *pd, void *addr, size_t length,
 		   struct ibv_mr *mr, struct ibv_reg_mr *cmd,
 		   size_t cmd_size,
 		   struct ibv_reg_mr_resp *resp, size_t resp_size);
+int ibv_cmd_rereg_mr(struct ibv_mr *mr, uint32_t flags, void *addr,
+		     size_t length, uint64_t hca_va, int access,
+		     struct ibv_pd *pd, struct ibv_rereg_mr *cmd,
+		     size_t cmd_sz, struct ibv_rereg_mr_resp *resp,
+		     size_t resp_sz);
 int ibv_cmd_dereg_mr(struct ibv_mr *mr);
 int ibv_cmd_create_cq(struct ibv_context *context, int cqe,
 		      struct ibv_comp_channel *channel,
diff --git a/include/infiniband/kern-abi.h b/include/infiniband/kern-abi.h
index 91b45d8..77d70ce 100644
--- a/include/infiniband/kern-abi.h
+++ b/include/infiniband/kern-abi.h
@@ -333,6 +333,26 @@ struct ibv_reg_mr_resp {
 	__u32 rkey;
 };
 
+struct ibv_rereg_mr {
+	__u32 command;
+	__u16 in_words;
+	__u16 out_words;
+	__u64 response;
+	__u32 mr_handle;
+	__u32 flags;
+	__u64 start;
+	__u64 length;
+	__u64 hca_va;
+	__u32 pd_handle;
+	__u32 access_flags;
+	__u64 driver_data[0];
+};
+
+struct ibv_rereg_mr_resp {
+	__u32 lkey;
+	__u32 rkey;
+};
+
 struct ibv_dereg_mr {
 	__u32 command;
 	__u16 in_words;
diff --git a/include/infiniband/verbs.h b/include/infiniband/verbs.h
index 7276c40..9b88bab 100644
--- a/include/infiniband/verbs.h
+++ b/include/infiniband/verbs.h
@@ -342,7 +342,8 @@ enum ibv_rereg_mr_flags {
 	IBV_REREG_MR_CHANGE_TRANSLATION	= (1 << 0),
 	IBV_REREG_MR_CHANGE_PD		= (1 << 1),
 	IBV_REREG_MR_CHANGE_ACCESS	= (1 << 2),
-	IBV_REREG_MR_KEEP_VALID		= (1 << 3)
+	IBV_REREG_MR_KEEP_VALID		= (1 << 3),
+	IBV_REREG_MR_FLAGS_SUPPORTED	= ((IBV_REREG_MR_KEEP_VALID << 1) - 1)
 };
 
 struct ibv_mr {
@@ -1157,6 +1158,12 @@ struct ibv_mr *ibv_reg_mr(struct ibv_pd *pd, void *addr,
 			  size_t length, int access);
 
 /**
+ * ibv_rereg_mr - Re-Register a memory region
+ */
+int ibv_rereg_mr(struct ibv_mr *mr, int flags,
+		 struct ibv_pd *pd, void *addr,
+		 size_t length, uint64_t access);
+/**
  * ibv_dereg_mr - Deregister a memory region
  */
 int ibv_dereg_mr(struct ibv_mr *mr);
diff --git a/src/cmd.c b/src/cmd.c
index 45ea06f..4be9572 100644
--- a/src/cmd.c
+++ b/src/cmd.c
@@ -267,6 +267,35 @@ int ibv_cmd_reg_mr(struct ibv_pd *pd, void *addr, size_t length,
 	return 0;
 }
 
+int ibv_cmd_rereg_mr(struct ibv_mr *mr, uint32_t flags, void *addr,
+		     size_t length, uint64_t hca_va, int access,
+		     struct ibv_pd *pd, struct ibv_rereg_mr *cmd,
+		     size_t cmd_sz, struct ibv_rereg_mr_resp *resp,
+		     size_t resp_sz)
+{
+	IBV_INIT_CMD_RESP(cmd, cmd_sz, REREG_MR, resp, resp_sz);
+
+	cmd->mr_handle	  = mr->handle;
+	cmd->flags	  = flags;
+	cmd->start	  = (uintptr_t) addr;
+	cmd->length	  = length;
+	cmd->hca_va	  = hca_va;
+	cmd->pd_handle	  = (flags & IBV_REREG_MR_CHANGE_PD) ? pd->handle : 0;
+	cmd->access_flags = access;
+
+	if (write(mr->context->cmd_fd, cmd, cmd_sz) != cmd_sz)
+		return errno;
+
+	(void) VALGRIND_MAKE_MEM_DEFINED(resp, resp_sz);
+
+	mr->lkey    = resp->lkey;
+	mr->rkey    = resp->rkey;
+	if (flags & IBV_REREG_MR_CHANGE_PD)
+		mr->context = pd->context;
+
+	return 0;
+}
+
 int ibv_cmd_dereg_mr(struct ibv_mr *mr)
 {
 	struct ibv_dereg_mr cmd;
diff --git a/src/libibverbs.map b/src/libibverbs.map
index 30212f3..307f412 100644
--- a/src/libibverbs.map
+++ b/src/libibverbs.map
@@ -108,5 +108,6 @@ IBVERBS_1.1 {
 		ibv_cmd_create_srq_ex;
 		ibv_cmd_create_qp_ex;
 		ibv_cmd_open_qp;
+		ibv_cmd_rereg_mr;
 
 } IBVERBS_1.0;
diff --git a/src/verbs.c b/src/verbs.c
index a6aae70..2e5abde 100644
--- a/src/verbs.c
+++ b/src/verbs.c
@@ -223,6 +223,61 @@ struct ibv_mr *__ibv_reg_mr(struct ibv_pd *pd, void *addr,
 }
 default_symver(__ibv_reg_mr, ibv_reg_mr);
 
+int __ibv_rereg_mr(struct ibv_mr *mr, int flags,
+		   struct ibv_pd *pd, void *addr,
+		   size_t length, uint64_t access)
+{
+	int dofork_onfail = 0;
+	int err;
+	void *old_addr;
+	size_t old_len;
+
+	if (flags & ~IBV_REREG_MR_FLAGS_SUPPORTED)
+		return errno = EINVAL;
+
+	if ((flags & IBV_REREG_MR_CHANGE_TRANSLATION) &&
+	    (0 >= length))
+		return errno = EINVAL;
+
+	if (!(flags & IBV_REREG_MR_CHANGE_ACCESS))
+		access = 0;
+
+	if ((flags & IBV_REREG_MR_CHANGE_TRANSLATION) &&
+	    (addr == NULL))
+		return errno = EINVAL;
+
+	if (NULL == mr->context->ops.rereg_mr)
+		return errno = ENOSYS;
+
+	/* If address will be allocated internally we should
+	   call don't fork later after having addr.
+	   */
+	if (flags & IBV_REREG_MR_CHANGE_TRANSLATION) {
+		err = ibv_dontfork_range(addr, length);
+		if (err)
+			return err;
+		dofork_onfail = 1;
+	}
+
+	old_addr = mr->addr;
+	old_len = mr->length;
+	err = mr->context->ops.rereg_mr(mr, flags, pd, addr, length, access);
+	if (!err) {
+		if (flags & IBV_REREG_MR_CHANGE_TRANSLATION) {
+			ibv_dofork_range(old_addr, old_len);
+			mr->addr    = addr;
+			mr->length  = length;
+		}
+		if (flags & IBV_REREG_MR_CHANGE_PD)
+			mr->pd = pd;
+	} else if (dofork_onfail) {
+		ibv_dofork_range(addr, length);
+	}
+
+	return err;
+}
+default_symver(__ibv_rereg_mr, ibv_rereg_mr);
+
 int __ibv_dereg_mr(struct ibv_mr *mr)
 {
 	int ret;
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
