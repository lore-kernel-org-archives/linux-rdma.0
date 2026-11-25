Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.222.82.36
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795634321;
	b=fgGC9WL5cJTWbVa9qr6t8OjOgsoiIC2I+xqrWZPZDNolAQQmK+l/6H5s1ct4TIxgzqlw
	 tp2q6vDuQiGwOIsF97dLmOizbYu7JesiSwrRgHYlq/hzrTGN/TCoCZfwWXF3q6UF91F2t
	 +dmEdD4i6Dc2gerwI8lZ/u9tS3nnCZ1bSDLym44n8SMZs+RaiMY1fBMfjpcdgruR8lFcd
	 MtjpWiMNeAlucUHZ9fd8vLEUuGnfc+waebl6Gjzx3P3VaebyHoxQADT2dD5wvXn8sYj4S
	 FFreJKhh3+NvKJ792CYRubtPCnL6iQtoo2nRrM/fYfYixkuMCK3ASaI4PgmfbM3zsvg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795634321;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Date:From:To:
	 Cc:Subject:Message-ID:References:Content-Type:Content-Disposition:
	 In-Reply-To:X-ClientProxiedBy:MIME-Version:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-Exchange-RoutingPolicyChecked:
	 X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-BESS-ID:
	 X-BESS-VER:X-BESS-Apparent-Source-IP:X-BESS-Parts:
	 X-BESS-Outbound-Spam-Score:X-BESS-Outbound-Spam-Report:
	 X-BESS-Outbound-Spam-Status:X-BESS-BRTS-Status;
	bh=Xb4FsNMsiaY0KRrqcjNtS6CKknCbvYV2/96NGaNSQ+Y=;
	b=1BTXCCy15r5yVhfIBtXoPf3HxqK5Ck7fGM/HPJWLZHj39LRMrJvR0FC1eMg5CGTCC8Mp
	 imILlmGKEBzxEJowopKk6KdYbl+r38eQCUVf/UXbquZ52qrIXuLJJAnmePrIY5BzqwAmI
	 gbOchN6uSGuV+4kbKnU+V6erjEUhhxtGxhTDrir6iMkihGUtIad1SXonnL1zVCECemq02
	 T5hRi6291xCz9KstZzh0SoO7+Ia/2UsoInTYe2EW7QUVxtQLrVDmGKvz8y33P6GfE6Exy
	 VYjUc5EnT8FXTDE/X2luCs69vEEIc5Yw7EEG+xyTkyTFNmoKzxUHvoQOEF4GNMLvLzQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=ddn.com;
	spf=pass smtp.mailfrom=ddn.com;
	dkim=pass header.d=ddn.com header.i=@ddn.com header.a=rsa-sha256 header.s=selector2 header.b=1H5O1FEA;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.222.82.36
Received: from outbound-ip168a.ess.barracuda.com (outbound-ip168a.ess.barracuda.com [209.222.82.36])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C0CE606A31E;
	Wed, 25 Nov 2026 19:18:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8C0CE606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=ddn.com header.i=@ddn.com header.a=rsa-sha256 header.s=selector2 header.b=1H5O1FEA
Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11021142.outbound.protection.outlook.com [52.101.57.142]) by mx-outbound13-190.us-east-2a.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Wed, 25 Nov 2026 19:18:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IIvPb4SU6L/hxbkweGjWuCAFzX9f6PKqlI4eaF48Gdp4aro661CPpehSo0vzi/u7MWuyVhHq/t3g1I5eT8pRho7+9guA9KP3p26kDH5LrxJLr1ZH4wm/h0/laRnAjojV64vKwQ4GGssofEvEe3nNzMHQn/O5dNOMp3kGm678K8Rcp9zyLZikSh6Rb8ri8AHLOhyl/u0+rPxTTZRg/sTW0VsdT1uU+LFWRX030UFl7Paon32sMgJd4OknN5Fx7vwS5lnK+GUhGbSzmu7MnPbblXAV1z1T+Xck6/8S1+FciPdCKEVQnzAEtwv8urkxLFLN3vKG5vxCJd3qWajP1SgxDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Xb4FsNMsiaY0KRrqcjNtS6CKknCbvYV2/96NGaNSQ+Y=;
 b=GqsujVaCMczig47BMUa2YIM34BjKDRX3yUAMTn4cIySYrUzfHamy3y3roVu5fWPSC80vSbNrFTS9+G/PnaYyBg4b43QwYD9nj8wNI3lgA0y8RtUA6pMvp2cFXWplNCGro0HOc+oauKiKtAofsjaxrHDAcMMhhI2vw+r45RTPLqQfEPYSYkBPkrP9Ku2Ux7YIfbpaYr0hIZDxLI92dYyKCNA79ceZGbOjglg+y9U4nkkT6KnInLIwEBnQo6Vnp7lu6LwHw8DHUGqlKDTuRbLHM2cmqCighSuZ4n1qOb5bs+wc6cAOfGRI+WQ407OX6iOt0BXCmahd1bBZn0TyYVwteQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ddn.com; dmarc=pass action=none header.from=ddn.com; dkim=pass
 header.d=ddn.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xb4FsNMsiaY0KRrqcjNtS6CKknCbvYV2/96NGaNSQ+Y=;
 b=1H5O1FEAR8uBkJMsiCTobuEudlphSQFZvqXLw6tLsa/fUxBIeL2QYQdDOSfawW8t46W5YBdie6AN6F1HFc++REydb/5S5y3gYvCAoaIvPsxz9N0msSNkpxx13oXfHE4tm0ClhvTFXTyNSZfcnImK2oJuDrISVaqF0DKuU++sHpI=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=ddn.com;
Received: from SA1PR19MB5570.namprd19.prod.outlook.com (2603:10b6:806:236::11)
 by IA1PR19MB6323.namprd19.prod.outlook.com (2603:10b6:208:3e5::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.662.4; Wed, 25 Nov
 2026 19:18:08 +0000
Received: from SA1PR19MB5570.namprd19.prod.outlook.com
 ([fe80::6167:d6e1:2c7b:a9d0]) by SA1PR19MB5570.namprd19.prod.outlook.com
 ([fe80::6167:d6e1:2c7b:a9d0%5]) with mapi id 15.21.0639.012; Wed, 25 Nov 2026
 19:18:08 +0000
Date: Wed, 25 Nov 2026 20:17:49 +0100
From: Etienne AUJAMES <eaujames@ddn.com>
To: netdev-bot+sinfo@kernel.org
Cc: Tariq Toukan <tariqt@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Dragos Tatulea <dtatulea@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>, netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org, Feng Liu <feliu@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	COURRIER Guillaume <guillaume.courrier@cea.fr>
Subject: Re: [PATCH net] net/mlx5e: guard child PKEY channel stats lookup in
 rx path
Message-ID: <awc0XQWnUPz-nIxz@eaujamesFR0130>
References: <awcn1-LpcFgzRKgq@eaujamesFR0130>
 <179563126757.3294.7703649268548084983@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <179563126757.3294.7703649268548084983@kernel.org>
X-ClientProxiedBy: PA7P264CA0481.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:3dc::29) To SA1PR19MB5570.namprd19.prod.outlook.com
 (2603:10b6:806:236::11)
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR19MB5570:EE_|IA1PR19MB6323:EE_
X-MS-Office365-Filtering-Correlation-Id: 2da4e5ee-8e29-4a80-7ef9-08df4b28d6e7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|19092799006|7416014|376014|366016|23010399003|10070799003|6133799003|22082099003|18002099003|3023799007|4143699003|56012099006|11063799006|261026121527099003|261028144727099003|261022075727099003|261021121427099003|261022105027099003|261102123227099003|261026140227099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	YFKCg5toQklN6og3UrH1wlLs+6sxwrH/EfTf+NdqvFgMHPmMyRqIRf7IxwHi1DNztPch7ryEVZdIfwSI4NcviG+kbf5uk7vjG6RH3CarPNzrCBTWoCiC6VK09TRnt+03XH6EEks+EcCzNq2cjqD2QaW6+B6bbZze21A1cjwUZyDUXhgFyOl01wfzSi8nvfyGRsMgcpC0F3mz7enuAvQHXDMzvkBMAoDmLZFH89/5/7yhAO3EXzKq5W2G9Up5Ce2nC3SkmDFN7oBbN4lcsLmQ/YEej1gRcpEbmLJLNepwHhlcu/2xvZmQf2TH06ivxrU87CqfMMirp3P2JAIMiV95bg0R+qZ4NLRzVUO81RrJWhgaZ7J8CrJ+7EUet1i9/r2PPRQzciGVE04dct/eGiOjFDscZ7Et8JDkMeUpH4/3P54sVHLrf6eP/V9TYU3gFxSdNesWI6hDqNvP/ytxJN5TawN5quZ2GM00AecQMn5DLL12w34PvKLhIHW4h++hRoPdfHb7wHAuaY7i0Fe7xSDZSYZhWeEOh0ZwU4yi0/xo0aFItwHV3Zf2biAGVxN4DhadjaCaFkw6NsY/Y6xOJt5Dji5myKa9gufeMdgiYah2XXfOwbFpreg1Uli7aP/jcWSSoZGFeq3wT6OvRPzLbepQhb6WYr6oZDYufjEqCny2DPE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR19MB5570.namprd19.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(19092799006)(7416014)(376014)(366016)(23010399003)(10070799003)(6133799003)(22082099003)(18002099003)(3023799007)(4143699003)(56012099006)(11063799006)(261026121527099003)(261028144727099003)(261022075727099003)(261021121427099003)(261022105027099003)(261102123227099003)(261026140227099003)(10067099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?8/CUUAtK8Joy5aEn1gqwi8kF2Ei9+X6IzR+szopHkgGcpM3EmM8SLpEjDvU3?=
 =?us-ascii?Q?3JcfYmIyjhz6autB144UB4p8mWnibpJUMiPZ7VAuWx7zJIPPmX41qD+mvw4A?=
 =?us-ascii?Q?E1PwLLEwdbemLOvE0T4av7ezchrWTIWBExcX7ZXKHpIHgA/vZRQOWbyuNiLk?=
 =?us-ascii?Q?rBiHy1ibhIC6Qkp4tfuoikCfYv5WdgftPHtbdGzUUzTn7paUlEqiqPROkzdH?=
 =?us-ascii?Q?MtYJ7rVYFU0on4Tb6wNgPvB/vBV1PrviJzbyPFiRTPfxQwOhHnWDLzHhpr5h?=
 =?us-ascii?Q?jak/I2iTU2oGjwi/Ck5ltNNs7UremkH014Oct0OXY2kOhd204EO66nhpb+u2?=
 =?us-ascii?Q?wWXaXOSpX8x8kZNIg3lvHxf5buS0mzufEQt4DqNhCkR4O7s0KwDycN1C095i?=
 =?us-ascii?Q?JWhMPU2/UtqQo9mvRRifncB/dkloi3HrAgzGFdhu0iAXdo3r6NlqWETJJfmg?=
 =?us-ascii?Q?HKiCDwzak8wnB+TprFgc6Kz9CW0J/eT+8R8r4vfY0n/LI3ePb1lG3/YUtGw6?=
 =?us-ascii?Q?gFFFJMb33++Sx0+ZMBVsX2dPrUUbyliKf96vsVEwHPxNFbyO7P8oO1w1wbIX?=
 =?us-ascii?Q?5cJ/NXlor4bOwrOkVOwF8HWL2HSl+FDzt2q2fKI6pfIj8Mu4feALX9uAjBdi?=
 =?us-ascii?Q?T3d3CB+5TYB115jDjEDe+pHUgNSOrnRXvEXuIRgAerqzERKgd+oHG5BTidzd?=
 =?us-ascii?Q?4Di2nLHYz85u6kr9GGWyc8msWMzubXidvyB6c8aMCLtN7Gmb5ZvPMulfMZwr?=
 =?us-ascii?Q?oANz3MrrPL2UTv47jpS4q8Kl1D48pK7xNN/SpjYMZuZNaOakBiAIc4U+34gH?=
 =?us-ascii?Q?Cdb7KnyrbK+z3/Wky0+T40VNRcyRYCmsBX/sWbtApWiTvamqx7e/NW9r/z20?=
 =?us-ascii?Q?IhZn5qbjISzKQVzNp1q+oqjWdc4FG8qPYm9aDePftKBUqCU2lO/wT9mj+6W4?=
 =?us-ascii?Q?3f5iwMiWBWcW91uSQm/CC3V6XsgcK9c/e57nQNWHjRFJeSkuI1zsiNrjdYGP?=
 =?us-ascii?Q?RbFyVVCZIKjA30EhJvqEl5ELVQepgpZDg6wEQxYc6u1ZvjVT728E9DTfDRMS?=
 =?us-ascii?Q?8ja//ufjiLwKfg0FegItKWhTZB9OtKN6lqMqZQw6SFbTV/aoZM0/Oo5PWo8G?=
 =?us-ascii?Q?KGPIKDbW4rOsxkG95csstJCytnlDVNSvVQNyteJWxRPecs3p67Oe2+ZkLo5K?=
 =?us-ascii?Q?imjOuVV9VV3SU2UdrDX5tlHLZs/X5PcRqM/FqTd4HUJ1gnIXdvCYJJ8pK2I4?=
 =?us-ascii?Q?kMJUsGrQoD+SlXK4f2ZfExgiLi0tHDih0onAMGUcC9LUY3s45eDSWYrtwHJ4?=
 =?us-ascii?Q?1i6I+DPYNaNLW1mzJPlje3GK0YnQ1Y7hO9E2OO3rO+W9Pyo7Ka8FjFdkow6j?=
 =?us-ascii?Q?fbCf5F3ruYooNcxhUBaZSGXu5eJsnc6b3hGwuS/QYHISVvWfSqWSTthkaG51?=
 =?us-ascii?Q?l4qBoy7zf+cnND841Yp0vgWO9GgOGygQpzGhHzoKpIiur95cseu9B/A9WYT+?=
 =?us-ascii?Q?R/cIjKTgJv6mUGSlG9WNayuHtXSbvTW/+z9AGFMrEs+jntW/7022BkkCkTB2?=
 =?us-ascii?Q?NOFForEgM/ytRn6pdL12L21UWPayTp99YeEOH9hw6lhJdEKMIN8tHvsg3Y4+?=
 =?us-ascii?Q?C2u+js5UxwI3ucZUXAjuyLcEH7bwMexvwccGt4OPiJAHmLMw9aDfxA9OZaw4?=
 =?us-ascii?Q?pQkA7AQNogRD2pdRgASkfDh3OLB7k17mYvNwKGyTQZ+Xt2JZWe6dl9fAArJ7?=
 =?us-ascii?Q?4DjDZqY637qhTVJ6h8uScxSnOs6gZOb+xuPAKqmIe/GlMAyHKg6l?=
X-Exchange-RoutingPolicyChecked:
	aLirdyUfmXfNr3V0ZZsbHE3QepNFUDDFPGdWwnMijCwWwTVlPYM/aDTxunMEqszSvgMpGW4F6PqUQDL4rdewqkl6n0Gos9SJbTHRd7UI+n5FILpRhn5oNHPA6BzHASZZvVeXDi+S+4M+WnAPuDhLGQcnVG+Lm0U75hxT5iOVaWIS1nI/xavbCueE/QY+HsCAIhrpeRoDvJ5O33WrAyHnZ85TmjpPAlZwCbBBDq2R2HpnGIL19fsWzRf2OTv65IMss4EGe717BkQePeSZMQyV+/bJvOkKo4X/2LzHhlH+/iV6xHEo+/xwPmYF0xcjpaKEsyfBgTEhqd+2Ni5X8moU5A==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	BFmE83Yp6SKYXV6XbwLOX8Phn/mtepwci9agEGfTl3U7rGhneh2SPbTanjxAC8uWtRAv38ZXG6Ky8tdpnYcGKd+ujFZzIE3bUhVZpY/5I01KIYSkyG4zf5GEtK1xfVPArOpUtlT7+HwcisQlzfpAOK7d7M9RA1BqwxdVsF9O+sfwu4Jiv0oWvD5LMdKpALmIEl3rcDY19K0rpO5AH2IS8ekvdYdhvxnEA0oTniGCGGYsyppL2CLD00wLTqVAvvaD3G1cTw03vCq2E4FzeUvoQAbdLdvTT4QMutyDJI7AEBr3H9bFWIh0gnSKLY/CZL2qs3xjPIgpusfRMikRNbZiTBlDpPws3joBwihw6pfJtZxUp3Te2PpQJoqqEpqS+ai3CrgLV7AlDb0yRU1z2uqemSmrxDxoE3+seuSkRMsVYvVcbZfzoo8sW9cdHcVgkXyCBbgbWdPXUe/lCBKI1WWPTEkuBOUB2y6rU5KZmRwHds0DN7BzGdsxe/n5xVWFRX353EtOJQ24cSt8K8609H37ZyNUTk8RwAw1iVhvo5CjCZjlRGHX3tSerSCw9oXuhwTRmAreKLPaT1jtD7wGTud8pcbHPCLYd/NL4iMY6PoiDXZm+R4jfS+yu09gZxuL347nPQFVNhHPWDD6fV84j6cTrQ==
X-OriginatorOrg: ddn.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2da4e5ee-8e29-4a80-7ef9-08df4b28d6e7
X-MS-Exchange-CrossTenant-AuthSource: SA1PR19MB5570.namprd19.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2026 19:18:08.7745
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JL1DAVfuNuaKJsjWXdadEB4bdKaQAgEndCyi4SwPIMkq2xt+BVAn5kVD3QAQS4II3lyRjbxa3fcnOpT6OkBfnw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR19MB6323
X-BESS-ID: 1795634291-103518-7647-16769-1
X-BESS-VER: 2019.1_20261116.1548
X-BESS-Apparent-Source-IP: 52.101.57.142
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVoYmhqZAVgZQ0MQ4Jck8zSLR1N
	LEPNnCwsjA0sQkyTTVMM3MyCzN1CJJqTYWANyrmjVBAAAA
X-BESS-Outbound-Spam-Score: 0.00
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.277842 [from 
	cloudscan15-242.us-east-2a.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.00 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_BESS_OUTBOUND
X-BESS-BRTS-Status:1

On 25/11/26, netdev-bot+sinfo@kernel.org wrote:
>  - How the issue was discovered, e.g. hit in production, hit during
>    development, syzbot report, manual code inspection, LLM or static
>    analysis tool scan.
This was hit in production with MOFED 24.10 on RHEL8.10 with an
ConnectX6 hardware.

>  - Whether the issue was actually triggered, or is only theoretical
>    (e.g. found by LLM and not proven at runtime). If it was triggered
>    please include the symptoms, like the stack trace or kernel messages.
The crash occurred at network startup on node reboot, reproducing in
roughly 90% of attempts. Crash analysis indicated that it was
triggered by a BFD protocol message received on the child interface
(the node hosts the "bird" routing daemon).
ibdump captures show BFD packets arriving at about 625 packets/s
(1.6 ms interval) on that child interface (PKey).

>  - What hardware the change was tested on. For driver fixes please
>    mention the device (and if relevant firmware version) used for
>    testing, or say that the change was not tested on real hardware.
Replacing the network card did not resolve the issue.
After downgrading MOFED to 5.8, the crash could no longer be
reproduced.
The patch itself was validated directly on the node with a MOFED 24.10
build containing the 5a799714e8 backport ("net/mlx5e: Fix publication
race for priv->channel_stats[]") and this fix.

Thanks,

Etienne
