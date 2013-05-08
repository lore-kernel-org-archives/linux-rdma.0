From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-3.10 2/3] IB/iser: Add Mellanox copyright
Date: Wed,  8 May 2013 15:05:44 +0300
Message-ID: <1368014745-8086-3-git-send-email-ogerlitz@mellanox.com>
References: <1368014745-8086-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1368014745-8086-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Add Mellanox copyright to the iser initiator source code which I maintain.

Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/iser/iscsi_iser.c     |    1 +
 drivers/infiniband/ulp/iser/iscsi_iser.h     |    1 +
 drivers/infiniband/ulp/iser/iser_initiator.c |    1 +
 drivers/infiniband/ulp/iser/iser_memory.c    |    1 +
 drivers/infiniband/ulp/iser/iser_verbs.c     |    1 +
 5 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
index f19b099..2e84ef8 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.c
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
@@ -5,6 +5,7 @@
  * Copyright (C) 2004 Alex Aizman
  * Copyright (C) 2005 Mike Christie
  * Copyright (c) 2005, 2006 Voltaire, Inc. All rights reserved.
+ * Copyright (c) 2013 Mellanox Technologies. All rights reserved.
  * maintained by openib-general-0P3JtQMG0aQdnm+yROfE0A@public.gmane.org
  *
  * This software is available to you under a choice of one of two
diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.h b/drivers/infiniband/ulp/iser/iscsi_iser.h
index cae6084..e0afab4 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.h
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.h
@@ -8,6 +8,7 @@
  *
  * Copyright (c) 2004, 2005, 2006 Voltaire, Inc. All rights reserved.
  * Copyright (c) 2005, 2006 Cisco Systems.  All rights reserved.
+ * Copyright (c) 2013 Mellanox Technologies. All rights reserved.
  *
  * This software is available to you under a choice of one of two
  * licenses.  You may choose to be licensed under the terms of the GNU
diff --git a/drivers/infiniband/ulp/iser/iser_initiator.c b/drivers/infiniband/ulp/iser/iser_initiator.c
index a00ccd1..b6d81a8 100644
--- a/drivers/infiniband/ulp/iser/iser_initiator.c
+++ b/drivers/infiniband/ulp/iser/iser_initiator.c
@@ -1,5 +1,6 @@
 /*
  * Copyright (c) 2004, 2005, 2006 Voltaire, Inc. All rights reserved.
+ * Copyright (c) 2013 Mellanox Technologies. All rights reserved.
  *
  * This software is available to you under a choice of one of two
  * licenses.  You may choose to be licensed under the terms of the GNU
diff --git a/drivers/infiniband/ulp/iser/iser_memory.c b/drivers/infiniband/ulp/iser/iser_memory.c
index 68ebb7f..7827baf 100644
--- a/drivers/infiniband/ulp/iser/iser_memory.c
+++ b/drivers/infiniband/ulp/iser/iser_memory.c
@@ -1,5 +1,6 @@
 /*
  * Copyright (c) 2004, 2005, 2006 Voltaire, Inc. All rights reserved.
+ * Copyright (c) 2013 Mellanox Technologies. All rights reserved.
  *
  * This software is available to you under a choice of one of two
  * licenses.  You may choose to be licensed under the terms of the GNU
diff --git a/drivers/infiniband/ulp/iser/iser_verbs.c b/drivers/infiniband/ulp/iser/iser_verbs.c
index f13cc22..2c4941d 100644
--- a/drivers/infiniband/ulp/iser/iser_verbs.c
+++ b/drivers/infiniband/ulp/iser/iser_verbs.c
@@ -1,6 +1,7 @@
 /*
  * Copyright (c) 2004, 2005, 2006 Voltaire, Inc. All rights reserved.
  * Copyright (c) 2005, 2006 Cisco Systems.  All rights reserved.
+ * Copyright (c) 2013 Mellanox Technologies. All rights reserved.
  *
  * This software is available to you under a choice of one of two
  * licenses.  You may choose to be licensed under the terms of the GNU
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
