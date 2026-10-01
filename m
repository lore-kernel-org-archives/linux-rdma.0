Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012071.outbound.protection.outlook.com [40.107.209.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 766F73E8C65;
	Thu,  1 Oct 2026 07:49:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.209.71
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790840989; cv=fail; b=hef1wXBSLaPTV4kmEgEgx3WT4UO2FO9uAcRsPTAAU6+LbPpUAI50tRA0vTnbeWaN6FwUfKVEBaYlHSfFLLIpL2qomePcF+Q7UOc+ZqzFIZNl+x/rBeJplJWUJdNFCcx14Qw2yZgoh1pIJzsZPe0wTE0tbynuVeoXKXjKr7ri8y0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790840989; c=relaxed/simple;
	bh=GMrxoNjzY6N7UM9W+fd8QjLwl/AZkLLahPC2MBKFO+M=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=CLqBDsw9LE2weDMk47kfBS42/jxOtgI9sDmhUHoJcmpS1/a3VjBLFTjWkAYM2tmxPxNvf//dboby9YIAMbvzVokeVAVWz35KjwxeJi3NDGvYLQRRBFBmB9SFklPmJHh6IYmSCQqvyF2nO5bKXCVhK5W4X6y32FhB/Q28xqeJlGA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=A8AIPHvi; arc=fail smtp.client-ip=40.107.209.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="A8AIPHvi"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XjATsynLetcFAq0yjaK2hMSjV2RjnCB/Gmo3kVaGq/c1ujeKGBlDhIQp7gW5rHsEqwKwIPZ3eLuo4oS19aAWYTOY/xm/k1oPn3bhvIn7NXZLwkiw/i4kdDFQpHB4d0vk0IiKHzwsj1zvH9qonQWhD0N/0v9YpAUcYpg2++XXukJ/syKLVOyLP2YNp1jlLpJQxvdOfFRRO9KbA2tzmsNVlWklJ3GEC6po/TLkDLDK87B1Gcj50328FVuabCy0Liwj3yjNTz+YhpcnkjWVZtsbwiOlWvSwuUq7FU71kxRLPZZmCULJuU1ep+AtS1vTZ3Tm1qeI1d/dmJ2sXE0L/spiKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=61c9RJRqV0v8SF5jCzJ92jNjqQ2bRKyWvaSrZ83sf2U=;
 b=TM3HgGReftuv2VAnewBdAs46YST1JsGNnzQPsJutoG6aKDoZAYc1/ylNPXTCPsGwvseUCoN8NBB6OAWeF8YaK90GGCST8ucRElSoOyQX93l7urR81dcq9ckI8cm1vxZuFz3fIbj8zYPInZJvfXg93heMwaNXHuXxTmCeeNahKOycTudKkarv6utpo72wz6mstXe0FdbfwySrG7p3t2ELCMgf9TrT4EUxDqt+79QJly7WIXc6O5edu6qQ+v1DJx3Cpqblvj8Qe36Dx2c0uq9a7MAmzXyYoJnohdhyO6h95bnG0/j6iOlbwdVT/iBMnSGfd9zCaFBbsxZ9Ip3dIScr8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=61c9RJRqV0v8SF5jCzJ92jNjqQ2bRKyWvaSrZ83sf2U=;
 b=A8AIPHviA7wPdocaeHmIUmsFc8Y1oTuig6niWJfkeb+CUF2QlxE4EbDr8vXFkRo0tyy5zhE95PAM/DYgN+rMQMJfM2JyAl6ehbBYab7T5X1CLU56hPcnSOpa+C8rpKwx3ZyL9oLXw6lHPrzjUrrKMljRCAtKFJ+kF/D21ECg8i4=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB5685.namprd12.prod.outlook.com (2603:10b6:510:13c::22)
 by MW4PR12MB5628.namprd12.prod.outlook.com (2603:10b6:303:185::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.16; Thu, 1 Oct
 2026 07:49:39 +0000
Received: from PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::ce69:cfae:774d:a65c]) by PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::ce69:cfae:774d:a65c%3]) with mapi id 15.21.0451.022; Thu, 1 Oct 2026
 07:49:39 +0000
Message-ID: <918ff7c0-76fe-4f22-b001-830eb5acf836@amd.com>
Date: Thu, 1 Oct 2026 09:49:31 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 16/23] dma-buf: Let importers ask how peer-to-peer
 traffic is routed
To: Leon Romanovsky <leon@kernel.org>,
 =?UTF-8?Q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Logan Gunthorpe
 <logang@deltatee.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 "Joerg Roedel (AMD)" <joro@8bytes.org>, Will Deacon <will@kernel.org>,
 Robin Murphy <robin.murphy@arm.com>, linux-pci@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 iommu@lists.linux.dev, Tushar Dave <tdave@nvidia.com>,
 linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
 linaro-mm-sig@lists.linaro.org, linux-rdma@vger.kernel.org,
 kvm@vger.kernel.org, Chaitanya Kulkarni <kch@nvidia.com>,
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
 <b2e766389e57a55da959369c5ad4b9e39e425659.camel@linux.intel.com>
 <20261001063747.GK3401365@unreal>
Content-Language: en-US
From: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
In-Reply-To: <20261001063747.GK3401365@unreal>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BL1P221CA0043.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:208:5b5::13) To PH7PR12MB5685.namprd12.prod.outlook.com
 (2603:10b6:510:13c::22)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5685:EE_|MW4PR12MB5628:EE_
X-MS-Office365-Filtering-Correlation-Id: 1df29464-fbd6-49fd-ca59-08df1f908ba0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|7416014|366016|376014|22082099003|18002099003|4143699003|6133799003|10067099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	RY0wZgM0C40V0R85f+LZ3h36+wL9nMGIq0wOl3rXHO4o1sxdtBY7R90gB9is9Kly4WFZsHj6J1cyUDrqtQTUyi/IEljMwSZBK68vSfa5qb7ZG4QwBoD74TMc9uaKvG/Y1RmWnes6mxz2xu8cwLQg/FbOugHPU05gPx1aRRu+H7cFwYku0sZ34VfDse17EXmjUMd68d2kYjljQeLLes4XdFFmetZHubq5efolb2LCb2Lj1b2hBY0Er8J1SCJS1oV0t6fp4+kOQMiKojHfMnEhAc8Qf15TyQF2K+DMPmduxyhofpag6Gx5tV9CZXKW+sm3PxodBsbXvqtAM6vpJqFMHE2/qiv7/FE+V68CkoQon2GPGHIezD1wQ0R275YAWg+F2VZiO3bzb5xAaSi6xGGLgwtGFK9g5xeYCPnUmoQBfoDWYFnA3vPG4JwOXdrI2EMWWzsEwQkDsvo2OiVK957B3GTQl/nrZGaNHZIHe9UO+Bao7jcLcT/ol5Hq/MWt0UIW27rqvN5QLzkifgwBOR5JyYf7iY7S2vrhCrKA8WBvbMtH+LRdBYgtVD62Iqz07bteOxkdxgnOPKOTAWxQ6lzkRqLylrLxUqunEOomswmPh56oTd0TfvHO2xgXs2C4okvtQtdyi5T07gYPJ+ujGqFxdPU6T/LZRbKyfZOqlzKt3ck=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5685.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(7416014)(366016)(376014)(22082099003)(18002099003)(4143699003)(6133799003)(10067099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RWhtWjBQNHdmQ1Z5eU5iQTN1SG5ud09LaG1QN2kzdG5rRVdodTZZQjhwaWdr?=
 =?utf-8?B?MXFodHVFL0hBajJRZ0ZTNThNZlNodkRXUHZlbWZYdkR3UVpZQ2NxVlRYcld2?=
 =?utf-8?B?a0N6V0FJVlZHWE9TNmZHYSt4SG16YmNJUzk3enpBTVJHY2Y1Q0FXNVh6K201?=
 =?utf-8?B?cURzRnM3Y2VLeXhJdnB5ZWxCZHNHVFlURUt4R2YrbXJEbE1nTXFBYTVSSThW?=
 =?utf-8?B?c2thb1FjS1Vsekk2MmRvT1llM1N3WTFDTmkzRk9qVjhOYUZIWWgxdnpoOFVa?=
 =?utf-8?B?VzhRM2ZnNkJvc1huY0FRR3V4MXA5VEFZdVA3QkFtbTQ2em95SHFLOGJvbWww?=
 =?utf-8?B?b0d5dlpYQXRUOHBwQTFuNDM0SjYvRUg1QStxeHBpVnpmZHdrTVBjUFJ0Zkl6?=
 =?utf-8?B?LytqeXI3S0ZuY0VWRkNKSExqbU9WY3JKanhrckg4SDQ3VUZxZE5wMnROODJ5?=
 =?utf-8?B?YjFLd0Zwenl3bmVmTnY3aFd0QjJMampZQ01VVWZISmxLYTlYd2w2UElwWlZG?=
 =?utf-8?B?aGJqZGIvUGlIMjdoT3VEcVBGekdTclBTMW1TQUF0LzNZWHNhYS84RUFtOW53?=
 =?utf-8?B?ejJnZ2hxZjZWSkRpcTA2UXBSKzY0anNUUXFKNTJIUk8xTVViWmZsRVBOQlBR?=
 =?utf-8?B?V2dYa2kyRTd2L3NRdXZvb0lpTTh2bWZOSEdFY3RTelM5MGFhZVpqQ1ZLN292?=
 =?utf-8?B?OTUxc1REZ2I3REc2UFV5VGpIL2QwdGxOME9kY0hjc0UvaVFmSHc3STg1WHhh?=
 =?utf-8?B?dFJKQmY1VmRsWkJ2WGFLdmZvbXBMVEc1YU83Ky9XWU9ldlZBeGU2UTZNWU5n?=
 =?utf-8?B?NndVeUpOLytDcmt5OUZwcXMwNnFYTTlOblg1RXg3ZUdSeDB1RHhXT3d3cDRu?=
 =?utf-8?B?UWd6MHVGNy9xYTRiY291MnBJK0FLaTZaL2FsRGcrNlB3WTREREZybXJYdnU0?=
 =?utf-8?B?eThLMHVVa1g1MStHSC9BM2J3eUIyN0MwUjJEUWdZTklJTW9MTFh5Y1NvZVEy?=
 =?utf-8?B?K0V4blErdUhQTUQ5ekpNRXNLSzNiLzd0YnpUb2Z4QkRDdnpwUWlJbTBqUTNW?=
 =?utf-8?B?cm5BbXlJWWoxMURvMDFBNyt3dGRpZWJXSXMxbkZVaGxObW05NzFyTUJrODJD?=
 =?utf-8?B?R2NsVEx5ZDJYK251RWZiMmo4MVhHMGI0NkRId1Z0NkV5M2RtWWRlclBJTnlW?=
 =?utf-8?B?SG9UeWdkUDBtWExBSVNVcTdEdW9LMXJDeTR3ZXlZbWwxWE85UklyVW1xTStB?=
 =?utf-8?B?bUI5Qi8rZ1Z1Q3lZQ0s3bGhGZFhMVkN5SVlMZ0ZXaXk5N00rWlZwbUI5MWJP?=
 =?utf-8?B?dWJNb2tuZ2w3bFFBd2srRGpKTEZ5eXhVR0hwZVBOdEpTSFdQdU5DYy82RVFF?=
 =?utf-8?B?RDRuVHFPajVkYWZyNlFDY1R3dmhtdmhmUUorSWdzVk5qbDk3V3Z1VjhwOW5E?=
 =?utf-8?B?eUJ5NXNIcnIvbmk0QnRYcVozbUQycVdQVFpaMlk4blJjb1BIOGsyWG5nZk9Q?=
 =?utf-8?B?b1FZYlVHTHllVktSamwyVGRRZGFPcVdQWkxId3lFZlNXR0xJdTAwUVIyYUhK?=
 =?utf-8?B?ZmdYSXpmOUFjVEVUY1N2ZWlTN2ZzTnhLcEdGS1d6cndwR2hSbHZta2E3cDQ2?=
 =?utf-8?B?SFRoc2NXUHhlekZmSkVtUU5JQUZldk9tUU4vbEZmcEk2S3RtUWtKYlNpaHAw?=
 =?utf-8?B?UlJaQXdkOU5CZnNvWWJOU2wxc1VBa21mTDdJV0UxV0VDUU1DY0V5M3dMeUpM?=
 =?utf-8?B?VHF5S1hrL1IyNVRZY2FwK2loQU50QVBYd283V0ZIMUZUUkRSeFloSXM1RzFI?=
 =?utf-8?B?T2ZZTVUxMldOYTM5aXVVY3FpZ0pPZGRhYklsVXNoTkJnejJZUVlvWUVjb0hD?=
 =?utf-8?B?Q054Z1dNVXBnNU1WU3g5NkQ3YjJiWkw1RWd5NnpNNFJqbW4zUVV5bU5XMjU5?=
 =?utf-8?B?VTFuRWZPUW4xbnhKUndJd0V3SWN0bGl2bEtUZGlmaVhwdFNxVlRidWkvYkRx?=
 =?utf-8?B?N0ppSFlVM2FiNzJTRS9obzVuYlNNbmZpOUZtNU01bEdQVlBRc3BpQi83Vk9t?=
 =?utf-8?B?VVZXYUs1R0xKcHhkZnR1MWllaGRscUxielFlZlYwQnFYZm1FNVlqWENtbldZ?=
 =?utf-8?B?YTJRU1NRNi9mV0orZmp1UEUvUFZONU11cG1OMlRZeUNGMzlEdWxienpmckl2?=
 =?utf-8?B?Qm9pS2hzMkorOTUzd3psN25pNUdyQ3NVUE1vei9BRWNFRWNRdzQ1T3pSbHN6?=
 =?utf-8?B?Ti94REVQMlNXdGVrMHNpUktwUjZQZ0U4UU85QldySUZKRjdmSlBGT2x1dXho?=
 =?utf-8?Q?ZDdcoU/jdXV2fUfAL4?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1df29464-fbd6-49fd-ca59-08df1f908ba0
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5685.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Oct 2026 07:49:38.9945
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DG0b3lJEBG0t0qkQmT1Q/yP04ShxIDQSkwyq/2FBNYzBXxmIGgLLp2YR9G3aojLB
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB5628

On 10/1/26 08:37, Leon Romanovsky wrote:
> On Wed, Sep 30, 2026 at 04:57:04PM +0200, Thomas Hellström wrote:
>> On Wed, 2026-09-30 at 17:32 +0300, Leon Romanovsky wrote:
...
>>
>> Returning again to Jason's series. Let's say we'd add just the mapping
>> type infrastructure, converted users of pcie_p2pdma only to use that
>> and then we'd have access to per-mapping-type data. This could actually
>> be done as a prereq for this series and merged separately. It's a
>> couple of patches only.
> 
> I afraid that you over optimistic about the amount of work.

Yeah, agree. The proposal looked good but there will probably be quite a bunch of work.

>>
>> Jason's match() and finish() callbacks could compute the interesting
>> routes at attach time,  perhaps even condesed to whether IOVA is used
>> and whether ATS translated packages have a direct route (which is what
>> mlx5 care about AFAICT). This information is kept outside core dma-buf
>> and would be specific to the pcie_p2p mapping type (interconnect) only
>> rather than having functions and callbacks bloating the core dma-buf
>> structures.
>>
>> Then exactly where the cross-subsystem match() and finish()
>> implementations should live I figure remain up for discussion and
>> guidance by Christoph?
> 
> Maybe I'm wrong, and everything will work out. However, given Christian's
> feedback to determine the mapping type when the mapping is established, this
> approach won't work for an RDMA exporter.
> 
> As I mentioned, mlx5 uses on-demand paging (ODP), creating mappings in
> response to page faults. To handle these faults with reasonable performance,
> mlx5 must create a memory region (MR), with or without ATS, and it is
> needed to be created before first page fault.

Yeah, I feared that you have something like that. At least for the current DMA-buf semantics that is not something which fits into that model.

Background is that system memory is usually seen as fallback which should always work and you can have really strange combination of use cases.

So what can happen is that you create a mapping and P2P is possible without ATS but then some other device attaches and we suddenly have to use ATS because the buffer is now in system memory.

When that is just a problem of quality of service, in other words it just takes long, then I would say it is irrelevant for production because that use case will most likely not happen in your environment.

It's just that if you don't support it somebody can trivially let your device run into a deny of service from userspace and that is something people try to avoid.

Only when you say that technically doesn't work at all then we need to find another solution. It is for example possible to call dma_buf_pin() to disable page faults, but that often also let exporters disable P2P so that is most likely problematic as well.

Regards,
Christian.
> I'm afraid we're going in circles, so I'll drop the dma-buf patches for now
> and focus on fixing only the PCI ATS flow.
> 
> Thanks
> 
>>
>> Thanks,
>> Thomas
>>
>>
>>

