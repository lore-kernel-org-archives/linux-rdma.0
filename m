From: Hakon Bugge <Haakon.Bugge-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 2/2] IB/mlx4: Fix incorrect order of formal and actual parameters
Date: Fri, 28 Apr 2017 13:06:54 +0200
Message-ID: <20170428110654.13176-3-Haakon.Bugge@oracle.com>
References: <20170428110654.13176-1-Haakon.Bugge@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170428110654.13176-1-Haakon.Bugge-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Hakon Bugge <Haakon.Bugge-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, =?UTF-8?q?H=C3=A5kon=20Bugge?= <haakon.bugge-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The last two actual parameters when calling id_map_find_by_sl_id()
from id_map_get() are swapped. However, the same formal parameters to
id_map_get() have them swapped as well, inverting the effect of the
first error.

Hence, this commit is a non-functional fix, improving readability.

Signed-off-by: Håkon Bugge <haakon.bugge-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Reviewed-by: Wengang Wang <wen.gang.wang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Reviewed-by: Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/cm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/cm.c b/drivers/infiniband/hw/mlx4/cm.c
index 61f63fe..1e6c526 100644
--- a/drivers/infiniband/hw/mlx4/cm.c
+++ b/drivers/infiniband/hw/mlx4/cm.c
@@ -279,14 +279,14 @@ id_map_alloc(struct ib_device *ibdev, int slave_id, u32 sl_cm_id)
 }
 
 static struct id_map_entry *
-id_map_get(struct ib_device *ibdev, int *pv_cm_id, int sl_cm_id, int slave_id)
+id_map_get(struct ib_device *ibdev, int *pv_cm_id, int slave_id, int sl_cm_id)
 {
 	struct id_map_entry *ent;
 	struct mlx4_ib_sriov *sriov = &to_mdev(ibdev)->sriov;
 
 	spin_lock(&sriov->id_map_lock);
 	if (*pv_cm_id == -1) {
-		ent = id_map_find_by_sl_id(ibdev, sl_cm_id, slave_id);
+		ent = id_map_find_by_sl_id(ibdev, slave_id, sl_cm_id);
 		if (ent)
 			*pv_cm_id = (int) ent->pv_cm_id;
 	} else
-- 
2.9.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
