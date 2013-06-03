From: Line Holen <line.holen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] umad_sm.h Add SM trap definitions
Date: Sun, 2 Jun 2013 23:22:05 -0700 (PDT)
Message-ID: <ad212e3b-4b92-4a0e-abf3-0cffffb8e0b8@default>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Line Holen <Line.Holen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

---

diff --git a/include/infiniband/umad_sm.h b/include/infiniband/umad_sm.h
index 0ef3863..297734f 100644
--- a/include/infiniband/umad_sm.h
+++ b/include/infiniband/umad_sm.h
@@ -4,6 +4,7 @@
  * Copyright (c) 2004 Intel Corporation.  All rights reserved.
  * Copyright (c) 2004 Topspin Corporation.  All rights reserved.
  * Copyright (c) 2004 Voltaire Corporation.  All rights reserved.
+ * Copyright (c) 2013 Oracle and/or its affiliates. All rights reserved.
  *
  * This software is available to you under a choice of one of two
  * licenses.  You may choose to be licensed under the terms of the GNU
@@ -77,6 +78,25 @@ enum {
 };
 
 enum {
+	UMAD_SM_GID_IN_SERVICE_TRAP		= 64,
+	UMAD_SM_GID_OUT_OF_SERVICE_TRAP		= 65,
+	UMAD_SM_MGID_CREATED_TRAP		= 66,
+	UMAD_SM_MGID_DESTROYED_TRAP		= 67,
+	UMAD_SM_UNPATH_TRAP			= 68,
+	UMAD_SM_REPATH_TRAP			= 69,
+	UMAD_SM_LINK_STATE_CHANGED_TRAP		= 128,
+	UMAD_SM_LINK_INTEGRITY_THRESHOLD_TRAP	= 129,
+	UMAD_SM_BUFFER_OVERRUN_THRESHOLD_TRAP	= 130,
+	UMAD_SM_WATCHDOG_TIMER_EXPIRED_TRAP	= 131,
+	UMAD_SM_LOCAL_CHANGES_TRAP		= 144,
+	UMAD_SM_SYS_IMG_GUID_CHANGED_TRAP	= 145,
+	UMAD_SM_BAD_MKEY_TRAP			= 256,
+	UMAD_SM_BAD_PKEY_TRAP			= 257,
+	UMAD_SM_BAD_QKEY_TRAP			= 258,
+	UMAD_SM_BAD_SWITCH_PKEY_TRAP		= 259
+};
+
+enum {
 	UMAD_LEN_SMP_DATA		= 64,
 	UMAD_SMP_MAX_HOPS		= 64
 };
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
