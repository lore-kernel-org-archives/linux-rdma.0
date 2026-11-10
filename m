Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.195.41
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794282333;
	b=REt/QMKd51Qw1ELuB1+25W0KRHYwmhh/dqr9sZscUJmzr+pv1xLbZnFSo0RNbwi6pEFp
	 lk83dWIlbJ5FTpVpfZHSxcneFjqb7oUpU2BwUUOUrVG2oc9LWwd2lCB5MoyRUW4lJdFfg
	 aBg4p4jZSnvBAmIW+ZwqjLbTZXW/1bby6VZ+f7grH3tEL7wN7b9wu4+j8eSt3oBXl8nFD
	 U4zygRGYOFkmTuPjOItJPqw3LUobBkd+o83fF3CzZoL9LdzrQzjOsIDkPw8BFy6byu332
	 xH3HfkIJtKz2qmF4kOWKx+utaN975tWPJgE1dKFZAFjcpMRKTsWC/DNCpMU6QAaTBuw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794282333;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Message-ID:Date:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-ClientProxiedBy:MIME-Version:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=Vcr3ANOqh4FnTgIC9l1Ac9wOKY5jyL63BGveL3W0hyY=;
	b=dCMdAKMdIwmQJEG1ySnSQRk3sJuQv7s0iek++qFtLJKclc5d6fSJHOxZsAbuJP43xnr7
	 SU+YhALfXv346KgCghL+M/5cIjNd9xrNV1cJo0TGrtcbHIX9vKlUOOwtt4MaIbR5FpZGS
	 vnOiXl98v790SWqDdpD5FQ8OKyY8we457JEVFqPNXj696hL9VSH6i5nNFMxhFmXW//M1y
	 TVBrQMn0t9/f5p7yr/pVYdwbvgkkc36T2fE2wihHj6qlsByaT1RZhlbj861WbxGnTjBVO
	 Oyqumt76VDbJt8R7qtZ2gQxfzfhCXFJIpCh7rBi1hckLmlgBcve2JlWWgR83m6B1Yrw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b="p2nCGy/c";
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.195.41
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012041.outbound.protection.outlook.com [40.93.195.41])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B44D606A31C;
	Tue, 10 Nov 2026 03:45:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6B44D606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=p2nCGy/c
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=a3ZZsFcRj5PLXZ38/syzfvSeLmNbQSiEG/Eq7/BgnNl2zMr441dpfuqoc1kKm3hKPM7uCerZNSurw2zAW59MWkeHspvxQMrAoJ4skIq8h2xv4kGNniS9QfSUV2C0qoQvzKv0hRTC37zc78ukQObTc+Uoq4lvDoR9ZPhClJs6N43F2LQaVcc5gX1o8FSee2QDu8ktwe2xRlMeLh7tHElNVHOh7FUg+c0/4ntznI7DhO4HlLBomSwVfYE+K5lyM1w6//+aAxD2DwrxgFgI9dM0q9zzPLzBWkxZnJwIQIrq5uMmFFihILs7uJ/FhyS25n0yS0g9Of2m6FOOVh9px6ZD/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Vcr3ANOqh4FnTgIC9l1Ac9wOKY5jyL63BGveL3W0hyY=;
 b=dOGTDGMJ0zGTyja1pM/g/XerucpKaDaBuaR8xqnosiq9nWSwOY55H56NJd1IiAll3q8LHYmkJDU5bXF7u8c1+QhbO4CV54ErwyKcY2l+5f9diThF855NPEEg7tovh64GxxOLfrsJJ9exKaFAB/+TM1kHleMSikMDbAKERGeSZQgc2+xXXT9ko76kYgRjqsMc/VLb2fd3XjZvtfuo4mDDaaTODVGsGDnB0BKKSyxuWKxT+kFLOZIAYO25Wm09QYp9XbmL/7VAgXSbtXTQzdlGljeHLDKJ1NF2JJBPVGysCfgt90e7H5+6hwrpAoX8CjHtmVzVfmjRTHE4tNwKWWVI6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vcr3ANOqh4FnTgIC9l1Ac9wOKY5jyL63BGveL3W0hyY=;
 b=p2nCGy/cDX5r+6Vx6VCuesweAlVRc2KOiGjAxkeWaEOQ291Ay62B5sB5hKdHUak1IYXM0E92XtuB4dS1he8epmu+Y+ZlxC7XJmxP4fJ1M3mqvjy1UVotX5TqrxrL4lHTTpW9mT+j1FqiKDgcgw9z5A1YRsgxqmUOgprjWW/0O+nDyUgYPuWCdznBMKxmQ/vqQcopENzFPvgcydx5oypwUDlFOfIBwxXd6fq/QmB6uwmIR8Bg37d8EZxs7UuEQ9HTA+GgzJU7Ll+1AamAj8fnvA/bNdrWe6htl7/CkM0ai2Ix+NzPVfvF2C71fxOuVonxwDlJ1jB+ONHXtge2F3K11g==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SAVPR12MB999143.namprd12.prod.outlook.com
 (2603:10b6:806:4e5::21) by CC6PR12MB283837.namprd12.prod.outlook.com
 (2603:10b6:170:209::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.13; Tue, 10 Nov
 2026 03:45:28 +0000
Received: from SAVPR12MB999143.namprd12.prod.outlook.com
 ([fe80::219e:6553:2ec0:3761]) by SAVPR12MB999143.namprd12.prod.outlook.com
 ([fe80::219e:6553:2ec0:3761%4]) with mapi id 15.21.0592.012; Tue, 10 Nov 2026
 03:45:28 +0000
Message-ID: <b1bd7ac1-be7c-4582-96aa-b9e982921c37@nvidia.com>
Date: Tue, 10 Nov 2026 11:45:21 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] net/mlx5e: TC, release meter if rule offload fails
To: netdev-bot+sashiko@kernel.org, vulab@iscas.ac.cn
Cc: saeedm@nvidia.com, tariqt@nvidia.com, mbloch@nvidia.com, leon@kernel.org,
 andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
 linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
References: <20261103102856.1340672-1-vulab@iscas.ac.cn>
 <179405671897.994134.13525993179862980932@kernel.org>
Content-Language: en-US
From: Jianbo Liu <jianbol@nvidia.com>
In-Reply-To: <179405671897.994134.13525993179862980932@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI2PR04CA0008.apcprd04.prod.outlook.com
 (2603:1096:4:197::20) To SAVPR12MB999143.namprd12.prod.outlook.com
 (2603:10b6:806:4e5::21)
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
X-MS-TrafficTypeDiagnostic: SAVPR12MB999143:EE_|CC6PR12MB283837:EE_
X-MS-Office365-Filtering-Correlation-Id: c9743fbf-d5da-4b61-0cd2-08df3edd0fe4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|23010399003|376014|7416014|18002099003|22082099003|10067099003|4143699003|11063799006|56012099006|261028144727099003|261022105027099003|261021123027099003|261026121527099003|261026140227099003|261009223027099003;
X-Microsoft-Antispam-Message-Info:
	q+ICFfJVb1JAd8r//hIw4FqAaSCJHEXCLxRIIhfmKkxJk+nn0rnmdlphrESyF7k96Lbw/+E0kjPicmqkiLEWqinh/Dirk2wlj6ZTy+h6XX/kHQKoRNaLLF/N/yect9fMMBflydW/S2ObQLXbZ8bTTqug7sQP3QVuvM7Zxms4GR89usXnCTVNqFBP7nIWa0MrNju1am3IXxi4lfcfC4TiA1l3i1SVypydVMYTLQqY9cDFZuJBtuzpL/a+cc16mhX9RnBIScmbBWn0MuOSuPeiJFPTSaLDTQmZILoMzccK82ouSSZt2WZAgU53Pc8Y2qh2EO+MzOXGclA61iV/ZyyAiI0q1uOMudVgHE2v49UiN6+BbV2h/NaXoqEZ3Qo64iNT/yAgujy1ja1qDQH74VJu3asy3v17BTCFTsj6dk5F9H4AMAhHWoCADRHqNRN9eq1XzfCZpCKvkH1Cr6nya2nlRv1hHeibcZm0H7dLU0Ld32Jia8UhNLcy30rhXYhKo8U8X6R4akigLhgLoZMV3ymwA2zdMuGm2lVWrrOfMa/xAwP38sbClrnd6DooV4QHNsOX/ZStxyQOnFn8PbWB7+6kcKmTqIBPljwUfgljsvNebyMIU+6aG+JdKJobU/kAW8c25xshTiDnk1aOv9GOpAZqss6L7qq4G3iU0h0eETPVJQo=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SAVPR12MB999143.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(376014)(7416014)(18002099003)(22082099003)(10067099003)(4143699003)(11063799006)(56012099006)(261028144727099003)(261022105027099003)(261021123027099003)(261026121527099003)(261026140227099003)(261009223027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QVlNVFpGTk0xdlR6Vy95alRrdE1vVERQNWo1ZFg5Si9PeHZiTXQrc0U0UG9R?=
 =?utf-8?B?TzAwT3RnY2IzRG9TZDlJYnAvUXlQd2FJZURpMVlFT29jZ0NtSGFuMVpXMTJ4?=
 =?utf-8?B?a1UyMG53c0NRSGtYbk10WVpQWWRBcHN1SU01aWt1a0lLOFdMS1FidUlhTGFI?=
 =?utf-8?B?eUJaYXc5RURIU3R3NHI1L0wvbzBzd1BodEFMZmdpeFhTT3d1bUVuVW1EUzZY?=
 =?utf-8?B?dXpFTkdoVzhYTjBZYjNLUmtYTEhONklqSUEyckZxTVdwbis5SE5iZmRkTlc3?=
 =?utf-8?B?YzdGQnFpY05Rb0kvTHg5WnRCNFVZSzNwYTZSek82Lzh5dWMzYy9mVDU4d28x?=
 =?utf-8?B?WTdFL3hxYTZYSksySWJzdEF2UDVTQUxjL1V1R3lRSVV0b1VYTEdFcVdjejlR?=
 =?utf-8?B?OEZjQW5mZlFLUE5jbURCYXZLemIrMjBSQWxnQ094WFhIZ0NSa1c2aGJvYjBI?=
 =?utf-8?B?VlBOd3prdFA5VnpTTnBrSVNQQXJ6a3U4Z2ZLMkxNUk5qUnJpbDRaSThYMUs2?=
 =?utf-8?B?cXhGL3QvYXA1M3FjV2owZW9nUkdlaTErY3RBdU4xZmNhMWsyOGVEc1h6M1Z3?=
 =?utf-8?B?L056dGZKa2tRbjg3K1RuRHBOV3k0eDl5R3ZEc3kxcDBML2JySmV5T1BvMzFD?=
 =?utf-8?B?TWk3SUpxUWtrcEhZaFJFMi8zMTFUN29NV0plODJxNm1yZU9DaUovNmNyZG9G?=
 =?utf-8?B?cWUranYxUm0rUlRnU21LNlpkRGNnNm1SQUVUQlAwUjh5RlNPY2tFeSt1ZGVx?=
 =?utf-8?B?ejdKRU9iVlhqT0tFTm1NNkwyNVFTVkNOYlR2ZjV0RU5HUGlnMUlTRG5zaUhV?=
 =?utf-8?B?UGgxZ1hJOXpYNkI3NXFtM2VJWGl2c1JibG5ObmhjZnQxd21PWEhqWUZzZklE?=
 =?utf-8?B?a3JFWVVpSTBQa0lhdWlGUzlScnk3dkRSclhscXRLbkVSbi84NjN2RzFKY1dJ?=
 =?utf-8?B?bmRvMUl3ZUZMcHNaaXhuZ252bTZOWU5PaWo4dTZsVTdGdVRjRDlaQldUYzRH?=
 =?utf-8?B?Nk1Hc0V4MnVPcmRCRjNCZGFNNmtZclN0YUsvNFM3dVFybGVNSXROSjR5MW9l?=
 =?utf-8?B?VjRuakdYWFYrUjhQL2VhbjQ5Z2dMVkhBYXN0V0tsai9PWXluRFV3aVdDN2N2?=
 =?utf-8?B?ZDBOTmIzR2FOU0FUSG0rckhDWHpZL2ZaVTVYSkdpYlcvZGlkaW9Eci9DaGhT?=
 =?utf-8?B?dWZBalJETGVlbWNQYjh5SnBVQngvdnp2OVdOcVZVSmRkOGtXdVJra2hBTDkx?=
 =?utf-8?B?NjNxQXljUkJFTHdRMUpFaVZiYWJXOUF1cGdZRktXdEJTZDF1NGpCZmZLY3No?=
 =?utf-8?B?N1lmN0ZONkY3U2YwNjBXY1Mwc1Z0UHpqdXlQanZ4LzFYYS8wNS90Z0pwN0Rv?=
 =?utf-8?B?bVZQWWtyQUNLNVRUMGtpQVFZYUsyTkVIajNkZjlpenlZMlNFZ09PeUtGZzdY?=
 =?utf-8?B?c0tJcHd1ZGcxQkFDbHJ1MWNrSTdNNWFtYjNnWThXWVpFcW5yVUZRTmFnSXhm?=
 =?utf-8?B?aDhSZ1JsMTVVUVdnYkNDdUp1L1RmWVh6Q05EQ0ovb2pGR092T2hCZkJRZkU2?=
 =?utf-8?B?Sm1meCszeFJOVHE2eThhQktseTl4aXJBYnluRFZTQTN0VWpZV2xtb0hNZVBM?=
 =?utf-8?B?U3dBVXU0VG5GdDNKT1lwbVlLYksxaWphOXVmeTJFQ3d6dklZcm11LzEva1VR?=
 =?utf-8?B?OGlmZEpGa1pEKzFLczNGWHJOSzh1S1Y0SHJhTlQ1RWZmY3ZCYlVvbDl3dEhk?=
 =?utf-8?B?cEp3ZERGQlRidjYya1EzUDJzRXhXdndEdEpGdXJrR0EwQXZSSm8wV2trenJQ?=
 =?utf-8?B?SjdvR25wWER6aTJJcDBlbjdzS2xmWCsyOWpkam81VlREbmVrbkw1T0d3ZFNF?=
 =?utf-8?B?TUE3QnNQUklkSEJhelpxZEtNM2JyUzRaNzZZbmFhMENIcmxRcE5Fejdpd0NS?=
 =?utf-8?B?U0hZaWs4SGNKTVFpZ1Z5WHRxeEZUK3NjcklzQ2pvN1pOT09CMXl4bjE0eUJa?=
 =?utf-8?B?S2hsUVNGWndJOHdGLzR4WTk5b281amhXTXcwaVVqdmplczVEbzhFRFdSR05w?=
 =?utf-8?B?ZnVaY3J2Yi8wVXVXbjZEb0pyNGRYVEpBSlJQa0Y2cXZYUU1OYXRFL2xTNk9Q?=
 =?utf-8?B?NGpWYkh0UGlrTmhibm1HbGZnTGp5NXFQZmZ4bnhUdU1KYXArdnFWNzAyejhE?=
 =?utf-8?B?ZTBJMWY3WHRkejg4aWpHWjhkejlzQ2xoNk5Bc3V5WUdXOStKNzhOVHZXZzk5?=
 =?utf-8?B?QmtKUmJ6RU5RelVtVzFqUUZ1eTJ0djRXZzMrMXEwcmEzQkN5V2FWQ09FRjFz?=
 =?utf-8?B?UHExVjJjK1JIS0w1WkxKWndyR25qT2ZLd3IwK3RadFRGUTdWY3FtUT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c9743fbf-d5da-4b61-0cd2-08df3edd0fe4
X-MS-Exchange-CrossTenant-AuthSource: SAVPR12MB999143.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2026 03:45:28.6106
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 95oWHeXjDLC3EHcTfODx0C7lbgEE7BHLUnR0lwCVCbtzAyNQ7P7yJW4cTzh+WfydpwJAP6R/ioX8zyTsdd9wtw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CC6PR12MB283837



On 11/7/2026 9:05 PM, netdev-bot+sashiko@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential
> issue(s) to consider.
> 
> Critical: 0 · High: 0 · Medium: 1 · Low: 0

[ ... ]

>> +	rule = mlx5_eswitch_add_offloaded_rule(esw, spec, attr);
>> +	if (IS_ERR(rule) && meter_added)
>> +		mlx5e_tc_del_flow_meter(esw, attr);
> 
> [Severity: Medium]
> Can this lead to a double free of the post meter and an extra meter put?

[ ... ]

> Would it help to set attr->meter_attr.meter and
> attr->meter_attr.post_meter to NULL, and undo the attr->dest_ft change,
> after mlx5e_tc_del_flow_meter() in this failure path? A later unoffload
> would then skip the meter release.

Hi Wentao,

Thanks for the fix, the leak is real. This comment is valid too:
mlx5e_tc_del_flow_meter() leaves the pointers set, and
mlx5e_tc_rule_unoffload() releases the meter whenever
attr->meter_attr.meter is non-NULL. After a failed re-offload in
mlx5e_reoffload_encap() the flow is still marked OFFLOADED, so the next
unoffload releases the meter and post meter a second time.

Please clear both pointers in mlx5e_tc_del_flow_meter() in v2. The
dest_ft part is not needed, the next mlx5e_tc_add_flow_meter() sets it
again before it is used.

Thanks,
Jianbo

