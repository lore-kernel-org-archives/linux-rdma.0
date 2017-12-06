From: Prashant Bhole <bhole_prashant_q7@lab.ntt.co.jp>
Subject: [PATCH net-next] rds: debug: fix null check on static array
Date: Wed,  6 Dec 2017 10:47:04 +0900
Message-ID: <20171206014704.3796-1-bhole_prashant_q7@lab.ntt.co.jp>
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
To: "David S . Miller" <davem@davemloft.net>
Cc: Prashant Bhole <bhole_prashant_q7@lab.ntt.co.jp>, netdev@vger.kernel.org, Santosh Shilimkar <santosh.shilimkar@oracle.com>, linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com
List-Id: linux-rdma@vger.kernel.org

t_name cannot be NULL since it is an array field of a struct.
Replacing null check on static array with string length check using
strnlen()

Signed-off-by: Prashant Bhole <bhole_prashant_q7@lab.ntt.co.jp>
---
 net/rds/connection.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/rds/connection.c b/net/rds/connection.c
index 9efc82c665b5..6492c0b608a4 100644
--- a/net/rds/connection.c
+++ b/net/rds/connection.c
@@ -230,8 +230,8 @@ static struct rds_connection *__rds_conn_create(struct net *net,
 
 	rdsdebug("allocated conn %p for %pI4 -> %pI4 over %s %s\n",
 	  conn, &laddr, &faddr,
-	  trans->t_name ? trans->t_name : "[unknown]",
-	  is_outgoing ? "(outgoing)" : "");
+	  strnlen(trans->t_name, sizeof(trans->t_name)) ? trans->t_name :
+	  "[unknown]", is_outgoing ? "(outgoing)" : "");
 
 	/*
 	 * Since we ran without holding the conn lock, someone could
-- 
2.13.6
