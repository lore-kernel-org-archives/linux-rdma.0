Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011039.outbound.protection.outlook.com [40.93.194.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8ECA4A5ED4;
	Thu,  8 Oct 2026 13:30:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.39
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791466202; cv=fail; b=QwJmj0j0UBHFzkoJdWFTI13IRNRLgzGKtcXeS4P8ONjDwKKxfkm/5gjZ8JgLIQz1fzO3G+69ccrOiN+GOLIUfAWv5VTPy3DACbTpwIUTH374jUoh0pjy3E6dJ7OmydLYxWRFJp12DWMT3n5nM/Kbge9WF1hN080zxmABrFn12+M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791466202; c=relaxed/simple;
	bh=lzKkd9ZnL9ezANrAAP29VsFQRgtXY4qOhziWZZOQWtw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aWH7J2n+LTerKE+T5PSSmb/972BeJ3ME7aPdAsDOVVsGr9GR57MFvFzg8Xf2yJgtTdiIY3zmzINOTHwmkJUXDzgYal1HNmxuHMjmf6WGrBf8w4IHKplFU8h0DNhFDDYg0CRCOnWeffIztqkJqjNIDWkmR+CMzT4M7WkJnxNrbiM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=DlToviSD; arc=fail smtp.client-ip=40.93.194.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="DlToviSD"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yV/nd4Swr3mRU6TMeC08zzIK9bgyubz8eVTzfE5BZCiQh2NViMdE34ObijV9NBEmeWqAKsuL+a7RrEdFg2VEUpvVD9bAn9N64IpbLs/IVzpzE/cHUO1VCuqfpxQs3zzxCtO2u07YdTMej+brHec3xmNxcwFwHPgKd5HbY0NcPervS9kJA/NMQngHnr26jFbe0GlMkheOfmHLOaQ+DmSEPGwmgXB1YioSSgjI4yXiLsxMVC1pdQ7AT73Y0CVz6cWuNIc8x2WqLb2mBsBCnmG4VMCyWIq3NyATtX23v7fZgai8UhPZFtKw6YbcIdOPa1czHXB1t612YvsY9zXzddcCkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KRRZJnL7fZ2TXWQTJaBnP0LNol/cv0UC0ZHnNk+OH4o=;
 b=gLFZEWuOMDjaBStVhKFlPF0bnrCJivWg1MGZ9rCDIvsmOAz9MhgN+5zOQDy/rPe55XMQGEyIuFtKys+wCt/C+3PVxqLU+IlGWT2Ummhhog4ak+2KIYP8EyVjobnVnzUBn8sw88OB2liTm2cicZMCrTVwo1/mGNP+2AmUz85MHDwQi8goTnyD86ra0J2LRtpEJXlMTFldPdfaebH1tbmSlIg8Rt64SJXnbl/tXEddNQXp7TqW5dPpPAfExgYbAeNKR78Mjt6zPtroTs82wkkGg5jBUvoQ36EN0BWIVHn2UrPHIMuc+JjrzfP1XCodXq3lnAPi/YrinFU4BSxCNreAbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KRRZJnL7fZ2TXWQTJaBnP0LNol/cv0UC0ZHnNk+OH4o=;
 b=DlToviSDtQE/sR4P+dKPAChCz4hf9TtWxV6BtfjLKn90QPt+87Hrv5UdHrzE5/1J+RewgJwj0qZ4/SPnuW/BLIlJz3W9ylXhGuK/NHcWWMXBzaTJ5uDjXHQRedUGViTK5BNZ99iuUJUaKqNFfHLhy513wbd6QCwsae04LOYCfJds4qkdIijHu0h5DauGufVQXG20IKlGEUOsM2PdGYjWTb7TO0w4VPwr581eKtJuoLUaTkvE9xalMLTrb1oxnD9RvBgOSqak1yDzx7ECw+JvGtpIUqtjqUng6azo1I3qhhYnaRe9WdUSnINqY7pycIIl4k1toW6lFNB7V5tEObOECw==
Received: from PH8PR15CA0018.namprd15.prod.outlook.com (2603:10b6:510:2d2::11)
 by SJ2PR12MB7822.namprd12.prod.outlook.com (2603:10b6:a03:4ca::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.16; Thu, 8 Oct
 2026 13:29:48 +0000
Received: from SJ5PEPF000001D6.namprd05.prod.outlook.com
 (2603:10b6:510:2d2:cafe::3e) by PH8PR15CA0018.outlook.office365.com
 (2603:10b6:510:2d2::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.472.20 via Frontend Transport; Thu, 8
 Oct 2026 13:29:48 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.160) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SJ5PEPF000001D6.mail.protection.outlook.com (10.167.242.58) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.522.6 via Frontend Transport; Thu, 8 Oct 2026 13:29:47 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Thu, 8 Oct
 2026 06:29:26 -0700
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Thu, 8 Oct
 2026 06:29:25 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.2562.49 via Frontend Transport; Thu, 8 Oct
 2026 06:29:18 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Bobby Eshleman <bobbyeshleman@meta.com>, Byungchul Park
	<byungchul@sk.com>, Carolina Jubran <cjubran@nvidia.com>, Cosmin Ratiu
	<cratiu@nvidia.com>, Dragos Tatulea <dtatulea@nvidia.com>, Gal Pressman
	<gal@nvidia.com>, Jacob Keller <Jacob.e.keller@intel.com>, Kees Cook
	<kees@kernel.org>, Leon Romanovsky <leon@kernel.org>, open list
	<linux-kernel@vger.kernel.org>, <linux-rdma@vger.kernel.org>, Mark Bloch
	<mbloch@nvidia.com>, Matt Fleming <mfleming@cloudflare.com>, Mina Almasry
	<almasrymina@google.com>, Nikolay Aleksandrov <razor@blackwall.org>, "Saeed
 Mahameed" <saeedm@nvidia.com>, Shivaji Kant <shivajikant@google.com>, "Simon
 Horman" <horms@kernel.org>, Stanislav Fomichev <sdf@fomichev.me>, "Stanislav
 Fomichev" <sdf.kernel@gmail.com>, Tariq Toukan <tariqt@nvidia.com>, William
 Tu <witu@nvidia.com>, Yue Haibing <yuehaibing@huawei.com>
Subject: [PATCH net-next 08/10] net/mlx5e: Recreate netdev channels on data direct device unbind
Date: Thu, 8 Oct 2026 16:28:13 +0300
Message-ID: <20261008132815.654147-9-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20261008132815.654147-1-tariqt@nvidia.com>
References: <20261008132815.654147-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001D6:EE_|SJ2PR12MB7822:EE_
X-MS-Office365-Filtering-Correlation-Id: 3f29e1d0-55b1-4f77-74f3-08df2540392a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|82310400026|36860700016|23010399003|11063799006|56012099006|10067099003|6133799003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	EVVAVkMy221aPVm83aomYQkp8lZMQ8ch4csHdLVcuZyf/z9KOHvYQhvjwairRE1AivE+Z7Yf1PguT2WzG4FwoVwEEm42K+eJ2xgMaSeMyJv3gPUedw+XZIkdArZMM2IeTDJ839H2pe37Ro7Eed2GkklhDhL/5S7s6kUqxW5yJYqeCCKr40X4oj4gnYLN6wt+fSvPzymMLGWSNyrCAXKqVrwwN+RozEcuaWH7gjfbe7cm4NU6ucCc7jZpRhX39Txb+C0LXXNtSXrZLDxGQCzqz7K+vLkkxP4rFZoKPdVp+zGpsKNtjagmCUc+eyzSMD6m6NVX3A6eSUyJoVIgvN9+Gq+TCzow+Zn9WvOd41so58QhqsMkdGbRqyVGvlDBI0JkxytZ2SPCGA8T6UQdHzsVk8G94dZJfnzGBvi+B8HX/eHpf1liQ+QS74BQsFvupYaWwEdcy4FNFkbva/RNDqnEtVfacTl3FyPqALNH0+e54kw4wap930QboFYmctrMDtMeGeUuG3HlgcNKpHhTvj02kIRlKoPBMofiToNqE2kue4d2ycUjOLWf0qi0AP/q9MEL1dpIadLW2if3S0vJ1nxqK1wjeKHyP1yshtAW+Mm5Dt9yVRXBfl+nDQK7clfks16K4AuUbGmbyY2zkKoG1bkuYwZcVnEtn1YYH0W97D9vqxVupjezXs5+J2akDC4CaVZUe61LolmbSIN9krh6gvTHlw==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(82310400026)(36860700016)(23010399003)(11063799006)(56012099006)(10067099003)(6133799003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	ZaApsbyXdHi4ynAQU8h7DHXV82ss66WBz0cuk44zwgyVycjthBvg0f0WREqwfHn79wd8nRR4L0iATzNn+ULu/kKCalJCfGIRAsdeyOOGJ+qyEDM2KHc3tyMEDQ4JoQMg4FISWRdKycco1cMdpP0+Fn/tL2kwFQyoSQoW3VJ8jGScWS4VwzaypNRUNbGUM8eOUoviuydM9iAbZ6KXyI/a+OsYOw/FfBj5MvDQDpF22Nx2RF9svjWCjY/5V73cCbplDpOTMmt5SqA/dgiAVa0+IQuw3LkZiThnjLJVrIKmb/B6bEs+C/42TN3/erffVkPYSL+qfYqPvscBvY5g5lKb1SOLEvkQcCM9TsQrVmZDrl6d5kq5fLA5JoDdc9Yx7P3dCXSv7hR/UdAzQmSEuQZ19jpE60b4ZQZqBzNkSI+WWDRhRBkBmuoAObv0Ajv154zk
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Oct 2026 13:29:47.6844
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f29e1d0-55b1-4f77-74f3-08df2540392a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001D6.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB7822

From: Dragos Tatulea <dtatulea@nvidia.com>

To prevent queues from using data direct resources, disable the data
direct private flag and trigger channel re-creation for each netdev that
is registered to a data direct device in the unbind callback.

Channels will be re-created without the data direct flag.

Note that this does not tear down dmabuf bindings attached to the data
direct device; the recreated channels will still pick up the binding via
rxq->mp_params and post DMA addresses from the data direct IOMMU domain
to the PF, causing IOMMU faults. A devmem revoke hook is needed to close
those bindings before the switch.

Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 23 +++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 6476baf71bde..fb3e0bd00f04 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -6144,9 +6144,28 @@ static int mlx5e_data_direct_event(struct notifier_block *nb,
 {
 	struct mlx5e_priv *priv = container_of(nb, struct mlx5e_priv,
 					       data_direct_nb);
+	struct mlx5e_params new_params;
+
+	if (action != MLX5_DATA_DIRECT_UNBIND)
+		return NOTIFY_DONE;
+
+	rtnl_lock();
+	netdev_lock(priv->netdev);
+	mutex_lock(&priv->state_lock);
 
-	if (action == MLX5_DATA_DIRECT_UNBIND)
-		mlx5_core_dbg(priv->mdev, "data direct device unbound\n");
+	if (!MLX5E_GET_PFLAG(&priv->channels.params, MLX5E_PFLAG_DATA_DIRECT))
+		goto out;
+
+	new_params = priv->channels.params;
+	MLX5E_SET_PFLAG(&new_params, MLX5E_PFLAG_DATA_DIRECT, false);
+	mlx5e_safe_switch_params(priv, &new_params, NULL, NULL, true);
+	netdev_info(priv->netdev,
+		    "data_direct device unbound, disabled data_direct\n");
+
+out:
+	mutex_unlock(&priv->state_lock);
+	netdev_unlock(priv->netdev);
+	rtnl_unlock();
 
 	return NOTIFY_OK;
 }
-- 
2.44.0

