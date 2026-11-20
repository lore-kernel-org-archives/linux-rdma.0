Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.196.10
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795154247;
	b=hXdT8SeB/ifFo9bguBaApHsiNRvNsyv4GGqpom0kdBM0luVcJmpNvnUvZqHa5QuJVn0d
	 x/aP4gGq6RIQcVVR3lv6DxlXBcdk8HTAxysolONkaLuDlpBr/zYLh05qjpojkGvB55gLl
	 GqdhUIbccg1+iMZaZsCXjCGItBNRmi6b9LHrfJYOEjvH78OcGoLamvzK6qzaYP3o7PSaO
	 mq+fGj7823IDmL1vC/j3uWlFGrqHsttV6JAYsRdIn5Bfpx8vxd78+QVnRlB6Wlg66LL0z
	 hb+7DfcWcG2V/Be6/762KqZ7dpo5wW76+o00b/fx+ErMoc5T7wNXPjwXWjkIeaJowYA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795154247;
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
	bh=gh9UMk+P12oc5pffW1Tfli+5ZIDE2BR9DrQfG3dJ3Jw=;
	b=buJ5UfoEgA5mEnhKUhMN/QM+X3QHVAlqgeUFZ1JPyQVhODi2WOXdOtFmyYA7dy5TaF+L
	 i1AOx/hlWTMid4U1nDRD30uW9fyKmAz1v41UFeYIgNyBfCfcsXkkUANfQTAtJh8264S1W
	 xOqfl3E5hLOoDEAcra0rRCsKQV9kkJVVJmsnZuCsw+V9r7trikaCXFA9NTHPooMPH5HD/
	 H2JTvx55yauBXM3xeL0NUEqxY5O54bsAeuIKSBRNM2TuMAdt3pzl0RycxyZC+Y068Cus4
	 nO0Gaz+NbIS1AkqWuGQG5tnh3Jkw5bVNRs+o9OzeBlcRHZSV2F15JWHQ86Gwl5zJ+5Q==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=DNGADqEm;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.196.10
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013010.outbound.protection.outlook.com [40.93.196.10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03DEF606A330;
	Fri, 20 Nov 2026 05:57:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 03DEF606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=DNGADqEm
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VOTjwqvUygv1gIlZb0To7V9ECL39Xsqxv4N9mWf4EgcmSL3bwJh3QM5ppvqgkScI0jObwBDIS1rKnYE2KvekTbiCv1WJK8CWIdpqcCpUFsiJK6UCuNsyj0uJDqmBSsYhYtS6JdLK1nRjzTyw5azr7D9wNA/He7bBejmeZUaAxmwIN05pAcSMAQc6LjUPf/lmJPZKUwy5kAL5QqEQraoajzk/lJ8G9xPJfG47r+LUTZAXlbZvJhxLVzbw+eD7XMfn1kSdngWDD04YQ5xwHxvT0sfStcgXVrGhRPt5YPKC+TAWXtcoveyo/thB67fQngSFUg8RoALAVxToVSxl6zeQCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gh9UMk+P12oc5pffW1Tfli+5ZIDE2BR9DrQfG3dJ3Jw=;
 b=iF2nSoBGFI7ZMULeW+vKMWLewyoEh5hriZrHDhezH09ozc66MVPsga/CUZfzEGRYiIvqXeKnojcNMcNdFsd/VjozzJ5RjCVQTPO7SKSo/ozA5q5+xv1dWy9G19vD+1JEOPnG440R3B7Xny9kHgfGqFp8i+SKyRcf4BZYcKxqsQP1xbpe8FANw16+gkqwg4UnQxlH8sZ496bT5vCtSHvaHOfk1APVAxZMmFX5PbCP4uE/K/NKp9HHgSXiBie6yN6eDJhbgXHX4+FktyMuN7HZF5K1Q8NXAuvHrMAyBE/5Bz/UxqOjMaW5dd+8ZGfsrhnRsAiYENX35Whp89slD5V7Bg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gh9UMk+P12oc5pffW1Tfli+5ZIDE2BR9DrQfG3dJ3Jw=;
 b=DNGADqEmqg2pgDQFmAq2jVUa4ouVe/lyQg+fL+uF2sUEaVv3eEuT5bVPC7SsSLAm0/JooTy4w7D1oW0mGDkzEqCLk906AQq9oaDjX54cxrXFJ2a2aOM+zry9GQ17k4DjLw11+yv3IzZsJCMxOKuQ1v0C4FVWGqWcQ4oo6/fYB2EKDjWUPjpCY4PnHZXVqIj3u1Ru71DK9VrO6D+WGa82UQ+AHVSKRNMgaM/CcAfBhGCk7/WPUi4Ll/J2Vbm/tYE0lL6xf6xSK5wTS+86VO34m0fYaNpjDornr5Nzde0Zg1vZ19VZ0viPVDDJTCPwcAnMYJYnfgEV9lzYDpE2wJuo8A==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SA3PR12MB598757.namprd12.prod.outlook.com
 (2603:10b6:806:52d::14) by IA0PR12MB7675.namprd12.prod.outlook.com
 (2603:10b6:208:433::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Fri, 20 Nov
 2026 05:57:18 +0000
Received: from SA3PR12MB598757.namprd12.prod.outlook.com
 ([fe80::e206:100:5946:a777]) by SA3PR12MB598757.namprd12.prod.outlook.com
 ([fe80::e206:100:5946:a777%5]) with mapi id 15.21.0639.011; Fri, 20 Nov 2026
 05:57:18 +0000
From: Alistair Popple <apopple@nvidia.com>
Date: Fri, 20 Nov 2026 16:55:47 +1100
Subject: [PATCH v3 09/24] dma-buf: Convert exporters keeping a table per
 attachment to the SGT mapping type
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261120-dma_mapping_type_v4-v3-9-c0183a409bdf@nvidia.com>
References: <20261120-dma_mapping_type_v4-v3-0-c0183a409bdf@nvidia.com>
In-Reply-To: <20261120-dma_mapping_type_v4-v3-0-c0183a409bdf@nvidia.com>
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
 Alex Deucher <alexander.deucher@amd.com>, linux-kernel@vger.kernel.org, 
 dri-devel@lists.freedesktop.org, intel-xe@lists.freedesktop.org, 
 amd-gfx@lists.freedesktop.org, linux-media@vger.kernel.org, 
 linaro-mm-sig@lists.linaro.org, linux-rdma@vger.kernel.org, 
 iommu@lists.linux.dev, Keith Busch <kbusch@kernel.org>, 
 Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, 
 Sagi Grimberg <sagi@grimberg.me>, linux-nvme@lists.infradead.org, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
 Simon Horman <horms@kernel.org>, Mina Almasry <almasrymina@google.com>, 
 netdev@vger.kernel.org, Alexey Kardashevskiy <aik@amd.com>, 
 zhipingz@meta.com, treding@nvidia.com, jhubbard@nvidia.com, 
 chaitanyak@nvidia.com, Jason Gunthorpe <jgg@ziepe.ca>, 
 Leon Romanovsky <leon@kernel.org>
Cc: Alistair Popple <apopple@nvidia.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795154186; l=31468;
 i=apopple@nvidia.com; s=20261105; h=from:subject:message-id;
 bh=z9wu0CJpUJK864/ARIXaxsAQWnsqirU58jSflKMxwc4=;
 b=Yt3rwNEpGCRIvvlnljSrmIutgr3KQ8/arhnI3Jh/Eg2LFQV+jOspBMzvuU+VAV/7VmtptEtNQ
 zrCe8XKhMQiC9JDQah0WKEXW8pK4dKVCC6wC5qrC5UkoUA55XlFufSj
X-Developer-Key: i=apopple@nvidia.com; a=ed25519;
 pk=WdWPT9rAq3YNfXldbGv1NSGVLGxzQGFGJvRUiShhNqs=
X-ClientProxiedBy: SY5PR01CA0090.ausprd01.prod.outlook.com
 (2603:10c6:10:1f5::11) To SA3PR12MB598757.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA3PR12MB598757:EE_|IA0PR12MB7675:EE_
X-MS-Office365-Filtering-Correlation-Id: 879f2cf5-d23e-4c8d-e17c-08df46cb2249
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|7416014|366016|1800799024|921020|10067099003|11063799006|5023799004|56012099006|261021123027099003|261028144727099003|261022105027099003|261026121527099003|261026140227099003|261022075727099003|261021121427099003|261102130727099003|261102123227099003|261009220027099003|261009223027099003|261009221727099003|261009221227099003|261009223327099003|22082099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	WSJunC6Le0epbAnvmXE+VySUr0pydkCaiRPlb6Ws462ZItKvHil919U7FPWhOk7WyNAR9wrbKe2kYnCaK786VCCxz3Ks28bsm+InnpDIePQ4YGYXqmKAVeE2AuLoCXOZfBP/Qk8NHsDYs+v3p4VLs3jZLC85w8Z7PBAcF959Q3wiP+01F7Xn/IdiHr1xw46QaX87tTwqhCz/+ZXRi8GZ2m2IhIZ7aoscD8+ZaqzMyhfnpMuGuluqpA2mSSxITFVQQz+OTwc72c1Ftphb+BY+dINYEkdXqlnnB/j9wxRw1jSAcVw8VrJmDF/wJ3oYX3BQbyQc3hppaC6WALrwce/AUL4joiW6dJjgSXNcD6fhHShUOI27ErwMywKb6m9Npg6svqS7rKqF3aPzloyQnM9cEqq1RRMZT3SPzgLG9dzYQrSxlniwqOd4q5bvs/G9hhr2wBwcrEqNhl7QMQbD+OvaiTHorN9RCtQqJS548jAYWD2XtSPCw4EtTTxcJgTJA48rmqsMY5gA1+MJQPHqRQBGTfsezUDebPhO4P0aol/So+Uhe8qHeO7llK+WEmxjjRvwfkh8mYIJnE4Uhl0MrAzM8HhLkq1IxfSvF/aLSRykwzJbLYBGV6W/RrxbXXsd5OQdgpN/JdAzHdljp4dhPtYN1zeM4PkUwo8eartHVPT7e/RceuzNsG3Ce+6UdCGatZvx5YZ7RVL1UkKHYLPUKKUoJA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA3PR12MB598757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(7416014)(366016)(1800799024)(921020)(10067099003)(11063799006)(5023799004)(56012099006)(261021123027099003)(261028144727099003)(261022105027099003)(261026121527099003)(261026140227099003)(261022075727099003)(261021121427099003)(261102130727099003)(261102123227099003)(261009220027099003)(261009223027099003)(261009221727099003)(261009221227099003)(261009223327099003)(22082099003)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZlJHaWxFdVh4MlBITThpNVI4SFZuRklDRStaZElaVjJhTysxSTltTnpWL1J6?=
 =?utf-8?B?cU5SZzl4ZHFxeHBsYTFhZ2E0bVczNlRzLzNYOS9TdURLeDNzcVVwQmFYVWNF?=
 =?utf-8?B?aGhkQ2N0d2drUnAzdkFxR0pVZnZHV2tEZjdrcm5pNXg1ZDNOSnpiSUxCME9P?=
 =?utf-8?B?dHVjclpZWlFhZ0FjL2J4MWJ5VFRDeEFqczZ1MEdEV2tDcmhqdmpQQTFpL20y?=
 =?utf-8?B?ZEdWOGJsUDIxYXZZZVU0eEl0Qk1YbmZDWFBwOExtODVSYWZBZ00wd09rd3I4?=
 =?utf-8?B?bHNHNGxvTnk1dWRUcDBqUHhuSXQ4SVJvKzFGS1MyOUorQitvZWlVbTc4cCtX?=
 =?utf-8?B?RnNCZVNlb09hTy9vWnYrNU8zRWhOaHcwcTNYWnhQV0xucEVNQlFJM1p1NFRI?=
 =?utf-8?B?S1h3aGZhNHZtTndETjhtUUtMenRVSS9sb1FDUHlTenBJc3grdmNva3hvbWl1?=
 =?utf-8?B?NWJiaWJuS3FMVEFMQlA4cFNxZ3BaeDRFcVZHRGh3ZkRUNHZHbDMwVVMvM3BG?=
 =?utf-8?B?Q2RlR1BhbHZpSXJFdzFZc3c2bFpvNlBXU3VyenJKOS9Ra0F3S3VZVEJjQ0J0?=
 =?utf-8?B?czZzdzBhRlltU1hsSkxHckpnSlJxMnI4aUVpMWdNdk8vVHJNOVAxM0tXVnRz?=
 =?utf-8?B?d0ozc2R4YjgvRWtaV2lvbnFWWGRaRjdaMzRyZXR6bEY3SExLZ0h4M2pKUWto?=
 =?utf-8?B?aTFZVHZnSEMyS3JsYUJtNUlWVG1Ha0ZSR09YWWxITmY4eEdoWTNscG1BUE1t?=
 =?utf-8?B?V1RLWWYzN0FEUjVrckE2OTQzd1lXNk4yS2hMMEJKWXpFSVdvTDlSMDUwaVYw?=
 =?utf-8?B?NjV6OHljb0ltQ1Z5ZmpnQjlvTDVRKy92NWVvM2JpSFkyQTVZSUpVSXcyUnhm?=
 =?utf-8?B?dXhPSWduS1Q0VFJFQTdVUklyb0xoS3RkRERIRHJ3dURxN2xoazNIOGtKWGx5?=
 =?utf-8?B?RCtCcFprMit4L2tkdVBZTEF4QytWSk5MNm9OQkVVL3VtcUdVWDNTYTNHZi95?=
 =?utf-8?B?RktmRkhCTlZpWS9rcmYzOFlyc1BodDlyeHVKMkM0NlpuZ1VxcDhIZ2haRExB?=
 =?utf-8?B?bjNiMkpvQ1VhOGF2c3Zsem9GR2Q5UEhmWEtmOTFnVlNjMDU1WGpVVFNJQnI4?=
 =?utf-8?B?czZaWkMzaU8wMW4vVXBTc0N3c1laeUFRU2doVExIb3BpT2pHeGhXNFc1OVdj?=
 =?utf-8?B?dnc4N29SVTQveGhxVG9tUlNFd2c0QlpsNHBmYTFGR0x1ZVRFYXQyTnNwQ3Z6?=
 =?utf-8?B?WkdKK1BTUjJKa2FKWGhYcXZlRXNUb0RnV3VRZTlxT2ZHejBFMzlxVTZrVFMr?=
 =?utf-8?B?MnFXc09POUtHelZyeVlhNms2Z3hJNmwxK0xUdG9iaUNlNXZTdWRaSXB4cnA1?=
 =?utf-8?B?ZngraVpYaTg2T2loanpLOEF2aW5DZVlidzNmZnplRldhNHBBM2RHb2k0MWh3?=
 =?utf-8?B?RGZWLzFrSGxmT2hqd1puazRtY3JwY0RNc21QL0Exb1JXMW1pa3p5dml4WjZP?=
 =?utf-8?B?VThud1RHTHBxNUdyZklMbUNzekFjdXdWNXZoYXZ2a2RUNTE5MFhtcHlRdW9n?=
 =?utf-8?B?Mk5ndG5TYVhkRnlTOUhCdDU4bFQyUjF1d0o0aXBibHVuSStxNS9qNGNhbU55?=
 =?utf-8?B?MXZXZ2VlUVk1aXJQZEVxNWJkd2ZDMWZmbzAxM0Z3cExaRW5BQ2gvWUVsaUFS?=
 =?utf-8?B?ekZRZVQ1NnZZYjlMUXFTdEJMOHY3RUNRYzFaUjVTbm55VlpSMkRtT29mR3Jv?=
 =?utf-8?B?NXdXNEh2eTQwVmpQbGJLOTRMajJOeDJxdkQxMWo2bW5nRDY2OGo3b2JSSUhr?=
 =?utf-8?B?T1o2UUFFK1hqODJrczl1OW5DWnpwZ1k4K1pmaGpxTmtSbjRzL2hlRExMZkla?=
 =?utf-8?B?c0Y1U2JTM3BhazJ1am5ablZqbWc2UXQxNXMvSXB5amJYRXR3dm9iWE1POFMr?=
 =?utf-8?B?cHprdGNOQmJmanowZ2xlWWQ3S0x1RTI3bWdHOHRuYnR1dVZYdzBsS2JHbExn?=
 =?utf-8?B?ZEZnOW1zWmJDZy9rQngyNVczNWdteGQ1L0ZxRFY3alNJVXZNdFBPc2lCN1Ry?=
 =?utf-8?B?RDA0T0NZTloxUHUzMGdBZnhTdFNSeXZnZjNsVEg5dkZzbEhBZGpKREdGUWpm?=
 =?utf-8?B?Z1Z3TnZSbWpYWGNUL0E4cnlMWVR0cUR1c0NFYkNuaVE0WHJGN2NCTG9qWHV3?=
 =?utf-8?B?bWRYcGtaeEx1TEFJbHZiYkJFeW1LUXVvUnkyVkRKdFc0L2MrRFltS2ZTZmQ1?=
 =?utf-8?B?Y1BUc3hqbXZlZFlPNmZNSnh3UGdEVk16ZWxVRzNpQXcwbTNmWWRKNGFKbzIx?=
 =?utf-8?B?VnB5dmNNcW8xbHdHVzRvNG1NMHFYV2hDakFxV1FDbEFCQWRobEh0dz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 879f2cf5-d23e-4c8d-e17c-08df46cb2249
X-MS-Exchange-CrossTenant-AuthSource: SA3PR12MB598757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2026 05:57:17.9772
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: r973mM4mJLEty5Snhsc0eur251/CQf74K+Lv9hJKx/9ymmuYzS3VsD8KBquXy00SI3owYMzvoGkbd6kNtQD+3w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7675

These exporters all keep one struct sg_table per attachment. It is
embedded in either attachment private data or allocated and cached
on first map. The same table is returned on every map_dma_buf()
and nothing is freed in unmap_dma_buf(). Instead the table is freed
during detach.

The private/cached struct sg_table becomes a struct dma_buf_sgt_mapping and
map_dma_buf() returns it every time. That is safe because the
core only fills in the mapping's header, and fills it identically for
every attachment map.

Co-developed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Alistair Popple <apopple@nvidia.com>
---
 drivers/dma-buf/heaps/cma_heap.c                   | 33 ++++++-----
 drivers/dma-buf/heaps/system_heap.c                | 34 ++++++-----
 .../media/common/videobuf2/videobuf2-dma-contig.c  | 34 +++++------
 drivers/media/common/videobuf2/videobuf2-dma-sg.c  | 33 ++++++-----
 drivers/media/common/videobuf2/videobuf2-vmalloc.c | 32 ++++++-----
 drivers/misc/fastrpc.c                             | 30 +++++-----
 drivers/tee/tee_heap.c                             | 28 ++++-----
 drivers/xen/gntdev-dmabuf.c                        | 67 ++++++++++++----------
 8 files changed, 158 insertions(+), 133 deletions(-)

diff --git a/drivers/dma-buf/heaps/cma_heap.c b/drivers/dma-buf/heaps/cma_heap.c
index 3fb4b946c91a..79bbb31e31cf 100644
--- a/drivers/dma-buf/heaps/cma_heap.c
+++ b/drivers/dma-buf/heaps/cma_heap.c
@@ -14,6 +14,7 @@
 
 #include <linux/cma.h>
 #include <linux/dma-buf.h>
+#include <linux/dma-buf-mapping.h>
 #include <linux/dma-heap.h>
 #include <linux/dma-map-ops.h>
 #include <linux/err.h>
@@ -48,7 +49,7 @@ struct cma_heap_buffer {
 
 struct dma_heap_attachment {
 	struct device *dev;
-	struct sg_table table;
+	struct dma_buf_sgt_mapping mapping;
 	struct list_head list;
 	bool mapped;
 };
@@ -64,7 +65,7 @@ static int cma_heap_attach(struct dma_buf *dmabuf,
 	if (!a)
 		return -ENOMEM;
 
-	ret = sg_alloc_table_from_pages(&a->table, buffer->pages,
+	ret = sg_alloc_table_from_pages(&a->mapping.sgt, buffer->pages,
 					buffer->pagecount, 0,
 					buffer->pagecount << PAGE_SHIFT,
 					GFP_KERNEL);
@@ -73,7 +74,7 @@ static int cma_heap_attach(struct dma_buf *dmabuf,
 		return ret;
 	}
 
-	a->dev = attachment->dev;
+	a->dev = dma_buf_sgt_dma_device(attachment);
 	INIT_LIST_HEAD(&a->list);
 	a->mapped = false;
 
@@ -96,32 +97,35 @@ static void cma_heap_detach(struct dma_buf *dmabuf,
 	list_del(&a->list);
 	mutex_unlock(&buffer->lock);
 
-	sg_free_table(&a->table);
+	sg_free_table(&a->mapping.sgt);
 	kfree(a);
 }
 
-static struct sg_table *cma_heap_map_dma_buf(struct dma_buf_attachment *attachment,
-					     enum dma_data_direction direction)
+static struct dma_buf_sgt_mapping *
+cma_heap_map_dma_buf(struct dma_buf_attachment *attachment,
+		     enum dma_data_direction direction)
 {
 	struct dma_heap_attachment *a = attachment->priv;
-	struct sg_table *table = &a->table;
+	struct sg_table *table = &a->mapping.sgt;
 	int ret;
 
-	ret = dma_map_sgtable(attachment->dev, table, direction, 0);
+	ret = dma_map_sgtable(dma_buf_sgt_dma_device(attachment), table,
+			      direction, 0);
 	if (ret)
 		return ERR_PTR(-ENOMEM);
 	a->mapped = true;
-	return table;
+	return &a->mapping;
 }
 
 static void cma_heap_unmap_dma_buf(struct dma_buf_attachment *attachment,
-				   struct sg_table *table,
+				   struct dma_buf_sgt_mapping *mapping,
 				   enum dma_data_direction direction)
 {
 	struct dma_heap_attachment *a = attachment->priv;
 
 	a->mapped = false;
-	dma_unmap_sgtable(attachment->dev, table, direction, 0);
+	dma_unmap_sgtable(dma_buf_sgt_mapping_dma_device(mapping),
+			  &mapping->sgt, direction, 0);
 }
 
 static int cma_heap_dma_buf_begin_cpu_access(struct dma_buf *dmabuf,
@@ -138,7 +142,7 @@ static int cma_heap_dma_buf_begin_cpu_access(struct dma_buf *dmabuf,
 	list_for_each_entry(a, &buffer->attachments, list) {
 		if (!a->mapped)
 			continue;
-		dma_sync_sgtable_for_cpu(a->dev, &a->table, direction);
+		dma_sync_sgtable_for_cpu(a->dev, &a->mapping.sgt, direction);
 	}
 	mutex_unlock(&buffer->lock);
 
@@ -159,7 +163,7 @@ static int cma_heap_dma_buf_end_cpu_access(struct dma_buf *dmabuf,
 	list_for_each_entry(a, &buffer->attachments, list) {
 		if (!a->mapped)
 			continue;
-		dma_sync_sgtable_for_device(a->dev, &a->table, direction);
+		dma_sync_sgtable_for_device(a->dev, &a->mapping.sgt, direction);
 	}
 	mutex_unlock(&buffer->lock);
 
@@ -268,14 +272,13 @@ static void cma_heap_dma_buf_release(struct dma_buf *dmabuf)
 static const struct dma_buf_ops cma_heap_buf_ops = {
 	.attach = cma_heap_attach,
 	.detach = cma_heap_detach,
-	.map_dma_buf = cma_heap_map_dma_buf,
-	.unmap_dma_buf = cma_heap_unmap_dma_buf,
 	.begin_cpu_access = cma_heap_dma_buf_begin_cpu_access,
 	.end_cpu_access = cma_heap_dma_buf_end_cpu_access,
 	.mmap = cma_heap_mmap,
 	.vmap = cma_heap_vmap,
 	.vunmap = cma_heap_vunmap,
 	.release = cma_heap_dma_buf_release,
+	DMA_BUF_SIMPLE_SGT_EXP_MATCH(cma_heap_map_dma_buf, cma_heap_unmap_dma_buf),
 };
 
 static struct dma_buf *cma_heap_allocate(struct dma_heap *heap,
diff --git a/drivers/dma-buf/heaps/system_heap.c b/drivers/dma-buf/heaps/system_heap.c
index c8959eadc71d..4c306f7fe506 100644
--- a/drivers/dma-buf/heaps/system_heap.c
+++ b/drivers/dma-buf/heaps/system_heap.c
@@ -12,6 +12,7 @@
 
 #include <linux/cc_platform.h>
 #include <linux/dma-buf.h>
+#include <linux/dma-buf-mapping.h>
 #include <linux/dma-mapping.h>
 #include <linux/dma-heap.h>
 #include <linux/err.h>
@@ -42,7 +43,7 @@ struct system_heap_buffer {
 
 struct dma_heap_attachment {
 	struct device *dev;
-	struct sg_table table;
+	struct dma_buf_sgt_mapping mapping;
 	struct list_head list;
 	bool mapped;
 	bool cc_shared;
@@ -122,13 +123,13 @@ static int system_heap_attach(struct dma_buf *dmabuf,
 	if (!a)
 		return -ENOMEM;
 
-	ret = dup_sg_table(&buffer->sg_table, &a->table);
+	ret = dup_sg_table(&buffer->sg_table, &a->mapping.sgt);
 	if (ret) {
 		kfree(a);
 		return ret;
 	}
 
-	a->dev = attachment->dev;
+	a->dev = dma_buf_sgt_dma_device(attachment);
 	INIT_LIST_HEAD(&a->list);
 	a->mapped = false;
 	a->cc_shared = buffer->cc_shared;
@@ -152,35 +153,38 @@ static void system_heap_detach(struct dma_buf *dmabuf,
 	list_del(&a->list);
 	mutex_unlock(&buffer->lock);
 
-	sg_free_table(&a->table);
+	sg_free_table(&a->mapping.sgt);
 	kfree(a);
 }
 
-static struct sg_table *system_heap_map_dma_buf(struct dma_buf_attachment *attachment,
-						enum dma_data_direction direction)
+static struct dma_buf_sgt_mapping *
+system_heap_map_dma_buf(struct dma_buf_attachment *attachment,
+			enum dma_data_direction direction)
 {
 	struct dma_heap_attachment *a = attachment->priv;
-	struct sg_table *table = &a->table;
+	struct sg_table *table = &a->mapping.sgt;
 	unsigned long attrs;
 	int ret;
 
 	attrs = cc_shared_buffer(a) ? DMA_ATTR_CC_SHARED : 0;
-	ret = dma_map_sgtable(attachment->dev, table, direction, attrs);
+	ret = dma_map_sgtable(dma_buf_sgt_dma_device(attachment), table,
+			      direction, attrs);
 	if (ret)
 		return ERR_PTR(ret);
 
 	a->mapped = true;
-	return table;
+	return &a->mapping;
 }
 
 static void system_heap_unmap_dma_buf(struct dma_buf_attachment *attachment,
-				      struct sg_table *table,
+				      struct dma_buf_sgt_mapping *mapping,
 				      enum dma_data_direction direction)
 {
 	struct dma_heap_attachment *a = attachment->priv;
 
 	a->mapped = false;
-	dma_unmap_sgtable(attachment->dev, table, direction, 0);
+	dma_unmap_sgtable(dma_buf_sgt_mapping_dma_device(mapping),
+			  &mapping->sgt, direction, 0);
 }
 
 static int system_heap_dma_buf_begin_cpu_access(struct dma_buf *dmabuf,
@@ -197,7 +201,7 @@ static int system_heap_dma_buf_begin_cpu_access(struct dma_buf *dmabuf,
 	list_for_each_entry(a, &buffer->attachments, list) {
 		if (!a->mapped)
 			continue;
-		dma_sync_sgtable_for_cpu(a->dev, &a->table, direction);
+		dma_sync_sgtable_for_cpu(a->dev, &a->mapping.sgt, direction);
 	}
 	mutex_unlock(&buffer->lock);
 
@@ -218,7 +222,7 @@ static int system_heap_dma_buf_end_cpu_access(struct dma_buf *dmabuf,
 	list_for_each_entry(a, &buffer->attachments, list) {
 		if (!a->mapped)
 			continue;
-		dma_sync_sgtable_for_device(a->dev, &a->table, direction);
+		dma_sync_sgtable_for_device(a->dev, &a->mapping.sgt, direction);
 	}
 	mutex_unlock(&buffer->lock);
 
@@ -365,14 +369,14 @@ static void system_heap_dma_buf_release(struct dma_buf *dmabuf)
 static const struct dma_buf_ops system_heap_buf_ops = {
 	.attach = system_heap_attach,
 	.detach = system_heap_detach,
-	.map_dma_buf = system_heap_map_dma_buf,
-	.unmap_dma_buf = system_heap_unmap_dma_buf,
 	.begin_cpu_access = system_heap_dma_buf_begin_cpu_access,
 	.end_cpu_access = system_heap_dma_buf_end_cpu_access,
 	.mmap = system_heap_mmap,
 	.vmap = system_heap_vmap,
 	.vunmap = system_heap_vunmap,
 	.release = system_heap_dma_buf_release,
+	DMA_BUF_SIMPLE_SGT_EXP_MATCH(system_heap_map_dma_buf,
+				     system_heap_unmap_dma_buf),
 };
 
 static struct page *alloc_largest_available(unsigned long size,
diff --git a/drivers/media/common/videobuf2/videobuf2-dma-contig.c b/drivers/media/common/videobuf2/videobuf2-dma-contig.c
index 284482335c1a..5f410c6c653d 100644
--- a/drivers/media/common/videobuf2/videobuf2-dma-contig.c
+++ b/drivers/media/common/videobuf2/videobuf2-dma-contig.c
@@ -11,6 +11,7 @@
  */
 
 #include <linux/dma-buf.h>
+#include <linux/dma-buf-mapping.h>
 #include <linux/module.h>
 #include <linux/refcount.h>
 #include <linux/scatterlist.h>
@@ -311,7 +312,7 @@ static int vb2_dc_mmap(void *buf_priv, struct vm_area_struct *vma)
 /*********************************************/
 
 struct vb2_dc_attachment {
-	struct sg_table sgt;
+	struct dma_buf_sgt_mapping mapping;
 	enum dma_data_direction dma_dir;
 };
 
@@ -329,7 +330,7 @@ static int vb2_dc_dmabuf_ops_attach(struct dma_buf *dbuf,
 	if (!attach)
 		return -ENOMEM;
 
-	sgt = &attach->sgt;
+	sgt = &attach->mapping.sgt;
 	/* Copy the buf->base_sgt scatter list to the attachment, as we can't
 	 * map the same scatter list to multiple attachments at the same time.
 	 */
@@ -362,7 +363,7 @@ static void vb2_dc_dmabuf_ops_detach(struct dma_buf *dbuf,
 	if (!attach)
 		return;
 
-	sgt = &attach->sgt;
+	sgt = &attach->mapping.sgt;
 
 	/* release the scatterlist cache */
 	if (attach->dma_dir != DMA_NONE)
@@ -372,28 +373,29 @@ static void vb2_dc_dmabuf_ops_detach(struct dma_buf *dbuf,
 		 * memory locations do not require any explicit cache
 		 * maintenance prior or after being used by the device.
 		 */
-		dma_unmap_sgtable(db_attach->dev, sgt, attach->dma_dir,
-				  DMA_ATTR_SKIP_CPU_SYNC);
+		dma_unmap_sgtable(dma_buf_sgt_dma_device(db_attach), sgt,
+				  attach->dma_dir, DMA_ATTR_SKIP_CPU_SYNC);
 	sg_free_table(sgt);
 	kfree(attach);
 	db_attach->priv = NULL;
 }
 
-static struct sg_table *vb2_dc_dmabuf_ops_map(
-	struct dma_buf_attachment *db_attach, enum dma_data_direction dma_dir)
+static struct dma_buf_sgt_mapping *
+vb2_dc_dmabuf_ops_map(struct dma_buf_attachment *db_attach,
+		      enum dma_data_direction dma_dir)
 {
 	struct vb2_dc_attachment *attach = db_attach->priv;
 	struct sg_table *sgt;
 
-	sgt = &attach->sgt;
+	sgt = &attach->mapping.sgt;
 	/* return previously mapped sg table */
 	if (attach->dma_dir == dma_dir)
-		return sgt;
+		return &attach->mapping;
 
 	/* release any previous cache */
 	if (attach->dma_dir != DMA_NONE) {
-		dma_unmap_sgtable(db_attach->dev, sgt, attach->dma_dir,
-				  DMA_ATTR_SKIP_CPU_SYNC);
+		dma_unmap_sgtable(dma_buf_sgt_dma_device(db_attach), sgt,
+				  attach->dma_dir, DMA_ATTR_SKIP_CPU_SYNC);
 		attach->dma_dir = DMA_NONE;
 	}
 
@@ -401,7 +403,7 @@ static struct sg_table *vb2_dc_dmabuf_ops_map(
 	 * mapping to the client with new direction, no cache sync
 	 * required see comment in vb2_dc_dmabuf_ops_detach()
 	 */
-	if (dma_map_sgtable(db_attach->dev, sgt, dma_dir,
+	if (dma_map_sgtable(dma_buf_sgt_dma_device(db_attach), sgt, dma_dir,
 			    DMA_ATTR_SKIP_CPU_SYNC)) {
 		pr_err("failed to map scatterlist\n");
 		return ERR_PTR(-EIO);
@@ -409,11 +411,11 @@ static struct sg_table *vb2_dc_dmabuf_ops_map(
 
 	attach->dma_dir = dma_dir;
 
-	return sgt;
+	return &attach->mapping;
 }
 
 static void vb2_dc_dmabuf_ops_unmap(struct dma_buf_attachment *db_attach,
-	struct sg_table *sgt, enum dma_data_direction dma_dir)
+	struct dma_buf_sgt_mapping *mapping, enum dma_data_direction dma_dir)
 {
 	/* nothing to be done here */
 }
@@ -462,13 +464,13 @@ static int vb2_dc_dmabuf_ops_mmap(struct dma_buf *dbuf,
 static const struct dma_buf_ops vb2_dc_dmabuf_ops = {
 	.attach = vb2_dc_dmabuf_ops_attach,
 	.detach = vb2_dc_dmabuf_ops_detach,
-	.map_dma_buf = vb2_dc_dmabuf_ops_map,
-	.unmap_dma_buf = vb2_dc_dmabuf_ops_unmap,
 	.begin_cpu_access = vb2_dc_dmabuf_ops_begin_cpu_access,
 	.end_cpu_access = vb2_dc_dmabuf_ops_end_cpu_access,
 	.vmap = vb2_dc_dmabuf_ops_vmap,
 	.mmap = vb2_dc_dmabuf_ops_mmap,
 	.release = vb2_dc_dmabuf_ops_release,
+	DMA_BUF_SIMPLE_SGT_EXP_MATCH(vb2_dc_dmabuf_ops_map,
+				     vb2_dc_dmabuf_ops_unmap),
 };
 
 static struct sg_table *vb2_dc_get_base_sgt(struct vb2_dc_buf *buf)
diff --git a/drivers/media/common/videobuf2/videobuf2-dma-sg.c b/drivers/media/common/videobuf2/videobuf2-dma-sg.c
index 54b07e3840ac..c00863ac0f88 100644
--- a/drivers/media/common/videobuf2/videobuf2-dma-sg.c
+++ b/drivers/media/common/videobuf2/videobuf2-dma-sg.c
@@ -10,6 +10,7 @@
  * the Free Software Foundation.
  */
 
+#include <linux/dma-buf-mapping.h>
 #include <linux/module.h>
 #include <linux/mm.h>
 #include <linux/refcount.h>
@@ -362,7 +363,7 @@ static int vb2_dma_sg_mmap(void *buf_priv, struct vm_area_struct *vma)
 /*********************************************/
 
 struct vb2_dma_sg_attachment {
-	struct sg_table sgt;
+	struct dma_buf_sgt_mapping mapping;
 	enum dma_data_direction dma_dir;
 };
 
@@ -380,7 +381,7 @@ static int vb2_dma_sg_dmabuf_ops_attach(struct dma_buf *dbuf,
 	if (!attach)
 		return -ENOMEM;
 
-	sgt = &attach->sgt;
+	sgt = &attach->mapping.sgt;
 	/* Copy the buf->base_sgt scatter list to the attachment, as we can't
 	 * map the same scatter list to multiple attachments at the same time.
 	 */
@@ -413,46 +414,50 @@ static void vb2_dma_sg_dmabuf_ops_detach(struct dma_buf *dbuf,
 	if (!attach)
 		return;
 
-	sgt = &attach->sgt;
+	sgt = &attach->mapping.sgt;
 
 	/* release the scatterlist cache */
 	if (attach->dma_dir != DMA_NONE)
-		dma_unmap_sgtable(db_attach->dev, sgt, attach->dma_dir, 0);
+		dma_unmap_sgtable(dma_buf_sgt_dma_device(db_attach), sgt,
+				  attach->dma_dir, 0);
 	sg_free_table(sgt);
 	kfree(attach);
 	db_attach->priv = NULL;
 }
 
-static struct sg_table *vb2_dma_sg_dmabuf_ops_map(
-	struct dma_buf_attachment *db_attach, enum dma_data_direction dma_dir)
+static struct dma_buf_sgt_mapping *
+vb2_dma_sg_dmabuf_ops_map(struct dma_buf_attachment *db_attach,
+			  enum dma_data_direction dma_dir)
 {
 	struct vb2_dma_sg_attachment *attach = db_attach->priv;
 	struct sg_table *sgt;
 
-	sgt = &attach->sgt;
+	sgt = &attach->mapping.sgt;
 	/* return previously mapped sg table */
 	if (attach->dma_dir == dma_dir)
-		return sgt;
+		return &attach->mapping;
 
 	/* release any previous cache */
 	if (attach->dma_dir != DMA_NONE) {
-		dma_unmap_sgtable(db_attach->dev, sgt, attach->dma_dir, 0);
+		dma_unmap_sgtable(dma_buf_sgt_dma_device(db_attach), sgt,
+				  attach->dma_dir, 0);
 		attach->dma_dir = DMA_NONE;
 	}
 
 	/* mapping to the client with new direction */
-	if (dma_map_sgtable(db_attach->dev, sgt, dma_dir, 0)) {
+	if (dma_map_sgtable(dma_buf_sgt_dma_device(db_attach), sgt, dma_dir,
+			    0)) {
 		pr_err("failed to map scatterlist\n");
 		return ERR_PTR(-EIO);
 	}
 
 	attach->dma_dir = dma_dir;
 
-	return sgt;
+	return &attach->mapping;
 }
 
 static void vb2_dma_sg_dmabuf_ops_unmap(struct dma_buf_attachment *db_attach,
-	struct sg_table *sgt, enum dma_data_direction dma_dir)
+	struct dma_buf_sgt_mapping *mapping, enum dma_data_direction dma_dir)
 {
 	/* nothing to be done here */
 }
@@ -510,13 +515,13 @@ static int vb2_dma_sg_dmabuf_ops_mmap(struct dma_buf *dbuf,
 static const struct dma_buf_ops vb2_dma_sg_dmabuf_ops = {
 	.attach = vb2_dma_sg_dmabuf_ops_attach,
 	.detach = vb2_dma_sg_dmabuf_ops_detach,
-	.map_dma_buf = vb2_dma_sg_dmabuf_ops_map,
-	.unmap_dma_buf = vb2_dma_sg_dmabuf_ops_unmap,
 	.begin_cpu_access = vb2_dma_sg_dmabuf_ops_begin_cpu_access,
 	.end_cpu_access = vb2_dma_sg_dmabuf_ops_end_cpu_access,
 	.vmap = vb2_dma_sg_dmabuf_ops_vmap,
 	.mmap = vb2_dma_sg_dmabuf_ops_mmap,
 	.release = vb2_dma_sg_dmabuf_ops_release,
+	DMA_BUF_SIMPLE_SGT_EXP_MATCH(vb2_dma_sg_dmabuf_ops_map,
+				     vb2_dma_sg_dmabuf_ops_unmap),
 };
 
 static struct dma_buf *vb2_dma_sg_get_dmabuf(struct vb2_buffer *vb,
diff --git a/drivers/media/common/videobuf2/videobuf2-vmalloc.c b/drivers/media/common/videobuf2/videobuf2-vmalloc.c
index 63f023696f3e..0c4d14fe62da 100644
--- a/drivers/media/common/videobuf2/videobuf2-vmalloc.c
+++ b/drivers/media/common/videobuf2/videobuf2-vmalloc.c
@@ -10,6 +10,7 @@
  * the Free Software Foundation.
  */
 
+#include <linux/dma-buf-mapping.h>
 #include <linux/io.h>
 #include <linux/module.h>
 #include <linux/mm.h>
@@ -205,7 +206,7 @@ static int vb2_vmalloc_mmap(void *buf_priv, struct vm_area_struct *vma)
 /*********************************************/
 
 struct vb2_vmalloc_attachment {
-	struct sg_table sgt;
+	struct dma_buf_sgt_mapping mapping;
 	enum dma_data_direction dma_dir;
 };
 
@@ -225,7 +226,7 @@ static int vb2_vmalloc_dmabuf_ops_attach(struct dma_buf *dbuf,
 	if (!attach)
 		return -ENOMEM;
 
-	sgt = &attach->sgt;
+	sgt = &attach->mapping.sgt;
 	ret = sg_alloc_table(sgt, num_pages, GFP_KERNEL);
 	if (ret) {
 		kfree(attach);
@@ -257,46 +258,49 @@ static void vb2_vmalloc_dmabuf_ops_detach(struct dma_buf *dbuf,
 	if (!attach)
 		return;
 
-	sgt = &attach->sgt;
+	sgt = &attach->mapping.sgt;
 
 	/* release the scatterlist cache */
 	if (attach->dma_dir != DMA_NONE)
-		dma_unmap_sgtable(db_attach->dev, sgt, attach->dma_dir, 0);
+		dma_unmap_sgtable(dma_buf_sgt_dma_device(db_attach), sgt,
+				  attach->dma_dir, 0);
 	sg_free_table(sgt);
 	kfree(attach);
 	db_attach->priv = NULL;
 }
 
-static struct sg_table *vb2_vmalloc_dmabuf_ops_map(
-	struct dma_buf_attachment *db_attach, enum dma_data_direction dma_dir)
+static struct dma_buf_sgt_mapping *
+vb2_vmalloc_dmabuf_ops_map(struct dma_buf_attachment *db_attach,
+			   enum dma_data_direction dma_dir)
 {
+	struct device *dma_dev = dma_buf_sgt_dma_device(db_attach);
 	struct vb2_vmalloc_attachment *attach = db_attach->priv;
 	struct sg_table *sgt;
 
-	sgt = &attach->sgt;
+	sgt = &attach->mapping.sgt;
 	/* return previously mapped sg table */
 	if (attach->dma_dir == dma_dir)
-		return sgt;
+		return &attach->mapping;
 
 	/* release any previous cache */
 	if (attach->dma_dir != DMA_NONE) {
-		dma_unmap_sgtable(db_attach->dev, sgt, attach->dma_dir, 0);
+		dma_unmap_sgtable(dma_dev, sgt, attach->dma_dir, 0);
 		attach->dma_dir = DMA_NONE;
 	}
 
 	/* mapping to the client with new direction */
-	if (dma_map_sgtable(db_attach->dev, sgt, dma_dir, 0)) {
+	if (dma_map_sgtable(dma_dev, sgt, dma_dir, 0)) {
 		pr_err("failed to map scatterlist\n");
 		return ERR_PTR(-EIO);
 	}
 
 	attach->dma_dir = dma_dir;
 
-	return sgt;
+	return &attach->mapping;
 }
 
 static void vb2_vmalloc_dmabuf_ops_unmap(struct dma_buf_attachment *db_attach,
-	struct sg_table *sgt, enum dma_data_direction dma_dir)
+	struct dma_buf_sgt_mapping *mapping, enum dma_data_direction dma_dir)
 {
 	/* nothing to be done here */
 }
@@ -326,11 +330,11 @@ static int vb2_vmalloc_dmabuf_ops_mmap(struct dma_buf *dbuf,
 static const struct dma_buf_ops vb2_vmalloc_dmabuf_ops = {
 	.attach = vb2_vmalloc_dmabuf_ops_attach,
 	.detach = vb2_vmalloc_dmabuf_ops_detach,
-	.map_dma_buf = vb2_vmalloc_dmabuf_ops_map,
-	.unmap_dma_buf = vb2_vmalloc_dmabuf_ops_unmap,
 	.vmap = vb2_vmalloc_dmabuf_ops_vmap,
 	.mmap = vb2_vmalloc_dmabuf_ops_mmap,
 	.release = vb2_vmalloc_dmabuf_ops_release,
+	DMA_BUF_SIMPLE_SGT_EXP_MATCH(vb2_vmalloc_dmabuf_ops_map,
+				     vb2_vmalloc_dmabuf_ops_unmap),
 };
 
 static struct dma_buf *vb2_vmalloc_get_dmabuf(struct vb2_buffer *vb,
diff --git a/drivers/misc/fastrpc.c b/drivers/misc/fastrpc.c
index 76c8dc05fa10..cbad55a93312 100644
--- a/drivers/misc/fastrpc.c
+++ b/drivers/misc/fastrpc.c
@@ -5,6 +5,7 @@
 #include <linux/completion.h>
 #include <linux/device.h>
 #include <linux/dma-buf.h>
+#include <linux/dma-buf-mapping.h>
 #include <linux/dma-mapping.h>
 #include <linux/dma-resv.h>
 #include <linux/idr.h>
@@ -234,7 +235,7 @@ struct fastrpc_buf {
 
 struct fastrpc_dma_buf_attachment {
 	struct device *dev;
-	struct sg_table sgt;
+	struct dma_buf_sgt_mapping mapping;
 	struct list_head node;
 };
 
@@ -770,27 +771,26 @@ static struct fastrpc_invoke_ctx *fastrpc_context_alloc(
 	return ERR_PTR(ret);
 }
 
-static struct sg_table *
+static struct dma_buf_sgt_mapping *
 fastrpc_map_dma_buf(struct dma_buf_attachment *attachment,
 		    enum dma_data_direction dir)
 {
 	struct fastrpc_dma_buf_attachment *a = attachment->priv;
-	struct sg_table *table;
 	int ret;
 
-	table = &a->sgt;
-
-	ret = dma_map_sgtable(attachment->dev, table, dir, 0);
+	ret = dma_map_sgtable(dma_buf_sgt_dma_device(attachment),
+			      &a->mapping.sgt, dir, 0);
 	if (ret)
-		table = ERR_PTR(ret);
-	return table;
+		return ERR_PTR(ret);
+	return &a->mapping;
 }
 
 static void fastrpc_unmap_dma_buf(struct dma_buf_attachment *attach,
-				  struct sg_table *table,
+				  struct dma_buf_sgt_mapping *mapping,
 				  enum dma_data_direction dir)
 {
-	dma_unmap_sgtable(attach->dev, table, dir, 0);
+	dma_unmap_sgtable(dma_buf_sgt_mapping_dma_device(mapping),
+			  &mapping->sgt, dir, 0);
 }
 
 static void fastrpc_release(struct dma_buf *dmabuf)
@@ -811,7 +811,7 @@ static int fastrpc_dma_buf_attach(struct dma_buf *dmabuf,
 	if (!a)
 		return -ENOMEM;
 
-	ret = dma_get_sgtable(buffer->dev, &a->sgt, buffer->virt,
+	ret = dma_get_sgtable(buffer->dev, &a->mapping.sgt, buffer->virt,
 			      fastrpc_ipa_to_dma_addr(buffer->fl->cctx, buffer->dma_addr),
 			      buffer->size);
 	if (ret < 0) {
@@ -820,7 +820,7 @@ static int fastrpc_dma_buf_attach(struct dma_buf *dmabuf,
 		return -EINVAL;
 	}
 
-	a->dev = attachment->dev;
+	a->dev = dma_buf_sgt_dma_device(attachment);
 	INIT_LIST_HEAD(&a->node);
 	attachment->priv = a;
 
@@ -840,7 +840,7 @@ static void fastrpc_dma_buf_detatch(struct dma_buf *dmabuf,
 	mutex_lock(&buffer->lock);
 	list_del(&a->node);
 	mutex_unlock(&buffer->lock);
-	sg_free_table(&a->sgt);
+	sg_free_table(&a->mapping.sgt);
 	kfree(a);
 }
 
@@ -868,11 +868,11 @@ static int fastrpc_mmap(struct dma_buf *dmabuf,
 static const struct dma_buf_ops fastrpc_dma_buf_ops = {
 	.attach = fastrpc_dma_buf_attach,
 	.detach = fastrpc_dma_buf_detatch,
-	.map_dma_buf = fastrpc_map_dma_buf,
-	.unmap_dma_buf = fastrpc_unmap_dma_buf,
 	.mmap = fastrpc_mmap,
 	.vmap = fastrpc_vmap,
 	.release = fastrpc_release,
+	DMA_BUF_SIMPLE_SGT_EXP_MATCH(fastrpc_map_dma_buf,
+				     fastrpc_unmap_dma_buf),
 };
 
 static dma_addr_t fastrpc_compute_dma_addr(struct fastrpc_user *fl, dma_addr_t sg_dma_addr)
diff --git a/drivers/tee/tee_heap.c b/drivers/tee/tee_heap.c
index 007c00156520..1d8a941891e9 100644
--- a/drivers/tee/tee_heap.c
+++ b/drivers/tee/tee_heap.c
@@ -4,6 +4,7 @@
  */
 
 #include <linux/dma-buf.h>
+#include <linux/dma-buf-mapping.h>
 #include <linux/dma-heap.h>
 #include <linux/genalloc.h>
 #include <linux/module.h>
@@ -33,7 +34,7 @@ struct tee_heap_buffer {
 };
 
 struct tee_heap_attachment {
-	struct sg_table table;
+	struct dma_buf_sgt_mapping mapping;
 	struct device *dev;
 };
 
@@ -98,13 +99,13 @@ static int tee_heap_attach(struct dma_buf *dmabuf,
 	if (!a)
 		return -ENOMEM;
 
-	ret = copy_sg_table(&a->table, &buf->table);
+	ret = copy_sg_table(&a->mapping.sgt, &buf->table);
 	if (ret) {
 		kfree(a);
 		return ret;
 	}
 
-	a->dev = attachment->dev;
+	a->dev = dma_buf_sgt_dma_device(attachment);
 	attachment->priv = a;
 
 	return 0;
@@ -115,35 +116,36 @@ static void tee_heap_detach(struct dma_buf *dmabuf,
 {
 	struct tee_heap_attachment *a = attachment->priv;
 
-	sg_free_table(&a->table);
+	sg_free_table(&a->mapping.sgt);
 	kfree(a);
 }
 
-static struct sg_table *
+static struct dma_buf_sgt_mapping *
 tee_heap_map_dma_buf(struct dma_buf_attachment *attachment,
 		     enum dma_data_direction direction)
 {
 	struct tee_heap_attachment *a = attachment->priv;
 	int ret;
 
-	ret = dma_map_sgtable(attachment->dev, &a->table, direction,
+	ret = dma_map_sgtable(dma_buf_sgt_dma_device(attachment),
+			      &a->mapping.sgt, direction,
 			      DMA_ATTR_SKIP_CPU_SYNC);
 	if (ret)
 		return ERR_PTR(ret);
 
-	return &a->table;
+	return &a->mapping;
 }
 
 static void tee_heap_unmap_dma_buf(struct dma_buf_attachment *attachment,
-				   struct sg_table *table,
+				   struct dma_buf_sgt_mapping *mapping,
 				   enum dma_data_direction direction)
 {
 	struct tee_heap_attachment *a = attachment->priv;
 
-	WARN_ON(&a->table != table);
+	WARN_ON(&a->mapping != mapping);
 
-	dma_unmap_sgtable(attachment->dev, table, direction,
-			  DMA_ATTR_SKIP_CPU_SYNC);
+	dma_unmap_sgtable(dma_buf_sgt_mapping_dma_device(mapping),
+			  &mapping->sgt, direction, DMA_ATTR_SKIP_CPU_SYNC);
 }
 
 static void tee_heap_buf_free(struct dma_buf *dmabuf)
@@ -160,9 +162,9 @@ static void tee_heap_buf_free(struct dma_buf *dmabuf)
 static const struct dma_buf_ops tee_heap_buf_ops = {
 	.attach = tee_heap_attach,
 	.detach = tee_heap_detach,
-	.map_dma_buf = tee_heap_map_dma_buf,
-	.unmap_dma_buf = tee_heap_unmap_dma_buf,
 	.release = tee_heap_buf_free,
+	DMA_BUF_SIMPLE_SGT_EXP_MATCH(tee_heap_map_dma_buf,
+				     tee_heap_unmap_dma_buf),
 };
 
 static struct dma_buf *tee_dma_heap_alloc(struct dma_heap *heap,
diff --git a/drivers/xen/gntdev-dmabuf.c b/drivers/xen/gntdev-dmabuf.c
index e07e34515421..62ec297355a1 100644
--- a/drivers/xen/gntdev-dmabuf.c
+++ b/drivers/xen/gntdev-dmabuf.c
@@ -11,6 +11,7 @@
 #include <linux/kernel.h>
 #include <linux/errno.h>
 #include <linux/dma-buf.h>
+#include <linux/dma-buf-mapping.h>
 #include <linux/dma-direct.h>
 #include <linux/slab.h>
 #include <linux/types.h>
@@ -62,7 +63,7 @@ struct gntdev_dmabuf_wait_obj {
 };
 
 struct gntdev_dmabuf_attachment {
-	struct sg_table *sgt;
+	struct dma_buf_sgt_mapping *mapping;
 	enum dma_data_direction dir;
 };
 
@@ -194,28 +195,28 @@ static int dmabuf_exp_wait_released(struct gntdev_dmabuf_priv *priv, int fd,
 
 /* DMA buffer export support. */
 
-static struct sg_table *
+static struct dma_buf_sgt_mapping *
 dmabuf_pages_to_sgt(struct page **pages, unsigned int nr_pages)
 {
-	struct sg_table *sgt;
+	struct dma_buf_sgt_mapping *mapping;
 	int ret;
 
-	sgt = kmalloc_obj(*sgt);
-	if (!sgt) {
+	mapping = kzalloc_obj(*mapping);
+	if (!mapping) {
 		ret = -ENOMEM;
 		goto out;
 	}
 
-	ret = sg_alloc_table_from_pages(sgt, pages, nr_pages, 0,
+	ret = sg_alloc_table_from_pages(&mapping->sgt, pages, nr_pages, 0,
 					nr_pages << PAGE_SHIFT,
 					GFP_KERNEL);
 	if (ret)
 		goto out;
 
-	return sgt;
+	return mapping;
 
 out:
-	kfree(sgt);
+	kfree(mapping);
 	return ERR_PTR(ret);
 }
 
@@ -239,39 +240,43 @@ static void dmabuf_exp_ops_detach(struct dma_buf *dma_buf,
 	struct gntdev_dmabuf_attachment *gntdev_dmabuf_attach = attach->priv;
 
 	if (gntdev_dmabuf_attach) {
-		struct sg_table *sgt = gntdev_dmabuf_attach->sgt;
+		struct dma_buf_sgt_mapping *mapping =
+			gntdev_dmabuf_attach->mapping;
+
+		if (mapping) {
+			struct device *dma_dev = dma_buf_sgt_dma_device(attach);
 
-		if (sgt) {
 			if (gntdev_dmabuf_attach->dir != DMA_NONE)
-				dma_unmap_sgtable(attach->dev, sgt,
+				dma_unmap_sgtable(dma_dev, &mapping->sgt,
 						  gntdev_dmabuf_attach->dir,
 						  DMA_ATTR_SKIP_CPU_SYNC);
-			sg_free_table(sgt);
+			sg_free_table(&mapping->sgt);
 		}
 
-		kfree(sgt);
+		kfree(mapping);
 		kfree(gntdev_dmabuf_attach);
 		attach->priv = NULL;
 	}
 }
 
-static struct sg_table *
+static struct dma_buf_sgt_mapping *
 dmabuf_exp_ops_map_dma_buf(struct dma_buf_attachment *attach,
 			   enum dma_data_direction dir)
 {
+	struct device *dma_dev = dma_buf_sgt_dma_device(attach);
 	struct gntdev_dmabuf_attachment *gntdev_dmabuf_attach = attach->priv;
 	struct gntdev_dmabuf *gntdev_dmabuf = attach->dmabuf->priv;
-	struct sg_table *sgt;
+	struct dma_buf_sgt_mapping *mapping;
 
 	pr_debug("Mapping %d pages for dev %p\n", gntdev_dmabuf->nr_pages,
-		 attach->dev);
+		 dma_dev);
 
 	if (dir == DMA_NONE || !gntdev_dmabuf_attach)
 		return ERR_PTR(-EINVAL);
 
 	/* Return the cached mapping when possible. */
 	if (gntdev_dmabuf_attach->dir == dir)
-		return gntdev_dmabuf_attach->sgt;
+		return gntdev_dmabuf_attach->mapping;
 
 	/*
 	 * Two mappings with different directions for the same attachment are
@@ -280,26 +285,26 @@ dmabuf_exp_ops_map_dma_buf(struct dma_buf_attachment *attach,
 	if (gntdev_dmabuf_attach->dir != DMA_NONE)
 		return ERR_PTR(-EBUSY);
 
-	sgt = dmabuf_pages_to_sgt(gntdev_dmabuf->pages,
-				  gntdev_dmabuf->nr_pages);
-	if (!IS_ERR(sgt)) {
-		if (dma_map_sgtable(attach->dev, sgt, dir,
+	mapping = dmabuf_pages_to_sgt(gntdev_dmabuf->pages,
+				      gntdev_dmabuf->nr_pages);
+	if (!IS_ERR(mapping)) {
+		if (dma_map_sgtable(dma_dev, &mapping->sgt, dir,
 				    DMA_ATTR_SKIP_CPU_SYNC)) {
-			sg_free_table(sgt);
-			kfree(sgt);
-			sgt = ERR_PTR(-ENOMEM);
+			sg_free_table(&mapping->sgt);
+			kfree(mapping);
+			mapping = ERR_PTR(-ENOMEM);
 		} else {
-			gntdev_dmabuf_attach->sgt = sgt;
+			gntdev_dmabuf_attach->mapping = mapping;
 			gntdev_dmabuf_attach->dir = dir;
 		}
 	}
-	if (IS_ERR(sgt))
-		pr_debug("Failed to map sg table for dev %p\n", attach->dev);
-	return sgt;
+	if (IS_ERR(mapping))
+		pr_debug("Failed to map sg table for dev %p\n", dma_dev);
+	return mapping;
 }
 
 static void dmabuf_exp_ops_unmap_dma_buf(struct dma_buf_attachment *attach,
-					 struct sg_table *sgt,
+					 struct dma_buf_sgt_mapping *mapping,
 					 enum dma_data_direction dir)
 {
 	/* Not implemented. The unmap is done at dmabuf_exp_ops_detach(). */
@@ -340,9 +345,9 @@ static void dmabuf_exp_ops_release(struct dma_buf *dma_buf)
 static const struct dma_buf_ops dmabuf_exp_ops =  {
 	.attach = dmabuf_exp_ops_attach,
 	.detach = dmabuf_exp_ops_detach,
-	.map_dma_buf = dmabuf_exp_ops_map_dma_buf,
-	.unmap_dma_buf = dmabuf_exp_ops_unmap_dma_buf,
 	.release = dmabuf_exp_ops_release,
+	DMA_BUF_SIMPLE_SGT_EXP_MATCH(dmabuf_exp_ops_map_dma_buf,
+				     dmabuf_exp_ops_unmap_dma_buf),
 };
 
 struct gntdev_dmabuf_export_args {

-- 
2.54.0

