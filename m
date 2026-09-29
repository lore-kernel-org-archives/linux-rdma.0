Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012049.outbound.protection.outlook.com [40.93.195.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9951D331202;
	Tue, 29 Sep 2026 13:39:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790689194; cv=fail; b=QP/eRxhb1JOKlvzOoBDdcg/9HafZ2bOdSYUBoX0mE4rpTHDhLpRVLictdO0sOAVtkWisLM38lN2vF9xf0h9LuYm/xn3RXdkX5p9YEX2fF2WD0+2GUQOtPqHQ9E3WsRKmJzm1yKR10B+KZLOr0d3ihRQ+V1PoxXdWfMLgvlys9fw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790689194; c=relaxed/simple;
	bh=jZhZ468FTagQfov/V0Lo1T+omqYn+46gJz3lTnnKjG4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=tI2Trjgvkor0/yDeiFiivFeca6G6O1Wt9NPfv7k1yZvh0o8CFyRcg6+z5Bm6YhVRirYFNBtolRQ5AN4VLZUL+VlM76ujFDL0PukMFxHYvc8yXyNfM3dcYsZFR+BGlxbwEdg7fQGwssNQesDZ8+g9CRZlFYp893xJj4XEl8Vyal8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Fhb47ryH; arc=fail smtp.client-ip=40.93.195.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Fhb47ryH"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qdwzXQrDE+854oZmRxuLpBYDDDqFnPulVdPW5Ooh5hvRhXufxaLAbkQ2R2tsE3ddRdI1lnSVbot90W324mI73Czq9eTtSjh6sbvQEMmpvb0wmmPqEoQVqgWUB1q2WVPwnFKbSd7FadAq0n2GTCdBdQ+4AgAfxdsiq4DGXsIY8rYnelBIM0SYrYtOMgoVdBTrJXaHRB9wnYlO/zHRBqjnCTtgxdP+oK0VIuehTVIU+KXGfBx5TRjsRDy3ppbre71TJ2jurQTXfhS2G2JD3VljDiddjljD/egnzvVeyaf2JjIDnN485EMxsxPY6+pS4B2W/d5jeWrEbwawhWclTHtK7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/DKxUVmlUNMF84gqISxc316RKHl7RXsVcNh3QJRCEOY=;
 b=emObO0JqXuVN4wikCiK49bhO0r+5FoIOwBQd7lvQBBL1xTHYLYRqGGC4e1Owf0dig+GfNoAlHYxIwGYEYFpd4BfUkS5qPYyXkgbUVp5EV6MFqNG2yzGey7vNnR6kER02e4Cod63N17UJ0IcA9NLEAGnE31n6Qq5XHTJHIDyLm8iKhzXnhyWZwYIS30w0NgY6sjims6hKWqd5MxYd8c3nuQ2/+AcFPWOo2KUtI2LqzGAtaTbvN5sd+mgwnOgc4eSXvMUCUq/jJsEZH2V7diF6i10O/vGPIUpTtrFFnup/cCNPjjDVLLR6L6puFSXkybwyBicbqysU5FHCPPNr+8MSsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/DKxUVmlUNMF84gqISxc316RKHl7RXsVcNh3QJRCEOY=;
 b=Fhb47ryHyYHVzE7RdYRQWpdeaCkDvvaImRX7MTP6wyfyYxdMQhaPJ+hfoWIuxRFfifPW+f1SAm5NqKGlfq1KBIEoc8aUX9z4cAJNCDb7wtwzprlhsmQdN4xwPBUUessAhOA9vz+NCz0GUbMHbnvNKvNT5kiKWhj+gJLlAVNl4TE=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB5685.namprd12.prod.outlook.com (2603:10b6:510:13c::22)
 by PH8PR12MB7352.namprd12.prod.outlook.com (2603:10b6:510:214::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.23; Tue, 29 Sep
 2026 13:39:49 +0000
Received: from PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::ce69:cfae:774d:a65c]) by PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::ce69:cfae:774d:a65c%3]) with mapi id 15.21.0451.022; Tue, 29 Sep 2026
 13:39:49 +0000
Message-ID: <720dbac3-24f6-4c91-899e-e205865c1fd1@amd.com>
Date: Tue, 29 Sep 2026 15:39:42 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 16/23] dma-buf: Let importers ask how peer-to-peer
 traffic is routed
To: Leon Romanovsky <leon@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Logan Gunthorpe
 <logang@deltatee.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 "Joerg Roedel (AMD)" <joro@8bytes.org>, Will Deacon <will@kernel.org>,
 Robin Murphy <robin.murphy@arm.com>,
 =?UTF-8?Q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
 linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, iommu@lists.linux.dev,
 Tushar Dave <tdave@nvidia.com>, linux-media@vger.kernel.org,
 dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
 linux-rdma@vger.kernel.org, kvm@vger.kernel.org,
 Chaitanya Kulkarni <kch@nvidia.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jens Axboe
 <axboe@kernel.dk>, Alex Williamson <alex@shazbot.org>,
 Ankit Agrawal <ankita@nvidia.com>, Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>, Randy Dunlap
 <rdunlap@infradead.org>, Sumit Semwal <sumit.semwal@linaro.org>
References: <20260928-fix-p2p-acs-v4-0-v8-0-404453b9c435@nvidia.com>
 <20260928-fix-p2p-acs-v4-0-v8-16-404453b9c435@nvidia.com>
 <607e8903-a979-4d78-bf08-447321c03119@amd.com>
 <20260929132305.GJ563127@unreal>
Content-Language: en-US
From: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
In-Reply-To: <20260929132305.GJ563127@unreal>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR4P281CA0225.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:e4::17) To PH7PR12MB5685.namprd12.prod.outlook.com
 (2603:10b6:510:13c::22)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5685:EE_|PH8PR12MB7352:EE_
X-MS-Office365-Filtering-Correlation-Id: 68f22e0c-83c5-4bfc-bd3c-08df1e2f21fd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|23010399003|366016|1800799024|6133799003|11063799006|4143699003|10067099003|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	CPl3uXOKx1EK6QBm/zE8m3N/tJQZ/Ja58aZeSzT9mD9aAKmuHdZQ270iVR7Wrhq9QbIm0birr0rUFyuhdWvjFp+igIGAdlmx4t9VA/CnYdm3kpqEw/ldsHuDm8RaTIuq1keYxvgtmCXvWQNsxRkEQjr/fASCtF+1IZhrdhWQSSLBO9znd2f5DQbFO60wSTDyKzdvDJbED/JUl0r4exFS8Wy9DMkB7DzoUtdkDH5CmyfQ4Ci/qlO6p8o/OpnYQwTABrdPKSP+eLZb/ixxW2DWG0nGVsWkA7dO+Vl0bMGlDKZ5xFmpfRRBEl0RrEH89CoSKScp2A1+pW8z11TbQDftMPFFGarGbVn6Y/lu6u7hOBMWXjdLPgjAVtymxTzHymXTv0dzOsBUrIOsTOkr22ewTgRnpGDsKtbJZPaMWU7Rm5R7lWRjOq58ReI9XyUhAXSFdG4hcenqQBU0ZK+OXjE24vVa1HSUn6Nt1VZpeXhdi6NxOZLz/Gva7ck6kLQmQPTJX6ztNPgMYOhJgYpo99vIa6/h8Pw/Op4khfqGOrQJwx9zj6OtmVl0KTr6rcU8Th1BDCHCTEGlE8kUYkNFrXUWpd2Qv46P7j1csZM+houmrjpnzErQRTD+qDPdfVM1pHP4
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5685.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(366016)(1800799024)(6133799003)(11063799006)(4143699003)(10067099003)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YVZtR1hIWHBIMitzRXZNUnNxWXcrYVg3Yy90SzFlL3hQTnYzMXdaQkRmZVI2?=
 =?utf-8?B?NmhBL3hSK1FPTHpBM1pZVVFsejFQeFU4ZGpET3pIOWF6QjI2NXVxUnR4TkRr?=
 =?utf-8?B?WTFQMkZWYzBVbDJ5WEQ5TVJvb3lMcFI0MUFIckxwSWs5L2VJQyszNTZuM3dC?=
 =?utf-8?B?eEh5c01XSmh6OGRoUHRkdnZkWW9qUCtMSVVPWUtNWU5EWHhrUzFTamcxb3FH?=
 =?utf-8?B?emdYSlBUeEd0RmU1UTNMTWNmMTVKeTN6a3ZBbm9jVTIrNDhxb21RdDNxNjFw?=
 =?utf-8?B?MkV5MTdGN1k4VU1wd3B2bktRc285bUFwNm9SQ0g2Qk01OStsZ2g5RGw1bDdP?=
 =?utf-8?B?cklwZGRVRUdCaVRBSjk2KytsSWdpSEpDOGxPU2NneTdXMmZIMzRyc1B2YzBu?=
 =?utf-8?B?aTV2ZlJlK3hrSHFSeTgxWjQ0dGU1Nk8wbmdvYU1USXNNa290UzF4cGh3Ni9Z?=
 =?utf-8?B?djQ0a2tCbG0xdlk1S1lhM2xQaWcxQVBGUHMxV3RQMHA3YVFXRThiUm5PV1Er?=
 =?utf-8?B?L3QweForZk1jbC9TeHhYTGgxNEFiZVpURTFtUHhaY1hoenB1eXVnMlNmMUlh?=
 =?utf-8?B?QkhNbEsyVExhMGZCWFo1dUNRZ1YxVGhjamVqNDRIRUZwNTJya1plMFB1bnZ5?=
 =?utf-8?B?Mk0vLzNuUDlCWWNmOUZzMDJTdnQrRWF6SWhNMjBhY1ZCTlpjaEFFVzZTQ29S?=
 =?utf-8?B?a0RpdThpZTA2MVNGVlk5UnY3Nlk4ZVM4MENsbWZjcVo2YmQzTnV2ZGZOay8v?=
 =?utf-8?B?QmNEUU5CbEFGOFVaZ0tqMG9JZTBORVNuM0ZKUEtqTFBuS0FEbUEwc1NqcnAw?=
 =?utf-8?B?R0ErZUxObXVjTkk0THB5VW03ZHlQT1ZtUEpuMVdkK0dwbjNwdCtmYjVxT2RW?=
 =?utf-8?B?SHlOdzJENitiRGNwL0JzNThIeldzaTdIQ09ob3diLytjRldHOVVRWVFnNUUv?=
 =?utf-8?B?U054cEVOQ3h1SE1UejNZNnNFOGVuMHhWNUgxM2tRcTlmTHZISERGTlBTcWxU?=
 =?utf-8?B?VTBySVhWNFozWTdTOEViTmZTWjN3L3pCM25RZ24xZmFQc2Q5TWFVelU4cmhs?=
 =?utf-8?B?aVZnSkRxY1dTcm8raEtSdk1URGIrZkk0QjdBeHZtdElmL1RCc1BFa3lCUWlT?=
 =?utf-8?B?ZzM4RTN6MWpPYzFoNmVGQ2xqSlJ4ZVQwWnBTVEFmTzlaK0pJUXNiU0x1S2dG?=
 =?utf-8?B?Q3QweEpmRWswSjFaSjZha3ZMMzIzZTB6RFNHZ09pVzR4clRTeWdVVHFXb0E2?=
 =?utf-8?B?ZWVuQlIwdllqbWJsYVBsL2NLNWQrSGMwQXJOakxLdUJIektwZEd6bm5yR0Yw?=
 =?utf-8?B?YmxtZkZwbzRST0FUVjBnRytHNmgrMkp0d0U5YUpIZW5IcWovRXowZi9qV1Qz?=
 =?utf-8?B?STdOeWRXS2hpZXVVakNMZzg1NkYwaEltc0hMbGkzSVBsdkhvOFdyYnZWYWJm?=
 =?utf-8?B?Z0VWTm9hMmh0MWY0eW9MelBXQ0J5V1N1UjRObENFZTZqaS9mSjMydjY0eHVV?=
 =?utf-8?B?NjV5cnVQdUZZak9lRW5QWEdFVkRMcjJTSDNiWTdMOHF5Z3RzejBYUFprdHU0?=
 =?utf-8?B?bzE0QkJMM2R5TWhsaThFZ2pmZ0FMNmpldnRsU1JrUFIxQUJyU2Zud0pndVUv?=
 =?utf-8?B?U1J3YVNrQ0tnaEk1QjdLK1NOQ081cmF1eG03MnpUeTRHTG9zOG54WXZvZWYv?=
 =?utf-8?B?Tlg5N3FDTXRsVjhBVVBqbHlySFB2bXBiU2J1K1RqdGN2V1pwbnBZSFNlT0wv?=
 =?utf-8?B?dVV5ekJzK0ZXN2VsekZ5YlhkZWlxVEtzVDRNVGhYSFNNaTVaSkRJS09ieGd1?=
 =?utf-8?B?c0JjRHZ6OHkzRTlRZzVhMlI0eDZQNlVxdmVKa0trT0l5WFgwV2tJbklIME1Q?=
 =?utf-8?B?RXYwY1c5QllLbHRCandwUWh4aC83NDAyQTZDTEc3SmRJKzFpQy9KeG9vOFgv?=
 =?utf-8?B?YmpvUkdBZERWL0NjWXNydlhpUDg5ZXBGWDJmMmprYmpCMWFzYjJYREJIZ1Nn?=
 =?utf-8?B?clc2RTdTR3I2M3crNWd3M2dxSWdwOWczdFpWaDhkb0Q3TUx0eXErMC9NcHdK?=
 =?utf-8?B?ck40TzFqWmdvYnFUd25HaFJKb2oyTVZjQmVLMU03MjRvbXdTWHJCblYwM2l5?=
 =?utf-8?B?Y0h0UWc5NnFlTFVxSklLTmRxQnZ0ZmZ6bjdZQ0U2bnFUYzQzdEY2dFJEYmZl?=
 =?utf-8?B?WUcyeHc2a2ErYnV4dHNDZFo1QjNkUm10QVJvQndTNXp2MHFzN3BZWDJaSnVT?=
 =?utf-8?B?OC9lNmZRR0NJd1RjQnZVd2gzRjFycnBTK0x0bjVpWnVjM0tWV2lXOFVCdVpa?=
 =?utf-8?Q?0v59DNI3iCLVUbUDbJ?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 68f22e0c-83c5-4bfc-bd3c-08df1e2f21fd
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5685.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2026 13:39:49.4000
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1xoKwk7vvB7JVNQYGOC8b+MbPksqBNN1o6DVPkYOw/hVayeswQvM6UCLWrBhVLAv
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7352

On 9/29/26 15:23, Leon Romanovsky wrote:
> On Tue, Sep 29, 2026 at 11:34:05AM +0200, Christian König wrote:
>> On 9/28/26 13:19, Leon Romanovsky wrote:
...>>
>>> +	return pci_p2pdma_map_type_tlp(provider, attach->dev, tlp_flags);
>>
>> This function call here *must* be in the exporter and not the DMA-buf framework.
>>
>> So clear NAK to putting that here.
> 
> "Look, it is easy to complain you don't like how it looks, but this
> stuff is hard there are lots of competing concerns, if you have a
> better idea now is a good time to present it."
> https://lore.kernel.org/all/20260921130858.GO11599@ziepe.ca/#t
> 
> Do you have a viable solution?

Ok, that sounds like you haven't understood why I'm rejecting this.

By moving the calls to pci_p2pdma functions into DMA-buf you bypass the NAK to expose those functions to drivers from the DMA maintainers.

I unfortunately didn't understood that when the dma-buf-mapping.c code was added and just assumed that you just needed a place to put some common code.

So as long as that NAK from the DMA maintainers to expose the pci_p2p functions to drivers stand I will push hard to get that stuff removed again from DMA-buf as well.

What you try to do here is seriously not ok and I will push back hard on that in the future.

Regards,
Christian.

> 
> Thanks
> 
>>
>> Regards,
>> Christian.

