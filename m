From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 1/4] opensm/osm_pkey_mgr.c: fix segfault when trying to
 access not allocated block
Date: Thu, 22 Mar 2012 10:36:02 +0200
Message-ID: <20120322083602.GB2613@calypso>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

If the program decides to add a pkey to block 1. It might not allocate memory
for block 0. As a result, when the program searches for a pkey, it might try
access a not allocated block.

Signed-off-by: Daniel Klein <danielk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_pkey_mgr.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/opensm/osm_pkey_mgr.c b/opensm/osm_pkey_mgr.c
index 52c2280..d051026 100644
--- a/opensm/osm_pkey_mgr.c
+++ b/opensm/osm_pkey_mgr.c
@@ -556,6 +556,9 @@ static int new_pkey_exists(osm_pkey_tbs_t * p_pkey_tbl, ib_net16_t pkey)
 	num_blocks = (uint16_t) cl_ptr_vector_get_size(&p_pkey_tbl->new_blocks);
 	for (block_index = 0; block_index < num_blocks; block_index++) {
 		block = osm_pkey_tbl_new_block_get(p_pkey_tbl, block_index);
+		if (!block)
+			continue;
+
 		for (pkey_idx = 0; pkey_idx < IB_NUM_PKEY_ELEMENTS_IN_BLOCK;
 		     pkey_idx++) {
 			if (block->pkey_entry[pkey_idx] == pkey)
-- 
1.7.7.6

-- Alex
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
