From: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 4/10] DAPL v2.0: common: add collective call mappings via
 standard dapli_post_ext()
Date: Thu, 11 Aug 2011 00:41:58 +0000
Message-ID: <54347E5A035A054EAE9D05927FB467F916E42B40@FMSMSX151.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, "ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 dapl/openib_common/ib_extensions.c |  190 ++++++++++++++++++++++++++++++++++++
 1 files changed, 190 insertions(+), 0 deletions(-)

diff --git a/dapl/openib_common/ib_extensions.c b/dapl/openib_common/ib_extensions.c
index 3c418e1..c85323c 100644
--- a/dapl/openib_common/ib_extensions.c
+++ b/dapl/openib_common/ib_extensions.c
@@ -32,6 +32,10 @@
 #include "dapl_cookie.h"
 #include <stdarg.h>
 
+#ifdef DAT_IB_COLLECTIVES
+#include "collectives/ib_collectives.h"
+#endif
+
 DAT_RETURN
 dapli_post_ext(IN DAT_EP_HANDLE ep_handle,
 	       IN DAT_UINT64 cmp_add,
@@ -181,7 +185,193 @@ dapl_extensions(IN DAT_HANDLE dat_handle,
 			break;
 		}
 #endif				/* DAPL_COUNTERS */
+#ifdef DAT_IB_COLLECTIVES
+	case DAT_IB_COLLECTIVE_CREATE_MEMBER_OP:
+	{
+		void *progress_func;
+		DAT_IB_COLLECTIVE_MEMBER *member_p;
+		DAT_COUNT *size_p;
+
+		dapl_dbg_log(DAPL_DBG_TYPE_EXTENSION,
+			     " COLLECTIVE_CREATE_MEMBER extension call\n");
+
+		progress_func = va_arg(args, void *);
+		member_p = va_arg(args, DAT_IB_COLLECTIVE_MEMBER *);
+		size_p   = va_arg(args, DAT_COUNT *);
+
+		return dapli_create_collective_member(dat_handle,
+						      progress_func,
+						      size_p,
+						      member_p);
+	}
+	case DAT_IB_COLLECTIVE_FREE_MEMBER_OP:
+	{
+		DAT_IB_COLLECTIVE_MEMBER member;
+
+		dapl_dbg_log(DAPL_DBG_TYPE_EXTENSION,
+				" COLLECTIVE_FREE_MEMBER extension call\n");
+
+		member = va_arg(args, DAT_IB_COLLECTIVE_MEMBER);
+		return dapli_free_collective_member(dat_handle, member);
+	}
+	case DAT_IB_COLLECTIVE_CREATE_GROUP_OP:
+	{
+		DAT_CONTEXT context;
+		DAT_IB_COLLECTIVE_MEMBER *members;
+		DAT_IB_COLLECTIVE_GROUP *grp;
+		DAT_IB_COLLECTIVE_RANK rank;
+		DAT_IB_COLLECTIVE_ID id;
+		DAT_PZ_HANDLE pd;
+		DAT_COUNT size;
+
+		dapl_dbg_log(DAPL_DBG_TYPE_EXTENSION,
+				" DAT_IB_COLLECTIVE_CREATE_GROUP extension call\n");
+
+		members = va_arg(args, DAT_IB_COLLECTIVE_MEMBER *);/* array */
+		size    = va_arg(args, DAT_COUNT);/* member count */
+		rank    = va_arg(args, DAT_IB_COLLECTIVE_RANK);/* rank */
+		id      = va_arg(args, DAT_IB_COLLECTIVE_ID);/* group id */
+		grp     = va_arg(args, DAT_IB_COLLECTIVE_GROUP *);/* group info */
+		pd      = va_arg(args, DAT_PZ_HANDLE);/* prot domain */
+		context = va_arg(args, DAT_CONTEXT);
+
+		return  dapli_create_collective_group(dat_handle, pd, members,
+						      size, rank, id, grp, context);
+	}
+	case DAT_IB_COLLECTIVE_FREE_GROUP_OP:
+	{
+		dapl_dbg_log(DAPL_DBG_TYPE_EXTENSION,
+				" DAT_IB_COLLECTIVE_FREE_GROUP extension call\n");
 
+		return dapli_free_collective_group(dat_handle);
+	}
+	case DAT_IB_COLLECTIVE_BARRIER_OP:
+	{
+		DAT_CONTEXT context;
+
+		dapl_dbg_log(DAPL_DBG_TYPE_EXTENSION,
+                        "Got DAT_IB_COLLECTIVE_BARRIER extension call\n");
+
+                context    = va_arg(args, DAT_CONTEXT);
+                comp_flags = va_arg(args, DAT_COMPLETION_FLAGS);
+
+                return dapli_collective_barrier(dat_handle, context, comp_flags);
+	}
+        case DAT_IB_COLLECTIVE_BROADCAST_OP:
+        {
+        	DAT_CONTEXT context;
+        	DAT_PVOID buf;
+        	DAT_COUNT size;
+        	DAT_IB_COLLECTIVE_RANK root;
+
+                dapl_dbg_log(DAPL_DBG_TYPE_EXTENSION,
+                        "Got DAT_IB_COLLECTIVE_BROADCAST extension call\n");
+
+                buf        = va_arg(args, DAT_PVOID);
+                size       = va_arg(args, DAT_COUNT);
+                root       = va_arg(args, DAT_IB_COLLECTIVE_RANK);
+                context    = va_arg(args, DAT_CONTEXT);
+                comp_flags = va_arg(args, DAT_COMPLETION_FLAGS);
+
+                return dapli_collective_broadcast(dat_handle, buf, size,
+                                                  root, context, comp_flags);
+
+        }
+        case DAT_IB_COLLECTIVE_REDUCE_OP:
+        {
+        	DAT_CONTEXT context;
+		DAT_IB_COLLECTIVE_RANK root;
+		DAT_PVOID sbuf, rbuf;
+		DAT_COUNT slen, rlen;
+		DAT_IB_COLLECTIVE_REDUCE_DATA_OP op;
+		DAT_IB_COLLECTIVE_DATA_TYPE type;
+
+                dapl_dbg_log(DAPL_DBG_TYPE_EXTENSION,
+                        "Got DAT_IB_COLLECTIVE_REDUCE extension call\n");
+
+                sbuf       = va_arg(args, DAT_PVOID);
+                slen       = va_arg(args, DAT_COUNT);
+                rbuf       = va_arg(args, DAT_PVOID);
+                rlen       = va_arg(args, DAT_COUNT);
+                op         = va_arg(args, DAT_IB_COLLECTIVE_REDUCE_DATA_OP);
+                type       = va_arg(args, DAT_IB_COLLECTIVE_DATA_TYPE);
+                root       = va_arg(args, DAT_IB_COLLECTIVE_RANK);
+                context    = va_arg(args, DAT_CONTEXT);
+                comp_flags = va_arg(args, DAT_COMPLETION_FLAGS);
+
+                return dapli_collective_reduce(dat_handle, sbuf, slen,
+                			       rbuf, rlen, op, type, root,
+                			       context, comp_flags);
+        }
+        case DAT_IB_COLLECTIVE_ALLREDUCE_OP:
+        {
+        	DAT_CONTEXT context;
+		DAT_PVOID sbuf, rbuf;
+		DAT_COUNT slen, rlen;
+		DAT_IB_COLLECTIVE_REDUCE_DATA_OP op;
+		DAT_IB_COLLECTIVE_DATA_TYPE type;
+
+                dapl_dbg_log(DAPL_DBG_TYPE_EXTENSION,
+                        "Got DAT_IB_COLLECTIVE_ALLREDUCE extension call\n");
+
+                sbuf       = va_arg(args, DAT_PVOID);
+                slen       = va_arg(args, DAT_COUNT);
+                rbuf       = va_arg(args, DAT_PVOID);
+                rlen       = va_arg(args, DAT_COUNT);
+                op         = va_arg(args, DAT_IB_COLLECTIVE_REDUCE_DATA_OP);
+                type       = va_arg(args, DAT_IB_COLLECTIVE_DATA_TYPE);
+                context    = va_arg(args, DAT_CONTEXT);
+                comp_flags = va_arg(args, DAT_COMPLETION_FLAGS);
+
+                return dapli_collective_allreduce(dat_handle, sbuf, slen,
+                				  rbuf, rlen, op, type,
+                				  context, comp_flags);
+        }
+        case DAT_IB_COLLECTIVE_ALLGATHER_OP:
+        {
+        	DAT_CONTEXT context;
+		DAT_PVOID sbuf, rbuf;
+		DAT_COUNT slen, rlen;
+
+                dapl_dbg_log(DAPL_DBG_TYPE_EXTENSION,
+                        "Got DAT_IB_COLLECTIVE_ALLGATHER extension call\n");
+
+                sbuf       = va_arg(args, DAT_PVOID);
+                slen       = va_arg(args, DAT_COUNT);
+                rbuf       = va_arg(args, DAT_PVOID);
+                rlen       = va_arg(args, DAT_COUNT);
+                context    = va_arg(args, DAT_CONTEXT);
+                comp_flags = va_arg(args, DAT_COMPLETION_FLAGS);
+
+                return dapli_collective_allgather(dat_handle, sbuf, slen,
+                				  rbuf, rlen, context,
+                				  comp_flags);
+        }
+        case DAT_IB_COLLECTIVE_ALLGATHERV_OP:
+        {
+        	DAT_CONTEXT context;
+		DAT_PVOID sbuf, rbuf;
+		DAT_COUNT slen;
+		DAT_COUNT *rlens;
+		DAT_COUNT *displs;
+
+                dapl_dbg_log(DAPL_DBG_TYPE_EXTENSION,
+                        "Got DAT_IB_COLLECTIVE_ALLGATHERV extension call\n");
+
+                sbuf       = va_arg(args, DAT_PVOID);
+                slen       = va_arg(args, DAT_COUNT);
+                rbuf       = va_arg(args, DAT_PVOID);
+                rlens      = va_arg(args, DAT_COUNT *);
+                displs     = va_arg(args, DAT_COUNT *);
+                context    = va_arg(args, DAT_CONTEXT);
+                comp_flags = va_arg(args, DAT_COMPLETION_FLAGS);
+
+                return dapli_collective_allgatherv(dat_handle, sbuf, slen,
+                				   rbuf, rlens, displs,
+                				   context, comp_flags);
+        }
+
+#endif
 	default:
 		dapl_dbg_log(DAPL_DBG_TYPE_ERR,
 			     "unsupported extension(%d)\n", (int)ext_op);
-- 
1.7.3



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
