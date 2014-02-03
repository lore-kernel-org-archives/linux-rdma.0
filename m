From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 4/5] opensm/osm_port_info_rcv.c: Reread pkeys from SP0 if switch rebooted during a sweep
Date: Mon,  3 Feb 2014 13:05:15 +0200
Message-ID: <1391425516-14462-4-git-send-email-alexne@mellanox.com>
References: <1391425516-14462-1-git-send-email-alexne@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1391425516-14462-1-git-send-email-alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

SM may miss switch reboot because of a long sweep. In that case it won't
reread pkey tables from Switch Port 0.

Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_port_info_rcv.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/opensm/osm_port_info_rcv.c b/opensm/osm_port_info_rcv.c
index d813f1a..eb68dbf 100644
--- a/opensm/osm_port_info_rcv.c
+++ b/opensm/osm_port_info_rcv.c
@@ -796,7 +796,8 @@ void osm_pi_rcv_process(IN void *context, IN void *data)
 		/*
 		   Get the tables on the physp.
 		 */
-		if (p_physp->need_update)
+		if (p_physp->need_update || (p_node->sw &&
+					     p_node->sw->need_update))
 			pi_rcv_get_pkey_slvl_vla_tables(sm, p_node, p_physp);
 
 	}
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
