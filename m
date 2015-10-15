From: Sagi Grimberg <sagig@mellanox.com>
Subject: [PATCH] IB/srp: Fix possible send queue overflow
Date: Thu, 15 Oct 2015 12:26:46 +0300
Message-ID: <1444901206-27462-1-git-send-email-sagig@mellanox.com>
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: linux-rdma@vger.kernel.org
Cc: Stable <stable@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

When using work request based memory registration (fast_reg)
we must reserve SQ entries for registration and invalidation
in addition to send operations. Each IO consumes 3 SQ entries
(registration, send, invalidation) so we need to allocate 3x
larger send-queue instead of 2x.

Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
CC: Stable <stable@vger.kernel.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index d00f819..43b07f7 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -488,7 +488,7 @@ static int srp_create_ch_ib(struct srp_rdma_ch *ch)
 	struct ib_qp *qp;
 	struct ib_fmr_pool *fmr_pool = NULL;
 	struct srp_fr_pool *fr_pool = NULL;
-	const int m = 1 + dev->use_fast_reg;
+	const int m = dev->use_fast_reg ? 3 : 1;
 	struct ib_cq_init_attr cq_attr = {};
 	int ret;
 
-- 
1.7.1
