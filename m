From: Line Holen <line.holen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] osm_sa_multipath_record.c Use aliasGUIDs when building
 responses
Date: Mon, 13 May 2013 09:30:43 -0700 (PDT)
Message-ID: <3127e9af-32d6-4b07-9468-6c9d950e5c0d@default>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This patch makes multipath responses use the GUIDs supplied in the request
when filling in response packets. Previously it could replace a aliasGUID
with the baseGUID (portGUID) of the port.
This change makes multipath record handling consistent with path record
handling.

Signed-off-by: Line Holen <Line.Holen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

---

diff --git a/opensm/osm_sa_multipath_record.c b/opensm/osm_sa_multipath_record.c
index b4fc30f..bde993c 100644
--- a/opensm/osm_sa_multipath_record.c
+++ b/opensm/osm_sa_multipath_record.c
@@ -2,6 +2,7 @@
  * Copyright (c) 2006-2009 Voltaire, Inc. All rights reserved.
  * Copyright (c) 2002-2011 Mellanox Technologies LTD. All rights reserved.
  * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
+ * Copyright (c) 2013 Oracle and/or its affiliates. All rights reserved.
  *
  * This software is available to you under a choice of one of two
  * licenses.  You may choose to be licensed under the terms of the GNU
@@ -841,10 +842,10 @@ static void mpr_rcv_build_pr(IN osm_sa_t * sa,
 	p_dest_physp = p_dest_alias_guid->p_base_port->p_physp;
 
 	p_pr->dgid.unicast.prefix = osm_physp_get_subnet_prefix(p_dest_physp);
-	p_pr->dgid.unicast.interface_id = osm_physp_get_port_guid(p_dest_physp);
+	p_pr->dgid.unicast.interface_id = p_dest_alias_guid->alias_guid;
 
 	p_pr->sgid.unicast.prefix = osm_physp_get_subnet_prefix(p_src_physp);
-	p_pr->sgid.unicast.interface_id = osm_physp_get_port_guid(p_src_physp);
+	p_pr->sgid.unicast.interface_id = p_src_alias_guid->alias_guid;
 
 	p_pr->dlid = cl_hton16(dest_lid_ho);
 	p_pr->slid = cl_hton16(src_lid_ho);
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
