Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.200.13
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794303136;
	b=GxxW0RuB/Ax6oaChRfeqrtazlH7ytqLk8QeWA8/7WU7KdLgBn3+CO7gnCEb2pD529uhv
	 NsMiormve4gIEc2X9qv3tiibHZbLeYIG0MueATwV1br7o/1KMuE5N9mNFvIC1PRCua3NM
	 ZYCG4WwD5lmd94VQ0ZZjBKFcFBTYSD9aYHCpEvfZIIWd+SNXvbxRSIswl7gA2tnKCgG5G
	 tAQ4vJlWkqYBz/uMTy6ke35kjoo5ivBt+feMybrJ1Cv35QXkrggJUWR8I3JNa4EEEUV5k
	 HR0Z/sHePE4sW57vxU2GtsM7EOy84l4pRwwRKDqgMf71M7lQl9foBj705t1PUmOJeLA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794303136;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:Received:
	 Received:From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 X-Originating-IP:X-ClientProxiedBy:X-EOPAttributedMessage:
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
	bh=7cwoiGha3zbjgIzCMh8+JAiAhp5xsn3qKM+rY/7gzMQ=;
	b=CoEdj3/fVtzFScQEmmE8tJ5Srd10nJgleap5ahfu1TvDpKjWZQzajtuhkGxXbEbMEuun
	 UEm9n3qrbVqHpqjYpgjK2pZPwkKcJH1xSgd7oKt5BQcMNjRfJpBTVOs0ZnHwQdoH88HQU
	 yyqAfkJJ8LuINiC5qov6Ix/qrpAxPXAFwLMAnzie0a2DxuVjMz+KUFxTNEh7kAUeMBiee
	 cPn5MduDNBxrt+kQZcIqe/w4xTK4SVsn4zHXD2x9sse80RqBE5yYMm7edvkajH8MB9xZn
	 Wyq29MuwE+iCReVyiE/AQen9MaNXfEREpbJ5sdgmxadvU64czMx4eStEPz4tPOcKLZA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b="JO/Kuqj8";
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.200.13
Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012013.outbound.protection.outlook.com [40.107.200.13])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E0966078876;
	Tue, 10 Nov 2026 09:32:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9E0966078876
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=JO/Kuqj8
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yrz38fpto2DMkB0jHRYoKWiheWi5Df+/WHI4Cia3td+irlg051WGNYNW8b9gRVr2QC84+T+wFwOuUfkOEAfXIxHdJ31YitVF5W2wxD2rbdF8XEh5TDhPTGpVs57hDMiptjmY7zU2pPTZlbmOayfwc3MuA4DqKO57p/4Jj8/WZgatvCSBRaUOaR2P7rrMd9zPhuUtb2RQO5Tl3jKBMxQuxo3ySiqu6dO/CobrHpMA+x0+grHhH5VZ8B2Z+N8wZOhabnixxHpM93mzjWCLs57GmK+0Lj2beiGdHDG1NA5qewYwvAEggtnlk6WRJ3+PUF02XvU5J2RjHENRofuDq1PsPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7cwoiGha3zbjgIzCMh8+JAiAhp5xsn3qKM+rY/7gzMQ=;
 b=GqDHWXbRRdb3dPbfTFGXmYLbfeNTlY3+hHIOrlkrBMQPNiGEI48FV+rajbK+c8ezTFBNXXSaNTgCK68PRQmPrYzR8+LIVo2e6AcStCK0Fln1zFdXagdd8+6eXbTpbjbzEsOCRVGWfUd4GeDBI8zw0TtezDKNAHlcOx/N6iFQIUapOKcY0WHDwjD8lT041EzNp4H3GmjGY0PaRDfdqNuyfl17YwSBgtVDUHqH3XtSDE5Nb02BnxNiFRgM9qQKpi0VHzKOIr1fLLRvKqyOQzxZbE7fTamRCZJihaWDvYeDRmmyG8qLptmvQ/9IQDWoHox6tz0wgy771xBcNMX5ju61fQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7cwoiGha3zbjgIzCMh8+JAiAhp5xsn3qKM+rY/7gzMQ=;
 b=JO/Kuqj8BXy7odlS385jLDWcZX06GBtdT5Ex6P7YKMzw5JTn9fUfQ/XaGvzw6JffooQmUdChWokA+goNRYRpq5Ypp3iQFrBEx8j7z1Ankdtm0nLr0iJVLFlZWvkHh54wJ0E9UT/QMDhpb/c+QMz2FzVcfUM5+EZgEY18OIiQtFdvsIhcM1Cy676kCk09s+OtF4x/TrdUKjh9c8tKnF579+O2sFN3c3vT+iOgw0+I7pdnxGqFudDfpN3cmtN6Wv4aB3Ei/UhdIIHZ33gPU0ZXdmSq6fbrpe37V+Jlr6CXjFSh2mFF5IUUQn7Ogy18IBlOptjG/7ozRA4pLrA7mgsQcQ==
Received: from BYAPR21CA0016.namprd21.prod.outlook.com (2603:10b6:a03:114::26)
 by DS0PR12MB7780.namprd12.prod.outlook.com (2603:10b6:8:152::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.12; Tue, 10 Nov
 2026 09:32:06 +0000
Received: from CO1PEPF00012E63.namprd05.prod.outlook.com
 (2603:10b6:a03:114:cafe::37) by BYAPR21CA0016.outlook.office365.com
 (2603:10b6:a03:114::26) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.639.0 via Frontend Transport; Tue, 10
 Nov 2026 09:32:06 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.161) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CO1PEPF00012E63.mail.protection.outlook.com (10.167.249.72) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Tue, 10 Nov 2026 09:32:06 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 10 Nov
 2026 01:31:49 -0800
Received: from nps-server-23.mtl.nbulabs.nvidia.com (10.126.231.37) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Tue, 10 Nov 2026 01:31:44 -0800
From: Shay Drory <shayd@nvidia.com>
To: <tariqt@nvidia.com>
CC: <andrew+netdev@lunn.ch>, <davem@davemloft.net>, <edumazet@kernel.org>,
	<kuba@kernel.org>, <netdev@vger.kernel.org>, <pabeni@redhat.com>,
	<agoldberger@nvidia.com>, <cjubran@nvidia.com>, <cratiu@nvidia.com>,
	<edwards@nvidia.com>, <gal@nvidia.com>, <leon@kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
	<mbloch@nvidia.com>, <moshe@nvidia.com>, <ohartoov@nvidia.com>,
	<phaddad@nvidia.com>, <saeedm@nvidia.com>
Subject: Re: [PATCH net-next 11/15] net/mlx5: E-switch, add match-metadata allocator for nested VF/SF eswitches
Date: Tue, 10 Nov 2026 11:31:36 +0200
Message-ID: <20261110093136.377962-1-shayd@nvidia.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20261103171009.563034-12-tariqt@nvidia.com>
References: <20261103171009.563034-1-tariqt@nvidia.com> <20261103171009.563034-12-tariqt@nvidia.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF00012E63:EE_|DS0PR12MB7780:EE_
X-MS-Office365-Filtering-Correlation-Id: ec602084-cea2-435d-eb9f-08df3f0d7c89
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|82310400026|376014|36860700016|1800799024|22082099003|18002099003|6133799003|10067099003|4143699003|5023799004|11063799006|261009223027099003|261028144727099003|261026121527099003|261102130727099003|261102123227099003|261022105027099003|56012099006|261021121427099003|261022075727099003|261022113327099003|261026140227099003;
X-Microsoft-Antispam-Message-Info:
	ak0uez6V/8+4LPujqfeE+VrywQok/dYTy6KOEBWaEcsuIdlJodOzgGjZo2PCEdsdKWgCv2PjNAaHQ4BlZp9bBB0GGwgSDJs+U6pKQBueRHiOS/m0727Kdm0hnb+gQuSSqIC0/VLl02p6LD3THDXnGKz3AXKijxqjj0QVyXjeKxohCJ41z2040QSH0Axj3PdkYV+R2vEWhC5wDZHSsGKfnAaHAyTaHj0HyiZXx8xFcDBKrL6V21WzG+0HmmAdT4AtwtA+s3hezxOXqyz9+w+Ou7KRusNOwTY1YgRvngUbMsp+lsVxW39pW/1dqDARtLBmo+TSS6WCoqG+jvjb0cx85SG5XguJkRprxrfwXnfOvaMjPiXSFOq2SY7JDs5fm+iiuf8+6yoGqFLPKHQTIn7pg+Mn3jVjfitFuBcuU+1DuA9DxwAVzgIuQCqvGCsEVngVXirCm99EdrCXTnfaZcI01KGtUm1G+bxhb09nhgdXIB1oops5J6x3i00oRUheDwOYgZchlOVpIrYnJJOU5GVcFdmQzU4gwzjB5tu4Cw9yfAwrMr939nyJ3SBrBEIC8OT8hFo3eebrz2qPlbcFWQ71+0HCVkn9uWjgCxB9dOIGtb9s3DBsdklobDTTMblP2zo6z/064eh3iRm4fJd56oEQoQ4RaB4ftpt+aqL3+iTY99azZpPGI2IDou/9KSE1oy1/KxeGj78tmz5s+CZR57gpjQ==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(23010399003)(82310400026)(376014)(36860700016)(1800799024)(22082099003)(18002099003)(6133799003)(10067099003)(4143699003)(5023799004)(11063799006)(261009223027099003)(261028144727099003)(261026121527099003)(261102130727099003)(261102123227099003)(261022105027099003)(56012099006)(261021121427099003)(261022075727099003)(261022113327099003)(261026140227099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	EYjIIvLjLmbgRJGDhQe+aIuE8KYskzv0y7/m3fz8AJirTbdeLv7xkFjAeUYA29s6o86WHh/f9/EtnAGLN6qivwTnMvocycDGpPD+8gc6+m1ie0SuhwShYcEAryvMAeO8IIUnRGE8b8Nr5AlwUWtprC0NuP+yTW1Lpol864tAasuhR/NslQaXQb29TJtwYmaaME3xtR6R54t418aqptRIHmFBs+64vgEu5yst+3JVA7suMGQAbSyx8+CDkFDj3B1CAiafVUwhnS70dWnOKtCuwfjvFOjF40Vc5EVizt2smwUApmB6Zzk78ysYbYB5CboBUGDGqP0tbEOZHl67MRvspsTLa7pMtA7A9Ry6uezb7tEvHgY0nlmhWbMmmWuFTPyTf6Y1aTfytqo2cd5id9KTd2vNFMZQH3+qc1Q7iwl15dyYLPglnBSAf3H8H6vCwmnZ
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2026 09:32:06.5448
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ec602084-cea2-435d-eb9f-08df3f0d7c89
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF00012E63.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7780

On 03/11/2026 19:10, Tariq Toukan wrote:
> From: Shay Drory <shayd@nvidia.com>
>
> The eswitch source-port match metadata is laid out as 4 bits of PFNUM
> and 12 bits of a unique id (ESW_SOURCE_PORT_METADATA_BITS). PFNUM is the
> native_port_num reported in HCA_CAP, so all VFs/SFs of the same PF share
> a single PFNUM. Each VF/SF eswitch allocates its id from its own
> vport_metadata_ida, restarting from the lowest value, so two VFs/SFs of
> the same PF can end up with identical metadata. Once their eswitches
> share an FDB (virt LAG), that metadata no longer uniquely identifies the
> source port.
>
> Add a dedicated allocator for nested (virt LAG) eswitches that replaces
> the PFNUM field with the VF/SF's slot in the LAG (its xarray index in
> ldev->fns). That index is unique per function within the LAG, so
> combined with a per-VF/SF id it yields unique metadata regardless of
> which PF the VFs/SFs belong to. The split is 8 bits for the virt LAG
> index - which fits the U8_MAX cap on the LAG xarray - and the remaining
> 8 bits for the id; the two still sum to ESW_SOURCE_PORT_METADATA_BITS,
> so nothing downstream of the match changes.
>
> The PFNUM value 0xf is reserved for internal port offload, which stamps
> it into reg_c_0 and matches it with the same mask used for vport
> metadata. That offload is gated on switchdev mode only, so it can be
> used on a nested eswitch as well. Cap the LAG index accordingly.
>
> Select the nested layout for any non-PF eswitch, so every PF keeps the
> PFNUM layout regardless of its virt LAG capabilities.
>
> Signed-off-by: Shay Drory <shayd@nvidia.com>
> Reviewed-by: Mark Bloch <mbloch@nvidia.com>
> Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
> ---
>  .../mellanox/mlx5/core/eswitch_offloads.c     | 48 +++++++++++++++++++
>  .../net/ethernet/mellanox/mlx5/core/lag/lag.c | 17 +++++++
>  .../ethernet/mellanox/mlx5/core/mlx5_core.h   |  1 +
>  3 files changed, 66 insertions(+)
>
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
> index 70e6dd9561a6..ef1043517e9e 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
> @@ -3651,6 +3651,48 @@ static u32 mlx5_esw_match_metadata_reserved(struct mlx5_eswitch *esw)
>  	return MLX5_ESW_METADATA_RSVD_UPLINK;
>  }
>  
> +/* Nested (virt LAG) source-port metadata layout: the upper ESW_NESTED_IDX_BITS
> + * hold the VF/SF's slot in the LAG and the lower ESW_NESTED_VPORT_BITS hold a
> + * vport id unique within its eswitch. The two fields still sum to
> + * ESW_SOURCE_PORT_METADATA_BITS. The LAG slot (0-254, per the xa_alloc() limit
> + * in mlx5_ldev_add_mdev()) fits in ESW_NESTED_IDX_BITS; slots 0xf0 and up would
> + * drive the PFNUM bits to the 0xf reserved by internal port offload, so only
> + * 0-239 are used.
> + */
> +#define ESW_NESTED_VPORT_BITS 8
> +#define ESW_NESTED_IDX_BITS (ESW_SOURCE_PORT_METADATA_BITS - ESW_NESTED_VPORT_BITS)
> +
> +static u32 mlx5_nested_esw_match_metadata_alloc(struct mlx5_eswitch *esw)
> +{
> +	u32 vport_end_ida = (1 << ESW_NESTED_VPORT_BITS) - 1;
> +	u32 max_idx = (1 << ESW_NESTED_IDX_BITS) -
> +		      (1 << (ESW_NESTED_IDX_BITS - ESW_PFNUM_BITS)) - 1;
> +	int idx;
> +	int id;
> +
> +	idx = mlx5_lag_get_member_idx(esw->dev);
> +	if (idx < 0 || idx > max_idx)
> +		return 0;
> +
> +	/* Use only non-zero id's (2-255). */
> +	id = ida_alloc_range(&esw->offloads.vport_metadata_ida,
> +			     MLX5_ESW_METADATA_RSVD_UPLINK + 1,
> +			     vport_end_ida, GFP_KERNEL);
> +	if (id < 0)
> +		return 0;
> +	id = (idx << ESW_NESTED_VPORT_BITS) | id;
> +	return id;
> +}
> +
> +static void mlx5_nested_esw_match_metadata_free(struct mlx5_eswitch *esw,
> +						u32 metadata)
> +{
> +	u32 vport_bit_mask = (1 << ESW_NESTED_VPORT_BITS) - 1;
> +
> +	/* Metadata holds only ESW_NESTED_VPORT_BITS of actual ida id. */
> +	ida_free(&esw->offloads.vport_metadata_ida, metadata & vport_bit_mask);
> +}
> +
>  u32 mlx5_esw_match_metadata_alloc(struct mlx5_eswitch *esw)
>  {
>  	u32 vport_end_ida = (1 << ESW_VPORT_BITS) - 1;
> @@ -3659,6 +3701,9 @@ u32 mlx5_esw_match_metadata_alloc(struct mlx5_eswitch *esw)
>  	int pf_num;
>  	int id;
>  
> +	if (!mlx5_core_is_pf(esw->dev) && !mlx5_virt_lag_nonmember(esw->dev))
> +		return mlx5_nested_esw_match_metadata_alloc(esw);
> +

answers to net-dev sashiko

Sashiko (High):
Does this predicate pick the intended devices? mlx5_virt_lag_nonmember()
is defined as:
static inline bool mlx5_virt_lag_nonmember(struct mlx5_core_dev *dev)
{
    return mlx5_virt_lag_is_supported(dev) && !mlx5_lag_dev(dev);
}
So !mlx5_virt_lag_nonmember() is also true for any VF/SF whose firmware
does not report the virt LAG caps (multi_uplink_eswitch, lag_master,
num_lag_ports < 2). That holds whether or not the device is in a LAG.
Such a VF/SF can still own an eswitch,

[SD] FW doesn't expose such a VF/SF.

because mlx5_eswitch_init() only
requires MLX5_ESWITCH_MANAGER. It never gets an ldev, though, because
mlx5_lag_add_mdev() returns early:
    if (!mlx5_lag_is_supported(dev))
        return;
For that device the enable path looks like this:
esw_offloads_enable()
  esw_offloads_metadata_init()
    esw_offloads_vport_metadata_setup()
      mlx5_esw_match_metadata_alloc()
        mlx5_nested_esw_match_metadata_alloc()
          mlx5_lag_get_member_idx()   <- ldev is NULL, returns -ENOENT
          return 0;
esw_offloads_vport_metadata_setup() then turns the 0 into -ENOSPC:
    vport->metadata = vport->default_metadata;
    return vport->metadata ? 0 : -ENOSPC;
Would that make switchdev mode fail on these non-PF eswitch managers?
Before this patch they got a PFNUM-layout id from mlx5_sd_pf_num_get().
mlx5_enable_lag_rep_bond() in en/rep/bond.c also calls
mlx5_esw_match_metadata_alloc(), so it would fail with -ENOSPC on the same
devices.
The behavior also seems to differ from the commit message:
    Select the nested layout for any non-PF eswitch, so every PF keeps the
    PFNUM layout regardless of its virt LAG capabilities.
With this predicate, a non-PF eswitch that is virt LAG capable but not in a
LAG keeps the PFNUM layout. A non-PF eswitch without virt LAG caps gets the
nested layout, which can never succeed for it.
At this commit, the virt LAG capable VFs/SFs cannot get an ldev either,
because mlx5_lag_add_mdev() still requires mlx5_lag_is_supported(). A later
commit in the series, "net/mlx5: LAG, enable LAG over functions that do not
represent a physical port", fixes that part. The predicate is unchanged at
the end of the series, so the failure for VF/SF eswitch managers without
virt LAG caps remains.


[SD] True, the sentence is looser than the code: a virt-capable non-PF
that is not in a LAG, e.g. one refused as a late joiner and left
standalone, keeps the PFNUM layout. That is fine: "net/mlx5: LAG, do not
add a device to an already-active LAG" also keeps such a device out of
the eswitch devcom component, so it never pairs with the eswitches of
the LAG members, and its metadata lives by itself and is never compared
against theirs.
In case of v2, The commit message wording will be fixed.


Would it work better to test for actual LAG membership? For example:
    if (!mlx5_core_is_pf(esw->dev) && mlx5_lag_dev(esw->dev))
This could optionally also check mlx5_virt_lag_is_supported(). The same
check would need to be used in mlx5_esw_match_metadata_free() so the alloc
and free sides stay consistent.

>  	/* Only 4 bits of pf_num */
>  	pf_num = mlx5_sd_pf_num_get(esw->dev);
>  	if (pf_num < 0 || pf_num > max_pf_num)
> @@ -3679,6 +3724,9 @@ void mlx5_esw_match_metadata_free(struct mlx5_eswitch *esw, u32 metadata)
>  {
>  	u32 vport_bit_mask = (1 << ESW_VPORT_BITS) - 1;
>  
> +	if (!mlx5_core_is_pf(esw->dev) && !mlx5_virt_lag_nonmember(esw->dev))
> +		return mlx5_nested_esw_match_metadata_free(esw, metadata);
> +
>  	/* Metadata contains only 12 bits of actual ida id */
>  	ida_free(&esw->offloads.vport_metadata_ida, metadata & vport_bit_mask);
>  }
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
> index d73bac8441f7..4e15e16ae6e8 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
> @@ -516,6 +516,23 @@ int mlx5_lag_get_dev_seq(struct mlx5_core_dev *dev)
>  }
>  EXPORT_SYMBOL(mlx5_lag_get_dev_seq);
>  
> +int mlx5_lag_get_member_idx(struct mlx5_core_dev *dev)
> +{
> +	struct mlx5_lag *ldev = mlx5_lag_dev(dev);
> +	struct lag_fn *fn;
> +	int idx;
> +
> +	if (!ldev)
> +		return -ENOENT;
> +
> +	xa_lock(&ldev->fns);
> +	fn = mlx5_lag_fn_by_dev(ldev, dev);
> +	idx = fn ? fn->idx : -ENOENT;
> +	xa_unlock(&ldev->fns);
> +
> +	return idx;
> +}
> +
>  /* seq 0 = master, then all remaining devices */
>  static int mlx5_lag_get_dev_index_by_seq_all(struct mlx5_lag *ldev, int seq)
>  {
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
> index d84d0424d04e..f5f105762d88 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
> @@ -275,6 +275,7 @@ void mlx5_lag_add_mdev(struct mlx5_core_dev *dev);
>  void mlx5_lag_remove_mdev(struct mlx5_core_dev *dev);
>  void mlx5_lag_disable_change(struct mlx5_core_dev *dev);
>  void mlx5_lag_enable_change(struct mlx5_core_dev *dev);
> +int mlx5_lag_get_member_idx(struct mlx5_core_dev *dev);
>  
>  int mlx5_events_init(struct mlx5_core_dev *dev);
>  void mlx5_events_cleanup(struct mlx5_core_dev *dev);
