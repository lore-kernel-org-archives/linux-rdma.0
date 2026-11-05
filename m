Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.56.8
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793860988;
	b=sqVIWVWtpAUQfiChNpSSON1KTdWgjAf5hteKcCrE9Tyw7mHM7vZTt2PCnaoe7BGPtok8
	 f/YdLhCEJ3eHkD5JTY9gkCyAVptf6cEBBMbaHOjDS2Z0NITf0Ogm2AZFX54jRW8Kgke8w
	 qEOZ+UV0Sq6/7hDyzhib4a+dfQ9NNbTrrRagPr1OVvNE83XtEgGOYr2VjkaBkmO0D+fhV
	 m0yt+gqgo9ukLXX/fuJ8NZrKOwvwkenRfXA7KJK92gnq8GeshohcRfn1qJa291i9lZVQc
	 AfYTv5QHIHvqUBW5g+U1she4AZaAWXNgFavN4YVggat7A6jlkXrY+uJaCJcrVbuoNUA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793860988;
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
	bh=M0/rHJKyNkkYtoCG+uw9pgVO/PkOCjE650UW66QdnHU=;
	b=nmznkIDknXrI0wt0d9bgwdSS7wKEDda967xxRIE/XUkQmw5njaYgpI108JqNNwHVByIz
	 PGJKPfVLxmXFIA6JK/GORUEH3mCDfNUkueTTV4xTPKwtWhTRrg7ellJJS+JDl+FwIPxdx
	 3QMgjDl1nps5h1s1kh4B/13XfnthDrV6IG03+S7sq8AfcV6at+oSJHUkzEKtywQlHy8BF
	 0JKpbpk09sEozn4Fo5jcbrLPJCZ1Sx5g/W/KG6LyZk8fJaE7WEc4k/C0kGNZSHYVS0H/c
	 aTwWK6B1pFaGqR3P6byBCuwMziZ9WGgu23GnwpwA2F155+ZOzhPOpPQOtpMAJrRbThA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=LM8gOb4c;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.56.8
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010008.outbound.protection.outlook.com [52.101.56.8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E882606A339;
	Thu,  5 Nov 2026 06:43:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8E882606A339
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=LM8gOb4c
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BtZFDUz8ulx+U5V8tCy+0hg5USr9wR8gJai+eymlcV2smlQmCUy5H9QeNWx/ayXCFmohSP5ap7Kg3EFcJinGjuGIwr5Haa7u2gY0vlezuUhF0jiaNFwC4kOKMXfu+6EGbaBD/SQD8KQKSlukOk8PjYsYJkW9QNSr6TGeViDQ+ro1weq86wMq2lUvkpbgt+Ds2oz4hHKnyfA8DBycV5bcB/ZKJobJHZMQDmU+FlJc+G0AJqRimEHT0NTZ0RFkymQB+og2RiHeLy9OF0rXcGYcctebkdDpvknYD1/Cok6izUWApav4MFaWXvrzKjxF2zRqme5DinZ1rPMrwonuD7Bfzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=M0/rHJKyNkkYtoCG+uw9pgVO/PkOCjE650UW66QdnHU=;
 b=PGYXnncVjfz7aRK2x5xRPZJG6QzRctWS29+n3u/gik6SV6DvLpKqZaVwwElWyRHsCjxRYuG2sA8z1I/Idt6PM5uKdZiPTyS8xKPa/7wGZfR49YO+9oU0onpsg4YUy7mExh5Q/31fskbe9X6zve3H2U1uYc6m1echcbo6hZkwfDcAvGWAVO5c30issOF1hoyeMc/4Rd1z3KxjxMzxiUC4LiCnj7W2FRA6oR7xCF8eq3GAAlG0JGnC8/Y7NkpHsX9BV5RBaQuXQuzznikHQSWwLgIV4Ey/Bx/UsPNZUm7xAvLOCoZSR64JVwkhJac/4Ea2886zxjDd7XuRepEJGptCeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M0/rHJKyNkkYtoCG+uw9pgVO/PkOCjE650UW66QdnHU=;
 b=LM8gOb4co2mW2EhSiopxOoD+wwgHv8g7DyJZ9MEuJW1WPfjWs2gcjtjXlVvGhdraU2Q+RRHojJsaVBtQGwE5iJ6SYqSJr07WcojHb+IEBSQIrMu593tfhCch1j+4F3REIoQe14/gZeK9D4+JLlOiZbo7PqciUwnImzHnllESznRjGVdZCiEjfAXr8yuu1DZfXX5vQs5jCFcJQb0X0PY4aZTYrfOJMOXAIuCyXlAmsXQQNygmH/dwXE7X3R+cbvWEsat4JoHlcIKaqY9WXZHFGWObw9tWqaPlPrHj5bnm8hQO1lPJqVJPKBOebYUasaILqNDYdlug3iGi55Ftn0Vl7Q==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SA3PR12MB598757.namprd12.prod.outlook.com
 (2603:10b6:806:52d::14) by IA0PR12MB8932.namprd12.prod.outlook.com
 (2603:10b6:208:492::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.9; Thu, 5 Nov 2026
 06:43:03 +0000
Received: from SA3PR12MB598757.namprd12.prod.outlook.com
 ([fe80::e206:100:5946:a777]) by SA3PR12MB598757.namprd12.prod.outlook.com
 ([fe80::e206:100:5946:a777%5]) with mapi id 15.21.0592.009; Thu, 5 Nov 2026
 06:43:03 +0000
From: Alistair Popple <apopple@nvidia.com>
Date: Thu, 05 Nov 2026 17:40:55 +1100
Subject: [PATCH v2 20/23] functionfs: convert to use the SGT mapping type
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261105-dma_mapping_type_v4-v2-20-78b8dc9ae80a@nvidia.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793860879; l=1510;
 i=apopple@nvidia.com; s=20261105; h=from:subject:message-id;
 bh=g4leWszYYOYQTMOVM+S9TZAQhclgsr0zjj3FSJdFZn8=;
 b=63UiwpSdwleD2B99rsY2a07poqLjnzRq3qcRH/Nn8NRWpWCb/nVQh4TBdI2KL1RQFlEePJOHc
 n5k2X/nso9BBXAqCtfItr7LY1Uoalp8pebtcnLieTYYUtIz8IalzU8S
X-Developer-Key: i=apopple@nvidia.com; a=ed25519;
 pk=WdWPT9rAq3YNfXldbGv1NSGVLGxzQGFGJvRUiShhNqs=
X-ClientProxiedBy: SY6PR01CA0158.ausprd01.prod.outlook.com
 (2603:10c6:10:1ba::6) To SA3PR12MB598757.namprd12.prod.outlook.com
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
X-MS-Office365-Filtering-Correlation-Id: 453a8022-80b6-478b-165b-08df3b080aa8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|7416014|1800799024|23010399003|6133799003|22082099003|18002099003|56012099006|261021123027099003|921020|261021121427099003|261022105027099003|261009223027099003|261026140227099003|10067099003|261028144727099003|11063799006|261102123227099003;
X-Microsoft-Antispam-Message-Info:
	62TM7qcU/bpn0CKDwJ62kRSLpsypzxAopmiKrvUFu8HdeJOiXiPK5i3fi8vBs1QmtxITfS8WYFSi5BYiF7jK1E4ed3+qBERLKzdQDxzkqiqQ7BkrCeo8UxvhzPL/AYCfm+aLOJDdWC2drFqKMm28W8Cpi88PtHYQg9VfYDuJB7rTT8Avax4EH6agjH8bJ1R3OvpUDfL7ZelG2fLgqBTl6D/b4z1q8QjdbkmN9d1C5U+IDGAXQ5aSzlH7r2xvbnkV4GNzhi8PwmH34fK7FIN3sfvwXNSPTbjlovtilU8ZpiMVqx4DO2ckf2hV3UzVUwtrlWUVGSNSb1uxnMlu3KqjNOzfFrI65laCtNIUtqzO6/9t4Nn4YouPWboa6B6sn58kTtYUfvL4Yu9TpTTs3U0kERiJHu5b+5ACZaUxiTqHOPXhykivqzVaRmdWJC1tRXljmbPtIQnCYwRJs+uGWLIiDqq39kIrm7sM/ecVS2dKEdY2nKLi9C26ULrvYzPf2lJLgKQrUwK4z0coV1p5fUoNlucRUlLy51wjiWG1TMMTDZRKJsvYrFS8+wOBxFxN9FdGtKrs9LpdcFOpqFNYzYtX1bUAF5gLRG3BWw/RZJWmCMlJcO20NsWVDf4L4z8rEiMMw/uKmFEp+I3guzc5yjzTKVI0wBaSX2ppyTLYxg3YxM9QKRAZU1HGwtarojLS0FCqHTh/9ZkFmv5MZVEE+eDOHg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA3PR12MB598757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(7416014)(1800799024)(23010399003)(6133799003)(22082099003)(18002099003)(56012099006)(261021123027099003)(921020)(261021121427099003)(261022105027099003)(261009223027099003)(261026140227099003)(10067099003)(261028144727099003)(11063799006)(261102123227099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dU0zV2VsZ3RVcmZKd1JVdnNTV2R6TEVaZmdiOEhacjlQK09KYTVTRXZCUVo5?=
 =?utf-8?B?NjROYUhPQzJaYVg0eUJmZ1RZQUVzV2VuZFcxNnZGL2NpaXI3ZXNrdUpoVG9v?=
 =?utf-8?B?UFR0UnJuWmJ3VG81M201dGVPbzZZQnhUUEpNaFdjOEdqeW1GVlh5ZnFVY1NY?=
 =?utf-8?B?dzBaVTA0dzJOaUpQdjJLa1ZKMEkzaVIyMW9mNDZwaHRpN3kyRC93TkFwZzla?=
 =?utf-8?B?TGNYZ2l3dUVMNkFSMXlCNUtpM1VCWVUwc0xwN2tOVW5zMzI3dlJvckZPYTFN?=
 =?utf-8?B?dWNya2JNNHNDUEVGdE9JenhIRXpOdmF3MVY4ZFlQRFpQaEVJYWJoYllrdExv?=
 =?utf-8?B?K2ZxQlpQNTRyd2JXRHFzdE9mbWhRSHppeVBoS2dLbTk2Z1RjVkh6dDF6ZFN2?=
 =?utf-8?B?V2l4TlEwT3Vab3o2a1dWODhUY2dRU0tYR0lsYVh0NWw2eVVVZDl5ZHB3SG1R?=
 =?utf-8?B?YU9pQnFUK0d6V2x5MUN2OW5FSFVEdklTOGtGd1N0QURBWWErb3oyK2w3VkE3?=
 =?utf-8?B?Y1h5ZG9GaFd1VE45djRJUXVQR08yWjE2djdLODBjK010aVNqVXphVlozWGRu?=
 =?utf-8?B?TlF3Vno1VzRJSThUQ1RvcC9DYUdDMHBOTjFlYW5XSWFmK1lVYXBYZjVTc2pl?=
 =?utf-8?B?ZEdQS0JVTVBXclNoOU1Xb1BNOWVTRCtYS3ZZblhKWGRTSW0wdU1WRCtwd2FH?=
 =?utf-8?B?MzVlUmxydStaTkVLNmxHb2NGcWZqSjRZT2J5MEVFR01QRDZ6K05XN3Q2eTk0?=
 =?utf-8?B?NVBoZUtOUWdzMlFMVFk3M3FJYUtCaldlYm50ZzFVOFhYU2Z6MmExZ0dQOGRL?=
 =?utf-8?B?bnhoQlhTeHpLRkFHdGV4VG9Mb1RVNG04ZitMVjFOZnFwWDhRT25yVTlLL25E?=
 =?utf-8?B?RGoxd0R4Q2lqa1oxYVNHcmdIU3AwcVBlV1ZlL200TVpDN3dOSnlLVWUwMnZx?=
 =?utf-8?B?RThESzcxQVJHd0N5YU5VZkZGOUQ4Q0tUcEU1VllqVnV5aU9EUHB6WjMwaDdC?=
 =?utf-8?B?TjdTM3R3SFYycm9EQVZOOEQ0clJqcVlpdHJMazEwZUcrUzAzZUVzUHdMSjlh?=
 =?utf-8?B?VDA1YjNkdFd3S1ptOHpVRnBtYStOQ2pXOHRtTUw4ZE81d0ZyRFNTZnNmeDQz?=
 =?utf-8?B?RDVqM1d6djR5TW5oeEttWWh6Ynd5VE1PU0wxL01QTnFYa3EzZGxCRFdmdWhR?=
 =?utf-8?B?V0lMeVBJOE5kNXJLWnUwT0cyVi83Qjh4Z08wMmtKdkZhQ2dRU2RvVk9lUUR5?=
 =?utf-8?B?YytrMFZYcXZlVS9SL0hXZUlUNStqeE14OFdDM1VwQm5DSW5GYStDaUZsdUZq?=
 =?utf-8?B?KzgxL3lvRFQrMnhqZGl1QTBWSmpwRktrWWlUdjdENjJmSWFxOFFPRUNXeEpG?=
 =?utf-8?B?bXNBVG1VUWpodGpIcjhGbG5BeGtndmZwWk5CT2R4UnVGcGlmbm1BS052Vy9q?=
 =?utf-8?B?TEo3Z0ltWkx0TnAraWk2cGM3ejZGTFRxQzJiV25NdWVzcklrbW9UeHRPUlZw?=
 =?utf-8?B?SEdBdVU2Skk2b0QyUXNIZGp2aEE1Y1lURzFNNnJSQnJXSGpBemp5bFNIMWNo?=
 =?utf-8?B?U0JTQllCNG5Rc2EyTWdZSFFSNVE0RlhLcWRZYWNRaitDQ0dkZzhSelFqR3Ju?=
 =?utf-8?B?T3p0T2luSm1xb3gzNkpEaTdXOWQ2VlEvY0wyd0tHc1VmdmRHOG1WRFIzK0VX?=
 =?utf-8?B?UGhOanduKy81NWswZ2RqRlVtVUhYd2ZDMi9kYW1IRnRuRXdmNkRmUzYya3Za?=
 =?utf-8?B?aFlqay9aNmtid1c1UUlzRFY5ekprMDFTRm9vUjBXSWV2L2xvN09vVjlQK2g4?=
 =?utf-8?B?WXBKcG5malBkcnBvbm5PakpDaG53U3FBdW1qbzY2V05GVnBOY1EzSWZ6TmNy?=
 =?utf-8?B?Q1FTQjB6Q2pURnFrY1RaU1FKMVdJS1Q1a1pMQVplNU9CSzh6dTBMWVlUc0hy?=
 =?utf-8?B?V3B4Vk1vaFV3bjgvb1BlZGZiNUlNOUpheEYrRkk4a1NiRnJBOUtkTDV5azN5?=
 =?utf-8?B?K1pDc1VOak42TWRqT1FyRTdxRTAzVVo5R3ppcE90S3Nlb25QNUdTT05qN1p6?=
 =?utf-8?B?NVR1RU1paVEveGZlVURUUFB5OW1KMFpBeGNjekhRZFFUN3V5L0U1RlpYckRz?=
 =?utf-8?B?NWVpRElVdXQxZVMycnFJV0d1MmFXa05Rb0ZoQ0lwMGMyaVBDWmlvallYMXNm?=
 =?utf-8?B?LzMwTWJFVml5RkxkckJCWDFNWlBlZG9mM0FsUDJVd2VZSTJHZzB1QXpxOGtM?=
 =?utf-8?B?ZGY5dEd2TXlWb1owdFVnelFqcVhtazBrTUNSVFdjd3paREhJaXJ1UXFLWUI1?=
 =?utf-8?B?QmNtTEs4dXJpUm5tS2ZCN2g0UzZWNDk5aUs3d2lsdFg4enAzSHBnZz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 453a8022-80b6-478b-165b-08df3b080aa8
X-MS-Exchange-CrossTenant-AuthSource: SA3PR12MB598757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2026 06:43:03.5048
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ezGR/itplADQvr269lzJBMP6N7oHr0Ho9FqnBSwHg0bDhVwNqnQecbb8YhZd7HmLsuJ8yw01bKTwMroMCSvpyA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8932

From: Jason Gunthorpe <jgg@nvidia.com>

These importer helper functions should call dma_buf_sgt_dma_device() as
they are always working with SGTs.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Alistair Popple <apopple@nvidia.com>
---
 drivers/usb/gadget/function/f_fs.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/gadget/function/f_fs.c b/drivers/usb/gadget/function/f_fs.c
index 2f221d0a983f..1efadf2c0f73 100644
--- a/drivers/usb/gadget/function/f_fs.c
+++ b/drivers/usb/gadget/function/f_fs.c
@@ -16,6 +16,7 @@
 
 #include <linux/blkdev.h>
 #include <linux/dma-buf.h>
+#include <linux/dma-buf-mapping.h>
 #include <linux/dma-fence.h>
 #include <linux/dma-resv.h>
 #include <linux/pagemap.h>
@@ -1514,7 +1515,7 @@ ffs_dmabuf_find_attachment(struct ffs_epfile *epfile, struct dma_buf *dmabuf)
 	mutex_lock(&epfile->dmabufs_mutex);
 
 	list_for_each_entry(priv, &epfile->dmabufs, entry) {
-		if (priv->attach->dev == dev
+		if (dma_buf_sgt_dma_device(priv->attach) == dev
 		    && priv->attach->dmabuf == dmabuf) {
 			attach = priv->attach;
 			break;
@@ -1616,7 +1617,7 @@ static int ffs_dmabuf_detach(struct file *file, int fd)
 	mutex_lock(&epfile->dmabufs_mutex);
 
 	list_for_each_entry_safe(priv, tmp, &epfile->dmabufs, entry) {
-		if (priv->attach->dev == dev
+		if (dma_buf_sgt_dma_device(priv->attach) == dev
 		    && priv->attach->dmabuf == dmabuf) {
 			/* Cancel any pending transfer */
 			spin_lock_irq(&ffs->eps_lock);

-- 
2.54.0

