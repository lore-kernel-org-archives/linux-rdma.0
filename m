From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V1 libibverbs 7/8] Man pages for time stamping support
Date: Wed, 24 Feb 2016 11:42:03 +0200
Message-ID: <1456306924-31298-8-git-send-email-yishaih@mellanox.com>
References: <1456306924-31298-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1456306924-31298-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Add and update man pages to describe how to
work with the extended new verbs to have time stamping
support.

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 Makefile.am                  |   4 +-
 man/ibv_create_cq_ex.3       |  75 ++++++++++++++++++
 man/ibv_poll_cq_ex.3         | 181 +++++++++++++++++++++++++++++++++++++++++++
 man/ibv_query_device_ex.3    |   6 +-
 man/ibv_query_rt_values_ex.3 |  50 ++++++++++++
 5 files changed, 313 insertions(+), 3 deletions(-)
 create mode 100644 man/ibv_create_cq_ex.3
 create mode 100644 man/ibv_poll_cq_ex.3
 create mode 100644 man/ibv_query_rt_values_ex.3

diff --git a/Makefile.am b/Makefile.am
index a916acb..59d3006 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -64,7 +64,9 @@ man_MANS = man/ibv_asyncwatch.1 man/ibv_devices.1 man/ibv_devinfo.1	\
     man/ibv_req_notify_cq.3 man/ibv_resize_cq.3 man/ibv_rate_to_mbps.3  \
     man/ibv_create_qp_ex.3 man/ibv_create_srq_ex.3 man/ibv_open_xrcd.3  \
     man/ibv_get_srq_num.3 man/ibv_open_qp.3 man/ibv_query_device_ex.3	\
-    man/ibv_alloc_mw.3 man/ibv_bind_mw.3 man/ibv_inc_rkey.3
+    man/ibv_alloc_mw.3 man/ibv_bind_mw.3 man/ibv_inc_rkey.3		\
+    man/ibv_poll_cq_ex.3 man/ibv_create_cq_ex.3           		\
+    man/ibv_query_rt_values_ex.3
 
 DEBIAN = debian/changelog debian/compat debian/control debian/copyright \
     debian/ibverbs-utils.install debian/libibverbs1.install \
diff --git a/man/ibv_create_cq_ex.3 b/man/ibv_create_cq_ex.3
new file mode 100644
index 0000000..3f655b4
--- /dev/null
+++ b/man/ibv_create_cq_ex.3
@@ -0,0 +1,75 @@
+.\" -*- nroff -*-
+.\"
+.TH IBV_CREATE_CQ_EX 3 2016-2-10 libibverbs "Libibverbs Programmer's Manual"
+.SH "NAME"
+ibv_create_cq_ex \- create a completion queue (CQ)
+.SH "SYNOPSIS"
+.nf
+.B #include <infiniband/verbs.h>
+.sp
+.BI "struct ibv_cq *ibv_create_cq_ex(struct ibv_context " "*context" ",
+.BI "                                struct ibv_cq_init_attr_ex " "*cq_attr" );
+.fi
+.SH "DESCRIPTION"
+.B ibv_create_cq_ex()
+creates a completion queue (CQ) for RDMA device context
+.I context\fR.
+The argument
+.I cq_attr
+is a pointer to struct ibv_create_cq_attr_ex as defined in <infiniband/verbs.h>.
+.PP
+.nf
+struct ibv_cq_init_attr_ex {
+.in +8
+int                     cqe;               /* Minimum number of entries required for CQ */
+void                    *cq_context;       /* Consumer-supplied context returned for completion events */
+struct ibv_comp_channel *channel;          /* Completion channel where completion events will be queued. May be NULL if completion events will not be used. */
+int                     comp_vector;       /* Completion vector used to signal completion events. Must be >= 0 and < context->num_comp_vectors. */
+uint64_t                wc_flags;          /* The wc_flags that should be returned in ibv_poll_cq_ex. Or'ed bit of enum ibv_wc_flags_ex. */
+uint32_t                comp_mask;         /* compatibility mask (extended verb). Or'd flags of enum ibv_cq_init_attr_mask */
+uint32_t                flags;             /* create cq flags - one or more flags from enum ibv_create_cq_attr_flags */
+.in -8
+};
+
+enum ibv_wc_flags_ex {
+        IBV_WC_EX_GRH                        = 1 << 0,  /* Output only */
+        IBV_WC_EX_IMM                        = 1 << 1,  /* Output only */
+        IBV_WC_EX_CSUM_OK                    = 1 << 2,  /* Output only */
+        IBV_WC_EX_INV                        = 1 << 3,  /* Output only */
+        IBV_WC_EX_WITH_BYTE_LEN              = 1 << 4,  /* Require byte len in WC */
+        IBV_WC_EX_WITH_IMM                   = 1 << 5,  /* Require immediate in WC */
+        IBV_WC_EX_WITH_QP_NUM                = 1 << 6,  /* Require QP number in WC */
+        IBV_WC_EX_WITH_SRC_QP                = 1 << 7,  /* Require source QP in WC */
+        IBV_WC_EX_WITH_PKEY_INDEX            = 1 << 8,  /* Require pkey index in WC */
+        IBV_WC_EX_WITH_SLID                  = 1 << 9,  /* Require slid in WC */
+        IBV_WC_EX_WITH_SL                    = 1 << 10, /* Require sl in WC */
+        IBV_WC_EX_WITH_DLID_PATH_BITS        = 1 << 11, /* Require dlid path bits in WC */
+        IBV_WC_EX_WITH_COMPLETION_TIMESTAMP  = 1 << 12, /* Require completion timestamp in WC */
+};
+
+
+enum ibv_cq_init_attr_mask {
+        IBV_CQ_INIT_ATTR_FLAGS               = 1 << 0,
+};
+.SH "RETURN VALUE"
+.B ibv_create_cq_ex()
+returns a pointer to the CQ, or NULL if the request fails.
+.SH "NOTES"
+.B ibv_create_cq_ex()
+may create a CQ with size greater than or equal to the requested
+size. Check the cqe attribute in the returned CQ for the actual size.
+.PP
+CQ should be destroyed with ibv_destroy_cq.
+.PP
+.SH "SEE ALSO"
+.BR ibv_create_cq (3),
+.BR ibv_destroy_cq (3),
+.BR ibv_resize_cq (3),
+.BR ibv_req_notify_cq (3),
+.BR ibv_ack_cq_events (3),
+.BR ibv_create_qp (3)
+.SH "AUTHORS"
+.TP
+Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
+.TP
+Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
diff --git a/man/ibv_poll_cq_ex.3 b/man/ibv_poll_cq_ex.3
new file mode 100644
index 0000000..5474dd7
--- /dev/null
+++ b/man/ibv_poll_cq_ex.3
@@ -0,0 +1,181 @@
+.\" -*- nroff -*-
+.\"
+.TH IBV_POLL_CQ_EX 3 2016-2-18 libibverbs "Libibverbs Programmer's Manual"
+.SH "NAME"
+ibv_poll_cq_ex \- poll a completion queue (CQ)
+.SH "SYNOPSIS"
+.nf
+.B #include <infiniband/verbs.h>
+.sp
+.BI "int ibv_poll_cq_ex(struct ibv_cq " "*cq" ", struct ibv_wc_ex " "*wc" ,
+.BI "                   struct ibv_poll_cq_ex_attr " "*attr");
+.fi
+.SH "DESCRIPTION"
+.B ibv_poll_cq_ex()
+polls the CQ
+.I cq
+for work completions according to the pointer argument
+.I attr
+of type struct ibv_poll_cq_ex_attr which is defined in <infiniband/verbs.h>.
+.PP
+.nf
+struct ibv_poll_cq_ex_attr {
+.in +8
+unsigned int    max_entries; /* the number of maximum wc_ex entries in array to return */
+uint32_t        comp_mask;   /* which commands extensions are available */
+.in -8
+};
+
+The first work completions (up to max_entries) are returned by this command.
+.I wc\fR is an array of type struct ibv_wc_ex which is also defined in <infiniband/verbs.h>.
+.PP
+.nf
+struct ibv_wc_ex {
+.in +8
+uint64_t                wr_id;       /* ID of the completed Work Request (WR) */
+uint64_t                wc_flags;    /* Combination of ibv_wc_flags_ex flags. The IBV_WC_EX_WITH_XXX flags
+                                      * dynamically define the fields exist in buffer[0] and hence defines the ibv_wc_ex's size.
+                                      */
+uint32_t                status;      /* Status of the operation */
+uint32_t                opcode;      /* Operation type specified in the completed WR */
+uint32_t                vendor_err;  /* Vendor error syndrome */
+uint32_t                reserved;    /* For future usage
+uint8_t                 buffer[0];   /* Other attributes, as described in wc_flags */
+.in -8
+};
+
+enum ibv_wc_flags_ex {
+.in +8
+IBV_WC_EX_GRH                           = 1 << 0,  /* GRH is present (valid only for UD QPs) */
+IBV_WC_EX_IMM                           = 1 << 1,  /* Action was carried with immediate data */
+IBV_WC_EX_IP_CSUM_OK                    = 1 << 2,  /* TCP/UDP checksum over IPv4 were verified */
+IBV_WC_EX_INV                           = 1 << 3,  /* Action was carried with invalidate immediate data */
+IBV_WC_EX_WITH_BYTE_LEN                 = 1 << 4,  /* The returned wc_ex contains byte_len field */
+IBV_WC_EX_WITH_IMM                      = 1 << 5,  /* The returned wc_ex contains imm_data field */
+IBV_WC_EX_WITH_QP_NUM                   = 1 << 6,  /* The returned wc_ex contains qp_num field */
+IBV_WC_EX_WITH_SRC_QP                   = 1 << 7,  /* The returned wc_ex contains src_qp field */
+IBV_WC_EX_WITH_PKEY_INDEX               = 1 << 8,  /* The returned wc_ex contains pkey_index field */
+IBV_WC_EX_WITH_SLID                     = 1 << 9,  /* The returned wc_ex contains slid field */
+IBV_WC_EX_WITH_SL                       = 1 << 10, /* The returned wc_ex contains sl field */
+IBV_WC_EX_WITH_DLID_PATH_BITS           = 1 << 11, /* The returned wc_ex contains dlid_path_bits field */
+IBV_WC_EX_WITH_COMPLETION_TIMESTAMP     = 1 << 12, /* The returned wc_ex contains completion_timestmap field */
+.in -8
+};
+
+.fi
+wc_flags describes which of the fields in buffer[0] have a valid value. The order of these fields and sizes are always as follows.
+Future fields will be added after the last field from their size.
+
+.nf
+uint64_t        completion_timestamp; /* Raw timestamp of completion. Implementation defined. Can't be relied upon to have any ordering value between more than one driver/hca */
+uint32_t        byte_len;
+uint32_t        imm_data;
+uint32_t        qp_num;
+uint32_t        src_qp;
+uint16_t        pkey_index;
+uint16_t        slid;
+uint8_t         sl;
+uint8_t         dlid_path_bits;
+
+.fi
+Upon creating a CQ using ibv_create_cq_ex, the required wc_flags are given.
+The user is advised to build a custom wc_ex struct that represents those field.
+For example, if
+.I IBV_WC_EX_WITH_QP_NUM\fR and
+.I IBV_WC_EX_WITH_DLID_PATH_BITS\fR are given to ibv_create_cq_ex in wc_flags parameter, the user is advised to build the following struct:
+
+.nf
+struct user_custom_wc {
+.in +8
+struct ibv_wc_ex     wc_ex;
+uint32_t             qp_num;
+uint8_t              dlid_path_bits;
+.in -8
+}
+
+.fi
+This allows the user to use ibv_poll_cq_ex with an array of type struct user_custom_cq.
+An alternative is to use the following functions:
+.nf
+static inline size_t ibv_wc_ex_get_offsetof64(uint64_t cq_creation_wc_flags,
+					      enum ibv_wc_flags_ex flag);
+static inline size_t ibv_wc_ex_get_offsetof32(uint64_t cq_creation_wc_flags,
+					      enum ibv_wc_flags_ex flag);
+static inline size_t ibv_wc_ex_get_offsetof16(uint64_t cq_creation_wc_flags,
+					      enum ibv_wc_flags_ex flag);
+static inline size_t ibv_wc_ex_get_offsetof8(uint64_t cq_creation_wc_flags,
+					     enum ibv_wc_flags_ex flag);
+static inline uint64_t ibv_wc_ex_get64(const struct ibv_wc_ex *wc_ex,
+				       uint64_t cq_creation_wc_flags,
+				       enum ibv_wc_flags_ex flag);
+static inline uint32_t ibv_wc_ex_get32(const struct ibv_wc_ex *wc_ex,
+				       uint64_t cq_creation_wc_flags,
+				       enum ibv_wc_flags_ex flag);
+static inline uint16_t ibv_wc_ex_get16(const struct ibv_wc_ex *wc_ex,
+				       uint64_t cq_creation_wc_flags,
+				       enum ibv_wc_flags_ex flag);
+static inline uint8_t ibv_wc_ex_get8(const struct ibv_wc_ex *wc_ex,
+				     uint64_t cq_creation_wc_flags,
+				     enum ibv_wc_flags_ex flag);
+static inline size_t ibv_wc_ex_get_size(uint64_t flags);
+
+.fi
+.PP
+The
+.I ibv_wc_ex_get_offsetxx\fR functions get the wc_flags that were used to create the CQ with and return the offset of the field in the returned WC.
+It's assumed that this flag exists in the returned wc_ex (meaning wc_ex->wc_flags & flag != 0).
+.PP
+.I ibv_wc_ex_getxx\fR functions return the value of this field given in flag. The same assumption as in
+.I ibv_wc_ex_get_offsetxx\fR also holds here.
+xx refers to the size of the required fields in bits. This size must match the sizes described above.
+.PP
+.I ibv_wc_ex_get_size\fR returns the size of a WC which is returned from CQs created with wc_flags given as the flags parameter.
+
+Users could use these functions by defining an array of ibv_wc_ex_get_size bytes:
+
+.nf
+struct ibv_wc_ex     *wc_ex = calloc(num_entries, ibv_wc_ex_get_size(cq_wc_creation_flags));
+
+.fi
+This array could be used for ibv_poll_cq_ex.
+After calling ibv_poll_cq_ex, the fields could be extracted using:
+
+.nf
+if (wc_ex->wc_flags & IBV_WC_EX_WITH_SL) {
+.in +8
+uint8_t sl = ibv_wc_ex_get8(wc_ex, cq_wc_creation_flags, IBV_WC_EX_WITH_SL);
+.in -8
+}
+
+.fi
+Please note that in x86, using SSE4.2 machine with "-mpopcount" compilation flag will cause these functions to run faster.
+
+Fields that aren't available for a completion won't be indicated in wc_ex->wc_flags and their values are undefined.
+
+.PP
+Not all
+.I wc\fR attributes are always valid. If the completion status is other than
+.B IBV_WC_SUCCESS\fR,
+only the following attributes are valid: wr_id, status, qp_num (if its respective wc_flags bit is set), and vendor_err.
+.SH "RETURN VALUE"
+On success,
+.B ibv_poll_cq_ex()
+returns a non-negative value equal to the number of completions
+found.  On failure, a negative value is returned.
+.SH "NOTES"
+.PP
+Each polled completion is removed from the CQ and cannot be returned to it.
+.PP
+The user should consume work completions at a rate that prevents CQ
+overrun from occurrence.  In case of a CQ overrun, the async event
+.B IBV_EVENT_CQ_ERR
+will be triggered, and the CQ cannot be used.
+.SH "SEE ALSO"
+.BR ibv_poll_cq (3),
+.BR ibv_post_send (3),
+.BR ibv_post_recv (3)
+.SH "AUTHORS"
+.TP
+Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
+.TP
+Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
diff --git a/man/ibv_query_device_ex.3 b/man/ibv_query_device_ex.3
index 1f483d2..db12c2b 100644
--- a/man/ibv_query_device_ex.3
+++ b/man/ibv_query_device_ex.3
@@ -22,8 +22,10 @@ is a pointer to an ibv_device_attr_ex struct, as defined in <infiniband/verbs.h>
 struct ibv_device_attr_ex {
 .in +8
 struct ibv_device_attr orig_attr;
-uint32_t               comp_mask;              /* Compatibility mask that defines which of the following variables are valid */
-struct ibv_odp_caps    odp_caps;               /* On-Demand Paging capabilities */
+uint32_t               comp_mask;                  /* Compatibility mask that defines which of the following variables are valid */
+struct ibv_odp_caps    odp_caps;                   /* On-Demand Paging capabilities */
+uint64_t               completion_timestamp_mask;  /* Completion timestamp mask (0 = unsupported) */
+uint64_t               hca_core_clock;             /* The frequency (in kHZ) of the HCA (0 = unsupported) */
 .in -8
 };
 
diff --git a/man/ibv_query_rt_values_ex.3 b/man/ibv_query_rt_values_ex.3
new file mode 100644
index 0000000..fcc460c
--- /dev/null
+++ b/man/ibv_query_rt_values_ex.3
@@ -0,0 +1,50 @@
+.\" -*- nroff -*-
+.\"
+.TH IBV_QUERY_RT_VALUES_EX 3 2016-2-20 libibverbs "Libibverbs Programmer's Manual"
+.SH "NAME"
+ibv_query_rt_values_ex \- query an RDMA device for some real time values
+.SH "SYNOPSIS"
+.nf
+.B #include <infiniband/verbs.h>
+.sp
+.BI "int ibv_query_rt_values_ex(struct ibv_context " "*context",
+.BI "                           struct ibv_values_ex " "*values" );
+.fi
+.SH "DESCRIPTION"
+.B ibv_query_rt_values_ex()
+returns certain real time values of a device
+.I context\fR.
+The argument
+.I attr
+is a pointer to an ibv_device_attr_ex struct, as defined in <infiniband/verbs.h>.
+.PP
+.nf
+struct ibv_values_ex {
+.in +8
+uint32_t             comp_mask;    /* Compatibility mask that defines the query/queried fields [in/out] */
+struct timespec      raw_clock;    /* HW raw clock */
+.in -8
+};
+
+enum ibv_values_mask {
+        IBV_VALUES_MASK_RAW_CLOCK = 1 << 0, /* HW raw clock */
+};
+
+.fi
+.SH "RETURN VALUE"
+.B ibv_query_rt_values_ex()
+returns 0 on success, or the value of errno on failure (which indicates the failure reason).
+.SH "NOTES"
+This extension verb only calls the provider, the provider has to query this value somehow and mark
+the queried values in the comp_mask field.
+.SH "SEE ALSO"
+.BR ibv_query_device (3),
+.BR ibv_open_device (3),
+.BR ibv_query_port (3),
+.BR ibv_query_pkey (3),
+.BR ibv_query_gid (3)
+.SH "AUTHORS"
+.TP
+Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
+.TP
+Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
