From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 4/4] IB/iser: Bump version to 1.4
Date: Thu, 22 May 2014 11:00:21 +0300
Message-ID: <1400745621-9978-5-git-send-email-ogerlitz@r-vnc04.mtr.labs.mlnx>
References: <1400745621-9978-1-git-send-email-ogerlitz@r-vnc04.mtr.labs.mlnx>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1400745621-9978-1-git-send-email-ogerlitz-lZu6o6FoHf8DyJZ7l8Lk7nI+JuX82XLG@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, sagig-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, arieln-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/iser/iscsi_iser.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.h b/drivers/infiniband/ulp/iser/iscsi_iser.h
index d309620..97cd385 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.h
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.h
@@ -69,7 +69,7 @@
 
 #define DRV_NAME	"iser"
 #define PFX		DRV_NAME ": "
-#define DRV_VER		"1.3"
+#define DRV_VER		"1.4"
 
 #define iser_dbg(fmt, arg...)				\
 	do {						\
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
