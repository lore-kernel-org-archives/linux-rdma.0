From: Ursula Braun <ubraun@linux.vnet.ibm.com>
Subject: [PATCH net-next 10/10] net/smc: no close wait in case of process shut down
Date: Wed, 20 Sep 2017 13:58:13 +0200
Message-ID: <20170920115813.63745-11-ubraun@linux.vnet.ibm.com>
References: <20170920115813.63745-1-ubraun@linux.vnet.ibm.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20170920115813.63745-1-ubraun@linux.vnet.ibm.com>
Sender: netdev-owner@vger.kernel.org
To: davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, linux-s390@vger.kernel.org, jwi@linux.vnet.ibm.com, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, raspl@linux.vnet.ibm.com, ubraun@linux.vnet.ibm.com
List-Id: linux-rdma@vger.kernel.org

Usually socket closing is delayed if there is still data available in
the send buffer to be transmitted. If a process is killed, the delay
should be avoided.

Signed-off-by: Ursula Braun <ubraun@linux.vnet.ibm.com>
---
 net/smc/smc_close.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/net/smc/smc_close.c b/net/smc/smc_close.c
index 5201bc103bd8..f0d16fb825f7 100644
--- a/net/smc/smc_close.c
+++ b/net/smc/smc_close.c
@@ -174,15 +174,15 @@ int smc_close_active(struct smc_sock *smc)
 {
 	struct smc_cdc_conn_state_flags *txflags =
 		&smc->conn.local_tx_ctrl.conn_state_flags;
-	long timeout = SMC_MAX_STREAM_WAIT_TIMEOUT;
 	struct smc_connection *conn = &smc->conn;
 	struct sock *sk = &smc->sk;
 	int old_state;
+	long timeout;
 	int rc = 0;
 
-	if (sock_flag(sk, SOCK_LINGER) &&
-	    !(current->flags & PF_EXITING))
-		timeout = sk->sk_lingertime;
+	timeout = current->flags & PF_EXITING ?
+		  0 : sock_flag(sk, SOCK_LINGER) ?
+		      sk->sk_lingertime : SMC_MAX_STREAM_WAIT_TIMEOUT;
 
 again:
 	old_state = sk->sk_state;
@@ -413,13 +413,14 @@ void smc_close_sock_put_work(struct work_struct *work)
 int smc_close_shutdown_write(struct smc_sock *smc)
 {
 	struct smc_connection *conn = &smc->conn;
-	long timeout = SMC_MAX_STREAM_WAIT_TIMEOUT;
 	struct sock *sk = &smc->sk;
 	int old_state;
+	long timeout;
 	int rc = 0;
 
-	if (sock_flag(sk, SOCK_LINGER))
-		timeout = sk->sk_lingertime;
+	timeout = current->flags & PF_EXITING ?
+		  0 : sock_flag(sk, SOCK_LINGER) ?
+		      sk->sk_lingertime : SMC_MAX_STREAM_WAIT_TIMEOUT;
 
 again:
 	old_state = sk->sk_state;
-- 
2.13.5
