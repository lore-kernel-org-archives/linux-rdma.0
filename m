Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.53.1
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794650073;
	b=b4WGh3/N0zxv433f0jo45yrh3Otb9KTAcfJmp7/H8XXAXeDJmjhMUqMcLve7TCFHNikX
	 3LNH7u+792i4SZpR9qdquj/HTRp8HAYZMNgmE9nkgKTWRMVJ4UKBlajCvSswhTzNUBTy8
	 1KDATWD1DJ3ORLLi7nN3Zcfqhdf83pDVtg4EdueDcGr08THF3k0NcrERJV1iMK9Nrqkql
	 twtnWznEgSMuoDkAfL7mSStTcvtQY+wE1hDLkfjTS/vqyXD0MmDKr9WwgnehXPpQyMD9A
	 oAiMch3CZVbHv8X9sBlNE1nQSaPf9FFHOed0U1dehyab9vtL5W+vvRco3Wagv+FHO/A==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794650073;
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
	bh=2uXQVVKdQfs1IL3b6TVhdN1rIhYZNujEZe1A/xOoZiU=;
	b=wzfMcEyz7diyuZHwGUwm78qa7JWF//NSTgm9m763ilUIlD2q0AFOWc9ddN1idb4KCUlI
	 RLEs+auh83DNZ9BmVCpLoxIq6T/qPqLpHjtpr5q/uzSqd1lj+uVwewP4//irOhXD4FTZI
	 mEujzp+xiDmzIPHqTrzQ5J50MEkaNMXiOueHIDDN3Zwft58FyJIEhMUp4WCgNnB4lZ2fX
	 ES1xHA7RVP7QfrmCichrjXtc3M9G7C2e4JlGT9LOZ5/m3YDFrHwNF2Db8CppelCDfFrXV
	 3witXHvltnBgIptO0GN+7+QBqlpoynXTmx6MQ9ibrQNoq42NQFkcUC//0MKq0LeRWfQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=kMlFfs0K;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.53.1
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012001.outbound.protection.outlook.com [52.101.53.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F41BC606A336;
	Sat, 14 Nov 2026 09:54:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F41BC606A336
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=kMlFfs0K
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UWNynKa228cRpQibsqv4UKEZb2H8a30+c+bRZ0XBXnpXY/kCuM5p8aVUQ0fMexr5WY7Z5sH40uKY1eXi3Tkn0u4sadpbs2MlHb0CQwrW8mraB3brmahqCpVyPzBts31L9ce3JfRrmMJxh5pkAEugSE9IcLSfZloypnFeqJAlvtDt84Z8yw38oseS0PHdc65EjLItbPPj4X7ScnkZ9hUeuGzaVSB+Jd2mIYcrZvP3w+9afC+7e6jgxCo2BVvWvUpl7ZadTwnwIabct54u95st1zsuYHsbs6ixL0MxhLW6quKtE5gpdJYceVS3lNzl70wJy6knboxCfB+8l5u7+w/lJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2uXQVVKdQfs1IL3b6TVhdN1rIhYZNujEZe1A/xOoZiU=;
 b=UQAGgo3CQC35UXZO9rQLZiDt2f0Y4nji8GTuej8PaVDVmGVoQ0DEgjUN9QsLwzIlGheP7Vojqy22gt3oFkHMnIf8YT4KI1J0peIGH2hW+GRQ36wSPe9LpwXhFiSYYO0hfLAyzjCfLOZlX7a1Wjq2EpWf4MGNnYvmjO9wMhYCAiapWDv21rtXLZa9xS22YlxF4UarBRbOx9ydO3xjW1ss0544ji3vSB5y3D3bsInBUZEWd9/jPAMLPQ4ShZDwLgKNTrbDHy6tlzZK3BSrrkWwITpUYsvZjZUnwZgoTDK/e0wgDV0T6n8mwqdk+/qvCpu23GJd3EGrnR75i0Sg7xGm9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2uXQVVKdQfs1IL3b6TVhdN1rIhYZNujEZe1A/xOoZiU=;
 b=kMlFfs0KeHd2b44qUCBvOtlz5JUPgylWYqWvsXVc/io2H57HOP/mbadZbogEE9BsAeMTeIaaHlbBZd3APXMcReIsWCNnLfLz0RnqdpevARJ/oIRxQaIDjNFYlmvSJgyTXJ7uFdQ19fk015c9Z1tckV6J3Ap4TUo5SYE5ATnLmMpBc4bXxyS0PRTNdP4nGyTNvp4tgzywTVmRznit7MtQlgBVVw+wbIYfpTKUA/OdvQoETjbTmhN6q22mYWS1efjvHuCrF3y1HOXEN+3XzaMuZIRl0ApvI8s9S46IiVYGwmrmMRgd2tB3L8Mj84ReqzBdrXLSdHriTqhbYTEQSHH2cg==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHAPR12MB999248.namprd12.prod.outlook.com
 (2603:10b6:610:2ff::22) by CYYPR12MB8730.namprd12.prod.outlook.com
 (2603:10b6:930:c1::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.10; Sat, 14 Nov
 2026 09:54:29 +0000
Received: from CHAPR12MB999248.namprd12.prod.outlook.com
 ([fe80::4972:8062:d74e:b205]) by CHAPR12MB999248.namprd12.prod.outlook.com
 ([fe80::4972:8062:d74e:b205%6]) with mapi id 15.21.0615.009; Sat, 14 Nov 2026
 09:54:29 +0000
Message-ID: <7b464808-2c49-4b30-83d5-5997bd22aa4f@nvidia.com>
Date: Sat, 14 Nov 2026 11:54:23 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next V2 11/13] net: add netdev_unbind_dma_dev() helper
To: netdev-bot+sashiko@kernel.org, tariqt@nvidia.com
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com,
 bobbyeshleman@meta.com, cjubran@nvidia.com, cratiu@nvidia.com,
 daniel@iogearbox.net, dw@davidwei.uk, erfansh@meta.com, gal@nvidia.com,
 Jacob.e.keller@intel.com, kaifengw@google.com, leon@kernel.org,
 linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, mbloch@nvidia.com,
 mfleming@cloudflare.com, almasrymina@google.com, razor@blackwall.org,
 saeedm@nvidia.com, horms@kernel.org, sdf@fomichev.me, sdf.kernel@gmail.com,
 witu@nvidia.com
References: <20261110183826.2927274-12-tariqt@nvidia.com>
 <179447641496.2199510.9115038837644205059@kernel.org>
Content-Language: en-US
From: Dragos Tatulea <dtatulea@nvidia.com>
In-Reply-To: <179447641496.2199510.9115038837644205059@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MM0P280CA0074.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:190:8::28) To CHAPR12MB999248.namprd12.prod.outlook.com
 (2603:10b6:610:2ff::22)
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
X-MS-TrafficTypeDiagnostic: CHAPR12MB999248:EE_|CYYPR12MB8730:EE_
X-MS-Office365-Filtering-Correlation-Id: ec33a1c5-338b-4fed-35b4-08df4235464d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|366016|23010399003|7416014|6133799003|18002099003|22082099003|10067099003|261022075727099003|4143699003|261026140227099003|261021135927099003|261102123227099003|261009223027099003|261026121527099003|5023799004|11063799006|261021121427099003|261022105027099003|261028144727099003|56012099006|261102130727099003;
X-Microsoft-Antispam-Message-Info:
	nlC0BEFppcJ4qZjSLbCvqNg1wv+q2Rel7JBtHYHZHv9cYB6oUexd1l56FSwSu3Mc9lRsWwd/MXEnaLSjlzBSj9yBLdQZRV2GLpMB5PLlyu2UgYzLHDHJHkhfcQIDCpW/bEaTY941Q31tOpZjYXJ4c3A0KDiP0y5L5z3FjVsGdIZi8j+7ucU6rKgirovaHAatdo1sTJgNE4Howsjl851TjWKQbjMLy6lNS6f0iNsdvoMM16tnYvIUHrUyScsrmyFcv8ailGfCJayA7yLuA71f146kfPihHPO0K8Qa20KE4f7/jv3pUc08z38/1LUkMFdY3UX0WMdVFxJwVDdCERrwgMzfzyZdKKNGNRpj4H0NkopzXACzGtw2h43a8eWnokewTMivaLo4k9NCXZ74mwdkhNJmex9V+IsEXBgC4GbpExdoyOrYAmL8xsbmBGuw/9/VJpGgc/SYDVJLVnXn2HEsaitAupbEHCi/1Y9ZpOhHmirz2q4a69C/zYPxHKFk8s9ZWmI74jR6NUXfuQCRjjh3mf8UiS6aW0An+2XZKXUpx7g/uv89BJqjg77Va+CdSiJu/mXvxZcPMhdlMt4kqvu/rIZVRInt1m/w23B4vLpz81+uoWB4NxSaK4pyezza4KnfI7CnBYbBzBIICoO4vmFJRUwv0jcHexVQOc7wJHPfYz0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHAPR12MB999248.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(23010399003)(7416014)(6133799003)(18002099003)(22082099003)(10067099003)(261022075727099003)(4143699003)(261026140227099003)(261021135927099003)(261102123227099003)(261009223027099003)(261026121527099003)(5023799004)(11063799006)(261021121427099003)(261022105027099003)(261028144727099003)(56012099006)(261102130727099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?c0xXbVBoZTRNM3JxbzBvbjdsNlBreFphMWR6ZFBvK1ZvUURtZSt5Qmx6Ni9q?=
 =?utf-8?B?WS9LTHRIcTBwMlhRbElYaEFCR2pzTk8xYXRDdzNwc2ZsaVlxRit1bjR4MHJq?=
 =?utf-8?B?OCtQUnppbHV3M29xWWZxY0VTWGN5b3E5MjRpekY1emNTTWk2QVkzM1RqK05X?=
 =?utf-8?B?M2FKUzlxdTZCZGZOdHRuNVdGUGVpVFY0NW1kK0NPbVNNczc3QXJKcitpZ3ND?=
 =?utf-8?B?VVlkRi9wcG84a21paW9sR0pJTkhuT2FCTXhsSzBvb1RaVGhBQjVjT2R1VmZE?=
 =?utf-8?B?RUsxRzJLOHlMZVZjcWl5L1hDTnI2Rnd2U29acm1IOUpzVGlEZnN1S3VnMldk?=
 =?utf-8?B?aVIyMnVwM2wrclh3OUw3eHZDZ0FtcEhwSGRvZUxoR2Z1L3lHUmt5ajdVV0M5?=
 =?utf-8?B?aDZQMysrWTFjSXluSG5IMEFxOElaSXd1dXRXU0lwdjlMU3lwVFFnWlVxejFm?=
 =?utf-8?B?U0FQZnlwYkw5eENUK0IvVVNiMFZkcWpNVUtsV04zQVNuYkhpZmVCVWxadDhQ?=
 =?utf-8?B?NjZMWXhzcU1OR3JaUEVKS1RRVkc2bktDM0x2LzBDaHdFTUhhVWVDZ1czOFRU?=
 =?utf-8?B?aktjb1ZRVUNKb05RNGthRm1FUGErNUMxY0p1NWg1ZE1zYTJiUkUwZGpQUTVI?=
 =?utf-8?B?QTB4d3lDSjNPQzQya0swOWNVVE00aXhwRUxvd0o5WWx1ekFFeGhTeVA4Sldm?=
 =?utf-8?B?OEduMGhwZVFLVzg5ODJIVlh2QmJ3dFVMMzNRUWcwemNnc1pONWdiUzd0emVV?=
 =?utf-8?B?N0RwRkJiWFllVUt6RFcrRkVtNWt1cllMKytkamIxaWs1SnEwTjVKOEx3WWFR?=
 =?utf-8?B?eEpHdkJiVExsNEg2SldLV3RKS2grL0NBZ0JGQjU2ekxqT0lZVWlxRXNuTklY?=
 =?utf-8?B?UDFySVlIQm1pcnR0eXZHU0ZaUUJLbEtCenZDdWtMdkpEdXk0emxzc0JzZTFU?=
 =?utf-8?B?U0oyQ280NTRtYkFUR1hxOTRjVUZQbjRWMS9MbTh6dzhMWHl5TTUyUXNTNVVZ?=
 =?utf-8?B?TXNnYkUyam02bnJWV1VBL3FWOVhGaTRJUUU5bmlGb2trYlVlMXFxT0ptLzBZ?=
 =?utf-8?B?cXRvdERGZS83UHRMY1hlSlNkVmtrQUZsYStXV2N4bU5xT3NBUDZNZjJLaFVs?=
 =?utf-8?B?U3ZIZ3p1eHk4V001UjdIaUVWSXUyVHhCMzA2U0Q4TjZtWDRkNzBRYWNLblIr?=
 =?utf-8?B?MzVGeG1FTHM3NE5ONEZmT0svNlQwNmdST0QrK0xZOWVpeVJhSVoyUmIzbWdl?=
 =?utf-8?B?TGpwcHhKdnBHci9kVnRWUnVZdWtBcVB6SEo0WWp4TUFSc2I5TXBnSCtxMXhv?=
 =?utf-8?B?S0FtOVN1TWtOdFpVcE4xOFU3U3BrbEhuR1c5MHRqSzBIRlJERDdqWHZkVWgy?=
 =?utf-8?B?TmVGekJYRzJsS0x5ZXBNbnd3cnNoQldDSVJKMHBvTkVWMWgwNU9mdW9TTHZU?=
 =?utf-8?B?RmxGQ2Nlc1hBTllaZHh6ZVZzN3NPY2M1ejF1WWpjdEs5dTViTUEwMUFKUElo?=
 =?utf-8?B?akQzLzhOQzd0V0djQitId0ZUVi8zclpVelE3NnFjdk1HeStDb3NLc0FFMFEy?=
 =?utf-8?B?cmM4cjVGUTluWDE5UWZKTk5xN0tLeGRydllzQ2plQnZxZld2OFJKNnJVbzVy?=
 =?utf-8?B?WHlCZzBiZTVJbmdCenI4WGh2UU5CcGw3VEpNTVdRK1FNbW5xN283aFVUZXA2?=
 =?utf-8?B?MEEyRTR1cmQrWHlXZjdrMWorYllqbklsQ28rajhLVThXZEhJRTY0aFVZQSto?=
 =?utf-8?B?L2VYN3dLZ1FqZFB6M21DTDBCSkVXTklSRU9PaC9mMkU1YlQ3dHZuMEIzRW5v?=
 =?utf-8?B?RjRLeDkvT2NzbjlNNU5EQjJUK2V2bEZOWjYvV2hNMXAwVklMeWRDcDFZcWVZ?=
 =?utf-8?B?RmM5MTIyaDdqRzluMEZTZTdIeUhmNE9GVkM3MGlwSTdzZHlibGk0d3lOcEpE?=
 =?utf-8?B?WkZRbnBiWjBVdExkUm5VNkpNbFU0bVFIRmZ3WDFXQjZtV3FJMEFvWUFacVRV?=
 =?utf-8?B?UGN1Z21hOGJSZHFPaEZ5OHJKaXIvQjRoVHVuUEg2MDhwRWpFSzZkdGdaMy8r?=
 =?utf-8?B?YTEwblE4b0cyNndTcGM0MDM3alpzWFlmOFFjQmhtMkR3WUI4VzdaN1g4M0dG?=
 =?utf-8?B?dXptWnRvWWxSVDNIUDlGTW9JY0tRNVh4elpWODh5SjZUdXhycGtlNWNCUFBC?=
 =?utf-8?B?VjR5QVFZM01MeUtlT3E3RGl2ZStrWkRYQTdSaTdJU0E3dytqSHZBZ3Q2VEtV?=
 =?utf-8?B?RHc0UkFES0J0d0tlU0U5K0VEUEt0b0JBK0dzRjVCVlJlc3pENnhRU0p3NzUz?=
 =?utf-8?B?N0dGODJDNjI4Nm1LZ2pyUG84MjhsN1MyNHR4UXNjRXNBekZTeTNHZz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ec33a1c5-338b-4fed-35b4-08df4235464d
X-MS-Exchange-CrossTenant-AuthSource: CHAPR12MB999248.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2026 09:54:29.1990
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DegVeawdzkmZ+ADbevY/4CLCwc4IMclzoBZUR2Hu1YyDIYTFqacaKtJRGvqYF5N0MLsINeCvWqkp67cptpRE6g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR12MB8730

On 12.11.26 10:40, netdev-bot+sashiko@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 7 potential
> issue(s) to consider.
> 
> Critical: 0 · High: 1 · Medium: 2 · Low: 4
> 
> If you believe none of the issues are legitimate, please reply to each
> issue of Medium severity or higher and explain why the AI is wrong.
> If any of them are legitimate and you plan to respin, please let patchwork
> know by including "pw-bot: cr" as a separate line at the end of your reply
> (one such reply per series is enough).
> 
> - [High] netdev_unbind_dma_dev() (net/core/netdev_queues.c:84) refuses
>   only when the netdev is both running and present (`netif_running(dev)…
> - [Medium] The two halves of netdev_unbind_dma_dev() use different rules
>   for which mappings belong to @dma_dev.
> - [Medium] __netif_mp_close_rxq() (net/core/netdev_rx_queue.c:291)
>   quietly accepts an already-uninstalled provider only when…
> - [Low] The commit message says "A detached netdev also works because ...
>   new bindings can't be added", but the core does not enforce this for…
> - [Low] Several in-tree comments that list binding lifecycle rules were
>   not updated for the new site that clears and unmaps bindings, and the…
> - [Low] netdev_unbind_dma_dev() treats a NULL result from
>   __netdev_queue_get_dma_dev() as "this queue maps against the departing…
> - [Low] net_devmem_unbind_dma_dev() (devmem.c:575-596) clears
>   NET_DEVMEM_BINDING_LIVE to "hide the binding from TX lookups while it…
> 
> --
> 
> net: add netdev_unbind_dma_dev() helper
> 
> This adds an exported helper for a closed or detached netdev. It
> uninstalls the memory providers of RX queues mapped against a departing
> DMA device and unmaps the devmem bindings that use that device. It is
> meant for mlx5 data direct, where the DMA device is not the netdev's own
> PCI device.
> 
>> diff --git a/net/core/devmem.c b/net/core/devmem.c
>> index dd3987bbd9f6c..bc8ae12b2318a 100644
>> --- a/net/core/devmem.c
>> +++ b/net/core/devmem.c
>> @@ -556,6 +556,48 @@ bool netdev_has_dmabuf_binding(struct net_device *dev, struct device *dma_dev)
>>  }
>>  EXPORT_SYMBOL_GPL(netdev_has_dmabuf_binding);
>>  
>> +/* Unmap the bindings of a closed @dev that use @dma_dev, the way netdev
>> + * unregister does. Senders that raced the detach drop their skbs at xmit.
>> + */
>> +void net_devmem_unbind_dma_dev(struct net_device *dev, struct device *dma_dev)
>> +{
>> +	struct net_devmem_dmabuf_binding *binding;
>> +	unsigned long xa_idx;
>> +	bool match, live;
>> +
>> +	netdev_assert_locked(dev);
>> +
>> +	xa_lock(&net_devmem_dmabuf_bindings);
>> +	xa_for_each(&net_devmem_dmabuf_bindings, xa_idx, binding) {
>> +		if (READ_ONCE(binding->dev) != dev)
>> +			continue;
>> +
>> +		/* Hide the binding from TX lookups while it is checked. */
>> +		live = xa_get_mark(&net_devmem_dmabuf_bindings, xa_idx,
>> +				   NET_DEVMEM_BINDING_LIVE);
>> +		if (live)
>> +			__xa_clear_mark(&net_devmem_dmabuf_bindings, xa_idx,
>> +					NET_DEVMEM_BINDING_LIVE);
>> +		xa_unlock(&net_devmem_dmabuf_bindings);
> 
> [Severity: Low]
> Does clearing the mark here actually hide the binding from TX lookups?
> net_devmem_lookup_dmabuf() runs under rcu_read_lock() and does:
> 
>     binding = xa_find(&net_devmem_dmabuf_bindings, &xa_idx, id,
>                       NET_DEVMEM_BINDING_LIVE);
> 
> net_devmem_unbind_dmabuf() needs a grace period after clearing the mark
> for exactly this reason:
> 
>     /* Ensure no tx net_devmem_lookup_dmabuf() are in flight after the
>      * mark is cleared.
>      */
>     synchronize_net();
> 
> There is no synchronize_net() here. A lookup already in flight can still
> find a matching binding and take a reference. The safety of matching
> bindings then rests only on clearing binding->dev and the check at xmit
> time.
> 
> There is also a side effect for bindings that don't match. A binding on
> @dev that doesn't use @dma_dev is invisible while xa_lock is dropped. A
> concurrent SO_DEVMEM_TX sendmsg on it could get a spurious -EINVAL.
> 
> The mark is cleared on entry and restored on exit to guard this region,
> rather than to express state. Is the clear and restore needed at all?
> 
v3 doesn't to the mark restore trick anymore.

>> +
>> +		mutex_lock(&binding->lock);
>> +		match = net_devmem_binding_mapped_to(binding, dma_dev);
>> +		mutex_unlock(&binding->lock);
>> +		if (match)
>> +			net_devmem_dmabuf_binding_unmap(binding);
> 
> [Severity: Medium]
> The commit message calls this half "devmem TX", and the comment says it
> works "the way netdev unregister does". However, nothing here filters on
> binding->direction or LIVE. net_devmem_dev_unregister() skips LIVE RX
> bindings:
> 
>     if (binding->direction == DMA_FROM_DEVICE) {
>         if (READ_ONCE(binding->dev) != dev ||
>             xa_get_mark(..., NET_DEVMEM_BINDING_LIVE))
>             continue;
> 
> The two halves of netdev_unbind_dma_dev() also pick mappings by
> different rules. The RX loop uses the driver's current per-queue report
> and skips leased queues. Here, net_devmem_binding_mapped_to() treats a
> NULL @dma_dev as a wildcard:
> 
>     return binding->attachment &&
>            (!dma_dev || binding->attachment->dev == dma_dev);
> 
> Take an RX binding whose queue the RX loop skipped but which matches
> here. That can happen with a NULL @dma_dev, with a driver that already
> reports a different device, or on the leased-queue path. Such a binding
> is unmapped and gets binding->dev cleared while rxq->mp_params and
> binding->bound_rxqs still point to it. mp_dmabuf_devmem_uninstall()
> avoids this by clearing dev only once bound_rxqs is empty.
> 
> A later netlink socket close then reaches net_devmem_unbind_dmabuf()
> with a NULL binding->dev:
> 
>     if (netif_mp_close_rxq(binding->dev, rxq_idx, &mp_params))
> 
> Wouldn't netif_mp_close_rxq() then dereference dev->real_num_rx_queues
> through NULL? If the netdev is reopened first, the page pool would be
> built from the provider that is still installed, over an sgt that has
> already been unmapped.
> 
> This doesn't look reachable from the in-tree mlx5 caller. But the helper
> is exported, and netdev_has_dmabuf_binding() documents a NULL dma_dev as
> "any". Should this half filter on DMA_TO_DEVICE, or should a NULL
> @dma_dev be rejected?
> 
Ack. Will fix in v3 to filter by DMA_TO_DEVICE and rename
net_devmem_unbind_dma_dev() to net_devmem_unbind_tx_dma_dev().

>> +
>> +		xa_lock(&net_devmem_dmabuf_bindings);
>> +		if (match) {
>> +			WRITE_ONCE(binding->vdev, NULL);
>> +			WRITE_ONCE(binding->dev, NULL);
> 
> [Severity: Low]
> This isn't a bug, but some comments about the binding lifecycle don't
> cover this new site.
> 
> The net_devmem_lock_dev() kernel-doc lists where binding->dev is
> cleared:
> 
>  * NULL while holding netdev_lock(dev) (in mp_dmabuf_devmem_uninstall(),
>  * net_devmem_unbind_dmabuf(), or net_devmem_dev_unregister() during
> 
> In struct net_devmem_dmabuf_binding, the vdev comment says "cleared with
> WRITE_ONCE() on unregistration". The ref comment says "TX bindings are
> also unmapped earlier if their device is unregistered". Both of these now
> also happen when the DMA device goes away.
> 
> The new netdev_unbind_dma_dev() kernel-doc says it uninstalls queues
> "that map against @dma_dev". It also uninstalls queues for which the
> driver reports no DMA device at all.
> 
> Should these comments be updated?
> 
Ok. Will update.

>> +		} else if (live) {
>> +			__xa_set_mark(&net_devmem_dmabuf_bindings, xa_idx,
>> +				      NET_DEVMEM_BINDING_LIVE);
>> +		}
>> +	}
>> +	xa_unlock(&net_devmem_dmabuf_bindings);
>> +}
> 
> [ ... ]
> 
>> diff --git a/net/core/netdev_queues.c b/net/core/netdev_queues.c
>> index 27cb6397bdd4e..71cc7bfc087dd 100644
>> --- a/net/core/netdev_queues.c
>> +++ b/net/core/netdev_queues.c
> 
> [ ... ]
> 
>> @@ -58,6 +60,55 @@ struct device *netdev_queue_get_dma_dev(struct net_device *dev,
>>  	return dma_dev;
>>  }
>>  
>> +/**
>> + * netdev_unbind_dma_dev() - drop the memory providers of a departing DMA device
>> + * @dev:	net_device, closed or detached by the caller
>> + * @dma_dev:	DMA device the driver is about to lose
> 
> [Severity: Low]
> The commit message says:
> 
>   A detached netdev also works because the driver has already torn down
>   the queues and new bindings can't be added.
> 
> Is that enforced for io_uring zcrx? The devmem netlink bind paths check
> netif_device_present(). zcrx_register_netdev() only needs
> netdev_queue_get_dma_dev() to return non-NULL before it calls
> netif_mp_open_rxq(). Neither netif_mp_open_rxq() nor
> __netif_mp_open_rxq() checks whether the device is present.
> 
> So once this returns and the instance lock is dropped, the only thing
> stopping a new zcrx area from being mapped against the departing device
> is the driver's ndo_queue_get_dma_dev() no longer reporting it. mlx5
> does stop reporting it: channels->num is 0 when closed, and dd.dev is
> cleared before the notifier runs.
> 
> The kernel-doc only says "net_device, closed or detached by the caller".
> Should it also state that the driver must stop reporting @dma_dev?
>
Driver does have to stop reporting the unbound dma_dev. Will add
to doc.

>> + *
>> + * Uninstalls the memory provider of every RX queue of @dev that maps
>> + * against @dma_dev. Unmaps the devmem bindings of @dev that use @dma_dev.
>> + * The bindings stay allocated until their users release them.
> 
> [ ... ]
> 
>> + * Return: 0 on success, -EBUSY if @dev is running and present.
>> + */
>> +int netdev_unbind_dma_dev(struct net_device *dev, struct device *dma_dev)
>> +{
>> +	unsigned int i;
>> +
>> +	netdev_assert_locked(dev);
>> +
>> +	if (netif_running(dev) && netif_device_present(dev))
>> +		return -EBUSY;
> 
> [Severity: High]
> Can a netdev that is running but detached get past this check while
> validated devmem TX skbs are still sitting in a qdisc?
> 
> The commit message says:
> 
>   The netdev must be closed or detached so that the hardware no longer
>   accesses the mappings and the qdiscs hold no validated skbs.
> 
> netif_device_detach() only clears __LINK_STATE_PRESENT and stops the TX
> queues. Only dev_close()->dev_deactivate()->qdisc_reset() empties the
> qdiscs.
> 
> The mlx5 caller later in this series seems to reach exactly this state
> in mlx5e_nic_disable():
> 
>     if (netif_running(priv->netdev))
>         mlx5e_close(priv->netdev);
>     netif_device_detach(priv->netdev);
>     ...
>     mlx5e_data_direct_unbind_dev(priv);
> 
> mlx5e_close() is the ndo_stop, so __LINK_STATE_START stays set. The
> check above then passes because the device is not present.
> 
> Consider this sequence:
> 
> sch_direct_xmit()
>   validate_xmit_skb_list()
>     validate_xmit_unreadable_skb()   <- binding->dev still set, passes
>                                      mlx5e_close() stops the txq
>   dev_requeue_skb(skb, q)            <- skb parked in q->gso_skb
> 
> netdev_unbind_dma_dev()
>   net_devmem_unbind_dma_dev()
>     net_devmem_dmabuf_binding_unmap()
>       dma_buf_unmap_attachment()
>       dma_buf_unpin()
> 
> On resume, mlx5e_open() and netif_device_attach() wake the queue.
> dequeue_skb() then returns the gso_skb with:
> 
>     /* skb in gso_skb were already validated */
>     *validate = false;
> 
> The binding->dev check in validate_xmit_unreadable_skb() never runs
> again for that skb. Would the NIC then be given net_iov DMA addresses
> that are no longer mapped for the DMA device?
> 
> The comment above net_devmem_unbind_dma_dev() says "Senders that raced
> the detach drop their skbs at xmit". That doesn't seem to hold for these
> requeued skbs.
> 
> For RX, the check relies on an unenforced convention that a detached
> driver has already torn down its RX rings. mlx5 meets it because it
> closes before detaching. A caller that only detaches would have its
> dmabuf and zcrx mappings revoked while RX descriptors still point at
> them. Should the exported helper enforce or document this?
> 
I did this to prevent another issue in mlx5e: mlx5e_suspend() disables
the data direct notifier so if the data direct device is unbound after
suspend, the DMA dev ptr would be left dangling. So I wanted to call
netdev_unbind_dma_dev() during suspend. Seems like this is not
the right way.

I will add one more mlx5 patch that closes the netdev on suspend
if it is in use. It will be ugly, but I can't see a better way.

>> +
>> +	for (i = 0; i < dev->real_num_rx_queues; i++) {
>> +		struct netdev_rx_queue *rxq = __netif_get_rx_queue(dev, i);
>> +		struct pp_memory_provider_params p = rxq->mp_params;
>> +		struct device *queue_dev;
>> +
>> +		if (!p.mp_ops)
>> +			continue;
>> +
>> +		queue_dev = __netdev_queue_get_dma_dev(dev, i);
>> +		if (queue_dev && queue_dev != dma_dev)
>> +			continue;
> 
> [Severity: Low]
> Here a NULL from __netdev_queue_get_dma_dev() counts as a match. Is that
> intended for a closed netdev?
> 
> mlx5e_queue_get_dma_dev() returns NULL whenever:
> 
>     /* Allow only opened channels. */
>     if (queue_index < 0 || queue_index >= channels->num)
>         goto out;
> 
> mlx5e_close_channels() sets chs->num = 0. So in the closed state this
> helper requires, the @dma_dev filter appears to do nothing for the only
> in-tree caller. Every RX queue with a provider is uninstalled, whichever
> device it is actually mapped to.
> 
> If a driver's queues can map against more than one device, wouldn't
> providers on a device that isn't going away be torn down as well?
Yes, that is the point.

> A leased queue with a provider would also get past this filter and hit
> the WARN_ON_ONCE(rxq->lease). The TX half filters on
> binding->attachment->dev instead.
>
I chose to keep leased queues as unsupported to keep this series
reasonably sized.

>> +
>> +		if (WARN_ON_ONCE(rxq->lease))
>> +			continue;
>> +
>> +		memset(&rxq->mp_params, 0, sizeof(rxq->mp_params));
>> +		__netif_mp_uninstall_rxq(rxq, &p);
> 
> [Severity: Medium]
> Can this race with io_close_queue() in io_uring/zcrx.c and trigger the
> WARN_ON_ONCE() in __netif_mp_close_rxq()?
> 
> __netif_mp_close_rxq() only accepts an already-uninstalled provider on
> the unregister path:
> 
>     if (dev->reg_state > NETREG_REGISTERED &&
>         !rxq->mp_params.mp_ops)
>         return 0;
> 
>     if (WARN_ON_ONCE(rxq->mp_params.mp_ops != old_p->mp_ops ||
> 
> Here mp_params is cleared on a device that is still registered. One
> possible sequence:
> 
> io_close_queue()
>   copies ifq->netdev, sets ifq->netdev = NULL under pp_lock
>   netdev_lock(netdev)   <- blocks, held by the unbind caller
>                                   netdev_unbind_dma_dev()
>                                     memset(&rxq->mp_params, 0, ...)
>                                     __netif_mp_uninstall_rxq()
>                                       io_pp_uninstall()
>                                         io_zcrx_unmap_areas()
>                                         io_zcrx_drop_netdev()
>                                         (ifq->if_rxq left unchanged)
>   if (ifq->if_rxq != -1)
>       netif_mp_close_rxq(netdev, ifq->if_rxq, &p);
>         __netif_mp_close_rxq()
>           reg_state == NETREG_REGISTERED, mp_ops == NULL
>           WARN_ON_ONCE(...) -> -EINVAL
> 
> The areas are already unmapped, so cleanup still completes. Would a
> zcrx teardown that races with a data direct unbind or a suspend produce
> a WARN splat (fatal with panic_on_warn) plus a spurious -EINVAL?
> 
Ack. I will add a patch in io_pp_uninstall() to set ifq->if_rxq to -1.

Thanks,
Dragos
