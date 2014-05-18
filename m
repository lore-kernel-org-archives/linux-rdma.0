From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH libibverbs V4 4/5] Add ibv_query_port_ex support
Date: Sun, 18 May 2014 12:38:48 +0300
Message-ID: <1400405929-14313-5-git-send-email-ogerlitz@r-vnc04.mtr.labs.mlnx>
References: <1400405929-14313-1-git-send-email-ogerlitz@r-vnc04.mtr.labs.mlnx>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1400405929-14313-1-git-send-email-ogerlitz-lZu6o6FoHf8DyJZ7l8Lk7nI+JuX82XLG@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

This patch adds extended support for ibv_query_port.

This allows to request fields that aren't availible by the current
ibv_query_port API and avoid fetching from vendor library fields that
the user doesn't need, which gives more room for optimizations.

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 Makefile.am                |    3 +-
 include/infiniband/verbs.h |   89 ++++++++++++++++++++++++++++++++++++++++
 man/ibv_query_port_ex.3    |   97 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 188 insertions(+), 1 deletions(-)
 create mode 100644 man/ibv_query_port_ex.3

diff --git a/Makefile.am b/Makefile.am
index 3104d5a..c992a36 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -62,7 +62,8 @@ man_MANS = man/ibv_asyncwatch.1 man/ibv_devices.1 man/ibv_devinfo.1	\
     man/ibv_query_srq.3 man/ibv_rate_to_mult.3 man/ibv_reg_mr.3		\
     man/ibv_req_notify_cq.3 man/ibv_resize_cq.3 man/ibv_rate_to_mbps.3  \
     man/ibv_create_qp_ex.3 man/ibv_create_srq_ex.3 man/ibv_open_xrcd.3  \
-    man/ibv_get_srq_num.3 man/ibv_open_qp.3 man/ibv_create_flow.3
+    man/ibv_get_srq_num.3 man/ibv_open_qp.3 man/ibv_create_flow.3 	\
+    man/ibv_query_port_ex.3
 
 DEBIAN = debian/changelog debian/compat debian/control debian/copyright \
     debian/ibverbs-utils.install debian/libibverbs1.install \
diff --git a/include/infiniband/verbs.h b/include/infiniband/verbs.h
index ab497b1..1dc2a8d 100644
--- a/include/infiniband/verbs.h
+++ b/include/infiniband/verbs.h
@@ -489,6 +489,58 @@ struct ibv_ah_attr_ex {
 	uint16_t		vid;
 };
 
+enum ibv_query_port_ex_attr_mask {
+	IBV_QUERY_PORT_EX_STATE			= 1 << 0,
+	IBV_QUERY_PORT_EX_MAX_MTU		= 1 << 1,
+	IBV_QUERY_PORT_EX_ACTIVE_MTU		= 1 << 2,
+	IBV_QUERY_PORT_EX_GID_TBL_LEN		= 1 << 3,
+	IBV_QUERY_PORT_EX_CAP_FLAGS		= 1 << 4,
+	IBV_QUERY_PORT_EX_MAX_MSG_SZ		= 1 << 5,
+	IBV_QUERY_PORT_EX_BAD_PKEY_CNTR		= 1 << 6,
+	IBV_QUERY_PORT_EX_QKEY_VIOL_CNTR	= 1 << 7,
+	IBV_QUERY_PORT_EX_PKEY_TBL_LEN		= 1 << 8,
+	IBV_QUERY_PORT_EX_LID			= 1 << 9,
+	IBV_QUERY_PORT_EX_SM_LID		= 1 << 10,
+	IBV_QUERY_PORT_EX_LMC			= 1 << 11,
+	IBV_QUERY_PORT_EX_MAX_VL_NUM		= 1 << 12,
+	IBV_QUERY_PORT_EX_SM_SL			= 1 << 13,
+	IBV_QUERY_PORT_EX_SUBNET_TIMEOUT	= 1 << 14,
+	IBV_QUERY_PORT_EX_INIT_TYPE_REPLY	= 1 << 15,
+	IBV_QUERY_PORT_EX_ACTIVE_WIDTH		= 1 << 16,
+	IBV_QUERY_PORT_EX_ACTIVE_SPEED		= 1 << 17,
+	IBV_QUERY_PORT_EX_PHYS_STATE		= 1 << 18,
+	IBV_QUERY_PORT_EX_LINK_LAYER		= 1 << 19,
+	/* mask of the fields that exists in the standard query_port_command */
+	IBV_QUERY_PORT_EX_STD_MASK		= (1 << 20) - 1,
+	/* mask of all supported fields */
+	IBV_QUERY_PORT_EX_MASK			= IBV_QUERY_PORT_EX_STD_MASK,
+};
+
+struct ibv_port_attr_ex {
+	enum ibv_port_state	state;
+	enum ibv_mtu		max_mtu;
+	enum ibv_mtu		active_mtu;
+	int			gid_tbl_len;
+	uint32_t		port_cap_flags;
+	uint32_t		max_msg_sz;
+	uint32_t		bad_pkey_cntr;
+	uint32_t		qkey_viol_cntr;
+	uint16_t		pkey_tbl_len;
+	uint16_t		lid;
+	uint16_t		sm_lid;
+	uint8_t			lmc;
+	uint8_t			max_vl_num;
+	uint8_t			sm_sl;
+	uint8_t			subnet_timeout;
+	uint8_t			init_type_reply;
+	uint8_t			active_width;
+	uint8_t			active_speed;
+	uint8_t			phys_state;
+	uint8_t			link_layer;
+	uint8_t			reserved;
+	uint32_t		comp_mask;
+};
+
 
 enum ibv_srq_attr_mask {
 	IBV_SRQ_MAX_WR	= 1 << 0,
@@ -998,6 +1050,8 @@ enum verbs_context_mask {
 
 struct verbs_context {
 	/*  "grows up" - new fields go here */
+	int (*query_port_ex)(struct ibv_context *context, uint8_t port_num,
+			     struct ibv_port_attr_ex *port_attr);
 	struct ibv_ah * (*create_ah_ex)(struct ibv_pd *pd,
 					struct ibv_ah_attr_ex *attr);
 	void (*_reserved_2)(void);
@@ -1128,6 +1182,41 @@ static inline int ___ibv_query_port(struct ibv_context *context,
 	return ibv_query_port(context, port_num, port_attr);
 }
 
+static inline int ibv_query_port_ex(struct ibv_context *context,
+				    uint8_t port_num,
+				    struct ibv_port_attr_ex *port_attr)
+{
+	struct verbs_context *vctx;
+
+	port_attr->link_layer = IBV_LINK_LAYER_UNSPECIFIED;
+	port_attr->reserved   = 0;
+
+	if (0 == port_attr->comp_mask)
+		return ibv_query_port(context, port_num,
+				      (struct ibv_port_attr *)port_attr);
+
+	/* Check that only valid flags were given */
+	if (port_attr->comp_mask & ~IBV_QUERY_PORT_EX_MASK) {
+		errno = EINVAL;
+		return -errno;
+	}
+
+	vctx = verbs_get_ctx_op(context, query_port_ex);
+
+	if (!vctx) {
+		/* Fallback to legacy mode */
+		if (!(port_attr->comp_mask & ~IBV_QUERY_PORT_EX_STD_MASK))
+			return ibv_query_port(context, port_num,
+					      (struct ibv_port_attr *)port_attr);
+
+		/* Unsupported field was requested */
+		errno = ENOSYS;
+		return -errno;
+	}
+
+	return vctx->query_port_ex(context, port_num, port_attr);
+}
+
 #define ibv_query_port(context, port_num, port_attr) \
 	___ibv_query_port(context, port_num, port_attr)
 
diff --git a/man/ibv_query_port_ex.3 b/man/ibv_query_port_ex.3
new file mode 100644
index 0000000..07073fd
--- /dev/null
+++ b/man/ibv_query_port_ex.3
@@ -0,0 +1,97 @@
+.\" -*- nroff -*-
+.\"
+.TH IBV_QUERY_PORT_EX 3 2006-10-31 libibverbs "Libibverbs Programmer's Manual"
+.SH "NAME"
+ibv_query_port_ex \- query an RDMA port's attributes
+.SH "SYNOPSIS"
+.nf
+.B #include <infiniband/verbs.h>
+.sp
+.BI "int ibv_query_port_ex(struct ibv_context " "*context" ", uint8_t " "port_num" ,
+.BI "                      struct ibv_port_attr_ex " "*port_attr" ");
+.fi
+.SH "DESCRIPTION"
+.B ibv_query_port_ex()
+returns the attributes of port
+.I port_num
+for device context
+.I context
+through the pointer
+.I port_attr\fR.
+The argument
+.I port_attr
+is an ibv_port_attr struct, as defined in <infiniband/verbs.h>.
+.PP
+.nf
+struct ibv_port_attr_ex {
+.in +8
+enum ibv_port_state     state;          /* Logical port state */
+enum ibv_mtu            max_mtu;        /* Max MTU supported by port */
+enum ibv_mtu            active_mtu;     /* Actual MTU */
+int                     gid_tbl_len;    /* Length of source GID table */
+uint32_t                port_cap_flags; /* Port capabilities */
+uint32_t                max_msg_sz;     /* Maximum message size */
+uint32_t                bad_pkey_cntr;  /* Bad P_Key counter */
+uint32_t                qkey_viol_cntr; /* Q_Key violation counter */
+uint16_t                pkey_tbl_len;   /* Length of partition table */
+uint16_t                lid;            /* Base port LID */
+uint16_t                sm_lid;         /* SM LID */
+uint8_t                 lmc;            /* LMC of LID */
+uint8_t                 max_vl_num;     /* Maximum number of VLs */
+uint8_t                 sm_sl;          /* SM service level */
+uint8_t                 subnet_timeout; /* Subnet propagation delay */
+uint8_t                 init_type_reply;/* Type of initialization performed by SM */
+uint8_t                 active_width;   /* Currently active link width */
+uint8_t                 active_speed;   /* Currently active link speed */
+uint8_t                 phys_state;     /* Physical port state */
+uint8_t                 link_layer;     /* link layer protocol of the port */
+uint8_t                 reserved;       /* reserved field */
+uint32_t                comp_mask;      /* relevant fields for command */
+.in -8
+};
+.sp
+The comp_mask value describes which values the user is intrested in.
+Only those fields have a meaningful value when the command returns successfully.
+The available fields are described by ibv_query_port_ex_attr_mask, which is defined
+in <infiniband/verbs.h>. Every bit in comp_mask corresponds to a field in
+struct ibv_port_attr_ex, by the same order.
+.PP
+.nf
+enum ibv_query_port_ex_attr_mask {
+        IBV_QUERY_PORT_EX_STATE                 = 1 << 0,
+        IBV_QUERY_PORT_EX_MAX_MTU               = 1 << 1,
+        IBV_QUERY_PORT_EX_ACTIVE_MTU            = 1 << 2,
+        IBV_QUERY_PORT_EX_GID_TBL_LEN           = 1 << 3,
+        IBV_QUERY_PORT_EX_CAP_FLAGS             = 1 << 4,
+        IBV_QUERY_PORT_EX_MAX_MSG_SZ            = 1 << 5,
+        IBV_QUERY_PORT_EX_BAD_PKEY_CNTR         = 1 << 6,
+        IBV_QUERY_PORT_EX_QKEY_VIOL_CNTR        = 1 << 7,
+        IBV_QUERY_PORT_EX_PKEY_TBL_LEN          = 1 << 8,
+        IBV_QUERY_PORT_EX_LID                   = 1 << 9,
+        IBV_QUERY_PORT_EX_SM_LID                = 1 << 10,
+        IBV_QUERY_PORT_EX_LMC                   = 1 << 11,
+        IBV_QUERY_PORT_EX_MAX_VL_NUM            = 1 << 12,
+        IBV_QUERY_PORT_EX_SM_SL                 = 1 << 13,
+        IBV_QUERY_PORT_EX_SUBNET_TIMEOUT        = 1 << 14,
+        IBV_QUERY_PORT_EX_INIT_TYPE_REPLY       = 1 << 15,
+        IBV_QUERY_PORT_EX_ACTIVE_WIDTH          = 1 << 16,
+        IBV_QUERY_PORT_EX_ACTIVE_SPEED          = 1 << 17,
+        IBV_QUERY_PORT_EX_PHYS_STATE            = 1 << 18,
+        IBV_QUERY_PORT_EX_LINK_LAYER            = 1 << 19
+}
+.sp
+possible values for the link layer field are IBV_LINK_LAYER_INFINIBAND,
+IBV_LINK_LAYER_ETHERNET, or IBV_LINK_LAYER_UNSPECIFIED.
+.sp
+.fi
+.SH "RETURN VALUE"
+.B ibv_query_port_ex()
+returns 0 on success, or the value of errno on failure (which indicates the failure reason).
+.SH "SEE ALSO"
+.BR ibv_create_qp (3),
+.BR ibv_destroy_qp (3),
+.BR ibv_query_qp (3),
+.BR ibv_create_ah (3)
+.SH "AUTHORS"
+.TP
+Dotan Barak <dotanba-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>        Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
