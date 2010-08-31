From: Hal Rosenstock <hnrose-Wuw85uim5zDR7s880joybQ@public.gmane.org>
Subject: [PATCH] opensm/include/osm_helper.h: Eliminate some duplicated
	declarations
Date: Tue, 31 Aug 2010 12:08:18 -0400
Message-ID: <20100831160818.GA2557@comcast.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


opensm/include/osm_helper.h: Eliminate some duplicate declarations

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/opensm/include/opensm/osm_helper.h b/opensm/include/opensm/osm_helper.h
index 1a10cde..9abbd61 100644
--- a/opensm/include/opensm/osm_helper.h
+++ b/opensm/include/opensm/osm_helper.h
@@ -1,6 +1,6 @@
 /*
  * Copyright (c) 2004-2009 Voltaire, Inc. All rights reserved.
- * Copyright (c) 2002-2005 Mellanox Technologies LTD. All rights reserved.
+ * Copyright (c) 2002-2010 Mellanox Technologies LTD. All rights reserved.
  * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
  * Copyright (c) 2009 HNR Consulting. All rights reserved.
  *
@@ -493,10 +493,6 @@ const char *osm_get_mtu_str(IN uint8_t mtu);
 
 const char *osm_get_lwa_str(IN uint8_t lwa);
 
-const char *osm_get_mtu_str(IN uint8_t mtu);
-
-const char *osm_get_lwa_str(IN uint8_t lwa);
-
 const char *osm_get_lsa_str(IN uint8_t lsa);
 
 /****f* IBA Base: Types/osm_get_sm_mgr_signal_str
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
