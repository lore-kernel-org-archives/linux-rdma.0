Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013026.outbound.protection.outlook.com [40.93.196.26])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEA68233933;
	Tue, 11 Aug 2026 06:48:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.26
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786430908; cv=fail; b=uf+WT2arlgzGLdF2qVZDUUTv+emPa0R5piZU48t1MFzYACLwpcfgCCQCSTLersMuwyxJPiuh5A4koNsmk6dMrFrOwKllSfyAzd9+BzqIhmRcbOv7bibEeVYleYIU5HwLYLwZuzcQDoG96pJjM6kPuckWF1T6O5yde6GZ+ijzCJY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786430908; c=relaxed/simple;
	bh=PzdS3uWt9gb7b83ehvWC5a9GiM/x/hJ2+1bxdtqNgjw=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=eciFljxViYCFJtlheUX15hw/Cyx9+KL/ETzzHem1MKbWnEQqCiKGEKNzWIqz4q2sE1lZD32StUNFx1N9Bniz2srNnHyb90nMMCDfkPnDxhF7nkxur4vsO8HA4HsU4d7LStch4s4ENrdCsVvKi9DzrsuynRJ9Aw7oj/wWQxWRmdc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ZUViOhZ8; arc=fail smtp.client-ip=40.93.196.26
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ZUViOhZ8"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TQ2j7+uokqXd9/u+THJXKTZ1EVfUOqQrpQJeM71eDRUSQtV3jWAHIWNvvdBAlAaWD3mw3xWP2XrQEdl7TQpOOFcVENuhfmKGDkp2xycwaCKK9nFXFxjbL2CUsV8zfOMUnb82HlT9Pzb/9ccip4DfiJKGRqooIZh9LOMU+JymLaiXjwDyy5rkLcKq0NnvaChbqkiDdvr+9XdXvwWWZeFchlWJpsBQVuMc2HbATbCGJSFrWCfHBzILJ7zID2+jSErPh4meo13Ydea4gO1tZqImM6ptzGJKts6ZSRpBZCNv8K+QJ1Yo6UzkHUtWjkWYAWf7yzhDNb3gs7Lw2Dg0z3dZ5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5V3wg0LkJ2VQqgx8x/kKc1NORvcrYg9GtId+cCPCJE4=;
 b=XIDoMIka1lFVkGIIFxQPuBnv1UDGB/NfNpV2fXYDz4u+5CiQoGhFnUnfiz1VBGsZe/Ttn9E+GL/XyNvmvnRzXxadnz1N9cXoa08pnbWcye013Sk9ig0H+YNckB1P/HE/pzmx3XGKJeF8Y0CtXNxuc7QAMYCTSw3bTueWGHlMmi+4RZ/0vXuYLEeJCXPe2/z00FTc58uWkYbCieF4BDCDRomVgZZrvbQbqCylKtGK4kH3+3KQ/nV/QNpTXmsou+4gyTZG7yhKqtwQEcAHc4uWg60VcqJY0VO68PFQn48x+ZYIapma9icW5twFg1pETLN+PkCqC6Ys1m4jKySXydD5Hw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5V3wg0LkJ2VQqgx8x/kKc1NORvcrYg9GtId+cCPCJE4=;
 b=ZUViOhZ8AgBgGSlv3PbJWsHHVbWYqVv0PMFMjiqDFJmxTBW3UzZ9Z4xVHoOK35wvWCVKp0xWbc9iDIQO55+FWlPtxO9f1qo9w4i16/CgXzjAOtNCor2hYPzJDdRvEQvvdmf6w/hWowRj7wphXRvHNOCNzTLOAGdk5llG9r8OQgeqSw/c6z6aXawipJkUJD3lflsltFCqvodiXjfJB92Ld8Sjj46ukaGJbV3KV+w5z80ziJtkyzS0DuGaiqp2kdn7jW+s/jb4+j7b+UnK9qKpDhZs/C0CQwpb8ITYMx5LAgkDJkLt+y4zTcD72Tln35/hrO+KJPnI545fnnvAGpaJaA==
Received: from DS7P221CA0011.NAMP221.PROD.OUTLOOK.COM (2603:10b6:8:25b::9) by
 PH7PR12MB7210.namprd12.prod.outlook.com (2603:10b6:510:205::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.12; Tue, 11 Aug
 2026 06:48:19 +0000
Received: from CH3PEPF00000016.namprd21.prod.outlook.com
 (2603:10b6:8:25b:cafe::43) by DS7P221CA0011.outlook.office365.com
 (2603:10b6:8:25b::9) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.315.11 via Frontend Transport; Tue,
 11 Aug 2026 06:48:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CH3PEPF00000016.mail.protection.outlook.com (10.167.244.121) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.339.0 via Frontend Transport; Tue, 11 Aug 2026 06:48:18 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Mon, 10 Aug
 2026 23:48:04 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Mon, 10 Aug
 2026 23:48:03 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.2562.20 via Frontend Transport; Mon, 10
 Aug 2026 23:47:56 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Akiva Goldberger <agoldberger@nvidia.com>, Alexei Starovoitov
	<ast@kernel.org>, Boris Pismenny <borisp@nvidia.com>, <bpf@vger.kernel.org>,
	Carolina Jubran <cjubran@nvidia.com>, Cosmin Ratiu <cratiu@nvidia.com>,
	Daniel Borkmann <daniel@iogearbox.net>, Dragos Tatulea <dtatulea@nvidia.com>,
	Gal Pressman <gal@nvidia.com>, Jacob Keller <Jacob.e.keller@intel.com>,
	Jesper Dangaard Brouer <hawk@kernel.org>, John Fastabend
	<john.fastabend@gmail.com>, Kees Cook <kees@kernel.org>, Leon Romanovsky
	<leon@kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-rdma@vger.kernel.org>, Li RongQing <lirongqing@baidu.com>, Mark Bloch
	<mbloch@nvidia.com>, Moshe Shemesh <moshe@nvidia.com>, Richard Cochran
	<richardcochran@gmail.com>, Saeed Mahameed <saeedm@nvidia.com>, "Shahar
 Shitrit" <shshitrit@nvidia.com>, Simon Horman <horms@kernel.org>, "Stanislav
 Fomichev" <sdf@fomichev.me>, Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH net-next V2] net/mlx5: Use dma_wmb() for completion queue doorbell updates
Date: Tue, 11 Aug 2026 09:47:50 +0300
Message-ID: <20260811064750.3218024-1-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PEPF00000016:EE_|PH7PR12MB7210:EE_
X-MS-Office365-Filtering-Correlation-Id: c5b59e9f-458f-4706-fd3e-08def77486ee
X-LD-Processed: 43083d15-7273-40c1-b7db-39efd9ccc17a,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|7416014|36860700016|376014|23010399003|18002099003|56012099006|5023799004|11063799006|13003099007|10067099003;
X-Microsoft-Antispam-Message-Info:
	YHhuYX8tjGwKM7OG2ceXCQMPMer+Z0y7LvvJ/yvVYwcRW97oXYQhLzsvwsh3WQfgV98H5Z+FpwQ3A5z7y3K7T5ARHJ6USiS6R9L6p355LgmhZqLOe1FfZmFeGnLERqroQ5B6X9gfCk0smUzbSEqfybM7pGk+iw1bXWpdnHhWlPOtxGhvdAjLYcavczKhj8Q7UQIc2jRCYeeZA8POUWxVLlwpn+goCILiYiyHlCKHGriPwAD4ZJp8h5WmFuuu8rCBY18CLoGx5BUb4FXDgJw06Jdg4Gpuw/y1ZIcaWlxd1/XzDOxEa0pFrvFesmUMGCEA0vnq3Y752yn7w/i+QWV2LKH1C+Zn+SJZjgzX/hORnhU0S6RvgofKzha2xjgexEFoitB+NhToUfHltatxlT1ARW2hmIa5NXipC2Ur8zRvHrHQ5exRva74QUyX3CkRrGtUCYukbUVUdsSoUrP0xadxMAJ4JLwAEsP74Ch33tWafHD1ZGeDe1W5ZkOjR7EJtRTZw6S3vNAqb0beOB0bvU3PB7CETkJlqsM0v3y2tj4jwrIUbjS9p0qV4y+G29MMjyDASvnf4fUruhjftl/J4YsY9tiSaYIJ3mmK7gplHEia9MkOuKBeYQf6VShFE7Z327QL3VsLWeXsjCt9vji3AJSbDmXRDH7ax1CQWfKiiJYiMOSGQ2AJMcJ/Ihu0JJ6JGSioYdJ307BXZ+Kh9rUZ5r0rXw==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(7416014)(36860700016)(376014)(23010399003)(18002099003)(56012099006)(5023799004)(11063799006)(13003099007)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	wadRzMI918jhcxudeQ76njBGde5POcvtoNJAZKp06va0sdv+2rugk/72GjWDcwLT8cnWo7Ig+LD/zzN444IUWN6qrdWFCHBuHDmdVjO1HMeGQw1Fv/FM92CzlN1yjRP2PdqdcRWaj8q3Te/oRa700CssSPhNNYxIpSyerSk5LM7Pig+oQEWshiOuE9+S3BHbLFhLRHYa4z3vZzSR7KIXrnjk2ykAS5eLiZdoceCKt3/Po0P4nwTe++A0SW6gsw2+Rt6x/FAQa3tVx9FNeoHWhHEgb3KgcwRwvSwG1j6dxvCrUHHPWYdzOdC/mS2HxbYXwQbFY6+DBk+lD/eBL73zrmq7T65IpLZ2P3Yifoum3p4wE8j+fM/g0JHPsmzBwzd1HPiPjaYHXREF00lUab5TGq/kMK9j5XBUOxy0t4GUruZt4wLsADwMx3FUWb/NsSeK
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2026 06:48:18.3566
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c5b59e9f-458f-4706-fd3e-08def77486ee
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH3PEPF00000016.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7210

From: Li RongQing <lirongqing@baidu.com>

dma_wmb() barriers are specifically for ordering writes to DMA
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
follow), can safely use dma_wmb() instead of wmb().

This change improves performance slightly on architectures where
dma_wmb() is lighter than wmb().

Signed-off-by: Li RongQing <lirongqing@baidu.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---

V2: rebased.

V1:
https://patchwork.kernel.org/project/netdevbpf/patch/20260402055206.2311-1-lirongqing@baidu.com/

 drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c    | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c    | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c     | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tx.c     | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/fpga/conn.c | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/lib/aso.c   | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/wc.c        | 2 +-
 7 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
index 723f66a6bd63..17084d76209e 100644
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
index 77ea51bfbaae..ee0986bd5c18 100644
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
index fb7110b1b683..442a8d7d6a58 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -2501,7 +2501,7 @@ int mlx5e_poll_rx_cq(struct mlx5e_cq *cq, int budget)
 	mlx5_cqwq_update_db_record(cqwq);
 
 	/* ensure cq space is freed before enabling more cqes */
-	wmb();
+	dma_wmb();
 
 	return work_done;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
index 0b5e600e4a6a..14479da98f42 100644
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
index 1f6bde5d7626..1341874ee58a 100644
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
index 614cd57a40d7..8f7a89ae4ad8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/aso.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/aso.c
@@ -421,7 +421,7 @@ int mlx5_aso_poll_cq(struct mlx5_aso *aso, bool with_data)
 	mlx5_cqwq_update_db_record(&cq->wq);
 
 	/* ensure cq space is freed before enabling more cqes */
-	wmb();
+	dma_wmb();
 
 	if (with_data)
 		aso->cc += MLX5_ASO_WQEBBS_DATA;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/wc.c b/drivers/net/ethernet/mellanox/mlx5/core/wc.c
index 7d3d4d739e2c..1afbdd19f8de 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/wc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/wc.c
@@ -314,7 +314,7 @@ static void mlx5_wc_post_nop(struct mlx5_wc_sq *sq, unsigned int *offset,
 	/* ensure doorbell record is visible to device before ringing the
 	 * doorbell
 	 */
-	wmb();
+	dma_wmb();
 
 	mlx5_iowrite64_copy(sq, mmio_wqe, sizeof(mmio_wqe), *offset);
 

base-commit: d67e5dbda22604d0fcde32fce58c65f88676e676
-- 
2.44.0

