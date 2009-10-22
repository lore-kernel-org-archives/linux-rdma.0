From: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] opensm/osm_ucast_updn.c: cosmetics - rename function
Date: Thu, 22 Oct 2009 17:33:03 +0200
Message-ID: <4AE07B2F.8030004@dev.mellanox.co.il>
Reply-To: kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Sasha,

There's a static function in the up/down routing, called
"updn_clear_root_hops". This function is supposed to clear
the hops to all targets but root switches.
So the more correct name for this function would be
"updn_clear_non_root_hops".

Signed-off-by: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
---
 opensm/opensm/osm_ucast_updn.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/opensm/opensm/osm_ucast_updn.c b/opensm/opensm/osm_ucast_updn.c
index e81a299..e567a46 100644
--- a/opensm/opensm/osm_ucast_updn.c
+++ b/opensm/opensm/osm_ucast_updn.c
@@ -286,7 +286,7 @@ static int updn_subn_rank(IN updn_t * p_updn)
 /**********************************************************************
  **********************************************************************/
 /* hack: preserve min hops entries to any other root switches */
-static void updn_clear_root_hops(updn_t * p_updn, osm_switch_t * p_sw)
+static void updn_clear_non_root_hops(updn_t * p_updn, osm_switch_t * p_sw)
 {
 	osm_port_t *p_port;
 	unsigned i;
@@ -325,7 +325,7 @@ static int updn_set_min_hop_table(IN updn_t * p_updn)
 		p_sw = (osm_switch_t *)item;
 		/* Clear Min Hop Table */
 		if (p_subn->opt.connect_roots)
-			updn_clear_root_hops(p_updn, p_sw);
+			updn_clear_non_root_hops(p_updn, p_sw);
 		else
 			osm_switch_clear_hops(p_sw);
 	}
-- 
1.5.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
