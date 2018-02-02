From: Roman Pen <roman.penyaev@profitbricks.com>
Subject: [PATCH 12/24] ibtrs: include client and server modules into kernel compilation
Date: Fri,  2 Feb 2018 15:08:52 +0100
Message-ID: <20180202140904.2017-13-roman.penyaev@profitbricks.com>
References: <20180202140904.2017-1-roman.penyaev@profitbricks.com>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20180202140904.2017-1-roman.penyaev@profitbricks.com>
Sender: linux-block-owner@vger.kernel.org
To: linux-block@vger.kernel.org, linux-rdma@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>, Sagi Grimberg <sagi@grimberg.me>, Bart Van Assche <bart.vanassche@sandisk.com>, Or Gerlitz <ogerlitz@mellanox.com>, Roman Pen <roman.penyaev@profitbricks.com>, Danil Kipnis <danil.kipnis@profitbricks.com>, Jack Wang <jinpu.wang@profitbricks.com>
List-Id: linux-rdma@vger.kernel.org

Add IBTRS Makefile, Kconfig and also corresponding lines into upper
layer infiniband/ulp files.

Signed-off-by: Roman Pen <roman.penyaev@profitbricks.com>
Signed-off-by: Danil Kipnis <danil.kipnis@profitbricks.com>
Cc: Jack Wang <jinpu.wang@profitbricks.com>
---
 drivers/infiniband/Kconfig            |  1 +
 drivers/infiniband/ulp/Makefile       |  1 +
 drivers/infiniband/ulp/ibtrs/Kconfig  | 20 ++++++++++++++++++++
 drivers/infiniband/ulp/ibtrs/Makefile | 15 +++++++++++++++
 4 files changed, 37 insertions(+)

diff --git a/drivers/infiniband/Kconfig b/drivers/infiniband/Kconfig
index cbf186522016..7adbd0e272c4 100644
--- a/drivers/infiniband/Kconfig
+++ b/drivers/infiniband/Kconfig
@@ -93,6 +93,7 @@ source "drivers/infiniband/ulp/srpt/Kconfig"
 
 source "drivers/infiniband/ulp/iser/Kconfig"
 source "drivers/infiniband/ulp/isert/Kconfig"
+source "drivers/infiniband/ulp/ibtrs/Kconfig"
 
 source "drivers/infiniband/ulp/opa_vnic/Kconfig"
 source "drivers/infiniband/sw/rdmavt/Kconfig"
diff --git a/drivers/infiniband/ulp/Makefile b/drivers/infiniband/ulp/Makefile
index 437813c7b481..1c4f10dc8d49 100644
--- a/drivers/infiniband/ulp/Makefile
+++ b/drivers/infiniband/ulp/Makefile
@@ -5,3 +5,4 @@ obj-$(CONFIG_INFINIBAND_SRPT)		+= srpt/
 obj-$(CONFIG_INFINIBAND_ISER)		+= iser/
 obj-$(CONFIG_INFINIBAND_ISERT)		+= isert/
 obj-$(CONFIG_INFINIBAND_OPA_VNIC)	+= opa_vnic/
+obj-$(CONFIG_INFINIBAND_IBTRS)		+= ibtrs/
diff --git a/drivers/infiniband/ulp/ibtrs/Kconfig b/drivers/infiniband/ulp/ibtrs/Kconfig
new file mode 100644
index 000000000000..eaeb8f3f6b4e
--- /dev/null
+++ b/drivers/infiniband/ulp/ibtrs/Kconfig
@@ -0,0 +1,20 @@
+config INFINIBAND_IBTRS
+	tristate
+	depends on INFINIBAND_ADDR_TRANS
+
+config INFINIBAND_IBTRS_CLIENT
+	tristate "IBTRS client module"
+	depends on INFINIBAND_ADDR_TRANS
+	select INFINIBAND_IBTRS
+	help
+	  IBTRS client allows for simplified data transfer and connection
+	  establishment over RDMA (InfiniBand, RoCE, iWarp). Uses BIO-like
+	  READ/WRITE semantics and provides multipath capabilities.
+
+config INFINIBAND_IBTRS_SERVER
+	tristate "IBTRS server module"
+	depends on INFINIBAND_ADDR_TRANS
+	select INFINIBAND_IBTRS
+	help
+	  IBTRS server module processing connection and IO requests received
+	  from the IBTRS client module.
diff --git a/drivers/infiniband/ulp/ibtrs/Makefile b/drivers/infiniband/ulp/ibtrs/Makefile
new file mode 100644
index 000000000000..e6ea858745ad
--- /dev/null
+++ b/drivers/infiniband/ulp/ibtrs/Makefile
@@ -0,0 +1,15 @@
+ibtrs-client-y := ibtrs-clt.o \
+		  ibtrs-clt-stats.o \
+		  ibtrs-clt-sysfs.o
+
+ibtrs-server-y := ibtrs-srv.o \
+		  ibtrs-srv-stats.o \
+		  ibtrs-srv-sysfs.o
+
+ibtrs-core-y := ibtrs.o
+
+obj-$(CONFIG_INFINIBAND_IBTRS)        += ibtrs-core.o
+obj-$(CONFIG_INFINIBAND_IBTRS_CLIENT) += ibtrs-client.o
+obj-$(CONFIG_INFINIBAND_IBTRS_SERVER) += ibtrs-server.o
+
+-include $(src)/compat/compat.mk
-- 
2.13.1
