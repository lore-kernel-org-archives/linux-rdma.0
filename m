From: "Stan C. Smith" <stan.smith@intel.com>
Subject: [PATCH] opensm - use uintptr_t instead of unsigned long
Date: Thu, 8 Oct 2009 10:12:03 -0700
Message-ID: <B4D2EF981C584307AA9204669ECE3F31@amr.corp.intel.com>
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


 sizeof unsigned long != sizeof void * in Windows world.

If you can live with uintptr_t for 
  __WORDSIZE == 32 being 'unsigned int' (see stdint.h)
  __WORDSIZE == 64 uintptr_t is 'unsigned long int'
then we could skip the ifdef __GNUC__ and just replace 'unsigned long' with uintptr_t.

Stan.

Signed-off-by: stan smith <stan.smith@intel.com>

diff --git a/opensm/include/opensm/st.h b/opensm/include/opensm/st.h
index 30cc308..dd7eacc 100644
--- a/opensm/include/opensm/st.h
+++ b/opensm/include/opensm/st.h
@@ -49,7 +49,11 @@
 #endif				/* __cplusplus */
 
 BEGIN_C_DECLS
+#ifdef __GNUC__
 #define st_ptr_t unsigned long
+#else
+#define st_ptr_t uintptr_t
+#endif
 typedef st_ptr_t st_data_t;
 
 #define ST_DATA_T_DEFINED
