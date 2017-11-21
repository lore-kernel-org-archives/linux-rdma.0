From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH rdma-core 3/3] libibumad: Move common enums, defines, and
 helpers to umad_sa.h
Date: Mon, 20 Nov 2017 20:41:25 -0500
Message-ID: <ae74fb52-94ea-7566-2b47-0fb3c4ae7210@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


A number of enums, defines and helpers for SA MCMemberRecord
are identical for SA PathRecord and MultiPathRecord
so move them from umad_sa_mcm.h to umad_sa.h

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 libibumad/tests/umad_sa_mcm_rereg_test.c | 12 ++++++------
 libibumad/umad_sa.h                      | 26 ++++++++++++++++++++++++++
 libibumad/umad_sa_mcm.h                  | 32 --------------------------------
 3 files changed, 32 insertions(+), 38 deletions(-)

diff --git a/libibumad/tests/umad_sa_mcm_rereg_test.c b/libibumad/tests/umad_sa_mcm_rereg_test.c
index 199d436..77209d4 100644
--- a/libibumad/tests/umad_sa_mcm_rereg_test.c
+++ b/libibumad/tests/umad_sa_mcm_rereg_test.c
@@ -120,16 +120,16 @@ static void build_mcm_rec(struct umad_sa_packet *sa, uint8_t method,
 			sa->comp_mask |=
 				htobe64(UMAD_SA_MCM_COMP_MASK_RATE_SEL |
 					UMAD_SA_MCM_COMP_MASK_RATE);
-			mcm->rate = (UMAD_SA_MCM_SELECTOR_EXACTLY <<
-				     UMAD_SA_MCM_SELECTOR_SHIFT) |
-				    (rate & UMAD_SA_MCM_RATE_MTU_PKT_LIFE_MASK);
+			mcm->rate = (UMAD_SA_SELECTOR_EXACTLY <<
+				     UMAD_SA_SELECTOR_SHIFT) |
+				    (rate & UMAD_SA_RATE_MTU_PKT_LIFE_MASK);
 		}
 		if (mtu != 0xff) {
 			sa->comp_mask |= htobe64(UMAD_SA_MCM_COMP_MASK_MTU_SEL |
 						 UMAD_SA_MCM_COMP_MASK_MTU);
-			mcm->mtu = (UMAD_SA_MCM_SELECTOR_EXACTLY <<
-				    UMAD_SA_MCM_SELECTOR_SHIFT) |
-				   (mtu & UMAD_SA_MCM_RATE_MTU_PKT_LIFE_MASK);
+			mcm->mtu = (UMAD_SA_SELECTOR_EXACTLY <<
+				    UMAD_SA_SELECTOR_SHIFT) |
+				   (mtu & UMAD_SA_RATE_MTU_PKT_LIFE_MASK);
 		}
 		if (sl != 0xff) {
 			sa->comp_mask |= htobe64(UMAD_SA_MCM_COMP_MASK_SL);
diff --git a/libibumad/umad_sa.h b/libibumad/umad_sa.h
index 3f0f877..2598741 100644
--- a/libibumad/umad_sa.h
+++ b/libibumad/umad_sa.h
@@ -132,6 +132,20 @@ enum {
 };
 
 /*
+ * Shared by SA MCMemberRecord, PathRecord, and MultiPathRecord
+ */
+enum {
+	UMAD_SA_SELECTOR_GREATER_THAN	= 0,
+	UMAD_SA_SELECTOR_LESS_THAN	= 1,
+	UMAD_SA_SELECTOR_EXACTLY	= 2,
+	UMAD_SA_SELECTOR_LARGEST_AVAIL	= 3,	/* rate & MTU */
+	UMAD_SA_SELECTOR_SMALLEST_AVAIL = 3	/* packet lifetime */
+};
+
+#define UMAD_SA_SELECTOR_SHIFT		6
+#define UMAD_SA_RATE_MTU_PKT_LIFE_MASK	0x3f
+
+/*
  *  sm_key is not aligned on an 8-byte boundary, so is defined as a byte array
  */
 struct umad_sa_packet {
@@ -144,5 +158,17 @@ struct umad_sa_packet {
 	uint8_t 		data[UMAD_LEN_SA_DATA]; /* network-byte order */
 };
 
+static inline uint8_t
+umad_sa_get_rate_mtu_or_life(uint8_t rate_mtu_or_life)
+{
+	return (rate_mtu_or_life & 0x3f);
+}
+
+static inline uint8_t
+umad_sa_set_rate_mtu_or_life(uint8_t selector, uint8_t rate_mtu_or_life)
+{
+	return (((selector & 0x3) << 6) | (rate_mtu_or_life & 0x3f));
+}
+
 END_C_DECLS
 #endif				/* _UMAD_SA_H */
diff --git a/libibumad/umad_sa_mcm.h b/libibumad/umad_sa_mcm.h
index 4aaaf02..b784b4d 100644
--- a/libibumad/umad_sa_mcm.h
+++ b/libibumad/umad_sa_mcm.h
@@ -62,22 +62,6 @@ enum {
 	UMAD_SA_MCM_COMP_MASK_PROXY_JOIN	= (1ULL << 17)
 };
 
-/*
- * Should this enum be moved to umad_sa.h and MCM_ removed
- * as these are shared by PathRecord and MultiPathRecord ?
- */
-enum {
-	UMAD_SA_MCM_SELECTOR_GREATER_THAN	= 0,
-	UMAD_SA_MCM_SELECTOR_LESS_THAN		= 1,
-	UMAD_SA_MCM_SELECTOR_EXACTLY		= 2,
-	UMAD_SA_MCM_SELECTOR_LARGEST_AVAIL	= 3,	/* rate & MTU */
-	UMAD_SA_MCM_SELECTOR_SMALLEST_AVAIL	= 3	/* packet lifetime */
-};
-
-/* Similarly for the following 2 defines */
-#define UMAD_SA_MCM_SELECTOR_SHIFT		6
-#define UMAD_SA_MCM_RATE_MTU_PKT_LIFE_MASK	0x3f
-
 enum {
 	UMAD_SA_MCM_JOIN_STATE_FULL_MEMBER	= (1 << 0),
 	UMAD_SA_MCM_JOIN_STATE_NON_MEMBER	= (1 << 1),
@@ -171,22 +155,6 @@ umad_sa_mcm_get_proxy_join(struct umad_sa_mcmember_record *p_mc_rec)
 	return ((p_mc_rec->proxy_join & 0x80) == 0x80);
 }
 
-/*
- * Similarly, should the next 2 helpers be moved to umad_sa.h
- * without mcm_ in the function name ?
- */
-static inline uint8_t
-umad_sa_mcm_get_rate_mtu_or_life(uint8_t rate_mtu_or_life)
-{
-	return (rate_mtu_or_life & 0x3f);
-}
-
-static inline uint8_t
-umad_sa_mcm_set_rate_mtu_or_life(uint8_t selector, uint8_t rate_mtu_or_life)
-{
-	return (((selector & 0x3) << 6) | (rate_mtu_or_life & 0x3f));
-}
-
 #ifdef __cplusplus
 }
 #endif
-- 
2.8.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
