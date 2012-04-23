From: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 01/15] uDAPL v2.0 common: add check for NULL handle on ext
 calls, SRQ free, and helper functions
Date: Mon, 23 Apr 2012 20:00:39 +0000
Message-ID: <54347E5A035A054EAE9D05927FB467F948120232@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
Cc: "ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Series of bug fixes, package cleanup, and debug counters.

Signed-off-by: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 dat/common/dat_api.c |   29 ++++++++++++++++++++++++++---
 1 files changed, 26 insertions(+), 3 deletions(-)

diff --git a/dat/common/dat_api.c b/dat/common/dat_api.c
index f53ead7..50ffa2c 100755
--- a/dat/common/dat_api.c
+++ b/dat/common/dat_api.c
@@ -292,6 +292,11 @@ DAT_RETURN DAT_API dat_ia_query(IN DAT_IA_HANDLE ia_handle,
 DAT_RETURN DAT_API dat_set_consumer_context(IN DAT_HANDLE dat_handle,
 					    IN DAT_CONTEXT context)
 {
+	if (dat_handle == NULL) {
+		return DAT_ERROR(DAT_INVALID_HANDLE,
+				 DAT_INVALID_HANDLE1);
+	}
+
 	if (dats_is_ia_handle(dat_handle)) {
 		DAT_IA_HANDLE dapl_ia_handle;
 		DAT_RETURN dat_status;
@@ -301,7 +306,7 @@ DAT_RETURN DAT_API dat_set_consumer_context(IN DAT_HANDLE dat_handle,
 
 		/* failure to map the handle is unlikely but possible */
 		/* in a mult-threaded environment                     */
-		if (DAT_SUCCESS == dat_status) {
+		if (DAT_SUCCESS != dat_status) {
 			return DAT_ERROR(DAT_INVALID_HANDLE,
 					 DAT_INVALID_HANDLE1);
 		}
@@ -315,6 +320,11 @@ DAT_RETURN DAT_API dat_set_consumer_context(IN DAT_HANDLE dat_handle,
 DAT_RETURN DAT_API dat_get_consumer_context(IN DAT_HANDLE dat_handle,
 					    OUT DAT_CONTEXT * context)
 {
+	if (dat_handle == NULL) {
+		return DAT_ERROR(DAT_INVALID_HANDLE,
+				 DAT_INVALID_HANDLE1);
+	}
+
 	if (dats_is_ia_handle(dat_handle)) {
 		DAT_IA_HANDLE dapl_ia_handle;
 		DAT_RETURN dat_status;
@@ -324,7 +334,7 @@ DAT_RETURN DAT_API dat_get_consumer_context(IN DAT_HANDLE dat_handle,
 
 		/* failure to map the handle is unlikely but possible */
 		/* in a mult-threaded environment                     */
-		if (DAT_SUCCESS == dat_status) {
+		if (DAT_SUCCESS != dat_status) {
 			return DAT_ERROR(DAT_INVALID_HANDLE,
 					 DAT_INVALID_HANDLE1);
 		}
@@ -338,6 +348,11 @@ DAT_RETURN DAT_API dat_get_consumer_context(IN DAT_HANDLE dat_handle,
 DAT_RETURN DAT_API dat_get_handle_type(IN DAT_HANDLE dat_handle,
 				       OUT DAT_HANDLE_TYPE * type)
 {
+	if (dat_handle == NULL) {
+		return DAT_ERROR(DAT_INVALID_HANDLE,
+				 DAT_INVALID_HANDLE1);
+	}
+
 	if (dats_is_ia_handle(dat_handle)) {
 		DAT_IA_HANDLE dapl_ia_handle;
 		DAT_RETURN dat_status;
@@ -347,7 +362,7 @@ DAT_RETURN DAT_API dat_get_handle_type(IN DAT_HANDLE dat_handle,
 
 		/* failure to map the handle is unlikely but possible */
 		/* in a mult-threaded environment                     */
-		if (DAT_SUCCESS == dat_status) {
+		if (DAT_SUCCESS != dat_status) {
 			return DAT_ERROR(DAT_INVALID_HANDLE,
 					 DAT_INVALID_HANDLE1);
 		}
@@ -1009,6 +1024,9 @@ DAT_RETURN DAT_API dat_srq_create(IN DAT_IA_HANDLE ia_handle,
 
 DAT_RETURN DAT_API dat_srq_free(IN DAT_SRQ_HANDLE srq_handle)
 {
+	if (srq_handle == NULL) {
+		return DAT_ERROR(DAT_INVALID_HANDLE, DAT_INVALID_HANDLE_SRQ);
+	}
 	return DAT_SRQ_FREE(srq_handle);
 }
 
@@ -1063,6 +1081,11 @@ DAT_RETURN DAT_API dat_extension_op(IN DAT_HANDLE handle,
 	DAT_IA_HANDLE dapl_handle;
 	va_list args;
 
+	if (handle == NULL) {
+		return DAT_ERROR(DAT_INVALID_HANDLE,
+				 DAT_INVALID_HANDLE1);
+	}
+
 	/* If not IA handle then just passthrough */
 	if (dats_get_ia_handle(handle, &dapl_handle) != DAT_SUCCESS) {
 		dapl_handle = handle;
-- 
1.7.3



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
