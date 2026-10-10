Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011071.outbound.protection.outlook.com [52.101.52.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 856FF1B2EF2;
	Sat, 10 Oct 2026 13:38:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.52.71
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791639535; cv=fail; b=sUdLQGYtC8fNGVeSfJCEcxHOdRqQ0g5L9IHpzU82uV/x1qIt4pduBE18UNiSALSKVVVy6brdpPqm7CQFoJothLhLzC+DuFd7651h9ruToHhPLEFvhcMUkTKYrx/+lxmPuiEfWgeCvMbmrnDI7OOzw2Zi6M2Mjr03hGny0kWWLXM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791639535; c=relaxed/simple;
	bh=D6y+37SqZ99dcMx9hA6AQ1X/M1pMsq1akZbUe6AEWNY=;
	h=Date:From:To:Cc:Message-ID:Content-Type:Content-Disposition:
	 MIME-Version; b=tykNse2F84bIfxIAGqAKeDHeG1P8nTHDJXZqajYKuzdBMJrGtQfslcIT44AcUfNHG2NJW2Ebyk5B0O2IHBRxO5GLF3DaKBVQT8sfXqKd2ktSRC0//CV27m+ATK5KEyrnTQfi4qU/bOrIKQCGwUQAxzNpGWApD3XtZqZzpoNZZI4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=fail (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=fail (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=LA/5v3Ao reason="signature verification failed"; arc=fail smtp.client-ip=52.101.52.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="LA/5v3Ao"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=duJfLMoKYurkrGtjUuetXWxZOy+gET76tXni3YOL0bo3JMEaondfePounT6wrgZ2+FUf7YgWuA43/U47YP8Hci22CkiraAjPVC3htUiY+VWI44tCc0yJnZWgJJlDeQww9aoKgZg/CYlhxUtWmwlBFhQt894yEFWc1CKc/kgmiDeUMqSRPZKm4woLXpolJFXmuLhgyJD7288pIJ7GibDa/diD7GnOCsLtGQU5cx0JKTtzsom6UOYP+a9VGr7CNdMdKvNBL4eT+d5tAJc++6/0nhyyTYpKd5yu9LXN0fPSh2LBQcd71yf/pGjv+m5Db5lCdxENBSMzBeU3gDTINyPYag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sikECreEq+L+cyicZ+Svbwdh0PNDSNUe5+Zr3UBppMI=;
 b=qcmTERPXR41cVXNEOqf/pOA8EttPTN5nGLVk9yHTMBeGLZnS2ZseF+hF6T+DUwH4Qf2A/RSy0RRh+s3NhHGbjZAZYEAXrfxgdFnrS9XeY7lswnC58b8vyGooE83Q4+/kWJoupNZV80hF5SibZVvUnbmyLVSZbRY3I3p91GoVfLAO8bB+hBoqgp9d7VGyRXUNt/5n/Nqw8uCRZ1hXQSR7/rwm4R9kzMJzBEu4M6KjfcdOEiUmvpHK53r0g8l5sHEXqLWHArFSVpNVhV9ZZ9VNmZfWocpiXZLsXcvwxTCy2VcZwHDEkLW56vhPyX56Y7rf/5zfOBWKd+E6LE5tywdJrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sikECreEq+L+cyicZ+Svbwdh0PNDSNUe5+Zr3UBppMI=;
 b=LA/5v3Aom0jLAOo1kgB+o5qUy5OE82i1KjPgMih+LL7AWgdFBScEm8wWX9/zYLrEUOeA/VsQ8S/IAqE0feOC+Wx4+nFYUQ1FXEJckX8LVmflgDsTkrV93Fj8qSwCWlg/om5UxfhYTo9UGQacL0xoWNInYpC+D3h8VON4k2QHDexI+VZ3sRsKg1eKDDr8168JyIwnWW4c55XtMVCx0EZ/QsiqXAZs3bPm+KxgXp0X+VOSQskPT7QJNPCfDRx4qfsBi3yPzuyyl0Xw42tsNuhg1eitQ2PXDzhSnRaFHyuMdyJj/O3oakUxuDtT+kopi5wCqoPRE5ghB/XL3/Q6mjhCNw==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH1PR12MB9647.namprd12.prod.outlook.com (2603:10b6:610:2b0::10)
 by CY8PR12MB8338.namprd12.prod.outlook.com (2603:10b6:930:7b::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.15; Sat, 10 Oct
 2026 13:38:49 +0000
Received: from CH1PR12MB9647.namprd12.prod.outlook.com
 ([fe80::228c:766a:191d:77b2]) by CH1PR12MB9647.namprd12.prod.outlook.com
 ([fe80::228c:766a:191d:77b2%3]) with mapi id 15.21.0496.019; Sat, 10 Oct 2026
 13:38:48 +0000
Date: Sat, 10 Oct 2026 13:38:45 +0000
From: Dragos Tatulea <dtatulea@nvidia.com>
To: sashiko-reviews@lists.linux.dev, Tariq Toukan <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org, netdev@vger.kernel.org
Message-ID: <vasyi34qqryx4thiiuevn72a3viybe5dlxuk5hsd3gprdxcfhu@3y43iovp3ebd>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR5P281CA0006.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:f2::16) To CH1PR12MB9647.namprd12.prod.outlook.com
 (2603:10b6:610:2b0::10)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH1PR12MB9647:EE_|CY8PR12MB8338:EE_
X-MS-Office365-Filtering-Correlation-Id: 372c642f-5a55-4a30-3222-08df26d3d072
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|366016|1800799024|6133799003|18002099003|11063799006|10067099003|261009223027099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	GvberFqzeKaP1mMCJrW1cX+wDYaLd/oeaRG5LbqR8Uvv1FAjamN0e/cfR0yrF86T7YXibNBz30VBuZbi/8SLKUaNFuksg5Nc5aLxXUjXiiRc8z49YDJzjqhcyiggJ/oH3A9FUf6QrklD/riZYqOj18BqXW2rJyAjYmvjx5XqtAK4Ed7/DLimwM/zzPm+mlFLoFAhs9hRwJFxGq6vXaxRQ03GljvsQdm2N3Qag8JQujaApyUD45AXx0PknNB7FvaPpJilnvXsQbOQCULz38z9r2NKK21jT2RZivLUJqpt8+et3krTBxHd2E1FUfOJMkdrEgRe70zWuqEAVYDs7k8gzHw89ChQYAfInJcmAPIFfX8UB4mtsvPTbcjspNmuk9nNuSikLolcRnPDh/W7qdndmxMGpJMSDEgAU2TsTjAZiEzOUGJlWT4hPXvEcsithLkXpKuyzpCBCrrK6Igf05tHE9I0pPRf80SAkXiAmXQpmatjcRPd9O6hp281VoLwYpV6GVPFhIkE9KOzTclb2+IPKGB1uMcqopWIMfApLEmzdYafu/i1I/22TXnlTfackSIB+9jBpfT5FeMv83lY6oHMAin41w81E9vse3RS9f0OUyibBjAaWgzMbhnWE7yjVu0IwjlBkMKhIvVtQ2SrH/kR2VXVBzUqRH5bCxBgDGtxhDg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH1PR12MB9647.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(366016)(1800799024)(6133799003)(18002099003)(11063799006)(10067099003)(261009223027099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?iso-8859-1?Q?grT+QlOb0frrXj7Irt3jVqBz/iFns4CY9M1l4y2A7GovbkGhOEOb7Q08CU?=
 =?iso-8859-1?Q?dkvg+r+/isdJW1oL3LUqjpgeIH1LZLurXv3046cGJCigGhMd6AU2K554l9?=
 =?iso-8859-1?Q?M6w4qa0VH5SZxc3qJ5Aa8ZPyvViAgWALDU0gPUPpTCRVdWHojXa4ZCTcZo?=
 =?iso-8859-1?Q?NJ29PBvdaOG3jJXSA1G8jwZrEUa4yXo2M/ek0UphzAUAK9nYOJHipG79Av?=
 =?iso-8859-1?Q?v700JmhEUSFgZPadyalZ+rMTn1ncVzVq+JUPxRfRolXqKqTYbV/WuZe4iH?=
 =?iso-8859-1?Q?3h0ZWu63nt5UKP+hwfeEggqcZ4aKWmKQB3qCd0olEGdLmRb8cgpBm+1e80?=
 =?iso-8859-1?Q?ZX6ZG1QmuPgjBEybleEnlLAy+9lCXZ4jv8EhMeugHoFL63ewiYdlGU1ygC?=
 =?iso-8859-1?Q?edKll8tSlu8f2Mp6KRc+nkvz94SjguIfrcmaTlti1KmR/JkpfmHL9eRgiX?=
 =?iso-8859-1?Q?9zbm/8IjY4PKv2SfNU/LvVdMVnqQ4p1AKPVucZNlZEx0rV4K8pKqgFMLer?=
 =?iso-8859-1?Q?Roq5FILEB212JF+wilgLy7P+D6rPwJTxZx/hZ9Px4YdazpMisCu4XzIosP?=
 =?iso-8859-1?Q?6XeQ9lNcsBh1OIz3KKVSDkD5eKsimvZYaUDhKisRQexW910F7VuXMBkGcl?=
 =?iso-8859-1?Q?WRiK1d+BaQf89P8wI5aw2yrm2J5tGvAavo6zkGmMQANI6SnpR17YN17FuW?=
 =?iso-8859-1?Q?oi0xjkjTnYeSto0yRtM7GsbstDlfQDmnEpj6OwMccUNw1u3oi8Ss5+K3Mq?=
 =?iso-8859-1?Q?DBxGtq6wwbw/tINxwJhLGbeYJzpu4ylxq+YaFV35CfNneeQMb0gD3wg5tk?=
 =?iso-8859-1?Q?/Qy5xFA65DxYXau3QjM+mNHgfyigvp1mUiCivwXuu7a9HFHnJDgFIA9Fyj?=
 =?iso-8859-1?Q?2/mupXkuRLT7wjfMlTJb8R+FalcJ02AGOriQtMPr8ocJoX7S32Ey2dkMVT?=
 =?iso-8859-1?Q?Ueb3pcyCx6sLtcBWg/1Igq7Puq2tHhu5AmkxkRXXu5nRdmoQzt758L8Isq?=
 =?iso-8859-1?Q?QRAfe5hylhEnhUYmOY6NeaOaXiBszvt5YT3iQn2TFNKAP3WbfDXKDSF9f7?=
 =?iso-8859-1?Q?ze7OdLAN5TJgLnh23UqzbHgnnTZxCztbTootocIkU9GG8nJXPJArrNuIFB?=
 =?iso-8859-1?Q?UBLPZHJ1vu+kKoQauB88Q4Wht0OCB8gxpqSWhxsEF+XkzDRf1q9fxkZnUC?=
 =?iso-8859-1?Q?rSpDxdBl0poR1iyyrrYs8C1C22bex3ZWymsmcWzXBkR8cee7xcFtVp8pCc?=
 =?iso-8859-1?Q?lLMU3IxrF+jQeieL0fDSClyC5QJBv34UrxmN+6efSwZSgp9aJeSWhRxo+D?=
 =?iso-8859-1?Q?p0NS/n7Df1GDsMQUPsm283AL2yBmrafgNJdbMQyATzq1Q7Vml91leHyNcs?=
 =?iso-8859-1?Q?FGL44L93QRROTrSpvVmv34To8GNkI51Vv43w87yOe06+Ayoy5n6Rk6Zzzg?=
 =?iso-8859-1?Q?uU26ROaw4r4Tg90oz5Z8h7Ud+yHm9hmF0cLPAP+VC2mmxUsTR9rhulz5KT?=
 =?iso-8859-1?Q?1DjcFgTLITlAwic+VsDGGddaRv/To80NZcj4zxttPvkkjOS1CD/s0hWK8M?=
 =?iso-8859-1?Q?X+AidCWa7Ui0aflIfzVvbfdF3+yfrKTHM8twI2zzN4VviexO4Q2EoR3ztj?=
 =?iso-8859-1?Q?3PkBq/kicw8Vco0lSPjqwWTl79bnKwCx/9TMUOnSTv1569n4IWfznvxuFT?=
 =?iso-8859-1?Q?q39IGZQVkZvHXWY8KbDP8JKIvPWAqfcjBl5fKMQCAYwZyCd+GHz0cLqh/C?=
 =?iso-8859-1?Q?URjLjdmPrtE8wyVUg8AIVlx88lx1uTGKSVXR8qq0gnpyPHolLCjtvN4yZc?=
 =?iso-8859-1?Q?TqM1C4c0Kw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 372c642f-5a55-4a30-3222-08df26d3d072
X-MS-Exchange-CrossTenant-AuthSource: CH1PR12MB9647.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Oct 2026 13:38:48.8153
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: abYvxRk1LHPFVLERRzc/TnsYqWaD4wLS6bra41Hbw107OrhXMEs7TBoBFP83Ejtz3xzdzXLF4owO1TYdXZ5PYw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB8338

dtatulea@nvidia.com
Bcc:
Subject: Re: [PATCH net-next 06/10] net/mlx5e: Add data direct TX
 infrastructure
Reply-To:
In-Reply-To: <sashiko-outbox-165640@kernel.org>

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
