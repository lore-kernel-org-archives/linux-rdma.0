Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.195.64
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793860964;
	b=2Sma9NZpzxaWbUIpbeAkPhMH5HOVHUIuzyqU/4jJ11km1UkXz/msj+a6lv+Ei3G4L415
	 3jmiHeaoJyAyUcXfBQFrqCF92BxRVLCa1JQbJT6WxTdFfYVCYSsDRjKOSwRhHHS0tCKDC
	 T/LqkAqpg5GqxRAvju8quZY5xyYwT/K1IggWbmcZWU4WYfW1ILFnOAuHqcuP1GQQMVPIJ
	 YZWAC11HpagncnPBjoJ+O7p2n6MFhbl2CGs57qJBpIkhw5gmxSh3omLVdUXfE2EZuRVbV
	 FiHc/Fp81iG0czYylugEJ4iimVx3CDPh0GrZahIAadz79YxuIYq7inAuNSdTUScoDcg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793860964;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:Date:Subject:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:
	 X-ClientProxiedBy:MIME-Version:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=H8Hi328qz9EetVVp2KpjhzH8s7Gs5Kn8S6aZAClk/tM=;
	b=ENDtpuPe0H2bH1MPI0BHRYeg2Pkgju9cZnlO6coBpiJvY1s7W3qjhvv5UBA8aDcYrz2P
	 HRKhL1a8JQZYho2SSat9RVUqPB4xXaVEzxmmrZ6LoCmbiSMqUNx22/EXxTfb2Fpyh8ZSs
	 i8a2N7QZ9uL07mtk2xjPV3GDxDONpfwEGzLB9jkq8iHadG8vKd41DxDcd4jDlOq2OzRTp
	 msjjc+ioY0CA5atQIr9XGK1HlUzE0vXK0EOwARdP3YT6ELlr/E6mxkRkszjqWdCL5nfnb
	 2wTmg7C6+G0XmCd2TWYo96J15kX61LwdVlIqpRsuqDCs7/AvYV9tT/6Xw0o5kHqp+6w==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=ArkeMx1w;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.195.64
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012064.outbound.protection.outlook.com [40.93.195.64])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D761606EE9D;
	Thu,  5 Nov 2026 06:42:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5D761606EE9D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=ArkeMx1w
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qRcRllLK6azhYw0N7z+E3yJBzBvC/Nyd7NR0czKvTav3jbqFs3coX5xbg/KGS7W8a9T4sn/WQnJxOiqm4uzUb6+ivs09sDq0B8X4rsYhTK+1F06yq/WfLJM09tFJZ1xSH86Yzcx8a8cWEDycOxqhuVQIIgMjnjP2TBbfGd6kHsvSxD57lkIAfBVSTeGQOYWhMjMyHjoxR4hBIlFSL0E6DikH2gP2uRMra6uM7XlPEsKz6Fo8Vu3xis3h2Tttopov250nDhpCoP9wFLvvZP6Bi6MeKesna6bKCIBuvv1/CKZxwcPqis1s/dDk1GWZk+dBT5DrjLzFIVmd77MBGadu1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H8Hi328qz9EetVVp2KpjhzH8s7Gs5Kn8S6aZAClk/tM=;
 b=RUsWHLOtcKQVHK+WuY+wa3ClSbZVB6GDyIuhYwpNd/ivikR90UCMNFC+9Pe21fZPoGY2hiRGMtao3e5iJTRmnSjE3hlcjDUhqtnnbaBv4CDlb1GUYC2BsbwMCMRhFd6TKLl2z2v+SL9voRnHF48ewJ2U4k+BBaaRpKsVyTzmIP27M8ACMctOtJWxNSFgb5X9JZYAuv3GDGOzldfCrIpUeXyhI/fGD1ZerJWNUYJFZCfU+LhLxb5bW/wW+hG7DbebPbFoeDK1HIfR1ZG5hJ3fyRMl4y/7FaAWAZVm12v/eDrIHqyqCI8oeyFqU/MF+Cfl9m/B84yofNk3/oJFlMnIWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H8Hi328qz9EetVVp2KpjhzH8s7Gs5Kn8S6aZAClk/tM=;
 b=ArkeMx1wad69H8BJ7ekboedL54dd/s+k7ts96eknvYtt4JTGgu4jLOuFo2RcY/ts2FJfRtMfxNTa7gm8N37HNv4IoWqnGcwcQJJpj1C++ATNMlxvQNdbsaJuAGtJkJaSguUJg0v/7QK5QFiUa8p5eCkN0TzbspyyEBJR2FKx5zG4U8Xv8npmguD8Rr0jlG8OWyXc37o16vGzZtYk6VR2CPGuUO12ctSU7phB4yvw2XypT5xDeipHnzqLchkx0igW0Eu4ZCwWqtvAEZxOWgifXGoSq0tW2/BuKFxqigJZ+wiQ+Ldd/d+sRmM3sm7lS9SycUCfQ+tNtbE5IJ5YEGTm4A==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SA3PR12MB598757.namprd12.prod.outlook.com
 (2603:10b6:806:52d::14) by IA0PR12MB8932.namprd12.prod.outlook.com
 (2603:10b6:208:492::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.9; Thu, 5 Nov 2026
 06:42:39 +0000
Received: from SA3PR12MB598757.namprd12.prod.outlook.com
 ([fe80::e206:100:5946:a777]) by SA3PR12MB598757.namprd12.prod.outlook.com
 ([fe80::e206:100:5946:a777%5]) with mapi id 15.21.0592.009; Thu, 5 Nov 2026
 06:42:39 +0000
From: Alistair Popple <apopple@nvidia.com>
Date: Thu, 05 Nov 2026 17:40:50 +1100
Subject: [PATCH v2 15/23] drm/amdgpu: Use the SGT mapping type
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261105-dma_mapping_type_v4-v2-15-78b8dc9ae80a@nvidia.com>
References: <20261105-dma_mapping_type_v4-v2-0-78b8dc9ae80a@nvidia.com>
In-Reply-To: <20261105-dma_mapping_type_v4-v2-0-78b8dc9ae80a@nvidia.com>
To: =?utf-8?q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
 Sumit Semwal <sumit.semwal@linaro.org>, 
 =?utf-8?q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>, 
 Simona Vetter <simona.vetter@ffwll.ch>, 
 Matthew Brost <matthew.brost@intel.com>, 
 Vivek Kasireddy <vivek.kasireddy@intel.com>, 
 Dongwon Kim <dongwon.kim@intel.com>, Kevin Tian <kevin.tian@intel.com>, 
 Xu Yilun <yilun.xu@linux.intel.com>, 
 Karl Mehltretter <kmehltretter@gmail.com>, 
 Baolu Lu <baolu.lu@linux.intel.com>, 
 Felix Kuehling <felix.kuehling@amd.com>, 
 Alex Deucher <alexander.deucher@amd.com>, dri-devel@lists.freedesktop.org, 
 intel-xe@lists.freedesktop.org, amd-gfx@lists.freedesktop.org, 
 linux-media@vger.kernel.org, linaro-mm-sig@lists.linaro.org, 
 linux-rdma@vger.kernel.org, iommu@lists.linux.dev, 
 Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@kernel.dk>, 
 Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, 
 linux-nvme@lists.infradead.org, "David S. Miller" <davem@davemloft.net>, 
 Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>, 
 Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
 Mina Almasry <almasrymina@google.com>, netdev@vger.kernel.org, 
 Alexey Kardashevskiy <aik@amd.com>, zhipingz@meta.com, treding@nvidia.com, 
 jhubbard@nvidia.com, Jason Gunthorpe <jgg@ziepe.ca>, 
 Leon Romanovsky <leon@kernel.org>
Cc: Alistair Popple <apopple@nvidia.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793860879; l=10551;
 i=apopple@nvidia.com; s=20261105; h=from:subject:message-id;
 bh=aoPqgwTRIKGCBlgH0CgiN6gJr5GA8+6d50dPaDX4s0U=;
 b=gjgDyTxVTVsiGUqbxXsoOhWFcELGGzK5E1TNJRXbF8VLzKfa1XR3s9qa0hRMGycK/f+7hrHKj
 2L4lhqqT2IZBIQu6vHleeaaXUTZQuwavIuUcd8ipZxTYhXp50E5WIdU
X-Developer-Key: i=apopple@nvidia.com; a=ed25519;
 pk=WdWPT9rAq3YNfXldbGv1NSGVLGxzQGFGJvRUiShhNqs=
X-ClientProxiedBy: SY5P282CA0007.AUSP282.PROD.OUTLOOK.COM
 (2603:10c6:10:208::18) To SA3PR12MB598757.namprd12.prod.outlook.com
 (2603:10b6:806:52d::14)
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
X-MS-TrafficTypeDiagnostic: SA3PR12MB598757:EE_|IA0PR12MB8932:EE_
X-MS-Office365-Filtering-Correlation-Id: 0f3647c9-4ecf-47ce-5ec9-08df3b07fc0f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|7416014|1800799024|23010399003|22082099003|18002099003|56012099006|261009221227099003|261021123027099003|921020|261021121427099003|261022075727099003|261022105027099003|261009223027099003|261026140227099003|261026121527099003|10067099003|261028144727099003|11063799006|261102123227099003|261102130727099003;
X-Microsoft-Antispam-Message-Info:
	cIPp6E5al24ISgIXOrEIL1tuJa2l/8N2eUW/NdfH9z7qhJTIz+7Zf5FrPRWGfcncvmzxRfROGOkqzR63ap5YMTc4bQ2rdImMnc68g5fLXbB8Jk49UIKHTtibO6Cjp3qc/BJyom/kd3eEyjwlAWnPxnxbET8PAi3GPi5vMLelq6V2uDU/dm+1UJs8uZjZ+TQt6OHl13U4W9bvSGmnTiZ2t4nRu0KQE6gWjarD+J1w7PVUcn84Q04kS0ef5NuT/SqDdRhujVT0Irsu9DIvE23BfX2XVz93veKU13fhbbU9ve+6eK9SB/x0cobYG4xkzhqWpoV2qV2X3cFhodnkWvjsy+LMjjpF7mhJmbKFv4yaLpHoWbBZ7dc/CcQbI+8FY4ByYCXnr9BNiNNDv8d96dmBUFawgnC3GRYp06UkWfUVetNIcVOkjrDa19yqA//xuyjkkPzviPR5EDT7XkrGGIbJknwrROl+erBb76Ya54BOV7/zqrcdw5prLLzCzMPHDgvmO9ANwqFprN9U9Ex2nTQR6WBEBTXq40FlVTY9UvO8K30Itxm9TxlSEJJlU/H4moftf82ACNYlC56ZgbV9kCfgOE5OAF8jeS5kKvq0Hq3S4DiMTOcYdHhHSomZVZPRha2B5nKysSv7gGr1jxnx3YoPYe6w5nmioMSpcQvtzXWOmy9NObH7eEJYp+7W2IaXEzX98KHQqnGCR4uRRkw5+pq0Gg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA3PR12MB598757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(7416014)(1800799024)(23010399003)(22082099003)(18002099003)(56012099006)(261009221227099003)(261021123027099003)(921020)(261021121427099003)(261022075727099003)(261022105027099003)(261009223027099003)(261026140227099003)(261026121527099003)(10067099003)(261028144727099003)(11063799006)(261102123227099003)(261102130727099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eFZNNWVBTm5CeXpqTC9UVDdlTjBUcHJESGErMWhnS056RW5WUFdCVGJMWlk2?=
 =?utf-8?B?SVh5VGl4dkFDQktSbGVtay85R0pQWE5Ecm9qWVJRK3VibE9nN0I4WFJQYmx5?=
 =?utf-8?B?MGk0cWFIOUdTcUpkWm56QWRseW45eUl6dUF4OUZzMXFWTkhQaHNtbmdlUm9w?=
 =?utf-8?B?Z25ZQTZMdi9XS1NQVzdLTTF1RTR5VUdyTkwxd3pqTWFCdDcvM1hqSUpwbmU3?=
 =?utf-8?B?bFJXczBMbENCaTlILzluMGptMWlQU0xPYW01bVgybEdrYnp3UEVwR2dBL3Fp?=
 =?utf-8?B?dVM2VHRFdHhGQkhncnpQU2FFaHo1c2pQeDNIRWZmL2ltaVNMRzlmRDlqUlp1?=
 =?utf-8?B?K0NhcEpiL21ON3ZIWGJDN2Evd3FFL0I3dDRDbkMzTko1NkpsS0lUejVDNElQ?=
 =?utf-8?B?Tlp0LzJMVFB1OGI3cGpaZmtPQXJZMHVoM1J5ZGxXV01DOWEySTQxb0hiVU4x?=
 =?utf-8?B?NGtPeGlQcG1VQ3dReC9NVG5nU0E4dEQyejVFWEtnQldsVHIzVHFWVy9JTGdx?=
 =?utf-8?B?dnljcmJsdW14UEpYS09JaXNGTXYxUjNqSGVhelNoWFVkRTJ0aWlCdUVkbldP?=
 =?utf-8?B?d3lmbko2Rm1EWGF4ZEpSZk9oU2YzNHJIeDhCeU10TWkzT21ZOHMzRWFRYzNJ?=
 =?utf-8?B?QU42bEVtYUc2Tkd5WUpwelU0eEVyV0tXUDJVaVNUeURXVlk5QUNNeW1wSHhs?=
 =?utf-8?B?MjNYOW1Fa2hUYmoxZjAxMUgwTGZwU0tDRjZaVncvdEpjV1ZWaUFCcEpMS2J5?=
 =?utf-8?B?TmVOVXdNMmJ5aGlXNzA4RExodDUveG96U2NYenpyU0lqaEFQdE5JSGx1ZXk5?=
 =?utf-8?B?UjFnM21zM0pFZTZQTkxITXhiekY1OW9zVnFBc2RReGJaWVhKbFRsTncwTTg3?=
 =?utf-8?B?MTBBOW1WQjZtRjRxOHBqYkNTaW41ZFFiSDRybW54aUprNGpTVnpNYkgxcjFD?=
 =?utf-8?B?cnhwVU1TOE12cUVnbDh3ZjdkN0NZZml4REV6YkFGRVpKaVdYSC9jWFNJRFd0?=
 =?utf-8?B?eWQwKzM0emJDZmpNdS9sZHc1KytjQXZZTTRxRG5BbUFVaFJKQzNTR1hhSjI2?=
 =?utf-8?B?eEFMQWdjWTlrbE9TNVBkTnlhSm5sSTE5a081dktxUGNUQ1NrNEFDQUNWOFZ2?=
 =?utf-8?B?RnFUQXdNamVvSXJjRDNlcXFMODM0OVloenFkRjAwelArRUt2bVNxWll3eXVW?=
 =?utf-8?B?Ylp5V0crOWNIcFhpUWNwSEpPSWk0cDFWbWQ1aENVSTBZZUthNUNXTW54bTIr?=
 =?utf-8?B?QjF1dGt4NlA0emxRbzVMc29BbHg1aXgvMzJLOUJUZGRwMUcvNmltOGxnbWVk?=
 =?utf-8?B?clJ4bTdvRUVSYkRtZ0pzUCtxUkYzWThjUnFoTVFlRy8zTFlmOWY0ZStSNHp3?=
 =?utf-8?B?MmdVd3d4VHM2enBUdWJTNnpnRnpMcjNkYTBtMGJGMm1BckdiR2FubnUxZ1RT?=
 =?utf-8?B?Q291RU1HNEtNd2h6bmNQNW56SndmZ09MaVJGcXFYczJTSDRjYWxROXkzeFh0?=
 =?utf-8?B?d3VUc2dtd3Z4SVJtWUhvSzBXR2dOQlAzNFQxbFpMbGlCTlg5aFdIYmEvekdx?=
 =?utf-8?B?c3VYcU1VNkM4OEV5WjNOMlRuNVhzdlU3QUFkVjdaWmdRUmxiMGh1ZTRLUHRm?=
 =?utf-8?B?VUdObGVCcURXYUM1dEpqL0xON1ptaERuTUNseDFjcS9aSVVESVZZTjZiU0Rq?=
 =?utf-8?B?UzBrYitDT2JmQUZQOVFPMEdPaC9YTHhxV1lORU5YcjVvcFVVWjBRSUliSFUv?=
 =?utf-8?B?ODZ2di8zZFlwdDVFMmdUS21mNDlYYWNBTzlKUWVJZGtzMGZCNm0rL2drNCtv?=
 =?utf-8?B?WHVMbVVSYlUvWVoyeWVBdjhLbVhGcUxjUUtDZDVTc1JxbW8xc2hjcXdpYkxE?=
 =?utf-8?B?ZkhTV0NVN1RHVFN5eUFRdGNYa29wQ2JMYnRiWEFqblJpRWo4aDRCSFlWNFBP?=
 =?utf-8?B?NllDc3NHNER3TXZ0Y3QyemJwRFZqekFBRVh5N2Y3bUJuU2FNZExTeUYxNUNz?=
 =?utf-8?B?c09HWGZWcGxLVlFzL3pYRGhFYmROQVljckM3NjVWZENxS0hxTjFmNlhKam0r?=
 =?utf-8?B?VzlTVURWZEZYZ3NZMjRIRmJGUW0wOE1ISmJSRWcyWjhYcUo3VlNZS2o4RUNT?=
 =?utf-8?B?Y2JmYXhvenEyNFFtREZoaHVjeiszamNUL0NML3NOUjJRM01ZRFU5TldIK0o0?=
 =?utf-8?B?YytNUEJaczZLTkNnN0tKb3VvZzI2WGN5aXplL0pZekJoUjBhR2wwVUlCbmRR?=
 =?utf-8?B?OElldk5sa0U4eFZZUmZPdExrWWRjaXlJeXdHWnpUMFRVQWN2U3NpNXpzWVNP?=
 =?utf-8?B?OWlkVGEvTlFid2pmN3ZiNm1UbGFlWjhRVDlSRnJvSlJ5YnlpMjhHZz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f3647c9-4ecf-47ce-5ec9-08df3b07fc0f
X-MS-Exchange-CrossTenant-AuthSource: SA3PR12MB598757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2026 06:42:39.1700
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gEuz56Dk8gofoDFpjUe8UMmBINeFFLBGbZpWiOIYyMd8RDauDXLZL9bqFWqBbZ1/g05GHHyMbKfTqh2dpjeOiw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8932

From: Jason Gunthorpe <jgg@nvidia.com>

Similar to xe, amdgpu wants to check pci_p2pdma_distance(), and
only needs that if peer2peer can be supported by the GPU. It can migrate to
system memory and support non-p2p DMA as well.

Further it supports a private non-PCI XGMI path. For now hack this on top
of a SGT type, but eventually this is likely better off as its own mapping
type.

Add two exporter SGT mapping types, one that matches P2P and one that
matches all of the non-p2p. The pin and map code will force migrate if
the non-p2p one is matched.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Alistair Popple <apopple@nvidia.com>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_dma_buf.c | 136 ++++++++++++++++++----------
 1 file changed, 90 insertions(+), 46 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_dma_buf.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_dma_buf.c
index bbe518757907..edb74e2f4e26 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_dma_buf.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_dma_buf.c
@@ -41,6 +41,7 @@
 #include <drm/amdgpu_drm.h>
 #include <drm/ttm/ttm_tt.h>
 #include <linux/dma-buf.h>
+#include <linux/dma-buf-mapping.h>
 #include <linux/dma-fence-array.h>
 #include <linux/pci-p2pdma.h>
 #include <linux/pm_runtime.h>
@@ -79,43 +80,11 @@ static struct amdgpu_device *dma_buf_attach_adev(struct dma_buf_attachment *atta
 static int amdgpu_dma_buf_attach(struct dma_buf *dmabuf,
 				 struct dma_buf_attachment *attach)
 {
-	struct amdgpu_device *attach_adev = dma_buf_attach_adev(attach);
 	struct drm_gem_object *obj = dmabuf->priv;
 	struct amdgpu_bo *bo = gem_to_amdgpu_bo(obj);
 	struct amdgpu_device *adev = amdgpu_ttm_adev(bo->tbo.bdev);
 	int r;
 
-	/*
-	 * Disable peer-to-peer access for DCC-enabled VRAM surfaces on GFX12+.
-	 * Such buffers cannot be safely accessed over P2P due to device-local
-	 * compression metadata. Fallback to system-memory path instead.
-	 * Device supports GFX12 (GC 12.x or newer)
-	 * BO was created with the AMDGPU_GEM_CREATE_GFX12_DCC flag
-	 *
-	 */
-	if (amdgpu_ip_version(adev, GC_HWIP, 0) >= IP_VERSION(12, 0, 0) &&
-	    bo->flags & AMDGPU_GEM_CREATE_GFX12_DCC)
-		attach->peer2peer = false;
-
-	if (!amdgpu_dmabuf_is_xgmi_accessible(attach_adev, bo) &&
-	    pci_p2pdma_distance(adev->pdev, attach->dev, false) < 0)
-		attach->peer2peer = false;
-
-	/*
-	 * Only allow P2P while the exporter is active, and keep it active
-	 * until detach.  With runtime PM disabled take a plain reference so
-	 * the put in detach stays balanced.
-	 */
-	if (attach->peer2peer) {
-		struct device *dev = adev_to_drm(adev)->dev;
-		int ret = pm_runtime_get_if_active(dev);
-
-		if (!ret)
-			attach->peer2peer = false;
-		else if (ret < 0)
-			pm_runtime_get_noresume(dev);
-	}
-
 	r = dma_resv_lock(bo->tbo.base.resv, NULL);
 	if (r)
 		goto err_pm_put;
@@ -127,7 +96,8 @@ static int amdgpu_dma_buf_attach(struct dma_buf *dmabuf,
 	return 0;
 
 err_pm_put:
-	if (attach->peer2peer)
+	/* Drop the reference taken in amdgpu_dma_buf_match_mapping() */
+	if (dma_buf_attach_accepts_sgt_p2p(attach))
 		pm_runtime_put_autosuspend(adev_to_drm(adev)->dev);
 	return r;
 }
@@ -138,7 +108,7 @@ static int amdgpu_dma_buf_attach(struct dma_buf *dmabuf,
  * @dmabuf: DMA-buf where we remove the attachment from
  * @attach: the attachment to remove
  *
- * Drop the runtime PM reference taken in amdgpu_dma_buf_attach().
+ * Drop the runtime PM reference taken in amdgpu_dma_buf_match_mapping().
  */
 static void amdgpu_dma_buf_detach(struct dma_buf *dmabuf,
 				  struct dma_buf_attachment *attach)
@@ -147,7 +117,7 @@ static void amdgpu_dma_buf_detach(struct dma_buf *dmabuf,
 	struct amdgpu_bo *bo = gem_to_amdgpu_bo(obj);
 	struct amdgpu_device *adev = amdgpu_ttm_adev(bo->tbo.bdev);
 
-	if (attach->peer2peer)
+	if (dma_buf_attach_accepts_sgt_p2p(attach))
 		pm_runtime_put_autosuspend(adev_to_drm(adev)->dev);
 }
 
@@ -175,7 +145,7 @@ static int amdgpu_dma_buf_pin(struct dma_buf_attachment *attach)
 	 * notiers are enabled.
 	 */
 	list_for_each_entry(attach, &dmabuf->attachments, node)
-		if (!attach->peer2peer)
+		if (!dma_buf_attach_accepts_sgt_p2p(attach))
 			domains &= ~AMDGPU_GEM_DOMAIN_VRAM;
 
 	if (domains & AMDGPU_GEM_DOMAIN_VRAM)
@@ -218,6 +188,7 @@ static void amdgpu_dma_buf_unpin(struct dma_buf_attachment *attach)
 static struct sg_table *amdgpu_dma_buf_map(struct dma_buf_attachment *attach,
 					   enum dma_data_direction dir)
 {
+	struct device *dma_dev = dma_buf_sgt_dma_device(attach);
 	struct dma_buf *dma_buf = attach->dmabuf;
 	struct drm_gem_object *obj = dma_buf->priv;
 	struct amdgpu_bo *bo = gem_to_amdgpu_bo(obj);
@@ -231,7 +202,7 @@ static struct sg_table *amdgpu_dma_buf_map(struct dma_buf_attachment *attach,
 		unsigned int domains = AMDGPU_GEM_DOMAIN_GTT;
 
 		if (bo->preferred_domains & AMDGPU_GEM_DOMAIN_VRAM &&
-		    attach->peer2peer) {
+		    dma_buf_sgt_p2p_allowed(attach)) {
 			bo->flags |= AMDGPU_GEM_CREATE_CPU_ACCESS_REQUIRED;
 			domains |= AMDGPU_GEM_DOMAIN_VRAM;
 		}
@@ -249,7 +220,7 @@ static struct sg_table *amdgpu_dma_buf_map(struct dma_buf_attachment *attach,
 		if (IS_ERR(sgt))
 			return sgt;
 
-		if (dma_map_sgtable(attach->dev, sgt, dir,
+		if (dma_map_sgtable(dma_dev, sgt, dir,
 				    DMA_ATTR_SKIP_CPU_SYNC))
 			goto error_free;
 		break;
@@ -261,7 +232,7 @@ static struct sg_table *amdgpu_dma_buf_map(struct dma_buf_attachment *attach,
 			return ERR_PTR(-EINVAL);
 
 		r = amdgpu_vram_mgr_alloc_sgt(adev, bo->tbo.resource, 0,
-					      bo->tbo.base.size, attach->dev,
+					      bo->tbo.base.size, dma_dev,
 					      dir, &sgt);
 		if (r)
 			return ERR_PTR(r);
@@ -269,7 +240,7 @@ static struct sg_table *amdgpu_dma_buf_map(struct dma_buf_attachment *attach,
 
 	case AMDGPU_PL_MMIO_REMAP:
 		r = amdgpu_ttm_mmio_remap_alloc_sgt(adev, bo->tbo.resource,
-						    attach->dev, dir, &sgt);
+						    dma_dev, dir, &sgt);
 		if (r)
 			return ERR_PTR(r);
 		break;
@@ -299,21 +270,22 @@ static void amdgpu_dma_buf_unmap(struct dma_buf_attachment *attach,
 				 struct sg_table *sgt,
 				 enum dma_data_direction dir)
 {
+	struct device *dma_dev = dma_buf_sgt_dma_device(attach);
 	struct drm_gem_object *obj = attach->dmabuf->priv;
 	struct amdgpu_bo *bo = gem_to_amdgpu_bo(obj);
 
 	if (bo->tbo.resource &&
 	    bo->tbo.resource->mem_type == AMDGPU_PL_MMIO_REMAP) {
-		amdgpu_ttm_mmio_remap_free_sgt(attach->dev, dir, sgt);
+		amdgpu_ttm_mmio_remap_free_sgt(dma_dev, dir, sgt);
 		return;
 	}
 
 	if (sg_page(sgt->sgl)) {
-		dma_unmap_sgtable(attach->dev, sgt, dir, 0);
+		dma_unmap_sgtable(dma_dev, sgt, dir, 0);
 		sg_free_table(sgt);
 		kfree(sgt);
 	} else {
-		amdgpu_vram_mgr_free_sgt(attach->dev, dir, sgt);
+		amdgpu_vram_mgr_free_sgt(dma_dev, dir, sgt);
 	}
 }
 
@@ -388,18 +360,90 @@ static void amdgpu_dma_buf_vunmap(struct dma_buf *dma_buf, struct iosys_map *map
 	amdgpu_bo_unpin(bo);
 }
 
+static const struct dma_buf_mapping_sgt_exp_ops amdgpu_dma_buf_sgt_ops = {
+	.map_dma_buf = amdgpu_dma_buf_map,
+	.unmap_dma_buf = amdgpu_dma_buf_unmap,
+};
+
+static int amdgpu_dma_buf_match_mapping(struct dma_buf_match_args *args)
+{
+	struct dma_buf_attachment *attach = args->attach;
+	struct drm_gem_object *obj = args->dmabuf->priv;
+	struct amdgpu_bo *bo = gem_to_amdgpu_bo(obj);
+	struct amdgpu_device *adev = amdgpu_ttm_adev(bo->tbo.bdev);
+	struct device *dev = adev_to_drm(adev)->dev;
+	struct dma_buf_mapping_match sgt_match[2];
+	unsigned int num_match = 0;
+	bool peer2peer = true;
+	int ret;
+
+	/*
+	 * Disable peer-to-peer access for DCC-enabled VRAM surfaces on GFX12+.
+	 * Such buffers cannot be safely accessed over P2P due to device-local
+	 * compression metadata. Fallback to system-memory path instead.
+	 * Device supports GFX12 (GC 12.x or newer)
+	 * BO was created with the AMDGPU_GEM_CREATE_GFX12_DCC flag
+	 *
+	 */
+	if (amdgpu_ip_version(adev, GC_HWIP, 0) >= IP_VERSION(12, 0, 0) &&
+	    bo->flags & AMDGPU_GEM_CREATE_GFX12_DCC)
+		peer2peer = false;
+
+	/*
+	 * Only allow P2P while the exporter is active, and keep it active
+	 * until detach.  With runtime PM disabled take a plain reference so
+	 * the put in detach stays balanced.
+	 */
+	if (peer2peer) {
+		ret = pm_runtime_get_if_active(dev);
+		if (!ret)
+			peer2peer = false;
+		else if (ret < 0)
+			pm_runtime_get_noresume(dev);
+	}
+
+	if (peer2peer)
+		sgt_match[num_match++] = DMA_BUF_EMAPPING_SGT_P2P(
+			&amdgpu_dma_buf_sgt_ops, adev->pdev);
+	sgt_match[num_match++] = DMA_BUF_EMAPPING_SGT(&amdgpu_dma_buf_sgt_ops);
+
+	ret = dma_buf_match_mapping(args, sgt_match, num_match);
+	if (ret)
+		goto err_pm_put;
+
+	/*
+	 * If the transfer will use XGMI then force a P2P match: the importer
+	 * reaches VRAM over XGMI, so the BO may stay there even though PCIe
+	 * P2P did not match. Rewrite the recorded match set entry, which is
+	 * what dma_buf_mapping_select() picks from at pin or map time.
+	 */
+	if (peer2peer && !dma_buf_attach_accepts_sgt_p2p(attach) &&
+	    amdgpu_dmabuf_is_xgmi_accessible(dma_buf_attach_adev(attach), bo))
+		attach->matches[0].sgt_data.exporter_requires_p2p =
+			DMA_SGT_EXPORTER_REQUIRES_P2P_DISTANCE;
+
+	/* The PM reference is only needed while P2P is actually possible. */
+	if (peer2peer && !dma_buf_attach_accepts_sgt_p2p(attach))
+		pm_runtime_put_autosuspend(dev);
+	return 0;
+
+err_pm_put:
+	if (peer2peer)
+		pm_runtime_put_autosuspend(dev);
+	return ret;
+}
+
 const struct dma_buf_ops amdgpu_dmabuf_ops = {
 	.attach = amdgpu_dma_buf_attach,
 	.detach = amdgpu_dma_buf_detach,
 	.pin = amdgpu_dma_buf_pin,
 	.unpin = amdgpu_dma_buf_unpin,
-	.map_dma_buf = amdgpu_dma_buf_map,
-	.unmap_dma_buf = amdgpu_dma_buf_unmap,
 	.release = drm_gem_dmabuf_release,
 	.begin_cpu_access = amdgpu_dma_buf_begin_cpu_access,
 	.mmap = drm_gem_dmabuf_mmap,
 	.vmap = amdgpu_dma_buf_vmap,
 	.vunmap = amdgpu_dma_buf_vunmap,
+	.match_mapping = amdgpu_dma_buf_match_mapping,
 };
 
 /**
@@ -635,7 +679,7 @@ struct drm_gem_object *amdgpu_gem_prime_import(struct drm_device *dev,
 	 * budget normally, so drop AMDGPU_GEM_CREATE_PREEMPTIBLE again.  The
 	 * BO is not published yet, so clearing the flag here is race-free.
 	 */
-	if (!attach->peer2peer)
+	if (!dma_buf_attach_accepts_sgt_p2p(attach))
 		gem_to_amdgpu_bo(obj)->flags &= ~AMDGPU_GEM_CREATE_PREEMPTIBLE;
 
 	get_dma_buf(dma_buf);

-- 
2.54.0

