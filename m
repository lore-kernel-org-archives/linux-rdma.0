From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [Patch] ib/mlx4: Fix build error on platforms where UL is not 64bit
Date: Tue, 16 Oct 2012 23:23:55 -0400
Message-ID: <6517a144c4ab826f66fcde6ac05cfd17d641811c.1350444206.git.dledford@redhat.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Line 110 uses UL as a compiler cast for the 0x constant, but
it's not large enough to hold a 64bit value on 32bit arches.
Use ULL instead.

Signed-off-by: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/alias_GUID.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/alias_GUID.c b/drivers/infiniband/hw/mlx4/alias_GUID.c
index d2fb38d..cb790a8 100644
--- a/drivers/infiniband/hw/mlx4/alias_GUID.c
+++ b/drivers/infiniband/hw/mlx4/alias_GUID.c
@@ -107,7 +107,7 @@ static __be64 get_cached_alias_guid(struct mlx4_ib_dev *dev, int port, int index
 {
 	if (index >= NUM_ALIAS_GUID_PER_PORT) {
 		pr_err("%s: ERROR: asked for index:%d\n", __func__, index);
-		return  (__force __be64) ((u64) 0xFFFFFFFFFFFFFFFFUL);
+		return  (__force __be64) ((u64) 0xFFFFFFFFFFFFFFFFULL);
 	}
 	return *(__be64 *)&dev->sriov.demux[port - 1].guid_cache[index];
 }
-- 
1.7.7.6

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
