Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.43.27
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795078729;
	b=Bu6ZNGRoTtIgq0t3sVwMZ6f8pqPqKuX5yGCI9S+gQnhKJgkD0JAg/gFrBbUNKlMSLLRl
	 0PyL08B0aoKJCNhieU4hYagZTvdB7S8To6gD9jmCzM6cQygeBLsWz3h35NKBL/6tBj9k6
	 qKBdDKSd5yEsmjbclpQCf8p3ChPGZn4zYW3q9XwEUfH6yO32tFyjBl9FSUzFvL6mHIeyE
	 gu4nheeUmu6taONs/DTsfuAx8AIgeKnhAfJ46hAvCT3tdYdxttEOLIylBAnACopqL3Gio
	 Oho0czMWmrNM2XRpM+QREJ2+C/IwfBAFcIE0ULN3tMUeqOZi375DyTgVglugY4dWvew==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795078729;
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
	bh=tORVYygeegvwgcS7dBzakpDxbWbrEdsVOxg9tjxWrYk=;
	b=dZ3ftIGN8o4GpDGFG0vcptnYjr9CAZeMAgneQSOVTkHlT3KtEnmLteJryupwvwKvTwek
	 Mewa3QfMQrp6d77VdRUiPks6zWhUJhnAw5rmeAuRQXWTaUB+AbLM7BXCIjOlEBSMmQ8HG
	 DCdNZYe8kndGM1/DcwL6ARXt49Vr+FBc97ak8pVUhlrdXtlKl15aFU4zsipEeHX95wWPt
	 5zwyjkpVO/HIIR/Gh5gBMliIH9WOqQ7fIfzL3uZFMM4mU3aiLrELAAFKlGy3QE1rbxs3A
	 +jF7voEGL1MHJutSvUz5e+NfE/OLdzdgDO4VH8fNk088FPmMgVk5EWi8qxiQ8Dj875g==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b="TuxK/dOV";
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.43.27
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012027.outbound.protection.outlook.com [52.101.43.27])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D593606A320;
	Thu, 19 Nov 2026 08:58:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0D593606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=TuxK/dOV
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=f/U99hAq8ZiGOArDq5Ix6iG7SUTj/dhdfM2q7RQkO89Ax9edsjs9l7GyRkKT2+XPI4suw4FVG86FvvcchvZOYx9R+U8e2fkr3/hwr9JVlZYN3fkgYK1qPC8PPA0E1OjSGUFZp2zjtt6325+UXAQ1cXHDZNFyxNNpIAfwrQXJksRgnppRcBP+8uuEV8BzoRYPAgr/WqtiRgCCaP9v1xnhrqHC1NvLRB1KgHbY91ITXGEKRkGCXhXXZkV8wPOpLzORyrzxsgVRB8Y7yxnPuMHy+6nds8cKb7f+FF2x6tR+UPUQNJ+kaW6Be++1jGgxBkyuyT9kej+5B4Jx0bxx1FPUWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tORVYygeegvwgcS7dBzakpDxbWbrEdsVOxg9tjxWrYk=;
 b=sv0x4qhD6I006BQNM5CMmox1p5fZr56sGyGq1tJrNW7cNsPzaXFHVCit86ffVOJknPWivB1nGkR1EoTH1FaTzOfc3rYMeST9X/fuqUXey7conz8LRXGyGqYlDppTt1hfR0f/6qlpGzXeBec0kRR4XwyzugOgI1sV78wX6HzvbhvpjsWPb4s9U5ImczNiOAIBIRKUMibQNmsGbcNqrpqNGNdOl7E7TYs/hxWUhi/LZuQVLQtsvtgpeBAfjQ/6w02jULdEWBMgVKzF1xI39dFoCVxcwY4cWdRqx3OPMFUW3LTvJnND9Ut2OdXb0AmLWXDAFk0a6pI0UNkccSNBsHB/ZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tORVYygeegvwgcS7dBzakpDxbWbrEdsVOxg9tjxWrYk=;
 b=TuxK/dOVc2O3FOKx+mt7LsJH/5r803b/+U5oa+xaDziNY3LS7sKiLwrslIV16dig2JLKx44krXWvWcBxeWI2yhTA7anf7uminfJ72ZLUNOlX5LvyYR3T/EH3pEDS13wg4qW2Wvp9bEmfJ9I/AjNWImJXAZhul4fX9NE33OAQbipfzmcAQe/iC1v9MBYDXvgwgw3oAG5oxPD6Jzu6b3l2p04fIVQU4v4PTqpTxeEQ1k00zhipoI4c/7wtSXKabxplBRJEAJwVGxZbuVLEBV5kMeL/eeuTCcTXZCS6k9vuAlEVKmS3ZqtU0QS8VoV40bg9zNoWhza7F7uK08wzwKULeA==
Received: from SJ0PR13CA0002.namprd13.prod.outlook.com (2603:10b6:a03:2c0::7)
 by DS4PR12MB9820.namprd12.prod.outlook.com (2603:10b6:8:2a7::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.12; Thu, 19 Nov
 2026 08:58:44 +0000
Received: from CO1PEPF00018866.namprd03.prod.outlook.com
 (2603:10b6:a03:2c0:cafe::19) by SJ0PR13CA0002.outlook.office365.com
 (2603:10b6:a03:2c0::7) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.639.8 via Frontend Transport; Thu, 19
 Nov 2026 08:58:44 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.161) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CO1PEPF00018866.mail.protection.outlook.com (10.167.249.150) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.639.5 via Frontend Transport; Thu, 19 Nov 2026 08:58:43 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Thu, 19 Nov
 2026 00:58:26 -0800
Received: from nps-server-23.mtl.nbulabs.nvidia.com (10.126.230.37) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.57; Thu, 19 Nov 2026 00:58:21 -0800
From: Shay Drory <shayd@nvidia.com>
To: <netdev-bot+sashiko@kernel.org>
CC: <tariqt@nvidia.com>, <andrew+netdev@lunn.ch>, <davem@davemloft.net>,
	<edumazet@kernel.org>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
	<pabeni@redhat.com>, <cjubran@nvidia.com>, <cratiu@nvidia.com>,
	<gal@nvidia.com>, <leon@kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-rdma@vger.kernel.org>, <mbloch@nvidia.com>, <moshe@nvidia.com>,
	<ohartoov@nvidia.com>, <phaddad@nvidia.com>, <saeedm@nvidia.com>,
	<udar@nvidia.com>
Subject: Re: [PATCH net-next V2 10/10] net/mlx5: LAG, do not add a device to an already-active virt LAG
Date: Thu, 19 Nov 2026 10:58:13 +0200
Message-ID: <20261119085813.1591422-1-shayd@nvidia.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <179499792089.3136.10061962693179545978@kernel.org>
References: <20261116103010.1129666-1-tariqt@nvidia.com> <20261116103010.1129666-11-tariqt@nvidia.com> <179499792089.3136.10061962693179545978@kernel.org>
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
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF00018866:EE_|DS4PR12MB9820:EE_
X-MS-Office365-Filtering-Correlation-Id: cfd510fa-185d-41a4-d2e8-08df461b5093
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|36860700016|1800799024|23010399003|82310400026|10067099003|11063799006|5023799004|4143699003|56012099006|261021121427099003|261009223027099003|261102123227099003|261022105027099003|261022075727099003|261026140227099003|261026121527099003|261028144727099003|18002099003|22082099003|6133799003|13003099007;
X-Microsoft-Antispam-Message-Info:
	4tkFVr0PO2pF5yScccfhNcccchXhqwr4AdWHl98jSggBB1srN8VU8ZcRk1HA/ZDqgI/f4AHou0dRawmEQLdZaTeWT4Ew/UcVEdmpgc9W4hgXC+rWnjqH7AE6Ntc+4yCxwu5f8/Ax1rrDhKKNTwnAQfoGA3dfYQ40uBUeh/b1awjgO2cGcENJf9eueJS8oZdiX/12fgDUDog7l9CYewse/wBpJn0ToENgrgGHPLEx77spQzsoKxA4V8riyLDevur6Lp/qEZUX5TmPa1BlQqeWpAczGmFHjG987xGt5ygXB3Lu3jSijS9nu1UD6HHDZA6eEaXrPBb0KqtjoW/DhlgsaNxY0SszyqsRIQp9Rwuij+/sczkT/EDMEBZKD9ZTjbao5OtzJIUGu8OJp5r4/Pz4U6KRqn9vJKls0W3TDRXiCenuV0bUoEuO7kZ/dCyCwp9HPDhs8bnNSfLRer7Enxyol9ZRwTyX5oL065YfAs0Pe2ADjpLG6h4ctAMNeW6N+ESPRGQhrvvO8Ce6RFJ4Pk1c9EGAZU2RhkUSn5nq3lndNkmpQBFDc1JAp1NFaHkczVN+iqX5JG2h6iEdXptZVZ/Q7eGNdh7luPxDYCfOCdDoVrfQej69zruSDqh1dsVfGiML9ZB2eI3Rom1vUZqwPlgbK4etqOOblx96wBrUTAxTP4rfAoiZ02oqQVTup5Fztd9QGjJ6DrWA0RgJapaV0FTYmQ==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(7416014)(36860700016)(1800799024)(23010399003)(82310400026)(10067099003)(11063799006)(5023799004)(4143699003)(56012099006)(261021121427099003)(261009223027099003)(261102123227099003)(261022105027099003)(261022075727099003)(261026140227099003)(261026121527099003)(261028144727099003)(18002099003)(22082099003)(6133799003)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	yaSLsEEJt0elhuZY+z4w4fIFtzu6uNrrvhMBAkdfXdMarLByDiHc4GVDPXp3NdmgeXtxQ2NZh0zSTYUIrzu/98QbDY42OV5Jg83ZjUt7QuTjaB5PPNnCE3GfcoEVy0noFrMOy5fRU+0I1kl4M6xBANAFqIBXDcZqfQv0DapRCTtQ2vnOlT4s5JBRwHfFKJRLjhg4pAoo45NSIUoNTUI3gyoDUPKcFgWYlCKyGcRHn/VXx8uM2lMaW1f7r50hBrmwF2MIKBfn10Ixw1mrtZpBjHPZGLOrAdtKiAfocBUYbHjYT5qvqYXmsduWFvn6SDd4i/mlRcZ6pIyWmxzUxTb6hZxG7rXe84pIGK0oGCG51VpvlMacviTHjYyKby2SUoSnWONfP1N6u8Rs3Jdta6hk1dutaN4565cN3SoZwsQBM4+CANzHa/O7nElBLHQSNevW
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2026 08:58:43.8765
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cfd510fa-185d-41a4-d2e8-08df461b5093
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF00018866.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PR12MB9820

On Wed, 18 Nov 2026 10:32:00 +0000, netdev-bot+sashiko@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential
> issue(s) to consider.
>
> Critical: 0 · High: 0 (1) · Medium: 1 · Low: 0
>
> If you believe none of the issues are legitimate, please reply to each
> issue of Medium severity or higher and explain why the AI is wrong.
> If any of them are legitimate and you plan to respin, please let patchwork
> know by including "pw-bot: cr" as a separate line at the end of your reply
> (one such reply per series is enough).
>
> - [Medium] In this tree, both parts of the patch hit a predicate
>   mismatch.
>
> Pre-existing issues:
> - [High] This problem wasn't introduced by this patch, but the patch now
>   cleans up the HCA devcom component on its own new -EOPNOTSUPP path…
>
> --
>
> net/mlx5: LAG, do not add a device to an already-active virt LAG
>
> This patch stops a virt LAG capable function from joining a LAG whose mode
> is already active. In that case __mlx5_lag_dev_add_mdev() returns
> -EOPNOTSUPP, and mlx5_lag_add_mdev() then unregisters the HCA devcom
> component. The patch also makes mlx5_esw_offloads_devcom_init() skip eswitch
> devcom registration for a non-PF virt LAG capable function that has no ldev.
>
> > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
> > index 3e88b3f51612e..abcab76fced0b 100644
> > --- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
> > +++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
> > @@ -2448,6 +2448,11 @@ static int __mlx5_lag_dev_add_mdev(struct mlx5_core_dev *dev)
> >  		mutex_unlock(&ldev->lock);
> >  		return -EAGAIN;
> >  	}
> > +
> > +	if (mlx5_virt_lag_is_supported(dev) && __mlx5_lag_is_active(ldev)) {
> > +		mutex_unlock(&ldev->lock);
> > +		return -EOPNOTSUPP;
> > +	}
>
> [Severity: Medium]
>
> Can this condition ever be true in this tree?
>
> mlx5_lag_add_mdev() is the only caller of __mlx5_lag_dev_add_mdev(). It
> returns early unless mlx5_lag_is_supported() passes:
>
> mlx5_lag_add_mdev() {
> 	if (!mlx5_lag_is_supported(dev))
> 		return;
> 	...
> }
>
> mlx5_lag_is_supported() requires num_lag_ports >= 2:
>
> 	if (!MLX5_CAP_GEN(dev, vport_group_manager) ||
> 	    !MLX5_CAP_GEN(dev, lag_master) ||
> 	    MLX5_CAP_GEN(dev, num_lag_ports) < 2 ||
> 	...
>
> mlx5_virt_lag_is_supported(), on the other hand, requires
> num_lag_ports < 2:
>
> 	if (!MLX5_CAP_GEN(dev, multi_uplink_eswitch) ||
> 	    !MLX5_CAP_GEN(dev, lag_master) ||
> 	    MLX5_CAP_GEN(dev, num_lag_ports) >= 2)
> 		return false;
>
> No device can satisfy both, so this -EOPNOTSUPP return and the new cleanup
> branch in mlx5_lag_add_mdev() look unreachable.
>
> The commit message says:
>
>   "mlx5_ldev_add_mdev() would add a newly probed device to the LAG even
>   when the LAG is already active"
>
> Can that happen today for a virt LAG capable function? If this check only
> prepares for a later series that enables virt LAG, could the commit message
> say so?

No, not in this series, and that is intended. As the cover letter says,
this series only prepares the LAG core. The follow-up series admits virt
LAG capable functions in mlx5_lag_add_mdev(), and only then can the check
fire.

> The same mismatch seems to affect the eswitch change. A non-PF virt LAG
> capable function never reaches mlx5_ldev_add_mdev() here, because
> sd_lag_init() only handles PF SD secondaries. So dev->priv.lag stays NULL
> for it, and mlx5_virt_lag_nonmember() is always true:
>
> static inline bool mlx5_virt_lag_nonmember(struct mlx5_core_dev *dev)
> {
> 	return mlx5_virt_lag_is_supported(dev) && !mlx5_lag_dev(dev);
> }
>
> As a result, the new early return in mlx5_esw_offloads_devcom_init() fires
> for every such VF/SF eswitch:
>
> 	if (!mlx5_core_is_pf(esw->dev) && mlx5_virt_lag_nonmember(esw->dev))
> 		return;
>
> Before this patch, a VF/SF eswitch with merged_eswitch would register
> MLX5_DEVCOM_ESW_OFFLOADS and send ESW_OFFLOADS_DEVCOM_PAIR. The existing
> MLX5_VPORT_MANAGER() / !mlx5_lag_is_supported() gate further down does not
> stop a non-PF, because MLX5_VPORT_MANAGER() requires mlx5_core_is_pf().
>
> Does this drop eswitch devcom pairing for those VF/SF eswitches? That would
> contradict "it is a no-op for existing configurations".

No existing VF/SF passes mlx5_virt_lag_is_supported(). New FW will allow
a VF/SF to report multi_uplink_eswitch and lag_master with
num_lag_ports < 2, so the skip changes nothing for existing
configurations.

For such a VF/SF, skipping the pairing outside a LAG is intended. It
manages its own nested E-switch, and it pairs with other E-switches only
as a member of the virt LAG's shared FDB.

> The commit message also limits the devcom change to "such a device", meaning
> one rejected from an active LAG. The condition, however, matches any virt LAG
> capable VF/SF that has no ldev.
>
> Once virt LAG joins are allowed, devices that are left out because
> mlx5_lag_dev_alloc(), mlx5_ldev_add_mdev() or
> mlx5_lag_register_hca_devcom_comp() failed would also be treated as
> non-members. Is that intended?

Yes. Whatever the reason the device was left out, it is not a LAG member,
so it must not pair with the LAG members' E-switches.

> >  	mlx5_ldev_get(ldev);
> >  	err = mlx5_ldev_add_mdev(ldev, dev, 0);
> >  	if (err) {
> > @@ -2536,6 +2541,10 @@ void mlx5_lag_add_mdev(struct mlx5_core_dev *dev)
> >  	err = __mlx5_lag_dev_add_mdev(dev);
> >  	mlx5_devcom_comp_unlock(dev->priv.hca_devcom_comp);
> >
> > +	if (err == -EOPNOTSUPP) {
> > +		mlx5_lag_unregister_hca_devcom_comp(dev);
> > +		return;
> > +	}
>
> [Severity: High]
>
> This isn't a bug introduced by this patch, but this new path unregisters the
> HCA devcom component, while the nearby failure paths in
> __mlx5_lag_dev_add_mdev() still leave it registered.
>
> If no peer ldev exists and mlx5_lag_dev_alloc() or mlx5_ldev_add_mdev()
> fails, __mlx5_lag_dev_add_mdev() returns 0 with dev->priv.lag still NULL:
>
> 	if (!ldev) {
> 		ldev = mlx5_lag_dev_alloc(dev);
> 		if (!ldev) {
> 			mlx5_core_err(dev, "Failed to alloc lag dev\n");
> 			return 0;
> 		}
> 		err = mlx5_ldev_add_mdev(ldev, dev, 0);
> 		if (err) {
> 			mlx5_core_err(dev, "Failed to add mdev to lag dev\n");
> 			mlx5_ldev_put(ldev);
> 			return 0;
> 		}
> 		return 0;
> 	}
>
> mlx5_lag_add_mdev() treats that as success, sends LAG_DEVCOM_PAIR and keeps
> dev->priv.hca_devcom_comp. On teardown, mlx5_lag_remove_mdev() returns
> before it reaches mlx5_lag_unregister_hca_devcom_comp():
>
> 	ldev = mlx5_lag_dev(dev);
> 	if (!ldev)
> 		return;
>
> The comp_dev's data still points at this mlx5_core_dev. Does that comp_dev
> stay on the shared component list after the core dev is freed?
>
> If so, a peer with the same key that probes or reloads would get the freed
> dev back from mlx5_devcom_get_next_peer_data() in __mlx5_lag_dev_add_mdev().
> It would then call mlx5_lag_dev(tmp_dev) on freed memory.
>
> A peer's LAG_DEVCOM_PAIR/UNPAIR event would likewise call
> mlx5_lag_devcom_event() with the freed dev. That reads dev->priv.lag and can
> call mutex_lock() on a garbage ldev.
>
> Could the component also be unregistered on those allocation failure paths?
>
> >  	if (err) {
> >  		msleep(100);
> >  		goto recheck;
>
> [ ... ]
>
> --
> Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261116103010.1129666-1-tariqt%40nvidia.com
