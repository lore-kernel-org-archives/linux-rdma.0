From: Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] RDMA/nes: Changing the version number of nes driver
Date: Tue, 2 Oct 2012 15:32:15 -0500
Message-ID: <20121002203215.GA9444@TENIKOLO-MOBL>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Changing the version of the nes driver to reflect recent fixes

Signed-off-by: Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/nes/nes.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/nes/nes.h b/drivers/infiniband/hw/nes/nes.h
index c438e46..0418bc0 100644
--- a/drivers/infiniband/hw/nes/nes.h
+++ b/drivers/infiniband/hw/nes/nes.h
@@ -57,7 +57,7 @@
 #define QUEUE_DISCONNECTS
 
 #define DRV_NAME    "iw_nes"
-#define DRV_VERSION "1.5.0.0"
+#define DRV_VERSION "1.5.0.1"
 #define PFX         DRV_NAME ": "
 
 /*
-- 
1.7.4.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
