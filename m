From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCHv3 1/3] libibmad: Add remaining SM GUIDInfo attribute fields
Date: Sat, 26 Mar 2011 14:13:12 +0200
Message-ID: <4D8DD858.3030306@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
Change since v2:
Another config change to try to fix formatting
Change since v1:
Hopefully fix formatting problem after sending

  libibmad/include/infiniband/mad.h |    9 ++++++++-
  libibmad/src/fields.c             |    9 ++++++++-
  2 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/libibmad/include/infiniband/mad.h 
b/libibmad/include/infiniband/mad.h
index 7571a61..02f0dc8 100644
--- a/libibmad/include/infiniband/mad.h
+++ b/libibmad/include/infiniband/mad.h
@@ -1,7 +1,7 @@
  /*
   * Copyright (c) 2004-2009 Voltaire Inc.  All rights reserved.
   * Copyright (c) 2009 HNR Consulting.  All rights reserved.
- * Copyright (c) 2009 Mellanox Technologies LTD.  All rights reserved.
+ * Copyright (c) 2009-2010 Mellanox Technologies LTD.  All rights reserved.
   *
   * This software is available to you under a choice of one of two
   * licenses.  You may choose to be licensed under the terms of the GNU
@@ -580,6 +580,13 @@ enum MAD_FIELDS {
  	 * GUIDInfo fields
  	 */
  	IB_GUID_GUID0_F,
+	IB_GUID_GUID1_F,
+	IB_GUID_GUID2_F,
+	IB_GUID_GUID3_F,
+	IB_GUID_GUID4_F,
+	IB_GUID_GUID5_F,
+	IB_GUID_GUID6_F,
+	IB_GUID_GUID7_F,

  	/*
  	 * ClassPortInfo fields
diff --git a/libibmad/src/fields.c b/libibmad/src/fields.c
index a5a510a..c9897e7 100644
--- a/libibmad/src/fields.c
+++ b/libibmad/src/fields.c
@@ -1,7 +1,7 @@
  /*
   * Copyright (c) 2004-2009 Voltaire Inc.  All rights reserved.
   * Copyright (c) 2009 HNR Consulting.  All rights reserved.
- * Copyright (c) 2009 Mellanox Technologies LTD.  All rights reserved.
+ * Copyright (c) 2009-2010 Mellanox Technologies LTD.  All rights reserved.
   *
   * This software is available to you under a choice of one of two
   * licenses.  You may choose to be licensed under the terms of the GNU
@@ -380,6 +380,13 @@ static const ib_field_t ib_mad_f[] = {
  	 * GUIDInfo fields
  	 */
  	{0, 64, "GUID0", mad_dump_hex},
+	{64, 64, "GUID1", mad_dump_hex},
+	{128, 64, "GUID2", mad_dump_hex},
+	{192, 64, "GUID3", mad_dump_hex},
+	{256, 64, "GUID4", mad_dump_hex},
+	{320, 64, "GUID5", mad_dump_hex},
+	{384, 64, "GUID6", mad_dump_hex},
+	{448, 64, "GUID7", mad_dump_hex},

  	/*
  	 * ClassPortInfo fields
-- 
1.5.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
