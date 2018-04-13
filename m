From: Greg Thelen <gthelen@google.com>
Subject: [PATCH v2] IB: make INFINIBAND_ADDR_TRANS configurable
Date: Fri, 13 Apr 2018 10:27:08 -0700
Message-ID: <20180413172708.30286-1-gthelen@google.com>
References: <9ad4563e701a38915d58552f9eee5b3602833ddf.camel@wdc.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <9ad4563e701a38915d58552f9eee5b3602833ddf.camel@wdc.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, Greg Thelen <gthelen@google.com>, Tarick Bedeir <tarick@google.com>
List-Id: linux-rdma@vger.kernel.org

Allow INFINIBAND without INFINIBAND_ADDR_TRANS.

Signed-off-by: Greg Thelen <gthelen@google.com>
Cc: Tarick Bedeir <tarick@google.com>
Change-Id: I6fbbf8a432e467710fa65e4904b7d61880b914e5
---
 drivers/infiniband/Kconfig | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/Kconfig b/drivers/infiniband/Kconfig
index ee270e065ba9..2a972ed6851b 100644
--- a/drivers/infiniband/Kconfig
+++ b/drivers/infiniband/Kconfig
@@ -61,9 +61,12 @@ config INFINIBAND_ON_DEMAND_PAGING
 	  pages on demand instead.
 
 config INFINIBAND_ADDR_TRANS
-	bool
+	bool "RDMA/CM"
 	depends on INFINIBAND
 	default y
+	---help---
+	  Support for RDMA communication manager (CM).
+	  This allows for a generic connection abstraction over RDMA.
 
 config INFINIBAND_ADDR_TRANS_CONFIGFS
 	bool
-- 
2.17.0.484.g0c8726318c-goog
