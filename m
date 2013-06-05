From: Jeff Squyres <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] libibverbs: A possible solution for allowing arbitrary MTU values.
Date: Wed,  5 Jun 2013 06:00:23 -0700
Message-ID: <1370437223-14171-1-git-send-email-jsquyres@cisco.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jeff Squyres <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Set the IBV_MTU_* enums equal to their values (e.g., IBV_MTU_1024 =
1024), and then pass MTU values around as int's.  Legacy applications
will use the enum values, but newer applications can use any int for
values that do not currently exist in the enum set (e.g., 1500, 9000).

The obvious drawback is that this will break ABI; applications will
need to be recompiled.

(if this approach/patch is acceptable, I will submit a corresponding
patch for the kernel side)

Signed-off-by: Jeff Squyres <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
---
 examples/devinfo.c         | 18 +++++++++---------
 examples/pingpong.c        | 12 ------------
 examples/pingpong.h        |  1 -
 examples/rc_pingpong.c     |  8 ++++----
 examples/srq_pingpong.c    |  8 ++++----
 examples/uc_pingpong.c     |  8 ++++----
 include/infiniband/verbs.h | 16 ++++++++--------
 man/ibv_modify_qp.3        |  2 +-
 man/ibv_query_port.3       |  4 ++--
 man/ibv_query_qp.3         |  2 +-
 10 files changed, 33 insertions(+), 46 deletions(-)

diff --git a/examples/devinfo.c b/examples/devinfo.c
index ff078e4..f46deca 100644
--- a/examples/devinfo.c
+++ b/examples/devinfo.c
@@ -111,16 +111,16 @@ static const char *atomic_cap_str(enum ibv_atomic_cap atom_cap)
 	}
 }
 
-static const char *mtu_str(enum ibv_mtu max_mtu)
+static const char *mtu_str(int max_mtu)
 {
-	switch (max_mtu) {
-	case IBV_MTU_256:  return "256";
-	case IBV_MTU_512:  return "512";
-	case IBV_MTU_1024: return "1024";
-	case IBV_MTU_2048: return "2048";
-	case IBV_MTU_4096: return "4096";
-	default:           return "invalid MTU";
-	}
+	static char str[16];
+
+	if (max_mtu > 0)
+		snprintf(str, sizeof(str), "%d", max_mtu);
+	else
+		strncpy(str, "invalid MTU", sizeof(str));
+
+	return str;
 }
 
 static const char *width_str(uint8_t width)
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
index 15494a1..8a5318b 100644
--- a/examples/rc_pingpong.c
+++ b/examples/rc_pingpong.c
@@ -78,7 +78,7 @@ struct pingpong_dest {
 };
 
 static int pp_connect_ctx(struct pingpong_context *ctx, int port, int my_psn,
-			  enum ibv_mtu mtu, int sl,
+			  int mtu, int sl,
 			  struct pingpong_dest *dest, int sgid_idx)
 {
 	struct ibv_qp_attr attr = {
@@ -209,7 +209,7 @@ out:
 }
 
 static struct pingpong_dest *pp_server_exch_dest(struct pingpong_context *ctx,
-						 int ib_port, enum ibv_mtu mtu,
+						 int ib_port, int mtu,
 						 int port, int sl,
 						 const struct pingpong_dest *my_dest,
 						 int sgid_idx)
@@ -547,7 +547,7 @@ int main(int argc, char *argv[])
 	int                      port = 18515;
 	int                      ib_port = 1;
 	int                      size = 4096;
-	enum ibv_mtu		 mtu = IBV_MTU_1024;
+	int			 mtu = 1024;
 	int                      rx_depth = 500;
 	int                      iters = 1000;
 	int                      use_event = 0;
@@ -608,7 +608,7 @@ int main(int argc, char *argv[])
 			break;
 
 		case 'm':
-			mtu = pp_mtu_to_enum(strtol(optarg, NULL, 0));
+			mtu = strtol(optarg, NULL, 0);
 			if (mtu < 0) {
 				usage(argv[0]);
 				return 1;
diff --git a/examples/srq_pingpong.c b/examples/srq_pingpong.c
index 6e00f8c..f1eb879 100644
--- a/examples/srq_pingpong.c
+++ b/examples/srq_pingpong.c
@@ -81,7 +81,7 @@ struct pingpong_dest {
 	union ibv_gid gid;
 };
 
-static int pp_connect_ctx(struct pingpong_context *ctx, int port, enum ibv_mtu mtu,
+static int pp_connect_ctx(struct pingpong_context *ctx, int port, int mtu,
 			  int sl, const struct pingpong_dest *my_dest,
 			  const struct pingpong_dest *dest, int sgid_idx)
 {
@@ -229,7 +229,7 @@ out:
 }
 
 static struct pingpong_dest *pp_server_exch_dest(struct pingpong_context *ctx,
-						 int ib_port, enum ibv_mtu mtu,
+						 int ib_port, int mtu,
 						 int port, int sl,
 						 const struct pingpong_dest *my_dest,
 						 int sgid_idx)
@@ -620,7 +620,7 @@ int main(int argc, char *argv[])
 	int                      port = 18515;
 	int                      ib_port = 1;
 	int                      size = 4096;
-	enum ibv_mtu		 mtu = IBV_MTU_1024;
+	int			 mtu = 1024;
 	int                      num_qp = 16;
 	int                      rx_depth = 500;
 	int                      iters = 1000;
@@ -685,7 +685,7 @@ int main(int argc, char *argv[])
 			break;
 
 		case 'm':
-			mtu = pp_mtu_to_enum(strtol(optarg, NULL, 0));
+			mtu = strtol(optarg, NULL, 0);
 			if (mtu < 0) {
 				usage(argv[0]);
 				return 1;
diff --git a/examples/uc_pingpong.c b/examples/uc_pingpong.c
index 52c6c28..02268c3 100644
--- a/examples/uc_pingpong.c
+++ b/examples/uc_pingpong.c
@@ -78,7 +78,7 @@ struct pingpong_dest {
 };
 
 static int pp_connect_ctx(struct pingpong_context *ctx, int port, int my_psn,
-			  enum ibv_mtu mtu, int sl,
+			  int mtu, int sl,
 			  struct pingpong_dest *dest, int sgid_idx)
 {
 	struct ibv_qp_attr attr = {
@@ -197,7 +197,7 @@ out:
 }
 
 static struct pingpong_dest *pp_server_exch_dest(struct pingpong_context *ctx,
-						 int ib_port, enum ibv_mtu mtu,
+						 int ib_port, int mtu,
 						 int port, int sl,
 						 const struct pingpong_dest *my_dest,
 						 int sgid_idx)
@@ -535,7 +535,7 @@ int main(int argc, char *argv[])
 	int                      port = 18515;
 	int                      ib_port = 1;
 	int                      size = 4096;
-	enum ibv_mtu		 mtu = IBV_MTU_1024;
+	int			 mtu = 1024;
 	int                      rx_depth = 500;
 	int                      iters = 1000;
 	int                      use_event = 0;
@@ -596,7 +596,7 @@ int main(int argc, char *argv[])
 			break;
 
 		case 'm':
-			mtu = pp_mtu_to_enum(strtol(optarg, NULL, 0));
+			mtu = strtol(optarg, NULL, 0);
 			if (mtu < 0) {
 				usage(argv[0]);
 				return 1;
diff --git a/include/infiniband/verbs.h b/include/infiniband/verbs.h
index 4b1ab57..78bcac1 100644
--- a/include/infiniband/verbs.h
+++ b/include/infiniband/verbs.h
@@ -145,11 +145,11 @@ struct ibv_device_attr {
 };
 
 enum ibv_mtu {
-	IBV_MTU_256  = 1,
-	IBV_MTU_512  = 2,
-	IBV_MTU_1024 = 3,
-	IBV_MTU_2048 = 4,
-	IBV_MTU_4096 = 5
+	IBV_MTU_256  = 256,
+	IBV_MTU_512  = 512,
+	IBV_MTU_1024 = 1024,
+	IBV_MTU_2048 = 2048,
+	IBV_MTU_4096 = 4096
 };
 
 enum ibv_port_state {
@@ -169,8 +169,8 @@ enum {
 
 struct ibv_port_attr {
 	enum ibv_port_state	state;
-	enum ibv_mtu		max_mtu;
-	enum ibv_mtu		active_mtu;
+	int			max_mtu;
+	int			active_mtu;
 	int			gid_tbl_len;
 	uint32_t		port_cap_flags;
 	uint32_t		max_msg_sz;
@@ -485,7 +485,7 @@ enum ibv_mig_state {
 struct ibv_qp_attr {
 	enum ibv_qp_state	qp_state;
 	enum ibv_qp_state	cur_qp_state;
-	enum ibv_mtu		path_mtu;
+	int			path_mtu;
 	enum ibv_mig_state	path_mig_state;
 	uint32_t		qkey;
 	uint32_t		rq_psn;
diff --git a/man/ibv_modify_qp.3 b/man/ibv_modify_qp.3
index cb3faaa..21165fa 100644
--- a/man/ibv_modify_qp.3
+++ b/man/ibv_modify_qp.3
@@ -25,7 +25,7 @@ struct ibv_qp_attr {
 .in +8
 enum ibv_qp_state       qp_state;               /* Move the QP to this state */
 enum ibv_qp_state       cur_qp_state;           /* Assume this is the current QP state */
-enum ibv_mtu            path_mtu;               /* Path MTU (valid only for RC/UC QPs) */
+int                     path_mtu;               /* Path MTU (valid only for RC/UC QPs) */
 enum ibv_mig_state      path_mig_state;         /* Path migration state (valid if HCA supports APM) */
 uint32_t                qkey;                   /* Q_Key for the QP (valid only for UD QPs) */
 uint32_t                rq_psn;                 /* PSN for receive queue (valid only for RC/UC QPs) */
diff --git a/man/ibv_query_port.3 b/man/ibv_query_port.3
index 9bedd90..2e9baf1 100644
--- a/man/ibv_query_port.3
+++ b/man/ibv_query_port.3
@@ -26,8 +26,8 @@ is an ibv_port_attr struct, as defined in <infiniband/verbs.h>.
 struct ibv_port_attr {
 .in +8
 enum ibv_port_state     state;          /* Logical port state */
-enum ibv_mtu            max_mtu;        /* Max MTU supported by port */
-enum ibv_mtu            active_mtu;     /* Actual MTU */
+int                     max_mtu;        /* Max MTU supported by port */
+int                     active_mtu;     /* Actual MTU */
 int                     gid_tbl_len;    /* Length of source GID table */
 uint32_t                port_cap_flags; /* Port capabilities */
 uint32_t                max_msg_sz;     /* Maximum message size */
diff --git a/man/ibv_query_qp.3 b/man/ibv_query_qp.3
index 3893ec8..3c7ff26 100644
--- a/man/ibv_query_qp.3
+++ b/man/ibv_query_qp.3
@@ -30,7 +30,7 @@ struct ibv_qp_attr {
 .in +8
 enum ibv_qp_state       qp_state;            /* Current QP state */
 enum ibv_qp_state       cur_qp_state;        /* Current QP state - irrelevant for ibv_query_qp */
-enum ibv_mtu            path_mtu;            /* Path MTU (valid only for RC/UC QPs) */
+int                     path_mtu;            /* Path MTU (valid only for RC/UC QPs) */
 enum ibv_mig_state      path_mig_state;      /* Path migration state (valid if HCA supports APM) */
 uint32_t                qkey;                /* Q_Key of the QP (valid only for UD QPs) */
 uint32_t                rq_psn;              /* PSN for receive queue (valid only for RC/UC QPs) */
-- 
1.8.2.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
