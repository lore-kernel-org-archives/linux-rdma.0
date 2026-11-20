Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.193.44
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795154201;
	b=4gcpdL7q6hvyZ5xk+bgGmL5BsCPPaPFBdSyXh6D+nPsV457tKWou5gmG9RELjvNwcNmw
	 FfxtM1261cdDIXmsqEdnZ1C1J3E/aP112oC2jvAe0nJZUyrmI5FGuKf7iAYrd1MhP5+q9
	 vQ7AL5KiZ4e9LioySgY2+hIASDgo+mZTv9LqKBadQNV57rgYoEqYXpWPhL7yBGc634+CL
	 Hyq5+NbQarxqLPlg/SPToeH2CQ1kOvwNoyDukYolNUvTVt4baAo+QQ5S3CKNl+cHhZQTa
	 BY74r+YTY8DzDVXtZ+H+4kDSV2TiGs+e2Xf90TF98Fe/vPvuOx+wS26o55rs02nnwYQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795154201;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:Subject:Date:
	 Message-Id:Content-Type:Content-Transfer-Encoding:X-B4-Tracking:
	 X-Change-ID:To:Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:
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
	bh=RCzJ7l/yM8HsunVHdXvmoc8PxMe33huRWpoj6XFOnFQ=;
	b=3IVEzMC0U3tGrQ5jXKHXE7CaqT8FgzFIM3QZlNAR9us2AzRJtZatnhH2T+QvugMjlaGm
	 So2yYeq4eiNGVR65NwVS2e8LOzlweU0DFqTF+HxTG3eCfzSYSsKWOyWGrb/V65qR0dUJV
	 BTsIMyEXId5bZuNW5QQhPfNSOJnEmXJIJOqwpHsY5MEiWyPiV4DlwaWV8sX0RFxgR8GSn
	 sLpOZb033Ntu0YNUqyuGxb8+xuihfq80sRQFKhtRHGnmyVjGTFUCIkdvi/oa5WdrlIcCB
	 RHEUip0ICql7BXW/lgkn+NMp9mmVpMY4cEeFgETxHuNQ3KEJkmoIhggr8YFVbFGxq2A==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=ER0kMiKk;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.193.44
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010044.outbound.protection.outlook.com [52.101.193.44])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B095A606A320;
	Fri, 20 Nov 2026 05:56:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B095A606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=ER0kMiKk
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TL9cjzpKWCnr2q1JAVusbIKpxq1Q/vvNNP9+TmBtzo4AzLgZQX9Lrse8c5VMptkl6RG4XxLK1OSPCPMFaGH6I2UeKTf/sqfprGZ2UVPKhzCTds/NVFdi/5cKFU8Q0ZClhbfDuu7kdiGWP4FdiYC4BE9ZfUgIImL2gO3dR7YwTF2Fdn5qLzOcG1c3VHTIobnMGTj+GxaGUgqotYBNG7aTGmW06FqRLciSTSB4sItkfK7fSp1SxgnpTKu8LCT5DHqDUCNcButWRh4KVQMHRj5+P143KSjYIz/KvR+lxjPuNgkatQU8BxIW5DiexG+hcmTk0RtRVgHoeN7vkksdsuIGEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RCzJ7l/yM8HsunVHdXvmoc8PxMe33huRWpoj6XFOnFQ=;
 b=y1pHZVtnNWOc4LMTQ11Hgn4V5UuXjmXUvQPb8cn+1FepQ8EDYEFqsi/N57C36IfAS+Dpz0cE0r7hEzJAUbLPrrG+wbPR1jVdcA9KGDU7jY3eChcrSBsJK4TYFbfTkjiiWkrqv8VEy7ypNbqgHd/TcM138K9NNIzOcoW3IWB4vfyT4UUiB32SKbKmzp9s+Evvm86GjlnoGZyesUsgsUIw5uJPkXrVtU+X0stoHLR8vO7eLKPxYCWAuElXTAPTQyrD2rH6JtvQNyn4QUjGN2i+1vcWuGv4CPHCUtLSCNgXOK7fVOTHjZ++QCEf5sUImR2mPBfT7w3DZkO/EIL1T458pQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RCzJ7l/yM8HsunVHdXvmoc8PxMe33huRWpoj6XFOnFQ=;
 b=ER0kMiKkoeDjo+MzPyj6sQGJGWfKkP//OJtt7nc6HK+sKU01wEuAgjM70iExemvvCvSEE6argXmo3oa0/LBwJS41EkpmfeIdH/1z+6F8HtGsbQyXodSYDHgHjiGW8kRrqoG9hLZXdTp1KIAwm9MpvvhRZshgOqmX148daCAyyCkWbmhBZasdPpiLqNj2z3tMDnlOAjRsu2koPE4aBM5mGO41el+5g67ZrOUJEmDwXfNugV9J3bDF+5WrLkZBMh2mlusX6IYqDe3/uNyRrLlELEMC/rtipDRO0OJF7ePwrzsZr342ptjtes5ZcIPVeJoR0v+7emSD1fyDeNQVkkpYvw==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SA3PR12MB598757.namprd12.prod.outlook.com
 (2603:10b6:806:52d::14) by IA0PR12MB7675.namprd12.prod.outlook.com
 (2603:10b6:208:433::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Fri, 20 Nov
 2026 05:56:32 +0000
Received: from SA3PR12MB598757.namprd12.prod.outlook.com
 ([fe80::e206:100:5946:a777]) by SA3PR12MB598757.namprd12.prod.outlook.com
 ([fe80::e206:100:5946:a777%5]) with mapi id 15.21.0639.011; Fri, 20 Nov 2026
 05:56:32 +0000
From: Alistair Popple <apopple@nvidia.com>
Subject: [PATCH v3 00/24] DMA-buf mapping types
Date: Fri, 20 Nov 2026 16:55:38 +1100
Message-Id: <20261120-dma_mapping_type_v4-v3-0-c0183a409bdf@nvidia.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIANrg/2oC/32Nyw6DIBBFf6WZdWmAPsCu+h+NMQijThORgCU1x
 n+v2n2XJzn33BkSRsIE98MMETMlGvwK5+MBbGd8i4zcyiC5vAnBr8z1pupNCOTbapwCVvnCGiW
 E5nWhFGpYlyFiQ5+9+ix/nN71C+24pTajozQOcdpvs9y8/w9ZMs6UrrWzhUHNzcNncmROduihX
 JblC5ISQ0vJAAAA
X-Change-ID: 20261105-dma_mapping_type_v4-f71180b977e8
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795154186; l=15186;
 i=apopple@nvidia.com; s=20261105; h=from:subject:message-id;
 bh=VUlh2SB+BFt47bJYLSE2vbsaVq5pXM/G98L1x6Rf66g=;
 b=+uCSVvUU3zuOcHtpYqc9un+ipAaqBMplES7uXyqH+cnUt4ko2tYWOAoCOeEGHIoDTfJFQBJvw
 MthlunmK/3mD8rtO/EADM3TMSjfEuUmmBSbn39b8zd+H+RjVaZgL8N1
X-Developer-Key: i=apopple@nvidia.com; a=ed25519;
 pk=WdWPT9rAq3YNfXldbGv1NSGVLGxzQGFGJvRUiShhNqs=
X-ClientProxiedBy: SY5P282CA0193.AUSP282.PROD.OUTLOOK.COM
 (2603:10c6:10:249::16) To SA3PR12MB598757.namprd12.prod.outlook.com
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
X-MS-Office365-Filtering-Correlation-Id: 46f32a5b-1e3a-4d51-5ff5-08df46cb0737
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|7416014|366016|1800799024|921020|10067099003|11063799006|5023799004|56012099006|261022113327099003|261021123027099003|261028144727099003|261022105027099003|261026121527099003|261026140227099003|261022075727099003|261021135927099003|261021121427099003|261102130727099003|261102123227099003|261009220027099003|261009223027099003|261009221727099003|261009221227099003|261009223327099003|18002099003|6133799003|3023799007;
X-Microsoft-Antispam-Message-Info:
	R3lnCADBMpmRNfJck8ZtMhHzh4ECMhQzCAUzqc83heeoGP1wuTvniK7GhaO5+RFinj78QYkcTgNgaz0+vT3WXOmrBp0fe2El7QIkqkxx26yn/VGnvFq4niDNvbA8RVntdYbiMp5K3fxDNjqa24E6CgWu0zkS3GJJoEGPpRm1kYD0I188hzKTxz9zO+dbYMb+CUXnw0RQm+IiEbMFUFXw/U+i3NOuwjVegDji3fCBT2ZGy3ebVbRux7Fqgdy5Vythe4jzt/22Yho1iTAWsvhtMXWh0vJj6kEPC+pJhMZvvE/BcGG2J/3YyRGnHsjbuxNk2bD7dAsEcDgHqhHQD5tq10/9pwU4FI2QT/gbDNRgYQaVCK0lJJdkbqgiezxTtp3Es8ZS6YOPW/WYFAkxeRG4KG2xXsIzX+i16vwm6NSQp1HUR0Xx7OKMp5vYJHpI92MTQSWuH0puL/hnfCEgWPMiVMewlzpptU2lJwBRt0LODicME6qxPHjjR0/z38lOq1w2aPh9XwijkOTB5V3VwJLu1hW6P1vGTgC49W+LdSUXO+IvnrowFvjjEtv3VD0vKVBW2QTKmzfpFklJt4wUR1rP0fOg7McMxBsJuM1IlTpMsZwkoByYr4Wo93jOHlk79Y9RE1EL2rDBn8AJU3odb+0o1TR0z5qtSYUEK6SHTHonEcWBjciJqQcCpElqIezh47SNFy0hMveDT1pVu1qWmsY6Yg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA3PR12MB598757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(7416014)(366016)(1800799024)(921020)(10067099003)(11063799006)(5023799004)(56012099006)(261022113327099003)(261021123027099003)(261028144727099003)(261022105027099003)(261026121527099003)(261026140227099003)(261022075727099003)(261021135927099003)(261021121427099003)(261102130727099003)(261102123227099003)(261009220027099003)(261009223027099003)(261009221727099003)(261009221227099003)(261009223327099003)(18002099003)(6133799003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bWNpMXphcjdFOWZENjNJMWI1SHdxejRCcVdxWkJLSWNDMnErVkJBazU4QVBk?=
 =?utf-8?B?UGQ2ZXhhSmVIZ2YvUmtpdFFzdFdXallFNHdGL3haY2s0OFlYazRYNEtFYXkv?=
 =?utf-8?B?cDgvd05hZ2phZTBQSXg5N0lKVDdLVDBvdlZvK0tkK2tvYmFCVHZhQmZPRGk2?=
 =?utf-8?B?MGVPK3owTFo4cnFna3lkZXZxbXp1QzY0S0tPOGcxeXFXUDlvNmJsc1JTMkdZ?=
 =?utf-8?B?eXV2dzVhVnNxNGtrZEZVT0JLY2lqT0tXNlZJNWZzZ2VLSlpFSDdXcFpQNGl2?=
 =?utf-8?B?a3M1NHVhRW0vVFgzSHJxY0I1MklrTkJyMkpsUWZFcTNmVjJrMGhYY3VDdStO?=
 =?utf-8?B?OW9VUWtvV05rZXZMTkd0M0RRV0tnM1hMTWtzV2pvSlB6ZGhlOTBLa3F4OFk0?=
 =?utf-8?B?d1ExaHlSUzdLUEN0V2kzVVJONDRvajdHMnVHUHI1OUZ3SGlnNk5JQVBqUDJP?=
 =?utf-8?B?VnJPR21jSWtSN3hoRXBwK0R3dEFZR0RHMFdoUnlQOXVDNDNTaSswaE1WaUtO?=
 =?utf-8?B?d3NWc1NFbTNKR1ptK25jbXNKRXhUejVmL0ZrN1BJK0VkYW9ESERudlRLQ056?=
 =?utf-8?B?QkM0KzY0SlBZaDJRNjV2MXo0UzhUMEt2czdTRTZPa3VwL00yMjVFbmE3Wnp4?=
 =?utf-8?B?RmQ3UGFEbFViSW5QazViSFM2UGZQZ1dQTnlDZ0hTOGoyWVBwVXorcDBlU1Bx?=
 =?utf-8?B?OFR1Vk1zM0hzRk8vOFFEb24xWFFGcmxMdGRwVUIvcUs2UWFlUUU4dEZJVm42?=
 =?utf-8?B?bnh0elk4by9HYm1UN1pLcXNpMmNOdHljeWtRNFpTbkpVRFpoUUx6QjVYWjRC?=
 =?utf-8?B?cHB3YXB3bVE0UFZYMFhvS0h0R1NyNmZLeWRMWG9LY2NhS2Y4VmFEVVhUSjJN?=
 =?utf-8?B?Um1XUFRIS2YzbnhQdGRFRXN2TmZwWVo5bjZtTkNFMFIvYkp5VFNNekxIQXZs?=
 =?utf-8?B?VXlMd2t2aUw3b29vaGpYTWVmdjlMbDBkdEM5USt1SkhRdUY4MGtPcHJraXQ1?=
 =?utf-8?B?NFkrMXdWNS92aHZ0V2hsNlRGeDhPU2xFenNJTXF4clRzUklxZ0xNUmw5RWd6?=
 =?utf-8?B?TEhJTkIxNDZlRU45ZkVoT3M5TXRPWHpKWVVMMVgvVjU3S0hDMVN2R2RQZkFj?=
 =?utf-8?B?Y25ia2xCUzRhQ1g1QlJ3TkFoRmZLa2xnSHo4c0htYWtPa21XSmhEN3hUSDBq?=
 =?utf-8?B?d2Eyd2pDZHdnYThSYnp5R0tGWHVXOCtJYWxyeGYzN2M2cTRYSFdzNzlBSGlO?=
 =?utf-8?B?a1ZwMzZBQ2ZFbmV4MC9EYTc3azh1bUtXTHhOYXNJVkV5eFV5WWNZaGNRY003?=
 =?utf-8?B?dHowc2g5K3R3S1FBT2lSaWhlbmkzS2hnYmFUVm1neTZuay9xU3FOV1pxNHM4?=
 =?utf-8?B?OGZFVUtDaTJENTlwOEVNZm82UzRPeDdYZXViMld1ZW9OYjBxeGZBcDVobWp3?=
 =?utf-8?B?YVdibVB1YTM3aXdCU1FQcU43dGNWdFhEeXlqSmVpZVFLdDJpRDBoalU5Rk5K?=
 =?utf-8?B?QnJpYm5WQ0Z3NWROb0RTZFZHSmpzWTFGR08wZVlieWNWYk9reXkzeGROMk94?=
 =?utf-8?B?ZXQzdGlUa2FrWVFqTmtlbGRjZUkxUUNtUEVkUVhrWW9OSk8wT2FFRXZYQnZW?=
 =?utf-8?B?aFFSUmlrdm1YSXNISWs4YzZvWHJPZG53LzlYU3BkVHNWOHNZejhNTktsbndV?=
 =?utf-8?B?ODdrelJqUmtOQUljM1VjTHQ1WlBWaS9UUExDd3ZDMExscEs1YVJGOTg4UUd2?=
 =?utf-8?B?UUhjVWxlOHdMUVRhTzE2ZlFOZG5iM3dhUXF3Zm5TQVk3YWZHVWZRV3ZSNTB5?=
 =?utf-8?B?VCt0SFVVbGlLdWFrb1IvVEdaLy8yMGZnN05aNHdCRzluR0I2MXczQ1BTcE04?=
 =?utf-8?B?WHVOUzJ6TkIvS0IxNFcweXpmeWlUSnFqblk4a0VhOG5iSytCZnpETENBSFBw?=
 =?utf-8?B?Nm1yV1I0MnpSSnJ5d3R1dlRtNlQvYzBJeFJoWDU5VUp5UFFIQ0xGQjdseGMx?=
 =?utf-8?B?VUp4L2J1ZzF4ZVhOdTJ6cGNhbFlaaU9Xd0FZeXVvUlcvT3JTTkJpaWFlREoz?=
 =?utf-8?B?dnJEWW1TOVk4UmVYUk84Y2FNdzBlc290dkxaWEVZSGRNSnU3RmR5MGc4dEg1?=
 =?utf-8?B?MGtRbGphaXFYZTF3OFpKamhUdkc4bzNkQ1VSSXQrTHdsVHlvbHJvaE9sNDI1?=
 =?utf-8?B?RTk4aVZLcjhTbjdIZDdYK3ZWaUpLSHlwM1o5WGRRNkZ3RkRncmxDTHdoU25R?=
 =?utf-8?B?bTBORmFaWmVaMzhSbzVUVjR0N1RTVVNhMDZDMzR3SFRqN0xJMGQwdXNSa3k0?=
 =?utf-8?B?endKRGlMZWJxb1dPODQ4V2t2YTU0QUFaekpWaksyV1R5UWlJL2hOUT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 46f32a5b-1e3a-4d51-5ff5-08df46cb0737
X-MS-Exchange-CrossTenant-AuthSource: SA3PR12MB598757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2026 05:56:32.5652
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WmHYzyVMZuV/ms/UTdsqrqVqdqelAWqu0vNs5ekAiC38/Le0J9+wBe+0t/k8CvgFpCcqbbrXFaE4Gs6PCaT1xw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7675

This is v3 of the DMA-buf mapping types series [1]. The main difference
from v2 is exporters have been changed to allocate a type-specific
mapping struct and the PCIe P2P changes have been deferred to a
follow-up patch series. The exporter conversion was primarily motivated
by a need to have the importer call the correct unmap functions even
if the selected attachment type has subsequently changed after an
invalidation.

Doing this conversion though will make it easier in future to move away
from providing the sgt data type to importers. A future patch series
will be posted to do that.

The PCIe P2P work was deferred in order to keep this series mostly a
mechanical "no behavioural change" that introduces the types, does the
conversion of exporters and adds the type selection contract/logic.

A follow up adding PCIe P2P as its own type will be posted shortly after
this.

Patch Summary
-------------

Patch 1 renames dma_buf_(un)map_attachment() to dma_buf_(un)map_sgt().

Patches 2-6 introduce the DMA-buf mapping type system, initially
developed by Jason Gunthorpe.

Patches 7-19 convert exporters to allocate and return a
dma_buf_sgt_mapping embedding an sg_table instead of an sg_table
directly. These are mechanical and should not change behaviour.

The mechanical changes for smaller drivers has been split up by class
based on how the sg_table is allocated (eg. per-map, attachment, etc.)
with corner cases getting their own patch. Larger drivers, such as Intel
Xe and amdgpu also get their own patch.

Patch 20 removes the compatibility code the conversion needed and patch
21 adds KUnit tests for the matching rules.

Patches 22-24 add the contract and logic for making and changing
exporter types. Nothing currently exports two types, but a follow up
series building on this with a PCIe P2P type will be posted shortly.

Future Work
-----------

Several series will build on top of this. Current proposals are:

1. A PCIe P2P mapping type series to handle P2P negotiation.
2. An exporter type that allows conversion to iommufd or new DMA address
   list instead of sg_table.
3. Possible exporters/importers for private interconnects such
   as converting existing XGMI code to use this or future UALink
   exporters/importers.

Why mapping types
-----------------

Since its introduction, DMA-buf has only supported using scatterlist for
the exporter and importer to exchange address information.  This is not
sufficient for all use cases as dma_addr_t is a very specific and limited
type that should not be abused for things unrelated to the DMA API.

There are several motivations for addressing this now:
 1) VFIO to IOMMUFD and KVM requires a physical address, not a dma_addr_t
    scatterlist, it cannot be represented in the scatterlist structure
 2) xe vGPU requires the host driver to accept a DMABUF from VFIO of its
    own VF and convert it into an internal VRAM address on the PF
 3) We are starting to look at replacement datastructures for
    scatterlist
 4) Ideas around UALink/etc are suggesting not using the DMA API
 5) Private interconnects, such as XGMI, are forced to work around this using
    driver-specific hacks.

None of these can be achieved using scatterlist. This series introduces a
"mapping type" mechanism allowing dma-buf to negotiate compatibility between
different types and support alternate mapping options. See the description of
patch 2 for more details.

Selecting mapping type
----------------------

Importers and exporters list possible mapping types with the exporter
responsible for selecting the final type at pin/map time under the dma_resv
lock. A matching phase at attachment time eliminates types which statically
cannot be supported for a given exporter/importer.

At pin/map the exporter chooses one of the types matched, taking the other
attachments and the buffer's placement into account. That choice is held by the
core until the exporter explicitly invalidates the attachment. This ensures
unmap/remap cannot cause buffer movement and ping/pong.

The dma-buf core enforces this by calling select_mapping() only on the
first pin/map after attach or after an invalidate. The pin/map type
can therefore only change once the exporter has explicitly invalidated
the mapping and the choice is remembered across unmap/map.

Testing
-------

- KUnit dma-buf-mapping suite passes with new tests to address issue
  found by Karl previously.
- iommufd self-test passes.
- Every patch compile-tested with a config enabling all converted drivers.
- A small test exporting via vfio-pci and importing and pinning via iommufd.

Changes since v2
----------------

Link to v2: https://patch.msgid.link/20261105-dma_mapping_type_v4-v2-0-78b8dc9ae80a@nvidia.com

- PCIe P2P is no longer negotiated in this series. P2P keeps working
  through allow_peer2peer and attach->peer2peer exactly as today, a
  future series will introduce a PCIe P2P type to introduce negotiation.
- Exporters allocate a mapping object with sg_table embedded and their
  unmap takes it back.
- Exporter unmap callbacks take the DMA device from the mapping rather
  than from the attachment so a mapping that outlives an invalidate and a
  new selection is unmapped against the device it was made for.
- dma_buf_map_sgt() and dma_buf_unmap_sgt() are now wrappers around the
  generic dma_buf_mapping_map() and dma_buf_mapping_unmap().
- The single "Convert all the simple exporters" patch is split by class
  of change.
- A pre-existing leak in fsl_asrc_m2m's unmap was fixed as a side-effect.
- Added more KUnit tests to test corner cases identified by Karl in
  previous postings.

Changes since v1 [2]
--------------------

- Rebased onto v7.4-rc1. The rename also covers the new nvme-pci DMA-buf
  importer and devmem's switch to pinning. xe's dynamic-debug knob for the
  p2pdma distance check (3bc497a40178) is dropped, since the check is now
  done by the core at match time, and amdgpu's PREEMPT-domain import
  decision (78cdd96ab497) asks the negotiated match set instead of
  attach->peer2peer.
- The dma_buf_map_attachment()/dma_buf_unmap_attachment() rename is now the
  first patch, squashed into one, and uses the shorter dma_buf_map_sgt() and
  dma_buf_unmap_sgt() names (Christian [3]).
- Dropped dma_buf_mapping_attach() and the dma_buf_sgt_attach() /
  dma_buf_sgt_dynamic_attach() renames. Importers that support more than
  the SGT type list them in a static dma_buf_attach_ops
  ->supported_mapping_types table. The importing device is passed to the
  mapping types through the match arguments rather than stored in each
  entry. dma_buf_attach() and dma_buf_dynamic_attach() are unchanged for
  everyone else (Christian [3]).
- The selected type is an index into the attachment's match set, read
  through dma_buf_attach_map_type(), instead of a copy in attach->map_type.
  finish_match() fills the match set entry directly and select_mapping()
  returns the index.
- A failed pin or map only undoes a selection it made itself, so a map
  failing under a held pin keeps the pinned type and a failed first pin
  leaves the attachment unselected; KUnit tests for both.
- dma_buf_match_mapping() returns -EOPNOTSUPP when the two sides have no
  type in common, keeping -EINVAL for an empty list, which restores the
  error xe's own tests expect (Sashiko).
- New DMA_SGT_EXPORTER_REQUIRES_P2P flavour that requires a P2P capable
  importer without a pci_p2pdma_distance() check at match time, used by
  vfio and uverbs so iommufd's non-PCI device can still attach and so no
  pci_dev is dereferenced outside the dma_resv lock (Sashiko).
- The SGT P2P distance check is quiet, as it was in xe and amdgpu before
  the conversion (Sashiko).
- Fixed a NULL importer_ops dereference in dma_buf_dynamic_attach() and the
  NULL check order in dma_buf_unmap_sgt() (Sashiko).
- Signed-off-by added to every patch (Jason). Patch 4 is now authored by me
  with Jason as co-developer, as little of the original remains.
- Not addressed: the Tegra fault with CONFIG_DMABUF_DEBUG that Karl
  reported [4] is a pre-existing Tegra bug being fixed separately.

Changes since RFC v1 [1]
------------------------

- Dropped the PAL type and its vfio/iommufd users (RFC 21-25).
- Rebased onto v7.3-rc5: move_notify is now invalidate_mappings,
  CONFIG_DMABUF_MOVE_NOTIFY is gone, new amdxdna/panfrost/panthor
  exporters converted, kzalloc_obj().
- Patch 1 records the whole match set in a fixed-size array in the
  attachment; patch 3 initialises the attachment before match_mapping()
  (Karl); patch 15 holds a pci_dev reference instead of asserting the resv
  lock (Baolu).
- New patches 5, 6 and 7: exporter selection at pin/map with core-enforced
  stickiness, match set queries, and dma_buf_mapping_map()/unmap().
- xe and amdgpu conversions written against the final API; amdgpu's XGMI
  override rewrites the recorded match set entry.
- New patch 26 with KUnit tests for the selection contract.

[1] https://lore.kernel.org/all/0-v1-b5cab63049c0+191af-dmabuf_map_type_jgg@nvidia.com/
[2] https://lore.kernel.org/all/20261026053623.202642-1-apopple@nvidia.com/
[3] https://lore.kernel.org/all/3151a820-c583-4968-8440-673a9e390446@amd.com/
[4] https://lore.kernel.org/all/auAIO0y09SXk34CN@gmail.com/

---
Alistair Popple (14):
      dma-buf: Negotiate the mapping type in dma_buf_dynamic_attach()
      dma-buf: Allow single exporter drivers to avoid the match_mapping function
      dma-buf: Convert exporters allocating a table per map to the SGT mapping type
      iommufd/selftest: Convert the test exporter to the SGT mapping type
      dma-buf: Convert exporters keeping a table per attachment to the SGT mapping type
      drm: Convert drm_gem_map_dma_buf() and its users to the SGT mapping type
      udmabuf: Convert to the SGT mapping type
      drm/omapdrm: Convert to the SGT mapping type
      accel/ivpu: Convert the userptr exporter to the SGT mapping type
      dma-buf: Convert dma_buf_phys_vec_to_sgt() and its users to the SGT mapping type
      dma-buf: Remove unused SGT stuff from the common structures
      dma-buf: Let the exporter select mapping type at pin/map
      dma-buf: Add dma_buf_mapping_map() returning a type-tagged mapping and implement it for sgt
      dma-buf: Add kunit tests for mapping type selection

Jason Gunthorpe (10):
      treewide: Rename dma_buf_(un)map_attachment() to dma_buf_(un)map_sgt()
      dma-buf: Introduce DMA-buf mapping types
      dma-buf: Add the SGT DMA mapping type
      dma-buf: Route SGT related actions through the attachment's mapping type
      drm/xe/dma-buf: Use the SGT mapping type
      drm/amdgpu: Use the SGT mapping type
      drm/vmwgfx: Use match_mapping instead of dummy calls
      iio: buffer: convert to use the SGT mapping type
      functionfs: convert to use the SGT mapping type
      dma-buf: Add kunit tests for mapping type

 drivers/accel/amdxdna/amdxdna_cbuf.c               |   30 +-
 drivers/accel/amdxdna/amdxdna_gem.c                |   11 +-
 drivers/accel/amdxdna/amdxdna_ubuf.c               |   34 +-
 drivers/accel/habanalabs/common/memory.c           |   52 +-
 drivers/accel/ivpu/ivpu_gem.c                      |    6 +-
 drivers/accel/ivpu/ivpu_gem_userptr.c              |   29 +-
 drivers/accel/qaic/qaic_data.c                     |    6 +-
 drivers/dma-buf/Makefile                           |    1 +
 drivers/dma-buf/dma-buf-mapping-internal.h         |   39 +
 drivers/dma-buf/dma-buf-mapping.c                  |  307 +++++-
 drivers/dma-buf/dma-buf.c                          |  349 ++++--
 drivers/dma-buf/heaps/cma_heap.c                   |   33 +-
 drivers/dma-buf/heaps/system_heap.c                |   34 +-
 drivers/dma-buf/st-dma-mapping.c                   | 1106 ++++++++++++++++++++
 drivers/dma-buf/udmabuf.c                          |   71 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_dma_buf.c        |   85 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c            |   29 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.h            |    4 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c       |   30 +-
 drivers/gpu/drm/armada/armada_gem.c                |   52 +-
 drivers/gpu/drm/drm_prime.c                        |   78 +-
 drivers/gpu/drm/i915/gem/i915_gem_dmabuf.c         |   31 +-
 drivers/gpu/drm/i915/gem/i915_gem_object.c         |    2 +-
 .../gpu/drm/i915/gem/selftests/i915_gem_dmabuf.c   |    4 +-
 drivers/gpu/drm/i915/gem/selftests/mock_dmabuf.c   |   30 +-
 drivers/gpu/drm/msm/msm_gem_prime.c                |    7 +-
 drivers/gpu/drm/omapdrm/omap_gem_dmabuf.c          |   51 +-
 drivers/gpu/drm/panfrost/panfrost_gem.c            |   27 +-
 drivers/gpu/drm/panthor/panthor_gem.c              |   25 +-
 drivers/gpu/drm/tegra/gem.c                        |   44 +-
 drivers/gpu/drm/virtio/virtgpu_drv.h               |    9 +-
 drivers/gpu/drm/virtio/virtgpu_prime.c             |   30 +-
 drivers/gpu/drm/virtio/virtgpu_vram.c              |   25 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_prime.c              |   32 +-
 drivers/gpu/drm/xe/xe_bo.c                         |   16 +-
 drivers/gpu/drm/xe/xe_dma_buf.c                    |   62 +-
 drivers/gpu/drm/xe/xe_ttm_vram_mgr.c               |   22 +-
 drivers/gpu/drm/xe/xe_ttm_vram_mgr.h               |    2 +-
 drivers/iio/industrialio-buffer.c                  |   13 +-
 drivers/infiniband/core/umem_dmabuf.c              |    8 +-
 drivers/infiniband/core/uverbs_std_types_dmabuf.c  |   23 +-
 drivers/iommu/iommufd/selftest.c                   |   22 +-
 drivers/media/common/videobuf2/videobuf2-core.c    |    2 +-
 .../media/common/videobuf2/videobuf2-dma-contig.c  |   42 +-
 drivers/media/common/videobuf2/videobuf2-dma-sg.c  |   37 +-
 drivers/media/common/videobuf2/videobuf2-vmalloc.c |   32 +-
 .../media/platform/nvidia/tegra-vde/dmabuf-cache.c |    6 +-
 drivers/misc/fastrpc.c                             |   36 +-
 drivers/nvme/host/pci-dmabuf.c                     |    6 +-
 drivers/tee/tee_heap.c                             |   28 +-
 drivers/usb/gadget/function/f_fs.c                 |    9 +-
 drivers/vfio/pci/vfio_pci_dmabuf.c                 |   24 +-
 drivers/xen/gntdev-dmabuf.c                        |   75 +-
 include/drm/drm_prime.h                            |    8 +-
 include/linux/dma-buf-mapping.h                    |  366 ++++++-
 include/linux/dma-buf.h                            |  212 ++--
 include/trace/events/dma_buf.h                     |    2 +-
 io_uring/zcrx.c                                    |    6 +-
 net/core/devmem.c                                  |    8 +-
 samples/vfio-mdev/mbochs.c                         |   31 +-
 sound/soc/fsl/fsl_asrc_m2m.c                       |   32 +-
 61 files changed, 2972 insertions(+), 861 deletions(-)
---
base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
change-id: 20261105-dma_mapping_type_v4-f71180b977e8

Best regards,
--  
Alistair Popple <apopple@nvidia.com>

