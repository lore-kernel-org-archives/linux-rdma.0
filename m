From: Masahiro Yamada <yamada.masahiro@socionext.com>
Subject: [PATCH 1/2] infiniband: remove unneeded header search paths
Date: Fri, 25 Jan 2019 13:39:30 +0900
Message-ID: <1548391171-6407-2-git-send-email-yamada.masahiro@socionext.com>
References: <1548391171-6407-1-git-send-email-yamada.masahiro@socionext.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1548391171-6407-1-git-send-email-yamada.masahiro@socionext.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@mellanox.com>, linux-rdma@vger.kernel.org, Doug Ledford <dledford@redhat.com>
Cc: Masahiro Yamada <yamada.masahiro@socionext.com>, Jason Gunthorpe <jgg@ziepe.ca>, Sagi Grimberg <sagi@grimberg.me>, linux-kernel@vger.kernel.org, target-devel@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>
List-Id: linux-rdma@vger.kernel.org

The included headers are located in include/target/. I was able to
build these drivers without the extra header search paths.

Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
---

 drivers/infiniband/ulp/isert/Makefile | 1 -
 drivers/infiniband/ulp/srpt/Makefile  | 1 -
 2 files changed, 2 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/Makefile b/drivers/infiniband/ulp/isert/Makefile
index c8bf242..a4a4766 100644
--- a/drivers/infiniband/ulp/isert/Makefile
+++ b/drivers/infiniband/ulp/isert/Makefile
@@ -1,2 +1 @@
-ccflags-y		:= -Idrivers/target -Idrivers/target/iscsi
 obj-$(CONFIG_INFINIBAND_ISERT)	+= ib_isert.o
diff --git a/drivers/infiniband/ulp/srpt/Makefile b/drivers/infiniband/ulp/srpt/Makefile
index e3ee4bd..43fbde4 100644
--- a/drivers/infiniband/ulp/srpt/Makefile
+++ b/drivers/infiniband/ulp/srpt/Makefile
@@ -1,2 +1 @@
-ccflags-y			:= -Idrivers/target
 obj-$(CONFIG_INFINIBAND_SRPT)	+= ib_srpt.o
-- 
2.7.4
