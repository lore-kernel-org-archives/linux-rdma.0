From: Hal Rosenstock <hnrose-Wuw85uim5zDR7s880joybQ@public.gmane.org>
Subject: [PATCH] opensm/osm_mcast_mgr.c: In mcast_mgr_set_mft_block, fix
	node GUID in log message
Date: Mon, 5 Oct 2009 09:36:32 -0400
Message-ID: <20091005133632.GA5792@comcast.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


Should come from mft_context rather than lft_context
(even though they are currently the same)

Signed-off-by: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
diff --git a/opensm/opensm/osm_mcast_mgr.c b/opensm/opensm/osm_mcast_mgr.c
index 6f51404..77e0b94 100644
--- a/opensm/opensm/osm_mcast_mgr.c
+++ b/opensm/opensm/osm_mcast_mgr.c
@@ -330,7 +330,7 @@ static int mcast_mgr_set_mft_block(osm_sm_t * sm, IN osm_switch_t * p_sw,
 		OSM_LOG(sm->p_log, OSM_LOG_DEBUG,
 			"Writing MFT block %u position %u to switch 0x%" PRIx64 "\n",
 			block_num, position,
-			cl_ntoh64(context.lft_context.node_guid));
+			cl_ntoh64(context.mft_context.node_guid));
 
 		status = osm_req_set(sm, p_path, (void *)block, sizeof(block),
 				     IB_MAD_ATTR_MCAST_FWD_TBL,
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
