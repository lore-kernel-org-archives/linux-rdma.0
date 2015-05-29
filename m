From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH opensm] osm_mcast_tbl.c: Wrong assert placement in osm_mcast_tbl_get_block
Date: Fri, 29 May 2015 08:47:52 -0400
Message-ID: <55685FF8.8000306@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Ilya Nelkenbaum <ilyan-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "rafiw-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <rafiw-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ilya Nelkenbaum <ilyan-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Date: Mon, 28 Jan 2013 13:53:38 +0200

Signed-off-by: Ilya Nelkenbaum <ilyan-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/opensm/osm_mcast_tbl.c b/opensm/osm_mcast_tbl.c
index c4a64e2..617fd50 100644
--- a/opensm/osm_mcast_tbl.c
+++ b/opensm/osm_mcast_tbl.c
@@ -242,7 +242,6 @@ boolean_t osm_mcast_tbl_get_block(IN osm_mcast_tbl_t * p_tbl,
 
 	CL_ASSERT(p_tbl);
 	CL_ASSERT(p_block);
-	CL_ASSERT(block_num * IB_MCAST_BLOCK_SIZE <= p_tbl->mft_depth);
 
 	if (block_num > p_tbl->max_block_in_use)
 		return FALSE;
@@ -255,6 +254,8 @@ boolean_t osm_mcast_tbl_get_block(IN osm_mcast_tbl_t * p_tbl,
 		return TRUE;
 	}
 
+	CL_ASSERT(block_num * IB_MCAST_BLOCK_SIZE <= p_tbl->mft_depth);
+
 	mlid_start_ho = (uint16_t) (block_num * IB_MCAST_BLOCK_SIZE);
 
 	for (i = 0; i < IB_MCAST_BLOCK_SIZE; i++)
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
