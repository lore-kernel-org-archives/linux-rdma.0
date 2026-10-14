Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012045.outbound.protection.outlook.com [52.101.48.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCC64361DCB;
	Wed, 14 Oct 2026 12:48:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791982122; cv=fail; b=DTgWzmhW4L/vIqgXLfDlaKnQBtn+X+W2r2U6eYUpBtYACmZUH2ajbrrNpDqnFOpX9VL0YW+BOqbvC2ncuRWqUnCuxb4uAPYh8jb55L/RX4agAmlMvEU2WUKm9r/OsRMa//aKxraV985QgNAneFYzV8XxSoksm6nQycX5/CKc/QU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791982122; c=relaxed/simple;
	bh=AFWifB7SLecylx2PT4p23IqRhbo+HLp6XdR4o9iUOhA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uiis8F4KPSsR2zpX0cPhh6qeqLl1PxyBAY5OSSOhUhHnc/knQdE/WgOV/l16SpbfFNhajX/nFq87m7fVp1rYN3eijWMCHc3Ww0iv4CR9TwZSRrdNjkFepIK5Dh9PtI3rZEyx/qs/8R6PQ+lOAJlDtEJQNx+F5DjJccPtxIEFQ44=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=AwYfQnOU; arc=fail smtp.client-ip=52.101.48.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="AwYfQnOU"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=smQkEVD6qQc6eZNCf3KkpukNWiMbxMg+ktPBCr5FFSKA9uek4CNFdV9FdYHs/lqJQ+/QYYLIyGEAgkbaiRFP536gt4UjbvjgRM/mHW/rw1SOY6z3YmWxJKuApUs8r7EBAJ289eS08rePv054Im+1Ga8CddcjVLguncVbQBv70Gb+dtduM5zUIZAsPj41QxDihpgjo4LQCmKmpbvTDZzDQhjqdc0mVi3bOLPMnEXyYqXbrRvS51ynkOjPu39nVF+oiA1gbd/eMoBlajjSPm56naDPGJqmD01Hv7Rz6jboPzDyhmRrgVUi0GVbP8BuJhP4oYzmrU910BFvCDMZi68+hg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6RPGpUDvFjfugISPtrPIAmlp669LIyooLUh6Y1mqTcg=;
 b=b405/rECusqljvWtjwJnypd3cej5HFqykYTgDQ55LSavmQZrYW5S3GWdY1fAFC1b8FOG/EuljqDYSiLjbWqibcOGq1KeKTVb7eNnITsM5n+5b6mOsKXdZZAP62CcRrxk/DKrAu1Grtm/QY0P/nvEb3EO5rsYjrV2ZyQ8XvC11Qk1fqv9xKtqpRCJNy286L9uCoySJNI07eUcSNeGGg/XMT488eNbHzDKd4907tnBZ7Q0/+yS1RtIHpRHQAhi3acFnK6m5wdYToPTcbW4qfcqfAEOKGIvR+3ODBr4Z0s7earRapd8FVkB4bn3oPHURvd+FQwI7FfHXkSG86PDUMTgrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6RPGpUDvFjfugISPtrPIAmlp669LIyooLUh6Y1mqTcg=;
 b=AwYfQnOUDupTUAKq4TiLfH3VGiQMeaDNT3kOMryJLKXgIoGPdpJgxnh7AvKBf9y+xwA7KW1YALDwZZ/srPsqEuKxkWs4eFg0oy269o+tct8dHQS1AML8rUjBILddovMQkVwqBewpaxtTihzVvh82zH5kdwTb58OIy0nWgVHULn8kX+Jvy5sIgu0cvQJlF0+v0WYBeXy5rJOvDN9Xd9Z0v/WEueJ6HRTHa8CGJe6OyHJ2CFlni+VsrjvmVzAu3BRYyvi6QbBpRqaUEzdFEdB5bZEtGNUUkRQ+G5YDgkW9kQ0TJ5x2iaadOSSsUQoeO6/tG8U4VpZGzM0zUroLE7zQhA==
Received: from MW4PR03CA0008.namprd03.prod.outlook.com (2603:10b6:303:8f::13)
 by SN7PR12MB8058.namprd12.prod.outlook.com (2603:10b6:806:348::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.13; Wed, 14 Oct
 2026 12:48:15 +0000
Received: from SJ5PEPF000001F7.namprd05.prod.outlook.com
 (2603:10b6:303:8f:cafe::36) by MW4PR03CA0008.outlook.office365.com
 (2603:10b6:303:8f::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.496.5 via Frontend Transport; Wed, 14
 Oct 2026 12:48:15 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.118.233) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 SJ5PEPF000001F7.mail.protection.outlook.com (10.167.242.75) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.522.6 via Frontend Transport; Wed, 14 Oct 2026 12:48:14 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Wed, 14 Oct
 2026 05:47:56 -0700
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 14 Oct 2026 05:47:55 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.2562.49 via Frontend
 Transport; Wed, 14 Oct 2026 05:47:51 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Dragos Tatulea <dtatulea@nvidia.com>, Gal Pressman <gal@nvidia.com>, "Joe
 Damato" <joe@dama.to>, Leon Romanovsky <leon@kernel.org>, open list
	<linux-kernel@vger.kernel.org>, <linux-rdma@vger.kernel.org>, Mark Bloch
	<mbloch@nvidia.com>, "Nabil S. Alramli" <dev@nalramli.com>, Rahul Rameshbabu
	<rrameshbabu@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>, Tariq Toukan
	<tariqt@nvidia.com>, Yael Chemla <ychemla@nvidia.com>
Subject: [PATCH net 3/3] net/mlx5e: Expose CQE moderation mode on representors
Date: Wed, 14 Oct 2026 15:47:04 +0300
Message-ID: <20261014124704.1017782-4-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20261014124704.1017782-1-tariqt@nvidia.com>
References: <20261014124704.1017782-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001F7:EE_|SN7PR12MB8058:EE_
X-MS-Office365-Filtering-Correlation-Id: 7c6f47f3-7d7f-4cee-437c-08df29f169e0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|7416014|36860700016|376014|82310400026|261009223027099003|10067099003|11063799006|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	/wJOZD+t0nIAiRBxalSSpnA3OZGgP5Kob1LpXbET/vYQGjivmbAwwihojzi74GpdpEI7bQ5gwJBHwyDDbyqqSE7YJgbO6wUDjVvr0RNENUbpL4eTU3S3iUPtwYLyLMqds7EHWlREp/Am+qUerYSjqx+V5eyIv56LrR+CbyM33XSnZ4iwfYVRTwC8cOudrmHZZBVcNfggL85kn+9PflzgqmpIdwGxW5J8gJFY3lIsdWkOJZiNsBkxuh9fC/FS2HUFLFv6BCTKAvxFH2ctrBMPnaG6hhl2MWE3Ldc9y1uUSFTAnuvH1tSeGQRSoBxxQoNfaQ512i+oTKVSRGr2diSbkL4jub4TqVcHVIYc2i3W7OGVinv9sLA8pwntN2G1mfKH0VMoVaIKtbQIHly5/GbLBMvUITnB9FVVYeekfs/U3oO+RR4MC/iJHa5b1TiLq1zhqn37BL9SxZdoUJPrPY4FRCpHryiaPh5FXQwlJcl0RbYzPBvK3qETMqBxzHrq7wk8d+HzA6v0IFWJ6MQ0x872rMU5vqqyIj7H+FUK8G25xhYu0/yzm5H9N1LK43/95hWuArp+5l/eTMRKflbhpqCRVkEI9jWJnoJI/3a5N1DdC8Mn/maduOTsWVmAG/8E4rVHMExe7KBd7WWpaiMB27BKay3FD4fq8WYte36fTZq/DXqh7WmoUN/FQ1dIyHN4YlsbA0TB2iSer/EK46vaQy25EA==
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(7416014)(36860700016)(376014)(82310400026)(261009223027099003)(10067099003)(11063799006)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	KvnjMXl5KODbubKjXRp2zuHg/ekxEuum4xHKG6KZ4K9CStsDyiIq5dZCbQUGcgbP06bSiEovyxXId7VPP+jdjasrZDXQ7kMJ/BaKrot6mhsi2+taGiTFiavL7vsIEw+zpqQpHP3hf1OhbSQa2MRt1ievbVfZYI0n9V4epM0HZlT6Z7G8tpqN3/6kBbVPLG0+5uf1WMY1Z88ClWPzIit9CykBwcAjbA/tEpPjtrgNVyVGVWlt8DMvAdRmxn+Z+h0saWAuH37teNNHTht6g4JRjb96KKNgkS0x6nsoB5iaITa8FZUhByaB/SmdI+97YerWfWqoTuRlZpP54HGBdQ8L0nyvPbgwh/F9Z9qUfmYry+tTODs6fTzP4gN7SzpNeUakugZ75HucrZP8BBR6a1w4mREVfywZ4eUItSAgLDVsmII7nxsWuHqat6lzXP37Kdbh
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2026 12:48:14.9868
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c6f47f3-7d7f-4cee-437c-08df29f169e0
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001F7.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB8058

From: Yael Chemla <ychemla@nvidia.com>

commit bc541621f8ba ("net/mlx5e: Support ethtool cq mode") added
ETHTOOL_COALESCE_USE_CQE to the NIC ethtool ops but omitted it from
mlx5e_rep_ethtool_ops.supported_coalesce_params. The ethtool netlink
layer rejects any attempt to set cqe-mode-rx/tx on a representor
with EINVAL.

Add ETHTOOL_COALESCE_USE_CQE to mlx5e_rep_ethtool_ops.
mlx5e_ethtool_set_coalesce() already handles it correctly.

Fixes: bc541621f8ba ("net/mlx5e: Support ethtool cq mode")
Signed-off-by: Yael Chemla <ychemla@nvidia.com>
Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index 88a170e40bd9..4fb132a57bca 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -416,7 +416,8 @@ static u32 mlx5e_rep_get_rxfh_indir_size(struct net_device *netdev)
 static const struct ethtool_ops mlx5e_rep_ethtool_ops = {
 	.supported_coalesce_params = ETHTOOL_COALESCE_USECS |
 				     ETHTOOL_COALESCE_MAX_FRAMES |
-				     ETHTOOL_COALESCE_USE_ADAPTIVE,
+				     ETHTOOL_COALESCE_USE_ADAPTIVE |
+				     ETHTOOL_COALESCE_USE_CQE,
 	.op_needs_rtnl	   = ETHTOOL_OP_NEEDS_RTNL_SCHANNELS |
 			     ETHTOOL_OP_NEEDS_RTNL_SRINGPARAM |
 			     ETHTOOL_OP_NEEDS_RTNL_GLINK,
-- 
2.44.0

