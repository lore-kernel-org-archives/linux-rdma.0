From: Jack Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: [PATCH 20/28] ibnbd_clt: add Makefile and Kconfig
Date: Fri, 24 Mar 2017 11:45:35 +0100
Message-ID: <1490352343-20075-21-git-send-email-jinpu.wangl@profitbricks.com>
References: <1490352343-20075-1-git-send-email-jinpu.wangl@profitbricks.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1490352343-20075-1-git-send-email-jinpu.wangl-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, hch-jcswGhMUV9g@public.gmane.org, mail-99BIx50xQYGELgA04lAiVw@public.gmane.org, Milind.dumbare-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org, Jack Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jack Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>

Signed-off-by: Jack Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
---
 drivers/block/Kconfig               |  2 ++
 drivers/block/Makefile              |  1 +
 drivers/block/ibnbd_client/Kconfig  | 16 ++++++++++++++++
 drivers/block/ibnbd_client/Makefile |  5 +++++
 4 files changed, 24 insertions(+)
 create mode 100644 drivers/block/ibnbd_client/Kconfig
 create mode 100644 drivers/block/ibnbd_client/Makefile

diff --git a/drivers/block/Kconfig b/drivers/block/Kconfig
index f744de7..c309e57 100644
--- a/drivers/block/Kconfig
+++ b/drivers/block/Kconfig
@@ -275,6 +275,8 @@ config BLK_DEV_CRYPTOLOOP
 
 source "drivers/block/drbd/Kconfig"
 
+source "drivers/block/ibnbd_client/Kconfig"
+
 config BLK_DEV_NBD
 	tristate "Network block device support"
 	depends on NET
diff --git a/drivers/block/Makefile b/drivers/block/Makefile
index 1e9661e..7da1813 100644
--- a/drivers/block/Makefile
+++ b/drivers/block/Makefile
@@ -34,6 +34,7 @@ obj-$(CONFIG_BLK_DEV_HD)	+= hd.o
 
 obj-$(CONFIG_XEN_BLKDEV_FRONTEND)	+= xen-blkfront.o
 obj-$(CONFIG_XEN_BLKDEV_BACKEND)	+= xen-blkback/
+obj-$(CONFIG_BLK_DEV_IBNBD_CLT)	+= ibnbd_client/
 obj-$(CONFIG_BLK_DEV_DRBD)     += drbd/
 obj-$(CONFIG_BLK_DEV_RBD)     += rbd.o
 obj-$(CONFIG_BLK_DEV_PCIESSD_MTIP32XX)	+= mtip32xx/
diff --git a/drivers/block/ibnbd_client/Kconfig b/drivers/block/ibnbd_client/Kconfig
new file mode 100644
index 0000000..162e4e1
--- /dev/null
+++ b/drivers/block/ibnbd_client/Kconfig
@@ -0,0 +1,16 @@
+config BLK_DEV_IBNBD_CLT
+	tristate "Network block device over Infiniband client support"
+	depends on INFINIBAND_IBTRS_CLT
+	---help---
+	  Saying Y here will allow your computer to be a client for network
+	  block devices over Infiniband, i.e. it will be able to use block
+	  devices exported by
+	  servers (mount file systems on them etc.). Communication between
+	  client and server works over Infiniband networking, but to the client
+	  program this is hidden: it looks like a regular local file access to
+	  a block device special file such as /dev/ibnbd0.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called ibnbd_client.
+
+	  If unsure, say N.
diff --git a/drivers/block/ibnbd_client/Makefile b/drivers/block/ibnbd_client/Makefile
new file mode 100644
index 0000000..bbf211f
--- /dev/null
+++ b/drivers/block/ibnbd_client/Makefile
@@ -0,0 +1,5 @@
+
+obj-$(CONFIG_BLK_DEV_IBNBD_CLT)	+= ibnbd_client.o
+
+ibnbd_client-y 	:= ibnbd_clt.o ibnbd_clt_sysfs.o ../ibnbd_lib/ibnbd.o \
+			   ../ibnbd_lib/ibnbd-proto.o
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
