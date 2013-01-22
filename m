From: Jens Domke <domke.j.aa@m.titech.ac.jp>
Subject: [PATCH 04/10] opensm/osm_ucast_dfsssp.c : fix dereference before null check
Date: Wed, 23 Jan 2013 01:40:07 +0900
Message-ID: <1358872807-16942-1-git-send-email-domke.j.aa@m.titech.ac.jp>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Torsten Hoefler <htor-gy3b+zu4XSAfv37vnLkPlQ@public.gmane.org>, Dan Ben Yosef <danby-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Jens Domke <domke.j.aa@m.titech.ac.jp>
List-Id: linux-rdma@vger.kernel.org

From: Dan Ben Yosef <danby-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>

Dereferencing "dfsssp_ctx" before a null check.

Signed-off-by: Dan Ben Yosef <danby-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Signed-off-by: Jens Domke <domke.j.aa@m.titech.ac.jp>
---
 opensm/osm_ucast_dfsssp.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/opensm/osm_ucast_dfsssp.c b/opensm/osm_ucast_dfsssp.c
index af1b062..f88382b 100644
--- a/opensm/osm_ucast_dfsssp.c
+++ b/opensm/osm_ucast_dfsssp.c
@@ -2069,14 +2069,16 @@ static uint8_t get_dfsssp_sl(void *context, uint8_t hint_for_default_sl,
 			     const ib_net16_t slid, const ib_net16_t dlid)
 {
 	dfsssp_context_t *dfsssp_ctx = (dfsssp_context_t *) context;
-	osm_ucast_mgr_t *p_mgr = (osm_ucast_mgr_t *) dfsssp_ctx->p_mgr;
 	osm_port_t *src_port, *dest_port;
 	vltable_t *srcdest2vl_table = NULL;
+	osm_ucast_mgr_t *p_mgr = NULL;
 	int32_t res = 0;
 
 	if (dfsssp_ctx
-	    && dfsssp_ctx->routing_type == OSM_ROUTING_ENGINE_TYPE_DFSSSP)
+	    && dfsssp_ctx->routing_type == OSM_ROUTING_ENGINE_TYPE_DFSSSP) {
+		p_mgr = (osm_ucast_mgr_t *) dfsssp_ctx->p_mgr;
 		srcdest2vl_table = (vltable_t *) (dfsssp_ctx->srcdest2vl_table);
+	}
 	else
 		return hint_for_default_sl;
 
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
