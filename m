From: akpm@linux-foundation.org
Subject: [patch 1/1] drivers/infiniband/ulp/srpt/ib_srpt.c: fix
 build with gcc-4.4.4
Date: Tue, 13 Mar 2018 15:06:45 -0700
Message-ID: <20180313220645.lyDF5eYS4%akpm@linux-foundation.org>
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: akpm@linux-foundation.org, bart.vanassche@wdc.com, hch@lst.de, jgg@mellanox.com, linux-rdma@vger.kernel.org, stable@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>
Subject: drivers/infiniband/ulp/srpt/ib_srpt.c: fix build with gcc-4.4.4

gcc-4.4.4 has issues with initialization of anonymous unions:

drivers/infiniband/ulp/srpt/ib_srpt.c: In function 'srpt_zerolength_write':
drivers/infiniband/ulp/srpt/ib_srpt.c:854: error: unknown field 'wr_cqe' specified in initializer
drivers/infiniband/ulp/srpt/ib_srpt.c:854: warning: initialization makes integer from pointer without a cast

Work aound this.

Fixes: 2a78cb4db487 ("IB/srpt: Fix an out-of-bounds stack access in srpt_zerolength_write()")
Cc: Bart Van Assche <bart.vanassche@wdc.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Jason Gunthorpe <jgg@mellanox.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/infiniband/ulp/srpt/ib_srpt.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/infiniband/ulp/srpt/ib_srpt.c~drivers-infiniband-ulp-srpt-ib_srptc-fix-build-with-gcc-444 drivers/infiniband/ulp/srpt/ib_srpt.c
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c~drivers-infiniband-ulp-srpt-ib_srptc-fix-build-with-gcc-444
+++ a/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -850,8 +850,9 @@ static int srpt_zerolength_write(struct
 	struct ib_send_wr *bad_wr;
 	struct ib_rdma_wr wr = {
 		.wr = {
+			.next		= NULL,
+			{ .wr_cqe	= &ch->zw_cqe, },
 			.opcode		= IB_WR_RDMA_WRITE,
-			.wr_cqe		= &ch->zw_cqe,
 			.send_flags	= IB_SEND_SIGNALED,
 		}
 	};
_
