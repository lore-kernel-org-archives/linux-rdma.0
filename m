From: Ursula Braun <ubraun-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: [RFC net-next 01/10] net/smc: serialize connection creation in all cases
Date: Thu, 20 Jul 2017 14:09:37 +0200
Message-ID: <20170720120946.67234-2-ubraun@linux.vnet.ibm.com>
References: <20170720120946.67234-1-ubraun@linux.vnet.ibm.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170720120946.67234-1-ubraun-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: hch-jcswGhMUV9g@public.gmane.org, schwidefsky-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org, heiko.carstens-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org, hwippel-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, raspl-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, ubraun-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

If a link group for a new server connection exists already, the mutex
serializing the determination of link groups is given up early.
The coming registration of memory regions benefits from the serialization
as well, if the mutex is held till connection creation is finished.
This patch postpones the unlocking of the link group creation mutex.

Signed-off-by: Ursula Braun <ubraun-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
---
 net/smc/af_smc.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index 6793d7348cc8..120a7b9b4d8e 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -779,11 +779,6 @@ static void smc_listen_work(struct work_struct *work)
 	mutex_lock(&smc_create_lgr_pending);
 	local_contact = smc_conn_create(new_smc, peeraddr.sin_addr.s_addr,
 					smcibdev, ibport, &pclc.lcl, 0);
-	if (local_contact == SMC_REUSE_CONTACT)
-		/* lock no longer needed, free it due to following
-		 * smc_clc_wait_msg() call
-		 */
-		mutex_unlock(&smc_create_lgr_pending);
 	if (local_contact < 0) {
 		rc = local_contact;
 		if (rc == -ENOMEM)
@@ -853,8 +848,7 @@ static void smc_listen_work(struct work_struct *work)
 	if (newsmcsk->sk_state == SMC_INIT)
 		newsmcsk->sk_state = SMC_ACTIVE;
 enqueue:
-	if (local_contact == SMC_FIRST_CONTACT)
-		mutex_unlock(&smc_create_lgr_pending);
+	mutex_unlock(&smc_create_lgr_pending);
 	lock_sock_nested(&lsmc->sk, SINGLE_DEPTH_NESTING);
 	if (lsmc->sk.sk_state == SMC_LISTEN) {
 		smc_accept_enqueue(&lsmc->sk, newsmcsk);
-- 
2.11.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
