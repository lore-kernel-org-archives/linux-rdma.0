Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.43.55
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795154288;
	b=o/T0ZlKNfqDmp+knMSJIqG9kJJdk7er2BqxRIY2ec5c6ADDNkAYVzjZhu8d+0xsLvP9B
	 BXb0vyvCQco3IqeD+gLiOzKUnAbkQnuQEgz0MtPC0KeEgHVVXNCR081LzXeX/O+nk8vRX
	 R6rhyWmhYKzStmnXAdg6H/MLBd9IpJ2WiBZlnAjyCN33sjAclvLXU4gVLa+WN6hasDl0e
	 4/o1Y0OdteBf8JVpI0cw9XHhNW6i6qJI4nx57O+6BxNVsFiqekFhI13e7r4nlYmRig7lE
	 gt0hfYNJvs4xuTM0CO10N1LGgfpkHJkp67pC11Zrtp05Lc7x9mHwrY0bAu6mmlyKegQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795154288;
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
	bh=8GTdNPmSGRqkufcgG3RA/KpcwHiqDFcK2OrE1+6yC4M=;
	b=lmRyT2j4pAQFwow+K+gALZQFpC2Rx9bIkBBLf5M0wu2MUTCl7aJx/LyRQzndA6mPXDvH
	 dd4BV8EqxF9El0yRM0Dy2VbGE3Yg10ljfCq2TXVAvoIhkxnSUE55RWYbSz/CpnE/oGf5P
	 4wERsKoXiKzcDZuGQdoBelzthc8VpBADUN7R6xg1Swr948NDb/HLWVBG0UbtFmgGKuKnO
	 idEaMNJ4nNrCksKEn5qW7M354h2PAD6sNCYr5Mcf6tsqvrrIPQm7PJs8LRHEh4WClnz5s
	 eVhdttkQVhXM+7qCIpQa2e0wLa9fqvZz5yauRUzwsQ4/SdhcAgraC6C+GnkodI6D4cQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=IKZFgVXU;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.43.55
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012055.outbound.protection.outlook.com [52.101.43.55])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22753606A339;
	Fri, 20 Nov 2026 05:58:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 22753606A339
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=IKZFgVXU
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aDKexHRzbL7ZNEbicSQ0QZq9PsAsdk1CuE1y3sekaRcn5vi99d1IS8LxXYNxKBQXvWnBKZOMNc4LMHj+s658sGjJ0Ijh+lq81ml/NuheNZQodLGZIt3pqBul1anVuhkWUt7IHSVBotPkJWQtVXF/VtEOBHjZMuIoQisQf3ptNDcMkJi73yFcgpS19ZPq5AhHkKYZmVRwEXohPRSbi0ANyXmvJhUyxZx0UgXD+eHn3SAC0PE3Nrq5vUuA+ex2e2eS/sZje9AwmsLSn7fVE4Cq0xZdeVc3Aq62AwIDwzfQg6Gs+5hZj/Y2kyzK4bSQlnBojNfDFdhLrmO0ZHgoE1R7eA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8GTdNPmSGRqkufcgG3RA/KpcwHiqDFcK2OrE1+6yC4M=;
 b=q6nCfn+RE4gC0VsMODjNI7EnvvjOwdiVuW4Yp7OsS86KdOZRIJSLWjlnQt8ddiZoh/dIqJMWWg0GJk0j2le/HtAldcoaXaR9/UelvjfUvpxZfcDwmWzWafuirQ+6xe5WbGFSs9pN7SBCuOh/yD7QXltleFJAbAj+H5R1at9DYsyWN59b8OMCLHqhs+6MN+h/0i9FwSHaZm1atMerTMB0eF38bh7mpCudDwlNxF+TlJFNxBwNtaKthhW5KsCS/OYhMuYUM6XI8fuugRfmvYbN47FUwMKFvKTQYxn++9JSjtxC5s5A/6+7BM6t8JcFtaKxMnART2Kv4N73iiMgg48htg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8GTdNPmSGRqkufcgG3RA/KpcwHiqDFcK2OrE1+6yC4M=;
 b=IKZFgVXUCCKzjqmn3o4bvK6vzBpn5xmzKHivmxOYrfZQrMWLM05M13qQmnVSKhgTr75xOQPK/AmVp0J/JdAhGL6uZTkfj/hJX20feXzfy/WYwzw2+KdXbGPzOm/UewDLtFIOUgORkIx9dOyhS7n13niR8nWko8uuTn/IYdL3sPEMuXaXDXk3opwFr2NOEQX43Bo6+MjxOdsuWpy7210fmRmcRFCfZ/YDZYGbExQVjMF6t2vYgdirR6uw0glXwMrRtMfCrYr7yfXOlKX0tOmBHpCbY9q0ve+Kw0fW81WJxR7SbS6JRFSOGTs7yyP/OcPkCu3u7i42d98GY7bMTszgEg==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SA3PR12MB598757.namprd12.prod.outlook.com
 (2603:10b6:806:52d::14) by PH7PR12MB6717.namprd12.prod.outlook.com
 (2603:10b6:510:1b0::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Fri, 20 Nov
 2026 05:58:03 +0000
Received: from SA3PR12MB598757.namprd12.prod.outlook.com
 ([fe80::e206:100:5946:a777]) by SA3PR12MB598757.namprd12.prod.outlook.com
 ([fe80::e206:100:5946:a777%5]) with mapi id 15.21.0639.011; Fri, 20 Nov 2026
 05:58:03 +0000
From: Alistair Popple <apopple@nvidia.com>
Date: Fri, 20 Nov 2026 16:55:56 +1100
Subject: [PATCH v3 18/24] iio: buffer: convert to use the SGT mapping type
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261120-dma_mapping_type_v4-v3-18-c0183a409bdf@nvidia.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795154186; l=1891;
 i=apopple@nvidia.com; s=20261105; h=from:subject:message-id;
 bh=LE7YFP1ARjpZf3SmEkIIrOo2zY3aq4eZTVUr3LoUroI=;
 b=NToYkHf++8uhop0pWfWzjTjtTqg8ze8H7RxKX3bpi/q6uVaI0pBF58Ke+dGeQwrGx6GuqS9HV
 weS841ehfZUBvMCGjyVRPwmgpM/2u5rpvF0ha1nRi5gOraDInXwQAAp
X-Developer-Key: i=apopple@nvidia.com; a=ed25519;
 pk=WdWPT9rAq3YNfXldbGv1NSGVLGxzQGFGJvRUiShhNqs=
X-ClientProxiedBy: SY5PR01CA0102.ausprd01.prod.outlook.com
 (2603:10c6:10:207::10) To SA3PR12MB598757.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA3PR12MB598757:EE_|PH7PR12MB6717:EE_
X-MS-Office365-Filtering-Correlation-Id: 1f70587f-9ed5-4890-9347-08df46cb3d76
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|7416014|23010399003|366016|921020|261102123227099003|261021121427099003|10067099003|11063799006|261021123027099003|261102130727099003|261026121527099003|56012099006|261026140227099003|261022075727099003|261028144727099003|261022105027099003|261009223027099003|22082099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	aHY7e5uwC+6J5ZldXwZCzTmUUASUt9ZiOuVPl1xFJuuUcTe/Bt9Aqmn3ZCg2zXvKyllHibWXslqLJ3b5l3YHIYsq4ln3SWZ4SnuTNuIxmilbkFdo9Oarg9DEUgRTXjJL/EFapF3KIAzCplNZ+H/jBc+C5Cw98o5nCM5ADwMRofbIFTfB6yw7A3sBIRw5OMjmfuJ7zWCcR2oxGMvCRhd3SyXwHwnAo8LPvFy/AeaSSq/ND0gxiF1M8Q0tTGIgauDXpO9K9PSLWZDBMUiT629w361Ld1DSP+Jw2EgiSuzSP0WiWGTE7dtGMdObjIVGX6zXdLD5neG2nx6YWX+kyOkKTUBTLhsL6KetBv3OqHGVEOv/0qi8bIIQUmU0uGGU/RXsUzQls1M3fXIFttzXR2uqsXLRS8JRvu2MftKMu3T/S2Fi1R9IB9SRV6YXglGxoL6VaQktFA7wT+AYpq1L9ANcHyKdCp+oA6L8VhvaADt+EwrmsJRdFNiCuf8JwDw/OG5Vum48nIJXMy3qTSCmFQeK9tFkqi9uR1ieel2q8x0QipzuMXD7Df0GLz+KN0sKsFAZYILJRMH9yqZBJbg32shNJdrNDvFKqVgzHq5SXpXP43sWA1ggHTuyMvMEgvJ1Q2kETnrwD7osmuA4aL3D4WdFBnMGePyLEzNDMgKdtVs7uDpQ9nQ0tMBXlTlhejPX6fE6doIr248qus3c3y4mdis3vA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA3PR12MB598757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(23010399003)(366016)(921020)(261102123227099003)(261021121427099003)(10067099003)(11063799006)(261021123027099003)(261102130727099003)(261026121527099003)(56012099006)(261026140227099003)(261022075727099003)(261028144727099003)(261022105027099003)(261009223027099003)(22082099003)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?S0llZUdFcnFvSmhyNDV1dVZnenhXdy9ZUW9IbTVocFBhM3RvUlFiRTFuRVpw?=
 =?utf-8?B?T004cVVoN0QxdjlLdmVoWkRPOFQ0c0JJUEhnSVRHc3dGWm9sT1RNZUg0b2xN?=
 =?utf-8?B?STlybEMwb2xJTFVpQWp0QUM4bUNpNkdZaElvTXhrMG9UUlpqZ1l3UWxtdS9E?=
 =?utf-8?B?bDlla2NIZ0g5RnJLQVZIeUtpN1p6b1BmUUFvN1l0VWFQRElGR2tEUVpEV1pM?=
 =?utf-8?B?YzI3SzJTVXpzSzJObUFuemcxZHY5c29DUGxINDVXVmhhTVFjT05KR3hHRkIy?=
 =?utf-8?B?ZW1WRmxvTFZSWTZoS25jZWZUUnhjUEJZRjlBV3pjOXZ6R0hnaEdWR096K1pq?=
 =?utf-8?B?T242cVZPd29xVy9ncFhHUWlnaTRMTkcxcVVZajBXOENIVDkvZUxDbm5ZemJa?=
 =?utf-8?B?Tno5c2g3VDkxOXgzRUo3N2k1V05uc1RKWm10TGxiWkM5aDk0NHQzTFVFWk95?=
 =?utf-8?B?cG5wbGNqamlSRkExanJxSE0wck5UZ1ZEMXF0R1BjMFVqVDhaSUFTZmJIMWx2?=
 =?utf-8?B?bnBMRVFGWXdCSldwYVZUb2p6bnhaTDZoNjlQNlFrbzN5dXNxR1JTNEFuYkRO?=
 =?utf-8?B?L3RVTjJSVEs3Q2dSSTlNc2tUT1ZzRGRQSVVpZTRIVjdvNkxERzRKQW1iVUJz?=
 =?utf-8?B?ZUZjTTQ3Tnk3NGlkUmk5YitNdGRFcFBWOVdCMjFsTVdZWHQzWGl0dHB2SDNn?=
 =?utf-8?B?cTlOZXVWSlNlTlNjMGdoZGxhdWwycXJXaFFwOGtKL2ltWHdzV0JhUU4zeVVs?=
 =?utf-8?B?TTl5WE9tTkxab0ZqRlVSYnBvNyt2dVAzZndTdERleEI3L0JzRTlxZjQrNDEz?=
 =?utf-8?B?cW5kU1p1OVRiWVo2S040OHF6OXNRZ2VkRlI5Q2hxQ0FhYndQdUwwVnFaaTAy?=
 =?utf-8?B?WWlPK1NCTTNTYm53ckt1VUdGTG1mb2JjWUtiSm0rWEJ4NklVUUptaU0zRHVX?=
 =?utf-8?B?bncwL3p5U1VGM0E4QVR6ZmJJY0tQcGp0SjNKM2J4c3lubDVlQTVQNzBsMk05?=
 =?utf-8?B?Wnhxb0toVDZRS0dDK0IycjY5TkJVOVZzVnBnZVF6R3J6bUNnT28yaVpMRW9W?=
 =?utf-8?B?VExhN1BnamhzeDUwOTZJWGF3WmUvanJkSTlSUTkyQloyejFobW1RMkx6MzJn?=
 =?utf-8?B?RUUwcHRONTZWQTFZamlTOUVrbkNVTFpSNEk5S2ZXM2xsWnAvSTM4VUJwVGxL?=
 =?utf-8?B?NWgvV3ZZRzRmS0tRaUVJbnlSVlhiTTNTOUFDRUZkSitKaE1ZdWRLeDVPU29l?=
 =?utf-8?B?NmttSDhFYnNMTjZ6TlRVMjFKMjVHbDZzNVJkRWZqaXNtcHZLdnZPZDN0VCta?=
 =?utf-8?B?UzMzT2pmYzNlWXpKeVN1T0gwa2tDSGl3L1dHSkg3TE5sTWw5ZWk5MWpVS0VT?=
 =?utf-8?B?dFY0SDZaSkszZlpQVEsyN3JLamtYRjVzaDYvcllEZ2xuOUdlNXJXTGxQWkM3?=
 =?utf-8?B?azhleExPdmcwUUtkanlDcTV1R1RHZG5BZlVpVzF2NUUyMzJlQ25vKzExcFZx?=
 =?utf-8?B?S1hKMmFrL0U4NUYvbUtvNGp6eWMreW9KaHNCZWFrSEN1VmhTTSt0NkQxbG1O?=
 =?utf-8?B?Vm1UZEJwVEFBSCtqYXR2LzBXbFJCUzhCSmIxRVAwR3lxL3hzY2dnd0ZWSXdt?=
 =?utf-8?B?My84bVY3QzZIZ0lVaGJvN2F3OWxmcU5JMmtxYmYveGNHZjZZelpPeG5NWkZW?=
 =?utf-8?B?UGttM0ptUmlzRzBWZmM4Nm5KcmxoT2tVdjc2WmhmZjZhbE1CeHliK25Dbzla?=
 =?utf-8?B?a29Ba0d4bmdaM2RXTEVsN0lyNkdYWVNjWHRhTFJuLzN3NG04UHdPMFUrQlUz?=
 =?utf-8?B?WEFoT3Y5am15VlBDN0ZiRkFDVlMvU2hvYVQvMkUzM3RJSVhpZkxnUmIrN3RO?=
 =?utf-8?B?am1RL2g0a0ZxZUVycGF5bG1JdVllMTlOM1Nha2xSY2JPRWpjRFB3eXNuRlY3?=
 =?utf-8?B?VDZWU3JaMDVqalBpNUNET0p2SjJUdEovVXgrWWtQYVdRNkROWmpmUy96QSta?=
 =?utf-8?B?VE9uSkNVdkdNRk5uU1J3TVNrMmE1VXBJY1NsSUxOZXVjSkZMazdsZzdVUlZs?=
 =?utf-8?B?S0NrZ3JYM3kxVlJ4RHM1TGdoSlRxS3grc3k1cHYzdHROYUZJWlZHTlZiN2xj?=
 =?utf-8?B?eko4Zk5qYm13N3Q0SjVmdTlGZ2xmRHhjUk1Wcmo0OE4rV3Bsak1LZTY2emo2?=
 =?utf-8?B?S1JxRmw4RzAxenZlWmtGRDBaWXFHa1NHZnoyaDR0MXM5cks3bUphZTRGeS9y?=
 =?utf-8?B?TTBpYVIwT3RGcjdvZUo0NUNQYTI1eENvL0hNT1VkWFV6cUhQNGROZnlmazkr?=
 =?utf-8?B?eGtobjk4OUpBczZ5UTBDZ0tTd0tER0p1czBQRSs4TzlYSzR0azZ3QT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f70587f-9ed5-4890-9347-08df46cb3d76
X-MS-Exchange-CrossTenant-AuthSource: SA3PR12MB598757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2026 05:58:03.7976
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DH3PAm5GxSjjKBnxbu+FUuhy+AtzT223zxAUKV+OTR6+TsJO6MiWOFlhlNrPjCozyDtP0rzVTBZoYxHFaeJ9Pw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6717

From: Jason Gunthorpe <jgg@nvidia.com>

These importer helper functions should call dma_buf_sgt_dma_device() as
they are always working with SGTs.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Alistair Popple <apopple@nvidia.com>
---
 drivers/iio/industrialio-buffer.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/iio/industrialio-buffer.c b/drivers/iio/industrialio-buffer.c
index 4a1063e4891f..f907fb6ca936 100644
--- a/drivers/iio/industrialio-buffer.c
+++ b/drivers/iio/industrialio-buffer.c
@@ -16,6 +16,7 @@
 #include <linux/export.h>
 #include <linux/device.h>
 #include <linux/dma-buf.h>
+#include <linux/dma-buf-mapping.h>
 #include <linux/dma-fence.h>
 #include <linux/dma-resv.h>
 #include <linux/file.h>
@@ -1676,7 +1677,7 @@ iio_buffer_find_attachment(struct iio_dev_buffer_pair *ib,
 	guard(mutex)(&buffer->dmabufs_mutex);
 
 	list_for_each_entry(priv, &buffer->dmabufs, entry) {
-		if (priv->attach->dev == dma_dev
+		if (dma_buf_sgt_dma_device(priv->attach) == dma_dev
 		    && priv->attach->dmabuf == dmabuf) {
 			attach = priv->attach;
 			break;
@@ -1760,7 +1761,7 @@ static int iio_buffer_attach_dmabuf(struct iio_dev_buffer_pair *ib,
 	 * combo. If we do, refuse to attach.
 	 */
 	list_for_each_entry(each, &buffer->dmabufs, entry) {
-		if (each->attach->dev == dma_dev
+		if (dma_buf_sgt_dma_device(each->attach) == dma_dev
 		    && each->attach->dmabuf == dmabuf) {
 			/*
 			 * We unlocked the reservation object, so going through
@@ -1814,7 +1815,7 @@ static int iio_buffer_detach_dmabuf(struct iio_dev_buffer_pair *ib,
 	guard(mutex)(&buffer->dmabufs_mutex);
 
 	list_for_each_entry(priv, &buffer->dmabufs, entry) {
-		if (priv->attach->dev == dma_dev
+		if (dma_buf_sgt_dma_device(priv->attach) == dma_dev
 		    && priv->attach->dmabuf == dmabuf) {
 			list_del(&priv->entry);
 

-- 
2.54.0

