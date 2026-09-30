Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010042.outbound.protection.outlook.com [52.101.56.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E06E3F9A13;
	Wed, 30 Sep 2026 08:35:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790757325; cv=fail; b=a9/yBPe4o505DVwOPuZ21Cu4t0NOikc+AcV/yFg6Yj/lz2LoPlShTr4E9Nat/3INDbHiM4zUEfGtqEFOS2ZdF3XjHSMSI4Y2c+3RmHfrOow8XemStVp/JRAFPJE/Ek5Xn+VjHWKmoKX6C2K71ODClwsSOLBFNqjrDvdakcLDFqY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790757325; c=relaxed/simple;
	bh=tFDAfiLj6ZvUJ6EBTMoFgDtstpJX44EfQDFfN3aF/Ko=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=tgDUgPufxaAsikrGrjDtL8pxoacmF5usaYQ280lnBpc/O34S+xO6FvTqtPxNbGog7YKl5VEHEtjvO7WbQvDQFbbyYdtZAvRkv013GMI3i+hTbUM/WKINjDbFWnwxvOYKQX4j3DqCkxkQvQHLg965lOvwpOhcMKTO0Pb4mZ9nGpc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=ngRyevEm; arc=fail smtp.client-ip=52.101.56.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="ngRyevEm"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=l72/qqpBAf2Nv4bgHa7Xu0coNedKBzvWntb/Qt1n85lTMnsO4E3Z3W9gCGkBNaH5mg+Et8MJOcUVY98lkCNJ5RCdUNBVvKv476AJxI7MiDXRSKSwBb//hdd0BSrUI/ubUO+GRy7hMqnsENVJRLj9kKn6mXh0Y1dP+k6VvestNSmN1jFEGuEs2a8mtDtnTGXDY5jJH8ls7OqODDeROOBlG2BisHTm8sX1c9aetQaBD1Z4yO57vlYsMRLef71/g7xWN6qug7S1srS5ydD6q96T5RJbYml0vOX8Hb/wzkD2qUJRSqMVvInypYK6lZ4T/tzyExOsfapIFSFdAlvnS+dR7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Yok2iiMapsZLVqqdOeheofsvqokA/lRENlccVX8xceM=;
 b=LNjL6PTSKuK3EK0ai4rWX24v+lkL5YF1s0YkFg1aAeQrOwxn4tXv2HukK1IlZpxQsJWuS2igot5gpCoy02laRdER9ECr3Li4zdD7lY3qYT0bPXFeToNbbLKIWGBW5Et6DTM4S1ftrcF+Gc7mer1kMMW5NHHgCPQOZO/iSLL5xQKLsDsEir6m0SLq3PUBEA9NJHK74pPK7o7rCYw7GmCxsK2sgCke3JtAKk2F6KQXONh3W7NYJh3dZwDrJYvqY7FywkqOiHrbyxj3ZrxhsY53J52ixYsAL4I8xvj8yJliJcyHDRaUAxuPy34hDZoTkA344RZ6qQmdYMY5k2syqrZY0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Yok2iiMapsZLVqqdOeheofsvqokA/lRENlccVX8xceM=;
 b=ngRyevEmpXvq/NfwqNenAPhYJvA9VhMQ6m6r3wJECvWFhL6g3JodBbm+QbF112bmDu7sHU0vzSlXSJeiGfNrqOViyZaxYjOwP97O1W4cZHo1+hMxHdwGdB1B+kTlaAe0pD02x0NyqVXZ15E+oTn26bEsP4g3v4pYZojktoROaCM=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB5685.namprd12.prod.outlook.com (2603:10b6:510:13c::22)
 by DM6PR12MB4154.namprd12.prod.outlook.com (2603:10b6:5:21d::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.15; Wed, 30 Sep
 2026 08:35:11 +0000
Received: from PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::ce69:cfae:774d:a65c]) by PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::ce69:cfae:774d:a65c%3]) with mapi id 15.21.0451.022; Wed, 30 Sep 2026
 08:35:05 +0000
Message-ID: <4549640c-f4a5-4dac-9be3-2e5aa127555c@amd.com>
Date: Wed, 30 Sep 2026 10:34:56 +0200
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
 <720dbac3-24f6-4c91-899e-e205865c1fd1@amd.com>
 <20260929175737.GK563127@unreal>
 <eeef5951-825e-459f-b474-bf8c59588446@amd.com>
 <20260930081832.GA3401365@unreal>
Content-Language: en-US
From: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
In-Reply-To: <20260930081832.GA3401365@unreal>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BL1PR13CA0420.namprd13.prod.outlook.com
 (2603:10b6:208:2c2::35) To PH7PR12MB5685.namprd12.prod.outlook.com
 (2603:10b6:510:13c::22)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5685:EE_|DM6PR12MB4154:EE_
X-MS-Office365-Filtering-Correlation-Id: 0a48fb07-a420-4818-b503-08df1ecdb9de
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|7416014|366016|1800799024|376014|4143699003|10067099003|56012099006|6133799003|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	wv1NI5qv0hDFXcq9bKAJUOQSrMmtWA72aJPad5QFeTMDOYaSwrWeTysa8qGVZvEIyUYid3YNp1pCysGGnE3mymDPQQo409mln8uyBQ3WiK1b+f4igKpRPVMss+qKZBcAqErmOF3VxNhhpBZykUVvkc/V94hmDurY0rKF7Kzb4ObS8eDa0Mm6Z+czZvun9gnLLTSmq8m7czewZsS0TPw9+G2LwvLKqUlLe924H9XOB1ha3kJecEKGe4trRfP63Mie7/060dJxW99JmtybcRNcJ9qqsJjJgX5AI/gAgo+Vv6fzCjcKRLVzc882ZENHz8CV7zRYYi2u5/jFwFxRUEiN/gvmWP9YzbH99N0NCipyL2WhBQ00y/XkjfIMxImasZRZI2/0imivpl0mVe/41xzzJ3bKBMes4D3Wl247AXuIUNdEFCjhk9+K+jiiX3RLMuumxPEizrQMDDJQ3MOi7S2TUwKyu0qgGnLU0plt8kw4/xIAbnMux82neCTs6bU4uHO4HcIBXyjV6qRQzXWIrsycUrpQwUPJMEDatLA70KSeGVN1oKFdHipMJvbT9SWZGUFMgN6zOHmY1lns3AQZhBDmLXO6XNT6GVbz1KiGkjEaVeOMCTh8wUMSg+CVRMaZdCmp
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5685.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(366016)(1800799024)(376014)(4143699003)(10067099003)(56012099006)(6133799003)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QVd5S0hhcjNYR1JSbjRmQis3TytmRDk2dS9OZHFoamZBTk8xZWFPQXVtOWtr?=
 =?utf-8?B?bDd1NXRVdU4xSzJXd3hNTDRQc0w5enpOZFBqSkhNQUFvcm1DNTkzOHBrbUhF?=
 =?utf-8?B?YnlUdGxmMzdoZzlyQU9lQm1GK3lsV2owa3czV2JFdGtSU2xtTms0SmlLSWhR?=
 =?utf-8?B?RiszYk1iYldhZzU5R0RGTXVuZGJwdTdLU1QwMnc1ZE14NVlWcHRsRzBVc1F2?=
 =?utf-8?B?S3VBQUtVVEtaTXFSYWo2RDVtYTdRU2kzZTVtbGtPS0ZPTXpPaWtnWFRnTlBW?=
 =?utf-8?B?SDBDT282akM3eklWQXJqUGpnM0FXUzczcnh4U0RjTXBYOW1zRTViZ0dGOU9I?=
 =?utf-8?B?TGVIWjNRNEJIVno0c0d4V2dEUDlPUnUxSkUrL2hMb3ZtdVJBaGFlUi8wbGFJ?=
 =?utf-8?B?Vzg3Y3ZVMTNBMUJHdWhybUtVanNoTEZRRWg1NlBBQTZqV1hINnJZbCtKQU5U?=
 =?utf-8?B?b1VrbWNaT0VxanZaVTA3N0lQUVpOY25sN05NWThJVnNJUStXeWtFQVdQTkZK?=
 =?utf-8?B?VVliSjNGbEhFQnJZYmF6UnUvMzZjQU1WN3ExVkpQV3J5MmRCb2d3bUxTN0pC?=
 =?utf-8?B?SkFOSCtONFI1VGY0ZFhUZm5RSWlBbDVNZG12QTVsdEhCNkJhV04xTUxOZDFM?=
 =?utf-8?B?UWJKNG1YMzRRNkt2a1RqeVRKbGpuNnpzRmNwZFpYUk1pVm54dFJTZk5PUmVP?=
 =?utf-8?B?Rzg0T25pM2lBb2sxV3NtQ0JlaWhXMCsrRDFGaGxlNjlDekEvbit5WU5ybXB4?=
 =?utf-8?B?dS9RUy9UeFM3Z0ZEeDFDQ2p6QkJVZTVFdjFYMnFrbXZBc1lqSWpjd3dSKzdS?=
 =?utf-8?B?V2hmbGRUUmk4U3ZvU2FvRE9rWVZ5RTR5aCtaWEMwRE9rMG1BWERncW40OU5R?=
 =?utf-8?B?V1ptcnhEVlY2WUk3N0VoMHV1SDlrN1dYODllM3dLUllxKzBvdG1MQU0rak1H?=
 =?utf-8?B?ZmJoRUQwTER4SEFpLzBnNzVBYjNMOXlvQkR6UmhIY3NLMWhGRVdXbnhuL09D?=
 =?utf-8?B?YmtNTnRLY2JDU01oNzBaRlBTbjd1T0pHQS84T3JUTERFaXE4d1U4bUsvaXRl?=
 =?utf-8?B?a2UzSThseDViSmNGSTlrK1JwdzJVeGF3UUMvVE5zOGNCd3ZLZUR5MlROVEkz?=
 =?utf-8?B?OVVKQndrdVZXQWpvVGcyMy83YTUybGRPNS83elZBVGE5ZTBxQ0gzNjBUYVBM?=
 =?utf-8?B?c1hlWHpBa0lKV2F1QS9RWTRKMGxHL2lHZXhqR1c1aFFVVlhrNmp2NE4ycm5Y?=
 =?utf-8?B?WnQ2Q1FwN2UzZzBPem1xb29tWFY0VzVzWGo2UE5IaDRKVXdsSWRheVAvRjEv?=
 =?utf-8?B?ZnJvZ3V4bFJMaUNpM2MzR3NWUHRITWNPWllwVEgzU3l6THVNSlBQY3g1c1RC?=
 =?utf-8?B?RVZ0eUovWnJUSXF0S3NkWWlUQ2wwUm12ellGbmpCVWYxUnc1K3VYT2pDTXpl?=
 =?utf-8?B?OEd0VmdBMnZ1TUlvUG1NQUFPL1BMY2RaQ3dkcm5uaElXb1RyWWxHVUxXdm51?=
 =?utf-8?B?bFJ0QjZ2akI5SGM2Vnh0RXZMR0lLVmdRN09aKzArcU0zNjZiYmVjVE9Jc3FZ?=
 =?utf-8?B?WC9yT0FDdVd0blcvVXBhTXYrcTY1RUUyUkI1QnFsaG9TTnN6U2tKMHNYZ0g0?=
 =?utf-8?B?ZXY0eHpRazNlQ3FDb013T3RESndPM1BPYWd5U1g0R0ZYOXZsWG03cDd1TTQr?=
 =?utf-8?B?bHg5UklzUmhOMTIvMjF0d0wrZnV3WEs0SXEycThoeHR1S01PVkNmekhVNU51?=
 =?utf-8?B?Rzk4Ny9RSTE3YnByYjlJSXNIcG50MUJTNUZCRnh2cGp2VjdtQks4cXMxZGJv?=
 =?utf-8?B?L1VablFuUTRZRU5LcmJkUUd1Rk1IRmVBK3lFM2x1Q283M0FVVWM4N1gzRkVr?=
 =?utf-8?B?SjFtLzVaaHRsQmlpRHlrNFBLOXZHMERJdUlHNlljeG9DMzh3dHNPQ1ZRaXJt?=
 =?utf-8?B?VDRpR3BvWlBNb3dlckgyM3hKbGlwei9JdVZ0RWVTRlI3SEEwTTNoc3NGdjIx?=
 =?utf-8?B?TTRqa3c3ZGIyTkNuSnIrdDFLYWJWOE1kMlB0SE1SaHk5VTNXQjRKbUJ1aHhT?=
 =?utf-8?B?SnJCSFdsanV4NWFZWmNFSUdLbzNQSHBwektFdFhEV1VmbzQzcVdTYlAwR0xC?=
 =?utf-8?B?MWxVRVZYUDlxWDdXQUxjV09FWkxiWnM2QTU1OHZ1MmVqOXRhSHZwRW1WcGhj?=
 =?utf-8?B?allNMVhvM0xpQVp3YTA2UE1HZWl4SVNjZ0pnU1ZKY05yVEV5ZjZTdUNDaFI0?=
 =?utf-8?B?Q0F0dnVhVEFjemlsSFpUc0JLU2ZWeEVaWVNuTzdRZldqSDZwTkljcTFEMXFz?=
 =?utf-8?Q?K/GDx71/VLJA8G+MBZ?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a48fb07-a420-4818-b503-08df1ecdb9de
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5685.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2026 08:35:04.7312
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: N/eu4A24mF/etHqDjdR5G/WkTRxZP/iKz2TRGtq5GM/xfT+KiFEeIRHAIOS0uBQp
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4154

On 9/30/26 10:18, Leon Romanovsky wrote:
> On Wed, Sep 30, 2026 at 09:00:57AM +0200, Christian König wrote:
>> On 9/29/26 19:57, Leon Romanovsky wrote:
>>> On Tue, Sep 29, 2026 at 03:39:42PM +0200, Christian König wrote:
>>>> On 9/29/26 15:23, Leon Romanovsky wrote:
>>>>> On Tue, Sep 29, 2026 at 11:34:05AM +0200, Christian König wrote:
>>>>>> On 9/28/26 13:19, Leon Romanovsky wrote:
>>>> ...>>
>>>>>>> +	return pci_p2pdma_map_type_tlp(provider, attach->dev, tlp_flags);
>>>>>>
>>>>>> This function call here *must* be in the exporter and not the DMA-buf framework.
>>>>>>
>>>>>> So clear NAK to putting that here.
>>>>>
>>>>> "Look, it is easy to complain you don't like how it looks, but this
>>>>> stuff is hard there are lots of competing concerns, if you have a
>>>>> better idea now is a good time to present it."
>>>>> https://lore.kernel.org/all/20260921130858.GO11599@ziepe.ca/#t
>>>>>
>>>>> Do you have a viable solution?
>>>>
>>>> Ok, that sounds like you haven't understood why I'm rejecting this.
>>>>
>>>> By moving the calls to pci_p2pdma functions into DMA-buf you bypass the NAK to expose those functions to drivers from the DMA maintainers.
>>>
>>> No, you have misunderstood Hellwig's position. His request was to ensure that only
>>> subsystems deal with P2P internals. He was perfectly fine with bringing P2P
>>> complexity into dma-buf, since it is the agreed-upon mechanism for sharing DMA
>>> regions between devices.
>>
>> Thanks for clearing that up, I indeed didn't realized that.
>>
>> But that is pretty much against my standpoint that I don't want any P2P complexity in DMA-buf.
>>
>>>
>>> So this is not a NAK bypass; it is a correct implementation of his request.
>>> He handled P2P-related complexity in the block layer.
>>>
>>> Let's add Christoph to the thread so he can correct me if I'm wrong.
>>>
>>>>
>>>> I unfortunately didn't understood that when the dma-buf-mapping.c code was added and just assumed that you just needed a place to put some common code.
>>>
>>> That is not correct. Devices A and B share a DMA region via the dma-buf
>>> mechanism. Where do you expect the code common to dma-buf to be placed?
>>
>> In the DMA layer!
>>
>>>>
>>>> So as long as that NAK from the DMA maintainers to expose the pci_p2p functions to drivers stand I will push hard to get that stuff removed again from DMA-buf as well.
>>>
>>> Are you seriously suggesting that every dma-buf driver in the world should
>>> have to reimplement this mess?
>>
>> Well I completely agree that this should probably not be replicated into each exporter, but that is the job of the DMA layer and not DMA-buf.
>>
>> The purpose of DMA-buf is to exchange DMA addresses between an exporter and one or more importers and handle things like lifetime and synchronization of accesses. 
>>
>> What the framework should do is to transport the capabilities of the importer to the exporter, e.g. what physical connections we have etc..
>>
>> What the framework can also do is to have additional information from the exporter to the importer regarding addresses and mappings, for example if they are bus, IOVA or some special internal DMA addresses or how to stitch together your PCIe TLP or whatever.
> 
> At a minimum, exporters need to pass `p2pdma_provider`.

No, exactly that is a no-go. The neither the framework nor the importer should see the p2pdma_provider.

Only fully translated addresses where the DMA access should happen.

> 
> If I keep the “dma-buf: Let exporters hand out the P2PDMA provider behind a
> buffer” patch, I can move the P2P TLP types back into `p2pdma.c` and export
> only the function that indicates whether ATS is required.
> 
> Is it ok?

What you can do is to forward declare enum pci_p2pdma_map_type and than pass that 1 to 1 from the exporter to the importer.

Regards,
Christian.

> 
> Thanks
> 
> 
>>
>> As long as both the exporter and importer agree on what those values mean I have no problem at all with that.
>>
>> But how those DMA addresses come to be should *absolutely not* be part of DMA-buf! The complexity of that is seriously not something we should have here.
>>
>> Regards,
>> Christian.
>>
>>>
>>> Thanks
>>>
>>>>
>>>> What you try to do here is seriously not ok and I will push back hard on that in the future.
>>>>
>>>> Regards,
>>>> Christian.
>>>>
>>>>>
>>>>> Thanks
>>>>>
>>>>>>
>>>>>> Regards,
>>>>>> Christian.
>>>>
>>>>
>>

