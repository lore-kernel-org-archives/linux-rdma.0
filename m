From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH][TRIVIAL] opensm/osm_madw.h: Fix a couple of cut 'n paste
 commentary errors
Date: Wed, 25 Jul 2012 06:40:46 -0400
Message-ID: <500FCD2E.5020503@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/include/opensm/osm_madw.h b/include/opensm/osm_madw.h
index 8f53d54..195f468 100644
--- a/include/opensm/osm_madw.h
+++ b/include/opensm/osm_madw.h
@@ -988,9 +988,9 @@ static inline osm_vend_wrap_t *osm_madw_get_vend_ptr(IN const osm_madw_t *
 * SEE ALSO
 *********/
 
-/****f* OpenSM: MAD Wrapper/osm_madw_get_vend_ptr
+/****f* OpenSM: MAD Wrapper/osm_madw_get_bind_handle
 * NAME
-*	osm_madw_get_vend_ptr
+*	osm_madw_get_bind_handle
 *
 * DESCRIPTION
 *	Returns the bind handle associated with this MAD.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
