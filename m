From: Hal Rosenstock <hnrose-Wuw85uim5zDR7s880joybQ@public.gmane.org>
Subject: [PATCH] opensm/osm_sa_lft_record.c: In lftr_rcv_new_lftr, handle
	osm_switch_get_lft_block failure
Date: Wed, 30 Sep 2009 11:43:41 -0400
Message-ID: <20090930154341.GA31709@comcast.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, general-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
diff --git a/opensm/opensm/osm_sa_lft_record.c b/opensm/opensm/osm_sa_lft_record.c
index d092129..828b277 100644
--- a/opensm/opensm/osm_sa_lft_record.c
+++ b/opensm/opensm/osm_sa_lft_record.c
@@ -99,8 +99,12 @@ static ib_api_status_t lftr_rcv_new_lftr(IN osm_sa_t * sa,
 	p_rec_item->rec.block_num = cl_hton16(block);
 
 	/* copy the lft block */
-	osm_switch_get_lft_block(p_sw, block, p_rec_item->rec.lft);
-
+	if (!osm_switch_get_lft_block(p_sw, block, p_rec_item->rec.lft)) {
+		OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 4403: "
+			"osm_switch_get_lft_block failed\n");
+		status = IB_INSUFFICIENT_RESOURCES;
+		goto Exit;
+	}
 	cl_qlist_insert_tail(p_list, &p_rec_item->list_item);
 
 Exit:
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
