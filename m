From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 6/6 v2] libibverbs: Add man page for ib_open_qp
Date: Fri, 19 Aug 2011 02:47:13 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237316E41B80@FMSMSX151.amr.corp.intel.com>
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
 man/ibv_open_qp.3 |   48 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 48 insertions(+), 0 deletions(-)
 create mode 100644 man/ibv_open_qp.3

diff --git a/man/ibv_open_qp.3 b/man/ibv_open_qp.3
new file mode 100644
index 0000000..577a28d
--- /dev/null
+++ b/man/ibv_open_qp.3
@@ -0,0 +1,48 @@
+.\" -*- nroff -*-
+.\"
+.TH IBV_OPEN_QP 3 2011-08-12 libibverbs "Libibverbs Programmer's Manual"
+.SH "NAME"
+ibv_open_qp \- open a shareable queue pair (QP)
+.SH "SYNOPSIS"
+.nf
+.B #include <infiniband/verbs.h>
+.sp
+.BI "struct ibv_qp *ibv_open_qp(struct ibv_xrcd " "*xrcd" ,
+.BI "                           struct ibv_qp_open_attr " "*qp_open_attr" );
+.fi
+.SH "DESCRIPTION"
+.B ibv_open_qp()
+opens an existing queue pair (QP) associated with the extended protection domain
+.I xrcd\fR.
+The argument
+.I qp_open_attr
+is an ibv_qp_open_attr struct, as defined in <infiniband/verbs.h>.
+.PP
+.nf
+struct ibv_qp_open_attr {
+.in +8
+void             *qp_context; /* Associated context of the QP */
+uint32_t          qp_num;     /* QP number */
+enum ibv_qp_type  qp_type;    /* QP transport service type */
+.fi
+.PP
+.B ibv_destroy_qp()
+closes the opened QP and destroys the underlying QP if it has no
+other references.
+.I qp\fR.
+.SH "RETURN VALUE"
+.B ibv_open_qp()
+returns a pointer to the opened QP, or NULL if the request fails.
+Check the QP number (\fBqp_num\fR) in the returned QP.
+.SH "NOTES"
+.B ibv_open_qp()
+will fail if a it is asked to open a QP that does not exist within
+the xrcd with the specified qp_num and qp_type.
+.SH "SEE ALSO"
+.BR ibv_alloc_pd (3),
+.BR ibv_create_qp (3),
+.BR ibv_modify_qp (3),
+.BR ibv_query_qp (3)
+.SH "AUTHORS"
+.TP
+Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
