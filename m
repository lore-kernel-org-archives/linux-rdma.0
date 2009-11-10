From: "Stan C. Smith" <stan.smith@intel.com>
Subject: [PATCH] opensm - use C99 transportable data type for pointer
	storage
Date: Mon, 9 Nov 2009 17:48:08 -0800
Message-ID: <086F8B40ADA84EE7B6398F4761937836@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <ofw-bounces@lists.openfabrics.org>
List-Unsubscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ofw>,
	<mailto:ofw-request@lists.openfabrics.org?subject=unsubscribe>
List-Archive: <http://lists.openfabrics.org/pipermail/ofw>
List-Post: <mailto:ofw@lists.openfabrics.org>
List-Help: <mailto:ofw-request@lists.openfabrics.org?subject=help>
List-Subscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ofw>,
	<mailto:ofw-request@lists.openfabrics.org?subject=subscribe>
Sender: ofw-bounces@lists.openfabrics.org
Errors-To: ofw-bounces@lists.openfabrics.org
To: 'Sasha Khapyorsky' <sashak@voltaire.com>
Cc: linux-rdma@vger.kernel.org, ofw@lists.openfabrics.org
List-Id: linux-rdma@vger.kernel.org


In order to skip the #ifndef __WIN__ around #include <stdint.h>, inttypes.h was used.
'inttypes.h' includes stdint.h and exists in the WinOF svn tree.
OFED opensm builds without problems on EL 5.3.

Signed-off-by: stan smith <stan.smith@intel.com>

diff --git a/opensm/include/opensm/st.h b/opensm/include/opensm/st.h
index 30cc308..ad6c289 100644
--- a/opensm/include/opensm/st.h
+++ b/opensm/include/opensm/st.h
@@ -39,6 +39,7 @@
 #define ST_INCLUDED
 
 #include <stdlib.h>
+#include <inttypes.h>
 
 #ifdef __cplusplus
 #  define BEGIN_C_DECLS extern "C" {
@@ -49,7 +50,7 @@
 #endif				/* __cplusplus */
 
 BEGIN_C_DECLS
-#define st_ptr_t unsigned long
+#define st_ptr_t uintptr_t
 typedef st_ptr_t st_data_t;
 
 #define ST_DATA_T_DEFINED
