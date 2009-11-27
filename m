From: Line Holen <Line.Holen-UdXhSnd/wVw@public.gmane.org>
Subject: [PATCH] opensm/osm_vl15intf.c Log change
Date: Fri, 27 Nov 2009 14:45:40 +0100
Message-ID: <4B0FD804.2020309@Sun.COM>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Added transaction ID to a message

Signed-off-by: Line Holen <Line.Holen-xsfywfwIY+M@public.gmane.org>

---

diff --git a/opensm/opensm/osm_vl15intf.c b/opensm/opensm/osm_vl15intf.c
index c380a55..cc3ff33 100644
--- a/opensm/opensm/osm_vl15intf.c
+++ b/opensm/opensm/osm_vl15intf.c
@@ -1,4 +1,5 @@
 /*
+ * Copyright (c) 2009 Sun Microsystems, Inc. All rights reserved.
  * Copyright (c) 2004-2009 Voltaire, Inc. All rights reserved.
  * Copyright (c) 2002-2006 Mellanox Technologies LTD. All rights reserved.
  * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
@@ -91,7 +92,8 @@ static void vl15_send_mad(osm_vl15_t * p_vl, osm_madw_t * p_madw)
 	}
 
 	OSM_LOG(p_vl->p_log, OSM_LOG_ERROR, "ERR 3E03: "
-		"MAD send failed (%s)\n", ib_get_err_str(status));
+		"MAD send failed (%s), TID 0x%" PRIx64 "\n",
+		ib_get_err_str(status), cl_ntoh64(p_madw->p_mad->trans_id));
 
 	/*
 	   The MAD was never successfully sent, so
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
