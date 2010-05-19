From: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] dapl-2.0: common: remove unnecessary lmr lkey hashing and
 duplicate lkey checking
Date: Wed, 19 May 2010 10:06:42 -0700
Message-ID: <E3280858FA94444CA49D2BA02341C983C7012F22@orsmsx506.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, ofw_list <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



lmr lkey hashing is too restrictive given the returned lkey could be
the same value for different regions on some rdma devices. Actually,
this checking is really unecesssary and requires considerable overhead
for hashing so just remove hashing of lmr lkey's. Let verbs device
level do the checking and validation.

Signed-off-by: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 dapl/common/dapl_hca_util.c  |   16 +-------
 dapl/common/dapl_lmr_free.c  |   19 +---------
 dapl/common/dapl_rmr_bind.c  |   15 ++-----
 dapl/udapl/dapl_lmr_create.c |   87 ------------------------------------------
 4 files changed, 7 insertions(+), 130 deletions(-)

diff --git a/dapl/common/dapl_hca_util.c b/dapl/common/dapl_hca_util.c
index b8f068c..4a8a400 100644
--- a/dapl/common/dapl_hca_util.c
+++ b/dapl/common/dapl_hca_util.c
@@ -38,7 +38,6 @@
 #include "dapl_adapter_util.h"
 #include "dapl_provider.h"
 #include "dapl_hca_util.h"
-#include "dapl_hash.h"
 
 /*
  * dapl_hca_alloc
@@ -66,13 +65,6 @@ DAPL_HCA *dapl_hca_alloc(char *name, char *port)
 	}
 
 	dapl_os_memzero(hca_ptr, sizeof(DAPL_HCA));
-
-	if (DAT_SUCCESS !=
-	    dapls_hash_create(DAPL_HASH_TABLE_DEFAULT_CAPACITY,
-			      &hca_ptr->lmr_hash_table)) {
-		goto bail;
-	}
-
 	dapl_os_lock_init(&hca_ptr->lock);
 	dapl_llist_init_head(&hca_ptr->ia_list_head);
 
@@ -87,13 +79,8 @@ DAPL_HCA *dapl_hca_alloc(char *name, char *port)
 	return (hca_ptr);
 
       bail:
-	if (NULL != hca_ptr) {
-		if (NULL != hca_ptr->lmr_hash_table) {
-			dapls_hash_free(hca_ptr->lmr_hash_table);
-		}
-
+	if (NULL != hca_ptr) 
 		dapl_os_free(hca_ptr, sizeof(DAPL_HCA));
-	}
 
 	return NULL;
 }
@@ -115,7 +102,6 @@ DAPL_HCA *dapl_hca_alloc(char *name, char *port)
  */
 void dapl_hca_free(DAPL_HCA * hca_ptr)
 {
-	(void)dapls_hash_free(hca_ptr->lmr_hash_table);
 	dapl_os_free(hca_ptr->name, dapl_os_strlen(hca_ptr->name) + 1);
 	dapl_os_free(hca_ptr, sizeof(DAPL_HCA));
 }
diff --git a/dapl/common/dapl_lmr_free.c b/dapl/common/dapl_lmr_free.c
index e72824a..5f9336f 100644
--- a/dapl/common/dapl_lmr_free.c
+++ b/dapl/common/dapl_lmr_free.c
@@ -90,29 +90,12 @@ DAT_RETURN DAT_API dapl_lmr_free(IN DAT_LMR_HANDLE lmr_handle)
 				return DAT_INVALID_STATE;
 			}
 
-			dat_status =
-			    dapls_hash_remove(lmr->header.owner_ia->hca_ptr->
-					      lmr_hash_table,
-					      lmr->param.lmr_context, NULL);
-			if (dat_status != DAT_SUCCESS) {
-				goto bail;
-			}
-
 			dat_status = dapls_ib_mr_deregister(lmr);
 
 			if (dat_status == DAT_SUCCESS) {
 				dapl_os_atomic_dec(&pz->pz_ref_count);
 				dapl_lmr_dealloc(lmr);
-			} else {
-				/*
-				 * Deregister failed; put it back in the
-				 * hash table.
-				 */
-				dapls_hash_insert(lmr->header.owner_ia->
-						  hca_ptr->lmr_hash_table,
-						  lmr->param.lmr_context, lmr);
-			}
-
+			} 
 			break;
 		}
 #if defined(__KDAPL__)
diff --git a/dapl/common/dapl_rmr_bind.c b/dapl/common/dapl_rmr_bind.c
index 9793f38..ecb190b 100755
--- a/dapl/common/dapl_rmr_bind.c
+++ b/dapl/common/dapl_rmr_bind.c
@@ -48,7 +48,8 @@
 
 STATIC _INLINE_ DAT_RETURN
 dapli_rmr_bind_fuse(IN DAPL_RMR * rmr,
-		    IN const DAT_LMR_TRIPLET * lmr_triplet,
+		    IN DAT_LMR_HANDLE lmr_handle,
+	            IN const DAT_LMR_TRIPLET * lmr_triplet,
 		    IN DAT_MEM_PRIV_FLAGS mem_priv,
 		    IN DAPL_EP * ep_ptr,
 		    IN DAT_RMR_COOKIE user_cookie,
@@ -69,6 +70,7 @@ dapli_rmr_bind_unfuse(IN DAPL_RMR * rmr,
 
 DAT_RETURN
 dapli_rmr_bind_fuse(IN DAPL_RMR * rmr,
+		    IN DAT_LMR_HANDLE lmr_handle,
 		    IN const DAT_LMR_TRIPLET * lmr_triplet,
 		    IN DAT_MEM_PRIV_FLAGS mem_priv,
 		    IN DAPL_EP * ep_ptr,
@@ -80,16 +82,8 @@ dapli_rmr_bind_fuse(IN DAPL_RMR * rmr,
 	DAPL_COOKIE *cookie;
 	DAT_RETURN dat_status;
 	DAT_BOOLEAN is_signaled;
-	DAPL_HASH_DATA hash_lmr;
 
-	dat_status =
-	    dapls_hash_search(rmr->header.owner_ia->hca_ptr->lmr_hash_table,
-			      lmr_triplet->lmr_context, &hash_lmr);
-	if (DAT_SUCCESS != dat_status) {
-		dat_status = DAT_ERROR(DAT_INVALID_PARAMETER, DAT_INVALID_ARG2);
-		goto bail;
-	}
-	lmr = (DAPL_LMR *) hash_lmr;
+	lmr = (DAPL_LMR *) lmr_handle;
 
 	/* if the ep in unconnected return an error. IB requires that the */
 	/* QP be connected to change a memory window binding since:       */
@@ -305,6 +299,7 @@ dapl_rmr_bind(IN DAT_RMR_HANDLE rmr_handle,
 	/* if the rmr should be bound */
 	if (0 != lmr_triplet->segment_length) {
 		return dapli_rmr_bind_fuse(rmr,
+					   lmr_handle,
 					   lmr_triplet,
 					   mem_priv,
 					   ep_ptr,
diff --git a/dapl/udapl/dapl_lmr_create.c b/dapl/udapl/dapl_lmr_create.c
index 849f4fe..f1d5016 100644
--- a/dapl/udapl/dapl_lmr_create.c
+++ b/dapl/udapl/dapl_lmr_create.c
@@ -128,32 +128,6 @@ dapli_lmr_create_virtual(IN DAPL_IA * ia,
 		goto bail;
 	}
 
-	/* if the LMR context is already in the hash table */
-	dat_status = dapls_hash_search(ia->hca_ptr->lmr_hash_table,
-				       lmr->param.lmr_context, NULL);
-	if (dat_status == DAT_SUCCESS) {
-		(void)dapls_ib_mr_deregister(lmr);
-		dapl_lmr_dealloc(lmr);
-
-		dat_status =
-		    DAT_ERROR(DAT_INVALID_STATE, DAT_INVALID_STATE_LMR_IN_USE);
-		goto bail;
-	}
-
-	dat_status = dapls_hash_insert(ia->hca_ptr->lmr_hash_table,
-				       lmr->param.lmr_context, lmr);
-	if (dat_status != DAT_SUCCESS) {
-		(void)dapls_ib_mr_deregister(lmr);
-		dapl_lmr_dealloc(lmr);
-
-		/* The value returned by dapls_hash_insert(.) is not    */
-		/* returned to the consumer because the spec. requires */
-		/* that dat_lmr_create(.) return only certain values.  */
-		dat_status =
-		    DAT_ERROR(DAT_INSUFFICIENT_RESOURCES, DAT_RESOURCE_MEMORY);
-		goto bail;
-	}
-
 	dapl_os_atomic_inc(&pz->pz_ref_count);
 	*lmr_handle = (DAT_LMR_HANDLE) lmr;
 
@@ -189,7 +163,6 @@ dapli_lmr_create_lmr(IN DAPL_IA * ia,
 	DAPL_LMR *lmr;
 	DAT_REGION_DESCRIPTION reg_desc;
 	DAT_RETURN dat_status;
-	DAPL_HASH_DATA hash_lmr;
 
 	dapl_dbg_log(DAPL_DBG_TYPE_API,
 		     "dapl_lmr_create_lmr (%p, %p, %p, %x, %x, %p, %p, %p, %p)\n",
@@ -199,14 +172,6 @@ dapli_lmr_create_lmr(IN DAPL_IA * ia,
 		     lmr_handle,
 		     lmr_context, registered_length, registered_address);
 
-	dat_status = dapls_hash_search(ia->hca_ptr->lmr_hash_table,
-				       original_lmr->param.lmr_context,
-				       &hash_lmr);
-	if (dat_status != DAT_SUCCESS) {
-		dat_status = DAT_ERROR(DAT_INVALID_PARAMETER, DAT_INVALID_ARG2);
-		goto bail;
-	}
-	lmr = (DAPL_LMR *) hash_lmr;
 	reg_desc.for_lmr_handle = (DAT_LMR_HANDLE) original_lmr;
 
 	lmr = dapl_lmr_alloc(ia,
@@ -228,32 +193,6 @@ dapli_lmr_create_lmr(IN DAPL_IA * ia,
 		goto bail;
 	}
 
-	/* if the LMR context is already in the hash table */
-	dat_status = dapls_hash_search(ia->hca_ptr->lmr_hash_table,
-				       lmr->param.lmr_context, NULL);
-	if (dat_status == DAT_SUCCESS) {
-		dapls_ib_mr_deregister(lmr);
-		dapl_lmr_dealloc(lmr);
-
-		dat_status =
-		    DAT_ERROR(DAT_INVALID_STATE, DAT_INVALID_STATE_LMR_IN_USE);
-		goto bail;
-	}
-
-	dat_status = dapls_hash_insert(ia->hca_ptr->lmr_hash_table,
-				       lmr->param.lmr_context, lmr);
-	if (dat_status != DAT_SUCCESS) {
-		dapls_ib_mr_deregister(lmr);
-		dapl_lmr_dealloc(lmr);
-
-		/* The value returned by dapls_hash_insert(.) is not    */
-		/* returned to the consumer because the spec. requires */
-		/* that dat_lmr_create(.) return only certain values.  */
-		dat_status =
-		    DAT_ERROR(DAT_INSUFFICIENT_RESOURCES, DAT_RESOURCE_MEMORY);
-		goto bail;
-	}
-
 	dapl_os_atomic_inc(&pz->pz_ref_count);
 	*lmr_handle = (DAT_LMR_HANDLE) lmr;
 
@@ -328,32 +267,6 @@ dapli_lmr_create_shared(IN DAPL_IA * ia,
 		goto bail;
 	}
 
-	/* if the LMR context is already in the hash table */
-	dat_status = dapls_hash_search(ia->hca_ptr->lmr_hash_table,
-				       lmr->param.lmr_context, NULL);
-	if (DAT_SUCCESS == dat_status) {
-		(void)dapls_ib_mr_deregister(lmr);
-		dapl_lmr_dealloc(lmr);
-
-		dat_status =
-		    DAT_ERROR(DAT_INVALID_STATE, DAT_INVALID_STATE_LMR_IN_USE);
-		goto bail;
-	}
-
-	dat_status = dapls_hash_insert(ia->hca_ptr->lmr_hash_table,
-				       lmr->param.lmr_context, lmr);
-	if (dat_status != DAT_SUCCESS) {
-		(void)dapls_ib_mr_deregister(lmr);
-		dapl_lmr_dealloc(lmr);
-
-		/* The value returned by dapls_hash_insert(.) is not    */
-		/* returned to the consumer because the spec. requires */
-		/* that dat_lmr_create(.) return only certain values.  */
-		dat_status =
-		    DAT_ERROR(DAT_INSUFFICIENT_RESOURCES, DAT_RESOURCE_MEMORY);
-		goto bail;
-	}
-
 	dapl_os_atomic_inc(&pz->pz_ref_count);
 	*lmr_handle = (DAT_LMR_HANDLE) lmr;
 
-- 
1.5.2.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
