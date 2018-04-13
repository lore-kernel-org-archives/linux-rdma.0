From: Greg Thelen <gthelen@google.com>
Subject: [PATCH] IB: make INFINIBAND_ADDR_TRANS configurable
Date: Fri, 13 Apr 2018 00:06:44 -0700
Message-ID: <20180413070644.11974-1-gthelen@google.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, Greg Thelen <gthelen@google.com>, Tarick Bedeir <tarick@google.com>
List-Id: linux-rdma@vger.kernel.org

Allow INFINIBAND without INFINIBAND_ADDR_TRANS.

Signed-off-by: Greg Thelen <gthelen@google.com>
Cc: Tarick Bedeir <tarick@google.com>
---
 drivers/infiniband/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/Kconfig b/drivers/infiniband/Kconfig
index ee270e065ba9..f20a3977087c 100644
--- a/drivers/infiniband/Kconfig
+++ b/drivers/infiniband/Kconfig
@@ -61,7 +61,7 @@ config INFINIBAND_ON_DEMAND_PAGING
 	  pages on demand instead.
 
 config INFINIBAND_ADDR_TRANS
-	bool
+	bool "InfiniBand address translation"
 	depends on INFINIBAND
 	default y
 
-- 
2.17.0.484.g0c8726318c-goog
