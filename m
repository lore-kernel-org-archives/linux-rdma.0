From: Yevgeny Kliteynik <kliteyn-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Subject: [PATCH] opensm/osm_pkey_mgr.c: fixing small memory leak
Date: Tue, 7 Sep 2010 18:15:58 +0300
Message-ID: <4C86572E.5080105@mellanox.co.il>
Reply-To: kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
---
 opensm/opensm/osm_pkey_mgr.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/opensm/opensm/osm_pkey_mgr.c b/opensm/opensm/osm_pkey_mgr.c
index 1e98c82..612130c 100644
--- a/opensm/opensm/osm_pkey_mgr.c
+++ b/opensm/opensm/osm_pkey_mgr.c
@@ -118,6 +118,7 @@ pkey_mgr_process_physical_port(IN osm_log_t * p_log,
 				cl_ntoh16(ib_pkey_get_base(pkey)),
 				cl_ntoh64(osm_node_get_node_guid(p_node)),
 				osm_physp_get_port_num(p_physp));
+			free(p_pending);
 			return;
 		}
 		cl_qlist_insert_head(&p_pkey_tbl->pending,
-- 
1.6.2.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
