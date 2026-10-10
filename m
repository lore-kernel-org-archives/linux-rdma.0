Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011005.outbound.protection.outlook.com [52.101.52.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 478F749EC45;
	Sat, 10 Oct 2026 13:40:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.52.5
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791639621; cv=fail; b=g9ZiKyr7cgff/iR9QnxZk0nzGvfeqYn0TkVqD4dAwg8Au9xUKcZBJp7wW6f65dsyW9TVqOeQemZeUmYVt3xfTJG7IZi4VAuyTEMblJCs7b3ffoQESOhP4iz9rSzwWj/dGQoOlOctbWwfv9kPG3/tDQj01t2vkMSwLzWqW2CVYbo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791639621; c=relaxed/simple;
	bh=gtDF/58zqa47ZN4CZI+lVdpM9S65dZrVJrPO4TpArAg=;
	h=Date:From:To:Cc:Message-ID:Content-Type:Content-Disposition:
	 MIME-Version; b=m+0OXDUwKNt6qRbmCsnu/m5dz9R3bpJSp5MbBzFyJ+bFeeHvvGYJXjb0RTviwO/InCq/Xpt5iCtuRSXJwN6yPfuj0F5KRMthNaVgbuhNV6baY2eAq8ChnvAtI+KpkvYZL6NFw2UQ9TipYiOUkMJAxgCH2EbXRyGmvugSUpXkNCY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=fail (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=fail (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=L+nC/mgs reason="signature verification failed"; arc=fail smtp.client-ip=52.101.52.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="L+nC/mgs"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qlXJ+lA2y/8kJRGHARZPmW36Snc778xQEcLo2hBbdQidw0fHjnrgUio9/FPbfoT7wjYieRMQubhZeVXBzA0MuMZ9Nf5b6LYwydLVCkuOojHGKASm/3G1l3bEEi1IvYpY4iZT2pHgs43q6vZBL4niYNECc4OgnktFquI6jEL5CvUjEqO5wcWCt/DueeecbhlrAYrbVN+l6GK+yL6iofPT/Ek2C6KC9OqvMZ/NgVdF050FUCEPfcT90xg/CFJb2FqWR2KUg1ARvw9Zd/7iO3Zg3DbsxErL134ipgGCpAHhYMpbOhlg1r/BwkB9aUmmDsZQT+HEw2/9v5S+KRlAGoK4Sg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rwOd5hyrhb/VV/BkrD8//bf/ZpIuV1fMz+PtxCCsxfs=;
 b=RFrLFH6fhW1fQZFC2bEf7xPVOuV16KdQdy2Wyb7gscXwy2Vh+74Yq0PK6ZDBxgz/P48+cfECM0Ws8mU801oa8vG+RCOBHtVsQqxWuaGfsJFcKba6I82FFUu0h16+DWCuQynrz1q0GjIkcgHXS6Aif+WKxPs8fKdAdXvdDfk8hnQeiCDnPw2wZG+KYCMy/TgWtomhTmpSceFda6RbS5JAn/LgSogqBcC7yN9Zgaw9LS+V9RyjnzZGjZRsCKF7HE1bWjRiNgT6ryajI7yE3iuMKd8gkmYz5dh+T3wlFPulZhdZrm7yrnhhpdMajdb9RIvrwYKcK8M2F1yQBn0hiv52kw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rwOd5hyrhb/VV/BkrD8//bf/ZpIuV1fMz+PtxCCsxfs=;
 b=L+nC/mgsBwojcEp34jHQKn0nEhXz0iUnaHG2jskzxuPphwYCK9pJg+wgmOp1j5szCyhQ9GC2j7LOn7vDFK4wUgzJKPwl1Y8MN6OqKoVVBrb99O4Fx34OfoyZa8u6cfNYFdpBC56z6u2hq2AYDHhxvpXFkcGf7OhoJfbWapnC/3AOmua+R/iDme7BLJZK/lbMOiof5r1ykdqtWZkUmP0nBO9kgdtQamovGEkGUozMowCyaRYtT1DIfMAMGeuQ3qgDaoUdN5RaWm63xSshjpwQfh/3clKQ/4MXrBNPcPsJ5b9w3vzCtW1eUg6erA/1Sl3EZ3wxqRya0vjWmWwmoTVXjA==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH1PR12MB9647.namprd12.prod.outlook.com (2603:10b6:610:2b0::10)
 by CY8PR12MB8338.namprd12.prod.outlook.com (2603:10b6:930:7b::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.15; Sat, 10 Oct
 2026 13:40:10 +0000
Received: from CH1PR12MB9647.namprd12.prod.outlook.com
 ([fe80::228c:766a:191d:77b2]) by CH1PR12MB9647.namprd12.prod.outlook.com
 ([fe80::228c:766a:191d:77b2%3]) with mapi id 15.21.0496.019; Sat, 10 Oct 2026
 13:40:10 +0000
Date: Sat, 10 Oct 2026 13:40:06 +0000
From: Dragos Tatulea <dtatulea@nvidia.com>
To: sashiko-reviews@lists.linux.dev, Tariq Toukan <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org, netdev@vger.kernel.org
Message-ID: <qad7v2jvs5okumdc5u4sikuna7lkkfbgbwumyztzdnugs6ekee@e4fqewnxyznh>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: TL2P290CA0009.ISRP290.PROD.OUTLOOK.COM
 (2603:1096:950:2::10) To CH1PR12MB9647.namprd12.prod.outlook.com
 (2603:10b6:610:2b0::10)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH1PR12MB9647:EE_|CY8PR12MB8338:EE_
X-MS-Office365-Filtering-Correlation-Id: ccbffb0d-e560-450f-afa9-08df26d400c5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|366016|1800799024|6133799003|18002099003|11063799006|10067099003|261009223027099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	Xj2QdpEoDRRDVXlP/BeTrPSZzAbBOAPBmVrE5Vq67DEySL7obkmjW44tGXGPHbGh+STcmNq0ps4BFttI3brKge/yqWYZ8HcS4JSEDGYD8UGSklt6tEBJxZ9MuETS5UvT3fIlDtdIUG1cZq0CiSqtgxTGfplx/2WCNho/J1p0WIq5dqo4gJBSMEv8AhlS5/PIfErtPwJWL+i5DHHVoky6ZuECobYmR0Tdvc4MSugg+2mX/jbLmHD3TeVRBKNHJG2ih5wbN3s4V/OdYT8eWugYrmR+8lPk0U5Vc/SjTeaGbAbMg/LUpUnfSOZAzwyQyH0RAsS53VDpZJbthQ17KxiFJdLDJ1Y/M7fH74OuDmPGaW8xzv7XWm1AIqe5ZoNe1T3cZ55Mw/1aHv9tIKPcN0U6bAh0M+B1aQMxW93JAS6buqJMnrZB33jVWx9OHICV/46xQ4S0qo9sarefDY5yOaOYLiuNE7My5WDg2bSM1L98X4kW2pyE/jP50zMvSt94U0lKFT99oVNFlQtKZzZR0uK9hGA07MgohtWAasqrjKKEj+5vIHFALjZoX053lT8zKdJUgMeoNLYdKLyJAWhXju0DgN9OLuL37oUOu2o+oRlYdK06EJVKtk/yCLHdl+XxMEKnmi/b/I/ts6ZixB+OVJBw/cmIo4oRixrt+dx2whFNnFM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH1PR12MB9647.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(366016)(1800799024)(6133799003)(18002099003)(11063799006)(10067099003)(261009223027099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?iso-8859-1?Q?4W4njP94gU9FsYk2AzmpqUs1kPlo0mC07/Texm3xay4PzMmoZ9YjJjfmtt?=
 =?iso-8859-1?Q?KuxkZ6l+6OFkcsQPu6j/biK6zZp9ykt74I4v6y8pRksMXxARtezk94qg+1?=
 =?iso-8859-1?Q?Op1Fr8LzwE58VlcgSRRcmSKkz2hoYxOqCNMbUdZoOw9XmSEjB1fRkj48n+?=
 =?iso-8859-1?Q?Z2/W5mqEZzsRMJDUdWts9nH2wX2HBaHooHCQJcRSW1yRcVS9S0IEUmgZfX?=
 =?iso-8859-1?Q?xGWAC+H+Z+DOTNWQPm35UZBwC9B7znhVMfCfzXQM4YVpizUbo6aGSfvQ3b?=
 =?iso-8859-1?Q?6e9F1Pt/uWcUflxq7D0getd4VfblqRel/l/2kiedRc2yG8dCZhJxFzUGkj?=
 =?iso-8859-1?Q?uSP5T7niBAB1UfuBq9SMC0pimYYglKqw/YnY5d2+b5FTub5WffSIzbYMRg?=
 =?iso-8859-1?Q?Fk4uoBdnt7+rHoWW+/i+2yQJ2E/F6bSYhlEt3Tz6bgfY7fRVWcICmGb3Ix?=
 =?iso-8859-1?Q?5aDqYb/UEyp5Rn8fMudwiXnZYo+Pw9B4N5/jWESm7atbm3P68CsfzMsb25?=
 =?iso-8859-1?Q?v+tB3bDD+Bc35Ewm0NRoXd1Qr9TPooCeddfaTtZ4/2ZWQ7uyrKrMEUmOSU?=
 =?iso-8859-1?Q?Emgqb+WTPXwVO84XwIvFbyOMChluPPBFyVKaPHeR/bOfGN+lG7UR6Xeoq+?=
 =?iso-8859-1?Q?DFkV2MjiCt9wocQH+/94z+ypmiWoFhWm36sUnHAW4SMLBCZJHfc/43bkg9?=
 =?iso-8859-1?Q?A/c1iGK8g8K3DKzB73TL0CnVeN8ZA6TVzIxqXgKzrU43w5lrkw46Un9J+J?=
 =?iso-8859-1?Q?pqVgpJ/imwlML546u+kA9p6ZuBzZLYJkNEmhIobP9lma5Ns0fAgvklyNCc?=
 =?iso-8859-1?Q?x8PwmTy6+hQBqHTuPHbwDFAnD77aqhL8Pcb95Y3kInlZdpzki+29CwrU6l?=
 =?iso-8859-1?Q?ILqhGZP3/nBAeiyObUKW6A7491qgN/bml6+gbi+h1PdCAUImeHYBgWC6hb?=
 =?iso-8859-1?Q?mpPa38AwNEpBIDjwa8lvriWfDfCc1eJtsTM0g2zLJhi/QxkmjGlo7qnXeX?=
 =?iso-8859-1?Q?R1gdfkqXmgyeKJFbBw2v94WX2uYQ8R1nB9zQZkQlrDnowRB3ZisJvWJjX/?=
 =?iso-8859-1?Q?FE4ZaegiIvPetjQJEhayiT1CMq8XtumDgcnR5Zefwq23YH/7fq+zdu3vJQ?=
 =?iso-8859-1?Q?K7fhWIcpOX3bcoIrNwty+7ORfBBoR5GzZXPws3mQPeYp/oeXWe+9ODr0r6?=
 =?iso-8859-1?Q?QYHQEIIVLmGS0pf4Diil5kry3Jot2t19QUOgnNmym2GBtiA7yvrlQ40TjY?=
 =?iso-8859-1?Q?al2m8PQX2hia4IuwqwIv7PgTsKAG91d8KIKvno+ZWp5ywgPU4GZG41gd8B?=
 =?iso-8859-1?Q?ItDFbtCsrQjngZBVumchZLKDUw3GDIjdjnhd6foITXMUcHFexFj8aeqcQS?=
 =?iso-8859-1?Q?aopufBQJQI+n8rM+7RBNxPPuxISq3ebLCAkuhkB6qocdLXtVZScjs8hRZf?=
 =?iso-8859-1?Q?meKZ8kGfebAyzwRWERVOdejGvLm5d+m7xtnx4KjjU38upTIrADm6uFAPgt?=
 =?iso-8859-1?Q?6Uwcb4exKZ5iOLLpog4Fa9/u1VTFHy5VHmGkbuHQdCOXXCovDrs0TG4FXa?=
 =?iso-8859-1?Q?MwzLYG1Mm4a+/RVEt08BWQolbwROXJ4tdUKNSMK8GzC5ngamtjLbQv1bpZ?=
 =?iso-8859-1?Q?D1k21mfSPxfBIMcpvWFEgEgKzF8gv7ojWyChvTGGbTiwKua+BvzAZSng/r?=
 =?iso-8859-1?Q?sslQXtoK/fSZsjTwD5zXxtCwvJOu9BD+dX3K9PxLjqsQ+Nb/hWUXjmkg/6?=
 =?iso-8859-1?Q?OuoUmDR/hzujHtAY5sdOWt+cgBI4JJ+fWGRCJT9QL4lvKGCA4KRE6seCol?=
 =?iso-8859-1?Q?4quEuRsR4A=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ccbffb0d-e560-450f-afa9-08df26d400c5
X-MS-Exchange-CrossTenant-AuthSource: CH1PR12MB9647.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Oct 2026 13:40:10.0585
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jNQTbDwMbBSPst/isq1bsPPTQKXVtuHrhjTfGl5cyy7zAJTIA65XcEvaszPtSCfQd60hfH8vzuIOh/wRvwLP2g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB8338

dtatulea@nvidia.com
Bcc:
Subject: Re: [PATCH net-next 08/10] net/mlx5e: Recreate netdev channels on
 data direct device unbind
Reply-To:
In-Reply-To: <sashiko-outbox-165642@kernel.org>

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
Yes, because the unbind operation can't be rolled back.

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
