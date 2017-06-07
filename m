From: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Subject: [PATCH] IB/qib: remove duplicate code
Date: Wed, 7 Jun 2017 15:42:02 -0500
Message-ID: <20170607204202.GA29640@embeddedgus>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Marciniszyn <infinipath@intel.com>, Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, "Gustavo A. R. Silva" <garsilva@embeddedor.com>
List-Id: linux-rdma@vger.kernel.org

Remove duplicate code.

Addresses-Coverity-ID: 1226951
Signed-off-by: Gustavo A. R. Silva <garsilva@embeddedor.com>
---
 drivers/infiniband/hw/qib/qib_mad.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_mad.c b/drivers/infiniband/hw/qib/qib_mad.c
index da295e0..c5eaa3c 100644
--- a/drivers/infiniband/hw/qib/qib_mad.c
+++ b/drivers/infiniband/hw/qib/qib_mad.c
@@ -874,8 +874,6 @@ static int subn_set_portinfo(struct ib_smp *smp, struct ib_device *ibdev,
 		ib_dispatch_event(&event);
 	}
 
-	ret = subn_get_portinfo(smp, ibdev, port);
-
 	/* restore re-reg bit per o14-12.2.1 */
 	pip->clientrereg_resv_subnetto |= clientrereg;
 
-- 
2.5.0
