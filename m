Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010014.outbound.protection.outlook.com [52.101.201.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 973704DAFAF;
	Thu, 17 Sep 2026 14:00:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789653649; cv=fail; b=kMu93qIZBR9mtSq5uurVwL5Gkc7T6uY4UKsQptWwfoVeVSZYQcuw429y366FkHurBKGRvIuRkN0bZep8fScKqMhUOM2q+SyjM3DGvu1WL0ZufK0r8ULWM9ekW9t4tLD0qB6qApvOGfx2iZXYeK5xYm0MCbZ7gcYCuxPg01RW2Gw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789653649; c=relaxed/simple;
	bh=hXk1BWgOd6o9tJoOl9FegQFysJCl8tMeVyPzwUqxZPU=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=YPEk0PXFquUq4sLSpDaSGyxDniZhYbbgS7nBIBs5QrAprc13ePNmMrVqhxSsgM2rF5Rx6Z852FFKvQldj31JOhBN4uYH9NK6gRLt8E2Qajq0XaFmTCilCXO21k77J/lhOhdSkIkyeDAKpjd1AKdwczHscFjZn5jipfqy1Q+vg00=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=GOuX6chE; arc=fail smtp.client-ip=52.101.201.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="GOuX6chE"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bGoV24B6mtqC1357VQhAG/S6jSycChKXK33o4klT2YEHtlTYaDLtVDllPFnfUIpsm+qJIy4Pr2lpy8vwcWZJs6izhqgJeA0S8EKDDOTcue2eSp0fFaSlc/cXcIqvUYR4/wWaPIaG0SGkvMo3odT+BlyT1JJH+JK3FxUYfeo4dlCN0Mvb1NJLyqqxXZB13rfDRLzKh2o7wWB+hBIOfEAutZq2knyYo7mlLZ9qs8Lyb4zj5MTkEznEK/HxWZm+16f09KkkJRhEJ9m3iWdRuPw3TCDUMyHXLv+LU5bPb4h4mpYDICtMgmuD8Z1vi3wMUjs1QoLXP42SsIv25YfJAG7j+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s+Ewu4dQwO8rAuFHbMSzCBfiPVJHIX1dQpiTq9du+Ew=;
 b=JpRjWVQPiC09Ay1hgiySMpf5DPpbtR95oJgVMmb9qmETViDtX+Zv3lrj89zvbXknX7wQkFKtkSdG62QDxdqyxiSJxGqzXaWWbWCJqRMmoRJ6mH3pOhH74USKayyoesYc8xWI9jWCVV8QLsD5PjYGeGJLZs64u0P9R7T6qAzX3sm5sUJSq1wXipnZVfw03MBLcNCyzWj/7ihw89Lbo4oxnLHDvkxNrOSWKR2WVon6A1hCLS0X/BK3kgroXBGf3Q2HdZrBg+J3tIx2R65KWSquVYwNe2cNJEV4tk9B4hiO7hBhVEJDA5t7AaTTDfK899/sHiJCr2I9ZmHD1xjVJgV2MA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s+Ewu4dQwO8rAuFHbMSzCBfiPVJHIX1dQpiTq9du+Ew=;
 b=GOuX6chEs6UZbp77ERa18HWdXE/WmU8wUEC81wDcTZ6gt3TG1o4YMbWhpBDdWtT7USNHSECqDROy40emz92CUo80sii9g6yO4uyPq9TKQG1Tzi4rjxWo7eupvqtfJWp/RmoFtC4UwuQp8vfQEkHBrDos05o6eFD+AspK/gUrieQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB5685.namprd12.prod.outlook.com (2603:10b6:510:13c::22)
 by BL1PR12MB5897.namprd12.prod.outlook.com (2603:10b6:208:395::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.12; Thu, 17 Sep
 2026 14:00:43 +0000
Received: from PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::ce69:cfae:774d:a65c]) by PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::ce69:cfae:774d:a65c%3]) with mapi id 15.21.0428.011; Thu, 17 Sep 2026
 14:00:42 +0000
Message-ID: <f3708893-4760-4157-83a3-313867a94e78@amd.com>
Date: Thu, 17 Sep 2026 16:00:33 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 18/18] RDMA/mlx5: Ask P2PDMA whether ATS takes a direct
 peer-to-peer route
To: =?UTF-8?Q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
 Leon Romanovsky <leon@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
 Logan Gunthorpe <logang@deltatee.com>, Chaitanya Kulkarni <kch@nvidia.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jens Axboe
 <axboe@kernel.dk>, Alex Williamson <alex@shazbot.org>,
 Ankit Agrawal <ankita@nvidia.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 "Joerg Roedel (AMD)" <joro@8bytes.org>, Will Deacon <will@kernel.org>,
 Robin Murphy <robin.murphy@arm.com>, Randy Dunlap <rdunlap@infradead.org>,
 Sumit Semwal <sumit.semwal@linaro.org>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, iommu@lists.linux.dev,
 Tushar Dave <tdave@nvidia.com>, linux-media@vger.kernel.org,
 dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
 linux-rdma@vger.kernel.org, kvm@vger.kernel.org
References: <20260914-fix-p2p-acs-v4-0-v6-0-5ef07ec9ef06@nvidia.com>
 <20260914-fix-p2p-acs-v4-0-v6-18-5ef07ec9ef06@nvidia.com>
 <321890690ce83d1943b2f678bd9bee9b8c895b66.camel@linux.intel.com>
Content-Language: en-US
From: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
In-Reply-To: <321890690ce83d1943b2f678bd9bee9b8c895b66.camel@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR4P281CA0209.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:e5::8) To PH7PR12MB5685.namprd12.prod.outlook.com
 (2603:10b6:510:13c::22)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5685:EE_|BL1PR12MB5897:EE_
X-MS-Office365-Filtering-Correlation-Id: 490942c8-a3dc-4ede-b866-08df14c40f35
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|23010399003|366016|18002099003|921020|22082099003|10067099003|11063799006|5023799004|56012099006|4143699003|6133799003;
X-Microsoft-Antispam-Message-Info:
	5HWkF+lUKVGYI/uu3XrIkDkirgdhKd2JAX07D7euMQA8jLo9taJOpQZ/4MvoZiN/kPvm8AHbDWdEYZ7PP59DaMS4LOEmbvWIE0sEEeUvxFhAsZfnGr/WIOEoHzDasnSWj1Sbocwlt+4mgDsk80RWGQCrlk7jBD9nY4p8n0wNXJMYNlp/me2FrcYhO0WIp8wObte7Ng2KLQyCYiYbd16JXP5qd6vumKEgk+ljt2f2UG/SQgp1JN/sjmAVFkeIYl1e0ijklLubg9iC+T8wozXF7NywoU4/8+yZU0GsER6pgZg/82TdfxRPEuG/PpmgwNCk25aCTjxzqE4bscpVhkWgC9D3Filn/P3R6XWEhkUH/lt+G51Vk2flRiQVJFodKTK0TjUMHLCEEg7Bob7pXFq2gdBqaYlq6FySoEbJnuI9GYfOo7ifFS/hnj3vTKxXbYheoLE97+elEL1O+dLIckwBLp++iOF6DW5UTBWm1JjD/JarTdjWynwHVDjeNhkChMA2xQJD85SyNxwW55zvbwtNHDzXZ6s0CbDGZozE0b4z9TvNt32+68SbqUZ4yuh+5pLhc75b+WPVOxF6tb6T1WsJ1a3j4eaa1PthqjzxWPJ8tjiI8EUBCiLyYM7iZdndvxjMOgJuiUrBUIPT8C7wA3Cbd2pD6phDasEIe79sEgVBlyAE9ftOj6ocsVKI9QgUvgUEeL0c7KvACcSC44LANZsfEQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5685.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(23010399003)(366016)(18002099003)(921020)(22082099003)(10067099003)(11063799006)(5023799004)(56012099006)(4143699003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SHNEVmdGaGxZYWdkZXZnVXUvcEROZmVwQmZsRGFITGpVblNLOXNmRFBVQm5V?=
 =?utf-8?B?M1VtM1NqNjNwN0VwSU5sYzY5TERCZjFQNklRRlBubUVTWTAvRkVQa3pLaFRQ?=
 =?utf-8?B?QWJJN2Zzck05dUthM0FrdzIzdXJFYmV1M0E3WmUyMGRrck15UzZab3lBZzVx?=
 =?utf-8?B?djJyaHdaaExJOXU2VmJabklGK2VDZGlLQ0VqSGd0NVdmTVdhY1BNa05TREQz?=
 =?utf-8?B?UEE2c28zZmcxUFFOcmxYd0hiSTlsOWFISCtOTXBXOTI0Rjd3WURsNjVPc0Uv?=
 =?utf-8?B?cjRXOEtmS1piQ2g5Y0p6cTF4VTNCM3drR1hLQnJMQzcwUFR2UEhQa05jSkhF?=
 =?utf-8?B?eGxnNitrc2picDF5VEtnQi9DamZkazZzck9WYUNJWFNyVXhOMmtjbkxiUFNl?=
 =?utf-8?B?TmdjUFF5QUsxd0hlSUdpL1liVG1LTkovaFErRjg0TzlRd2dQM0xVNHFoaFBR?=
 =?utf-8?B?OTJZZUJNUEZDMmdNdlhOeDFPU3dSRGtLZ0l1cXdiYkRROVZ1WG5ZSy9pdHE1?=
 =?utf-8?B?a3lGNmJ3VXJVODdxSFFOYmg2T1pvdkQramlLY29BR1o5eFo3UERkQ0xBclFr?=
 =?utf-8?B?Q1plS2Y5cGRZRkVoSUMrd0tUeWN3eENld0p5dEJRZmNkdnB0bTF2ZVI1eWQy?=
 =?utf-8?B?Ty9tTCtXRnhMVzRDYW1lMXFkZzZ1eDQ3ek9VeXZSUWZMemtDYUZZUzlKbGhJ?=
 =?utf-8?B?MEVLd1V4dVpDd29EZ0o0YSthdS9oNXVDb094VVFtY2xvTlRkMlE1czhsRFpq?=
 =?utf-8?B?RHNaNzZtdzdXTENiSkpIelk3SnZwdTdGWjY2Mm5HSm9NRU9XVDJnUHBTRUgx?=
 =?utf-8?B?WVZGT1phM2FYQlQxdmlqME0vWjJBbGVtMisxVEpkMnM0R0JMR1IvZS8vV2Ny?=
 =?utf-8?B?ZHN1OTNWRHVlSTV1eFlyNlRQMjdGYVhwd056QlVmSk1sbytIYUJmaEh1dmFm?=
 =?utf-8?B?dUpxREJwTEVQb09DWS9yZlFlMFlUR0RmQ3o4T2ZmV3IwclBKU2NidXhTSGUy?=
 =?utf-8?B?WlBzMGpyTGlNTlVZakgxeVVhMEhMa2s5dkpvbkNUYU5BN3FESGlxQkxESjMv?=
 =?utf-8?B?MHFqbmQ3WDlHc1JMVmhvNER5VHFvLzEvcE11ZE9YZHpXb2lRcjM5Qkc3akFa?=
 =?utf-8?B?dTVabFIra0tSM25wSi9DQU1ZUFpyUHpIT0I1ZUlzMTZNTmY0MWUyblp0UzV2?=
 =?utf-8?B?WUNqUlpzeEk0QXBxcnhqakhHNjc1bVUvM2NWRmJGTEZoWEg3c1ZnUS9KbWJZ?=
 =?utf-8?B?WCt1K2VxZE5reFFVOFFBMTNWREdmcFd1WU12Zk1uRkd1ZTRHRkR6SS9Zbmgv?=
 =?utf-8?B?UHUvWGdxaWdpZ1JuTDZjZ2Z3T1k4ZEZlcDduMFRTN29vUmgxZys4cHN6TDV0?=
 =?utf-8?B?eGRMdWtGVFYvOWhQQzVzQk8ySXNic2xQMHViUkpsQ04xU3pJcG1rZmpnT2Mz?=
 =?utf-8?B?ZHpJQ1hvOHlwanJPUHhxUFJlWDhJWk5OUURpbGxtMUZsTjlWNVFwbmdyQnU4?=
 =?utf-8?B?S2oyaWVsR2hheVp6cSs4R3d4WU1OZHBuazE5UktZdmpYMFdiRnp4ZmxzR29n?=
 =?utf-8?B?M3k5QWErbWYvTDdaTGVscFpQTVM0NUZ2TjZwZEFYODEweStqaDVCdUh5cGFr?=
 =?utf-8?B?TDlza284ZEVvaUNhaTlyR09Xb0l3Zklaa2FjeHdZQzk2VmxHdkVFYXJqYUhH?=
 =?utf-8?B?TTBxbGdrOGE3R2ViUUNLWFhSWUlwQ1paYnlOa0x1bk0zQUJKOW5PelFNTytJ?=
 =?utf-8?B?TUJFWHc2VjRuSks4Tmp3WEUxaHoyTjcyMmRzVlNiTkpxbTBrVVIxUFdQczhV?=
 =?utf-8?B?RDB2SVRkZnZDKzlDTzVXUG5ySDg2KzA4REJqeXhZdllkVFY0dHdhNVR6a1lC?=
 =?utf-8?B?MUxqRXYweFJkYS9kaG82aGxOWVpZV0E0WWtGelVFU0ZMMHo2TklUQkl4RUs0?=
 =?utf-8?B?T2Q2cHpDby9IWDVIQXA4Zlc1QjEyNW1XYVMyejhXRlhzZ0Q0Q2ZjMnhMRjlU?=
 =?utf-8?B?S2VrQThlZkFpNHNUYTRzS0N0T0ZLS2srTDZqekg4MkRnUm9qSU5CVk1HOTdJ?=
 =?utf-8?B?S3BLT0ZtOWhGRGM2UFNaNFFCcnpjcEdja254anVnWVM1aXNnbCtTTVBIajlH?=
 =?utf-8?B?N0pCYldoTEtLZi9uTDFrQXhlWEZheDI5bkY1QUpKMFJlWHlkb25Yd2hoc25t?=
 =?utf-8?B?QkNRYkhsUVpOd0pNUHpHZEEvVHZzTFUyNURmQ3I5SkhCTTF6VnZCSmFFT2RW?=
 =?utf-8?B?bGpiRFgxQVJxR3NjNHphcVZxQWRCU0hBV0JnZGovYmxNaE0zOWZ1bC9zS1E2?=
 =?utf-8?Q?Q9oYJQ/mJVd8y9DSZI?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 490942c8-a3dc-4ede-b866-08df14c40f35
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5685.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2026 14:00:41.5075
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YEVYm34Z6IVTlqJhpgSz3rXTw6MRliTKtwhhTmPvHyKT+YfJ/hz7NMsfTSPXvN0/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5897

On 9/17/26 15:56, Thomas Hellström wrote:
> Hi
> 
> On Mon, 2026-09-14 at 14:22 +0300, Leon Romanovsky wrote:
>> From: Leon Romanovsky <leonro@nvidia.com>
>>
>> mlx5_umem_needs_ats() enables ATS for any dma-buf whose caller asked
>> for
>> Relaxed Ordering, on the assumption that a switch in the path has CR,
>> RR
>> and DT all set. It also enables it for a buffer already mapped with
>> the
>> peer's bus addresses, which are not translatable at all.
>>
>> P2PDMA has read the ACS controls, so ask it through
>> dma_buf_p2pdma_map_type(): enable ATS only where the path is not
>> routed
>> directly as it stands, but would be for a Translated Request whose
>> Completions carry Relaxed Ordering. Exporters that name no provider
>> keep
>> the old assumption, since their ACS settings remain hidden.
>>
>> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
>> ---
>>  drivers/infiniband/hw/mlx5/mlx5_ib.h | 36 ++------------------------
>> ------
>>  drivers/infiniband/hw/mlx5/mr.c      | 40
>> ++++++++++++++++++++++++++++++++++++
>>  2 files changed, 42 insertions(+), 34 deletions(-)
>>
>> diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h
>> b/drivers/infiniband/hw/mlx5/mlx5_ib.h
>> index e9ddf2e97a76..ab32742b2180 100644
>> --- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
>> +++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
>> @@ -1646,40 +1646,8 @@ static inline bool rt_supported(int ts_cap)
>>  	       ts_cap ==
>> MLX5_TIMESTAMP_FORMAT_CAP_FREE_RUNNING_AND_REAL_TIME;
>>  }
>>  
>> -/*
>> - * PCI Peer to Peer is a trainwreck. If no switch is present then
>> things
>> - * sometimes work, depending on the pci_distance_p2p logic for
>> excluding broken
>> - * root complexes. However if a switch is present in the path, then
>> things get
>> - * really ugly depending on how the switch is setup. This table
>> assumes that the
>> - * root complex is strict and is validating that all req/reps are
>> matches
>> - * perfectly - so any scenario where it sees only half the
>> transaction is a
>> - * failure.
>> - *
>> - * CR/RR/DT  ATS RO P2P
>> - * 00X       X   X  OK
>> - * 010       X   X  fails (request is routed to root but root never
>> sees comp)
>> - * 011       0   X  fails (request is routed to root but root never
>> sees comp)
>> - * 011       1   X  OK
>> - * 10X       X   1  OK
>> - * 101       X   0  fails (completion is routed to root but root
>> didn't see req)
>> - * 110       X   0  SLOW
>> - * 111       0   0  SLOW
>> - * 111       1   0  fails (completion is routed to root but root
>> didn't see req)
>> - * 111       1   1  OK
>> - *
>> - * Unfortunately we cannot reliably know if a switch is present or
>> what the
>> - * CR/RR/DT ACS settings are, as in a VM that is all hidden. Assume
>> that
>> - * CR/RR/DT is 111 if the ATS cap is enabled and follow the last
>> three rows.
>> - *
>> - * For now assume if the umem is a dma_buf then it is P2P.
>> - */
>> -static inline bool mlx5_umem_needs_ats(struct mlx5_ib_dev *dev,
>> -				       struct ib_umem *umem, int
>> access_flags)
>> -{
>> -	if (!MLX5_CAP_GEN(dev->mdev, ats) || !umem->is_dmabuf)
>> -		return false;
>> -	return access_flags & IB_ACCESS_RELAXED_ORDERING;
>> -}
>> +bool mlx5_umem_needs_ats(struct mlx5_ib_dev *dev, struct ib_umem
>> *umem,
>> +			 int access_flags);
>>  
>>  int set_roce_addr(struct mlx5_ib_dev *dev, u32 port_num,
>>  		  unsigned int index, const union ib_gid *gid,
>> diff --git a/drivers/infiniband/hw/mlx5/mr.c
>> b/drivers/infiniband/hw/mlx5/mr.c
>> index 00e13028762a..286f372e5b0c 100644
>> --- a/drivers/infiniband/hw/mlx5/mr.c
>> +++ b/drivers/infiniband/hw/mlx5/mr.c
>> @@ -38,6 +38,7 @@
>>  #include <linux/export.h>
>>  #include <linux/delay.h>
>>  #include <linux/dma-buf.h>
>> +#include <linux/dma-buf-mapping.h>
>>  #include <linux/dma-resv.h>
>>  #include <rdma/frmr_pools.h>
>>  #include <rdma/ib_umem_odp.h>
>> @@ -47,6 +48,45 @@
>>  #include "data_direct.h"
>>  #include "dmah.h"
>>  
>> +MODULE_IMPORT_NS("DMA_BUF");
>> +
>> +bool mlx5_umem_needs_ats(struct mlx5_ib_dev *dev, struct ib_umem
>> *umem,
>> +			 int access_flags)
>> +{
>> +	struct dma_buf_attachment *attach;
>> +
>> +	if (!MLX5_CAP_GEN(dev->mdev, ats) || !umem->is_dmabuf)
>> +		return false;
>> +
>> +	/*
>> +	 * The Completer decides whether its Completions carry
>> Relaxed
>> +	 * Ordering, and only a Request that asked for it can expect
>> them to.
>> +	 */
>> +	if (!(access_flags & IB_ACCESS_RELAXED_ORDERING))
>> +		return false;
>> +
>> +	attach = to_ib_umem_dmabuf(umem)->attach;
>> +	switch (dma_buf_p2pdma_map_type(attach, 0)) {
>> +	case PCI_P2PDMA_MAP_NONE:
>> +		/* Nothing is known about the route, so fall back to
>> the bet. */
>> +		return true;
>> +	case PCI_P2PDMA_MAP_BUS_ADDR:
>> +		/*
>> +		 * The path is routed directly already and is
>> programmed with
>> +		 * the peer's bus addresses. Those are not
>> translatable, so
>> +		 * ATS would be wrong as well as pointless.
>> +		 */
>> +		return false;
>> +	default:
>> +		break;
>> +	}
>> +
>> +	return dma_buf_p2pdma_map_type(attach,
>> +				       PCI_P2PDMA_TLP_TRANSLATED |
>> +					      
>> PCI_P2PDMA_TLP_RELAXED_CPL) ==
>> +	       PCI_P2PDMA_MAP_BUS_ADDR;
>> +}
>> +
> 
> It looks like this works well when the device can choose whether to
> enable ATS per transaction. 
> 
> However, at least for the Intel GPUs, ATS enablement is based on the
> PCIe-side enable bit.

Yeah, I can confirm as well that this is something really exotic.

I never heard of any other device who can enable/disable ATS on a transaction basis.

Additional to that the setup that ACS seems to be disabled for some bridges bit not all also sounds extremely uncommon.

> This means that if p2pdma tells the dma-mapping layer to give an Xe
> device a bus address rather than an IOVA, things break, while
> pci_p2pdma_distance says everything is OK.
> 
> It looks like the infrastructure and solution added in this series is
> targeted at fixing this on the device side by conditionally enabling
> ATS. However I think we need to look also at having the computed
> routing assume untranslated transactions using IOVA rather than bus
> address.
> 
> That is, a flag to tell the topology check that some transactions
> *will* take the host-bridge path due to IOVA being used, and that the
> computations including pci_p2pdma_distance() need to check whether that
> is possible (checking whitelist etc.) and return the corresponding
> THRU_HOST_BRIDGE mapping type. Translated transactions taking a short-
> cut using the bus-address would then be hidden from the driver.
> 
> Whether that is best done as a parameter to these functions or perhaps
> as a flag in the PCI device, I'm not sure.

That sounds totally reasonable to me as well.

Regards,
Christian.

> 
> Thanks,
> Thomas
> 
> 
> 
> 
>>  static int mkey_max_umr_order(struct mlx5_ib_dev *dev)
>>  {
>>  	if (MLX5_CAP_GEN(dev->mdev,
>> umr_extended_translation_offset))

