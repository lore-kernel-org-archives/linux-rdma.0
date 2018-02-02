From: Roman Pen <roman.penyaev@profitbricks.com>
Subject: [PATCH 22/24] ibnbd: include client and server modules into kernel compilation
Date: Fri,  2 Feb 2018 15:09:02 +0100
Message-ID: <20180202140904.2017-23-roman.penyaev@profitbricks.com>
References: <20180202140904.2017-1-roman.penyaev@profitbricks.com>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20180202140904.2017-1-roman.penyaev@profitbricks.com>
Sender: linux-block-owner@vger.kernel.org
To: linux-block@vger.kernel.org, linux-rdma@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>, Sagi Grimberg <sagi@grimberg.me>, Bart Van Assche <bart.vanassche@sandisk.com>, Or Gerlitz <ogerlitz@mellanox.com>, Roman Pen <roman.penyaev@profitbricks.com>, Danil Kipnis <danil.kipnis@profitbricks.com>, Jack Wang <jinpu.wang@profitbricks.com>
List-Id: linux-rdma@vger.kernel.org

Add IBNBD Makefile, Kconfig and also corresponding lines into upper
block layer files.

Signed-off-by: Roman Pen <roman.penyaev@profitbricks.com>
Signed-off-by: Danil Kipnis <danil.kipnis@profitbricks.com>
Cc: Jack Wang <jinpu.wang@profitbricks.com>
---
 drivers/block/Kconfig        |  2 ++
 drivers/block/Makefile       |  1 +
 drivers/block/ibnbd/Kconfig  | 22 ++++++++++++++++++++++
 drivers/block/ibnbd/Makefile | 13 +++++++++++++
 4 files changed, 38 insertions(+)

diff --git a/drivers/block/Kconfig b/drivers/block/Kconfig
index 40579d0cb3d1..483aae5d391e 100644
--- a/drivers/block/Kconfig
+++ b/drivers/block/Kconfig
@@ -477,4 +477,6 @@ config BLK_DEV_RSXX
 	  To compile this driver as a module, choose M here: the
 	  module will be called rsxx.
 
+source "drivers/block/ibnbd/Kconfig"
+
 endif # BLK_DEV
diff --git a/drivers/block/Makefile b/drivers/block/Makefile
index dc061158b403..65346a1d0b1a 100644
--- a/drivers/block/Makefile
+++ b/drivers/block/Makefile
@@ -38,6 +38,7 @@ obj-$(CONFIG_BLK_DEV_PCIESSD_MTIP32XX)	+= mtip32xx/
 obj-$(CONFIG_BLK_DEV_RSXX) += rsxx/
 obj-$(CONFIG_BLK_DEV_NULL_BLK)	+= null_blk.o
 obj-$(CONFIG_ZRAM) += zram/
+obj-$(CONFIG_BLK_DEV_IBNBD)	+= ibnbd/
 
 skd-y		:= skd_main.o
 swim_mod-y	:= swim.o swim_asm.o
diff --git a/drivers/block/ibnbd/Kconfig b/drivers/block/ibnbd/Kconfig
new file mode 100644
index 000000000000..c5cc7d111c7a
--- /dev/null
+++ b/drivers/block/ibnbd/Kconfig
@@ -0,0 +1,22 @@
+config BLK_DEV_IBNBD
+	boolean
+
+config BLK_DEV_IBNBD_CLIENT
+	tristate "Network block device driver on top of IBTRS transport"
+	depends on INFINIBAND_IBTRS_CLIENT
+	select BLK_DEV_IBNBD
+	help
+	  IBNBD client allows for mapping of a remote block devices over
+	  IBTRS protocol from a target system where IBNBD server is running.
+
+	  If unsure, say N.
+
+config BLK_DEV_IBNBD_SERVER
+	tristate "Network block device over RDMA Infiniband server support"
+	depends on INFINIBAND_IBTRS_SERVER
+	select BLK_DEV_IBNBD
+	help
+	  IBNBD server allows for exporting local block devices to a remote client
+	  over IBTRS protocol.
+
+	  If unsure, say N.
diff --git a/drivers/block/ibnbd/Makefile b/drivers/block/ibnbd/Makefile
new file mode 100644
index 000000000000..5f20e72e0633
--- /dev/null
+++ b/drivers/block/ibnbd/Makefile
@@ -0,0 +1,13 @@
+ccflags-y := -Idrivers/infiniband/ulp/ibtrs
+
+ibnbd-client-y := ibnbd-clt.o \
+		  ibnbd-clt-sysfs.o
+
+ibnbd-server-y := ibnbd-srv.o \
+		  ibnbd-srv-dev.o \
+		  ibnbd-srv-sysfs.o
+
+obj-$(CONFIG_BLK_DEV_IBNBD_CLIENT) += ibnbd-client.o
+obj-$(CONFIG_BLK_DEV_IBNBD_SERVER) += ibnbd-server.o
+
+-include $(src)/compat/compat.mk
-- 
2.13.1
