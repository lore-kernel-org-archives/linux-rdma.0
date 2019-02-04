From: Ursula Braun <ubraun@linux.ibm.com>
Subject: [PATCH net 4/4] net/smc: correct state change for peer closing
Date: Mon,  4 Feb 2019 13:44:47 +0100
Message-ID: <20190204124447.39816-5-ubraun@linux.ibm.com>
References: <20190204124447.39816-1-ubraun@linux.ibm.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190204124447.39816-1-ubraun@linux.ibm.com>
Sender: netdev-owner@vger.kernel.org
To: davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, raspl@linux.ibm.com, ubraun@linux.ibm.com
List-Id: linux-rdma@vger.kernel.org

If some kind of closing is received from the peer while still in
state SMC_INIT, it means the peer has had an active connection and
closed the socket quickly before listen_work finished. This should
not result in a shortcut from state SMC_INIT to state SMC_CLOSED.
This patch adds the socket to the accept queue in state
SMC_APPCLOSEWAIT1. The socket reaches state SMC_CLOSED once being
accepted and closed with smc_release().

Signed-off-by: Ursula Braun <ubraun@linux.ibm.com>
---
 net/smc/smc_close.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/net/smc/smc_close.c b/net/smc/smc_close.c
index ea2b87f29469..e39cadda1bf5 100644
--- a/net/smc/smc_close.c
+++ b/net/smc/smc_close.c
@@ -345,14 +345,7 @@ static void smc_close_passive_work(struct work_struct *work)
 
 	switch (sk->sk_state) {
 	case SMC_INIT:
-		if (atomic_read(&conn->bytes_to_rcv) ||
-		    (rxflags->peer_done_writing &&
-		     !smc_cdc_rxed_any_close(conn))) {
-			sk->sk_state = SMC_APPCLOSEWAIT1;
-		} else {
-			sk->sk_state = SMC_CLOSED;
-			sock_put(sk); /* passive closing */
-		}
+		sk->sk_state = SMC_APPCLOSEWAIT1;
 		break;
 	case SMC_ACTIVE:
 		sk->sk_state = SMC_APPCLOSEWAIT1;
-- 
2.16.4
