From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] complib: replace intn_t types by C99 intptr_t
Date: Fri, 13 Nov 2009 18:06:26 +0200
Message-ID: <20091113160626.GQ7192@me>
References: <3F6F638B8D880340AB536D29CD4C1E1912C86E8A8F@orsmsx501.amr.corp.intel.com>
 <20091004001316.GK17846@me>
 <A6E929B3F38F455EB28EB478FBAF290E@amr.corp.intel.com>
 <20091112191811.GO7192@me>
 <81D21ED9D6F34BC1B7DA64F50EE5A7DD@amr.corp.intel.com>
 <20091112202257.GR7192@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20091112202257.GR7192@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Smith, Stan" <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


Use C99 standard pointer size integer types intptr_t and uintptr_t
instead of privately defined intn_t and uintn_t.

Signed-off-by: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
---
 opensm/complib/cl_pool.c              |    2 +-
 opensm/include/complib/cl_types.h     |   12 ++----------
 opensm/include/complib/cl_types_osd.h |    5 +----
 3 files changed, 4 insertions(+), 15 deletions(-)

diff --git a/opensm/complib/cl_pool.c b/opensm/complib/cl_pool.c
index 1f66284..5a8d637 100644
--- a/opensm/complib/cl_pool.c
+++ b/opensm/complib/cl_pool.c
@@ -128,7 +128,7 @@ cl_status_t cl_qcpool_init(IN cl_qcpool_t * const p_pool,
 		 * are aligned on a natural boundary.
 		 */
 		p_pool->component_sizes[i] =
-		    ROUNDUP(p_pool->component_sizes[i], sizeof(uintn_t));
+		    ROUNDUP(p_pool->component_sizes[i], sizeof(uintptr_t));
 	}
 
 	p_pool->max_objects = max_size ? max_size : ~(size_t) 0;
diff --git a/opensm/include/complib/cl_types.h b/opensm/include/complib/cl_types.h
index 84f629d..2891c6b 100644
--- a/opensm/include/complib/cl_types.h
+++ b/opensm/include/complib/cl_types.h
@@ -89,7 +89,7 @@ typedef uint64_t net64_t;
 *	The offsetof macro returns the offset of a member within a structure.
 *
 * SYNOPSIS
-*	uintn_t
+*	uintptr_t
 *	offsetof(
 *		IN TYPE,
 *		IN MEMBER );
@@ -110,7 +110,7 @@ typedef uint64_t net64_t;
 *	PARENT_STRUCT
 *********/
 #ifndef offsetof
-#define offsetof(TYPE, MEMBER) ((uintn_t) &((TYPE *)0)->MEMBER)
+#define offsetof(TYPE, MEMBER) ((uintptr_t) &((TYPE *)0)->MEMBER)
 #endif
 
 /****d* Component Library: Pointer Manipulation/PARENT_STRUCT
@@ -245,14 +245,6 @@ typedef uint64_t net64_t;
 *	net64_t
 *		64-bit network byte order value.
 *
-*	intn_t
-*		Signed natural sized integer.  32-bit on a 32-bit platform, 64-bit on
-*		a 64-bit platform.
-*
-*	uintn_t
-*		Unsigned natural sized integer.  32-bit on a 32-bit platform, 64-bit on
-*		a 64-bit platform.
-*
 *	boolean_t
 *		integral sized.  Set to TRUE or FALSE and used in logical expressions.
 *
diff --git a/opensm/include/complib/cl_types_osd.h b/opensm/include/complib/cl_types_osd.h
index d12aa4c..7c6e51d 100644
--- a/opensm/include/complib/cl_types_osd.h
+++ b/opensm/include/complib/cl_types_osd.h
@@ -37,8 +37,7 @@
  * Abstract:
  *	Defines sized datatypes for Linux User mode
  *  exported sizes are int8_t, uint8_t, int16_t, uint16_t, int32_t, uint32_t
- *  int64_t, uint64_t. uintn_t is a polymorphic type, size is native size and
- *  also size of the pointer.
+ *  int64_t, uint64_t.
  */
 
 #ifndef _CL_TYPES_OSD_H_
@@ -73,8 +72,6 @@ BEGIN_C_DECLS
 /*
  * Types not explicitly defined are native to the platform.
  */
-typedef unsigned long uintn_t;
-typedef long intn_t;
 typedef int boolean_t;
 typedef volatile int32_t atomic32_t;
 
-- 
1.6.5.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
