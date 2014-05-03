From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH 3/3 opensm] osm_perfmgr_db.c: Add missing clear of new xmit_wait
 counter in clear_counters
Date: Sat, 03 May 2014 01:40:53 -0400
Message-ID: <53648165.20403@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Susan Coulter (skc-YOWKrPYUwWM@public.gmane.org)" <skc-YOWKrPYUwWM@public.gmane.org>, Florent Parent <florent.parent-hUdP7zcY/u2zFPF/XzyFIQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Found-by: Susan Coulter <skc-YOWKrPYUwWM@public.gmane.org>

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 opensm/osm_perfmgr_db.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/opensm/osm_perfmgr_db.c b/opensm/osm_perfmgr_db.c
index 1b78942..e57b804 100644
--- a/opensm/osm_perfmgr_db.c
+++ b/opensm/osm_perfmgr_db.c
@@ -627,6 +627,7 @@ static void clear_counters(cl_map_item_t * const
p_map_item, void *context)
 		node->ports[i].err_total.link_integrity = 0;
 		node->ports[i].err_total.buffer_overrun = 0;
 		node->ports[i].err_total.vl15_dropped = 0;
+		node->ports[i].err_total.xmit_wait = 0;
 		node->ports[i].err_total.time = ts;

 		node->ports[i].dc_total.xmit_data = 0;
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
