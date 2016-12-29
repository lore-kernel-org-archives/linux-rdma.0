From: Kenneth Lee <liguozhu-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org>
Subject: [PATCH v2] ib umem: bugfix: mixed put_pid()s in ib_umem_get()
Date: Thu, 29 Dec 2016 16:27:28 +0800
Message-ID: <1483000048-183875-1-git-send-email-liguozhu@hisilicon.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: robin.murphy-5wv7dgnIgG8@public.gmane.org, jroedel-l3A5Bk7waGM@public.gmane.org, egtvedt-BrfabpQBY5qlHtIdYg32fQ@public.gmane.org, vgupta-HKixBCOQz3hWk0Htik3J/w@public.gmane.org, liguozhu-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org, dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, lstoakes-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, krzk-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, sebott-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

There are two bugfixes in this patch:

1. When the execution go to the ib_umem_odp_get() path, pid should be put
   back.
2. When the memory allocation fail, the pid also should be put back before
   exit.

Signed-off-by: Kenneth Lee <liguozhu-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org>
Reviewed-by: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
Change from v1 to v2:
  Correcting the patch title and description

 drivers/infiniband/core/umem.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/infiniband/core/umem.c b/drivers/infiniband/core/umem.c
index 1e62a5f..4609b92 100644
--- a/drivers/infiniband/core/umem.c
+++ b/drivers/infiniband/core/umem.c
@@ -134,6 +134,7 @@ struct ib_umem *ib_umem_get(struct ib_ucontext *context, unsigned long addr,
 		 IB_ACCESS_REMOTE_ATOMIC | IB_ACCESS_MW_BIND));
 
 	if (access & IB_ACCESS_ON_DEMAND) {
+		put_pid(umem->pid);
 		ret = ib_umem_odp_get(context, umem);
 		if (ret) {
 			kfree(umem);
@@ -149,6 +150,7 @@ struct ib_umem *ib_umem_get(struct ib_ucontext *context, unsigned long addr,
 
 	page_list = (struct page **) __get_free_page(GFP_KERNEL);
 	if (!page_list) {
+		put_pid(umem->pid);
 		kfree(umem);
 		return ERR_PTR(-ENOMEM);
 	}
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
