From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] opensm/osm_state_mgr.c: Force subn->need_update when coming
 out of STANDBY
Date: Mon, 18 Jun 2012 13:14:28 -0400
Message-ID: <4FDF61F4.5020003@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Daniel Klein <danielk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

When SM comes out of Standby, it might have data saved from the
time it was previously MASTER. Because of that it might not send
LFTs, pkeys and QoS configuration when it becomes MASTER again as
it might see that there is no change in the configuration.
But because we don't know what previous SM really configured, we
must send LFTs, pkeys, and QoS configuration to all switches.

Signed-off-by: Daniel Klein <danielk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/opensm/osm_state_mgr.c b/opensm/osm_state_mgr.c
index 2629fc5..048a88d 100644
--- a/opensm/osm_state_mgr.c
+++ b/opensm/osm_state_mgr.c
@@ -1080,7 +1079,7 @@ static void do_sweep(osm_sm_t * sm)
 	    sm->p_subn->sm_state != IB_SMINFO_STATE_DISCOVERING)
 		return;
 
-	if (sm->p_subn->coming_out_of_standby)
+	if (sm->p_subn->coming_out_of_standby) {
 		/*
 		 * Need to force re-write of sm_base_lid to all ports
 		 * to do that we want all the ports to be considered
@@ -1088,6 +1087,13 @@ static void do_sweep(osm_sm_t * sm)
 		 */
 		state_mgr_clean_known_lids(sm);
 
+		/*
+		 * Need to reconfigure LFTs, PKEYs, and QoS on all switches
+		 * when coming out of STANDBY
+		 */
+		sm->p_subn->need_update = 1;
+	}
+
 	sm->master_sm_found = 0;
 
 	/*

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
