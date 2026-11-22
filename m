Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.193.28
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795351286;
	b=hNSFR5qKbsqTJtM8B3APMCr0gLE0MU4CpUKaN31p8x2+3uJiLQSdiXD8C3044vw3yhdO
	 gCzFTKNhBLnqt+4jmfhy4LpLJxuXHTg82LM5a5TXQUdrvv0yLEiPRT+DPr3tzk5/KI+lV
	 cBfLQrsGUx3R0GJX41akydmDPW6hIGJvr4Je4NtfuKpQFhhNXq10u9B91xndPvOEWNYgW
	 6TTFBJUy/dRh1llXCpsd/MxSP8yAgy1v/l1qr3JHNLYqDBxUNnQ9EzZXlJEOc6H3SoPun
	 LD2C9NOIJNiYC4MJGv749Syg2bSWL0Y5wWcsoXOwFKYcBFfbsUw/4CABToOqPguqlEA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795351286;
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
	bh=naDP2vrLXbZWA2DqoKqLmT5x74aTIufaJWdXRRLJoXc=;
	b=tAz5y9My2LD3Jkx5ivHSpAOLZhHP/d6mi/Ycnr+w3KjGtvCKa/fx9WSr2mw5nXrwFUhv
	 l+nCOtSLifd3NqYCUNryDtKDGHOTGkLkKiU/mDVSCoW+ZaIf/f04tIvUsuwMLouGIM41M
	 SNEBvkkafKnAu99c5FARYWFH80thAViulETDE0dGA73TAgQnsFMqfoRltu8+ORnswcfMG
	 mYywsZsRLQg8tIH9wzGPuxt1CMewucW8AcIcXeX51lD7f1o882JImbR+jrxQ/Sd4Fg8j8
	 uYRtNLacxYM1yylvq2cP364cpiYhLKlZytboU4r5wxQUPxh8VLipdF6IBnbwdqTr2hQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=oF3Fwv0V;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.193.28
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010028.outbound.protection.outlook.com [52.101.193.28])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57119606A320
	for <linux-rdma@vger.kernel.org>; Sun, 22 Nov 2026 12:41:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 57119606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=oF3Fwv0V
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=og+26xISnu6oXW4hNm8Cu2nLz7LUAiqGc4K9n7cmYRlwWT8I6pzhqS7qbVS2U0z7Wxhmwg8rG4395HGiVXyOG000CmTuvBFEihAG/WFxhfxS9HqCdhdvuOvY5EiUX0Vn+ltU8mTic1sxeLSGJ+X3Wh2+mOAuerI1WNvEv1yGRflWmPEJ9VGRbntG3oN9ASBhUTVCXBknm23hXInuOmEG6yL4PXPP6XiKup6FUj1Is/T3zMBAXc/75J5VWp+v2dZhrHaWDyPrfMjQT2oS42RQlrKP3hJNjICZ3d1FMloovzJ45jLCOUYiBKLEXzassQThlt+brwELj/xtufCknX3ePA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=naDP2vrLXbZWA2DqoKqLmT5x74aTIufaJWdXRRLJoXc=;
 b=WVq+1QVaA+Hqckfptnxgw30h/26rAE8vnALrzofpcooteEPM4hLEB9zN0B//MW4bpt4X7cWGVF6zioAE86QJUSCV4okveJQFbeB2x40No2lZxAHjjg2dGWFwW99eR2H+r3QAiesbs4py59Jr8nvn2u+Mg2CLJxJi6kWQ2fSSwC/y+ktFLEDRuW+X3y5I2DePmWQPohyjaYCIpuIGZ1xR/6ORxvBYE8wrdzVfvptGlHAqm7rlwEC6zMX1o6Cszu/a10B/83yD2efICt5Zu4d7dmYQrq0+u1vLJBTIA0q6QmKTomxWQqLVEwWy7kDYazsC3ucA7mp4WSEuCsYA+cEtxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=naDP2vrLXbZWA2DqoKqLmT5x74aTIufaJWdXRRLJoXc=;
 b=oF3Fwv0V2Mh5GicDW8gEyzXF9J5mIzJzDFQq9Q53UeASkCs7jW11zBDZqsPvMmLwYSLSRf+cNxz8x6DEmqd9FWwBybJuFXGbn6cXDX7cucN+8IPfJvl9JZefUKOibpeVyJB1T6j6VuefvU3JsdWgVixlFMkeEjFuFASilFTYLMdUiORtElSSqDkE31cKbWuCKGdzJOwufLJb5TtsDd/sUKar1Hou3Sy3EZ07lJtyrdJZaEJE87GYO9GHh5UxP4Ejm5hkLkbGtev970LnYZgkxyugJJjaZCeFMDUH+iJowGAcNtNHkh2UwIOVgh9F4hvD5qSocw5HZnLhHi5BPt8mKg==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL3PR12MB6473.namprd12.prod.outlook.com (2603:10b6:208:3b9::16)
 by SJ2PR12MB8160.namprd12.prod.outlook.com (2603:10b6:a03:4af::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.13; Sun, 22 Nov
 2026 12:41:21 +0000
Received: from BL3PR12MB6473.namprd12.prod.outlook.com
 ([fe80::778:72e1:e792:df81]) by BL3PR12MB6473.namprd12.prod.outlook.com
 ([fe80::778:72e1:e792:df81%6]) with mapi id 15.21.0639.012; Sun, 22 Nov 2026
 12:41:21 +0000
Message-ID: <37289b87-4e90-4e1d-b793-f99f57135975@nvidia.com>
Date: Sun, 22 Nov 2026 14:41:17 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH rdma-next 09/11] RDMA/mlx5: Cache the CQ core device and
 resolve it via cq_to_mdev()
To: sashiko-reviews@lists.linux.dev
Cc: linux-rdma@vger.kernel.org
References: <20261117-mlx5-sd-prep-v1-0-8efd124c7895@nvidia.com>
 <20261117-mlx5-sd-prep-v1-9-8efd124c7895@nvidia.com>
 <sashiko-outbox-221138@kernel.org>
Content-Language: en-US
From: Edward Srouji <edwards@nvidia.com>
In-Reply-To: <sashiko-outbox-221138@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: TL2P290CA0002.ISRP290.PROD.OUTLOOK.COM
 (2603:1096:950:2::12) To BL3PR12MB6473.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: BL3PR12MB6473:EE_|SJ2PR12MB8160:EE_
X-MS-Office365-Filtering-Correlation-Id: e98437cf-6ae1-45c7-810f-08df4895e94d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|1800799024|376014|10067099003|56012099006|11063799006|4143699003|261026140227099003|261026121527099003|261028144727099003|261022105027099003|261022075727099003|261021121427099003|261102123227099003|261009223027099003|18002099003|22082099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	3AVXAYDK4zbnScAFuQCn4lrlt7H5kWmq/Jok/UQ7u3ZA28GHMBnWWYqLjUaPHLaUGQVE/DuRBI08hqQPqjVhaaHVvAyaDb9MDKl785SLIKBLC23QUdZwYSAuntz1kHxtW6Yoci236pDi+XnoXJdFZmQyo2SY132fU630g2oNvGY4BOfEKvVZsvgFp38uEo29wLZhjb4hrmlD5jDJOiuPK4Gue5SLOa8J1xjYV1BZcopHYDOQMulsHos6IdXGKRHoXvQZszB+tdo8PVsV6KDo36hp8nCWE1uNAOPJoOLr32JJH2KujXODZ4gB7cbQOq+T+BV6QlD2/++MUjSZ5nh+kGBX1Z0tWZKOqY1iKvuX10+kTioJQiU3g40lJpkjd78zzdnZ6x9cQnmrvmgZ//XXiFECjHftxV/YR23WwC8B1mIyT0KO1f0Xlx6CcrobHv21ubY/UYsqVkQ4/XFMtM0LGra452OBeASf+q0jOlweS/dhOicahvMTXzNkXc6dCPNcQqcrfu9eJBmDNyYPmvcBg9a39DUWFNyDohoAR4qfPtgd2efizqhq6mZoA1qIEQXU30voNZUzG6c//YSKXx3RpHe0lI+QIerc2zA/BYfLYTl6/sc2UsKdOqwZhatOWZnmu3xqlcQ7G1HEhBdvXPgfqegr8XFyTF+ttb7cp1cuB0Q=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB6473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(376014)(10067099003)(56012099006)(11063799006)(4143699003)(261026140227099003)(261026121527099003)(261028144727099003)(261022105027099003)(261022075727099003)(261021121427099003)(261102123227099003)(261009223027099003)(18002099003)(22082099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZHpzdW1tTklSWmtnQUNrOTlQYW15RGlpK0tQMDFCd3N0dXh2R0NIby9tSUk0?=
 =?utf-8?B?TUVYWGFWOVI5enh1UGgyckNRb2M1Sy9QTnZnTjM1TTlNRFJsaWo1ZFhxNkdh?=
 =?utf-8?B?K0pXUFFscDVlQXNRcktJM2FBdnY1VVhWaE0zMUQxV3lLQm9PMHM0OGNBY3lR?=
 =?utf-8?B?d2hzRE5nQUdhZDlqWGMrS0IxeVNWL0N3NWJkYlRSODVJMGUwVVBjbC9jOWlV?=
 =?utf-8?B?WjhBMkdtMW1hYTg0eFUvUzh4eHR0VkVORzRLTlBWNDdPYnNMZlhXVTVnS2g5?=
 =?utf-8?B?UDNLSDVJRkRmLzNmOEt0UmtxYW5GRjJxZTdMWXlTWVZCWTFTVmIwT3Jod0Y3?=
 =?utf-8?B?N0ZsSGdoWnVCeVpoeUhuT00rWU81ME9Cc01LRnVjL2tLTXFYTlJRQnV4T1dq?=
 =?utf-8?B?WitacVVtZWpxSW94YzRLWHVPbExBVjVzaUVwS1ZQRjBQTWY5bzVqK1FxWldi?=
 =?utf-8?B?dHUrOTVINEIxTkJ3Y25scUFnUlN2WGdPY2t1VjNwQjRobk0vQ3FmanlJZGdT?=
 =?utf-8?B?Sll1c29CMEErSWQySXh5UEJmbkJhcm1HdThYRU5ERzAvYnhHMTUweEF6K3l2?=
 =?utf-8?B?UG9IL0VjTzAwcWNOWFdNTm03N0ZEaysyNlg3dnpMOCtBdWlpd0Q5THpqeUtj?=
 =?utf-8?B?UTJyVjJyYXRQcERzMGZtQ1lCMW9GR01nckN2UEJ5Y1liVGJCemprV3plaXBY?=
 =?utf-8?B?SmMwRlFRV1hYQ1hxUVJPQzlHWkdtUCtrTHYxQm5yTlcwTkgrcENTUUtjSVFi?=
 =?utf-8?B?SnJmc1piMHRseWZybXVWaFFwdkJoUitwMTFXbTFzQzYyc3ZDRmdhL2l2U1hq?=
 =?utf-8?B?aHZDZGhQQlFpTnZvVGFJS1Z6ZFBpRjBRaFNFWmVhVUNSTmV0M1FUMWx6OG9M?=
 =?utf-8?B?OHp3K2U0WUsyLy8vMk5hS3R6UkJ6aVVPUHcyMVR5dHFlV2taeE82RXV2bis2?=
 =?utf-8?B?NkprZ0JWN0VIR2dWSUhjd0J6bkQ0YTRlMU1tUWJhQTF6OHBHNVIrS1ViRVVv?=
 =?utf-8?B?b3RoOXJhNEVrUWoyMVdHeStwVjhHbFZIL3hFRWNveVRkYlFaMU4vQ3ZEOFc1?=
 =?utf-8?B?Ty9NMWdQUGV3dkhKNnMxNFRKQXF3eFpxT2RnenRWMWhVNS82cWVFUG5DVTl0?=
 =?utf-8?B?dXJTQUFDcCtlNjZ2QWRsSzZGUkhLUEJYeVhTMUhVTVE5RFNXYlJQb1BIeFEz?=
 =?utf-8?B?bG01WktOdGNHbmNwV0U4aXJGaG5MRDYrc1pzaU0vMW4zUm5MenZvdzNMVTlC?=
 =?utf-8?B?L29MNDEwd2x1bXhadkVZaEpQSlJYN1VoVm5hVkdGbzFCZFhLLzVRcVdLRW14?=
 =?utf-8?B?eGREbmxuYUQ5THlxZ0xvTzdVTkJFVFh5YW1rUktOdDFOZTUraVA2TDhoRnFm?=
 =?utf-8?B?RjBiTHQwUTk2L1BSdW5ML2JsQmRqZUQrMWNvRmo0OWJONVNSZDFsNWZidVk4?=
 =?utf-8?B?bTI3aGxQZVVkZXN2V0Q3UE1lMWJDQUl6L3BGQ0JHL0VXM0R0UGk1ZTBFdVN4?=
 =?utf-8?B?ZHNIa3lxenFFOWV4dHlqYjI4dTErSU9aTXB6U1RSYUZOdG1wNDluM0Mvbjd5?=
 =?utf-8?B?cHVOMlpqNUdsK0tlQ2NEZy9mcVhlV2NEYlVQVms1dk04L0djUlpqWnZWbHZY?=
 =?utf-8?B?WmZTTVNGZ2xJK29tVU15azhRSDB2K0RvaTNzaXoyOFdRS09qYVBGSDdVMTRU?=
 =?utf-8?B?cDdEY2w3ZGorZHlSM3VwbVN5K2JYWU9pWGZMNTB3VG5UZ3BvZnBVdnN3VWpQ?=
 =?utf-8?B?MWZEL1d0Z3lLMmhkWlVtSGhFejV2bUZlRU9ZNC9mM2tkRE1ENW1EOEc3ZXlR?=
 =?utf-8?B?NjBNNi9vTlhqWVdZcnB6QUxudk1ESUFYb1EzZVBYUXl2NVFWRk9sOFBVZXVW?=
 =?utf-8?B?Rzh3UG9YKzRJd0M3aTd0WnVadnFOcDcxNXd6WU55SXlJcTNIaWxzYzY4dlRE?=
 =?utf-8?B?SGJwTkI3alhRSXZVdTNNMm1nYStRbUgwMXhnYUVhVkNBbmUyT1NoYmduMU8z?=
 =?utf-8?B?czQvRTRMVWVKenpCdWdGdmNoRGs3R0JPODU2VDJYcVJCeUQrWWU5NFJ1SzdW?=
 =?utf-8?B?WkpvYTJLN3JhOXlXZHJ1b3I5R0RsQzhTb2tEWjZONTVqbHMxRHRuNzhNREcy?=
 =?utf-8?B?NFJTMGgrZFNYUlpDNkV0RDVMVE5IRzdHUm90ZTZuQTdwZXF4aGp6UXQ2OEdt?=
 =?utf-8?B?UFplOEVtNS80TkMrTDNpUE9Sc0J5anI0TG53TmtCT1QzMmNHSUtrNHUvY0N0?=
 =?utf-8?B?R2FqcEZTS3Z0UFc0d1hnUWNSb3g1azQ2OGNSUWhwdVoraUFFTDJVejdmN0Ey?=
 =?utf-8?B?MTNaUWFjRURlVlp3VEpzaGZQdVhaY2JnYmQ1Yk9Ma2FKRmJKSEdZZz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e98437cf-6ae1-45c7-810f-08df4895e94d
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB6473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2026 12:41:21.3394
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lzEC4h/utOnevBwWi6BLz/qSOhdMBNNAZ9st2Ph58m5eElOSdMY4vacY8snMleVuCqn/IEl/OQrRl+YLBk+5Vw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8160



On 11/18/2026 4:04 PM, sashiko-bot@kernel.org wrote:
> External email: Use caution opening links or attachments
> 
> 
> Thank you for your contribution! Sashiko AI review found no new issues
> in this patch, but noticed 1 related pre-existing issue it does not
> introduce:
> - [Critical] RDMA/mlx5: hardcoded CQE size breaks kernel CQ resize in
>    mlx5_ib_resize_cq() [1]
> --
> 
> commit f7f9b358d0115bb8244e5cdf7d781d650dc
> Author: Akiva Goldberger <agoldberger@nvidia.com>
> 
> RDMA/mlx5: Cache the CQ core device and resolve it via cq_to_mdev()
> 
> This commit caches the mlx5_core_dev pointer in struct mlx5_ib_cq at CQ
> creation time and introduces the cq_to_mdev() helper to resolve it instead
> of going through dev->mdev.
> 
>> diff --git a/drivers/infiniband/hw/mlx5/cq.c b/drivers/infiniband/hw/mlx5/cq.c
>> index b28ce05fab8f3..5eaf50fe7f540 100644
>> --- a/drivers/infiniband/hw/mlx5/cq.c
>> +++ b/drivers/infiniband/hw/mlx5/cq.c
> 
> [ ... ]
> 
>> @@ -1394,7 +1398,7 @@ int mlx5_ib_resize_cq(struct ib_cq *ibcq, unsigned int entries,
>>                struct mlx5_frag_buf *frag_buf;
>>
>>                cqe_size = 64;
>> -             err = resize_kernel(dev, cq, entries, cqe_size);
>> +             err = resize_kernel(cq, entries, cqe_size);
>>                if (err)
>>                        goto ex;
>>                frag_buf = &cq->resize_buf->frag_buf;
> 
> [Severity: Critical]
> This problem wasn't introduced by this patch, but does hardcoding
> cqe_size = 64 here break kernel CQ resize on systems with a 128-byte
> cache line size [1]?
> 
> mlx5_ib_create_cq() initializes kernel CQs with a 128-byte CQE size when
> cache_line_size() == 128.  Allocating the resize buffer with cqe_size = 64
> causes copy_resize_cqes() to reject the mismatch with -EINVAL after
> mlx5_core_modify_cq() has already modified the CQ in hardware, leaving the
> software and hardware CQ state out of sync:
> 
> drivers/infiniband/hw/mlx5/cq.c:copy_resize_cqes() {
>      ...
>          ssize = cq->buf.cqe_size;
>          dsize = cq->resize_buf->cqe_size;
>          if (ssize != dsize) {
>                  mlx5_ib_warn(dev, "resize from different cqe size is not supported\n");
>                  return -EINVAL;
>          }
>      ...
> }
> 

Severity is overstated. There is currently no in-tree path that can 
trigger this issue since the only caller of mlx5_ib_resize_cq is the 
uverbs user resize_cq cmd which always carries udata. The "cqe_size = 
64" line only triggers if udata is null.

> [1] https://sashiko.dev/#/bug/linux-a14c4506-9ca5-444f-8be1-7990d9e001b0
> 
> --
> Sashiko AI review · https://sashiko.dev/#/patchset/20261117-mlx5-sd-prep-v1-0-8efd124c7895@nvidia.com?part=9

