From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-rc 14/15] IB/uverbs: Fix unbalanced unlock on error path for rdma_explicit_destroy
Date: Tue, 13 Feb 2018 12:18:40 +0200
Message-ID: <20180213101841.20101-15-leon@kernel.org>
References: <20180213101841.20101-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180213101841.20101-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Alaa Hleihel <alaa-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

If remove_commit fails then the lock is left locked while the uobj still
exists. Eventually the kernel will deadlock.

lockdep detects this and says:

 test/4221 is leaving the kernel with locks still held!
 1 lock held by test/4221:
  #0:  (&ucontext->cleanup_rwsem){.+.+}, at: [<000000001e5c7523>] rdma_explicit_destroy+0x37/0x120 [ib_uverbs]

Fixes: 4da70da23e9b ("IB/core: Explicitly destroy an object while keeping uobject")
Signed-off-by: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/core/rdma_core.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/rdma_core.c b/drivers/infiniband/core/rdma_core.c
index 1cb6849b2231..e2c2aa424e4d 100644
--- a/drivers/infiniband/core/rdma_core.c
+++ b/drivers/infiniband/core/rdma_core.c
@@ -484,12 +484,13 @@ int rdma_explicit_destroy(struct ib_uobject *uobject)
 	ret = uobject->type->type_class->remove_commit(uobject,
 						       RDMA_REMOVE_DESTROY);
 	if (ret)
-		return ret;
+		goto out;
 
 	uobject->type = &null_obj_type;
 
+out:
 	up_read(&ucontext->cleanup_rwsem);
-	return 0;
+	return ret;
 }
 
 static void alloc_commit_idr_uobject(struct ib_uobject *uobj)
-- 
2.16.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
