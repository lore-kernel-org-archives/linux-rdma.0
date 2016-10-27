From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-rc 1/6] IB/uverbs: Fix leak of XRC target QPs
Date: Thu, 27 Oct 2016 16:36:26 +0300
Message-ID: <1477575391-20134-2-git-send-email-leon@kernel.org>
References: <1477575391-20134-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1477575391-20134-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tariq Toukan <tariqt-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Tariq Toukan <tariqt-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

The real QP is destroyed in case of the ref count reaches zero, but
for XRC target QPs this call was missed and caused to QP leaks.

Let's call to destroy for all flows.

Fixes: 0e0ec7e0638e ('RDMA/core: Export ib_open_qp() to share XRC...')
Signed-off-by: Tariq Toukan <tariqt-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/core/uverbs_main.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index 0012fa5..44b1104 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -262,12 +262,9 @@ static int ib_uverbs_cleanup_ucontext(struct ib_uverbs_file *file,
 			container_of(uobj, struct ib_uqp_object, uevent.uobject);
 
 		idr_remove_uobj(&ib_uverbs_qp_idr, uobj);
-		if (qp != qp->real_qp) {
-			ib_close_qp(qp);
-		} else {
+		if (qp == qp->real_qp)
 			ib_uverbs_detach_umcast(qp, uqp);
-			ib_destroy_qp(qp);
-		}
+		ib_destroy_qp(qp);
 		ib_uverbs_release_uevent(file, &uqp->uevent);
 		kfree(uqp);
 	}
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
