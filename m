Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012048.outbound.protection.outlook.com [40.107.200.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EA6A3EAC71;
	Thu,  1 Oct 2026 09:07:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.200.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790845667; cv=fail; b=YHDw61x3qZigDNzD6fcCzWt9wIB1aYXzbYTs5YW30Eh5o7AaQJLmpkvNO52ELAT9Wc7imyShGUkYMHCSnumB1ulX1PSRXxT6oBwtomBH156I1mBrkVS3gAJPFd77N5NTThZ05ykJpXXBBeL6V1rVVlk4IAVfK3QuDo1I6/SfLkk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790845667; c=relaxed/simple;
	bh=6o5XaDN/Pczob5BVA2DzSqIDmTDDmxd8pyYolfhMZfY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=UVtSCVVYl7ssolT00rzrvNCTLSUIVjN0RNKt3iTbNKmg2ZE7VmjQyy7Ji/Y5oN1RX/er6VSVlN8srv90HwjtVPVsJ5rZJK13jgItmAk8W2uMqYccgJscldTJLBHlvlZC4ZtcijOQEmTkH368XsDvDEdBhaCcymjiLiFMUSVZwkI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=MK2ekKqs; arc=fail smtp.client-ip=40.107.200.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="MK2ekKqs"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=veWRoYYm7OKkJInVBzxtL+M4FNVzSDBUtZiIhIwLXD3GRY3fvtXWugMEriT0qzb3Lsng18+4wMCSi0He6d3WcJK2aC7doL/XAQeDNhnhn0M0QECE3IhTVJqVvlAuseDJ4AM49DpsMLPEI7M4JgdRanNcUvoYZxfzC6RdepMQaity3zlFaXDYLTaX+m6uqgZz+TX8N1GH7T0F5Zxy1hMGDcTj+WqxnWoILlfT24PwYpDWbedJYEuKzpOm3x0d+k7cdrwBAPm0g3ClYLFtIKlkOGkKhbGYZXP7NLq4BT4pylH4cd6+kNb1IBQCsQqUVl9Vc8Q9r/pb50DBYjPEWN2eVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oVtOt/Fym9y6YlbT6MHcCSpx8EAc6amsnQFc4FnJER4=;
 b=XD8BkQzYQ7cGycvWcuJFppWnQ7xRB60k+Al2g62mtyxx35OI9BvLC7cgBmm0h4CQ4Dz2L979eVHrgfy86lBwIcOgeafZDzIhripyaPwPyYq96cm/hL0rjMiDx7iBCR6fYJLh0XTuLNlj9y2/rVt0zhzExGrtNcer7oD/7fyiZHg21VI+yppbTz5GwiiwGWlwyjLZLb0FHyvJYTpMFo7RQScdgirphLnh64wpxg/8lSN+reFS38YsAJ4jXGdG2hXh8cH2MvAW2t8r/TMaR1gE2pkDxF97rBu1z2sJwPowp1qeG03xpRAym5IigfWtCB3d2ZnSFOLfBpsS4IgCT8WO5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oVtOt/Fym9y6YlbT6MHcCSpx8EAc6amsnQFc4FnJER4=;
 b=MK2ekKqsSO0wVcO89M6KVTjfX86UBQl8pLi6DztHf5YRF8tILFzksU5mM1qnf8ZsQhXp1z7atm6MY9cZRODKga19Lvldm5+9ksabOsSxymsTGJxGCBacBzXJv/MxRF96IiVLqArdCdRUjtq1PId7aQH5KG5RrkHgpERMqy4T0s8=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB5685.namprd12.prod.outlook.com (2603:10b6:510:13c::22)
 by MN0PR12MB5882.namprd12.prod.outlook.com (2603:10b6:208:37a::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.22; Thu, 1 Oct
 2026 09:07:42 +0000
Received: from PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::ce69:cfae:774d:a65c]) by PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::ce69:cfae:774d:a65c%3]) with mapi id 15.21.0451.022; Thu, 1 Oct 2026
 09:07:42 +0000
Message-ID: <0c49c6d0-8301-4ded-accc-eaa5cf91b066@amd.com>
Date: Thu, 1 Oct 2026 11:07:34 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 16/23] dma-buf: Let importers ask how peer-to-peer
 traffic is routed
To: Leon Romanovsky <leon@kernel.org>
Cc: =?UTF-8?Q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
 Bjorn Helgaas <bhelgaas@google.com>, Logan Gunthorpe <logang@deltatee.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, "Joerg Roedel (AMD)" <joro@8bytes.org>,
 Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
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
References: <20260929175737.GK563127@unreal>
 <eeef5951-825e-459f-b474-bf8c59588446@amd.com>
 <20260930081832.GA3401365@unreal>
 <4549640c-f4a5-4dac-9be3-2e5aa127555c@amd.com>
 <20260930114356.GC3401365@unreal>
 <fbdc710d-7be1-4021-83c2-548c798d9d14@amd.com>
 <20260930143237.GI3401365@unreal>
 <b2e766389e57a55da959369c5ad4b9e39e425659.camel@linux.intel.com>
 <20261001063747.GK3401365@unreal>
 <918ff7c0-76fe-4f22-b001-830eb5acf836@amd.com>
 <20261001082710.GL3401365@unreal>
Content-Language: en-US
From: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
In-Reply-To: <20261001082710.GL3401365@unreal>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BL1P221CA0007.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:208:2c5::33) To PH7PR12MB5685.namprd12.prod.outlook.com
 (2603:10b6:510:13c::22)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5685:EE_|MN0PR12MB5882:EE_
X-MS-Office365-Filtering-Correlation-Id: 87fe88b9-a66b-4b25-e920-08df1f9b72d3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|7416014|23010399003|366016|4143699003|11063799006|10067099003|6133799003|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	iPUWEzl9tCEmlcxceUKSpRvrfoZMjN4jmve9kI7Y6W16lDrNcoI+nJ7COCOhQCX+OQrl/hGX6dzvUG5fC7mS4+3DVzZltR23OzFQ8I5dP3QReW/XbVaYlyhetVGnp0nFqfe4QguFAmLytv9aPSheGpSo2wdf42Gj1CST1csSmD/6HG9jaNyaygzxOlykcH7K7vmFwIjmilNYkhzzOh9uqgShoSiXjNL0EMIo5Lw+lHLRivr4dcLf6MCdl4pkTl0amQbFDzCXSSnBTX0b6BiG+WrVS8YR9VlnSd6yv6V904ARDNBCak49RQKJKMdeOy6vAlGe5ucF2ObN1+zdNH5WE23QTCxNNsHnBkbuJGxRh9OXZfDyMN7EgWw9f5sXuJ3XXU5B3Ksrx77bjf8Iwx91BeqOdkfsQdEYjDrhM6P23zg3fdYOeHHuYbVmzn7QeeNaenxr1B+Q0K48+Psi/GwdWPOuHr01Dlls0OR1QjWeKEUq2PGsSl4fyNY5+sBXjMnNPesJ26v2k+vdXplmScOw4j3MNN/HNAY2KCRa1ajpdenPwq83ALdPZLdyVhd+lADiH3wViUst1OZxRTAjCEj0bmjrcndWAmoInZXXkzt7CjnR+S81fE7xC0BRJ3S1zp1NgqhjxudcKikVwf3Itz5lKYqCViFY1kRra7raMc27g3M=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5685.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(23010399003)(366016)(4143699003)(11063799006)(10067099003)(6133799003)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YmZyeXY1WkpiVnBCYzdYQ2hOUzVNVnZCMUNGTkJ3dG1Wdk5PNENqS1ZIeG5X?=
 =?utf-8?B?MDR3OHpLSnN2R0h3cGdGb0lLeU5TNE5Wdkx5SFBNdTdiaVFEQnJ3bCsxUlJ3?=
 =?utf-8?B?NDBtakhoSDMyQm1vaWt4am1RbzVHNFh6TmJjV240TCtzay84RXAybG8wdVE4?=
 =?utf-8?B?WlM3WmZibXJNOGoxZ0VsUTkrUkxoU0UwVzdPaGE1YXpVNnRaSnEzQWYxYnZJ?=
 =?utf-8?B?cHpMMkJyaktZK2d4S1hONEU0L3pEWjFUWGk3c1ZXek1zLzZMZVBZcXpuVVls?=
 =?utf-8?B?aEljbkd4aG1ZWjJ3K3lsSFkxdFk3dTY2OHdSazAwU0pPR0dWZ2c4bjVGRWls?=
 =?utf-8?B?ZHpRRW5wcjNIVllyN1FMWGtOU2NOc1RYcmVyVVJDZFRqdkVpaTBSbHZ4QjQz?=
 =?utf-8?B?SlVHYk51TTZPREREaGh6V1I4VklKL1lzdkw2bDhob244OE9sVW02Y0srNnB1?=
 =?utf-8?B?V095N3FKN0crZmpEZmRZMmlEdTlZdHY5M3Z3NDZ3Ky9XNVBPSnZWWklKMUJv?=
 =?utf-8?B?czBWbXJoekdBWHJ0Wjgrb1hQdVp2NStXalZEK1QzMnVuU3BKM3lWLzQ0L0h3?=
 =?utf-8?B?d25nQlVNY0FpZlRMcnJEd0F4T1NzbGFKRHNGZVlUQzFEUXJnSzQ2NEQ4N1pV?=
 =?utf-8?B?OCtkaVJYV282OEYrbkpDbXFaWWdKSjlxMDZxR21nenpjVmN1Y2pqODRSWHJ6?=
 =?utf-8?B?UGphcnBhNjgrUDBIblVDVkNyK3U1RmhaOGg1TVBrMldJRy9zU2NYSCtrMkp4?=
 =?utf-8?B?RFJkZU15eHpKVk90NkhzU3dNWXVqNHlFZXdXR1pjQUxXN0NsdUZTOWh5TjVa?=
 =?utf-8?B?VXhSbmI2cVZCaEkzcE0wcHJ1cXZUR3RTSmlrcHZTV0E3b2h6WVBMdUVJSnlB?=
 =?utf-8?B?VTBRcTF4eVUrNDg2QzB4Wnh5eERydDlmUlFjcmxKRFJUODdSRllvUGhhQjBK?=
 =?utf-8?B?OFFwTVkrQVFWelFCeFJDS2xJU0J6cGN6dXhyTWYzd0dZWTlJdXp4Ry9zQm1q?=
 =?utf-8?B?MGFDeFR5Q1hHUkpYL1FPVmJaRkcvVEZLbENZb0R2ejk4ZWRicEhiMWM1VnBs?=
 =?utf-8?B?NEJkbWxhWUp3TXlOeVA5UnV2QnRhQWt0WkdYc3BWMnpiTHZCVUd1VTJzMDM0?=
 =?utf-8?B?cWVUSEliUkdmTHUyWWNCL1hqRTMzNU8zMFRyM0RGa0JLSUJtRklWWE94TDdD?=
 =?utf-8?B?STBPZXdqZ2FLRndUQjR6YU5kUWxkWmlsclFaOVNnSjF0OGxwcVlJT1NKS09F?=
 =?utf-8?B?M2VLYlVnMTdUaGI2VEhidHBuMkdaWVMwdW9jL3ZONE1IY091YytvN0R5ZHJ4?=
 =?utf-8?B?cHMxYkJuMEdlc1prQmhKNjlxMldWNkpFbGduTTAvRUwxVXlRdndueERiR1pU?=
 =?utf-8?B?Szc3SjNQZFpKTVNWeE5zbFBpcVhsQkIwTG5iTWRJQkJtSE9mUFpLZndseUtE?=
 =?utf-8?B?VW80ZmhvaVNtS1A1OFM2dCtObGVLSlM1Z2FOSS9FazVKNHhvaytPYzVsdStO?=
 =?utf-8?B?K2dSZTRCOHZYT0ZVakl4Zm1FTUFoZEd5cWlTakxEbmFNbDJMSjBkV2xZSjFU?=
 =?utf-8?B?OWkxNHB5OTJ1c0VPSlNoeG56Y2htUWRkUUZ1NVF3Z1dKS3V3bm9PMWh5SnY0?=
 =?utf-8?B?NzFRUFcxOE9sRjBuek9BcDE2L2tpNUFQamlyWG43dUJReWV6UUpVZDZ2V2NU?=
 =?utf-8?B?Z3dtYjRiWWNBUU1IV0o2a1VrK09aTWJVOW5LemZadSthMUh5aXp3UWFqK3Bx?=
 =?utf-8?B?RUw3V0dIZ2czNWFyZVJOSGJKNlltUTNQVkQ2b05kdTJGZllMWWovQmREN3NX?=
 =?utf-8?B?aTNIY21Kb3YwdFQ5NXpzNTk3RFBOcXh4OEUxRURQZzVETEQwRWUzY0JsMVdU?=
 =?utf-8?B?ODFxZHdZaTBjdk93VHMraUI4a1hhYmorMEFsZWhkbSt4L3lyU0svK2ZXVnJt?=
 =?utf-8?B?ekY3VTMxSktHZTlCU3o2U2tMV1VmTGtXNU5GcmtvMU1ZS0ZnWXRvT21LcHEr?=
 =?utf-8?B?WlpsM3RLZGRiaFlSU2pPamRsK1JPeVdZSVlRM1lDWlc3aFZsaThnRWVyMk1M?=
 =?utf-8?B?RlluM0V2U09ycjlpcWUwenFjcXRFKzVneVVDOHVHK0lrUGZ0Mk1Zb1IvOE1E?=
 =?utf-8?B?dllRM2FYMzkvZzlDalRFWTYzdmRxVlZPbVhic0s0NzF6dWJhbE1jZHBOaXFy?=
 =?utf-8?B?anFSVURYY2RHc2xGS3lhbnNmTVBwTXlkSWZyRHRzWlpMZFZTakNpZ0VSdEFW?=
 =?utf-8?B?WHVhVkhub1NrcFFzWGFZL2pWRHBZRWNlSXV1M1RidmNkTkJTSVN0WU9KbHg0?=
 =?utf-8?Q?m+feeyag9HW/Yxe8rE?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 87fe88b9-a66b-4b25-e920-08df1f9b72d3
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5685.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Oct 2026 09:07:41.9639
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wrLiBbRiGXx/WXOosVbi/I+1xP/sHesAK//+jMdUlWh78GqoYWH6jAz6wcKN6nBK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5882

On 10/1/26 10:27, Leon Romanovsky wrote:
> On Thu, Oct 01, 2026 at 09:49:31AM +0200, Christian König wrote:
>> On 10/1/26 08:37, Leon Romanovsky wrote:
>>> On Wed, Sep 30, 2026 at 04:57:04PM +0200, Thomas Hellström wrote:
>>>> On Wed, 2026-09-30 at 17:32 +0300, Leon Romanovsky wrote:
>> ...
>>>>
>>>> Returning again to Jason's series. Let's say we'd add just the mapping
>>>> type infrastructure, converted users of pcie_p2pdma only to use that
>>>> and then we'd have access to per-mapping-type data. This could actually
>>>> be done as a prereq for this series and merged separately. It's a
>>>> couple of patches only.
>>>
>>> I afraid that you over optimistic about the amount of work.
>>
>> Yeah, agree. The proposal looked good but there will probably be quite a bunch of work.
>>
>>>>
>>>> Jason's match() and finish() callbacks could compute the interesting
>>>> routes at attach time,  perhaps even condesed to whether IOVA is used
>>>> and whether ATS translated packages have a direct route (which is what
>>>> mlx5 care about AFAICT). This information is kept outside core dma-buf
>>>> and would be specific to the pcie_p2p mapping type (interconnect) only
>>>> rather than having functions and callbacks bloating the core dma-buf
>>>> structures.
>>>>
>>>> Then exactly where the cross-subsystem match() and finish()
>>>> implementations should live I figure remain up for discussion and
>>>> guidance by Christoph?
>>>
>>> Maybe I'm wrong, and everything will work out. However, given Christian's
>>> feedback to determine the mapping type when the mapping is established, this
>>> approach won't work for an RDMA exporter.
>>>
>>> As I mentioned, mlx5 uses on-demand paging (ODP), creating mappings in
>>> response to page faults. To handle these faults with reasonable performance,
>>> mlx5 must create a memory region (MR), with or without ATS, and it is
>>> needed to be created before first page fault.
>>
>> Yeah, I feared that you have something like that. At least for the current DMA-buf semantics that is not something which fits into that model.
>>
>> Background is that system memory is usually seen as fallback which should always work and you can have really strange combination of use cases.
>>
>> So what can happen is that you create a mapping and P2P is possible without ATS but then some other device attaches and we suddenly have to use ATS because the buffer is now in system memory.
> 
> The importer reports ATS support on a per-mapping basis. If the exporter
> receives this hint from deviceA but not deviceB, it prepares different
> addresses for the two mappings.
> 
> The `ats_per_mapping` flag is stored in the importer structure:
> https://lore.kernel.org/linux-rdma/20260928-fix-p2p-acs-v4-0-v8-20-404453b9c435@nvidia.com/
> 
> In our example, if the mlx5 and XE importers both attach to the same
> exporter, they receive different mappings.

That isn't sufficient.

It is perfectly possible that P2P is disabled later on because of another device attaching or simply resource constrains.

So that your initial mapping has ATS enabled and then you get a mapping with ATS disabled is perfectly possible and even trivially trigger able through uAPI with some exporters.

Supporting that is a must have, even if it's slow. The only alternative I can see is to pin things but as I said that also has some other down sides.

Regards,
Christian.


> 
> Thanks

