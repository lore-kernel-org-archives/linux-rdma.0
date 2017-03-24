From: Jack Wang <jinpu.wang@profitbricks.com>
Subject: [PATCH 08/28] ibtrs_clt: add Makefile and Kconfig
Date: Fri, 24 Mar 2017 11:45:23 +0100
Message-ID: <1490352343-20075-9-git-send-email-jinpu.wangl@profitbricks.com>
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
 drivers/infiniband/Kconfig                   | 2 ++
 drivers/infiniband/ulp/Makefile              | 1 +
 drivers/infiniband/ulp/ibtrs_client/Kconfig  | 8 ++++++++
 drivers/infiniband/ulp/ibtrs_client/Makefile | 6 ++++++
 4 files changed, 17 insertions(+)
 create mode 100644 drivers/infiniband/ulp/ibtrs_client/Kconfig
 create mode 100644 drivers/infiniband/ulp/ibtrs_client/Makefile

diff --git a/drivers/infiniband/Kconfig b/drivers/infiniband/Kconfig
index 66f8602..cb1b864 100644
--- a/drivers/infiniband/Kconfig
+++ b/drivers/infiniband/Kconfig
@@ -85,6 +85,8 @@ source "drivers/infiniband/ulp/srpt/Kconfig"
 source "drivers/infiniband/ulp/iser/Kconfig"
 source "drivers/infiniband/ulp/isert/Kconfig"
 
+source "drivers/infiniband/ulp/ibtrs_client/Kconfig"
+
 source "drivers/infiniband/sw/rdmavt/Kconfig"
 source "drivers/infiniband/sw/rxe/Kconfig"
 
diff --git a/drivers/infiniband/ulp/Makefile b/drivers/infiniband/ulp/Makefile
index f3c7dcf..acd8ce6 100644
--- a/drivers/infiniband/ulp/Makefile
+++ b/drivers/infiniband/ulp/Makefile
@@ -3,3 +3,4 @@ obj-$(CONFIG_INFINIBAND_SRP)		+= srp/
 obj-$(CONFIG_INFINIBAND_SRPT)		+= srpt/
 obj-$(CONFIG_INFINIBAND_ISER)		+= iser/
 obj-$(CONFIG_INFINIBAND_ISERT)		+= isert/
+obj-$(CONFIG_INFINIBAND_IBTRS_CLT)      += ibtrs_client/
diff --git a/drivers/infiniband/ulp/ibtrs_client/Kconfig b/drivers/infiniband/ulp/ibtrs_client/Kconfig
new file mode 100644
index 0000000..3cf0728
--- /dev/null
+++ b/drivers/infiniband/ulp/ibtrs_client/Kconfig
@@ -0,0 +1,8 @@
+config INFINIBAND_IBTRS_CLT
+	tristate "InfiniBand IBTRS CLIENT"
+	depends on INFINIBAND_ADDR_TRANS
+	---help---
+	  Support for the simplified data transfer over InfiniBand.
+	  This offer API to user module IBNBD_CLIENT
+
+	  The IBTRS protocol is defined by the ProfitBricks GmbH.
diff --git a/drivers/infiniband/ulp/ibtrs_client/Makefile b/drivers/infiniband/ulp/ibtrs_client/Makefile
new file mode 100644
index 0000000..d0fb226
--- /dev/null
+++ b/drivers/infiniband/ulp/ibtrs_client/Makefile
@@ -0,0 +1,6 @@
+
+obj-$(CONFIG_INFINIBAND_IBTRS_CLT)	+= ibtrs_client.o
+
+ibtrs_client-y		:= ibtrs_clt.o ibtrs_clt_sysfs.o \
+	../ibtrs_lib/ibtrs.o ../ibtrs_lib/ibtrs-proto.o ../ibtrs_lib/iu.o \
+	../ibtrs_lib/heartbeat.o ../ibtrs_lib/common.o
-- 
2.7.4
