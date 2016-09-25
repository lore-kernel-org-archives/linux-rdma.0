From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-core 3/5] utils: Remove container_of and offset local declarations
Date: Sun, 25 Sep 2016 09:50:05 +0300
Message-ID: <1474786207-2149-4-git-send-email-leon@kernel.org>
References: <1474786207-2149-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1474786207-2149-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 ibacm/linux/osd.h   |  3 ---
 libmlx5/src/list.h  | 19 -------------------
 librdmacm/src/cma.h |  6 ------
 3 files changed, 28 deletions(-)

diff --git a/ibacm/linux/osd.h b/ibacm/linux/osd.h
index ec18f7b..1a738e0 100644
--- a/ibacm/linux/osd.h
+++ b/ibacm/linux/osd.h
@@ -55,9 +55,6 @@
 #define LIB_DESTRUCTOR __attribute__((destructor))
 #define CDECL_FUNC
 
-#define container_of(ptr, type, field) \
-	((type *) ((void *) ptr - offsetof(type, field)))
-
 #if __BYTE_ORDER == __LITTLE_ENDIAN
 #define htonll(x) bswap_64(x)
 #else
diff --git a/libmlx5/src/list.h b/libmlx5/src/list.h
index cd7d25b..4f96482 100644
--- a/libmlx5/src/list.h
+++ b/libmlx5/src/list.h
@@ -201,25 +201,6 @@ static inline void list_splice_init(struct list_head *list,
 	}
 }
 
-#ifndef offsetof
-#define offsetof(TYPE, MEMBER) ((size_t) &((TYPE *)0)->MEMBER)
-#endif
-
-/**
- * container_of - cast a member of a structure out to the containing structure
- *
- * @ptr:        the pointer to the member.
- * @type:       the type of the container struct this is embedded in.
- * @member:     the name of the member within the struct.
- *
- */
-#ifndef container_of
-#define container_of(ptr, type, member) ({			\
-	const typeof(((type *)0)->member)*__mptr = (ptr);	\
-	(type *)((char *)__mptr - offsetof(type, member)); })
-#endif	
-
-
 /**
  * list_entry - get the struct for this entry
  * @ptr:	the &struct list_head pointer.
diff --git a/librdmacm/src/cma.h b/librdmacm/src/cma.h
index d640688..83d98b0 100644
--- a/librdmacm/src/cma.h
+++ b/librdmacm/src/cma.h
@@ -70,12 +70,6 @@ static inline uint64_t htonll(uint64_t x) { return x; }
 static inline uint64_t ntohll(uint64_t x) { return x; }
 #endif
 
-#ifndef container_of
-#define container_of(ptr, type, field) \
-	((type *) ((void *)ptr - offsetof(type, field)))
-#endif
-
-
 /*
  * Fast synchronization for low contention locking.
  */
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
