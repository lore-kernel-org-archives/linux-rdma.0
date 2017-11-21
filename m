From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH rdma-core] Eliminate BEGIN_C_DECLS and END_C_DECLS macros in
 libibverbs and libibumad headers
Date: Mon, 20 Nov 2017 21:42:50 -0500
Message-ID: <774ff06e-2274-13e3-00c0-97ccba78b1a6@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


to reduce symbol pollution

Replace these macros with open coding

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 libibumad/umad.h       | 14 +++++---------
 libibumad/umad_cm.h    | 14 +++++---------
 libibumad/umad_sa.h    | 14 +++++---------
 libibumad/umad_sm.h    | 14 +++++---------
 libibumad/umad_str.h   | 14 +++++---------
 libibumad/umad_types.h | 14 +++++---------
 libibverbs/driver.h    |  8 --------
 libibverbs/marshall.h  | 14 +++++---------
 libibverbs/tm_types.h  | 14 +++++---------
 libibverbs/verbs.h     | 17 +++++++----------
 10 files changed, 47 insertions(+), 90 deletions(-)

diff --git a/libibumad/umad.h b/libibumad/umad.h
index 479165a..59677f3 100644
--- a/libibumad/umad.h
+++ b/libibumad/umad.h
@@ -41,14 +41,8 @@
 #include <linux/types.h> /* __be16, __be32 and __be64 */
 
 #ifdef __cplusplus
-#  define BEGIN_C_DECLS extern "C" {
-#  define END_C_DECLS   }
-#else				/* !__cplusplus */
-#  define BEGIN_C_DECLS
-#  define END_C_DECLS
-#endif				/* __cplusplus */
-
-BEGIN_C_DECLS
+extern "C" {
+#endif
 
 typedef __be16 __attribute__((deprecated)) be16_t;
 typedef __be32 __attribute__((deprecated)) be32_t;
@@ -259,5 +253,7 @@ static inline __attribute__((deprecated)) uint64_t htonll(uint64_t x) { return h
 #define htonll htonll
 #endif
 
-END_C_DECLS
+#ifdef __cplusplus
+}
+#endif
 #endif				/* _UMAD_H */
diff --git a/libibumad/umad_cm.h b/libibumad/umad_cm.h
index e063f8a..dd077f7 100644
--- a/libibumad/umad_cm.h
+++ b/libibumad/umad_cm.h
@@ -37,14 +37,8 @@
 #include <infiniband/umad_types.h>
 
 #ifdef __cplusplus
-#  define BEGIN_C_DECLS extern "C" {
-#  define END_C_DECLS   }
-#else				/* !__cplusplus */
-#  define BEGIN_C_DECLS
-#  define END_C_DECLS
-#endif				/* __cplusplus */
-
-BEGIN_C_DECLS
+extern "C" {
+#endif
 
 /* Communication management attributes */
 enum {
@@ -63,5 +57,7 @@ enum {
 	UMAD_CM_ATTR_SPR		= 0x001C,
 };
 
-END_C_DECLS
+#ifdef __cplusplus
+}
+#endif
 #endif				/* _UMAD_CM_H */
diff --git a/libibumad/umad_sa.h b/libibumad/umad_sa.h
index 3f0f877..ba41216 100644
--- a/libibumad/umad_sa.h
+++ b/libibumad/umad_sa.h
@@ -39,14 +39,8 @@
 #include <infiniband/umad_types.h>
 
 #ifdef __cplusplus
-#  define BEGIN_C_DECLS extern "C" {
-#  define END_C_DECLS   }
-#else				/* !__cplusplus */
-#  define BEGIN_C_DECLS
-#  define END_C_DECLS
-#endif				/* __cplusplus */
-
-BEGIN_C_DECLS
+extern "C" {
+#endif
 
 /* SA specific methods */
 enum {
@@ -144,5 +138,7 @@ struct umad_sa_packet {
 	uint8_t 		data[UMAD_LEN_SA_DATA]; /* network-byte order */
 };
 
-END_C_DECLS
+#ifdef __cplusplus
+}
+#endif
 #endif				/* _UMAD_SA_H */
diff --git a/libibumad/umad_sm.h b/libibumad/umad_sm.h
index d912608..5a326e5 100644
--- a/libibumad/umad_sm.h
+++ b/libibumad/umad_sm.h
@@ -41,14 +41,8 @@
 #include <infiniband/umad_types.h>
 
 #ifdef __cplusplus
-#  define BEGIN_C_DECLS extern "C" {
-#  define END_C_DECLS   }
-#else				/* !__cplusplus */
-#  define BEGIN_C_DECLS
-#  define END_C_DECLS
-#endif				/* __cplusplus */
-
-BEGIN_C_DECLS
+extern "C" {
+#endif
 
 enum {
 	UMAD_SMP_DIRECTION		= 0x8000,
@@ -124,5 +118,7 @@ struct umad_smp {
 	uint8_t  return_path[UMAD_SMP_MAX_HOPS];
 };
 
-END_C_DECLS
+#ifdef __cplusplus
+}
+#endif
 #endif				/* _UMAD_SM_H */
diff --git a/libibumad/umad_str.h b/libibumad/umad_str.h
index f343942..ddd6867 100644
--- a/libibumad/umad_str.h
+++ b/libibumad/umad_str.h
@@ -37,14 +37,8 @@
 #include <infiniband/umad.h>
 
 #ifdef __cplusplus
-#  define BEGIN_C_DECLS extern "C" {
-#  define END_C_DECLS   }
-#else				/* !__cplusplus */
-#  define BEGIN_C_DECLS
-#  define END_C_DECLS
-#endif				/* __cplusplus */
-
-BEGIN_C_DECLS
+extern "C" {
+#endif
 
 const char * umad_class_str(uint8_t mgmt_class);
 const char * umad_method_str(uint8_t mgmt_class, uint8_t method);
@@ -53,5 +47,7 @@ const char * umad_attribute_str(uint8_t mgmt_class, __be16 attr_id);
 const char * umad_common_mad_status_str(__be16 status);
 const char * umad_sa_mad_status_str(__be16 status);
 
-END_C_DECLS
+#ifdef __cplusplus
+}
+#endif
 #endif /* _UMAD_STR_H */
diff --git a/libibumad/umad_types.h b/libibumad/umad_types.h
index 7d29dd4..bb0d57f 100644
--- a/libibumad/umad_types.h
+++ b/libibumad/umad_types.h
@@ -41,14 +41,8 @@
 #include <infiniband/umad.h>
 
 #ifdef __cplusplus
-#  define BEGIN_C_DECLS extern "C" {
-#  define END_C_DECLS   }
-#else				/* !__cplusplus */
-#  define BEGIN_C_DECLS
-#  define END_C_DECLS
-#endif				/* __cplusplus */
-
-BEGIN_C_DECLS
+extern "C" {
+#endif
 
 #define UMAD_BASE_VERSION		1
 #define UMAD_QKEY			0x80010000
@@ -213,5 +207,7 @@ umad_class_resp_time(struct umad_class_port_info *cpi)
 			 & UMAD_CLASS_RESP_TIME_MASK);
 }
 
-END_C_DECLS
+#ifdef __cplusplus
+}
+#endif
 #endif				/* _UMAD_TYPES_H */
diff --git a/libibverbs/driver.h b/libibverbs/driver.h
index 04071a7..4b1e5dd 100644
--- a/libibverbs/driver.h
+++ b/libibverbs/driver.h
@@ -42,14 +42,6 @@
 #include <config.h>
 #include <stdbool.h>
 
-#ifdef __cplusplus
-#  define BEGIN_C_DECLS extern "C" {
-#  define END_C_DECLS   }
-#else /* !__cplusplus */
-#  define BEGIN_C_DECLS
-#  define END_C_DECLS
-#endif /* __cplusplus */
-
 struct verbs_device;
 
 enum verbs_xrcd_mask {
diff --git a/libibverbs/marshall.h b/libibverbs/marshall.h
index 1dab111..c5ba62c 100644
--- a/libibverbs/marshall.h
+++ b/libibverbs/marshall.h
@@ -39,14 +39,8 @@
 #include <rdma/ib_user_sa.h>
 
 #ifdef __cplusplus
-#  define BEGIN_C_DECLS extern "C" {
-#  define END_C_DECLS   }
-#else /* !__cplusplus */
-#  define BEGIN_C_DECLS
-#  define END_C_DECLS
-#endif /* __cplusplus */
-
-BEGIN_C_DECLS
+extern "C" {
+#endif
 
 void ibv_copy_qp_attr_from_kern(struct ibv_qp_attr *dst,
 				struct ibv_kern_qp_attr *src);
@@ -60,6 +54,8 @@ void ibv_copy_path_rec_from_kern(struct ibv_sa_path_rec *dst,
 void ibv_copy_path_rec_to_kern(struct ib_user_path_rec *dst,
 			       struct ibv_sa_path_rec *src);
 
-END_C_DECLS
+#ifdef __cplusplus
+}
+#endif
 
 #endif /* INFINIBAND_MARSHALL_H */
diff --git a/libibverbs/tm_types.h b/libibverbs/tm_types.h
index 9a50d45..f1b302a 100644
--- a/libibverbs/tm_types.h
+++ b/libibverbs/tm_types.h
@@ -37,14 +37,8 @@
 #include <stdint.h>
 
 #ifdef __cplusplus
-#  define BEGIN_C_DECLS extern "C" {
-#  define END_C_DECLS   }
-#else				/* !__cplusplus */
-#  define BEGIN_C_DECLS
-#  define END_C_DECLS
-#endif				/* __cplusplus */
-
-BEGIN_C_DECLS
+extern "C" {
+#endif
 
 enum ibv_tmh_op {
 	IBV_TMH_NO_TAG	      = 0,
@@ -66,5 +60,7 @@ struct ibv_rvh {
 	__be32		len;
 };
 
-END_C_DECLS
+#ifdef __cplusplus
+}
+#endif
 #endif				/* _TM_TYPES_H */
diff --git a/libibverbs/verbs.h b/libibverbs/verbs.h
index b39dc30..ce18b50 100644
--- a/libibverbs/verbs.h
+++ b/libibverbs/verbs.h
@@ -48,21 +48,16 @@
 #include <limits>
 #endif
 
-#ifdef __cplusplus
-#  define BEGIN_C_DECLS extern "C" {
-#  define END_C_DECLS   }
-#else /* !__cplusplus */
-#  define BEGIN_C_DECLS
-#  define END_C_DECLS
-#endif /* __cplusplus */
-
 #if __GNUC__ >= 3
 #  define __attribute_const __attribute__((const))
 #else
 #  define __attribute_const
 #endif
 
-BEGIN_C_DECLS
+#ifdef __cplusplus
+extern "C" {
+#endif
+
 
 union ibv_gid {
 	uint8_t			raw[16];
@@ -2535,7 +2530,9 @@ static inline int ibv_is_qpt_supported(uint32_t caps, enum ibv_qp_type qpt)
 	return !!(caps & (1 << qpt));
 }
 
-END_C_DECLS
+#ifdef __cplusplus
+}
+#endif
 
 #  undef __attribute_const
 
-- 
2.8.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
