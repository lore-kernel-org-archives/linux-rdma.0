Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.201.3
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795154235;
	b=pPf2QyadppOBtLOzeHkmjuOxT1kd/L3Y7tUNXZQZnLfVCNGNHlv1AP60cMTbQCyudd3f
	 WDn7L30e6DFMLaHIEBVCb7pM8AVOuynHPv5zQoDYg4xZ2u0aWujziW8VgcTPkRQOhF3cH
	 Cxn1F6gvYUILpCY+64Ktmg4iisPZsw0RDtnNwkIm0d6zCIA9RBGHLxuup2CKwLmnvx17T
	 6LBWEFfxTE84f80KOGK3mCDCGcauaqWACuoXhGRn/zxcedjr9hlfnxWOG/hvHODs/VeIQ
	 4ZMbLVvNEEEmk+Zz0K+w42iiGumTrJz4pDpuf2dn997tYVuxys0P4HBshgAcwQj6tew==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795154235;
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
	bh=4us7zo/2qO0MszWmdxtAB66H288lZ7SbVo4RaGOSPtA=;
	b=dXU85vMN/aEpO0BPgx+H83NZjk1f3/R9ErUtPR1/qIXt04JQKolHYnlGZmMwj6ALjG1E
	 54X7vLIu4Gb4FXP0hh6IjpizVAL1ZgILWvo1pM9k+yHxYeQG4kaXjXR7T/Ws/h3PC6bBw
	 XBMKGF39h6OifOHZtOiqHLKzlTTp7J5ykyIjCCdbhix6a32VichtMiYPd1fbaI1bzxBjo
	 ikRn+p5RE3V7ihJl5uIQFWIYBhEJT6vyf//mHm7yXiCPjECEiW+/DczjszPafwxSpWXvx
	 4Vb5qF37oT3C3GKXTP0fLthz5/Ah5DBvXUnYDQhUiMz9287mMw12AybPfx/ccj8+x2g==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b="igP/uaYQ";
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.201.3
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013003.outbound.protection.outlook.com [40.93.201.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB133606A33B;
	Fri, 20 Nov 2026 05:57:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BB133606A33B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=igP/uaYQ
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vuzVHXRx3NZPPP/XAZOjzwUZl6dTvm6zfdPJvuzcId+rojh8wE1GssMZeNMZ76kngWHPWG3d96Qqbt+aEPyb0Y8MN8og7/Yrv1gUbTOPFiKkYOvHTrzTow6JSN38CoVQhbXSKph6o+PTVZts0G73WiqA+MpyQvs7cqan5+RmjWeEBfwVac0dwSj5hm23ERjpCxtDkFTSwVBhDLOaDkW10i/BRgmnY6uqFtBCidbYfHu84lh1vbXzAU0eLfOIXCW9IsR25K/LbQlaQI+EeReN31nL26Z5mzMT9rNe04/vLN1e5WQiCq8r8rth+Y+VI9BZQF1BmoruGiH93lEEAYAzrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4us7zo/2qO0MszWmdxtAB66H288lZ7SbVo4RaGOSPtA=;
 b=eFT8XaAhN2nG5qlHzdLlvcst7qonUuie1FdWCs0gl0ZV4Hwt07upeqGhyiyYWlk0WPUGLPZXrOE1oPCPK5t0RCfszubRDCt6d/tFtXC8vHZcS0NnsBpKWwUwbyFYNeRR6cxjT1AdUkCR1z65HwjWeH2ToATbKaBmUmrEwOA8Q7Wz893mTm+WLroxO9zkiwGM6sjvgoklVqoTFJ+rf3pMLiSrt9yo2BerHystuAIQAy1Xgqp7XyQG24La92zijQvV1xKmrV1bvuP8OD+7gsa+VzOIk+uPr55mO5uIVwIAGv04u3KZigaqaGR8jMa5gNU3W1T8PggtxCI0OeM1wdli1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4us7zo/2qO0MszWmdxtAB66H288lZ7SbVo4RaGOSPtA=;
 b=igP/uaYQH1LeXgneKm0uyXxFvkbSBjpY5m9ApeBXPiId5CUlr3Vt/rfq3j8OEqi+MJA+uaKm0IGPHM32c6kZg8QIUO5KESPoTDBYbGbi8Z0BvntesyQ7qO3aMvEfx9O+rRThdx7AMPTXqNB0lDdaQpRtnFQ987eIGgDybTXipkx796VKVu7JhS0vJ7nfbn0zhupNQnjaag0zp+5NKeU3EuIwJ1bl4S8rm0H5SMmME5gZIrrhNCxfvSPmtERkwAPo5Hh9hIA2FAcTrg7/osLEDqcTH8N6bstb28hdbEQ8z7xPcu/Dc1M0D+1O0910OPq4Dd1fO1F+w5h34R1c5ZeD0w==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SA3PR12MB598757.namprd12.prod.outlook.com
 (2603:10b6:806:52d::14) by IA0PR12MB7675.namprd12.prod.outlook.com
 (2603:10b6:208:433::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Fri, 20 Nov
 2026 05:57:08 +0000
Received: from SA3PR12MB598757.namprd12.prod.outlook.com
 ([fe80::e206:100:5946:a777]) by SA3PR12MB598757.namprd12.prod.outlook.com
 ([fe80::e206:100:5946:a777%5]) with mapi id 15.21.0639.011; Fri, 20 Nov 2026
 05:57:08 +0000
From: Alistair Popple <apopple@nvidia.com>
Date: Fri, 20 Nov 2026 16:55:45 +1100
Subject: [PATCH v3 07/24] dma-buf: Convert exporters allocating a table per
 map to the SGT mapping type
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20261120-dma_mapping_type_v4-v3-7-c0183a409bdf@nvidia.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795154186; l=26650;
 i=apopple@nvidia.com; s=20261105; h=from:subject:message-id;
 bh=fRtXyG1RigGnE0OgMUH/fMpv1f406fqkaMAMBhmz6k8=;
 b=pwPU0OpZaijvjfTiNMQfRy7ES9YzWd5ibvd3SxI/+f8pJAVSxy70ICZrrcQiSD1e0htOLbcQB
 9BjIByTCRBdAcSa5JkbMvcvzLc9Z/lajIj2T9IXogSAUAN5gEei9Gqm
X-Developer-Key: i=apopple@nvidia.com; a=ed25519;
 pk=WdWPT9rAq3YNfXldbGv1NSGVLGxzQGFGJvRUiShhNqs=
X-ClientProxiedBy: SY6PR01CA0077.ausprd01.prod.outlook.com
 (2603:10c6:10:110::10) To SA3PR12MB598757.namprd12.prod.outlook.com
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
X-MS-Office365-Filtering-Correlation-Id: 378f32aa-da80-4076-793e-08df46cb1c6c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|7416014|366016|1800799024|921020|10067099003|11063799006|56012099006|261022113327099003|261021123027099003|261028144727099003|261022105027099003|261026121527099003|261026140227099003|261022075727099003|261021135927099003|261021121427099003|261102130727099003|261102123227099003|261009223027099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	uJYmT54Vh92rnab97LMjdXcaeF5Ylv5yHoHmKUhppumCnWsGca92Q++jofGfs3XRXg7dVB5EGaHrJHVpImYCeWQPWgxrqX4HbAyVEiv1CLbEbsMyf8m29FHvdXcyax/fA1ovVM9ZLsaMdXch2JgFs+MqHupBoOSSdfap2jLK4Z1OveB5H4iMP12TaWjmdfdZDNUo/Q9MigHdjjDqrAxoGvsFO0kAb1OLIKfbRp2ByO0dyZUmKcw2XcYiQkcqVhA4BcEdgr2QeKwSYSPcU4rmJPP6Iz7M2cXh/TVUfeSt9EYQ9lzErXLm4vJ+DWAwuesh0d8W8NokS4mzGsCPan/ybLv4l2UNAst2N7bA/K+0syKO0hqll6L6z9Vt+e2/hHj0CN+byXJNXlLNpV6KK6fnn4g/l3FO5tlcMS15+Dq6BefWtdTcCRVfc458bslAC3Y2UEJjjVxOYrkdlF3fn2naP6fgn5j1Su80/V1REWfaDuUH+niu15CeHHptnMgiyASjNWeC7HGbs7vt9QdAqSmDh0fQrWWfst7/HNtcqKJbeRm6N+1CRmsQkZ66HGjtFnMAIjM5dxRJOHEAS/4jhobPPIm7GnS/RL7qDuzBGHVRydSVahwWbj+tzghPM6nKo6l12AYHw6UqAa7Ypr9sOTtckxT9PKVxYEgBrG40P6pTiwyAy+wExPcscmaXG4hd4f7Zk7NQmrhibOAU4kyQZ7wFxA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA3PR12MB598757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(7416014)(366016)(1800799024)(921020)(10067099003)(11063799006)(56012099006)(261022113327099003)(261021123027099003)(261028144727099003)(261022105027099003)(261026121527099003)(261026140227099003)(261022075727099003)(261021135927099003)(261021121427099003)(261102130727099003)(261102123227099003)(261009223027099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RElZNmtYalRhOFl3d2RoVGxKb2g0UzRnemtDeUpaVlJLYkJMQnZiSVd1VVEw?=
 =?utf-8?B?ZVQrWHNoMkV4R3g0Vk5GNFY3MnBiTEUwZ2lsU3dtenFBWGtIOS9Od2VkRzd1?=
 =?utf-8?B?djdqZExRZDlMWFZNQTFpRldGWm8rV0tieTIvMU1NM0QrYmtPQ1hBalFXeUJk?=
 =?utf-8?B?YnZ1aEVoL0NWUDhaRWx1Nzd3cGIxQlF0clJpU0VNMGVmWVBLbWJEc2N2L1V1?=
 =?utf-8?B?TVhIajlWaDhLRCtqOWhiY0ZBck1wTCt5V1NxamNzdjNPcU9TYldPOHZqMmFa?=
 =?utf-8?B?akQ1akQvSW5KcHczNFBtZ2FxTm9xL0RGVnQrV1Z6QnFkL09mSVdTNHFWbGxa?=
 =?utf-8?B?VnFXTjZzNW1RMmpEQUVVZDA0R3FhQ1BqRE45TmtTLzZtSFR5VGNLZ2ZCSnhx?=
 =?utf-8?B?Z0xLOHVFZDNxUi9kdHRGK3E3YjRPWFA1UzI2UmtBVjlGbmZIVGhxWjh1MzFp?=
 =?utf-8?B?dGt5QUJpUWtDK2FMbTFScUcwRVpKN0s4OVdocmYxbFZBS3p3TkZFcFltQ0F4?=
 =?utf-8?B?b3VCNjlJbmFzOEhJNFhocGRmQTIwOWJnV1lWeWFsU2d2SzM5WjYrZlFQMWVJ?=
 =?utf-8?B?WnU2TUNIeFVPYUd2amR5UkNwb0JrNHJGdURtSThGRjVVdjBySXd5SFQ2NlJi?=
 =?utf-8?B?ajJPU2hVUmdyZFV5cHRvTVB0T0ZGekRLMHVENDNjdW9ZRG9pYXA5V3ZXSURk?=
 =?utf-8?B?NUthTS8zRUlsVk8vRG1nSE5KcDhaaUYwdk5sS2tFOHI3cTA1VXhIK1dQUnVG?=
 =?utf-8?B?bFVpSFN2MldJSGorTkZiMFJSQUsvYnlLUklwQXQ0WVM2NVUrWEtGRTdrNWFJ?=
 =?utf-8?B?cGRnbG9YQUF2Yloybi9LbHF0aEVUdWx6cWxRSFFwcit3TUVrWXF0bDI3NGtO?=
 =?utf-8?B?UytqMzBmblJmVElLZHlWL0c0T0R4d0w4ejUzaDNpL1Qza0tNM0RwMHJEMkF1?=
 =?utf-8?B?dFlZOGdUV3pRbHNCVTJreVY4cHhGZmJwL0czT3A5ZHVvWlZwMVpzUEZyZmlK?=
 =?utf-8?B?WDJWc0VKdS9RQWZLRnlQSWY0ak9obllGMHRETEhmMndVZFp1MWJpcGFya2dW?=
 =?utf-8?B?VVBiTFI5Wk9jZzhrOGpDYjZ6Z3VpOVVvQWJYc21OaXliUW1hRE00QU5sa3dV?=
 =?utf-8?B?aWpNZHk0THhJbmxXOXVMRC8rRFlDdExvdDBMN3ZnR3hmVWZkd3JrZGlWdisv?=
 =?utf-8?B?azBLdnBZdldtZ1V0WEZlVDdES1FNQlVkMDJQdW1xZmgwOHhHM1E1QjFoeW92?=
 =?utf-8?B?Z2FHNWEwdERnNWRoVEx3MjVwTzVNenFKdnJmM3lNYy96dU50aU5BY05YZnNU?=
 =?utf-8?B?dlEyTEcwUVVRbi9ITDFmRFJXc0ZYS0pXYUFaKy9DZGovVHBnbVZMUzEyUEV4?=
 =?utf-8?B?b3hrQ2t6MmkyVWhXbW1lZk5kbEhYdWxTWlVWKzFDVWI0MUx3U09DZlJGY2Zk?=
 =?utf-8?B?VlEyUFIwOHk0WWU3c2tDc3pMaktuUmR3RjVhL0pvZ0NTRDJJRTJCQ2JsSWFW?=
 =?utf-8?B?S1czSzlOaE9RQjVVbmpJZ1lrd0hZVmRvMWtyMjg4YXRQanZEZzdCeG1YS1ZR?=
 =?utf-8?B?Mmw1ZEdINndacnlJODZHU0xwQXdEakl1WmVXd21kV1dydjFPaWVsWjlmdlJU?=
 =?utf-8?B?UjBscEdvVFh3VGJ5ZnlTeVZRSmN5NXluOXdkMTBBTXJoZlpPSTJnUndyS3c3?=
 =?utf-8?B?TTBndjhrRnJaNE1pV05FNGNTUGtSMkhsdlJmVEdwdmsxZVZpeFI4YzRZRy9i?=
 =?utf-8?B?MHlaN3hLcERjUnhKR3lnRkduam5qNUhqZHJKVWhqZXlrOTlLYTlGYitKTFFM?=
 =?utf-8?B?cDdaSDAvdGZpaEhXbm1FVHhsQUpnT0txa1hmRHJmOUZPaDBFVW4vRDhxbDFO?=
 =?utf-8?B?VmdkdzRSMWVXNitzclptYVlkZkNGNUtlWFcxSjMwVjdZeHR1YkNoOUFOd1JO?=
 =?utf-8?B?WG5iQWRteXdNa0hjOEhwQ1NGcFRhclpsQk0zRGZobWNyV3IyZ0FySEdzM0Ny?=
 =?utf-8?B?TGVUeFp6ZERvWUNhb3RRY2UxVXMxUlNkRGpETHdTMWphN3Jvd05PMXg0cks2?=
 =?utf-8?B?WUt0cG5lcFFjYStnREJQWWRBYXNyeDQzN3V5L09LMFlmRXpIemg5K2hLYUF3?=
 =?utf-8?B?bWJCZnpwRjRsMFVoblJZZi9paFlsNU5DeXhjQVJBc214UVEwN3FabFAxOFM3?=
 =?utf-8?B?cTRNMi9oS0cwUE8zcTY3UWxLVUo0M2RJRzFkcXVLcklSK3dRcjhLOE5wd0pN?=
 =?utf-8?B?RGVLQnhMbnl6UGpjSWt5UEQ0ZHNORzlQVWlXTTFsUkc2Tnk4MnN4bkZSSUJ3?=
 =?utf-8?B?aFdmL3dZMTMzUEVNYVNLRCtqUEVqakxIQnJTeTBFQ2FqTU5IY2Fsdz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 378f32aa-da80-4076-793e-08df46cb1c6c
X-MS-Exchange-CrossTenant-AuthSource: SA3PR12MB598757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2026 05:57:08.1350
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FicN62g7ZegxQb2M/AW6dK/4c+tH/ZJE21VDSos0OWZ0H4dOgf3w6q/5vFGVxkEn9YLp1JSOxRsC0tyFHyUFBA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7675

These exporters allocate a struct sg_table in map_dma_buf() and free
it again in unmap_dma_buf().

The conversion is mechanical and no behaviour change is expected.
Instead of map_dma_buf() allocating a sg_table it instead allocates and
returns a dma_buf_sgt_mapping, which the unmap callbacks also take.

As a side effect this fixes a leak in fsl_asrc_m2m. Its unmap_dma_buf()
only DMA unmapped the per-map table and never freed it. It now frees the
mapping including the table.

Co-developed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Alistair Popple <apopple@nvidia.com>
---
 drivers/accel/amdxdna/amdxdna_cbuf.c             | 30 ++++++++------
 drivers/accel/amdxdna/amdxdna_ubuf.c             | 34 +++++++++-------
 drivers/accel/habanalabs/common/memory.c         | 52 +++++++++++++-----------
 drivers/gpu/drm/armada/armada_gem.c              | 36 +++++++++-------
 drivers/gpu/drm/i915/gem/selftests/mock_dmabuf.c | 30 ++++++++------
 drivers/gpu/drm/tegra/gem.c                      | 30 ++++++++------
 samples/vfio-mdev/mbochs.c                       | 31 ++++++++------
 sound/soc/fsl/fsl_asrc_m2m.c                     | 32 +++++++++------
 8 files changed, 161 insertions(+), 114 deletions(-)

diff --git a/drivers/accel/amdxdna/amdxdna_cbuf.c b/drivers/accel/amdxdna/amdxdna_cbuf.c
index a504560aae98..945436516cc6 100644
--- a/drivers/accel/amdxdna/amdxdna_cbuf.c
+++ b/drivers/accel/amdxdna/amdxdna_cbuf.c
@@ -5,6 +5,7 @@
 
 #include <drm/drm_mm.h>
 #include <drm/drm_prime.h>
+#include <linux/dma-buf-mapping.h>
 
 #include "amdxdna_cbuf.h"
 #include "amdxdna_pci_drv.h"
@@ -81,11 +82,13 @@ struct amdxdna_cbuf_priv {
 	struct drm_mm_node node;
 };
 
-static struct sg_table *amdxdna_cbuf_map(struct dma_buf_attachment *attach,
-					 enum dma_data_direction direction)
+static struct dma_buf_sgt_mapping *
+amdxdna_cbuf_map(struct dma_buf_attachment *attach,
+		 enum dma_data_direction direction)
 {
 	struct amdxdna_cbuf_priv *cbuf = attach->dmabuf->priv;
-	struct device *dev = attach->dev;
+	struct device *dev = dma_buf_sgt_dma_device(attach);
+	struct dma_buf_sgt_mapping *mapping;
 	struct scatterlist *sgl, *sg;
 	int ret, n_entries, i;
 	struct sg_table *sgt;
@@ -93,9 +96,10 @@ static struct sg_table *amdxdna_cbuf_map(struct dma_buf_attachment *attach,
 	size_t dma_size;
 	size_t max_seg;
 
-	sgt = kzalloc_obj(*sgt);
-	if (!sgt)
+	mapping = kzalloc_obj(*mapping);
+	if (!mapping)
 		return ERR_PTR(-ENOMEM);
+	sgt = &mapping->sgt;
 
 	max_seg = min_t(size_t, UINT_MAX, dma_max_mapping_size(dev));
 	n_entries = (cbuf->node.size + max_seg - 1) / max_seg;
@@ -127,24 +131,27 @@ static struct sg_table *amdxdna_cbuf_map(struct dma_buf_attachment *attach,
 		dma_size -= len;
 	}
 
-	return sgt;
+	return mapping;
 
 free_sgl:
 	kfree(sgl);
 free_sgt:
-	kfree(sgt);
+	kfree(mapping);
 	return ERR_PTR(ret);
 }
 
 static void amdxdna_cbuf_unmap(struct dma_buf_attachment *attach,
-			       struct sg_table *sgt,
+			       struct dma_buf_sgt_mapping *mapping,
 			       enum dma_data_direction direction)
 {
-	dma_unmap_resource(attach->dev, sg_dma_address(sgt->sgl),
+	struct sg_table *sgt = &mapping->sgt;
+
+	dma_unmap_resource(dma_buf_sgt_mapping_dma_device(mapping),
+			   sg_dma_address(sgt->sgl),
 			   drm_prime_get_contiguous_size(sgt), direction,
 			   DMA_ATTR_SKIP_CPU_SYNC);
 	sg_free_table(sgt);
-	kfree(sgt);
+	kfree(mapping);
 }
 
 static void amdxdna_cbuf_release(struct dma_buf *dbuf)
@@ -210,12 +217,11 @@ static void amdxdna_cbuf_vunmap(struct dma_buf *dbuf, struct iosys_map *map)
 }
 
 static const struct dma_buf_ops amdxdna_cbuf_dmabuf_ops = {
-	.map_dma_buf = amdxdna_cbuf_map,
-	.unmap_dma_buf = amdxdna_cbuf_unmap,
 	.release = amdxdna_cbuf_release,
 	.mmap = amdxdna_cbuf_mmap,
 	.vmap = amdxdna_cbuf_vmap,
 	.vunmap = amdxdna_cbuf_vunmap,
+	DMA_BUF_SIMPLE_SGT_EXP_MATCH(amdxdna_cbuf_map, amdxdna_cbuf_unmap),
 };
 
 static int amdxdna_cbuf_clear(struct dma_buf *dbuf)
diff --git a/drivers/accel/amdxdna/amdxdna_ubuf.c b/drivers/accel/amdxdna/amdxdna_ubuf.c
index 0e0cd69cd1fb..ed8b0ab9e554 100644
--- a/drivers/accel/amdxdna/amdxdna_ubuf.c
+++ b/drivers/accel/amdxdna/amdxdna_ubuf.c
@@ -7,6 +7,7 @@
 #include <drm/drm_device.h>
 #include <drm/drm_print.h>
 #include <linux/dma-buf.h>
+#include <linux/dma-buf-mapping.h>
 #include <linux/overflow.h>
 #include <linux/pagemap.h>
 #include <linux/vmalloc.h>
@@ -20,42 +21,48 @@ struct amdxdna_ubuf_priv {
 	struct mm_struct *mm;
 };
 
-static struct sg_table *amdxdna_ubuf_map(struct dma_buf_attachment *attach,
-					 enum dma_data_direction direction)
+static struct dma_buf_sgt_mapping *
+amdxdna_ubuf_map(struct dma_buf_attachment *attach,
+		 enum dma_data_direction direction)
 {
 	struct amdxdna_ubuf_priv *ubuf = attach->dmabuf->priv;
+	struct dma_buf_sgt_mapping *mapping;
 	struct sg_table *sg;
 	int ret;
 
-	sg = kzalloc_obj(*sg);
-	if (!sg)
+	mapping = kzalloc_obj(*mapping);
+	if (!mapping)
 		return ERR_PTR(-ENOMEM);
+	sg = &mapping->sgt;
 
 	ret = sg_alloc_table_from_pages(sg, ubuf->pages, ubuf->nr_pages, 0,
 					ubuf->nr_pages << PAGE_SHIFT, GFP_KERNEL);
 	if (ret)
-		goto err_free_sg;
+		goto err_free_mapping;
 
-	ret = dma_map_sgtable(attach->dev, sg, direction, 0);
+	ret = dma_map_sgtable(dma_buf_sgt_dma_device(attach), sg, direction, 0);
 	if (ret)
 		goto err_free_table;
 
-	return sg;
+	return mapping;
 
 err_free_table:
 	sg_free_table(sg);
-err_free_sg:
-	kfree(sg);
+err_free_mapping:
+	kfree(mapping);
 	return ERR_PTR(ret);
 }
 
 static void amdxdna_ubuf_unmap(struct dma_buf_attachment *attach,
-			       struct sg_table *sg,
+			       struct dma_buf_sgt_mapping *mapping,
 			       enum dma_data_direction direction)
 {
-	dma_unmap_sgtable(attach->dev, sg, direction, 0);
+	struct sg_table *sg = &mapping->sgt;
+
+	dma_unmap_sgtable(dma_buf_sgt_mapping_dma_device(mapping), sg,
+			  direction, 0);
 	sg_free_table(sg);
-	kfree(sg);
+	kfree(mapping);
 }
 
 static void amdxdna_ubuf_release(struct dma_buf *dbuf)
@@ -70,9 +77,8 @@ static void amdxdna_ubuf_release(struct dma_buf *dbuf)
 }
 
 static const struct dma_buf_ops amdxdna_ubuf_dmabuf_ops = {
-	.map_dma_buf = amdxdna_ubuf_map,
-	.unmap_dma_buf = amdxdna_ubuf_unmap,
 	.release = amdxdna_ubuf_release,
+	DMA_BUF_SIMPLE_SGT_EXP_MATCH(amdxdna_ubuf_map, amdxdna_ubuf_unmap),
 };
 
 struct dma_buf *amdxdna_get_ubuf(struct drm_device *dev,
diff --git a/drivers/accel/habanalabs/common/memory.c b/drivers/accel/habanalabs/common/memory.c
index 361cff577381..fc39ccd6f8db 100644
--- a/drivers/accel/habanalabs/common/memory.c
+++ b/drivers/accel/habanalabs/common/memory.c
@@ -9,6 +9,7 @@
 #include "habanalabs.h"
 #include "../include/hw_ip/mmu/mmu_general.h"
 
+#include <linux/dma-buf-mapping.h>
 #include <linux/uaccess.h>
 #include <linux/slab.h>
 #include <linux/vmalloc.h>
@@ -1531,13 +1532,15 @@ static int set_dma_sg(struct scatterlist *sg, u64 bar_address, u64 chunk_size,
 	return 0;
 }
 
-static struct sg_table *alloc_sgt_from_device_pages(struct hl_device *hdev, u64 *pages, u64 npages,
-						u64 page_size, u64 exported_size, u64 offset,
-						struct device *dev, enum dma_data_direction dir)
+static struct dma_buf_sgt_mapping *
+alloc_sgt_from_device_pages(struct hl_device *hdev, u64 *pages, u64 npages, u64 page_size,
+			    u64 exported_size, u64 offset, struct device *dev,
+			    enum dma_data_direction dir)
 {
 	u64 dma_max_seg_size, curr_page, size, chunk_size, left_size_to_export, left_size_in_page,
 		left_size_in_dma_seg, device_address, bar_address, start_page;
 	struct asic_fixed_properties *prop = &hdev->asic_prop;
+	struct dma_buf_sgt_mapping *mapping;
 	struct scatterlist *sg;
 	unsigned int nents, i;
 	struct sg_table *sgt;
@@ -1553,9 +1556,10 @@ static struct sg_table *alloc_sgt_from_device_pages(struct hl_device *hdev, u64
 		return ERR_PTR(-EINVAL);
 	}
 
-	sgt = kzalloc_obj(*sgt);
-	if (!sgt)
+	mapping = kzalloc_obj(*mapping);
+	if (!mapping)
 		return ERR_PTR(-ENOMEM);
+	sgt = &mapping->sgt;
 
 	/* Use the offset to move to the actual first page that is exported */
 	for (start_page = 0 ; start_page < npages ; ++start_page) {
@@ -1686,7 +1690,7 @@ static struct sg_table *alloc_sgt_from_device_pages(struct hl_device *hdev, u64
 			"SG entry %d: address %#llx, length %#x\n",
 			i, sg_dma_address(sg), sg_dma_len(sg));
 
-	return sgt;
+	return mapping;
 
 err_unmap:
 	for_each_sgtable_dma_sg(sgt, sg, i) {
@@ -1700,7 +1704,7 @@ static struct sg_table *alloc_sgt_from_device_pages(struct hl_device *hdev, u64
 	sg_free_table(sgt);
 
 err_free_sgt:
-	kfree(sgt);
+	kfree(mapping);
 	return ERR_PTR(rc);
 }
 
@@ -1714,22 +1718,22 @@ static int hl_dmabuf_attach(struct dma_buf *dmabuf,
 	hl_dmabuf = dmabuf->priv;
 	hdev = hl_dmabuf->ctx->hdev;
 
-	rc = pci_p2pdma_distance(hdev->pdev, attachment->dev, true);
+	rc = pci_p2pdma_distance(hdev->pdev, dma_buf_sgt_dma_device(attachment), true);
 
 	if (rc < 0)
 		attachment->peer2peer = false;
 	return 0;
 }
 
-static struct sg_table *hl_map_dmabuf(struct dma_buf_attachment *attachment,
-					enum dma_data_direction dir)
+static struct dma_buf_sgt_mapping *
+hl_map_dmabuf(struct dma_buf_attachment *attachment, enum dma_data_direction dir)
 {
 	u64 *pages, npages, page_size, exported_size, offset;
 	struct dma_buf *dma_buf = attachment->dmabuf;
 	struct hl_vm_phys_pg_pack *phys_pg_pack;
+	struct dma_buf_sgt_mapping *mapping;
 	struct hl_dmabuf_priv *hl_dmabuf;
 	struct hl_device *hdev;
-	struct sg_table *sgt;
 
 	hl_dmabuf = dma_buf->priv;
 	hdev = hl_dmabuf->ctx->hdev;
@@ -1753,18 +1757,21 @@ static struct sg_table *hl_map_dmabuf(struct dma_buf_attachment *attachment,
 		page_size = hl_dmabuf->dmabuf->size;
 	}
 
-	sgt = alloc_sgt_from_device_pages(hdev, pages, npages, page_size, exported_size, offset,
-						attachment->dev, dir);
-	if (IS_ERR(sgt))
-		dev_err(hdev->dev, "failed (%ld) to initialize sgt for dmabuf\n", PTR_ERR(sgt));
+	mapping = alloc_sgt_from_device_pages(hdev, pages, npages, page_size,
+					      exported_size, offset,
+					      dma_buf_sgt_dma_device(attachment),
+					      dir);
+	if (IS_ERR(mapping))
+		dev_err(hdev->dev, "failed (%ld) to initialize sgt for dmabuf\n", PTR_ERR(mapping));
 
-	return sgt;
+	return mapping;
 }
 
 static void hl_unmap_dmabuf(struct dma_buf_attachment *attachment,
-				  struct sg_table *sgt,
+				  struct dma_buf_sgt_mapping *mapping,
 				  enum dma_data_direction dir)
 {
+	struct sg_table *sgt = &mapping->sgt;
 	struct scatterlist *sg;
 	int i;
 
@@ -1776,14 +1783,14 @@ static void hl_unmap_dmabuf(struct dma_buf_attachment *attachment,
 	 * a sync of the memory to the CPU's cache, as it never resided inside that cache.
 	 */
 	for_each_sgtable_dma_sg(sgt, sg, i)
-		dma_unmap_resource(attachment->dev, sg_dma_address(sg),
-					sg_dma_len(sg), dir,
-					DMA_ATTR_SKIP_CPU_SYNC);
+		dma_unmap_resource(dma_buf_sgt_mapping_dma_device(mapping),
+				   sg_dma_address(sg), sg_dma_len(sg), dir,
+				   DMA_ATTR_SKIP_CPU_SYNC);
 
 	/* Need to restore orig_nents because sg_free_table use that field */
 	sgt->orig_nents = sgt->nents;
 	sg_free_table(sgt);
-	kfree(sgt);
+	kfree(mapping);
 }
 
 static struct hl_vm_hash_node *memhash_node_export_get(struct hl_ctx *ctx, u64 addr)
@@ -1850,9 +1857,8 @@ static void hl_release_dmabuf(struct dma_buf *dmabuf)
 
 static const struct dma_buf_ops habanalabs_dmabuf_ops = {
 	.attach = hl_dmabuf_attach,
-	.map_dma_buf = hl_map_dmabuf,
-	.unmap_dma_buf = hl_unmap_dmabuf,
 	.release = hl_release_dmabuf,
+	DMA_BUF_SIMPLE_SGT_EXP_MATCH(hl_map_dmabuf, hl_unmap_dmabuf),
 };
 
 static int export_dmabuf(struct hl_ctx *ctx,
diff --git a/drivers/gpu/drm/armada/armada_gem.c b/drivers/gpu/drm/armada/armada_gem.c
index 044acdef6351..1eff00567386 100644
--- a/drivers/gpu/drm/armada/armada_gem.c
+++ b/drivers/gpu/drm/armada/armada_gem.c
@@ -4,6 +4,7 @@
  */
 
 #include <linux/dma-buf.h>
+#include <linux/dma-buf-mapping.h>
 #include <linux/dma-mapping.h>
 #include <linux/mman.h>
 #include <linux/shmem_fs.h>
@@ -383,41 +384,44 @@ int armada_gem_pwrite_ioctl(struct drm_device *dev, void *data,
 }
 
 /* Prime support */
-static struct sg_table *
+static struct dma_buf_sgt_mapping *
 armada_gem_prime_map_dma_buf(struct dma_buf_attachment *attach,
 	enum dma_data_direction dir)
 {
+	struct device *dma_dev = dma_buf_sgt_dma_device(attach);
 	struct drm_gem_object *obj = attach->dmabuf->priv;
 	struct armada_gem_object *dobj = drm_to_armada_gem(obj);
+	struct dma_buf_sgt_mapping *mapping;
 	struct scatterlist *sg;
 	struct sg_table *sgt;
 	int i;
 
-	sgt = kmalloc_obj(*sgt);
-	if (!sgt)
+	mapping = kzalloc_obj(*mapping);
+	if (!mapping)
 		return NULL;
+	sgt = &mapping->sgt;
 
 	if (dobj->obj.filp) {
-		struct address_space *mapping;
+		struct address_space *file_mapping;
 		int count;
 
 		count = dobj->obj.size / PAGE_SIZE;
 		if (sg_alloc_table(sgt, count, GFP_KERNEL))
 			goto free_sgt;
 
-		mapping = dobj->obj.filp->f_mapping;
+		file_mapping = dobj->obj.filp->f_mapping;
 
 		for_each_sgtable_sg(sgt, sg, i) {
 			struct page *page;
 
-			page = shmem_read_mapping_page(mapping, i);
+			page = shmem_read_mapping_page(file_mapping, i);
 			if (IS_ERR(page))
 				goto release;
 
 			sg_set_page(sg, page, PAGE_SIZE, 0);
 		}
 
-		if (dma_map_sgtable(attach->dev, sgt, dir, 0))
+		if (dma_map_sgtable(dma_dev, sgt, dir, 0))
 			goto release;
 	} else if (dobj->page) {
 		/* Single contiguous page */
@@ -426,7 +430,7 @@ armada_gem_prime_map_dma_buf(struct dma_buf_attachment *attach,
 
 		sg_set_page(sgt->sgl, dobj->page, dobj->obj.size, 0);
 
-		if (dma_map_sgtable(attach->dev, sgt, dir, 0))
+		if (dma_map_sgtable(dma_dev, sgt, dir, 0))
 			goto free_table;
 	} else if (dobj->linear) {
 		/* Single contiguous physical region - no struct page */
@@ -437,7 +441,7 @@ armada_gem_prime_map_dma_buf(struct dma_buf_attachment *attach,
 	} else {
 		goto free_sgt;
 	}
-	return sgt;
+	return mapping;
 
  release:
 	for_each_sgtable_sg(sgt, sg, i)
@@ -446,19 +450,21 @@ armada_gem_prime_map_dma_buf(struct dma_buf_attachment *attach,
  free_table:
 	sg_free_table(sgt);
  free_sgt:
-	kfree(sgt);
+	kfree(mapping);
 	return NULL;
 }
 
 static void armada_gem_prime_unmap_dma_buf(struct dma_buf_attachment *attach,
-	struct sg_table *sgt, enum dma_data_direction dir)
+	struct dma_buf_sgt_mapping *mapping, enum dma_data_direction dir)
 {
 	struct drm_gem_object *obj = attach->dmabuf->priv;
 	struct armada_gem_object *dobj = drm_to_armada_gem(obj);
+	struct sg_table *sgt = &mapping->sgt;
 	int i;
 
 	if (!dobj->linear)
-		dma_unmap_sgtable(attach->dev, sgt, dir, 0);
+		dma_unmap_sgtable(dma_buf_sgt_mapping_dma_device(mapping), sgt,
+				  dir, 0);
 
 	if (dobj->obj.filp) {
 		struct scatterlist *sg;
@@ -468,7 +474,7 @@ static void armada_gem_prime_unmap_dma_buf(struct dma_buf_attachment *attach,
 	}
 
 	sg_free_table(sgt);
-	kfree(sgt);
+	kfree(mapping);
 }
 
 static int
@@ -478,10 +484,10 @@ armada_gem_dmabuf_mmap(struct dma_buf *buf, struct vm_area_struct *vma)
 }
 
 static const struct dma_buf_ops armada_gem_prime_dmabuf_ops = {
-	.map_dma_buf	= armada_gem_prime_map_dma_buf,
-	.unmap_dma_buf	= armada_gem_prime_unmap_dma_buf,
 	.release	= drm_gem_dmabuf_release,
 	.mmap		= armada_gem_dmabuf_mmap,
+	DMA_BUF_SIMPLE_SGT_EXP_MATCH(armada_gem_prime_map_dma_buf,
+				     armada_gem_prime_unmap_dma_buf),
 };
 
 struct dma_buf *
diff --git a/drivers/gpu/drm/i915/gem/selftests/mock_dmabuf.c b/drivers/gpu/drm/i915/gem/selftests/mock_dmabuf.c
index f2863da7f5c1..bba066f3cb50 100644
--- a/drivers/gpu/drm/i915/gem/selftests/mock_dmabuf.c
+++ b/drivers/gpu/drm/i915/gem/selftests/mock_dmabuf.c
@@ -4,20 +4,24 @@
  * Copyright © 2016 Intel Corporation
  */
 
+#include <linux/dma-buf-mapping.h>
 #include <linux/vmalloc.h>
 #include "mock_dmabuf.h"
 
-static struct sg_table *mock_map_dma_buf(struct dma_buf_attachment *attachment,
-					 enum dma_data_direction dir)
+static struct dma_buf_sgt_mapping *
+mock_map_dma_buf(struct dma_buf_attachment *attachment,
+		 enum dma_data_direction dir)
 {
 	struct mock_dmabuf *mock = to_mock(attachment->dmabuf);
+	struct dma_buf_sgt_mapping *mapping;
 	struct sg_table *st;
 	struct scatterlist *sg;
 	int i, err;
 
-	st = kmalloc_obj(*st);
-	if (!st)
+	mapping = kzalloc_obj(*mapping);
+	if (!mapping)
 		return ERR_PTR(-ENOMEM);
+	st = &mapping->sgt;
 
 	err = sg_alloc_table(st, mock->npages, GFP_KERNEL);
 	if (err)
@@ -29,26 +33,27 @@ static struct sg_table *mock_map_dma_buf(struct dma_buf_attachment *attachment,
 		sg = sg_next(sg);
 	}
 
-	err = dma_map_sgtable(attachment->dev, st, dir, 0);
+	err = dma_map_sgtable(dma_buf_sgt_dma_device(attachment), st, dir, 0);
 	if (err)
 		goto err_st;
 
-	return st;
+	return mapping;
 
 err_st:
 	sg_free_table(st);
 err_free:
-	kfree(st);
+	kfree(mapping);
 	return ERR_PTR(err);
 }
 
 static void mock_unmap_dma_buf(struct dma_buf_attachment *attachment,
-			       struct sg_table *st,
+			       struct dma_buf_sgt_mapping *mapping,
 			       enum dma_data_direction dir)
 {
-	dma_unmap_sgtable(attachment->dev, st, dir, 0);
-	sg_free_table(st);
-	kfree(st);
+	dma_unmap_sgtable(dma_buf_sgt_mapping_dma_device(mapping),
+			  &mapping->sgt, dir, 0);
+	sg_free_table(&mapping->sgt);
+	kfree(mapping);
 }
 
 static void mock_dmabuf_release(struct dma_buf *dma_buf)
@@ -88,12 +93,11 @@ static int mock_dmabuf_mmap(struct dma_buf *dma_buf, struct vm_area_struct *vma)
 }
 
 static const struct dma_buf_ops mock_dmabuf_ops =  {
-	.map_dma_buf = mock_map_dma_buf,
-	.unmap_dma_buf = mock_unmap_dma_buf,
 	.release = mock_dmabuf_release,
 	.mmap = mock_dmabuf_mmap,
 	.vmap = mock_dmabuf_vmap,
 	.vunmap = mock_dmabuf_vunmap,
+	DMA_BUF_SIMPLE_SGT_EXP_MATCH(mock_map_dma_buf, mock_unmap_dma_buf),
 };
 
 static struct dma_buf *mock_dmabuf(int npages)
diff --git a/drivers/gpu/drm/tegra/gem.c b/drivers/gpu/drm/tegra/gem.c
index e6aa6dae4ec8..8e288a34f10f 100644
--- a/drivers/gpu/drm/tegra/gem.c
+++ b/drivers/gpu/drm/tegra/gem.c
@@ -11,6 +11,7 @@
  */
 
 #include <linux/dma-buf.h>
+#include <linux/dma-buf-mapping.h>
 #include <linux/iommu.h>
 #include <linux/module.h>
 #include <linux/pagemap.h>
@@ -626,51 +627,56 @@ int tegra_drm_mmap(struct file *file, struct vm_area_struct *vma)
 	return __tegra_gem_mmap(gem, vma);
 }
 
-static struct sg_table *
+static struct dma_buf_sgt_mapping *
 tegra_gem_prime_map_dma_buf(struct dma_buf_attachment *attach,
 			    enum dma_data_direction dir)
 {
+	struct device *dma_dev = dma_buf_sgt_dma_device(attach);
 	struct drm_gem_object *gem = attach->dmabuf->priv;
 	struct tegra_bo *bo = to_tegra_bo(gem);
+	struct dma_buf_sgt_mapping *mapping;
 	struct sg_table *sgt;
 
-	sgt = kmalloc_obj(*sgt);
-	if (!sgt)
+	mapping = kzalloc_obj(*mapping);
+	if (!mapping)
 		return NULL;
+	sgt = &mapping->sgt;
 
 	if (bo->pages) {
 		if (sg_alloc_table_from_pages(sgt, bo->pages, bo->num_pages,
 					      0, gem->size, GFP_KERNEL) < 0)
 			goto free;
 	} else {
-		if (dma_get_sgtable(attach->dev, sgt, bo->vaddr, bo->iova,
+		if (dma_get_sgtable(dma_dev, sgt, bo->vaddr, bo->iova,
 				    gem->size) < 0)
 			goto free;
 	}
 
-	if (dma_map_sgtable(attach->dev, sgt, dir, 0))
+	if (dma_map_sgtable(dma_dev, sgt, dir, 0))
 		goto free;
 
-	return sgt;
+	return mapping;
 
 free:
 	sg_free_table(sgt);
-	kfree(sgt);
+	kfree(mapping);
 	return NULL;
 }
 
 static void tegra_gem_prime_unmap_dma_buf(struct dma_buf_attachment *attach,
-					  struct sg_table *sgt,
+					  struct dma_buf_sgt_mapping *mapping,
 					  enum dma_data_direction dir)
 {
 	struct drm_gem_object *gem = attach->dmabuf->priv;
 	struct tegra_bo *bo = to_tegra_bo(gem);
+	struct sg_table *sgt = &mapping->sgt;
 
 	if (bo->pages)
-		dma_unmap_sgtable(attach->dev, sgt, dir, 0);
+		dma_unmap_sgtable(dma_buf_sgt_mapping_dma_device(mapping), sgt,
+				  dir, 0);
 
 	sg_free_table(sgt);
-	kfree(sgt);
+	kfree(mapping);
 }
 
 static void tegra_gem_prime_release(struct dma_buf *buf)
@@ -740,14 +746,14 @@ static void tegra_gem_prime_vunmap(struct dma_buf *buf, struct iosys_map *map)
 }
 
 static const struct dma_buf_ops tegra_gem_prime_dmabuf_ops = {
-	.map_dma_buf = tegra_gem_prime_map_dma_buf,
-	.unmap_dma_buf = tegra_gem_prime_unmap_dma_buf,
 	.release = tegra_gem_prime_release,
 	.begin_cpu_access = tegra_gem_prime_begin_cpu_access,
 	.end_cpu_access = tegra_gem_prime_end_cpu_access,
 	.mmap = tegra_gem_prime_mmap,
 	.vmap = tegra_gem_prime_vmap,
 	.vunmap = tegra_gem_prime_vunmap,
+	DMA_BUF_SIMPLE_SGT_EXP_MATCH(tegra_gem_prime_map_dma_buf,
+				     tegra_gem_prime_unmap_dma_buf),
 };
 
 struct dma_buf *tegra_gem_prime_export(struct drm_gem_object *gem,
diff --git a/samples/vfio-mdev/mbochs.c b/samples/vfio-mdev/mbochs.c
index 64ea19253ee3..3502d0b37bd1 100644
--- a/samples/vfio-mdev/mbochs.c
+++ b/samples/vfio-mdev/mbochs.c
@@ -32,6 +32,7 @@
 #include <linux/pci.h>
 #include <linux/dma-buf.h>
 #include <linux/highmem.h>
+#include <linux/dma-buf-mapping.h>
 #include <drm/drm_fourcc.h>
 #include <drm/drm_rect.h>
 #include <drm/drm_modeset_lock.h>
@@ -857,46 +858,51 @@ static void mbochs_print_dmabuf(struct mbochs_dmabuf *dmabuf,
 		dmabuf->mode.offset, dmabuf->mode.size, dmabuf->pagecount);
 }
 
-static struct sg_table *mbochs_map_dmabuf(struct dma_buf_attachment *at,
-					  enum dma_data_direction direction)
+static struct dma_buf_sgt_mapping *
+mbochs_map_dmabuf(struct dma_buf_attachment *at,
+		  enum dma_data_direction direction)
 {
 	struct mbochs_dmabuf *dmabuf = at->dmabuf->priv;
 	struct device *dev = mdev_dev(dmabuf->mdev_state->mdev);
+	struct dma_buf_sgt_mapping *mapping;
 	struct sg_table *sg;
 
 	dev_dbg(dev, "%s: %d\n", __func__, dmabuf->id);
 
-	sg = kzalloc(sizeof(*sg), GFP_KERNEL);
-	if (!sg)
+	mapping = kzalloc_obj(*mapping);
+	if (!mapping)
 		goto err1;
+	sg = &mapping->sgt;
 	if (sg_alloc_table_from_pages(sg, dmabuf->pages, dmabuf->pagecount,
 				      0, dmabuf->mode.size, GFP_KERNEL) < 0)
 		goto err2;
-	if (dma_map_sgtable(at->dev, sg, direction, 0))
+	if (dma_map_sgtable(dma_buf_sgt_dma_device(at), sg, direction, 0))
 		goto err3;
 
-	return sg;
+	return mapping;
 
 err3:
 	sg_free_table(sg);
 err2:
-	kfree(sg);
+	kfree(mapping);
 err1:
 	return ERR_PTR(-ENOMEM);
 }
 
 static void mbochs_unmap_dmabuf(struct dma_buf_attachment *at,
-				struct sg_table *sg,
+				struct dma_buf_sgt_mapping *mapping,
 				enum dma_data_direction direction)
 {
 	struct mbochs_dmabuf *dmabuf = at->dmabuf->priv;
 	struct device *dev = mdev_dev(dmabuf->mdev_state->mdev);
+	struct sg_table *sg = &mapping->sgt;
 
 	dev_dbg(dev, "%s: %d\n", __func__, dmabuf->id);
 
-	dma_unmap_sgtable(at->dev, sg, direction, 0);
+	dma_unmap_sgtable(dma_buf_sgt_mapping_dma_device(mapping), sg,
+			  direction, 0);
 	sg_free_table(sg);
-	kfree(sg);
+	kfree(mapping);
 }
 
 static void mbochs_release_dmabuf(struct dma_buf *buf)
@@ -918,11 +924,10 @@ static void mbochs_release_dmabuf(struct dma_buf *buf)
 	mutex_unlock(&mdev_state->ops_lock);
 }
 
-static struct dma_buf_ops mbochs_dmabuf_ops = {
-	.map_dma_buf	  = mbochs_map_dmabuf,
-	.unmap_dma_buf	  = mbochs_unmap_dmabuf,
+static const struct dma_buf_ops mbochs_dmabuf_ops = {
 	.release	  = mbochs_release_dmabuf,
 	.mmap		  = mbochs_mmap_dmabuf,
+	DMA_BUF_SIMPLE_SGT_EXP_MATCH(mbochs_map_dmabuf, mbochs_unmap_dmabuf),
 };
 
 static struct mbochs_dmabuf *mbochs_dmabuf_alloc(struct mdev_state *mdev_state,
diff --git a/sound/soc/fsl/fsl_asrc_m2m.c b/sound/soc/fsl/fsl_asrc_m2m.c
index 58101ce07c9f..79fde68f9394 100644
--- a/sound/soc/fsl/fsl_asrc_m2m.c
+++ b/sound/soc/fsl/fsl_asrc_m2m.c
@@ -7,6 +7,7 @@
 
 #include <linux/dma/imx-dma.h>
 #include <linux/dma-buf.h>
+#include <linux/dma-buf-mapping.h>
 #include <linux/dma-mapping.h>
 #include <linux/pm_runtime.h>
 #include <sound/asound.h>
@@ -414,35 +415,42 @@ static int fsl_asrc_m2m_mmap(struct dma_buf *dmabuf, struct vm_area_struct *vma)
 	return snd_dma_buffer_mmap(dmab, vma);
 }
 
-static struct sg_table *fsl_asrc_m2m_map_dma_buf(struct dma_buf_attachment *attachment,
-						 enum dma_data_direction direction)
+static struct dma_buf_sgt_mapping *
+fsl_asrc_m2m_map_dma_buf(struct dma_buf_attachment *attachment,
+			 enum dma_data_direction direction)
 {
+	struct device *dma_dev = dma_buf_sgt_dma_device(attachment);
 	struct snd_dma_buffer *dmab = attachment->dmabuf->priv;
+	struct dma_buf_sgt_mapping *mapping;
 	struct sg_table *sgt;
 
-	sgt = kmalloc_obj(*sgt);
-	if (!sgt)
+	mapping = kzalloc_obj(*mapping);
+	if (!mapping)
 		return NULL;
+	sgt = &mapping->sgt;
 
-	if (dma_get_sgtable(attachment->dev, sgt, dmab->area, dmab->addr, dmab->bytes) < 0)
+	if (dma_get_sgtable(dma_dev, sgt, dmab->area, dmab->addr, dmab->bytes) < 0)
 		goto free;
 
-	if (dma_map_sgtable(attachment->dev, sgt, direction, 0))
+	if (dma_map_sgtable(dma_dev, sgt, direction, 0))
 		goto free;
 
-	return sgt;
+	return mapping;
 
 free:
 	sg_free_table(sgt);
-	kfree(sgt);
+	kfree(mapping);
 	return NULL;
 }
 
 static void fsl_asrc_m2m_unmap_dma_buf(struct dma_buf_attachment *attachment,
-				       struct sg_table *table,
+				       struct dma_buf_sgt_mapping *mapping,
 				       enum dma_data_direction direction)
 {
-	dma_unmap_sgtable(attachment->dev, table, direction, 0);
+	dma_unmap_sgtable(dma_buf_sgt_mapping_dma_device(mapping),
+			  &mapping->sgt, direction, 0);
+	sg_free_table(&mapping->sgt);
+	kfree(mapping);
 }
 
 static void fsl_asrc_m2m_release(struct dma_buf *dmabuf)
@@ -452,9 +460,9 @@ static void fsl_asrc_m2m_release(struct dma_buf *dmabuf)
 
 static const struct dma_buf_ops fsl_asrc_m2m_dma_buf_ops = {
 	.mmap = fsl_asrc_m2m_mmap,
-	.map_dma_buf = fsl_asrc_m2m_map_dma_buf,
-	.unmap_dma_buf = fsl_asrc_m2m_unmap_dma_buf,
 	.release = fsl_asrc_m2m_release,
+	DMA_BUF_SIMPLE_SGT_EXP_MATCH(fsl_asrc_m2m_map_dma_buf,
+				     fsl_asrc_m2m_unmap_dma_buf),
 };
 
 static int fsl_asrc_m2m_comp_task_create(struct snd_compr_stream *stream,

-- 
2.54.0

