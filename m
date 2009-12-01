From: Chien Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 9/9] RDMA/nes: Update copyright and branding string
Date: Tue, 1 Dec 2009 16:20:04 -0600
Message-ID: <20091201222004.GA7448@ctung-MOBL>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


Update copyright from Intel-NE, Inc. to Intel Corporation.
Use proper branding string in Kconfig and simplify description.

Signed-off-by: Chien Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/nes/Kconfig       |    9 ++++-----
 drivers/infiniband/hw/nes/nes.c         |    2 +-
 drivers/infiniband/hw/nes/nes.h         |    2 +-
 drivers/infiniband/hw/nes/nes_cm.c      |    2 +-
 drivers/infiniband/hw/nes/nes_cm.h      |    2 +-
 drivers/infiniband/hw/nes/nes_context.h |    2 +-
 drivers/infiniband/hw/nes/nes_hw.c      |    2 +-
 drivers/infiniband/hw/nes/nes_hw.h      |    2 +-
 drivers/infiniband/hw/nes/nes_nic.c     |    2 +-
 drivers/infiniband/hw/nes/nes_user.h    |    2 +-
 drivers/infiniband/hw/nes/nes_utils.c   |    2 +-
 drivers/infiniband/hw/nes/nes_verbs.c   |    2 +-
 drivers/infiniband/hw/nes/nes_verbs.h   |    2 +-
 13 files changed, 16 insertions(+), 17 deletions(-)

diff --git a/drivers/infiniband/hw/nes/Kconfig b/drivers/infiniband/hw/nes/Kconfig
index d449eb6..9f78aa7 100644
--- a/drivers/infiniband/hw/nes/Kconfig
+++ b/drivers/infiniband/hw/nes/Kconfig
@@ -4,14 +4,13 @@ config INFINIBAND_NES
 	select LIBCRC32C
 	select INET_LRO
 	---help---
-	  This is a low-level driver for NetEffect RDMA enabled
-	  Network Interface Cards (RNIC).
+	  This is the RDMA Network Interface Card (RNIC) driver for
+	  NetEffect Ethernet Cluster Server Adapters.
 
 config INFINIBAND_NES_DEBUG
 	bool "Verbose debugging output"
 	depends on INFINIBAND_NES
 	default n
 	---help---
-	  This option causes the NetEffect RNIC driver to produce debug
-	  messages.  Select this if you are developing the driver
-	  or trying to diagnose a problem.
+	  This option enables debug messages from the NetEffect RNIC
+	  driver.  Select this if you diagnosing a problem.
diff --git a/drivers/infiniband/hw/nes/nes.c b/drivers/infiniband/hw/nes/nes.c
index cbde0cf..88d3114 100644
--- a/drivers/infiniband/hw/nes/nes.c
+++ b/drivers/infiniband/hw/nes/nes.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2006 - 2009 Intel-NE, Inc.  All rights reserved.
+ * Copyright (c) 2006 - 2009 Intel Corporation.  All rights reserved.
  * Copyright (c) 2005 Open Grid Computing, Inc. All rights reserved.
  *
  * This software is available to you under a choice of one of two
diff --git a/drivers/infiniband/hw/nes/nes.h b/drivers/infiniband/hw/nes/nes.h
index bcc6abc..9884056 100644
--- a/drivers/infiniband/hw/nes/nes.h
+++ b/drivers/infiniband/hw/nes/nes.h
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2006 - 2009 Intel-NE, Inc.  All rights reserved.
+ * Copyright (c) 2006 - 2009 Intel Corporation.  All rights reserved.
  * Copyright (c) 2005 Open Grid Computing, Inc. All rights reserved.
  *
  * This software is available to you under a choice of one of two
diff --git a/drivers/infiniband/hw/nes/nes_cm.c b/drivers/infiniband/hw/nes/nes_cm.c
index 73473db..dbe5455 100644
--- a/drivers/infiniband/hw/nes/nes_cm.c
+++ b/drivers/infiniband/hw/nes/nes_cm.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2006 - 2009 Intel-NE, Inc.  All rights reserved.
+ * Copyright (c) 2006 - 2009 Intel Corporation.  All rights reserved.
  *
  * This software is available to you under a choice of one of two
  * licenses.  You may choose to be licensed under the terms of the GNU
diff --git a/drivers/infiniband/hw/nes/nes_cm.h b/drivers/infiniband/hw/nes/nes_cm.h
index 90e8e4d..5e4808c 100644
--- a/drivers/infiniband/hw/nes/nes_cm.h
+++ b/drivers/infiniband/hw/nes/nes_cm.h
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2006 - 2009 Intel-NE, Inc.  All rights reserved.
+ * Copyright (c) 2006 - 2009 Intel Corporation.  All rights reserved.
  *
  * This software is available to you under a choice of one of two
  * licenses.  You may choose to be licensed under the terms of the GNU
diff --git a/drivers/infiniband/hw/nes/nes_context.h b/drivers/infiniband/hw/nes/nes_context.h
index 0fb8d81..b4393a1 100644
--- a/drivers/infiniband/hw/nes/nes_context.h
+++ b/drivers/infiniband/hw/nes/nes_context.h
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2006 - 2009 Intel-NE, Inc.  All rights reserved.
+ * Copyright (c) 2006 - 2009 Intel Corporation.  All rights reserved.
  *
  * This software is available to you under a choice of one of two
  * licenses.  You may choose to be licensed under the terms of the GNU
diff --git a/drivers/infiniband/hw/nes/nes_hw.c b/drivers/infiniband/hw/nes/nes_hw.c
index 6f625a9..9fc0273 100644
--- a/drivers/infiniband/hw/nes/nes_hw.c
+++ b/drivers/infiniband/hw/nes/nes_hw.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2006 - 2009 Intel-NE, Inc.  All rights reserved.
+ * Copyright (c) 2006 - 2009 Intel Corporation.  All rights reserved.
  *
  * This software is available to you under a choice of one of two
  * licenses.  You may choose to be licensed under the terms of the GNU
diff --git a/drivers/infiniband/hw/nes/nes_hw.h b/drivers/infiniband/hw/nes/nes_hw.h
index 8a4c738..084be0e 100644
--- a/drivers/infiniband/hw/nes/nes_hw.h
+++ b/drivers/infiniband/hw/nes/nes_hw.h
@@ -1,5 +1,5 @@
 /*
-* Copyright (c) 2006 - 2009 Intel-NE, Inc.  All rights reserved.
+* Copyright (c) 2006 - 2009 Intel Corporation.  All rights reserved.
 *
 * This software is available to you under a choice of one of two
 * licenses.  You may choose to be licensed under the terms of the GNU
diff --git a/drivers/infiniband/hw/nes/nes_nic.c b/drivers/infiniband/hw/nes/nes_nic.c
index e593af3..5a7b554 100644
--- a/drivers/infiniband/hw/nes/nes_nic.c
+++ b/drivers/infiniband/hw/nes/nes_nic.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2006 - 2009 Intel-NE, Inc.  All rights reserved.
+ * Copyright (c) 2006 - 2009 Intel Corporation.  All rights reserved.
  *
  * This software is available to you under a choice of one of two
  * licenses.  You may choose to be licensed under the terms of the GNU
diff --git a/drivers/infiniband/hw/nes/nes_user.h b/drivers/infiniband/hw/nes/nes_user.h
index ce62f3c..71e133a 100644
--- a/drivers/infiniband/hw/nes/nes_user.h
+++ b/drivers/infiniband/hw/nes/nes_user.h
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2006 - 2009 Intel-NE, Inc.  All rights reserved.
+ * Copyright (c) 2006 - 2009 Intel Corporation.  All rights reserved.
  * Copyright (c) 2005 Topspin Communications.  All rights reserved.
  * Copyright (c) 2005 Cisco Systems.  All rights reserved.
  * Copyright (c) 2005 Open Grid Computing, Inc. All rights reserved.
diff --git a/drivers/infiniband/hw/nes/nes_utils.c b/drivers/infiniband/hw/nes/nes_utils.c
index 9687c39..729d525 100644
--- a/drivers/infiniband/hw/nes/nes_utils.c
+++ b/drivers/infiniband/hw/nes/nes_utils.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2006 - 2009 Intel-NE, Inc.  All rights reserved.
+ * Copyright (c) 2006 - 2009 Intel Corporation.  All rights reserved.
  *
  * This software is available to you under a choice of one of two
  * licenses.  You may choose to be licensed under the terms of the GNU
diff --git a/drivers/infiniband/hw/nes/nes_verbs.c b/drivers/infiniband/hw/nes/nes_verbs.c
index e09d3ed..7a77450 100644
--- a/drivers/infiniband/hw/nes/nes_verbs.c
+++ b/drivers/infiniband/hw/nes/nes_verbs.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2006 - 2009 Intel-NE, Inc.  All rights reserved.
+ * Copyright (c) 2006 - 2009 Intel Corporation.  All rights reserved.
  *
  * This software is available to you under a choice of one of two
  * licenses.  You may choose to be licensed under the terms of the GNU
diff --git a/drivers/infiniband/hw/nes/nes_verbs.h b/drivers/infiniband/hw/nes/nes_verbs.h
index 795aa4f..cc7a604 100644
--- a/drivers/infiniband/hw/nes/nes_verbs.h
+++ b/drivers/infiniband/hw/nes/nes_verbs.h
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2006 - 2009 Intel-NE, Inc.  All rights reserved.
+ * Copyright (c) 2006 - 2009 Intel Corporation.  All rights reserved.
  * Copyright (c) 2005 Open Grid Computing, Inc. All rights reserved.
  *
  * This software is available to you under a choice of one of two
-- 
1.6.4.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
