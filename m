From: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH rdma-next v2] RDMA/qedr: Add qedr to MAINTAINERS file
Date: Mon, 29 May 2017 11:18:54 +0300
Message-ID: <1496045934-4727-1-git-send-email-Ram.Amrani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Ariel Elior <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
---
 MAINTAINERS | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index c776906..c8fee60 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -10339,6 +10339,14 @@ L:	linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
 S:	Supported
 F:	drivers/scsi/qedf/
 
+QLOGIC QL4xxx RDMA DRIVER
+M:	Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
+M:	Ariel Elior <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
+L:	linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
+S:	Supported
+F:	drivers/infiniband/hw/qedr/
+F:	include/uapi/rdma/qedr-abi.h
+
 QNX4 FILESYSTEM
 M:	Anders Larsen <al-V9/YLgxv/GvR7s880joybQ@public.gmane.org>
 W:	http://www.alarsen.net/linux/qnx4fs/
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
