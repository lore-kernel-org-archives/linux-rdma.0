From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH] opensm: make osm_get_path_params public
Date: Mon, 25 Feb 2013 08:30:10 -0800
Message-ID: <20130225083010.b8fb512ac9a7a5289ce016c9@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
---
 include/opensm/osm_sa.h          |   21 +++++++++++++++++++++
 opensm/osm_sa_multipath_record.c |   10 ----------
 opensm/osm_sa_path_record.c      |    9 ---------
 3 files changed, 21 insertions(+), 19 deletions(-)

diff --git a/include/opensm/osm_sa.h b/include/opensm/osm_sa.h
index d9016ab..8393412 100644
--- a/include/opensm/osm_sa.h
+++ b/include/opensm/osm_sa.h
@@ -555,5 +555,26 @@ osm_mgrp_t *osm_mcmr_rcv_find_or_create_new_mgrp(IN osm_sa_t * sa,
 *
 *********/
 
+/**
+ * The following expose functionality of osm_sa_path_record.c for internal use
+ * by sub managers
+ */
+typedef struct osm_path_parms {
+	ib_net16_t pkey;
+	uint8_t mtu;
+	uint8_t rate;
+	uint8_t sl;
+	uint8_t pkt_life;
+	boolean_t reversible;
+	int hops;
+} osm_path_parms_t;
+
+ib_api_status_t osm_get_path_params(IN osm_sa_t * sa,
+				    IN const osm_port_t * p_src_port,
+				    IN const uint16_t slid_ho,
+				    IN const osm_port_t * p_dest_port,
+				    IN const uint16_t dlid_ho,
+				    OUT osm_path_parms_t * p_parms);
+
 END_C_DECLS
 #endif				/* _OSM_SA_H_ */
diff --git a/opensm/osm_sa_multipath_record.c b/opensm/osm_sa_multipath_record.c
index 8bb23e3..b4fc30f 100644
--- a/opensm/osm_sa_multipath_record.c
+++ b/opensm/osm_sa_multipath_record.c
@@ -68,16 +68,6 @@
 
 #define SA_MPR_RESP_SIZE SA_ITEM_RESP_SIZE(mpr_rec)
 
-typedef struct osm_path_parms {
-	ib_net16_t pkey;
-	uint8_t mtu;
-	uint8_t rate;
-	uint8_t sl;
-	uint8_t pkt_life;
-	boolean_t reversible;
-	int hops;
-} osm_path_parms_t;
-
 static boolean_t sa_multipath_rec_is_tavor_port(IN const osm_port_t * p_port)
 {
 	osm_node_t const *p_node;
diff --git a/opensm/osm_sa_path_record.c b/opensm/osm_sa_path_record.c
index e6d4e49..c121dba 100644
--- a/opensm/osm_sa_path_record.c
+++ b/opensm/osm_sa_path_record.c
@@ -77,15 +77,6 @@
 
 #define MAX_HOPS 64
 
-typedef struct osm_path_parms {
-	ib_net16_t pkey;
-	uint8_t mtu;
-	uint8_t rate;
-	uint8_t sl;
-	uint8_t pkt_life;
-	boolean_t reversible;
-} osm_path_parms_t;
-
 static inline boolean_t sa_path_rec_is_tavor_port(IN const osm_port_t * p_port)
 {
 	osm_node_t const *p_node;
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
