From: Roman Pen <roman.penyaev@profitbricks.com>
Subject: [PATCH 24/24] MAINTAINERS: Add maintainer for IBNBD/IBTRS modules
Date: Fri,  2 Feb 2018 15:09:04 +0100
Message-ID: <20180202140904.2017-25-roman.penyaev@profitbricks.com>
References: <20180202140904.2017-1-roman.penyaev@profitbricks.com>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20180202140904.2017-1-roman.penyaev@profitbricks.com>
Sender: linux-block-owner@vger.kernel.org
To: linux-block@vger.kernel.org, linux-rdma@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>, Sagi Grimberg <sagi@grimberg.me>, Bart Van Assche <bart.vanassche@sandisk.com>, Or Gerlitz <ogerlitz@mellanox.com>, Roman Pen <roman.penyaev@profitbricks.com>, Danil Kipnis <danil.kipnis@profitbricks.com>, Jack Wang <jinpu.wang@profitbricks.com>
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Roman Pen <roman.penyaev@profitbricks.com>
Cc: Danil Kipnis <danil.kipnis@profitbricks.com>
Cc: Jack Wang <jinpu.wang@profitbricks.com>
---
 MAINTAINERS | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 18994806e441..fad9c2529f8a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6714,6 +6714,20 @@ IBM ServeRAID RAID DRIVER
 S:	Orphan
 F:	drivers/scsi/ips.*
 
+IBNBD BLOCK DRIVERS
+M:	IBNBD/IBTRS Storage Team <ibnbd@profitbricks.com>
+L:	linux-block@vger.kernel.org
+S:	Maintained
+T:	git git://github.com/profitbricks/ibnbd.git
+F:	drivers/block/ibnbd/
+
+IBTRS TRANSPORT DRIVERS
+M:	IBNBD/IBTRS Storage Team <ibnbd@profitbricks.com>
+L:	linux-rdma@vger.kernel.org
+S:	Maintained
+T:	git git://github.com/profitbricks/ibnbd.git
+F:	drivers/infiniband/ulp/ibtrs/
+
 ICH LPC AND GPIO DRIVER
 M:	Peter Tyser <ptyser@xes-inc.com>
 S:	Maintained
-- 
2.13.1
