From: Greg Thelen <gthelen@google.com>
Subject: [PATCH 3/5] ib_srpt: depend on INFINIBAND_ADDR_TRANS
Date: Wed, 25 Apr 2018 15:33:39 -0700
Message-ID: <20180425223340.206907-1-gthelen@google.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Bart Van Assche <Bart.VanAssche@wdc.com>, Jason Gunthorpe <jgg@ziepe.ca>
Cc: Christoph Hellwig <hch@lst.de>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, Greg Thelen <gthelen@google.com>, Tarick Bedeir <tarick@google.com>
List-Id: linux-rdma@vger.kernel.org

INFINIBAND_SRPT code depends on INFINIBAND_ADDR_TRANS provided symbols.
So declare the kconfig dependency.  This is necessary to allow for
enabling INFINIBAND without INFINIBAND_ADDR_TRANS.

Signed-off-by: Greg Thelen <gthelen@google.com>
Cc: Tarick Bedeir <tarick@google.com>
---
 drivers/infiniband/ulp/srpt/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/ulp/srpt/Kconfig b/drivers/infiniband/ulp/srpt/Kconfig
index 31ee83d528d9..fb8b7182f05e 100644
--- a/drivers/infiniband/ulp/srpt/Kconfig
+++ b/drivers/infiniband/ulp/srpt/Kconfig
@@ -1,6 +1,6 @@
 config INFINIBAND_SRPT
 	tristate "InfiniBand SCSI RDMA Protocol target support"
-	depends on INFINIBAND && TARGET_CORE
+	depends on INFINIBAND && INFINIBAND_ADDR_TRANS && TARGET_CORE
 	---help---
 
 	  Support for the SCSI RDMA Protocol (SRP) Target driver. The
-- 
2.17.0.441.gb46fe60e1d-goog
