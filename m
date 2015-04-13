From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v1 1/2] IB/core: disallow registering 0-sized memory region
Date: Mon, 13 Apr 2015 14:56:22 +0200
Message-ID: <0e246088b73c1eb19fb4cc20a1aefcb08919087d.1428929103.git.ydroneaud@opteya.com>
References: <cover.1428929103.git.ydroneaud@opteya.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1428929103.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
In-Reply-To: <cover.1428929103.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
References: <cover.1428929103.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jack Morgenstein <jackm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

If ib_umem_get() is called with a size equal to 0 and an
non-page aligned address, one page will be pinned and a
0-sized umem will be returned to the caller.

This should not be allowed: it's not expected for a memory
region to have a size equal to 0.

This patch adds a check to explicitly refuse to register
a 0-sized region.

Link: http://mid.gmane.org/cover.1428929103.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org
Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Jack Morgenstein <jackm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/core/umem.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/infiniband/core/umem.c b/drivers/infiniband/core/umem.c
index 8c014b5dab4c..9ac4068d2088 100644
--- a/drivers/infiniband/core/umem.c
+++ b/drivers/infiniband/core/umem.c
@@ -99,6 +99,9 @@ struct ib_umem *ib_umem_get(struct ib_ucontext *context, unsigned long addr,
 	if (dmasync)
 		dma_set_attr(DMA_ATTR_WRITE_BARRIER, &attrs);
 
+	if (!size)
+		return ERR_PTR(-EINVAL);
+
 	/*
 	 * If the combination of the addr and size requested for this memory
 	 * region causes an integer overflow, return error.
-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
