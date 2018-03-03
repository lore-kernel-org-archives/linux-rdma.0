From: Arushi Singhal <arushisinghal19971997@gmail.com>
Subject: [PATCH] infiniband: hw: Drop unnecessary continue
Date: Sat, 3 Mar 2018 18:33:36 +0530
Message-ID: <20180303130336.GA8210@seema-Inspiron-15-3567>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: dennis.dalessandro@intel.com
Cc: mike.marciniszyn@intel.com, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, outreachy-kernel@googlegroups.com
List-Id: linux-rdma@vger.kernel.org

Continue at the bottom of a loop are removed.
Issue found using drop_continue.cocci Coccinelle script.

Signed-off-by: Arushi Singhal <arushisinghal19971997@gmail.com>
---
 drivers/infiniband/hw/qib/qib_init.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/infiniband/hw/qib/qib_init.c b/drivers/infiniband/hw/qib/qib_init.c
index 3990f38..1bd3b32 100644
--- a/drivers/infiniband/hw/qib/qib_init.c
+++ b/drivers/infiniband/hw/qib/qib_init.c
@@ -681,7 +681,6 @@ int qib_init(struct qib_devdata *dd, int reinit)
 		if (lastfail) {
 			qib_dev_err(dd,
 				"failed to allocate kernel ctxt's rcvhdrq and/or egr bufs\n");
-			continue;
 		}
 	}
 
-- 
2.7.4
