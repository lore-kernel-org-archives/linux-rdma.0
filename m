From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] complib/fleximap: make compar callback to return int
Date: Thu, 12 Nov 2009 22:22:57 +0200
Message-ID: <20091112202257.GR7192@me>
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
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Smith, Stan" <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


To be consistent with another similar comparator functions (used in
qsort, scandir, etc.) make fleximap comparator function to return 'int'
instead of 'long'.

Signed-off-by: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
---
 opensm/complib/cl_map.c              |    8 ++++----
 opensm/include/complib/cl_fleximap.h |    2 +-
 opensm/opensm/osm_subnet.c           |    2 +-
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/opensm/complib/cl_map.c b/opensm/complib/cl_map.c
index b49b4b8..d851bf8 100644
--- a/opensm/complib/cl_map.c
+++ b/opensm/complib/cl_map.c
@@ -1148,7 +1148,7 @@ cl_fmap_item_t *cl_fmap_get(IN const cl_fmap_t * const p_map,
 			    IN const void *const p_key)
 {
 	cl_fmap_item_t *p_item;
-	intn_t cmp;
+	int cmp;
 
 	CL_ASSERT(p_map);
 	CL_ASSERT(p_map->state == CL_INITIALIZED);
@@ -1175,7 +1175,7 @@ cl_fmap_item_t *cl_fmap_get_next(IN const cl_fmap_t * const p_map,
 {
 	cl_fmap_item_t *p_item;
 	cl_fmap_item_t *p_item_found;
-	intn_t cmp;
+	int cmp;
 
 	CL_ASSERT(p_map);
 	CL_ASSERT(p_map->state == CL_INITIALIZED);
@@ -1273,7 +1273,7 @@ cl_fmap_item_t *cl_fmap_insert(IN cl_fmap_t * const p_map,
 			       IN cl_fmap_item_t * const p_item)
 {
 	cl_fmap_item_t *p_insert_at, *p_comp_item;
-	intn_t cmp = 0;
+	int cmp = 0;
 
 	CL_ASSERT(p_map);
 	CL_ASSERT(p_map->state == CL_INITIALIZED);
@@ -1575,7 +1575,7 @@ void cl_fmap_delta(IN OUT cl_fmap_t * const p_map1,
 		   OUT cl_fmap_t * const p_new, OUT cl_fmap_t * const p_old)
 {
 	cl_fmap_item_t *p_item1, *p_item2;
-	intn_t cmp;
+	int cmp;
 
 	CL_ASSERT(p_map1);
 	CL_ASSERT(p_map2);
diff --git a/opensm/include/complib/cl_fleximap.h b/opensm/include/complib/cl_fleximap.h
index 0af8766..ec008cf 100644
--- a/opensm/include/complib/cl_fleximap.h
+++ b/opensm/include/complib/cl_fleximap.h
@@ -181,7 +181,7 @@ typedef struct _cl_fmap_item {
 *
 * SYNOPSIS
 */
-typedef intn_t
+typedef int
     (*cl_pfn_fmap_cmp_t) (IN const void *const p_key1,
 			  IN const void *const p_key2);
 /*
diff --git a/opensm/opensm/osm_subnet.c b/opensm/opensm/osm_subnet.c
index cac5e94..dd72a3a 100644
--- a/opensm/opensm/osm_subnet.c
+++ b/opensm/opensm/osm_subnet.c
@@ -397,7 +397,7 @@ static const opt_rec_t opt_tbl[] = {
 	{0}
 };
 
-static long compar_mgids(const void *m1, const void *m2)
+static int compar_mgids(const void *m1, const void *m2)
 {
 	return memcmp(m1, m2, sizeof(ib_gid_t));
 }
-- 
1.6.5.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
