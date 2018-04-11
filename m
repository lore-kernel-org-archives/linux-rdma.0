From: Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [PATCH 1/3] infiniband: i40iw: Replace GFP_ATOMIC with GFP_KERNEL in i40iw_add_mqh_4
Date: Wed, 11 Apr 2018 15:32:25 +0800
Message-ID: <1523431945-3508-1-git-send-email-baijiaju1990@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: faisal.latif@intel.com, shiraz.saleem@intel.com, dledford@redhat.com, sean.hefty@intel.com, hal.rosenstock@gmail.com
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, Jia-Ju Bai <baijiaju1990@gmail.com>
List-Id: linux-rdma@vger.kernel.org

i40iw_add_mqh_4() is never called in atomic context, because it 
calls rtnl_lock() that can sleep.

Despite never getting called from atomic context,
i40iw_add_mqh_4() calls kzalloc() with GFP_ATOMIC,
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
index 5230dd3..4e79af5 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_cm.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_cm.c
@@ -1758,7 +1758,7 @@ static enum i40iw_status_code i40iw_add_mqh_4(
 					    &ifa->ifa_address,
 					    rdma_vlan_dev_vlan_id(dev),
 					    dev->dev_addr);
-				child_listen_node = kzalloc(sizeof(*child_listen_node), GFP_ATOMIC);
+				child_listen_node = kzalloc(sizeof(*child_listen_node), GFP_KERNEL);
 				cm_parent_listen_node->cm_core->stats_listen_nodes_created++;
 				i40iw_debug(&iwdev->sc_dev,
 					    I40IW_DEBUG_CM,
-- 
1.9.1
