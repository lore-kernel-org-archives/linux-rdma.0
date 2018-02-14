From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-rc 1/4] RDMA/restrack: Increment CQ restrack object before committing
Date: Wed, 14 Feb 2018 12:35:37 +0200
Message-ID: <20180214103540.22374-2-leon@kernel.org>
References: <20180214103540.22374-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180214103540.22374-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Once the uobj is committed it is immediately possible another thread
could destroy it, which worst case, can result in a use-after-free
of the restrack objects.

Cc: syzkaller <syzkaller-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
Fixes: 08f294a1524b ("RDMA/core: Add resource tracking for create and destroy CQs")
Reported-by: Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/uverbs_cmd.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 256934d1f64f..4e55f8325049 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -1030,14 +1030,14 @@ static struct ib_ucq_object *create_cq(struct ib_uverbs_file *file,
 	resp.response_length = offsetof(typeof(resp), response_length) +
 		sizeof(resp.response_length);
 
+	cq->res.type = RDMA_RESTRACK_CQ;
+	rdma_restrack_add(&cq->res);
+
 	ret = cb(file, obj, &resp, ucore, context);
 	if (ret)
 		goto err_cb;
 
 	uobj_alloc_commit(&obj->uobject);
-	cq->res.type = RDMA_RESTRACK_CQ;
-	rdma_restrack_add(&cq->res);
-
 	return obj;
 
 err_cb:
-- 
2.16.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
