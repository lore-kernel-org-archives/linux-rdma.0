From: Colin King <colin.king@canonical.com>
Subject: [PATCH][V2] RDMA/nes: do not leak uninitialized resp.reserved to userspace Content-Type: text/plain; charset="utf-8" Content-Transfer-Encoding: 8bit
Date: Mon,  4 Sep 2017 14:37:05 +0100
Message-ID: <20170904133705.3980-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: Faisal Latif <faisal.latif@intel.com>, Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, stable@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

resp.reserved has not been initialized and so the copy_to_user (via
ib_copy_to_udata) is copying uninitialized data from the stack back
to user space which is a potential information leak. Fix this by
initializing all of resp to zero.

V2: Initialize all of the struct rather than just resp.reserved as
suggested by Leon Romanovsky.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/infiniband/hw/nes/nes_verbs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/nes/nes_verbs.c b/drivers/infiniband/hw/nes/nes_verbs.c
index f0dc5f4aa177..8998d11449c0 100644
--- a/drivers/infiniband/hw/nes/nes_verbs.c
+++ b/drivers/infiniband/hw/nes/nes_verbs.c
@@ -1437,7 +1437,7 @@ static struct ib_cq *nes_create_cq(struct ib_device *ibdev,
 	struct nes_hw_cqp_wqe *cqp_wqe;
 	struct nes_pbl *nespbl = NULL;
 	struct nes_create_cq_req req;
-	struct nes_create_cq_resp resp;
+	struct nes_create_cq_resp resp = { 0 };
 	u32 cq_num = 0;
 	u32 opcode = 0;
 	u32 pbl_entries = 1;
-- 
2.14.1
