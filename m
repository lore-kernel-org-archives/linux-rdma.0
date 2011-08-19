From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 3/6 v2] libibverbs: Add/update man pages for xrc verbs
Date: Fri, 19 Aug 2011 02:47:11 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237316E41B63@FMSMSX151.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 Makefile.am           |    3 +-
 man/ibv_create_qp.3   |   13 +++++++-
 man/ibv_create_xsrq.3 |   80 +++++++++++++++++++++++++++++++++++++++++++++++++
 man/ibv_open_xrcd.3   |   65 ++++++++++++++++++++++++++++++++++++++++
 man/ibv_post_send.3   |   11 ++++++-
 5 files changed, 168 insertions(+), 4 deletions(-)
 create mode 100644 man/ibv_create_xsrq.3
 create mode 100644 man/ibv_open_xrcd.3

diff --git a/Makefile.am b/Makefile.am
index 5aa1289..4702a2b 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -53,7 +53,8 @@ man_MANS = man/ibv_asyncwatch.1 man/ibv_devices.1 man/ibv_devinfo.1	\
     man/ibv_post_srq_recv.3 man/ibv_query_device.3 man/ibv_query_gid.3	\
     man/ibv_query_pkey.3 man/ibv_query_port.3 man/ibv_query_qp.3	\
     man/ibv_query_srq.3 man/ibv_rate_to_mult.3 man/ibv_reg_mr.3		\
-    man/ibv_req_notify_cq.3 man/ibv_resize_cq.3
+    man/ibv_req_notify_cq.3 man/ibv_resize_cq.3 man/ibv_open_xrcd.3	\
+    man/ibv_create_xsrq.3
 
 DEBIAN = debian/changelog debian/compat debian/control debian/copyright \
     debian/ibverbs-utils.install debian/libibverbs1.install \
diff --git a/man/ibv_create_qp.3 b/man/ibv_create_qp.3
index 5301ad8..3f6305f 100644
--- a/man/ibv_create_qp.3
+++ b/man/ibv_create_qp.3
@@ -1,6 +1,6 @@
 .\" -*- nroff -*-
 .\"
-.TH IBV_CREATE_QP 3 2006-10-31 libibverbs "Libibverbs Programmer's Manual"
+.TH IBV_CREATE_QP 3 2011-06-17 libibverbs "Libibverbs Programmer's Manual"
 .SH "NAME"
 ibv_create_qp, ibv_destroy_qp \- create or destroy a queue pair (QP)
 .SH "SYNOPSIS"
@@ -28,8 +28,17 @@ struct ibv_cq          *send_cq;        /* CQ to be associated with the Send Que
 struct ibv_cq          *recv_cq;        /* CQ to be associated with the Receive Queue (RQ) */
 struct ibv_srq         *srq;            /* SRQ handle if QP is to be associated with an SRQ, otherwise NULL */
 struct ibv_qp_cap       cap;            /* QP capabilities */
-enum ibv_qp_type        qp_type;        /* QP Transport Service Type: IBV_QPT_RC, IBV_QPT_UC, or IBV_QPT_UD */
+enum ibv_qp_type        qp_type;        /* QP Transport Service Type */
 int                     sq_sig_all;     /* If set, each Work Request (WR) submitted to the SQ generates a completion entry */
+union {
+.in +8
+struct {
+.in +8
+struct ibv_xrcd *xrcd;   /* XRC domain associated with XRC receive QPs */
+.in -8
+} xrc_recv;
+.in -8
+} ext;
 .in -8
 };
 .sp
diff --git a/man/ibv_create_xsrq.3 b/man/ibv_create_xsrq.3
new file mode 100644
index 0000000..a5162dd
--- /dev/null
+++ b/man/ibv_create_xsrq.3
@@ -0,0 +1,80 @@
+.\" -*- nroff -*-
+.\"
+.TH IBV_CREATE_XSRQ 3 2011-06-17 libibverbs "Libibverbs Programmer's Manual"
+.SH "NAME"
+ibv_create_xsrq, ibv_destroy_srq \- create or destroy a shared receive queue (SRQ)
+.SH "SYNOPSIS"
+.nf
+.B #include <infiniband/verbs.h>
+.sp
+.BI "struct ibv_srq *ibv_create_xsrq(struct ibv_pd " "*pd" ", struct "
+.BI "                                ibv_srq_init_attr " "*srq_init_attr" );
+.sp
+.BI "int ibv_destroy_srq(struct ibv_srq " "*srq" );
+.fi
+.SH "DESCRIPTION"
+.B ibv_create_xsrq()
+creates a shared receive queue (SRQ) associated with the protection domain
+.I pd\fR.
+The argument
+.I srq_init_attr
+is an ibv_srq_init_attr struct, as defined in <infiniband/verbs.h>.
+.PP
+.nf
+struct ibv_srq_init_attr {
+.in +8
+void                   *srq_context;    /* Associated context of the SRQ */
+struct ibv_srq_attr     attr;           /* SRQ attributes */
+enum ibv_srq_type       srq_type;       /* Specifies type of SRQ to create */
+union {
+.in +8
+struct {
+.in +8
+struct ibv_xrcd *xrcd;   /* XRC domain associated with an XRC SRQ */
+struct ibv_cq   *cq;     /* completion queue for an XRC SRQ*/
+.in -8
+} xrc;   /* Extended attributes for IBV_SRQT_XRC type SRQs */
+.in -8
+} ext;
+.in -8
+};
+.sp
+.nf
+struct ibv_srq_attr {
+.in +8
+uint32_t                max_wr;         /* Requested max number of outstanding work requests (WRs) in the SRQ */
+uint32_t                max_sge;        /* Requested max number of scatter elements per WR */
+uint32_t                srq_limit;      /* The limit value of the SRQ (ignored for ibv_create_srq) */
+.in -8
+};
+.fi
+.PP
+The function
+.B ibv_create_xsrq()
+will update the
+.I srq_init_attr
+struct with the original values of the SRQ that was created; the
+values of max_wr and max_sge will be greater than or equal to the
+values requested.
+.PP
+.B ibv_destroy_srq()
+destroys the SRQ
+.I srq\fR.
+.SH "RETURN VALUE"
+.B ibv_create_xsrq()
+returns a pointer to the created SRQ, or NULL if the request fails.
+.PP
+.B ibv_destroy_srq()
+returns 0 on success, or the value of errno on failure (which indicates the failure reason).
+.SH "NOTES"
+.B ibv_destroy_srq()
+fails if any queue pair is still associated with this SRQ.
+.SH "SEE ALSO"
+.BR ibv_alloc_pd (3),
+.BR ibv_create_cq (3),
+.BR ibv_open_xrcd (3),
+.BR ibv_modify_srq (3),
+.BR ibv_query_srq (3)
+.SH "AUTHORS"
+.TP
+Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
diff --git a/man/ibv_open_xrcd.3 b/man/ibv_open_xrcd.3
new file mode 100644
index 0000000..f0ae30c
--- /dev/null
+++ b/man/ibv_open_xrcd.3
@@ -0,0 +1,65 @@
+.\" -*- nroff -*-
+.\"
+.TH IBV_OPEN_XRCD 3 2011-06-17 libibverbs "Libibverbs Programmer's Manual"
+.SH "NAME"
+ibv_open_xrcd, ibv_close_xrcd \- open or close an XRC protection domain (XRCDs)
+.SH "SYNOPSIS"
+.nf
+.B #include <infiniband/verbs.h>
+.sp
+.BI "struct ibv_xrcd *ibv_open_xrcd(struct ibv_context " "*context" ","
+.BI "                               int " "fd" ", int " "oflag" );
+.sp
+.BI "int ibv_close_xrcd(struct ibv_xrcd " "*xrcd" );
+.fi
+.SH "DESCRIPTION"
+.B ibv_open_xrcd()
+open an XRC domain for the RDMA device context
+.I context
+.I fd
+is the file descriptor to associate with the XRCD.
+.I oflag
+describes the desired creation attributes.  It is a bitwise OR of zero or more
+of the following flags:
+.PP
+.TP
+.B O_CREAT
+Indicates that an XRCD should be created and associated with the inode referenced
+by the given fd.  If the XRCD exists, this flag has no effect except as noted under
+.BR O_EXCL
+below.\fR
+.TP
+.B O_EXCL
+If
+.BR O_EXCL
+and
+.BR O_CREAT
+are set, open will fail if an XRCD associated with the inode exists.
+.PP
+If
+.I fd
+equals -1, no inode is associated with the XRCD, and the only valid value for
+.I oflag
+is
+.B O_CREAT\fR.
+.PP
+.B ibv_close_xrcd()
+closes the XRCD
+.I xrcd\fR.
+If this is the last reference, the XRCD will be destroyed.
+.SH "RETURN VALUE"
+.B ibv_open_xrcd()
+returns a pointer to the opened XRCD, or NULL if the request fails.
+.PP
+.B ibv_close_xrcd()
+returns 0 on success, or the value of errno on failure (which indicates the
+failure reason).
+.SH "NOTES"
+.B ibv_close_xrcd()
+may fail if any other resource is still associated with the XRCD being closed.
+.SH "SEE ALSO"
+.BR ibv_create_xsrq (3),
+.BR ibv_create_qp (3),
+.SH "AUTHORS"
+.TP
+Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
diff --git a/man/ibv_post_send.3 b/man/ibv_post_send.3
index 33fbb50..cc0fa09 100644
--- a/man/ibv_post_send.3
+++ b/man/ibv_post_send.3
@@ -1,6 +1,6 @@
 .\" -*- nroff -*-
 .\"
-.TH IBV_POST_SEND 3 2006-10-31 libibverbs "Libibverbs Programmer's Manual"
+.TH IBV_POST_SEND 3 2011-06-17 libibverbs "Libibverbs Programmer's Manual"
 .SH "NAME"
 ibv_post_send \- post a list of work requests (WRs) to a send queue
 .SH "SYNOPSIS"
@@ -58,6 +58,13 @@ uint32_t        remote_qpn;     /* QP number of the destination QP */
 uint32_t        remote_qkey;    /* Q_Key number of the destination QP */
 .in -8
 } ud;
+struct {
+.in +8
+uint64_t        reserved[3];
+uint32_t        reserved2;
+uint32_t        remote_srqn;    /* SRQ number of the destination XRC SRQ */
+.in -8
+} xrc;
 .in -8
 } wr;
 .in -8
@@ -87,6 +94,8 @@ IBV_WR_ATOMIC_CMP_AND_SWP   |            |            |     X
 IBV_WR_ATOMIC_FETCH_AND_ADD |            |            |     X
 .fi
 .PP
+IBV_QPT_XRC_SEND transports behave similar to IBV_QPT_RC and support the same set of operations.
+.PP
 The attribute send_flags describes the properties of the \s-1WR\s0. It is either 0 or the bitwise \s-1OR\s0 of one or more of the following flags:
 .PP
 .TP


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
