From: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] MAINTAINERS: modify information for ipath/qib
Date: Tue, 28 Jun 2011 17:30:09 -0400
Message-ID: <20110628213009.8433.54347.stgit@kop-dev-sles11-04.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The maintainer information for the Qlogic infiniband hardware was
out of date.

This patch corrects the issue.

Signed-off-by: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
---
 MAINTAINERS |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index e50fc6e..c7ac0ff 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3417,10 +3417,9 @@ S:	Maintained
 F:	drivers/net/ipg.*
 
 IPATH DRIVER
-M:	Ralph Campbell <infinipath-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
+M:	Mike Marciniszyn <infinipath-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
 L:	linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
-T:	git git://git.qlogic.com/ipath-linux-2.6
-S:	Supported
+S:	Maintained
 F:	drivers/infiniband/hw/ipath/
 
 IPMI SUBSYSTEM
@@ -5138,6 +5137,12 @@ M:	Robert Jarzmik <robert.jarzmik-GANU6spQydw@public.gmane.org>
 L:	rtc-linux-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
 S:	Maintained
 
+QIB DRIVER
+M:	Mike Marciniszyn <infinipath-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
+L:	linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
+S:	Supported
+F:	drivers/infiniband/hw/qib/
+
 QLOGIC QLA1280 SCSI DRIVER
 M:	Michael Reed <mdr-sJ/iWh9BUns@public.gmane.org>
 L:	linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
