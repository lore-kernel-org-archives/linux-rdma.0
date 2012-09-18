From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH][TRIVIAL] opensm/complib/cl_spinlock.h: Remove some unimplemented
 routines
Date: Tue, 18 Sep 2012 14:53:21 -0400
Message-ID: <5058C321.3000003@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Remove cl_spinlock_acquire_irq and cl_spinlock_release_irq

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 include/complib/cl_spinlock.h |   61 ++---------------------------------------
 1 files changed, 3 insertions(+), 58 deletions(-)

diff --git a/include/complib/cl_spinlock.h b/include/complib/cl_spinlock.h
index 1a04b56..4de6f26 100644
--- a/include/complib/cl_spinlock.h
+++ b/include/complib/cl_spinlock.h
@@ -73,7 +73,6 @@ BEGIN_C_DECLS
 *
 *	Manipulation
 *		cl_spinlock_acquire, cl_spinlock_release
-*		cl_spinlock_acquire_irq, cl_spinlock_release_irq
 *********/
 /****f* Component Library: Spinlock/cl_spinlock_construct
 * NAME
@@ -133,9 +132,7 @@ cl_status_t cl_spinlock_init(IN cl_spinlock_t * const p_spinlock);
 *
 * SEE ALSO
 *	Spinlock, cl_spinlock_construct, cl_spinlock_destroy,
-*	cl_spinlock_acquire, cl_spinlock_acquire_irq,
-*	cl_spinlock_release, cl_spinlock_release
-*	cl_spinlock_release_irq, cl_spinlock_release_irq
+*	cl_spinlock_acquire, cl_spinlock_release
 *********/
 
 /****f* Component Library: Spinlock/cl_spinlock_destroy
@@ -174,8 +171,7 @@ void cl_spinlock_destroy(IN cl_spinlock_t * const p_spinlock);
 *	The cl_spinlock_acquire function acquires a spin lock.
 *	This version of lock does not prevent an interrupt from
 *	occuring on the processor on which the code is being
-*	executed. To protect from an interrupt level resource
-*	use the cl_spinlock_acquire_irq function.
+*	executed.
 *
 * SYNOPSIS
 */
@@ -189,33 +185,7 @@ void cl_spinlock_acquire(IN cl_spinlock_t * const p_spinlock);
 *	This function does not return a value.
 *
 * SEE ALSO
-*	Spinlock, cl_spinlock_acquire_irq, cl_spinlock_release
-*	cl_spinlock_release_irq
-*********/
-
-/****f* Component Library: Spinlock/cl_spinlock_acquire_irq
-* NAME
-*	cl_spinlock_acquire_irq
-*
-* DESCRIPTION
-*	The cl_spinlock_acquire_irq function acquires a spin lock and protects
-*	the current processor from taking interrupts. If you need to protect
-*	a variable from an interrupt resource, use this version to acquire
-*	a lock.
-*
-* SYNOPSIS
-*/
-void cl_spinlock_acquire_irq(IN cl_spinlock_t * const p_spinlock);
-/*
-* PARAMETERS
-*	p_spin_lock
-*		[in] Pointer to a spin lock structure to acquire.
-*
-* RETURN VALUE
-*	This function does not return a value.
-*
-* SEE ALSO
-*	Spinlock, cl_spinlock_release_irq
+*	Spinlock, cl_spinlock_release
 *********/
 
 /****f* Component Library: Spinlock/cl_spinlock_release
@@ -243,30 +213,5 @@ void cl_spinlock_release(IN cl_spinlock_t * const p_spinlock);
 *	Spinlock, cl_spinlock_acquire
 *********/
 
-/****f* Component Library: Spinlock/cl_spinlock_release_irq
-* NAME
-*	cl_spinlock_release_irq
-*
-* DESCRIPTION
-*	The cl_spinlock_release_irq function releases a spin lock object.
-*
-* SYNOPSIS
-*/
-void cl_spinlock_release_irq(IN cl_spinlock_t * const p_spinlock);
-/*
-* PARAMETERS
-*	p_spin_lock
-*		[in] Pointer to a spin lock structure to release.
-*
-* RETURN VALUE
-*	This function does not return a value.
-*
-* NOTES
-*	Releases a spin lock after a call to cl_spinlock_acquire.
-*
-* SEE ALSO
-*	Spinlock, cl_spinlock_acquire_irq
-*********/
-
 END_C_DECLS
 #endif				/* _CL_SPINLOCK_H_ */
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
