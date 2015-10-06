From: Jan Kara <jack-IBi9RG/b67k@public.gmane.org>
Subject: [PATCH 5/7] IB/mthca: Convert mthca_map_user_db() to use get_user_pages_fast()
Date: Tue,  6 Oct 2015 11:24:28 +0200
Message-ID: <1444123470-4932-6-git-send-email-jack@suse.com>
References: <1444123470-4932-1-git-send-email-jack@suse.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1444123470-4932-1-git-send-email-jack-IBi9RG/b67k@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>

Function mthca_map_user_db() appears to call get_user_pages() without
holding mmap_sem. Fix the bug by using get_user_pages_fast() instead
which also takes care of the locking.

CC: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
CC: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Signed-off-by: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
---
 drivers/infiniband/hw/mthca/mthca_memfree.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/mthca/mthca_memfree.c b/drivers/infiniband/hw/mthca/mthca_memfree.c
index 7d2e42dd6926..c3543b27a2a7 100644
--- a/drivers/infiniband/hw/mthca/mthca_memfree.c
+++ b/drivers/infiniband/hw/mthca/mthca_memfree.c
@@ -472,8 +472,7 @@ int mthca_map_user_db(struct mthca_dev *dev, struct mthca_uar *uar,
 		goto out;
 	}
 
-	ret = get_user_pages(current, current->mm, uaddr & PAGE_MASK, 1, 1, 0,
-			     pages, NULL);
+	ret = get_user_pages_fast(uaddr & PAGE_MASK, 1, 1, pages);
 	if (ret < 0)
 		goto out;
 
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
