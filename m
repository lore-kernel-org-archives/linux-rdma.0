From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH opensm] libvendor/osm_vendor_ibumad.c: Check the next CA card
 if the error is returned for the current one
Date: Mon, 09 Jun 2014 12:16:55 -0400
Message-ID: <5395DDF7.6040006@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

osm_vendor_open_port should check matching of the input GUID
on all CA cards. When umad_get_ca_portguids returns an error
on the current CA card,next card should be examined.
This change resolves an issue with Win opensm.
Win lower layers are not following libibumad Linux convention/assumption
and are sometimes returning an error
when umad_get_ca_portguids is called from osm_vendor_open_port.

Signed-off-by: Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 libvendor/osm_vendor_ibumad.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/libvendor/osm_vendor_ibumad.c b/libvendor/osm_vendor_ibumad.c
index 69020f2..838923b 100644
--- a/libvendor/osm_vendor_ibumad.c
+++ b/libvendor/osm_vendor_ibumad.c
@@ -727,10 +727,14 @@ osm_vendor_open_port(IN osm_vendor_t * const p_vend,
 	for (ca = 0; ca < p_vend->ca_count; ca++) {
 		if ((r = umad_get_ca_portguids(p_vend->ca_names[ca], portguids,
 					       OSM_UMAD_MAX_PORTS_PER_CA + 1)) < 0) {
+#ifdef __WIN__
+			OSM_LOG(p_vend->p_log, OSM_LOG_VERBOSE,
+#else
 			OSM_LOG(p_vend->p_log, OSM_LOG_ERROR, "ERR 5421: "
+#endif
 				"Unable to get CA %s port guids (%s)\n",
 				p_vend->ca_names[ca], strerror(r));
-			goto Exit;
+			continue;
 		}
 		for (i = 0; i < r; i++)
 			if (port_guid == portguids[i]) {
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
