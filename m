Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.201.45
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793103071;
	b=hz2VmrR3TR6xDPNJFiSXyBP/jWiikZ6YuTBmSe113Dy2GjeH3FEYogOFM6dNLt+gtEB8
	 7QwQBBzX5MO5KUKeBbp7TO+QrPXVdit6faVt41EuPCwRXXnaTHOFT9DlAWy9Q0pvfHMdz
	 oolOfUGGl1vCiQVu7PhTmkaJ2GzaPGujKuciyc8YYA5DvV5WKwunAHcixe5BIk5MIgRPx
	 If1RVmkpZZ66fAMB6AzW900hEExNeegsWWmhPH0IYmTYB1Ctw2gopffG6DnERlT58NN38
	 nYip+/jfZo4B2dmnDIDLXdl/nmIcKgZ0N5N1kPu4WYTC/1PLWm2U/yJxp2v5ub3RbNQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793103071;
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
	bh=/tME6forgyOmuBD42rpANv4g8SLPE6jaRGhRFe5+D1U=;
	b=jeunIEPvOa1zNKYiRXi3M7x5bMwo0Xd4j9jXErvj3aS7EPM7pUwashVcUSfydYJCWu3h
	 BSoDLjgdRB0LbNfKC3lgM7ENsypFb0eUR+BI4idLXrBm+RlUROSGSLxg52ICWvqb+4aHq
	 prNkgfYUZsOp4Yd0tFT7WQ5J0qOORakhc8hIDeaF/D8+QPgPv1pOXzVWUrP8KedG8wZpU
	 Q/1TQbk5mFRzQh7Nlo4nlhe1OES9twex/EjYE8H2cJ9NzDdzNM8pomDinZgLNjdQFxsH3
	 tjWpLAF4TFDh2EGiI40wwM6gORT3bqC1CUcLXG8bhQztd8JeC35UcjGx2F20PJp/vGA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amd.com;
	spf=fail smtp.mailfrom=amd.com;
	dkim=pass header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=jSVTJUMr;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.201.45
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010045.outbound.protection.outlook.com [52.101.201.45])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C0CC606A326;
	Tue, 27 Oct 2026 12:11:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1C0CC606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=jSVTJUMr
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SF65qqByPE2h5fDM1M1cZIzXhQte6OcXHI+Bk3jGFNEsXxm7sc48bIquJ3KsWb+rRDPuK/AJeJW8wQtJzvZEqq+N6j5Pa39im1HTPrpStwr5aFQ+k7OtC67NHLI2M8J11AtPQcOZZKVtcuK1BZ3TZcIJ/CeSqTdtUVa/MPIqLyY3GPruIMoEAx+ICPEVO8LSa1BexEIFRgBuk17m8KENMEC91/Qf1dySoBuxguTaLIdxJMvd83o4gzZ2PzEqxNxlreB9TLDCJ2ksy1sjLuja2NuF+naMS0gBUfd+5U9tos9ppCnhr/97QdnH2cwyvvFyV+DrVWQ7IBOe6AyKHi0IYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/tME6forgyOmuBD42rpANv4g8SLPE6jaRGhRFe5+D1U=;
 b=lDK8QRQC1s2JeQAPLUFAAmf/RZAmzYL4POawhqjdxS8s91+utNKFe6VvnmHoG8s7h9qa6Yvu151FK18UYDxvexiaGcAtBFHZUjGQZ4o972Qg483HhwrIgITcooCyyeFkHKtO+8lSZ+o3FFyJ2TrN0yEtlYpZWBbKUPZqpcjuuJG9vM7P8+xon8qZzjoqNW0x8iyRGLyd4e5iG2WQOUeSjhypjaeWKyIYKdlf94GmuyH4SFkxzyfyKkZloqDWd77/VbRD46pj3DI4rCk53JWvvyAYRIHw+6wAjWEReKWySAHTQd17lzt2L/hCcn+P419JoeFJWHPSb1nGxsLC9AiIbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/tME6forgyOmuBD42rpANv4g8SLPE6jaRGhRFe5+D1U=;
 b=jSVTJUMr+AzOw04Te0UnkMZ7cOHV17sTE1MyRwwZbBYLUhpiigormist6P7WjcjtUqxI3hqsVEfcvU3E2tWhU+YtEaqJAvECaUxXq7MJJKP05oNIzJlwe3cqhZo7xuTeCpu+ST2UF8SCQ77no/ltDWWPZeez8pu1pkpWK4udwQg=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB5685.namprd12.prod.outlook.com (2603:10b6:510:13c::22)
 by DSVPR12MB999172.namprd12.prod.outlook.com (2603:10b6:8:38b::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Tue, 27 Oct
 2026 12:11:08 +0000
Received: from PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::ce69:cfae:774d:a65c]) by PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::ce69:cfae:774d:a65c%3]) with mapi id 15.21.0546.021; Tue, 27 Oct 2026
 12:11:08 +0000
Message-ID: <2be3338a-5657-4312-869d-3bb1d386f9fc@amd.com>
Date: Tue, 27 Oct 2026 13:11:01 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 23/26] treewide: Rename dma_buf_attach() to
 dma_buf_sgt_attach()
To: Karl Mehltretter <kmehltretter@gmail.com>,
 Alistair Popple <apopple@nvidia.com>
Cc: dri-devel@lists.freedesktop.org, sumit.semwal@linaro.org, jgg@nvidia.com,
 =?UTF-8?Q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
 Simona Vetter <simona.vetter@ffwll.ch>,
 Matthew Brost <matthew.brost@intel.com>,
 Vivek Kasireddy <vivek.kasireddy@intel.com>,
 Dongwon Kim <dongwon.kim@intel.com>, Leon Romanovsky <leonro@nvidia.com>,
 Kevin Tian <kevin.tian@intel.com>, Xu Yilun <yilun.xu@linux.intel.com>,
 Baolu Lu <baolu.lu@linux.intel.com>, Felix Kuehling
 <felix.kuehling@amd.com>, Alex Deucher <alexander.deucher@amd.com>,
 intel-xe@lists.freedesktop.org, amd-gfx@lists.freedesktop.org,
 linux-media@vger.kernel.org, linaro-mm-sig@lists.linaro.org,
 linux-rdma@vger.kernel.org, iommu@lists.linux.dev,
 Alexey Kardashevskiy <aik@amd.com>, zhipingz@meta.com, treding@nvidia.com,
 jhubbard@nvidia.com
References: <20261026053623.202642-1-apopple@nvidia.com>
 <20261026053623.202642-24-apopple@nvidia.com> <auAIO0y09SXk34CN@gmail.com>
Content-Language: en-US
From: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
In-Reply-To: <auAIO0y09SXk34CN@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR3P281CA0203.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a5::11) To PH7PR12MB5685.namprd12.prod.outlook.com
 (2603:10b6:510:13c::22)
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
X-MS-TrafficTypeDiagnostic: PH7PR12MB5685:EE_|DSVPR12MB999172:EE_
X-MS-Office365-Filtering-Correlation-Id: 8989abdd-5036-44b5-2f3b-08df342361f4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|1800799024|7416014|376014|261022105027099003|261022113327099003|261022075727099003|261021121427099003|10067099003|56012099006|261026140227099003|6133799003|18002099003|22082099003|261026121527099003|11063799006|4143699003;
X-Microsoft-Antispam-Message-Info:
	0sfZRKpXbGaBQ0QN2xfG0yiqSvS0kDYFWBxyrpq4MZewoke171RiqbIttqpuGyEpqfZZ//bj4Xt3OyUDcUZqWt6a01FpPBavj5fo7AbzeHghvr4kwo7ffmgydsElcHIyWYlqM7a6DQZCXbZsMusBTRQkxbtygLaqgD+71rx5O8Dt48ds5Q1UYyP3qBdbylLfg2aDlPAn3n94KLmJF7Jr/RFl5zO3P/6RIYUQbOBnbDdJGC2EQt30kTIYZGM67Ajx0VccrbnpWSOXRfYseBl4KaWO0vEaHQSLGiH22Cw+6WaFebthrymPVQbtFSZeVENebOvF3XsYaP2CPuYZ0Vlc+CF/ZDTbnkWuh2GXvW6oe3XEFptPeY0jrhD0dAldkMAtwhoSH04+a/ixRxnz1EnHkV3YiSWI98hoWMvNv2AXN7Jgo3WahzgepibtFC1BI9Enr0wI+6PzEzd3ywQv8f+XWG+H9U8KfJqKYuuCIseDZQAFpTPDyxtpFtB63RhzI0MX5nDmH0UDGn2X9+BtIg0m1LL+aRarQjy6Cf39/tjidROFzGjksmZX1nagJuKge7wZS8KUeCxzQkeFtvu0/hhYGscJZrBGb9nUL8+5Wfhk3nmWOEYrM6va8yJqVtSpq6AFOHZFYXfUsMIrlMBr2dBAgyQsd+I8SqvHEVT3GJHlNfg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5685.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(1800799024)(7416014)(376014)(261022105027099003)(261022113327099003)(261022075727099003)(261021121427099003)(10067099003)(56012099006)(261026140227099003)(6133799003)(18002099003)(22082099003)(261026121527099003)(11063799006)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MS8zOCtiWmQ5cXRZWXN2RXlHUEZ4L3RwdXBSWFFDWWg4YlZrdEw2UFM1eUVQ?=
 =?utf-8?B?ZjduVlBzalBTRURmcDd3SWtFV1E5d3poeVVDTFUwT2JYTDJWOUlmd1V5djlX?=
 =?utf-8?B?REdKemtXdFNHL014cnpZM1JpTFB1aUxLa3FPQVFMY3AzdzhsaFZqejNKYmpN?=
 =?utf-8?B?cVJUUGpsT1lUNEQvKzZKYjFwK01LbThBeE9GSzgwR0c0azR6VmtId2xYVXE1?=
 =?utf-8?B?cnBKVmE2TW1teEZTREtRSkwvSXcwRkVzdHR6R0Y1cTh3NlFBdTZlSDVDeGRB?=
 =?utf-8?B?dnVjZ0I2dHVYQklya0UwVkNsNHVyT3VMS3lNYk5vNVM5eXBIZFJNY3hLalE5?=
 =?utf-8?B?UjBvblhIaDBRbE5aVi9sQTNZMzhqVlB0RTFNVzR1OWJENStzTU1lNG5qWFl5?=
 =?utf-8?B?UmF4Nmlsd0VnaXJZZ081Zzh6ZFpBU2ozUEtHWVl6OTZkUjllSVlKVXRqclhv?=
 =?utf-8?B?QXVHSHRzcm1uaHY1MTA5bzF3WEk2Sml4RUN0dkZLaU5Lb21yb2NYbnkrY2Nu?=
 =?utf-8?B?ckhqWjFNQ05SbndlODdrR1hkUG05V1JEYkxHbDYwVlJjMUlBODhtS0lxZzZG?=
 =?utf-8?B?Wk5UemthNlRCc2NJUTFpeGFJT2s2eU0zT29Gb05OZkVPTy9lVTI5VlM0Wlkv?=
 =?utf-8?B?UjNnUTROY0lEb3E0S01RNHdPSGdzNDBmL25iNmF1a2FFNDN3VlJLMjNlYUkr?=
 =?utf-8?B?eXU3RGJkRjh3MTJCT2JaSFhtSmp6YjAxdkZBMXFtVXZmT0hUM1FWYVpwZVRN?=
 =?utf-8?B?a0p0N2NNRmF2OVRZQUFFUnZicC9LNWN3TlFHS3k2QnE1TksyRzlFQ3RScHFm?=
 =?utf-8?B?ditnR0Q5VG40TmFSMHlna1hGWVpHRUUyK2hCdkFZQkM0bXRSQm9OMkJ5OFhh?=
 =?utf-8?B?R0l0VFhEbm5kWk1hbVJRVllFTlhlUjB0ZXkxR2VtTVk1NTc5cXYyOU9Tckpv?=
 =?utf-8?B?UDZ4eXloYktXVy9XTkE4Z2ZjWWd0WVlxMlUrVG9JaXNkQW45UTI0RDlnMFJv?=
 =?utf-8?B?TkVTNlE2ZlJqZnVCTDAwVVNvUjVrcS9MTTMrU1NNQmRIaEx6dUdTdEtlU2FZ?=
 =?utf-8?B?bHlNQ1NrRWhkS1IzZXFJaVBLYy9YcEdzYktJcmVBZHpBS1QxcENTazlvRGJR?=
 =?utf-8?B?SHA0QXVjcGNRYlMrN3YySjRkcmRJajhmSXNwL3dweERpcDQxM2RGclhjaVBY?=
 =?utf-8?B?dTZmOC9lbTkwdDdpR3RFZ3JXbU9PMWttNUZTcHpYMlhIM09ESDE1dzFUdUJF?=
 =?utf-8?B?TUJxRUZybXE4NWMybEpuZ1VsSnczdlFxUCt0Y1hMWC9ldTR6L04wNHl3OWRn?=
 =?utf-8?B?UHZaQWFRSkZYWWNlaWRQR3VGUTNzaCtNdy9XYThnRjNGcCtKNEdRUklNRTBN?=
 =?utf-8?B?aGVaZU43ZmhlUFQrUHExREtyemxlRkV3bS91aVRJL3FuZFAwd2tzMzlyZUJ0?=
 =?utf-8?B?OHg0bnpHVzZwSXU2eG5STUdXa1FPUkVCelNDT0NMSTQxdkV0U3FodXJmbXli?=
 =?utf-8?B?Y0IrY3l1c01oN3Q0RTJsTFlTNGp6ZG80RktqbHRiKzk5UWRBSTVnemZ6T1lu?=
 =?utf-8?B?dEZTanlGSVdhYzNoSDZlY2FCbzNVcWVsNVNxY2dyaDVHK216ZVFrd0ZjQ21W?=
 =?utf-8?B?N3J4Qi9JZnVSQ0NRTWFzYVdWc2lZbUpmYXlWaERmR24wV1VuZmVjZGIvTXhN?=
 =?utf-8?B?NnBpL2dTSnBSZE5BLzRyU1N0eUlPVUtZbHdOK3g1TktRZUxTL1ByWU5qZ2Ur?=
 =?utf-8?B?WUlSSUJ2dU5MbVFNVTRzbjlyVndpT2drQW9qV0dYYWJPK1N4aHpNWE9QbnlQ?=
 =?utf-8?B?VlF0WUhIdzIwWEJ2YjZyVXRlQmFpWkgxR2czOWpsY2hxL1ZmQ3I0UEhrMTF5?=
 =?utf-8?B?WWI1WHZkOVFSZkRFVkFaWEQwOWJWMUczNGxFUDJXVXFCTk1CTnhYSUpUWTEx?=
 =?utf-8?B?WEFvcFkzN24yRmQrM1dBa2I3NEJjRU5VVVNRamVmR0tJenFDQnNkK1NlY1pM?=
 =?utf-8?B?RjdGZFpodGhudVZMTW1SZTIwUmpXYkdObU1ZQnJ4cnViZmd0R1Y4eGYzZEN1?=
 =?utf-8?B?dWRERzQ0MzVESXM5VzRhZTlIMW04ZjYwT0xMb3lZMCtuMGJwcHhoYnZnWXNC?=
 =?utf-8?B?TGl3cmFmMHRtcFRyb25HTndlNDh4QU93Q3ovT0tsM2VkaHdBTGhaNnorUFRU?=
 =?utf-8?B?TDhJdDFmMkJEYnZpMW1SdW1IQ3V2cFV1UWdYNDB4dmkzN3dSR2Y2NkJzQnp3?=
 =?utf-8?B?RS9EaERPcFdSSW5tZjRqZmFjUE14ZXljZDNRV1JRTHR3N2lrTnJWNzl4c25T?=
 =?utf-8?Q?T/ICWeMWW1dR+Gbv/K?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8989abdd-5036-44b5-2f3b-08df342361f4
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5685.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2026 12:11:08.2919
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dIrznXJQSVGATTk7tGDfHYu39YG9D2ZyU1sdnA1Gp5Fo6kcQ0STt9A3j1gwmUaHv
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DSVPR12MB999172

On 10/27/26 03:15, Karl Mehltretter wrote:
> On Mon, Oct 26, 2026 at 04:36:14PM +0100, Alistair Popple wrote:
> 
> Testing the series on a Jetson Nano exposed this path. A 3 MiB system-heap
> buffer was imported into Tegra DRM and scanned out over HDMI. With
> CONFIG_DMABUF_DEBUG=y the PRIME import succeeded, but scanout immediately
> produced display SMMU faults starting at 0x300000.
> 
> Tracing the fault led here:
> 
>> @@ -475,7 +475,7 @@ static struct tegra_bo *tegra_bo_import(struct drm_device *drm,
>>  	 * domain, map it first to the DRM device to get an sgt.
>>  	 */
>>  	if (tegra->domain) {
>> -		attach = dma_buf_attach(buf, drm->dev);
>> +		attach = dma_buf_sgt_attach(buf, drm->dev);
> 
> tegra_bo_import() passes the attachment SGT to iommu_map_sgtable(), which
> uses sg_phys() and sg->length. The SGT mapping contract only guarantees the
> DMA address and length fields. The debug wrapper clears the page-side fields,
> so iommu_map_sgtable() maps zero bytes. 
> 
> Tegra only treats negative returns as errors and keeps the reserved
> IOVA, which scanout then faults on.
> 
> This page-side use predates the series, so the fault is not itself a v2
> regression. Is dma_buf_sgt_attach() valid for this call site, or does Tegra
> need a page/physical mapping type first?

Sharing page/physical to be used with the IOMMU functions through DMA-buf is an absolutely hard NAK from my side.

We still need to figure out how to do this between KVM, IOMMUFD and virtio so that it is limited to only those three.

Regards,
Christian.

> 
> Karl

