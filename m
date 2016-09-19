From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 9/9] remove iwpmd/README
Date: Mon, 19 Sep 2016 08:56:33 -0700
Message-ID: <1474300593-31922-10-git-send-email-hch@lst.de>
References: <1474300593-31922-1-git-send-email-hch@lst.de>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1474300593-31922-1-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

No useful information left in it for the modern-day package.

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 iwpmd/README | 36 ------------------------------------
 1 file changed, 36 deletions(-)
 delete mode 100644 iwpmd/README

diff --git a/iwpmd/README b/iwpmd/README
deleted file mode 100644
index 49a2890..0000000
--- a/iwpmd/README
+++ /dev/null
@@ -1,36 +0,0 @@
-iWarp Port Mapper Daemon - iwpmd
-
-DESCRIPTION
-
-iwpmd provides a user space service (iwpmd) for the iWarp drivers
-to claim tcp ports through the standard socket interface.
-The drivers currently using the service are Intel nes and Chelsio cxgb4.
-
-PREREQUISITES
-
-iwpmd requires libnl-1 or higher version and the corresponding libnl-devel
-to be installed.
-
-The kernel space support for the port mapper is part of the iw_cm module.
-The ib_core module includes netlink support, which is used by the port mapper 
-clients to exchange messages with iwpmd. Both modules iw_cm and ib_core need to 
-be loaded in order for the iwpmd service to start successfully.
-
-If the iwpmd is installed, but the required modules aren't loaded, you need to
-load the modules and then restart the iwpmd service.
-
-STARTING THE SERVICE
-
-After installing an OFED package which includes iwpmd, the service should start 
-automatically after reboot.
-
-To check if the service is running:
-ps aux | grep iwpmd
-
-To start/stop the iwpmd service use:
-service iwpmd start
-service iwpmd stop
-
-With systemd, to start/stop the iwpmd service use:
-systemctl start iwpmd
-systemctl stop iwpmd
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
