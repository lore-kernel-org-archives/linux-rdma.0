From: "Justin P. Mattock" <justinmattock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [RFC 4/9]drivers:ide Change the copyright info.
Date: Fri, 26 Nov 2010 22:21:14 -0800
Message-ID: <1290838879-11038-5-git-send-email-justinmattock@gmail.com>
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
 drivers/ide/hpt366.c      |    2 +-
 drivers/ide/serverworks.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/ide/hpt366.c b/drivers/ide/hpt366.c
index 58c51cd..8e31cfa 100644
--- a/drivers/ide/hpt366.c
+++ b/drivers/ide/hpt366.c
@@ -1,6 +1,6 @@
 /*
  * Copyright (C) 1999-2003		Andre Hedrick <andre-QA/0nRrxPJrNLxjTenLetw@public.gmane.org>
- * Portions Copyright (C) 2001	        Sun Microsystems, Inc.
+ * Portions Copyright (C) 2001	        Oracle and/or its affiliates. 
  * Portions Copyright (C) 2003		Red Hat Inc
  * Portions Copyright (C) 2007		Bartlomiej Zolnierkiewicz
  * Portions Copyright (C) 2005-2009	MontaVista Software, Inc.
diff --git a/drivers/ide/serverworks.c b/drivers/ide/serverworks.c
index 35fb8da..267c87e 100644
--- a/drivers/ide/serverworks.c
+++ b/drivers/ide/serverworks.c
@@ -3,7 +3,7 @@
  * Copyright (C) 1998-2000 Andrzej Krzysztofowicz
  * Copyright (C) 1998-2000 Andre Hedrick <andre-QA/0nRrxPJrNLxjTenLetw@public.gmane.org>
  * Copyright (C) 2007-2010 Bartlomiej Zolnierkiewicz
- * Portions copyright (c) 2001 Sun Microsystems
+ * Portions copyright (c) 2001 Oracle and/or its affiliates. 
  *
  *
  * RCC/ServerWorks IDE driver for Linux
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
