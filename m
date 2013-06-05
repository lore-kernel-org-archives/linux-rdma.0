From: Line Holen <line.holen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] osm_sm_state_mgr.c Don't clear IS_SM bit when changing state
 to NOT_ACTIVE
Date: Wed, 5 Jun 2013 04:14:12 -0700 (PDT)
Message-ID: <89cab6e6-1a00-4def-8f89-cda8ccef67ce@default>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The SM is still operational even though it is in this state. Other
SMs will not know about "our" presence when IS_SM is cleared and will
therefor not attempt to enable "us" again.

Signed-off-by: Line Holen <Line.Holen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

---

diff --git a/opensm/osm_sm_state_mgr.c b/opensm/osm_sm_state_mgr.c
index c996ea2..11defdd 100644
--- a/opensm/osm_sm_state_mgr.c
+++ b/opensm/osm_sm_state_mgr.c
@@ -2,6 +2,7 @@
  * Copyright (c) 2004-2009 Voltaire, Inc. All rights reserved.
  * Copyright (c) 2002-2005 Mellanox Technologies LTD. All rights reserved.
  * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
+ * Copyright (c) 2013 Oracle and/or its affiliates. All rights reserved.
  *
  * This software is available to you under a choice of one of two
  * licenses.  You may choose to be licensed under the terms of the GNU
@@ -330,7 +331,6 @@ ib_api_status_t osm_sm_state_mgr_process(osm_sm_t * sm,
 			 */
 			sm->p_subn->sm_state = IB_SMINFO_STATE_NOTACTIVE;
 			osm_report_sm_state(sm);
-			osm_vendor_set_sm(sm->mad_ctrl.h_bind, FALSE);
 			break;
 		case OSM_SM_SIGNAL_HANDOVER:
 			/*
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
