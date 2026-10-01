Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013033.outbound.protection.outlook.com [40.93.196.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 271E72E3FE;
	Thu,  1 Oct 2026 07:07:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.33
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790838427; cv=fail; b=OsyqYOg5E8oPav4i21obD9UJDzUhpqzy2libtFTnREHwfLGVc9qVnLyNhq4c8tH7a8NOJNUOdMGGMgfMyT/oUinEzTXQAGgepBecDyz0E+vr8rJdbuVhgdP/g/mhGd7QfINbxI7SF0/VPJYkZODFqfWvAdYuuLdEg0XodpK9zLE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790838427; c=relaxed/simple;
	bh=bol+32sjuDEqGPOyiOZ10hMrWUQuJfsmLcsGulxYXNE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=UJvaRGHZEorsIdfURczv2MoDlkNLJdmm+ZVoBmIWbWi9YWT8hEHzOXwkxG7znFTi1DBoj1o3R94hYsaezwCygiwzKDVV7d2h4byiI0/bV0rixSFwkx5i8JtmVBpJBfcuaVqb3/6Hbj5IMbOMhQ+jrcbK+FXR4wc1+ckABRG+OQ8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=36AwCbZQ; arc=fail smtp.client-ip=40.93.196.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="36AwCbZQ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dVMZMwFU66itSTulAHUSoEdloZ12DaCH9TSJITtPQOa4Sa+doquJzT8ikhaS71TdtM4ap0UXBOCOAOhfP8TI5uOe3p2R77AxnaGR8P4j/mkLJTl5QnLePHcds5GhRQuA4tFjEduxMkgtAWozDfIfd+1AEbpt1SVVg/nlTvzGPzgi9mNHHdO1EthBfNfqsOhghblIOI9GEKfLMIFLxUU7t4QgPIQV4xQ1eTugVKlZ04QQ58tqMDEjhDx5tCRJ+kT23FXKgtkppXfQ4ez/zgolX6Ci9QnV8J9wPUjLB9Eo58/7JZXOl7YUnhdpmEO3YZWPrrJSMFJPNFQrQF/Frb9XRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nkk+zx2foG7LAhjHNK/8EYmVjGaH3Cl4gw98xP5af3c=;
 b=oHJ9fVrINfXyTqaAqi2RxDrMgexGZ7mVdQQ7AHMDGERcY9AqPfWpNAZJdtL2/2RxgeW9G/HXtZXlmN3hi+9EYXoBBE5enRFYDORQkdxT34Ci+PDE5+wT/yAY0fbregnBruukCH2zUpMt4wtXF7ATfSAkUV277AZMPf8s4njsVqUUEQRZtShZHi4rqQmrD3q8NLeDTJlf/aIrkRARnQlfIrE38U45U6NqMDxiOtR9WZ3mZJKOlhySTTn5NKt1X4qbW56/+3XgoGF7PCR/J8sam9V0gdMEIIRRlmh4kDFGWXWrSCph1P4GmqIB/f57a7HWFMnjRW5nSENlFdiM/cJO4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nkk+zx2foG7LAhjHNK/8EYmVjGaH3Cl4gw98xP5af3c=;
 b=36AwCbZQGVvHIzdm7bfnwKmAyEIOrVJmckvIUL995DXcLVnVDzQE2UPhFR0SpwTsrQ2Yavr2mkIu0rb777vLZx1s5QjL4pdh1jwBDXrFFX6jCB1m2qNgdB2JKdF6gcfDOoEY8OITms+xT5oMlN53ANVhIfcOLqfapGbIIUuXq/0=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB5685.namprd12.prod.outlook.com (2603:10b6:510:13c::22)
 by PH7PR12MB5596.namprd12.prod.outlook.com (2603:10b6:510:136::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.24; Thu, 1 Oct
 2026 07:07:01 +0000
Received: from PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::ce69:cfae:774d:a65c]) by PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::ce69:cfae:774d:a65c%3]) with mapi id 15.21.0451.022; Thu, 1 Oct 2026
 07:07:01 +0000
Message-ID: <f5c5319b-e8fd-4a54-b7ea-6bb64a4ff7e2@amd.com>
Date: Thu, 1 Oct 2026 09:06:54 +0200
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
References: <20260929132305.GJ563127@unreal>
 <720dbac3-24f6-4c91-899e-e205865c1fd1@amd.com>
 <20260929175737.GK563127@unreal>
 <eeef5951-825e-459f-b474-bf8c59588446@amd.com>
 <20260930081832.GA3401365@unreal>
 <4549640c-f4a5-4dac-9be3-2e5aa127555c@amd.com>
 <20260930114356.GC3401365@unreal>
 <fbdc710d-7be1-4021-83c2-548c798d9d14@amd.com>
 <20260930143237.GI3401365@unreal>
 <ed393791-46d5-40ad-998b-4ac0e1e9c6fa@amd.com>
 <20261001061752.GJ3401365@unreal>
Content-Language: en-US
From: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
In-Reply-To: <20261001061752.GJ3401365@unreal>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BLAPR03CA0160.namprd03.prod.outlook.com
 (2603:10b6:208:32f::25) To PH7PR12MB5685.namprd12.prod.outlook.com
 (2603:10b6:510:13c::22)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5685:EE_|PH7PR12MB5596:EE_
X-MS-Office365-Filtering-Correlation-Id: 0955ad18-71e4-4dbd-3fb4-08df1f8a970d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|1800799024|7416014|376014|22082099003|18002099003|56012099006|4143699003|4133799003|10067099003|5023799004|11063799006;
X-Microsoft-Antispam-Message-Info:
	kcnPMq4M1I5/G8ZOuj1CBfW5wcwdlpnGudn1QOzEj/Fg20tBUpi+QQdc4GcGU9C6H5xko5I04Ab/V05jG8On2ZSYNKTo9JoxyC4YQBCEZTFCsy64xx5QlUwy49aWeFb3DMZfYah80ONN8pd1YysFiKR02vUc7jWgQCeJOHLBPZcV8X0fSVE2uiGGHStpmQbBGUqk4AzVBH2uMCQPyhpxSD8R++Y7qXST6rmZ42R9NpzNFmGBdatdM7Zw56Aygra1EVBwMdg3PYj7VTP6nYJsvw3CR/kUGkkwKA/2RInOU+M3nwgocsI/hdokOzmPOuVw0iBM5Zl91/uQgBrZLMu28uGhkafN/0963ZdlCaM8Cc6Ah32Ti3NvkSEwVafj85TQvA0TSod3H4AJnChXs/JOorYD0/MJHLuqKyBHGy6gPb8T0dUy/YiXcQ98OmiQUPX+aTEqIcOYhPSJ7/Ahur/z3X7SwC993RNTU26cjxx2XyTpeITa4RStJAcNrkvLqUVKBzPey5xNgy6xDptEkrkOL19VnhYGSORH/+8yI4+XPcgrTdce2/C7NTvJR6oik772IvJrMfbDrk/Ll0GyG9jLP+2g6uwpNk+3PYa6WeMhIJefcAv8R0dQAeA3oH7txv8b
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5685.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(7416014)(376014)(22082099003)(18002099003)(56012099006)(4143699003)(4133799003)(10067099003)(5023799004)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VEpQR0c0NmlnN3BJdmh0MjN3aHZINFN1ZUMwWmt2MEduRmxzeTlsSU1aZGs4?=
 =?utf-8?B?RGl5cXI5UnAvR2w5RlNndWxDU2lnUmdzVG9VNzVObzJqdG5ta014VCtiQ21m?=
 =?utf-8?B?dXY2WFdrc2svK1VoZUdIYkxFTmJKM3ZrbTVjTlVFUi8xTGZjSGM4WTMvd0ZW?=
 =?utf-8?B?RUZOKytIazNQRkg2K0xyczlMSjcyYlBSN3lET1IzU1NRSEgvUkVBSlpvN0h6?=
 =?utf-8?B?RWlLYnA2dkI2aEkwdmpUVGxDMGpVNWozWklzRzAzaW9EakFrRnhFRmtSbDli?=
 =?utf-8?B?SEdkU0U2akR1Q1B4YjZZWk9QclhtV2VXODRQTjd5S29LSEZSZFJqazNORThi?=
 =?utf-8?B?OWZpSGk1WVhlWG5iM01STDExN3VhWll0TnhReTR3YXEvRU5Gc3BaQWNoSnk4?=
 =?utf-8?B?cGIxdWFhRXZ5ek41czAxSkc2RThtUytnZHhIMXhIZlZtd1NueDlRVGN3akdZ?=
 =?utf-8?B?cDdwcmErelEwYUh4bTl0SUdibVQyTDRHZ2RoL2c1S0hVWEpCSmFGMGhiQnlx?=
 =?utf-8?B?TWJPTUw4QUJUeHFVQmpwR1ZwcWxIRXRQUmtVMENuQ25PWW5xSzdVQllLZTls?=
 =?utf-8?B?WVJvV0RIQ3ZYRDRvUksrdnZXcTFZMkNDUU1xNnZKYXdzYnBlQUZob1VUNVpk?=
 =?utf-8?B?T2JReXdrMHpNeHJpdVBFbk5tVEdPU29pd3E5b2pyczhvb2pJREl2QUMxQVNx?=
 =?utf-8?B?Q09CSnFmTXRDVEt0Z0ltclZNZ2pTMXZtRTlGNGJmc1RYUzU3dmZpcDZWUG50?=
 =?utf-8?B?QVFjTlU5QWgxWER1Q21lTW41eVlWSmdCM2d6Q1hKZTRQMGFxOEQ1SHpYd1RD?=
 =?utf-8?B?Y0djSzc4U3dUQ0RIOEs0ejV6V2x1ZVovL0lGd3hnMW9DOHBiZzdIc1NSRlF4?=
 =?utf-8?B?OFZQbkRQUXZNaGdDNk5BTzlWTnozd2xBejVCK3FHTlZoTnZvZEhFSnUzYnJS?=
 =?utf-8?B?UDgxaEhzcXJ4TkM0SHZ3Ny9WQTh6NUd3YW5RN2QvTlFEWTQ0RWMxSXZkNzh2?=
 =?utf-8?B?R1NOSWpwODc4T0Z1TXpIV0srUGhmZ2hGODVMYysxZzR1WVFhMUVZNlFDT0Yx?=
 =?utf-8?B?WmlNY2Q1T0xPMUFWMWdHRGl6cjczS3QyVTlZV0ZqdVFYdmtoN1I3bjUwNVBJ?=
 =?utf-8?B?ZG5ON2ozRUFXZEs2M3hsTFB5ZTd2SkFSMDloaDVjc3M4MWVKaXFheUwxVUgz?=
 =?utf-8?B?TDVYYU11eEc5a0JEQVM4N2VkaGh5RHRkWDdhV2dYWTZmYXVGYmx4QkphV0N6?=
 =?utf-8?B?emREV050dVhZMWVBTUw4Y2g1enJqL0tqeWYzb3hWYUtOU3dBMjF4dnJUdnBs?=
 =?utf-8?B?VXVlWEVsdDZBWStCU0xHN2dBazg4RWkvdWQ4NmNHQVFaZGZLWWxxZFpKN2Zq?=
 =?utf-8?B?ald3WS84T0ZtMGtHWFVtb2VnV1h5ZkhjMDBZOXZkb1BxOTdNUDFuY0ZNZ2Nh?=
 =?utf-8?B?ekM5alc3Z3h4STJvZEZDM2FYeGtSaEoxUGJZYWVZeUJzMDFLQVRJcUJLTFBk?=
 =?utf-8?B?L0ZyR1hOS2xBTzJIYUF1NmFhUm12RzM0RkNBZ09MaXJIZDRzOGROV2tSVllX?=
 =?utf-8?B?R1NSOFZldHprcWNMbmppNDlNdDdpT3J3d1o0QUgwS1JLQXE3enRReVo1K3Yy?=
 =?utf-8?B?ZDFLenRuWnJQREN0ZURFcmkrb2plUmNaZHVWaTR5L3hRV0NkVklMLytWLzBi?=
 =?utf-8?B?cm9TS3VWbXBJMzQ2U2wxSTc1aDU3dFg2eHNyamNHdjVFZWplM1VVbHhFUVBs?=
 =?utf-8?B?ZEN3SVFtTG0wdFlUR0RiVWVoYW4xTHl4VFFPOFI4Ujk1QTdXL2FOY2RTdU1D?=
 =?utf-8?B?OUV0TlE1T2pIbmpKLzYrUXMvR1l6aVF1UnRKenFTWnAyUGN0Q2cyL21oL3VN?=
 =?utf-8?B?RTVib3gwTjdLaFl2M3R3M3g3Y1FUUnc0cmg1YmJwTHVnRHJpWVZ6bkxXMHVI?=
 =?utf-8?B?emZ6SjM5TGV1SnB3QlliZDFGUUh1NEdyZDJpOUJ2YXYxakl6YUh3WUNrcmhG?=
 =?utf-8?B?KytpQWNyamNPRWNnTXNwQkplWnlScEpWck01cFErNE1HNDU1U2lOSU5nMGdP?=
 =?utf-8?B?S0duNGNGRitqaUdYeHltQ1Yrcis5WUJIMnFmVjN5Y0RHRGVWaXUvN0QzdHRs?=
 =?utf-8?B?QXl1bWVuOTRJM0FXZlJEYTVTSU10OUtYWVhIaXoyMlQ5MTBNREVkVjgvNmV3?=
 =?utf-8?B?bmVjWmkvNW9DMHBjMGdVQ0hRTW1ZckpoeEtoOG5GSnA4cjF0Umt3T2JveUVr?=
 =?utf-8?B?L0ZuZVRESWs2Q3dOLzBlb3Y1a2tUNVNIV1MzK3MreDJSczJrTTZpMFYzOUhQ?=
 =?utf-8?Q?zbhqywhZ8Qzdl1n8Y+?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0955ad18-71e4-4dbd-3fb4-08df1f8a970d
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5685.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Oct 2026 07:07:01.2609
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UqJyBsK/boQWkN8i2F/SEK7tUlPl5F4cvGB9AQjK+xpT8szTa2bPgDEBNqLGLqem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5596

On 10/1/26 08:17, Leon Romanovsky wrote:
> On Wed, Sep 30, 2026 at 04:52:20PM +0200, Christian König wrote:
>> On 9/30/26 16:32, Leon Romanovsky wrote:
>>> On Wed, Sep 30, 2026 at 01:52:39PM +0200, Christian König wrote:
>> ...
>>>>> The importer needs a way to obtain device information from the exporter so
>>>>> that it can configure itself correctly.
>>>>
>>>> That won't work with DMA-buf then, the exporter is completely opaque to the importer and that is for really good reasons.
>>>>
>>>> Why in the world does the importer needs to know the information from the exporter before the mapping is created?
>>>>
>>>> It is the exporter who decides how data is accessed by the importer and not the other way around.
>>>
>>> There are several reasons:
>>>
>>> 1. This is how DMA-BUF MRs are built in RDMA. In mlx5, they rely on the ODP
>>>    mechanism, which requires an MKEY to be created first. See commit
>>>    90da7dc8206a (“RDMA/mlx5: Support dma-buf based userspace memory region”).
>>
>> I know that patch, but I absolutely don't understand where the problem is.
>>
>>> 2. P2P routing is a property of devices, not memory. It is known and remains
>>>    stable.
>>
>> No, absolutely not. You are making completely incorrect assumptions how DMA-buf works.
> 
> Maybe, but I understand how the kernel, PCI, and P2P DMA work, and dma-buf
> seems to operate in a parallel reality that is not aligned with any of them.

Yes, but that behavior predates the P2P DMA work by over a decade.

You can't ignore how existing drivers work just because you want PCI P2P to work this way.

>> Again: What is exported and from which path is up to the exporter and only determined when you create a DMA-buf mapping!
> 
> Let's discuss the PCI P2P case, where `p2pdma_provider` is present. In this
> flow, the exporter has a PCI device, and the importer also has one when it
> attaches.

No, they don't.

> The decision about how to construct the addresses is made at that
> point. Note that both the exporter and importer are PCI P2P devices, so the
> importer should make the request.

Again, no.

The decision where to place things is done when the first mapping is created and that is documented and full intentional behavior since the very first merged version in 2011.

>> In most cases you don't even have a single device which is the DMA-buf exporter.
> 
> How is it possible for exporter with p2pdma_provider?
> 
>>
>> Only while creating the mapping the underlying access path is finally determined. It can be that P2P is used, it can be that internal connections are used, it can be that the data is moved to system memory....
> 
> But we are talking about in-tree exporters: RDMA, VFIO e.t.c
> 
>>
>> That's why we have the distinction between attaching and importer and the importer creating a mapping.
>>
>>> 3. See the VFIO TPH ST discussion, where the requirement to obtain the
>>>    exporter’s P2P information in the importer was raised again.
>>
>> As far as I can see there isn't any. The TPH/ST information are just passed through from the exporter to the importer.
>>
>> We could define a bit better what needs to come first the mapping or the TPH/ST query but for their use case that is actually irrelevant.
> 
> They need an access to p2pdma_provider too.
> https://lore.kernel.org/linux-rdma/CAH3zFs2rhg6-b-pVDps1V8LsM4Dn48t4J4LFVyKOZtT4axdY=Q@mail.gmail.com/

No they don't. They just need the routing information the same way as you do it here.

And Zhiping reply actually makes it 100% clear were the misunderstanding is here:

> Two properties are worth stating explicitly:

>  - The metadata and its callback are per-dmabuf, while routing is per
> attachment, so this deliberately uses a conservative all-or-nothing
> gate across the current attachments. It may withhold TPH from a direct
> importer when another attachment is not BUS_ADDR, but it cannot return
> a tag while any current attachment has a non-direct route.

Yes that is fully correct.

> An importer
> attaching later does not change an existing importer's route, and
> future queries reevaluate the current attachment list.

No, that is incorrect! An importer attaching later eventually *does* change the routing!

The final routing is only determined on the first mapping call.

In other word the semantics is like this:

attachmentA = dma_buf_attach(dma_buf, importerA);
...
attachmentB = dma_buf_attach(dma_buf, importerB);
...
...
dma_resv_lock(dma_buf->resv, NULL);
...
pci_info = dma_buf_get_tph_st_and_routing(attachmentA);
mappingA = dma_buf_map_attachment(attachmentA, ...);
...
dma_resv_add_fence(dma_buf->resv, async_signal_preventing_unmap);
dma_resv_unlock(dma_buf->resv);

So that PCI info including TPH, ST and routing is only valid as long as you hold the lock of the DMA-buf.

When another dma_buf_attach() call comes after the mapping is already created the invalidate mappings callback is called and eventually the buffer is moved to a completely different location.

So on the next mapping call you can get different TPH, ST and routing information and depending on the internal topology of the exporter eventually a different PCI device you can do P2P with.

What can be is that not all importers support the invalidate mappings callback and/or dma_buf-pin() is called, but then exporters usually don't allow PCI P2P in the first place or at least only under restrictive limits (like for example cgroups).

And yes that semantics has been the one of DMA-buf for 15 years now and yes we can't change any of that on existing exporters since that is uAPI.

I hope that I finally made it clear how things work here. I'm kind of running out of ideas how to explain that.

Regards,
Christian.

> 
> Thanks
> 
>>
>> Regards,
>> Christian.
>>
>>>
>>> Thanks
>>

