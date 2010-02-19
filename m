From: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] uDAPL v2.0 Windows patch to fix IB_INVLAID_HANDLE name
 collision.
Date: Fri, 19 Feb 2010 14:57:21 -0800
Message-ID: <E3280858FA94444CA49D2BA02341C983B57CCDCB@orsmsx506.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Smith, Stan" <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: ofw_list <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Applied. Thanks!

-----Original Message-----
From: Smith, Stan 
Sent: Friday, February 19, 2010 2:42 PM
To: Davis, Arlin R
Subject: Windows patch to fix IB_INVLAID_HANDLE name collision.


signed-off-by: stan smith <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

diff U3 a/dapl/dapl/ibal/dapl_ibal_cm.c b/dapl/ibal/dapl_ibal_cm.c
--- a/dapl/ibal/dapl_ibal_cm.c	Fri Feb 19 14:03:58 2010
+++ b/dapl/ibal/dapl_ibal_cm.c	Fri Feb 19 14:15:22 2010
@@ -37,6 +37,12 @@
 #define  DAPL_ATS_NAME              ATS_NAME
 #define  HCA_IPV6_ADDRESS_LENGTH    16
 
+/* until dapl_ibal_util.h define of IB_INVALID_HANDLE which overlaps the
+ * Windows ib_types.h typedef enu ib_api_status_t IB_INVALID_HANDLE is fixed.
+ */
+#undef IB_INVALID_HANDLE
+#define DAPL_IB_INVALID_HANDLE NULL
+
 int g_dapl_loopback_connection = 0;
 extern dapl_ibal_root_t        dapl_ibal_root;
 
@@ -268,7 +274,7 @@
         return;
     }
 
-    if (ep_ptr->cm_handle == IB_INVALID_HANDLE )
+    if (ep_ptr->cm_handle == DAPL_IB_INVALID_HANDLE )
     {
          dapl_dbg_log (DAPL_DBG_TYPE_CM,
                   "--> %s: Invalid EP->CM handle?\n", __FUNCTION__); 
@@ -1013,9 +1019,10 @@
     {
          dapl_dbg_log (DAPL_DBG_TYPE_CM,
                   "--> %s: BAD EP Magic EP=%lx\n", __FUNCTION__,ep_ptr); 
+        return DAT_SUCCESS;
     }
 
-    if (ep_ptr->cm_handle == IB_INVALID_HANDLE )
+    if (ep_ptr->cm_handle == DAPL_IB_INVALID_HANDLE )
     {
          dapl_dbg_log (DAPL_DBG_TYPE_CM,
                   "--> %s: Invalid EP->CM handle, OK.\n", __FUNCTION__); 
@@ -1064,21 +1071,24 @@
     {
         ep_ptr->sent_discreq = DAT_TRUE;
         ib_status = ib_cm_dreq ( &cm_dreq );
+
+	if ( ib_status == IB_SUCCESS )
+	    dapl_dbg_log (DAPL_DBG_TYPE_CM,
+			"--> DsD: EP %p  DREQ SENT\n", ep_ptr);
+
 	/* tolerate INVALID_STATE error as the other side can race ahead and
 	 * generate a DREQ before we do.
 	 */
-	if ( ib_status == IB_INVALID_STATE )
+	if ( ib_status == IB_INVALID_STATE || ib_status == IB_INVALID_HANDLE )
+	{
 	    ib_status = IB_SUCCESS;
-
-	if (ib_status)
+	}
+	else if (ib_status)
 	{
 	    dapl_dbg_log(DAPL_DBG_TYPE_ERR,
 			"%s() EP %p ib_cm_dreq() status %s\n",
 			__FUNCTION__,ep_ptr,ib_get_err_str(ib_status));
 	}
-	if ( ib_status == IB_SUCCESS )
-        dapl_dbg_log (DAPL_DBG_TYPE_CM,
-				"--> DsD: EP %p  DREQ SENT\n", ep_ptr);
     }
     return ib_status;
 }
@@ -1650,7 +1660,7 @@
         return DAT_INVALID_PARAMETER;
     }
 
-    if (cr_ptr->sp_ptr == IB_INVALID_HANDLE)
+    if (cr_ptr->sp_ptr == DAPL_IB_INVALID_HANDLE)
     {
         dapl_dbg_log ( DAPL_DBG_TYPE_ERR,
                        "--> DsCH: CR = %lx invalid psp handle\n", cr_ptr);
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
