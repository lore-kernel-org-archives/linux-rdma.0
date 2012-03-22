From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 3/4] opensm: Fix continous looping when clearing accum_pkeys
 table
Date: Thu, 22 Mar 2012 10:37:42 +0200
Message-ID: <20120322083742.GD2613@calypso>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

p_pkey_tbl->accum_pkeys maximal size is 0x10000 (last used index is 0xFFFF),
so when we itterate over accum_pkeys we should make sure we don't go over the
bounds of uint16_t.

Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_pkey.c     |    5 +++--
 opensm/osm_pkey_mgr.c |    5 +++--
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/opensm/osm_pkey.c b/opensm/osm_pkey.c
index 632d44d..30a5767 100644
--- a/opensm/osm_pkey.c
+++ b/opensm/osm_pkey.c
@@ -205,7 +205,8 @@ void osm_pkey_tbl_clear_accum_pkeys(IN osm_pkey_tbl_t * p_pkey_tbl,
 {
 	void *ptr;
 	uintptr_t pkey_idx_ptr;
-	uint16_t pkey_idx, last_pkey_idx, i;
+	uint16_t pkey_idx, last_pkey_idx;
+	uint32_t i;
 
 	ptr = cl_ptr_vector_get(&p_pkey_tbl->accum_pkeys, pkey);
 	if (ptr == NULL)
@@ -218,7 +219,7 @@ void osm_pkey_tbl_clear_accum_pkeys(IN osm_pkey_tbl_t * p_pkey_tbl,
 
 	if (p_pkey_tbl->last_pkey_idx == pkey_idx) {
 		last_pkey_idx = 0;
-		for (i = 0; i < cl_ptr_vector_get_size(&p_pkey_tbl->accum_pkeys); i++) {
+		for (i = 1; i < cl_ptr_vector_get_size(&p_pkey_tbl->accum_pkeys); i++) {
 			ptr = cl_ptr_vector_get(&p_pkey_tbl->accum_pkeys, i);
 			if (ptr != NULL) {
 				pkey_idx_ptr = (uintptr_t) ptr;
diff --git a/opensm/osm_pkey_mgr.c b/opensm/osm_pkey_mgr.c
index d051026..f7e6eae 100644
--- a/opensm/osm_pkey_mgr.c
+++ b/opensm/osm_pkey_mgr.c
@@ -255,12 +255,13 @@ pkey_mgr_enforce_partition(IN osm_log_t * p_log, osm_sm_t * sm,
 static void clear_accum_pkey_index(osm_pkey_tbl_t * p_pkey_tbl,
                                    uint16_t pkey_index)
 {
-	uint16_t i, pkey_idx_bias, pkey_idx;
+	uint16_t pkey_idx_bias, pkey_idx;
+	uint32_t i;
 	void *ptr;
 	uintptr_t pkey_idx_ptr;
 
 	pkey_idx_bias = pkey_index + 1; // adjust for pkey index bias in accum_pkeys
-	for (i = 0; i < cl_ptr_vector_get_size(&p_pkey_tbl->accum_pkeys); i++) {
+	for (i = 1; i < cl_ptr_vector_get_size(&p_pkey_tbl->accum_pkeys); i++) {
 		ptr = cl_ptr_vector_get(&p_pkey_tbl->accum_pkeys, i);
 		if (ptr != NULL) {
 			pkey_idx_ptr = (uintptr_t) ptr;
-- 
1.7.7.6

-- Alex
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
