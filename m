From: Line Holen <Line.Holen-UdXhSnd/wVw@public.gmane.org>
Subject: [PATCH] opensm/osm_vl_arb_rcv.c: fix double mutex release bug
Date: Wed, 27 Jan 2010 10:45:29 +0100
Message-ID: <4B600B39.9080100@Sun.COM>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The sm lock might be released twice if a response was received
for a non existent node.

Signed-off-by: Line Holen <Line.Holen-xsfywfwIY+M@public.gmane.org>

---

diff --git a/opensm/opensm/osm_vl_arb_rcv.c b/opensm/opensm/osm_vl_arb_rcv.c
index 823a9ca..93d9b1d 100644
--- a/opensm/opensm/osm_vl_arb_rcv.c
+++ b/opensm/opensm/osm_vl_arb_rcv.c
@@ -3,6 +3,7 @@
  * Copyright (c) 2002-2005 Mellanox Technologies LTD. All rights reserved.
  * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
  * Copyright (c) 2010 HNR Consulting. All rights reserved.
+ * Copyright (c) 2010 Sun Microsystems, Inc. All rights reserved.
  *
  * This software is available to you under a choice of one of two
  * licenses.  You may choose to be licensed under the terms of the GNU
@@ -92,7 +93,6 @@ void osm_vla_rcv_process(IN void *context, IN void *data)
 	cl_plock_excl_acquire(sm->p_lock);
 	p_port = osm_get_port_by_guid(sm->p_subn, port_guid);
 	if (!p_port) {
-		cl_plock_release(sm->p_lock);
 		OSM_LOG(sm->p_log, OSM_LOG_ERROR, "ERR 3F06: "
 			"No port object for port with GUID 0x%" PRIx64
 			"\n\t\t\t\tfor parent node GUID 0x%" PRIx64

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
