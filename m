Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012011.outbound.protection.outlook.com [52.101.43.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEF9F3A4F4B;
	Mon, 31 Aug 2026 08:47:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788166081; cv=fail; b=P0ZmdMm/Y/BfC8p9SvRDNqm3mQpx37urL2pS40htinqTOhdKjrPjNsz1ryIxe1vvdX7yFKS0CC9uhRshOf2cTQzeMmyHwPnSQjSoVhIQEFwswgcz25R+GSjgqCi4ORcawwdYbJ52W44C7AcKfOFVKzoM6IoLzYf+fNqh8wYQIbU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788166081; c=relaxed/simple;
	bh=YDQz9xalNsJYc+0UsCxCHPPI4dn/CCANyBUqkgoTLiY=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ogKWcnROybFnji67M9UUnZcIU66rHjmgKLGho94Wq22iHk1nO4+3Gko2wqmClyHAhLyXXA/Ry5wE3uFbPc2xFicCRR7hY1fg7oQTRWig9o+MrxaW31l8KcpRmaS6fxc17yrRdh6+lb8s1e8oAiHdhOH/+5bnz5wbLauJqR1od7E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=hGPoWO8r; arc=fail smtp.client-ip=52.101.43.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="hGPoWO8r"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=n4R8EIV6M5tLGVqHKm79CAkKSbVNIL083lnzQmnRZ1lK5iMvx4dO8pf/6wg6Oy81yOhku+uuMyabr90Qcg0ZTBOLBW29RvarKEBjpbBensoFYGzqxJnFLNadWtYq4Od64akPOFzKogetCU2lq5+spNdoXcBXCITmL9cPA53zfM6EBrzhHb+ItdfE/+2+0dUEJ21Afg6bKt+4u0ogQW8CQuOgstfRGEal+1zECGZOe/q/nbVkGo/iczXMF5/upKdFizg621oYZEPb3GyMpHli+SVHidWicVByiACrsOdy80fsq27Ob5/gTWlAvmB8lzzmi3nXnn/OgTEvfGf4NH2Jlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0qunzlDVybyncnNMApW71pYFeTG3N7I8/5zQ+8rpicg=;
 b=FL5Z6cZw1xmWgjQ82XzYoiJTPaxA596IWJhDS4ilF93gY5bYLFLEjPHcnElpDWJpbBajkH9arrtMLayc9BnJTFrLYXkdEQlFLJmq9OHUuNrmrClgM98C9wVK2pLhPscT7nKnfxzstBcY/n3zcV2qHY3rwbUX6gmtaKbsGuhr67EYDb4NYxPVrPca8TgW1nZMCb2p/WkCVzgeOYrNtbsT/iZvXLljyn3fak8YPLtIiBmkoQJd/xgYPdB23u8u9Rmmio6tI3rzwd3PgglL6ovnRCEASyCXTF1cXvrGPHC0XUpXVFWKsY4+nTzkq/IicExhtWv7Cu2cgrzTRaIeAkdH+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0qunzlDVybyncnNMApW71pYFeTG3N7I8/5zQ+8rpicg=;
 b=hGPoWO8rA88CE4TFl0AUSzOdJj2u040k8kxov8olrhYBVhRx1DFSpaWBITLxJJah7G46+NfhTtwaIpLWbw7UVjrI/Kz5G936FlJmTqHs/CVSbMok+6qRixDhJo9YrmHj5bRWUAaYA/4RVi1oPOPSnveazyXm2ud8efKMChsyI2s1r8KWgH4G19hSD5myScmzYBk+pmTfn/Tfd6QtoDUnUJtCMC3sm2eZWFctR7CDYI/q3lyS8ERLZq2gHUKmMkdQVA2LoD5Yl7pgoD8aZQySS5pOTr7Z8wYRodk39uoUZBFebQbLQg+eqFQ/vgrSFvA82BG9nbFOA9ZBv6NXPNDKIQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8728.namprd12.prod.outlook.com (2603:10b6:610:171::12)
 by CH3PR12MB8329.namprd12.prod.outlook.com (2603:10b6:610:12e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.13; Mon, 31 Aug
 2026 08:47:57 +0000
Received: from CH3PR12MB8728.namprd12.prod.outlook.com
 ([fe80::2641:1046:bdf3:93d7]) by CH3PR12MB8728.namprd12.prod.outlook.com
 ([fe80::2641:1046:bdf3:93d7%6]) with mapi id 15.21.0360.008; Mon, 31 Aug 2026
 08:47:56 +0000
Message-ID: <f5ca7380-7c23-4e99-9ec5-64a1a248775f@nvidia.com>
Date: Mon, 31 Aug 2026 10:47:52 +0200
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [PATCH net] net/mlx5e: Order ICOSQ cc update after CQ doorbell
To: lirongqing <lirongqing@baidu.com>, Saeed Mahameed <saeedm@nvidia.com>,
 Tariq Toukan <tariqt@nvidia.com>, Mark Bloch <mbloch@nvidia.com>,
 Leon Romanovsky <leon@kernel.org>, Andrew Lunn <andrew+netdev@lunn.ch>,
 "David S . Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
 linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260820030821.1731-1-lirongqing@baidu.com>
Content-Language: en-US
From: Dragos Tatulea <dtatulea@nvidia.com>
In-Reply-To: <20260820030821.1731-1-lirongqing@baidu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0040.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:92::7) To CH3PR12MB8728.namprd12.prod.outlook.com
 (2603:10b6:610:171::12)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8728:EE_|CH3PR12MB8329:EE_
X-MS-Office365-Filtering-Correlation-Id: 9d09400f-71f7-4377-69d4-08df073c8d9d
X-LD-Processed: 43083d15-7273-40c1-b7db-39efd9ccc17a,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|23010399003|7416014|366016|921020|11063799006|10067099003|18002099003|22082099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	qtq9DNNyMwn0h3uqjwQ/Mx9NjYRRA6m9/VPUrQhNRkiOIMIvvc24dCWZei3QEg0FGdWcdbjXE4xvC13AlFPsDPS73NZwlg2qetr+Sf+jMo5/42beyNYJVeM1h6owDxiDGGZCHDmhSgs+fZJoN3EUzTYZngzrFjvG631ZSjq3r2ktLqMVNZDT+TqIKTMRYyLA0J88JE9deGzBE1dcVL00lW52dcywqk0aZF+o+c/dmNC2Ig4RHJ2N96H3Thd7u4ca54TZz3RXhE01layO6GCPGpAOCPckG2mEzMynnG1Fs3fg0v51Q2mlPdgq8wcTM2pgozZYlCwU99iZ8HIj6Vj9tltOhPk5T1KLRbay/bXqPSgZkCTEZ358RgWPSQpnrkAwF4gCOdY/7BcM8rhmmeK7Q7o9Sv6jgBKNNZP5O2GXZSbDChkWs2EfNlXBMWoocTNoPj5eMENQNk3py/Ri1bCn68c46/gAR2sqSrIIftgnZYkds8QXWLnQBN4PRdYIo1MINemFxbMj8HsZJgKaw7jhGeBD4DyZX534+Qc4LeMviv0AegRgxqj0yMuffh96lt4IGafJjgvW3x4Xx6YFiCQEwj2pSi0xQoiUkGGAb5arMaDQaoQ0cFCFuI/+iJKQ/nlDUejeFk4RKTqCsgQkEd07yvqBTsyK5av94qU7wF/DtfTwPPnf9O98CxzEDnvqnSUdqGpryB2Uwt4y062Ur/0WVw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8728.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(23010399003)(7416014)(366016)(921020)(11063799006)(10067099003)(18002099003)(22082099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Wk54U3kxZ2Y1K2VlekJyMjNnMG9Ud1Jra0o0QWJraVpLYkRqQUU4c1lGQkFG?=
 =?utf-8?B?OFVjckVHakpUU3ZHa0xRdmdCMkh1NlpaS3paU2x5NzZ2aURNVmt2VlJhdjJU?=
 =?utf-8?B?ZUhzd2xGa25abzBBM0xFajVkRGZjN2IxZmduUmh0aXdwTDd2TVNPa3ZXS2dr?=
 =?utf-8?B?SHU2R0htOFFtVUpMZ3NKNDk3MVcycnBzWWJ6WW1kbExrSklLZlNuVVJOUEF6?=
 =?utf-8?B?NzRDS2lXYXZBb0N0WUpXU3huOHFPbVY1NkZyVnFLblRuZDBRdGJCdW1JOXph?=
 =?utf-8?B?UFowRXBySUl2UU5MSlNkVWNFaG5WbVNmeEhPekZGanVUUXhudk9jMkwreTI5?=
 =?utf-8?B?Vi93TkdFa3hxZWJDdG9CQVNhci9FSEw1dUhrZFhmb0UwdENhL1B3T2QzSnZn?=
 =?utf-8?B?NHVFYlArVGpJYnJVNGJEU2ppU0dEaWVpSVlWd3dSRDJVNldOYzVUb0JEZ0do?=
 =?utf-8?B?ZHk3Z2RpK25CaVgyUGhHNTZEc1FZLzl3QUVvWWRxMSt4QXJiVkVQb0RNc2ho?=
 =?utf-8?B?WlE4dFVFdEsvSCtQZ3BjaER2T0pnOVRBVVA3Rzg3ZytWUVhldkEzUmlxRWlC?=
 =?utf-8?B?RE96MFI3bVpmWU5tdmVvWGp4OFFya1pkV1Ewa3c0TEFhb0xyVjVuekx5cG5M?=
 =?utf-8?B?TTFEV200aERaWldMTG5pMStMSHIvdStNZVVFTkdZdWwzQklHMDVjV3VRZ1k3?=
 =?utf-8?B?UVAvUVp5Nnh1eEF1OWtEd1JqeFJNTnIvYVZjcHIwZHNZVkY5a3NVQzdhZi9X?=
 =?utf-8?B?dEdpbnkzdW5VWnJacjdqOXRicDNzMUY5L01oUDBtUUVKMXdQazVCSVZjNFpj?=
 =?utf-8?B?aFZwekVwQjZOZ3pMY0xld21xaFhmQWhVZWNQdGdKd3dvY3V2ekNIQXBWR2x0?=
 =?utf-8?B?UHBsa2xxdndYMUtzNjR1QithK2dXVHJCa2FwU21ONS9MK2prOGM2YlhyVVBi?=
 =?utf-8?B?cFgwbGZyQ3dSTVhQN2QxR0lVbXdjQUl2UU9NR1ppZmw1alBMT293SkpXQU5r?=
 =?utf-8?B?Y3pEQWdPSEtWRGttYTdBY1BQZDY5YWhJbWlBQmMwS3lEMlJyMlFqM0JCNUR6?=
 =?utf-8?B?WlgvNGJKUEZnMHdSV3VlZWFVTTFYUUQ3YzdoY0VVVEVTL2VmQXFheFllOGI1?=
 =?utf-8?B?bkN6N2orcG5YbWtTc0t5UVhhRDhXdGZEQWZ1UEtxZ040VXozRnFBSDZUalNH?=
 =?utf-8?B?Mmx3R2VjcThiaDNtRjgzTVFJRjFCM0R2STJoUSttamJiam1vT0F4TFFyZzBP?=
 =?utf-8?B?dkZuemMrdGRwRCtKZGZnQXJBYmZadGpuanpqTmF5TWhFOTF0U1BESXp3SDBD?=
 =?utf-8?B?NXJNL3RVOVBKbFZZaHdUandBbzBjcE1CMlhLM3Exa2p1K01VRWgwTGVjeWhk?=
 =?utf-8?B?L2FuRmtCS2ZyWDJXZ3BlWDk3MVZjVkZxYjJHMXgwQW5wWGlIaEhHQUNXenZK?=
 =?utf-8?B?dlZObVJtMThmUjg5MUxDYURVOEhkaE1nOUFlU1JQYnh3cUhTbTBYa2Y1R3o0?=
 =?utf-8?B?VzMvTi9yOURxTUpNd2R4bTBjV2ptMStVUzZ1T0JDeXZENDhyNU1hd2FVSHlp?=
 =?utf-8?B?SlJWKzN0Y1hNN3dyV005WkhPeFlnWWtiSDN6NjJ1R28yT0djYkpibFprYXJr?=
 =?utf-8?B?SEpmVXpOUDZjVUliL1JhdjBCTk5pNTlrRjNHY3EwYktib0pmSituYk43anlW?=
 =?utf-8?B?WUtIZzZISXlGQ0pvc2szSjFoSFl3bVRtRGgxa0hkbkV5d1RkK0lRVlFQZGtt?=
 =?utf-8?B?ZTMvUWxuQUdqYWgzSk5pekl1SDZ0NU9YRWtTSVVydm1rSDNQMzRzanh1aTRQ?=
 =?utf-8?B?NlNpU2JzcmduSnFRZjJaazlqc0dPTlhmMW4zR2VDQzB1YVBMaDJ5TjZEWjFh?=
 =?utf-8?B?QzEzL3VpZFpzQnVHMUs3Z0FiTWI0WUZuSUtGOVVyejhuMUR1RWQxQ1B1T3or?=
 =?utf-8?B?ckdKL0VaK2JwTC9mVnlYbzBHdjNNcEJqaEhxdzQzWFA0TTJ1ZFZaSjMyMjdP?=
 =?utf-8?B?Smg3K0tqb3pmTjlldUR5bTFLMDJ4SFhCdXdSR2wwUHBwdnYrL1R1MXZnT3E3?=
 =?utf-8?B?MjRtUEFBTGZLMWV0NG43U3B0cmovUFRDTk8xOHN6WWlZYkNWanhUR1Q1aEQ2?=
 =?utf-8?B?Q044dDVXby9Oc2hSSTZHVkdna0xOM0FSRWVqSGE0MElRVjNBcTIxZ0w0N1lq?=
 =?utf-8?B?TVZxWVNReWwvcVRGWVpZVFlyRUt5TnJZdTlueWNEOW1iOTVRWmNwSnpTRW50?=
 =?utf-8?B?ZHp0TjZKUlp4TVVpZ0pFY0tpSWdWa0N6S0xVZXByNnIzOWZjWmY3bTNJZjdO?=
 =?utf-8?B?OTRUR2JZSFJoREFBNTdmbUxEL0tkOGtiV0xpbGtGcEgxMDJnTkgrdz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d09400f-71f7-4377-69d4-08df073c8d9d
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8728.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Aug 2026 08:47:56.7519
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: q2E1LbuvtxuZQpltGS37RM+ZsOeOA/T5Rh52yCSGmmgih9WUyMd9lyXY0uJ0VtOnyd6bY+NrjEMH0REb0GXrSw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8329



On 20.08.26 05:08, lirongqing wrote:
> From: Li RongQing <lirongqing@baidu.com>
> 
> mlx5e_poll_ico_cq() requires sq->cc to be updated only after
> mlx5_cqwq_update_db_record(), otherwise a CQ overrun may occur.
> 
> The current implementation updates sq->cc before the CQ doorbell
> record, violating this ordering requirement.
> 
> Update the CQ doorbell record first and use dma_wmb() before updating
> sq->cc. This ensures that the CQ space is released to the device
> before the corresponding ICOSQ consumer index is updated by software.
> 
> Fixes: fd9b4be8002c ("net/mlx5e: RX, Support multiple outstanding UMR posts")
> Signed-off-by: Li RongQing <lirongqing@baidu.com>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/en_rx.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
> index f6eff03..01867dd 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
> @@ -905,10 +905,12 @@ int mlx5e_poll_ico_cq(struct mlx5e_cq *cq)
>  		} while (!last_wqe);
>  	} while ((++i < MLX5E_TX_CQ_POLL_BUDGET) && (cqe = mlx5_cqwq_get_cqe(&cq->wq)));
>  
> -	sq->cc = sqcc;
> -
>  	mlx5_cqwq_update_db_record(&cq->wq);
>  
> +	/* ensure cq space is freed before enabling more cqes */
> +	dma_wmb();
> +
> +	sq->cc = sqcc;
>  	return i;
>  }
>  
Thanks for your patch. The patch looks good but we want to pass it through our
internal regressions.

Thanks,
Dragos
