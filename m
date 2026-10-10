Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011039.outbound.protection.outlook.com [40.107.208.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98BB537647E;
	Sat, 10 Oct 2026 13:47:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.39
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791640044; cv=fail; b=tZCQIFeHBqDIW80krSaoP7jxn3O7FT9AXFgznaiSVaK9CrXxKaQtoMcSfDDHDbYi6N1COSFuhMugPvEr8bg4cbC4rhwdNOR+XegTAeH2q+A1fTndUnFRX3GNaGPWDcJ2KbCS1+8tgs2UDK8GPCf5wnhp8dPOBTUu0Mb/QZY9Bsc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791640044; c=relaxed/simple;
	bh=8Q6M/2s8q8LFNzxMtlfALbHKKAp4V8Rj2IdWBEah6hQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=OYSGPmBxF/1/QPiThFkJ3+l5F9YDdh/UVpU9sydgJp98j0MCAJOBjGay0bA3ndUDRZhQpv6Udnj/WebIC3cwrnyio69i1pFd2mdF/rj/8e2Yh6p/2iRkBr3zrqtpErVOFqJmPk97LLm+sSwPgs92wj44k34KPwnsCzr1XOxbCgE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=fail (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=fail (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=qi+ddjMT reason="signature verification failed"; arc=fail smtp.client-ip=40.107.208.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="qi+ddjMT"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kvo9JZjsvJYxvmBQAAiWwaAo1eOnaa7U6t777SQ0Htk/iPPcOxnoLRMOfHciKREdPAseKsc4E2FIjcNAc4eIapzTY2ikOANoFomWFJeNMpZdzR5NcLp7CYp6PW/MKhjDwFz8CtvyuqNByFVwEeVz4L1tvIHRLCjmSoxAmHXjmqQtYSP2Yl/PVCzR0LgQMPmQ7zgdAjz9VCIuRH2C74PkUvs0J+H1r+13ZchiXZ9ElrYEEfZiVMhdueSyz7/YDSTpOEaM+67NWwnTVFE4ORgp1uk08hUibJihb2AhP/NOGU70kBAM4Bs3ersl955gZMju/ty7KAmiAiKBaGv6rWZWbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UJ+UcHrkeA8JwSMkxh7hai7Xo53euoXaxNzQRiB6S/E=;
 b=I2OamiTm390vUZCNpcHN8gNXQbrcrTBZoc0Cgfrkslnr8rgowoHmOPFcClHm2CNEeExW0ml/kbqOeqBVa506jIcSA00wKFeo3tTA8Atmp/KNfmVKMqvJbPvZ+40EEGF17wtJN+3CKmAq4o3j+hsoNJ4rPySoNmEwuUBfvS6WW2idTvX+azGwA7/U6v5fKZcabMAPNKLDve3EJ9DwyO+13gnEMgcBMsEbELZwepXnPrOOS0dZn6jXh7hVuu/o7QXDbXrYZkYVIU8agTGfGjfXPTq6eAKUpLdvdkkP2yFfVKN5eJgpLS6t8VPpQL3fz4ha4QOCrJzUPSflvoVX1J5Y8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UJ+UcHrkeA8JwSMkxh7hai7Xo53euoXaxNzQRiB6S/E=;
 b=qi+ddjMTpsKhz46KiGY67rft0RkHG3nBQajAoL0jUPe93ZI2PqMA14xkgCBHPOrxgdNF7FsrXN50tikrfhix3g7mp0CIQphDnMcK97kJDPsR0+AvWxQ/ezuPTCUxL5Wvt+TK0Ng3Lga3TlnqM2PT3u9TKBl9tqa0JCp0a8QVPGMHWLGgER/jhM8wkSxc/lgwrxlh47jsz4A2bvkXab9IAui/v+918tArczS++ZhHO2UEtfmIlhlNpN0WfMIloHOa6xo5g4QVpaY9wxq80Gsdr41glTKEFErJcWouV0AK33bB+l/g4qPfJZVg4+sK9ZZvlpvBURO4ZZ9yXB977gOcvA==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH1PR12MB9647.namprd12.prod.outlook.com (2603:10b6:610:2b0::10)
 by CY8PR12MB8338.namprd12.prod.outlook.com (2603:10b6:930:7b::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.15; Sat, 10 Oct
 2026 13:47:19 +0000
Received: from CH1PR12MB9647.namprd12.prod.outlook.com
 ([fe80::228c:766a:191d:77b2]) by CH1PR12MB9647.namprd12.prod.outlook.com
 ([fe80::228c:766a:191d:77b2%3]) with mapi id 15.21.0496.019; Sat, 10 Oct 2026
 13:47:19 +0000
Date: Sat, 10 Oct 2026 13:47:16 +0000
From: Dragos Tatulea <dtatulea@nvidia.com>
To: sashiko-reviews@lists.linux.dev, Tariq Toukan <tariqt@nvidia.com>, 
	dtatulea@nvidia.com
Cc: linux-rdma@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 08/10] net/mlx5e: Recreate netdev channels on
 data direct device unbind
Message-ID: <wlgqjiussmqbvbpzygi2jrtexupsu4l6a7j3vnm6dgkrbvtxez@goz2l6jmrvcz>
References: <20261008132815.654147-1-tariqt@nvidia.com>
 <20261008132815.654147-9-tariqt@nvidia.com>
 <sashiko-outbox-165642@kernel.org>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <sashiko-outbox-165642@kernel.org>
X-ClientProxiedBy: FR0P281CA0181.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:ab::8) To CH1PR12MB9647.namprd12.prod.outlook.com
 (2603:10b6:610:2b0::10)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH1PR12MB9647:EE_|CY8PR12MB8338:EE_
X-MS-Office365-Filtering-Correlation-Id: 83745309-5b07-4665-9a55-08df26d500e1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|366016|1800799024|6133799003|18002099003|22082099003|4143699003|11063799006|10067099003|5023799004|261009223027099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	pR+qmpkoovTKzJIAK7ilC22BTRG7H0APnUHwcLdrvx4sPoeANjbHL4uVlRLKr2gbLvaFyGOKOwE0/0QTY2c2QvBF6B8pCsGRZwDq+t/92tCKVW/52otld2pXmqWC6gTO0XlYp0itbzCy7hrtHHotmFRjyZKdhesiB2w5cH108Jg2R++Hi/1ufDZqA1IKq5W35zNHfavQBi1IkKIsTFE264WlpaGlV/o94NopNYSFc41D3YKJ6ThZBvQYk9Dp/giG1zJWZqxGsb98sFiTVIrKtA7/xHfrkR+hdrWzSvZ5T419G18JK9YzSYAS3BvdtRzmLl00iKvBqUZA/gxzT00svtSEF486sxemEm/rB5sAEAhivnIiz/2OZehyMXT0RWW8Xka+J+juvt9RMRho5nVMEM2HfGRtjH3uM0RGBKNVem/lFJT8geQKQfVBPCEv0HSoD4iUJfHE2ZbxpRaOBG1/t8hcSp2po/WYKNFU3yeQnfSpYajft5LQwPPnrMwBFtW0l7WzE6ByqPt1Ii/hA/5RwLIhjK6lnwwvjJVUzzeWxfDKEV475FV/eICwWjtOiEeI2Hr8IZlWsiVeupq6sZeJ9oQNH48y97DFjf7JnAmAb777qeZhXRxuNGp5comT6eWO9hsCl4lf6nMjqCnMhepXPkBEnUUdB8izijol9mdB/IY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH1PR12MB9647.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(366016)(1800799024)(6133799003)(18002099003)(22082099003)(4143699003)(11063799006)(10067099003)(5023799004)(261009223027099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?iso-8859-1?Q?miHBk2B0CzlLPVQPs0WjCljyAzGeMQoGwkgZmdqZ79auI2JS+YvqiHAEKe?=
 =?iso-8859-1?Q?1flCk+cvBEKv3+AkzFgmm3fTUCWQYYv1tvFuhBBosPAaMx23jzK0JQX9z0?=
 =?iso-8859-1?Q?NyhDbhpL9Z8uGCb1yBdCrsjUuI+rk91f7+eBSCYan70u2g93BvL4ArRPvK?=
 =?iso-8859-1?Q?2E2QX937aazRnr6ceIpSPpRfgVPiKFLlYDr61Rem3uw72Zy6cmd04RrT+P?=
 =?iso-8859-1?Q?8ljvsLg9EMn43Pzce1xgzQ6bDqLJJS4DHB52OiYd3u7I78Di3dc1cS29lA?=
 =?iso-8859-1?Q?lTJ2Dr6ZTkr7YfmBcd/WECg6n2FshhoqXdmKkGG8sUH1Ad027ZcYJ6LJQC?=
 =?iso-8859-1?Q?RzH0+OIiJVCXlSsgWlB/buMO6mzm/GIznDTS+NiXP7LPlzHZcnPvAVfhZQ?=
 =?iso-8859-1?Q?Fi4XNDMFRODW4T/wv8k8eSnvP+LpCKFnlMpedXTdm2+espTEhdn1c2ugZv?=
 =?iso-8859-1?Q?m3XFeGCaBdt+83uPoXoW4GnKkGMDXYHwxL56ZlFffWdoKoLaJ9k22oZXDd?=
 =?iso-8859-1?Q?rLhnxZ3OuO2swBlJdz2NadCbYRgZZZKboK37FiYMTLtKJj0qL+n4xfdMeb?=
 =?iso-8859-1?Q?DB58KgkDWBDVDUGQqL1rXJ2egxL2O0u7hEKXRtMZjht27k/uq8N9dloKgS?=
 =?iso-8859-1?Q?gu+ixKjKx82eABkU/hBvA5y/rriRoScqWCO9RBxYukirqqxPNizFuSDM85?=
 =?iso-8859-1?Q?Mknb2kHpGw+jUBmOcgoOBUVxV+S367yTjD3SwpBty3PPqSedKAXsvvVbT9?=
 =?iso-8859-1?Q?n3s4Siz41QEr7CTky5H4IA6hOb2MrWbR+bVLrRGViEGpjW701sIsa5yvef?=
 =?iso-8859-1?Q?6Er7/5pJ1cQpaKX8PwuLPxrT9g3KEA4uVO9XlC4iSA+cB+r6L4GxmkQIGU?=
 =?iso-8859-1?Q?wgigqBCiL12NHBUls4heoglUpjhhcLOLFPWNFj3PjiZjOCLQ1qjzZ3TSRf?=
 =?iso-8859-1?Q?io/H4zuzEyC0pN+u5A0b8H/ZBgTuGoecAaunoDG9uuwoGMUFLF6ea4Sysp?=
 =?iso-8859-1?Q?KLsnuhXeOZ0Qh2OV9LAvvNqxLJ2IO33LaNx4Fxcxpl3zgByWZPBzpcQc5k?=
 =?iso-8859-1?Q?pkqwCr2U4Q9VwThCt7DQBpcUSxXL/OvKUyHZRnat1nnv3mvkmBBTPqddKw?=
 =?iso-8859-1?Q?P1yQkzVcsTxxiwdfBYs5vwGJJtVpS/sF3jqcrHhf3rwxKOHG059zt99jpB?=
 =?iso-8859-1?Q?uKU9BimWiiriAO3gFgYCQGQJmHbOJEtHidujnwWAYo9z+kwSpM5rLZA6dQ?=
 =?iso-8859-1?Q?xnbj0cCupLGomtf1+1ftQH/nRKDKEAGTg6wndM0rAsdhbP9pWlXEuHo6m5?=
 =?iso-8859-1?Q?l+7oX7cPT1VHzK6JT7hauxQeij1yvE7PH7Ji9iaHiMciPmHlY/X1b51U8U?=
 =?iso-8859-1?Q?pnsOoGNoIMm7idJCeWIYc2mOMnuEN6/4ZaoNpG2HnbeZti4Bekq22DYb3W?=
 =?iso-8859-1?Q?ndlFpjoD1EYuCVlZe1MovKclBTHsRSp/A1h8gX8A47uA4T41S7KDjgjLg6?=
 =?iso-8859-1?Q?qaJEXP5CzAlyLeUib06LjsvkPXy1jm+35+RJ5KYw4AS3DNMmS2U4BeeX+G?=
 =?iso-8859-1?Q?u3gTTew9TGx6Fb/OxhM/qiw5vr7Ay6U9+OBfBsKQyFjx1rLtkMxW2XTMec?=
 =?iso-8859-1?Q?WI2alxX/3rJzdQ/9BFkU80FEhlQpUuFI0kZwyWet0tXKFf8JlPJLU/LZZX?=
 =?iso-8859-1?Q?kdm2XUOrkr2X5W0xMRxPhgBr0BcPpC08MaxeIkw8L1gUbsR+D+ZuT0v67d?=
 =?iso-8859-1?Q?dR/yCP5kcMqX51zTr9rLOGddkCg4haHsG58XiHpiOF/ebObMjlguQsy5uj?=
 =?iso-8859-1?Q?ll/zS/91Rw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 83745309-5b07-4665-9a55-08df26d500e1
X-MS-Exchange-CrossTenant-AuthSource: CH1PR12MB9647.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Oct 2026 13:47:19.5764
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RteMnffkXY5D8SaM6S+xRY7LeNxr+BmTL4CPYBFmlE+tnyDBhlDzOs9fmZMdP78n8octYZK4r/69XFnwq35pIA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB8338

On Fri, Oct 09, 2026 at 01:31:06PM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 2 potential issue(s) to consider:
> - [High] net/mlx5e: unhandled mlx5e_safe_switch_params() failure leaves queues using unbound data direct device
> - [High] net/mlx5e: missing devmem revoke hook causes IOMMU faults for dmabuf bindings on unbind
> --
> 
> commit e6199c36bc278fa5fdfb415d4fa28dbdfc733a06
> Author: Dragos Tatulea <dtatulea@nvidia.com>
> Subject: net/mlx5e: Recreate netdev channels on data direct device unbind
> 
> This commit handles the unbinding of a data direct device by disabling
> the data direct flag and triggering channel recreation for the affected
> netdevs. It intends to stop queues from using data direct resources.
> 
> > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> > --- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> > +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> > @@ -6144,9 +6144,28 @@ static int mlx5e_data_direct_event(struct notifier_block *nb,
> 
> [ ... ]
> 
> > +	new_params = priv->channels.params;
> > +	MLX5E_SET_PFLAG(&new_params, MLX5E_PFLAG_DATA_DIRECT, false);
> > +	mlx5e_safe_switch_params(priv, &new_params, NULL, NULL, true);
> 
> [Severity: High]
> Is it safe to ignore the return value of mlx5e_safe_switch_params() here?
> 
The unbind operation can't be rolled back. So even if we check for error
there's nothing to be done about it.

> If this function fails (for example, due to an allocation failure when setting
> up the new channels), the parameter switch is aborted and the currently active
> channels are left untouched. They will continue to run with the data direct
> flag enabled.
> 
> Since the driver proceeds with the unbind process while the active queues
> still reference the soon-to-be-destroyed data direct resources, could the
> hardware access invalid resources and cause use-after-free or crashes?
> 
> [Severity: High]
> Additionally, since the newly recreated channels inherit existing bindings
> via rxq->mp_params, won't they continue to post DMA addresses mapped in
> the unbound data direct IOMMU domain to the primary PF?
> 
> The commit message notes this will cause IOMMU faults because a devmem
> revoke hook is needed to close those bindings before the switch. Does this
> leave the automatic unbind path fundamentally broken when dmabuf bindings
> are present?
> 
> > +	netdev_info(priv->netdev,
> > +		    "data_direct device unbound, disabled data_direct\n");
> > +
> > +out:
> > +	mutex_unlock(&priv->state_lock);
> 
> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20261008132815.654147-1-tariqt@nvidia.com?part=8
