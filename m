From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH 1/8] opensm/include/osm_opensm.h: Fix commentary typo
Date: Wed, 28 Nov 2012 14:02:54 -0500
Message-ID: <50B65FDE.2030500@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jim Schutt <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 include/opensm/osm_opensm.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/opensm/osm_opensm.h b/include/opensm/osm_opensm.h
index 8fe793e..0b6e44f 100644
--- a/include/opensm/osm_opensm.h
+++ b/include/opensm/osm_opensm.h
@@ -165,7 +165,7 @@ struct osm_routing_engine {
 *		     IN uint8_t in_port_num, IN uint8_t out_port_num,
 *		     OUT ib_slvl_table_t *t)
 *		The callback to allow routing engine input for SL2VL maps.
-*		*port is the phyical port for which the SL2VL map is to be
+*		*port is the physical port for which the SL2VL map is to be
 *		updated. For switches, in_port_num/out_port_num identify
 *		which part of the SL2VL map to update.  For router/HCA ports,
 *		in_port_num/out_port_num should be ignored.
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
