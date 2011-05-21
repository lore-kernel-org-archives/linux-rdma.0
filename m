From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH 14/13] opensm/osm_sa_guidinfo_record.c: Fix locking
Date: Sat, 21 May 2011 10:56:26 -0400
Message-ID: <4DD7D29A.3030206@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Fix locking around set_guidinfo/del_guidinfo

Found and fixed by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/opensm/osm_sa_guidinfo_record.c b/opensm/osm_sa_guidinfo_record.c
index c792943..a1bb166 100644
--- a/opensm/osm_sa_guidinfo_record.c
+++ b/opensm/osm_sa_guidinfo_record.c
@@ -737,10 +737,12 @@ void osm_gir_rcv_process(IN void *ctx, IN void *data)
 		if (!osm_physp_share_pkey(sa->p_log, p_req_physp,
 					  p_port->p_physp))
 			goto Exit;
+		CL_PLOCK_EXCL_ACQUIRE(sa->p_lock);
 		if (p_rcvd_mad->method == IB_MAD_METHOD_SET)
 			set_guidinfo(sa, p_madw, p_port, p_rcvd_rec->block_num);
 		else
 			del_guidinfo(sa, p_madw, p_port, p_rcvd_rec->block_num);
+		CL_PLOCK_RELEASE(sa->p_lock);
 		break;
 	default:
 		OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 5105: "
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
