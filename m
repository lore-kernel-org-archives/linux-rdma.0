From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 21/21] IB/iser: Bump version, add maintainer
Date: Wed,  1 Oct 2014 14:02:17 +0300
Message-ID: <1412161337-25285-22-git-send-email-ogerlitz@mellanox.com>
References: <1412161337-25285-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1412161337-25285-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roi Dayan <roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ariel Nahum <arieln-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Update the driver version and add Sagi Grimberg as maintainer

Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 MAINTAINERS                              |    1 +
 drivers/infiniband/ulp/iser/iscsi_iser.h |    2 +-
 2 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index f8db3c3..402e079 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5023,6 +5023,7 @@ F:	include/scsi/*iscsi*
 
 ISCSI EXTENSIONS FOR RDMA (ISER) INITIATOR
 M:	Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
+M:	Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
 M:	Roi Dayan <roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
 L:	linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
 S:	Supported
diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.h b/drivers/infiniband/ulp/iser/iscsi_iser.h
index 5250a12..cd4174c 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.h
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.h
@@ -69,7 +69,7 @@
 
 #define DRV_NAME	"iser"
 #define PFX		DRV_NAME ": "
-#define DRV_VER		"1.4.1"
+#define DRV_VER		"1.4.8"
 
 #define iser_dbg(fmt, arg...)				 \
 	do {						 \
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
