From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next 01/15] rds: Don't check return value from destroy CQ
Date: Mon, 20 May 2019 09:54:19 +0300
Message-ID: <20190520065433.8734-2-leon@kernel.org>
References: <20190520065433.8734-1-leon@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190520065433.8734-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Santosh Shilimkar <santosh.shilimkar@oracle.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Glenn Streiff <gstreiff@neteffect.com>, Steve Wise <swise@opengridcomputing.com>, "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

There is no value in checking ib_destroy_cq() result and skipping
to clear struct ic fields. This connection needs to be reinitialized
anyway.

Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 net/rds/ib_cm.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/rds/ib_cm.c b/net/rds/ib_cm.c
index 66c6eb56072b..5a42ebb892cd 100644
--- a/net/rds/ib_cm.c
+++ b/net/rds/ib_cm.c
@@ -611,11 +611,11 @@ static int rds_ib_setup_qp(struct rds_connection *conn)
 qp_out:
 	rdma_destroy_qp(ic->i_cm_id);
 recv_cq_out:
-	if (!ib_destroy_cq(ic->i_recv_cq))
-		ic->i_recv_cq = NULL;
+	ib_destroy_cq(ic->i_recv_cq);
+	ic->i_recv_cq = NULL;
 send_cq_out:
-	if (!ib_destroy_cq(ic->i_send_cq))
-		ic->i_send_cq = NULL;
+	ib_destroy_cq(ic->i_send_cq);
+	ic->i_send_cq = NULL;
 rds_ibdev_out:
 	rds_ib_remove_conn(rds_ibdev, conn);
 out:
