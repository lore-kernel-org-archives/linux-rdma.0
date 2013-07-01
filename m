From: Jeff Squyres <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] libibverbs: Allow arbitrary int values for MTU
Date: Mon,  1 Jul 2013 07:23:00 -0700
Message-ID: <1372688580-15452-1-git-send-email-jsquyres@cisco.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jeff Squyres <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Keep IBV_MTU_* enums values as they are, but pass MTU values around as
a struct containing a single int.  Per lengthy discusson on the
linux-rdma list, this patch introdces a source code incompatibility.
Although legacy applications can continue to use the enum values, they
will need to be updated to use the struct.  Newer applications are
encouraged to use arbitrary int values, not the MTU enums (e.g., 1024,
1500, 9000).

(if people like the idea of this patch, I will send the corresponding
kernel patch)

Signed-off-by: Jeff Squyres <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
---
 Makefile.am                |  3 ++-
 examples/devinfo.c         | 20 +++------------
 examples/pingpong.c        | 12 ---------
 examples/pingpong.h        |  1 -
 examples/rc_pingpong.c     | 10 ++++----
 examples/srq_pingpong.c    | 10 ++++----
 examples/uc_pingpong.c     | 10 ++++----
 examples/ud_pingpong.c     |  2 +-
 include/infiniband/verbs.h | 61 +++++++++++++++++++++++++++++++++++++++++++---
 man/ibv_modify_qp.3        |  2 +-
 man/ibv_query_port.3       |  4 +--
 man/ibv_query_qp.3         |  2 +-
 src/cmd.c                  |  8 +++---
 src/marshall.c             |  2 +-
 14 files changed, 89 insertions(+), 58 deletions(-)

diff --git a/Makefile.am b/Makefile.am
index 40e83be..1159e55 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -54,7 +54,8 @@ man_MANS = man/ibv_asyncwatch.1 man/ibv_devices.1 man/ibv_devinfo.1	\
     man/ibv_post_srq_recv.3 man/ibv_query_device.3 man/ibv_query_gid.3	\
     man/ibv_query_pkey.3 man/ibv_query_port.3 man/ibv_query_qp.3	\
     man/ibv_query_srq.3 man/ibv_rate_to_mult.3 man/ibv_reg_mr.3		\
-    man/ibv_req_notify_cq.3 man/ibv_resize_cq.3 man/ibv_rate_to_mbps.3
+    man/ibv_req_notify_cq.3 man/ibv_resize_cq.3 man/ibv_rate_to_mbps.3  \
+    man/ibv_mtu_to_num.3
 
 DEBIAN = debian/changelog debian/compat debian/control debian/copyright \
     debian/ibverbs-utils.install debian/libibverbs1.install \
diff --git a/examples/devinfo.c b/examples/devinfo.c
index ff078e4..e8fb27e 100644
--- a/examples/devinfo.c
+++ b/examples/devinfo.c
@@ -111,18 +111,6 @@ static const char *atomic_cap_str(enum ibv_atomic_cap atom_cap)
 	}
 }
 
-static const char *mtu_str(enum ibv_mtu max_mtu)
-{
-	switch (max_mtu) {
-	case IBV_MTU_256:  return "256";
-	case IBV_MTU_512:  return "512";
-	case IBV_MTU_1024: return "1024";
-	case IBV_MTU_2048: return "2048";
-	case IBV_MTU_4096: return "4096";
-	default:           return "invalid MTU";
-	}
-}
-
 static const char *width_str(uint8_t width)
 {
 	switch (width) {
@@ -301,10 +289,10 @@ static int print_hca_cap(struct ibv_device *ib_dev, uint8_t ib_port)
 		printf("\t\tport:\t%d\n", port);
 		printf("\t\t\tstate:\t\t\t%s (%d)\n",
 		       port_state_str(port_attr.state), port_attr.state);
-		printf("\t\t\tmax_mtu:\t\t%s (%d)\n",
-		       mtu_str(port_attr.max_mtu), port_attr.max_mtu);
-		printf("\t\t\tactive_mtu:\t\t%s (%d)\n",
-		       mtu_str(port_attr.active_mtu), port_attr.active_mtu);
+		printf("\t\t\tmax_mtu:\t\t%d (%d)\n",
+		       ibv_mtu_to_num(port_attr.max_mtu), port_attr.max_mtu.mtu);
+		printf("\t\t\tactive_mtu:\t\t%d (%d)\n",
+			ibv_mtu_to_num(port_attr.active_mtu), port_attr.active_mtu.mtu);
 		printf("\t\t\tsm_lid:\t\t\t%d\n", port_attr.sm_lid);
 		printf("\t\t\tport_lid:\t\t%d\n", port_attr.lid);
 		printf("\t\t\tport_lmc:\t\t0x%02x\n", port_attr.lmc);
diff --git a/examples/pingpong.c b/examples/pingpong.c
index 90732ef..d1c22c9 100644
--- a/examples/pingpong.c
+++ b/examples/pingpong.c
@@ -36,18 +36,6 @@
 #include <stdio.h>
 #include <string.h>
 
-enum ibv_mtu pp_mtu_to_enum(int mtu)
-{
-	switch (mtu) {
-	case 256:  return IBV_MTU_256;
-	case 512:  return IBV_MTU_512;
-	case 1024: return IBV_MTU_1024;
-	case 2048: return IBV_MTU_2048;
-	case 4096: return IBV_MTU_4096;
-	default:   return -1;
-	}
-}
-
 uint16_t pp_get_local_lid(struct ibv_context *context, int port)
 {
 	struct ibv_port_attr attr;
diff --git a/examples/pingpong.h b/examples/pingpong.h
index 9cdc03e..91d217b 100644
--- a/examples/pingpong.h
+++ b/examples/pingpong.h
@@ -35,7 +35,6 @@
 
 #include <infiniband/verbs.h>
 
-enum ibv_mtu pp_mtu_to_enum(int mtu);
 uint16_t pp_get_local_lid(struct ibv_context *context, int port);
 int pp_get_port_info(struct ibv_context *context, int port,
 		     struct ibv_port_attr *attr);
diff --git a/examples/rc_pingpong.c b/examples/rc_pingpong.c
index 15494a1..a7e1836 100644
--- a/examples/rc_pingpong.c
+++ b/examples/rc_pingpong.c
@@ -78,7 +78,7 @@ struct pingpong_dest {
 };
 
 static int pp_connect_ctx(struct pingpong_context *ctx, int port, int my_psn,
-			  enum ibv_mtu mtu, int sl,
+			  struct ibv_mtu_t mtu, int sl,
 			  struct pingpong_dest *dest, int sgid_idx)
 {
 	struct ibv_qp_attr attr = {
@@ -209,7 +209,7 @@ out:
 }
 
 static struct pingpong_dest *pp_server_exch_dest(struct pingpong_context *ctx,
-						 int ib_port, enum ibv_mtu mtu,
+						 int ib_port, struct ibv_mtu_t mtu,
 						 int port, int sl,
 						 const struct pingpong_dest *my_dest,
 						 int sgid_idx)
@@ -547,7 +547,7 @@ int main(int argc, char *argv[])
 	int                      port = 18515;
 	int                      ib_port = 1;
 	int                      size = 4096;
-	enum ibv_mtu		 mtu = IBV_MTU_1024;
+	struct ibv_mtu_t	 mtu = num_to_ibv_mtu(1024);
 	int                      rx_depth = 500;
 	int                      iters = 1000;
 	int                      use_event = 0;
@@ -608,8 +608,8 @@ int main(int argc, char *argv[])
 			break;
 
 		case 'm':
-			mtu = pp_mtu_to_enum(strtol(optarg, NULL, 0));
-			if (mtu < 0) {
+			mtu = num_to_ibv_mtu(strtol(optarg, NULL, 0));
+			if (mtu.mtu < 0) {
 				usage(argv[0]);
 				return 1;
 			}
diff --git a/examples/srq_pingpong.c b/examples/srq_pingpong.c
index 6e00f8c..9173274 100644
--- a/examples/srq_pingpong.c
+++ b/examples/srq_pingpong.c
@@ -81,7 +81,7 @@ struct pingpong_dest {
 	union ibv_gid gid;
 };
 
-static int pp_connect_ctx(struct pingpong_context *ctx, int port, enum ibv_mtu mtu,
+static int pp_connect_ctx(struct pingpong_context *ctx, int port, struct ibv_mtu_t mtu,
 			  int sl, const struct pingpong_dest *my_dest,
 			  const struct pingpong_dest *dest, int sgid_idx)
 {
@@ -229,7 +229,7 @@ out:
 }
 
 static struct pingpong_dest *pp_server_exch_dest(struct pingpong_context *ctx,
-						 int ib_port, enum ibv_mtu mtu,
+						 int ib_port, struct ibv_mtu_t mtu,
 						 int port, int sl,
 						 const struct pingpong_dest *my_dest,
 						 int sgid_idx)
@@ -620,7 +620,7 @@ int main(int argc, char *argv[])
 	int                      port = 18515;
 	int                      ib_port = 1;
 	int                      size = 4096;
-	enum ibv_mtu		 mtu = IBV_MTU_1024;
+	struct ibv_mtu_t	 mtu = num_to_ibv_mtu(1024);
 	int                      num_qp = 16;
 	int                      rx_depth = 500;
 	int                      iters = 1000;
@@ -685,8 +685,8 @@ int main(int argc, char *argv[])
 			break;
 
 		case 'm':
-			mtu = pp_mtu_to_enum(strtol(optarg, NULL, 0));
-			if (mtu < 0) {
+			mtu = num_to_ibv_mtu(strtol(optarg, NULL, 0));
+			if (mtu.mtu < 0) {
 				usage(argv[0]);
 				return 1;
 			}
diff --git a/examples/uc_pingpong.c b/examples/uc_pingpong.c
index 52c6c28..6b6bc85 100644
--- a/examples/uc_pingpong.c
+++ b/examples/uc_pingpong.c
@@ -78,7 +78,7 @@ struct pingpong_dest {
 };
 
 static int pp_connect_ctx(struct pingpong_context *ctx, int port, int my_psn,
-			  enum ibv_mtu mtu, int sl,
+			  struct ibv_mtu_t mtu, int sl,
 			  struct pingpong_dest *dest, int sgid_idx)
 {
 	struct ibv_qp_attr attr = {
@@ -197,7 +197,7 @@ out:
 }
 
 static struct pingpong_dest *pp_server_exch_dest(struct pingpong_context *ctx,
-						 int ib_port, enum ibv_mtu mtu,
+						 int ib_port, struct ibv_mtu_t mtu,
 						 int port, int sl,
 						 const struct pingpong_dest *my_dest,
 						 int sgid_idx)
@@ -535,7 +535,7 @@ int main(int argc, char *argv[])
 	int                      port = 18515;
 	int                      ib_port = 1;
 	int                      size = 4096;
-	enum ibv_mtu		 mtu = IBV_MTU_1024;
+	struct ibv_mtu_t	 mtu = num_to_ibv_mtu(1024);
 	int                      rx_depth = 500;
 	int                      iters = 1000;
 	int                      use_event = 0;
@@ -596,8 +596,8 @@ int main(int argc, char *argv[])
 			break;
 
 		case 'm':
-			mtu = pp_mtu_to_enum(strtol(optarg, NULL, 0));
-			if (mtu < 0) {
+			mtu = num_to_ibv_mtu(strtol(optarg, NULL, 0));
+			if (mtu.mtu < 0) {
 				usage(argv[0]);
 				return 1;
 			}
diff --git a/examples/ud_pingpong.c b/examples/ud_pingpong.c
index 21c551d..5a0656f 100644
--- a/examples/ud_pingpong.c
+++ b/examples/ud_pingpong.c
@@ -332,7 +332,7 @@ static struct pingpong_context *pp_init_ctx(struct ibv_device *ib_dev, int size,
 			fprintf(stderr, "Unable to query port info for port %d\n", port);
 			goto clean_device;
 		}
-		mtu = 1 << (port_info.active_mtu + 7);
+		mtu = ibv_mtu_to_num(port_info.active_mtu);
 		if (size > mtu) {
 			fprintf(stderr, "Requested size larger than port MTU (%d)\n", mtu);
 			goto clean_device;
diff --git a/include/infiniband/verbs.h b/include/infiniband/verbs.h
index 4b1ab57..0545a8c 100644
--- a/include/infiniband/verbs.h
+++ b/include/infiniband/verbs.h
@@ -144,6 +144,10 @@ struct ibv_device_attr {
 	uint8_t			phys_port_cnt;
 };
 
+/*
+ * Symbolic enum names for MTU values are preserved for backwards
+ * compatibility.
+ */
 enum ibv_mtu {
 	IBV_MTU_256  = 1,
 	IBV_MTU_512  = 2,
@@ -152,6 +156,16 @@ enum ibv_mtu {
 	IBV_MTU_4096 = 5
 };
 
+/*
+ * ibv_mtu_t is an encoded integer type that represents an MTU value.
+ * If the value is <= IBV_MTU_4096, it is treated as one of the
+ * IBV_MTU_* enum values.  Otherwise, it is treated as its integer
+ * value.
+ */
+struct ibv_mtu_t {
+	int mtu;
+};
+
 enum ibv_port_state {
 	IBV_PORT_NOP		= 0,
 	IBV_PORT_DOWN		= 1,
@@ -169,8 +183,8 @@ enum {
 
 struct ibv_port_attr {
 	enum ibv_port_state	state;
-	enum ibv_mtu		max_mtu;
-	enum ibv_mtu		active_mtu;
+	struct ibv_mtu_t	max_mtu;
+	struct ibv_mtu_t	active_mtu;
 	int			gid_tbl_len;
 	uint32_t		port_cap_flags;
 	uint32_t		max_msg_sz;
@@ -485,7 +499,7 @@ enum ibv_mig_state {
 struct ibv_qp_attr {
 	enum ibv_qp_state	qp_state;
 	enum ibv_qp_state	cur_qp_state;
-	enum ibv_mtu		path_mtu;
+	struct ibv_mtu_t	path_mtu;
 	enum ibv_mig_state	path_mig_state;
 	uint32_t		qkey;
 	uint32_t		rq_psn;
@@ -1138,6 +1152,47 @@ const char *ibv_port_state_str(enum ibv_port_state port_state);
  */
 const char *ibv_event_type_str(enum ibv_event_type event);
 
+/**
+ * num_to_ibv_mtu - Convert an integer to its corresponding encoded
+ * ibv_mtu_t value.  If an integer value corresponding to an IBV_MTU_*
+ * enum value is passed, return the enum value (e.g., 1024 ->
+ * IBV_MTU_1024).  Otherwise, just return the value (e.g., 1500 ->
+ * 1500).
+ */
+static inline struct ibv_mtu_t num_to_ibv_mtu(int num)
+{
+	struct ibv_mtu_t mtu;
+
+	switch (num) {
+	case 256:  mtu.mtu = IBV_MTU_256;  break;
+	case 512:  mtu.mtu = IBV_MTU_512;  break;
+	case 1024: mtu.mtu = IBV_MTU_1024; break;
+	case 2048: mtu.mtu = IBV_MTU_2048; break;
+	case 4096: mtu.mtu = IBV_MTU_4096; break;
+	default:   mtu.mtu = num;          break;
+	}
+
+	return mtu;
+}
+
+/**
+ * ibv_mtu_to_num - Convert an encoded ibv_mtu_t value to its
+ * corresponding integer value.  If an enum ibv_mtu value is passed,
+ * return its integer value (e.g., IBV_MTU_1024 -> 1024).  Otherwise,
+ * just return the value (e.g., 1500 -> 1500).
+ */
+static inline int ibv_mtu_to_num(struct ibv_mtu_t mtu)
+{
+	switch (mtu.mtu) {
+	case IBV_MTU_256:  return 256;
+	case IBV_MTU_512:  return 512;
+	case IBV_MTU_1024: return 1024;
+	case IBV_MTU_2048: return 2048;
+	case IBV_MTU_4096: return 4096;
+	default:           return mtu.mtu;
+	}
+}
+
 END_C_DECLS
 
 #  undef __attribute_const
diff --git a/man/ibv_modify_qp.3 b/man/ibv_modify_qp.3
index cb3faaa..26dfcf3 100644
--- a/man/ibv_modify_qp.3
+++ b/man/ibv_modify_qp.3
@@ -25,7 +25,7 @@ struct ibv_qp_attr {
 .in +8
 enum ibv_qp_state       qp_state;               /* Move the QP to this state */
 enum ibv_qp_state       cur_qp_state;           /* Assume this is the current QP state */
-enum ibv_mtu            path_mtu;               /* Path MTU (valid only for RC/UC QPs) */
+ibv_mtu_t               path_mtu;               /* Path MTU (valid only for RC/UC QPs) */
 enum ibv_mig_state      path_mig_state;         /* Path migration state (valid if HCA supports APM) */
 uint32_t                qkey;                   /* Q_Key for the QP (valid only for UD QPs) */
 uint32_t                rq_psn;                 /* PSN for receive queue (valid only for RC/UC QPs) */
diff --git a/man/ibv_query_port.3 b/man/ibv_query_port.3
index 9bedd90..3700a5e 100644
--- a/man/ibv_query_port.3
+++ b/man/ibv_query_port.3
@@ -26,8 +26,8 @@ is an ibv_port_attr struct, as defined in <infiniband/verbs.h>.
 struct ibv_port_attr {
 .in +8
 enum ibv_port_state     state;          /* Logical port state */
-enum ibv_mtu            max_mtu;        /* Max MTU supported by port */
-enum ibv_mtu            active_mtu;     /* Actual MTU */
+ibv_mtu_t               max_mtu;        /* Max MTU supported by port */
+ibv_mtu_t               active_mtu;     /* Actual MTU */
 int                     gid_tbl_len;    /* Length of source GID table */
 uint32_t                port_cap_flags; /* Port capabilities */
 uint32_t                max_msg_sz;     /* Maximum message size */
diff --git a/man/ibv_query_qp.3 b/man/ibv_query_qp.3
index 3893ec8..ad7d9d5 100644
--- a/man/ibv_query_qp.3
+++ b/man/ibv_query_qp.3
@@ -30,7 +30,7 @@ struct ibv_qp_attr {
 .in +8
 enum ibv_qp_state       qp_state;            /* Current QP state */
 enum ibv_qp_state       cur_qp_state;        /* Current QP state - irrelevant for ibv_query_qp */
-enum ibv_mtu            path_mtu;            /* Path MTU (valid only for RC/UC QPs) */
+ibv_mtu_t               path_mtu;            /* Path MTU (valid only for RC/UC QPs) */
 enum ibv_mig_state      path_mig_state;      /* Path migration state (valid if HCA supports APM) */
 uint32_t                qkey;                /* Q_Key of the QP (valid only for UD QPs) */
 uint32_t                rq_psn;              /* PSN for receive queue (valid only for RC/UC QPs) */
diff --git a/src/cmd.c b/src/cmd.c
index 9789092..13fac0d 100644
--- a/src/cmd.c
+++ b/src/cmd.c
@@ -180,8 +180,8 @@ int ibv_cmd_query_port(struct ibv_context *context, uint8_t port_num,
 	(void) VALGRIND_MAKE_MEM_DEFINED(&resp, sizeof resp);
 
 	port_attr->state      	   = resp.state;
-	port_attr->max_mtu         = resp.max_mtu;
-	port_attr->active_mtu      = resp.active_mtu;
+	port_attr->max_mtu.mtu     = resp.max_mtu;
+	port_attr->active_mtu.mtu  = resp.active_mtu;
 	port_attr->gid_tbl_len     = resp.gid_tbl_len;
 	port_attr->port_cap_flags  = resp.port_cap_flags;
 	port_attr->max_msg_sz      = resp.max_msg_sz;
@@ -678,7 +678,7 @@ int ibv_cmd_query_qp(struct ibv_qp *qp, struct ibv_qp_attr *attr,
 	attr->alt_pkey_index                = resp.alt_pkey_index;
 	attr->qp_state                      = resp.qp_state;
 	attr->cur_qp_state                  = resp.cur_qp_state;
-	attr->path_mtu                      = resp.path_mtu;
+	attr->path_mtu.mtu                  = resp.path_mtu;
 	attr->path_mig_state                = resp.path_mig_state;
 	attr->sq_draining                   = resp.sq_draining;
 	attr->max_rd_atomic                 = resp.max_rd_atomic;
@@ -752,7 +752,7 @@ int ibv_cmd_modify_qp(struct ibv_qp *qp, struct ibv_qp_attr *attr,
 	cmd->alt_pkey_index 	 = attr->alt_pkey_index;
 	cmd->qp_state 		 = attr->qp_state;
 	cmd->cur_qp_state 	 = attr->cur_qp_state;
-	cmd->path_mtu 		 = attr->path_mtu;
+	cmd->path_mtu		 = attr->path_mtu.mtu;
 	cmd->path_mig_state 	 = attr->path_mig_state;
 	cmd->en_sqd_async_notify = attr->en_sqd_async_notify;
 	cmd->max_rd_atomic 	 = attr->max_rd_atomic;
diff --git a/src/marshall.c b/src/marshall.c
index 577b4b1..a3595dc 100644
--- a/src/marshall.c
+++ b/src/marshall.c
@@ -59,7 +59,7 @@ void ibv_copy_qp_attr_from_kern(struct ibv_qp_attr *dst,
 				struct ibv_kern_qp_attr *src)
 {
 	dst->cur_qp_state = src->cur_qp_state;
-	dst->path_mtu = src->path_mtu;
+	dst->path_mtu.mtu = src->path_mtu;
 	dst->path_mig_state = src->path_mig_state;
 	dst->qkey = src->qkey;
 	dst->rq_psn = src->rq_psn;
-- 
1.8.2.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
