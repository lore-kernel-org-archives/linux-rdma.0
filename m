From: "Justin P. Mattock" <justinmattock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [RFC 8/9]drivers:net Change the copyright info.
Date: Fri, 26 Nov 2010 22:21:18 -0800
Message-ID: <1290838879-11038-9-git-send-email-justinmattock@gmail.com>
References: <1290838879-11038-1-git-send-email-justinmattock@gmail.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1290838879-11038-1-git-send-email-justinmattock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: trivial-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ide-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mtd-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-wireless-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Justin P. Mattock" <justinmattock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Change the copyright info from Sun Microsystems to Oracle since Oracle now owns them.

Signed-off-by: Justin P. Mattock <justinmattock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

---
 drivers/net/cassini.c   |    2 +-
 drivers/net/cassini.h   |    4 ++--
 drivers/net/mlx4/cq.c   |    2 +-
 drivers/net/mlx4/main.c |    2 +-
 drivers/net/mlx4/mlx4.h |    2 +-
 drivers/net/natsemi.c   |    2 +-
 drivers/net/tg3.c       |    2 +-
 drivers/net/tg3.h       |    2 +-
 8 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/net/cassini.c b/drivers/net/cassini.c
index d6b6d6a..f09f544 100644
--- a/drivers/net/cassini.c
+++ b/drivers/net/cassini.c
@@ -1,6 +1,6 @@
 /* cassini.c: Sun Microsystems Cassini(+) ethernet driver.
  *
- * Copyright (C) 2004 Sun Microsystems Inc.
+ * Copyright (C) 2004 Oracle and/or its affiliates. 
  * Copyright (C) 2003 Adrian Sun (asun-KL5DX587PH7rWH8gY9oQAwC/G2K4zDHf@public.gmane.org)
  *
  * This program is free software; you can redistribute it and/or
diff --git a/drivers/net/cassini.h b/drivers/net/cassini.h
index dbc4787..30c760c 100644
--- a/drivers/net/cassini.h
+++ b/drivers/net/cassini.h
@@ -1,7 +1,7 @@
 /* $Id: cassini.h,v 1.16 2004/08/17 21:15:16 zaumen Exp $
  * cassini.h: Definitions for Sun Microsystems Cassini(+) ethernet driver.
  *
- * Copyright (C) 2004 Sun Microsystems Inc.
+ * Copyright (C) 2004 Oracle and/or its affiliates. 
  * Copyright (c) 2003 Adrian Sun (asun-KL5DX587PH7rWH8gY9oQAwC/G2K4zDHf@public.gmane.org)
  *
  * This program is free software; you can redistribute it and/or
@@ -19,7 +19,7 @@
  * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA
  * 02111-1307, USA.
  *
- * vendor id: 0x108E (Sun Microsystems, Inc.)
+ * vendor id: 0x108E (Oracle and/or its affiliates.)
  * device id: 0xabba (Cassini)
  * revision ids: 0x01 = Cassini
  *               0x02 = Cassini rev 2
diff --git a/drivers/net/mlx4/cq.c b/drivers/net/mlx4/cq.c
index 7cd34e9..d730de4 100644
--- a/drivers/net/mlx4/cq.c
+++ b/drivers/net/mlx4/cq.c
@@ -1,6 +1,6 @@
 /*
  * Copyright (c) 2004, 2005 Topspin Communications.  All rights reserved.
- * Copyright (c) 2005 Sun Microsystems, Inc. All rights reserved.
+ * Copyright (c) 2005 Oracle and/or its affiliates. All rights reserved.
  * Copyright (c) 2005, 2006, 2007 Cisco Systems, Inc. All rights reserved.
  * Copyright (c) 2005, 2006, 2007, 2008 Mellanox Technologies. All rights reserved.
  * Copyright (c) 2004 Voltaire, Inc. All rights reserved.
diff --git a/drivers/net/mlx4/main.c b/drivers/net/mlx4/main.c
index 782f11d..4e711e3 100644
--- a/drivers/net/mlx4/main.c
+++ b/drivers/net/mlx4/main.c
@@ -1,6 +1,6 @@
 /*
  * Copyright (c) 2004, 2005 Topspin Communications.  All rights reserved.
- * Copyright (c) 2005 Sun Microsystems, Inc. All rights reserved.
+ * Copyright (c) 2005 Oracle and/or its affiliates. All rights reserved.
  * Copyright (c) 2005, 2006, 2007, 2008 Mellanox Technologies. All rights reserved.
  * Copyright (c) 2006, 2007 Cisco Systems, Inc. All rights reserved.
  *
diff --git a/drivers/net/mlx4/mlx4.h b/drivers/net/mlx4/mlx4.h
index 0da5bb7..4fc154c 100644
--- a/drivers/net/mlx4/mlx4.h
+++ b/drivers/net/mlx4/mlx4.h
@@ -1,6 +1,6 @@
 /*
  * Copyright (c) 2004, 2005 Topspin Communications.  All rights reserved.
- * Copyright (c) 2005 Sun Microsystems, Inc. All rights reserved.
+ * Copyright (c) 2005 Oracle and/or its affiliates. All rights reserved.
  * Copyright (c) 2005, 2006, 2007 Cisco Systems.  All rights reserved.
  * Copyright (c) 2005, 2006, 2007, 2008 Mellanox Technologies. All rights reserved.
  * Copyright (c) 2004 Voltaire, Inc. All rights reserved.
diff --git a/drivers/net/natsemi.c b/drivers/net/natsemi.c
index 2fd3963..406f43a 100644
--- a/drivers/net/natsemi.c
+++ b/drivers/net/natsemi.c
@@ -1,7 +1,7 @@
 /* natsemi.c: A Linux PCI Ethernet driver for the NatSemi DP8381x series. */
 /*
 	Written/copyright 1999-2001 by Donald Becker.
-	Portions copyright (c) 2001,2002 Sun Microsystems (thockin-xsfywfwIY+M@public.gmane.org)
+	Portions copyright (c) 2001,2002 Oracle and/or its affiliates. (thockin-xsfywfwIY+M@public.gmane.org)
 	Portions copyright 2001,2002 Manfred Spraul (manfred-nhLOkwUX5cPe2c5cEj3t2g@public.gmane.org)
 	Portions copyright 2004 Harald Welte <laforge-TgoAw6mPHtdg9hUCZPvPmw@public.gmane.org>
 
diff --git a/drivers/net/tg3.c b/drivers/net/tg3.c
index 30ccbb6..337850a 100644
--- a/drivers/net/tg3.c
+++ b/drivers/net/tg3.c
@@ -3,7 +3,7 @@
  *
  * Copyright (C) 2001, 2002, 2003, 2004 David S. Miller (davem-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org)
  * Copyright (C) 2001, 2002, 2003 Jeff Garzik (jgarzik-e+AXbWqSrlAAvxtiuMwx3w@public.gmane.org)
- * Copyright (C) 2004 Sun Microsystems Inc.
+ * Copyright (C) 2004 Oracle and/or its affiliates. 
  * Copyright (C) 2005-2010 Broadcom Corporation.
  *
  * Firmware is:
diff --git a/drivers/net/tg3.h b/drivers/net/tg3.h
index 4a19748..f8d7210 100644
--- a/drivers/net/tg3.h
+++ b/drivers/net/tg3.h
@@ -3,7 +3,7 @@
  *
  * Copyright (C) 2001, 2002, 2003, 2004 David S. Miller (davem-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org)
  * Copyright (C) 2001 Jeff Garzik (jgarzik-e+AXbWqSrlAAvxtiuMwx3w@public.gmane.org)
- * Copyright (C) 2004 Sun Microsystems Inc.
+ * Copyright (C) 2004 Oracle and/or its affiliates. 
  * Copyright (C) 2007-2010 Broadcom Corporation.
  */
 
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
