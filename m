From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V3 libibverbs 2/2] Add MR re-registeration
Date: Mon, 14 Mar 2016 12:59:07 +0200
Message-ID: <1457953147-4280-3-git-send-email-yishaih@mellanox.com>
References: <1457953147-4280-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1457953147-4280-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Memory re-registeration is a feature that enables one to change
the attributes of a memory region, including PD, translation
(address and length) and access flags.

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 Makefile.am                   |  3 +-
 include/infiniband/driver.h   |  5 +++
 include/infiniband/kern-abi.h | 20 ++++++++++++
 include/infiniband/verbs.h    | 23 ++++++++++++-
 man/ibv_rereg_mr.3            | 76 +++++++++++++++++++++++++++++++++++++++++++
 src/cmd.c                     | 29 +++++++++++++++++
 src/libibverbs.map            |  1 +
 src/verbs.c                   | 62 +++++++++++++++++++++++++++++++++++
 8 files changed, 217 insertions(+), 2 deletions(-)
 create mode 100644 man/ibv_rereg_mr.3

diff --git a/Makefile.am b/Makefile.am
index eefda4a..03c556a 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -64,7 +64,8 @@ man_MANS = man/ibv_asyncwatch.1 man/ibv_devices.1 man/ibv_devinfo.1	\
     man/ibv_req_notify_cq.3 man/ibv_resize_cq.3 man/ibv_rate_to_mbps.3  \
     man/ibv_create_qp_ex.3 man/ibv_create_srq_ex.3 man/ibv_open_xrcd.3  \
     man/ibv_get_srq_num.3 man/ibv_open_qp.3 man/ibv_query_device_ex.3	\
-    man/ibv_alloc_mw.3 man/ibv_bind_mw.3 man/ibv_inc_rkey.3
+    man/ibv_alloc_mw.3 man/ibv_bind_mw.3 man/ibv_inc_rkey.3		\
+    man/ibv_rereg_mr.3
 
 DEBIAN = debian/changelog debian/compat debian/control debian/copyright \
     debian/ibverbs-utils.install debian/libibverbs1.install \
diff --git a/include/infiniband/driver.h b/include/infiniband/driver.h
index a37ee06..053ad5f 100644
--- a/include/infiniband/driver.h
+++ b/include/infiniband/driver.h
@@ -138,6 +138,11 @@ int ibv_cmd_reg_mr(struct ibv_pd *pd, void *addr, size_t length,
 		   struct ibv_mr *mr, struct ibv_reg_mr *cmd,
 		   size_t cmd_size,
 		   struct ibv_reg_mr_resp *resp, size_t resp_size);
+int ibv_cmd_rereg_mr(struct ibv_mr *mr, uint32_t flags, void *addr,
+		     size_t length, uint64_t hca_va, int access,
+		     struct ibv_pd *pd, struct ibv_rereg_mr *cmd,
+		     size_t cmd_sz, struct ibv_rereg_mr_resp *resp,
+		     size_t resp_sz);
 int ibv_cmd_dereg_mr(struct ibv_mr *mr);
 int ibv_cmd_alloc_mw(struct ibv_pd *pd, enum ibv_mw_type type,
 		     struct ibv_mw *mw, struct ibv_alloc_mw *cmd,
diff --git a/include/infiniband/kern-abi.h b/include/infiniband/kern-abi.h
index 9f733bb..31da4be 100644
--- a/include/infiniband/kern-abi.h
+++ b/include/infiniband/kern-abi.h
@@ -364,6 +364,26 @@ struct ibv_reg_mr_resp {
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
index 709926d..7f66480 100644
--- a/include/infiniband/verbs.h
+++ b/include/infiniband/verbs.h
@@ -428,7 +428,8 @@ enum ibv_rereg_mr_flags {
 	IBV_REREG_MR_CHANGE_TRANSLATION	= (1 << 0),
 	IBV_REREG_MR_CHANGE_PD		= (1 << 1),
 	IBV_REREG_MR_CHANGE_ACCESS	= (1 << 2),
-	IBV_REREG_MR_KEEP_VALID		= (1 << 3)
+	IBV_REREG_MR_KEEP_VALID		= (1 << 3),
+	IBV_REREG_MR_FLAGS_SUPPORTED	= ((IBV_REREG_MR_KEEP_VALID << 1) - 1)
 };
 
 struct ibv_mr {
@@ -1259,6 +1260,26 @@ static inline int ibv_close_xrcd(struct ibv_xrcd *xrcd)
 struct ibv_mr *ibv_reg_mr(struct ibv_pd *pd, void *addr,
 			  size_t length, int access);
 
+
+enum ibv_rereg_mr_err_code {
+	/* Old MR is valid, invalid input */
+	IBV_REREG_MR_ERR_INPUT = -1,
+	/* Old MR is valid, failed via dont fork on new address range */
+	IBV_REREG_MR_ERR_DONT_FORK_NEW = -2,
+	/* New MR is valid, failed via do fork on old address range */
+	IBV_REREG_MR_ERR_DO_FORK_OLD = -3,
+	/* MR shouldn't be used, command error */
+	IBV_REREG_MR_ERR_CMD = -4,
+	/* MR shouldn't be used, command error, invalid fork state on new address range */
+	IBV_REREG_MR_ERR_CMD_AND_DO_FORK_NEW = -5,
+};
+
+/**
+ * ibv_rereg_mr - Re-Register a memory region
+ */
+int ibv_rereg_mr(struct ibv_mr *mr, int flags,
+		 struct ibv_pd *pd, void *addr,
+		 size_t length, int access);
 /**
  * ibv_dereg_mr - Deregister a memory region
  */
diff --git a/man/ibv_rereg_mr.3 b/man/ibv_rereg_mr.3
new file mode 100644
index 0000000..a678437
--- /dev/null
+++ b/man/ibv_rereg_mr.3
@@ -0,0 +1,76 @@
+.\" -*- nroff -*-
+.\"
+.TH IBV_REREG_MR 3 2016-03-13 libibverbs "Libibverbs Programmer's Manual"
+.SH "NAME"
+ibv_rereg_mr \- re-register a memory region (MR)
+.SH "SYNOPSIS"
+.nf
+.B #include <infiniband/verbs.h>
+.sp
+.BI "int ibv_rereg_mr(struct ibv_mr " "*mr" ", int " " flags" ,
+.BI "                 struct ibv_pd * " "pd" ", void " " *addr",
+.BI "                 size_t " " length" ", int " " access");
+.fi
+.fi
+.SH "DESCRIPTION"
+.B ibv_rereg_mr()
+Modifies the attributes of an existing memory region (MR)
+.I mr\fR.
+Conceptually, this call performs the functions deregister memory region
+followed by register memory region.  Where possible,
+resources are reused instead of deallocated and reallocated.
+.PP
+.I flags\fR
+is a bit-mask used to indicate which of the following properties of the memory region are being modified. Flags should be a combination (bit field) of:
+.PP
+.TP
+.B IBV_REREG_MR_CHANGE_TRANSLATION \fR Change translation (location and length)
+.TP
+.B IBV_REREG_MR_CHANGE_PD \fR Change protection domain
+.TP
+.B IBV_REREG_MR_CHANGE_ACCESS \fR Change access flags
+.PP
+When
+.B IBV_REREG_MR_CHANGE_PD
+is used,
+.I pd\fR
+represents the new PD this MR should be registered to.
+.br
+When
+.B IBV_REREG_MR_CHANGE_TRANSLATION
+is used,
+.I addr\fR.
+represents the virtual address (user-space pointer) of the new MR, while
+.I length\fR
+represents its length.
+.PP
+The access and other flags are represented in the field
+.I access\fR.
+This field describes the desired memory protection attributes; it is either 0 or the bitwise OR of one or more of ibv_access_flags.
+.TP
+.SH "RETURN VALUE"
+.B ibv_rereg_mr()
+returns 0 on success, otherwise an error has occurred,
+.I enum ibv_rereg_mr_err_code\fR
+represents the error as of below.
+.br
+IBV_REREG_MR_ERR_INPUT - Old MR is valid, an input error was detected by libibverbs.
+.br
+IBV_REREG_MR_ERR_DONT_FORK_NEW - Old MR is valid, failed via dont fork on new address range.
+.br
+IBV_REREG_MR_ERR_DO_FORK_OLD - New MR is valid, failed via do fork on old address range.
+.br
+IBV_REREG_MR_ERR_CMD - MR shouldn't be used, command error.
+.br
+IBV_REREG_MR_ERR_CMD_AND_DO_FORK_NEW - MR shouldn't be used, command error, invalid fork state on new address range.
+
+.SH "NOTES"
+Even on a failure, the user still needs to call ibv_dereg_mr on this MR.
+.SH "SEE ALSO"
+.BR ibv_reg_mr (3),
+.BR ibv_dereg_mr (3),
+.SH "AUTHORS"
+.TP
+Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
+.TP
+Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
diff --git a/src/cmd.c b/src/cmd.c
index 5b5bfee..b8c51ce 100644
--- a/src/cmd.c
+++ b/src/cmd.c
@@ -334,6 +334,35 @@ int ibv_cmd_reg_mr(struct ibv_pd *pd, void *addr, size_t length,
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
+	cmd->start	  = (uintptr_t)addr;
+	cmd->length	  = length;
+	cmd->hca_va	  = hca_va;
+	cmd->pd_handle	  = (flags & IBV_REREG_MR_CHANGE_PD) ? pd->handle : 0;
+	cmd->access_flags = access;
+
+	if (write(mr->context->cmd_fd, cmd, cmd_sz) != cmd_sz)
+		return errno;
+
+	(void)VALGRIND_MAKE_MEM_DEFINED(resp, resp_sz);
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
index dd269bf..a150416 100644
--- a/src/libibverbs.map
+++ b/src/libibverbs.map
@@ -116,5 +116,6 @@ IBVERBS_1.1 {
 		ibv_cmd_create_qp_ex;
 		ibv_cmd_create_qp_ex2;
 		ibv_cmd_open_qp;
+		ibv_cmd_rereg_mr;
 
 } IBVERBS_1.0;
diff --git a/src/verbs.c b/src/verbs.c
index ada3515..68888c3 100644
--- a/src/verbs.c
+++ b/src/verbs.c
@@ -228,6 +228,68 @@ struct ibv_mr *__ibv_reg_mr(struct ibv_pd *pd, void *addr,
 }
 default_symver(__ibv_reg_mr, ibv_reg_mr);
 
+int __ibv_rereg_mr(struct ibv_mr *mr, int flags,
+		   struct ibv_pd *pd, void *addr,
+		   size_t length, int access)
+{
+	int dofork_onfail = 0;
+	int err;
+	void *old_addr;
+	size_t old_len;
+
+	if (flags & ~IBV_REREG_MR_FLAGS_SUPPORTED) {
+		errno = EINVAL;
+		return IBV_REREG_MR_ERR_INPUT;
+	}
+
+	if ((flags & IBV_REREG_MR_CHANGE_TRANSLATION) &&
+	    (!length || !addr)) {
+		errno = EINVAL;
+		return IBV_REREG_MR_ERR_INPUT;
+	}
+
+	if (access && !(flags & IBV_REREG_MR_CHANGE_ACCESS)) {
+		errno = EINVAL;
+		return IBV_REREG_MR_ERR_INPUT;
+	}
+
+	if (!mr->context->ops.rereg_mr) {
+		errno = ENOSYS;
+		return IBV_REREG_MR_ERR_INPUT;
+	}
+
+	if (flags & IBV_REREG_MR_CHANGE_TRANSLATION) {
+		err = ibv_dontfork_range(addr, length);
+		if (err)
+			return IBV_REREG_MR_ERR_DONT_FORK_NEW;
+		dofork_onfail = 1;
+	}
+
+	old_addr = mr->addr;
+	old_len = mr->length;
+	err = mr->context->ops.rereg_mr(mr, flags, pd, addr, length, access);
+	if (!err) {
+		if (flags & IBV_REREG_MR_CHANGE_PD)
+			mr->pd = pd;
+		if (flags & IBV_REREG_MR_CHANGE_TRANSLATION) {
+			mr->addr    = addr;
+			mr->length  = length;
+			err = ibv_dofork_range(old_addr, old_len);
+			if (err)
+				return IBV_REREG_MR_ERR_DO_FORK_OLD;
+		}
+	} else {
+		err = IBV_REREG_MR_ERR_CMD;
+		if (dofork_onfail) {
+			if (ibv_dofork_range(addr, length))
+				err = IBV_REREG_MR_ERR_CMD_AND_DO_FORK_NEW;
+		}
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
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
