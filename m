From: Line Holen <Line.Holen-UdXhSnd/wVw@public.gmane.org>
Subject: [PATCH] opensm/osm_sa_path_record.c: livelock in pr_rcv_get_path_parms
Date: Mon, 19 Apr 2010 11:15:43 +0200
Message-ID: <4BCC1F3F.5080000@Sun.COM>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

SA path request handling can end up in a livelock in pr_rcv_get_path_parms().
This can happen if a path request is handled while LFT updates to the fabric
are in progress. 
The LFT of the switch data structure is updated as part of the LFT response 
processing. So while the SM is busy pushing the LFT updates, some switches have
up to date LFT info while others are not yet updated and contains the LFT of
the previous routing. For a (short) time interval there is a potential for 
loops in the fabric. The livelock occurs if a path request is received during
this time interval.
Both LFT response handling and path request processing needs the SM lock.
When the livelock occurs the LFT response handling blocks forever waiting for 
the lock to be released.

The suggested fix is simply to introduce a max number of hops that should
be traversed while handling the path request. If this max is reached then
the request will return with NO_RECORD response and release the SM lock.
This way the LFT processing will be able to complete.

Signed-off-by: Line Holen <Line.Holen-xsfywfwIY+M@public.gmane.org>

---

diff --git a/opensm/opensm/osm_sa_path_record.c b/opensm/opensm/osm_sa_path_record.c
index c4c3f86..b399b70 100644
--- a/opensm/opensm/osm_sa_path_record.c
+++ b/opensm/opensm/osm_sa_path_record.c
@@ -4,6 +4,7 @@
  * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
  * Copyright (c) 2008 Xsigo Systems Inc. All rights reserved.
  * Copyright (c) 2009 HNR Consulting. All rights reserved.
+ * Copyright (c) 2010 Sun Microsystems, Inc. All rights reserved.
  *
  * This software is available to you under a choice of one of two
  * licenses.  You may choose to be licensed under the terms of the GNU
@@ -69,6 +70,9 @@
 #include <opensm/osm_prefix_route.h>
 #include <opensm/osm_ucast_lash.h>
 
+
+#define MAX_HOPS 128
+
 typedef struct osm_pr_item {
 	cl_list_item_t list_item;
 	ib_path_rec_t path_rec;
@@ -178,6 +182,7 @@ static ib_api_status_t pr_rcv_get_path_parms(IN osm_sa_t * sa,
 	osm_qos_level_t *p_qos_level = NULL;
 	uint16_t valid_sl_mask = 0xffff;
 	int is_lash;
+	int hops = 0;
 
 	OSM_LOG_ENTER(sa->p_log);
 
@@ -369,6 +374,25 @@ static ib_api_status_t pr_rcv_get_path_parms(IN osm_sa_t * sa,
 				goto Exit;
 			}
 		}
+
+		/* update number of hops traversed */
+		hops++;
+		if (hops > MAX_HOPS) {
+
+			OSM_LOG(sa->p_log, OSM_LOG_ERROR,
+			    "Path from GUID 0x%016" PRIx64 " (%s) to lid %u GUID 0x%016"
+			    PRIx64 " (%s) needs more than %d hops, "
+			    "max %d hops allowed\n",
+			    cl_ntoh64(osm_physp_get_port_guid(p_src_physp)),
+			    p_src_physp->p_node->print_desc,
+			    dest_lid_ho,
+			    cl_ntoh64(osm_physp_get_port_guid(p_dest_physp)),
+			    p_dest_physp->p_node->print_desc,
+			    hops, MAX_HOPS);
+
+			status = IB_NOT_FOUND;
+			goto Exit;
+		}
 	}
 
 	/*
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
