From: Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [PATCH 2/3] infiniband: i40iw: Replace GFP_ATOMIC with GFP_KERNEL in i40iw_make_listen_node
Date: Wed, 11 Apr 2018 15:32:48 +0800
Message-ID: <1523431968-3552-1-git-send-email-baijiaju1990@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: faisal.latif@intel.com, shiraz.saleem@intel.com, dledford@redhat.com, sean.hefty@intel.com, hal.rosenstock@gmail.com
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, Jia-Ju Bai <baijiaju1990@gmail.com>
List-Id: linux-rdma@vger.kernel.org

i40iw_make_listen_node() is never called in atomic context.

i40iw_make_listen_node() is only called by i40iw_create_listen, which is 
set as ".create_listen" in struct iw_cm_verbs.

Despite never getting called from atomic context,
i40iw_make_listen_node() calls kzalloc() with GFP_ATOMIC,
which does not sleep for allocation.
GFP_ATOMIC is not necessary and can be replaced with GFP_KERNEL,
which can sleep and improve the possibility of sucessful allocation.

This is found by a static analysis tool named DCNS written by myself.
And I also manually check it.

Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
---
 drivers/infiniband/hw/i40iw/i40iw_cm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/i40iw/i40iw_cm.c b/drivers/infiniband/hw/i40iw/i40iw_cm.c
index 5230dd3..d021399 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_cm.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_cm.c
@@ -2834,7 +2834,7 @@ static struct i40iw_cm_listener *i40iw_make_listen_node(
 
 	if (!listener) {
 		/* create a CM listen node (1/2 node to compare incoming traffic to) */
-		listener = kzalloc(sizeof(*listener), GFP_ATOMIC);
+		listener = kzalloc(sizeof(*listener), GFP_KERNEL);
 		if (!listener)
 			return NULL;
 		cm_core->stats_listen_nodes_created++;
-- 
1.9.1
