Received: from outbound.baidu.com (mx14.baidu.com [220.181.3.101])
	by smtp.subspace.kernel.org (Postfix) with SMTP id 02786201278;
	Sun, 16 Aug 2026 03:56:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.181.3.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786852596; cv=none; b=Qe+ZaYY4x9eoWpKhbXgUfqALNZWB7wQLAC8qHTqLGJc2qt+nju4Kb8McM4aQsn+T7odVJ//TeavNqU2fb80aYDeeFI8RcIbv3GS6RWskkMU7TpiVtU5QIQOpSTmtBxLUo36EpGXGfuE+y+oaWvqKpoZN7I9iklriTWL8kZrbGkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786852596; c=relaxed/simple;
	bh=6cbLuym+1cqRI7P7D4gMdqm+OHpINkJYcn9natJyGsk=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Oie0GtLXvxSfWw5YGXDMUw7AvnbWSUxc3X7kyIu6eo9g3omFCQiXIulbhKv6bQvKgYIWkihOdKQkyf7ceMLhtzcYJTKMECKgXY+m6iH0z0587JTu7bgTfxKaAu8hpe/HrAC2lwowa3qSAV/Sm71I73wpyAB0MsEJRblwsJi+PlE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com; spf=pass smtp.mailfrom=baidu.com; dkim=pass (2048-bit key) header.d=baidu.com header.i=@baidu.com header.b=NTLoGFoI; arc=none smtp.client-ip=220.181.3.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baidu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=baidu.com header.i=@baidu.com header.b="NTLoGFoI"
X-MD-Sfrom: lirongqing@baidu.com
X-MD-SrcIP: 172.31.50.47
From: lirongqing <lirongqing@baidu.com>
To: Saeed Mahameed <saeedm@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
	Tariq Toukan <tariqt@nvidia.com>, Mark Bloch <mbloch@nvidia.com>, Andrew Lunn
	<andrew+netdev@lunn.ch>, "David S . Miller" <davem@davemloft.net>, Eric
 Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann
	<daniel@iogearbox.net>, Jesper Dangaard Brouer <hawk@kernel.org>, John
 Fastabend <john.fastabend@gmail.com>, Stanislav Fomichev <sdf@fomichev.me>,
	Boris Pismenny <borisp@nvidia.com>, Richard Cochran
	<richardcochran@gmail.com>, Cosmin Ratiu <cratiu@nvidia.com>, Dragos Tatulea
	<dtatulea@nvidia.com>, Carolina Jubran <cjubran@nvidia.com>, Li RongQing
	<lirongqing@baidu.com>, Kees Cook <kees@kernel.org>, Akiva Goldberger
	<agoldberger@nvidia.com>, Simon Horman <horms@kernel.org>,
	<netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <bpf@vger.kernel.org>
Subject: [PATCH net-next, v3] net/mlx5: Use dma_wmb() for completion queue doorbell updates
Date: Sun, 16 Aug 2026 11:56:05 +0800
Message-ID: <20260816035605.1873-1-lirongqing@baidu.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: bjhj-exc3.internal.baidu.com (172.31.3.13) To
 bjkjy-exc3.internal.baidu.com (172.31.50.47)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=baidu.com;
	s=selector1; t=1786852580;
	bh=CoCztr6XAGEBvv7TN377FtTXgA/2hXdT8SEOdZBtANs=;
	h=From:To:Subject:Date:Message-ID:Content-Type;
	b=NTLoGFoISOzPQiSktm5+AmMXT1oHO6xmi7YjLpp4ef+j/cHW/39vT0qO07iS9Cyds
	 iRVl5U1hhMKpyY1n9Qkl5MHPTMfCWXRqcVSx6DbDu1NHghuNstnSo3x46l1WfZcmPr
	 Dwy7WJ5yG3tQeBk7TtIz+rcg932cZWY8tqybGRRlAFw6OA842IlQJUebVUCypAKB9X
	 9Osx1tvQcids58cPMCMxVsECaqYhU7QMSq3IbsLlLkTVG4opZOprA+J3MyHu/ve34c
	 BehnyyN7WgbejNu7v6GlY/Dj/FtTD/8nLY5MCSf3jKtnAFBjx9LmXa6IYvptfHqC14
	 AKKYEs/UB27zg==

From: Li RongQing <lirongqing@baidu.com>

dma_*() barriers are specifically for ordering writes to DMA
coherent memory that is accessible to both the CPU and DMA capable
devices.

The dma_wmb() barrier is lighter than wmb() on some architectures
because it only ensures ordering for DMA writes, not for all writes
including MMIO accesses.

In the MLX5 driver, completion queue (CQ) doorbell records are
allocated as DMA coherent memory via mlx5_dma_zalloc_coherent_node().
The CQ update pattern is:
  1. Update CQ space (device reads via DMA)
  2. Update doorbell record (device reads via DMA)
  3. Memory barrier
  4. Enable more CQEs
Since only DMA coherent memory accesses are involved (no MMIO accesses
follow), we can safely use dma_wmb() instead of wmb().

This change improves performance slightly on architectures where
dma_wmb() is lighter than wmb().

Signed-off-by: Li RongQing <lirongqing@baidu.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
V3: Kept the original wmb() barrier inside wc.c 

V2: rebased.
https://patchwork.kernel.org/project/netdevbpf/patch/20260811064750.3218024-1-tariqt@nvidia.com/

V1:
https://patchwork.kernel.org/project/netdevbpf/patch/20260402055206.2311-1-lirongqing@baidu.com/

 drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c    | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c    | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c     | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tx.c     | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/fpga/conn.c | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/lib/aso.c   | 2 +-
 6 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
index 723f66a..17084d7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
@@ -259,7 +259,7 @@ static bool mlx5e_ptp_poll_ts_cq(struct mlx5e_cq *cq, int napi_budget)
 	mlx5_cqwq_update_db_record(cqwq);
 
 	/* ensure cq space is freed before enabling more cqes */
-	wmb();
+	dma_wmb();
 
 	while (metadata_buff_sz > 0)
 		mlx5e_ptp_metadata_fifo_push(&ptpsq->metadata_freelist,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
index 77ea51b..ee0986b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
@@ -817,7 +817,7 @@ bool mlx5e_poll_xdpsq_cq(struct mlx5e_cq *cq)
 	mlx5_cqwq_update_db_record(&cq->wq);
 
 	/* ensure cq space is freed before enabling more cqes */
-	wmb();
+	dma_wmb();
 
 	sq->cc = sqcc;
 	return (i == MLX5E_TX_CQ_POLL_BUDGET);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 6fbc044..3c80193 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -2507,7 +2507,7 @@ int mlx5e_poll_rx_cq(struct mlx5e_cq *cq, int budget)
 	mlx5_cqwq_update_db_record(cqwq);
 
 	/* ensure cq space is freed before enabling more cqes */
-	wmb();
+	dma_wmb();
 
 	return work_done;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
index 0b5e600..14479da 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
@@ -849,7 +849,7 @@ bool mlx5e_poll_tx_cq(struct mlx5e_cq *cq, int napi_budget)
 	mlx5_cqwq_update_db_record(&cq->wq);
 
 	/* ensure cq space is freed before enabling more cqes */
-	wmb();
+	dma_wmb();
 
 	sq->dma_fifo_cc = dma_fifo_cc;
 	sq->cc = sqcc;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fpga/conn.c b/drivers/net/ethernet/mellanox/mlx5/core/fpga/conn.c
index 1f6bde5..1341874 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fpga/conn.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fpga/conn.c
@@ -384,7 +384,7 @@ static inline void mlx5_fpga_conn_cqes(struct mlx5_fpga_conn *conn,
 
 	mlx5_fpga_dbg(conn->fdev, "Re-arming CQ with cc# %u\n", conn->cq.wq.cc);
 	/* ensure cq space is freed before enabling more cqes */
-	wmb();
+	dma_wmb();
 	mlx5_fpga_conn_arm_cq(conn);
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/aso.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/aso.c
index 614cd57..8f7a89a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/aso.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/aso.c
@@ -421,7 +421,7 @@ int mlx5_aso_poll_cq(struct mlx5_aso *aso, bool with_data)
 	mlx5_cqwq_update_db_record(&cq->wq);
 
 	/* ensure cq space is freed before enabling more cqes */
-	wmb();
+	dma_wmb();
 
 	if (with_data)
 		aso->cc += MLX5_ASO_WQEBBS_DATA;
-- 
2.9.4

