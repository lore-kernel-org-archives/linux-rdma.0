From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] opensm/osm_[lid pkey]_mgr.c: Remove no longer needed memset
Date: Tue, 26 Jul 2011 08:31:13 -0400
Message-ID: <4E2EB391.4090807@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


at the end of PortInfo as PortInfo now takes up the full size of SMP data

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---

diff --git a/opensm/osm_lid_mgr.c b/opensm/osm_lid_mgr.c
index 4d59761..08faff0 100644
--- a/opensm/osm_lid_mgr.c
+++ b/opensm/osm_lid_mgr.c
@@ -838,8 +838,6 @@ static int lid_mgr_set_physp_pi(IN osm_lid_mgr_t * p_mgr,
 	 */
 
 	memcpy(payload, p_old_pi, sizeof(ib_port_info_t));
-	memset(payload + sizeof(ib_port_info_t), 0,
-	       IB_SMP_DATA_SIZE - sizeof(ib_port_info_t));
 
 	/*
 	   Should never write back a value that is bigger then 3 in
diff --git a/opensm/osm_pkey_mgr.c b/opensm/osm_pkey_mgr.c
index e6bf0d1..19e8210 100644
--- a/opensm/osm_pkey_mgr.c
+++ b/opensm/osm_pkey_mgr.c
@@ -203,8 +203,6 @@ pkey_mgr_enforce_partition(IN osm_log_t * p_log, osm_sm_t * sm,
 	}
 
 	memcpy(payload, p_pi, sizeof(ib_port_info_t));
-	memset(payload + sizeof(ib_port_info_t), 0,
-	       IB_SMP_DATA_SIZE - sizeof(ib_port_info_t));
 
 	p_pi = (ib_port_info_t *) payload;
 	if (enforce == TRUE)
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
