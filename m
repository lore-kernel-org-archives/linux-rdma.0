Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.61.0
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794578329;
	b=ZEEEyr/xo6wwJDJTxa8Dm/7/PTG8HeHVtwuyvLmn/4DEgcKED+KyVZ39sBAhd+E3+Vff
	 FCwV+ultaqW76YC5tUmPIeKun/ySWfhlZnOevomQA/ukX37bzSOo4lRSl6QECoDsr+hk7
	 jyO05+OyPt671DdD0LSzuXKvYcl4HKLyJs4s5RYF/V2fARcjx9CAKjaur6JNzgWsiKX+8
	 c0St3Fs0JbdbZ4hxVo0FwkgXaGFLMo+rFN9l9ngKyyXDjli1SHVznX8YY4PmqNeMtJxVs
	 FV/GYKVvPd78qsGikfW0fuv35XW9j81MwUEvln3FMUoO3vKYlxqPPRkC1aoyMyjfgFA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794578329;
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
	bh=GeXIwmbqoplNFzrD/+ZJ5AXtZKtjh81UApvfHwhNdgU=;
	b=sz8192BV3Ipl5Ld+Zc50WXnfToo8tfmlZoUdkuxSnU+vXOJXTVRdLPkzWiPMieub+CST
	 +V7/Kf5VgNcyLUGFag4INF3J7PfjIdIAEf/mcO8RnajvzI5VKPZbQVWxpOC6SoyaVVu8w
	 AzOsJ05G2csc6yfGbeQDfsmU75u6YfXOFpas4t6Xp2uettPRnCgofIq9IlKL0Q+mjNDiO
	 a02cSHI9BJy7vN3Mok4sWpAmkgcE2BQSsvU9UCIAkcuogqWbQleSzcMVWiTncr+0bjgUj
	 VzWcEFeBrkiFhJZDtLE4Lba75a1X/R62BNUroRxQKOZqBfglXpQ54u71fdAPeoCn+Iw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=Sl0m8MGW;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.61.0
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010000.outbound.protection.outlook.com [52.101.61.0])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAAAF606A336;
	Fri, 13 Nov 2026 13:58:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EAAAF606A336
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=Sl0m8MGW
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sbV66+AkOhHa8ThpNqcRMtXEHMg7KV67qnpmJYu9Hp+gltK0+rrq3Zv7b3xVQoPJGtllEXk5lIQa34K5SXF+tsNPdjp4sdwco2YBIadnUcVrBJPNUWIRAzVGgAs5e4WzlwWI3M5ggdih9Fxt6s4t17ebB35Q7iEgTuKzI5oYAzWIo7DONwJdkeJ2pQb1+aTLGsXdh5JlbgrlQQHWvoPRtR5cTzk79ACFJSZiHjCItqQm5/ICvARGmuLOkAG9Y802xuMQsyzt5SBqTJ1LCKLgJcYqXMjtWR+xVpwh+5nEheaU55spADiFX86H8vYO8LzE6q7ZQRK9bL1ZIzAVE36QsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GeXIwmbqoplNFzrD/+ZJ5AXtZKtjh81UApvfHwhNdgU=;
 b=fFRuGPYr7J9g9zwWvazXU340JfjkfIcEOKZ+ER11zssai8dH0dXbpO/j1MD4xgzV1TpDrftgQaxVlsEP3aCJfaFFFPvjWSTfJV7+/KD1F+BcylrufT9L6G6i4XfSEPD/QI7A2OnEhFwYEP3YdSupsXXIudxSRG5YUK4rnIosrlb4Wulo68Mb+JgL0To55EDemsAC47m18yC2yOW/IpLpgTYDuNSLPiO5i+1lbo9KEIkjdMY7M7Zv8Q50dOg5+aLSgVuuZ/wL53sNsiRCmoc1oxhQrgH0+z9ZoGT6XsUg13ITypRnekh2ODslQgj/k9CGrTr3CDD8CrJxWuZ55qyDsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GeXIwmbqoplNFzrD/+ZJ5AXtZKtjh81UApvfHwhNdgU=;
 b=Sl0m8MGWWuiVtD1pv3u3sF8Zg7KD/Y+crn1eX8zaOQ47PP7NdWvtPQF/J8afoaccNP7iwExkYjPL21waI0eEqKiiEh7yrETuPKtXNi0dbo9nAkq+UuVN91y61MvE5ObUXwjUX3lfcGTKBE7rmDnvYY4/uDN2tAmT/Io8tk+UoyovC6WLRCxfiV3M3j0eLyZw5ODYkVF1H9gMKzqA8YQ3CBpu//v61FYZBkM0pTOsqo89tiqnF2quxMLK2q2sgjILNcVIelTe30LCSQ1QM4uLVjNV/9WjVGpJ+XzvX1DHNJVBT9SQj5Bf+O4KFREDq+UKhUEsgmEQRl8AlDcG3alFrQ==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHAPR12MB999248.namprd12.prod.outlook.com
 (2603:10b6:610:2ff::22) by DS0PR12MB7656.namprd12.prod.outlook.com
 (2603:10b6:8:11f::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.9; Fri, 13 Nov
 2026 13:58:28 +0000
Received: from CHAPR12MB999248.namprd12.prod.outlook.com
 ([fe80::4972:8062:d74e:b205]) by CHAPR12MB999248.namprd12.prod.outlook.com
 ([fe80::4972:8062:d74e:b205%6]) with mapi id 15.21.0615.007; Fri, 13 Nov 2026
 13:58:28 +0000
Message-ID: <85961085-59fa-4a9b-9b0d-30768e1e0fd9@nvidia.com>
Date: Fri, 13 Nov 2026 15:58:19 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next V2 02/13] net/mlx5: Detach auxiliary devices on
 attach failure during load
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
References: <20261110183826.2927274-3-tariqt@nvidia.com>
 <179447640317.2199510.744399659255139654@kernel.org>
Content-Language: en-US
From: Dragos Tatulea <dtatulea@nvidia.com>
In-Reply-To: <179447640317.2199510.744399659255139654@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0419.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:d0::18) To CHAPR12MB999248.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: CHAPR12MB999248:EE_|DS0PR12MB7656:EE_
X-MS-Office365-Filtering-Correlation-Id: ad766133-eeca-463b-777a-08df418e3170
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|7416014|376014|1800799024|366016|11063799006|10067099003|4143699003|56012099006|261022075727099003|261026121527099003|261026140227099003|261022105027099003|261028144727099003|261009223027099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	St8femSsrgPQbQUYGJIypn49ZR9qtXTzaeSiCXefOgy2Zp/ssVq5NaDssFnG6Ga0vD/vdVsfkp+b7lXpupmpVYsgj5ZbR0TV9SbOSxsIgQ6EIUPyXXvJBV1xtkHqoYG4v+38w/MNCYNeBkYOAekAJjhVgRWd5nqKJhmeNJDV+eMstccGSxaQleFPLkF3GE5g3naKy+F/wiUfGDU7s+rof6tIp4rObB8FLGW2JfJnVc2885Oq1gkHwVC+Au6WmcrcSix8itzZ7r5zcZNLXQ0ZuhtsKzT8DnKVjvC492nzPgM4IjlNHP6nLWM1HrfMJ6UsQFyEEGZGWa1gaVjdSpltWU6kQsT+9UdD8L/mbBxldeCtTrR0VMcnnaCvEDwyBR/fmT+XeGLNk/orzuF58AaIR9jd/moN16cps033z3+1H185cFMbV2uIkOpNRn4NytMd4qPV8vZ0DsIam3S1c0wAoUoowy8gfGfspYVwh3veGToM1YzsgfUZpdhtDGrEHTKAvEUjw2Rh5CCrcvtFvgEK8kkV+zwqA1dIEx9+Am14rtP93SmcNCbwcX+0ShgtuMkZpyDnF56jY4AAkeo1aj/Ury9sMeiJCsWRMLccvzxq0P5XLPidHoiDoI8S13mTt4UhLEWC9qn0NSRXfJjbfFQqjAQygwYEHMu7pxAZhtQg2L4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHAPR12MB999248.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(376014)(1800799024)(366016)(11063799006)(10067099003)(4143699003)(56012099006)(261022075727099003)(261026121527099003)(261026140227099003)(261022105027099003)(261028144727099003)(261009223027099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VXRZYjQrMTVvR1BIRHY4bmhlWjVJMWJ2VG4xMmkyUkpDR09NU0JhU1Mrb2hi?=
 =?utf-8?B?bE1wbEwwOUlZQVpVWVN4eGRyNitIOUJEM1ZGYm5jTHpJZHQwOTJqZXBTWkM4?=
 =?utf-8?B?YVc4bnVmaThjdFJiKzRMVDYxeWpteitaVXpiQ0NCQncxMnFGR3Nmay9COUpt?=
 =?utf-8?B?L2RJNk42L29XWkRjVjJ6RVNCQnFKNWp3cnZMUHZVVzcyNitURzFRdHZ2TGhw?=
 =?utf-8?B?TytocUVEblQ5SlZEaldEclpzcWgyVUVoUnRtZE9JR2h1SGE2SnpVL3dGN3NH?=
 =?utf-8?B?aFQ4cHZPeUR3LzZlcVZRQkxvSUgwaDdiSlBPRWh1U2JFeDkxeU1oSUdMMWly?=
 =?utf-8?B?UWJiMmUzaUhzd2t4RnBGWDduZXpQK25BempyU2doTzhNejdzWndZM2d3Unk4?=
 =?utf-8?B?cDQ4QlJwa3VYaHR2Qkd0V0VGYmlqVXFodVFvMWpaODVnbHlLNXlYeFRJODZz?=
 =?utf-8?B?MlR5OFZza3VsNjMxMDd6ZEZaTkFSNHA1OWVaSW1lTWs3ZmNMdFoxQmdoZkNQ?=
 =?utf-8?B?Y3FIeXdNbHNLZDQreHFnUFh0V3RjQW1KY3dXcFVXaUNqSFVISXVtellmQS9U?=
 =?utf-8?B?cjlKcW9ZNHFqSnl4elZJNk9pMERtdDlodVNUR2FpbnV6UnJYMEpKdkR5UUly?=
 =?utf-8?B?WkZlb0dKcjExZkFmMzB0a0RkYkY4WFpWL01LcWYvNzRsK1pYL1BVRldqTm03?=
 =?utf-8?B?ZStTY3U0ekhOb3dhL3dtaTNQYXRxY1JOSVI4a2MvcnpsVStMS1Q0VUVaMnRx?=
 =?utf-8?B?ZS9abUI1ajAvWCs5ZVpFRjhQSkFjMk5ENE5XVnhmMnk2SVFaaG5FTFlNUFI4?=
 =?utf-8?B?ekZxMXRnclRxUWxmUjVlUG51V2NQcmZhR3MrbUJ2NW9PbmFaQzhDajZ1Tm5P?=
 =?utf-8?B?QnRuc2p4anB6cGtTaG5FcjI5RnYrdkxicVNXdXVaVkVlK2x1SWhWRmh1YWRy?=
 =?utf-8?B?WHdzYkNURjZYY2xTUFpGVi93ODhvZkl3dlZVeC8vQXhuNzh3UnR2dzVmaDlT?=
 =?utf-8?B?MDkxVXp0b3k4eGFqbkw4Z3dpSjh1VUNtT1o5R3pleDJTMTkxcHBtRzUrMko5?=
 =?utf-8?B?ZmFUbUFQRlg3NWhndmk1VE8rL2E5SEdRWmhFVUloSWtPdjQra1AxMFdTTUQ4?=
 =?utf-8?B?V2JJNUNOQ0RWR25rdzNibjNMSDdlY201SGdsOGljUjlqRW1PQUJLSVVTa3BJ?=
 =?utf-8?B?eDQzZzFZelJPR1ZRN3ZTdzJkTFFsaFk5VkdzZGpSQjVwQ0dXbm1TbDJiMk5W?=
 =?utf-8?B?cVRJUG1GTC9VK0hQY3JaUUVIL0xJVDNma2ZiQ3NuMk9CUUQ1MDRkbXhqTG5J?=
 =?utf-8?B?eWtxaVh3UGloeVI4ZHBPSjNPQkVHSytYOUxPTy8rVEVScEg4bmhxVkRaRm8z?=
 =?utf-8?B?RjZsdTE1NlVRbHJ4VUVYQ0VOdXRQa3ZWSzFUYXFaU05KUzIvaENaY0dnWXhP?=
 =?utf-8?B?Q1Jic0FOUFBoSCt5Z3MyKzROczkzRmRBTEp1SXJTWXo3QXBPc2pReUtTTVhQ?=
 =?utf-8?B?djFTeUoxaTBwN1dqZFRLZTUvVG9lb2UzdExoMXlFeDZIVnoyT1RDT1Q3amda?=
 =?utf-8?B?dmVKZUNuZDZ1c0hMc3ZJcUF6TDQ5WTZla21GR2ZCMTRRYUw0K1YvVUlRaWtq?=
 =?utf-8?B?UW5wUFVKSnJpczM4T2ZRcERrd3BRZ1BlMmRlYUZZRjlIa0dLcml0ZjVvc0Vw?=
 =?utf-8?B?eStreUdmZ2xoc25nd2M4dTlIYW5Kb05pU3d6UUpwMEJ3TWRWTVFweWFVb2JJ?=
 =?utf-8?B?RDJSN3JQK1BOZUxnakdmcUpTbDhTZjg5RFh3QUk3RjNTVVZ3dGVEQ1d2Q25l?=
 =?utf-8?B?Nnd2RG1IM0dFb1g1QWJ2bFF1aVo5VElxcmlOQmNoRkRDT1Zxc2RTcXdzZDFh?=
 =?utf-8?B?Sk1uWkpaZTBVZi9FWCtHYW8zOWVGMnVwR0NUWGcrTStTV3lOQWI0STc2MmtU?=
 =?utf-8?B?NFRGWUovUFVkZE14WTNvK2ZtU3FOQU9aQXJ5UkdFU1NzVE9XU3l1cFlaVzl3?=
 =?utf-8?B?NkJEcndEV0ZqSlhOM3RkSnlyMjhnQnRKeFJXNE1Bdnl0L0FDaWtEWHgxTWpH?=
 =?utf-8?B?RWNrc0lFUTVzbWpsbHZvelpnZm1Va2RIdTBhMHN1NnFUdi9Pa1kzNU9ueW1k?=
 =?utf-8?B?dVprLzVrZitEdGVja2ZIL3UyTDdCdEpuWUdxSjc1dTBsSUU0TFE0Tmdqc2No?=
 =?utf-8?B?bDJIR3dsdUdmUnErWXRzNWJ5U1J6c2FSb3Flc2l5cUFLTUVuTEIzVlJmZDZa?=
 =?utf-8?B?bjN1N09lYmIyT0J4cnZrOVpxcWV5TE9UWkRSTlBqTlZYK25nN2M3bG0vOXpp?=
 =?utf-8?B?aWtnQnYxemhoRFROTERJSk1udVJRZm1hY3hLZmJTMDhZUWJJWStpQT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ad766133-eeca-463b-777a-08df418e3170
X-MS-Exchange-CrossTenant-AuthSource: CHAPR12MB999248.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2026 13:58:28.2885
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ty43Zqp7IQjBRktsktcAW2Jo43SE00N/4uZAHffFyCzHTYlUpgWmj4IHVABHe8HjrtVxlfbY7UUyLC0+6RWt3g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7656

On 12.11.26 10:40, netdev-bot+sashiko@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found more severe
> issue(s) in other patches of this series. This mail is only an FYI, in case
> you want to address the nit picks below when you respin.
> 
> Low priority / nit picks for your consideration:
> 
> - [Low] The commit message says the fix "doesn't deserve a Fixes tag"
>   because the bug was found by code inspection and never reproduced.
> 
> --
> 
> net/mlx5: Detach auxiliary devices on attach failure during load
> 
> This patch adds a mlx5_detach_device() call to the err_attach path of
> mlx5_load_one_devl_locked(). The goal is to detach the auxiliary devices
> that attached successfully before mlx5_attach_device() hit a failure.
> 
>> This issue was found during code inspection and was not reproduced.
>> Hence it doesn't deserve a Fixes tag.
> 
> [Severity: Low]
> Is this a valid reason to leave out the Fixes tag? The Fixes convention
> points at the commit that introduced the bug. It doesn't exempt bugs that
> were found by inspection and never reproduced.
> 
I will leave the maintainers to respond to this. But I think it is
fine as is.

Thanks,
Dragos
