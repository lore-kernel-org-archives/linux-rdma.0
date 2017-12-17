From: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH rdma-next 1/2] nes: Change accelerated flag to bool
Date: Sun, 17 Dec 2017 12:21:38 -0600
Message-ID: <20171217182139.17096-2-shiraz.saleem@intel.com>
References: <20171217182139.17096-1-shiraz.saleem@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171217182139.17096-1-shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jgg-uk2M96/98Pc@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The accelerated flag only utilizes two values: 0 and 1.
Modify accelerated flag in struct nes_cm_node to bool.

Signed-off-by: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/nes/nes_cm.c | 2 +-
 drivers/infiniband/hw/nes/nes_cm.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/nes/nes_cm.c b/drivers/infiniband/hw/nes/nes_cm.c
index c56ca2a..6cdfbf8 100644
--- a/drivers/infiniband/hw/nes/nes_cm.c
+++ b/drivers/infiniband/hw/nes/nes_cm.c
@@ -1365,7 +1365,7 @@ static int mini_cm_del_listen(struct nes_cm_core *cm_core,
 static inline int mini_cm_accelerated(struct nes_cm_core *cm_core,
 				      struct nes_cm_node *cm_node)
 {
-	cm_node->accelerated = 1;
+	cm_node->accelerated = true;
 
 	if (cm_node->accept_pend) {
 		BUG_ON(!cm_node->listener);
diff --git a/drivers/infiniband/hw/nes/nes_cm.h b/drivers/infiniband/hw/nes/nes_cm.h
index d827d03..d462797 100644
--- a/drivers/infiniband/hw/nes/nes_cm.h
+++ b/drivers/infiniband/hw/nes/nes_cm.h
@@ -341,7 +341,7 @@ struct nes_cm_node {
 	u16                       mpa_frame_size;
 	struct iw_cm_id           *cm_id;
 	struct list_head          list;
-	int                       accelerated;
+	bool                      accelerated;
 	struct nes_cm_listener    *listener;
 	enum nes_cm_conn_type     conn_type;
 	struct nes_vnic           *nesvnic;
-- 
2.8.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
