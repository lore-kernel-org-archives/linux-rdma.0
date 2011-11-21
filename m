From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH][TRIVIAL] opensm/complib/cl_atomic.h: Commentary changes
Date: Mon, 21 Nov 2011 07:02:05 -0500
Message-ID: <4ECA3DBD.8090206@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Remove mention of unused routines cl_atomic_xchg and cl_atomic_comp_xchg

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/include/complib/cl_atomic.h b/include/complib/cl_atomic.h
index 92620ee..ba21442 100644
--- a/include/complib/cl_atomic.h
+++ b/include/complib/cl_atomic.h
@@ -87,8 +87,7 @@ int32_t cl_atomic_inc(IN atomic32_t * const p_value);
 *	synchronization mechanisms in multi-threaded environments.
 *
 * SEE ALSO
-*	Atomic Operations, cl_atomic_dec, cl_atomic_add, cl_atomic_sub,
-*	cl_atomic_xchg, cl_atomic_comp_xchg
+*	Atomic Operations, cl_atomic_dec, cl_atomic_add, cl_atomic_sub
 *********/
 
 /****f* Component Library: Atomic Operations/cl_atomic_dec
@@ -118,8 +117,7 @@ int32_t cl_atomic_dec(IN atomic32_t * const p_value);
 *	synchronization mechanisms in multi-threaded environments.
 *
 * SEE ALSO
-*	Atomic Operations, cl_atomic_inc, cl_atomic_add, cl_atomic_sub,
-*	cl_atomic_xchg, cl_atomic_comp_xchg
+*	Atomic Operations, cl_atomic_inc, cl_atomic_add, cl_atomic_sub
 *********/
 
 /****f* Component Library: Atomic Operations/cl_atomic_add
@@ -153,8 +151,7 @@ cl_atomic_add(IN atomic32_t * const p_value, IN const int32_t increment);
 *	synchronization mechanisms in multi-threaded environments.
 *
 * SEE ALSO
-*	Atomic Operations, cl_atomic_inc, cl_atomic_dec, cl_atomic_sub,
-*	cl_atomic_xchg, cl_atomic_comp_xchg
+*	Atomic Operations, cl_atomic_inc, cl_atomic_dec, cl_atomic_sub
 *********/
 
 /****f* Component Library: Atomic Operations/cl_atomic_sub
@@ -188,8 +185,7 @@ cl_atomic_sub(IN atomic32_t * const p_value, IN const int32_t decrement);
 *	synchronization mechanisms in multi-threaded environments.
 *
 * SEE ALSO
-*	Atomic Operations, cl_atomic_inc, cl_atomic_dec, cl_atomic_add,
-*	cl_atomic_xchg, cl_atomic_comp_xchg
+*	Atomic Operations, cl_atomic_inc, cl_atomic_dec, cl_atomic_add
 *********/
 
 END_C_DECLS
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
