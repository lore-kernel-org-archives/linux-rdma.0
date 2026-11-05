Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.62.7
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793860955;
	b=O3G1aGQboiy/50Ymit3X5iT08+awsdD4qeNjRP776jBGCBVPvaIQSyLuoVIBAm/ZkSwW
	 iN73bYegp3gm6qWuAUIdvPHQ+QCNAv2j6Si5CPt8eBZqpkTbIXZ4zI+2Bm+cnL6FsKwqj
	 zLV88CdNSiub4kz9XP0BENTKfFtUpzrgCSXhB/5Lc+1sQJ9da1vz7luDDxJ42I2nIkGPi
	 kWAzhvIGOIyyPbddhU9wU9URdCsaJ5S1GmjF87F+gJGbdrW/Q4M7HjMnnx7DcLodmtRw+
	 NQl5Hqg5MBTaUFutWw9l/+DRMbfkwgnQpzROQvZkqX4bhBTHZeWj5IZ+vc7REzQuVPQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793860955;
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
	bh=LZBL1WFGhnP4gkbLWhTxFuWluMuYr1eStmSJBlX5QNM=;
	b=B8S/jqKWZYAj2bCU3PTbQf5a83alJO/JC2i4nHekT8Y1UpddZyl3pvXDpAjyCP8fFFBo
	 MNEPSg3tAgR8T9JDmk8jLuM8W00ZFaeNxW62pzrNuDazzAwxhnnBjUftyGRULyrFbszEK
	 8JKINUotbbIgrlqZfXXum2sqOyK98TmDdjL71Jei6hk8F171KuqGwsIdvGYAeMDniZVrt
	 yz7z77Ld55buJSyOXRXXpm/1rbdnxF3cYW1anm36Y7XoJLbe9pIlJjTxjYdqDH14pIyWr
	 heaqsNNWqn9F8FGES3RmVRR21JQu9N+yQstOE52AqVxjRWcnGwNlJkSvNBoH/QiUZaQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=XD5zhrdx;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.62.7
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011007.outbound.protection.outlook.com [52.101.62.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0CDE606D80B;
	Thu,  5 Nov 2026 06:42:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A0CDE606D80B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=XD5zhrdx
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EhpFvobuntbQ5Fk0p4iLotyEdBcY1kRGTTkH64wECDqhjnVIDuCBkXqxfNSJ0HUMHnWpLzGVtMaDEuzCoCIb7qXLXczJsuWuSCFnQmig9UlfHoUf5NtjvkA9tcLmnpbhsuGXHts8bfQw57LamVPEoUeYqPJi3j0RvRYZGcbHMhaG/CFO/fsjnDaydsZTrI3jzKDGAVLxVY1WoC/v5X6mjtzYKHxKigDvRLw5iMA/pDUycwTdwd7ICPDtxmMageftrx1iZx8rNJ3GGrKSb5qrrMwSJdXEjzs0NXodydJKqKZivPqVmtNjwPr67BTvzvsIGm9nmDGNMwW7MTqkx+gr7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LZBL1WFGhnP4gkbLWhTxFuWluMuYr1eStmSJBlX5QNM=;
 b=qtQ7CefG84tBsYIKkmIx79jvUuIK2ChQdVREtZB6Io86jK/kfFbMd8zEwZaBxKwqMA4ftFj5ZXcmj//z2eHfI69WLRnABDZjzqs23HekiXL6mbVzrFDQ66xUem/CC6GF2GV1G3hO0EDZ8qo+yYfuxpFm91U1C44ndhAnLiCKyv92+AS03MntoNu+luFdtk95t+A8sK8BKrScGVqlexdvHk36YR6X+8nqW8P1ExlpM9TIWLu+qHmNQP1w16se+BxuCUGERhkf9NlTn3fGGenN7cLEg+pHeGN7pB3+4BGMqBKVdNReDp9RWC78TQWheVpP2hXx0LigewugEwFQ6IBd5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LZBL1WFGhnP4gkbLWhTxFuWluMuYr1eStmSJBlX5QNM=;
 b=XD5zhrdx3S+2ItsrMDbSCLxM4/Vgw3CYjV8k6EY+HvFym5g0MPIbT2U+FIiQpeIzV3x++4rGSH0KnlF7V1Wxw7N4gb765+3ce9gBN1Wl444XGqv0MTbo12YDrI+PGqEWA4og3xRw8kXutLMnASscqLa/M6G/9XrgLEevZrPEIpykK4y6/cb6FRRkc4NXJ7sgBIlMPfgztezgJa9zcQXv24o+PwMChU+O0mJHOEkRLuwmzC5ZDtn1bV49npSe3c5T1b/XqaVg2PARiq/H30OLzUWPC7rBDPhk9CxBRJ5O/kjXa5dw5rzNVKK7ANA0BpbbkdRmbLLXP0bz/FqLGcn9kA==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SA3PR12MB598757.namprd12.prod.outlook.com
 (2603:10b6:806:52d::14) by CH1PR12MB9573.namprd12.prod.outlook.com
 (2603:10b6:610:2ae::5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.8; Thu, 5 Nov 2026
 06:42:20 +0000
Received: from SA3PR12MB598757.namprd12.prod.outlook.com
 ([fe80::e206:100:5946:a777]) by SA3PR12MB598757.namprd12.prod.outlook.com
 ([fe80::e206:100:5946:a777%5]) with mapi id 15.21.0592.009; Thu, 5 Nov 2026
 06:42:20 +0000
From: Alistair Popple <apopple@nvidia.com>
Date: Thu, 05 Nov 2026 17:40:46 +1100
Subject: [PATCH v2 11/23] dma-buf: Convert all the simple exporters to use
 SGT mapping type
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20261105-dma_mapping_type_v4-v2-11-78b8dc9ae80a@nvidia.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793860879; l=49134;
 i=apopple@nvidia.com; s=20261105; h=from:subject:message-id;
 bh=tiTXkOZShpsl8gGmibC83DOz487BA0CAyVw20u3Z0II=;
 b=RG83XVsVr4zdu061E56aEK8kz7MitUR406z2EkgBlQCPzS6RL45Y9svnWXosl8/UhOssogZ74
 ddm/90oyq32C+fH66Xgjc2u7fWI0ww0x0Hx+66J3pAZj6MQ3ycYB828
X-Developer-Key: i=apopple@nvidia.com; a=ed25519;
 pk=WdWPT9rAq3YNfXldbGv1NSGVLGxzQGFGJvRUiShhNqs=
X-ClientProxiedBy: SY6PR01CA0015.ausprd01.prod.outlook.com
 (2603:10c6:10:e8::20) To SA3PR12MB598757.namprd12.prod.outlook.com
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
X-MS-Office365-Filtering-Correlation-Id: ef5c8199-10a6-4bf6-8523-08df3b07f0cd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|7416014|376014|366016|921020|261028144727099003|261021123027099003|261009223327099003|261022075727099003|261022113327099003|11063799006|56012099006|261021135927099003|261009221227099003|261009220027099003|261009221727099003|261009223027099003|261026121527099003|261102123227099003|261021121427099003|261022105027099003|261102130727099003|261026140227099003|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	p9vk1JG70SDIifEX+5FZ60mCdBv0IgL2cNqXyd40c1Yt1YjjUF/MPUFxTfWqKAFY/8oD9FGEO+Y6sN4UjrXblnpKC/Pq9s3oDCdevYi/019oHtWH8cwnWmpTNIyi7ZyLZhU8c4Q9fylp6rZ0uWVohifCxBs/OBavhvpIgQLAZa3mlotRISpLDQyy9qoGEIQgL4OFe5LLB3D6ZUeDG1pmHvWO0vvhOzNGMarECWxCpCYvF1hZ3AnY81Fdu3Sm+pMnGPDzOP/6l5wKKsAZqmstYIOLlQ7AaWIbj3Q2pzrZqzz5eNPamKNuHaooR0AG3Xst5g69FVCJek35phg4LvpGCCs1Q7bMiw5Zpu4NhIHc5CGKhFHD0ayWXUfwGB7CTukn6zHAw0cURkCTGrnupPohV9wCVXWeQyfnP5BWO5OTqbO4vI2amj5HtKqJc1OAOo9x/doEG6WSpgLjVQqj0j9o6pknyAEJLGy5fjLKwtS7ptVSoxL2AC3JWdDX+1vLG4BvwmOeQq8I0Y0vZcOQx7fsYWOBX8msFEZESH8v7MYy2sPzVhpy0x3jDur0dbw9M+2tjFIQ3V8M0xFHBrT/GovecAG0uCA05DuU2lhOyPGfJZkbeTcJKivnLwX6aAcuRxI138cSsTR2u88/sYQY5maDi5BbQCy+X8ISQ9CffkC/VqSEJDSP5offF5+htXXJDxkDZbNQNI5WwHQLUAXy3GcAsQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA3PR12MB598757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(7416014)(376014)(366016)(921020)(261028144727099003)(261021123027099003)(261009223327099003)(261022075727099003)(261022113327099003)(11063799006)(56012099006)(261021135927099003)(261009221227099003)(261009220027099003)(261009221727099003)(261009223027099003)(261026121527099003)(261102123227099003)(261021121427099003)(261022105027099003)(261102130727099003)(261026140227099003)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dldiMUZhR2ZMd0JOc2NHQk5KdWNFTW04M2pmdm5tRjRpWUxHTzQvbkE5TnNE?=
 =?utf-8?B?U3BzeGtxaXFBeUkyZitzK0QrTzNJSzFoTGRodml5c2Rtcy8zeFB0Uk1BWS9i?=
 =?utf-8?B?M2JtT3JESldGdUFZVTUvWXc1QU1IKzUzVjB6MGZaTjlFbldHcHRlNkZFZm5z?=
 =?utf-8?B?NmViSzdLNUhxSHVPL01KQWFKL09QdG9jU2t1Rnk2UFZkcjJ1U21xbWkxSUpC?=
 =?utf-8?B?Y3dNcGloNlZQWkZmUmsvNDlQYWJXODUyZDFVTEVCWldxQnk0cU1zRnI4bU44?=
 =?utf-8?B?aExvMGs3cUpzUmQzQUpXTExuTEpvbFVaOTZQMmxCbWg4T2FFV0FLTldGUXNY?=
 =?utf-8?B?RlpKOGIrN2JCdXBHVFBmaDdnc2xKUVBjOTdvMkRLakdnTDgwUFZvMUgwY201?=
 =?utf-8?B?bmE4TnRPdWd2alJyVUNuUEE1c3JPUlhuaGR2UkhKdUhrRXArMmM2aHN6NzRS?=
 =?utf-8?B?YVhlaUZsODRtVC8zd2FpZzRuRFBuN3FyM3F5SENhdkZoQ0ZGRkFPVW1WRjVD?=
 =?utf-8?B?Q2F5YXZvOTE0OVlKQjV6ckN1a1hvekw5UmJSL1FGWFpjeXpxMWVXaElaWjdq?=
 =?utf-8?B?TEZ0WEJiUjBDS1ZncGJISlVQcDVDSVJqRGIxK0lvcEZtT3FveGo0MENlNFVU?=
 =?utf-8?B?cThKakE0cC9FVStMYjVwVktlREZxb2MvNmp4R3Nzdmw1K2hmVVM1dk5vZXJt?=
 =?utf-8?B?dTZ6ZVBpTTB0d3NJYy9xQkVaNFZFSFdKbXdzSTAzUHlyZVRuakQ4K3NTQlFX?=
 =?utf-8?B?TStYaXFINUdveDlzdUxKR3NLUFk0SVJ4UTFCV1pZcytEY0dGVC9ueWFVOHRY?=
 =?utf-8?B?YXB5TGpKRDJCQ0ZXdjRyZDZueTVtNU5FUkgvVTJkS2xYTWNqbGJNSHptZnNL?=
 =?utf-8?B?WGdpL29Ub0VSaURjT0pkVm9iU0dOSmpFWjNxUHNzZk5FSGlDMHVhMlRzTWcx?=
 =?utf-8?B?eVhGN0o4Y1pHZVljRzJxbEZxZ00yVFFwQUQzRW1XL3B1V2JmWW1Qd2tVNWl0?=
 =?utf-8?B?Q0hGdUppNXQxT3VmN25PL2NBd3dxYnY4MVpBRy8wVVdlNi82ZnllZFBpMDdk?=
 =?utf-8?B?SzJKc0VQWUZrc1A4TVRHSVRKd1ZuSHBvZ3hCNXRHdW8rZ25RMGlDMkdHN1lL?=
 =?utf-8?B?Vm9kNVhCeW4vYXQwUXlrdXJRbnBUTWtvaUNNdmljSCtvR1V5QXBBNXBqR2RT?=
 =?utf-8?B?Y01iNm04WGdOaDM4aENjZS8zd1V0T0VseTlSenBkQ0JVR0F5SHZXVXU0RGJI?=
 =?utf-8?B?UlFBbmRWK053NkJYUE9yajJDMUlFTG5hRUNPUW1BRkRXM2hnZTF0dlBjdzl0?=
 =?utf-8?B?VGQzOEJlOHRZcWhFNExIcFpxbldMU1pSVVAvV1ZKSXlxNEVhWkZ3RkZJeEw5?=
 =?utf-8?B?bGRYcDB5SUlIdUxWa0lPTGZoZjdBdHltS05HUVRJM3dmWEdYTkovREx6Lzha?=
 =?utf-8?B?RThnL3FBVmpGZWluWDczSm1MVU1wUkFLSnc4Nk5BT3VhaytibmNpVnBrcDEx?=
 =?utf-8?B?Y2lpbGNlbTcwM3pGaU1semlRZk9sdW1XWlZvUHpYbWRxcStGRWNNVUw5eXdn?=
 =?utf-8?B?Mlc3dDhTYkkyRSsxd2JLSkRab2hhRlZTeThKM2ozRlcxZHRmN1prQ0lqSE01?=
 =?utf-8?B?MXFVa0ZrWVZib3p2MFRSdWpMcHRYMWplSDhzejNWTktOekpMZTlJNFlWNUdq?=
 =?utf-8?B?ZlhONVNHNDZWVE9GU2JxUWdLUzZaL0ZzbnFRRkJwVHQrMmFjZ3N4VjBmNmlw?=
 =?utf-8?B?Y0dubWdabmhXSmJVOVNKMHE3bWpidzJVV25WYlFGYktOc012bkFGNW9JcUNY?=
 =?utf-8?B?VWpQNGtEY0lvb0Y2Rys0YmEyK1k0djFNdml6QU1rdVpTLzJLcHp5TGhUS3h0?=
 =?utf-8?B?c0xFcndwaDVrT1phLzZlWXRTeFdQOTFPMXhZV2YwakYxWnozbytXblZYUXlL?=
 =?utf-8?B?cmY4L0oxQ1BLMlc4V2swRWZOMVdLUDlVeisyemhVL2VUMlN6NStGR3B5RndZ?=
 =?utf-8?B?S3pCcWJiampsQWNXTUw5UHREd1hwM291OW9RTktzajNEdU9vemkzSkMrWDRF?=
 =?utf-8?B?d3R3NEpndnJOZSs3NzVKK2lmZkFBcElXODRIdmdXWWY5b3hUUE5TT3dFOXZW?=
 =?utf-8?B?b3E5ZTB4OGNTSkFYbVo2YlFLc3MyRGpHMWU4N21NMmV5bnp4SmVhOFJtVU1x?=
 =?utf-8?B?aVN3RUlMMUZIRnJlMGYyaWpVWUc4b0RTY1FTRXczdy95Qzl4MG96UW9lTFFW?=
 =?utf-8?B?UVNyVjBDTkZBbVB1WFN6T0FxTmxFS1k2WHAvT1JXVU41TDJYZkZUVGRCb3No?=
 =?utf-8?B?MnVPdUVhcFhMK2xaS0lETTBod3ZQSE9lS1RYWlhPYUZPaGpocWhvZz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ef5c8199-10a6-4bf6-8523-08df3b07f0cd
X-MS-Exchange-CrossTenant-AuthSource: SA3PR12MB598757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2026 06:42:20.3034
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EBjcUDLAj4I7pSfh8XDyUTrm81Tv8e06nznletBINsv5dnb3/gxJUceTm4HhpOzGoN/B3KvdXUGvX2aFjOh7xQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH1PR12MB9573

From: Jason Gunthorpe <jgg@nvidia.com>

Update the exporters to use a SGT mapping type and the new style mapping
type API. None of these exporters do anything with attach->peer2peer or
importer_ops->allow_peer2peer and they all follow the same pattern.

Change all the places that need to get the SGT's DMA device for DMA API
use to use dma_buf_sgt_dma_device().

This is all a mechanical change of moving the map_dma_buf/unmap_dma_buf
into DMA_BUF_SIMPLE_SGT_EXP_MATCH() arguments and switching
attach->dev to dma_buf_sgt_dma_device(attach).

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Alistair Popple <apopple@nvidia.com>
---
 drivers/accel/amdxdna/amdxdna_cbuf.c                  |  8 ++++----
 drivers/accel/amdxdna/amdxdna_gem.c                   |  5 +++--
 drivers/accel/amdxdna/amdxdna_ubuf.c                  |  8 ++++----
 drivers/accel/ivpu/ivpu_gem_userptr.c                 | 11 +++++++----
 drivers/dma-buf/heaps/cma_heap.c                      | 12 +++++++-----
 drivers/dma-buf/heaps/system_heap.c                   | 13 ++++++++-----
 drivers/dma-buf/udmabuf.c                             |  8 ++++----
 drivers/gpu/drm/armada/armada_gem.c                   | 12 +++++++-----
 drivers/gpu/drm/drm_prime.c                           |  9 +++++----
 drivers/gpu/drm/i915/gem/i915_gem_dmabuf.c            |  8 +++++---
 drivers/gpu/drm/i915/gem/selftests/mock_dmabuf.c      |  8 ++++----
 drivers/gpu/drm/msm/msm_gem_prime.c                   |  7 +++++--
 drivers/gpu/drm/omapdrm/omap_gem_dmabuf.c             |  5 +++--
 drivers/gpu/drm/panfrost/panfrost_gem.c               | 13 +++++++++----
 drivers/gpu/drm/panthor/panthor_gem.c                 | 11 +++++++----
 drivers/gpu/drm/tegra/gem.c                           | 12 +++++++-----
 drivers/gpu/drm/virtio/virtgpu_prime.c                | 11 +++++++----
 drivers/iommu/iommufd/selftest.c                      | 18 +++---------------
 drivers/media/common/videobuf2/videobuf2-dma-contig.c | 15 ++++++++-------
 drivers/media/common/videobuf2/videobuf2-dma-sg.c     | 14 +++++++++-----
 drivers/media/common/videobuf2/videobuf2-vmalloc.c    | 13 ++++++++-----
 drivers/misc/fastrpc.c                                | 12 +++++++-----
 drivers/tee/tee_heap.c                                | 13 +++++++------
 drivers/xen/gntdev-dmabuf.c                           | 19 +++++++++++--------
 samples/vfio-mdev/mbochs.c                            | 10 +++++-----
 sound/soc/fsl/fsl_asrc_m2m.c                          | 12 +++++++-----
 26 files changed, 161 insertions(+), 126 deletions(-)

diff --git a/drivers/accel/amdxdna/amdxdna_cbuf.c b/drivers/accel/amdxdna/amdxdna_cbuf.c
index a504560aae98..2070a371903d 100644
--- a/drivers/accel/amdxdna/amdxdna_cbuf.c
+++ b/drivers/accel/amdxdna/amdxdna_cbuf.c
@@ -5,6 +5,7 @@
 
 #include <drm/drm_mm.h>
 #include <drm/drm_prime.h>
+#include <linux/dma-buf-mapping.h>
 
 #include "amdxdna_cbuf.h"
 #include "amdxdna_pci_drv.h"
@@ -85,7 +86,7 @@ static struct sg_table *amdxdna_cbuf_map(struct dma_buf_attachment *attach,
 					 enum dma_data_direction direction)
 {
 	struct amdxdna_cbuf_priv *cbuf = attach->dmabuf->priv;
-	struct device *dev = attach->dev;
+	struct device *dev = dma_buf_sgt_dma_device(attach);
 	struct scatterlist *sgl, *sg;
 	int ret, n_entries, i;
 	struct sg_table *sgt;
@@ -140,7 +141,7 @@ static void amdxdna_cbuf_unmap(struct dma_buf_attachment *attach,
 			       struct sg_table *sgt,
 			       enum dma_data_direction direction)
 {
-	dma_unmap_resource(attach->dev, sg_dma_address(sgt->sgl),
+	dma_unmap_resource(dma_buf_sgt_dma_device(attach), sg_dma_address(sgt->sgl),
 			   drm_prime_get_contiguous_size(sgt), direction,
 			   DMA_ATTR_SKIP_CPU_SYNC);
 	sg_free_table(sgt);
@@ -210,12 +211,11 @@ static void amdxdna_cbuf_vunmap(struct dma_buf *dbuf, struct iosys_map *map)
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
diff --git a/drivers/accel/amdxdna/amdxdna_gem.c b/drivers/accel/amdxdna/amdxdna_gem.c
index adee6e806eed..74b8e86638b1 100644
--- a/drivers/accel/amdxdna/amdxdna_gem.c
+++ b/drivers/accel/amdxdna/amdxdna_gem.c
@@ -11,6 +11,7 @@
 #include <drm/drm_print.h>
 #include <drm/gpu_scheduler.h>
 #include <linux/dma-buf.h>
+#include <linux/dma-buf-mapping.h>
 #include <linux/dma-direct.h>
 #include <linux/iosys-map.h>
 #include <linux/pagemap.h>
@@ -669,12 +670,12 @@ static int amdxdna_gem_dmabuf_mmap(struct dma_buf *dma_buf, struct vm_area_struc
 static const struct dma_buf_ops amdxdna_dmabuf_ops = {
 	.attach = drm_gem_map_attach,
 	.detach = drm_gem_map_detach,
-	.map_dma_buf = drm_gem_map_dma_buf,
-	.unmap_dma_buf = drm_gem_unmap_dma_buf,
 	.release = drm_gem_dmabuf_release,
 	.mmap = amdxdna_gem_dmabuf_mmap,
 	.vmap = drm_gem_dmabuf_vmap,
 	.vunmap = drm_gem_dmabuf_vunmap,
+	DMA_BUF_SIMPLE_SGT_EXP_MATCH(drm_gem_map_dma_buf,
+				     drm_gem_unmap_dma_buf),
 };
 
 static struct dma_buf *amdxdna_gem_prime_export(struct drm_gem_object *gobj, int flags)
diff --git a/drivers/accel/amdxdna/amdxdna_ubuf.c b/drivers/accel/amdxdna/amdxdna_ubuf.c
index 0e0cd69cd1fb..b81f947712e8 100644
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
@@ -36,7 +37,7 @@ static struct sg_table *amdxdna_ubuf_map(struct dma_buf_attachment *attach,
 	if (ret)
 		goto err_free_sg;
 
-	ret = dma_map_sgtable(attach->dev, sg, direction, 0);
+	ret = dma_map_sgtable(dma_buf_sgt_dma_device(attach), sg, direction, 0);
 	if (ret)
 		goto err_free_table;
 
@@ -53,7 +54,7 @@ static void amdxdna_ubuf_unmap(struct dma_buf_attachment *attach,
 			       struct sg_table *sg,
 			       enum dma_data_direction direction)
 {
-	dma_unmap_sgtable(attach->dev, sg, direction, 0);
+	dma_unmap_sgtable(dma_buf_sgt_dma_device(attach), sg, direction, 0);
 	sg_free_table(sg);
 	kfree(sg);
 }
@@ -70,9 +71,8 @@ static void amdxdna_ubuf_release(struct dma_buf *dbuf)
 }
 
 static const struct dma_buf_ops amdxdna_ubuf_dmabuf_ops = {
-	.map_dma_buf = amdxdna_ubuf_map,
-	.unmap_dma_buf = amdxdna_ubuf_unmap,
 	.release = amdxdna_ubuf_release,
+	DMA_BUF_SIMPLE_SGT_EXP_MATCH(amdxdna_ubuf_map, amdxdna_ubuf_unmap),
 };
 
 struct dma_buf *amdxdna_get_ubuf(struct drm_device *dev,
diff --git a/drivers/accel/ivpu/ivpu_gem_userptr.c b/drivers/accel/ivpu/ivpu_gem_userptr.c
index 7cbf3a4cdc73..7ca9d8d4f5a8 100644
--- a/drivers/accel/ivpu/ivpu_gem_userptr.c
+++ b/drivers/accel/ivpu/ivpu_gem_userptr.c
@@ -4,6 +4,7 @@
  */
 
 #include <linux/dma-buf.h>
+#include <linux/dma-buf-mapping.h>
 #include <linux/err.h>
 #include <linux/highmem.h>
 #include <linux/mm.h>
@@ -26,7 +27,8 @@ ivpu_gem_userptr_dmabuf_map(struct dma_buf_attachment *attachment,
 	struct sg_table *sgt = attachment->dmabuf->priv;
 	int ret;
 
-	ret = dma_map_sgtable(attachment->dev, sgt, direction, DMA_ATTR_SKIP_CPU_SYNC);
+	ret = dma_map_sgtable(dma_buf_sgt_dma_device(attachment), sgt,
+			      direction, DMA_ATTR_SKIP_CPU_SYNC);
 	if (ret)
 		return ERR_PTR(ret);
 
@@ -37,7 +39,8 @@ static void ivpu_gem_userptr_dmabuf_unmap(struct dma_buf_attachment *attachment,
 					  struct sg_table *sgt,
 					  enum dma_data_direction direction)
 {
-	dma_unmap_sgtable(attachment->dev, sgt, direction, DMA_ATTR_SKIP_CPU_SYNC);
+	dma_unmap_sgtable(dma_buf_sgt_dma_device(attachment), sgt, direction,
+			  DMA_ATTR_SKIP_CPU_SYNC);
 }
 
 static void ivpu_gem_userptr_dmabuf_release(struct dma_buf *dma_buf)
@@ -56,9 +59,9 @@ static void ivpu_gem_userptr_dmabuf_release(struct dma_buf *dma_buf)
 }
 
 static const struct dma_buf_ops ivpu_gem_userptr_dmabuf_ops = {
-	.map_dma_buf = ivpu_gem_userptr_dmabuf_map,
-	.unmap_dma_buf = ivpu_gem_userptr_dmabuf_unmap,
 	.release = ivpu_gem_userptr_dmabuf_release,
+	DMA_BUF_SIMPLE_SGT_EXP_MATCH(ivpu_gem_userptr_dmabuf_map,
+				     ivpu_gem_userptr_dmabuf_unmap),
 };
 
 static struct dma_buf *
diff --git a/drivers/dma-buf/heaps/cma_heap.c b/drivers/dma-buf/heaps/cma_heap.c
index 3fb4b946c91a..fa05c242f238 100644
--- a/drivers/dma-buf/heaps/cma_heap.c
+++ b/drivers/dma-buf/heaps/cma_heap.c
@@ -14,6 +14,7 @@
 
 #include <linux/cma.h>
 #include <linux/dma-buf.h>
+#include <linux/dma-buf-mapping.h>
 #include <linux/dma-heap.h>
 #include <linux/dma-map-ops.h>
 #include <linux/err.h>
@@ -73,7 +74,7 @@ static int cma_heap_attach(struct dma_buf *dmabuf,
 		return ret;
 	}
 
-	a->dev = attachment->dev;
+	a->dev = dma_buf_sgt_dma_device(attachment);
 	INIT_LIST_HEAD(&a->list);
 	a->mapped = false;
 
@@ -107,7 +108,8 @@ static struct sg_table *cma_heap_map_dma_buf(struct dma_buf_attachment *attachme
 	struct sg_table *table = &a->table;
 	int ret;
 
-	ret = dma_map_sgtable(attachment->dev, table, direction, 0);
+	ret = dma_map_sgtable(dma_buf_sgt_dma_device(attachment), table,
+			      direction, 0);
 	if (ret)
 		return ERR_PTR(-ENOMEM);
 	a->mapped = true;
@@ -121,7 +123,8 @@ static void cma_heap_unmap_dma_buf(struct dma_buf_attachment *attachment,
 	struct dma_heap_attachment *a = attachment->priv;
 
 	a->mapped = false;
-	dma_unmap_sgtable(attachment->dev, table, direction, 0);
+	dma_unmap_sgtable(dma_buf_sgt_dma_device(attachment), table, direction,
+			  0);
 }
 
 static int cma_heap_dma_buf_begin_cpu_access(struct dma_buf *dmabuf,
@@ -268,14 +271,13 @@ static void cma_heap_dma_buf_release(struct dma_buf *dmabuf)
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
index c8959eadc71d..e954238463d4 100644
--- a/drivers/dma-buf/heaps/system_heap.c
+++ b/drivers/dma-buf/heaps/system_heap.c
@@ -12,6 +12,7 @@
 
 #include <linux/cc_platform.h>
 #include <linux/dma-buf.h>
+#include <linux/dma-buf-mapping.h>
 #include <linux/dma-mapping.h>
 #include <linux/dma-heap.h>
 #include <linux/err.h>
@@ -128,7 +129,7 @@ static int system_heap_attach(struct dma_buf *dmabuf,
 		return ret;
 	}
 
-	a->dev = attachment->dev;
+	a->dev = dma_buf_sgt_dma_device(attachment);
 	INIT_LIST_HEAD(&a->list);
 	a->mapped = false;
 	a->cc_shared = buffer->cc_shared;
@@ -165,7 +166,8 @@ static struct sg_table *system_heap_map_dma_buf(struct dma_buf_attachment *attac
 	int ret;
 
 	attrs = cc_shared_buffer(a) ? DMA_ATTR_CC_SHARED : 0;
-	ret = dma_map_sgtable(attachment->dev, table, direction, attrs);
+	ret = dma_map_sgtable(dma_buf_sgt_dma_device(attachment), table,
+			      direction, attrs);
 	if (ret)
 		return ERR_PTR(ret);
 
@@ -180,7 +182,8 @@ static void system_heap_unmap_dma_buf(struct dma_buf_attachment *attachment,
 	struct dma_heap_attachment *a = attachment->priv;
 
 	a->mapped = false;
-	dma_unmap_sgtable(attachment->dev, table, direction, 0);
+	dma_unmap_sgtable(dma_buf_sgt_dma_device(attachment), table, direction,
+			  0);
 }
 
 static int system_heap_dma_buf_begin_cpu_access(struct dma_buf *dmabuf,
@@ -365,14 +368,14 @@ static void system_heap_dma_buf_release(struct dma_buf *dmabuf)
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
diff --git a/drivers/dma-buf/udmabuf.c b/drivers/dma-buf/udmabuf.c
index df6dd0046242..911a3fa347b3 100644
--- a/drivers/dma-buf/udmabuf.c
+++ b/drivers/dma-buf/udmabuf.c
@@ -2,6 +2,7 @@
 #include <linux/cred.h>
 #include <linux/device.h>
 #include <linux/dma-buf.h>
+#include <linux/dma-buf-mapping.h>
 #include <linux/dma-resv.h>
 #include <linux/highmem.h>
 #include <linux/init.h>
@@ -168,14 +169,14 @@ static void put_sg_table(struct device *dev, struct sg_table *sg,
 static struct sg_table *map_udmabuf(struct dma_buf_attachment *at,
 				    enum dma_data_direction direction)
 {
-	return get_sg_table(at->dev, at->dmabuf, direction);
+	return get_sg_table(dma_buf_sgt_dma_device(at), at->dmabuf, direction);
 }
 
 static void unmap_udmabuf(struct dma_buf_attachment *at,
 			  struct sg_table *sg,
 			  enum dma_data_direction direction)
 {
-	return put_sg_table(at->dev, sg, direction);
+	return put_sg_table(dma_buf_sgt_dma_device(at), sg, direction);
 }
 
 static void unpin_all_folios(struct udmabuf *ubuf)
@@ -256,14 +257,13 @@ static int end_cpu_udmabuf(struct dma_buf *buf,
 }
 
 static const struct dma_buf_ops udmabuf_ops = {
-	.map_dma_buf	   = map_udmabuf,
-	.unmap_dma_buf	   = unmap_udmabuf,
 	.release	   = release_udmabuf,
 	.mmap		   = mmap_udmabuf,
 	.vmap		   = vmap_udmabuf,
 	.vunmap		   = vunmap_udmabuf,
 	.begin_cpu_access  = begin_cpu_udmabuf,
 	.end_cpu_access    = end_cpu_udmabuf,
+	DMA_BUF_SIMPLE_SGT_EXP_MATCH(map_udmabuf, unmap_udmabuf),
 };
 
 #define SEALS_WANTED (F_SEAL_SHRINK)
diff --git a/drivers/gpu/drm/armada/armada_gem.c b/drivers/gpu/drm/armada/armada_gem.c
index 044acdef6351..0e34cbb7c5b2 100644
--- a/drivers/gpu/drm/armada/armada_gem.c
+++ b/drivers/gpu/drm/armada/armada_gem.c
@@ -4,6 +4,7 @@
  */
 
 #include <linux/dma-buf.h>
+#include <linux/dma-buf-mapping.h>
 #include <linux/dma-mapping.h>
 #include <linux/mman.h>
 #include <linux/shmem_fs.h>
@@ -387,6 +388,7 @@ static struct sg_table *
 armada_gem_prime_map_dma_buf(struct dma_buf_attachment *attach,
 	enum dma_data_direction dir)
 {
+	struct device *dma_dev = dma_buf_sgt_dma_device(attach);
 	struct drm_gem_object *obj = attach->dmabuf->priv;
 	struct armada_gem_object *dobj = drm_to_armada_gem(obj);
 	struct scatterlist *sg;
@@ -417,7 +419,7 @@ armada_gem_prime_map_dma_buf(struct dma_buf_attachment *attach,
 			sg_set_page(sg, page, PAGE_SIZE, 0);
 		}
 
-		if (dma_map_sgtable(attach->dev, sgt, dir, 0))
+		if (dma_map_sgtable(dma_dev, sgt, dir, 0))
 			goto release;
 	} else if (dobj->page) {
 		/* Single contiguous page */
@@ -426,7 +428,7 @@ armada_gem_prime_map_dma_buf(struct dma_buf_attachment *attach,
 
 		sg_set_page(sgt->sgl, dobj->page, dobj->obj.size, 0);
 
-		if (dma_map_sgtable(attach->dev, sgt, dir, 0))
+		if (dma_map_sgtable(dma_dev, sgt, dir, 0))
 			goto free_table;
 	} else if (dobj->linear) {
 		/* Single contiguous physical region - no struct page */
@@ -458,7 +460,7 @@ static void armada_gem_prime_unmap_dma_buf(struct dma_buf_attachment *attach,
 	int i;
 
 	if (!dobj->linear)
-		dma_unmap_sgtable(attach->dev, sgt, dir, 0);
+		dma_unmap_sgtable(dma_buf_sgt_dma_device(attach), sgt, dir, 0);
 
 	if (dobj->obj.filp) {
 		struct scatterlist *sg;
@@ -478,10 +480,10 @@ armada_gem_dmabuf_mmap(struct dma_buf *buf, struct vm_area_struct *vma)
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
diff --git a/drivers/gpu/drm/drm_prime.c b/drivers/gpu/drm/drm_prime.c
index c5184ca602bc..a50ab33cd7b9 100644
--- a/drivers/gpu/drm/drm_prime.c
+++ b/drivers/gpu/drm/drm_prime.c
@@ -693,7 +693,7 @@ struct sg_table *drm_gem_map_dma_buf(struct dma_buf_attachment *attach,
 	if (IS_ERR(sgt))
 		return sgt;
 
-	ret = dma_map_sgtable(attach->dev, sgt, dir,
+	ret = dma_map_sgtable(dma_buf_sgt_dma_device(attach), sgt, dir,
 			      DMA_ATTR_SKIP_CPU_SYNC);
 	if (ret) {
 		sg_free_table(sgt);
@@ -720,7 +720,8 @@ void drm_gem_unmap_dma_buf(struct dma_buf_attachment *attach,
 	if (!sgt)
 		return;
 
-	dma_unmap_sgtable(attach->dev, sgt, dir, DMA_ATTR_SKIP_CPU_SYNC);
+	dma_unmap_sgtable(dma_buf_sgt_dma_device(attach), sgt, dir,
+			  DMA_ATTR_SKIP_CPU_SYNC);
 	sg_free_table(sgt);
 	kfree(sgt);
 }
@@ -840,12 +841,12 @@ EXPORT_SYMBOL(drm_gem_dmabuf_mmap);
 static const struct dma_buf_ops drm_gem_prime_dmabuf_ops =  {
 	.attach = drm_gem_map_attach,
 	.detach = drm_gem_map_detach,
-	.map_dma_buf = drm_gem_map_dma_buf,
-	.unmap_dma_buf = drm_gem_unmap_dma_buf,
 	.release = drm_gem_dmabuf_release,
 	.mmap = drm_gem_dmabuf_mmap,
 	.vmap = drm_gem_dmabuf_vmap,
 	.vunmap = drm_gem_dmabuf_vunmap,
+	DMA_BUF_SIMPLE_SGT_EXP_MATCH(drm_gem_map_dma_buf,
+				     drm_gem_unmap_dma_buf),
 };
 
 /**
diff --git a/drivers/gpu/drm/i915/gem/i915_gem_dmabuf.c b/drivers/gpu/drm/i915/gem/i915_gem_dmabuf.c
index 4ab54d2e616f..5a53e281df46 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_dmabuf.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_dmabuf.c
@@ -4,6 +4,7 @@
  */
 
 #include <linux/dma-buf.h>
+#include <linux/dma-buf-mapping.h>
 #include <linux/highmem.h>
 #include <linux/dma-resv.h>
 #include <linux/module.h>
@@ -52,7 +53,8 @@ static struct sg_table *i915_gem_map_dma_buf(struct dma_buf_attachment *attach,
 		dst = sg_next(dst);
 	}
 
-	ret = dma_map_sgtable(attach->dev, sgt, dir, DMA_ATTR_SKIP_CPU_SYNC);
+	ret = dma_map_sgtable(dma_buf_sgt_dma_device(attach), sgt, dir,
+			      DMA_ATTR_SKIP_CPU_SYNC);
 	if (ret)
 		goto err_free_sg;
 
@@ -203,14 +205,14 @@ static void i915_gem_dmabuf_detach(struct dma_buf *dmabuf,
 static const struct dma_buf_ops i915_dmabuf_ops =  {
 	.attach = i915_gem_dmabuf_attach,
 	.detach = i915_gem_dmabuf_detach,
-	.map_dma_buf = i915_gem_map_dma_buf,
-	.unmap_dma_buf = drm_gem_unmap_dma_buf,
 	.release = drm_gem_dmabuf_release,
 	.mmap = i915_gem_dmabuf_mmap,
 	.vmap = i915_gem_dmabuf_vmap,
 	.vunmap = i915_gem_dmabuf_vunmap,
 	.begin_cpu_access = i915_gem_begin_cpu_access,
 	.end_cpu_access = i915_gem_end_cpu_access,
+	DMA_BUF_SIMPLE_SGT_EXP_MATCH(i915_gem_map_dma_buf,
+				     drm_gem_unmap_dma_buf),
 };
 
 struct dma_buf *i915_gem_prime_export(struct drm_gem_object *gem_obj, int flags)
diff --git a/drivers/gpu/drm/i915/gem/selftests/mock_dmabuf.c b/drivers/gpu/drm/i915/gem/selftests/mock_dmabuf.c
index f2863da7f5c1..911d8f59011a 100644
--- a/drivers/gpu/drm/i915/gem/selftests/mock_dmabuf.c
+++ b/drivers/gpu/drm/i915/gem/selftests/mock_dmabuf.c
@@ -4,6 +4,7 @@
  * Copyright © 2016 Intel Corporation
  */
 
+#include <linux/dma-buf-mapping.h>
 #include <linux/vmalloc.h>
 #include "mock_dmabuf.h"
 
@@ -29,7 +30,7 @@ static struct sg_table *mock_map_dma_buf(struct dma_buf_attachment *attachment,
 		sg = sg_next(sg);
 	}
 
-	err = dma_map_sgtable(attachment->dev, st, dir, 0);
+	err = dma_map_sgtable(dma_buf_sgt_dma_device(attachment), st, dir, 0);
 	if (err)
 		goto err_st;
 
@@ -46,7 +47,7 @@ static void mock_unmap_dma_buf(struct dma_buf_attachment *attachment,
 			       struct sg_table *st,
 			       enum dma_data_direction dir)
 {
-	dma_unmap_sgtable(attachment->dev, st, dir, 0);
+	dma_unmap_sgtable(dma_buf_sgt_dma_device(attachment), st, dir, 0);
 	sg_free_table(st);
 	kfree(st);
 }
@@ -88,12 +89,11 @@ static int mock_dmabuf_mmap(struct dma_buf *dma_buf, struct vm_area_struct *vma)
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
diff --git a/drivers/gpu/drm/msm/msm_gem_prime.c b/drivers/gpu/drm/msm/msm_gem_prime.c
index e1e74e9b7e6a..b6aae3c85250 100644
--- a/drivers/gpu/drm/msm/msm_gem_prime.c
+++ b/drivers/gpu/drm/msm/msm_gem_prime.c
@@ -5,6 +5,7 @@
  */
 
 #include <linux/dma-buf.h>
+#include <linux/dma-buf-mapping.h>
 
 #include <drm/drm_drv.h>
 #include <drm/drm_prime.h>
@@ -54,12 +55,12 @@ static void msm_gem_dmabuf_release(struct dma_buf *dma_buf)
 static const struct dma_buf_ops msm_gem_prime_dmabuf_ops =  {
 	.attach = drm_gem_map_attach,
 	.detach = drm_gem_map_detach,
-	.map_dma_buf = drm_gem_map_dma_buf,
-	.unmap_dma_buf = drm_gem_unmap_dma_buf,
 	.release = msm_gem_dmabuf_release,
 	.mmap = drm_gem_dmabuf_mmap,
 	.vmap = drm_gem_dmabuf_vmap,
 	.vunmap = drm_gem_dmabuf_vunmap,
+	DMA_BUF_SIMPLE_SGT_EXP_MATCH(drm_gem_map_dma_buf,
+				     drm_gem_unmap_dma_buf),
 };
 
 struct drm_gem_object *msm_gem_prime_import(struct drm_device *dev,
@@ -125,3 +126,5 @@ void msm_gem_prime_unpin(struct drm_gem_object *obj)
 
 	msm_gem_unpin_pages_locked(obj);
 }
+
+MODULE_IMPORT_NS("DMA_BUF");
diff --git a/drivers/gpu/drm/omapdrm/omap_gem_dmabuf.c b/drivers/gpu/drm/omapdrm/omap_gem_dmabuf.c
index afae0a56da8c..0628a054f17a 100644
--- a/drivers/gpu/drm/omapdrm/omap_gem_dmabuf.c
+++ b/drivers/gpu/drm/omapdrm/omap_gem_dmabuf.c
@@ -5,6 +5,7 @@
  */
 
 #include <linux/dma-buf.h>
+#include <linux/dma-buf-mapping.h>
 #include <linux/highmem.h>
 
 #include <drm/drm_prime.h>
@@ -69,12 +70,12 @@ static int omap_gem_dmabuf_mmap(struct dma_buf *buffer,
 }
 
 static const struct dma_buf_ops omap_dmabuf_ops = {
-	.map_dma_buf = omap_gem_map_dma_buf,
-	.unmap_dma_buf = omap_gem_unmap_dma_buf,
 	.release = drm_gem_dmabuf_release,
 	.begin_cpu_access = omap_gem_dmabuf_begin_cpu_access,
 	.end_cpu_access = omap_gem_dmabuf_end_cpu_access,
 	.mmap = omap_gem_dmabuf_mmap,
+	DMA_BUF_SIMPLE_SGT_EXP_MATCH(omap_gem_map_dma_buf,
+				     omap_gem_unmap_dma_buf),
 };
 
 struct dma_buf *omap_gem_prime_export(struct drm_gem_object *obj, int flags)
diff --git a/drivers/gpu/drm/panfrost/panfrost_gem.c b/drivers/gpu/drm/panfrost/panfrost_gem.c
index 518f24549b9d..d7c3dd9a631e 100644
--- a/drivers/gpu/drm/panfrost/panfrost_gem.c
+++ b/drivers/gpu/drm/panfrost/panfrost_gem.c
@@ -6,6 +6,7 @@
 #include <linux/err.h>
 #include <linux/slab.h>
 #include <linux/dma-buf.h>
+#include <linux/dma-buf-mapping.h>
 #include <linux/dma-mapping.h>
 
 #include <drm/panfrost_drm.h>
@@ -23,6 +24,8 @@ MODULE_PARM_DESC(transparent_hugepage, "Use a dedicated tmpfs mount point with T
 #define panfrost_transparent_hugepage false
 #endif
 
+MODULE_IMPORT_NS("DMA_BUF");
+
 int panfrost_gem_init(struct panfrost_device *pfdev)
 {
 	if (panfrost_transparent_hugepage) {
@@ -330,7 +333,8 @@ panfrost_gem_prime_begin_cpu_access(struct dma_buf *dma_buf,
 		struct sg_table *sgt = attach->priv;
 
 		if (sgt)
-			dma_sync_sgtable_for_cpu(attach->dev, sgt, dir);
+			dma_sync_sgtable_for_cpu(dma_buf_sgt_dma_device(attach),
+						 sgt, dir);
 	}
 	dma_resv_unlock(obj->resv);
 
@@ -351,7 +355,8 @@ panfrost_gem_prime_end_cpu_access(struct dma_buf *dma_buf,
 		struct sg_table *sgt = attach->priv;
 
 		if (sgt)
-			dma_sync_sgtable_for_device(attach->dev, sgt, dir);
+			dma_sync_sgtable_for_device(dma_buf_sgt_dma_device(attach),
+						    sgt, dir);
 	}
 
 	if (shmem->vaddr)
@@ -367,14 +372,14 @@ panfrost_gem_prime_end_cpu_access(struct dma_buf *dma_buf,
 static const struct dma_buf_ops panfrost_dma_buf_ops = {
 	.attach = drm_gem_map_attach,
 	.detach = drm_gem_map_detach,
-	.map_dma_buf = panfrost_gem_prime_map_dma_buf,
-	.unmap_dma_buf = panfrost_gem_prime_unmap_dma_buf,
 	.release = drm_gem_dmabuf_release,
 	.mmap = drm_gem_dmabuf_mmap,
 	.vmap = drm_gem_dmabuf_vmap,
 	.vunmap = drm_gem_dmabuf_vunmap,
 	.begin_cpu_access = panfrost_gem_prime_begin_cpu_access,
 	.end_cpu_access = panfrost_gem_prime_end_cpu_access,
+	DMA_BUF_SIMPLE_SGT_EXP_MATCH(panfrost_gem_prime_map_dma_buf,
+				     panfrost_gem_prime_unmap_dma_buf),
 };
 
 static struct dma_buf *
diff --git a/drivers/gpu/drm/panthor/panthor_gem.c b/drivers/gpu/drm/panthor/panthor_gem.c
index 22b57ab6f929..56c7e724a6c7 100644
--- a/drivers/gpu/drm/panthor/panthor_gem.c
+++ b/drivers/gpu/drm/panthor/panthor_gem.c
@@ -7,6 +7,7 @@
 #include <linux/cleanup.h>
 #include <linux/debugfs.h>
 #include <linux/dma-buf.h>
+#include <linux/dma-buf-mapping.h>
 #include <linux/dma-mapping.h>
 #include <linux/err.h>
 #include <linux/slab.h>
@@ -512,7 +513,8 @@ panthor_gem_prime_begin_cpu_access(struct dma_buf *dma_buf,
 		struct sg_table *sgt = attach->priv;
 
 		if (sgt)
-			dma_sync_sgtable_for_cpu(attach->dev, sgt, dir);
+			dma_sync_sgtable_for_cpu(dma_buf_sgt_dma_device(attach),
+						 sgt, dir);
 	}
 	dma_resv_unlock(obj->resv);
 
@@ -533,7 +535,8 @@ panthor_gem_prime_end_cpu_access(struct dma_buf *dma_buf,
 		struct sg_table *sgt = attach->priv;
 
 		if (sgt)
-			dma_sync_sgtable_for_device(attach->dev, sgt, dir);
+			dma_sync_sgtable_for_device(dma_buf_sgt_dma_device(attach),
+						    sgt, dir);
 	}
 
 	if (bo->cmap.vaddr)
@@ -549,14 +552,14 @@ panthor_gem_prime_end_cpu_access(struct dma_buf *dma_buf,
 static const struct dma_buf_ops panthor_dma_buf_ops = {
 	.attach = drm_gem_map_attach,
 	.detach = drm_gem_map_detach,
-	.map_dma_buf = panthor_gem_prime_map_dma_buf,
-	.unmap_dma_buf = panthor_gem_prime_unmap_dma_buf,
 	.release = drm_gem_dmabuf_release,
 	.mmap = drm_gem_dmabuf_mmap,
 	.vmap = drm_gem_dmabuf_vmap,
 	.vunmap = drm_gem_dmabuf_vunmap,
 	.begin_cpu_access = panthor_gem_prime_begin_cpu_access,
 	.end_cpu_access = panthor_gem_prime_end_cpu_access,
+	DMA_BUF_SIMPLE_SGT_EXP_MATCH(panthor_gem_prime_map_dma_buf,
+				     panthor_gem_prime_unmap_dma_buf),
 };
 
 static struct dma_buf *
diff --git a/drivers/gpu/drm/tegra/gem.c b/drivers/gpu/drm/tegra/gem.c
index e6aa6dae4ec8..faff826848bd 100644
--- a/drivers/gpu/drm/tegra/gem.c
+++ b/drivers/gpu/drm/tegra/gem.c
@@ -11,6 +11,7 @@
  */
 
 #include <linux/dma-buf.h>
+#include <linux/dma-buf-mapping.h>
 #include <linux/iommu.h>
 #include <linux/module.h>
 #include <linux/pagemap.h>
@@ -630,6 +631,7 @@ static struct sg_table *
 tegra_gem_prime_map_dma_buf(struct dma_buf_attachment *attach,
 			    enum dma_data_direction dir)
 {
+	struct device *dma_dev = dma_buf_sgt_dma_device(attach);
 	struct drm_gem_object *gem = attach->dmabuf->priv;
 	struct tegra_bo *bo = to_tegra_bo(gem);
 	struct sg_table *sgt;
@@ -643,12 +645,12 @@ tegra_gem_prime_map_dma_buf(struct dma_buf_attachment *attach,
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
 
 	return sgt;
@@ -667,7 +669,7 @@ static void tegra_gem_prime_unmap_dma_buf(struct dma_buf_attachment *attach,
 	struct tegra_bo *bo = to_tegra_bo(gem);
 
 	if (bo->pages)
-		dma_unmap_sgtable(attach->dev, sgt, dir, 0);
+		dma_unmap_sgtable(dma_buf_sgt_dma_device(attach), sgt, dir, 0);
 
 	sg_free_table(sgt);
 	kfree(sgt);
@@ -740,14 +742,14 @@ static void tegra_gem_prime_vunmap(struct dma_buf *buf, struct iosys_map *map)
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
diff --git a/drivers/gpu/drm/virtio/virtgpu_prime.c b/drivers/gpu/drm/virtio/virtgpu_prime.c
index a47783b47dcc..fd6943e8a40a 100644
--- a/drivers/gpu/drm/virtio/virtgpu_prime.c
+++ b/drivers/gpu/drm/virtio/virtgpu_prime.c
@@ -24,6 +24,7 @@
 
 #include <drm/drm_prime.h>
 #include <drm/drm_print.h>
+#include <linux/dma-buf-mapping.h>
 #include <linux/virtio_dma_buf.h>
 
 #include "virtgpu_drv.h"
@@ -54,7 +55,8 @@ virtgpu_gem_map_dma_buf(struct dma_buf_attachment *attach,
 	struct virtio_gpu_object *bo = gem_to_virtio_gpu_obj(obj);
 
 	if (virtio_gpu_is_vram(bo))
-		return virtio_gpu_vram_map_dma_buf(bo, attach->dev, dir);
+		return virtio_gpu_vram_map_dma_buf(
+			bo, dma_buf_sgt_dma_device(attach), dir);
 
 	return drm_gem_map_dma_buf(attach, dir);
 }
@@ -67,7 +69,8 @@ static void virtgpu_gem_unmap_dma_buf(struct dma_buf_attachment *attach,
 	struct virtio_gpu_object *bo = gem_to_virtio_gpu_obj(obj);
 
 	if (virtio_gpu_is_vram(bo)) {
-		virtio_gpu_vram_unmap_dma_buf(attach->dev, sgt, dir);
+		virtio_gpu_vram_unmap_dma_buf(dma_buf_sgt_dma_device(attach),
+					      sgt, dir);
 		return;
 	}
 
@@ -78,12 +81,12 @@ static const struct virtio_dma_buf_ops virtgpu_dmabuf_ops =  {
 	.ops = {
 		.attach = virtio_dma_buf_attach,
 		.detach = drm_gem_map_detach,
-		.map_dma_buf = virtgpu_gem_map_dma_buf,
-		.unmap_dma_buf = virtgpu_gem_unmap_dma_buf,
 		.release = drm_gem_dmabuf_release,
 		.mmap = drm_gem_dmabuf_mmap,
 		.vmap = drm_gem_dmabuf_vmap,
 		.vunmap = drm_gem_dmabuf_vunmap,
+		DMA_BUF_SIMPLE_SGT_EXP_MATCH(virtgpu_gem_map_dma_buf,
+					     virtgpu_gem_unmap_dma_buf),
 	},
 	.device_attach = drm_gem_map_attach,
 	.get_uuid = virtgpu_virtio_get_uuid,
diff --git a/drivers/iommu/iommufd/selftest.c b/drivers/iommu/iommufd/selftest.c
index 25387969ab75..77b7d962cf17 100644
--- a/drivers/iommu/iommufd/selftest.c
+++ b/drivers/iommu/iommufd/selftest.c
@@ -6,6 +6,7 @@
 #include <linux/anon_inodes.h>
 #include <linux/debugfs.h>
 #include <linux/dma-buf.h>
+#include <linux/dma-buf-mapping.h>
 #include <linux/dma-resv.h>
 #include <linux/fault-inject.h>
 #include <linux/file.h>
@@ -1959,17 +1960,6 @@ struct iommufd_test_dma_buf {
 	bool revoked;
 };
 
-static int iommufd_test_dma_buf_attach(struct dma_buf *dmabuf,
-				       struct dma_buf_attachment *attachment)
-{
-	return 0;
-}
-
-static void iommufd_test_dma_buf_detach(struct dma_buf *dmabuf,
-					struct dma_buf_attachment *attachment)
-{
-}
-
 static struct sg_table *
 iommufd_test_dma_buf_map(struct dma_buf_attachment *attachment,
 			 enum dma_data_direction dir)
@@ -1992,11 +1982,9 @@ static void iommufd_test_dma_buf_release(struct dma_buf *dmabuf)
 }
 
 static const struct dma_buf_ops iommufd_test_dmabuf_ops = {
-	.attach = iommufd_test_dma_buf_attach,
-	.detach = iommufd_test_dma_buf_detach,
-	.map_dma_buf = iommufd_test_dma_buf_map,
 	.release = iommufd_test_dma_buf_release,
-	.unmap_dma_buf = iommufd_test_dma_buf_unmap,
+	DMA_BUF_SIMPLE_SGT_EXP_MATCH(iommufd_test_dma_buf_map,
+				     iommufd_test_dma_buf_unmap),
 };
 
 int iommufd_test_dma_buf_iommufd_map(struct dma_buf_attachment *attachment,
diff --git a/drivers/media/common/videobuf2/videobuf2-dma-contig.c b/drivers/media/common/videobuf2/videobuf2-dma-contig.c
index 284482335c1a..039ff95ac4db 100644
--- a/drivers/media/common/videobuf2/videobuf2-dma-contig.c
+++ b/drivers/media/common/videobuf2/videobuf2-dma-contig.c
@@ -11,6 +11,7 @@
  */
 
 #include <linux/dma-buf.h>
+#include <linux/dma-buf-mapping.h>
 #include <linux/module.h>
 #include <linux/refcount.h>
 #include <linux/scatterlist.h>
@@ -372,8 +373,8 @@ static void vb2_dc_dmabuf_ops_detach(struct dma_buf *dbuf,
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
@@ -392,8 +393,8 @@ static struct sg_table *vb2_dc_dmabuf_ops_map(
 
 	/* release any previous cache */
 	if (attach->dma_dir != DMA_NONE) {
-		dma_unmap_sgtable(db_attach->dev, sgt, attach->dma_dir,
-				  DMA_ATTR_SKIP_CPU_SYNC);
+		dma_unmap_sgtable(dma_buf_sgt_dma_device(db_attach), sgt,
+				  attach->dma_dir, DMA_ATTR_SKIP_CPU_SYNC);
 		attach->dma_dir = DMA_NONE;
 	}
 
@@ -401,7 +402,7 @@ static struct sg_table *vb2_dc_dmabuf_ops_map(
 	 * mapping to the client with new direction, no cache sync
 	 * required see comment in vb2_dc_dmabuf_ops_detach()
 	 */
-	if (dma_map_sgtable(db_attach->dev, sgt, dma_dir,
+	if (dma_map_sgtable(dma_buf_sgt_dma_device(db_attach), sgt, dma_dir,
 			    DMA_ATTR_SKIP_CPU_SYNC)) {
 		pr_err("failed to map scatterlist\n");
 		return ERR_PTR(-EIO);
@@ -462,13 +463,13 @@ static int vb2_dc_dmabuf_ops_mmap(struct dma_buf *dbuf,
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
index 54b07e3840ac..5a201062ff5b 100644
--- a/drivers/media/common/videobuf2/videobuf2-dma-sg.c
+++ b/drivers/media/common/videobuf2/videobuf2-dma-sg.c
@@ -10,6 +10,7 @@
  * the Free Software Foundation.
  */
 
+#include <linux/dma-buf-mapping.h>
 #include <linux/module.h>
 #include <linux/mm.h>
 #include <linux/refcount.h>
@@ -417,7 +418,8 @@ static void vb2_dma_sg_dmabuf_ops_detach(struct dma_buf *dbuf,
 
 	/* release the scatterlist cache */
 	if (attach->dma_dir != DMA_NONE)
-		dma_unmap_sgtable(db_attach->dev, sgt, attach->dma_dir, 0);
+		dma_unmap_sgtable(dma_buf_sgt_dma_device(db_attach), sgt,
+				  attach->dma_dir, 0);
 	sg_free_table(sgt);
 	kfree(attach);
 	db_attach->priv = NULL;
@@ -436,12 +438,14 @@ static struct sg_table *vb2_dma_sg_dmabuf_ops_map(
 
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
@@ -510,13 +514,13 @@ static int vb2_dma_sg_dmabuf_ops_mmap(struct dma_buf *dbuf,
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
index 63f023696f3e..d79acf83286a 100644
--- a/drivers/media/common/videobuf2/videobuf2-vmalloc.c
+++ b/drivers/media/common/videobuf2/videobuf2-vmalloc.c
@@ -10,6 +10,7 @@
  * the Free Software Foundation.
  */
 
+#include <linux/dma-buf-mapping.h>
 #include <linux/io.h>
 #include <linux/module.h>
 #include <linux/mm.h>
@@ -261,7 +262,8 @@ static void vb2_vmalloc_dmabuf_ops_detach(struct dma_buf *dbuf,
 
 	/* release the scatterlist cache */
 	if (attach->dma_dir != DMA_NONE)
-		dma_unmap_sgtable(db_attach->dev, sgt, attach->dma_dir, 0);
+		dma_unmap_sgtable(dma_buf_sgt_dma_device(db_attach), sgt,
+				  attach->dma_dir, 0);
 	sg_free_table(sgt);
 	kfree(attach);
 	db_attach->priv = NULL;
@@ -270,6 +272,7 @@ static void vb2_vmalloc_dmabuf_ops_detach(struct dma_buf *dbuf,
 static struct sg_table *vb2_vmalloc_dmabuf_ops_map(
 	struct dma_buf_attachment *db_attach, enum dma_data_direction dma_dir)
 {
+	struct device *dma_dev = dma_buf_sgt_dma_device(db_attach);
 	struct vb2_vmalloc_attachment *attach = db_attach->priv;
 	struct sg_table *sgt;
 
@@ -280,12 +283,12 @@ static struct sg_table *vb2_vmalloc_dmabuf_ops_map(
 
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
@@ -326,11 +329,11 @@ static int vb2_vmalloc_dmabuf_ops_mmap(struct dma_buf *dbuf,
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
index 76c8dc05fa10..cbe53144e79b 100644
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
@@ -780,7 +781,8 @@ fastrpc_map_dma_buf(struct dma_buf_attachment *attachment,
 
 	table = &a->sgt;
 
-	ret = dma_map_sgtable(attachment->dev, table, dir, 0);
+	ret = dma_map_sgtable(dma_buf_sgt_dma_device(attachment), table, dir,
+			      0);
 	if (ret)
 		table = ERR_PTR(ret);
 	return table;
@@ -790,7 +792,7 @@ static void fastrpc_unmap_dma_buf(struct dma_buf_attachment *attach,
 				  struct sg_table *table,
 				  enum dma_data_direction dir)
 {
-	dma_unmap_sgtable(attach->dev, table, dir, 0);
+	dma_unmap_sgtable(dma_buf_sgt_dma_device(attach), table, dir, 0);
 }
 
 static void fastrpc_release(struct dma_buf *dmabuf)
@@ -820,7 +822,7 @@ static int fastrpc_dma_buf_attach(struct dma_buf *dmabuf,
 		return -EINVAL;
 	}
 
-	a->dev = attachment->dev;
+	a->dev = dma_buf_sgt_dma_device(attachment);
 	INIT_LIST_HEAD(&a->node);
 	attachment->priv = a;
 
@@ -868,11 +870,11 @@ static int fastrpc_mmap(struct dma_buf *dmabuf,
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
index 007c00156520..099b153087a3 100644
--- a/drivers/tee/tee_heap.c
+++ b/drivers/tee/tee_heap.c
@@ -4,6 +4,7 @@
  */
 
 #include <linux/dma-buf.h>
+#include <linux/dma-buf-mapping.h>
 #include <linux/dma-heap.h>
 #include <linux/genalloc.h>
 #include <linux/module.h>
@@ -104,7 +105,7 @@ static int tee_heap_attach(struct dma_buf *dmabuf,
 		return ret;
 	}
 
-	a->dev = attachment->dev;
+	a->dev = dma_buf_sgt_dma_device(attachment);
 	attachment->priv = a;
 
 	return 0;
@@ -126,8 +127,8 @@ tee_heap_map_dma_buf(struct dma_buf_attachment *attachment,
 	struct tee_heap_attachment *a = attachment->priv;
 	int ret;
 
-	ret = dma_map_sgtable(attachment->dev, &a->table, direction,
-			      DMA_ATTR_SKIP_CPU_SYNC);
+	ret = dma_map_sgtable(dma_buf_sgt_dma_device(attachment), &a->table,
+			      direction, DMA_ATTR_SKIP_CPU_SYNC);
 	if (ret)
 		return ERR_PTR(ret);
 
@@ -142,7 +143,7 @@ static void tee_heap_unmap_dma_buf(struct dma_buf_attachment *attachment,
 
 	WARN_ON(&a->table != table);
 
-	dma_unmap_sgtable(attachment->dev, table, direction,
+	dma_unmap_sgtable(dma_buf_sgt_dma_device(attachment), table, direction,
 			  DMA_ATTR_SKIP_CPU_SYNC);
 }
 
@@ -160,9 +161,9 @@ static void tee_heap_buf_free(struct dma_buf *dmabuf)
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
index e07e34515421..27cb179efc15 100644
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
@@ -243,9 +244,10 @@ static void dmabuf_exp_ops_detach(struct dma_buf *dma_buf,
 
 		if (sgt) {
 			if (gntdev_dmabuf_attach->dir != DMA_NONE)
-				dma_unmap_sgtable(attach->dev, sgt,
-						  gntdev_dmabuf_attach->dir,
-						  DMA_ATTR_SKIP_CPU_SYNC);
+				dma_unmap_sgtable(
+					dma_buf_sgt_dma_device(attach), sgt,
+					gntdev_dmabuf_attach->dir,
+					DMA_ATTR_SKIP_CPU_SYNC);
 			sg_free_table(sgt);
 		}
 
@@ -259,12 +261,13 @@ static struct sg_table *
 dmabuf_exp_ops_map_dma_buf(struct dma_buf_attachment *attach,
 			   enum dma_data_direction dir)
 {
+	struct device *dma_dev = dma_buf_sgt_dma_device(attach);
 	struct gntdev_dmabuf_attachment *gntdev_dmabuf_attach = attach->priv;
 	struct gntdev_dmabuf *gntdev_dmabuf = attach->dmabuf->priv;
 	struct sg_table *sgt;
 
 	pr_debug("Mapping %d pages for dev %p\n", gntdev_dmabuf->nr_pages,
-		 attach->dev);
+		 dma_dev);
 
 	if (dir == DMA_NONE || !gntdev_dmabuf_attach)
 		return ERR_PTR(-EINVAL);
@@ -283,7 +286,7 @@ dmabuf_exp_ops_map_dma_buf(struct dma_buf_attachment *attach,
 	sgt = dmabuf_pages_to_sgt(gntdev_dmabuf->pages,
 				  gntdev_dmabuf->nr_pages);
 	if (!IS_ERR(sgt)) {
-		if (dma_map_sgtable(attach->dev, sgt, dir,
+		if (dma_map_sgtable(dma_dev, sgt, dir,
 				    DMA_ATTR_SKIP_CPU_SYNC)) {
 			sg_free_table(sgt);
 			kfree(sgt);
@@ -294,7 +297,7 @@ dmabuf_exp_ops_map_dma_buf(struct dma_buf_attachment *attach,
 		}
 	}
 	if (IS_ERR(sgt))
-		pr_debug("Failed to map sg table for dev %p\n", attach->dev);
+		pr_debug("Failed to map sg table for dev %p\n", dma_dev);
 	return sgt;
 }
 
@@ -340,9 +343,9 @@ static void dmabuf_exp_ops_release(struct dma_buf *dma_buf)
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
diff --git a/samples/vfio-mdev/mbochs.c b/samples/vfio-mdev/mbochs.c
index 64ea19253ee3..c2eaa14b9ddd 100644
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
@@ -872,7 +873,7 @@ static struct sg_table *mbochs_map_dmabuf(struct dma_buf_attachment *at,
 	if (sg_alloc_table_from_pages(sg, dmabuf->pages, dmabuf->pagecount,
 				      0, dmabuf->mode.size, GFP_KERNEL) < 0)
 		goto err2;
-	if (dma_map_sgtable(at->dev, sg, direction, 0))
+	if (dma_map_sgtable(dma_buf_sgt_dma_device(at), sg, direction, 0))
 		goto err3;
 
 	return sg;
@@ -894,7 +895,7 @@ static void mbochs_unmap_dmabuf(struct dma_buf_attachment *at,
 
 	dev_dbg(dev, "%s: %d\n", __func__, dmabuf->id);
 
-	dma_unmap_sgtable(at->dev, sg, direction, 0);
+	dma_unmap_sgtable(dma_buf_sgt_dma_device(at), sg, direction, 0);
 	sg_free_table(sg);
 	kfree(sg);
 }
@@ -918,11 +919,10 @@ static void mbochs_release_dmabuf(struct dma_buf *buf)
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
index 58101ce07c9f..ef5a0d7639ed 100644
--- a/sound/soc/fsl/fsl_asrc_m2m.c
+++ b/sound/soc/fsl/fsl_asrc_m2m.c
@@ -7,6 +7,7 @@
 
 #include <linux/dma/imx-dma.h>
 #include <linux/dma-buf.h>
+#include <linux/dma-buf-mapping.h>
 #include <linux/dma-mapping.h>
 #include <linux/pm_runtime.h>
 #include <sound/asound.h>
@@ -417,6 +418,7 @@ static int fsl_asrc_m2m_mmap(struct dma_buf *dmabuf, struct vm_area_struct *vma)
 static struct sg_table *fsl_asrc_m2m_map_dma_buf(struct dma_buf_attachment *attachment,
 						 enum dma_data_direction direction)
 {
+	struct device *dma_dev = dma_buf_sgt_dma_device(attachment);
 	struct snd_dma_buffer *dmab = attachment->dmabuf->priv;
 	struct sg_table *sgt;
 
@@ -424,10 +426,10 @@ static struct sg_table *fsl_asrc_m2m_map_dma_buf(struct dma_buf_attachment *atta
 	if (!sgt)
 		return NULL;
 
-	if (dma_get_sgtable(attachment->dev, sgt, dmab->area, dmab->addr, dmab->bytes) < 0)
+	if (dma_get_sgtable(dma_dev, sgt, dmab->area, dmab->addr, dmab->bytes) < 0)
 		goto free;
 
-	if (dma_map_sgtable(attachment->dev, sgt, direction, 0))
+	if (dma_map_sgtable(dma_dev, sgt, direction, 0))
 		goto free;
 
 	return sgt;
@@ -442,7 +444,7 @@ static void fsl_asrc_m2m_unmap_dma_buf(struct dma_buf_attachment *attachment,
 				       struct sg_table *table,
 				       enum dma_data_direction direction)
 {
-	dma_unmap_sgtable(attachment->dev, table, direction, 0);
+	dma_unmap_sgtable(dma_buf_sgt_dma_device(attachment), table, direction, 0);
 }
 
 static void fsl_asrc_m2m_release(struct dma_buf *dmabuf)
@@ -452,9 +454,9 @@ static void fsl_asrc_m2m_release(struct dma_buf *dmabuf)
 
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

