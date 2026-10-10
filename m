Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010057.outbound.protection.outlook.com [52.101.85.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 730CB49EC45;
	Sat, 10 Oct 2026 13:27:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.85.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791638850; cv=fail; b=Cx6zJ4s+A1xpL0i1EqIdeR9aWPiD1XDRsxTXmFJVDpDXuB3p+YiZK6cR+f0+R3n+d1ZzA2K+rfnjxN7KLLHZ0L3Ez/IJxBY0zVoLgQpWQt89CtU0vFQaEJ1X7/PEWGgPb1y/YF/3R2N1NHaJAGGdw7eFPMx1ekjCy8r8QG2sj8A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791638850; c=relaxed/simple;
	bh=gZZjiZt5Ad3mq4RwASlsZGmAC0msqpJQOpRgZKecKG8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=JeR9XJDwM9lDEnyW2DVfZk5uYNDYfymlW7sO5k7GwUQo+YSxbZi7Byl5OUr3z2HfI/HairRaXI8eR5TIVXjZivpKY/hyB0BtPf139MdnEODMfLUFuPbgObTAMkPyAwj4CrbpEZBYXREnJbMAya6LcWoiyuU/+RTdb0p2jrqjqa4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=fail (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=fail (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=iBLLBivs reason="signature verification failed"; arc=fail smtp.client-ip=52.101.85.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="iBLLBivs"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mIoYsXLRdR6CvcmOmbaBA9eeWESD3sRT2kZeRaLZD99PT+JlrD6In+AXPsOUAXYC+19etWGzAIs69rS7dFInF5ONHLKZWgCgSv6Bm5qwbHyt0KgOHwV2QgioS3XAWYxdIBtFrOe6zeofTeyGIk/g/h+mlvr9ftLS8Pjk2M1K8Fhu9qVu/v994ZX/NkxOjRiIxs12752UuWTp241Wkk506qufrFmYCwICRMm5KiyOuvYeEC9ohTjC/ZUA51yJXR7nJg/1seYE3lIGiIxAFJ/0EAoTKmnHdzVSwp8I6UJERanodjx8u97a12MVcEV+LezbcLqfy7MFW5GBX0Klh03BtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qT7PXc/IPFP3OsurbLaAvc0ax0wLaCnsMWV7Ra/YMVI=;
 b=uHvp5L6Rj64lrNnrEKEaIVpj+tjWrFmtsfsb1YStkjQ4fodHWLwjqvUNX+2ku4mHcjgHvijTXp2D89DBr5FzmNnYZKaMkxA/fddvBp/6mlOTANFAN3lMoKPvjFFhn9Gzv9ZzzIA+AhuXei+oZzaw/ur4jer+lEHH+4CUrZNC51Wu7x4HCEhyz1Ot/8npeTbkIza7jJbWCaXDUOBX0F9sksjHwbcrhbyt3sOU7yZ3dJpueBP1vv9fBs0QVG0AHFbAl7zlhaNGGsfzelM1JJfoqY3vGZiBzghlWVPrHu7WnUOpPdb5b5IEZRHdctAOpFJD+LagXn+0AAdy1flynyQg9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qT7PXc/IPFP3OsurbLaAvc0ax0wLaCnsMWV7Ra/YMVI=;
 b=iBLLBivsXPSOVzDW/gkbeJmjS44M4561M/3SjAQwpZa4WJxob11p70zLYnBTuOiLdp5f/MrwTzldHEOW3REoJugMsuoRiA9O9T0DjR9qllkcJC/cEGY/bdEgryEowONQY4VGPa3r3g8utqxTAr5FptBNRHclQWSohN/YcKxYy+/E5JilBBcqHIZxl6Ahi176hvsxLqZOs1cBojgeMot7O35IoJ/xdROuTfxzCGJLNniYCiATk56/Ekca1S5EM6oLLJ/mqX8DqrdLMo1mvmseVnMI22yNkKBwHP6mGONr/UIqKjnh/mRRf4wco3Eao59vs1LyKT2sWZVL7fzv/Z44sA==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH1PR12MB9647.namprd12.prod.outlook.com (2603:10b6:610:2b0::10)
 by BL1PR12MB5778.namprd12.prod.outlook.com (2603:10b6:208:391::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.16; Sat, 10 Oct
 2026 13:27:25 +0000
Received: from CH1PR12MB9647.namprd12.prod.outlook.com
 ([fe80::228c:766a:191d:77b2]) by CH1PR12MB9647.namprd12.prod.outlook.com
 ([fe80::228c:766a:191d:77b2%3]) with mapi id 15.21.0496.019; Sat, 10 Oct 2026
 13:27:25 +0000
Date: Sat, 10 Oct 2026 13:27:20 +0000
From: Dragos Tatulea <dtatulea@nvidia.com>
To: sashiko-reviews@lists.linux.dev, Tariq Toukan <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org, dtatulea@nvidia.com, 
	netdev@vger.kernel.org
Subject: Re: [PATCH net-next 05/10] net/mlx5e: Add data direct RX
 infrastructure
Message-ID: <zjbhutcpaugxqfo5hfu2hbnfdgsjs34ef3cmhrk7t3evaxn2j5@yqaeswmxvmor>
References: <20261008132815.654147-1-tariqt@nvidia.com>
 <20261008132815.654147-6-tariqt@nvidia.com>
 <sashiko-outbox-165639@kernel.org>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <sashiko-outbox-165639@kernel.org>
X-ClientProxiedBy: FR4P281CA0029.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:c9::14) To CH1PR12MB9647.namprd12.prod.outlook.com
 (2603:10b6:610:2b0::10)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH1PR12MB9647:EE_|BL1PR12MB5778:EE_
X-MS-Office365-Filtering-Correlation-Id: f689899a-6112-47ba-063f-08df26d238c2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|23010399003|376014|22082099003|18002099003|56012099006|6133799003|10067099003|4143699003|11063799006|261009223027099003|27256017;
X-Microsoft-Antispam-Message-Info:
	i26WksGo/3ZXdMwEIAF7jgxXFtu+ysyWgqZjmnemC181HyzgrZu3d13sAc+Izk3pEutQ7aCmq9zFjeuJhjCST9KYi4d5gRayw44gjHf/a/Y+d+k9sr7kyqB2qFGNqO+0p57Gp3U9Naj7QfIrqWS9H7bq8uvTmOuEreORZo8Pao5LonGUuvi92pzAGl7tPiFU30TvVwhhSRxx3UF9Sau8HnHxKIwxOuwznotQxmc4g8yEeQbabq5nJwJGh/lf8u90wHv3PZVAwhreX+tu2xSxY1PEAOW61kS7ZaicoveisI4Dyw88vtWmph79PRJYFX6r0Xd7odKjSiKjxRfj8+hsLSnAAUyq1RRgUTPdk556xMgvtLk/3AON+je9HxAYOvSF0Lo5xcvSU56kw4GB6Is2GOI4IfdREpF/KTAw1gUJyZq50rU276ae0uuM/qKxUNWAaVNJEhSzl7BsL3uu6ci6zjRamHduV0r6JVXNHwI/8o5m9GJEGTC6b5VIbBp91hW1MTu16mbFqWQRSpLzZeo7wc74J+VAbpFoLpsFlWvDciR/EzuSaATN+rmX3Irin1tJEw2KVky+qMjq9PIb4omBjYgKFY5jbxryjf/7j3ZDK+9mT6yQOh8Pwa1Wge0OpdliUFjMzLdlItwh5SAMPQG9JTPzGZbunhFlxDIRXKMqboQoaUXYrI/K5fT+wILGlveixUdM2P8bi7wgWiAAugw4yQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH1PR12MB9647.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(376014)(22082099003)(18002099003)(56012099006)(6133799003)(10067099003)(4143699003)(11063799006)(261009223027099003)(27256017);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?iso-8859-1?Q?V/McvOQ/G8p1btdexE8Ua1r8iUV0NRY3PnY19gZNbd8tNafdvCJVFnLrmw?=
 =?iso-8859-1?Q?VmG1qndufUriE1QAxINpsubkM0SoSWfrtboOJ0hAQKd/DvMEpswXuv0OH6?=
 =?iso-8859-1?Q?KQGc5ow3sOgZbBnCPOPyPVtNyz+rpOyI2mkNR/xZnRmicgBc3iE2TzEnSA?=
 =?iso-8859-1?Q?/Gsx/uXTPl2BX6PzjB50TkoWlaQX+SWLQOBDlSC520t7zubWKv3DsS3jcc?=
 =?iso-8859-1?Q?b1hfHpD6w5qstDSBIRW9egwyhio1r0M8KWVApLiiE81aphChyVDodY5DmC?=
 =?iso-8859-1?Q?FvgKBGONFVxGQuCL7AXQoeTaToGECO483ZaVVF/JTA741lS0zUJ6UaokWA?=
 =?iso-8859-1?Q?QYvA721DpOnYZfk+m6euyDDCcu/EX6yRDc5qvoj2cGVzGDZ1rCbFX4rMoz?=
 =?iso-8859-1?Q?mg13/uggJF/uGOK+0ihCnVaYEABWIWJft2X3uJQOUrj7QLLomOVnybi/i7?=
 =?iso-8859-1?Q?IkFHItzsrupGNJKtyr7oew0nzO60TcWdltQg55+vUoRG3WWT9qExtc/N2S?=
 =?iso-8859-1?Q?jkvCSpwR9UJp7YjMFftukP7HR+pk8UGPmWiCgwyRNSNrBN+f2B583kagVM?=
 =?iso-8859-1?Q?Y4zb5bMni5LKjtKCsBiR1CYneufJUdt+CKNDhWuye3K+1F1eNudFtAE2GS?=
 =?iso-8859-1?Q?IrCo0OEnutpj4LCktxoYS0E4iFYt0k950ArNC+OGknM85aTMUisLX7muhh?=
 =?iso-8859-1?Q?80ylUF9SvvsSWfSoxw2do9xjzKze0V5DX3YTeQuHotHgJN5k9t+uk9RY5b?=
 =?iso-8859-1?Q?BqmZzxoidnoCEUl4CJBZd04gplPUaYpszRJ+ScRlKCc+my06/SPZr5VhrD?=
 =?iso-8859-1?Q?rYP589mhOz2KmHr6u8BnfmAHoZVc9gM35Q4p+bRbOJqiH6Jmo3GqgzuRiW?=
 =?iso-8859-1?Q?ZSqcZ0i1o9z0+0NG+SDfuwtK9d73BHu4fIougcYkWgZPIedFxArE8OT9p4?=
 =?iso-8859-1?Q?rqMayhxjwtfuEoRym2E8d4OkIweRadcfA1+f7KnP7uclCP8w9QD3xa3h8i?=
 =?iso-8859-1?Q?Qp1mbKO1lbJTlTPRFl/3ARUJSogFr9CHYcVrBC1YVNOtEMEWwFqT+hrD6e?=
 =?iso-8859-1?Q?IG0JC0yc6maRiK4nuJpeUWMajGcimAvmDDJWc2tOGNsthNRyVl5htgkMor?=
 =?iso-8859-1?Q?3tcFw2idfbGN3xTF0gGotaaZ0FBf6zWZ180WSZpp72TNSzjbklADDDcRll?=
 =?iso-8859-1?Q?LvQKPSzJbkcNGlEbNoxBgaA/WD+RnLWsSKB7kVd+w95wzDELXe8+TtTQnw?=
 =?iso-8859-1?Q?boXTVXftozdO4JHj+0hP/in+JmGgiNcomzs02igOzZ1IGGk+IgXXkUuNle?=
 =?iso-8859-1?Q?7WLwHBahYlgj5gP9IujlYkN/xhLUivekVPCHkMw8ooWmy+5LOKa6LcovqU?=
 =?iso-8859-1?Q?BX8jlXyOGwISNdvRnYzRENZLdtEDUaeR9m/eKVbJDDQjj8Wdm0aliYeE4g?=
 =?iso-8859-1?Q?NeMLR+ktuQ9IWlh7iRJEWLGCAFduntOxxSKOXefBScOc9HNMFjma/i9tFE?=
 =?iso-8859-1?Q?oie4vm0XwFY9c+c/0gZWYh3Skb2wtYVzc/Afk5Wy4Z9BDmoKhWXwLrVWGm?=
 =?iso-8859-1?Q?MVsPrI9r/dzvueiG+xSnaTema8lZUBPV35JlVlXdWxdMLbn0/3UDaenbd0?=
 =?iso-8859-1?Q?Iv3AZw6fZn47VzOevEAosXBRklRHv2p7A0iJlO7jqWNpDH+kyFtgvpt37u?=
 =?iso-8859-1?Q?20UD7QWJieDyIEptW3SjqvojohVYc+RaD7EegS68TVAeb91ZKtCFKuzC9g?=
 =?iso-8859-1?Q?MLzu6TjSfSSW/KfWDVOJzygkahbcWX3SfbSwyCSHCXxeL/vIXmQsc26U11?=
 =?iso-8859-1?Q?uNu8mGU2xg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f689899a-6112-47ba-063f-08df26d238c2
X-MS-Exchange-CrossTenant-AuthSource: CH1PR12MB9647.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Oct 2026 13:27:25.0308
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: p7QyyNaVAaWoRAkFPa34TocUjGa5KkLzS2Ncmj4xAxjPyDdN8NsxW7MN8iptLXIZJeDJo9kdGnQWceKza/xYeQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5778

On Fri, Oct 09, 2026 at 01:31:04PM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 2 potential issue(s) to consider:
> - [High] net/mlx5e: data direct with SHAMPO disabled causes peer-to-peer DMA to use host memory addresses
> - [High] net/mlx5e: MKey PD mismatch for wqe_overflow causes HW protection fault
> --
> 
> commit 6520b18194c553450bad712fcea9bc323c0c23ce
> Author: Dragos Tatulea <dtatulea@nvidia.com>
> 
> net/mlx5e: Add data direct RX infrastructure
> 
> This commit adds RX infrastructure for data direct, which enables
> peer-to-peer DMA between the NIC and another device like a GPU. It
> introduces a new RQ state flag, a crossing mkey, and a KSM mkey
> pointing to the crossed mkey.
> 
> > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> > index b86c7b52774a0..e0d46e067c720 100644
> > --- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> > +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> [ ... ]
> > @@ -546,13 +548,80 @@ static int mlx5e_create_rq_umr_mkey(struct mlx5_core_dev *mdev, struct mlx5e_rq
> >  			      __func__, wq_size, rq->mpwqe.mtts_per_wqe,
> >  			      max_num_entries);
> >  
> > +	pdn = dd ? mdev->data_direct->pdn : mdev->mlx5e_res.hw_objs.pdn;
> >  	err = mlx5e_create_umr_mkey(mdev, num_entries, rq->mpwqe.page_shift,
> >  				    &umr_mkey, rq->wqe_overflow.addr,
> > -				    rq->mpwqe.umr_mode, xsk_chunk_size);
> > +				    rq->mpwqe.umr_mode, pdn,
> > +				    xsk_chunk_size);
> >  	rq->mpwqe.umr_mkey_be = cpu_to_be32(umr_mkey);
> 
> [Severity: High]
> Could this lead to a hardware protection fault due to a protection domain
> mismatch?
> 
No. This is on purpose: data-direct is a cross-function access.

> When data direct is enabled, the indirect umr_mkey is explicitly created in
> the data direct pdn. However, the gap (padding) entries for oversized
> packets are initialized in mlx5e_create_umr_mkey() using an mkey that belongs
> to the hardware objects protection domain:
> 
> ksm[i] = (struct mlx5_ksm) {
>     .key = cpu_to_be32(mdev->mlx5e_res.hw_objs.mkey),
>     .va = cpu_to_be64(filler_addr),
> };
> 
> Because mlx5e_alloc_rx_mpwqe() issues a UMR WQE that only overwrites the valid
> pages_per_wqe entries, these gap entries between WQEs remain untouched. If an
> oversized packet overflows into the gap, the hardware will access the KSM and
> encounter a mismatch between the indirect umr_mkey and the target
> hw_objs.mkey.
> 
> Would this cause the hardware to drop the queue into an error state,
> resulting in a potential denial of service from remotely sent oversized
> packets?
> 
No. This is on purpose: data-direct is a cross-function access.
> > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
> > index 9e1224930e067..c992da08caaee 100644
> > --- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
> > +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
> [ ... ]
> > @@ -669,9 +669,15 @@ static int mlx5e_alloc_rx_mpwqe(struct mlx5e_rq *rq, u16 ix)
> >  			goto err_unmap;
> >  
> >  		addr = page_pool_get_dma_addr_netmem(frag_page->netmem);
> > -		umr_wqe->inline_mtts[i] = (struct mlx5_mtt) {
> > -			.ptag = cpu_to_be64(addr | MLX5_EN_WR),
> > -		};
> > +		if (test_bit(MLX5E_RQ_STATE_DATA_DIRECT, &rq->state))
> > +			umr_wqe->inline_ksms[i] = (struct mlx5_ksm) {
> > +				.key = rq->mpwqe.ksm_child_mkey_be,
> > +				.va  = cpu_to_be64(addr),
> > +			};
> > +		else
> > +			umr_wqe->inline_mtts[i] = (struct mlx5_mtt) {
> > +				.ptag = cpu_to_be64(addr | MLX5_EN_WR),
> > +			};
> >  	}
> 
> [Severity: High]
> Can this write out of bounds and corrupt peer device memory?
> 
> If the administrator enables data direct but later disables hardware GRO
> (SHAMPO) via ethtool, or if it is otherwise disabled, mlx5e_alloc_rq() does
> not set PP_FLAG_ALLOW_UNREADABLE_NETMEM during page pool creation.
> 
When HW-GRO is disabled, queues will be re-created without data-direct.
HW-GRO can't be disabled while dmabuf memory providers are attached.

> Without this flag, page_pool_create() ignores the dmabuf memory provider
> and allocates standard host memory pages instead. Here in
> mlx5e_alloc_rx_mpwqe(), the function fetches a host page, retrieves its host
> DMA address, and configures the hardware using the data direct crossing mkey
> along with the host DMA address as the virtual address (va).
> 
> Since the crossing mkey points to the peer device memory (such as a GPU),
> the hardware will treat the large host DMA address as an offset into the
> peer memory. Will this lead to out-of-bounds peer-to-peer DMA writes that
> corrupt the GPU memory or trigger an IOMMU fault?
> 
> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20261008132815.654147-1-tariqt@nvidia.com?part=5

Thanks,
Dragos
