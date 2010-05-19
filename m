From: "Davis, Arlin R" <arlin.r.davis@intel.com>
Subject: [PATCH 02/12] dapl-2.0: common: missed linking changes from
 atomic to acquire/release
Date: Wed, 19 May 2010 11:11:22 -0700
Message-ID: <E3280858FA94444CA49D2BA02341C983C7013083@orsmsx506.amr.corp.intel.com>
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

 

Signed-off-by: Arlin Davis <arlin.r.davis@intel.com>
---
 dapl/common/dapl_ep_util.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/dapl/common/dapl_ep_util.c b/dapl/common/dapl_ep_util.c
index bd7cdd9..daad78d 100644
--- a/dapl/common/dapl_ep_util.c
+++ b/dapl/common/dapl_ep_util.c
@@ -417,7 +417,7 @@ void dapls_ep_timeout(uintptr_t arg)
 	 * The disconnect_clean interface requires the provided dependent 
 	 *cm event number.
 	 */
-	ib_cm_event = dapls_ib_get_cm_event(DAT_CONNECTION_EVENT_DISCONNECTED);
+	ib_cm_event = dapls_ib_get_cm_event(DAT_CONNECTION_EVENT_TIMED_OUT);
 	dapls_ib_disconnect_clean(ep_ptr, DAT_TRUE, ib_cm_event);
 
 	(void)dapls_evd_post_connection_event((DAPL_EVD *) ep_ptr->param.
@@ -590,7 +590,6 @@ dapl_ep_legacy_post_disconnect(DAPL_EP * ep_ptr,
  *	dp_ib_cm_handle_t *cm_ptr  defined in provider's dapl_util.h
  *
  *	CM objects linked with EP using  ->list_entry
- *      CM objects sync'ed with EP using ->ref_count
  * Output:
  * 	none
  *
@@ -601,7 +600,7 @@ dapl_ep_legacy_post_disconnect(DAPL_EP * ep_ptr,
 void dapl_ep_link_cm(IN DAPL_EP *ep_ptr, IN dp_ib_cm_handle_t cm_ptr)
 {
 	dapl_os_lock(&ep_ptr->header.lock);
-	dapl_os_atomic_inc(&cm_ptr->ref_count);
+	dapls_cm_acquire(cm_ptr);
 	dapl_llist_add_tail(&ep_ptr->cm_list_head, &cm_ptr->list_entry, cm_ptr);
 	dapl_os_unlock(&ep_ptr->header.lock);
 }
@@ -610,7 +609,7 @@ void dapl_ep_unlink_cm(IN DAPL_EP *ep_ptr, IN dp_ib_cm_handle_t cm_ptr)
 {
 	dapl_os_lock(&ep_ptr->header.lock);
 	dapl_llist_remove_entry(&ep_ptr->cm_list_head, &cm_ptr->list_entry);
-	dapl_os_atomic_dec(&cm_ptr->ref_count);
+	dapls_cm_release(cm_ptr);
 	dapl_os_unlock(&ep_ptr->header.lock);
 }
 
-- 
1.5.2.5
