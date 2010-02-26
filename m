From: Line Holen <Line.Holen-UdXhSnd/wVw@public.gmane.org>
Subject: [PATCH] opensm/osm_pkey.h: Fix typo in comment
Date: Fri, 26 Feb 2010 09:49:39 +0100
Message-ID: <4B878B23.60001@Sun.COM>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Line Holen <Line.Holen-xsfywfwIY+M@public.gmane.org>

---

diff --git a/opensm/include/opensm/osm_pkey.h b/opensm/include/opensm/osm_pkey.h
index e6ec74a..d10479d 100644
--- a/opensm/include/opensm/osm_pkey.h
+++ b/opensm/include/opensm/osm_pkey.h
@@ -1,4 +1,5 @@
 /*
+ * Copyright (c) 2010 Sun Microsystems, Inc. All rights reserved.
  * Copyright (c) 2004-2009 Voltaire, Inc. All rights reserved.
  * Copyright (c) 2002-2005 Mellanox Technologies LTD. All rights reserved.
  * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
@@ -211,9 +212,9 @@ void osm_pkey_tbl_destroy(IN osm_pkey_tbl_t * p_pkey_tbl);
 *
 *********/
 
-/****f* OpenSM: osm_pkey_get_num_blocks
+/****f* OpenSM: osm_pkey_tbl_get_num_blocks
 * NAME
-*  osm_pkey_get_num_blocks
+*  osm_pkey_tbl_get_num_blocks
 *
 * DESCRIPTION
 *  Obtain the number of blocks in IB PKey table

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
