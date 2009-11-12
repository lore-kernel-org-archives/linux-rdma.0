From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] opensm: cleanup intn_t uses
Date: Thu, 12 Nov 2009 22:21:37 +0200
Message-ID: <20091112202137.GQ7192@me>
References: <3F6F638B8D880340AB536D29CD4C1E1912C86E8A8F@orsmsx501.amr.corp.intel.com>
 <20091004001316.GK17846@me>
 <A6E929B3F38F455EB28EB478FBAF290E@amr.corp.intel.com>
 <20091112191811.GO7192@me>
 <81D21ED9D6F34BC1B7DA64F50EE5A7DD@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <81D21ED9D6F34BC1B7DA64F50EE5A7DD-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Smith, Stan" <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


In all cases where non standard (defined in complib) intn_t and uintn_t
types were used pointer boundary was not required. So clean it up -
replace by int and unsigned int types.

Signed-off-by: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
---
 opensm/include/opensm/osm_mcast_tbl.h   |    2 +-
 opensm/libvendor/osm_vendor_al.c        |    4 ++--
 opensm/libvendor/osm_vendor_ibumad_sa.c |    6 +++---
 opensm/libvendor/osm_vendor_mlx_sa.c    |    6 +++---
 opensm/opensm/osm_mcast_tbl.c           |   14 +++++---------
 opensm/opensm/osm_sa_multipath_record.c |    5 ++---
 opensm/opensm/osm_sa_path_record.c      |    6 ++----
 7 files changed, 18 insertions(+), 25 deletions(-)

diff --git a/opensm/include/opensm/osm_mcast_tbl.h b/opensm/include/opensm/osm_mcast_tbl.h
index 0745b5b..37e2c26 100644
--- a/opensm/include/opensm/osm_mcast_tbl.h
+++ b/opensm/include/opensm/osm_mcast_tbl.h
@@ -174,7 +174,7 @@ void osm_mcast_tbl_delete(IN osm_mcast_tbl_t ** pp_tbl);
 *
 * SYNOPSIS
 */
-int osm_mcast_tbl_realloc(IN osm_mcast_tbl_t * p_tbl, IN uintn_t mlid_offset);
+int osm_mcast_tbl_realloc(IN osm_mcast_tbl_t * p_tbl, IN unsigned mlid_offset);
 /*
 * PARAMETERS
 *
diff --git a/opensm/libvendor/osm_vendor_al.c b/opensm/libvendor/osm_vendor_al.c
index abf3395..3ac05c9 100644
--- a/opensm/libvendor/osm_vendor_al.c
+++ b/opensm/libvendor/osm_vendor_al.c
@@ -489,7 +489,7 @@ Exit:
 static ib_api_status_t
 __osm_vendor_get_ca_guids(IN osm_vendor_t * const p_vend,
 			  IN ib_net64_t ** const p_guids,
-			  IN uintn_t * const p_num_guids)
+			  IN unsigned * const p_num_guids)
 {
 	ib_api_status_t status;
 
@@ -581,7 +581,7 @@ osm_vendor_get_all_port_attr(IN osm_vendor_t * const p_vend,
 	ib_api_status_t status;
 
 	uint32_t ca;
-	uintn_t ca_count;
+	unsigned ca_count;
 	uint32_t port_count = 0;
 	uint8_t port_num;
 	uint32_t total_ports = 0;
diff --git a/opensm/libvendor/osm_vendor_ibumad_sa.c b/opensm/libvendor/osm_vendor_ibumad_sa.c
index 1a7d5a2..e05a5ef 100644
--- a/opensm/libvendor/osm_vendor_ibumad_sa.c
+++ b/opensm/libvendor/osm_vendor_ibumad_sa.c
@@ -129,9 +129,9 @@ __osmv_sa_mad_rcv_cb(IN osm_madw_t * p_madw,
 			if (ib_get_attr_size(p_sa_mad->attr_offset)) {
 				/* we used the offset value to calculate the
 				   number of records in here */
-				query_res.result_cnt = (uintn_t)
-				    ((p_madw->mad_size - IB_SA_MAD_HDR_SIZE) /
-				     ib_get_attr_size(p_sa_mad->attr_offset));
+				query_res.result_cnt =
+				    (p_madw->mad_size - IB_SA_MAD_HDR_SIZE) /
+				    ib_get_attr_size(p_sa_mad->attr_offset);
 				OSM_LOG(p_bind->p_log, OSM_LOG_DEBUG,
 					"Count = %u = %zu / %u (%zu)\n",
 					query_res.result_cnt,
diff --git a/opensm/libvendor/osm_vendor_mlx_sa.c b/opensm/libvendor/osm_vendor_mlx_sa.c
index 0a4e050..e47f072 100644
--- a/opensm/libvendor/osm_vendor_mlx_sa.c
+++ b/opensm/libvendor/osm_vendor_mlx_sa.c
@@ -141,9 +141,9 @@ __osmv_sa_mad_rcv_cb(IN osm_madw_t * p_madw,
 					"__osmv_sa_mad_rcv_cb: Count = 0\n");
 			}
 			else {
-				query_res.result_cnt = (uintn_t)
-					((p_madw->mad_size - IB_SA_MAD_HDR_SIZE) /
-					 ib_get_attr_size(p_sa_mad->attr_offset));
+				query_res.result_cnt =
+					(p_madw->mad_size - IB_SA_MAD_HDR_SIZE) /
+					ib_get_attr_size(p_sa_mad->attr_offset);
 				osm_log(p_bind->p_log, OSM_LOG_DEBUG,
 					"__osmv_sa_mad_rcv_cb: "
 					"Count = %u = %zu / %u (%zu)\n",
diff --git a/opensm/opensm/osm_mcast_tbl.c b/opensm/opensm/osm_mcast_tbl.c
index 14f8e7a..ee59275 100644
--- a/opensm/opensm/osm_mcast_tbl.c
+++ b/opensm/opensm/osm_mcast_tbl.c
@@ -88,9 +88,7 @@ void osm_mcast_tbl_destroy(IN osm_mcast_tbl_t * p_tbl)
 void osm_mcast_tbl_set(IN osm_mcast_tbl_t * p_tbl, IN uint16_t mlid_ho,
 		       IN uint8_t port)
 {
-	uintn_t mlid_offset;
-	uintn_t mask_offset;
-	uintn_t bit_mask;
+	unsigned mlid_offset, mask_offset, bit_mask;
 	int16_t block_num;
 
 	CL_ASSERT(p_tbl && p_tbl->p_mask_tbl);
@@ -108,7 +106,7 @@ void osm_mcast_tbl_set(IN osm_mcast_tbl_t * p_tbl, IN uint16_t mlid_ho,
 		p_tbl->max_block_in_use = (uint16_t) block_num;
 }
 
-int osm_mcast_tbl_realloc(IN osm_mcast_tbl_t * p_tbl, IN uintn_t mlid_offset)
+int osm_mcast_tbl_realloc(IN osm_mcast_tbl_t * p_tbl, IN unsigned mlid_offset)
 {
 	size_t mft_depth, size;
 	uint16_t (*p_mask_tbl)[][IB_MCAST_POSITION_MAX + 1];
@@ -144,9 +142,7 @@ done:
 boolean_t osm_mcast_tbl_is_port(IN const osm_mcast_tbl_t * p_tbl,
 				IN uint16_t mlid_ho, IN uint8_t port_num)
 {
-	uintn_t mlid_offset;
-	uintn_t mask_offset;
-	uintn_t bit_mask;
+	unsigned mlid_offset, mask_offset, bit_mask;
 
 	CL_ASSERT(p_tbl);
 
@@ -171,7 +167,7 @@ boolean_t osm_mcast_tbl_is_port(IN const osm_mcast_tbl_t * p_tbl,
 boolean_t osm_mcast_tbl_is_any_port(IN const osm_mcast_tbl_t * p_tbl,
 				    IN uint16_t mlid_ho)
 {
-	uintn_t mlid_offset;
+	unsigned mlid_offset;
 	uint8_t position;
 	uint16_t result = 0;
 
@@ -223,7 +219,7 @@ ib_api_status_t osm_mcast_tbl_set_block(IN osm_mcast_tbl_t * p_tbl,
 
 void osm_mcast_tbl_clear_mlid(IN osm_mcast_tbl_t * p_tbl, IN uint16_t mlid_ho)
 {
-	uintn_t mlid_offset;
+	unsigned mlid_offset;
 
 	CL_ASSERT(p_tbl);
 	CL_ASSERT(mlid_ho >= IB_LID_MCAST_START_HO);
diff --git a/opensm/opensm/osm_sa_multipath_record.c b/opensm/opensm/osm_sa_multipath_record.c
index ca3d967..0658480 100644
--- a/opensm/opensm/osm_sa_multipath_record.c
+++ b/opensm/opensm/osm_sa_multipath_record.c
@@ -872,8 +872,7 @@ static uint32_t mpr_rcv_get_port_pair_paths(IN osm_sa_t * sa,
 	uint16_t dest_lid_ho;
 	uint32_t path_num = 0;
 	uint8_t preference;
-	uintn_t src_offset;
-	uintn_t dest_offset;
+	unsigned src_offset, dest_offset;
 
 	OSM_LOG_ENTER(sa->p_log);
 
@@ -1058,7 +1057,7 @@ static osm_mpr_item_t *mpr_rcv_get_apm_port_pair_paths(IN osm_sa_t * sa,
 	uint16_t dest_lid_max_ho;
 	uint16_t src_lid_ho;
 	uint16_t dest_lid_ho;
-	uintn_t iterations;
+	unsigned iterations;
 	int src_lids, dest_lids;
 
 	OSM_LOG_ENTER(sa->p_log);
diff --git a/opensm/opensm/osm_sa_path_record.c b/opensm/opensm/osm_sa_path_record.c
index 457b40c..62a2a8b 100644
--- a/opensm/opensm/osm_sa_path_record.c
+++ b/opensm/opensm/osm_sa_path_record.c
@@ -898,9 +898,7 @@ static void pr_rcv_get_port_pair_paths(IN osm_sa_t * sa,
 	uint16_t dest_lid_ho;
 	uint32_t path_num;
 	uint8_t preference;
-	uintn_t iterations;
-	uintn_t src_offset;
-	uintn_t dest_offset;
+	unsigned iterations, src_offset, dest_offset;
 
 	OSM_LOG_ENTER(sa->p_log);
 
@@ -1015,7 +1013,7 @@ static void pr_rcv_get_port_pair_paths(IN osm_sa_t * sa,
 	else if (comp_mask & IB_PR_COMPMASK_NUMBPATH)
 		iterations = ib_path_rec_num_path(p_pr);
 	else
-		iterations = (uintn_t) (-1);
+		iterations = (unsigned) (-1);
 
 	while (path_num < iterations) {
 		/*
-- 
1.6.5.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
