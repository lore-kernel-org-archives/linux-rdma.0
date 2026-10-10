Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012047.outbound.protection.outlook.com [52.101.48.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C69253515CB;
	Sat, 10 Oct 2026 13:56:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791640566; cv=fail; b=MObsdFTyD6l8miUL/8uDQbgmBa+LFUrTnXVQLzjrzJBpHIuV4YSpTGzIM7eLyvcV6korQfJpR2njGmIXUYQ/Gz70kCyGtAYY7bL17cyeDkyKcr9hLHVRPgVxkDqcOUy+ZYbultX7/rFAclrokOx7vf1J9iyfu8MEzwQiWwwpdp8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791640566; c=relaxed/simple;
	bh=clhv2qdFWrbgxFwhwAxXv1Ma8BwM9THeLGGUAejmzNQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=OjQ2lBra8PhCYSEwobBnomPImy8qRJssxZ+NZn1sDVNBIKUtVDrxMGGgOam4joQTtpZZews0qf/Xcs9N2MUKMZeZG5R4pIZ+0tHeaXl80BYFDJZX1z6LnXgpFdm2m1C8ORvW+7xsvswuQc6kt855M6xGsuBcx9wLjKj7PeOxD0o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=fail (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=fail (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=pnaDgj0d reason="signature verification failed"; arc=fail smtp.client-ip=52.101.48.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="pnaDgj0d"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=j0z6nAlEyf//lZIri4HK7NMz6lY7WlxfqzK/DqVSSYF02yUwKRx08Jliki6sN16I39089zsyYF5R5lRoC10VkuEJn+1sBkj4L5qgxLOvue/2kqRhJK5TanuCUV3RiGpoRXMwgFE6zc8vfp1R8Y1AvJbOeiZGFi4ucX/7R37CkT+kHSRimvPaoZ7B9AilgaNCmNt/05fAfeeJTKX9+2K4AHqAT+DUjC9egTEktMTNU5QPJt/+tFYA42w5h0nXURoXq67+aEFS/M7bcm4P33M2d1iJdIXTudMKGGWLHU/FH1nqYYO0vn88SWs0n/zc5agNuPGiSsRFZF0+D01l38aheg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4DDgdht7q4h42zRNbpqD2nluYt7DopaOHk1Dvw/AzA8=;
 b=Ginh8sLggcEQWBpjUGvS1h584Rehkn7E8GgpOaTS3lybTa2IIwerWh7vGEKvaiRQU4erasEseSb6gyeU5ouTNPJOJD0m9gZb9E6K6Su71Ifvw90fpxXvGrJqBjphLgjTJVgUpTWYhxzlapnTiFA2qrdUoAK8XRObqArKIOaWeMB/va9MC2kIfdJc3rWnAxyiIIMxgCc6I2usMyLawLnYgPUzLS8YKEw0uqD7sZAccm6PgGwH3ytN6D4jRkr5370Jl7o7UvbeaJZL4zFnT2eYm1nHWrBepEe8u2wTiE1fDUdwWlXdm74SPsoncJvFIkyqXO6uEam3m4t9A9Ka7I2CDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4DDgdht7q4h42zRNbpqD2nluYt7DopaOHk1Dvw/AzA8=;
 b=pnaDgj0d3qqAHTkbF16tqLzxB9tTcWOXlVI5BVyMpzQwraaqwvB4CrmyM1pFu0AWh8cNKo/SW9AFoJ7zncFSPmmW77HGTjTj1VyoEXSvyD5ZPyN+fnd+ZYwqV03lqdFcKiHMyDBThOfqwDXDm3YkbJ8GyOFr88sfHjq927jou3y9cLMbpFirVz8g8bMlLgC8jgMN4M9slJQCjjA/X8x7tjHs0nQglq3niYpZWKA5E4Xt6Rhaavh2OsoCMcHLQDJsCr8dCZUtfPFZ/jEshgA5ORoK2pets9bJSwehGNIezEMq8ld5CXMv+Mg5F1hC265pWYiVhI3AQDkANj0JH73gXw==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH1PR12MB9647.namprd12.prod.outlook.com (2603:10b6:610:2b0::10)
 by SACPR12MB056849.namprd12.prod.outlook.com (2603:10b6:806:543::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.18; Sat, 10 Oct
 2026 13:56:02 +0000
Received: from CH1PR12MB9647.namprd12.prod.outlook.com
 ([fe80::228c:766a:191d:77b2]) by CH1PR12MB9647.namprd12.prod.outlook.com
 ([fe80::228c:766a:191d:77b2%3]) with mapi id 15.21.0496.019; Sat, 10 Oct 2026
 13:56:02 +0000
Date: Sat, 10 Oct 2026 13:55:57 +0000
From: Dragos Tatulea <dtatulea@nvidia.com>
To: sashiko-reviews@lists.linux.dev, Tariq Toukan <tariqt@nvidia.com>, 
	dtatulea@nvidia.com
Cc: linux-rdma@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 10/10] net/mlx5e: Enable the data direct netdev
 feature
Message-ID: <mywoc3pafnmdenxpdtw5vjkc3s3a6abwtpv6gq6rt7wezkxl4w@loafojttrtlh>
References: <20261008132815.654147-1-tariqt@nvidia.com>
 <20261008132815.654147-11-tariqt@nvidia.com>
 <sashiko-outbox-165644@kernel.org>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <sashiko-outbox-165644@kernel.org>
X-ClientProxiedBy: FR2P281CA0019.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:14::6) To CY1PR12MB9627.namprd12.prod.outlook.com
 (2603:10b6:930:104::9)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH1PR12MB9647:EE_|SACPR12MB056849:EE_
X-MS-Office365-Filtering-Correlation-Id: bc26171d-33a7-4926-b55b-08df26d63801
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|23010399003|376014|261009223027099003|56012099006|4143699003|11063799006|10067099003|22082099003|18002099003|6133799003|3023799007|27256017;
X-Microsoft-Antispam-Message-Info:
	Xjqb+NK3LGqDNF/UyKhYZV/Xows1rkuo+MAraZox31KJgqIKLFkqxFfx6plQ1b2kTn+R4YZuEX4+3uV9xeLb1hxwxboUevXEg28D0IUUgjqkTvRGflMMcN2sAvxu8YR2FqA5PyecR1Gq0QvRrXG+Y2CIO2m7ecy31vVkKnsFzrx2YugvEbiGaRjOPPNd+j6oN9TceyrfDc3KZJ4l25HGmOXhL4h1R+c//wmZN6AheWsY3VwennysQY6y2sc97A+Alj7aeg7qM99ZZp9NiMxr+2XM02GbD/HLHrquS+GEw8TSoudNq/v0jZYzIlz/1CsAshmmA1VfHUtwxk0fkig7F38Ka9cx1yYwCpqQhdVRZlge23ozlEB4fvRZoarEPhld/3yxEdPhzn7mtHm34laqFWy5fWqYxchPU299K4W8LdphV0ODEPorbaaueGbvlbh1Ar6Vx/lhp6fuibLez3C3SIFd2V9tU5WKBCHhbXPHhR2TuV9f7etPLD6fymwsCE2KMLEQ4sXJA7WzQVHtrI0XE5AepwBVHqnAWU6b+fspF11d5peZI9EDUJD0i2x1P236eG/id5WslVKY7Epho99ZGVtyw+yJuAGSDahz5xx51w6sZvVFvb2WS9bLlBUCPYoaaDiLVsY7Y/gLZ95g4VsoMAK82RW/RQ+6zdXu5hudJPFYDA9kx3tTBnYAV8mA54xEJbgDkNNyk7Oq0BIv2z+q/A==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH1PR12MB9647.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(376014)(261009223027099003)(56012099006)(4143699003)(11063799006)(10067099003)(22082099003)(18002099003)(6133799003)(3023799007)(27256017);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?iso-8859-1?Q?035zmyeA5BhT/WS+HGIuetDWLMCJNByvksX21wnprXPcpzJ82KNuz9lOt1?=
 =?iso-8859-1?Q?80Rn/4LvWAGGAhIbvB8vuR8p8VQDJyu/ZpQVYrwq5+7Y3v1FQaxCJYHwek?=
 =?iso-8859-1?Q?9ThZ6f7gf9MGArefYmzvFQwALMEYuf0c4iKVdVwY5fsgL8BlzYtG0HcWJS?=
 =?iso-8859-1?Q?UrOZd7PQHVU2k52+V6Sh//HW19wPKc9L7ZAynED5GRKKxcEBL39snHKEUo?=
 =?iso-8859-1?Q?ZXTNvf9PmIyXEq65UsjJ0QEmVmXY4kFf3nYZ0q8+p8CakJLClWVo95bl30?=
 =?iso-8859-1?Q?InDczE3BxSp478FFfigPj+B5Mzzi++2XfjPUvnhNivrImy5r1V3a9wPK7Z?=
 =?iso-8859-1?Q?Sk0XV0my7M/DUs5I3O4ZZ5F/5Jrokk8fUbg8gxCtVUo8tAPjg1v2mG5att?=
 =?iso-8859-1?Q?8ue3+HFhwFuPGlbFOthX43NfQzoe55NNzmmBj8XoO/xujm+PWZedh+Nm/C?=
 =?iso-8859-1?Q?L1+VrfRO/iScxauIlH4+IANH+J3mIEb69fAFHAVJu9/horb4bFOe/KvLdr?=
 =?iso-8859-1?Q?RO9RG+Io4STUG75T5KDkkmF+HaKmFhLjkpUCK72/jOmATa6HbtGfWKdUBK?=
 =?iso-8859-1?Q?yFjJ0xrgsxtz5ITxb50yTBcq5o0hKfRS6GzoWwg4nOtF3/QJe5xWeKd4yi?=
 =?iso-8859-1?Q?RGXHCovqXLGjLJaHgC394hjL8Fq7u68Fv4qTpSPuKRlHci+rcLagqNCZWz?=
 =?iso-8859-1?Q?72PcvTFSI4mXRz4Y9YnTmIWpGfDV/4WOBD+nZFq6Gn1VBpeKGvn7cX2ExD?=
 =?iso-8859-1?Q?yxgXpG+e6ZnYJg+eZsR/vSENsxFBaOf12W6sbM2mAR3tDBx5Tg/ujF8D8/?=
 =?iso-8859-1?Q?3Hkq2Wa65ONrVNY1/dc0AQXFNQwqpdZe6XTy4AdQhH2zkPvOAskgi8Wufq?=
 =?iso-8859-1?Q?UpHEzTnL8BUOafCk+Mxc2o3hkJqt/h8g5MBhvdq3xOVE75tU0jonhxvbgU?=
 =?iso-8859-1?Q?pUOot24QHqTYaT+41GX5uqfgshMMS9lcg1im1Nsroou1Yv5JQwrz9OyitE?=
 =?iso-8859-1?Q?yDopR5TzvwQ9BGNqUKA4PGUFSgQKnzavxBTr02MDzI15wD60tQr6zJOVuJ?=
 =?iso-8859-1?Q?1XBHPzxup5LIQ0UDANjawNIdrzpxaC2Mqfl7fAKdArcWJs7gLYvxqJkhhK?=
 =?iso-8859-1?Q?m5SPOQXA8DVPgZJo5X2CbDUDI27OGMpezELb5i/A7I3pUGPGgtRUcym//J?=
 =?iso-8859-1?Q?25JgxFWWsWQHuCDaEPx5INWlXSsyyT2qNOoREP19Wk/yLItJkxC5R/vfjn?=
 =?iso-8859-1?Q?yVJhNszoHNaSEKetU4SJb3I2FlDYlPfX3U+y3Cp7z4QoIaS+V9S8S/pe9K?=
 =?iso-8859-1?Q?OMKTLXmnZYCEf9dubKJo19M6D+7cqQTv1lfuOO6jGWwcUG9G0trtFnJqto?=
 =?iso-8859-1?Q?In8c/qrom6k2K2uaEX2tlRw4cAP63jF+18GBevSh2pK70S5C7gImu3rdu1?=
 =?iso-8859-1?Q?fbeEqXXInaJ9zqE03AmJxsIxEc/G6T6O7DqiFaiAeiF5ywUmKYH2nm17/C?=
 =?iso-8859-1?Q?rgKUe0UxcpNjAHKT42H1rCy8Ap13AUfv9m2jUtEF6W11rBF5QJpJBa9RwZ?=
 =?iso-8859-1?Q?sql/kYkzCZltjlCg1ux5PpGaw3E+4+bWAgOkE8rsX/OMmFTrpNb+zhbSZO?=
 =?iso-8859-1?Q?GHR3OlTk5sRZ3B8g2zLKzSl5JzMM0/UEIMckI7+/KgE7xg96xEuDBVUL3q?=
 =?iso-8859-1?Q?N9muq+7HxrmMeqV6rsPCpnJxKozzv4J32SQcgcS5aly2w4veTSfIsBBQSv?=
 =?iso-8859-1?Q?KD6AbWQ49jF+nRDj76jfmsrQBbtUhjwvUwY7Bbgjd36QyfhgQ01WVqITfG?=
 =?iso-8859-1?Q?eZbxA8b+Xw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc26171d-33a7-4926-b55b-08df26d63801
X-MS-Exchange-CrossTenant-AuthSource: CY1PR12MB9627.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Oct 2026 13:56:02.2852
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DisNJfKfoPtgaFjmINxUjtiZ3L57fxRWwZAO1awLgAVhCIOwDGBnFn7MGuSpCi1tSe8K3uOxKGzeGkGDlovmPA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SACPR12MB056849

On Fri, Oct 09, 2026 at 01:31:07PM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [High] net/mlx5e: unbind event ignores dmabuf bindings and channel switch failures
> --
> 
> commit 9f56d4d1fade135dc92a72f9f099f77953de0c1d
> Author: Dragos Tatulea <dtatulea@nvidia.com>
> 
> net/mlx5e: Enable the data direct netdev feature
> 
> This commit implements the data_direct private flag in the mlx5e driver,
> enabling the feature. It also adds a check to prevent changing the flag's
> state if there are active dmabuf bindings to avoid breaking them during
> the resulting DMA device change.
> 
> > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
> > index b3eced1dd43fd..8ab1150ce3f20 100644
> > --- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
> > +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
> 
> [ ... ]
> 
> > @@ -2402,7 +2403,40 @@ static int set_pflag_tx_port_ts(struct net_device *netdev, bool enable)
> >  
> >  static int set_pflag_data_direct(struct net_device *netdev, bool enable)
> >  {
> > -	return -EOPNOTSUPP;
> > +	struct mlx5e_priv *priv = netdev_priv(netdev);
> > +	struct mlx5_core_dev *mdev = priv->mdev;
> > +	struct mlx5e_params new_params;
> > +
> > +	if (enable) {
> > +		if (!mlx5_data_direct_supported(mdev) ||
> > +		    !MLX5_CAP_GEN(mdev, crossing_vhca_mkey)) {
> > +			netdev_err(netdev, "data_direct is not supported by the device\n");
> > +			return -EOPNOTSUPP;
> > +		}
> > +
> > +		if (!MLX5_CAP_GEN(mdev, shampo)) {
> > +			netdev_err(netdev, "data_direct requires SHAMPO (Header-Data Split) support\n");
> > +			return -EOPNOTSUPP;
> > +		}
> > +
> > +		if (!mlx5_data_direct_get_dev(mdev->data_direct)) {
> > +			netdev_err(netdev, "data_direct device not bound\n");
> > +			return -ENODEV;
> > +		}
> > +	}
> > +
> > +	/* Changing the flag reopens the channels with a different DMA device,
> > +	 * which would break any dmabuf currently bound to this netdev.
> > +	 */
> > +	if (netdev_has_dmabuf_binding(netdev, NULL)) {
> > +		netdev_err(netdev, "Can't change data_direct while dmabufs are bound\n");
> > +		return -EBUSY;
> > +	}
> > +
> > +	new_params = priv->channels.params;
> > +	MLX5E_SET_PFLAG(&new_params, MLX5E_PFLAG_DATA_DIRECT, enable);
> > +
> > +	return mlx5e_safe_switch_params(priv, &new_params, NULL, NULL, true);
> >  }
> 
> [Severity: High]
> This ethtool callback explicitly acknowledges that reopening channels with a
> different DMA device breaks dmabuf bindings. However, does the unbind notifier
> in mlx5e_data_direct_event() omit this safety check?
> 
Safety check is not useful in mlx5e_data_direct_event(). It uses the
private flag state to trigger the channel recreation.

> Looking at mlx5e_data_direct_event() in
> drivers/net/ethernet/mellanox/mlx5/core/en_main.c:
> 
> 	new_params = priv->channels.params;
> 	MLX5E_SET_PFLAG(&new_params, MLX5E_PFLAG_DATA_DIRECT, false);
> 
> 	mlx5e_safe_switch_params(priv, &new_params, NULL, NULL, true);
> 
> 	netdev_info(priv->netdev,
> 		    "data_direct device unbound, disabled data_direct\n");
> 
> The notifier forcefully reopens the channels without checking for or revoking
> active dmabuf bindings. The channels are reopened using the netdev's primary
> DMA device, but the dmabufs remain mapped for the removed data_direct GPU,
> which could cause IOMMU faults.
> 
Once revoke support is added in dmabuf, it will be triggered from here.

> Additionally, what happens if the channel switch in the notifier fails?
>
> The return value of mlx5e_safe_switch_params() is ignored. If it fails
> (e.g., due to ENOMEM), the old channels might continue running with the old
> parameters, actively issuing DMA requests to the unbound and
> soon-to-be-freed data_direct device, potentially leading to a
> use-after-free and DMA corruption.
> 
Responded in another commit: if channel switch fails, there is no way to
go back and trigger an unbind.

> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20261008132815.654147-1-tariqt@nvidia.com?part=10
