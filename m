Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.61.9
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795345321;
	b=jAIC9vA3E5b7u3Zc+jufqez7rHydCkAKx46cYcfP5+i0Esn/cn5me1JVpClK++MHSRPc
	 E4FgENxUFkfXUZuNPbUfq+vQOj2rABQoptnue3vuSEZwXD9QhuGUdHBTBpTv3AcLOC025
	 s1653pyCydgbyunk39v1vWciZ6RN8EVIZLEJseaJhlwiutOEaU1h+qn6FkXYQOOI7IB8q
	 0scWzZnAL/96wcHrQC89A9lAaRLwDl/pvQ9brZL+8D0bpKI/56BibBO1y7iTkVnA0/GMs
	 TJPULdbJQXdfBkmaTvbSTj0McXLvsEoo9+w6by0jaM5IiVjwOspqqXR4pll9wwThTSg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795345321;
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
	bh=6UF7VrQuwXDMiY9VuxYejzMJsLf375oQs9Y11qhoEM0=;
	b=XBQnmxtCNafgebEHnBU3WeoDo9HsYvCWClFdJNyCnVUd+RF4m7/GldOHMn4oue1AbeaG
	 Ovi7DAJoTyLyjUfUJ8WvIDV5/Lp7Jk0tIMDs8e/yTRGK1YIhI5qBFeSSDu+vG9Zyingcw
	 i7cpJbVGJjBvHo+wxeqxoOhqxVUaIiXf/Mn/iUs/wmRCE7CUwz4lJijTBG3ytzRbSIWcw
	 svnXx9rREHFdtTzayLv5PvuPMDDjbPvW5QjtOLKTigyjYvw4X/KHA1apcELKvpWIQ+tU7
	 gF0308J8/9gind7a6XwPn0mu48ytrd4+aePfUGDQaZI8x+0rs3kwiD2NjKr9P9A9JwQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=F1nGUUGP;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.61.9
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010009.outbound.protection.outlook.com [52.101.61.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77C53606A32A
	for <linux-rdma@vger.kernel.org>; Sun, 22 Nov 2026 11:02:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 77C53606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=F1nGUUGP
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hVdTMB13Z/Wxle+VMAy91iAWP9JYItEROBy8ISN5TYFMS8a/a3axIO8A2z8Q+HzhMqouwC9ogdmPYP7HzsUtxEEnSFUNcCP0NQiL05fFdr5jLeVuAFGyoxaM6soaNLW2IBDk1krA61xvQ6XuzJ2Cpcvv/wcQ7oiNcTSlYEeKFjnryZhwF3d2sS6gooEvFSFE9aYvX+Dn/p7Wn38+Fg8gsr2Edm3NO/ynBkR+n5DsB8J/68kd/t1Zo5xOCR/Cc99xG5OdKSV6GiQIxRoGZEpB/uAfTFmDr4fHFH6AFsgQXWcGO7G4UoluO8Oh/OCguFHfE9V1YjLBEIc2TSXmJTIEvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6UF7VrQuwXDMiY9VuxYejzMJsLf375oQs9Y11qhoEM0=;
 b=Fbl0AIDR6efFgfZi5S1+OaolSmAR7mXb/w7b0j0Ju/Uc696OuKO4MNc6RlRwnzRSRlvNvRidOl7m5cTMlDhEeEQldM/nQtN1HnPZVNLqgZe32NtlGJXtoK/QuGIgG9oDYrfM/Flgr6w/P7jEWGAnMNIXn1huYqlsPMNKzJzzhBVBczUCZD9Mvoe4qPOQoW/msTfISnw51uFWhKaI9AA88H7uB914SlM9S6qRkBrTjuUbBvgFGVW3uPEXlkFu1twvqw9dpQaF8yebhLowvpg/NuHcEkt+g7x5y+VXKFykBDNuEnsHFuUlR4550toosckGmCfFm1VMu3tvIycFkcqMcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6UF7VrQuwXDMiY9VuxYejzMJsLf375oQs9Y11qhoEM0=;
 b=F1nGUUGPAe98DhZBz4a80pmMpkQGjybb0ul72sIcuF/C0S2yjT3auySVyTdAoz1kvrgGq8O3m9V2SkJQBnK5MAMZg0KsE1xh4XHzpx0cL5eE0rwY2nTYTk6sLsCjjb77lJWi+S2XvbAr9qwB4eatayv0BUiHtzVI/4f2y8CpD2FsIidp9O1V3P/xvnYrtvsCxON/5VjYvIjfhdNy6cvCqWpSf1xKnzR6wsvXine2djazTXZblsXakC9mHKYNvw7EcEwzgAOQCSkt1Bf5SSV0W+Q786cMHZums8h+M2QeFd+2GLjfsi/J1CS3gONfmiT1SUTJKvDbTGxTX17UnudJcQ==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL3PR12MB6473.namprd12.prod.outlook.com (2603:10b6:208:3b9::16)
 by DS8PR12MB899436.namprd12.prod.outlook.com (2603:10b6:8:446::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.13; Sun, 22 Nov
 2026 10:59:24 +0000
Received: from BL3PR12MB6473.namprd12.prod.outlook.com
 ([fe80::778:72e1:e792:df81]) by BL3PR12MB6473.namprd12.prod.outlook.com
 ([fe80::778:72e1:e792:df81%6]) with mapi id 15.21.0639.012; Sun, 22 Nov 2026
 10:59:24 +0000
Message-ID: <7edbb19c-d517-41b0-8dc9-3201d07ed0e5@nvidia.com>
Date: Sun, 22 Nov 2026 12:59:21 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH rdma-next 02/11] RDMA/mlx5: Rename to_mdev() helpers that
 return an IB device
To: sashiko-reviews@lists.linux.dev
Cc: linux-rdma@vger.kernel.org
References: <20261117-mlx5-sd-prep-v1-0-8efd124c7895@nvidia.com>
 <20261117-mlx5-sd-prep-v1-2-8efd124c7895@nvidia.com>
 <sashiko-outbox-221131@kernel.org>
Content-Language: en-US
From: Edward Srouji <edwards@nvidia.com>
In-Reply-To: <sashiko-outbox-221131@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: TL2P290CA0030.ISRP290.PROD.OUTLOOK.COM
 (2603:1096:950:3::16) To BL3PR12MB6473.namprd12.prod.outlook.com
 (2603:10b6:208:3b9::16)
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
X-MS-TrafficTypeDiagnostic: BL3PR12MB6473:EE_|DS8PR12MB899436:EE_
X-MS-Office365-Filtering-Correlation-Id: 66633723-6aa3-4af2-1767-08df4887ab48
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|1800799024|376014|6133799003|22082099003|18002099003|5023799004|11063799006|56012099006|4143699003|261028144727099003|261026121527099003|261026140227099003|261102123227099003|261022105027099003|261022075727099003|261021121427099003|261009223027099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	bHNZQIp6gQ8WM6+CtDeGyg/StZQV0apsXnPhxnYc6Z1ZWaJ4hDAYIufINO6i0Pvh1PK6MM5IMhidbUmEm7HyAnHrTPMPjFb49vSPCyIooBNartmvtTVa08WljDK3tcB1ZPAJM2D1P+/++d0kOOk9UhePAqB3OV+DNZJs1JMvPZ5U0CO/T9crqirNvEed+C8zfEtQaKbq069RO5nIcktWhICL8fD9t3LiqpyCvCooRJIavYtBEscK6HwV3JozjdM/Akb1TLIPb5jF4AELcc/Wr1pgRa3fUsO4+E9maQWkrdqqoQDEM1Ngij3Xncn7AMhZ5xzFLKXEn64CJC2nYhDKA96HosdwRddsoaKROcoyJlY04KwUrZMSGlFdpc7qK8UDYq5VsgxEaqnBRzuy9JW1i1KcuWNNbF3eH3QxUOrSXlr4olXlxjUVmbwl4QK/PIsJ4N7JJ8QbkkN8YTsO9yvrHEdVqGFIovGlJZNaDQfyuKd5WiOB/gTFwBHmQtfKvpA+SEm3PGXb1NA/JDfZLbcAlXnkABEw5+G261fcTKloDeUjI1JVL0rjLVgVfeGtPsOR3VRc0E7Z1bG1bC1lGnR2ubql3rLhZZkyN+8MUUUYzJpXxNUvysmX+U6LEU9VbDndYC753WLwJdq6DxQ6p0E91t/11aUo77CKwIP5UhSO5zE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB6473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(376014)(6133799003)(22082099003)(18002099003)(5023799004)(11063799006)(56012099006)(4143699003)(261028144727099003)(261026121527099003)(261026140227099003)(261102123227099003)(261022105027099003)(261022075727099003)(261021121427099003)(261009223027099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SzZFV2xKL0NpRTgzclhKWDRHYWFGOTZPeU9YNllxV3BMVFNielRhaG1FcDdT?=
 =?utf-8?B?WHlhckR3dTlRL01XN2Q4NWc1ZlRIV3k2TDcwVzI5Q1ZwSVRmQmc5dTlUeDZh?=
 =?utf-8?B?NGNOY21tb0JHS3V4Y1BiVHQxSS90dGZEYnhXUFkxaEJIc2diQkFsL2Jta3pt?=
 =?utf-8?B?WnJtdFJYRi84anlsUXhTNzRKY1ZRRjE3WUx4NnViQjNOVG9BdCtkVkdHTFds?=
 =?utf-8?B?c1BuWExmb1R0OUF1L1BLQWw2eUpQZldVeEcxejZPMHo5dWNVMUZHMGhJcmRm?=
 =?utf-8?B?RGJLWlE4NG9GSk41aG1OdHFHdVY2Q00rempMYTE0WWV3dU5yVGhvT3lSaTk0?=
 =?utf-8?B?YTNaV285NENIV3dOVUk3VW44S3FvVTdpaTZxVnFRN21iRzZEVGVORmMvOE5O?=
 =?utf-8?B?RFhHQkJGK0ttUGcrL2F2S1JlUS9pVUwrOHZqd2tiZVlTNTV5NGh4eUFNSEFK?=
 =?utf-8?B?eE1CN245N2dyMHhPS0p6ZTNDakduNWJSNWN0b1puTU8xVHJUbURMc0hLNGs2?=
 =?utf-8?B?blJscm9pd2hVdTh5UU4wOHhNUkFVMENQVmdSNU5EV2dHRHYwN3FWSzIyY09X?=
 =?utf-8?B?WjlNQVYyYXo0VnhJRzZVV29rYmpCVi9OanlGNnJFODR0alJpZTA5bGtNcWF4?=
 =?utf-8?B?MStjWVVEWmdnaUwyTk1XNWQwSitYL0g2dFVyZzdvWUlidVlDM0l1SXo2bHly?=
 =?utf-8?B?MWtmWVpZV2hSTnJhMEhhanEzWlNJVDhlV0czcHVQNFgyZkplNDlaUFRFc0hh?=
 =?utf-8?B?citxdGppTFhWaDVnWlI2dCs4RXdOeFJlUDhvZlNkell5NUZGZGUxZGxZaUNk?=
 =?utf-8?B?OWlsTWVWOHJka2x1TFhKWEZVTUlaeVNGRTV1MUxlU0V2VE5MaXVwZXN2VWEy?=
 =?utf-8?B?anpCMDNjWUdLakFOME5lTlU4QStBRkg5bnlFZUZWRytrT3F3Z0VGSjF5blZM?=
 =?utf-8?B?RHZHWU10WTBFeEJYcHgxeU9oRUVkYlh5eFFOYytDaDFacE1pZmNleVZPVzdU?=
 =?utf-8?B?eWQwQnFMOWV1TW10emRURnRLb2paTmVPSldrN2JzV01XN0VnYkNUOW9DQzJH?=
 =?utf-8?B?cmlDbW85aFdBazJ4SVprVFlmSEpxZytaL1BSWEo2TXVxRm9RTCt2ckJETXpJ?=
 =?utf-8?B?M2lMNHNncURjOWQ1em9mWnJNTTFwaE04ZHRmbFYyWEp4QWxVbWJrV2tiRlAy?=
 =?utf-8?B?NjVKMWZxaDMyWllTY051dU5aS2lsOEJrZUt5MEhXR29hOVRzSUsyZU1KRkw3?=
 =?utf-8?B?Y3B6cmRnTkFUZjRldVpRSFM0U3Y5N3JrQm44cEI0TXZBakUrUzJrSWV6bFZJ?=
 =?utf-8?B?QnFRRURZRkR5S0wwRzBQMFdqYTNwaVhmSzlVUTd3bUExNXNMK1ZtYjlHMUJ2?=
 =?utf-8?B?aGFLcXNONFNwWE1iYnVFMkp5ME5aMnZnU1N3MWkzaUFtSmZkNUFXN2YwdHAw?=
 =?utf-8?B?aVdudE5ZZnBiczJpZ29MenY1ejhiTmdGTEhUVVJ0cGVHODR2TjdMemh4QmtS?=
 =?utf-8?B?UkhHQmlkbkdPWGsvd2V1RnEwWFVDK2hTQjR4Yi9NTjhqV3N1WlRXRHhYUFJ6?=
 =?utf-8?B?MlRqbmVWKys1R1pqeldsNVBSdUdPN1NCNSt6REhEc3kySUIzbUpBQW1kQlNF?=
 =?utf-8?B?ZS9NaDdiZ1dlVCtaME5Md1pSRE54ZjVxOFI5eU1hd3ZsTXI1OWViRUVPUndo?=
 =?utf-8?B?R0VBY1FEa3FJZ2RNL28rdzZKc21yWWk0OGlFRHNuNGJXdUtoblZISGlEYWJt?=
 =?utf-8?B?RjhUMURmRFJlVElRNlRKcXBpL1JJZENvdkJiZGl0OWZwc3JQdDRISW92Y1BE?=
 =?utf-8?B?VnRXQ2N6MWtVM2xMY2JQMjhCckh3anhqczA1bG1jNXVQSG5zVlhTZzR3RHRZ?=
 =?utf-8?B?bDRoaCsvUHkzMjZGT1d1cjN6UWwzdXIxRDM2MGJDb1ZCWVFTdDFDZ1hHZ05P?=
 =?utf-8?B?Z0g5YnpMMlc0NTl6Z051eFdDdUZ2UEliTnY3Smc3WldmM3ZKTW1XMm9kYWR4?=
 =?utf-8?B?MnlCS1Z1ays2QkFVWlJTQzJIbmFDMjFQT1hOTEl4NlBUUHpmSEUwd2hud0ZW?=
 =?utf-8?B?ZFZrbnRSUEpEWVkyUkIvZ1o2VU0wOSt2VUhrUHFGSjNjdXNQTmhaK2xKTzVM?=
 =?utf-8?B?bG9QWW5LNit4NHNPeURwb0s4Y3BpZWN3UytONEl3dlNwbEdRRXYwZzBVYkc5?=
 =?utf-8?B?aUtXY0Q3MDcxZEF0MmpDM0VIRXZGdkhqV3RYNlZDbFpTdnhoeml1U2FXMGhW?=
 =?utf-8?B?RUN2UUFhb2xnMlVHRnhHSmlkZzJTVHlrTm1jRmtuVkxaR0cvS2RPZ1k4Qld4?=
 =?utf-8?B?Z0dkc1E1a0I5QUhlRjdISHN1Z3p3aU1TYitDcy9DZzlIY0FZS2Q3QT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 66633723-6aa3-4af2-1767-08df4887ab48
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB6473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2026 10:59:24.3064
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +8RIkJ2+cPux5FeTcgQt8KqyIjV/OH15Y6bJDeCBLXC2idfFJLXsvA0ekjg2jAVgKp9GvLi6kVcP0z4lKMx5tQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS8PR12MB899436



On 11/18/2026 4:04 PM, sashiko-bot@kernel.org wrote:
> External email: Use caution opening links or attachments
> 
> 
> Thank you for your contribution! Sashiko AI review found no new issues
> in this patch, but noticed 2 related pre-existing issues it does not
> introduce:
> - [High] RDMA/mlx5: memory leak of implicit child MRs in
>    mlx5_ib_free_odp_mr() [1]
> - [High] RDMA/mlx5: NULL pointer dereference in mlx5_ib_wq_event() [2]
> --
> 
> commit 19b81e90add2578f27e3e1241ff81dd5b9fdd061
> Author: Akiva Goldberger <agoldberger@nvidia.com>
> 
> RDMA/mlx5: Rename to_mdev() helpers that return an IB device
> 
> This commit renames to_mdev(), mr_to_mdev(), and mlx5_udata_to_mdev() to
> to_dev(), mr_to_dev(), and udata_to_dev() across the mlx5_ib driver to match
> their struct mlx5_ib_dev return type.
> 
>> diff --git a/drivers/infiniband/hw/mlx5/odp.c b/drivers/infiniband/hw/mlx5/odp.c
>> index 0b1b63d36e4bc..a4318b11cd81b 100644
>> --- a/drivers/infiniband/hw/mlx5/odp.c
>> +++ b/drivers/infiniband/hw/mlx5/odp.c
> 
> [ ... ]
> 
>> @@ -680,10 +680,10 @@ void mlx5_ib_free_odp_mr(struct mlx5_ib_mr *mr)
>>        }
>>
>>        if (mr->null_mmkey.key) {
>> -             xa_erase(&mr_to_mdev(mr)->odp_mkeys,
>> +             xa_erase(&mr_to_dev(mr)->odp_mkeys,
>>                         mlx5_base_mkey(mr->null_mmkey.key));
>>
>> -             mlx5_core_destroy_mkey(mr_to_mdev(mr)->mdev,
>> +             mlx5_core_destroy_mkey(mr_to_dev(mr)->mdev,
>>                                       mr->null_mmkey.key);
>>        }
>>   }
> 
> [Severity: High]
> This problem wasn't introduced by this patch, but can mlx5_ib_free_odp_mr()
> leak implicit child MRs [1] when a page fault races with teardown?
> 
> mlx5_ib_free_odp_mr() drains mr->implicit_children before removing
> mr->null_mmkey.key from dev->odp_mkeys:
> 
> drivers/infiniband/hw/mlx5/odp.c:mlx5_ib_free_odp_mr() {
>          ...
>          xa_for_each(&mr->implicit_children, idx, mtt) {
>                  xa_erase(&mr->implicit_children, idx);
>                  mlx5_ib_dereg_mr(&mtt->ibmr, NULL);
>          }
> 
>          if (mr->null_mmkey.key) {
>                  xa_erase(&mr_to_dev(mr)->odp_mkeys,
>                           mlx5_base_mkey(mr->null_mmkey.key));
>          ...
> }
> 
> Because null_mmkey remains in odp_mkeys while the loop runs, a concurrent
> page fault can still look it up and insert a new child MR after the loop
> finishes:
> 
> CPU0                              CPU1
> mlx5_ib_free_odp_mr()
>    xa_for_each(&mr->implicit_children, ...)
>      xa_erase(...)
>                                    pagefault_single_data_segment()
>                                      find_odp_mkey() -> null_mmkey
>                                      pagefault_implicit_mr()
>                                        implicit_get_child_mr()
>                                          __xa_cmpxchg(&imr->implicit_children, ...)
>    xa_erase(&dev->odp_mkeys, ...)
> 
> The newly inserted child MR and its xarray nodes are then leaked when the
> parent MR is freed.  Erasing null_mmkey from odp_mkeys and waiting for
> in-flight faults to complete before draining implicit_children would avoid
> this.
> 

The race is real. Not going to fix in this pure renaming patch.
We will add it to our fixes queue though.

> [ ... ]
> 
>> diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
>> index e4f18f7567d67..da4e9a52d2f9b 100644
>> --- a/drivers/infiniband/hw/mlx5/qp.c
>> +++ b/drivers/infiniband/hw/mlx5/qp.c
> 
> [ ... ]
> 
>> @@ -5331,7 +5331,7 @@ static void mlx5_ib_wq_event(struct mlx5_core_qp *core_qp, int type)
>>   {
>>        struct mlx5_ib_rwq *rwq = to_mibrwq(core_qp);
>> -     struct mlx5_ib_dev *dev = to_mdev(rwq->ibwq.device);
>> +     struct mlx5_ib_dev *dev = to_dev(rwq->ibwq.device);
>>        struct ib_event event;
>>
>>        if (rwq->ibwq.event_handler) {
> 
> [Severity: High]
> This problem wasn't introduced by this patch, but can an asynchronous WQ
> event trigger a NULL pointer dereference [2] in mlx5_ib_wq_event()
> before the RDMA core finishes initializing rwq->ibwq?
> 
> In UVERBS_HANDLER(UVERBS_METHOD_WQ_CREATE), the core sets wq->device and
> wq->uobject only after ops.create_wq() returns, whereas mlx5_ib_create_wq()
> sets rwq->ibwq.event_handler and activates the hardware RQ before returning:
> 
> CPU0                              CPU1
> UVERBS_HANDLER(UVERBS_METHOD_WQ_CREATE)
>    mlx5_ib_create_wq()
>      create_rq()
>        mlx5_core_create_rq_tracked()
>      rwq->ibwq.event_handler = ...
>      return &rwq->ibwq;
>                                    mlx5_ib_wq_event()
>                                      dev = to_dev(rwq->ibwq.device);
>                                      ib_uverbs_wq_event_handler()
>                                        wq->uobject->uevent  <-- NULL deref
>    wq->device = pd->device;
>    wq->uobject = obj;
> 
> If an event fires in this window, rwq->ibwq.device is still NULL (crashing
> in mlx5_ib_warn() on unexpected events) and ib_uverbs_wq_event_handler()
> dereferences a NULL wq->uobject.
> 

Hm... I'm not sure if this is real. The window is between create_wq() 
returning and the uverbs core setting wq->device. A WQ is created with 
its RQ in RST and is only moved to RDY by the user's modify_wq(), which 
needs the handle that create_wq() has not returned yet. An RQ in RST 
does not process doorbells and has no TIR or RQT referencing it, so 
nothing can raise WQ_CATAS_ERROR before wq->device is set. Only uverbs 
creates WQs (both the write and ioctl paths set wq->device after 
create_wq() returns). ib_create_wq() passes no udata and mlx5 rejects that.


> [1] https://sashiko.dev/#/bug/linux-f9cb6026-426e-45f3-b251-f749672898fb
> [2] https://sashiko.dev/#/bug/linux-63691fc3-b762-467d-89ea-1bf281490cc3
> 
> --
> Sashiko AI review · https://sashiko.dev/#/patchset/20261117-mlx5-sd-prep-v1-0-8efd124c7895@nvidia.com?part=2

