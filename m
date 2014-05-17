From: Rickard Strandqvist <rickard_strandqvist-IW2WV5XWFqGZkjO+N0TKoMugMpMbD5Xr@public.gmane.org>
Subject: [PATCH] infiniband: hw: ehca: ehca_mrmw.c:  Fix for possible null pointer dereference
Date: Sat, 17 May 2014 19:15:26 +0200
Message-ID: <1400346926-25235-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hoang-Nam Nguyen <hnguyen-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Christoph Raisch <raisch-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>
Cc: Rickard Strandqvist <rickard_strandqvist-IW2WV5XWFqGZkjO+N0TKoMugMpMbD5Xr@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

There is otherwise a risk of a possible null pointer dereference.

Was largely found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist-IW2WV5XWFqGZkjO+N0TKoMugMpMbD5Xr@public.gmane.org>
---
 drivers/infiniband/hw/ehca/ehca_mrmw.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/ehca/ehca_mrmw.c b/drivers/infiniband/hw/ehca/ehca_mrmw.c
index 3488e8c..1fe4344 100644
--- a/drivers/infiniband/hw/ehca/ehca_mrmw.c
+++ b/drivers/infiniband/hw/ehca/ehca_mrmw.c
@@ -316,9 +316,8 @@ struct ib_mr *ehca_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 {
 	struct ib_mr *ib_mr;
 	struct ehca_mr *e_mr;
-	struct ehca_shca *shca =
-		container_of(pd->device, struct ehca_shca, ib_device);
-	struct ehca_pd *e_pd = container_of(pd, struct ehca_pd, ib_pd);
+	struct ehca_shca *shca;
+	struct ehca_pd *e_pd;
 	struct ehca_mr_pginfo pginfo;
 	int ret, page_shift;
 	u32 num_kpages;
@@ -330,6 +329,9 @@ struct ib_mr *ehca_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 		return ERR_PTR(-EFAULT);
 	}
 
+	shca = container_of(pd->device, struct ehca_shca, ib_device);
+	e_pd = container_of(pd, struct ehca_pd, ib_pd);
+
 	if (((mr_access_flags & IB_ACCESS_REMOTE_WRITE) &&
 	     !(mr_access_flags & IB_ACCESS_LOCAL_WRITE)) ||
 	    ((mr_access_flags & IB_ACCESS_REMOTE_ATOMIC) &&
-- 
1.7.10.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
