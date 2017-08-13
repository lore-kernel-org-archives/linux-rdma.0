From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH] IB/core: fix duplicated code for different branches
Date: Sat, 12 Aug 2017 19:52:35 -0500
Message-ID: <20170813005235.GA30629@embeddedgus>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, "Gustavo A. R. Silva" <gustavo@embeddedor.com>
List-Id: linux-rdma@vger.kernel.org

Refactor code to avoid identical code for different branches.

This issue was detected with the help of Coccinelle.

Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/infiniband/core/cm.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
index 2b4d613..b46262f 100644
--- a/drivers/infiniband/core/cm.c
+++ b/drivers/infiniband/core/cm.c
@@ -590,8 +590,6 @@ static struct cm_id_private * cm_insert_listen(struct cm_id_private *cm_id_priv)
 			link = &(*link)->rb_right;
 		else if (be64_lt(service_id, cur_cm_id_priv->id.service_id))
 			link = &(*link)->rb_left;
-		else if (be64_gt(service_id, cur_cm_id_priv->id.service_id))
-			link = &(*link)->rb_right;
 		else
 			link = &(*link)->rb_right;
 	}
@@ -619,8 +617,6 @@ static struct cm_id_private * cm_find_listen(struct ib_device *device,
 			node = node->rb_right;
 		else if (be64_lt(service_id, cm_id_priv->id.service_id))
 			node = node->rb_left;
-		else if (be64_gt(service_id, cm_id_priv->id.service_id))
-			node = node->rb_right;
 		else
 			node = node->rb_right;
 	}
-- 
2.5.0
