From: Fabian Frederick <fabf-AgBVmzD5pcezQB+pC5nmwQ@public.gmane.org>
Subject: [PATCH 1/1 linux-next] IB/mthca: use swap() in mthca_make_profile()
Date: Wed, 10 Jun 2015 18:31:51 +0200
Message-ID: <1433953911-23735-1-git-send-email-fabf@skynet.be>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Julia Lawall <Julia.Lawall-L2FTfq7BK8M@public.gmane.org>, Fabian Frederick <fabf-AgBVmzD5pcezQB+pC5nmwQ@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Use kernel.h macro definition.

Thanks to Julia Lawall for Coccinelle scripting support.

Signed-off-by: Fabian Frederick <fabf-AgBVmzD5pcezQB+pC5nmwQ@public.gmane.org>
---
 drivers/infiniband/hw/mthca/mthca_profile.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/mthca/mthca_profile.c b/drivers/infiniband/hw/mthca/mthca_profile.c
index 8edb28a..15d0644 100644
--- a/drivers/infiniband/hw/mthca/mthca_profile.c
+++ b/drivers/infiniband/hw/mthca/mthca_profile.c
@@ -77,7 +77,6 @@ s64 mthca_make_profile(struct mthca_dev *dev,
 	u64 mem_base, mem_avail;
 	s64 total_size = 0;
 	struct mthca_resource *profile;
-	struct mthca_resource tmp;
 	int i, j;
 
 	profile = kzalloc(MTHCA_RES_NUM * sizeof *profile, GFP_KERNEL);
@@ -136,11 +135,8 @@ s64 mthca_make_profile(struct mthca_dev *dev,
 	 */
 	for (i = MTHCA_RES_NUM; i > 0; --i)
 		for (j = 1; j < i; ++j) {
-			if (profile[j].size > profile[j - 1].size) {
-				tmp            = profile[j];
-				profile[j]     = profile[j - 1];
-				profile[j - 1] = tmp;
-			}
+			if (profile[j].size > profile[j - 1].size)
+				swap(profile[j], profile[j - 1]);
 		}
 
 	for (i = 0; i < MTHCA_RES_NUM; ++i) {
-- 
2.4.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
