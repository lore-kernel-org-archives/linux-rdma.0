From: Jack Wang <jinpu.wang@profitbricks.com>
Subject: [PATCH 26/28] ibnbd_srv: add Makefile and Kconfig
Date: Fri, 24 Mar 2017 11:45:41 +0100
Message-ID: <1490352343-20075-27-git-send-email-jinpu.wangl@profitbricks.com>
References: <1490352343-20075-1-git-send-email-jinpu.wangl@profitbricks.com>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <1490352343-20075-1-git-send-email-jinpu.wangl@profitbricks.com>
Sender: linux-block-owner@vger.kernel.org
To: linux-block@vger.kernel.org, linux-rdma@vger.kernel.org
Cc: dledford@redhat.com, axboe@kernel.dk, hch@lst.de, mail@fholler.de, Milind.dumbare@gmail.com, yun.wang@profitbricks.com, Jack Wang <jinpu.wang@profitbricks.com>
List-Id: linux-rdma@vger.kernel.org

From: Jack Wang <jinpu.wang@profitbricks.com>

Signed-off-by: Jack Wang <jinpu.wang@profitbricks.com>
---
 drivers/block/Kconfig               |  1 +
 drivers/block/Makefile              |  1 +
 drivers/block/ibnbd_server/Kconfig  | 16 ++++++++++++++++
 drivers/block/ibnbd_server/Makefile |  3 +++
 4 files changed, 21 insertions(+)
 create mode 100644 drivers/block/ibnbd_server/Kconfig
 create mode 100644 drivers/block/ibnbd_server/Makefile

diff --git a/drivers/block/Kconfig b/drivers/block/Kconfig
index c309e57..e4823c4 100644
--- a/drivers/block/Kconfig
+++ b/drivers/block/Kconfig
@@ -276,6 +276,7 @@ config BLK_DEV_CRYPTOLOOP
 source "drivers/block/drbd/Kconfig"
 
 source "drivers/block/ibnbd_client/Kconfig"
+source "drivers/block/ibnbd_server/Kconfig"
 
 config BLK_DEV_NBD
 	tristate "Network block device support"
diff --git a/drivers/block/Makefile b/drivers/block/Makefile
index 7da1813..cd20888 100644
--- a/drivers/block/Makefile
+++ b/drivers/block/Makefile
@@ -35,6 +35,7 @@ obj-$(CONFIG_BLK_DEV_HD)	+= hd.o
 obj-$(CONFIG_XEN_BLKDEV_FRONTEND)	+= xen-blkfront.o
 obj-$(CONFIG_XEN_BLKDEV_BACKEND)	+= xen-blkback/
 obj-$(CONFIG_BLK_DEV_IBNBD_CLT)	+= ibnbd_client/
+obj-$(CONFIG_BLK_DEV_IBNBD_SRV)	+= ibnbd_server/
 obj-$(CONFIG_BLK_DEV_DRBD)     += drbd/
 obj-$(CONFIG_BLK_DEV_RBD)     += rbd.o
 obj-$(CONFIG_BLK_DEV_PCIESSD_MTIP32XX)	+= mtip32xx/
diff --git a/drivers/block/ibnbd_server/Kconfig b/drivers/block/ibnbd_server/Kconfig
new file mode 100644
index 0000000..943e1b2
--- /dev/null
+++ b/drivers/block/ibnbd_server/Kconfig
@@ -0,0 +1,16 @@
+config BLK_DEV_IBNBD_SRV
+	tristate "Network block device over Infiniband server support"
+	depends on INFINIBAND_IBTRS_SRV
+	---help---
+	  Saying Y here will allow your computer to be a server for network
+	  block devices over Infiniband, i.e. it will be able to use block
+	  devices exported by servers (mount file systems on them etc.).
+	  Communication between client and server works over Infiniband
+	  networking, but to the client program this is hidden:
+	  it looks like a regular local file access to a block device
+	  special file such as /dev/ibnbd0.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called ibnbd_client.
+
+	  If unsure, say N.
diff --git a/drivers/block/ibnbd_server/Makefile b/drivers/block/ibnbd_server/Makefile
new file mode 100644
index 0000000..e66860f
--- /dev/null
+++ b/drivers/block/ibnbd_server/Makefile
@@ -0,0 +1,3 @@
+obj-$(CONFIG_BLK_DEV_IBNBD_SRV) += ibnbd_server.o
+ibnbd_server-objs 	:= ibnbd_srv.o ibnbd_srv_sysfs.o ibnbd_dev.o \
+	../ibnbd_lib/ibnbd.o ../ibnbd_lib/ibnbd-proto.o
-- 
2.7.4
