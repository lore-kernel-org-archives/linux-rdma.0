Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.208.42
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793107051;
	b=jFbOkZ3N/c+CPNV5zHVCRDpp1snRkdvBcKj1VJNa2hIUEsaJeXO8exGzqnibXe1T1b/J
	 PhVh1sJdWDk95zM+pErxUnzAvlfvHbCdKQnMcPND4c6FxurEvXM5uSMIffbgoJTA/rWD3
	 oKXOYSaZnigUcmnywpHdAsMbCNz1sLtQ+eOMZJYGI51kA9WrqGrGIfyoS49K82/ddOhMu
	 nuWw/cfX+yNWrn/uiGWReeeBUDW7A5r4QZPcSGvpiSXpViWW97ELUgLbMA4PQjfEdmLsW
	 MhuWd5S1ji3LMM+1g1zsLJFedWBwoAbAORhvogVubovpmvVnucfJ0eGcY0FIoRmBfyw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793107051;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Message-ID:Date:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-ClientProxiedBy:MIME-Version:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=qVc7aJ/FLgHe8RzKaxEZe7c3vRMP4oiOukOZ2uiwvhc=;
	b=wjyC8muy70pgPqv1nISiniZHlncBcYh6Y9nd3kr1IZnsC6G7ryZ6nPxfXFcq4Vx6O7bJ
	 X/tqwafBgKFzSwTVnTReVz13Wn/prn48holOELzHJoJYYTH+7jbBUUZm4bKHM5LSbVJJ6
	 7emIrukA0gmhynrSMkp4iqm6vyiGQK2PVXClm8tdiIICu4pSbpKiZJFmpH4+JL9TYthD9
	 EAULXK9McUmwgXeSIlAbXHmERMrLj7k7y9PE0tdmYQ4MdCfma3r7c4ooB6+xAD0KzDDkq
	 G7EghiPpQJcfHvpO84dzHtjPfvFPE/Iv2NomcjginuK3XL6Eq8XsYZHP6MlYMu+8wpw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amd.com;
	spf=fail smtp.mailfrom=amd.com;
	dkim=pass header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=t0mkpAPd;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.208.42
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011042.outbound.protection.outlook.com [40.107.208.42])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85EE8606A31D;
	Tue, 27 Oct 2026 13:17:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 85EE8606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=t0mkpAPd
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=C3z9meoGaMzFC8BklbAXKC+hCR6relLgHcAEooE2LLRfCKhmKC+IVQ5PIl5qCP2ctKI2z8QYTGFJCu3ICXYBWIPnaIRb7tWjVFAzEEJTaZezCVjgl+6EoWRZ/ogVWsA6MhX749HW52RGRP93J5GbH0iw1QL8byG94PZaUn/VVh2HKA8B46R9CVJ52Y+JgJgbUt3bQVT8qiObWwAP/h64Z6n1p9K3D50TyRKq8IJpDIM5oxhaAAlEN1Fbm9kS8sxxcw8/6Nf/NDL4NpWkPp0HO5YaVJ9mJYJXhZHLqDKN1JcjQxws4RnBqIg0UJ6K++py/0C4vcAIIjp7a4+nwmPStw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qVc7aJ/FLgHe8RzKaxEZe7c3vRMP4oiOukOZ2uiwvhc=;
 b=cr5cMe+TyTxnjqwgA3ynB0JwmnmVCbcrqZ79ybpJC7OzI/YP6LctRK5EyBQtF20Jy5ilWA3OfySo7gS/EY9eKkCH0aV3kaBkvnYmGDNkwk8tC4Yub14hBUsDR/wJmf41JieYk7lUSFR+JVsBX1ZfGO64ekDZ7pBLAd4E5RiMga1a0GWhuHv9Pj6akWLCXwVD70AwYsurILM8A1JeDXYY991bvQb55pZEeSDy16qWwBWxl6xj+jelt3g+/cAc26zFQxNMBwfAkvvb26AwT+DxNjajx+bdBsJQbx/yYYWi5s+iMrLHKIu5FiEqKfnDpFXgaItAMofIJXhAlyfmijSYkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qVc7aJ/FLgHe8RzKaxEZe7c3vRMP4oiOukOZ2uiwvhc=;
 b=t0mkpAPdnm2iZie4bKooOEJywyX2k6PWTi3NO5Hjp6LtMZ85i7JaWSlh5qI8x+bhVJBoM0fXbJv+X5F2wwJry1k563CDGTj79NrdxJqdauzVzGy4OOGN30VHxNRPJvMkOBu8YsRaCs82YgZ1cp5zxslCnDiChRXG4mYDhJDgQro=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB5685.namprd12.prod.outlook.com (2603:10b6:510:13c::22)
 by SA3PR12MB8000.namprd12.prod.outlook.com (2603:10b6:806:31f::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Tue, 27 Oct
 2026 13:17:26 +0000
Received: from PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::ce69:cfae:774d:a65c]) by PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::ce69:cfae:774d:a65c%3]) with mapi id 15.21.0546.021; Tue, 27 Oct 2026
 13:17:25 +0000
Message-ID: <3a09ef96-45a6-486f-b482-fd34c27415af@amd.com>
Date: Tue, 27 Oct 2026 14:17:16 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 23/26] treewide: Rename dma_buf_attach() to
 dma_buf_sgt_attach()
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Alistair Popple <apopple@nvidia.com>, dri-devel@lists.freedesktop.org,
 sumit.semwal@linaro.org, =?UTF-8?Q?Thomas_Hellstr=C3=B6m?=
 <thomas.hellstrom@linux.intel.com>, Simona Vetter <simona.vetter@ffwll.ch>,
 Matthew Brost <matthew.brost@intel.com>,
 Vivek Kasireddy <vivek.kasireddy@intel.com>,
 Dongwon Kim <dongwon.kim@intel.com>, Leon Romanovsky <leonro@nvidia.com>,
 Kevin Tian <kevin.tian@intel.com>, Xu Yilun <yilun.xu@linux.intel.com>,
 Karl Mehltretter <kmehltretter@gmail.com>,
 Baolu Lu <baolu.lu@linux.intel.com>, Felix Kuehling
 <felix.kuehling@amd.com>, Alex Deucher <alexander.deucher@amd.com>,
 intel-xe@lists.freedesktop.org, amd-gfx@lists.freedesktop.org,
 linux-media@vger.kernel.org, linaro-mm-sig@lists.linaro.org,
 linux-rdma@vger.kernel.org, iommu@lists.linux.dev,
 Alexey Kardashevskiy <aik@amd.com>, zhipingz@meta.com, treding@nvidia.com,
 jhubbard@nvidia.com
References: <20261026053623.202642-1-apopple@nvidia.com>
 <20261026053623.202642-24-apopple@nvidia.com>
 <27307d58-9ca9-4624-a564-6e35fb4befb5@amd.com>
 <20261027123859.GE1671235@nvidia.com>
Content-Language: en-US
From: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
In-Reply-To: <20261027123859.GE1671235@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BLAPR03CA0061.namprd03.prod.outlook.com
 (2603:10b6:208:329::6) To PH7PR12MB5685.namprd12.prod.outlook.com
 (2603:10b6:510:13c::22)
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5685:EE_|SA3PR12MB8000:EE_
X-MS-Office365-Filtering-Correlation-Id: 173ae5ad-f690-43ae-6d03-08df342ca42c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|23010399003|366016|6133799003|22082099003|18002099003|261026140227099003|56012099006|11063799006|4143699003|261021121427099003|10067099003|261022105027099003|261026121527099003;
X-Microsoft-Antispam-Message-Info:
	bfWwPUC+F8vxijDrWkh3g2l2iXHWwcZ5LvE4ceB03Ew3v26OT2EkPReRIwFxEVG8u0EACcos7Q9fNgjRYCTMiX313m6JUFfwH9uKTpDgU9AkwlfOZKFEyK1qE5PgGXP4SVMxR+8d+ISc5jNoTZJb6P8quUD+BcJHbuvjzb8xa3VmbQ1xCYUAjxDLLGyA627n3zznVBYRFIrVTCoTnB96nn6xCYZemBFZlogbtDA2djYK2YGFlQUY/rT8gPAma8KT2Dd5ts7m1Fd+j4fDP2A0GSD9F+UCuHpqZTuEleS6fpf7/fML9WE4NRgOb3Nomq0bOPLcRW3hwfOG282wmlQKlyk11ZQqeKdDGn9SK87/fW38jwCaaujffDL8yL9vNOhGNuAvjLWC4JKkxhkrpyTTDsAz4GhJHJ+zerlQryt/g7jOt+48nW8Iyi919TxyaX3V0BpYV3YNg0vevllBStS02zp5GL8j5rtyZ3UMxflf01tBWqt+6rH4nU387nWWe0TBE0xLTVY5SV5JT57OKOeq3RTRXpkCtMU2aFueOqxqSN8BrAgBEcAjwVo2AE2/GK0fVGlwHXVWzhk1j1Hji1H+yy3zNkebM4UxTL7v2zszWKtFjU4r2Ps5hlrkB8PFbJPeCdDDShK93SZ/vEMs20B7tgmXKkwqgb0oL/M4zN41g9k=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5685.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(23010399003)(366016)(6133799003)(22082099003)(18002099003)(261026140227099003)(56012099006)(11063799006)(4143699003)(261021121427099003)(10067099003)(261022105027099003)(261026121527099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VnBISzRkdzRSOVdNV0w4VWNISS9WV1FHZmkyUE91Tm1ndUZxTnZUdlVxQ1du?=
 =?utf-8?B?YklIU0Yva053WENoUE9HbHRHNFFib21yQ1JWREZXUmFnWmZ1Tjh6bHVJdVp5?=
 =?utf-8?B?NGFrbVJXWFhCSHdDK2xJK3JqMVNhR0l0VmZuU2Y4dk81ZVZ1ZmtJOE1wdlVZ?=
 =?utf-8?B?dDgvMjlIWXF0M3F1clFGSG5EZmg0TVdUazFNdEJoMWJZMlNjOXAxU1NadVFF?=
 =?utf-8?B?UlJMUHB1S1E5R2s1WWhWcHhmUks4VEJaVWpMcEUzQjRWeTgwcG9ZQkU3dnVo?=
 =?utf-8?B?VVB5YWcrMlRoNkdHZ0p4N0UvWkN5RVp5TXUvM0hHY2FmRU1ZdDlrYTlYZ1BS?=
 =?utf-8?B?L3RSQklBYUhmcmJZYkk5czI4Z3hJeWZCclBqTVdkT3hOUkw0SURTeWp1ZEdL?=
 =?utf-8?B?SWxHZE5tNnpvWWVaWmJDY21QTFJXdEFvV1dxWFl0Q2JVdy9mWVNBUXhzYm9Z?=
 =?utf-8?B?NEtFMm5EbWJHQ2l5QnZ3WnpmU3FNTmk4L1Z5eE5QTFd6MzRQQlFDM1Y5a3h0?=
 =?utf-8?B?Rnk1OUdXek5IL0xscXFMeUpHdmQzQzk4Vnh3dG1NK1ozNEN4Wm56Um5rZTht?=
 =?utf-8?B?UnlvNVlaUFAvTS83d2hCWC9aai85Y1BxMDBsNkNiNmhmQVdlUWNHdnVRL2th?=
 =?utf-8?B?L1cydGZDd1ZqWG9oZjJwVERBR3ZvTklFRDY2Ym5oeVhoWE5tQUM0WWx5OFVP?=
 =?utf-8?B?ZmowczRSTksxWUVZb1pIQVNId2NubmRvdmo1TWNvRmd2aDUyMytnajdNMURB?=
 =?utf-8?B?SjluU3ZFT1hWbWtrbWRsNmVwTkV5RUxEQytZTFA2TnptMkNEcWtObDlTMDAv?=
 =?utf-8?B?S3NFblVWOHZtY2F3VjgxMGc5ZWh0WVdjNXprTEc2SmxPOTB4eXZkTHhBT1JJ?=
 =?utf-8?B?aEtyMDErMUY0YXFOMGVQL0dCY1hTY0d5UHZtNHowRXZFTzJNWkFKdTlvbWgx?=
 =?utf-8?B?RkRqbG8wMlhmV1lWVi9Tc1E4QkpNRDlEZW5lcVA0eDJzWmlTRXhvaFFIcVd4?=
 =?utf-8?B?ay9BSkc5d09MS2lqeXBGQnV5Yml3WEJ4d2RJUzc0bVpMS3k4U280Sk5vaE9J?=
 =?utf-8?B?akxYZDI0MDlrb2F2cW1za1lIM21CMzdXQzdFNFFlREVEQ3BEUmY2SW1lNlNK?=
 =?utf-8?B?cjRTbGdsTm1iclZBSTRnMWMzNDhCdEhzc0ZoTjF0N1FCekFrN25iTDVKak90?=
 =?utf-8?B?dzdJendHbUltbFRTYWlObEJTT0RqYUd4QTQ2WElzM1A4RHpPazZnbkd0VFI2?=
 =?utf-8?B?aEhMS3JDRWcvTmo5ZEhONVNKTXBjeERsRzBBZERjR081Q2thZElXK3V1VEhD?=
 =?utf-8?B?MGwzb0tnRHV5RVZzWmtwUXozak5JODBhT3hCYXRTckhNdFlZOU5EVUt1SXdQ?=
 =?utf-8?B?OG1iT3BpeHA1djBYNUFQRHdMOHZNb3dqL3VvZ01lMVhqcjJtMmJkYmRlMnlw?=
 =?utf-8?B?N2pGMmJWRGFkb2lLbGRrZDVMZEhzc2FWRHRMMWN2dDZ0UWRrYmxRTjZ6eXJS?=
 =?utf-8?B?c1V2aVhTNnVmTExDVmZKUW5sZnRWYkdqVHZGYUtSSzNNYTNpcnE1YnRWRXEr?=
 =?utf-8?B?RHM1eUFMQStsMStaMlF4VlVOTk56eEsyN1hVY2dLdDJJYnNrMUorTFAyaDZm?=
 =?utf-8?B?VlozWEo4UVNSZmxiR25KRzVVNmJ2eExTRUcxVkxhUE1XRHd2OGNNNElrOGJm?=
 =?utf-8?B?cHM0dEhsc2ozM05qeUVXa1VBMXkxcFJPTVZLUHhxK1NJbXFXN0c1Q0hyK0dW?=
 =?utf-8?B?Tm1UaytOajk4a3pBQ0xucUtSTlRoS1ZkdVMzb3lBeGF2L1V4NEF2ZzRWRlho?=
 =?utf-8?B?dW9YMnh0OU9QM1hlRmNjOXdCcWg4emVRU3UrNnYrbmduVVR6SHFyTWk1TVE1?=
 =?utf-8?B?Z0JHanNJS0dIdlNocHBjNTNkYUE5KzU1bEEzNFM1ak1nQ3ZISWdKWEcyZ3hG?=
 =?utf-8?B?b2VQTllnaVV4Ri9CNXZCTjFyU3REWG5rVytNRWNiR1pmUG5QaHdJZ2hSdGhN?=
 =?utf-8?B?MWdidnVUKytNN3Jha1c3SXQ2bGpGVWo0cnIxQlE1KzdCYTUzUHRueDFlRXc2?=
 =?utf-8?B?dVNhNnRKK2VPdnpEbXZuWXhkVlNVQlRpaHR4M2lYNkdNb25jVDduSHFHendB?=
 =?utf-8?B?aEVhV1lhQ2RzOW9YL3JmRERmeEtzNnlqRmExSE51NEtuQWE5c3prZFJuRUxp?=
 =?utf-8?B?em5qTy9BZDdYMk9CNEwySWhRWEs5QWNwZmUzbHcrWHUxVlNXY0NSV1NYV3lW?=
 =?utf-8?B?emQ5N1Jpa0xod2RndlpDNmpvYlRKcWZhaFZWZ045TGs4M0kxWEx2aE1zWGVV?=
 =?utf-8?Q?QG/kn5yl8qzOTkSJ45?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 173ae5ad-f690-43ae-6d03-08df342ca42c
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5685.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2026 13:17:24.8809
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 49IhY6W+4wNODHOl5++jxYzs4scw3BTnYBPOIRwAoap/oeMI1YRt3433jK48/86u
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB8000

On 10/27/26 13:38, Jason Gunthorpe wrote:
> On Tue, Oct 27, 2026 at 01:07:36PM +0100, Christian König wrote:
>> On 10/26/26 06:36, Alistair Popple wrote:
>>> From: Jason Gunthorpe <jgg@nvidia.com>
>>>
>>> This attach function always creates a SGT mapping type importer.
>>
>> Yeah that is a clear NO-GO. The attachment should be the same for
>> the new interface as well.
> 
> Not sure I understand this comment...
> 
> This was intended as a helper so that existing drivers can run through
> the sgt based mapping type flow without having to open code it. It is
> hardwired to only do sgt like this. If you want to use more than sgt
> as your mapping type don't use this function
> 
> The point was to create a clear distinction in the API names when
> things were in a SGT-only flow vs using the newer negotiable flow.

Well that is my point, the dma_buf_attach() or rather dynamic_attach() function should still be part of the new flow.

The only difference is that the importer ops given to the dynamic_attach() functions now also contain the information necessary for the negotiation.

Regards,
Christian.

> 
>>> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> 
> Alistair since you rebased it you should put your SOB on every
> patch...
> 
> Regards,
> Jason

