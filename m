From: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH libibverbs v6 6/7] libibverbs: Add man page for ibv_open_qp
Date: Tue,  4 Jun 2013 11:49:50 -0700
Message-ID: <1370371791-15018-7-git-send-email-sean.hefty@intel.com>
References: <1370371791-15018-1-git-send-email-sean.hefty@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1370371791-15018-1-git-send-email-sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 man/ibv_open_qp.3 |   50 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 50 insertions(+), 0 deletions(-)
 create mode 100644 man/ibv_open_qp.3

diff --git a/man/ibv_open_qp.3 b/man/ibv_open_qp.3
new file mode 100644
index 0000000..0bc5647
--- /dev/null
+++ b/man/ibv_open_qp.3
@@ -0,0 +1,50 @@
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
+uint32_t          comp_mask;  /* Identifies valid fields */
+uint32_t          qp_num;     /* QP number */
+void             *qp_context; /* Associated context of the QP */
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
+.BR ibv_create_qp_ex (3),
+.BR ibv_modify_qp (3),
+.BR ibv_query_qp (3)
+.SH "AUTHORS"
+.TP
+Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
-- 
1.7.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
