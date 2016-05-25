From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V3 libibverbs 6/7] Add a verb that queries real time values from the HCA
Date: Wed, 25 May 2016 16:02:23 +0300
Message-ID: <1464181344-11987-7-git-send-email-yishaih@mellanox.com>
References: <1464181344-11987-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1464181344-11987-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Add ibv_query_rt_values_ex, an extension verb to query certain real
time values of a device. Currently, only IBV_VALUES_MASK_RAW_CLOCK is
supported, but this verb could support other flags like
IBV_VALUES_MASK_TEMP_SENSOR, IBV_VALUES_MASK_CORE_FREQ, etc.

This extension verb only calls the provider.
The provider has to query this value somehow and mark the queried
values in comp_mask.

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 Makefile.am                  |  3 ++-
 include/infiniband/verbs.h   | 33 +++++++++++++++++++++++++++++
 man/ibv_query_rt_values_ex.3 | 50 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 85 insertions(+), 1 deletion(-)
 create mode 100644 man/ibv_query_rt_values_ex.3

diff --git a/Makefile.am b/Makefile.am
index a1c2122..16f838d 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -65,7 +65,8 @@ man_MANS = man/ibv_asyncwatch.1 man/ibv_devices.1 man/ibv_devinfo.1	\
     man/ibv_create_qp_ex.3 man/ibv_create_srq_ex.3 man/ibv_open_xrcd.3  \
     man/ibv_get_srq_num.3 man/ibv_open_qp.3 man/ibv_query_device_ex.3	\
     man/ibv_alloc_mw.3 man/ibv_bind_mw.3 man/ibv_inc_rkey.3		\
-    man/ibv_rereg_mr.3 man/ibv_create_cq_ex.3
+    man/ibv_rereg_mr.3 man/ibv_create_cq_ex.3				\
+    man/ibv_query_rt_values_ex.3
 
 DEBIAN = debian/changelog debian/compat debian/control debian/copyright \
     debian/ibverbs-utils.install debian/libibverbs1.install \
diff --git a/include/infiniband/verbs.h b/include/infiniband/verbs.h
index f254d18..424d0fd 100644
--- a/include/infiniband/verbs.h
+++ b/include/infiniband/verbs.h
@@ -1222,6 +1222,16 @@ struct ibv_cq_init_attr_ex {
 	uint32_t		flags;
 };
 
+enum ibv_values_mask {
+	IBV_VALUES_MASK_RAW_CLOCK	= 1 << 0,
+	IBV_VALUES_MASK_RESERVED	= 1 << 1
+};
+
+struct ibv_values_ex {
+	uint32_t	comp_mask;
+	struct timespec raw_clock;
+};
+
 enum verbs_context_mask {
 	VERBS_CONTEXT_XRCD	= 1 << 0,
 	VERBS_CONTEXT_SRQ	= 1 << 1,
@@ -1233,6 +1243,8 @@ enum verbs_context_mask {
 
 struct verbs_context {
 	/*  "grows up" - new fields go here */
+	int (*query_rt_values)(struct ibv_context *context,
+			       struct ibv_values_ex *values);
 	struct ibv_cq_ex *(*create_cq_ex)(struct ibv_context *context,
 					  struct ibv_cq_init_attr_ex *init_attr);
 	struct verbs_ex_private *priv;
@@ -1752,6 +1764,27 @@ ibv_create_qp_ex(struct ibv_context *context, struct ibv_qp_init_attr_ex *qp_ini
 }
 
 /**
+ * ibv_query_rt_values_ex - Get current real time @values of a device.
+ * @values - in/out - defines the attributes we need to query/queried.
+ * (Or's bits of enum ibv_values_mask on values->comp_mask field)
+ */
+static inline int
+ibv_query_rt_values_ex(struct ibv_context *context,
+		       struct ibv_values_ex *values)
+{
+	struct verbs_context *vctx;
+
+	vctx = verbs_get_ctx_op(context, query_rt_values);
+	if (!vctx)
+		return ENOSYS;
+
+	if (values->comp_mask & ~(IBV_VALUES_MASK_RESERVED - 1))
+		return EINVAL;
+
+	return vctx->query_rt_values(context, values);
+}
+
+/**
  * ibv_query_device_ex - Get extended device properties
  */
 static inline int
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
