Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.195.68
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793860958;
	b=fplB4F2EDmnTg67M6UCmMdw5LXLWhE/fAXQFcMO9S3cAcDCLuk3UTAO5RDi1mmr5Z7qI
	 0Lnthfg20BPVavKL9/XOXKEOlfUrDkVz3sW2fDjb2YpYUuf9wbLzdphPZKYndernPuOLN
	 m6CDgx+R6jFrp57PC6H2NoextmGuJIm6dw2RbNumawMSnrUTnSNTwYxd27WD4pIxp/2Mp
	 j12/S3UteNcoX88KRl0thuQkN9SCkiprjp6vTn8oQsK6mAMjSnM/tjFK53U6naohk3iRW
	 8kGjqgJGRK6j+PEVOCAqQ8qlC3AGOImlnKti7qUlS2clvAXGyc/mir6UapIx1WgIRHw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793860958;
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
	bh=B0AGq8Mr8SXgQ9BiA9oyHFIFLj02KkSlsTZPJ2pehhs=;
	b=ndV8E+vop3S71gSZIHp51b0+NL7j3ndkTUhl7H8ZqL6A+pLNYc+ym9mLDbIlCml/UR2m
	 qd9loROoz+wpIMC5DwNa/zZiGAFqsuoAVYPdw6Wh/Zpru9EnLofM1BOTkCeuXpyKzSRn7
	 2c151X13rA3QQ1+SfP4ntK3BPj/pBV13h2fAQnMgK1zH0pcMoA8XDPBNTPlc3MFTCHxir
	 Oub4JYsT46/7I98MxcEDd04hx4KHATw4kGLLjqsRQ/0eghMlb32BwE1Mpv32zKOBMmAMO
	 1TUio8K1Q7wYHVM3yATwgfMAFWMInEejbziribe0nC1KLN4SR7VP+poJgwqYcdZUdew==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=t7dky2R1;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.195.68
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012068.outbound.protection.outlook.com [40.93.195.68])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68DB1606D801;
	Thu,  5 Nov 2026 06:42:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 68DB1606D801
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=t7dky2R1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ho06imP0MuHkwUJHoWhL48ctx++4itsVignQwbdVEEbgEOPpBuKcDPzapJY2i7INv5jmExXHRPU5KnFb5S8ieZk5dDaL7i2XbIpRIMjmi1U4a6rTLma3ph35xCfvkt1oFwURxZYLexCPQ6EqQI9Cm9zzNvkEH4Nl9QUfE7BppEO1QXQalJ00n2zRnyFeF8x/tflzVvuwkERhRMt6PEecxauvJU3x/P1rYFFQE73PI/he1Ct6fnPQGOQUAq3RJGXJ9515l/BvTYry2V1wXdDJaOVoKFLaxj9Exhg2psBS/7AiWqRi+77vkyflSUrgcaAjqOL1CQnjnJQo/QZbSt4Fow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B0AGq8Mr8SXgQ9BiA9oyHFIFLj02KkSlsTZPJ2pehhs=;
 b=jEsLf7YtucaSf+O5Du5FGd1JguDaQu5EbA2e0yGli/LNjII3Z6KrHkH6DlDTHzZWqMFbAHnO0euY7P1TLjnR/r797K9Xsw0RVV77vF379ACudeQb9V+NlPqSZekxnSMFeRox74QjnUM3Mjvvjj00ZrzswjFL/OJ5PJeB9S5dXhQlJDwfuaHmw5JSR6HHX5cPEPJ0300jaV7FAaF53E2sqXplRp/UEp3xd2sAr8fms7DH3Anlfw4op3ecQLq5m+6HmgvNlvNMuHtRaYwZdufg7phD/KEMj32G8niu5fdGtDBRZwWCfoMnxl4uSw42cQFZcBj5J3KkNssbCGiiLRa97Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B0AGq8Mr8SXgQ9BiA9oyHFIFLj02KkSlsTZPJ2pehhs=;
 b=t7dky2R132TwLod4u3cRqGjcoJtgMd/6HDkRSKs9TR7TvwmgfcpA7bqLYwZYqqYYsLUKnZs2supQtOrRySsG/bUKrNdZKWxjJPyXx94t6/U8OPRsmIeNGz51C/V5OYWshNae5men4SYNhHl4L5xWxdnvgsRS9CiLO/iy3smu1cgN1xUhARmqeGGFIv93Zi51Lfl+YIjay8cMVRqRNNk/as7Oq0dNZZJm8gaOxZJTNA+Dhs1VIfTkaX3lCNmxj1l7PqKnnXHwwUOF84/IpKtHLn1rgy4rYHrtEt7OGNnowf2LeBMBFITt883saazWsWt796d02/Qfty0r+w0PNNIqWw==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SA3PR12MB598757.namprd12.prod.outlook.com
 (2603:10b6:806:52d::14) by IA0PR12MB8932.namprd12.prod.outlook.com
 (2603:10b6:208:492::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.9; Thu, 5 Nov 2026
 06:42:33 +0000
Received: from SA3PR12MB598757.namprd12.prod.outlook.com
 ([fe80::e206:100:5946:a777]) by SA3PR12MB598757.namprd12.prod.outlook.com
 ([fe80::e206:100:5946:a777%5]) with mapi id 15.21.0592.009; Thu, 5 Nov 2026
 06:42:33 +0000
From: Alistair Popple <apopple@nvidia.com>
Date: Thu, 05 Nov 2026 17:40:49 +1100
Subject: [PATCH v2 14/23] drm/xe/dma-buf: Use the SGT mapping type
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261105-dma_mapping_type_v4-v2-14-78b8dc9ae80a@nvidia.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793860879; l=6238;
 i=apopple@nvidia.com; s=20261105; h=from:subject:message-id;
 bh=nRhxm5/PfBtoCQBkHq5Rj0+GHv2ryPf/STY8zjax0/I=;
 b=mkkqFKbggmEu2902Rj3iipFiuHs0CZMLrUBgrZbOI9KPhz/ZoMT9J5TkK5peeOQ4fkjo4ocQT
 2IKmDuPs3SBAOcLqXvaP82H7NI2XN5QRLU9dPg8D87jomoXkBqMoqLm
X-Developer-Key: i=apopple@nvidia.com; a=ed25519;
 pk=WdWPT9rAq3YNfXldbGv1NSGVLGxzQGFGJvRUiShhNqs=
X-ClientProxiedBy: SY5PR01CA0005.ausprd01.prod.outlook.com
 (2603:10c6:10:1fa::13) To SA3PR12MB598757.namprd12.prod.outlook.com
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
X-MS-Office365-Filtering-Correlation-Id: a8d7eec0-d5e5-4303-1284-08df3b07f8f2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|7416014|1800799024|23010399003|22082099003|18002099003|56012099006|261021123027099003|921020|261021121427099003|261022075727099003|261022105027099003|261009223027099003|261026140227099003|261026121527099003|10067099003|261028144727099003|11063799006|261102123227099003|261102130727099003;
X-Microsoft-Antispam-Message-Info:
	KNoTf+5P8EZt6E8yYORdtc2TkbRoOYic8PckgQuoIT1j+embgoQq2tNdIQ4a2JHjsdnolkE/pp4OgZcBTI1UvuKnrQWXZre2RC8UpI2PWzRaRxWJa+yW3uUeNw7E4DeLH+ZeRAmT1+6oq1x7Vh1T3ySjWhVY0Z7WXjbFYWclTQPokg4EBi9z+C0Fwz6jiY68V5Tgr8JEteP/xd8ASRZmrPz3yQD7fxkMsDVtatIp3uW2E8tfV5sNigaNPxdL4JauRu1wKQ9CVDBCvRBHfbKBUml2I9CBFLx8IsS/e7um/S4TnmVOhZUMwlv7ePHxtvQcbxnR040zcqMkI5/plwH0QWOrf25WxONWPFO5uONnWHNHGzIC6R3N9/7UG+d8Oo+UOssTk3KxDzbvLd+TQcXdHPaLoRuphcb93uWYRaXjbCgW/oy1+NaNcgE5nt3vifUE48ihRwaoZeYubEXIapXIQ90XbQtensMd2Izqt74AdGfk8a/9w0nGlWWUwuGQOGFV11coL0E7tuUoPL0bSu6VT1DMy4B7cfw30V7HD6qPPCerLWuqrqFWfRc02tJttXLvPZUvNGCV1qwjqNqWWZ3c/vx95zllFInnJHlMo6qmDo7Au702TOGMHO7t2r9+oZDkT8aZvqQyL5PgMT9m0Ih6FNDS4vOgQo0Z2tyV7uguPmPcqSGbVf/HImo3TLWWpIQyGdqGn88x3ChBSvIryhuHHw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA3PR12MB598757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(7416014)(1800799024)(23010399003)(22082099003)(18002099003)(56012099006)(261021123027099003)(921020)(261021121427099003)(261022075727099003)(261022105027099003)(261009223027099003)(261026140227099003)(261026121527099003)(10067099003)(261028144727099003)(11063799006)(261102123227099003)(261102130727099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?blVtNWZuV0R5d0wzdXZ4U29veUVXVEhpbUs5dlFTeWcvbHo2S09vSS9UNGhu?=
 =?utf-8?B?M0cwL3hWRGJQMWVYUng4WlNGemlYbVNMVGMxZmhJV3BIZHBCQ09KbXg5QUdy?=
 =?utf-8?B?RHRVY0Qwc2JWSXRRbCthdGMzc2kxSy9zUWRqM1RwU2hlbDZSbXA0dHk4T285?=
 =?utf-8?B?UVBiNTBWTWR6elVVTFpsZnp3MUUzQnV6WHF3RzRvMkZEeURsdlhPR3NoL3lH?=
 =?utf-8?B?aDVRSDNwS2g0SGNieXhDY1hBNXdLQWd3UUZXZ01aRFptQWRQd0d2Njc4aG8v?=
 =?utf-8?B?NktKZ0dMbnBUQXdQWEROWWk3bWxZdUFlZER5cFJKWDBoYytqVmhLOEZOVXJ0?=
 =?utf-8?B?U2JDanM0dTdleE9KSmMzTlBYOXk5LytjWjNOQUNKY2NPaWxIem1PRnRoNkhI?=
 =?utf-8?B?eWVvM3grM1RBQ0ttbjVJY0lPeTNxV1ovYnVSSXhaMW9VK0FEL050MXJvQTJw?=
 =?utf-8?B?elM1d2cvaEo5K2xDY0sxN2VNOFIwVTZVVFdUMTdpNTRBbnlZdkVlVHZrREZ4?=
 =?utf-8?B?d3JwQ201alJhaHdxV1ZmVjhsSEVwQUthQ0Y1YVFWQ3RkdXVVNVlXcWxvRXMr?=
 =?utf-8?B?Zm5aTDl3a0h3MlZOZ2k1SHZ6YUx3NjlMWjJPejh2K2NjYjRWRXJ2ZGkzc1Y4?=
 =?utf-8?B?cGROMG1kL2FJL2pKdjRxVUpxalh4N1YxK3E2ek5yeG1WWUVHbXJiTVNnZUpY?=
 =?utf-8?B?ZFJjc01aMStpSFVkQlovc2ZuMXNjd29XUE5WaEQ3cEo4ZTFqaDBkbEZYbTF6?=
 =?utf-8?B?SE9HS2FYVDJKQXN3MlE5YzhWWUl1TkNWVllEN1FlQ3F6WXBrL21mcXhoeFdH?=
 =?utf-8?B?TTNKNVgxN0Y2TlgycEtSNG45aXVWOUx4SS9XUEE2K1hxNVZkZ0d6SHJpRk1H?=
 =?utf-8?B?Vy9xNmpsRWUrNU9IaW14MXorT3JETkVlUXliVFNNVFFSM2RBbnJzeEFZRU9h?=
 =?utf-8?B?dU42QXVoZHZxRFJ6ZjErNnZpeE1nMFRVNlphVEJWUGtqNVd5UU44QXJESHpq?=
 =?utf-8?B?TnRURFJNOHNKdmg2MGtrc0ZVYU1wRzBzRmtoUHRoaWdKbW5YWFdvaXNJdE4v?=
 =?utf-8?B?OWlJeFpqS3ZhSWJHQ1E2Mm5TeUNleFdvVGlVdUZiU2pCaW10ZVJDdnNkaXhq?=
 =?utf-8?B?QWFlaEpVN2wzTWU5RVF6b3BZaW5zQWo3Rk85RURKMStEMGRJcXI2VVp3Q0U4?=
 =?utf-8?B?WjJvcWtKZHJLUlNPYVRNV0h6SHJCK0QvMG9MWFlteEQ3cXg3aDdrRW9VYjd5?=
 =?utf-8?B?cVFpUkwvRWJ0bTlHZHZxQU83UlBNRFdUQ3ZXSkhXVk8yRk1LUUZWMldHT0lV?=
 =?utf-8?B?NExvZGh0dGlXZU5pbjRheW14M3MrSVZpcytGTlBqWnV0QVlOMFFhT3hRMWNW?=
 =?utf-8?B?VDBzcGN4YWdVWjZhTTlkb1cwVXVFK3ZyUHVIcTRGUEk3ekdkMEJXWGdNU0Zn?=
 =?utf-8?B?T0pvdkFLdnEwQno1RDREWDJrWGRadWJ5SmFSaFZMWG04S3hzR042dUZKbEFZ?=
 =?utf-8?B?MXlHSFJsMXpFZENDeDdqSGV6K3VmRVAwZzVIbXdRVWlnalE2SFFoSk1DTWYy?=
 =?utf-8?B?TDhEVitIS3lSYVI3aUdBK1RvVzNiVy8wajM0bmZqSkJ6TGNsZkEyenpVY2Fi?=
 =?utf-8?B?dm1BQ081OEZYdlJkL2NXRzRMQmJVK2pjWVBqVEdNMkFCNGJ4cElXd2IxYmsy?=
 =?utf-8?B?elpwUlRFRDc1RU83TWtRNEFyVVVlK1RWcHFvdDE4bnRUNzFiSGNTMVZnNXEw?=
 =?utf-8?B?VG9JdnVuNXJQc0NySGw0Y29xajB1SWxLOHhsN3RqcWRuS1pGVTgwRXIvWVFp?=
 =?utf-8?B?ZDRUQnNaRkpGWCt2T1lDc2Y1bWpkVm1qNkpNQm1zNkV6cURJWTJHL2VWazNG?=
 =?utf-8?B?OFhGZGNvOGducTVQZEdwRzRCc2FCOTBIcDhJZlpreVdZaVE2WGlieEduMzJv?=
 =?utf-8?B?MVplTkFyTm4yUExvcXRDWTg0aXlzTVNhK2J1dW0vWDh3R0EwTlN4aSt2QVVV?=
 =?utf-8?B?UjlCTk5OZE8zQ2FNd3lyL2RBK1lBN1QwRWIyM1ZhalE1RWtEM3ZVbS9aUWky?=
 =?utf-8?B?NHdmRmFiYlVNTFBFTG1qV3c0REg5WWZyWUNjeDR1NFkzaGRQMVl1UkNEOG5S?=
 =?utf-8?B?U3IzUzB6QnVVZktLb090RW5vNzV1K2hCMEk1dU1rYnpZWk0zdURLMUJZWVJY?=
 =?utf-8?B?NjF4azE0M3gvd3ZVRVNwUW1iTklOejRZSmxoNi9MSjJrbmZtNTMyb1N6U0k0?=
 =?utf-8?B?VUpKeElBM2d0MVN2eDZNRGRmbjcrTUVQRVM0Ynk5aEwvWCtBRGhYR2g2RG1W?=
 =?utf-8?B?M2syV3N2QU1aS1ZHWEZrbi82dGhDNE5zTUZYVVlRcnZIbHE3RzMyZz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a8d7eec0-d5e5-4303-1284-08df3b07f8f2
X-MS-Exchange-CrossTenant-AuthSource: SA3PR12MB598757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2026 06:42:33.7896
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +bKCiujCojVulTX818uN8p7s8FyYZbr+V9Ot3MfkECWchFo+F9vLZfN2xKtHBifJbcMJe50Z6s+0SW7WpW8YGw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8932

From: Jason Gunthorpe <jgg@nvidia.com>

Like habana, xe wants to check pci_p2pdma_distance(), but unlike
habana, it can migrate to system memory and support non-p2p DMAs as well.

Add two exporter SGT mapping types, one that matches P2P and one that
matches all of the non-p2p. The pin and map code will force migrate if
the non-p2p one is matched.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Alistair Popple <apopple@nvidia.com>
---
 drivers/gpu/drm/xe/xe_dma_buf.c | 79 +++++++++++++++++++++--------------------
 1 file changed, 41 insertions(+), 38 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_dma_buf.c b/drivers/gpu/drm/xe/xe_dma_buf.c
index 6a85b292dee7..f9bdfe7ee2c7 100644
--- a/drivers/gpu/drm/xe/xe_dma_buf.c
+++ b/drivers/gpu/drm/xe/xe_dma_buf.c
@@ -7,8 +7,7 @@
 
 #include <kunit/test.h>
 #include <linux/dma-buf.h>
-#include <linux/dynamic_debug.h>
-#include <linux/pci-p2pdma.h>
+#include <linux/dma-buf-mapping.h>
 
 #include <drm/drm_device.h>
 #include <drm/drm_prime.h>
@@ -23,33 +22,10 @@
 
 MODULE_IMPORT_NS("DMA_BUF");
 
-#if defined(CONFIG_DYNAMIC_DEBUG) || \
-	(defined(CONFIG_DYNAMIC_DEBUG_CORE) && defined(DYNAMIC_DEBUG_MODULE))
-static void xe_ddebug_flip_bool(const struct _ddebug *desc, bool *flag)
-{
-	*flag = true;
-}
-
-#define xe_dma_buf_p2p_debug_flip(flag) \
-	_dynamic_func_call("xe dma-buf p2p debug", xe_ddebug_flip_bool, flag)
-#else
-#define xe_dma_buf_p2p_debug_flip(flag) do { } while (0)
-#endif
-
 static int xe_dma_buf_attach(struct dma_buf *dmabuf,
 			     struct dma_buf_attachment *attach)
 {
 	struct drm_gem_object *obj = attach->dmabuf->priv;
-	bool verbose_p2p_dist = drm_debug_enabled(DRM_UT_DRIVER);
-
-	xe_dma_buf_p2p_debug_flip(&verbose_p2p_dist);
-
-	if (attach->peer2peer &&
-	    pci_p2pdma_distance(to_pci_dev(obj->dev->dev), attach->dev, verbose_p2p_dist) < 0)
-		attach->peer2peer = false;
-
-	if (!attach->peer2peer && !xe_bo_can_migrate(gem_to_xe_bo(obj), XE_PL_TT))
-		return -EOPNOTSUPP;
 
 	xe_pm_runtime_get(to_xe_device(obj->dev));
 	return 0;
@@ -70,13 +46,16 @@ static int xe_dma_buf_pin(struct dma_buf_attachment *attach)
 	struct xe_bo *bo = gem_to_xe_bo(obj);
 	struct xe_device *xe = xe_bo_device(bo);
 	struct drm_exec *exec = XE_VALIDATION_UNSUPPORTED;
-	bool allow_vram = true;
+	bool allow_vram = dma_buf_sgt_p2p_allowed(attach);
 	int ret;
 
-	list_for_each_entry(attach, &dmabuf->attachments, node) {
-		if (!attach->peer2peer) {
-			allow_vram = false;
-			break;
+	if (allow_vram) {
+		/* Other attachments may be unmapped: ask what they accept */
+		list_for_each_entry(attach, &dmabuf->attachments, node) {
+			if (!dma_buf_attach_accepts_sgt_p2p(attach)) {
+				allow_vram = false;
+				break;
+			}
 		}
 	}
 
@@ -114,6 +93,8 @@ static void xe_dma_buf_unpin(struct dma_buf_attachment *attach)
 static struct sg_table *xe_dma_buf_map(struct dma_buf_attachment *attach,
 				       enum dma_data_direction dir)
 {
+	struct device *dma_dev = dma_buf_sgt_dma_device(attach);
+	bool peer2peer = dma_buf_sgt_p2p_allowed(attach);
 	struct dma_buf *dma_buf = attach->dmabuf;
 	struct drm_gem_object *obj = dma_buf->priv;
 	struct xe_bo *bo = gem_to_xe_bo(obj);
@@ -124,11 +105,11 @@ static struct sg_table *xe_dma_buf_map(struct dma_buf_attachment *attach,
 	if (xe_bo_is_purged(bo))
 		return ERR_PTR(-ENOENT);
 
-	if (!attach->peer2peer && !xe_bo_can_migrate(bo, XE_PL_TT))
+	if (!peer2peer && !xe_bo_can_migrate(bo, XE_PL_TT))
 		return ERR_PTR(-EOPNOTSUPP);
 
 	if (!xe_bo_is_pinned(bo)) {
-		if (!attach->peer2peer)
+		if (!peer2peer)
 			r = xe_bo_migrate(bo, XE_PL_TT, NULL, exec);
 		else
 			r = xe_bo_validate(bo, NULL, false, exec);
@@ -144,7 +125,7 @@ static struct sg_table *xe_dma_buf_map(struct dma_buf_attachment *attach,
 		if (IS_ERR(sgt))
 			return sgt;
 
-		if (dma_map_sgtable(attach->dev, sgt, dir,
+		if (dma_map_sgtable(dma_dev, sgt, dir,
 				    DMA_ATTR_SKIP_CPU_SYNC))
 			goto error_free;
 		break;
@@ -153,7 +134,7 @@ static struct sg_table *xe_dma_buf_map(struct dma_buf_attachment *attach,
 	case XE_PL_VRAM1:
 		r = xe_ttm_vram_mgr_alloc_sgt(xe_bo_device(bo),
 					      bo->ttm.resource, 0,
-					      bo->ttm.base.size, attach->dev,
+					      bo->ttm.base.size, dma_dev,
 					      dir, &sgt);
 		if (r)
 			return ERR_PTR(r);
@@ -174,12 +155,14 @@ static void xe_dma_buf_unmap(struct dma_buf_attachment *attach,
 			     struct sg_table *sgt,
 			     enum dma_data_direction dir)
 {
+	struct device *dma_dev = dma_buf_sgt_dma_device(attach);
+
 	if (sg_page(sgt->sgl)) {
-		dma_unmap_sgtable(attach->dev, sgt, dir, 0);
+		dma_unmap_sgtable(dma_dev, sgt, dir, 0);
 		sg_free_table(sgt);
 		kfree(sgt);
 	} else {
-		xe_ttm_vram_mgr_free_sgt(attach->dev, dir, sgt);
+		xe_ttm_vram_mgr_free_sgt(dma_dev, dir, sgt);
 	}
 }
 
@@ -225,18 +208,38 @@ static void xe_dma_buf_release(struct dma_buf *dmabuf)
 	drm_gem_dmabuf_release(dmabuf);
 }
 
+static const struct dma_buf_mapping_sgt_exp_ops xe_dma_buf_sgt_ops = {
+	.map_dma_buf = xe_dma_buf_map,
+	.unmap_dma_buf = xe_dma_buf_unmap,
+};
+
+static int xe_dma_buf_match_mapping(struct dma_buf_match_args *args)
+{
+	struct drm_gem_object *obj = args->dmabuf->priv;
+	struct dma_buf_mapping_match sgt_match[2];
+	unsigned int num_match = 0;
+
+	sgt_match[num_match++] = DMA_BUF_EMAPPING_SGT_P2P(
+		&xe_dma_buf_sgt_ops, to_pci_dev(obj->dev->dev));
+
+	if (xe_bo_can_migrate(gem_to_xe_bo(obj), XE_PL_TT))
+		sgt_match[num_match++] =
+			DMA_BUF_EMAPPING_SGT(&xe_dma_buf_sgt_ops);
+
+	return dma_buf_match_mapping(args, sgt_match, num_match);
+}
+
 static const struct dma_buf_ops xe_dmabuf_ops = {
 	.attach = xe_dma_buf_attach,
 	.detach = xe_dma_buf_detach,
 	.pin = xe_dma_buf_pin,
 	.unpin = xe_dma_buf_unpin,
-	.map_dma_buf = xe_dma_buf_map,
-	.unmap_dma_buf = xe_dma_buf_unmap,
 	.release = xe_dma_buf_release,
 	.begin_cpu_access = xe_dma_buf_begin_cpu_access,
 	.mmap = drm_gem_dmabuf_mmap,
 	.vmap = drm_gem_dmabuf_vmap,
 	.vunmap = drm_gem_dmabuf_vunmap,
+	.match_mapping = xe_dma_buf_match_mapping,
 };
 
 struct dma_buf *xe_gem_prime_export(struct drm_gem_object *obj, int flags)

-- 
2.54.0

