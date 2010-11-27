From: "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [RFC 1/9]drivers:infiniband:hw:mthca Change the copyright info.
Date: Fri, 26 Nov 2010 22:21:11 -0800
Message-ID: <1290838879-11038-2-git-send-email-justinmattock@gmail.com>
References: <1290838879-11038-1-git-send-email-justinmattock@gmail.com>
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1290838879-11038-1-git-send-email-justinmattock@gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: trivial@kernel.org
Cc: linux-rdma@vger.kernel.org, linux-ide@vger.kernel.org, linux-mtd@lists.infradead.org, linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org, "Justin P. Mattock" <justinmattock@gmail.com>
List-Id: linux-rdma@vger.kernel.org

Change the copyright info from Sun Microsystems to Oracle since Oracle now owns them.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/infiniband/hw/amso1100/c2_cq.c       |    2 +-
 drivers/infiniband/hw/mthca/mthca_av.c       |    2 +-
 drivers/infiniband/hw/mthca/mthca_cq.c       |    2 +-
 drivers/infiniband/hw/mthca/mthca_dev.h      |    2 +-
 drivers/infiniband/hw/mthca/mthca_doorbell.h |    2 +-
 drivers/infiniband/hw/mthca/mthca_main.c     |    2 +-
 drivers/infiniband/hw/mthca/mthca_provider.c |    2 +-
 7 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/hw/amso1100/c2_cq.c b/drivers/infiniband/hw/amso1100/c2_cq.c
index 49e0e85..2235d43 100644
--- a/drivers/infiniband/hw/amso1100/c2_cq.c
+++ b/drivers/infiniband/hw/amso1100/c2_cq.c
@@ -1,6 +1,6 @@
 /*
  * Copyright (c) 2004, 2005 Topspin Communications.  All rights reserved.
- * Copyright (c) 2005 Sun Microsystems, Inc. All rights reserved.
+ * Copyright (c) 2005 Oracle and/or its affiliates. All rights reserved.
  * Copyright (c) 2005 Cisco Systems, Inc. All rights reserved.
  * Copyright (c) 2005 Mellanox Technologies. All rights reserved.
  * Copyright (c) 2004 Voltaire, Inc. All rights reserved.
diff --git a/drivers/infiniband/hw/mthca/mthca_av.c b/drivers/infiniband/hw/mthca/mthca_av.c
index 32f6c63..e882071 100644
--- a/drivers/infiniband/hw/mthca/mthca_av.c
+++ b/drivers/infiniband/hw/mthca/mthca_av.c
@@ -1,6 +1,6 @@
 /*
  * Copyright (c) 2004 Topspin Communications.  All rights reserved.
- * Copyright (c) 2005 Sun Microsystems, Inc. All rights reserved.
+ * Copyright (c) 2005 Oracle and/or its affiliates. All rights reserved.
  *
  * This software is available to you under a choice of one of two
  * licenses.  You may choose to be licensed under the terms of the GNU
diff --git a/drivers/infiniband/hw/mthca/mthca_cq.c b/drivers/infiniband/hw/mthca/mthca_cq.c
index 18ee3fa..3a68bdc 100644
--- a/drivers/infiniband/hw/mthca/mthca_cq.c
+++ b/drivers/infiniband/hw/mthca/mthca_cq.c
@@ -1,6 +1,6 @@
 /*
  * Copyright (c) 2004, 2005 Topspin Communications.  All rights reserved.
- * Copyright (c) 2005 Sun Microsystems, Inc. All rights reserved.
+ * Copyright (c) 2005 Oracle and/or its affiliates. All rights reserved.
  * Copyright (c) 2005, 2006 Cisco Systems, Inc. All rights reserved.
  * Copyright (c) 2005 Mellanox Technologies. All rights reserved.
  * Copyright (c) 2004 Voltaire, Inc. All rights reserved.
diff --git a/drivers/infiniband/hw/mthca/mthca_dev.h b/drivers/infiniband/hw/mthca/mthca_dev.h
index 7e6a6d6..2af6812 100644
--- a/drivers/infiniband/hw/mthca/mthca_dev.h
+++ b/drivers/infiniband/hw/mthca/mthca_dev.h
@@ -1,6 +1,6 @@
 /*
  * Copyright (c) 2004, 2005 Topspin Communications.  All rights reserved.
- * Copyright (c) 2005 Sun Microsystems, Inc. All rights reserved.
+ * Copyright (c) 2005 Oracle and/or its affiliates. All rights reserved.
  * Copyright (c) 2005, 2006 Cisco Systems.  All rights reserved.
  * Copyright (c) 2005 Mellanox Technologies. All rights reserved.
  * Copyright (c) 2004 Voltaire, Inc. All rights reserved.
diff --git a/drivers/infiniband/hw/mthca/mthca_doorbell.h b/drivers/infiniband/hw/mthca/mthca_doorbell.h
index 14f51ef..c139265 100644
--- a/drivers/infiniband/hw/mthca/mthca_doorbell.h
+++ b/drivers/infiniband/hw/mthca/mthca_doorbell.h
@@ -1,6 +1,6 @@
 /*
  * Copyright (c) 2004 Topspin Communications.  All rights reserved.
- * Copyright (c) 2005 Sun Microsystems, Inc. All rights reserved.
+ * Copyright (c) 2005 Oracle and/or its affiliates. All rights reserved.
  * Copyright (c) 2005 Mellanox Technologies. All rights reserved.
  *
  * This software is available to you under a choice of one of two
diff --git a/drivers/infiniband/hw/mthca/mthca_main.c b/drivers/infiniband/hw/mthca/mthca_main.c
index 5eee666..7ff36b0 100644
--- a/drivers/infiniband/hw/mthca/mthca_main.c
+++ b/drivers/infiniband/hw/mthca/mthca_main.c
@@ -1,6 +1,6 @@
 /*
  * Copyright (c) 2004, 2005 Topspin Communications.  All rights reserved.
- * Copyright (c) 2005 Sun Microsystems, Inc. All rights reserved.
+ * Copyright (c) 2005 Oracle and/or its affiliates. All rights reserved.
  * Copyright (c) 2005 Mellanox Technologies. All rights reserved.
  *
  * This software is available to you under a choice of one of two
diff --git a/drivers/infiniband/hw/mthca/mthca_provider.c b/drivers/infiniband/hw/mthca/mthca_provider.c
index 1e0b4b6..7fb8b4f 100644
--- a/drivers/infiniband/hw/mthca/mthca_provider.c
+++ b/drivers/infiniband/hw/mthca/mthca_provider.c
@@ -1,6 +1,6 @@
 /*
  * Copyright (c) 2004, 2005 Topspin Communications.  All rights reserved.
- * Copyright (c) 2005 Sun Microsystems, Inc. All rights reserved.
+ * Copyright (c) 2005 Oracle and/or its affiliates. All rights reserved.
  * Copyright (c) 2005, 2006 Cisco Systems.  All rights reserved.
  * Copyright (c) 2005 Mellanox Technologies. All rights reserved.
  * Copyright (c) 2004 Voltaire, Inc. All rights reserved.
-- 
1.7.1

