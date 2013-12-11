From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH opensm] osm_mtree.c: Cosmetic change in osm_mtree_destroy
Date: Wed, 11 Dec 2013 13:44:38 -0500
Message-ID: <52A8B296.8010401@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

max_children defined to be less or equal to switch number of ports, so
uint8_t should be enough.

Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_mtree.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/opensm/osm_mtree.c b/opensm/osm_mtree.c
index cb32276..218f557 100644
--- a/opensm/osm_mtree.c
+++ b/opensm/osm_mtree.c
@@ -83,7 +83,7 @@ osm_mtree_node_t *osm_mtree_node_new(IN osm_switch_t * p_sw)
 
 void osm_mtree_destroy(IN osm_mtree_node_t * p_mtn)
 {
-	uint32_t i;
+	uint8_t i;
 
 	if (p_mtn == NULL)
 		return;
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
