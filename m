Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012005.outbound.protection.outlook.com [40.93.195.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37BC1369207;
	Sat, 10 Oct 2026 13:45:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.5
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791639935; cv=fail; b=FpYFiap9IDT3uC2ddl4bZmcDocnjEq+Oek47WsSLIyEsd9xxZC4miQA4WEds5pl4boO42UMoEqWB5J4MkavMNpsQ8m7vrsZNVHkD+wr9A+IyGZ8cWYYdbUsOMBlM2sXCcZwZfz9blrIH6Ko4tt5FI84rwVxvKGifeX7lLCqHsSk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791639935; c=relaxed/simple;
	bh=7N/oTy6ZhokL21Niq6A/hwqBAVq5U4RCTVYRkJZ3Hjs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=leov8DeIlIeV2NApqHcIDCAf8ORORGkLnU0jsMNo4v+a+rMYVQJvlX5RMhIo28/HhqOwjma7CLb+B73EROkyNwC3ZMtSoOKJAFJ9+EGkdGiXimQNjshxYjLSh2BlhiLC3cesTdNKUj25ItecgWTSDcmwzYcezo1nRAYlG6qDJp0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=fail (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=fail (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=KM1CzHvi reason="signature verification failed"; arc=fail smtp.client-ip=40.93.195.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="KM1CzHvi"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tHp5vMmmxdComu2Cbsa7v8qEDWUVT9Bur+f/n2/Wi/4eTpgeNFAEf2ty4nsbif+F3JNjxvTz5OyhWlztrdhg5dmLzzdNR4EC+MvLMvJ/DZbrKXu9lCDCObQsTmpHj1wANaZoFiTH0SYTpEE8url6IX1CUSIPjRAZHUpzN8bGeceBsLH85HGgXwNf7gGnQH50N+Ktx1a5mQgCW0HaQHYU0/iD2y26cYc3NtOyiOzY3q+24tthMiLkPUlLhVQvi5lEp7REd3yLGB750Urtl3GdGBuPulSlS5jal1a52zNpHe9VoG3usQ0k6trLCWbzAgGOKNVavVs393dVTB5QB7tZag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w9FER3A9qoq4DEjiv6uRsU3AN3c0RELgD5i2ryGfe8A=;
 b=h/P6HrkcGOcAIur6LQknCcZT9bczCCYU5QR2P136lv3EsCdKVHX6FuP0NMfRlcyRFLIxh/5SbQD3t7Q8mVuo7jY7t8M9vLXtwys8S/4EG4OvAJAZgH7QViTVW1Yj9XaVl2NO219mHOmXodAeK/zlI1ZgIMjZidcYj2AVKSImRJGuPCLmLn4BPI2Klxe8QV2Xm+2sJc3416+305wEa/ACLLxleHQ7RrZd4xfDryApeoXIgCKQVl15y4aslbjlJGB4yeorfMQgaXknYP58Qr2rlj4kWQXeIAvrGzNJqfBqiqbHtBBUVBWmnbdI9qO7ciL1Mvxgc74/8wWz3lOg7EIHhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w9FER3A9qoq4DEjiv6uRsU3AN3c0RELgD5i2ryGfe8A=;
 b=KM1CzHviCYLffHEyJnoSfi3HJ6fmdwTt6Lw291J367giaACixuDm0E03ut7CKeEPKCeFymJc6+RFvPxoWwRVZjC5KX0oYUVubwgNPsUirjHHrMpsyP076GBXQ/nET+FJUO6sr5z47CnMgOSlSyC35Vv28sorBTeroXOa23Zen5x5ool+bSoGdFEKQHOcebSFV8mHUkqlThQU908jIz9QBgKypMWiTuEZqgMfmMFSHulPylUe3h6rAuWhN0uJQ0dBdSH7W2KKMqSiOejTcayAZa48hcb9bpBRAUkdJfTQIoLgeRDf0rg61TxyCSa0iWrqNyolqhBYymFYCsa+qYtEhw==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH1PR12MB9647.namprd12.prod.outlook.com (2603:10b6:610:2b0::10)
 by CY8PR12MB8338.namprd12.prod.outlook.com (2603:10b6:930:7b::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.15; Sat, 10 Oct
 2026 13:45:30 +0000
Received: from CH1PR12MB9647.namprd12.prod.outlook.com
 ([fe80::228c:766a:191d:77b2]) by CH1PR12MB9647.namprd12.prod.outlook.com
 ([fe80::228c:766a:191d:77b2%3]) with mapi id 15.21.0496.019; Sat, 10 Oct 2026
 13:45:29 +0000
Date: Sat, 10 Oct 2026 13:45:26 +0000
From: Dragos Tatulea <dtatulea@nvidia.com>
To: sashiko-reviews@lists.linux.dev, Tariq Toukan <tariqt@nvidia.com>, 
	dtatulea@nvidia.com
Cc: linux-rdma@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 06/10] net/mlx5e: Add data direct TX
 infrastructure
Message-ID: <uc63em2ficuikpwefcdn46dayb2lalnynylbc7wkmeua4l6scc@i3yoeilmyyke>
References: <20261008132815.654147-1-tariqt@nvidia.com>
 <20261008132815.654147-7-tariqt@nvidia.com>
 <sashiko-outbox-165640@kernel.org>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <sashiko-outbox-165640@kernel.org>
X-ClientProxiedBy: FR4P281CA0356.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:f4::20) To CH1PR12MB9647.namprd12.prod.outlook.com
 (2603:10b6:610:2b0::10)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH1PR12MB9647:EE_|CY8PR12MB8338:EE_
X-MS-Office365-Filtering-Correlation-Id: 6c25412c-b1db-4a68-4f90-08df26d4bf5d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|366016|1800799024|6133799003|18002099003|22082099003|4143699003|11063799006|10067099003|261009223027099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	gTkK9ymKdRY/aZmf+H8Mih8tTLLzGZRGIPt/jKIDW0Cs0F4wCbcQSsXJSgB1aKfICf8GVXjNnlXpdY70nFJqYbaq/OhQWLIoxLls2gRdHIL25wNwjpaj29xm2jCbIOJ/EPqXPnXVwyvTmawNUxJkypjuDaYzlj/455ldTW2NUzqa77+K509S8g2Mm3X6+A3PtY0nTPcy9w/Q+ZZwIX4C9ydyqb+19H3VoPhpeLxgDbV77d8XHOJFnGxAJMEEduusGj2N0B3/PQhTnwOmurgELveloFtyhdsZK1YKVMhhgPw44sanMeZrdxvGfQACYN3Y8WeZca/9JwWqXqvXDk6SAOUKii73hloeiFfjGjwb5Oac0AQdQ/3V52+fDmlAYtgCxzdKaQfI8Ek6wDWnxiotrmQkr6E6h6DG2AEMzwLR1PZRlkCtjTwyPuijqKV0U+HOIMpViY4eM9jFUOIAiwM7gG9Dl7iX+g4jZx/0QMXq1BLuR3j9DUS03dDSYoP9H7tmrQYXw29AcUbVGzCOV39egdHRls429Q25Xzkp+lhh7HK8KafzaidALdaTdMris1CTYySRVNFlecxkRReaXl8p7tOjNJ6qY3Yp9foCyXDTiowuzCJnLBlwD2SVxKgBLlXxh3EzIdeWLc5AGkQuP13xtPAWd+oEXjG+8ItjnealKHA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH1PR12MB9647.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(366016)(1800799024)(6133799003)(18002099003)(22082099003)(4143699003)(11063799006)(10067099003)(261009223027099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?iso-8859-1?Q?xi/0BWPuIjmY6/hLDHE2afXC3+Qx9LzU8gHMSVbP0vx2Hrh4r1NS4J7bqx?=
 =?iso-8859-1?Q?SWbxCLAXlAnOq6v4JJ6cgiZ1JfRis5OztIk5HV10/psgkw9/DhqCHK2CF/?=
 =?iso-8859-1?Q?PZaSMExlQQAW+ndFZyCTrUzUEdlOAg7rsQoutv04tBjqDocVK0YvO9Zpx6?=
 =?iso-8859-1?Q?6T38PiSHYlubsrDTvuStWtJItf/0XHqEkVMCIw3WZ1G7oXgJxuwVbJ3lVD?=
 =?iso-8859-1?Q?DKuZpOaQTNMM4ptLnDy7XAbi5IPpdg4kPgeqD6imR/2vNZEglsRzKoLjW4?=
 =?iso-8859-1?Q?U8GQJ4Kmj/6UIK8dy89/YzDdx8eeFNyGNbVyqk+FjL2sAo/6LFnys4oDgp?=
 =?iso-8859-1?Q?AAYDkgZFM/3u53hNLndsC+f8XlRKmajV6oTi6g6wjjlfNBjq0cv09GfuQd?=
 =?iso-8859-1?Q?+t7B36khQxDdZ3QNV3HHDtF9t1CL7Jnx8vRjwHkIqGmXt5BQG35kW1JrRG?=
 =?iso-8859-1?Q?2gUtOElyShU38oanEBttkWdLy6ilmhV9EXE7fgLf7JC26SHCn21n3eAhWr?=
 =?iso-8859-1?Q?oO2ozjP8WjvTEO/NDk5prV5OF6hHMTtV69j9eu0QY9sIjeORmHZUD8K8N/?=
 =?iso-8859-1?Q?vIkrgTuHXlo8fFjYanTs/UIecUVM5ML3jVSYzlgE4x+J/HraMRL6sw9LYF?=
 =?iso-8859-1?Q?HKkv1/KXNX41DapDUETP95gU+k/qJPejgue1osuIK2PneaMtIu96f6ddyO?=
 =?iso-8859-1?Q?9MNRgTjfR4vzA9tJrIhep+i3OVuq42Aj7MUR5HxvhKheQE/ZehFu6UZGAq?=
 =?iso-8859-1?Q?KoRGAI7DQu2MHE+eJ+8i1QBDRcDCXGzX+IR//1AhR3EUkKzPnq0qw194Wu?=
 =?iso-8859-1?Q?1zSqxljlnwpKnhUwYdGfll71GaxYGDIf5mXTRe3Se0Bd5N1DhBQce5kldu?=
 =?iso-8859-1?Q?sM3Q/AZc473Nh3jp34w7ANrOvKzQ/u2Ua35JZvlqmSuRW9b9RlWIP2RLG1?=
 =?iso-8859-1?Q?qFGy3FisR9XiMk43PxKpkA4kyJfe4nrBIjAUXIlh6PPz5qRsm6mBcBE+Nq?=
 =?iso-8859-1?Q?YqgneXwpSQy+LoypmWAdTiiEAfKoQl2M6OPeAWP9XXdpSlbgE/ZIkre6mS?=
 =?iso-8859-1?Q?fcC3vCiMgaNmNSXns617QzVFumqTYMXeXmiiEdUInfxkeLp/rciS8RlJRk?=
 =?iso-8859-1?Q?T81HyGIMNLj1IKAMrjGouagoTZbiwMuwaEfdpomchyLhBEme/S9wV9zhdx?=
 =?iso-8859-1?Q?FiD9rKRbswUeXj8HcwY9ij00b37zjkjiL4+6aJK7bXvQPjpGPNmBq9O/8E?=
 =?iso-8859-1?Q?QKsS6U2npMoXHAG1+hZDR2BNhjMRCgZ7v6J8mg0ZpRHETSjvOuXZxBHtTg?=
 =?iso-8859-1?Q?oFlHRsKGo5vrJ8zbX8w7cd4eSx0gF36JYltO/pQjyLC3nlKgkUmY+kMQZu?=
 =?iso-8859-1?Q?thokbj408nrIOsxd+qPiO/1RiouyuiSj+3Qs2KTiuu0RmifHbGqCgjh4Qn?=
 =?iso-8859-1?Q?aKlV1s9AG7TNeed2SpHFc/Zj3W+lbEQv+8dYIhOU+Cf0Zc9AaKmPymlSHC?=
 =?iso-8859-1?Q?btlpxSkqMtpsNuHVmE2gmaQ8eWf7pMBFjuLwx7idinlOZq/Wz3v+OPHTpT?=
 =?iso-8859-1?Q?lRviehhoxyhtf6vulvzGjYC/Rd/sT8wSoHY6DuApV+eWDy9QLQWoViB2tJ?=
 =?iso-8859-1?Q?DPwXeoFUx/BaZcqnCFycY1i5ec8w590O/Njj/8fQ5xkfMqHsBgXVqzO7Uc?=
 =?iso-8859-1?Q?UG73Fpicxq2uQ2h8GjaDrW5fOisDgZyDVXcPDMhWq18HgBJYtBkQsoFGIE?=
 =?iso-8859-1?Q?Ah91+Y9X5wp+9G8ROWwHqK/JFunbjY+cL5UKmHR7B5jEMS1y0DuwGcq1QZ?=
 =?iso-8859-1?Q?LlCDxA2HfQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c25412c-b1db-4a68-4f90-08df26d4bf5d
X-MS-Exchange-CrossTenant-AuthSource: CH1PR12MB9647.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Oct 2026 13:45:29.8482
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Cp0yEm3qiBY2jXwJQ29eswdiRDr+ZdesSvFbCO4uQoVBOuWltxIBHAllE4PS6pqe3Yz81bQrf+/4Xra6fvWXtA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB8338

On Fri, Oct 09, 2026 at 01:31:04PM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [High] net/mlx5e: GPU unbind causes DMA corruption for active devmem TX
> --
> 
> commit 2beff8c1365001300351d8ed26d31fd617a37400
> Author: Dragos Tatulea <dtatulea@nvidia.com>
> 
> net/mlx5e: Add data direct TX infrastructure
> 
> This commit introduces the necessary infrastructure for peer-to-peer DMA
> between the NIC and another device (e.g., GPU) on the TX path. It creates
> a crossing mkey linked to the SQ and adds a new SQ state flag to indicate
> when Data Direct is enabled.
> 
> > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
> > index 14479da98f427..62ffb41a64dfe 100644
> > --- a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
> > +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
> > @@ -182,6 +182,7 @@ mlx5e_txwqe_build_dsegs(struct mlx5e_txqsq *sq, struct sk_buff *skb,
> >  			unsigned char *skb_data, u16 headlen,
> >  			struct mlx5_wqe_data_seg *dseg)
> >  {
> > +	bool dd = test_bit(MLX5E_SQ_STATE_DATA_DIRECT, &sq->state);
> >  	dma_addr_t dma_addr = 0;
> >  	u8 num_dma          = 0;
> >  	int i;
> 
> [ ... ]
> 
> > @@ -211,7 +212,8 @@ mlx5e_txwqe_build_dsegs(struct mlx5e_txqsq *sq, struct sk_buff *skb,
> >  			goto dma_unmap_wqe_err;
> >  
> >  		dseg->addr       = cpu_to_be64(dma_addr);
> > -		dseg->lkey       = sq->mkey_be;
> > +		dseg->lkey       = dd && skb_frag_is_net_iov(frag) ?
> > +				   sq->crossing_mkey_be : sq->mkey_be;
> 
> [Severity: High]
> If a peer GPU device unbinds while a Data Direct devmem DMABUF is mapped
> for TX, the MLX5E_SQ_STATE_DATA_DIRECT flag is forcefully cleared.
> 
This requires devmem to implement dma-buf importer ops and implement
revoking. The driver can't do anything about it.

> Since the asynchronous unbind bypasses the devmem socket binding safety
> checks, the application can continue transmitting net_iov fragments that
> still contain GPU IOVAs.
> 
> When those fragments arrive here, dd is now false, so the code falls
> back to using the NIC's local sq->mkey_be for those GPU IOVAs.
> 
> Could this cause the NIC to read incorrect local memory or trigger host
> IOMMU protection faults? How should active net_iov transmissions be explicitly
> fenced or dropped when the queue state reverts?
> 
> >  		dseg->byte_count = cpu_to_be32(fsz);
> >  
> >  		mlx5e_dma_push_netmem(sq, skb_frag_netmem(frag), dma_addr, fsz);
> 
> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20261008132815.654147-1-tariqt@nvidia.com?part=6
