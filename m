From: "Stan C. Smith" <stan.smith@intel.com>
Subject: [PATCH] opensm - use uintptr_t instead of unsigned long
Date: Mon, 12 Oct 2009 09:23:48 -0700
Message-ID: <F2E0E9BDB4F2489992B2747077F52652@amr.corp.intel.com>
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
Cc: ofw@lists.openfabrics.org, 'linux-rdma' <linux-rdma@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org


 sizeof unsigned long != sizeof void * in Windows world
Use correct type.

Signed-off-by: stan smith <stan.smith@intel.com>

diff --git a/opensm/include/opensm/st.h b/opensm/include/opensm/st.h
index 30cc308..fc558c8 100644
--- a/opensm/include/opensm/st.h
+++ b/opensm/include/opensm/st.h
@@ -49,7 +49,7 @@
 #endif				/* __cplusplus */
 
 BEGIN_C_DECLS
-#define st_ptr_t unsigned long
+#define st_ptr_t uintptr_t
 typedef st_ptr_t st_data_t;
 
 #define ST_DATA_T_DEFINED
