From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [rdma-next v1 12/22] RDMA/mthca: Make explicit conversion to 64bit value
Date: Sun, 13 Aug 2017 13:18:06 +0300
Message-ID: <20170813101816.3120-13-leon@kernel.org>
References: <20170813101816.3120-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170813101816.3120-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

The "lg" variable is declared as int so in all places where
this variable is used as a shift operand, the output will be
int too.

This produces the following smatch warning:
drivers/infiniband/hw/mthca/mthca_cmd.c:701 mthca_map_cmd() warn:
	should '1 << lg' be a 64 bit type?

Simple declaration of "1" to be "1ULL" will fix the issue.

Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
---
 drivers/infiniband/hw/mthca/mthca_cmd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mthca/mthca_cmd.c b/drivers/infiniband/hw/mthca/mthca_cmd.c
index e19ae0b9b439..89529d204178 100644
--- a/drivers/infiniband/hw/mthca/mthca_cmd.c
+++ b/drivers/infiniband/hw/mthca/mthca_cmd.c
@@ -698,7 +698,7 @@ static int mthca_map_cmd(struct mthca_dev *dev, u16 op, struct mthca_icm *icm,
 		for (i = 0; i < mthca_icm_size(&iter) >> lg; ++i) {
 			if (virt != -1) {
 				pages[nent * 2] = cpu_to_be64(virt);
-				virt += 1 << lg;
+				virt += 1ULL << lg;
 			}
 
 			pages[nent * 2 + 1] =
-- 
2.14.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
