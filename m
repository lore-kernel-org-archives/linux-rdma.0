From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V1 libibverbs 7/7] Extend man pages to describe Memory Window usage
Date: Mon,  8 Feb 2016 14:43:22 +0200
Message-ID: <1454935402-15192-8-git-send-email-yishaih@mellanox.com>
References: <1454935402-15192-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1454935402-15192-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Add and update man pages to describe the Memory Window usage.

Signed-off-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 Makefile.am         |  8 +++--
 man/ibv_alloc_mw.3  | 54 +++++++++++++++++++++++++++++++
 man/ibv_bind_mw.3   | 92 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 man/ibv_inc_rkey.3  | 32 +++++++++++++++++++
 man/ibv_post_send.3 | 25 +++++++++++++++
 5 files changed, 208 insertions(+), 3 deletions(-)
 create mode 100644 man/ibv_alloc_mw.3
 create mode 100644 man/ibv_bind_mw.3
 create mode 100644 man/ibv_inc_rkey.3

diff --git a/Makefile.am b/Makefile.am
index c85e98a..4698ecb 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -62,8 +62,8 @@ man_MANS = man/ibv_asyncwatch.1 man/ibv_devices.1 man/ibv_devinfo.1	\
     man/ibv_query_srq.3 man/ibv_rate_to_mult.3 man/ibv_reg_mr.3		\
     man/ibv_req_notify_cq.3 man/ibv_resize_cq.3 man/ibv_rate_to_mbps.3  \
     man/ibv_create_qp_ex.3 man/ibv_create_srq_ex.3 man/ibv_open_xrcd.3  \
-    man/ibv_get_srq_num.3 man/ibv_open_qp.3 \
-    man/ibv_query_device_ex.3
+    man/ibv_get_srq_num.3 man/ibv_open_qp.3 man/ibv_query_device_ex.3	\
+    man/ibv_alloc_mw.3 man/ibv_bind_mw.3 man/ibv_inc_rkey.3
 
 DEBIAN = debian/changelog debian/compat debian/control debian/copyright \
     debian/ibverbs-utils.install debian/libibverbs1.install \
@@ -99,6 +99,7 @@ install-data-hook:
 	$(RM) ibv_port_state_str.3 && \
 	$(RM) mbps_to_ibv_rate.3 && \
 	$(RM) ibv_close_xrcd.3 && \
+	$(RM) ibv_dealloc_mw.3 && \
 	$(LN_S) ibv_get_async_event.3 ibv_ack_async_event.3 && \
 	$(LN_S) ibv_get_cq_event.3 ibv_ack_cq_events.3 && \
 	$(LN_S) ibv_open_device.3 ibv_close_device.3 && \
@@ -116,4 +117,5 @@ install-data-hook:
 	$(LN_S) ibv_event_type_str.3 ibv_node_type_str.3 && \
 	$(LN_S) ibv_event_type_str.3 ibv_port_state_str.3 && \
 	$(LN_S) ibv_rate_to_mbps.3 mbps_to_ibv_rate.3 && \
-	$(LN_S) ibv_open_xrcd.3 ibv_close_xrcd.3
+	$(LN_S) ibv_open_xrcd.3 ibv_close_xrcd.3 && \
+	$(LN_S) ibv_alloc_mw.3 ibv_dealloc_mw.3
diff --git a/man/ibv_alloc_mw.3 b/man/ibv_alloc_mw.3
new file mode 100644
index 0000000..366cefb
--- /dev/null
+++ b/man/ibv_alloc_mw.3
@@ -0,0 +1,54 @@
+.\" -*- nroff -*-
+.\"
+.TH IBV_ALLOC_MW 3 2016-02-02 libibverbs "Libibverbs Programmer's Manual"
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
+The MW is created not bound. For it to be useful, the MW must be bound, through either ibv_bind_mw (type 1) or a special WR (type 2).
+Once bound, the memory window allows RDMA (remote) access to a subset of the MR to which it was bound,
+until invalidated by: ibv_bind_mw verb with zero length for type 1,
+IBV_WR_LOCAL_INV/IBV_WR_SEND_WITH_INV WR opcode for type 2, deallocation.
+.PP
+.B ibv_dealloc_mw()
+Unbinds in case was previously bound and deallocates the MW
+.I mw\fR.
+.SH "RETURN VALUE"
+.B ibv_alloc_mw()
+returns a pointer to the allocated MW, or NULL if the request fails.
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
+.TP
+Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
diff --git a/man/ibv_bind_mw.3 b/man/ibv_bind_mw.3
new file mode 100644
index 0000000..2943cbc
--- /dev/null
+++ b/man/ibv_bind_mw.3
@@ -0,0 +1,92 @@
+.\" -*- nroff -*-
+.\"
+.TH IBV_BIND_MW 3 2016-02-02 libibverbs "Libibverbs Programmer's Manual"
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
+uint64_t                     addr;            /* The address the MW should start at */
+uint64_t                     length;          /* The length (in bytes) the MW should span */
+int                          mw_access_flags; /* Access flags to the MW. Use ibv_access_flags */
+.in -8
+};
+.fi
+.PP
+The QP Transport Service Type must be either UC, RC or XRC_SEND for bind operations.
+.PP
+The attribute send_flags describes the properties of the \s-1WR\s0. It is either 0 or the bitwise \s-1OR\s0 of one or more of the following flags:
+.PP
+.TP
+.B IBV_SEND_FENCE \fR Set the fence indicator.
+.TP
+.B IBV_SEND_SIGNALED \fR Set the completion notification indicator.  Relevant only if QP was created with sq_sig_all=0
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
+.B IBV_ACCESS_ZERO_BASED\fR If set, the address set on the 'remote_addr' field on the WR will be an offset from the MW's start address.
+.SH "RETURN VALUE"
+.B ibv_bind_mw()
+returns 0 on success, or the value of errno on failure (which
+indicates the failure reason).  In case of a success, the R_key of the
+memory window after the bind is returned in the mw_bind->mw->rkey field.
+.SH "NOTES"
+The bind does not complete when the function return - it is merely
+posted to the QP. The user should keep a copy of the old R_key, and
+fix the mw structure if the subsequent CQE for the bind operation
+indicates a failure. The user may safely send the R_key using a send
+request on the same QP, (based on QP ordering rules: a send after a bind
+request on the same QP are always ordered), but must not transfer it to the
+remote in any other manner before reading a successful CQE.
+.PP
+Note that for type 2 MW, one should directly post bind WR to the QP,
+using ibv_post_send.
+.SH "SEE ALSO"
+.BR ibv_alloc_mw (3),
+.BR ibv_post_send (3),
+.BR ibv_poll_cq (3)
+.BR ibv_reg_mr (3),
+.SH "AUTHORS"
+.TP
+Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
+.TP
+Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
diff --git a/man/ibv_inc_rkey.3 b/man/ibv_inc_rkey.3
new file mode 100644
index 0000000..930368b
--- /dev/null
+++ b/man/ibv_inc_rkey.3
@@ -0,0 +1,32 @@
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
+The verb generates a new rkey that is different from the previous one on its tag part
+but has the same index (bits 0xffffff00).
+A use case for this verb can be to create a new rkey from a Memory window's rkey
+when binding it to a Memory region.
+.SH "AUTHORS"
+.TP
+Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
+.TP
+Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
diff --git a/man/ibv_post_send.3 b/man/ibv_post_send.3
index 26bbd06..f918afb 100644
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
+struct ibv_mr            *mr;             /* The Memory region (MR) to bind the MW to */
+uint64_t                 addr;           /* The address the MW should start at */
+uint64_t                 length;          /* The length (in bytes) the MW should span */
+int                      mw_access_flags; /* Access flags to the MW. Use ibv_access_flags */
 .in -8
 };
 .fi
@@ -95,6 +113,9 @@ IBV_WR_RDMA_WRITE_WITH_IMM  |            |     X      |     X     |     X
 IBV_WR_RDMA_READ            |            |            |     X     |     X
 IBV_WR_ATOMIC_CMP_AND_SWP   |            |            |     X     |     X
 IBV_WR_ATOMIC_FETCH_AND_ADD |            |            |     X     |     X
+IBV_WR_LOCAL_INV            |            |     X      |     X     |     X
+IBV_WR_BIND_MW              |            |     X      |     X     |     X
+IBV_WR_SEND_WITH_INV        |            |     X      |     X     |     X
 .fi
 .PP
 The attribute send_flags describes the properties of the \s-1WR\s0. It is either 0 or the bitwise \s-1OR\s0 of one or more of the following flags:
@@ -135,3 +156,7 @@ after the call returns.
 .SH "AUTHORS"
 .TP
 Dotan Barak <dotanba-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
+.TP
+Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
+.TP
+Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
