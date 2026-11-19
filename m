Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.196.70
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795076453;
	b=MuzwoXwxy2B7qKsWZedDIlMk8IAB+Hi66/cSpOLe8JXJD+48k1xUjE9D2s2/kAAWxawZ
	 F+QJ0xrPZPjfBwZtSgRvbzfc2R+6URx4VX3n/sewwS1W9rGVaUamCDa7zjB8M60HOj7z+
	 XlZZK1D2wGG98Xj0wXmJsdkrW6waTMgMyvjWmtWJFV6aNAQJ2i79bZadXTZ7KHtpY30XD
	 P0aQ25USH9ZQUF/5IROR7sCwYXUqJX9Sc/0jI2u2FJ6/eaKVUpad52myIW6TXoM2INAtL
	 s/OPj4Luqwt9Rmm75Fj5ZPdV3KeHh3NS9lAJ4lJWv8A6BGsX8LVgUh0nTnViv1906YA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795076453;
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
	bh=vPzFKVisMzC3gaOVoag0R9Gabnwulp2PdCB9AebOZjs=;
	b=FcYh4so+PBjguJEa1rgAF3npxJ5g8wNYgzU7E1eEYfCwb7pU7pkOiqTonW4ZTkxbVQRR
	 gbZtW8oQXFs+Pld6k9TRRHjVSNWOwIZ0YL55nEmyH9sA4JYTVAlZKirbhzIBD8WMx66yj
	 q9M6kClvRwoPhBKs/vYXYm28wfouL+WJlKV246KTYfVjhp/Ukdu/B1fNj74cv+ATNV1T7
	 avKIFNa4XcLJIH0SfF+X/mr25a/161iB3hZ03y3gf1QTdENl6g6mG27VHy/FYUcrxAfBO
	 qczqZVZl90exMtWwdyN3kcPuEHE9LAl+pCMvT5gSxCDdJ+9SBLGrbVuqIjN6qE62xKg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=obgGXUQM;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.196.70
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013070.outbound.protection.outlook.com [40.93.196.70])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CBFB606A320;
	Thu, 19 Nov 2026 08:20:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4CBFB606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=obgGXUQM
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=C9gy0/YnM4NPnSqNls4u4qxlm/h5RQjP0+S1atPBQyahu6nqHRSy/OOJ4EgNzUruqGv8SOnfzQtvgKETAeVgX1Thk2lJpqqlYjUoO1Z7rp33vyOh8ZE3EUuSGLYHQyUO6EzBnAwg5/zm6cvaq2zhnHsoOBnxQUNzXEGXROMGapEeDDEUat62QWfIaF8jEdlfuMWpB9kwcT6mn12/d6825rrMxJBiviyyWThrITHg/W3sAvlmYBRSyF3oVKZSkWouHD5/XyyAIHWwKjnAYdN6iaYVnEBP2/w2WmPneTGQzZ0UD+BtMsSzwTs67/TUIWPrKybxB3kiIhTm+fdF8ivrxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vPzFKVisMzC3gaOVoag0R9Gabnwulp2PdCB9AebOZjs=;
 b=EtbkXYaV9J7/5DQtn0KsAGqJ4a1S6WzNUtDxJg1YynITgmFmeQL7M04uSxMPxwLS1WSY/NYujKe7S4kLcFWeNd0IMZI8Yo0a/Qrj5HfirPahWhzZTf1OSxE0ddeGYLUYsz6JUJ+wQpf54MmUsYtESPZNbwIfq98duBPz5LPs1ms1dPUWOmwQuP3B3LZEj43Zw+ox10/tJAAS9eM6NoDAu5Bdz2p5/4ki0bwGc12KiGkeJ3p84h7RVacLuv42ezBHfbgKvSZ6akjEVGB/lYIOdRa1azc5KqE4oIj4+QmcFjGVB0oksNYPE39RMigwyNNEprJkSadYpW+NoZ1fGPmDjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vPzFKVisMzC3gaOVoag0R9Gabnwulp2PdCB9AebOZjs=;
 b=obgGXUQMNuzI6xfdCeZ/NpVRqRIbZ0ivvjpYuxJ7g+WOycNO6jVbIV9uOc7W/uCsm+FocvtON3G9qICdaHMbGnij4Ve2TLFH36+kYt2gIRz6nVJqRFxn3MOFAqLL9Yha8LbAwNvvTamllKG0RwfGNjI0YJYjgmEw3Gb1cmJo/TUsX/Zgg5fUb/unxqJqD5zbqP0l/+QgWKjdYP6kIRuoVYpT4EGpA4evbA+1T5kX5tiXLNPsC65D5MzIvHOJy+YADWGckOCxRWujl3tnLJPSxg9b60v1Td4rC+JaMu04YJD363HhH5JPZThsuvIKntMLacjz1h5P8sCYQ2jxYzYrng==
Received: from DS7P220CA0114.NAMP220.PROD.OUTLOOK.COM (2603:10b6:8:25f::7) by
 LV9PR12MB9830.namprd12.prod.outlook.com (2603:10b6:408:2ec::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Thu, 19 Nov
 2026 08:20:48 +0000
Received: from DS4PEPF000001C5.namprd21.prod.outlook.com
 (2603:10b6:8:25f:cafe::1c) by DS7P220CA0114.outlook.office365.com
 (2603:10b6:8:25f::7) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.14 via Frontend Transport; Thu,
 19 Nov 2026 08:20:48 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.160) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DS4PEPF000001C5.mail.protection.outlook.com (10.167.23.171) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.662.0 via Frontend Transport; Thu, 19 Nov 2026 08:20:48 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Thu, 19 Nov
 2026 00:20:32 -0800
Received: from nps-server-23.mtl.nbulabs.nvidia.com (10.126.231.37) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.57; Thu, 19 Nov 2026 00:20:26 -0800
From: Shay Drory <shayd@nvidia.com>
To: <netdev-bot+sashiko@kernel.org>
CC: <tariqt@nvidia.com>, <andrew+netdev@lunn.ch>, <davem@davemloft.net>,
	<edumazet@kernel.org>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
	<pabeni@redhat.com>, <cjubran@nvidia.com>, <cratiu@nvidia.com>,
	<gal@nvidia.com>, <leon@kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-rdma@vger.kernel.org>, <mbloch@nvidia.com>, <moshe@nvidia.com>,
	<ohartoov@nvidia.com>, <phaddad@nvidia.com>, <saeedm@nvidia.com>,
	<udar@nvidia.com>
Subject: Re: [PATCH net-next V2 08/10] net/mlx5: LAG: replace fixed MLX5_MAX_PORTS arrays with dynamic allocation
Date: Thu, 19 Nov 2026 10:20:18 +0200
Message-ID: <20261119082018.1587771-1-shayd@nvidia.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <179499791769.3136.2377396411292995534@kernel.org>
References: <20261116103010.1129666-1-tariqt@nvidia.com> <20261116103010.1129666-9-tariqt@nvidia.com> <179499791769.3136.2377396411292995534@kernel.org>
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
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PEPF000001C5:EE_|LV9PR12MB9830:EE_
X-MS-Office365-Filtering-Correlation-Id: bdd786a7-76af-47dc-d598-08df4616045e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|82310400026|23010399003|36860700016|10067099003|261026140227099003|4143699003|56012099006|11063799006|261026121527099003|261022105027099003|261028144727099003|22082099003|18002099003|261009223027099003;
X-Microsoft-Antispam-Message-Info:
	KMnzZIec483xKuOsH1JDBPuPFwWIZAk151eXKzj2G6b0cMZZMe1KLg3AeWnVMYvcgjkeLgOUVYZA5JidSCotD7Hhur4haCzjIFT1RJ1ibpY8kiflGWA+D9aXUafNE3hwcx64scyvkW4iU9tByNavY6S4XiwF3eslfc9xCucIJuPbXg+qkoRarZ7YvAUmOTv9DTyEj0yOK5hqJAD+w18KG3iTDD/SENx1DozjnQ1dx2J5FbqEBaHuq/umEV+IfsOE4NicDt2PuxKxjs44aOKdGQjItk4EsQ87DlRmWLPoM8pAB6Km0hV/AQGit+1qvBS2l5BepE0Z4WuEl2rpUiUIKN1pRZoRDZh9utwudr/A2UQTRIBjzTLcarIkhw2NlA8iAfDaD3Q9EzmR6Flpoz3D5+29+ma3CaSc7vuYOGY0D1oUzzvLtNANypB+CUGCZLEeZCenY0MiY2WHZTDQUjAPv/6EE7yIly702+qa8S1um5Al04nl5iPoXw1oYusVODedo0jfHNSMGXNBptB9pM0ifbSIJrVQndag3ATLV/i2elatlgdHsotCyBJ8fHZVElqAVVrROuEbE3AN0niADCRPnpmdrsHwDVFpa48Mj41eMNlxXV4u9M8IP7lA9+Y6jp2SX9vXBk9lYf9YKgA4HjDsmbknRBeGdnrfRJxfm1Tyw5PnOqOntvtDegGeU3GWKKitkwGYNM+zSknznxdyF49IOA==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(82310400026)(23010399003)(36860700016)(10067099003)(261026140227099003)(4143699003)(56012099006)(11063799006)(261026121527099003)(261022105027099003)(261028144727099003)(22082099003)(18002099003)(261009223027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	HQieTBFxNfyukt83vS5T72pXnmbF8c97+EmFdPnkdyZk3JO6B0o+RMfl35qRPooLwjzL0ZxkolKk0B/KPbRIQevVSiafqIZDtg3sEhpL6HYnWDO4/kxBdkpT0c/AKyz/r5+221+cJc/GGAP/7z6swql0PBoy2P+6HuMprghst4pqA92YFM9//G2+STWAs7xpUyN2UqjxEfyCo+REeZTbLsdyuv4ntcGMG2kLFF5lP/y/lHfVe8sa9ly2kLod7XS+J788Tfm21m82UKRmxVv7Y5TvVCpkVE1koSx2aEomP7m36xpF/l/bQh38X4d8iO/Q3/OkMEWK1/ACVLmNLeolMw2Wd9uN+WGEsXH5br86YFLKFxMRw+yOsTV6NJ7ztUtea0w2HW/ajfC2wDfMMfVY38kzhjrTim/NcbN0mGmCrMBm8BwxXqnJvh3aiaawKOER
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2026 08:20:48.5360
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bdd786a7-76af-47dc-d598-08df4616045e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS4PEPF000001C5.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV9PR12MB9830

On Wed, 18 Nov 2026 10:31:57 +0000, netdev-bot+sashiko@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 2 potential
> issue(s) to consider.
>
> Critical: 0 · High: 1 · Medium: 0 · Low: 1
>
> If you believe none of the issues are legitimate, please reply to each
> issue of Medium severity or higher and explain why the AI is wrong.
> If any of them are legitimate and you plan to respin, please let patchwork
> know by including "pw-bot: cr" as a separate line at the end of your reply
> (one such reply per series is enough).
>
> - [High] Possible heap out-of-bounds read/write in
>   mlx5_mpesw_metadata_cleanup()…
> - [Low] The commit message ends with "Thus, removes the hard dependency
>   on MLX5_MAX_PORTS", which overstates what the patch does.
>
> --
>
> net/mlx5: LAG: replace fixed MLX5_MAX_PORTS arrays with dynamic allocation
>
> This converts lag_mpesw.pf_metadata and the mdev array in
> mlx5_lag_query_cong_counters() from fixed MLX5_MAX_PORTS sized arrays to
> dynamically allocated buffers. pf_metadata is sized by ldev->max_fns when
> MPESW is enabled. The cong counters array is sized by ldev->ports.
>
> > Thus, removes the hard dependency on MLX5_MAX_PORTS.
>
> [Severity: Low]
> Is this statement accurate? This patch converts only two arrays.
>
> This patch leaves the devs[MLX5_MAX_PORTS] scratch array in
> mlx5_lag_rescan_devices_locked_filter() in place. The later series patch
> "drop MLX5_MAX_PORTS scratch array from device rescan" removes it.
>
> Some arrays tied to the LAG member index space are still there at the end
> of the series. That index space is no longer capped at MLX5_MAX_PORTS,
> because "decouple iteration end-of-walk from MLX5_MAX_PORTS" moved
> xa_alloc() to XA_LIMIT(0, U8_MAX - 1):
>
> drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h:struct lag_tracker {
>     ...
>     struct netdev_lag_lower_state_info  netdev_state[MLX5_MAX_PORTS];
>     ...
> }
>
> drivers/net/ethernet/mellanox/mlx5/core/lag/port_sel.h:struct mlx5_lag_port_sel {
>     ...
>     struct mlx5_flow_handle *rules[MLX5_MAX_PORTS * MLX5_LAG_MAX_HASH_BUCKETS];
>     ...
> }
>
> Could the commit message say that these remain? Or should they be
> converted or bounded as well?

The sentence refers to the two arrays this patch converts.
tracker.netdev_state[] and the port_sel rules[] keep their
MLX5_MAX_PORTS size on purpose.

> > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c
> > index 49602f8306155..8a867a04916a8 100644
> > --- a/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c
> > +++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c
> > @@ -15,6 +15,9 @@ static void mlx5_mpesw_metadata_cleanup(struct mlx5_lag *ldev)
> >  	u32 pf_metadata;
> >  	int i;
> >
> > +	if (!ldev->lag_mpesw.pf_metadata)
> > +		return;
> > +
> >  	mlx5_lag_for_each(i, 0, ldev, MLX5_LAG_FILTER_ALL) {
> >  		dev = mlx5_lag_fn(ldev, i)->dev;
> >  		esw = dev->priv.eswitch;
> > @@ -27,6 +30,9 @@ static void mlx5_mpesw_metadata_cleanup(struct mlx5_lag *ldev)
> >  		mlx5_esw_match_metadata_free(esw, pf_metadata);
> >  		ldev->lag_mpesw.pf_metadata[i] = 0;
> >  	}
> > +
> > +	kfree(ldev->lag_mpesw.pf_metadata);
> > +	ldev->lag_mpesw.pf_metadata = NULL;
> >  }
> >
> >  static int mlx5_mpesw_metadata_set(struct mlx5_lag *ldev)
> > @@ -36,6 +42,12 @@ static int mlx5_mpesw_metadata_set(struct mlx5_lag *ldev)
> >  	u32 pf_metadata;
> >  	int i, err;
> >
> > +	ldev->lag_mpesw.pf_metadata =
> > +		kcalloc(ldev->max_fns, sizeof(*ldev->lag_mpesw.pf_metadata),
> > +			GFP_KERNEL);
> > +	if (!ldev->lag_mpesw.pf_metadata)
> > +		return -ENOMEM;
> > +
>
> [Severity: High]
> Can ldev->max_fns grow after this allocation while MPESW is still active?
>

It shouldn't. This is a pre-existing bug: MPESW shouldn't be enabled
while an SD secondary hasn't probed yet. A separate fix that rejects
MPESW in this case is in the pipe.

> The allocated length is not stored anywhere. Yet
> mlx5_mpesw_metadata_cleanup() walks the members with mlx5_lag_for_each(),
> which checks against the current max_fns:
>
> #define mlx5_lag_for_each(i, start_index, ldev, filter) \
> 	for (int tmp = start_index; \
> 	     tmp = mlx5_get_next_lag_func(ldev, tmp, filter), \
> 	     i = tmp, tmp < (ldev)->max_fns; tmp++)
>
> mlx5_ldev_add_mdev() grows max_fns without looking at the LAG mode:
>
> drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c:mlx5_ldev_add_mdev() {
>     ...
> 	/* max_fns is the iteration ceiling; grow it, never shrink. */
> 	if (idx >= ldev->max_fns)
> 		ldev->max_fns = idx + 1;
>     ...
> }
>
> sd_lag_init() calls it for each SD secondary, also without checking
> ldev->mode:
>
> drivers/net/ethernet/mellanox/mlx5/core/lib/sd.c:sd_lag_init() {
>     ...
> 	mlx5_sd_for_each_secondary(i, primary, pos) {
> 		err = mlx5_ldev_add_mdev(ldev, pos, sd->group_id);
>     ...
> }
>
> Here is one possible sequence on an SD card:
>
>   devlink esw_multiport=true
>     mlx5_lag_enable_mpesw()
>       mlx5_mpesw_metadata_set()
>         kcalloc(max_fns = 2)
>
>   secondary PF probes later
>     mlx5e_probe() -> mlx5_sd_init() -> sd_lag_init()
>       mlx5_ldev_add_mdev()     /* idx 2, max_fns = 3 */
>
>   devlink esw_multiport=false, or unload
>     mlx5_lag_disable_mpesw()
>       mlx5_mpesw_metadata_cleanup()
>         reads and writes pf_metadata[2]
>
> SD secondaries have fn->dev set, so the MLX5_LAG_FILTER_ALL walk visits
> them. Three things then go wrong for any index past the allocated count:
>
> - cleanup reads pf_metadata[i] past the end of the slab object.
> - if that stale value is non-zero, it calls
>   mlx5_esw_acl_ingress_vport_metadata_update() on that eswitch, and
>   mlx5_esw_match_metadata_free() with an ida id that was never allocated.
> - it writes 0 to pf_metadata[i] past the end of the buffer.
>
> With the old embedded u32 pf_metadata[MLX5_MAX_PORTS], a member added
> later at an index below MLX5_MAX_PORTS read a zero slot and was skipped.
>
> The last patch in the series ("do not add a device to an already-active
> virt LAG") says SD secondaries join before MPESW can be enabled. Is that
> enforced anywhere?
>
> - mlx5_devlink_esw_multiport_set()->mlx5_lag_mpesw_enable() does not
>   check SD readiness.
> - mlx5_phys_mpesw_validate()->mlx5_lag_check_prereq() only checks
>   mlx5_lag_num_devs(ldev) == ldev->ports. That counts port members, not
>   SD secondaries.
>
> Would it be safer to record the allocated length and bound the cleanup
> loop by it? Another option is to refuse max_fns growth and SD joins
> while MPESW is active.
> [ ... ]
>
> --
> Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261116103010.1129666-1-tariqt%40nvidia.com
