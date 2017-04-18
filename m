From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 4/6] IB/core: A small refactor in destroy WQ handler
Date: Tue, 18 Apr 2017 12:03:40 +0300
Message-ID: <1492506222-28999-5-git-send-email-matanb@mellanox.com>
References: <1492506222-28999-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1492506222-28999-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Instead of having uverbs_uobject_put both in the error flow and the
good flow, we unite them.

Fixes: fd3c7904db6e ('IB/core: Change idr objects to use the new schema')
Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/uverbs_cmd.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index b9024fa..66cb22e 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -2989,18 +2989,12 @@ int ib_uverbs_ex_destroy_wq(struct ib_uverbs_file *file,
 	uverbs_uobject_get(uobj);
 
 	ret = uobj_remove_commit(uobj);
-	if (ret) {
-		uverbs_uobject_put(uobj);
-		return ret;
-	}
-
 	resp.events_reported = obj->uevent.events_reported;
 	uverbs_uobject_put(uobj);
-	ret = ib_copy_to_udata(ucore, &resp, resp.response_length);
 	if (ret)
 		return ret;
 
-	return 0;
+	return ib_copy_to_udata(ucore, &resp, resp.response_length);
 }
 
 int ib_uverbs_ex_modify_wq(struct ib_uverbs_file *file,
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
