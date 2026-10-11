Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010052.outbound.protection.outlook.com [52.101.85.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1539B456DE8;
	Sun, 11 Oct 2026 13:55:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.85.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791726909; cv=fail; b=J/RkoMVE9Ef+yHOhJ5SLGvqQYOY8OlrBJoJJ/KMaYnqMQ6YPynAuQ8dOnqxJjsMAsrDI9pf7lsEdjSn5yIcoGRFPY05Wt0MSOA9elnGO1/Dk+ptB+JqOv6Ts3isojxQRA9Iz3y6eowNCFBh3d9Vb3G5u4hPQxz5ziC/5kfczEVk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791726909; c=relaxed/simple;
	bh=vlDIYbrWeFAUkMkphwFLAW9Sj1aCcJloUoVKNtC7ssk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=parZ8sRSyTN/sBNUrDwTB+pAA673RntdFy2olRUSQzYU4lK9OrQrzn+aRBJclgz5Zo/bhC528+6R4lTsb9LTxI3VFvyX8gyKfpeKo2VzH5tuqZ10BX5Uag77MjBINlPjJfDkB/L54dOPGOFJC8bKb/6tMrKQ19V52JWay7z56gg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=rpJexQzK; arc=fail smtp.client-ip=52.101.85.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="rpJexQzK"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Sy2SuSiaMrFK7ZY9hdRROFhwE7jDaHLWQCltwFHmIJYmYkm7P8DGgBFcaTWJAUY7LJY01+8wW5dG+1m6IZ4pC/EQmXMhGt1DqYGuQycXkSDNCqk1IEHPQs0ppZJVvBMtr8nyXZPYiY+wHcjtmXho0NnVgIVitVvxYNxKRZtERlQY0giGyYNGseGQk+M736WfkOGm4B08eg61eX+clISQwnYVpN+xLbaOqyWlC15RDH15Pjv00JEXywuQn7/x7pfR/nUF5+dHXOimJ5gCbNZZeTqz+S7YA9BEXPyxBFIDQhEPPzzl5lZtBkWvDL1bA1ziPEEjjspyirHkNCYkVjyqZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=349SU+17rnzfau9liSExcVKuj1Q7B1Pm+t80GtLBjdU=;
 b=Nzo4Uh2zERHVbKWnbUeFGHZHkdVN0ffTAJGV/rArIERSR74Se0NRDUOaFxKu3Nrjazoo87JzUSep6G6ant+U84Cg0V+HtMjaIHbk6QtzEneEMjl8R+WeyULnTH5I3UhZWj0Krw9NYzsRyuIAPyLav47ke4S22fj4Jw3tKg5eDXh8XAHr9Mddy8Sn5surwFsTgIGi97XX97XrOVq9UcNffAbk+NVKAxkM3oheo9Np8GBcBoKGKDWVjqJLxFwU8oKETvC4+SIZT7w5pbXnAyHq13v43zLsUrhAOckQhioJD6B7wcrHaUKMvUBsNnCABYJzl9skdFf2ejTQaFJyV70LEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=349SU+17rnzfau9liSExcVKuj1Q7B1Pm+t80GtLBjdU=;
 b=rpJexQzKJQrgd8FSoIVa6hTOW5kzpMMemepdUceKTuvFrsypaggyYiDAnkpkwmVVDkeBqVpGd7QlPsdSYXeO5t9BVB+4QR1llEPFFlkW3eBR1lpRWa5v4u2X7QwxBetXTmKwioCtk4tN4J3tC9eWKqCRyhN70gL7AcvXNvNL2QmLkUW0wRDY6vfjU/NSrFuLdwoanSpuKB0iVtqibcXTjxHb54Ug7fvmFWKxhcGu7SvolJ22Nq0arX2009ZTgG3lSwy5Y3vH7RJQLC+LXr9kJex9ERPWwts0ds2oqPqmE5lx0ONDjPHoxEoYAjOJHdX53p7+z7n6AhayUyLQo9vQGA==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SA0PR12MB7090.namprd12.prod.outlook.com (2603:10b6:806:2d5::16)
 by SA3PR12MB043340.namprd12.prod.outlook.com (2603:10b6:806:517::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.20; Sun, 11 Oct
 2026 13:55:05 +0000
Received: from SA0PR12MB7090.namprd12.prod.outlook.com
 ([fe80::de78:df30:c2e6:7adc]) by SA0PR12MB7090.namprd12.prod.outlook.com
 ([fe80::de78:df30:c2e6:7adc%3]) with mapi id 15.21.0472.015; Sun, 11 Oct 2026
 13:55:05 +0000
Message-ID: <07ad95a1-0e26-42bf-bf74-41ea9f4b0da5@nvidia.com>
Date: Sun, 11 Oct 2026 16:54:55 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next 00/10] net/mlx5e: Add netdev support for data
 direct
To: Mina Almasry <almasrymina@google.com>, Tariq Toukan <tariqt@nvidia.com>
Cc: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>,
 Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
 Paolo Abeni <pabeni@redhat.com>, Bobby Eshleman <bobbyeshleman@meta.com>,
 Byungchul Park <byungchul@sk.com>, Carolina Jubran <cjubran@nvidia.com>,
 Cosmin Ratiu <cratiu@nvidia.com>, Dragos Tatulea <dtatulea@nvidia.com>,
 Gal Pressman <gal@nvidia.com>, Jacob Keller <Jacob.e.keller@intel.com>,
 Kees Cook <kees@kernel.org>, Leon Romanovsky <leon@kernel.org>,
 open list <linux-kernel@vger.kernel.org>, linux-rdma@vger.kernel.org,
 Mark Bloch <mbloch@nvidia.com>, Matt Fleming <mfleming@cloudflare.com>,
 Nikolay Aleksandrov <razor@blackwall.org>, Saeed Mahameed
 <saeedm@nvidia.com>, Shivaji Kant <shivajikant@google.com>,
 Simon Horman <horms@kernel.org>, Stanislav Fomichev <sdf@fomichev.me>,
 Stanislav Fomichev <sdf.kernel@gmail.com>, William Tu <witu@nvidia.com>,
 Yue Haibing <yuehaibing@huawei.com>
References: <20261008132815.654147-1-tariqt@nvidia.com>
 <CAHS8izNSo4YzXxD3C6c2HohdOfH2GK1M=51biuevLUk3vz5k4g@mail.gmail.com>
 <CAHS8izMKNeEmJM0wOgtoz9_3WRLUOqP0PEDMn5SZ+hXTKTwSyw@mail.gmail.com>
Content-Language: en-US
From: Tariq Toukan <tariqt@nvidia.com>
In-Reply-To: <CAHS8izMKNeEmJM0wOgtoz9_3WRLUOqP0PEDMn5SZ+hXTKTwSyw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR3P281CA0172.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a0::10) To SA0PR12MB7090.namprd12.prod.outlook.com
 (2603:10b6:806:2d5::16)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA0PR12MB7090:EE_|SA3PR12MB043340:EE_
X-MS-Office365-Filtering-Correlation-Id: 34f5a26c-f050-41f6-69db-08df279f4096
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|23010399003|4143699003|11063799006|56012099006|18002099003|22082099003|6133799003|3023799007|10067099003;
X-Microsoft-Antispam-Message-Info:
	fyKbnPtOroZXv12gxILWuROsQT7xHVs3IofPFNItluBW+UH6JfREf+kSgurQO/lDOmGLqv18WsbkoQCHMvZLFgUtlij+R9rcM+zD6ZlqPfGP1c+CKOcg2/xnGnrP56GsDArRajHBZF495W0zEFiCNDicmprKa6hIwU2OwKmgqOUchAG2FKE+pAC17SV7/OgErULtD00WC0Nz5Sr6E4+a7lxt+Wr3TzFwX9YQaxC4TxhPWJqYDtKuVc9Skp3ag/xkAFmJX2u539HXVRMHet+hw4LfVNmAjhU9lWJZ09/cVNl00JOBARNsf44mhg4FX60gfvXoOfAti5HRVVLohoq8vxfaShjMLpvOR2oR3TDPhN6ph5MhXHNKK1Fx4HWSbSJvLvAXDIiu/dJQV2DeHciLeMZrwOyC95ih/ClofJ1ohzZqTKqRSeKd+4oVVro/J3mNWCr4mbbwy2jdIXfknPN/vx0ye7Q47imTWE7WIbNkmvX6rl5RhBhiSfRBD8M5+Z8dcvHLstWzdK2/So7a2lgEhV4MqPB7BCyBYyDaQA22RbRFuLqiHg3TagKiPit8tG5iQ0SIP0f6uMLfDhjqQMlC+/w+8WNK3Jo9YudROf+Xv4CdJl/hXskjGOUlaSDtqXFhcyp/HvT1PnIWJ53PdrWWjM/te0Mv/8qFA3B8qtUTL+M=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA0PR12MB7090.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(23010399003)(4143699003)(11063799006)(56012099006)(18002099003)(22082099003)(6133799003)(3023799007)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?N2lleVBqMVc5ZWxKcGhJOHIvbm1DNi9QNXJpdkpUMU92Yy9MOXBFQjNtZzQ4?=
 =?utf-8?B?ZjNQUFlOL2hBZkxrbWRzUSsrcU5vZ3JENm1GV3ErYm4vMVBMK0J4a2VMU3RK?=
 =?utf-8?B?MU5wMFJNWVk5by9mS2lyK2Jaem9MS09WMzN1djdIQk1QbU52N2F5dFBtV0Zq?=
 =?utf-8?B?aGZaWlBwbjlMRWRPNGJIVUErNXNVcnowUmU5Y0cyNUV2d2JHL2NwRTNjSDFH?=
 =?utf-8?B?Ykx0YURwVUJpN1FYd09aMjZQcmp6cG41NW9pMlB2ZHFDNnUraVExSDhYN2JG?=
 =?utf-8?B?bHJDUUsxdFFITHV2U1RBejhCUEljQWF6bTZFdVJFeE50V05CK2txQkwvSVZW?=
 =?utf-8?B?NExwMi9VWDRFSGZVczRpaVZ2SzVnUFFNL2xpZEZGTjY3a2w5L29PL2Y1UmlG?=
 =?utf-8?B?SkRrVlhtaVNwRjQwc2c5bGJ1ZTh0RTl6L0xYWVh2cHJQbXNKK1k1eG9xcU8x?=
 =?utf-8?B?OERLclVOaHA3U0pmRFhJd2R1bTBsWDVFZ3BLb3BuYm5kQjR6bC9rMDdoVFNn?=
 =?utf-8?B?WGtGQVp0ZGZLckF0d2lmQjN0ZXRtYnhlVmQvMTd4MUFtUjhsS3ppSnk2cW1l?=
 =?utf-8?B?ZDVvN2dxZTM2RDRTOFF1M0ZhclVzUVZoejlBeFAwR1FIZUt2WW8wWHhJYis3?=
 =?utf-8?B?SktNN1BGRDdYM0o2OVRsZVZMV3owQmNGakJjeXkzRUpHOHBsUUpPSm9nbUU3?=
 =?utf-8?B?MEs2d2RWUCtZRUpjcWJvZEExU21XZkc4cVpweWVsR3JqSkZweVBTNWN5dC8x?=
 =?utf-8?B?WkhmVGxYUU9pWitiWHZQWDh2SnVFRng3N2RyUU9KMXl3NXcxVG1jNGV2dmV0?=
 =?utf-8?B?RWJ0M3VuV1BVd1UzbEY3VDJSK2l4bEhmY3E3VERFcWR2cFJOYU1RSllNSVd3?=
 =?utf-8?B?bU1tQlZrVC9LTm5MUTVTa2FmM3pNTlRMOGRlZGcyWUFJYTVGc2ZjRlVZK1ho?=
 =?utf-8?B?Rm1SeXpPOU5QclhvSmw5YUdHMTFPb2lib3N1eHhHMWQwbG9ZeHRRTHNMTDNl?=
 =?utf-8?B?SExrYUI1WUdhbERqVzRPS1BhZUR6blJlYW1qdFBRQ0F4VWd1R05xZFg1bVEw?=
 =?utf-8?B?TE1NVnMzVGNIOWYyeTFRRjFaUmJHOFYxWkNCb21Ra09DVTlqWGRCNlZ1UWdv?=
 =?utf-8?B?RzFkZkwwT1hyS05oNkF0OElYUjBPbGtJb1FOTzZHUzdkRmMxRFVpbklKZk9o?=
 =?utf-8?B?UDVZYVZ6QzhWUTBNTWk0QkpudkxldDVEMUdhdFVvYTBWRzI3WDFqZHVITEI0?=
 =?utf-8?B?cFVlVU9DMERPZGFxamU0SzFXVDA5RWtxc3JMb2V3Ry9lZTJ0R2FaYUR4ZmQ0?=
 =?utf-8?B?YTJGT3h0RFAvS1NFSHdhMEdpVm56bk5FVTJpZDI3ck56c2xxcFo3NVE3WnI0?=
 =?utf-8?B?dTQzME9hL3BuUGpTU2FGeVJDQThKVkhiNjQwV0xTYWlTZzJUVEtEV05HOUVp?=
 =?utf-8?B?THE1cXZDNThVcXRtamwwZzg1K3c0eUtGRW53eGxKblNyNHNocEpBOGp6VFFr?=
 =?utf-8?B?YTlESWwyWnV6eVRJbjRaVis3S2p2N004L1IydS8zS1U1N2U1aGkwMGkyY3oy?=
 =?utf-8?B?d21jM1o5Y2R1RjJhdHlHaExuVXZIZmxWQ2JUaGVGTkxOTTFPNUUvallaY09B?=
 =?utf-8?B?dXRqUVlhRlNINTNnVmQ1bERCd1lubG50alB5R2dCZW1tNnAwLzdzZzRGUXgx?=
 =?utf-8?B?ajBGWmpHaHNqTWZkQ0hzTVBtdmduYnJzMUZBUnlTSkxuRFRER0Mwa1lGUlBj?=
 =?utf-8?B?c215WUtzc3hoc09vSnY1Qk5BK2NtMnF2bGZaR0NubzByN3hOK3JiSW1RcU5J?=
 =?utf-8?B?V1U5NzViM2h3ZnE1MzJlSENnbFpKL3JlUC9KR2QwQXljZzdlbW9VclhOdml4?=
 =?utf-8?B?bEFuckF6MDNqcHYwNmY4emJFUlRXdGRkcUV6bmdjMHFvQjNPbFhEcjFkVlpp?=
 =?utf-8?B?NjJpYTF6WWVmUzdpS0tFUjB3Y2NTQXFsUVYyZ2VBWk5VK3NPaC93VTZRYXFN?=
 =?utf-8?B?RjF1bU5lYXpFVkVHMXdQYU9EK2grVVdCVnAwQVJuU3lmNW4vWVQzeWxhU3Fm?=
 =?utf-8?B?UUJZNzkweDg4YkUycmY5TFFPRXpLVmtHZEtEMEs0cFFiWDNlVUtKK0xaeU81?=
 =?utf-8?B?ZUhCTUZZWjM0UkU1MmJXbW92dE80SjJkeS82YVNVcGVMQzNSVnJSSmhWbm1L?=
 =?utf-8?B?NExoaVZHRjh1QWdvRjhCVHVISmgyZEZsMDgyYlhDMzFTUHpkR0kvM2pTakJo?=
 =?utf-8?B?R3dFZnZBSlFJUmtRQ0FwYzUweU9qYll5cVAwUHFCU0w5T3lpK3hSeGVMeDlU?=
 =?utf-8?B?ako4cGZ1cnl2SnBWV1FXNUlGOHhXWnlmTDhZRUZMQ1BOTGZ2WUtOZz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 34f5a26c-f050-41f6-69db-08df279f4096
X-MS-Exchange-CrossTenant-AuthSource: SA0PR12MB7090.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Oct 2026 13:55:04.9294
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: o8RCV7SZyav8QhGaSyYPBu/teUjEe2H7tZ4SjwztpE/EWzS8UZt68WBFQEJt96ZuNWVIgRIB1hXN+a/sV3vb6w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB043340



On 10/10/2026 2:54, Mina Almasry wrote:
> On Fri, Oct 9, 2026 at 9:42 AM Mina Almasry <almasrymina@google.com> wrote:
>>
>> On Thu, Oct 8, 2026 at 6:28 AM Tariq Toukan <tariqt@nvidia.com> wrote:
>>>
>>> Hi,
>>>
>>> This patch series by Dragos adds data direct support for netdev devices,
>>> allowing a mlx5 netdev to issue DMA commands through multiple paths.
>>> This feature is critical for improving performance and reaching line
>>> rate in certain environments where issuing PCI transactions over one
>>> path may be significantly faster than over another. These differences
>>> can arise from various PCI generations in the system or the specific
>>> system topology.
>>>
>>> Data direct for netdev will work with devmem by returning the data
>>> direct DMA device instead of the DMA device of the NIC. Each PF netdev
>>> registers its own data direct device and support for RX and TX datapath
>>> is added. The feature is selected through a new data direct priv flag.
>>>
>>> The feature is enabled though a ethtool private flag. When this flag
>>> is enabled, the driver will return the data direct device in the
>>> ndo_queue_get_dma_dev op.
>>>
>>> During data_direct device unbind, a re-creation of the channels is
>>> triggered.
>>>
>>> A note about the unbind: it does not does not tear down dmabuf bindings
>>> attached to the data direct device; the recreated channels will still
>>> pick up the binding via rxq->mp_params and post DMA addresses from the
>>> data direct IOMMU domain to the PF, causing IOMMU faults. A devmem
>>> revoke hook is needed to close those bindings before the switch. This is
>>> out of scope for this series.
>>>
>>
>> Elaborate on this please. Are you referring to the fact that on
>> page_pool_scrub we unmap the netmems dma-mapped by the page-pool, but
>> we don't unmap the netmems dma-mapped by the memory provider?
>>
>> What's the impact of leaving this unfixed? Is the machine going to
>> crash if the device goes away but we don't unmap the dmabuf?
> 
> Oh, you're referring to an even different bug than the one I had in
> mind. (I'll see if I can submit a fix for the bug I had in mind).
> 
> But in general I think not addressing the issue you're referring to is
> way too messy. I think we do indeed need to unbind the dma-buf if the
> dma-dev is going away. The invariant should be that the
> binding->attachment->dev should not change at all during the entire
> lifetime of the binding. We already 'revoke' the dma-buf binding if
> the netdev is going away, sorta (there is a bug there I need to fix.
> The uninstall function in the provider doesn't actually unmap the
> dma-buf :sad face:).
> 
> I've worked with my LLM to suggest some changes that (we think) make
> this work, but you may disagree. I'll post the suggestions. But please
> I think this should be handled one way or another.
> 

Mina, thanks for your review.

pw-bot: cr

