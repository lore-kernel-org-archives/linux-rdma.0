Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011023.outbound.protection.outlook.com [40.93.194.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 682F843C07C;
	Tue, 22 Sep 2026 17:51:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.23
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790099466; cv=fail; b=bisgBL8uTbyxg70ag3kocF/Zy5UlQMuhknOCBSL28ASHIhzVdutD2VE7ECtPCw5iG2hulBxGRe4KXtZ4bi3FDfmNfT14MvoW9NKVR/yHvmKsR6nJ1cMnNghR0CYn/DY3+0idXnBqJDyEBy26cFRkzUihGsm0jjCrG7iMgHw+CP8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790099466; c=relaxed/simple;
	bh=3MGhBmMmXcajgcyy0RTzt9i94dPk0aX7a9XyHjkgdMo=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=G+FKNalyhK/tYEnItgg3vGy2b8XDlrFxdf8kdRQCX790A/xqjxr3M3UoHO8h5Bvll/qdTxfq+b9N+mG+v7slPc9o4b41O8wKAABG5SY80W/H3/SOCdGg4P9Pv9DsPxL+nsvenOBWXwV185Y80X49UmxUmTveNSzz1cqteQ7PVNo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=InUaIgMD; arc=fail smtp.client-ip=40.93.194.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="InUaIgMD"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jWikXq6zFRyTkG1tKqsrEwn/BlrELNRFuCSsVwYl6roDB6esgVK4UmP+uhK9SQHkLBW0g/SB9dhDolYmU9EHbQCE6ndwOX6SAvgSBgT7WEPgJGiR/rYVTln9e5Sb1tVxsKYS577auLdngbhvcn2pOLRMLgsP+HXr3zK3s8LsSziS3HP/X2tsGlfR6w7vGRpEp1txit4VTlnJvDQ4dPm56OluvU3s47k9TlgvvMPvLMQvL/6VnekXV3aHdHwh3FE23m3fchOVnZE2wEwK+lojQJZIaDxrlZ8lWxjbqTOZU0VkoEAz2n/ZZ/QPg+X4Y3SwZkIXdy/e0YF3aJCGdLsukg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+ptsfCuuewqfHdl8Q3bgWr8VIdPMuIO1WryXXS3EQHc=;
 b=XIlt24QBNI3uWCex7maPQWETL6TKtBjjlFNtNHHKND4BUmzEaaJSk/gRK1Agez05u54HEan+e0eohphgIcfS8VCzlNQxY7jIqU7eWTDhbZnbTxFpxApe5odvts5Y2Jts1U//m6ct2X4l1v23oYqw8NXjiaSwgBoUH/ZVT1rqXhOpxQuJGGDQjDkMN9/BX2VBofDEX6VS8TmThn2mqXa72qM/wA1DjXljuuv9ePRI8kc0yoX/mCWj7qTKjbF7V5PfRX1lEyncX75y/q2KfWqYpP1Ku3AeIu2GA7/jFwWOi2pZ8gRPyaMiP+99mMwcTbq3GEndUmmLRdHbaYCv4FQU/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+ptsfCuuewqfHdl8Q3bgWr8VIdPMuIO1WryXXS3EQHc=;
 b=InUaIgMDJNyZ0mdL9VvJOoq4R7stizD04MUAu+RPc9ajX1veBaQxQf9vn0dKFIdQZVbaLM4zibNOSdxCE+dDnDBbNpfSimaKgBrc6Q+tAYJod5IXr9ygv8L4mzCEdN3YMKJ55khawZ9d58Htf6IzklMxeEj0iZhVQ3a1keVSjUjtykzvplZEKUf6sX5mYZQ6yRA7QD1DHrb4BpZst5gE5Q0AIiLWfJIPKYbua/fecabbNqcBdNv0vNW1LpMIuL729yEB7vFWWoSprn+RqYSrMd8BvAnIx21T8mTuaTc/SVQCB9Z694COyFkxGHYLGhpwUFwvYoZQ0reDpiV/z59XnQ==
Received: from BN9P222CA0018.NAMP222.PROD.OUTLOOK.COM (2603:10b6:408:10c::23)
 by LV9PR12MB9830.namprd12.prod.outlook.com (2603:10b6:408:2ec::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.16; Tue, 22 Sep
 2026 17:51:02 +0000
Received: from BN1PEPF00006002.namprd05.prod.outlook.com
 (2603:10b6:408:10c:cafe::75) by BN9P222CA0018.outlook.office365.com
 (2603:10b6:408:10c::23) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.428.16 via Frontend Transport; Tue,
 22 Sep 2026 17:51:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN1PEPF00006002.mail.protection.outlook.com (10.167.243.234) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.451.8 via Frontend Transport; Tue, 22 Sep 2026 17:51:01 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Tue, 22 Sep
 2026 10:50:34 -0700
Received: from [10.125.205.140] (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Tue, 22 Sep
 2026 10:50:29 -0700
Message-ID: <eb64923a-afc1-422f-a0f1-e2dd034d322c@nvidia.com>
Date: Tue, 22 Sep 2026 20:50:24 +0300
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net] net/mlx5: Fix slab-out-of-bounds when handling team
 device events
To: Anirudh Virdi <avirdi@redhat.com>, <netdev@vger.kernel.org>
CC: <saeedm@nvidia.com>, <leon@kernel.org>, <tariqt@nvidia.com>,
	<mbloch@nvidia.com>, <andrew+netdev@lunn.ch>, <davem@davemloft.net>,
	<edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
	<ohartoov@nvidia.com>, <maorg@nvidia.com>, <linux-rdma@vger.kernel.org>
References: <20260922135123.46205-1-avirdi@redhat.com>
Content-Language: en-US
From: Shay Drori <shayd@nvidia.com>
In-Reply-To: <20260922135123.46205-1-avirdi@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN1PEPF00006002:EE_|LV9PR12MB9830:EE_
X-MS-Office365-Filtering-Correlation-Id: 3750d30d-1f33-47ac-303f-08df18d2112d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|23010399003|1800799024|36860700016|6133799003|18002099003|22082099003|56012099006|11063799006|10067099003;
X-Microsoft-Antispam-Message-Info:
	FJBVKD25RyWLAE1n9mtv+TpLyyE5qqiB1nkNmDmt0rhl2X0/NC/ZwAHk/09nbhs9ULPqRNr8lJdYm+O0EBydJKj/sh8+LjX296wioHm8dKDeU9AgsTIk/fjfArWaj0MZsk0X7ihG6iOT4z5iId1tSM8JlbhkEjHu8Y05kh9EyIhgKG5TSBv/YVuSy8SubC1KfzdVDRAaSw70pR1OsaLcAsbMp6PbEKkdKopg45ji7zyDYM06LDwu+yFMW8/NNQH+nzRcoKDDegcouTpmWJxjNn63NJoTPizpbXpvBRqbfCXdh7JT7wAltciRDM1HYLw6373YLUMuPvy2DvsUIp2tIePWUa/B4ZcUPhsdSv27+mP1FJ1ENZT3Tj6oH5iN0TA/wu9rAW4GWoFoC2bDSn3hsnAYCRFceXV4CV6isy1JSV8icwzLyDEx8cngBubC8i5/fIbt2dFmc23obvXjK4aAQepyuMnry2atY0e4RYeCUvAw3GZO9WGFvWgPJ5YlQ8oIAroaysgca/yPBsEv88Reep3edoMEXVzJLS0vNhuLnDWljN7q+73nEsHMMlPIU3UA/TxXyjQ/tALDqHMnYRUh/HtIY6sRQhN3pVI2Kz9LR8908fTLRJWAwbQvottIZ23rA3CyU61sgDi3tU2dkQ273RbglPinIG9W2JAD0DkkJ1Qj3XGMGs1mQYbnHtIDa2e17tMl282/Hn4UqJLT8BzuUg==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(82310400026)(23010399003)(1800799024)(36860700016)(6133799003)(18002099003)(22082099003)(56012099006)(11063799006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	ZgLt/4MbzyHzn//GZfkell33JuautdBQ66aOHoUbY00qJ3h5eIL5/Jd1QV5P9xgt4+oUYwU5pDsNYr54HsX5+LxTJFHLaFlwYxmFHCLAL+x7dHhO7KVOLyAUn9lu0VmEye9UtnTAN43Qiw67HOQhBA9I/ruLnZw2+CQT1ZjBVRahkyqfIiiAMaNp1novAxhOTiJmYsVJ2b2TQdvgdthAXSjL/xZe2rsca0W7uTZCypbZHx7HcpVGQ3cjvtN8TXyS3ji875euCK3ekAXmC8QbFM6KEJ2xfRXLJcU1/RIhAWjrBilTNo8fIou8HIIKq+wDZG8j/bNV3yGZerzWKKYnNN4JOSX87QKZnTPBsDLSa2NFXB8hLSKkyqXvsvkWRjR5X0YGoLawxfSfATvbaq7qR2Sm0OTZ1sTO8aL8aNSeLPxUi6us1JMSvFHQF1G/u5mH
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2026 17:51:01.8425
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3750d30d-1f33-47ac-303f-08df18d2112d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF00006002.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV9PR12MB9830



On 22/09/2026 16:51, Anirudh Virdi wrote:
> External email: Use caution opening links or attachments
> 
> 
> The mlx5_handle_changeupper_event() and mlx5_handle_changeinfodata_event()
> functions assume the upper device is a bonding device and call bonding-
> specific
> APIs like bond_slave_get_rcu() and bond_is_slave_inactive().
> 
> When a device is enslaved to a team master instead of bonding, the code
> attempts to access the team_port structure as if it were a bond slave
> structure. Since team_port is smaller than slave, this causes KASAN to
> detect an out-of-bounds memory access.
> 
> Fix this by checking explicitly for bonding devices using
> netif_is_bond_master() instead of the generic netif_is_lag_master() which
> includes both bonding and team devices. This ensures mlx5 only processes
> bonding events, not team events, preventing the invalid memory access.
> 
> Tested with Mellanox ConnectX-5 on Linux 7.2.0-rc6:
> - Bonding: PASS (no regressions)
> - Team device: PASS (no KASAN errors)
> 
> Fixes: 54493a08e21f ("net/mlx5: Lag, record inactive state of bond device")
> Signed-off-by: Anirudh Virdi <avirdi@redhat.com>

Reviewed-by: Shay Drory <shayd@nvidia.com>

> ---
>   drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
> index 28d16fdc3f06..022a69cdebaf 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
> @@ -1897,7 +1897,7 @@ static int mlx5_handle_changeupper_event(struct mlx5_lag *ldev,
>          int changed = 0;
>          int i, idx = -1;
> 
> -       if (!netif_is_lag_master(upper))
> +       if (!netif_is_bond_master(upper))
>                  return 0;
> 
>          if (info->linking)
> @@ -2004,7 +2004,7 @@ static int mlx5_handle_changeinfodata_event(struct mlx5_lag *ldev,
>          bool has_inactive = 0;
>          int idx;
> 
> -       if (!netif_is_lag_master(ndev))
> +       if (!netif_is_bond_master(ndev))
>                  return 0;
> 
>          rcu_read_lock();
> --
> 2.55.0
> 

