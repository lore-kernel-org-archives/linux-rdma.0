From: Arushi Singhal <arushisinghal19971997@gmail.com>
Subject: [PATCH v2] infiniband: hw: Drop unnecessary continue
Date: Sat, 3 Mar 2018 21:54:57 +0530
Message-ID: <20180303162457.GA21730@seema-Inspiron-15-3567>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: dennis.dalessandro@intel.com
Cc: Mike Marciniszyn <mike.marciniszyn@intel.com>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, outreachy-kernel@googlegroups.com
List-Id: linux-rdma@vger.kernel.org

Continue at the bottom of a loop are removed.
Issue found using drop_continue.cocci Coccinelle script.

Signed-off-by: Arushi Singhal <arushisinghal19971997@gmail.com>
---
Changes in v2:
- Braces is dropped from if with single statement.

 drivers/infiniband/hw/qib/qib_init.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_init.c b/drivers/infiniband/hw/qib/qib_init.c
index 3990f38..6c68f8a 100644
--- a/drivers/infiniband/hw/qib/qib_init.c
+++ b/drivers/infiniband/hw/qib/qib_init.c
@@ -678,11 +678,9 @@ int qib_init(struct qib_devdata *dd, int reinit)
 		lastfail = qib_create_rcvhdrq(dd, rcd);
 		if (!lastfail)
 			lastfail = qib_setup_eagerbufs(rcd);
-		if (lastfail) {
+		if (lastfail)
 			qib_dev_err(dd,
 				"failed to allocate kernel ctxt's rcvhdrq and/or egr bufs\n");
-			continue;
-		}
 	}
 
 	for (pidx = 0; pidx < dd->num_pports; ++pidx) {
-- 
2.7.4
