From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] opensm/vendor: fix portguids array size
Date: Sun, 18 Apr 2010 07:50:20 +0300
Message-ID: <20100418045020.GD11943@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


As discovered and suggested in bug #2001 OpenSM ibumad vendor in
function osm_vendor_open_port() Fix portguids array size passed to
umad_get_ca_portguids().

Signed-off-by: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
---
 opensm/libvendor/osm_vendor_ibumad.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/opensm/libvendor/osm_vendor_ibumad.c b/opensm/libvendor/osm_vendor_ibumad.c
index bcddba4..eac686a 100644
--- a/opensm/libvendor/osm_vendor_ibumad.c
+++ b/opensm/libvendor/osm_vendor_ibumad.c
@@ -637,9 +637,8 @@ osm_vendor_open_port(IN osm_vendor_t * const p_vend,
 	}
 
 	for (ca = 0; ca < p_vend->ca_count; ca++) {
-		if ((r = umad_get_ca_portguids(p_vend->ca_names[ca],
-					       portguids,
-					       OSM_UMAD_MAX_CAS)) < 0) {
+		if ((r = umad_get_ca_portguids(p_vend->ca_names[ca], portguids,
+					       OSM_UMAD_MAX_PORTS_PER_CA + 1)) < 0) {
 			OSM_LOG(p_vend->p_log, OSM_LOG_ERROR, "ERR 5421: "
 				"Unable to get CA %s port guids (%s)\n",
 				p_vend->ca_names[ca], strerror(r));
-- 
1.7.0.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
