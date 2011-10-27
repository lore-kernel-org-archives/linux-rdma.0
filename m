From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] opensm/osm_link_mgr.c: Remove no longer needed memset
Date: Thu, 27 Oct 2011 12:55:51 -0400
Message-ID: <4EA98D17.6090006@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Leonid Keller <leonid-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, Stan Smith <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Since PortInfo attribute is now IB_SMP_DATA_SIZE (64 bytes),
there is no remaining space at the end of the attribute as
it now fills the entire SMP data size.

Found-by: Leonid Keller <leonid-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/opensm/osm_link_mgr.c b/opensm/osm_link_mgr.c
index aaefa78..e834d16 100644
--- a/opensm/osm_link_mgr.c
+++ b/opensm/osm_link_mgr.c
@@ -157,8 +157,6 @@ static int link_mgr_set_physp_pi(osm_sm_t * sm, IN osm_physp_t * p_physp,
 	}
 
 	memcpy(payload, p_old_pi, sizeof(ib_port_info_t));
-	memset(payload + sizeof(ib_port_info_t), 0,
-	       IB_SMP_DATA_SIZE - sizeof(ib_port_info_t));
 
 	/*
 	   Should never write back a value that is bigger then 3 in
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
