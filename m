Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011021.outbound.protection.outlook.com [40.93.194.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9F6347A874;
	Tue, 11 Aug 2026 19:32:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786476738; cv=fail; b=GMSzHOeyybRGv8U+H0fnb44feETVfZvZcf7decHxlVUNaMjf8/cnTnF+BMzWVegwG4fDrbfVcKEEbzIfqCrjNcZJB17ZVvRd2Ol3iV+reOapzrzfO3ixorJSOuRfpbuZMH1m5mgz04Y3XYCXfdIbC1bfd2KUE70Wx5339pz2UkQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786476738; c=relaxed/simple;
	bh=MDIVaB8BQRfZa5hbqzYXGzBuybbzsHhsFIzZHO3YMQE=;
	h=Content-Type:Subject:From:To:Cc:In-Reply-To:References:Date:
	 Message-Id:MIME-Version; b=cgejTMPEG9QUOq57YqhnXiJG6j0UZxQHijne+eu2LK/CSnYhhb6fwe1D1r8tSYhPCyCuJ+B6NAMb5JrZ6XtleVbVRWCLh0m/J6NekRRCEN5/6/hd0AHLxvnzBRZpEig33vxfonPPXYraOZYOyH8TM77FjA+SOLBvYcJwQI3HRTg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=iBhf2Gk+; arc=fail smtp.client-ip=40.93.194.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="iBhf2Gk+"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nojYCNeljdTRixbCr1bwGY9AWgVE4FHd65WbBy9ogcVBcEeeQ8a+tFFuLDT34y095izvUaBnNn5WqNALpJdjVZsyHHAoOmGIV9AD6ouVMnZvA8SUf1oZ1GXcBswpeZ3gVmn4l7ZLF7Zxe0emXg903fOiNsqiYlYpulfsIMHEvdO3Kj2LjuuGGhym+7LBlLc2sYP7SzxmKuvCevSy/7A+irbaW8RKbfxLuGliLr0SSKvKrQ1CmWccMLaLbDsjSr/hIeq+BltAwYkjDRaS+j14ODAo9o418q69k88cyLZSlahEwtFucS5pZRERFwzTsUnTDJnwIL1LJ8unafQXITol/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oGDOgaQB4ptjcrc1Z809gT3or6XqQJDrj5Ax21NoD00=;
 b=n9wYg8ywYrODwgs+2hK9gtyG9XYNEaj9WbtjAq/nGQvNqQTZ3jS7Rx58PpP7O4J12QkUj33OwmVNN1RzDa3GejHyHntfvF2Ul/WC8O1Tu1TvSkSly8iX+BnrI2keu+65LF5jCMc0guXXusLIs3gsGxiV8deMQVlABLbitDwF+7Gp08tbO8n8dvyUQ9SrWdYOj5/rZR6bEMKIrsp0WTG9B9aj1/wSp/KgZQAU6xSpHIul96x/Swoj+9E+m9i6xEXuqs9xZEybrj3wxKVWyyFgDeLBBlF0g42Ymb54DXi2RaqsHpN7MR8URnzQJl4YatzvwZ7Du182fGZZ9oWufurCRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oGDOgaQB4ptjcrc1Z809gT3or6XqQJDrj5Ax21NoD00=;
 b=iBhf2Gk+9BvfH1lrKLtayibq/13VwlVKCwfcWJWtoxbyJQ+p/C4LbUC58KL6EgWOLjNhwkmMcABGXHp4T9Iw7pFXLfC8ZRUSLqoMEhk/Xma8Hek5zwfOQS0Eh3+mkIlJcV33OD9Wgwx3JdEQ0LQTI/2EyF+Kv0eA1OJNpfMJoLQ0G2dXjFZ8z5zyhNm1M/Wsq/Akp4Qjc5FELkLffx626EYioBVcgr3IwQaHwqocKRFKiOiSBdxrMmN2HCTDjtP4SH5QwSnU71SMGpxLV2x7/xO4B2A6LtKYqKEfA5A5e05kJyei8ZPiJGNN4UAjfFysAqsT16wTLdLyaqP+dbMTIA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by MW4PR12MB7238.namprd12.prod.outlook.com (2603:10b6:303:229::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.25; Tue, 11 Aug
 2026 19:31:50 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%4]) with mapi id 15.21.0315.011; Tue, 11 Aug 2026
 19:31:50 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH rdma-next 00/15] RDMA: Support HW requiring relaxed
 ordering and add Unordered access flag
From: Jason Gunthorpe <jgg@nvidia.com>
To: Michael Gur <michaelgur@nvidia.com>
Cc: jgg@ziepe.ca, leon@kernel.org, linux-rdma@vger.kernel.org, 
 netdev@vger.kernel.org, Edward Srouji <edwards@nvidia.com>, 
 Yishai Hadas <yishaih@nvidia.com>
In-Reply-To: <20260726092943.2880176-1-michaelgur@nvidia.com>
References: <20260726092943.2880176-1-michaelgur@nvidia.com>
Date: Tue, 11 Aug 2026 16:31:35 -0300
Message-Id: <178647669506.282103.2915831899844186795.b4-review@b4>
X-Mailer: b4 0.17-dev
X-ClientProxiedBy: CH0PR03CA0090.namprd03.prod.outlook.com
 (2603:10b6:610:cc::35) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|MW4PR12MB7238:EE_
X-MS-Office365-Filtering-Correlation-Id: f1ae0935-b543-4e8f-ee76-08def7df2f07
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|1800799024|376014|11063799006|56012099006|10067099003|6133799003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	rm3VeGOvy71o5yNdXr9UnWr/0X+MMiwVkbifpUJjBmcAJjYbwgsg8Zbw1CxRkME6JdBTOuxIFcuH8G2BxSifDBUCaBbXFF/FvH7ZrwlKlJ5wHjIXyJAq5ECagaIHp9FIEEhw4T7O0Avjl48juG2I7SjVivDDgPCrczymkTfjgurmz+IMuujaYzn16pwW8dhMO7EE/PWAMj/zORSxYu2NlQCx63EM1MRrIVMpBlLj+2tm1s9J1DuwtGNrlifOAfKnGccLvuKU+8bBPF31kudYTFFuAQe4bMYPaT3bd9gifrWPPzT0Cm+z5Ts8l3XlMaVOTaiRmxHODFbtUZsF5/TsllB6SCwU60RXRFwB0i7r6ja/5aVoC9+But5/c8imY5jffPqGsS7kp2tZf1RqGzWiordl4sI4pKLRQj2AFBlAipUS8HuE2Gk5b/Dyn65EXo1kUct+63RkNJ5p9FwoXtBNDWkiQ8bYEZ8Z6kmopwuBG7yxrFLjru/dFfFHdCbShqRSa+PT/69/JzFHTdyx5TUtvd4ql6PV9KqYMKKDZc4HDDQFEpgutQuWOXw7qFWIwqHRkyFz+RIRbnQAJ+K/uWm7vycEwwE9I4ApYJK+fyHbAB80Gy3FuUmIMOlxIjaP8IQHG7jmrwJ0QmBGjnsc3u6nKl2GH2C1rTRnQq1T0p0W9Sg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(376014)(11063799006)(56012099006)(10067099003)(6133799003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?c2dYRWNqZE1WbHpBM1gza0t4cHM2M05lWFQzZzZkWjJsbVphTnZSSk5vNG5O?=
 =?utf-8?B?aWtlOHhrU2ptem5DYi9GeWk5cVY4MkN2VHIxNHJnTmQwaUpvZm1CdUw5OGdJ?=
 =?utf-8?B?YmFKTnQ4cHA5SVFRRldqWE1vS2xleEZWUXVhbSt3ZllUMU5HaFBjamZPRVlv?=
 =?utf-8?B?L2VVUVJTaVFvb3VyS0tRcXZJMjNhN0pMQnR6ZUhUaEJnWk5CWkVCVVV0QUR6?=
 =?utf-8?B?bUpwOUlWNVBKSUZrWHNPaW56NmZpdHE3OG82ZFowcU4weVp5NHBiekhsQTBJ?=
 =?utf-8?B?SnJ1YktCVm82bXdYV2YvenNBYjNkRGtEUXRTQWpHUnNzYWoyL3c0ZTNyT3V3?=
 =?utf-8?B?TC9wUFRsSFUvVlQwa0xqVWxrQmdUZTdYQytyN3p6ZkRUeDV0N2FXV0hod0la?=
 =?utf-8?B?NlI2Y1Q2QTZ4S2dMbXduaC9GZGpGT3BoNTJON09EeDBaRlRnbFdSSkpJT2Iv?=
 =?utf-8?B?eEtFMFhGc1RCWWczL1hpQkJhdTRpSGpGM3ZHSFMwQ3hWemZoUlJ1OFVhTXpw?=
 =?utf-8?B?dElLT2xkRng3TXQ0a0MzSWlHTlhZNGdrbnlMVTFBUGNsYXlhdkVVbEMraGRG?=
 =?utf-8?B?RXYrQXNoelJieHZxS2E5UG1aSkU5SUdCMTVDS2hwcmE0QzdEUStwQ01RRUls?=
 =?utf-8?B?cUdScXZjMzZFNkFucDRXeERta0J1R3BSRWNRVGlRT0dJNndHaU1FTVlyQlVL?=
 =?utf-8?B?ZHcrNGkyODFReHd5Q0duMlYyWXA5Y3dWVXpnaXZqZTlwODJMMUIrSzBpNEky?=
 =?utf-8?B?K3MvUTVqTW04dWJsS2xMQ2JXaGplVTZ5NEsySGpIUTd4OTRMcDhjYzY1bHpE?=
 =?utf-8?B?VU5sbXBZYjNpT1pQUEgrOEtnMjlhUjVSaFpBT0VIS2lEQlh0akVHNzFQRVhr?=
 =?utf-8?B?eG1FampWdzNaTm9yYkNMYXRpVWVyVzkxcVF1akg3SVVrNmRQWWhhYm52M3Ba?=
 =?utf-8?B?MU5ud3ZCcnlUUlZDdk1vb24rakQyUU1sclZxdXk1Y1BEQWJrZEwxWWxZR3Vq?=
 =?utf-8?B?bENOay9qR2lWRjFabk91b1AwaXRpOW0xUlR4VGlQZ2c0Y3kvRzQxcHhEN010?=
 =?utf-8?B?UjhXUEdwR0ZGK0grSWJITTdlTmRvbjZIY3g4OHBmRmRIR3NRcHh0akU1aHdQ?=
 =?utf-8?B?QnJ1N1F3VlQ0a0JqZXdOQnkvcWhvOVVsaTNnRkx6dmNVMFpUMk16ZjZBb1RJ?=
 =?utf-8?B?ejhFVVlmUno5VmpVK09HbjYvbDhLNExUdFk2d0JaaU1hRTZkU2NES3JmRjUv?=
 =?utf-8?B?TmlDbC9WUGhGQUhET1g1aWRKK0JjbVF6K212d2lYQ2VtNzc4bnI4K2xvekR4?=
 =?utf-8?B?Q0lHa25pdWx6R1lINmRRTFRGMlJQRkd6UEhacUtQVzc1VWlJY1FFNnhjNU1a?=
 =?utf-8?B?cS9Jbm5OakdSUXVkYzhiSVVpSGV3NTBad2Q5NU1lWTV5Yzd2MnVwa21OYldW?=
 =?utf-8?B?eE1TZkMxY1RaQXVaelk4Y0JYa0pPMTM4Rm9FZGxHTURTY1Z2dkVZNUwraG80?=
 =?utf-8?B?dUlsckNlc1p5RDJtd0tHY3VWUW9BWEpOS1R1RGVMSThEL0FOOG1BTFlaci9s?=
 =?utf-8?B?OG1hcHJtMGptSlorbjdFN0lGOGQ4akhCWDNDT0I0cWxsY0NPbVJWRGQxUStl?=
 =?utf-8?B?YnVhRjF3Y1d3NTdhclRnNWREeVFObXFrL1pnZlpiT1lkcXN5MUJ0Wld2SElX?=
 =?utf-8?B?elRFL1Q2c3k4ZUJwMWcwTGdwWm1DemNQN2poVnRaVFAvWDEwamoya25VMEpZ?=
 =?utf-8?B?Y0dXSlA0Rm5KRFJNckZtZ0tUSWJQZElHWTNJREg3R2J1Zk5ZWDFISnA2ZjdF?=
 =?utf-8?B?UldaOEt1R2Mrd0N3WWJZNGhjME5lNGRuckU4WVFBNFRzU1dvN3pLRDllSVEx?=
 =?utf-8?B?K2ZPZXlrVHdVelh3cXMwN0wvUEpIUGg4SWxEdVFMMTJUQnNZSWsvSEc2Mk9S?=
 =?utf-8?B?TlAyd1RsK1MybmI2ampNelpOUDRBMFFvUXlSNlhmdlBsM2dCRlRURm8xNGU0?=
 =?utf-8?B?YTlTeDh1V3RxYTFXUm5JbHEvM1ZEUVBpVHlzRHNEVXJvSlVtMGdSeVB4Z1VJ?=
 =?utf-8?B?aHY1WlpVR0ZvQXVsRzY4OG9CZEwyTzlpcWxwaE45bWI2aUJ5dDBsbkhqR2lD?=
 =?utf-8?B?dTJrUUtnSTFGdCsrb3F3OHJ2UDlDTFlUKzZySTd1SGJuN3RyWWkxeitnYnYr?=
 =?utf-8?B?NTEzd0YweURyUVZ5THZISG5RU1N2K3plT0FPVldSU3hURE9YajA5L1BsNEhx?=
 =?utf-8?B?TW1OMno2cTFqVnZ1eFdBMzBtUVh1VDNKa0Y4RnVET0h2OGlURnQybnRPOVhX?=
 =?utf-8?B?ejdUV2s3L0lMWWQ5endsa3A0Ym80ekpUdjVOZ3d2dmg3Q2RwRFYvUT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f1ae0935-b543-4e8f-ee76-08def7df2f07
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2026 19:31:47.5126
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aDQ75Pa6AMVQ0XZzyvxKY4Kjrf7AjY38aEAn6uO7i8cvr+/FaVu1xenl5YTOHVwF
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7238

> This series prepares the mlx5 stack for hardware that restricts strong-
> ordered memory accesses, i.e. HW whose fabric doesn't guarantee memory
> operation ordering. The HW may choose to reject creation of an mkey that
> doesn't request relaxed ordering, so every mkey the driver creates -
> internal and user-facing - has to be handled accordingly.
> 
> The previously added 'ConnectX-10 NVLink-C2C' PCI device is such a device,
> as will be any future PCIe Gen7 UIO devices.
> 
> The series does four things:
> 
> 1. Allow optional access flags on all memory registration
>    The uverbs ABI defines the optional access flags range as best-effort:
>    drivers must accept any flag in this range and treat support as
>    opportunistic, never failing registration. Several registration paths
>    (DM, DEVX UMEM, dmabuf ioctl, reg_mr ioctl) did not allow this range
>    and would reject such requests. These are fixed to allow newly added
>    optional access flag added later in the series and any future optional
>    access flag.
> 
> 2. Groundwork and internal mkeys
>    Rename the relaxed-ordering IFC fields to the new naming, add the new
>    ordering capability and mkey-context bits, and consolidate RO-setting
>    to a single helper in mlx5_core so all consumers share one cap-gated
>    implementation. Then enable relaxed ordering on the internal mkeys that
>    don't require strong ordering (resource dump, vfio live-migration data,
>    ODP null mkey, memory window mkey), so they keep working on strict-RO
>    HW.
> 
> 3. New Unordered access flag and enforcement
>    Add IB_ACCESS_UNORDERED, an optional access flag that additionally
>    allows read-after-write reordering, and wire up mlx5 support for it.
> 
> 4. Enforce no-strong-ordering in user MR registration on HW that requires
>    it.

You should mention the rdma-core series here which provides a full definition
for what IB_ACCESS_UNORDERED actually means

-- 
Jason
