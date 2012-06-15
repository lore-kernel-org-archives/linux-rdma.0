From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH][TRIVIAL] opensm/osm_port.h: Fix commentary typo
Date: Fri, 15 Jun 2012 06:32:08 -0400
Message-ID: <4FDB0F28.20404@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/include/opensm/osm_port.h b/include/opensm/osm_port.h
index 473b269..56e9c37 100644
--- a/include/opensm/osm_port.h
+++ b/include/opensm/osm_port.h
@@ -245,7 +245,7 @@ void osm_physp_init(IN osm_physp_t * p_physp, IN ib_net64_t port_guid,
 *
 *	h_bind
 *		[in] Bind handle on which this port is accessed.
-*		Caller should use OSM_INVALID_BIND_HANDLE if the bind
+*		Caller should use OSM_BIND_INVALID_HANDLE if the bind
 *		handle to this port is unknown.
 *
 *	hop_count
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
