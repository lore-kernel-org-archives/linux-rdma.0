Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.62.7
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793860954;
	b=1i0sNXC3UdTEfC0//AFS3Q6QQj75Bjf0z3pf6UDD+qGqgVOvGoXIhKieGnyJL19tr/bj
	 8YR8zXbLtpit54uaCtaECCxumb9UPcrrEOXJJjcZHZ28F2VSQ97OwTO4MWT0/LeQa+2cU
	 KZEu95Gl4xNek80haxeTB537y/KxHgS/v5U69H0YlkfNXY1oi29joGmajvfy5ZuyAccgH
	 TpvF3QyRdzu7abRFP9KNOtZHtejREqdsLfR7xa0WtfoTTNlZz8H4VeK+qpLnvb0v0f9p0
	 uD/1phkg2Sp+823NP8lAYqd7Zje8EoC0B1a5y+e0zj4e34VZWbZpiTQaxQl99fYpgCg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793860954;
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
	bh=W0xlRST0KLD/mye0t7G/drYY9wOD93SgfsLM/fCSrYM=;
	b=t0oq0VUs5aOjyXEVyfun1vRac4BAi1K0X0YfyR0krvXHsMQbhaBtqwKM+AtGMkrLZvwZ
	 x5wwPgIEF1kaUYI5xZHEOK4wRWnoyavhtJtvNI++0iJ7k+RI+9miWgpOy5pN9oU9OhWWY
	 tl77QQN5vRyQ61as/gW9vgrjdZJkn3f20dabtE8F3h4HtAfJVs7KSWqVWSybjPLK8Yi2Z
	 7KNYEMkcAaj1k+D75+RhobDhqrb3ZkpQeR9VTk3nAs3QEauCxQFHmnFYw1SmUnlLwKZ6S
	 7CAdwQZmDEFEJkUcJyWWYQRJrXe2bi2rFtzBWP2hgdY+ThZ1qXfggYsdfUsFFmQk5nw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=CdRIw7Do;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.62.7
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011007.outbound.protection.outlook.com [52.101.62.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5CF6606A336;
	Thu,  5 Nov 2026 06:42:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E5CF6606A336
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=CdRIw7Do
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Tk4k31VSD63e2l4gE1t2hItB5pQIxWG+IrWykZlRKJJlYomBfujc0/RQKx1W8TdKybOxou64MhZ0xsRgp+d2dqr6L1fro1kP2gTvFIu0VT3tUhXp55k1OyjBg09c3Fe+ReeIaykMnanljfTPDBQyXC5tFlq7aYRbLLUHKu3L9rF4MrE1DsE9DB9tB9pQBH2IB9woMZCIH87YTSJPTUgMnLlZyRgTFIzygBp7X7vtGqAll+vvA37mldJPcVK/vFD4AEbfs0Pgz5q5ogt3SN5gOMXdDOchUv1Drvtj06fbl5LaixlM11r4vlneO3oyF9u+5xdvj7r2aTzEYD1CHp3bBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W0xlRST0KLD/mye0t7G/drYY9wOD93SgfsLM/fCSrYM=;
 b=wBez9LmpJ8DGQcaNZFS3lVLBT01ENpCss8e7TfCi/FH8V/1jT36kybVyz+NJcNvYG7+HoxC2xORXlE1QphZwML4e6R/L7yyfVsRCC0D4w1udN7hB8y7dNqfeblVIFBj8ehHBdD0mmQGea/G4zKhZ00SukbL5YK++B6XbKThKIv2HrR99NpNG88yqGk5Buq6lBwALBYChlEepYIpIUyyFq49K/xSKjnwl5I9cWdedKBjiugxu+L2Dde8+5t5thvUAfQUYXyzQQtujW/e3AGTdkUz8Zo14ekbLli3hiNAaM2RSEaLR2Ksd9pwC+8Q07cuBgX5ISE2k09Ikuuf9BCFm1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W0xlRST0KLD/mye0t7G/drYY9wOD93SgfsLM/fCSrYM=;
 b=CdRIw7DoFgpxqQ5I/1wFdq4xSD3Q025EngC+2JTy1UMHbdFYTlzsN5GzuIiRUV0elP9ZVYQeTloJrM9OaPjCv8tk1QBkQTSLDh8dopekg2sIo9gOq/tr4ukDI1Azi2uJRYyFEDaZu73wFvrpieB92moc7/H7DNyPMkA4XmkE+K8sE9p70rDjYCUxlaCp+T+1D8PxhxccWqsMCXEQJNl94v3lThpHaCGFq03rkSgfwDEJQoRh5MacpJTZpN6bYczoNabVBrgQpBgdFzjt7hEqzp0nIsjP81V9fJ1hTjNvwEoDLjqnyp/BNZHOfNRaoXPeGQNBh9lvLTjbEGmi1hvbBQ==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SA3PR12MB598757.namprd12.prod.outlook.com
 (2603:10b6:806:52d::14) by CH1PR12MB9573.namprd12.prod.outlook.com
 (2603:10b6:610:2ae::5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.8; Thu, 5 Nov 2026
 06:42:15 +0000
Received: from SA3PR12MB598757.namprd12.prod.outlook.com
 ([fe80::e206:100:5946:a777]) by SA3PR12MB598757.namprd12.prod.outlook.com
 ([fe80::e206:100:5946:a777%5]) with mapi id 15.21.0592.009; Thu, 5 Nov 2026
 06:42:15 +0000
From: Alistair Popple <apopple@nvidia.com>
Date: Thu, 05 Nov 2026 17:40:45 +1100
Subject: [PATCH v2 10/23] drm: Check the SGT ops for drm_gem_map_dma_buf()
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261105-dma_mapping_type_v4-v2-10-78b8dc9ae80a@nvidia.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793860879; l=1733;
 i=apopple@nvidia.com; s=20261105; h=from:subject:message-id;
 bh=SP+hChF2u/Hr/gQAhVAommESkDYt32vV8Xb/U9SN750=;
 b=LR1hQ5u6GyFcCAZnxt4LrLii7rlFksNhVzLgKs0tFzSr9sMYE21vbhG6UMzgAJmXvF/AVd/Zr
 ynJC3RbwY/SBrRhq4A9LyCes2fbpjH+3+itgaw2Vrl2gwU+kacAuDUU
X-Developer-Key: i=apopple@nvidia.com; a=ed25519;
 pk=WdWPT9rAq3YNfXldbGv1NSGVLGxzQGFGJvRUiShhNqs=
X-ClientProxiedBy: SY5P282CA0130.AUSP282.PROD.OUTLOOK.COM
 (2603:10c6:10:209::10) To SA3PR12MB598757.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA3PR12MB598757:EE_|CH1PR12MB9573:EE_
X-MS-Office365-Filtering-Correlation-Id: a9a90025-e93c-46fe-9c20-08df3b07edd2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|7416014|376014|366016|921020|261028144727099003|261021123027099003|261022075727099003|11063799006|56012099006|261009221227099003|261009223027099003|261026121527099003|261102123227099003|261021121427099003|261022105027099003|261102130727099003|261026140227099003|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	kNbE2aCLvFppOVMFzCAHeHvDtTYFtOYkInxqsBecgoHmpu51MxiDQSK1h8Jolp4sfhs5qEe//KYxe3UXs8AqUbrQ/JU4NW7g1IrSqBohUT5hV6eFGfSueWCDRqu6GkvTG6N1aThSuaPbZSAlp/JhXpH6cZLjOv3jW9v7cbm5YGJ53zMA8vfQU5EaqOQihk/BiqO8FdITF06n1YPzOnfL1xzFgh+h6zje7r//MVS3quN+7mmBlDIvotZEIfmVF+Nz7X1JxtOAPMVqbtceBCqpKrKFvK1CjJqkFrPNMCvVfxUC5fyyYpdGV8GL8IaWXodF0BD2RqT2gSL5fKpWKuDKQQmD6p0LPiD/wCAxag2tj5pzy2oRzyZIcMKN3uhjyOoSCrLncxDkX9N8TLa7omYNX9y5iiFeU859LDnl31gjfpnJR9doiW2OTlj6fLu+vESobLJqsi0q1XMupA7lDJjPc+Cyyu7UEEtoM06MsTvSGZuR0Nq2xDOBvmY+CZoRSVsMo6rbzfYjh2C5auEAnD2TGeSucn2TLg4AomxKsC4MZX9l6WOl6lcmz8noqBv5PPjVRIu2GHG55FexzIkqqBLyCpW/aFKgIa9FWujYx8Xby1+E2ba/jGdor+pkQSY+fgi1xQ7h8DLRyg11flIVwzpPbOYIPmYMTRhQVO4bq94kiSM7Dl+YoeEKCeewrqd4guoC0LpmV+G8gDe37k2Np9Ai1w==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA3PR12MB598757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(7416014)(376014)(366016)(921020)(261028144727099003)(261021123027099003)(261022075727099003)(11063799006)(56012099006)(261009221227099003)(261009223027099003)(261026121527099003)(261102123227099003)(261021121427099003)(261022105027099003)(261102130727099003)(261026140227099003)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RnZWTGJob0U2QktwREt2TldibUI3L2o5V1p5SklJa2VTWlJGQytPbHhFb2ds?=
 =?utf-8?B?L0JVb2hvL0R4ZEJIbEg5N25uUldpVEFkeDhWOFVqZjNVcnBabkYrRmp2ZUFO?=
 =?utf-8?B?Qm0zVkZwL2o5MHFqSEgyQmJCYVBNdU4rMTVCUXhQaGdBZ2hsZmZ3NzVDSVdH?=
 =?utf-8?B?VVhQN2Nnc3lEZWRhYzVSQkhlRFdhS3V1bmtvUG1OdFdoMGJkK2NpRy9Kc0Er?=
 =?utf-8?B?cFBBOWpmR2YzOVRLelI0bGhSQ2FzZ2dBR01yWE50dUdUSmw3VFk0bGZyNm5W?=
 =?utf-8?B?R0NBZHNiOFU1ajN0M2k4d0FuRzlJeXNaZWpXRjlnVnhJZG0zK1gyZVhIUzZj?=
 =?utf-8?B?a3hpd1gyVURwZm5CSkhOc1BqL0RCWmRUNVV4eGkrS3d6elUwTHF2NzNVcm9S?=
 =?utf-8?B?VlFtNEEraXZLdko5dnB3aWRsTUFpTkt4ZGdaS2dGRmJQdHkraXViV2hmVlBu?=
 =?utf-8?B?Q29qTm9MWFg3ejlIcWpoOGR2VjkrOVdSUXByVXJPMnp0YnBUYjM0UXV0Q3Z3?=
 =?utf-8?B?dThXQlptSFpQdEZwbS9ITERVYWVZNy9hUDRlMU9VMlNZMS84dFplakJFcnJP?=
 =?utf-8?B?emZ1UEtXbXA5OUZXQnZZcFBDVURadE90YjdpbHlINmNDbjl3Z0V0OWhycDMr?=
 =?utf-8?B?dVFmeUJGNUNucnZmS3dCN3RTNzRsZ1dZeWtxT09OeVpwU0l0OW5nK3VGVmRF?=
 =?utf-8?B?U3FFcDJtSklWVi9TblhxT3dlNSt1R2liUno4TC8za1dJYUFDTXhkRUxLRktv?=
 =?utf-8?B?R0FDUmg4QWhyTnZQNXJDVDRXckJkelMwU3pQL1Y2MjBLVUYzenk0Y01qenc1?=
 =?utf-8?B?aDVkRUdXRWRTTHFiRlE1MzBuZ0FhUkFweHZYLyt3dU5NYkFTU2YwMXNJZmtp?=
 =?utf-8?B?M3lXNE9PRWhrSzZiR1plWEJyeklGZ3B0YXJoM0NhNVBBWlRYbDRWWHNPTjU1?=
 =?utf-8?B?enpBc3lmNWQrZHlMSXJUV1BUYmIrRGxNZTk2L2RjM1ZtTU9pUEpZV1RyeHRx?=
 =?utf-8?B?OXFYQ25DMmEzZzQ5aUp0K29CblJCS0lmM1lpQWZhLzZPWUJNaEFOa2tKNXBw?=
 =?utf-8?B?R3E3S2ZhTUJUdHMrTHgyMFpCOW9VTGRZWUVXOTVFUDNPeHFJdTdUYUhvUGR1?=
 =?utf-8?B?d0RIV3lSOGR1bHpOWWROUDNOYy9JSzA0aEl2SDRjckJMcEllMkFLSjNlZHla?=
 =?utf-8?B?dDFLOWx4OHJzc1F1Y09CV0ZIeitKaGNIYkJiVEQ4d01pd05CWHFxdEMxY0lL?=
 =?utf-8?B?WlZoQkZ2a3dOeHRybXJ3UmxRYkNiUFpRdUpGT0F3bmFMTlh4Q1RCbHRtU0xJ?=
 =?utf-8?B?ZWRVQVIzNXpNUjhMTUwyTnRETjYxTlN5ZUlNZmhhNFZYV2Z1V1Y5K09xcnZL?=
 =?utf-8?B?QVc5amt3VnNlNTJKR2JQb1U0b011ei9jTU9USThYejdUSXh6MVNwbUNJNWVY?=
 =?utf-8?B?UHYrdzhhR1padmFXVUVaNW9UV3RKaUVVZ3RHTzE5TWx0a2pYaUNtblJvYm9o?=
 =?utf-8?B?VnZ1Z2dwNTN4M0tOZmdWaER1N0F2Z0htR0FzNTIxR1RQTmhzVUZOSmRydVlp?=
 =?utf-8?B?K0xWcE1JQ3ErV2FQWnJtc3dhbEpxcXg2Wm91YXpSKzBlYkFaWGUwckJFZGJx?=
 =?utf-8?B?QjdpdzJhRzlFSjhlK0R1WnFjWlNaTW9EUG1ZcTZkbTBIYldycUo2RllsVEhX?=
 =?utf-8?B?c0xoMStaYndGNzRuSktqNXJkM21VTURsS0hKRll2Wkp4VGhlNmcxUURSRVpB?=
 =?utf-8?B?MCtWTjBncWlnamc1d3dqK212aFhnZ0picEZrbURsYXZXQVVhYXVVaEpFQnhW?=
 =?utf-8?B?dFhmcThLSFJ1Rjhxb0gwQmkyeVhDQzQ4RWxjNWVSRlFqalhmaWd1L0lmd2tI?=
 =?utf-8?B?ajVOeC9HbjRYYkhnTHlDUkJhcGEwbGt6U3REOTZJSnZlTHVxOGRrZTFaSmVG?=
 =?utf-8?B?NnZ3alBVd2Fmdkt5TzhyVDRMK2VBNGFCUElTU1g1K2NlamJ6ODhiSnZ6bjZl?=
 =?utf-8?B?UEFuNjdDZlpxalM1RnBxWk9UTWNFQngzbmt0dlUrWEtVNnN4MHh5MzlvUktv?=
 =?utf-8?B?SEhWWllRdDVFK1krQ2tCc2RyOHRiRXNiN2RnL1RYd3gvNmQxTmY2TVJSU2Rx?=
 =?utf-8?B?UDdPYmxxV0UwSU5YNW1xcjNtNFFsNXdJWjZJVXB2MllUU2FRTklKRGNYZVpv?=
 =?utf-8?B?ejdrRHowWEUzUDIzaW9QVmVxRWpNdkl2bTExL1lubXNaZlhLZUZocDN4TU1D?=
 =?utf-8?B?dUNHVzIvVU03ZXpIbktuOVprQzQwOVg4ZVJjQ09RSkN0MHpwM0JVcUtkbTFu?=
 =?utf-8?B?YUE2UFNIQy9FTkhUcU1lQVFRUTNSNkQwcXhlZFBhYkRNTE1YQVB5QT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a9a90025-e93c-46fe-9c20-08df3b07edd2
X-MS-Exchange-CrossTenant-AuthSource: SA3PR12MB598757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2026 06:42:15.1278
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BQGKP7Wezm9sdw6kdPyuFnBWJfKWavVblUqC6I4IL50340ua6hLAMiCFZV5HN13ncdxqqJLnC8/rob61NoJ0fA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH1PR12MB9573

From: Jason Gunthorpe <jgg@nvidia.com>

When the next patch converts exporters to use SGT natively, the
dma_buf->ops->map_dma_buf will become NULL. Additionally check
sgt_exp_ops to see the new location.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Alistair Popple <apopple@nvidia.com>
---
 drivers/gpu/drm/drm_prime.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_prime.c b/drivers/gpu/drm/drm_prime.c
index e27bda3423ed..c5184ca602bc 100644
--- a/drivers/gpu/drm/drm_prime.c
+++ b/drivers/gpu/drm/drm_prime.c
@@ -28,6 +28,7 @@
 
 #include <linux/export.h>
 #include <linux/dma-buf.h>
+#include <linux/dma-buf-mapping.h>
 #include <linux/rbtree.h>
 #include <linux/module.h>
 
@@ -587,6 +588,18 @@ int drm_prime_handle_to_fd_ioctl(struct drm_device *dev, void *data,
  * option for sharing lots of buffers for rendering.
  */
 
+static bool is_gem_map_dma_buf(struct dma_buf_attachment *attach)
+{
+	const struct dma_buf_mapping_sgt_exp_ops *sgt_exp_ops =
+		dma_buf_get_sgt_ops(attach);
+
+	if (attach->dmabuf->ops->map_dma_buf == drm_gem_map_dma_buf)
+		return true;
+	if (sgt_exp_ops && sgt_exp_ops->map_dma_buf == drm_gem_map_dma_buf)
+		return true;
+	return false;
+}
+
 /**
  * drm_gem_map_attach - dma_buf attach implementation for GEM
  * @dma_buf: buffer to attach device to
@@ -608,7 +621,7 @@ int drm_gem_map_attach(struct dma_buf *dma_buf,
 	 * drm_gem_map_dma_buf() requires obj->get_sg_table(), but drivers
 	 * that implement their own ->map_dma_buf() do not.
 	 */
-	if (dma_buf->ops->map_dma_buf == drm_gem_map_dma_buf &&
+	if (is_gem_map_dma_buf(attach) &&
 	    !obj->funcs->get_sg_table)
 		return -ENOSYS;
 

-- 
2.54.0

