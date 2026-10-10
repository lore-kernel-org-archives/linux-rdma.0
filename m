Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010027.outbound.protection.outlook.com [52.101.61.27])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ABE52D592D;
	Sat, 10 Oct 2026 14:16:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.61.27
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791641809; cv=fail; b=FbtN4ddTfh9tAKVUBQ5pIyEpXBMPiiQP5mSpC5diXia7CRCstQ9TVMQ+ClXuSbdjOqQeMB82Pn7lAyoImltfcOGRZsmCf0cOADGkEqsiWKJ29caaCyFCrFgp66JUzZiOoMlilO8NEKc2b/OVro0v0Trf6cECs26EDemMA9EHytg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791641809; c=relaxed/simple;
	bh=rhC+/wJCIkyYCczT6C8CVo1IxJ7cVzWNNIdDI204IFA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=A163xwMMK7xPtVxKaWFvRVh4F5saSKUQG2fPWDCNdjLEOYOY0iN9Ujy0rXxOMaRhj4eesrw0jDvGC0yXOuuUrgdJPtGo2RN+lwHNznZKiE6XfugAN3ngmoplv8fMrwMgQWNGsjV+Sog67d1v++cNNd+UtAtnUPmYSivZLDJ0mdc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=XM2yXn8y; arc=fail smtp.client-ip=52.101.61.27
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="XM2yXn8y"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lgqvhVNOksg+ZYNMSTfmbwHlRfmLzwpe2xY9LQhEVopU7TNtIElXxhGmH8X/hZUozTUZ5fRHowjIpa1j779KG303FmL0apyP2JN0eUb8nxM2X/CaeZWbTxfItG34ppravDNhopKHctGr4Gdmrt8S50pWG58euMOg+0jXiM18KsP8Mryt0HPsXnjGJHOqU+L/j8jn3QhnYZLDrXC+vvyzckHtVkMtX7GgJKvefTwjWYqOKm5IDHI2L7G3x/9Q+GMIup3XQo5+fBxf5h6olaII9N9D9/0PpR0ZLxHRPO5Y6qaIVejPEhDfn7bDzVgqjObganqtUEHXvm8hflGZ/DKbqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aBhCX94cL/V1rYHDmmV4UCcAHlDh4iXiUab/7PhSM+M=;
 b=K0PEP4/ievQJgaSfagmG2rZl/wPYWPkH8YkMy8nDgJvttbpQaxBGB3BOgwzURAusrWtjI2rTJGHWWzJ9HM4V/r5JGomdIw8Widv5hUe4jv0UWzZ8NU4MxQNCa0TJzzaK7AgrqrJCpge3eoRnrfV/eOKZylOiZaFO9t4DTE3ynyIT76hok35heJZczPTiIF+XxHC8wjC2AS2s+gzIn8cQlmqQFGfKXixcM/GL5drIEU4f1u597iUPQ3+AJFp1L7l6TnajeiYhTRwKizx8EVsJmzf71akjYeIZkzjT2ApQt6iZyWxB7FQcPdrjuaKoVn7fiwc3YfNJ8xaiWjDU7Fx9uQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aBhCX94cL/V1rYHDmmV4UCcAHlDh4iXiUab/7PhSM+M=;
 b=XM2yXn8yPQqQIe2OP3NtfeS0P4ujrFa8ULsnGKbVXcIwL7OkEjOvrIyyuKAys7Ks1BkCcoyk0C9dSb0fiw7D7CbGiuHOb49Tsjzi8yH6chdJX2wvF8QjiXYVoojUYUsX+ROi/Vji1IniHb95Fgjd0v+1bO/54Hw6YxKHpFJmPC2w+61HGAXg9pHGdW0J/vD+VU504WomiUO4JhTFdCf8BDb28u+YI6OVaCm6eri3ZnZPral3eUFq8WYubtYTNGqRkpHXIx0mp7c+NGXbGBv6oOYF/pei8UlY5zRQYp1M3xnN5R6xah/ubj6CiP8MWymOXMYauTFFYBpcs22YCqcZtw==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH1PR12MB9647.namprd12.prod.outlook.com (2603:10b6:610:2b0::10)
 by DM4PR12MB7767.namprd12.prod.outlook.com (2603:10b6:8:100::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.17; Sat, 10 Oct
 2026 14:16:24 +0000
Received: from CH1PR12MB9647.namprd12.prod.outlook.com
 ([fe80::228c:766a:191d:77b2]) by CH1PR12MB9647.namprd12.prod.outlook.com
 ([fe80::228c:766a:191d:77b2%3]) with mapi id 15.21.0496.019; Sat, 10 Oct 2026
 14:16:24 +0000
Message-ID: <7a0bff03-2a7d-4819-b96e-a5ad8a5f6bf6@nvidia.com>
Date: Sat, 10 Oct 2026 16:16:17 +0200
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [PATCH net-next 00/10] net/mlx5e: Add netdev support for data
 direct
To: Mina Almasry <almasrymina@google.com>, Tariq Toukan <tariqt@nvidia.com>
Cc: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>,
 Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
 Paolo Abeni <pabeni@redhat.com>, Bobby Eshleman <bobbyeshleman@meta.com>,
 Byungchul Park <byungchul@sk.com>, Carolina Jubran <cjubran@nvidia.com>,
 Cosmin Ratiu <cratiu@nvidia.com>, Gal Pressman <gal@nvidia.com>,
 Jacob Keller <Jacob.e.keller@intel.com>, Kees Cook <kees@kernel.org>,
 Leon Romanovsky <leon@kernel.org>, open list <linux-kernel@vger.kernel.org>,
 linux-rdma@vger.kernel.org, Mark Bloch <mbloch@nvidia.com>,
 Matt Fleming <mfleming@cloudflare.com>,
 Nikolay Aleksandrov <razor@blackwall.org>, Saeed Mahameed
 <saeedm@nvidia.com>, Shivaji Kant <shivajikant@google.com>,
 Simon Horman <horms@kernel.org>, Stanislav Fomichev <sdf@fomichev.me>,
 Stanislav Fomichev <sdf.kernel@gmail.com>, William Tu <witu@nvidia.com>,
 Yue Haibing <yuehaibing@huawei.com>
References: <20261008132815.654147-1-tariqt@nvidia.com>
 <CAHS8izNSo4YzXxD3C6c2HohdOfH2GK1M=51biuevLUk3vz5k4g@mail.gmail.com>
 <CAHS8izMKNeEmJM0wOgtoz9_3WRLUOqP0PEDMn5SZ+hXTKTwSyw@mail.gmail.com>
Content-Language: en-US
From: Dragos Tatulea <dtatulea@nvidia.com>
In-Reply-To: <CAHS8izMKNeEmJM0wOgtoz9_3WRLUOqP0PEDMn5SZ+hXTKTwSyw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR4P281CA0416.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:d0::19) To CH1PR12MB9647.namprd12.prod.outlook.com
 (2603:10b6:610:2b0::10)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH1PR12MB9647:EE_|DM4PR12MB7767:EE_
X-MS-Office365-Filtering-Correlation-Id: ea3e3aa8-54ee-4453-dd9b-08df26d910c9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|23010399003|3023799007|6133799003|22082099003|18002099003|11063799006|56012099006|4143699003|10067099003;
X-Microsoft-Antispam-Message-Info:
	/4kHnEQtyrrquPIs8MIvtZjIZK34jA/V4kDggee9mNUSlG+Uu9ZICinXN3G1b+Y6KDydQzOQ/W9LNNa2JqPUmU5AuitrZdsMKTUh1ffcy09VUvJrxEgxJkWe0yZ9frbqBA7bW4OSq9S0ACHnQQraQ8pe3LjrJgDa6XpJdBEUIcW7DeiQpb+WQjgRWanXuckGc/JuQWR/wr5csFOnHtGZGsqyV56gqfhJRoI2vzqPpApTB8+dFnshZE3naffuTKqvFoCIVcr1Vxf4VQ4Pcfn7JDn6LvOuiShiPovAlJZ0jm/XiAndEHR49sYYaJW6RlGyqExlx6VeyxUvS5JwSPBtT45sVjIddj5Z584eLjUEiAyN2hM+XUPCHkdPx3w2SffH95C2W+LHnVflvJJIsxpuZt9Q8Zmirj6GbH70BXpTULSecJS1YOMOPEUivHsaXFpdxoy7gtjh4GDDOQf7w9fvd3ZcO9JGXzP4vvXaMETJnmiHuSp3XDqnb9arBZvzFL57EX6sd3vrh7ojxs7QhlmrTO5BamSEwBa6VWEw27JkebNGC/1oeIeYo4HYI4yhsr7J6mOnvIAz65MB5NAkPHshGojlaDRvee2w0p3iAxVNdsx+p8jMAc6Y/AV5CUPCG77lK/SecleT3s6zwtLxLqxrBHLhH0KNgUpTVX0EPIGjEsc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH1PR12MB9647.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(23010399003)(3023799007)(6133799003)(22082099003)(18002099003)(11063799006)(56012099006)(4143699003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TDg1aXBtaWFtWFQ2bU9qZWxpenlNMmpieEgwY2dsVks5K2lyYWpoRlUyeC9L?=
 =?utf-8?B?VzV3UUk3RVFCdXVpNFJ6NEdHRXhSS2k5NVJwQ1piL3o2ZVI3V1E1YnIxTU5O?=
 =?utf-8?B?S2U5d1h2TGRBOWNld3hpVjV1TEs5VVhIMmhJQ0xYVzhCWnF4Rjc2em4wSVJC?=
 =?utf-8?B?VnA5NCt3L0t5Wnp2UG9GNnNiaEhTU3djNCtSUDY4NUJrNFU0d0czc2U4SnV2?=
 =?utf-8?B?SEx3OG0zMld5QmZaNlQ1VW54d2hHTEhxeWpEclUvR3ZnRXdhSml6MGNMeDA1?=
 =?utf-8?B?cng2Q2JYN0V5SnE0Q0lNaTBkMCtuME02Njd0UVRJY0dzVHgyaHNpRzM0Y2Iw?=
 =?utf-8?B?ZGhPTzc1dldrVFlDRzRGUUlwaGhMaFY2UkdpV0dITDc0TG1oSHFQaEhnSTVZ?=
 =?utf-8?B?Q2ptNVkrNnh2Qy8yUFpsNmUzL01ybFMrRmFrZEE3cUljdElTYjZTZ1hrc091?=
 =?utf-8?B?cjJRZDg1L2p0dXlFZWJDa0plS0E0K3NyWStodWorU3huYW5nNENiY0FyYkFt?=
 =?utf-8?B?dmZXdDNrdWJINVNmYnJFZURtL1ViMFMvWWlRQ0RFVzNSZDI1QmhTbFVCNG4z?=
 =?utf-8?B?cXNvVzFrUVRQRHorYXpBWkViR01ua1BUNVA5bTV6ZEVqTDNMN3k3OU5Odktv?=
 =?utf-8?B?cXFab2RSOHRQZ25NckVCa3lsNExpQ21RcjkrcFBZRTBwSmg4YWFIUC84dWt4?=
 =?utf-8?B?bkk1OGRzWVhQd29TZW0ySld6NHg2K2R4N21SK0pmaFBDekVIS3FQelpJZDlO?=
 =?utf-8?B?VTBBMFY1Z21FUzY4dVk4R2RZWjNUTzUrTWlTL1drMU5Rdm5Rc1pyQW1KcEdB?=
 =?utf-8?B?UFRwcFdUcGZuSE5JZVJ3Ym80dzZvR2l0OGVvcDc5TGw0OE5xZXVmK1ZnRktK?=
 =?utf-8?B?d21uL2lQMlJvcVRxYTM3anMrYmpjK2UveENWM2lhSzVnQy9ZVmJFTjljZkdR?=
 =?utf-8?B?THJXNmRuU0hRVGtBcnNwaVBHQVo5NG5vRW92ODV2WkRnNW82MXNXK2NkS2Z0?=
 =?utf-8?B?TkpVNDZjdFV5ZStiaGRKaDdwNWhSTEtKdkRKNVROelBvOVM3WStGc0ZFODhZ?=
 =?utf-8?B?V2wwOUducGFHSG1Zd1FVSWRqQjVhNG1kbCtCbkttY204Ums4RGVKdEpwVlZk?=
 =?utf-8?B?aERRd0FEOTAyV01mUDNWd1VPUmNkdnM5OUNkUVVXanNreDF1RlZMV1d4bU9E?=
 =?utf-8?B?eXlrTWZ5OERFMUxoVnRLVnk4a3RvL3BTYmtTYTlwNmlndUNxbFFDWWF3NmxE?=
 =?utf-8?B?ckxuWHpGcllPM3lwTVlIVUlURkdyRWM4ejFRYnU3N1ZHSWxMWU12bmRjM0NJ?=
 =?utf-8?B?M29xd0dRa2hFWnBZV05UT2FKU282NkpjNW0vaUJGNUIzSkN1dmJsYUpiQ1RW?=
 =?utf-8?B?SnRwKzVlNVpVUWx1RTRCRHBQd1VhckJ6bkc2Tmd0eWpmMDF5R1FhbXBCZWEz?=
 =?utf-8?B?Q0RUYXA5YnVKSW1aSlNKRGFiRDMzNkFWZVFGUDFnOTMwNnRzUGI1dDRNT3lW?=
 =?utf-8?B?VkdjZ3JBRTFhYW9DMnBrTFBPZ3JmVEJIRlpKZFZpTHAxOThKZVlydmVpQUg5?=
 =?utf-8?B?M0JuOWRCS3RPcGdGQksyTnBpWUkxZDZvQktVTy90bS94czc2OVBwZnhEcERp?=
 =?utf-8?B?Y2VMN2c4dmZvSFEvcnNROUVLK1NZODZLdWlFUTZObGR0WXlZL0dEdmV4bjc1?=
 =?utf-8?B?OXoxVWNhSnZUQm53YUhCN0ZwT2MwZVZra2wwZklQbG4ycmZJOWpFc01vVm93?=
 =?utf-8?B?YjNQK2xIUk40eDVSUytuTzNYUGtiMVVUb2FXK2FIMkNLV2V6ZmZTaTJaN2Rr?=
 =?utf-8?B?V2x0ZTgvVXJldmFKVU8zZ21VSzZpekdnbEQxcm10VndMMlcwb3pleDdaVGR3?=
 =?utf-8?B?aHc5cDJha3N4QndpbFcrM0E5ZGpPNzRsZ0lLcStrSXRSQm55YzViMW9POGla?=
 =?utf-8?B?QlczWjVkdlJrU0ZNN3lmay9RdGhCa0dzYTZaRGdrZE5zRVZBT3hROEN6M3BK?=
 =?utf-8?B?MFNoRThJSGwrcUxRaW1BVzdrUFljakdtMkw1ZTJhZmZ2dkxWZUgzZWQyN0lC?=
 =?utf-8?B?TUhlYVRvcjUvSTRFcDc2dWE0UzdhNzAyOVpPb3FJN25EZGhDdmU5RUEzVlVp?=
 =?utf-8?B?Wm9INitpSUhZTmFVZDl4VXlpWlptUEwwVkkxWkxBQWZuU2hiSTkvRGZQcVRp?=
 =?utf-8?B?Qm4xa3ljTFBMU2pFRkdCcnUyOCtzWHpxL2xNcmVlalJIc2hWSVJGaFV5NG1Y?=
 =?utf-8?B?cXN0SlFIYm0yTXJOYWhFQ2NTa1hudnVDbmUyemhxRGlINGM5QmVOWGM1RFlq?=
 =?utf-8?B?UjZ5SGdZZVRkRXNmZUZMSExabEJRTFEzOHJNUmg1YkQ3MEhGbE0zUT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ea3e3aa8-54ee-4453-dd9b-08df26d910c9
X-MS-Exchange-CrossTenant-AuthSource: CH1PR12MB9647.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Oct 2026 14:16:24.2482
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1FVUV5gbi3adHbwnPqXo7w4WRtxs7MLEpk89LdibQQDr8Fq31lKTapeuw7JTx3sbTemO1Vzk9LMNVWQpxx/f8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7767



On 10.10.26 01:54, Mina Almasry wrote:
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
IOMMU faults because the dma device is invalid. Either because the
DD dev is still in use and was unbound. Or because the non-DD
one is used and is invalid (due to channel reopen).

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
My idea was to handle the unbind part in a subsequent series because
it probably needs some more back and forth to get this cleanup path
right.

If not acceptable I'll work on adding it to this series.

Thanks,
Dragos

