From: Zhu Yanjun <yanjun.zhu@oracle.com>
Subject: [PATCHv2 1/1] net: rds: add per rds connection cache statistics
Date: Mon,  3 Jun 2019 00:28:01 -0400
Message-ID: <1559536081-25401-1-git-send-email-yanjun.zhu@oracle.com>
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
To: santosh.shilimkar@oracle.com, davem@davemloft.net, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com
List-Id: linux-rdma@vger.kernel.org

The variable cache_allocs is to indicate how many frags (KiB) are in one
rds connection frag cache.
The command "rds-info -Iv" will output the rds connection cache
statistics as below:
"
RDS IB Connections:
      LocalAddr RemoteAddr Tos SL  LocalDev            RemoteDev
      1.1.1.14 1.1.1.14   58 255  fe80::2:c903:a:7a31 fe80::2:c903:a:7a31
      send_wr=256, recv_wr=1024, send_sge=8, rdma_mr_max=4096,
      rdma_mr_size=257, cache_allocs=12
"
This means that there are about 12KiB frag in this rds connection frag
cache. 
Since rds.h in rds-tools is not related with the kernel rds.h, the change
in kernel rds.h does not affect rds-tools.
rds-info in rds-tools 2.0.5 and 2.0.6 is tested with this commit. It works
well.

Signed-off-by: Zhu Yanjun <yanjun.zhu@oracle.com>
---
V1->V2: RDS CI is removed. 
---
 include/uapi/linux/rds.h | 2 ++
 net/rds/ib.c             | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/include/uapi/linux/rds.h b/include/uapi/linux/rds.h
index 5d0f76c..fd6b5f6 100644
--- a/include/uapi/linux/rds.h
+++ b/include/uapi/linux/rds.h
@@ -250,6 +250,7 @@ struct rds_info_rdma_connection {
 	__u32		rdma_mr_max;
 	__u32		rdma_mr_size;
 	__u8		tos;
+	__u32		cache_allocs;
 };
 
 struct rds6_info_rdma_connection {
@@ -264,6 +265,7 @@ struct rds6_info_rdma_connection {
 	__u32		rdma_mr_max;
 	__u32		rdma_mr_size;
 	__u8		tos;
+	__u32		cache_allocs;
 };
 
 /* RDS message Receive Path Latency points */
diff --git a/net/rds/ib.c b/net/rds/ib.c
index 2da9b75..f9baf2d 100644
--- a/net/rds/ib.c
+++ b/net/rds/ib.c
@@ -318,6 +318,7 @@ static int rds_ib_conn_info_visitor(struct rds_connection *conn,
 		iinfo->max_recv_wr = ic->i_recv_ring.w_nr;
 		iinfo->max_send_sge = rds_ibdev->max_sge;
 		rds_ib_get_mr_info(rds_ibdev, iinfo);
+		iinfo->cache_allocs = atomic_read(&ic->i_cache_allocs);
 	}
 	return 1;
 }
@@ -351,6 +352,7 @@ static int rds6_ib_conn_info_visitor(struct rds_connection *conn,
 		iinfo6->max_recv_wr = ic->i_recv_ring.w_nr;
 		iinfo6->max_send_sge = rds_ibdev->max_sge;
 		rds6_ib_get_mr_info(rds_ibdev, iinfo6);
+		iinfo6->cache_allocs = atomic_read(&ic->i_cache_allocs);
 	}
 	return 1;
 }
-- 
2.7.4
