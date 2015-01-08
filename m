From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH opensm 4/5] osm_ucast_cache.c: Rewrite p_sw->lft allocation
 in osm_ucast_cache_process
Date: Thu, 08 Jan 2015 07:49:59 -0500
Message-ID: <54AE7CF7.5000805@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Daniel Klein <danielk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Daniel Klein <danielk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Performed the following changes in the code that allocates p_sw->lft
buffer in osm_ucast_cache_process:

1. remove allocation of p_sw->new_lft and replace it with assert that
checks that p_sw->is already allocated.
p_sw->new_lft, should already be allocated and defined by either
ucast_cache or the ucast_mgr.

2. replace p_sw->need_update check, with checking if p_sw->lft is not
allocated.
p_sw->need update could indicate the switches LFT are not updated, and
when p_sw->lft is already allocated, it cause memory leak.

Signed-off-by: Daniel Klein <danielk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_ucast_cache.c |    9 ++-------
 1 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/opensm/osm_ucast_cache.c b/opensm/osm_ucast_cache.c
index 2fab643..3caf318 100644
--- a/opensm/osm_ucast_cache.c
+++ b/opensm/osm_ucast_cache.c
@@ -1040,13 +1040,8 @@ int osm_ucast_cache_process(osm_ucast_mgr_t * p_mgr)
 	for (item = cl_qmap_head(tbl); item != cl_qmap_end(tbl);
 	     item = cl_qmap_next(item)) {
 		p_sw = (osm_switch_t *) item;
-
-		if (p_sw->need_update) {
-			if (!p_sw->new_lft)
-				/* no new routing was recently calculated for this
-				   switch, but the LFT needs to be updated anyway */
-				p_sw->new_lft = p_sw->lft;
-
+		CL_ASSERT(p_sw->new_lft);
+		if (!p_sw->lft) {
 			lft_size = (p_sw->max_lid_ho / IB_SMP_DATA_SIZE + 1)
 				   * IB_SMP_DATA_SIZE;
 			p_sw->lft = malloc(lft_size);
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
