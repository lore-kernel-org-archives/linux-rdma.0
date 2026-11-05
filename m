Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.198.55
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793860972;
	b=p5kADsYe+Wq4sgIoqIqsOnwOOjVGEj9g7RVIF2jTUjKF0W0Ggyeh4xYTjNwZkVwGNmy7
	 OJ1ONPFjilXKq2zf/8ctw/UMe+oT+nvAF1a/xO5js5OOdW1DTSAX3mEQI3RO7Tppi7u0i
	 GXtVtCArgh87vaPqNiiUkwqsLzT79Fsz5L1xiYAyPy6x7pSNXw3HknxymSWy9oYz7KsBJ
	 pmsolFjXeXs1+7zmlAZFPWN9AgCTyl20LTdGef/XwJvw1YHLS/xcmat/vzVTp9MBziSsj
	 hiOjG+86G3FCcAMrpn5iHRnchoqLnaFpTGD2Xsyo6rWsaaQEl9O1xAiQwGdG/O3CTNQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793860972;
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
	bh=af3y0HlYYkxHC5UdGIrztB/GP4Dp0U6tXxdZOBU7WZM=;
	b=V3OWfS2GMG6sHVq18U4i+4gdQfadO1GJ9GII0X70uuzvCynzg6utckv3tPHS2p5XZdZ3
	 cBmH3iEPZuXNEouwqgNPdqrB5Zw6qfFVXD6mfCDkMv+pYdcCn1qjb9zhAD+QadSN1CLkK
	 9F8qUffKWAdB/MdoOjHC6AAjK0f4DG+0uowvcTzOLtQnFjg0ARsnu3/csMCU4iio1tEO4
	 COxnvOyGsold7oikIEqXAGuA9dmd1oVUy7ZGGW3jbbO/eLUSopF0XKYAQ+dOZdz9uIKb2
	 vs0X30vaCOtdJn8m5wek3az7CxbFZNqcf58X8o08e6J+18cJHadxmuG/a9C6KjzdBXA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b="ftN5/QwL";
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.198.55
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010055.outbound.protection.outlook.com [40.93.198.55])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B81AC606A33A;
	Thu,  5 Nov 2026 06:42:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B81AC606A33A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=ftN5/QwL
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ODSze3fcKAkSsxzxsQpXwnYEUejLTJ5433pIbjuqCSxQxWxR1c1gof/zeKeq1eUKHCDIZLUY2ZqM/yqzbxHKTheBkJ3TAx/LXBzSIwhdOGVKWCOcdcpOPZaIwXCTsYs016TB1KYHmikx1iNJKBU0f0NxA0aMVM6NjSwRiVLWNCBjJrgB3Wf5t2OzdqkiY/fd8tBW6Ho1ATzm4fO4BsKFV7EgWqpeqz1J2hDIwxYVWCCgRcgoe0yzl+rB4mZ6RjKfDIXEc+YTZzjNNe/hFMSIsj0Hd5Kg+OAfgzFcvYYZi6u44dcNZnZul8hzUV9CtqvQn4RDTbhfrrexzVfeF01TFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=af3y0HlYYkxHC5UdGIrztB/GP4Dp0U6tXxdZOBU7WZM=;
 b=o6FQix3hwPwhy0eE9MkroFfx04jp5QGDTPp06x75KufzFsZNPdaHo2I198ESUphPVrtGVsLazQxUGPUN50Ep6aRqM5DknB3waMI+rh/HbhhcsfYAkusF7xFI0vU1m3iwoB93oD49Ojv0LfibxM7OeJxBQF4/eRY05VYKGtwlHYCLox0m102ez1mjEodSt9U0/eh/nGoLycWD2kr+ferKzyI3UBQnG48qx27tUSXjed9JZ+fkO+JRw/jIYUGKHjPIh6NqAcEcB3zzU/BpFjLJf/sYUoYJU7PyH99ACJIgzTlOS+eUkKgs6YqyMUwvOI2arB0Lf88KygXXja7b1Tnbeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=af3y0HlYYkxHC5UdGIrztB/GP4Dp0U6tXxdZOBU7WZM=;
 b=ftN5/QwLZlxjBjWkbLbk/HBLLL1P0zBwyyC0qOtcHklBpy8nampBDUqUZWeFdgs0amIR1BPc3+1CEZlCeQbJGcauZjzRFwRhY2zvnco4x0O6VZWC2DaXEpXEgxMHw8fjYQZQxm0YeGcXgTt6kReTFp0jKDEFGahfKusE7QJ/68QaBxwSZV724XdoVcLxjZq3F09I6BV/92bh2DqagCEojQ1bkE2gQSX68K2QWmjxP8D1jVtUhth/zfzfMt3fiLKNv5AQpdUI1I4fEkXxYI8E0IXP9T7O1+MwxPc9kydOb6JTVDefmJAMiphmt1Et5/yZemn88OH7m/vFpLMfWQaBGA==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SA3PR12MB598757.namprd12.prod.outlook.com
 (2603:10b6:806:52d::14) by IA0PR12MB8932.namprd12.prod.outlook.com
 (2603:10b6:208:492::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.9; Thu, 5 Nov 2026
 06:42:48 +0000
Received: from SA3PR12MB598757.namprd12.prod.outlook.com
 ([fe80::e206:100:5946:a777]) by SA3PR12MB598757.namprd12.prod.outlook.com
 ([fe80::e206:100:5946:a777%5]) with mapi id 15.21.0592.009; Thu, 5 Nov 2026
 06:42:48 +0000
From: Alistair Popple <apopple@nvidia.com>
Date: Thu, 05 Nov 2026 17:40:52 +1100
Subject: [PATCH v2 17/23] RDMA/uverbs: Use the SGT_P2P mapping type
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261105-dma_mapping_type_v4-v2-17-78b8dc9ae80a@nvidia.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793860879; l=2351;
 i=apopple@nvidia.com; s=20261105; h=from:subject:message-id;
 bh=ESeb24BoNKQpZfDwwkGacwOa2G5SDGNGPUZICBgDcJg=;
 b=qaZEhC1VqR5YfOqrSDyl9nhMrwQ+DFbbsCZFjLT0rFzyTtYkl2Jga+02gOMhG1HkAkxnIcugw
 rqS/B8x1UQGBf5IVzZFISF23q7uXAqK0djcZqHs17uxuhUrpbR9Mqie
X-Developer-Key: i=apopple@nvidia.com; a=ed25519;
 pk=WdWPT9rAq3YNfXldbGv1NSGVLGxzQGFGJvRUiShhNqs=
X-ClientProxiedBy: SY5PR01CA0052.ausprd01.prod.outlook.com
 (2603:10c6:10:1fc::12) To SA3PR12MB598757.namprd12.prod.outlook.com
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
X-MS-Office365-Filtering-Correlation-Id: b835aeda-25d5-4821-c054-08df3b08018c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|7416014|1800799024|23010399003|22082099003|18002099003|56012099006|261021123027099003|921020|261021121427099003|261022075727099003|261022105027099003|261009223027099003|261026140227099003|261026121527099003|10067099003|261028144727099003|11063799006|261102123227099003;
X-Microsoft-Antispam-Message-Info:
	YhRAjfp2IRAL/y9rgVAtOKHKnUpLMYjVsdg3IqZ68aviJ+RaYykKgwpAJN5xn0BZfSDdO+bVRdFS+vp67WE6PLCYNjm3Np0DZoe8TMHn469hIEHlNrbUTQuYIEOfFjeMCWtjQ+SPCR7gFzsnNu/Ka7vU68+fbTeFSDeovTb04lvXmVEliAV5FkrdFsM2QOLsD0CdJoHz6dudHCk0WYpWGQFkgxAjV95xTMS0YnvU8pLpuCypedv9rChMDlt5LH6fvU9PX/csOUKnORxKtEt/s5SAA+2NBDoZORQ4f94RC7Vz0Eb9muh0EA89AgEh+wCasKeB1w5xGI18owEoi0V8aKNs4A+35pdd+bE7EcFJfcOQNxqx/869TVGqJAa8VkRvJmByXu9yTvVfSQrevbZw/ZRoBjdUTbdxLo4rhKr66/vHmHTB5jW2/tEZcycJMHEx2YCjJF3jRu1Q5UmRi2bDSWB4fh0sQdDnEfIQU3RAjuqGbGYsYdTPZEaMKHvHRjGKDC1BQVPa0Vvd6qWOo9tlm0KLSBYHhEy+aVLJqvEsuPSLnoXuFVLrDEIyiHGWwgyVxVwi+U3HPlqXYw24BBbyJGb94NA5twUWfFaHz4zOC6GVgYEd1XHFUzp6sXGdUHxkGZ+ZsyFr+HNBbBQKw3wAIzMoYxLd9IWwDfTVH8XJjkQrN43peuJthUN9eZL1FvPk6Yj186ceJILLqgyXSSBVrA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA3PR12MB598757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(7416014)(1800799024)(23010399003)(22082099003)(18002099003)(56012099006)(261021123027099003)(921020)(261021121427099003)(261022075727099003)(261022105027099003)(261009223027099003)(261026140227099003)(261026121527099003)(10067099003)(261028144727099003)(11063799006)(261102123227099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?a1R3ZDIzSTBET1BEQVVsUTVmbW9VNXVGV0ZzT200UVkyNCswUHNJYS8wRjlR?=
 =?utf-8?B?Qy8zeDRmUGhFREpVTzZJOFRLVFJZZGFDNC83Z2d0TEtBT0hiUzRWTWhRWlFy?=
 =?utf-8?B?SmRJZmFFOFdWdHVYd2VWYUh4a092WWtJUGNhTnBqWExDRUk0K3UwRWs2eHJE?=
 =?utf-8?B?cThwdXZWWmhWdDlRY25zbmJPT05ueGxLcmU5cTV0cE1iRXVpSkR1Tm9FNTYy?=
 =?utf-8?B?MVRQdWdLTXJyQzF5MXpjNm1sNVB3ZXhmcWRkZmJCM0pxSWFsWngwcStFM1lB?=
 =?utf-8?B?Tjh0aGRDRE81em0vZFpyNUFNTmhFNjFvcDMrLzBjbEFWdGFuVlB0bzlWTnQx?=
 =?utf-8?B?dE9LV05KTklySXUvS3Y1SjJNQzdSamtURzFOdHBoS2Y3MUZSbUdYd3Z3T3pE?=
 =?utf-8?B?UGJHVnJiKzBiZjV3ZVpsYkZPUE1xaVROb09LRzdCZDB2NGcyNFpsbFYvKzBE?=
 =?utf-8?B?WDlwUDdneG5EaEdWWlpDTXRVVi9zR3hMQ3NSenRyeGYrOGNrdHlGVXdlTXlU?=
 =?utf-8?B?ZUpxZlByQTYyU2ZLQStNUHpHSVE5U1F3MDVCNW1hUW9WdGhzbHlPQWlQWjRs?=
 =?utf-8?B?WW1ld0NvbTJEeFljZkJKZlhQMVBjaHRVZ21LcFdxOXI2dWJYYzl2Z0c4Wjh0?=
 =?utf-8?B?WEpKR3kwd2Mya1hRK2pIVkEyZXhaV2ZvZkpERWRBMzBwV3FuQlh1eDJYZUdu?=
 =?utf-8?B?WGVJQzR0WGRsanJwUllrS2ZQUlJ2ekZHRWVtRzdWQSs4YldBNHQ4ZmVEc3l1?=
 =?utf-8?B?Z0hNbnR5OW9VUnNJK28wM04xSlUyT0x1bUdJK1dUUVVFNEdPanRXMWhEZXow?=
 =?utf-8?B?MkJFSzYxanVWZytiT1pzMlV4VXo0ejBQd1NXdk9uZEpYLytyanVuMDR4OEZD?=
 =?utf-8?B?L2xCREFGTmNYVDdWcm95S09FMVgrbEpqdHZSeVR3eU1ySFd0T3BGanNhZVY3?=
 =?utf-8?B?REkyUVdNMHhac2tuMmYrU1ZER2twaEMwQlRHL3l2MGkvWVJWenA2U0FLRGpm?=
 =?utf-8?B?c0lheUpaYlhZY2NSSFlUK1hzRTRqald5R3JoMXhGV2JzS1ZTVkJEWUhkaE5K?=
 =?utf-8?B?NlpvdkxBQ3VERzNQcjRvUno5RHE5ZlZES0t1TURSajVzOUd3eW5jVjI4cXhE?=
 =?utf-8?B?S2FQQjB3MGozOXh0MFVVNTQyOWZUdEo0MnV0ZzVZeC9JOEV5bi8zU0VLQUxX?=
 =?utf-8?B?ZjBLVXE5R3lKdTNIaEN4REh1YXU3UDBGMGVwSkkvQzZlMjQybnFYajNNVlJY?=
 =?utf-8?B?dm9YYmZwOHhmdWg5anV1SS9RTTByWm5rd0p1U1p5OXNwYVlSRklZd1dmTG85?=
 =?utf-8?B?ZGp2Qkozd0NrSW5Mcm9TZ2xjelh5YkZYQ3N3dGhHTG5uN1ltMktHbmZrZVJ1?=
 =?utf-8?B?dFVaVmorRCs0WGNoV0xTL3M5aFJQUUxIVnc2S1MrVGVRRlJjN25HU0NUY3Yw?=
 =?utf-8?B?cVRPRTQ5S1RYYW11S0FYN1hoQU45NVh5a0ZVbUpKaXNZZFE2bEczUFFIekM3?=
 =?utf-8?B?b2lQUUltZmlVSGhoZkM4QUMyMU81ajR3Q2QwdDRCbENHOHdQQjF0YXFPSGJN?=
 =?utf-8?B?K2gxOFJvaGl6QjRLRFRKdTB4cVRGdWd0b053YWJYYnhZS1BoQyt0RXRlWCtt?=
 =?utf-8?B?VHc5a2RNelJGbHRIcnBQZm1JZnBaRHk0endVQ0NjT1BWRUNWU1RKVDVrQWQ1?=
 =?utf-8?B?eVhJZFd3bldmQkFZY29mck56Ym5WakZoRHBXZHhQYnAvM2dNM2dxaFM5aUFG?=
 =?utf-8?B?VFRSRUZFY3Aya3VkMllHeDBHei9ROEhPS2NsbWJXTWtvSzFZQnkwU2krdmdG?=
 =?utf-8?B?L2hsS29yQlVGSVZ6TkYvaHVRZll1NnVOeEhQSWgrejBIQkpvNG92UVFvYUgv?=
 =?utf-8?B?K1ZNbEFXTG05SFhyQmpRSUpDU00wZi8rc1ExbTlsVXBOV1Y0bDJWL3RFUnNK?=
 =?utf-8?B?ZVNiczVSckduWWtQQ25RSHd2VXNHN1BIMjFOY2JtMHdGR2V2cThMQVVrbm04?=
 =?utf-8?B?SmMrRGYxMzBpSkgzSnlBQVZDYUYxbStHc3RnVjVCSnZra3VlcURFMTl3dDF0?=
 =?utf-8?B?c2RScTd0NE5SWHEzUDRuSmk2WklTMnExM3ZZVmdrQlVaU05NaFJLaDIzY2Rh?=
 =?utf-8?B?UFY5R2hBSHcyckd2QjRoMzhFWXBGY1dwWkdEMXNDb1E0NnBZYkNsRERIcHFS?=
 =?utf-8?B?K1dzaDBNT2VuZDA4MGdqbVRTQ3YwUGthdldsRnNicytoNnM2dEtJbStGbG1E?=
 =?utf-8?B?K0xzcUl4RmNOdmNsVEtLOEdvMlFVRjA5NS9YakdDNXJIK1NDckQ1b1BXazk3?=
 =?utf-8?B?cjdyK2Z4QWZ0SVFnNXRjNWc0dWRFb2JtNmVrREMwSk5TaUFLRnQwZz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b835aeda-25d5-4821-c054-08df3b08018c
X-MS-Exchange-CrossTenant-AuthSource: SA3PR12MB598757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2026 06:42:48.2232
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: r7ZKJ0Bs5kQ5tenQZslmKaj9VNQVe7WY/XZnljwOE2QCj8wk0hgSrekyt19el7ZPqgE7qtzxqGZh/ddwqt5CWw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8932

From: Jason Gunthorpe <jgg@nvidia.com>

Very similar to habana, except the rejection of unsupported
pci_p2p_dma_distance() is done inside map not attach via
dma_buf_phys_vec_to_sgt().

Convert this directly to a SGT_P2P match which will prevent matching if
dma_buf_phys_vec_to_sgt() would fail.

Remove the now empty attach function.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Alistair Popple <apopple@nvidia.com>
---
 drivers/infiniband/core/uverbs_std_types_dmabuf.c | 30 ++++++++++++++---------
 1 file changed, 19 insertions(+), 11 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_std_types_dmabuf.c b/drivers/infiniband/core/uverbs_std_types_dmabuf.c
index 8d8c997a4883..0bae578c3d78 100644
--- a/drivers/infiniband/core/uverbs_std_types_dmabuf.c
+++ b/drivers/infiniband/core/uverbs_std_types_dmabuf.c
@@ -12,15 +12,6 @@
 
 MODULE_IMPORT_NS("DMA_BUF");
 
-static int uverbs_dmabuf_attach(struct dma_buf *dmabuf,
-				struct dma_buf_attachment *attachment)
-{
-	if (!attachment->peer2peer)
-		return -EOPNOTSUPP;
-
-	return 0;
-}
-
 static struct sg_table *
 uverbs_dmabuf_map(struct dma_buf_attachment *attachment,
 		  enum dma_data_direction dir)
@@ -95,13 +86,30 @@ static void uverbs_dmabuf_release(struct dma_buf *dmabuf)
 	uverbs_uobject_put(&priv->uobj);
 }
 
-static const struct dma_buf_ops uverbs_dmabuf_ops = {
-	.attach = uverbs_dmabuf_attach,
+static const struct dma_buf_mapping_sgt_exp_ops uverbs_dma_buf_sgt_ops = {
 	.map_dma_buf = uverbs_dmabuf_map,
 	.unmap_dma_buf = uverbs_dmabuf_unmap,
+};
+
+static int uverbs_dmabuf_match_mapping(struct dma_buf_match_args *args)
+{
+	struct dma_buf_mapping_match sgt_match[1];
+
+	/*
+	 * MMIO, so the importer must accept P2P. The provider is only valid
+	 * under the dma_resv lock while not revoked, so the distance check is
+	 * left to dma_buf_phys_vec_to_sgt() at map time, as before.
+	 */
+	sgt_match[0] = DMA_BUF_EMAPPING_SGT_REQUIRES_P2P(&uverbs_dma_buf_sgt_ops);
+
+	return dma_buf_match_mapping(args, sgt_match, ARRAY_SIZE(sgt_match));
+}
+
+static const struct dma_buf_ops uverbs_dmabuf_ops = {
 	.pin = uverbs_dmabuf_pin,
 	.unpin = uverbs_dmabuf_unpin,
 	.release = uverbs_dmabuf_release,
+	.match_mapping = uverbs_dmabuf_match_mapping,
 };
 
 static int UVERBS_HANDLER(UVERBS_METHOD_DMABUF_ALLOC)(

-- 
2.54.0

