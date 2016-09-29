From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V1 rdma-core 1/5] Remove container_of and offset local declarations
Date: Thu, 29 Sep 2016 14:10:58 +0300
Message-ID: <1475147462-803-2-git-send-email-yishaih@mellanox.com>
References: <1475147462-803-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1475147462-803-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This tree uses the version of container_of in infinband/verbs.h,
and requires stddef.h to declare offsetof.

Signed-off-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 ibacm/linux/osd.h   |  3 ---
 libibcm/src/cm.c    |  5 -----
 libmlx5/src/list.h  | 19 -------------------
 librdmacm/src/cma.h |  6 ------
 4 files changed, 33 deletions(-)

diff --git a/ibacm/linux/osd.h b/ibacm/linux/osd.h
index 5ca4c6f..0113d10 100644
--- a/ibacm/linux/osd.h
+++ b/ibacm/linux/osd.h
@@ -53,9 +53,6 @@
 #define LIB_DESTRUCTOR __attribute__((destructor))
 #define CDECL_FUNC
 
-#define container_of(ptr, type, field) \
-	((type *) ((void *) ptr - offsetof(type, field)))
-
 #define min(a, b) (a < b ? a : b)
 #define max(a, b) (a > b ? a : b)
 
diff --git a/libibcm/src/cm.c b/libibcm/src/cm.c
index 5c56381..f5318f0 100644
--- a/libibcm/src/cm.c
+++ b/libibcm/src/cm.c
@@ -121,11 +121,6 @@ struct cm_id_private {
 	pthread_mutex_t mut;
 };
 
-#ifndef container_of
-#define container_of(ptr, type, field) \
-	((type *) ((void *)ptr - offsetof(type, field)))
-#endif
-
 static int check_abi_version(void)
 {
 	char value[8];
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
index 98eba8d..e773591 100644
--- a/librdmacm/src/cma.h
+++ b/librdmacm/src/cma.h
@@ -71,12 +71,6 @@ static inline uint64_t ntohll(uint64_t x) { return x; }
 #define max(a, b) ((a) > (b) ? a : b)
 #define min(a, b) ((a) < (b) ? a : b)
 
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
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
