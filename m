Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011011.outbound.protection.outlook.com [52.101.62.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3D3A35E1AD;
	Mon, 21 Sep 2026 06:44:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789973048; cv=fail; b=sbt3pw9/Vk1P/jccjmDMp/eka0m748vxm4+MakoFHigDMmyXre1IAPEBC+AL4BeIJFwktLc++v6KjKNXvvrxlO2+hUvffafeLe74pO0t4OWy0csDcM5AtupnO6ivEfLQmoLZMKsGWVBtdISanirBSERyt+I19HzERdYITSZPKQI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789973048; c=relaxed/simple;
	bh=OIGfSfN+En0nHj88gNfM2/en4SpzsU+0qJ+VSr21mDQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=RLTaz/OLmL2cX5xs+6rGysFSXyg+VQk5I+GqHZwgEMugcXx8KgCwx8kNoYU6C2O6nH0SwQqkPrKany03pzPSICO6CtvHqWbE1MtdP88naC9Cwf/olTs+WN7g0zLlOIf5GNOHpaL+fBWh3kMr87yBiemPIxvziB/X2drE7rWZIVg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=knykQCKj; arc=fail smtp.client-ip=52.101.62.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="knykQCKj"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kk8dm1/YBHt7nv3YHA/Rw0VRqPIOJRJMRyrjRJK/kaqx9Dw7D89KiWDnMoY0ayNkG5NrYT/B5BtRBnZ/unDheXVpUlK+WTy3087b3IoXwBX3fo5RYDotgSu8mHQLPxVGksxkHyxN6wTstI0hMLuVnISnfZtPACXAcRBOjPmKCKUf7dwPipQSIvQ5ftLjpSNiBhLV/31/305aR1XM5nJMDkyCtKuvhvYAWqt5iBEXz4fbPDL5tWG7YgBHI2H8kbjRcbTtJIhx3qKiyd6ifUKy7bvjTo0NbqyPmUJAkMAST3HpsKJ9H6pM7DpVxD9XF22lsPwl2B+zkK0X/I5CiL6d5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4FAs5ZqnZSg4v95aA8NFmTexcjTpwmfM84fz1IQRbsI=;
 b=rc852jBXcXHGo+Ex1lx96RykwRPFQ15UFzVX1QUlzscaYgFqDZ7zc7J7ggnJPHE1Jit0KZk+L89Lw9HKrDRSx56GsKOq71rKVUSKl3K65pw6Wr5foZx+2DT07OgbI1BGEtqUkvV2AmWWsxT3a63HIP1AxXHBFAH7/noeuUgjabew1/b0P49lGyZVigZH/28ypwpUAKtIcH4bxFgr3IYKApYf8CubAwdL4QVxUmunhm/IDmPnjhBr6N/jxyg3Cl8hT7oz/sAtyImVPkBGhDsdql/taThS7IFYWnZbrKVYTV3BINOjW5dOgm6kk1BKhVBaC/I10m9gnX2yPIe6xewgoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4FAs5ZqnZSg4v95aA8NFmTexcjTpwmfM84fz1IQRbsI=;
 b=knykQCKj2wKiILxdAjRj97unIA3RL2GM0iBq5EhcVpnPn/RvVsP2pZspVjrH2Mp86BtbLvn/6KKUK3+0+LzK1VkvHKVOkPN99/TjPEQfk6fgZw9Z98h13EqpWFjoEaEEshxsMof0RR5yNOHxo7uPyt+d3H9pFT3ANkifpNa1LCM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB5685.namprd12.prod.outlook.com (2603:10b6:510:13c::22)
 by IA1PR12MB8263.namprd12.prod.outlook.com (2603:10b6:208:3f8::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.16; Mon, 21 Sep
 2026 06:43:57 +0000
Received: from PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::ce69:cfae:774d:a65c]) by PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::ce69:cfae:774d:a65c%3]) with mapi id 15.21.0428.011; Mon, 21 Sep 2026
 06:43:57 +0000
Message-ID: <9656f2f9-2e39-4007-b065-3b763b53c6de@amd.com>
Date: Mon, 21 Sep 2026 08:43:49 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 18/18] RDMA/mlx5: Ask P2PDMA whether ATS takes a direct
 peer-to-peer route
To: Jason Gunthorpe <jgg@ziepe.ca>,
 =?UTF-8?Q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
 Christoph Hellwig <hch@lst.de>
Cc: Leon Romanovsky <leon@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
 Logan Gunthorpe <logang@deltatee.com>, Chaitanya Kulkarni <kch@nvidia.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jens Axboe
 <axboe@kernel.dk>, Alex Williamson <alex@shazbot.org>,
 Ankit Agrawal <ankita@nvidia.com>, Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>, "Joerg Roedel (AMD)"
 <joro@8bytes.org>, Will Deacon <will@kernel.org>,
 Robin Murphy <robin.murphy@arm.com>, Randy Dunlap <rdunlap@infradead.org>,
 Sumit Semwal <sumit.semwal@linaro.org>, linux-pci@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 iommu@lists.linux.dev, Tushar Dave <tdave@nvidia.com>,
 linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
 linaro-mm-sig@lists.linaro.org, linux-rdma@vger.kernel.org,
 kvm@vger.kernel.org
References: <20260914-fix-p2p-acs-v4-0-v6-0-5ef07ec9ef06@nvidia.com>
 <20260914-fix-p2p-acs-v4-0-v6-18-5ef07ec9ef06@nvidia.com>
 <321890690ce83d1943b2f678bd9bee9b8c895b66.camel@linux.intel.com>
 <20260918121500.GV13683@unreal>
 <b517070d0b9236b03962fcba649faffcacda23eb.camel@linux.intel.com>
 <20260918170524.GH11599@ziepe.ca>
Content-Language: en-US
From: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
In-Reply-To: <20260918170524.GH11599@ziepe.ca>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR2P281CA0078.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9a::20) To PH7PR12MB5685.namprd12.prod.outlook.com
 (2603:10b6:510:13c::22)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5685:EE_|IA1PR12MB8263:EE_
X-MS-Office365-Filtering-Correlation-Id: 2e740638-f10b-4228-3ec3-08df17abb5ce
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|7416014|366016|23010399003|10067099003|4143699003|56012099006|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	N2ObD7PJEldHyR8x8JIRV87VjQP+uCxNM/w7gt0w3kU8tbE4fiPbToU3vBvQPorzKJiutAPcqi70uh5/6hskDEMmBmzHGosHzly6H4UP5RoKX1vFlkUWqtGn0f3Hr4JkJgcKwgm/bXc5xT9QnruGCG7vfchPMj77P1BNF2DGv3pDtN/X1xn+gjhQPaeaB7QRNVt5k9HQELL1B3yj4PsGIfmSSjmtEchrWRzut3absPbIDGP7bvSMX+7Zg+ELEpOfy3s6GPatlJ/HqvwlPMCzDer6oyzc0w6nCBOGr0LrYmWy8QOMMY/Wa1vnPRZlbtHe1TMxn+PFyO13qv2bPZmAtqv90eS+1kuPWNNJVpJu09xI9+8AX39eP4M3De9ld0gQWbzEn8HIfXAylc5fXBjN8vJFJp+rOS/K29dILm+XBVKG06t+rs+Wf0ws/yYWUolpaZ33Qx3CEtBElS5FVbEVIAX408a+g1e0iKuOWTYICoS/U9zk0YVdMLxNvSo92enhJSA3xgm53iaDj0CEM1rQcPQkIBy9pnOyBvf6L2yJCETy6Y5ocybMbhga42BFA5t3OUCi9lrhYC1tD8itqhknlizrK05zgTAKWSeI+3/IvwDZcVXtKkow5XFVcmMzoE+YSlKvIP0Qmb7aoJB2SsD2HBbya/7tIcuu+DfOAwmUZy0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5685.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(366016)(23010399003)(10067099003)(4143699003)(56012099006)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aC85LzQ0RE9aY3VNaWx2emNMSnlvcUlSQVlSdlFOTDVwd2J5aHB5Z1pQWVhY?=
 =?utf-8?B?S1NoWGZFYXpXN0FzVithVjM5UUJraFUzYlMxU3B6V0lZeGxwT0xFaWhXVjE1?=
 =?utf-8?B?UmJIdys1Vk1sME1FOFBidmt3ZHM1YjJ3RldoOFp6RElUc0ZvWi9peXB2QlRo?=
 =?utf-8?B?MTFJTmVPNkloVmRwenNNUmY1anpRYy9IVEJxQ0prN2lhSWJSTGg4Qm9SOUZh?=
 =?utf-8?B?QkNyZTdnbzIwWjJMMG1JZVZuRlpYMmwybU15VDFCb2FYcEZnZkpLS0NvNUZl?=
 =?utf-8?B?MG5QYS83UW1MUmlIbEJtRFpXOW9EVnZPbEd3bDBpbk4vVi94M0NKVzdNQzZ6?=
 =?utf-8?B?dHc5U3o3ajhtZ2Y0M2E0NHBwMXJpbVduNUZ3dmgxUEYyU05YQ2I2ZVpQQk0z?=
 =?utf-8?B?YUpKSjVXd05aQlpOb3c4SklzNHI0VXdzZjN3ajEwUVVKK1pUUVZRRXRGbEhm?=
 =?utf-8?B?NDVIUm0xZ3VkMHNEaDVUeEtwYzdndUZXK2NvbW9MWExhTStYSmJQNk05UnF0?=
 =?utf-8?B?SDFPOUdleTVGNUVkYS9oSWJNTmZSZGExOTVjZmhYNmxhQnFMRXZNSGFsaFgv?=
 =?utf-8?B?Tnh6RUtaQ2txYnJzRUlLTklTUS95OWFGeDRBVndpTTd6UnRDMVJRUi9TUG55?=
 =?utf-8?B?MUtOcHJiNHlmUE1BeklydHZ1b3VEeTl5bTBuMW1lRlNkT0FQMVlMbXpZOEJk?=
 =?utf-8?B?eGZ0Skx5N1RuRjlnSEcvUnFhSWt5R2kzenpmc3Y5OUdqSzZzbmV3Sm1WMldQ?=
 =?utf-8?B?c1EzTy9NMUJTYTlGWG56OStNNlZCNnNwbDlaUEU3TjVrV3NHVzd4S3R4ZmVG?=
 =?utf-8?B?Y3lxT3pRYlJkNFRuU1NDaVZNakgrdjByWVdvOFJrNDdYb1VLSC94SmNKcVpI?=
 =?utf-8?B?UlBjMWhPRTZBSGluL3lUNzBrdzVtcVpZWkJHcnlDQnc5WDhwZzZ2ckxZZzZD?=
 =?utf-8?B?OUgxZGNIbHdDc3BnTUNmYWlhYUxObzh1V2pQRG9XMUNaSkhTckpBL3NsaVp1?=
 =?utf-8?B?MzQ4eVlzeXBuL3FGakpHM0dKOTFRRDFWR0g1WHMyZlFzN3VHUVJjVnY0TUti?=
 =?utf-8?B?cUhNUHZMK2ZqME10dnJnb0I1cFN1R1k1WGsrQ2JhNHk3STBZTGY5RERFTFpB?=
 =?utf-8?B?YVowcm80THd5TGZqaFNkcW9rWk52akcwbFZVQTMrNzF5TXQyVzVBY1FGbllw?=
 =?utf-8?B?L1R1T2tuV3JlY0JmdlB4bXNXZk1UQ0JNaTF6UFBzd1NlMlFodFBKNnZ4RDc0?=
 =?utf-8?B?RHdoNXVtNURUWmt2UEdKMSt1N0Z4TzQzbmVaT3IxL3pESlRPbUZBV2JzSVdD?=
 =?utf-8?B?Q05MRk55b2NNTnRlMFZQSWMvV0FvZWUvenBteGJ5aUw4d2hrZXNYK3pFTEhr?=
 =?utf-8?B?cHVpa05DdDJ5czJPT1VoOWF6cEZMMFBmbk5Fb05ORnNuMnlydUE2Mld6MUwv?=
 =?utf-8?B?aHJLaXVOUjFUK3lJUjlIMGVsNTVpTm1CN3A1OFZBeWtDTkdqdXc5aDVhenBj?=
 =?utf-8?B?Z29hb0hIYU94UER1NWhYRCtQU1MrK2tDazlHUXp0eExtSHlmSFdjcTBWQzA4?=
 =?utf-8?B?cnBxZjBsTDNEVTZSUTdHeUFCYm8xbEY0Ykl2Q1BCckxFVkw1dHRoMVVodjIr?=
 =?utf-8?B?MFJwOGdvejJZMWUzZ2EwVGl4V0xldEJXejBTYUlhQUIvdFhSNlprejZYRWNw?=
 =?utf-8?B?MTJaSzlkNm1ZU2VqVFZMN2JsRDJValBUbDdPdm5IQ3RDMzNvSEwxVFVHN001?=
 =?utf-8?B?azNldWdSZlVLTWFKOWp6cVJ4WnBsNktBQTk0QThhdzc0TlB2QklwbDNUMjk3?=
 =?utf-8?B?ZWJRbStzL0FkQkhQTG4rQXV6Z0toMkZSaU9GOUR3dytPbUhWazlXK3dmaDFS?=
 =?utf-8?B?b0xTU3Ayc2twU0t5U3o1RXkyMklRbGw0SHBEMTl2V3ByS2RMRGY3OEo3T2tU?=
 =?utf-8?B?YUVpb3hCdlB5K3V5TEIyYk9NVVZpcDN4Y29CYVpGZFRRSnFwREhJY3Izd1Bp?=
 =?utf-8?B?aTVsbFJJend3QTBzdEJnNmVjVzhmeXBnbHNybGNLajBlQndWZDdrVGROMUEr?=
 =?utf-8?B?ZGJ0YXJrVlhMNlZwbzlYaDRYREZNUGJaWU9Ta052cE5TRFpobHNzdFYzZmpt?=
 =?utf-8?B?TWVuQitjc3lTYzZPUjlZSnV1YWdhZVF2SWZUalp1T0pNTU5RbC9sTVlxY1dx?=
 =?utf-8?B?UWZkdDZpdzhtY1VLTjFxbmUvZ3ZMcUZzdUVtQ1ZSVFpCRjZMdEFUaC9UYklY?=
 =?utf-8?B?S05ucTZ5di9XdTMzMVJtWUNncDVSdnc0VkM1bFpaUEdLV2xidEhlMTZibXpV?=
 =?utf-8?Q?Q2Jy0kIEIxhP8u2g4a?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e740638-f10b-4228-3ec3-08df17abb5ce
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5685.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2026 06:43:56.9804
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OnpxN2tjN2yIRcQXeovIbSrlowrK2DLICMj4rVmrUmjoLiwsO8MrKwbsDuAf90q/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8263

On 9/18/26 19:05, Jason Gunthorpe wrote:
> On Fri, Sep 18, 2026 at 03:42:28PM +0200, Thomas Hellström wrote:
>>
>> 1) Xe attachment check if pci_p2pdma_distance() returns OK for the
>> path. Then Xe always sets up dma-addresses using dma_map_resource(). 
> 
> Open coding pci_p2pdma_distance() in drivers is a hack. Using
> dma_map_resource() like this was never "allowed".
> 
> We've fixed things so these hacks are not needed, the drivers need to
> move over to things like dma_buf_phys_vec_to_sgt() and the hmm helpers
> to use the DMA API correctly.

That is a completely broken approach as well since it limits the exported resources to addresses the CPU can reach.

Christoph Hellwig is right that drivers should never use that stuff directly, not even through that dma_buf_phys_vec_to_sgt() function.

I need to take a closer look and maybe discuss with Christoph and Thomas how to proceed here.

>> 1a) Let's say the importer (Xe) has ATS enabled, and the exporter is
>> supposed to map dma_addresses.
>> In between there is a switch that allows direct traffic.
>> Now with your patch series, How would the exporter know that Xe has ATS
>> enabled and therefore should return IOVA mappings rather than the BUS
>> addresses representing the shortcut.
> 
> The thing that does the DMA map must be aware of what PCI TLPs the
> PCIe initiator will use to compute the proper P2P mapping mode.
> 
> ATS always needs an IOVA but that still doesn't mean the P2P will
> work.
> 
>> It seems to me that a pci-device settable flag "ATS always enabled"
>> should be enough to fix both issues?
> 
> It should be be per-mapping to support the NIC workflow that isn't a
> global operation.

I just realized what you guys are doing and I'm not sure if the Linux PCI subsystem should support such hacks at all.

Basically from the point of view of the TA the NIC has ATS enabled all the time, but has a per request option to use translated addresses directly without previously translating and caching them using ATS, correct?

If yes than that is extremely questionable behavior, I'm not sure if that is covered by the PCIe spec.

ATS is meant to be an optimization which moves the TLB from the root complex (TA) into the devices at the cost of TLB invalidation complexity. But what you do here is abusing that functionality as far as I can see.

Christian.


> 
> Jason

