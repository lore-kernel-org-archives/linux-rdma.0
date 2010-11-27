From: "Justin P. Mattock" <justinmattock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [RFC 9/9]include:linux Change the copyright info.
Date: Fri, 26 Nov 2010 22:21:19 -0800
Message-ID: <1290838879-11038-10-git-send-email-justinmattock@gmail.com>
References: <1290838879-11038-1-git-send-email-justinmattock@gmail.com>
Return-path: <linux-wireless-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1290838879-11038-1-git-send-email-justinmattock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-wireless-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: trivial-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ide-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mtd-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-wireless-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Justin P. Mattock" <justinmattock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Change the copyright info from Sun Microsystems to Oracle since Oracle now owns them.

Signed-off-by: Justin P. Mattock <justinmattock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

---
 include/linux/ethtool.h       |    4 ++--
 include/linux/mlx4/doorbell.h |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
index 6628a50..2d895be 100644
--- a/include/linux/ethtool.h
+++ b/include/linux/ethtool.h
@@ -3,11 +3,11 @@
  *
  * Copyright (C) 1998 David S. Miller (davem-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org)
  * Copyright 2001 Jeff Garzik <jgarzik-e+AXbWqSrlAAvxtiuMwx3w@public.gmane.org>
- * Portions Copyright 2001 Sun Microsystems (thockin-xsfywfwIY+M@public.gmane.org)
+ * Portions Copyright 2001 Oracle and/or its affiliates. (thockin-xsfywfwIY+M@public.gmane.org)
  * Portions Copyright 2002 Intel (eli.kupermann-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org,
  *                                christopher.leech-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org,
  *                                scott.feldman-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org)
- * Portions Copyright (C) Sun Microsystems 2008
+ * Portions Copyright (C) 2008 Oracle and/or its affiliates. 
  */
 
 #ifndef _LINUX_ETHTOOL_H
diff --git a/include/linux/mlx4/doorbell.h b/include/linux/mlx4/doorbell.h
index f31bba2..d251ee8 100644
--- a/include/linux/mlx4/doorbell.h
+++ b/include/linux/mlx4/doorbell.h
@@ -1,6 +1,6 @@
 /*
  * Copyright (c) 2004 Topspin Communications.  All rights reserved.
- * Copyright (c) 2005 Sun Microsystems, Inc. All rights reserved.
+ * Copyright (c) 2005 Oracle and/or its affiliates. All rights reserved.
  * Copyright (c) 2005 Mellanox Technologies. All rights reserved.
  *
  * This software is available to you under a choice of one of two
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
