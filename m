From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] opensm/osm_switch.c: In switch_find_guid_common, handle NULL
 parameter
Date: Thu, 02 Jun 2011 20:40:21 -0400
Message-ID: <4DE82D75.8030506@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Since port->priv can be NULL, struct osm_remote_guids_count * supplied
can be NULL so handle this.

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/opensm/osm_switch.c b/opensm/osm_switch.c
index 9785a9d..fbb8292 100644
--- a/opensm/osm_switch.c
+++ b/opensm/osm_switch.c
@@ -1,6 +1,6 @@
 /*
  * Copyright (c) 2004-2009 Voltaire, Inc. All rights reserved.
- * Copyright (c) 2002-2009 Mellanox Technologies LTD. All rights reserved.
+ * Copyright (c) 2002-2011 Mellanox Technologies LTD. All rights reserved.
  * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
  * Copyright (c) 2009 HNR Consulting. All rights reserved.
  *
@@ -177,6 +177,9 @@ switch_find_guid_common(IN const osm_switch_t * p_sw,
 
 	CL_ASSERT(p_sw);
 
+	if (!r)
+		goto out;
+
 	p_physp = osm_node_get_physp_ptr(p_sw->p_node, port_num);
 	p_rem_physp = osm_physp_get_remote(p_physp);
 	p_rem_node = osm_physp_get_node_ptr(p_rem_physp);
@@ -193,6 +196,7 @@ switch_find_guid_common(IN const osm_switch_t * p_sw,
 		}
 	}
 
+out:
 	return p_remote_guid;
 }
 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
