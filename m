From: Ursula Braun <ubraun@linux.ibm.com>
Subject: [PATCH net 3/4] net/smc: delete rkey first before switching to unused
Date: Mon,  4 Feb 2019 13:44:46 +0100
Message-ID: <20190204124447.39816-4-ubraun@linux.ibm.com>
References: <20190204124447.39816-1-ubraun@linux.ibm.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190204124447.39816-1-ubraun@linux.ibm.com>
Sender: netdev-owner@vger.kernel.org
To: davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, raspl@linux.ibm.com, ubraun@linux.ibm.com
List-Id: linux-rdma@vger.kernel.org

Once RMBs are flagged as unused they are candidates for reuse.
Thus the LLC DELETE RKEY operaton should be made before flagging
the RMB as unused.

Fixes: c7674c001b11 ("net/smc: unregister rkeys of unused buffer")
Signed-off-by: Ursula Braun <ubraun@linux.ibm.com>
---
 net/smc/smc_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index 097c798983ca..aa1c551cee81 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -302,13 +302,13 @@ static void smc_buf_unuse(struct smc_connection *conn,
 		conn->sndbuf_desc->used = 0;
 	if (conn->rmb_desc) {
 		if (!conn->rmb_desc->regerr) {
-			conn->rmb_desc->used = 0;
 			if (!lgr->is_smcd) {
 				/* unregister rmb with peer */
 				smc_llc_do_delete_rkey(
 						&lgr->lnk[SMC_SINGLE_LINK],
 						conn->rmb_desc);
 			}
+			conn->rmb_desc->used = 0;
 		} else {
 			/* buf registration failed, reuse not possible */
 			write_lock_bh(&lgr->rmbs_lock);
-- 
2.16.4
