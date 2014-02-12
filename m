From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH opensm] osm_ucast_mgr.c: Use LFT block of all port 0s to indicate
 resend
Date: Wed, 12 Feb 2014 14:20:17 -0500
Message-ID: <52FBC971.3090203@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


In set_lft_block, use LFT block set to port 0 rather than invalid port
as a better way to detect that resending the LFT block is needed.

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
--
diff --git a/opensm/osm_ucast_mgr.c b/opensm/osm_ucast_mgr.c
index c8a7360..2329ea6 100644
--- a/opensm/osm_ucast_mgr.c
+++ b/opensm/osm_ucast_mgr.c
@@ -1006,7 +1006,7 @@ static int set_lft_block(IN osm_switch_t *p_sw, IN osm_ucast_mgr_t *p_mgr,
 	 * Zero the stored LFT block, so in case the MAD will end up
 	 * with error, we will resend it in the next sweep.
 	 */
-	memset(p_sw->lft + block_id_ho * IB_SMP_DATA_SIZE, OSM_NO_PATH,
+	memset(p_sw->lft + block_id_ho * IB_SMP_DATA_SIZE, 0,
 	       IB_SMP_DATA_SIZE);
 
 	OSM_LOG(p_mgr->p_log, OSM_LOG_DEBUG,
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
