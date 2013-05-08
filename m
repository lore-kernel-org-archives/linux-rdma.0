From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH RESEND for-3.10 3/3] MAINTAINERS: Add entry for iSCSI Extensions for RDMA (iSER) initiator
Date: Wed,  8 May 2013 15:21:19 +0300
Message-ID: <1368015679-15215-4-git-send-email-ogerlitz@mellanox.com>
References: <1368015679-15215-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1368015679-15215-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Add entry for the iSER initiator driver and which is maintained by
Or Gerlitz and Roi Dayan below the kernel Infiniband subsystem.

Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 MAINTAINERS |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 8bdd7a7..cc5861c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4378,6 +4378,16 @@ S:	Maintained
 F:	drivers/scsi/*iscsi*
 F:	include/scsi/*iscsi*
 
+ISCSI EXTENSIONS FOR RDMA (ISER) INITIATOR
+M:	Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
+M:	Roi Dayan <roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
+L:	linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
+S:	Supported
+W:	http://www.openfabrics.org
+W:	www.open-iscsi.org
+Q:	http://patchwork.kernel.org/project/linux-rdma/list/
+F:	drivers/infiniband/ulp/iser
+
 ISDN SUBSYSTEM
 M:	Karsten Keil <isdn-iHCpqvpFUx0uJkBD2foKsQ@public.gmane.org>
 L:	isdn4linux-JX7+OpRa80SjiSfgN6Y1Ib39b6g2fGNp@public.gmane.org (subscribers-only)
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
