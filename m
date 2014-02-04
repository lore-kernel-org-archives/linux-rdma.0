From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH opensm] osm_qos.c: Fix possible seg fault
Date: Tue, 04 Feb 2014 09:56:36 -0500
Message-ID: <52F0FFA4.6000807@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jens Domke <domke.j.aa@m.titech.ac.jp>
List-Id: linux-rdma@vger.kernel.org


From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Pointed-out-by: Jens Domke <domke.j.aa@m.titech.ac.jp>
Introduced by commit 1633550020087f3296dbc2f7b1dd533cd83a6398

If force_update is set, p_tbl isn't initialized

Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_qos.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/opensm/osm_qos.c b/opensm/osm_qos.c
index f55a509..b174f66 100644
--- a/opensm/osm_qos.c
+++ b/opensm/osm_qos.c
@@ -248,8 +248,9 @@ static ib_api_status_t sl2vl_update_table(osm_sm_t * sm, osm_physp_t * p,
 		tbl.raw_vl_by_sl[i] = (vl1 << 4) | vl2;
 	}
 
-	if (!force_update && (p_tbl = osm_physp_get_slvl_tbl(p, in_port)) &&
-	    !memcmp(p_tbl, &tbl, sizeof(tbl)))
+	p_tbl = osm_physp_get_slvl_tbl(p, in_port);
+
+	if (!force_update && !memcmp(p_tbl, &tbl, sizeof(tbl)))
 		return IB_SUCCESS;
 
 	p_mad = osm_qos_mad_create(sm, p, sizeof(tbl), (uint8_t *) & tbl,
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
