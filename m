Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.85.71
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795350754;
	b=xailO9H2wVxrc1gYLbbmRcizP+glUNWeSN5Lp6Z/tdk5h94EyM0OyQLm4KcOnV1eDXxA
	 xLO9yJyb1ozMRaoT5gHgIQfIfRuFFGYVOb5CHQyBQG1xHIp/kvUEKpd/AnT0HY4il/vke
	 R51v1Ollqf/hunxOX2rg0LidOeKPqubh5B8ofIFRzTSk9myA9UZQjuNhv8Q83himnzZ4C
	 +0OB119FhIu+wgq2oIEQ7BlHamLXIDS/T7Dj5gEgZgTGVbvDKrr6e2CGdzi584jaMjY4S
	 Hl1G5lzFldkMGB15t8oarURC7sCbBMh/UV3KoZTcIuqJhvwWvWTwTTdnzX+HCIgD2Fw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795350754;
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
	bh=eXbgwFGaJ8jvREqzxTBt8W8Z0Q8jgdvgqOffYGhE4jo=;
	b=WpjxK4zJ2HHL/yUHFe9TlY6AVar8AoqO9FsosOrW1PCNVF1JFki7OGEsn8ZUvRmApNhq
	 9cIwypr3NhZ07DeVnDZxbdGjm7WT0TjHwwMAwBpATmCC1uiVhm1Ip3FxAF1Ido85lJPIO
	 M1U0uoCDC36aywYQzPGN9QTdVckXbnl2x5DOLAOyAeCT2tCyp1gy0FfD/IeIqCm4rmmiJ
	 nOd2dxvPrqTJ+JO8+0slyaDDBfmqUwmQnUzduDFyRgK/YgIKTbDwQdPMIGzD+ZxFndi2S
	 AUmiJkyo+jgdjCC7nbzhXuz5LORUuTPjLVRz0rsb0U9e3ui1NWI/YH80ZoWW9OO9giQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=N2qalSkb;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.85.71
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010071.outbound.protection.outlook.com [52.101.85.71])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67568606A320
	for <linux-rdma@vger.kernel.org>; Sun, 22 Nov 2026 12:32:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 67568606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=N2qalSkb
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nNVTYNiDkxeUmXZIf9H3t43S51YNpm2lPl12XL4OZ7Tx6vuJbSkf43vkqBWgA2W45uqn0IYdVW8qPz1JCtgig7RKJX00VuS4uWIpVczeh/xF/0dP0BxoId5xm+sdh4W8XdDJ8wGCnFV1o3yaiH0Byzo35At78eHyaNW9R3eArBm8y9CxbGe4M/+7BHzUg+KcNB0B0rGrgenlUSUza+ntWoo650tAGv1+li70SfqSp1OgBIHDXsRtK9L75G29tSM604qkf6Q9EC7THLfZNHzp3KpyS6MT9VUsSpnsTWSQaDcU4coe3qFQsggu3+FkGX8NopDIk8wXpr7S2vc3cHPBpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eXbgwFGaJ8jvREqzxTBt8W8Z0Q8jgdvgqOffYGhE4jo=;
 b=SdawPHy/SzBuJyqyqpkxNK/B/S/+7zS8cjmthpvI6vMNKrI3+z67t6ToN2OeoPyQapMym86BWPp6J9P5pEYhViJ9JJZ0K6kH84+HCbDHVG8qJ5ZSYFWXO3A8WBRNPMjU8q2pGMr3UBuegFU8HzJ4u69Y7ghmZY3smxYKRLCO6Bwz+n5NiBjo0sdtwHEG9KvKWFEp7n+tP+GeCfjb0WOucSFW2LAvoQ2J8Yb84UksAHBGhQweQ+WtCyntBU+XfNnmnday0rqZAUyB4u+v53ooW2bZ4boPnEbOTH/dYxvN4UPr/kjHy4/SiaS1uU71a3ld5xRxq2SY91RZm7JHrsLQZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eXbgwFGaJ8jvREqzxTBt8W8Z0Q8jgdvgqOffYGhE4jo=;
 b=N2qalSkbFaRb7ik0BqDPNONMweQ3yULPjaQmSYWlXGAKIK+QyTcNDPtdt0lG4+UWzOZvqQOslD0I9moLCCvkV5NFuNJGLSFn/mYkdF6Fkk4wRzreB/irbxzskma+KnlMiLhorxuowU016O8iOfN5GtStj3ct8QChOc2wTPd7dGA/j64AzUlaXgudxkQijpNJ+5M6MdeEXQvRFP3VIiGMxYmWPeUggBMw/HExpYRxrSNl07r6C1DyQci+jPg05hbWWqhX7CNjc+ZGy47uLSjlVNHjULMw0Iyij2VOs6MWxQh3l1m3VzpRyLvWQz7iPDwk5NwUu2qga6oJHTPGBojH1w==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL3PR12MB6473.namprd12.prod.outlook.com (2603:10b6:208:3b9::16)
 by PH7PR12MB8015.namprd12.prod.outlook.com (2603:10b6:510:26a::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.14; Sun, 22 Nov
 2026 12:32:30 +0000
Received: from BL3PR12MB6473.namprd12.prod.outlook.com
 ([fe80::778:72e1:e792:df81]) by BL3PR12MB6473.namprd12.prod.outlook.com
 ([fe80::778:72e1:e792:df81%6]) with mapi id 15.21.0639.012; Sun, 22 Nov 2026
 12:32:30 +0000
Message-ID: <4598e9d5-342f-4345-b90b-0510914b300d@nvidia.com>
Date: Sun, 22 Nov 2026 14:32:26 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH rdma-next 05/11] RDMA/mlx5: Cache the MR core device and
 resolve the MW's via its PD
To: sashiko-reviews@lists.linux.dev
Cc: linux-rdma@vger.kernel.org
References: <20261117-mlx5-sd-prep-v1-0-8efd124c7895@nvidia.com>
 <20261117-mlx5-sd-prep-v1-5-8efd124c7895@nvidia.com>
 <sashiko-outbox-221134@kernel.org>
Content-Language: en-US
From: Edward Srouji <edwards@nvidia.com>
In-Reply-To: <sashiko-outbox-221134@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: TL2P290CA0019.ISRP290.PROD.OUTLOOK.COM
 (2603:1096:950:3::14) To BL3PR12MB6473.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: BL3PR12MB6473:EE_|PH7PR12MB8015:EE_
X-MS-Office365-Filtering-Correlation-Id: 96a690cb-635b-4fa1-c137-08df4894acf8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|366016|376014|261026121527099003|261026140227099003|261022075727099003|261022105027099003|261028144727099003|261021121427099003|261102123227099003|11063799006|4143699003|56012099006|10067099003|260925022911599003|260925021911599003|260925021311599003|261009223027099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	zmAiTg/MawsTei2BT90LxbvJl+hNHr2wzPvmvBjqwKA4keI3hla8H0JYKD7yNOUREVXUmgp26+Cb3Od9mx4WhHCtXEFNOPxgNdLyIKtD3rBzHH0tJFYchZ53BMdbufx4IXZpCU3C5BYqMUS8QtZH/p4KNDpE+U11BljR2tAsrK2xM+lakggYLq0aKCWtm8ZYkr6Fp2mgYZ9idMcVAoqufGcC8++7+ft6YD9kXqDBI4q/X4gGccyTh7ZTn6a/WhePwiLHqKk9KLPZR5Q+zLdD9pJw4uAD+UGk/YiMdl/mhhGFdJ+Do61tOnPEUWJ0EC99UrSSuWP3t2Fql07pgIgYr9cwWyNmxpV+uUne7s6GF7F0+8pKpRscD8ktmC/IgPsUSkgWWpi6kM9w7vu1FezhHugxQOYiU5UP9G1YdarxDiItKlVN0lamI+pxCvdYxZHXrXWtqL9nwPhpVExC66xeVsAhufs5NAf+JRv7jcf1Hdc4U+kC9PAt5vMiRZzyJZnny1U7PQ6+HQspzD5P3zUn6HrUY33PxtyYx9u5qDnvnS9/C02f8Ys8TZTkp2KGa7tKlaTk/UGHQNruu5TLU69DJG0rfEc0vmBZmg6kbMm7AdBqml87xjNE1CveJYsg/bmesSMSMNxUgEGih2SzYcISzp65FBLgF/dowTVRNIFGRS0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB6473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(366016)(376014)(261026121527099003)(261026140227099003)(261022075727099003)(261022105027099003)(261028144727099003)(261021121427099003)(261102123227099003)(11063799006)(4143699003)(56012099006)(10067099003)(260925022911599003)(260925021911599003)(260925021311599003)(261009223027099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?T2pJNGNxUWk0b2JROC9mdHBrcWJITUNPVjlWODF5eTFCV3NJZmdualYrS09G?=
 =?utf-8?B?MENXSG5vYmROcjVNeC9vbmdNTEU2WURJRzZTUEM1VHVYTDZMRUVwQ0l3Smlp?=
 =?utf-8?B?VndzWWh4dDRmdDc0a3pocnN5b1k0MjFLWklSSGpRcnhjalpGNDBtbytGOWtR?=
 =?utf-8?B?MTZ1Q1l1TFJaR1VmMks3aUFpMm01N1JDVFRqeWtBcnVBUHRWaWU5RUJiWG9a?=
 =?utf-8?B?cTlUVkZJWkJjNWZaZmxMZHZXR1ovMFhGOHhyZUxLT0FaOXNTTE9sWWVORmlB?=
 =?utf-8?B?emxGWnZOeUpFdUVHVERnU0RVL1Q5YkJUTDQ1dmJjYS9Qdm5XMGNiNW1uNDZ4?=
 =?utf-8?B?UWtabUZiRGJXNWVvaFRPWW1EVkpnQmluaXlJZnhPeE94Z3BpRVV1eFNqekxV?=
 =?utf-8?B?emt4OU5vbWgxTWRQcnQzRXIybHMyWVdzVFc3aE9Qa3RrRjhKTGMxaXFWaUxC?=
 =?utf-8?B?d3hBSXZYZ2tDMnRGWkJSKzF6QUxIVHBjS29qTVFTejU3OXhoZGdBWmd4ZHhh?=
 =?utf-8?B?YzdBZzNrbmM3YlZHZVlvSVdTYXB5MGlkdnlHaHNLU0tnUUtPaE1VQTF6ZFBY?=
 =?utf-8?B?NFE1dU55OUJjb2Zlc0JCeGNvQThJUVF2SlU1OUJLSHZPOWVjNkxaVmd2b3p2?=
 =?utf-8?B?a2VwYyt4UFg4dVZvdEZMQ2FudC9ySm1VOHlEVDU2aXJsRjQ2VEVpV1JaNUhp?=
 =?utf-8?B?QjNVb2hvUCthSk56TXFlRnhiVWR5ZVp0UHl3OC91TU9SekdRUnZJRlVwa2cz?=
 =?utf-8?B?SXFZQmpuaTVoMFcrb2ZONHdZcEFSNWUwU05JaFBCeDVBb3FMbk9rTTkwUlZK?=
 =?utf-8?B?Ny80bHRSOWlsQzJJbnpjRk1MTE1RYXgrOGdNR1ptSXhvQmdWWi9ienp5b1hH?=
 =?utf-8?B?OHZBRVQwMm1PaWNDVG1hWCtVNXVqYWhuK2ZydG9YbVMzd0I1V0NTanptMnZr?=
 =?utf-8?B?ZWRPN1VPR2l1N0k3TFlpSWFEL09EM3o3eVlDQXQ4dmFVL3ZjdXpNUUprMXpG?=
 =?utf-8?B?K3B0UjhvZzJ4MFIwazllN2lHZkM1Ym9hTTVEZnc2SHdWaG1xZUY0S0xYYkhF?=
 =?utf-8?B?TVNpNDhNdmRHSXBtb2hLQzcxQ05IbjBOQUVGOEk1LzFJdHRuamRJME00Y2Fn?=
 =?utf-8?B?bkVWb0htbWVjb0VNQzBYL2UvMkRXSnVWUzYwcnQ1aXBlR2YxY0duSDlnLzhs?=
 =?utf-8?B?V2V1ZGYxYTkwN0tQdENWRkZmUVo3VjRvU3hibHJQdnBUei9vbU5yazJJOTRJ?=
 =?utf-8?B?eDN0RlJtb0VaakpjNEdSYjJrcHBRYmZPcERZaXFnaDZoeEFQazgrWmZDY05p?=
 =?utf-8?B?amtINzVwM09KeWFGdGdRSTFJR2RUMDdxMmVsMlovTTZ1c28yQWVwMHFCdHV3?=
 =?utf-8?B?OGVGUlJ3VnlFMmlFOGNwWCtieUg3Ymt0WnFzbWxCMGpzRkY1RDFhb2VES09i?=
 =?utf-8?B?MWZSdjhFYTF2aS80blBzVVJGcFJUYTlIOWZtNThCWmpwR3BGVms5S1dkV1Bo?=
 =?utf-8?B?MTNSaXVTa2lOTVMxcEh0NnFSVkxLbWY5aHNqOEFUa09zT0NCU29iM1AwZnRI?=
 =?utf-8?B?QWdtVFJlSE9FTGY4Wi9yR1pGenZlcFFpTG5DTlJUS1BoSnBMc1BVRWh3RVNF?=
 =?utf-8?B?Wkp0U05pQlVqQy9DYy95RFlNbUtnMU9FMWVKclBDbnhDeFVxWjg1S3NrMnQw?=
 =?utf-8?B?K2F0ZHg1amtzWFIvWFVuMzJER1VWdWVPWUVYV0NCWjhDeE15L2l1YWl6N040?=
 =?utf-8?B?TElKNnA0S3MvMzBzTnBoditUOHdRUUpyOWphdEJiMDY4UWhISUgwRTlLNEx1?=
 =?utf-8?B?VnF4enFKMHIrY053dit5UWh6VDdQVyszTkpVQ1g5dlRhZVZVL2NUR1Rjb0VH?=
 =?utf-8?B?VVRuSEcwR1ZPaVpsbTRTUC8wVmloVDdreXplcTNjNE5pL1BYMzNKcE8vWmJM?=
 =?utf-8?B?aGtQd25mbURWNmx5Z0V1aGdSdFNkMnBxNFhsMnVWWW12bEd5UXdHYTdnUzc3?=
 =?utf-8?B?OG1Obi9IK1grYjJ5TEloYk9EOGZLcFVmTFp3bWFjOFRPSlBFdFJqWDlsRHd0?=
 =?utf-8?B?M3YyWlMwelJnU1p1WWNVWG9waDd1R29TQUhjUmUxYkNiaXo0V2t2eFB3aGkx?=
 =?utf-8?B?Mzc5UGdTM3dHaSs2a0JGRGZURnk2VHZkU1RGcUo2bmRJdm9DQ0VwSTd5NXNl?=
 =?utf-8?B?citsVi9SSUtnNEZSdmNwQXM3UVR3M2IvZlJ5MEtoeXo0RGtEREZqSW9nUkVI?=
 =?utf-8?B?bnBGZmZiemtIRjVWWVdUWHRuYWg2ZTRFVCtIR1d5STZQOGRub1Bkb2NzeGxS?=
 =?utf-8?B?SzAxcllZUzUrWThnbEE5ZUZQMm1sV0NUZ25wSHRhdXFaaHV0MDZIUT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 96a690cb-635b-4fa1-c137-08df4894acf8
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB6473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2026 12:32:30.6184
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BmfFLHiP9GVLqaF1L8doLki74VeQKAj9p8I0lPYfw5SjrT4IqyWVwy4/IWXPR5ChmVkvIDOL8nt80pKpUsL/uQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB8015



On 11/18/2026 4:04 PM, sashiko-bot@kernel.org wrote:
> External email: Use caution opening links or attachments
> 
> 
> Thank you for your contribution! Sashiko AI review found no new issues
> in this patch, but noticed 1 related pre-existing issue it does not
> introduce:
> - [High] RDMA/mlx5: unlocked state check in mlx5r_umr_post_send() misses
>    error flush [1]
> --
> 
> commit 6252ceba1b31eba36693680458665fa14b71227b
> Author: Akiva Goldberger <agoldberger@nvidia.com>
> 
> RDMA/mlx5: Cache the MR core device and resolve the MW's via its PD
> 
> This commit caches the mlx5_core_dev pointer in struct mlx5_ib_mr and adds
> mr_to_mdev() and mw_to_mdev() helpers so MR and MW operations resolve the
> core device from the resource instead of dev->mdev.
> 
>> diff --git a/drivers/infiniband/hw/mlx5/umr.c b/drivers/infiniband/hw/mlx5/umr.c
>> index f030885505df5..f9485591130d3 100644
>> --- a/drivers/infiniband/hw/mlx5/umr.c
>> +++ b/drivers/infiniband/hw/mlx5/umr.c
> 
> [ ... ]
> 
>> @@ -243,8 +243,7 @@ static int mlx5r_umr_post_send(struct ib_qp *ibqp, u32 mkey, struct ib_cqe *cqe,
>>                with_data ? sizeof(struct mlx5r_umr_wqe) :
>>                            sizeof(struct mlx5r_umr_wqe) -
>>                                    sizeof(struct mlx5_wqe_data_seg);
>> -     struct mlx5_ib_dev *dev = to_dev(ibqp->device);
>> -     struct mlx5_core_dev *mdev = dev->mdev;
>> +     struct mlx5_core_dev *mdev = qp_to_mdev(ibqp);
>>        struct mlx5_ib_qp *qp = to_mqp(ibqp);
>>        struct mlx5_wqe_ctrl_seg *ctrl;
>>        union {
> 
> [Severity: High]
> This problem wasn't introduced by this patch, but can checking mdev->state
> outside qp->sq.lock in mlx5r_umr_post_send() [1] cause
> mlx5r_umr_post_send_wait() to hang forever in wait_for_completion()?
> 
> mlx5_ib_handle_internal_error() walks ibdev->qp_list under mqp->sq.lock and
> arms send_mcq for software flushing only when mqp->sq.tail != mqp->sq.head.
> Because mlx5r_umr_post_send() checks mdev->state before taking qp->sq.lock,
> it can queue a WQE after the error handler has already checked the SQ:
> 
> CPU0                                  CPU1
> mlx5r_umr_post_send_wait()
>    down(&umrc->sem)
>    mlx5r_umr_post_send()
>      if (mdev->state ==
>          MLX5_DEVICE_STATE_INTERNAL_ERROR)
>                                        enter_error_state()
>                                          mdev->state =
>                                            MLX5_DEVICE_STATE_INTERNAL_ERROR
>                                          mlx5_ib_handle_internal_error()
>                                            spin_lock(&mqp->sq.lock)
>                                            if (mqp->sq.tail != mqp->sq.head)
>                                              /* arm send_mcq for SW flush */
>                                            spin_unlock(&mqp->sq.lock)
>      spin_lock_irqsave(&qp->sq.lock, flags)
>      mlx5r_finish_wqe(...)
>      mlx5r_ring_db(...)
>      spin_unlock_irqrestore(&qp->sq.lock, flags)
>    wait_for_completion(&umr_context.done)  <-- hangs forever holding umrc->sem
> 
> With hardware completions stopped and software flushing already past this QP,
> umr_context.done is never completed, blocking subsequent UMR operations and
> device teardown on umrc->sem.  Checking mdev->state under qp->sq.lock (as
> mlx5_ib_post_send() does) avoids this race.
> 

The window exists, but mlx5_ib_post_send() checks the device state 
before taking sq.lock in the same way, this isn't specific to UMR. 
Anyway, this patch only changes where the core device is resolved from, 
so we'll look at it separately.


> [1] https://sashiko.dev/#/bug/linux-d43f2378-f2de-4246-8c9d-53b5f5f256a1
> 
> --
> Sashiko AI review · https://sashiko.dev/#/patchset/20261117-mlx5-sd-prep-v1-0-8efd124c7895@nvidia.com?part=5

