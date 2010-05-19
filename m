From: "Davis, Arlin R" <arlin.r.davis@intel.com>
Subject: [PATCH 2/2] compat-dapl-1.2: cma: memory leak of verbs CQ and
 completion channels created during dat_ia_open
Date: Wed, 19 May 2010 09:43:02 -0700
Message-ID: <E3280858FA94444CA49D2BA02341C983C7012E96@orsmsx506.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <ofw-bounces@lists.openfabrics.org>
Content-Language: en-US
List-Unsubscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ofw>,
	<mailto:ofw-request@lists.openfabrics.org?subject=unsubscribe>
List-Archive: <http://lists.openfabrics.org/pipermail/ofw>
List-Post: <mailto:ofw@lists.openfabrics.org>
List-Help: <mailto:ofw-request@lists.openfabrics.org?subject=help>
List-Subscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ofw>,
	<mailto:ofw-request@lists.openfabrics.org?subject=subscribe>
Sender: ofw-bounces@lists.openfabrics.org
Errors-To: ofw-bounces@lists.openfabrics.org
To: "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, ofw_list <ofw@lists.openfabrics.org>
List-Id: linux-rdma@vger.kernel.org

 
check/cleanup CQ and completion channels during dat_ia_close

Signed-off-by: Arlin Davis <arlin.r.davis@intel.com>
---
 dapl/openib_cma/dapl_ib_util.c |   22 ++++++++++++++++------
 1 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/dapl/openib_cma/dapl_ib_util.c b/dapl/openib_cma/dapl_ib_util.c
index 9d97ae1..00aa5fb 100755
--- a/dapl/openib_cma/dapl_ib_util.c
+++ b/dapl/openib_cma/dapl_ib_util.c
@@ -373,12 +373,6 @@ DAT_RETURN dapls_ib_close_hca(IN DAPL_HCA *hca_ptr)
 	dapl_dbg_log(DAPL_DBG_TYPE_UTIL," close_hca: %p->%p\n",
 		     hca_ptr,hca_ptr->ib_hca_handle);
 
-	if (hca_ptr->ib_hca_handle != IB_INVALID_HANDLE) {
-		if (rdma_destroy_id(hca_ptr->ib_trans.cm_id)) 
-			return(dapl_convert_errno(errno,"ib_close_device"));
-		hca_ptr->ib_hca_handle = IB_INVALID_HANDLE;
-	}
-
 	dapl_os_lock(&g_hca_lock);
 	if (g_ib_thread_state != IB_THREAD_RUN) {
 		dapl_os_unlock(&g_hca_lock);
@@ -410,6 +404,22 @@ DAT_RETURN dapls_ib_close_hca(IN DAPL_HCA *hca_ptr)
 		nanosleep (&sleep, &remain);
 	}
 bail:
+	if (hca_ptr->ib_trans.ib_cq)
+		ibv_destroy_comp_channel(hca_ptr->ib_trans.ib_cq);
+
+	if (hca_ptr->ib_trans.ib_cq_empty) {
+		struct ibv_comp_channel *channel;
+		channel = hca_ptr->ib_trans.ib_cq_empty->channel;
+		ibv_destroy_cq(hca_ptr->ib_trans.ib_cq_empty);
+		ibv_destroy_comp_channel(channel);
+	}
+
+	if (hca_ptr->ib_hca_handle != IB_INVALID_HANDLE) {
+		if (rdma_destroy_id(hca_ptr->ib_trans.cm_id))
+			return (dapl_convert_errno(errno, "ib_close_device"));
+		hca_ptr->ib_hca_handle = IB_INVALID_HANDLE;
+	}
+
 	return (DAT_SUCCESS);
 }
   
-- 
1.5.2.5
