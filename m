From: Line Holen <line.holen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] osm_mcast_mgr.c Add block number to error message
Date: Fri, 15 Nov 2013 04:53:31 -0800 (PST)
Message-ID: <80393bcc-37d5-4977-b59a-7021c791fd23@default>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Linux-Rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Signed-off-by : Line Holen <line.holen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

---

diff --git a/opensm/osm_mcast_mgr.c b/opensm/osm_mcast_mgr.c
index 7993150..19d7e30 100644
--- a/opensm/osm_mcast_mgr.c
+++ b/opensm/osm_mcast_mgr.c
@@ -397,7 +397,8 @@ static int mcast_mgr_set_mft_block(osm_sm_t * sm, IN osm_switch_t * p_sw,
 				     CL_DISP_MSGID_NONE, &context);
 		if (status != IB_SUCCESS) {
 			OSM_LOG(sm->p_log, OSM_LOG_ERROR, "ERR 0A02: "
-				"Sending multicast fwd. tbl. block to %s failed (%s)\n",
+				"Sending multicast fwd. tbl. block 0x%X to %s "
+				"failed (%s)\n", block_id_ho,
 				p_node->print_desc, ib_get_err_str(status));
 			ret = -1;
 		}
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
