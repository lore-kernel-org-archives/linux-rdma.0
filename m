From: Colin King <colin.king@canonical.com>
Subject: [PATCH][next] IB/uverbs: fix an unsigned being compared to < 0
Date: Sat, 22 Dec 2018 13:25:51 +0000
Message-ID: <20181222132551.14696-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, Moni Shoua <monis@mellanox.com>, linux-rdma@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The check for num_sge < 0 is always false because num_sge is not signed,
fix this by declaring it as an int.

Detected by CoverityScan, CID#1476005 ("Unsigned compared against 0")

Fixes: ad8a4496757f ("IB/uverbs: Add support to advise_mr")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/infiniband/core/uverbs_std_types_mr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/uverbs_std_types_mr.c b/drivers/infiniband/core/uverbs_std_types_mr.c
index 71dfa5e5938e..4d4be0c2b752 100644
--- a/drivers/infiniband/core/uverbs_std_types_mr.c
+++ b/drivers/infiniband/core/uverbs_std_types_mr.c
@@ -47,7 +47,7 @@ static int UVERBS_HANDLER(UVERBS_METHOD_ADVISE_MR)(
 	enum ib_uverbs_advise_mr_advice advice;
 	struct ib_device *ib_dev = pd->device;
 	struct ib_sge *sg_list;
-	u32 num_sge;
+	int num_sge;
 	u32 flags;
 	int ret;
 
-- 
2.19.1
