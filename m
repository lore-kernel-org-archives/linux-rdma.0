From: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] opensm/complib/cl_passivelock.h: remove unneeded casting
Date: Thu, 04 Feb 2010 16:14:41 +0200
Message-ID: <4B6AD651.3080303@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

After converting cl_status_t from enum to int,
no need to do this casting any more.

Signed-off-by: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
---

Note: this patch replaces the following patch:
 "[PATCH v3] opensm/complib/cl_passivelock.h: some casting issues"

 opensm/include/complib/cl_passivelock.h |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/opensm/include/complib/cl_passivelock.h b/opensm/include/complib/cl_passivelock.h
index bafd339..aea3bab 100644
--- a/opensm/include/complib/cl_passivelock.h
+++ b/opensm/include/complib/cl_passivelock.h
@@ -1,6 +1,6 @@
 /*
  * Copyright (c) 2004, 2005 Voltaire, Inc. All rights reserved.
- * Copyright (c) 2002-2005 Mellanox Technologies LTD. All rights reserved.
+ * Copyright (c) 2002-2010 Mellanox Technologies LTD. All rights reserved.
  * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
  *
  * This software is available to you under a choice of one of two
@@ -196,7 +196,7 @@ static inline cl_status_t cl_plock_init(IN cl_plock_t * const p_lock)
 	cl_status_t status;

 	CL_ASSERT(p_lock);
-	status = (cl_status_t) pthread_rwlock_init(&p_lock->lock, NULL);
+	status = pthread_rwlock_init(&p_lock->lock, NULL);
 	if (status)
 		return CL_ERROR;
 	p_lock->state = CL_INITIALIZED;
@@ -238,7 +238,7 @@ static inline void cl_plock_acquire(IN cl_plock_t * const p_lock)
 	CL_ASSERT(p_lock);
 	CL_ASSERT(p_lock->state == CL_INITIALIZED);

-	status = (cl_status_t) pthread_rwlock_rdlock(&p_lock->lock);
+	status = pthread_rwlock_rdlock(&p_lock->lock);
 	CL_ASSERT(status == 0);
 }

@@ -271,7 +271,7 @@ static inline void cl_plock_excl_acquire(IN cl_plock_t * const p_lock)
 	CL_ASSERT(p_lock);
 	CL_ASSERT(p_lock->state == CL_INITIALIZED);

-	status = (cl_status_t) pthread_rwlock_wrlock(&p_lock->lock);
+	status = pthread_rwlock_wrlock(&p_lock->lock);
 	CL_ASSERT(status == 0);
 }

@@ -303,7 +303,7 @@ static inline void cl_plock_release(IN cl_plock_t * const p_lock)
 	CL_ASSERT(p_lock);
 	CL_ASSERT(p_lock->state == CL_INITIALIZED);

-	status = (cl_status_t) pthread_rwlock_unlock(&p_lock->lock);
+	status = pthread_rwlock_unlock(&p_lock->lock);
 	CL_ASSERT(status == 0);
 }

-- 
1.5.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
