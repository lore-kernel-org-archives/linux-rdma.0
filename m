From: akpm@linux-foundation.org
Subject: [patch 1/1] drivers/infiniband/core/verbs.c: fix build
 with gcc-4.4.4
Date: Tue, 13 Mar 2018 14:51:57 -0700
Message-ID: <20180313215157.GL3mSm-p6%akpm@linux-foundation.org>
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: akpm@linux-foundation.org, bart.vanassche@wdc.com, jgg@mellanox.com, linux-rdma@vger.kernel.org, sagi@grimberg.me, stable@vger.kernel.org, swise@opengridcomputing.com
List-Id: linux-rdma@vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>
Subject: drivers/infiniband/core/verbs.c: fix build with gcc-4.4.4

gcc-4.4.4 has issues with initialization of anonymous unions.

drivers/infiniband/core/verbs.c: In function '__ib_drain_sq':
drivers/infiniband/core/verbs.c:2204: error: unknown field 'wr_cqe' specified in initializer
drivers/infiniband/core/verbs.c:2204: warning: initialization makes integer from pointer without a cast

Work around this.

Fixes: a1ae7d0345edd5 ("RDMA/core: Avoid that ib_drain_qp() triggers an out-of-bounds stack access")
Cc: Bart Van Assche <bart.vanassche@wdc.com>
Cc: Steve Wise <swise@opengridcomputing.com>
Cc: Sagi Grimberg <sagi@grimberg.me>
Cc: Jason Gunthorpe <jgg@mellanox.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/infiniband/core/verbs.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/infiniband/core/verbs.c~drivers-infiniband-core-verbsc-fix-build-with-gcc-444 drivers/infiniband/core/verbs.c
--- a/drivers/infiniband/core/verbs.c~drivers-infiniband-core-verbsc-fix-build-with-gcc-444
+++ a/drivers/infiniband/core/verbs.c
@@ -2200,8 +2200,9 @@ static void __ib_drain_sq(struct ib_qp *
 	struct ib_send_wr *bad_swr;
 	struct ib_rdma_wr swr = {
 		.wr = {
+			.next = NULL,
+			{ .wr_cqe	= &sdrain.cqe, },
 			.opcode	= IB_WR_RDMA_WRITE,
-			.wr_cqe	= &sdrain.cqe,
 		},
 	};
 	int ret;
_
