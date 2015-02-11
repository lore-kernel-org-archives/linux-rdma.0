From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH opensm] osm_ucast_mgr.c: Support diverse paths for LMC > 0
 when scatter_ports is enabled
Date: Wed, 11 Feb 2015 07:22:21 -0500
Message-ID: <54DB497D.70600@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Shlomi Nimrodi <shlomin-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

The patch adds an ability to calculate diverse paths for all LIDs
(LMC > 0) derived from the same Base LID,
when scatter ports is enabled (different from 0).
We apply randomization during selection of the outports
only when routing is calculated for the Base LID. For LIDs different
from the Base LID, we don't randomize the outport but apply the procedure
for calculating diverse path as if scatter_ports equals 0.
The patch is relevant for minhop/updn routing.

Signed-off-by: Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Shlomi Nimrodi <shlomin-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_ucast_mgr.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/opensm/osm_ucast_mgr.c b/opensm/osm_ucast_mgr.c
index 0b24e73..219e080 100644
--- a/opensm/osm_ucast_mgr.c
+++ b/opensm/osm_ucast_mgr.c
@@ -260,7 +260,7 @@ static void ucast_mgr_process_port(IN osm_ucast_mgr_t * p_mgr,
 					 p_mgr->p_subn->opt.lmc,
 					 p_mgr->is_dor,
 					 p_mgr->p_subn->opt.port_shifting,
-					 p_port->use_scatter,
+					 !lid_offset && p_port->use_scatter,
 					 OSM_LFT);
 
 	if (port == OSM_NO_PATH) {
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
