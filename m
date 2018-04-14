From: Greg Thelen <gthelen@google.com>
Subject: [PATCH v3] IB: make INFINIBAND_ADDR_TRANS configurable
Date: Sat, 14 Apr 2018 08:36:42 -0700
Message-ID: <20180414153642.28178-1-gthelen@google.com>
References: <CAHH2K0YTCa99ZfCdvq0WEJVvszo7+kUiVP_cz0igqE4TZSNYGQ@mail.gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAHH2K0YTCa99ZfCdvq0WEJVvszo7+kUiVP_cz0igqE4TZSNYGQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: dennis.dalessandro@intel.com, Bart Van Assche <Bart.VanAssche@wdc.com>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, Greg Thelen <gthelen@google.com>, Tarick Bedeir <tarick@google.com>
List-Id: linux-rdma@vger.kernel.org

Allow INFINIBAND without INFINIBAND_ADDR_TRANS.

Signed-off-by: Greg Thelen <gthelen@google.com>
Cc: Tarick Bedeir <tarick@google.com>
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
