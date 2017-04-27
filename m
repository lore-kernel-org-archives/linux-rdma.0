From: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Subject: [rdma-core 1/4] libqedr: remove obsolete device IDs
Date: Thu, 27 Apr 2017 09:11:05 +0300
Message-ID: <1493273468-23774-2-git-send-email-Ram.Amrani@cavium.com>
References: <1493273468-23774-1-git-send-email-Ram.Amrani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1493273468-23774-1-git-send-email-Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org
Cc: Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The removed device IDs were never actually used.
Signed-off-by: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
---
 providers/qedr/qelr_main.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/providers/qedr/qelr_main.c b/providers/qedr/qelr_main.c
index ba70db9..9f3feda 100644
--- a/providers/qedr/qelr_main.c
+++ b/providers/qedr/qelr_main.c
@@ -58,10 +58,7 @@
 #define PCI_DEVICE_ID_QLOGIC_57980S_50  (0x1654)
 #define PCI_DEVICE_ID_QLOGIC_57980S_25  (0x1656)
 #define PCI_DEVICE_ID_QLOGIC_57980S_IOV (0x1664)
-#define PCI_DEVICE_ID_QLOGIC_AH_50G     (0x8070)
-#define PCI_DEVICE_ID_QLOGIC_AH_10G     (0x8071)
-#define PCI_DEVICE_ID_QLOGIC_AH_40G     (0x8072)
-#define PCI_DEVICE_ID_QLOGIC_AH_25G     (0x8073)
+#define PCI_DEVICE_ID_QLOGIC_AH         (0x8070)
 #define PCI_DEVICE_ID_QLOGIC_AH_IOV     (0x8090)
 
 uint32_t qelr_dp_level;
@@ -83,10 +80,7 @@ static const struct {
 	QHCA(57980S_50),
 	QHCA(57980S_25),
 	QHCA(57980S_IOV),
-	QHCA(AH_50G),
-	QHCA(AH_10G),
-	QHCA(AH_40G),
-	QHCA(AH_25G),
+	QHCA(AH),
 	QHCA(AH_IOV),
 };
 
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
