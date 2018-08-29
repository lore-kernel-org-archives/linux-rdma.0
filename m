From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH net-next] rds: store socket timestamps as ktime_t
Date: Wed, 29 Aug 2018 17:47:19 +0200
Message-ID: <20180829154732.844217-1-arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Santosh Shilimkar <santosh.shilimkar@oracle.com>, "David S. Miller" <davem@davemloft.net>
Cc: Arnd Bergmann <arnd@arndb.de>, Sowmini Varadhan <sowmini.varadhan@oracle.com>, Willem de Bruijn <willemb@google.com>, Ka-Cheong Poon <ka-cheong.poon@oracle.com>, Salvatore Mesoraca <s.mesoraca16@gmail.com>, Avinash Repaka <avinash.repaka@oracle.com>, Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

rds is the last in-kernel user of the old do_gettimeofday()
function. Convert it over to ktime_get_real() to make it
work more like the generic socket timestamps, and to let
us kill off do_gettimeofday().

A follow-up patch will have to change the user space interface
to deal better with 32-bit tasks, which may use an incompatible
layout for 'struct timespec'.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 net/rds/rds.h  |  2 +-
 net/rds/recv.c | 14 ++++++--------
 2 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/net/rds/rds.h b/net/rds/rds.h
index c4dcf654d8fe..6bfaf05b63b2 100644
--- a/net/rds/rds.h
+++ b/net/rds/rds.h
@@ -278,7 +278,7 @@ struct rds_incoming {
 	struct in6_addr		i_saddr;
 
 	rds_rdma_cookie_t	i_rdma_cookie;
-	struct timeval		i_rx_tstamp;
+	ktime_t			i_rx_tstamp;
 	u64			i_rx_lat_trace[RDS_RX_MAX_TRACES];
 };
 
diff --git a/net/rds/recv.c b/net/rds/recv.c
index 504cd6bcc54c..12719653188a 100644
--- a/net/rds/recv.c
+++ b/net/rds/recv.c
@@ -50,8 +50,7 @@ void rds_inc_init(struct rds_incoming *inc, struct rds_connection *conn,
 	inc->i_conn = conn;
 	inc->i_saddr = *saddr;
 	inc->i_rdma_cookie = 0;
-	inc->i_rx_tstamp.tv_sec = 0;
-	inc->i_rx_tstamp.tv_usec = 0;
+	inc->i_rx_tstamp = ktime_set(0, 0);
 
 	for (i = 0; i < RDS_RX_MAX_TRACES; i++)
 		inc->i_rx_lat_trace[i] = 0;
@@ -67,8 +66,7 @@ void rds_inc_path_init(struct rds_incoming *inc, struct rds_conn_path *cp,
 	inc->i_conn_path = cp;
 	inc->i_saddr = *saddr;
 	inc->i_rdma_cookie = 0;
-	inc->i_rx_tstamp.tv_sec = 0;
-	inc->i_rx_tstamp.tv_usec = 0;
+	inc->i_rx_tstamp = ktime_set(0, 0);
 }
 EXPORT_SYMBOL_GPL(rds_inc_path_init);
 
@@ -385,7 +383,7 @@ void rds_recv_incoming(struct rds_connection *conn, struct in6_addr *saddr,
 				      be32_to_cpu(inc->i_hdr.h_len),
 				      inc->i_hdr.h_dport);
 		if (sock_flag(sk, SOCK_RCVTSTAMP))
-			do_gettimeofday(&inc->i_rx_tstamp);
+			inc->i_rx_tstamp = ktime_get_real();
 		rds_inc_addref(inc);
 		inc->i_rx_lat_trace[RDS_MSG_RX_END] = local_clock();
 		list_add_tail(&inc->i_item, &rs->rs_recv_queue);
@@ -552,11 +550,11 @@ static int rds_cmsg_recv(struct rds_incoming *inc, struct msghdr *msg,
 			goto out;
 	}
 
-	if ((inc->i_rx_tstamp.tv_sec != 0) &&
+	if ((inc->i_rx_tstamp != 0) &&
 	    sock_flag(rds_rs_to_sk(rs), SOCK_RCVTSTAMP)) {
+		struct timeval tv = ktime_to_timeval(inc->i_rx_tstamp);
 		ret = put_cmsg(msg, SOL_SOCKET, SCM_TIMESTAMP,
-			       sizeof(struct timeval),
-			       &inc->i_rx_tstamp);
+			       sizeof(tv), &tv);
 		if (ret)
 			goto out;
 	}
-- 
2.18.0
