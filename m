From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH][TRIVIAL] opensm/osm_torus.c: Cosmetic formatting change
Date: Wed, 10 Oct 2012 19:40:05 -0400
Message-ID: <50760755.2090809@dev.mellanox.co.il>
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
 opensm/osm_torus.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/opensm/osm_torus.c b/opensm/osm_torus.c
index 49abef8..ec2c5ef 100644
--- a/opensm/osm_torus.c
+++ b/opensm/osm_torus.c
@@ -8016,7 +8016,7 @@ void torus_update_osm_sl2vl(void *context, osm_physp_t *osm_phys_port,
 				"Error: osm_switch (GUID 0x%04"PRIx64") "
 				"not in our fabric description\n",
 				cl_ntoh64(guid));
-		return;
+			return;
 		}
 	}
 	for (sl = 0; sl < 16; sl++) {
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
