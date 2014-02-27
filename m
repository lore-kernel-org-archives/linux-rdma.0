From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH opensm] osm_sw_info_rcv.c: Add check of switch mcast_cap
Date: Thu, 27 Feb 2014 07:21:20 -0500
Message-ID: <530F2DC0.8000204@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Ilya Nelkenbaum <ilyan-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ilya Nelkenbaum <ilyan-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Signed-off-by: Ilya Nelkenbaum <ilyan-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_sw_info_rcv.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/opensm/osm_sw_info_rcv.c b/opensm/osm_sw_info_rcv.c
index 77c5be7..ce747a9 100644
--- a/opensm/osm_sw_info_rcv.c
+++ b/opensm/osm_sw_info_rcv.c
@@ -222,7 +222,8 @@ static void si_rcv_process_new(IN osm_sm_t * sm, IN osm_node_t * p_node,
 	}
 
 	/* set subnet max mlid to the minimum MulticastFDBCap of all switches */
-	if (cl_ntoh16(p_si->mcast_cap) + IB_LID_MCAST_START_HO - 1 <
+	if (p_si->mcast_cap &&
+	    cl_ntoh16(p_si->mcast_cap) + IB_LID_MCAST_START_HO - 1 <
 	    sm->p_subn->max_mcast_lid_ho) {
 		sm->p_subn->max_mcast_lid_ho = cl_ntoh16(p_si->mcast_cap) +
 			IB_LID_MCAST_START_HO - 1;
-- 
1.7.8.2


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
