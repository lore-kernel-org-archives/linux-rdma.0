Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.194.68
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793729629;
	b=sXJusbmUwasotThxepYBFOB6+kCzEIOyIhkhlo7C5ONbnPEPPENbfrBjH4xOqpLvGwM8
	 6VTpBZ8liy4d+PT+JevZBgKt5NzayMGzIyiQ3Adn1Toh20zq9q4IpMAx4J6J1LE7C6cPy
	 1Kfz6ZwdqQtvG316jVj7/sw/2ynxR20h3LDuoUw0kJ5SK9xiiB6Vj1VBsm6gDDXGAlt/S
	 YQh+xp+MPytwGYDAbHnlGx5gKjl2cII6Yt+21ES75cOl65zUi2CwEafl4AfKpfZzaAqw/
	 ZiBqFZA6TZheQIk6gyiV+R+vD/QLEF2EBS2/n1dIu6+mcdeUjKmOVsHJ67L/86YbBmA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793729629;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:Received:
	 Received:Received:From:To:CC:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:X-Mailer:
	 Content-Transfer-Encoding:X-NV-OnPremToCloud:X-EOPAttributedMessage:
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
	bh=ZfLaI3c4bTzeJoOM5yd9lN/+q7T14Gm0ZxyNGoW/aik=;
	b=0lOWHw+u0ooNHxCtXvHC+gfAjIi+PTiHb6vuIY7jlC6Qa26CYDrTAZABOYynrooMvJRB
	 UfrV9Kf2ydPWXmOZSjn40g9r+LzlxvU8uKYyYu98aQ19A7OYb9MAvSx5FGkhbZwjJ66B5
	 x/pt2OUhqVdd3vbPH6BJ2D0jEEYK8IkemazIppywWOpUXMC7Qk3FueJffqSF/gfXk1Q3S
	 eCJQfkOSGiQmfCf+1VCMeAXJE0xb99OrCJF/bX/x3qZAeA3PO0BrrUReIvRMNJuah+9NO
	 gMOb5802vBaU+bl2A5VWrUd2GyeSIiIrKy1adgJ2Vz1+W14cfIpdQjZx8PsSdlrkADg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=koKT0NR6;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.194.68
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011068.outbound.protection.outlook.com [40.93.194.68])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B31BD606D818;
	Tue,  3 Nov 2026 18:13:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B31BD606D818
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=koKT0NR6
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=so4r/AuSns5vnPhdku9eGWsTImYa/d6kKRlkDx03am5agXxEWHQTQKE/5UHsvdyPy7qSpHkQkrsc0ALJmO/nfBApqwugd1YtjsFtM0UwaijDc3nfQotYF9LsR5p3su3CNIL5lHJSHSx4pT2m2MmZo1pfhReRbMD0wKTmXbOj4B6fS1IazqQofr9hThzDB1Val/xGeNFcgR3IduHYam9p08Y26pWs4//rkCN5ADSB3refhWAKwOSqGzQNrFsrNeiAL/pKtJjm+DDwbwYHE38b/I//Db9pNs+aYK1l1js/WBKrP1qlEv4FgwwPB9soIkO2ldlvtYsthfIGgaIOpuMLhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZfLaI3c4bTzeJoOM5yd9lN/+q7T14Gm0ZxyNGoW/aik=;
 b=v0rie5tJWqfs0MkG37eL/a3pJDEM/YDzwZtCHqNgwwC68ko2aybPzIK1ulwj37lpWyaq0RGaR2cqGpRQctD/yk1dTlhr323RkhQZiZG/VODovqQBg+Yx6/7RhieD9fkEPXARkksJK5np6qC/Rnsw5Z56wHeGj5o/o2LRlDjyXB2JlaTBEGzLYzm8xcim1gEEMerhryXBP7GYYLoVtzO4Si7GwR13TxQjOGAP2KqEttrWgVkFVRubduc0t03USI2ZV2jPuMq4GJWtWPHs5JVdbBOE1XuWrDOwIv0jSKtPlqwXteH8lavm+WnMONrhyCuA1Cv2nVHlgqREs9XDkIX74Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZfLaI3c4bTzeJoOM5yd9lN/+q7T14Gm0ZxyNGoW/aik=;
 b=koKT0NR6RjNyGuQvnIdinoS6Ii1rceBZwfoWb4vQk25SqpZZYDkMF99w4fpaXOtg6xxhwTKLkoU2CD3kjf480BIrBfzPUsU6htIRJr4hXSdHDTq7giVfi8YyU+vVK7H1tuK7W3hKDimK3pgIsHpwKjdQD85iFSu6+z+7JSpFdkdtX8U3MWHQQL5RueCE8ejXl1J2FpDEHd5/gjIQWPyTowDG1la6V4ll/VLyAA031XeKWZMRpbZ0OwDNumpOFMHNt5HG9Kxxw8TuHvR+5H4BoWIW3g0LEmNDU/nUOjiBkdoeHIW6cv24jQbaEB93l4L1Lr6BbwhBYKMSpQiYXpwbyw==
Received: from SJ0PR05CA0028.namprd05.prod.outlook.com (2603:10b6:a03:33b::33)
 by DS0PR12MB8442.namprd12.prod.outlook.com (2603:10b6:8:125::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.12; Tue, 3 Nov
 2026 18:13:39 +0000
Received: from SJ1PEPF000037B8.namprd05.prod.outlook.com
 (2603:10b6:a03:33b:cafe::6b) by SJ0PR05CA0028.outlook.office365.com
 (2603:10b6:a03:33b::33) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.8 via Frontend Transport; Tue, 3
 Nov 2026 18:13:37 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.118.232) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 SJ1PEPF000037B8.mail.protection.outlook.com (10.167.244.197) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.592.5 via Frontend Transport; Tue, 3 Nov 2026 18:13:37 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 3 Nov
 2026 10:13:17 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Tue, 3 Nov 2026 10:13:16 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.2562.56 via Frontend
 Transport; Tue, 3 Nov 2026 10:13:12 -0800
From: Edward Srouji <edwards@nvidia.com>
To: Saeed Mahameed <saeedm@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
	Tariq Toukan <tariqt@nvidia.com>, Mark Bloch <mbloch@nvidia.com>, Andrew Lunn
	<andrew+netdev@lunn.ch>, "David S. Miller" <davem@davemloft.net>, "Eric
 Dumazet" <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, Yishai Hadas
	<yishaih@mellanox.com>
CC: Edward Srouji <edwards@nvidia.com>, <linux-rdma@vger.kernel.org>,
	<netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Mark Bloch
	<markb@mellanox.com>, Michael Gur <michaelgur@nvidia.com>, Patrisious Haddad
	<phaddad@nvidia.com>
Subject: [PATCH mlx5-next 4/5] net/mlx5: fs, add NIC_RX_CLASS steering domain support
Date: Tue, 3 Nov 2026 20:12:52 +0200
Message-ID: <20261103-rdma-rx-classifier-v1-4-1ad6c8cfe936@nvidia.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20261103-rdma-rx-classifier-v1-0-1ad6c8cfe936@nvidia.com>
References: <20261103-rdma-rx-classifier-v1-0-1ad6c8cfe936@nvidia.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.14.2
Content-Transfer-Encoding: 8bit
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF000037B8:EE_|DS0PR12MB8442:EE_
X-MS-Office365-Filtering-Correlation-Id: f8f28bbc-4fb1-4141-267d-08df39d62ea0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|7416014|376014|1800799024|36860700016|23010399003|18002099003|22082099003|261102123227099003|56012099006|10067099003|261009223027099003|921020|261022113327099003|261022105027099003|261021121427099003|261021123027099003|261021135927099003|261022075727099003|11063799006|261026121527099003|261028144727099003|261026140227099003;
X-Microsoft-Antispam-Message-Info:
	qdnlE6cr1fSgT2OLHw7XSX5Rg3JDuRg4MY/3O0GZjhJmcfMWt83R2xwsGM8/cXcxwTwu3cAV4P35X4Tw1paOgaj661BqY2uvKNvtg82RwgzgC2Jjgk64BK6yhP7W3cwLujApDJLw1NkJxVxYMgw5fim+RuXKIDDeWzGTwLAqsCcA8KeyDjUCKHpolxLunLmG7cgTaHUWh0clmVnL3sJuJJgzGNvmXzJCoajlLupNh9S4a5j4GyzVJwdWHFRMW+aD1Aa6NNXPjIWtrcuvrhgDDfrfuCkWbFY3zbhJlhkt6p8EOJh1/JHtGZPt480kQGSKPdsSYdnryiwcWBxcmhJCSbCwoEV+d+jAXz3j4JbgrhxQ7bMn/kHy/miB8PWAWBpth5pnk67073iV8VOfeM7OPc+w6LcSv9Hq0H+/F2cQlaLfAqBM7iUswlGoDka0mvaLJaRqt31yxIbsU0nhcpWCWXXUXF82241t3kmLkCdlg+GzixnzhRrkABV/0HVpqqhZn1Iky4A4UPYpUZU+jxrHeW6RMl441Fa+cvc7mOIP2kJgcs1P9ISWjMhEMYNS2v+Uhw9BNYUDfNXdqImIk58yDd/8//FzzAS5S9r/oXM3XKtZJ3z0807T5jiFY/PCrvBgHDk79bfJoYT3yrsoDA+syMDUDmA5Ml7eEsIxeNdI/M0uB8oMxqAFC0WDp4LcLQSwfofnYQF4LjNGWHc8+rUKF1BCFhYDvWWUDBuZNOvShuVeWjQpo+vMAQxamoC6MNII
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(7416014)(376014)(1800799024)(36860700016)(23010399003)(18002099003)(22082099003)(261102123227099003)(56012099006)(10067099003)(261009223027099003)(921020)(261022113327099003)(261022105027099003)(261021121427099003)(261021123027099003)(261021135927099003)(261022075727099003)(11063799006)(261026121527099003)(261028144727099003)(261026140227099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	whEtKyhYB7EjLlJ6uLUxr+nDoc0khIQvnrKdNo9AnzmPAJnuudXWSidTwxkF8z24nMpxF4Tv45b3IbHdW8KvESOQUjblc7wI8/1q2emcDpx9BpLETu36RqJXTA93QosteIEdIPUQ8PVDDrd6D8vM257iiVrz1hQ6oK06pIFNAw7+U0T0+EfP6HoRsRTjen7Ix4Pq+22F2IZODNIP0K+YeJ4oeeimQa2RF7VWIyZH8EgoHHIZnb50OYLVwsosn0rieBr/OjyBEu/Hnvtqpe/aks4VKIKM3Pdc6s2NKKmmKu0TObUvYgKL46OeJCHVfrCbEl4ak1+zDqLMAPdvziJ7KTZVnK+bUKEUM+2oJcou/IEKiyQ9Nn1324CKC8zjOGeEhgTsKKNytbtgP0yjpbNogi5oKq9EMsgrBXuyRpIPo0+oV8mEwLMrLCAjbw5FGBfe
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2026 18:13:37.7713
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f8f28bbc-4fb1-4141-267d-08df39d62ea0
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF000037B8.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8442

From: Michael Gur <michaelgur@nvidia.com>

RDMA transports that don't natively map to hardware's fixed RoCE
recognition (UDP dst port 4791) need a way to tell the NIC that other
packets should be treated as RDMA traffic too. NIC_RX_CLASS gives the
RDMA transport manager a programmable classification stage ahead of
the regular NIC receive path: software installs match/modify-header
rules there to steer packets using other UDP ports, or other packet
formats entirely, into the RDMA receive path, instead of being limited
to hardware's native RoCE detection.

This domain supports Modify header actions in case steering the packet
into the RDMA path requires rewriting it into a format RDMA_RX expects.

Signed-off-by: Michael Gur <michaelgur@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Reviewed-by: Patrisious Haddad <phaddad@nvidia.com>
Signed-off-by: Edward Srouji <edwards@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c  |  5 +++++
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c | 24 ++++++++++++++++++++++-
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.h |  4 +++-
 include/linux/mlx5/device.h                       |  3 +++
 include/linux/mlx5/fs.h                           |  4 +++-
 5 files changed, 37 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
index 8af73393770c3c8eef2556efe591d5b712388aa6..fad0050c53a666da54c5d26e8d78bef917558b69 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
@@ -1016,6 +1016,10 @@ static int mlx5_cmd_modify_header_alloc(struct mlx5_flow_root_namespace *ns,
 		max_actions = MLX5_CAP_FLOWTABLE_RDMA_TX(dev, max_modify_header_actions);
 		table_type = FS_FT_RDMA_TX;
 		break;
+	case MLX5_FLOW_NAMESPACE_NIC_RX_CLASS:
+		max_actions = MLX5_CAP_FLOWTABLE_NIC_RX_CLASS(dev, max_modify_header_actions);
+		table_type = FS_FT_NIC_RX_CLASS;
+		break;
 	default:
 		return -EOPNOTSUPP;
 	}
@@ -1177,6 +1181,7 @@ const struct mlx5_flow_cmds *mlx5_fs_cmd_get_default(enum fs_flow_table_type typ
 	case FS_FT_PORT_SEL:
 	case FS_FT_RDMA_TRANSPORT_RX:
 	case FS_FT_RDMA_TRANSPORT_TX:
+	case FS_FT_NIC_RX_CLASS:
 		return mlx5_fs_cmd_get_fw_cmds();
 	default:
 		return mlx5_fs_cmd_get_stub_cmds();
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
index 033ea5a198ee0d5a7e77ce0770f38bb8ffe97812..77985347e4f13831d7561094af2b2a998c345fcb 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -2833,6 +2833,14 @@ mlx5_get_flow_vport_namespace(struct mlx5_core_dev *dev,
 			return &steering->rdma_transport_tx.root_ns[vport_idx]->ns;
 		else
 			return NULL;
+	case MLX5_FLOW_NAMESPACE_NIC_RX_CLASS:
+		if (vport_idx >= steering->nic_rx_class.vports)
+			return NULL;
+		if (steering->nic_rx_class.root_ns &&
+		    steering->nic_rx_class.root_ns[vport_idx])
+			return &steering->nic_rx_class.root_ns[vport_idx]->ns;
+		else
+			return NULL;
 	default:
 		return NULL;
 	}
@@ -3304,6 +3312,10 @@ int mlx5_fs_set_root_dev(struct mlx5_core_dev *dev,
 		root = dev->priv.steering->rdma_transport_rx.root_ns;
 		total_vports = dev->priv.steering->rdma_transport_rx.vports;
 		break;
+	case FS_FT_NIC_RX_CLASS:
+		root = dev->priv.steering->nic_rx_class.root_ns;
+		total_vports = dev->priv.steering->nic_rx_class.vports;
+		break;
 	default:
 		WARN_ON_ONCE(true);
 		return -EINVAL;
@@ -3807,6 +3819,7 @@ void mlx5_fs_core_cleanup(struct mlx5_core_dev *dev)
 	cleanup_root_ns(steering->egress_root_ns);
 	cleanup_transport_manager_root_ns(&steering->rdma_transport_rx);
 	cleanup_transport_manager_root_ns(&steering->rdma_transport_tx);
+	cleanup_transport_manager_root_ns(&steering->nic_rx_class);
 
 	devl_params_unregister(priv_to_devlink(dev), mlx5_fs_params,
 			       ARRAY_SIZE(mlx5_fs_params));
@@ -3892,6 +3905,14 @@ int mlx5_fs_core_init(struct mlx5_core_dev *dev)
 			goto err;
 	}
 
+	if (MLX5_CAP_FLOWTABLE_NIC_RX_CLASS(dev, ft_support)) {
+		err = init_transport_manager_root_ns(steering,
+						     &steering->nic_rx_class,
+						     FS_FT_NIC_RX_CLASS);
+		if (err)
+			goto err;
+	}
+
 	xa_init(&steering->esw_egress_root_ns);
 	xa_init(&steering->esw_ingress_root_ns);
 	return 0;
@@ -4048,7 +4069,8 @@ mlx5_get_root_namespace(struct mlx5_core_dev *dev, enum mlx5_flow_namespace_type
 	if (ns_type == MLX5_FLOW_NAMESPACE_ESW_EGRESS ||
 	    ns_type == MLX5_FLOW_NAMESPACE_ESW_INGRESS ||
 	    ns_type == MLX5_FLOW_NAMESPACE_RDMA_TRANSPORT_TX ||
-	    ns_type == MLX5_FLOW_NAMESPACE_RDMA_TRANSPORT_RX)
+	    ns_type == MLX5_FLOW_NAMESPACE_RDMA_TRANSPORT_RX ||
+	    ns_type == MLX5_FLOW_NAMESPACE_NIC_RX_CLASS)
 		ns = mlx5_get_flow_vport_namespace(dev, ns_type, 0);
 	else
 		ns = mlx5_get_flow_namespace(dev, ns_type);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.h b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.h
index e36735bea218c6909a6196305caa5c2aa5a83af6..1ef4201e0c5b2ee460bda1c3e79ee37b30291d4a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.h
@@ -148,6 +148,7 @@ struct mlx5_flow_steering {
 	struct mlx5_flow_root_namespace	*port_sel_root_ns;
 	struct mlx5_transport_manager_ns rdma_transport_rx;
 	struct mlx5_transport_manager_ns rdma_transport_tx;
+	struct mlx5_transport_manager_ns nic_rx_class;
 };
 
 struct fs_node {
@@ -420,7 +421,8 @@ int mlx5_fs_get_packet_reformat_id(struct mlx5_pkt_reformat *pkt_reformat,
 	(type == FS_FT_FDB_TX) ? MLX5_CAP_ESW_FLOWTABLE_FDB(mdev, cap) :      \
 	(type == FS_FT_RDMA_TRANSPORT_RX) ? MLX5_CAP_FLOWTABLE_RDMA_TRANSPORT_RX(mdev, cap) :      \
 	(type == FS_FT_RDMA_TRANSPORT_TX) ? MLX5_CAP_FLOWTABLE_RDMA_TRANSPORT_TX(mdev, cap) :      \
-	(BUILD_BUG_ON_ZERO(FS_FT_RDMA_TRANSPORT_TX != FS_FT_MAX_TYPE))\
+	(type == FS_FT_NIC_RX_CLASS) ? MLX5_CAP_FLOWTABLE_NIC_RX_CLASS(mdev, cap) :      \
+	(BUILD_BUG_ON_ZERO(FS_FT_NIC_RX_CLASS != FS_FT_MAX_TYPE))\
 	)
 
 #endif
diff --git a/include/linux/mlx5/device.h b/include/linux/mlx5/device.h
index 37727b5ab78f25df35b07536e106125e2167f20d..b82cf2d6330c612d4cacdda22ed6fdbf1163548c 100644
--- a/include/linux/mlx5/device.h
+++ b/include/linux/mlx5/device.h
@@ -1155,6 +1155,9 @@ enum mlx5_qcam_feature_groups {
 #define MLX5_CAP_FLOWTABLE_RDMA_TRANSPORT_TX(mdev, cap) \
 	MLX5_CAP_ADV_RDMA(mdev, rdma_transport_tx_flow_table_properties.cap)
 
+#define MLX5_CAP_FLOWTABLE_NIC_RX_CLASS(mdev, cap) \
+	MLX5_CAP_ADV_RDMA(mdev, nic_rx_class_flow_table_properties.cap)
+
 #define MLX5_CAP_ESW_FLOWTABLE(mdev, cap) \
 	MLX5_GET(flow_table_eswitch_cap, \
 		 mdev->caps.hca[MLX5_CAP_ESWITCH_FLOW_TABLE]->cur, cap)
diff --git a/include/linux/mlx5/fs.h b/include/linux/mlx5/fs.h
index d8f3b7ef319e192cc9fa895be8d0735c2df4463a..4a868005a36e077655bdb26dfffe1441f5c4e208 100644
--- a/include/linux/mlx5/fs.h
+++ b/include/linux/mlx5/fs.h
@@ -115,6 +115,7 @@ enum mlx5_flow_namespace_type {
 	MLX5_FLOW_NAMESPACE_RDMA_TX_MACSEC,
 	MLX5_FLOW_NAMESPACE_RDMA_TRANSPORT_RX,
 	MLX5_FLOW_NAMESPACE_RDMA_TRANSPORT_TX,
+	MLX5_FLOW_NAMESPACE_NIC_RX_CLASS,
 };
 
 enum {
@@ -145,7 +146,8 @@ enum fs_flow_table_type {
 	FS_FT_FDB_TX		= 0xb,
 	FS_FT_RDMA_TRANSPORT_RX	= 0xd,
 	FS_FT_RDMA_TRANSPORT_TX	= 0xe,
-	FS_FT_MAX_TYPE = FS_FT_RDMA_TRANSPORT_TX,
+	FS_FT_NIC_RX_CLASS	= 0xf,
+	FS_FT_MAX_TYPE = FS_FT_NIC_RX_CLASS,
 };
 
 struct mlx5_pkt_reformat;

-- 
2.49.0

