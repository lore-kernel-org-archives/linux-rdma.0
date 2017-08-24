From: Colin King <colin.king@canonical.com>
Subject: [PATCH] RDMA/qedr: fix spelling mistake: "invlaid" -> "invalid"
Date: Thu, 24 Aug 2017 09:25:53 +0100
Message-ID: <20170824082553.18619-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Ram Amrani <Ram.Amrani@cavium.com>, Michal Kalderon <Michal.Kalderon@cavium.com>, Ariel Elior <Ariel.Elior@cavium.com>, Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Trivial fix to spelling mistake in DP_ERR error message

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/infiniband/hw/qedr/verbs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/qedr/verbs.c b/drivers/infiniband/hw/qedr/verbs.c
index 4e14a558734b..9612aaa9fbbb 100644
--- a/drivers/infiniband/hw/qedr/verbs.c
+++ b/drivers/infiniband/hw/qedr/verbs.c
@@ -510,7 +510,7 @@ struct ib_pd *qedr_alloc_pd(struct ib_device *ibdev,
 		 (udata && context) ? "User Lib" : "Kernel");
 
 	if (!dev->rdma_ctx) {
-		DP_ERR(dev, "invlaid RDMA context\n");
+		DP_ERR(dev, "invalid RDMA context\n");
 		return ERR_PTR(-EINVAL);
 	}
 
-- 
2.14.1
