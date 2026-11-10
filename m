Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.195.57
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794336023;
	b=ZHV+xoe6/kKoZSqkhOVv2K/qSvSxfj3fOZ8uORZSW8doNTtC85fG7gTbXgtJuqtPT2dL
	 EBtN4+d88xyAuWfxxvdUkr77/VhaZlX55fVveEmPLU5ypmTTOlpaP9kPqKSCZ7DxoZhb3
	 DCMYtRESRexqqv6A8WY5XtWYb+Emzjjs2X7LLlaAxPM7AH5IaMVqHp2TFWiWnFBVwmCzM
	 9ii/S70UDo0Qn6DkCJPr8vuEOQSdaGE2D2Vm52eXaxonypO+0LQ1MlNftGQEoZ1hd5apT
	 zvwAUYbMrDJ1Noq9jLOhFh4VJWNKm0Xcz9QqGZdAxQzzTzkncTFz1kLFcwsEc+RZ9tw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794336023;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:Received:
	 Received:Received:From:To:CC:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:
	 Content-Type:X-NV-OnPremToCloud:X-EOPAttributedMessage:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-Id:
	 X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=eDsN0gSO2XYkjp3UUG+NavbPCYDhpHpv8AP5f2RurLo=;
	b=44Dy2f0g69HL4FFyEbpLoImzronFdPGHcM9ZlMhvgnWhNkDhsCh7KD5T3XGtMUybB5OW
	 wv0EDuG02780EoQri3gWur1hUgOqpaZDLoBnUhwQ79iu6G9nPRcVCVsn+VEtulBB1SDIn
	 jXAXq8JUjkrKnpBznNV7M6AJRSqDKxzOBO/OxRv3Sf47+7EzqylfWh1eVEjPu0xvDn8t0
	 EGU3jkSQXHzURCcpfhAKAG/12PkntLS0UOIkAUAoSO5UOrG+wtHC++1I29AAbdlBbkcn7
	 vkftmeBaHVdcw8AJaiBLifQrJSU8XEWpXY0eNByN7ds/eJxOXdWHHmV+ZbNK6j0xcLA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=VNJCzROl;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.195.57
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012057.outbound.protection.outlook.com [40.93.195.57])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CD80606A901;
	Tue, 10 Nov 2026 18:40:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9CD80606A901
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=VNJCzROl
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ua2g969D1QE1LC81HNwr5a+h5RJKpD4DjoMkE6aZ9Nztpa42ZdonGVaLdgOkI8+HDpBy4qleIGtTA7FRCjGm+83cI9XNC6mwX/n7aSEkT4ZTVeaN7Vki2ePaAFdm4APEiOAaVWzWsSeMQFIwSxVg3Z5WPZ5x8NZXsn/VDx92MDzvYRh3OvlLv7tJU4jBfhWtCizOc3jnTAffOH+ufqpLQiD4kkkCD43+gS7fZFZmSHoNtUE/mvuMOxheB0RtkMTeZ/lkbJ4cLzREZ9IgEzoXCMhFIxOthoR1sZypEnzd2r5qTybHBqz1b1+ZL1Ylf85aP3yKgH22GH5oUg8g84A38A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eDsN0gSO2XYkjp3UUG+NavbPCYDhpHpv8AP5f2RurLo=;
 b=WcYUQdjYogdYS7eG6FjCPV6+1cPl4ZpskiLjxFdHCpvHnYSo+fkCLegWqoKlWzalTGGlvwm+iohnjMiMct+Llus+CXVn3Y5tYqmTxgsvMjbZXK2PMSM3KVgRATm0y4bQqXbWK2cnwp5sOeJbSSP/26+fcGX+5kQmu8gDAB/s4mVzuLGcJqGPGXd9erGdAOexcl7qMqUJXDYO+oBKJYojzqpOx+j2TjU798FZX0+McMd+wuMTs2ia6J40YUhkoEEObDmMf0Cz0KLtBeZS1Uz+syPNIc0NgQjYgAgeKx//peTp/p3uj0KtNWEwlCJoSBsZkJ5pRUL4Rjo7nSlJKUApLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eDsN0gSO2XYkjp3UUG+NavbPCYDhpHpv8AP5f2RurLo=;
 b=VNJCzROl+T0MO3NdtpYuuWP9ONe+K8QZQWZydgTR9Q9vniG+PMoBKqsOOdbcEAxioNGXGYx5EqXMKwSPnN+FNaZd45HntX/4XMUXB/Dx4zo8Z8ar67TcSkbnq6zL82tvlnd5IqVx8FrAYP5QDPzsyOR5JSDuD0ILvwsGbKXTYZnEDmFSuaz1o3Uh9gtHBKGmFs1ljUB4EIArovI/2ZKdGqWHkK3R1vLGqcMBaKPl3InV5ygLwOYPBNoRMn1b4sO/MkT9KdYGkWPE/bBelQsjbeEXX/ZrDewTEbWe8auCD71NLziCdEV4siBqfuhLT2liFQv1K/IB4gDQaowjlepfNQ==
Received: from CY8PR19CA0037.namprd19.prod.outlook.com (2603:10b6:930:6::11)
 by CH3PR12MB9313.namprd12.prod.outlook.com (2603:10b6:610:1ca::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.13; Tue, 10 Nov
 2026 18:40:12 +0000
Received: from PH2PEPF00048912.namprd05.prod.outlook.com
 (2603:10b6:930:6:cafe::44) by CY8PR19CA0037.outlook.office365.com
 (2603:10b6:930:6::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.8 via Frontend Transport; Tue, 10
 Nov 2026 18:40:10 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.160) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 PH2PEPF00048912.mail.protection.outlook.com (10.167.243.68) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Tue, 10 Nov 2026 18:40:09 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 10 Nov
 2026 10:39:50 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 10 Nov
 2026 10:39:50 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.2562.56 via Frontend Transport; Tue, 10
 Nov 2026 10:39:42 -0800
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Bobby Eshleman <bobbyeshleman@meta.com>, Carolina Jubran
	<cjubran@nvidia.com>, Cosmin Ratiu <cratiu@nvidia.com>, Daniel Borkmann
	<daniel@iogearbox.net>, David Wei <dw@davidwei.uk>, Dragos Tatulea
	<dtatulea@nvidia.com>, Erfan Sharafzadeh <erfansh@meta.com>, Gal Pressman
	<gal@nvidia.com>, Jacob Keller <Jacob.e.keller@intel.com>, Kaifeng Wang
	<kaifengw@google.com>, Leon Romanovsky <leon@kernel.org>, open list
	<linux-kernel@vger.kernel.org>, <linux-rdma@vger.kernel.org>, Mark Bloch
	<mbloch@nvidia.com>, Matt Fleming <mfleming@cloudflare.com>, Mina Almasry
	<almasrymina@google.com>, Nikolay Aleksandrov <razor@blackwall.org>, "Saeed
 Mahameed" <saeedm@nvidia.com>, Simon Horman <horms@kernel.org>, "Stanislav
 Fomichev" <sdf@fomichev.me>, Stanislav Fomichev <sdf.kernel@gmail.com>,
	"Tariq Toukan" <tariqt@nvidia.com>, William Tu <witu@nvidia.com>
Subject: [PATCH net-next V2 08/13] net/mlx5e: Add data direct TX infrastructure
Date: Tue, 10 Nov 2026 20:38:21 +0200
Message-ID: <20261110183826.2927274-9-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20261110183826.2927274-1-tariqt@nvidia.com>
References: <20261110183826.2927274-1-tariqt@nvidia.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH2PEPF00048912:EE_|CH3PR12MB9313:EE_
X-MS-Office365-Filtering-Correlation-Id: 55ad4427-0f69-495c-5def-08df3f5a0c8d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|82310400026|36860700016|23010399003|261102123227099003|261021135927099003|11063799006|261021121427099003|261021123027099003|261026140227099003|261022105027099003|261009223027099003|56012099006|261026121527099003|261028144727099003|18002099003|22082099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	WHgleWcYPMc3hBxhtGog+AkJ3lGyBt5vCQynR4eHtrcASY//qeO1FgKY4jRKKai/04AFbPsVs7XFkrLYXU+09cDacTGS+qvRsS0+5nR0yjU9BurLffkR7ZtHz28/G0eJ2eqxilLdvRxxIFwlU0NSUhIF+e6luBtqEd/RCpfW0UCjzE7DblFalLbE/k0xZJ9rSHp8/8RM50JTRdSq6KkZ5iTYCK/j8iWpCE7amkdFzl9MM6h4YPO37+q3rRBUK6STq4CdaiNflJAcgarLSx5oYxVX4+Tu23fWv2V5TfUggS+BZ1A9liJo6vAKoNprSpK6Z0aa2uZrxmsuFhotSp0iY3ErmIxSFTs/D4yQoX/6zOZUthpJ+q6tXm3bZT24Z3iYmsucloZtDe65T2TGQtHQTSKJX8VoN07imBkwNU62ucIlaTVOUN03NkU+QOhs3iUA6UFZfjyFfuJoAELEWgA3qIFyuCXB51PbWc1HigpqVWMEyjrHt8cY/Qa7LItUscwdL88i1WbAzq/NBnZCpOklsASpgBrxv9dM3Z9xwM/foAQyZLyWusSYXQprUfzdTo2NSOReRtoQDhiAJbWe0xNwpUNs8oc4hGK79ju7VJRzXeEWDVovQA8mlCVZBvS1+8GUMvSvFjumaU39ox2NoKioA6OH+3blUsaag6KdExqs690JgBTuedLLNCuarNGSvNkFV5DAFtgvfufiAOuZTFQMDw==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(82310400026)(36860700016)(23010399003)(261102123227099003)(261021135927099003)(11063799006)(261021121427099003)(261021123027099003)(261026140227099003)(261022105027099003)(261009223027099003)(56012099006)(261026121527099003)(261028144727099003)(18002099003)(22082099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	40BbiJjkyGflUEpVgtDkz1L4hwU+XVjMq7GlRHmUDRadHPCd9FeccCTy4CzfCAIuucNAfwHUaaLUU6Munq//9lYf/o/MiQmznMQq6HbgkKaX0BQ8r2+u5JYjcIz0fE3T3m3JTrA7QoUh1mk42B6lgkUyZf6gKDtFCp2UAoh/oqIC5aW1gD/g3h1/IKSjHdS+ktWgk2oiPKrDKkIPoEdLSt0APx82QkhhzWzpbdtZIyd9/+8lKR8Q8/o38rU2IhYZamJi3o4K9zUM3qN2mMX2HN9KIFAKl4YlDblaX2eMe6jwth/WClymdccP3BxwOp1VKdls9E7xRnp9UeqSR+FbK8MaRNO+sgpSBWH2FDg1+jjNZgGsaJtJBcPR7cwhbC6nBDXXBVnduyDxo4TVEdrPDTblxee77uWkdH/XHxT9YJSca33UIjKicaoNXintBJTb
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2026 18:40:09.9133
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 55ad4427-0f69-495c-5def-08df3f5a0c8d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	PH2PEPF00048912.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9313

From: Dragos Tatulea <dtatulea@nvidia.com>

Data direct is a HW feature that allows a type of peer-to-peer DMA
between the NIC and another device (e.g. GPU) going through a specific
PCIe topology.

For data direct to work on the TX path, a crossing mkey is necessary
which is created as a mlx5e resource. This mkey is used by all SQs.
For simplicity always create this resource and link it to the SQ
if data direct is supported.

An SQ state flag is added as well to signal to the TX data path that
data direct is enabled.

This commit has no functional changes. data direct mode will be
enabled in a subsequent commit and mlx5e_queue_get_dma_dev() will then
point to the right device.

The data_direct private flag is not propagated to PTP SQs because
the queue selector will direct devmem net_iovs to regular SQs.

Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
Reviewed-by: Cosmin Ratiu <cratiu@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |  2 +
 .../mellanox/mlx5/core/en/reporter_tx.c       |  1 +
 .../ethernet/mellanox/mlx5/core/en_common.c   | 38 ++++++++++++++++++-
 .../net/ethernet/mellanox/mlx5/core/en_main.c |  6 +++
 .../net/ethernet/mellanox/mlx5/core/en_tx.c   |  4 +-
 include/linux/mlx5/driver.h                   |  1 +
 6 files changed, 50 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index d716e70c6d47..23e45e87cdee 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -397,6 +397,7 @@ enum {
 	MLX5E_SQ_STATE_PENDING_XSK_TX,
 	MLX5E_SQ_STATE_PENDING_TLS_RX_RESYNC,
 	MLX5E_SQ_STATE_LOCK_NEEDED,
+	MLX5E_SQ_STATE_DATA_DIRECT, /* set when the sq maps net_iov frags through data direct */
 	MLX5E_NUM_SQ_STATES, /* Must be kept last */
 };
 
@@ -453,6 +454,7 @@ struct mlx5e_txqsq {
 	u8                         min_inline_mode;
 	struct device             *pdev;
 	__be32                     mkey_be;
+	__be32                     crossing_mkey_be;
 	unsigned long              state;
 	unsigned int               hw_mtu;
 	struct mlx5_clock         *clock;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
index 8409ae73768f..b4a4ff877bbc 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
@@ -18,6 +18,7 @@ static const char * const sq_sw_state_type_name[] = {
 	[MLX5E_SQ_STATE_PENDING_XSK_TX] = "pending_xsk_tx",
 	[MLX5E_SQ_STATE_PENDING_TLS_RX_RESYNC] = "pending_tls_rx_resync",
 	[MLX5E_SQ_STATE_LOCK_NEEDED] = "lock_needed",
+	[MLX5E_SQ_STATE_DATA_DIRECT] = "data_direct",
 };
 
 static int mlx5e_wait_for_sq_flush(struct mlx5e_txqsq *sq)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_common.c b/drivers/net/ethernet/mellanox/mlx5/core/en_common.c
index c2d4bae533de..c1d3b2ba1864 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_common.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_common.c
@@ -30,6 +30,8 @@
  * SOFTWARE.
  */
 
+#include <linux/mlx5/data_direct.h>
+
 #include "devlink.h"
 #include "en.h"
 #include "lib/crypto.h"
@@ -153,6 +155,30 @@ mlx5e_get_devlink_param_num_doorbells(struct mlx5_core_dev *dev)
 	return err ? MLX5_DEFAULT_NUM_DOORBELLS : val.vu32;
 }
 
+static int mlx5e_create_data_direct_crossing_mkey(struct mlx5_core_dev *mdev)
+{
+	struct mlx5e_hw_objs *res = &mdev->mlx5e_res.hw_objs;
+
+	if (!mdev->data_direct ||
+	    !MLX5_CAP_GEN(mdev, crossing_vhca_mkey))
+		return 0;
+
+	return mlx5e_create_crossing_vhca_mkey(mdev, mdev->data_direct->mkey,
+					       U64_MAX,
+					       &res->data_direct_crossing_mkey);
+}
+
+static void mlx5e_destroy_data_direct_crossing_mkey(struct mlx5_core_dev *mdev)
+{
+	struct mlx5e_hw_objs *res = &mdev->mlx5e_res.hw_objs;
+
+	if (!mdev->data_direct ||
+	    !MLX5_CAP_GEN(mdev, crossing_vhca_mkey))
+		return;
+
+	mlx5_core_destroy_mkey(mdev, res->data_direct_crossing_mkey);
+}
+
 int mlx5e_create_mdev_resources(struct mlx5_core_dev *mdev, bool create_tises)
 {
 	struct mlx5e_hw_objs *res = &mdev->mlx5e_res.hw_objs;
@@ -177,12 +203,19 @@ int mlx5e_create_mdev_resources(struct mlx5_core_dev *mdev, bool create_tises)
 		goto err_dealloc_transport_domain;
 	}
 
+	err = mlx5e_create_data_direct_crossing_mkey(mdev);
+	if (err) {
+		mlx5_core_err(mdev, "create data direct crossing mkey failed, %d\n",
+			      err);
+		goto err_destroy_mkey;
+	}
+
 	num_doorbells = min(mlx5e_get_devlink_param_num_doorbells(mdev),
 			    mlx5e_get_max_num_channels(mdev));
 	res->bfregs = kzalloc_objs(*res->bfregs, num_doorbells);
 	if (!res->bfregs) {
 		err = -ENOMEM;
-		goto err_destroy_mkey;
+		goto err_destroy_crossing_mkey;
 	}
 
 	for (i = 0; i < num_doorbells; i++) {
@@ -221,6 +254,8 @@ int mlx5e_create_mdev_resources(struct mlx5_core_dev *mdev, bool create_tises)
 	for (i = 0; i < res->num_bfregs; i++)
 		mlx5_free_bfreg(mdev, res->bfregs + i);
 	kfree(res->bfregs);
+err_destroy_crossing_mkey:
+	mlx5e_destroy_data_direct_crossing_mkey(mdev);
 err_destroy_mkey:
 	mlx5_core_destroy_mkey(mdev, res->mkey);
 err_dealloc_transport_domain:
@@ -241,6 +276,7 @@ void mlx5e_destroy_mdev_resources(struct mlx5_core_dev *mdev)
 	for (unsigned int i = 0; i < res->num_bfregs; i++)
 		mlx5_free_bfreg(mdev, res->bfregs + i);
 	kfree(res->bfregs);
+	mlx5e_destroy_data_direct_crossing_mkey(mdev);
 	mlx5_core_destroy_mkey(mdev, res->mkey);
 	mlx5_core_dealloc_transport_domain(mdev, res->td.tdn);
 	mlx5_core_dealloc_pd(mdev, res->pdn);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index cee73f3b7a99..5b99099e4ed0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -1825,6 +1825,12 @@ static int mlx5e_alloc_txqsq(struct mlx5e_channel *c,
 		set_bit(MLX5E_SQ_STATE_IPSEC, &sq->state);
 	if (param->is_mpw)
 		set_bit(MLX5E_SQ_STATE_MPWQE, &sq->state);
+	if (MLX5E_GET_PFLAG(params, MLX5E_PFLAG_DATA_DIRECT)) {
+		u32 mkey = mdev->mlx5e_res.hw_objs.data_direct_crossing_mkey;
+
+		sq->crossing_mkey_be = cpu_to_be32(mkey);
+		set_bit(MLX5E_SQ_STATE_DATA_DIRECT, &sq->state);
+	}
 	sq->stop_room = param->stop_room;
 	sq->ptp_cyc2time = mlx5_sq_ts_translator(mdev);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
index 14479da98f42..62ffb41a64df 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
@@ -182,6 +182,7 @@ mlx5e_txwqe_build_dsegs(struct mlx5e_txqsq *sq, struct sk_buff *skb,
 			unsigned char *skb_data, u16 headlen,
 			struct mlx5_wqe_data_seg *dseg)
 {
+	bool dd = test_bit(MLX5E_SQ_STATE_DATA_DIRECT, &sq->state);
 	dma_addr_t dma_addr = 0;
 	u8 num_dma          = 0;
 	int i;
@@ -211,7 +212,8 @@ mlx5e_txwqe_build_dsegs(struct mlx5e_txqsq *sq, struct sk_buff *skb,
 			goto dma_unmap_wqe_err;
 
 		dseg->addr       = cpu_to_be64(dma_addr);
-		dseg->lkey       = sq->mkey_be;
+		dseg->lkey       = dd && skb_frag_is_net_iov(frag) ?
+				   sq->crossing_mkey_be : sq->mkey_be;
 		dseg->byte_count = cpu_to_be32(fsz);
 
 		mlx5e_dma_push_netmem(sq, skb_frag_netmem(frag), dma_addr, fsz);
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index abb99371ff13..4c8b447337f1 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -678,6 +678,7 @@ struct mlx5e_resources {
 		u32                        pdn;
 		struct mlx5_td             td;
 		u32			   mkey;
+		u32			   data_direct_crossing_mkey;
 		struct mlx5_sq_bfreg      *bfregs;
 		unsigned int               num_bfregs;
 #define MLX5_MAX_NUM_TC 8
-- 
2.44.0

