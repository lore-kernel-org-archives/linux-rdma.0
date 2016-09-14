From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V1 libibverbs 7/7] Update man pages for RSS usage
Date: Wed, 14 Sep 2016 16:56:28 +0300
Message-ID: <1473861388-22064-8-git-send-email-yishaih@mellanox.com>
References: <1473861388-22064-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1473861388-22064-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Update man pages for RSS usage, it includes:
- Add man pages for the new related verbs.
- Update  man/ibv_create_qp_ex and man/ibv_query_device_ex
  to include the related RSS stuff.

Signed-off-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 Makefile.am                    | 10 +++++--
 man/ibv_create_qp_ex.3         | 14 +++++++++-
 man/ibv_create_rwq_ind_table.3 | 58 +++++++++++++++++++++++++++++++++++++++++
 man/ibv_create_wq.3            | 59 ++++++++++++++++++++++++++++++++++++++++++
 man/ibv_modify_wq.3            | 43 ++++++++++++++++++++++++++++++
 man/ibv_query_device_ex.3      | 10 +++++++
 6 files changed, 191 insertions(+), 3 deletions(-)
 create mode 100644 man/ibv_create_rwq_ind_table.3
 create mode 100644 man/ibv_create_wq.3
 create mode 100644 man/ibv_modify_wq.3

diff --git a/Makefile.am b/Makefile.am
index 5349314..1361e96 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -66,7 +66,9 @@ man_MANS = man/ibv_asyncwatch.1 man/ibv_devices.1 man/ibv_devinfo.1	\
     man/ibv_get_srq_num.3 man/ibv_open_qp.3 man/ibv_query_device_ex.3	\
     man/ibv_alloc_mw.3 man/ibv_bind_mw.3 man/ibv_inc_rkey.3		\
     man/ibv_rereg_mr.3 man/ibv_create_cq_ex.3				\
-    man/ibv_query_rt_values_ex.3 man/ibv_xsrq_pingpong.1
+    man/ibv_query_rt_values_ex.3 man/ibv_xsrq_pingpong.1		\
+    man/ibv_create_wq.3 man/ibv_modify_wq.3				\
+    man/ibv_create_rwq_ind_table.3
 
 DEBIAN = debian/changelog debian/compat debian/control debian/copyright \
     debian/ibverbs-utils.install debian/libibverbs1.install \
@@ -104,6 +106,8 @@ install-data-hook:
 	$(RM) ibv_close_xrcd.3 && \
 	$(RM) ibv_dealloc_mw.3 && \
 	$(RM) ibv_destroy_flow.3 && \
+	$(RM) ibv_destroy_wq.3 && \
+	$(RM) ibv_destroy_rwq_ind_table.3 && \
 	$(LN_S) ibv_get_async_event.3 ibv_ack_async_event.3 && \
 	$(LN_S) ibv_get_cq_event.3 ibv_ack_cq_events.3 && \
 	$(LN_S) ibv_open_device.3 ibv_close_device.3 && \
@@ -123,4 +127,6 @@ install-data-hook:
 	$(LN_S) ibv_rate_to_mbps.3 mbps_to_ibv_rate.3 && \
 	$(LN_S) ibv_open_xrcd.3 ibv_close_xrcd.3 && \
 	$(LN_S) ibv_alloc_mw.3 ibv_dealloc_mw.3 && \
-	$(LN_S) ibv_create_flow.3 ibv_destroy_flow.3
+	$(LN_S) ibv_create_flow.3 ibv_destroy_flow.3 && \
+	$(LN_S) ibv_create_wq.3 ibv_destroy_wq.3 && \
+	$(LN_S) ibv_create_rwq_ind_table.3 ibv_destroy_rwq_ind_table.3
diff --git a/man/ibv_create_qp_ex.3 b/man/ibv_create_qp_ex.3
index a2a67a4..08cb92c 100644
--- a/man/ibv_create_qp_ex.3
+++ b/man/ibv_create_qp_ex.3
@@ -35,6 +35,8 @@ struct ibv_pd          *pd;		/* PD to be associated with the QP */
 struct ibv_xrcd        *xrcd;		/* XRC domain to be associated with the target QP */
 enum ibv_qp_create_flags create_flags;	/* Creation flags for this QP */
 uint16_t                max_tso_header; /* Maximum TSO header size */
+struct ibv_rwq_ind_table *rwq_ind_tbl;  /* Indirection table to be associated with the QP */
+struct ibv_rx_hash_conf  rx_hash_conf;  /* RX hash configuration to be used */
 .in -8
 };
 .sp
@@ -48,6 +50,15 @@ uint32_t                max_recv_sge;   /* Requested max number of s/g elements
 uint32_t                max_inline_data;/* Requested max number of data (bytes) that can be posted inline to the SQ, otherwise 0 */
 .in -8
 };
+.nf
+struct ibv_rx_hash_conf {
+.in +8
+uint8_t                rx_hash_function;       /* RX hash function, use enum ibv_rx_hash_function_flags */
+uint8_t                rx_hash_key_len;        /* RX hash key length */
+uint8_t                *rx_hash_key;           /* RX hash key data */
+uint64_t               rx_hash_fields_mask;    /* RX fields that should participate in the hashing, use enum ibv_rx_hash_fields */
+.in -8
+};
 .fi
 .PP
 The function
@@ -78,7 +89,8 @@ fails if the QP is attached to a multicast group.
 .SH "SEE ALSO"
 .BR ibv_alloc_pd (3),
 .BR ibv_modify_qp (3),
-.BR ibv_query_qp (3)
+.BR ibv_query_qp (3),
+.BR ibv_create_rwq_ind_table (3)
 .SH "AUTHORS"
 .TP
 Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
diff --git a/man/ibv_create_rwq_ind_table.3 b/man/ibv_create_rwq_ind_table.3
new file mode 100644
index 0000000..2b060b5
--- /dev/null
+++ b/man/ibv_create_rwq_ind_table.3
@@ -0,0 +1,58 @@
+.\" -*- nroff -*-
+.\"
+.TH CREATE_RWQ_IND_TBL 3  2016-07-27 libibverbs "Libibverbs Programmer's Manual"
+.SH "NAME"
+ibv_create_rwq_ind_table, ibv_destroy_rwq_ind_table  \- create or destroy a Receive Work Queue Indirection Table (RWQ IND TBL).
+.SH "SYNOPSIS"
+.nf
+.B #include <infiniband/verbs.h>
+.sp
+.BI "struct ibv_rwq_ind_table *ibv_create_rwq_ind_table(struct ibv_context " "*context,"
+.BI "                                                           struct ibv_rwq_ind_table_init_attr " "*init_attr" );
+.sp
+.BI "int ibv_destroy_rwq_ind_table(struct ibv_rwq_ind_table " "*rwq_ind_table" );
+.fi
+.SH "DESCRIPTION"
+.B ibv_create_rwq_ind_table()
+creates a RWQ IND TBL associated with the ibv_context
+.I context\fR.
+The argument
+.I init_attr
+is an ibv_rwq_ind_table_init_attr struct, as defined in <infiniband/verbs.h>.
+.PP
+.nf
+struct ibv_rwq_ind_table_init_attr {
+.in +8
+uint32_t        log_ind_tbl_size;     /* Log, base 2, of Indirection table size */
+struct          ibv_wq **ind_tbl;     /* Each entry is a pointer to Receive Work Queue */
+uint32_t        comp_mask;            /* Identifies valid fields. Use ibv_ind_table_init_attr_mask */
+.in -8
+};
+.fi
+.PP
+The function
+.B ibv_create_rwq_ind_table()
+will create a RWQ IND TBL that holds a table of Receive Work Queue.
+For further usage of the created object see below
+.I NOTES\fR.
+.PP
+.B ibv_destroy_rwq_ind_table()
+destroys the RWQ IND TBL
+.I rwq_ind_table\fR.
+.SH "RETURN VALUE"
+.B ibv_create_rwq_ind_table()
+returns a pointer to the created RWQ IND TBL, or NULL if the request fails.
+.PP
+.B ibv_destroy_rwq_ind_table()
+returns 0 on success, or the value of errno on failure (which indicates the failure reason).
+.SH "NOTES"
+The created object should be used as part of
+.I ibv_create_qp_ex()
+to enable dispatching of incoming packets based on some RX hash configuration.
+.SH "SEE ALSO"
+.BR ibv_create_wq (3),
+.BR ibv_modify_wq (3),
+.BR ibv_create_qp_ex (3),
+.SH "AUTHORS"
+.TP
+Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
diff --git a/man/ibv_create_wq.3 b/man/ibv_create_wq.3
new file mode 100644
index 0000000..1ee584a
--- /dev/null
+++ b/man/ibv_create_wq.3
@@ -0,0 +1,59 @@
+.\" -*- nroff -*-
+.\"
+.TH IBV_CREATE_WQ 3 2016-07-27 libibverbs "Libibverbs Programmer's Manual"
+.SH "NAME"
+ibv_create_wq, ibv_destroy_wq \- create or destroy a Work Queue (WQ).
+.SH "SYNOPSIS"
+.nf
+.B #include <infiniband/verbs_exp.h>
+.sp
+.BI "struct ibv_wq *ibv_create_wq(struct ibv_context " "*context,"
+.BI "                                     struct ibv_wq_init_attr " "*wq_init_attr" );
+.sp
+.BI "int ibv_destroy_wq(struct ibv_wq " "*wq" );
+.fi
+.SH "DESCRIPTION"
+.B ibv_create_wq()
+creates a WQ associated with the ibv_context
+.I context\fR.
+The argument
+.I wq_init_attr
+is an ibv_wq_init_attr struct, as defined in <infiniband/verbs.h>.
+.PP
+.nf
+struct ibv_wq_init_attr {
+.in +8
+void                      *wq_context;    /* Associated context of the WQ */
+enum ibv_wq_type           wq_type;       /* WQ type */
+uint32_t                   max_wr;        /* Requested max number of outstanding WRs in the WQ */
+uint32_t                   max_sge;       /* Requested max number of scatter/gather (s/g) elements per WR in the WQ */
+struct  ibv_pd            *pd;            /* PD to be associated with the WQ */
+struct  ibv_cq            *cq;            /* CQ to be associated with the WQ */
+uint32_t                   comp_mask;     /* Identifies valid fields. Use ibv_wq_init_attr_mask */
+.in -8
+};
+.fi
+.PP
+The function
+.B ibv_create_wq()
+will update the
+.I wq_init_attr\fB\fR->max_wr
+and
+.I wq_init_attr\fB\fR->max_sge
+fields with the actual \s-1WQ\s0 values of the WQ that was created;
+the values will be greater than or equal to the values requested.
+.PP
+.B ibv_destroy_wq()
+destroys the WQ
+.I wq\fR.
+.SH "RETURN VALUE"
+.B ibv_create_wq()
+returns a pointer to the created WQ, or NULL if the request fails.
+.PP
+.B ibv_destroy_wq()
+returns 0 on success, or the value of errno on failure (which indicates the failure reason).
+.SH "SEE ALSO"
+.BR ibv_modify_wq (3),
+.SH "AUTHORS"
+.TP
+Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
diff --git a/man/ibv_modify_wq.3 b/man/ibv_modify_wq.3
new file mode 100644
index 0000000..cf37864
--- /dev/null
+++ b/man/ibv_modify_wq.3
@@ -0,0 +1,43 @@
+.\" -*- nroff -*-
+.\"
+.TH IBV_MODIFY_WQ 3 2016-07-27 libibverbs "Libibverbs Programmer's Manual"
+.SH "NAME"
+ibv_modify_wq \- Modify a Work Queue (WQ).
+.SH "SYNOPSIS"
+.nf
+.B #include <infiniband/verbs.h>
+.sp
+.BI "struct int ibv_modify_wq(struct ibv_wq " "*wq,"
+.BI "                             struct ibv_wq_attr " "*wq_attr" );
+.sp
+.fi
+.SH "DESCRIPTION"
+.B ibv_modify_wq()
+modifys a WQ
+.I wq\fR.
+The argument
+.I wq_attr
+is an ibv_wq_attr struct, as defined in <infiniband/verbs.h>.
+.PP
+.nf
+struct ibv_wq_attr {
+.in +8
+uint32_t                attr_mask;     /* Use enum ibv_wq_attr_mask */
+enum ibv_wq_state       wq_state;      /* Move to this state */
+enum ibv_wq_state       curr_wq_state; /* Assume this is the current state */
+.in -8
+};
+.fi
+.PP
+The function
+.B ibv_modify_wq()
+will modify the WQ based on the given
+.I wq_attr\fB\fR->attr_mask
+.SH "RETURN VALUE"
+returns 0 on success, or the value of errno on failure (which indicates the failure reason).
+.SH "SEE ALSO"
+.BR ibv_create_wq (3),
+.BR ibv_destroy_wq (3),
+.SH "AUTHORS"
+.TP
+Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
diff --git a/man/ibv_query_device_ex.3 b/man/ibv_query_device_ex.3
index d06b40f..88c8ce4 100644
--- a/man/ibv_query_device_ex.3
+++ b/man/ibv_query_device_ex.3
@@ -28,6 +28,8 @@ uint64_t               completion_timestamp_mask;  /* Completion timestamp mask
 uint64_t               hca_core_clock;             /* The frequency (in kHZ) of the HCA (0 = unsupported) */
 uint64_t               device_cap_flags_ex;        /* Extended device capability flags */
 struct ibv_tso_caps    tso_caps;                   /* TCP segmentation offload capabilities */
+struct ibv_rss_caps    rss_caps;                   /* RSS capabilities */
+uint32_t               max_wq_type_rq;             /* Max Work Queue from type RQ */
 .in -8
 };
 
@@ -57,6 +59,14 @@ struct ibv_tso_caps {
         uint32_t supported_qpts; /* Bitmap showing which QP types are supported by TSO operation. */
 };
 
+struct ibv_rss_caps {
+        uint32_t supported_qpts;                   /* Bitmap showing which QP types are supported RSS */
+        uint32_t max_rwq_indirection_tables;       /* Max receive work queue indirection tables */
+        uint32_t max_rwq_indirection_table_size;   /* Max receive work queue indirection table size */
+        uint64_t rx_hash_fields_mask;              /* Mask with enum ibv_rx_hash_fields to know which incoming packet's field can participates in the RX hash */
+        uint8_t  rx_hash_function;                 /* Mask with enum ibv_rx_hash_function_flags to know which hash functions are supported */
+};
+
 .fi
 .SH "RETURN VALUE"
 .B ibv_query_device_ex()
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
