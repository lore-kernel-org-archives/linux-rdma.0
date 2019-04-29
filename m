From: Nicholas Mc Guire <hofrat@osadl.org>
Subject: [PATCH] rds: ib: force endiannes annotation
Date: Mon, 29 Apr 2019 08:09:38 +0200
Message-ID: <1556518178-13786-1-git-send-email-hofrat@osadl.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Santosh Shilimkar <santosh.shilimkar@oracle.com>
Cc: "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com, linux-kernel@vger.kernel.org, Nicholas Mc Guire <hofrat@osadl.org>
List-Id: linux-rdma@vger.kernel.org

While the endiannes is being handled correctly as indicated by the comment
above the offending line - sparse was unhappy with the missing annotation
as be64_to_cpu() expects a __be64 argument. To mitigate this annotation
issue forced annotation is introduced. Note that this patch has no impact
on the generated binary.

Signed-off-by: Nicholas Mc Guire <hofrat@osadl.org>
---

Problem located by an experimental coccinelle script to locate
patters that make sparse unhappy (false positives):
net/rds/ib_recv.c:827:23: warning: cast to restricted __le64

Patch was compile-tested with: x86_64_defconfig + RDS_RDMA=m

Patch was verified not to change the binary by diffing the
generated object code before and after applying the patch.

Patch is against 5.1-rc6 (localversion-next is 20190426)

 net/rds/ib_recv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/rds/ib_recv.c b/net/rds/ib_recv.c
index 7055985..a070a2d 100644
--- a/net/rds/ib_recv.c
+++ b/net/rds/ib_recv.c
@@ -824,7 +824,7 @@ static void rds_ib_cong_recv(struct rds_connection *conn,
 	}
 
 	/* the congestion map is in little endian order */
-	uncongested = le64_to_cpu(uncongested);
+	uncongested = le64_to_cpu((__force __le64)uncongested);
 
 	rds_cong_map_updated(map, uncongested);
 }
-- 
2.1.4
