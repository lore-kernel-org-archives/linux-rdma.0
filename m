From: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>
Subject: [PATCH libibverbs] Allow use of huge pages in multiple calls to ibv_fork_init
Date: Wed,  3 Feb 2016 13:42:42 +0200
Message-ID: <1454499762-29819-1-git-send-email-leon@leon.nu>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: yosefe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Setting the environment variable RDMAV_HUGEPAGES_SAFE tells the library
to check the underlying page size used by the kernel for memory regions.
This is required if an application uses huge pages either directly or
indirectly via a library such as libhugetlbfs.

The check of this variable was performed at the first call to
ibv_fork_init. This caused to unpredicted behavior in complex
applications with multiple underlying libraries.

The proposed change will allow support of huge pages without relying on
ibv_fork_init calls order.

Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 src/memory.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/src/memory.c b/src/memory.c
index e9d1eecd9eab..89509c6e356f 100644
--- a/src/memory.c
+++ b/src/memory.c
@@ -140,6 +140,9 @@ int ibv_fork_init(void)
 	int ret;
 	unsigned long size;
 
+	if (getenv("RDMAV_HUGEPAGES_SAFE"))
+		huge_page_enabled = 1;
+
 	if (mm_root)
 		return 0;
 
@@ -153,11 +156,6 @@ int ibv_fork_init(void)
 	if (posix_memalign(&tmp, page_size, page_size))
 		return ENOMEM;
 
-	if (getenv("RDMAV_HUGEPAGES_SAFE"))
-		huge_page_enabled = 1;
-	else
-		huge_page_enabled = 0;
-
 	if (huge_page_enabled) {
 		size = get_page_size(tmp);
 		tmp_aligned = (void *) ((uintptr_t) tmp & ~(size - 1));
-- 
1.7.12.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
