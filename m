Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.43.43
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794412326;
	b=5CRhvR72c5kRr2LLDjeEF2zqpJoDuziiDoWGl5Kh79j5Y/c7mLPo8vgD1V29VxL2fGlB
	 4BVUTZ7E4kfDaEy1/ypXSK//JUWnanffILiTtLdDOMGTLoursnqcAV/beGk6TB09KaNss
	 jS9iT7zlPoXV5X3cl++EUULoa+Cy+kreoAu4LAVvFOS/bsZfTCb5KEF8bR2d8TTnvv9/V
	 EppEZdIN9w4jYer7gUZNo1TgUgxeWnJkLCWP/ZsRakIxU3yYEXiOOxGjFgIp/J79Frp/C
	 YXwdU80nufjjl2JVoev/5QQTCww1uS+yjPzdMd2OdqlUcUz5yoOCW+UzqwOCw6jt16Q==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794412326;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:Received:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:CC:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-Originating-IP:X-ClientProxiedBy:
	 X-EOPAttributedMessage:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-Id:
	 X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=lgGrbJcYUU+gCpuOdYiMLcKFXce2afjz5UIe8IguZyQ=;
	b=i9H68ctMsGFCHVjgtR83SXbqQviZlBzTmot3n99tQhzOUq0Z686Rs88w8ul4f8VWoFg9
	 i/WrghlZay0nw7Eg8RhHau0PLcyPEE9rkSNM9GEKzL+xzE3ZiLc/+XbCFBZfQP30+UHAr
	 nqxFcefgdlSikm8blybi3QmCeTVp0EosHihw8AqaFutdG8lzQKt2zqK+aobWdAgeohKD3
	 YbhLUIbD07Kbex68Nph8vgMhiJkcUcauXvWAF9FZULefO937t6vj90hv2abAoRorov/Dc
	 RrZBwmN/tWdmmkPNRbRVVtHG5GsWV7ODcH7v6dQuUVitqEIhRYuxTIA4uXQUE8O49wQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=kRSBVf4D;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.43.43
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012043.outbound.protection.outlook.com [52.101.43.43])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D85B7606A88E
	for <linux-rdma@vger.kernel.org>; Wed, 11 Nov 2026 15:52:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D85B7606A88E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=kRSBVf4D
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=U4Gquf2Zsd4hjGz0Q8FIS7t8S5FDCRUMkN9jgRCVlguAFFTckeWh5pbU/ZSGjm/OQVmd/CZMJHtfW+vmrkr5ob7NIaaMLusauWaC8ug8qU9mqMg2uNNH46pMrKwRTZvUp0gI3N293eC19na2jlLS/Qy9BOif9rVngpJgVMvtlEOxftYmUPAXzh6mpYFWLyN2PGacPD6m91W7aL73848ZRz4hgEOCfR8vK6I3esdAFASXqqd4d6H8jpKx/JrIlRNzBKNbWk0JAL7LGZbda5J3kTC1qzltmjkcZBwfI6sLmkf/oDu9HcMaSR2JxOrEjJ3SdRphi/g20/uv6yNhpR6kuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lgGrbJcYUU+gCpuOdYiMLcKFXce2afjz5UIe8IguZyQ=;
 b=ZXystCVBWjPqr94z8VC8jp8bDDKNEdEBtwXfR1CFdZiteMUhOKSvcUOmtDqamHhCAHqex9QChBEXDNRYCioITHrrcry+ANiOs7LuUbyuLIJ01wSy3OpCW7LzvPLGfmhpz/Y6mw9tPwacni+iP124WZjTx8qKx0n00pegJSzqAbEM8BWV7NmoTrRYSokhNuBUDME2y4PPXCBVOn4AmR86icIZJjZ9WhsfK0B6covrpVYxrl85st4UC84WjWd4HA7qty+g4a8Pfownbn1YEgrUrIbpyx1jUHWgDLqx5JIMo1bRLOVOgTMRNp/vAjIB0gffybj6Nj1eKW1yQhAGyNH0yQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lgGrbJcYUU+gCpuOdYiMLcKFXce2afjz5UIe8IguZyQ=;
 b=kRSBVf4DerOuNLrAPejk7Zu5WIbEgKSBA64u6Sc+FbDBvZ3PLubqXpdABHv3xO+RoQ5nldgAimilmTRvBsjw8TsUhxLsmZX7CTDYMHDSC3T4kCojctsLiZjbv+b3BdNn2YTSdbb+VyrzlDb0sIsIEnPRzDxeOoq5TeWXnYUALMneas9HrbprUVQtX9FFdDhUy0LTeYeug+kYpASrgGpgEDmdCfNgEcUMt/PUyjUUHGtBtjmRFNP2IkJJNlrTbmWQTYYGLnfSfmC0XMEseYtzWqgrIkOCIOqwzNlq5unZcWN6QXZ11TqadMDWsE+nPfzxsKOkfT/6jGViBD3CI/td1g==
Received: from DS1PR07CA0018.namprd07.prod.outlook.com (2603:10b6:8:44d::13)
 by SJ5PPFCD5E2E1DE.namprd12.prod.outlook.com (2603:10b6:a0f:fc02::9a2) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.11; Wed, 11 Nov
 2026 15:51:46 +0000
Received: from CY7PEPF000000F5.namprd05.prod.outlook.com
 (2603:10b6:8:44d:cafe::a1) by DS1PR07CA0018.outlook.office365.com
 (2603:10b6:8:44d::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.9 via Frontend Transport; Wed, 11
 Nov 2026 15:51:46 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.161) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CY7PEPF000000F5.mail.protection.outlook.com (10.167.247.153) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Wed, 11 Nov 2026 15:51:45 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Wed, 11 Nov
 2026 07:51:28 -0800
Received: from [10.125.206.103] (10.126.230.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Wed, 11 Nov
 2026 07:51:27 -0800
Message-ID: <a746452d-c193-4b6b-ad70-8ba51beb6f29@nvidia.com>
Date: Wed, 11 Nov 2026 17:51:25 +0200
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V1 rdma-next 03/24] net/mlx5: Add capability filtering in
 adversarial mode
To: <sashiko-reviews@lists.linux.dev>
CC: <linux-rdma@vger.kernel.org>
References: <20261110134320.34408-1-yishaih@nvidia.com>
 <20261110134320.34408-4-yishaih@nvidia.com>
 <sashiko-outbox-209088@kernel.org>
Content-Language: en-US
From: Yishai Hadas <yishaih@nvidia.com>
In-Reply-To: <sashiko-outbox-209088@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY7PEPF000000F5:EE_|SJ5PPFCD5E2E1DE:EE_
X-MS-Office365-Filtering-Correlation-Id: 07e3be85-3eef-4e01-a5e7-08df400bb085
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|82310400026|376014|36860700016|261102123227099003|261022105027099003|261021121427099003|261028144727099003|261026121527099003|261026140227099003|261022075727099003|11063799006|261009223027099003|10067099003|6133799003|18002099003|22082099003|56012099006|4143699003;
X-Microsoft-Antispam-Message-Info:
	SMVU3Wz/BgtUSRN3zp0VEi/GqGfg0aAS3B4YxHSZV563YTqTGnhohOKKo6F3G4t8SU3BS31peXr/5Zbj7i2JGKK2ykppCoIgFGnaDK1EZVSMQJDb7FVU7ctb0vBJ35TW/0HI1WZqfCdfa4nXjPPn803tB9X04rSmjbJAcXRheKbCH1mVsFt7X67a5KH8isrH6u6ENwFl6y2JOxsagUJdrGg5ou9+iG9xLpJkNme9YLfgz3eI+E0ey0nrnxD3K4IJRaE9XCgyg9qv6E08vKUynWJWEMheHzr6xT9XlXDZOsXOfY2d+x8+0eGdQSszaioqCd/SrzMyxjwEj7MDmFvE7QESd3WJ4BOdJ2MRiQmQTw/xpOfZRrdafsZGFHALo7Abp0rDx/MePJcTP0J5XDIQdgDIdpFHNH246VVuYayLJq76BZWEuz6VmSuhx6BczICKGwUrd3xivBpa5M5jMnETyES/YtRkZbbBtx4z7CjQxXTU4K/H03lYAA9BG8IR+eYsid9zCyYoKKA8HxhGKeVvrB7+1BgcpNSqSD4BUnjQDufxB/559Fk+gd7RXJGon5GrLu72O2hib3TJJ0Y0GXFX7tIfLSDzTZhebZhfj7yiMKlhQCDdv2+skyyUvWZN+rfRrDcmvuiuvfwnT4S/Ib66GUh8t+v9F7iBtqEJkm6xn02yNNHPvjM8UHdo24hGSEgHbd3OEWL+H8elGxfCNdf13A==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(82310400026)(376014)(36860700016)(261102123227099003)(261022105027099003)(261021121427099003)(261028144727099003)(261026121527099003)(261026140227099003)(261022075727099003)(11063799006)(261009223027099003)(10067099003)(6133799003)(18002099003)(22082099003)(56012099006)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	aC4RcWpWMCTBdRnTzE60oSghX8TRsUEEKy98FcCi2FkU03iEP6MBDk5IjC8bP8l71zQ5wZV7IXLseQhYZe6pJzY8Jwg2zCckS7jW+xH3WEjVfafpG8vlRugtPzxqgKoHmoHfuKf2v3ER0naO+o/9TNXSrK36HbDWgZ120oo/Il3OgTnK1kyma7SI/lpQIMNP72YVwIS3hLaiLv1cTxdi11KkwnVyjNYoAxO9psn5OOc94uGS9BET8yuoW+inNwghVtqQdrd7iGFp4lMALKtbJ+T3QY7Gv+Q5yKNNC4awJr5EuUCrr9W+ArXrxJRkqfpaxr15UXBR/V07Ki/KBJD3fVpdudS0tCB6xa5XixuXvG+l15//9CRrZCiMWRdNObehkZLz2tIoBiDPCklZjNaktpJbc2Q7Ca8LVWXMLguumgxnlT4qYG49ZseSBp9ukpBr
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2026 15:51:45.9268
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 07e3be85-3eef-4e01-a5e7-08df400bb085
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY7PEPF000000F5.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPFCD5E2E1DE

On 11/11/2026 15:46, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 3 potential
> issues to consider:
> - [High] net/mlx5: unclamped log_max_flow_counter_bulk causes OOB heap
>    read
> - [High] net/mlx5: unclamped max_tc in mlx5_adversarial_filter_general()
>    overflows stack
> - [Medium] net/mlx5: unclamped log_max_*_list caps in
>    mlx5_adversarial_filter_general()
> --
> 
> commit 3a4fed029c43a049522bf33112212c850561f40e
> Author: Dragos Tatulea <dtatulea@nvidia.com>
> 
> net/mlx5: Add capability filtering in adversarial mode
> 
> This commit introduces capability filtering and range validation for HCA
> capabilities queried from firmware when running in adversarial mode.
> 
>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/caps_filter.c b/drivers/net/ethernet/mellanox/mlx5/core/caps_filter.c
>> new file mode 100644
>> index 0000000000000..023f996bc95ea
>> --- /dev/null
>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/caps_filter.c
>> @@ -0,0 +1,381 @@
> [ ... ]
>> +static int mlx5_adversarial_filter_general(struct mlx5_core_dev *dev, void *dst,
>> +					   void *src)
>> +{
> [ ... ]
>> +	/* 0 is invalid, 8 is for MLX5_MAX_PORTS */
>> +	MLX5_HCA_CAP_CLAMP(cmd_hca_cap, num_ports, 1, 8);
>> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, log_max_msg);
>> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, max_tc);
>> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, dcbx);
> 
> [Severity: High]
> Should max_tc be clamped to IEEE_8021QAZ_MAX_TCS (8)?
> 
> max_tc is a 4-bit field, so untrusted firmware can report up to 15 and make
> mlx5_max_tc() return up to 14.  When qos and ets are also enabled,
> mlx5e_ets_init() and mlx5e_dcbnl_ieee_setets_core() run during mlx5e probe
> and loop up to mlx5_max_tc() + 1, overflowing the 8-entry arrays in struct
> ieee_ets, tc_group[], tc_tx_bw[], and qetc_reg on the stack:
> 
> drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c:mlx5e_ets_init() {
> 	ets.ets_cap = mlx5_max_tc(priv->mdev) + 1;
> 	for (i = 0; i < ets.ets_cap; i++) {
> 		ets.tc_tx_bw[i] = MLX5E_MAX_BW_ALLOC;
> 		ets.tc_tsa[i] = IEEE_8021QAZ_TSA_VENDOR;
> 		ets.prio_tc[i] = i;
> 	}
> ...
> }

This is a net flow, which is out of scope of this series.

> [Severity: High]
> Can an unclamped log_max_flow_counter_bulk cause an out-of-bounds heap read
> past fc_stats->bulk_query_out?
> log_max_flow_counter_bulk is an 8-bit field.  During mlx5_init_fc_stats(),
> get_init_bulk_query_len() shifts 1 by log_max_flow_counter_bulk as a signed
> int:
> 
> drivers/net/ethernet/mellanox/mlx5/core/fs_counters.c:get_init_bulk_query_len() {
> 	return min_t(int, MLX5_INIT_COUNTERS_BULK,
> 		     (1 << MLX5_CAP_GEN(dev, log_max_flow_counter_bulk)));
> }

Only aging counters are bulk queried, and only net flows create them.
This is out of scope of this series.

> [Severity: Medium]
> Can log_max_vlan_list, log_max_current_mc_list, or log_max_current_uc_list
> overflow the signed shift in mlx5e_vport_context_update_vlans() and
> mlx5e_vport_context_update_addr_list()?

This is a net flow, which is out of scope of this series.

Yishai
