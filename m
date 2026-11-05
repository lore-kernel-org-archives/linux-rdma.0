Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.209.24
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793861004;
	b=aGH/z7f082975Bjqn1xLwVdCylJ760IfwDLYvS0GpnR7rclFliB/4svWdIZMFkXVXgGC
	 jENqSraUO/gGiCfoaLVpE/6zg11khju8qLbfgb22gGHM5DzJTg6MF817xekOE7k1yA8g0
	 JxpPMR2MgSO/qF7d5EWMwi2/XdNr58LjkVsuOK0fCm/A46aZ679REZrDsBLXV+/OQ2T/o
	 cfN8Dp0+VxcFrVlPpokDE92/bZYc2Ii1x2AEQ+YJuENnQNzaiGP3iiZAAxby3wruYEYWf
	 JjAtpajflm+C5ZaPKMdbvku9xkNyeUuR8K+Rr83+51JW08FLbXe9LEzcQ1RU4VUd5nQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793861004;
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
	bh=1FaHODCqOvRJPKRwNH8uMbcfJPwXF4sHg5m665p5Xqs=;
	b=s1kbX3XetXZe50jCdC/mNypyDDJI/hxJODzCulZKOFTAPBHBC5aNexKEgjC+WKuIejr9
	 x/2nQ/sHkSUwKssnLGpXa3A3+5V7M6XKOb3FvL1MmTg1dEQTSPtzeXvBUGSy8pFijDywj
	 yR9Gwbqqa/3j5ZX3XtFPtkBW1AlYTnuWALs05mjYKkMxPOu06rCZoF72sUtGtVJ1v9KrU
	 Zm4Wpf8wvMCGJjYcW9Uxw3I6eJV897/rF1uKn8t+QLJr6iIyn/tw4ZdkK1VBDdx3Kcrfg
	 PHjK9hoEf7FXwvklbJ2ydg7othWTbaBs7ajbE49ev8jBFrQIAeXZ8yZhLIfFcKzvl0A==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=JqjebT4t;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.209.24
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012024.outbound.protection.outlook.com [40.107.209.24])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07421606EEA4;
	Thu,  5 Nov 2026 06:43:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 07421606EEA4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=JqjebT4t
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hHYe6ByuK+9g3HaUgoaFLTEAm/UnQmDEvEuejluQLsofodre4Op+R7JxgRsiao6BmTmvgoxKl707vxUWXZeeKhZdohyHv0lblzXa17FvypgqGtgR2jLXzCG7VL4cEM7F+mXyCQVfERv5DRzsr5u2KuH3OlDcXKVyZM+aH9ddfMyVSCXX+85bzP+QqWlx0bNc8usfdrTaMVw5uaArZvtBKCpuX0jQkrMObPs3ofR8pbRvqICQ1DL5M5HHuRFyYhDmUXqMCnA5CcIYFdpj9vnEHKf3I4VkwjaxDALnK8mxsc7egAe3CPR7cyL7vT+vc/20rlcbqpci41LFdBGAPnR4mg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1FaHODCqOvRJPKRwNH8uMbcfJPwXF4sHg5m665p5Xqs=;
 b=VZOaRDEDrmrV2SrbXNQh0SAgne3zhJieGnbLibFPZDTeKaLA5IsEw/bthxE7hP/fUnc2ufkIx13WsAp0CJOM4sKfi4klkvQPC1v2kBZewfGDdoYH/GHGEGYopwIys9kTPMRIJmbL0g5nmaAbYw4mVf7YSV+hRagxmzVmeO2y4Pv0w8eRmlYCeeyZTARmoZbh5yVRZHKyvNrSlSdFMZMDegn8l6IGe4pM54JT+PWclSU7PbrxPU0lroEH822Yq2fau3rxtL1QZrcvzpnsfTrbZ/j0zfqS9E91+4hzfe1Do+FkVehXhtaclGHYLf24wks6EL3YLfgCyL3Tqa+m7TvsNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1FaHODCqOvRJPKRwNH8uMbcfJPwXF4sHg5m665p5Xqs=;
 b=JqjebT4tmOXeKpVZuIhd757HIl5OYYDSbg+xRnIwheb2mdsWDaaeR15f66oKYLg7gkt5PKQChomQEA4KrbqTgSB0xHDMRDRuMUHy8QfLQmG01atqN9u883NGq8LsJiyDjqRrXgTk0KL5+KV5EMyXvPzk/yPXVMjj1SWRY7mxCFeTeqMQliKHPn5UH7Zj54jl1ELxDSAUP9ekXqLMC9AIbV07K5uqJlxtuBC3cj/q7RQ/cP1j6L5YCRcgXjZcZC1RoCaK1AcbH0qKxygK/8+BzL75HLxia/KCd8W1IoFtonUnFlxu0V9ggD+88agfc/tBMJpH1O6OuGgM9D3qF+bBzg==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SA3PR12MB598757.namprd12.prod.outlook.com
 (2603:10b6:806:52d::14) by IA0PR12MB8932.namprd12.prod.outlook.com
 (2603:10b6:208:492::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.9; Thu, 5 Nov 2026
 06:43:18 +0000
Received: from SA3PR12MB598757.namprd12.prod.outlook.com
 ([fe80::e206:100:5946:a777]) by SA3PR12MB598757.namprd12.prod.outlook.com
 ([fe80::e206:100:5946:a777%5]) with mapi id 15.21.0592.009; Thu, 5 Nov 2026
 06:43:18 +0000
From: Alistair Popple <apopple@nvidia.com>
Date: Thu, 05 Nov 2026 17:40:58 +1100
Subject: [PATCH v2 23/23] dma-buf: Add kunit tests for mapping type
 selection
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261105-dma_mapping_type_v4-v2-23-78b8dc9ae80a@nvidia.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793860879; l=19416;
 i=apopple@nvidia.com; s=20261105; h=from:subject:message-id;
 bh=WOUIDU8qRXiUxMPCCcxWVpcYlg9sDT9scbc0nDb0mWg=;
 b=DynNR9FHKyThOkVXfnzjLjp8xJUchdX24B22H6vemcdT6pTIIOCNtwN3pnPDZfJ70onaRAGuM
 7BXS0uGdwzABK4dNtAGo2VZOhhdTERquhdFe+cR9CVU7hr3nxTk2FLm
X-Developer-Key: i=apopple@nvidia.com; a=ed25519;
 pk=WdWPT9rAq3YNfXldbGv1NSGVLGxzQGFGJvRUiShhNqs=
X-ClientProxiedBy: SY5P300CA0048.AUSP300.PROD.OUTLOOK.COM
 (2603:10c6:10:1fe::17) To SA3PR12MB598757.namprd12.prod.outlook.com
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
X-MS-Office365-Filtering-Correlation-Id: 6813b2ef-6355-4fca-97df-08df3b0813b2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|7416014|1800799024|23010399003|260925021311599003|22082099003|18002099003|56012099006|260925021911599003|260925022911599003|921020|261021121427099003|261022075727099003|261022105027099003|261009223027099003|261026140227099003|261026121527099003|5023799004|10067099003|261028144727099003|11063799006|261102123227099003|261102130727099003;
X-Microsoft-Antispam-Message-Info:
	MZUaED7QDruK5uRcwm5kJPqObKrc+Qojka7+vwfbqT8R3ePOc/hK13M1qXo+WOiqdx5SxzuMy3laFKqevkcFSsE363P42yh/8aeNTSuvWD2Obeb0Hp+TGZzZuwfp32t/87AlzUncLqnqe3Dli2Gvz1y+3VEES8fNmnao7ZPsBuswTBfVY/18xD6iMT4cTYw+NQMWi7hGRuSsynUMhsCXZEqjo3g82eYE09GiF+tOFrrttjN/e3ZTnD9DkQGwMLwNHkFHd1+L1KCjY5/mt4pLX5a7uXO3FIB+5+OPf23vZ7M+FIFrIhYOMHe6sucpUVAyiYYz0HkW99sO9yLRlqEtYwA6X64f3rFyzGMFTgnjk+QckNKO6TJt1YSCTYN+No61YNizWCZSuV8pRy1OQiKzyG5YXwojC+VOCh5NP5BoqDHTKzBh77kIAEJoN4+dcqjujXyxKlLRB6i/EQ1XkKW+gXaVHCJy0iIM5xj/ZYa1gHx28O+yPEsGbKtgA8jsPDRKW/GaFH4fImto121iW5zNZyKSwn/Qa8fGqmuRMcUPAHI7taS0oGcXyGZx6xDzRX7un2qhZTDyhdc13tk2wlLflL+mujSYVx6LNLuv4WW/R3VUO8TudSkGQblqivCyxw+sUihCMiv3SHPivgHjNf/eULC+P5uYu6dTQB7igfm3u6Scsq2z9zKuisKX6X/+My8i3idIXZqhfsDaVx6hYo4uKQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA3PR12MB598757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(7416014)(1800799024)(23010399003)(260925021311599003)(22082099003)(18002099003)(56012099006)(260925021911599003)(260925022911599003)(921020)(261021121427099003)(261022075727099003)(261022105027099003)(261009223027099003)(261026140227099003)(261026121527099003)(5023799004)(10067099003)(261028144727099003)(11063799006)(261102123227099003)(261102130727099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UURmclNPL0dDbmt6UTdxQ1dPQUFCenBmVEo2amxXYzhFWkdzeWRYNHU0TG9m?=
 =?utf-8?B?bWpGT2ozR0V1NHdZbjY1c0c4RUZTWjB5REU2VWpIcnNPNGNMSjVhbXg2NDdx?=
 =?utf-8?B?QnpKYlRpZno1WVJHOUJtVll6L1dkUDVhWUhxTlZXU3JkTzZwend1UUZUN3pl?=
 =?utf-8?B?SldkVE00Vmp5YzRBV1RHdnMvU3JXWGp2WEdWWlRMTXBvZkw2dEtsT0NtcXV3?=
 =?utf-8?B?RzR3T2l3eTA5M0FtVGVNMk43bUJ3V1Vid1BPdkEraEVwUmNhNlpWR01hOFpH?=
 =?utf-8?B?TmQ5eDhMKzJudlBnL3l6aE9XZkNQZWlwbXA2Sm1KWTBPZU1rODJNL3ArTnYy?=
 =?utf-8?B?UkIwODdFYThwUWdYL0JHR2xvTXVQU3dHa3UxR3NtOEpZUTRneFgyTStJTjhk?=
 =?utf-8?B?NnZpTitjU3JLQ3UxUDZxaUtvTHFqV2h4SXIra3RNYms4ZHRGcll4SUJ3RTRr?=
 =?utf-8?B?cGtuZFc4Sm9CaG80UW1sVGprcjdlMm5zYmZaNEM0OWdTSk9tYTJnQWdXY3Zm?=
 =?utf-8?B?N3hDMk1OYkVqWWJTem0rT05WWmpOcEQzYUlKSFFQVmtNVnNNeW55MVhIL25T?=
 =?utf-8?B?Z3NDd0YvSTYyMStqamZCVjRaa3dLeTNtNXFPRjFWZ3A2YW9KVFJMckVobjJx?=
 =?utf-8?B?dzFubWE1RGJ0TDFMb2FpU3piK2krelJUTjhHc3pPL3FCRC9BeEhrY2NlQmpJ?=
 =?utf-8?B?dy9ZRHlYM3RRTWhTWk1Vdmg5S1hkVXFnSjdWS0dnQjNYYU1WNWx2dWJiK1d4?=
 =?utf-8?B?bitEcUpGMmZicDM2cGE5ZUJSNTg1TXlaOEwxSHkxMXIxYVdvZnJhd08rT1pI?=
 =?utf-8?B?UkRPODd0d0JoODJQQkZpZFNOV25DaDlSQ3YxV0R4b2kxNWx4QUs3eFk4ZWZO?=
 =?utf-8?B?ZDNsQlNNcngxRmQwZ2J1emMwTGxtVUVnMS8wS0VybStkZ0dzeXJYb1E4dXJx?=
 =?utf-8?B?Y2J5anlJQjNSWk1wUmtEc0ZDclJTakNvRElBSVRINTFFSFVjeHVwMlJ4aGtj?=
 =?utf-8?B?ak1jZWM1Z3FSV0RKUEtqVUM4NU91SWdkRkNEWGdjUzJzUERSeHNId3VHbEpl?=
 =?utf-8?B?RVVCeHVBVUR3TE45MmhCTHJza1FMZUVqQ3BCUEFqTXFhV3NWL2ZCSm1yN2VS?=
 =?utf-8?B?eGJxaUQydjNPazI5bS9vWXV5SlU5MHF0aDV0Y3grbDFKN0hodEFCbmpSTUxt?=
 =?utf-8?B?OFJnR0Q5bjV0cDJsUmxRRHd6V2lycWlmQ1ZWMEFqMXhSNlh0QkNON1p2ZXV3?=
 =?utf-8?B?TlJZYXhQajZzQ1paMlhXVGpkK1paNmQvSDN4UVBNWlA4OUY4dzl6bGVDZmZi?=
 =?utf-8?B?VDloT0QxYmh2MnNTVjBNWmFQRi9WK1RFN2dGZHcybk1jOFgyYWdyUzNtQmRD?=
 =?utf-8?B?YzBKWVArbzdIYVJZZUxMQmY2d3pyQ0ZqaFc4TnBzb3hxZG5wbE5uUEZQL09C?=
 =?utf-8?B?U0F0OXlmc3BZeVBEZ1VpblNWK0c1OW5zclE4S0ZNOWxqSXhybWJEcnRqUTdX?=
 =?utf-8?B?MXhnMGE2RlFLSWdra25mMjd4VjBGMTIwWWp0TzBTNndMNXBwcjY2QnFrQ0Rz?=
 =?utf-8?B?R0JBdXZzc1RtODBmejVoOFVHWWlqdGNVSU9BVTJEZlZ2WFd6SVc2aHQxQklC?=
 =?utf-8?B?N2E4YUZUM3ZYTjlZTkFTaXJNdkxaanFoTEw2ak9raDIzZUI2cHlYUWExNWhO?=
 =?utf-8?B?UGI0dHJYSW1xc2xMcElHRzlZV0RxQ0g5d3kxaUZxRG1PV3ZUN0pyMG0rRW5H?=
 =?utf-8?B?MTZGZXFmQnhZcExyYnQ2eTQ1MXRXMG9GbXdjanBmWTRybW9vNXFQeDVJS1Bo?=
 =?utf-8?B?WU9vREtmWEdOZURQckpSckRLTGpZcDA5aGF6bFVUSGZtUFJPMWZ5MmN0OWpR?=
 =?utf-8?B?SVlJS1MybldlVlRiUXlSVllRUGkxdXByNWtjRndXZWY0dnFaQkhJWUpPZll3?=
 =?utf-8?B?SXc3c3lHSGg3L2pVL080d042bXJFZ3NNQ3M1QVV5WnlkckpYbzFjLzZqYjN5?=
 =?utf-8?B?QzVtcEtFUTl3dFlvdlY5NE5nNXNlUGhlNy9HMHpOQkd1NEYyaEhxaU1sK05m?=
 =?utf-8?B?WnpYVjhOcmVLTjR2MkRBYVg4elppT2dXeEFGc0I1L2NxbXZab29DOG9VeWU4?=
 =?utf-8?B?d2dLaEluRlZzN3lRZyt0RWszdWoxQU9OYWY4RDdzTStlZzRxWUpsdWhmTWg2?=
 =?utf-8?B?QkJERWlEdlFkVXVGak1BQXBhdzBZWDUyZXpWTGJObmg2SkxsYTBUQjk5YUt0?=
 =?utf-8?B?U2ZLOC91eHdHdklnTFJESDI2L1pwTmVtT2RQbk9PSHRnRzVhdDJDUjJvSm1U?=
 =?utf-8?B?bmNodE1PTmEzMHJ1bEpKUi9MdnVzWUE0bS9ZM3V5RzEwbUJTQkNWdz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6813b2ef-6355-4fca-97df-08df3b0813b2
X-MS-Exchange-CrossTenant-AuthSource: SA3PR12MB598757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2026 06:43:18.8275
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sBkjUgbL+23etT/RJGmKvUYq40Pje1BKsijMPctL6PlAyPyPglzwmh1eB287LFz1nB9PbmcgBgAFa7SL9cBCew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8932

Add an offer list and a select_mapping() callback to the mock exporter
along with map/unmap for the two mock types.

Adds tests for the exporter/importer contract.

 - test_match_set_is_final: a later importer attaching, even one the
   exporter answers differently, does not change an existing
   attachment's match set or default. Later attachments influence what
   the exporter selects at pin and map time, not previous attachments.

 - test_select_at_map: the exporter chooses a non-default entry
   at the first map and the result is tagged with it. A pin taken
   under the live mapping inherits the type and the choice survives
   unmap/remap even though the exporter would answer differently. Only
   dma_buf_invalidate_mappings() allows the exporter to make a different
   selection. An -EBUSY from selection leaves nothing established.

 - test_select_at_pin: pin selects, and the choice survives map, unmap
   and unpin so a pinned importer that is never invalidated keeps its
   first type for the life of the import.

Signed-off-by: Alistair Popple <apopple@nvidia.com>
---
 drivers/dma-buf/st-dma-mapping.c | 493 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 493 insertions(+)

diff --git a/drivers/dma-buf/st-dma-mapping.c b/drivers/dma-buf/st-dma-mapping.c
index cbfa99aeb0ff..11010731150a 100644
--- a/drivers/dma-buf/st-dma-mapping.c
+++ b/drivers/dma-buf/st-dma-mapping.c
@@ -7,6 +7,7 @@
 #include <kunit/test.h>
 #include <linux/dma-buf.h>
 #include <linux/dma-buf-mapping.h>
+#include <linux/dma-resv.h>
 #include <linux/errno.h>
 
 /* Mock tracking state -- reset before each test */
@@ -21,6 +22,19 @@ static const struct dma_buf_match_args *mock_finish_args_arg;
 static const struct dma_buf_mapping_match *mock_finish_exp_arg;
 static const struct dma_buf_mapping_match *mock_finish_imp_arg;
 
+/* Mapping types the configurable mock exporter currently offers */
+static const struct dma_buf_mapping_match *mock_exp_offer;
+static size_t mock_exp_offer_len;
+
+/* Which match set entry the selecting mock exporter picks, or an error */
+static int mock_select_idx;
+static int mock_select_err;
+
+/* Failure injection for the mock types' map and the mock exporter's pin */
+static int mock_map_err;
+static int mock_pin_err;
+static int mock_pin_count;
+
 static int reset_mock_state(struct kunit *test)
 {
 	mock_match_called = false;
@@ -32,6 +46,13 @@ static int reset_mock_state(struct kunit *test)
 	mock_finish_args_arg = NULL;
 	mock_finish_exp_arg = NULL;
 	mock_finish_imp_arg = NULL;
+	mock_exp_offer = NULL;
+	mock_exp_offer_len = 0;
+	mock_select_idx = 0;
+	mock_select_err = 0;
+	mock_map_err = 0;
+	mock_pin_err = 0;
+	mock_pin_count = 0;
 	return 0;
 }
 
@@ -370,11 +391,478 @@ static void test_mock_attach(struct kunit *test)
 	KUNIT_EXPECT_PTR_EQ(test, dma_buf_attach_map_type(attach)->type,
 			    &mock_type_a);
 	KUNIT_EXPECT_PTR_EQ(test, mock_match_dev_arg, dev);
+	KUNIT_EXPECT_PTR_EQ(test, mock_match_dev_arg, dev);
 
 	dma_buf_detach(dmabuf, attach);
 	dma_buf_put(dmabuf);
 }
 
+static int mock_dmabuf_offer_match_mapping(struct dma_buf_match_args *args)
+{
+	return dma_buf_match_mapping(args, mock_exp_offer, mock_exp_offer_len);
+}
+
+static const struct dma_buf_ops mock_dmabuf_offer_ops = {
+	.release = mock_dmabuf_release,
+	.match_mapping = mock_dmabuf_offer_match_mapping,
+};
+
+/*
+ * The match set is final once attached. A later importer attaching, even one
+ * the exporter answers differently, must not change an existing attachment.
+ *
+ * Later attachments influence what the exporter selects at pin or map time,
+ * not what was previously negotiated.
+ */
+static void test_match_set_is_final(struct kunit *test)
+{
+	static const struct dma_buf_mapping_match offer_ab[] = {
+		{ .type = &mock_type_a },
+		{ .type = &mock_type_b },
+	};
+	static const struct dma_buf_mapping_match offer_b[] = {
+		{ .type = &mock_type_b },
+	};
+	struct dma_buf_mapping_match imp1[] = {
+		{ .type = &mock_type_a },
+		{ .type = &mock_type_b },
+	};
+	struct dma_buf_mapping_match imp2[] = { { .type = &mock_type_b } };
+	MOCK_IMPORTER_OPS(importer1_ops, imp1);
+	MOCK_IMPORTER_OPS(importer2_ops, imp2);
+	struct dma_buf_attachment *attach1, *attach2;
+	struct dma_buf *dmabuf;
+	struct device *dev;
+
+	dev = kunit_device_register(test, "dma-buf-test");
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, dev);
+
+	dmabuf = mock_dmabuf_export(&mock_dmabuf_offer_ops);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, dmabuf);
+
+	mock_exp_offer = offer_ab;
+	mock_exp_offer_len = ARRAY_SIZE(offer_ab);
+	attach1 = dma_buf_dynamic_attach(dmabuf, dev, &importer1_ops, NULL);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, attach1);
+	KUNIT_ASSERT_EQ(test, attach1->nr_matches, 2);
+	KUNIT_EXPECT_PTR_EQ(test, dma_buf_attach_map_type(attach1)->type,
+			    &mock_type_a);
+
+	/* Exporter's answer for new importers changes; attach1 does not */
+	mock_exp_offer = offer_b;
+	mock_exp_offer_len = ARRAY_SIZE(offer_b);
+	attach2 = dma_buf_dynamic_attach(dmabuf, dev, &importer2_ops, NULL);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, attach2);
+	KUNIT_ASSERT_EQ(test, attach2->nr_matches, 1);
+	KUNIT_EXPECT_PTR_EQ(test, dma_buf_attach_map_type(attach2)->type,
+			    &mock_type_b);
+	KUNIT_EXPECT_EQ(test, attach1->nr_matches, 2);
+	KUNIT_EXPECT_PTR_EQ(test, dma_buf_attach_map_type(attach1)->type,
+			    &mock_type_a);
+
+	dma_buf_detach(dmabuf, attach2);
+	KUNIT_EXPECT_EQ(test, attach1->nr_matches, 2);
+	KUNIT_EXPECT_PTR_EQ(test, dma_buf_attach_map_type(attach1)->type,
+			    &mock_type_a);
+
+	dma_buf_detach(dmabuf, attach1);
+	dma_buf_put(dmabuf);
+}
+
+/* Mock mapping result for the generic map path */
+struct mock_mapping {
+	struct dma_buf_mapping base;
+	const struct dma_buf_mapping_type *made_by;
+};
+
+static struct dma_buf_mapping *mock_type_map(struct dma_buf_attachment *attach,
+					     enum dma_data_direction dir)
+{
+	struct mock_mapping *m;
+
+	if (mock_map_err)
+		return ERR_PTR(mock_map_err);
+	m = kzalloc_obj(*m);
+	if (!m)
+		return ERR_PTR(-ENOMEM);
+	m->base.type = dma_buf_attach_map_type(attach)->type;
+	m->made_by = dma_buf_attach_map_type(attach)->type;
+	return &m->base;
+}
+
+static void mock_type_unmap(struct dma_buf_attachment *attach,
+			    struct dma_buf_mapping *mapping,
+			    enum dma_data_direction dir)
+{
+	kfree(container_of(mapping, struct mock_mapping, base));
+}
+
+/* Exporter choosing the match set entry the test asks for */
+static int mock_dmabuf_select_mapping(struct dma_buf_attachment *attach)
+{
+	if (mock_select_err)
+		return mock_select_err;
+	return mock_select_idx;
+}
+
+static int mock_dmabuf_pin(struct dma_buf_attachment *attach)
+{
+	if (mock_pin_err)
+		return mock_pin_err;
+	mock_pin_count++;
+	return 0;
+}
+
+static void mock_dmabuf_unpin(struct dma_buf_attachment *attach)
+{
+	mock_pin_count--;
+}
+
+static const struct dma_buf_ops mock_dmabuf_select_ops = {
+	.release = mock_dmabuf_release,
+	.match_mapping = mock_dmabuf_offer_match_mapping,
+	.select_mapping = mock_dmabuf_select_mapping,
+	.pin = mock_dmabuf_pin,
+	.unpin = mock_dmabuf_unpin,
+};
+
+/*
+ * Exporter decides type at first map from the match set. The result is tagged
+ * with it and the core holds the choice across unmap/remap until the attachment
+ * has been explicitly invalidated.
+ */
+static void test_select_at_map(struct kunit *test)
+{
+	static const struct dma_buf_mapping_match offer_ab[] = {
+		{ .type = &mock_type_a },
+		{ .type = &mock_type_b },
+	};
+	struct dma_buf_mapping_match imp[] = {
+		{ .type = &mock_type_a },
+		{ .type = &mock_type_b },
+	};
+	MOCK_IMPORTER_OPS(importer_ops, imp);
+	struct dma_buf_attachment *attach;
+	struct dma_buf_mapping *mapping;
+	struct dma_buf *dmabuf;
+	struct device *dev;
+
+	mock_type_a.map = mock_type_map;
+	mock_type_a.unmap = mock_type_unmap;
+	mock_type_b.map = mock_type_map;
+	mock_type_b.unmap = mock_type_unmap;
+
+	dev = kunit_device_register(test, "dma-buf-test");
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, dev);
+
+	dmabuf = mock_dmabuf_export(&mock_dmabuf_select_ops);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, dmabuf);
+
+	mock_exp_offer = offer_ab;
+	mock_exp_offer_len = ARRAY_SIZE(offer_ab);
+	attach = dma_buf_dynamic_attach(dmabuf, dev, &importer_ops, NULL);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, attach);
+	KUNIT_EXPECT_FALSE(test, attach->selected);
+	KUNIT_EXPECT_PTR_EQ(test, dma_buf_attach_map_type(attach)->type,
+			    &mock_type_a);
+
+	dma_resv_lock(dmabuf->resv, NULL);
+
+	/* Exporter picks the second entry (mock_type_b) */
+	mock_select_idx = 1;
+	mapping = dma_buf_mapping_map(attach, DMA_BIDIRECTIONAL);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, mapping);
+	KUNIT_EXPECT_PTR_EQ(test, mapping->type, &mock_type_b);
+	KUNIT_EXPECT_PTR_EQ(test, dma_buf_attach_map_type(attach)->type,
+			    &mock_type_b);
+	KUNIT_EXPECT_TRUE(test, attach->selected);
+
+	/* A pin taken whilst mapping is live gets the same type */
+	mock_select_idx = 0;
+	KUNIT_EXPECT_EQ(test, dma_buf_pin(attach), 0);
+	KUNIT_EXPECT_PTR_EQ(test, dma_buf_attach_map_type(attach)->type,
+			    &mock_type_b);
+	dma_buf_unpin(attach);
+
+	dma_buf_mapping_unmap(attach, mapping, DMA_BIDIRECTIONAL);
+
+	/*
+	 * Unmapped the exporter would now pick A, but no invalidate has
+	 * happened so remap must get B again to avoid ping-ponging.
+	 */
+	KUNIT_EXPECT_TRUE(test, attach->selected);
+	mapping = dma_buf_mapping_map(attach, DMA_BIDIRECTIONAL);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, mapping);
+	KUNIT_EXPECT_PTR_EQ(test, mapping->type, &mock_type_b);
+	dma_buf_mapping_unmap(attach, mapping, DMA_BIDIRECTIONAL);
+
+	/* Only an explicit invalidation allows the type to change */
+	dma_buf_invalidate_mappings(dmabuf);
+	KUNIT_EXPECT_FALSE(test, attach->selected);
+	/* The selection is kept for a pending unmap until the next one */
+	KUNIT_EXPECT_PTR_EQ(test, dma_buf_attach_map_type(attach)->type,
+			    &mock_type_b);
+
+	mapping = dma_buf_mapping_map(attach, DMA_BIDIRECTIONAL);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, mapping);
+	KUNIT_EXPECT_PTR_EQ(test, mapping->type, &mock_type_a);
+	dma_buf_mapping_unmap(attach, mapping, DMA_BIDIRECTIONAL);
+
+	/* Exporter cannot serve this importer right now */
+	dma_buf_invalidate_mappings(dmabuf);
+	mock_select_err = -EBUSY;
+	mapping = dma_buf_mapping_map(attach, DMA_BIDIRECTIONAL);
+	KUNIT_EXPECT_EQ(test, PTR_ERR(mapping), -EBUSY);
+	KUNIT_EXPECT_FALSE(test, attach->selected);
+	mock_select_err = 0;
+
+	dma_resv_unlock(dmabuf->resv);
+
+	dma_buf_detach(dmabuf, attach);
+	dma_buf_put(dmabuf);
+
+	mock_type_a.map = NULL;
+	mock_type_a.unmap = NULL;
+	mock_type_b.map = NULL;
+	mock_type_b.unmap = NULL;
+}
+
+/*
+ * Pin selects too and the choice survives map, unmap and unpin. A pinned
+ * importer that is never invalidated keeps its first type for the life of the
+ * attachment.
+ */
+static void test_select_at_pin(struct kunit *test)
+{
+	static const struct dma_buf_mapping_match offer_ab[] = {
+		{ .type = &mock_type_a },
+		{ .type = &mock_type_b },
+	};
+	struct dma_buf_mapping_match imp[] = {
+		{ .type = &mock_type_a },
+		{ .type = &mock_type_b },
+	};
+	MOCK_IMPORTER_OPS(importer_ops, imp);
+	struct dma_buf_attachment *attach;
+	struct dma_buf_mapping *mapping;
+	struct dma_buf *dmabuf;
+	struct device *dev;
+
+	mock_type_a.map = mock_type_map;
+	mock_type_a.unmap = mock_type_unmap;
+	mock_type_b.map = mock_type_map;
+	mock_type_b.unmap = mock_type_unmap;
+
+	dev = kunit_device_register(test, "dma-buf-test");
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, dev);
+
+	dmabuf = mock_dmabuf_export(&mock_dmabuf_select_ops);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, dmabuf);
+
+	mock_exp_offer = offer_ab;
+	mock_exp_offer_len = ARRAY_SIZE(offer_ab);
+	attach = dma_buf_dynamic_attach(dmabuf, dev, &importer_ops, NULL);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, attach);
+
+	dma_resv_lock(dmabuf->resv, NULL);
+
+	mock_select_idx = 1;
+	KUNIT_EXPECT_EQ(test, dma_buf_pin(attach), 0);
+	KUNIT_EXPECT_TRUE(test, attach->selected);
+	KUNIT_EXPECT_PTR_EQ(test, dma_buf_attach_map_type(attach)->type,
+			    &mock_type_b);
+
+	/* Map after pin uses the pinned type regardless of the exporter now */
+	mock_select_idx = 0;
+	mapping = dma_buf_mapping_map(attach, DMA_BIDIRECTIONAL);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, mapping);
+	KUNIT_EXPECT_PTR_EQ(test, mapping->type, &mock_type_b);
+	dma_buf_mapping_unmap(attach, mapping, DMA_BIDIRECTIONAL);
+
+	KUNIT_EXPECT_PTR_EQ(test, dma_buf_attach_map_type(attach)->type,
+			    &mock_type_b);
+
+	dma_buf_unpin(attach);
+	KUNIT_EXPECT_TRUE(test, attach->selected);
+	KUNIT_EXPECT_PTR_EQ(test, dma_buf_attach_map_type(attach)->type,
+			    &mock_type_b);
+
+	dma_resv_unlock(dmabuf->resv);
+
+	dma_buf_detach(dmabuf, attach);
+	dma_buf_put(dmabuf);
+
+	mock_type_a.map = NULL;
+	mock_type_a.unmap = NULL;
+	mock_type_b.map = NULL;
+	mock_type_b.unmap = NULL;
+}
+
+/*
+ * A failed pin or map may only undo a selection it made itself. One made by
+ * an earlier pin or map belongs to that pin or mapping and must survive,
+ * otherwise the retry reselects under it without an invalidate. Reproduced
+ * by Karl Mehltretter against the posted series: pin selects B, map fails,
+ * retry selects A with the pin still held.
+ */
+static void test_select_survives_failed_map(struct kunit *test)
+{
+	static const struct dma_buf_mapping_match offer_ab[] = {
+		{ .type = &mock_type_a },
+		{ .type = &mock_type_b },
+	};
+	struct dma_buf_mapping_match imp[] = {
+		{ .type = &mock_type_a },
+		{ .type = &mock_type_b },
+	};
+	MOCK_IMPORTER_OPS(importer_ops, imp);
+	struct dma_buf_attachment *attach;
+	struct dma_buf_mapping *mapping;
+	struct dma_buf *dmabuf;
+	struct device *dev;
+
+	mock_type_a.map = mock_type_map;
+	mock_type_a.unmap = mock_type_unmap;
+	mock_type_b.map = mock_type_map;
+	mock_type_b.unmap = mock_type_unmap;
+
+	dev = kunit_device_register(test, "dma-buf-test");
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, dev);
+
+	dmabuf = mock_dmabuf_export(&mock_dmabuf_select_ops);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, dmabuf);
+
+	mock_exp_offer = offer_ab;
+	mock_exp_offer_len = ARRAY_SIZE(offer_ab);
+	attach = dma_buf_dynamic_attach(dmabuf, dev, &importer_ops, NULL);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, attach);
+
+	dma_resv_lock(dmabuf->resv, NULL);
+
+	/* A map that selected and then failed leaves nothing behind */
+	mock_select_idx = 1;
+	mock_map_err = -EIO;
+	mapping = dma_buf_mapping_map(attach, DMA_BIDIRECTIONAL);
+	KUNIT_EXPECT_EQ(test, PTR_ERR(mapping), -EIO);
+	KUNIT_EXPECT_FALSE(test, attach->selected);
+	KUNIT_EXPECT_PTR_EQ(test, dma_buf_attach_map_type(attach)->type,
+			    &mock_type_a);
+	mock_map_err = 0;
+
+	/* Pin selects B and holds it */
+	KUNIT_EXPECT_EQ(test, dma_buf_pin(attach), 0);
+	KUNIT_EXPECT_TRUE(test, attach->selected);
+	KUNIT_EXPECT_PTR_EQ(test, dma_buf_attach_map_type(attach)->type,
+			    &mock_type_b);
+	KUNIT_EXPECT_EQ(test, mock_pin_count, 1);
+
+	/* A map failing under that pin must not reopen the choice */
+	mock_select_idx = 0;
+	mock_map_err = -EIO;
+	mapping = dma_buf_mapping_map(attach, DMA_BIDIRECTIONAL);
+	KUNIT_EXPECT_EQ(test, PTR_ERR(mapping), -EIO);
+	KUNIT_EXPECT_TRUE(test, attach->selected);
+	KUNIT_EXPECT_PTR_EQ(test, dma_buf_attach_map_type(attach)->type,
+			    &mock_type_b);
+	KUNIT_EXPECT_EQ(test, mock_pin_count, 1);
+	mock_map_err = 0;
+
+	/* The retry gets the pinned type, whatever the exporter answers now */
+	mapping = dma_buf_mapping_map(attach, DMA_BIDIRECTIONAL);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, mapping);
+	KUNIT_EXPECT_PTR_EQ(test, mapping->type, &mock_type_b);
+	dma_buf_mapping_unmap(attach, mapping, DMA_BIDIRECTIONAL);
+
+	dma_buf_unpin(attach);
+	KUNIT_EXPECT_EQ(test, mock_pin_count, 0);
+
+	dma_resv_unlock(dmabuf->resv);
+
+	dma_buf_detach(dmabuf, attach);
+	dma_buf_put(dmabuf);
+
+	mock_type_a.map = NULL;
+	mock_type_a.unmap = NULL;
+	mock_type_b.map = NULL;
+	mock_type_b.unmap = NULL;
+}
+
+/*
+ * The same rule for a failing exporter pin: a pin that selected and then
+ * failed leaves nothing behind, one that failed under an existing mapping
+ * leaves the mapping's selection alone.
+ */
+static void test_select_after_failed_pin(struct kunit *test)
+{
+	static const struct dma_buf_mapping_match offer_ab[] = {
+		{ .type = &mock_type_a },
+		{ .type = &mock_type_b },
+	};
+	struct dma_buf_mapping_match imp[] = {
+		{ .type = &mock_type_a },
+		{ .type = &mock_type_b },
+	};
+	MOCK_IMPORTER_OPS(importer_ops, imp);
+	struct dma_buf_attachment *attach;
+	struct dma_buf_mapping *mapping;
+	struct dma_buf *dmabuf;
+	struct device *dev;
+
+	mock_type_a.map = mock_type_map;
+	mock_type_a.unmap = mock_type_unmap;
+	mock_type_b.map = mock_type_map;
+	mock_type_b.unmap = mock_type_unmap;
+
+	dev = kunit_device_register(test, "dma-buf-test");
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, dev);
+
+	dmabuf = mock_dmabuf_export(&mock_dmabuf_select_ops);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, dmabuf);
+
+	mock_exp_offer = offer_ab;
+	mock_exp_offer_len = ARRAY_SIZE(offer_ab);
+	attach = dma_buf_dynamic_attach(dmabuf, dev, &importer_ops, NULL);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, attach);
+
+	dma_resv_lock(dmabuf->resv, NULL);
+
+	/* First pin selects B but the exporter cannot pin: nothing is kept */
+	mock_select_idx = 1;
+	mock_pin_err = -ENOSPC;
+	KUNIT_EXPECT_EQ(test, dma_buf_pin(attach), -ENOSPC);
+	KUNIT_EXPECT_FALSE(test, attach->selected);
+	KUNIT_EXPECT_PTR_EQ(test, dma_buf_attach_map_type(attach)->type,
+			    &mock_type_a);
+	KUNIT_EXPECT_EQ(test, mock_pin_count, 0);
+	mock_pin_err = 0;
+
+	/* A live mapping selects A */
+	mock_select_idx = 0;
+	mapping = dma_buf_mapping_map(attach, DMA_BIDIRECTIONAL);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, mapping);
+	KUNIT_EXPECT_PTR_EQ(test, mapping->type, &mock_type_a);
+
+	/* A pin failing under it leaves that selection in place */
+	mock_select_idx = 1;
+	mock_pin_err = -ENOSPC;
+	KUNIT_EXPECT_EQ(test, dma_buf_pin(attach), -ENOSPC);
+	KUNIT_EXPECT_TRUE(test, attach->selected);
+	KUNIT_EXPECT_PTR_EQ(test, dma_buf_attach_map_type(attach)->type,
+			    &mock_type_a);
+	mock_pin_err = 0;
+
+	dma_buf_mapping_unmap(attach, mapping, DMA_BIDIRECTIONAL);
+	dma_resv_unlock(dmabuf->resv);
+
+	dma_buf_detach(dmabuf, attach);
+	dma_buf_put(dmabuf);
+
+	mock_type_a.map = NULL;
+	mock_type_a.unmap = NULL;
+	mock_type_b.map = NULL;
+	mock_type_b.unmap = NULL;
+}
+
 static const struct dma_exporter dma_exporter_params[] = {
 	{ &mock_dmabuf_simple_sgt_ops, "simple_sgt" },
 	{ &mock_dmabuf_two_exp_ops, "two_exp" },
@@ -389,6 +877,11 @@ static struct kunit_case dma_mapping_cases[] = {
 	KUNIT_CASE(test_match_importer_priority),
 	KUNIT_CASE_PARAM(test_sgt_attach, dma_exporter_gen_params),
 	KUNIT_CASE(test_mock_attach),
+	KUNIT_CASE(test_match_set_is_final),
+	KUNIT_CASE(test_select_at_map),
+	KUNIT_CASE(test_select_at_pin),
+	KUNIT_CASE(test_select_survives_failed_map),
+	KUNIT_CASE(test_select_after_failed_pin),
 	{}
 };
 

-- 
2.54.0

