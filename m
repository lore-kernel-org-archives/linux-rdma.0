From: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] opensm/complib: redundant redeclarations
Date: Mon, 01 Feb 2010 15:22:32 +0200
Message-ID: <4B66D598.3030401@dev.mellanox.co.il>
Reply-To: kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Sasha,

There are couple of places in complib headers that cause
compiler to complain:

    cl_atomic.h:73: warning: redundant redeclaration of 'cl_atomic_inc'
    cl_atomic_osd.h:58: warning: previous definition of 'cl_atomic_inc' was here

    cl_atomic.h:104: warning: redundant redeclaration of 'cl_atomic_dec'
    cl_atomic_osd.h:69: warning: previous definition of 'cl_atomic_dec' was here

    cl_atomic.h:136: warning: redundant redeclaration of 'cl_atomic_add'
    cl_atomic_osd.h:81: warning: previous definition of 'cl_atomic_add' was here

    cl_atomic.h:171: warning: redundant redeclaration of 'cl_atomic_sub'
    cl_atomic_osd.h:93: warning: previous definition of 'cl_atomic_sub' was here

    cl_thread.h:346: warning: redundant redeclaration of 'cl_is_blockable'
    cl_thread_osd.h:63: warning: previous definition of 'cl_is_blockable' was here

In general, here's the problem:

We have cl_file.h and cl_file_osd.h.
cl_file.h has include directive for cl_file_osd.h
cl_file.h has the following definition of function:
    int foo();

cl_file_osd.h has another function definition, but
this time it also has implementation:
    static inline int foo() { ..... }

Any preferable way to fix this?

Get rid of the _osd.h files and have the functions
implementation included in the usual .h file?

Define some *_HAVE_OSD flag in the _osd.h file
and enclose function declaration in the usual .h
file with #ifndef?

The following patch implements option 2.

This patch is also kind of an RFC, so let
me what you think. Any other ideas?

Signed-off-by: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
---
 opensm/include/complib/cl_atomic.h     |    8 ++++++++
 opensm/include/complib/cl_atomic_osd.h |    4 ++++
 opensm/include/complib/cl_thread.h     |    2 ++
 opensm/include/complib/cl_thread_osd.h |    1 +
 4 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/opensm/include/complib/cl_atomic.h b/opensm/include/complib/cl_atomic.h
index 92620ee..7e343d7 100644
--- a/opensm/include/complib/cl_atomic.h
+++ b/opensm/include/complib/cl_atomic.h
@@ -70,7 +70,9 @@ BEGIN_C_DECLS
 *
 * SYNOPSIS
 */
+#ifndef _OSD_CL_ATOMIC_INC
 int32_t cl_atomic_inc(IN atomic32_t * const p_value);
+#endif
 /*
 * PARAMETERS
 *	p_value
@@ -101,7 +103,9 @@ int32_t cl_atomic_inc(IN atomic32_t * const p_value);
 *
 * SYNOPSIS
 */
+#ifndef _OSD_CL_ATOMIC_DEC
 int32_t cl_atomic_dec(IN atomic32_t * const p_value);
+#endif
 /*
 * PARAMETERS
 *	p_value
@@ -132,8 +136,10 @@ int32_t cl_atomic_dec(IN atomic32_t * const p_value);
 *
 * SYNOPSIS
 */
+#ifndef _OSD_CL_ATOMIC_ADD
 int32_t
 cl_atomic_add(IN atomic32_t * const p_value, IN const int32_t increment);
+#endif
 /*
 * PARAMETERS
 *	p_value
@@ -167,8 +173,10 @@ cl_atomic_add(IN atomic32_t * const p_value, IN const int32_t increment);
 *
 * SYNOPSIS
 */
+#ifndef _OSD_CL_ATOMIC_SUB
 int32_t
 cl_atomic_sub(IN atomic32_t * const p_value, IN const int32_t decrement);
+#endif
 /*
 * PARAMETERS
 *	p_value
diff --git a/opensm/include/complib/cl_atomic_osd.h b/opensm/include/complib/cl_atomic_osd.h
index ac14f8a..43d1b77 100644
--- a/opensm/include/complib/cl_atomic_osd.h
+++ b/opensm/include/complib/cl_atomic_osd.h
@@ -54,6 +54,7 @@

 BEGIN_C_DECLS extern cl_spinlock_t cl_atomic_spinlock;

+#define _OSD_CL_ATOMIC_INC
 static inline int32_t cl_atomic_inc(IN atomic32_t * const p_value)
 {
 	int32_t new_val;
@@ -65,6 +66,7 @@ static inline int32_t cl_atomic_inc(IN atomic32_t * const p_value)
 	return (new_val);
 }

+#define _OSD_CL_ATOMIC_DEC
 static inline int32_t cl_atomic_dec(IN atomic32_t * const p_value)
 {
 	int32_t new_val;
@@ -76,6 +78,7 @@ static inline int32_t cl_atomic_dec(IN atomic32_t * const p_value)
 	return (new_val);
 }

+#define _OSD_CL_ATOMIC_ADD
 static inline int32_t
 cl_atomic_add(IN atomic32_t * const p_value, IN const int32_t increment)
 {
@@ -88,6 +91,7 @@ cl_atomic_add(IN atomic32_t * const p_value, IN const int32_t increment)
 	return (new_val);
 }

+#define _OSD_CL_ATOMIC_SUB
 static inline int32_t
 cl_atomic_sub(IN atomic32_t * const p_value, IN const int32_t decrement)
 {
diff --git a/opensm/include/complib/cl_thread.h b/opensm/include/complib/cl_thread.h
index 0a622a1..b7ee1ca 100644
--- a/opensm/include/complib/cl_thread.h
+++ b/opensm/include/complib/cl_thread.h
@@ -343,7 +343,9 @@ boolean_t cl_is_current_thread(IN const cl_thread_t * const p_thread);
 *
 * SYNOPSIS
 */
+#ifndef _OSD_CL_IS_BLOCKABLE
 boolean_t cl_is_blockable(void);
+#endif
 /*
 * RETURN VALUE
 *	TRUE
diff --git a/opensm/include/complib/cl_thread_osd.h b/opensm/include/complib/cl_thread_osd.h
index ad7df90..50fb6f7 100644
--- a/opensm/include/complib/cl_thread_osd.h
+++ b/opensm/include/complib/cl_thread_osd.h
@@ -59,6 +59,7 @@ typedef struct _cl_thread_osd_t {
 	cl_state_t state;
 } cl_thread_osd_t;

+#define _OSD_CL_IS_BLOCKABLE
 static inline boolean_t cl_is_blockable(void)
 {
 	return TRUE;
-- 
1.5.1.4


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
