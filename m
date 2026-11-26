Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.201.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795719689;
	b=F8MGqW4rjN2yHjDy6Ccvpb/aqemKxgBaUTRj1KqlHA9XL+0I7IK7IXfvYiWKfCk9b8qS
	 HsmmpfJOVF0x8O09EuGMjCzrKb3pnM6frGvnQ7TchVduWxiXrG/jjC8iypGmlerCMyU8j
	 4cGx4UPHAQ0xXpCD95ze9v7dqewbfqanSLMGcPEuLt545ZER2GLrr2ncOYDIrwgnrj5ze
	 DyEnzd0hYQCj3W4pcex+br1PgcRXn9HqWothKSIxqllW+A+EUZLSkIArjxpO4fAd6x7Ll
	 frHBB8wnpYlu2GABot0Vnqog1I8IlEe6TdmwWqwFMkm490dQlSYZpRBuoonOIfKx90g==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795719689;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:Received:
	 Received:Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To:X-Originating-IP:
	 X-ClientProxiedBy:X-EOPAttributedMessage:X-MS-PublicTrafficType:
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
	bh=d3mzaYdM0jbcpbNwH7ckitTJscPG4udH4PCcM2YF3xw=;
	b=GjpXnBQyjszw/AXb8+qLsjoKbtcHLrvg43TWM+rjB/5stEEXicKskjGmVtIvXufkSj4R
	 Bthqjg0/ydFLUzC5qi86T+WLkEmWTMPNVQviey5WTAhky9VP+9dN9E6HTh11lw71OTPtc
	 dmP+ovMJ6xSwAemq4vjD+zFLwIKRWKkztJNn6pR4RVIBhMnr3qeGMzatKEuYP2Mthf6/k
	 85YrFoX+EoktcoyfdyTKgS9R3crV+tEiaGnWha05wsV+vnJHX5PmxgDMHkqhRMfPIzKg8
	 oOZnj6kfno7frq8XzzodyUXFiNeNV7wx4HG1KljFgZp/GfSE4hkEzCNDthzWGPw9UxA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=X4m++H6a;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.201.18
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013018.outbound.protection.outlook.com [40.107.201.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 060B5606A31E;
	Thu, 26 Nov 2026 19:01:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 060B5606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=X4m++H6a
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QQzqhQHqooL61KPF3ILD46ucrVc0w3P2XdrNH0Zecs/LWrGHlrQEK4sHX/nm9XyvIIHCpywWHoohifd66aaPrLu1aHr/O1fKpooKPZE83FhOyufeQPYGkXEPc94OkTLtQl90j7K0OXwslHaVB/th5nn0zqXL51O5o5S1ejkYpRSewnqUqLwpsajbVSq7jAi23RuhC0huLrPbgCOnf4IUGB0ZjFC6F6Bqy5/PTFebrvkFrlhLZB5TlJg+8USNTVx2pVb2OENDvJ5FfNK9ITgRxK11mS20I12PZJchAH0bRWrH50FqGzQex0WfvQs2G06TxIiDaA9ylkjFevsO0ZAMLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d3mzaYdM0jbcpbNwH7ckitTJscPG4udH4PCcM2YF3xw=;
 b=HSS+FTHn57dMEu34TKUKhcYRGV1zbnHyB1irHdM4g+pWOhkeJYq5DTQOvagzkJVl9x73Epn/RNJbOi7ehLWUtwQxS9LBvPieqwMH2U//Aezvo50T6WIYMVst5znOw7cDWrn02EULCVYyDjoJf/Fush6DH5Qb/DsxCLm+6uMAed6Af1HT0bdxV/biMVcRmUTWbHXeR9SxMnDEy2wZ85+9o13Thamy/H6kg2sRSJlvgfh2O5B0QvHH0TAFI62Cqydj9W1GCNhXiRKFKiSZUPG9OC7lmebZTlypZOfZQgLCmFTYx2vNsWjc35k1zvObhMgFyaCVdM0M0Xtlq8qxwXgoIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d3mzaYdM0jbcpbNwH7ckitTJscPG4udH4PCcM2YF3xw=;
 b=X4m++H6aE5CpKhobp6HPZtwMxXetgfTR6LGH/Fuv9hXtT5D0kZaysSWsgySfRSVZh7Fxrvli1GwDlPY2tKO0QR8/csAzHgOA7lUwVVftyjYr4VwtzJrh5Kfc273yK5BmQEHwF4gkN2Ng8/vN7HSx5R2+BRJD0yTTSUZqmkuvw3fXcesGbgdo39F5qZwl5SEOMVJkgiML4Bbib90zx0TLWn4GOhkwWhLUKNr+uwl3m4YIBG+Dcj35i5e96XW9QcwM4RSfKBHNWOmr9sQVC1JWdEMyToIfb2+iTFluIwYcbnZuKtRqpJ8o7kcVeVaRQe+3ZkiS3wtOO+RxUkxXsW2pBA==
Received: from SJ0PR03CA0134.namprd03.prod.outlook.com (2603:10b6:a03:33c::19)
 by IA1PR12MB8224.namprd12.prod.outlook.com (2603:10b6:208:3f9::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.662.7; Thu, 26 Nov
 2026 19:01:23 +0000
Received: from BY1PEPF00026966.namprd05.prod.outlook.com
 (2603:10b6:a03:33c:cafe::38) by SJ0PR03CA0134.outlook.office365.com
 (2603:10b6:a03:33c::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.14 via Frontend Transport; Thu,
 26 Nov 2026 19:01:22 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.160) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BY1PEPF00026966.mail.protection.outlook.com (10.167.244.150) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.688.5 via Frontend Transport; Thu, 26 Nov 2026 19:01:22 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Thu, 26 Nov
 2026 11:00:56 -0800
Received: from localhost (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Thu, 26 Nov
 2026 11:00:55 -0800
Date: Thu, 26 Nov 2026 21:00:51 +0200
From: Leon Romanovsky <leonro@nvidia.com>
To: "Bin Luo (University of Electronic Science and Technology of China)"
	<luob87709@gmail.com>
CC: <jgg@nvidia.com>, <linux-rdma@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] IB/ipoib: re-lookup mcast and pin ah across lock drop in
 ipoib_mcast_send()
Message-ID: <20261126190051.GX774860@unreal>
References: <20261126065125.1082-1-luob87709@gmail.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20261126065125.1082-1-luob87709@gmail.com>
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY1PEPF00026966:EE_|IA1PR12MB8224:EE_
X-MS-Office365-Filtering-Correlation-Id: 1391cd0d-4694-4fbe-3f87-08df4befa974
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|23010399003|36860700016|82310400026|261009223027099003|10067099003|56012099006|11063799006|261021135927099003|261021123027099003|261021121427099003|261026121527099003|261022105027099003|261026140227099003|261102123227099003|261028144727099003|261022075727099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	TrUPP3/8vlbwrqKT0SKVz1x6sXUG5lxcjGwx/AZULWFEXKi7zt25rDzn7uSQL+PHgpuOun91wXB7m5UeXcsTDQuKCGkrOHakjMJoqcZkgJAi6OAiba9WmGLNhY0mRY0qTR5W2jm4enBUG+2AuO1XcuUEpnInlxpB5lwAarPDsDyqAQOuDthd9JryHGMbM5G2wq/5xh+W7we0OPmGihwJaNv6gpU/BwUUZSUnFORj44prLBUcnhExCkslJ0AtUlw5zknP42ZwSVmKcfEiUYoYzECxGkwLatDVDvyRF64nLahUA7vAegv6qDg7x3t6Re7CVqfRRjDRJRnBPOIHx4Is1XMMVXg2uEvPzJR+fSYIF12PNXtwgSkIgyS86bD+t/RMO6Mxzm9VBCw6aaMJGEdXV4Pw6JDnscisix59Kj9n5kqvjqf6rsPjf0iIo+pNluB+zqyvQ0pxZXkSY8AyT3cQZFMHT3sWHbXq8ZAa0Pa0l+Y4g9HbnQ0glIl/ZmtZEtpeHudLj7dj21D5SWozh+oP2MFnTtRfb9AwMCWxtHFTIfFnK7DzULtbnFBfYA7ajolsGZYXO1f9I7v5ZpcgeAwtWBJuGdN3OGMYT3Y5h97wyYDZVrWXvKe4pPrMYaE++dVrpqY/kKTNO7YWSeDyhqA8+JsY62bDGJX2a7MkUDmYXtz3IQYKCP1THzg4e/IhXmA5ZTpTQ2OBNcEfUycdIvE7hQ==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(376014)(23010399003)(36860700016)(82310400026)(261009223027099003)(10067099003)(56012099006)(11063799006)(261021135927099003)(261021123027099003)(261021121427099003)(261026121527099003)(261022105027099003)(261026140227099003)(261102123227099003)(261028144727099003)(261022075727099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	GBmDp5BxPZCMGm4xw+28XJvScZCOBMVl+N+Gm+L08rFAULbLxKWZ+TnPmplgPZLtr3r7421tgtWelwt2BpovYOHyo2l8f3NR3iUYxXfHEa7hR1AFOSeSEwv89lRYWb52caMUyEVjkN7gTNEPu0ZWM6/ML52r2h2TFwdPStcOUFBtn9IxTJJslvL+lz3HVu+Nt2BODRLN3v3nvfesdSpGzCIzeZwPA3+jqVmVvX6O8lxgUWJd7CngD1vT7Oqm7Wwye831X00UlgemRDYZNiaYGPG2XXCuZ7ILbVMcx3XbiDWZd0ig3n9wrqC4RtsxVztpW6/6ETclvvlx3rq/YVeOviJ1WhhF1eaToMrPCRnpTOYZRvSirLQ2yA7zNlEVpenHySRE9i7l5Jp774N28Peu++XDGhLy9+pVht9YYC0AgbKsXR095j03mJpXUrUd52tQ
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2026 19:01:22.1542
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1391cd0d-4694-4fbe-3f87-08df4befa974
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BY1PEPF00026966.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8224

On Thu, Nov 26, 2026 at 02:51:25PM +0800, Bin Luo (University of Electronic Science and Technology of China) wrote:
> In ipoib_mcast_send(), priv->lock is dropped around ipoib_neigh_get()
> and reacquired without re-validating mcast. During that window,
> ipoib_mcast_dev_flush() can unlink mcast from priv->multicast_list and
> priv->multicast_tree, and ipoib_mcast_free() can run
> ipoib_del_neighs_by_gid() and ipoib_put_ah(mcast->ah) before blocking
> on netif_tx_lock_bh().
> 
> When ipoib_mcast_send() reacquires priv->lock, it can attach a newly
> allocated neigh onto the dying mcast->neigh_list (leaving a dangling
> list pointer once ipoib_mcast_free() calls kfree(mcast)) and access
> mcast->ah after its reference was dropped. Furthermore, mcast->ah is
> dereferenced after priv->lock is released without holding a dedicated
> reference when neigh allocation fails.
> 
> Re-lookup mcast with __ipoib_mcast_find() after reacquiring priv->lock,
> drop the skb if mcast or mcast->ah is gone, and take a reference on ah
> under priv->lock across rn->send().
> 
> Fixes: b63b70d87741 ("IPoIB: Use a private hash table for path lookup in xmit path")
> Signed-off-by: Bin Luo (University of Electronic Science and Technology of China) <luob87709@gmail.com>
> ---
> Found by code inspection. Compile-tested on x86_64 with W=1 and KASAN (drivers/infiniband/ulp/ipoib/ipoib_multicast.o); not runtime-tested on InfiniBand hardware.

To exercise the KASAN paths, you need to run the code. Are you saying the code
has not been tested at all?

Thanks

> 
>  .../infiniband/ulp/ipoib/ipoib_multicast.c    | 21 +++++++++++++++----
>  1 file changed, 17 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
> index 379b783..81393a2 100644
> --- a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
> +++ b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
> @@ -792,25 +792,38 @@ void ipoib_mcast_send(struct net_device *dev, u8 *daddr, struct sk_buff *skb)
>  		}
>  	} else {
>  		struct ipoib_neigh *neigh;
> +		struct ipoib_ah *ah;
>  
>  		spin_unlock_irqrestore(&priv->lock, flags);
>  		neigh = ipoib_neigh_get(dev, daddr);
>  		spin_lock_irqsave(&priv->lock, flags);
> +		mcast = __ipoib_mcast_find(dev, mgid);
> +		if (!mcast || !mcast->ah) {
> +			++dev->stats.tx_dropped;
> +			dev_kfree_skb_any(skb);
> +			spin_unlock_irqrestore(&priv->lock, flags);
> +			if (neigh)
> +				ipoib_neigh_put(neigh);
> +			return;
> +		}
> +		ah = mcast->ah;
> +		kref_get(&ah->ref);
>  		if (!neigh) {
>  			neigh = ipoib_neigh_alloc(daddr, dev);
>  			/* Make sure that the neigh will be added only
>  			 * once to mcast list.
>  			 */
>  			if (neigh && list_empty(&neigh->list)) {
> -				kref_get(&mcast->ah->ref);
> -				neigh->ah	= mcast->ah;
> +				kref_get(&ah->ref);
> +				neigh->ah	= ah;
>  				neigh->ah->valid = 1;
>  				list_add_tail(&neigh->list, &mcast->neigh_list);
>  			}
>  		}
>  		spin_unlock_irqrestore(&priv->lock, flags);
> -		mcast->ah->last_send = rn->send(dev, skb, mcast->ah->ah,
> -						IB_MULTICAST_QPN);
> +		ah->last_send = rn->send(dev, skb, ah->ah,
> +					 IB_MULTICAST_QPN);
> +		ipoib_put_ah(ah);
>  		if (neigh)
>  			ipoib_neigh_put(neigh);
>  		return;
> -- 
> 2.43.0
> 
> 
