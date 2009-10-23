From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] opensm: make subnet's max mlid update implementation
 independent
Date: Sat, 24 Oct 2009 00:00:55 +0200
Message-ID: <20091023220055.GG5764@me>
References: <20091016182834.GA26292@comcast.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20091016182834.GA26292-Wuw85uim5zDR7s880joybQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hnrose-Wuw85uim5zDR7s880joybQ@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


Make subnet's max mlid (max_mcast_lid_ho) setup procedure to be
independent from implementation details of switch multicast table
object.

Signed-off-by: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
---
 opensm/opensm/osm_sw_info_rcv.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/opensm/opensm/osm_sw_info_rcv.c b/opensm/opensm/osm_sw_info_rcv.c
index ad75fd4..f32adc5 100644
--- a/opensm/opensm/osm_sw_info_rcv.c
+++ b/opensm/opensm/osm_sw_info_rcv.c
@@ -220,10 +220,10 @@ static void si_rcv_process_new(IN osm_sm_t * sm, IN osm_node_t * p_node,
 	}
 
 	/* set subnet max mlid to the minimum MulticastFDBCap of all switches */
-	if (p_sw->mcast_tbl.num_entries < sm->p_subn->max_mcast_lid_ho -
-					  IB_LID_MCAST_START_HO + 1) {
-		sm->p_subn->max_mcast_lid_ho = p_sw->mcast_tbl.num_entries +
-					       IB_LID_MCAST_START_HO - 1;
+	if (cl_ntoh16(p_si->mcast_cap) + IB_LID_MCAST_START_HO - 1 <
+	    sm->p_subn->max_mcast_lid_ho) {
+		sm->p_subn->max_mcast_lid_ho = cl_ntoh16(p_si->mcast_cap) +
+			IB_LID_MCAST_START_HO - 1;
 		OSM_LOG(sm->p_log, OSM_LOG_VERBOSE,
 			"Subnet max multicast lid is 0x%X\n",
 			sm->p_subn->max_mcast_lid_ho);
-- 
1.6.5.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
