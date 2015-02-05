From: majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Subject: [PATCH libibverbs 2/3] Add Memory Windows support
Date: Thu,  5 Feb 2015 13:10:36 +0200
Message-ID: <1423134637-14438-3-git-send-email-majd@mellanox.com>
References: <1423134637-14438-1-git-send-email-majd@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1423134637-14438-1-git-send-email-majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Memory Windows(MW) is a method to raise the remote privileges of memory range
within a Memory Region(MR).

A MW is allocated using ibv_alloc_mw, and for it to be useful it should be
bound to a MR using ibv_bind_mw.

The bind operation generates a new R_key with the new permissions for the MW.
The advantages of MWs is the light weight generation of R_key with changing
permissions.

MW type 1's R_key can be invalidated by binding the MW to a MR where the length
of the MW is zero.

A local MW type 2's R_key can be invalidated by sending a work request(WR),
where the immediate data contains the MW's R_key and the opcode is
IBV_WR_LOCAL_INV.

When done, the user can unbind and deallocate the MW using ibv_dealloc_mw.

Add the following verbs:
1. ibv_alloc_mw: Takes a Protection Domain(PD) and type of MW, and return
		 a MW.
2. ibv_bind_mw: Takes a Queue Pair(QP), a type 1 MW and bind information (MR,
		address, length, access flags). Then it posts a bind request
		to the given QP. Upon success, the MW's R_key is updated.
		For type 2 MW, one should directly post bind WQE to the QP,
		using ibv_post_send.
3. ibv_dealloc_mw: Unbinds and deallocates the MW.

Signed-off-by: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 Makefile.am                   |    7 ++-
 include/infiniband/driver.h   |    6 +++
 include/infiniband/kern-abi.h |   23 ++++++++++
 include/infiniband/verbs.h    |   75 ++++++++++++++++++++++++++++++---
 man/ibv_alloc_mw.3            |   49 ++++++++++++++++++++++
 man/ibv_bind_mw.3             |   91 +++++++++++++++++++++++++++++++++++++++++
 man/ibv_inc_rkey.3            |   29 +++++++++++++
 man/ibv_post_send.3           |   22 ++++++++++
 src/cmd.c                     |   37 +++++++++++++++++
 src/libibverbs.map            |    3 +
 10 files changed, 333 insertions(+), 9 deletions(-)
 create mode 100644 man/ibv_alloc_mw.3
 create mode 100644 man/ibv_bind_mw.3
 create mode 100644 man/ibv_inc_rkey.3

diff --git a/Makefile.am b/Makefile.am
index a6767de..5ae1dab 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -58,7 +58,8 @@ man_MANS = man/ibv_asyncwatch.1 man/ibv_devices.1 man/ibv_devinfo.1	\
     man/ibv_query_srq.3 man/ibv_rate_to_mult.3 man/ibv_reg_mr.3		\
     man/ibv_req_notify_cq.3 man/ibv_resize_cq.3 man/ibv_rate_to_mbps.3  \
     man/ibv_create_qp_ex.3 man/ibv_create_srq_ex.3 man/ibv_open_xrcd.3  \
-    man/ibv_get_srq_num.3 man/ibv_open_qp.3
+    man/ibv_get_srq_num.3 man/ibv_open_qp.3 man/ibv_alloc_mw.3		\
+    man/ibv_bind_mw.3 man/ibv_inc_rkey.3
 
 DEBIAN = debian/changelog debian/compat debian/control debian/copyright \
     debian/ibverbs-utils.install debian/libibverbs1.install \
@@ -94,6 +95,7 @@ install-data-hook:
 	$(RM) ibv_port_state_str.3 && \
 	$(RM) mbps_to_ibv_rate.3 && \
 	$(RM) ibv_close_xrcd.3 && \
+	$(RM) ibv_dealloc_mw.3 && \
 	$(LN_S) ibv_get_async_event.3 ibv_ack_async_event.3 && \
 	$(LN_S) ibv_get_cq_event.3 ibv_ack_cq_events.3 && \
 	$(LN_S) ibv_open_device.3 ibv_close_device.3 && \
@@ -111,4 +113,5 @@ install-data-hook:
 	$(LN_S) ibv_event_type_str.3 ibv_node_type_str.3 && \
 	$(LN_S) ibv_event_type_str.3 ibv_port_state_str.3 && \
 	$(LN_S) ibv_rate_to_mbps.3 mbps_to_ibv_rate.3 && \
-	$(LN_S) ibv_open_xrcd.3 ibv_close_xrcd.3
+	$(LN_S) ibv_open_xrcd.3 ibv_close_xrcd.3 && \
+	$(LN_S) ibv_alloc_mw.3 ibv_dealloc_mw.3
diff --git a/include/infiniband/driver.h b/include/infiniband/driver.h
index 5cc092b..e3b7401 100644
--- a/include/infiniband/driver.h
+++ b/include/infiniband/driver.h
@@ -129,6 +129,12 @@ int ibv_cmd_reg_mr(struct ibv_pd *pd, void *addr, size_t length,
 		   size_t cmd_size,
 		   struct ibv_reg_mr_resp *resp, size_t resp_size);
 int ibv_cmd_dereg_mr(struct ibv_mr *mr);
+int ibv_cmd_alloc_mw(struct ibv_pd *pd, enum ibv_mw_type type,
+		     struct ibv_mw *mw, struct ibv_alloc_mw *cmd,
+		     size_t cmd_size,
+		     struct ibv_alloc_mw_resp *resp, size_t resp_size);
+int ibv_cmd_dealloc_mw(struct ibv_mw *mw,
+		       struct ibv_dealloc_mw *cmd, size_t cmd_size);
 int ibv_cmd_create_cq(struct ibv_context *context, int cqe,
 		      struct ibv_comp_channel *channel,
 		      int comp_vector, struct ibv_cq *cq,
diff --git a/include/infiniband/kern-abi.h b/include/infiniband/kern-abi.h
index 91b45d8..ceb2ca9 100644
--- a/include/infiniband/kern-abi.h
+++ b/include/infiniband/kern-abi.h
@@ -340,6 +340,29 @@ struct ibv_dereg_mr {
 	__u32 mr_handle;
 };
 
+struct ibv_alloc_mw {
+	__u32 command;
+	__u16 in_words;
+	__u16 out_words;
+	__u64 response;
+	__u32 pd_handle;
+	__u8  mw_type;
+	__u8  reserved[3];
+};
+
+struct ibv_alloc_mw_resp {
+	__u32 mw_handle;
+	__u32 rkey;
+};
+
+struct ibv_dealloc_mw {
+	__u32 command;
+	__u16 in_words;
+	__u16 out_words;
+	__u32 mw_handle;
+	__u32 reserved;
+};
+
 struct ibv_create_comp_channel {
 	__u32 command;
 	__u16 in_words;
diff --git a/include/infiniband/verbs.h b/include/infiniband/verbs.h
index cfa1156..dcee050 100644
--- a/include/infiniband/verbs.h
+++ b/include/infiniband/verbs.h
@@ -115,8 +115,11 @@ enum ibv_device_cap_flags {
 	IBV_DEVICE_RC_RNR_NAK_GEN	= 1 << 12,
 	IBV_DEVICE_SRQ_RESIZE		= 1 << 13,
 	IBV_DEVICE_N_NOTIFY_CQ		= 1 << 14,
+	IBV_DEVICE_MEM_WINDOW           = 1 << 17,
 	IBV_DEVICE_XRC			= 1 << 20,
-	IBV_DEVICE_MANAGED_FLOW_STEERING = 1 << 29
+	IBV_DEVICE_MEM_WINDOW_TYPE_2A   = 1 << 23,
+	IBV_DEVICE_MEM_WINDOW_TYPE_2B   = 1 << 24,
+	IBV_DEVICE_MANAGED_FLOW_STEERING = 1 << 29,
 };
 
 enum ibv_atomic_cap {
@@ -280,6 +283,7 @@ enum ibv_wc_opcode {
 	IBV_WC_COMP_SWAP,
 	IBV_WC_FETCH_ADD,
 	IBV_WC_BIND_MW,
+	IBV_WC_LOCAL_INV,
 /*
  * Set value of IBV_WC_RECV so consumers can test if a completion is a
  * receive by testing (opcode & IBV_WC_RECV).
@@ -314,7 +318,15 @@ enum ibv_access_flags {
 	IBV_ACCESS_REMOTE_WRITE		= (1<<1),
 	IBV_ACCESS_REMOTE_READ		= (1<<2),
 	IBV_ACCESS_REMOTE_ATOMIC	= (1<<3),
-	IBV_ACCESS_MW_BIND		= (1<<4)
+	IBV_ACCESS_MW_BIND		= (1<<4),
+	IBV_ACCESS_ZERO_BASED		= (1<<5)
+};
+
+struct ibv_mw_bind_info {
+	struct ibv_mr	*mr;
+	uint64_t	 addr;
+	uint64_t	 length;
+	uint64_t	 mw_access_flags; /* use ibv_access_flags */
 };
 
 struct ibv_pd {
@@ -364,6 +376,8 @@ struct ibv_mw {
 	struct ibv_context     *context;
 	struct ibv_pd	       *pd;
 	uint32_t		rkey;
+	uint32_t		handle;
+	enum ibv_mw_type	type;
 };
 
 struct ibv_global_route {
@@ -620,7 +634,9 @@ enum ibv_wr_opcode {
 	IBV_WR_SEND_WITH_IMM,
 	IBV_WR_RDMA_READ,
 	IBV_WR_ATOMIC_CMP_AND_SWP,
-	IBV_WR_ATOMIC_FETCH_AND_ADD
+	IBV_WR_ATOMIC_FETCH_AND_ADD,
+	IBV_WR_LOCAL_INV,
+	IBV_WR_BIND_MW
 };
 
 enum ibv_send_flags {
@@ -666,6 +682,11 @@ struct ibv_send_wr {
 			uint32_t    remote_srqn;
 		} xrc;
 	} qp_type;
+	struct {
+		struct ibv_mw		*mw;
+		uint32_t		rkey;
+		struct ibv_mw_bind_info	bind_info;
+	} bind_mw;
 };
 
 struct ibv_recv_wr {
@@ -677,11 +698,8 @@ struct ibv_recv_wr {
 
 struct ibv_mw_bind {
 	uint64_t		wr_id;
-	struct ibv_mr	       *mr;
-	void		       *addr;
-	size_t			length;
 	int			send_flags;
-	int			mw_access_flags;
+	struct ibv_mw_bind_info bind_info;
 };
 
 struct ibv_srq {
@@ -1167,6 +1185,49 @@ int ibv_dereg_mr(struct ibv_mr *mr);
 struct ibv_comp_channel *ibv_create_comp_channel(struct ibv_context *context);
 
 /**
+ * ibv_alloc_mw - Allocate a memory window
+ */
+static inline struct ibv_mw *ibv_alloc_mw(struct ibv_pd *pd,
+					  enum ibv_mw_type type)
+{
+	if (!pd->context->ops.alloc_mw) {
+		errno = ENOSYS;
+		return NULL;
+	}
+
+	struct ibv_mw *mw = pd->context->ops.alloc_mw(pd, type);
+
+	return mw;
+}
+
+/**
+ * ibv_dealloc_mw - Free a memory window
+ */
+static inline int ibv_dealloc_mw(struct ibv_mw *mw)
+{
+	return mw->context->ops.dealloc_mw(mw);
+}
+
+/**
+ * ibv_inc_rkey - increase the 8 lsb in the given rkey
+ */
+static inline uint32_t ibv_inc_rkey(uint32_t rkey)
+{
+	const uint32_t mask = 0x000000ff;
+	uint8_t newtag = (uint8_t) ((rkey + 1) & mask);
+	return (rkey & ~mask) | newtag;
+}
+
+/**
+ * ibv_bind_mw - Bind a memory window to a region
+ */
+static inline int ibv_bind_mw(struct ibv_qp *qp, struct ibv_mw *mw,
+			      struct ibv_mw_bind *mw_bind)
+{
+	return mw->context->ops.bind_mw(qp, mw, mw_bind);
+}
+
+/**
  * ibv_destroy_comp_channel - Destroy a completion event channel
  */
 int ibv_destroy_comp_channel(struct ibv_comp_channel *channel);
diff --git a/man/ibv_alloc_mw.3 b/man/ibv_alloc_mw.3
new file mode 100644
index 0000000..5da9d69
--- /dev/null
+++ b/man/ibv_alloc_mw.3
@@ -0,0 +1,49 @@
+.\" -*- nroff -*-
+.\"
+.TH IBV_ALLOC_MW 3 2015-01-27 libibverbs "Libibverbs Programmer's Manual"
+.SH "NAME"
+ibv_alloc_mw, ibv_dealloc_mw \- allocate or deallocate a memory window (MW)
+.SH "SYNOPSIS"
+.nf
+.B #include <infiniband/verbs.h>
+.sp
+.BI "struct ibv_mw *ibv_alloc_mw(struct ibv_pd " "*pd" ,
+.BI "                            enum ibv_mw_type " "type");
+.sp
+.BI "int ibv_dealloc_mw(struct ibv_mw " "*mw" );
+.fi
+.SH "DESCRIPTION"
+.B ibv_alloc_mw()
+allocates a memory window (MW) associated with the protection domain
+.I pd\fR.
+The MW's type (1 or 2A/2B) is
+.I type\fR.
+.PP
+The MW is created not bound. For it to be useful, the MW must be bound, through either ibv_bind_mw (type 1) or a special WQE (type 2). Once bound, the memory window allows RDMA (remote) access to a subset of the MR to which it was bound, until invalidated/unbound/deallocated.
+.PP
+.B ibv_dealloc_mw()
+Unbinds and deallocates the MW
+.I mw\fR.
+.SH "RETURN VALUE"
+.B ibv_alloc_mw()
+returns a pointer to the registered MW, or NULL if the request fails.
+The remote key (\fBR_Key\fR)
+field
+.B rkey
+is used by remote processes to perform Atomic and RDMA operations. This key will be changed during bind operations. The remote process places this
+.B rkey
+as the rkey field of struct ibv_send_wr passed to the ibv_post_send function.
+.PP
+.B ibv_dealloc_mw()
+returns 0 on success, or the value of errno on failure (which indicates the failure reason).
+.SH "NOTES"
+.B ibv_dereg_mr()
+fails if any memory window is still bound to this MR.
+.SH "SEE ALSO"
+.BR ibv_alloc_pd (3),
+.BR ibv_post_send (3),
+.BR ibv_bind_mw (3),
+.BR ibv_reg_mr (3),
+.SH "AUTHORS"
+.TP
+Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
diff --git a/man/ibv_bind_mw.3 b/man/ibv_bind_mw.3
new file mode 100644
index 0000000..54e7bcb
--- /dev/null
+++ b/man/ibv_bind_mw.3
@@ -0,0 +1,91 @@
+.\" -*- nroff -*-
+.\"
+.TH IBV_BIND_MW 3 2015-01-27 libibverbs "Libibverbs Programmer's Manual"
+.SH "NAME"
+ibv_bind_mw \- post a request to bind a type 1 memory window to a memory region
+.SH "SYNOPSIS"
+.nf
+.B #include <infiniband/verbs.h>
+.sp
+.BI "int ibv_bind_mw(struct ibv_qp " "*qp" ", struct ibv_mw " "*mw" ",
+.BI "                struct ibv_mw_bind " "*mw_bind" ");
+.fi
+.SH "DESCRIPTION"
+.B ibv_bind_mw()
+posts to the queue pair
+.I qp
+a request to bind the memory window
+.I mw
+according to the details in
+.I mw_bind\fR.
+.PP
+The argument
+.I mw_bind
+is an ibv_mw_bind struct, as defined in <infiniband/verbs.h>.
+.PP
+.nf
+struct ibv_mw_bind {
+.in +8
+uint64_t                     wr_id;           /* User defined WR ID */
+int                          send_flags;      /* Use ibv_send_flags */
+struct ibv_mw_bind_info      bind_info;       /* MW bind information */
+.in -8
+}
+.fi
+.PP
+.nf
+struct ibv_mw_bind_info {
+.in +8
+struct ibv_mr                *mr;             /* The MR to bind the MW to */
+void                         *addr;           /* The address the MW should start at */
+uint64_t                     length;          /* The length (in byte) the MW should span */
+uint64_t                     mw_access_flags; /* Access flags to the MW. use ibv_access_flags */
+.in -8
+};
+.fi
+.PP
+The QP Transport Service Type must be either UC or RC for bind operations.
+.PP
+The attribute send_flags describes the properties of the \s-1WR\s0. It is either 0 or the bitwise \s-1OR\s0 of one or more of the following flags:
+.PP
+.TP
+.B IBV_SEND_FENCE \fR Set the fence indicator.  Valid only for QPs with Transport Service Type \fBIBV_QPT_RC
+.TP
+.B IBV_SEND_SIGNALED \fR Set the completion notification indicator.  Relevant only if QP was created with sq_sig_all=0
+.TP
+.B IBV_SEND_SOLICITED \fR Set the solicited event indicator.  Valid only for Send and RDMA Write with immediate
+.PP
+The mw_access_flags define the allowed access to the MW after the bind
+completes successfully. It is either 0 or the bitwise \s-1OR\s0 of one
+or more of the following flags:
+.TP
+.B IBV_ACCESS_REMOTE_WRITE \fR Enable Remote Write Access. Requires local write access to the MR.
+.TP
+.B IBV_ACCESS_REMOTE_READ\fR   Enable Remote Read Access
+.TP
+.B IBV_ACCESS_REMOTE_ATOMIC\fR Enable Remote Atomic Operation Access (if supported). Requires local write access to the MR.
+.TP
+.B IBV_ACCESS_ZERO_BASED\fR If set, the address given in post send is offset from the MW's start address.
+.SH "RETURN VALUE"
+.B ibv_bind_mw()
+returns 0 on success, or the value of errno on failure (which
+indicates the failure reason).  In case of a success, the R_Key of the
+memory window after the bind is returned in the mw_bind->mw->rkey field.
+.SH "NOTES"
+The bind does not complete when the function return - it is merely
+posted to the QP. The user should keep a copy of the old R_Key, and
+fix the mw structure if the subsequent CQE for the bind operation
+indicates a failure. The user may safely send the R_Key using a send
+request on the same QP, but must not transfer it to the remote in any
+other manner before reading a successful CQE.
+.PP
+Note that for type 2 MW, one should directly post bind WQE to the QP,
+using ibv_post_send.
+.SH "SEE ALSO"
+.BR ibv_alloc_mw (3),
+.BR ibv_post_send (3),
+.BR ibv_poll_cq (3)
+.BR ibv_reg_mr (3),
+.SH "AUTHORS"
+.TP
+Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
diff --git a/man/ibv_inc_rkey.3 b/man/ibv_inc_rkey.3
new file mode 100644
index 0000000..9864179
--- /dev/null
+++ b/man/ibv_inc_rkey.3
@@ -0,0 +1,29 @@
+.\" -*- nroff -*-
+.\"
+.TH IBV_INC_RKEY 3 2015-01-29 libibverbs "Libibverbs Programmer's Manual"
+.SH "NAME"
+.nf
+ibv_inc_rkey \- creates a new rkey from the given one
+.SH "SYNOPSIS"
+.nf
+.B #include <infiniband/verbs.h>
+.sp
+.BI "uint32_t ibv_inc_rkey(uint32_t " "rkey" ");
+.fi
+.SH "DESCRIPTION"
+.B ibv_inc_rkey()
+Increases the 8 LSB of
+.I rkey
+and returns the new value.
+.PP
+.SH "RETURN VALUE"
+.B ibv_inc_rkey()
+returns the new rkey.
+.SH "NOTES"
+.PP
+A use case for this verb can be to create a new rkey from a Memory window's rkey
+when binding it to a Memory region.
+.SH "SEE ALSO"
+.SH "AUTHORS"
+.TP
+Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
diff --git a/man/ibv_post_send.3 b/man/ibv_post_send.3
index 9571575..0d599ad 100644
--- a/man/ibv_post_send.3
+++ b/man/ibv_post_send.3
@@ -69,6 +69,24 @@ uint32_t remote_srqn;            /* Number of the remote SRQ */
 } xrc;
 .in -8
 } qp_type;
+struct {
+.in +8
+struct ibv_mw            *mw;             /* Memory window (MW) of type 2 to bind */
+uint32_t                 rkey;            /* The desired new rkey of the MW */
+struct ibv_mw_bind_info  bind_info;       /* MW additional bind information */
+.in -8
+} bind_mw;
+.in -8
+};
+.fi
+.sp
+.nf
+struct ibv_mw_bind_info {
+.in +8
+struct ibv_mr            *mr;             /* The Memory region (MR) to bind the MW to*/
+void                     *addr;           /* The address the MW should start at */
+size_t                   length;          /* The length (in byte) the MW should span */
+int                      mw_access_flags; /* Acess flags to the MW */
 .in -8
 };
 .fi
@@ -95,6 +113,8 @@ IBV_WR_RDMA_WRITE_WITH_IMM  |            |     X      |     X
 IBV_WR_RDMA_READ            |            |            |     X
 IBV_WR_ATOMIC_CMP_AND_SWP   |            |            |     X
 IBV_WR_ATOMIC_FETCH_AND_ADD |            |            |     X
+IBV_WR_LOCAL_INV            |            |     X      |     X
+IBV_WR_BIND_MW              |            |     X      |     X
 .fi
 .PP
 The attribute send_flags describes the properties of the \s-1WR\s0. It is either 0 or the bitwise \s-1OR\s0 of one or more of the following flags:
@@ -131,3 +151,5 @@ after the call returns.
 .SH "AUTHORS"
 .TP
 Dotan Barak <dotanba-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
+.TP
+Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
diff --git a/src/cmd.c b/src/cmd.c
index 45ea06f..4230d0f 100644
--- a/src/cmd.c
+++ b/src/cmd.c
@@ -280,6 +280,43 @@ int ibv_cmd_dereg_mr(struct ibv_mr *mr)
 	return 0;
 }
 
+int ibv_cmd_alloc_mw(struct ibv_pd *pd, enum ibv_mw_type type,
+		     struct ibv_mw *mw, struct ibv_alloc_mw *cmd,
+		     size_t cmd_size,
+		     struct ibv_alloc_mw_resp *resp, size_t resp_size)
+{
+	IBV_INIT_CMD_RESP(cmd, cmd_size, ALLOC_MW, resp, resp_size);
+	cmd->pd_handle	= pd->handle;
+	cmd->mw_type	= type;
+	memset(cmd->reserved, 0, sizeof(cmd->reserved));
+
+	if (write(pd->context->cmd_fd, cmd, cmd_size) != cmd_size)
+		return errno;
+
+	VALGRIND_MAKE_MEM_DEFINED(resp, resp_size);
+
+	mw->context = pd->context;
+	mw->pd      = pd;
+	mw->rkey    = resp->rkey;
+	mw->handle  = resp->mw_handle;
+	mw->type    = type;
+
+	return 0;
+}
+
+int ibv_cmd_dealloc_mw(struct ibv_mw *mw,
+		       struct ibv_dealloc_mw *cmd, size_t cmd_size)
+{
+	IBV_INIT_CMD(cmd, cmd_size, DEALLOC_MW);
+	cmd->mw_handle = mw->handle;
+	cmd->reserved = 0;
+
+	if (write(mw->context->cmd_fd, cmd, cmd_size) != cmd_size)
+		return errno;
+
+	return 0;
+}
+
 int ibv_cmd_create_cq(struct ibv_context *context, int cqe,
 		      struct ibv_comp_channel *channel,
 		      int comp_vector, struct ibv_cq *cq,
diff --git a/src/libibverbs.map b/src/libibverbs.map
index 30212f3..bbb2259 100644
--- a/src/libibverbs.map
+++ b/src/libibverbs.map
@@ -100,6 +100,9 @@ IBVERBS_1.1 {
 		ibv_event_type_str;
 		ibv_wc_status_str;
 
+		ibv_cmd_alloc_mw;
+		ibv_cmd_dealloc_mw;
+
 		ibv_rate_to_mbps;
 		mbps_to_ibv_rate;
 
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
