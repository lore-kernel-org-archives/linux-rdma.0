From: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] libdat v2.0: static provider entries created for local SR
 database not freed
Date: Mon, 6 Dec 2010 16:22:53 -0800
Message-ID: <E3280858FA94444CA49D2BA02341C983011E66B8EA@orsmsx506.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
Cc: "Smith, Stan" <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "King, Perry E." <perry.king-itBhTGHPdi0@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

during load (dat_sr_init) the SR database is created with all dat.conf entries
but are never cleaned up during unload. Add new functions dat_sr_remove_all()
and dat_sr_remove() calls to cleanup and deallocate SR database entries and
database via dat_sr_fini().

Signed-off-by: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 dat/common/dat_sr.c |  111 +++++++++++++++++++++++++++++++++++++++++++++++----
 dat/common/dat_sr.h |   10 +++++
 2 files changed, 113 insertions(+), 8 deletions(-)

diff --git a/dat/common/dat_sr.c b/dat/common/dat_sr.c
index 95b9333..e86c5dc 100755
--- a/dat/common/dat_sr.c
+++ b/dat/common/dat_sr.c
@@ -94,6 +94,11 @@ extern DAT_RETURN dat_sr_fini(void)
 {
 	DAT_RETURN status;
 
+	status = dat_sr_remove_all(g_sr_dictionary);
+	if (DAT_SUCCESS != status) {
+		return status;
+	}
+
 	status = dat_os_lock_destroy(&g_sr_lock);
 	if (DAT_SUCCESS != status) {
 		return status;
@@ -116,9 +121,7 @@ dat_sr_insert(IN const DAT_PROVIDER_INFO * info, IN DAT_SR_ENTRY * entry)
 {
 	DAT_RETURN status;
 	DAT_SR_ENTRY *data;
-	DAT_OS_SIZE lib_path_size;
 	DAT_OS_SIZE lib_path_len;
-	DAT_OS_SIZE ia_params_size;
 	DAT_OS_SIZE ia_params_len;
 	DAT_DICTIONARY_ENTRY dict_entry;
 	DAT_DICTIONARY_DATA prev_data;
@@ -132,9 +135,9 @@ dat_sr_insert(IN const DAT_PROVIDER_INFO * info, IN DAT_SR_ENTRY * entry)
 	dat_os_memset(data, '\0', sizeof(DAT_SR_ENTRY));
 
 	lib_path_len = strlen(entry->lib_path);
-	lib_path_size = (lib_path_len + 1) * sizeof(char);
+	data->lib_path_size = (lib_path_len + 1) * sizeof(char);
 
-	if (NULL == (data->lib_path = dat_os_alloc(lib_path_size))) {
+	if (NULL == (data->lib_path = dat_os_alloc(data->lib_path_size))) {
 		status =
 		    DAT_ERROR(DAT_INSUFFICIENT_RESOURCES, DAT_RESOURCE_MEMORY);
 		goto bail;
@@ -144,9 +147,9 @@ dat_sr_insert(IN const DAT_PROVIDER_INFO * info, IN DAT_SR_ENTRY * entry)
 	data->lib_path[lib_path_len] = '\0';
 
 	ia_params_len = strlen(entry->ia_params);
-	ia_params_size = (ia_params_len + 1) * sizeof(char);
+	data->ia_params_size = (ia_params_len + 1) * sizeof(char);
 
-	if (NULL == (data->ia_params = dat_os_alloc(ia_params_size))) {
+	if (NULL == (data->ia_params = dat_os_alloc(data->ia_params_size))) {
 		status =
 		    DAT_ERROR(DAT_INSUFFICIENT_RESOURCES, DAT_RESOURCE_MEMORY);
 		goto bail;
@@ -197,11 +200,11 @@ dat_sr_insert(IN const DAT_PROVIDER_INFO * info, IN DAT_SR_ENTRY * entry)
 	if (DAT_SUCCESS != status) {
 		if (NULL != data) {
 			if (NULL != data->lib_path) {
-				dat_os_free(data->lib_path, lib_path_size);
+				dat_os_free(data->lib_path, data->lib_path_size);
 			}
 
 			if (NULL != data->ia_params) {
-				dat_os_free(data->ia_params, ia_params_size);
+				dat_os_free(data->ia_params, data->ia_params_size);
 			}
 
 			dat_os_free(data, sizeof(DAT_SR_ENTRY));
@@ -218,6 +221,42 @@ dat_sr_insert(IN const DAT_PROVIDER_INFO * info, IN DAT_SR_ENTRY * entry)
 //***********************************************************************
 // Function: dat_sr_size
 //***********************************************************************
+extern DAT_RETURN dat_sr_remove(IN const DAT_PROVIDER_INFO *info)
+{
+	DAT_DICTIONARY_ENTRY dict_entry = NULL;
+	DAT_RETURN status = DAT_ERROR(DAT_PROVIDER_IN_USE, 0);
+	DAT_SR_ENTRY *data;
+
+	dat_os_lock(&g_sr_lock);
+	status = dat_dictionary_search(g_sr_dictionary, info,
+				       (DAT_DICTIONARY_DATA)&data);
+	if (DAT_SUCCESS != status)
+		goto bail;
+
+	if (0 != ((DAT_SR_ENTRY *) data)->ref_count)
+		goto bail;
+
+	status = dat_dictionary_remove(g_sr_dictionary,
+				       &dict_entry, info,
+				       (DAT_DICTIONARY_DATA)&data);
+	if (DAT_SUCCESS != status)
+		goto bail;
+
+	dat_os_free(data->lib_path, data->lib_path_size);
+	dat_os_free(data->ia_params, data->ia_params_size);
+	dat_os_free(data, sizeof(DAT_SR_ENTRY));
+bail:
+	dat_os_unlock(&g_sr_lock);
+
+	if (NULL != dict_entry)
+		(void)dat_dictionary_entry_destroy(dict_entry);
+
+	return status;
+}
+
+//***********************************************************************
+// Function: dat_sr_size
+//***********************************************************************
 
 extern DAT_RETURN dat_sr_size(OUT DAT_COUNT * size)
 {
@@ -302,6 +341,62 @@ dat_sr_list(IN DAT_COUNT max_to_return,
 }
 
 //***********************************************************************
+// Function: dat_sr_remove_all()
+//***********************************************************************
+extern DAT_RETURN dat_sr_remove_all(IN  DAT_DICTIONARY *p_dictionary)
+{
+	int i;
+	DAT_RETURN status = DAT_ERROR(DAT_INSUFFICIENT_RESOURCES, DAT_RESOURCE_MEMORY);
+	DAT_COUNT entries = 0;
+	DAT_PROVIDER_INFO  **plist;
+
+	/* get provider count */
+	dat_sr_size(&entries);
+
+	/* need array of pointers to info */
+	plist = dat_os_alloc(entries * sizeof(DAT_PROVIDER_INFO *));
+	if (plist == NULL)
+		goto bail;
+
+	dat_os_memset(plist, 0, entries * sizeof(DAT_PROVIDER_INFO *));
+	for (i = 0; i < entries; i++ ) {
+		plist[i] = dat_os_alloc(sizeof(DAT_PROVIDER_INFO));
+		if (plist[i] == NULL)
+			goto bail;
+	}
+
+	/* remove and destroy each SR entry */
+	status = dat_sr_list(entries, &entries, plist);
+	if (DAT_SUCCESS != status)
+		goto bail;
+
+	for (i=0;i<entries;i++) {
+		status = dat_sr_remove(plist[i]);
+		if (DAT_SUCCESS != status) {
+			dat_os_dbg_print(DAT_OS_DBG_TYPE_SR,
+					 " WARNING: libdat2 remove SR"
+					 " provider: IA %s busy\n",
+					 plist[i]->ia_name);
+			goto bail;
+		}
+		dat_os_dbg_print(DAT_OS_DBG_TYPE_SR,
+				 " libdat2 removed SR"
+				 " provider: IA %s\n",
+				 plist[i]->ia_name);
+	}
+bail:
+	for (i = 0; i < entries; i++ ) {
+		if (plist[i] != NULL)
+			dat_os_free(plist[i], sizeof(DAT_PROVIDER_INFO));
+	}
+	dat_os_free(plist, entries * sizeof(DAT_PROVIDER_INFO *));
+
+	return status;
+
+}
+
+
+//***********************************************************************
 // Function: dat_sr_provider_open
 //***********************************************************************
 
diff --git a/dat/common/dat_sr.h b/dat/common/dat_sr.h
index 86be8a0..1990023 100644
--- a/dat/common/dat_sr.h
+++ b/dat/common/dat_sr.h
@@ -45,6 +45,7 @@
 #include <dat2/dat_registry.h>
 
 #include "dat_osd.h"
+#include "dat_dictionary.h"
 
 /*********************************************************************
  *                                                                   *
@@ -57,6 +58,8 @@ typedef struct DAT_SR_ENTRY
     DAT_PROVIDER_INFO 		info;
     char * 			lib_path;
     char * 			ia_params;
+    DAT_OS_SIZE			lib_path_size;
+    DAT_OS_SIZE			ia_params_size;
     DAT_OS_LIBRARY_HANDLE 	lib_handle;
     DAT_PROVIDER_INIT_FUNC 	init_func;
     DAT_PROVIDER_FINI_FUNC	fini_func;
@@ -82,6 +85,9 @@ dat_sr_insert (
     IN  const DAT_PROVIDER_INFO *info,
     IN  DAT_SR_ENTRY 		*entry );
 
+extern DAT_RETURN dat_sr_remove(
+    IN const DAT_PROVIDER_INFO  *info);
+
 extern DAT_RETURN
 dat_sr_size (
     OUT DAT_COUNT               *size);
@@ -93,6 +99,10 @@ dat_sr_list (
     OUT DAT_PROVIDER_INFO       * (dat_provider_list[]) );
 
 extern DAT_RETURN
+dat_sr_remove_all(
+    IN  DAT_DICTIONARY          *p_dictionary);
+
+extern DAT_RETURN
 dat_sr_provider_open (
     IN  const DAT_PROVIDER_INFO *info );
 
-- 
1.7.3



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
