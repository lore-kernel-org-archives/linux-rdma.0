Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.222.82.124
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795631108;
	b=lCs8SjkwgxXQtoi473iIZky9Iqi8OjwBcOEZtGcqNYo7OaOd2Tszv9Fh/Db5aWrGyktS
	 f2SeojiwWx4TXocGQC9u2v2wn2c+Etd4mEqMLliqQFLB3mSA/31qxwD+am+4KUYxjLFJw
	 DEp3jq8syCk01qU7x2SmZr3WPfKhiRXFI+eGhXmRLq+DX6omVh9jZBK17x1Wf9ilYZRF7
	 X69Xstg2Imzay/y3Tnixx7lSUF3niuG5LtzuLbSAP0OvmF/ILxNrxFE4i9v1NPyyhxVAL
	 Nwoy9tiL/8zP8arvrLh6ePVD0oJZeStvnGi+Cp9BPawN97Yu10Xbju9gaqEG0w9R+Zw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795631108;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Date:From:To:
	 Cc:Subject:Message-ID:Content-Type:Content-Disposition:
	 X-ClientProxiedBy:MIME-Version:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:
	 X-MS-Exchange-AntiSpam-MessageData-1:X-Exchange-RoutingPolicyChecked:
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
	bh=i6Io6fjmF6Ww31gIoq9BBLfpxA3y7wmDDvVyhZL8qUU=;
	b=z32bWbDI9NDFBfVZv+gtIf6zSPsAfVsADtHdVAGAZcwrJ3k/YZuObXpJdL95lN5ygYX0
	 DZq/CjJ0qHPm5bL7aiRa9U68rHy2oC5npKmw91Q6e7950L58vyCEZEzWaGWmbltU1o+8Q
	 VQoMLPu0tKBHTm57J9E9Fmc9sgRiXGosH3W3/9nOTiB+t9JH8DdSkP2WDJvYTIoBfV2mo
	 p+WcQhE6JXXWaTxJuUMIXvTA1U6f/25QHZVYAX3jvp640P5PjUGO59pD4KXYbPQGnJeJr
	 DaUX2bPgsmQA9JROUyoBtSUpHs71tkVBdJhaPeQtPD5CagehFHXiRd2lSF5bHAMqPWg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=ddn.com;
	spf=pass smtp.mailfrom=ddn.com;
	dkim=pass header.d=ddn.com header.i=@ddn.com header.a=rsa-sha256 header.s=selector2 header.b=AYXi27uF;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.222.82.124
Received: from outbound-ip191b.ess.barracuda.com (outbound-ip191b.ess.barracuda.com [209.222.82.124])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5F4E606A335;
	Wed, 25 Nov 2026 18:24:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B5F4E606A335
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=ddn.com header.i=@ddn.com header.a=rsa-sha256 header.s=selector2 header.b=AYXi27uF
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11020103.outbound.protection.outlook.com [52.101.46.103]) by mx-outbound17-239.us-east-2b.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Wed, 25 Nov 2026 18:24:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dx6aHcpM5dnR3esPNfR/TlX38aMVgGcYyzrpgtGtwg+xmpyGHKlZYaUiKeHuit84EjqFoQgICSwTJw+jbLdgO/TTpJnoSFQN3w149zpetlo+FzocXn7fqDFzoiOPTb0MWp0xDyc4QDERSk6tAhLDV7SygE9zXYVF/NInGy/ZgOIqMpWW/ragHD13quyBWDtYO/SqebdrQrCeqrS1NBTRkRPSEh/4WLADSbiM6lV1IBxH1H6J+siPWxd3rnJXzyhlN7qChoAmlIcu54FINbe9Wp6So+htR3oQ4hnTBaBG0VBLqFhRtmHhCnbzRH7K9apTR2jNE6y7tgJg0jL94PqoiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i6Io6fjmF6Ww31gIoq9BBLfpxA3y7wmDDvVyhZL8qUU=;
 b=Z0W59MVp9xM7wakw7hGjtLi5cpvUc6Pc2h0f99d3kmJ69Im4Cn1VLsl65mAdk2adnFxQxFe7bFUinCnB7GcYeT+qMXECDHbYCMMjRkoUWfVxs2FjKVEHgwfEylZ2xkDc9cW6O95UTi/sWoqjmnfX4+kjByG4xAbjkzJwAiuDuz8Wte1S0VnP598mdq0sm8LwNnK4yES9z5UoMp+peGebKiF1pQ2qYwTB6FmifvCw8QRAw4BpbD6lr2+1kx08DV9uHmeIHf6HCJwCIuOJ1cHkCYhZe5iIh7Iqn354kJbHTJEFOQMzJ+RcSRK1E7zlySLt/qBBanoQTEpH2avbRNm0Hw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ddn.com; dmarc=pass action=none header.from=ddn.com; dkim=pass
 header.d=ddn.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i6Io6fjmF6Ww31gIoq9BBLfpxA3y7wmDDvVyhZL8qUU=;
 b=AYXi27uF9T0yisK/LiZVbgkWgx7KH7thuU6beMIU2UiB8KSFeAuyr9LMwqBJaBQHkTpqex0hDpKwjLXqzdU4o1mcIxmyKcvJrL5sjbcXpdQ/3A+2IK2X+SWSD64noRoQ7BaniRk0L5LaDMpfjaZ8q6Pxd0abrD0d/EwE5H9LE/s=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=ddn.com;
Received: from SA1PR19MB5570.namprd19.prod.outlook.com (2603:10b6:806:236::11)
 by SJ2PR19MB8228.namprd19.prod.outlook.com (2603:10b6:a03:55d::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.662.6; Wed, 25 Nov
 2026 18:24:30 +0000
Received: from SA1PR19MB5570.namprd19.prod.outlook.com
 ([fe80::6167:d6e1:2c7b:a9d0]) by SA1PR19MB5570.namprd19.prod.outlook.com
 ([fe80::6167:d6e1:2c7b:a9d0%5]) with mapi id 15.21.0639.012; Wed, 25 Nov 2026
 18:24:29 +0000
Date: Wed, 25 Nov 2026 19:24:23 +0100
From: Etienne AUJAMES <eaujames@ddn.com>
To: Tariq Toukan <tariqt@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Dragos Tatulea <dtatulea@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
	Feng Liu <feliu@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	COURRIER Guillaume <guillaume.courrier@cea.fr>
Subject: [PATCH net] net/mlx5e: guard child PKEY channel stats lookup in rx
 path
Message-ID: <awcn1-LpcFgzRKgq@eaujamesFR0130>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-ClientProxiedBy: PR3P195CA0014.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:102:b6::19) To SA1PR19MB5570.namprd19.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA1PR19MB5570:EE_|SJ2PR19MB8228:EE_
X-MS-Office365-Filtering-Correlation-Id: e3c542b9-3abb-40ea-89b4-08df4b215835
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|1800799024|7416014|376014|10070799003|19092799006|10067099003|11063799006|56012099006|261021121427099003|261021123027099003|261009223027099003|261102123227099003|261022105027099003|261028144727099003|261026140227099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	FCfqTcQ0tp2PrpUj+gfHtwUznnpMfZrVBh4v/RZEGhnt9ga/8om30ZJXGZhNgluFRaxT3em+j5PB/E9/JU5kGjeKFkwn7Kcgy6ebXk7t0oR4QLGZpID+P9d5fbgQdXbod2WKBlRpW8GMeyT7HXgdYQT9T5o1Xr+ikaRsodBw3RkozkzPyQzY5aQxMzeg1fn173S2lhqdxpASPGDliTllDDAG5S8kRF5j/ffsTlzXAqw4Lw6GqyG0MyQG3vQf+JtsipLhJgajPteMG4+pDSaFP5/aDoCFGWMz5D47Az+rBcNZoXPouKHbB/FYopuAu4n0tFaEATrvA3tpRnV7y3icDAi4qcbYP0l8AGWwQ3/nd5i3e+U52O52eFaBi9xJT55A0alUhJObpHp2lvaTZkZiF2MmolsDnRrrVPBiJvsgXQwo8l02JViozx+RmuOnGnfBrQeiB9YWSHRLoq5izJ4Is2EacqrazhHZGCassj5ecFUZhN7GPLi5dDSgyI3BRx2PnZhH6GOnAd2lq1cb8DmYH/w5MRbJsFLgOcjYjBIUyDSz4L94u9v2fC8Q9N0Tr/12L0i+4cs78jL15i2lttWDAqCRS7FHILfxz/W1WuU6DI3QCF2bEI0UkqYIPWRWuF+AE0HNfwdNG7uMPVJK/Gc+m8eOcdpfuUQfaBRLKju05jw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR19MB5570.namprd19.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(7416014)(376014)(10070799003)(19092799006)(10067099003)(11063799006)(56012099006)(261021121427099003)(261021123027099003)(261009223027099003)(261102123227099003)(261022105027099003)(261028144727099003)(261026140227099003)(18002099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?QUdJkVS2Becjcjb9GHTdqrQx1C9AgWifPz19SpxHeAyifi+7auCKjVEthEvb?=
 =?us-ascii?Q?FGm99j/4FncXNMyofXW0JLlqqXMd/3UWv2RDMHUccjzpNSsnqCH/hE+2cowW?=
 =?us-ascii?Q?bnan4gUyAdKpD+Y2V+cvxanJ4qSZVWMPQq+KwZxuOJ7DxmfFvqJewk5k/ttL?=
 =?us-ascii?Q?CJvkqGTZuJS8h2K6QytpR8zc7XImaLONHgYn9xt9Yb6uhF7T803LKgTciM5Q?=
 =?us-ascii?Q?rTlUwdiLMOqXmo+AdsMVxe7Y82aDKdDBRjuWtLJuWRMY8AyvMgGTdcnm1ZuT?=
 =?us-ascii?Q?YzVQkTiqV5xRDecZO84RzaksmDQKC5ld4uFjLHu9tDgVZk/RUSlXvpRMS0Nw?=
 =?us-ascii?Q?WXidd8YuQV0BX+wGkmyHlJ6l28quLyDwZ14dt/8wsDMydSliTr6tbBsZi/XC?=
 =?us-ascii?Q?eydgBgkWdVykhCtBWKxAK3V6CCWSTz98RjqTjWcwPgqX7LhjZ1W9DrY9qQrx?=
 =?us-ascii?Q?FXUkqHZcl9Jffj3NtEtTJqmrIhG7s5t2Fxz933g4DHm0BmdqcL3mzQiwIHiJ?=
 =?us-ascii?Q?Nvycw05SJjP9m+EknxujnuuXxfCvw+bBRc/UMSRCRu9vjcuULudJ/3RVlfah?=
 =?us-ascii?Q?fQrPrkWgoy2TT6oFhUO7K0buY0gNkRfrJTe6b2Z7dQ7lKtoJfPspvjWTVfGe?=
 =?us-ascii?Q?RFoPvMCsEr0c4Z/owz6JbLywJTaFycoO5j4+QVrurrVPIwzlM9e/gDanj3ah?=
 =?us-ascii?Q?GY4BSD7MiRNyzA+lbABDyp3IYigGzMNFxDCCv5SFEG6DV/j3kVuJyl5VIN37?=
 =?us-ascii?Q?XrCineFinGvyjESzTnewP2teKUQDSlx5FR6MWMBiU70bL/JaELkLmR3raq5j?=
 =?us-ascii?Q?7QuvMMVMFfEiwuqX3CbBnLPL8sONBk4IahvLBmd8um/bt2KxCUB8nNmLUE4Y?=
 =?us-ascii?Q?orQqed4iShBqqV32riwLr+itLZNT7GlzX+ByqMogItY231Crl+j2Aa+HZd31?=
 =?us-ascii?Q?8wGGjMz9/Byz6dG9O768ZQ4SZPkykRztYF7rCdzIWffbpDUc2vidfsdr35m2?=
 =?us-ascii?Q?XnpqzSEpZJ763soxv/Da62jPqLacLrS68p5wxLf1NoHq31TwsJPjrf/7mobN?=
 =?us-ascii?Q?zb9AYneMqn2NP9WlIZ1J+yrYAXvVSYr146oqwy2hKuREO+LRUm0VzAIg78go?=
 =?us-ascii?Q?m+2w1JH92mBoEdaprDndhsRZai4rTHTTXiQTyFV1v45RgkmYPsFddkDM2slP?=
 =?us-ascii?Q?bwGo7ii05ePE9MawoSywJAkQ1QB50tgnOFKlAsj0rffxJQCfbX5sMTj7YjBm?=
 =?us-ascii?Q?G8vlZVgNe3s7XaQe8TpzOQoojmGHbIFQD+m32vHowtk517aLsESUoH7UVNFv?=
 =?us-ascii?Q?VKckH0VsXlnI68J+Kp2QXk+BQgS0H3mUpsfvsMZ8L9vwehXZat1eJW56wNLI?=
 =?us-ascii?Q?xtVWSAFNvlkc0rAyzIJBXTHUxNZO6FP3x7xhxNkGQwzorM6I8TY1UPqYwNDK?=
 =?us-ascii?Q?fTsFEVs5mcjTEHNCyTIagROI1vJWop848l2USef++PCkeSsSEYOWRZcj5Lup?=
 =?us-ascii?Q?ufZvY50ZMlQic9/zg3Q6MsEQHt5b3YRKm64yZ5qrGqZIDYNfNo8/ulr/mFOA?=
 =?us-ascii?Q?0kYzUomMmoR5eeUaMUeYcwWZVuLUpykAn60y/c1LiZSvy/8FjQybjxerJVxs?=
 =?us-ascii?Q?QQ2RVL4Ffud5JSbGyNtWBSlWhOOvWDOHLZDMMWvXx4IBchKUUftsu6yw1EIp?=
 =?us-ascii?Q?MRxnW84LuUlN2U8KnQwT4iyLcOLMTpmI/qKng+GY6h6OOUZT5ndfsIhGkKXP?=
 =?us-ascii?Q?Be1rZ4Egdwzyy48TYtjuBrqBZ+83u1MAHSYt+6uLTwZxYZrY7wA5q0JfEir/?=
X-MS-Exchange-AntiSpam-MessageData-1: Y0r2Ba97mPRc/w==
X-Exchange-RoutingPolicyChecked:
	D+CIvAR96e01zMDuwEOXr0esm9L1HJyfQU5XdVLMf7luu0sgPKlJCS1XCysd+D0+Hf8XJFj7eSEh/2AlgglHPOj/0wqunaqvBS+bZBYNlHF+9k223lv9CAGWJ7nBNe0LFLRCRcMxKE5tQus0gddUfPg6h5SRBfd6c9vZdmOdFOaYMF7z1InG80yM8WqeqgJFgRsSGrjG/zLIVbxXELyX4zpFbX4/69N1Vc+WMCWAywyJHsVAGTWG1dIbxP8qbtzThbyDqMMiGWXE8dD2WiYUJh+yoG9QcAihrUi5qNhytXGt2LxaQBHfOx93k4Az0EJJgUrzEz9FxJgoSmWBlX9Qxg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	70qeefRhj5lBhmXZkEuiQ6bWcEg8HbhFMj/bwfoknrQEFBLG5+8cFUhUNG45QtFMdagwglvsjyYQChCgt7Gpgy6aYZC+m1DgiWnAdimv8ebvhgotYeGXOxq+kVoTSTmEW3ce161zc2zIgoZ9v/rouFUrK976aUnXjKtsKImMqSkVDrQ72K0YN52+FD07k8x1wUYegvOdR2rOLs/do8ctiOjT9PU5k3x898H9djoJe+mgWrZqO96rBGFv0HPCSUa35YHBMd64Lty4yXbZeSXjc7frdft7tU6b43Gmz8sY4/CAe3HCeg5hBNlpU4IYDl4ir4MzfqI2H8UKEGMzLTWIu5pXLfSykPklzn4XyMQc/QCuvTACgipyuG1sFFU+Cn4a/CZifp3hpPh2Fpov/SKNho3VDV1l9pSYyDnGMtH9ENT+lhNfN8D+gMBTivJmhUzFznjLvdlsuF+ksAoR8VcoyotYsaSZg37m2oR6sZduaPd87hjr3f9jvOIzCcbIKnF41KTwAxO+Y56NeFw41ScG/Mp8fA1T5ztnEoV38f0+d7MuaNioEzHQ9oFZXYHifxWqzodk1z6xl1xRfuSxPHyKTa87f2cIOCJaHB1ZWFOm/r8zHUC3ki6LcsVFn1u1MIQqBoqJCvg+aIK11QZqPafPnw==
X-OriginatorOrg: ddn.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e3c542b9-3abb-40ea-89b4-08df4b215835
X-MS-Exchange-CrossTenant-AuthSource: SA1PR19MB5570.namprd19.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2026 18:24:29.7238
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: euvXF353DReoQVzITyrHjr9gCF5U+zeXThOiPZbfkZMBM5yHMYZ7B5ITkD9mHIGi80ivqJc2t3wkOiKCYN4IEg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR19MB8228
X-BESS-ID: 1795631077-104591-7682-766-1
X-BESS-VER: 2019.1_20261116.1548
X-BESS-Apparent-Source-IP: 52.101.46.103
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVkaWJiZAVgZQ0NTYzNDcIjnVJC
	0lJSUtycAk0czS0NjU3NIy0dLM0CJNqTYWADEBiI9BAAAA
X-BESS-Outbound-Spam-Score: 0.00
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.277841 [from 
	cloudscan8-156.us-east-2a.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.00 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_BESS_OUTBOUND
X-BESS-BRTS-Status:1

mlx5i_complete_rx_cqe() uses the parent's rq->ix to index the child
PKEY priv's channel_stats[]. The child only populates entries for its
own channels, so on a parent channel with a higher index the entry is
NULL and the stat accounting crashes.

The race occurs between mlx5i_complete_rx_cqe() and mlx5i_pkey_open()
(bringing the PKEY interface up). Once the QPN is registered in
hardware by mlx5_fs_add_rx_underlay_qpn(), packets for the PKEY can
be received before all the channel_stats entries are allocated.

Look the entry up through a new mlx5e_channel_stats_get() helper that
checks ix against mlx5e_stats_nch_read(). This is safe because
mlx5e_channel_stats_alloc() allocates entries in order and
stats_nch is published with smp_store_release() after the entry is
stored, so every ix < stats_nch is non-NULL (paired with the acquire
in mlx5e_stats_nch_read()).

Fall back to the parent's rq->stats when the child has no entry for that
index. The fallback runs in the same parent NAPI context, so it adds no
new data race.

Fixes: b5e23931c45a ("net/mlx5e: IPoIB, Fix child PKEY interface stats on rx path")
Signed-off-by: Etienne AUJAMES <eaujames@ddn.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h    | 10 ++++++++++
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c |  4 +++-
 2 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index a3945195f454..478fea5bfc69 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -998,6 +998,16 @@ static inline void mlx5e_stats_nch_write(struct mlx5e_priv *priv, u16 n)
 	smp_store_release(&priv->stats_nch, n);
 }
 
+static inline
+struct mlx5e_channel_stats *mlx5e_channel_stats_get(struct mlx5e_priv *priv,
+						    int channel)
+{
+	if (channel >= mlx5e_stats_nch_read(priv))
+		return NULL;
+
+	return priv->channel_stats[channel];
+}
+
 struct mlx5e_dev {
 	struct net_device *netdev;
 	struct devlink_port dl_port;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 1586cb2404c0..5f2347672cf3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -2529,6 +2529,7 @@ static inline void mlx5i_complete_rx_cqe(struct mlx5e_rq *rq,
 					 u32 cqe_bcnt,
 					 struct sk_buff *skb)
 {
+	struct mlx5e_channel_stats *channel_stats;
 	struct mlx5e_rq_stats *stats;
 	struct net_device *netdev;
 	struct mlx5e_priv *priv;
@@ -2552,7 +2553,8 @@ static inline void mlx5i_complete_rx_cqe(struct mlx5e_rq *rq,
 	}
 
 	priv = mlx5i_epriv(netdev);
-	stats = &priv->channel_stats[rq->ix]->rq;
+	channel_stats = mlx5e_channel_stats_get(priv, rq->ix);
+	stats = likely(channel_stats) ? &channel_stats->rq : rq->stats;
 
 	flags_rqpn = be32_to_cpu(cqe->flags_rqpn);
 	g = (flags_rqpn >> 28) & 3;
-- 
2.56.1

