Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.198.47
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795154306;
	b=GlFwHjcHM7rOXL94u+CJMiGg/XiG2PtNAUP7lOM1m93JucKhTBXdZyMNi5rJHlp88Yk1
	 ahyKvkTbPwGsyk6z4igGUIte78rRl+oHgHAfWgyFV+9xmfzZKbrk68jVFYqPZeFs7uv2G
	 MxbtksISCseFXSmqwS7Piax8xafMSCJDgfyWEswpuCXJ3HF6QoA4cNbSwG+EVNdoztdgD
	 QXdEvO6zLLOfS7Sb/PkdjPVaPcnkfiWrCr/Bpbz2Vfcf42gNpxJARytgoGF4i7CSeNNwC
	 D7OUgspH/z5sviqholQ3GQWT21mgxrRF3wFvGqYs/Xi49y1Ju1x3A17xHIlA9ovxBNA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795154306;
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
	bh=Pa9qBmxx43qFD+/bVBBIN+GjHvp4f6UYO7paFuB2co0=;
	b=Rbe3oGRd3OK9zo99a4KeJlvs/574MplRLRE4YyAEdt53bpXXo4yDpp76j30St7ln2XZA
	 8+t6tm1wrWsvbsfJmWQATQnlXvJS8sq7jVD1O0XpzlUMzhjSmWceMlUvNdmhAoxkwr7Jx
	 7louzGPS5ktKy2wH2m0k6srURA5dlhXddxgMPQNmhtAXFQaSO9pXHa7h+ivxXh8yYBh9Y
	 KvK/yXNSTeQvMS6uKzhpSWDgl15U5mkiv3jZzDmHfZcFdRJvynVfrLwBDFw3IFpKos7OO
	 IQNz38cFOKIvXAdpg5eBP1PL4IiBAq4slP08hur0073/U+EQwIVB3lQVRIPEwhwcVlQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=Flt0E9Dd;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.198.47
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010047.outbound.protection.outlook.com [40.93.198.47])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E78F560A6F5B;
	Fri, 20 Nov 2026 05:58:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E78F560A6F5B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=Flt0E9Dd
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OHwoHBl/Wbdkcu+lPTotK20WdEpp9Q3bGmg5CCK/TXjCFkMcajaGDpwbssPC3FbAuKx73xYBH7x2PKaHYP6nuuZ5EEZyQpM2Gp6RphZrIZzpBYePMDR88yVk1TKWYLAE9/1zQUXuvcwTVDEAmUWyAQP/GaVZPQ+Cvsw4AlLTeURMkcjgiJMiE4CiiYF4UyWc4IFDTIG45BDyuRNP/OTLg7Bo2bBozU/fqq5yVVhAX/mJM8m2ijSibs85h3U1Hz5XGRCJtptVCQgtcug+vfGCmb9EAHIsOEgG1bijH2VmzIvruNGgjbIY+1rNJbXbDWmm1iHKwPyd1NtZGL+/p8dBrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Pa9qBmxx43qFD+/bVBBIN+GjHvp4f6UYO7paFuB2co0=;
 b=E3FdZ2avTnErhLnvZL9DxfKlgdxA5vzUQ6aK77uxDO2iSqsDKPEUzTGxwu4OHvl7YQkmsRhIhODBPXtI3M8mDk0D1p1ZLJOr8tpyfYMU29PirzBjNqcGTr92eISDUy/kUQmrsxS+3hUPpIX9t4dx2NczJ65p0lEoMDH0NB32TARgdaxCLjUQMwgaJaUBY1dW/Z125nTWAX5/IebWcC1GihpMA0H24kNR0rnM41uRkdSP70KWrBlkPFHbZUUxHkkodB4k2GxLaf41yHOz3cq32+b3JYUallh2GWApIJG2guIVadcV/Erebu8kIGlpTRgZzivR2KbgKnQc8rpGaSIzog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Pa9qBmxx43qFD+/bVBBIN+GjHvp4f6UYO7paFuB2co0=;
 b=Flt0E9DdUYJ+nGUd8a30ZYHrKPhCBDtU9F2IJOk9djYzSFt45kpvMLNHxP5uprIQqCg8kBiYEmmD1hR8c3X35Mn7n6bvrCeyEX6lu2Sw/6tG8BKsuMQY0etLijxKxF4ATrDD/F03tEwR2VkM2FJvVVj5GReLXhsdVX/5+z2Os9zaORveSSGanOtP8MnTKVCEtRcJuFnUYTBHgUNcVXoIJ1MPWWMFEyJWzRvxRViz9ngTin8vCOZRXQpm2PrNYcpw9UdDHQKqqVlIwY160k41IZM529x5j0OwvAs2UIcGZrT/kAZsNC9XDETx/8+p6j3poYFpjcpzFvCX/Ab+/r5PJQ==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SA3PR12MB598757.namprd12.prod.outlook.com
 (2603:10b6:806:52d::14) by PH7PR12MB6717.namprd12.prod.outlook.com
 (2603:10b6:510:1b0::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Fri, 20 Nov
 2026 05:58:18 +0000
Received: from SA3PR12MB598757.namprd12.prod.outlook.com
 ([fe80::e206:100:5946:a777]) by SA3PR12MB598757.namprd12.prod.outlook.com
 ([fe80::e206:100:5946:a777%5]) with mapi id 15.21.0639.011; Fri, 20 Nov 2026
 05:58:18 +0000
From: Alistair Popple <apopple@nvidia.com>
Date: Fri, 20 Nov 2026 16:55:59 +1100
Subject: [PATCH v3 21/24] dma-buf: Add kunit tests for mapping type
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261120-dma_mapping_type_v4-v3-21-c0183a409bdf@nvidia.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795154186; l=14149;
 i=apopple@nvidia.com; s=20261105; h=from:subject:message-id;
 bh=HA5XOM585B90bJB4HRCJQF2bTog8fTGSNF4dHHuCmig=;
 b=nxahcJuspd/vtBXj1bsE2fGKCDX8eeeRpJ/IYUHo4g6LL5ynPaUV3TmJnicyIcf1QFWMxvutg
 5Bxj1FYP381Bhx2WTVsCH1JceeS7LzF/22qBJtxE4VmylIdCW6g5JFf
X-Developer-Key: i=apopple@nvidia.com; a=ed25519;
 pk=WdWPT9rAq3YNfXldbGv1NSGVLGxzQGFGJvRUiShhNqs=
X-ClientProxiedBy: SY5P282CA0039.AUSP282.PROD.OUTLOOK.COM
 (2603:10c6:10:206::17) To SA3PR12MB598757.namprd12.prod.outlook.com
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
X-MS-Office365-Filtering-Correlation-Id: 4d7ea046-281b-4fe2-92d1-08df46cb4668
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|7416014|23010399003|366016|921020|261102123227099003|261021121427099003|10067099003|11063799006|261102130727099003|261026121527099003|56012099006|261026140227099003|261022075727099003|261028144727099003|261022105027099003|261009223027099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	bajc/kqsnnk6R9wKbJvdKjfl/bH6lV+LR1YHtTNatoOboud9iEMPVKe6RBLcpuAcG/yGwDc2yuG/wYhCgjVVk8OnREcuuupxEwcxsala0sxXom9CdbjVNum8mHUI3VLjIMMMBZbOnsv6rwjt8jmFEy3YUckq5hOFKdRtKXmA1kam4bWvvg68f2J+JrTHeXVxsJZYgtBJtmTnNLhs1E3yqoRsDlJKAo4VUcgwKknWwUbD5WfOl30oD7X8Iea+h5k2beL09NY3Mg+vF5EWD4rG2Jjp/M5XmuGT7B8+/JFyB79wprkzkJ59i4YQ0Uul3FzwRAOMtzOv7+Bl6jKVmDEHoK8iH7B40bQEuvUEFv2wg0A7I9yVfyoAAU67vtO3U1YYB67iZBLyynFN/hjdUJh5mJi8OuELrCZZVRqkkD5G0Aymc2xdewN4IV4/yW6ODe2ISdf80sE3L9YFDxvCp+RFyv86dPzpyvVrvg3lrBdYQWwxtEwV1RkLxX1AGg4XsF32qVPRtK9jIok3YxJPtBI47LBkBUMlGwBNt3r1xMB24rRESQLJM7NWByoOoEDSo0KAvRcMOGk1Oqd6HVxvyhXEF2C8bgDG7wLjt/HIi5wQWUX1kpXx2+VBf/cE+Sv5RazgsjUugGZsD9sdDcNxGFivkYx0o327/tuw4Gs/Ri9kPFJRp9IGF5HmIZlQb1NlVusadKbxI/PstnysA0C7sZ1sqA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA3PR12MB598757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(23010399003)(366016)(921020)(261102123227099003)(261021121427099003)(10067099003)(11063799006)(261102130727099003)(261026121527099003)(56012099006)(261026140227099003)(261022075727099003)(261028144727099003)(261022105027099003)(261009223027099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QVRlbEU4ZHJ1SUhWZ3NnNGFscFJ1d1FrU2w3dHdXaHRHZjZhbGlpcyt3TDFk?=
 =?utf-8?B?M2JkR2JQK1RINVA2bm54SUtXMExMa3FsYnR5OFlCcnlqNEhqc0grSGV5Qkh1?=
 =?utf-8?B?OVlnTHlpRkJaNyt3M3p2N3JvZDFlZU5IUTl3V1c2STFmTE83Uk1hb2w2dTZu?=
 =?utf-8?B?Znhsd0prcnZJZnhHYnZnL3l6UGlMcHdRZzRLU0orQ2hDRFZTVGRlSUhXSzNB?=
 =?utf-8?B?VzJMOWp2dkV4ZXR1Sy9WT1l1a29EMUhydDFPbHhiVndra0wybDRNaEdPdDB3?=
 =?utf-8?B?MXozcWtleWI2Y2VyNjM1RUcwYk0zU3dCQStOdlFZcHhRWFl5VFpsd0g4eEhn?=
 =?utf-8?B?cGFWVSttLzV1eHU3bVp2MHYrcGJlaDZqNFZ1b0ptbGg5TzNob1psZjhFZVly?=
 =?utf-8?B?aHh4eXpRYUl0QVJzQ3dWL2xJVFRRaW5LWlE0VnBvcnR2VnFqb01QWDdFUkZ0?=
 =?utf-8?B?WXlIejJlb1RKVk44SWpCelJiSERxRGhRTmtxN3paUFhZTHpGb2pycHFDSERx?=
 =?utf-8?B?bnppSHFGN04yWUlXZGxoNEFudXZlT0JHVVJtNFVNVHdMNE5KSlpUNUxEWHlP?=
 =?utf-8?B?T2RvVW5YRnJFSk1jbDJoSVUrSjc4cUM3eFVyek9oeEFyaGpLT0V1QWI2Q0Nh?=
 =?utf-8?B?eWcxN2MxZEdjclhaNEtTc3NKVUpHa01xZEg0VUcrUmxJOTZQQS82Ymd6RFB1?=
 =?utf-8?B?TjJKcFF1cVVzaGxzS252YVo2Q1A5NjRSVldVZEF6WXhLWVlYWVJQTkhpbkxE?=
 =?utf-8?B?WGdBSU9YQUdyNitncmFITVN6Z0FDbEpzaEN6eStnSTh5T2E3WUZZczZSM2tX?=
 =?utf-8?B?VG1RbmM3NzBwd0p3ZnhzMTBNOWtxbWoxNXhndTkyL0xpK3ZZdTM4NVNXZDNh?=
 =?utf-8?B?ZVNIY0M0VlVIN1BaOFNrNjAzVTVPaXBKS3Z4WGtMUm1tNGcwNXlKazl2T0dN?=
 =?utf-8?B?VHJEby9ON0xIazFxT1ZMZ1lGYzU4VjN5am1MNkwxSnNTRXZ1Y2VBaVNFRDdW?=
 =?utf-8?B?RXdORVF3R2diU2s5N3E3c3RJZk1VOVZORjYydGx1QmhJNER4RzRhMklqOW1r?=
 =?utf-8?B?andwcDFMM2NFaitncU5sYVNjeGlWcmFURFlWM2lEaWpNRUtjRmQ1ZFhsVzVp?=
 =?utf-8?B?dWhiNjRvMzRvWXh1a2xnaTlaRG1rOWFsbS90dk1wWUk3M2cxbk84bGFJQjRn?=
 =?utf-8?B?OG01RkhjN2VHazlab3ZVakJRQmJkeG0yckVkM1lGdGN0VjdiUVJRWHhuTkMx?=
 =?utf-8?B?dXkzY2MvMFNsVzlMeGNzUHFxUGtqd05MZlNPb2w4ZFFtYVliZG0xWXBINU52?=
 =?utf-8?B?Y2RYQ3pPK2ZVZmpVU20zbytBbjAzRmdBUnNrbjFWZ1JGS1lvNWV5Tk1qODRW?=
 =?utf-8?B?c0M4dzhaUVFxcEFTZnNOY0lWODMwaVJjL285OXRVZmUvSS93aFlqM2J3SENn?=
 =?utf-8?B?TjJhWWVNcXRvUU5tdUJVbklOelhoS3hlSHAyZzZNN2hBc3lwSWRXeTNqR0tr?=
 =?utf-8?B?V0VkNEh3YjhYNE5NR00xUXBPbS9ZNWNmdm5WaFdIekp1Y3A3d1F0S3ptcmFX?=
 =?utf-8?B?TXlpK1dkc2tENUxlK21uTnQrUHhTeXJCWmZOZ1Y2eTA5cW5aU0gwY1paOUlo?=
 =?utf-8?B?NXpSU0IxZlc3NzdjMjJqTCtqV2N5UE5OVDRuMjlOT0xpN2tielBrUFZsNndw?=
 =?utf-8?B?L0pnOUlwbTgydlJ2R0dmeUhqR3RlUUxpVy85bTQwWmp1c1c1cTJ6YnBJWDJO?=
 =?utf-8?B?NmhOUHByNE1MRkQrVkFoMUpQTWk1NEF6ZWdyd01mbFpsWDF0QlUrYUVGUE9U?=
 =?utf-8?B?R2dWbWdaYjZRZlBvcDVBR3EvcS8yOEFUait2TG1qbDQxS2JpQVowNXJmb1Nw?=
 =?utf-8?B?eTIwOWhJc1RFYTZXbVVhd0d3QWFWamlqN1M3OHBTWXJkZm1WcVBXUW1WT1l6?=
 =?utf-8?B?c1JvTWoxTW1GYnJlZnhhL3V6am1VWW1UVTBmVEhQcGEzOVZ0a2lhaC8wcFJG?=
 =?utf-8?B?R0RyV2tJVXhoM21RdEhNWkVFbnoxOFhGTDZxbmljNFgrWEl4RkRHTkQrdDdW?=
 =?utf-8?B?SFllajRWN1VYdWNKZ3B4NEc0MFhNN0JQRnZOc3lUdkRyNXk0TkpIUjZxMlpa?=
 =?utf-8?B?VW9vRWlPRnpNNmlFRnlTRC9EQ2tBdnJPcEZFYVptdkpiKzAzYUFMWldXOUla?=
 =?utf-8?B?YldDaVA1cklaR2Q0ZFNXVFp1d3BycW1CaFQxbGhQNVVicmRRejd1UnpoU3Jj?=
 =?utf-8?B?L1BHOEtGd0hVamtxL2MvZlRuemlZRG9jZWdlUjNRdUI3RmVmRTVhc2tPSkNP?=
 =?utf-8?B?UEJjNXNRdUtvVmdraWYzUGlRdjRDSDRNYkhjWWJhWG1sb3FOekpnUT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d7ea046-281b-4fe2-92d1-08df46cb4668
X-MS-Exchange-CrossTenant-AuthSource: SA3PR12MB598757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2026 05:58:18.4255
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hqHmyfNh11q1awD6BLgWewneOFUzzmTPrLWNNIJgok5REklN5eih9MEzWE//cMLq+kWzH3vu78/4Yma+CV9aoQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6717

From: Jason Gunthorpe <jgg@nvidia.com>

Some basic coverage of common flows:
 - Check dma_buf_match_mapping()'s rules. These choices effectively
   become driver facing API and it would be a pain to change them later
 - Test the dma_buf_sgt attachment flow to see that the new wrappers work

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Alistair Popple <apopple@nvidia.com>
---
 drivers/dma-buf/Makefile         |   1 +
 drivers/dma-buf/st-dma-mapping.c | 403 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 404 insertions(+)

diff --git a/drivers/dma-buf/Makefile b/drivers/dma-buf/Makefile
index 523731b0f83e..02745fca8b88 100644
--- a/drivers/dma-buf/Makefile
+++ b/drivers/dma-buf/Makefile
@@ -11,6 +11,7 @@ dmabuf_kunit-y := \
 	st-dma-fence.o \
 	st-dma-fence-chain.o \
 	st-dma-fence-unwrap.o \
+	st-dma-mapping.o \
 	st-dma-resv.o
 
 obj-$(CONFIG_DMABUF_KUNIT_TEST) += dmabuf_kunit.o
diff --git a/drivers/dma-buf/st-dma-mapping.c b/drivers/dma-buf/st-dma-mapping.c
new file mode 100644
index 000000000000..8c69ae212455
--- /dev/null
+++ b/drivers/dma-buf/st-dma-mapping.c
@@ -0,0 +1,403 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * KUnit tests for dma_buf_match_mapping()
+ */
+
+#include <kunit/device.h>
+#include <kunit/test.h>
+#include <linux/dma-buf.h>
+#include <linux/dma-buf-mapping.h>
+#include <linux/errno.h>
+
+/* Mock tracking state -- reset before each test */
+static bool mock_match_called;
+static const struct dma_buf_mapping_match *mock_match_exp_arg;
+static const struct dma_buf_mapping_match *mock_match_imp_arg;
+static struct device *mock_match_dev_arg;
+static int mock_match_ret;
+
+static bool mock_finish_called;
+static const struct dma_buf_match_args *mock_finish_args_arg;
+static const struct dma_buf_mapping_match *mock_finish_exp_arg;
+static const struct dma_buf_mapping_match *mock_finish_imp_arg;
+
+static int reset_mock_state(struct kunit *test)
+{
+	mock_match_called = false;
+	mock_match_exp_arg = NULL;
+	mock_match_imp_arg = NULL;
+	mock_match_dev_arg = NULL;
+	mock_match_ret = 0;
+	mock_finish_called = false;
+	mock_finish_args_arg = NULL;
+	mock_finish_exp_arg = NULL;
+	mock_finish_imp_arg = NULL;
+	return 0;
+}
+
+static int mock_match(struct dma_buf_match_args *args,
+		      const struct dma_buf_mapping_match *exp,
+		      const struct dma_buf_mapping_match *imp)
+{
+	mock_match_called = true;
+	mock_match_exp_arg = exp;
+	mock_match_imp_arg = imp;
+	mock_match_dev_arg = args->dev;
+	return mock_match_ret;
+}
+
+static void mock_finish_match(struct dma_buf_match_args *args,
+			      const struct dma_buf_mapping_match *exp,
+			      const struct dma_buf_mapping_match *imp,
+			      struct dma_buf_mapping_match *match)
+{
+	mock_finish_called = true;
+	mock_finish_args_arg = args;
+	mock_finish_exp_arg = exp;
+	mock_finish_imp_arg = imp;
+
+	*match = (struct dma_buf_mapping_match){
+		.type = exp->type,
+		.exp_ops = exp->exp_ops,
+	};
+}
+
+/* Type with both match and finish_match callbacks */
+static struct dma_buf_mapping_type mock_type_a = {
+	.name = "mock_type_a",
+	.match = mock_match,
+	.finish_match = mock_finish_match,
+};
+
+/* Second type -- distinct pointer identity from A */
+static struct dma_buf_mapping_type mock_type_b = {
+	.name = "mock_type_b",
+	.match = mock_match,
+	.finish_match = mock_finish_match,
+};
+
+static void test_match_fail(struct kunit *test)
+{
+	struct dma_buf_mapping_match matches[] = { { .type = &mock_type_a } };
+	struct dma_buf_mapping_match exp[] = { { .type = &mock_type_b } };
+	struct dma_buf_attachment attach = {};
+	struct dma_buf_match_args args = {
+		.attach = &attach,
+		.imp_matches = matches,
+		.imp_len = ARRAY_SIZE(matches),
+	};
+
+	/* Zero-length exporter array returns -EINVAL */
+	KUNIT_EXPECT_EQ(test, dma_buf_match_mapping(&args, NULL, 0), -EINVAL);
+	KUNIT_EXPECT_FALSE(test, mock_match_called);
+	KUNIT_EXPECT_FALSE(test, mock_finish_called);
+
+	/* Zero-length importer array returns -EINVAL */
+	args = (struct dma_buf_match_args){ .attach = &attach };
+	KUNIT_EXPECT_EQ(test,
+			dma_buf_match_mapping(&args, matches,
+					      ARRAY_SIZE(matches)),
+			-EINVAL);
+	KUNIT_EXPECT_FALSE(test, mock_match_called);
+	KUNIT_EXPECT_FALSE(test, mock_finish_called);
+
+	/* Different types produce no match */
+	args.imp_matches = matches;
+	args.imp_len = ARRAY_SIZE(matches);
+	KUNIT_EXPECT_EQ(test,
+			dma_buf_match_mapping(&args, exp, ARRAY_SIZE(exp)),
+			-EOPNOTSUPP);
+	KUNIT_EXPECT_FALSE(test, mock_match_called);
+	KUNIT_EXPECT_FALSE(test, mock_finish_called);
+}
+
+/* When type->match() is NULL same types always match */
+static void test_match_no_match_callback(struct kunit *test)
+{
+	static struct dma_buf_mapping_type mock_type_no_match = {
+		.name = "mock_type_no_match",
+		.finish_match = mock_finish_match,
+	};
+	struct dma_buf_mapping_match matches[] = {
+		{ .type = &mock_type_no_match }
+	};
+	struct dma_buf_attachment attach = {};
+	struct dma_buf_match_args args = {
+		.attach = &attach,
+		.imp_matches = matches,
+		.imp_len = ARRAY_SIZE(matches),
+	};
+
+	KUNIT_EXPECT_EQ(test, dma_buf_match_mapping(&args, matches,
+						    ARRAY_SIZE(matches)), 0);
+	KUNIT_EXPECT_FALSE(test, mock_match_called);
+	KUNIT_EXPECT_TRUE(test, mock_finish_called);
+	KUNIT_EXPECT_PTR_EQ(test, mock_finish_args_arg, &args);
+	KUNIT_EXPECT_PTR_EQ(test, mock_finish_exp_arg, &matches[0]);
+	KUNIT_EXPECT_PTR_EQ(test, mock_finish_imp_arg, &matches[0]);
+}
+
+static void test_match_callback_returns(struct kunit *test)
+{
+	struct dma_buf_mapping_match matches[] = { { .type = &mock_type_a } };
+	struct dma_buf_attachment attach = {};
+	struct dma_buf_match_args args = {
+		.attach = &attach,
+		.imp_matches = matches,
+		.imp_len = ARRAY_SIZE(matches),
+	};
+
+	/* type->match() returns -EOPNOTSUPP. Skips to next */
+	mock_match_ret = -EOPNOTSUPP;
+	KUNIT_EXPECT_EQ(test,
+			dma_buf_match_mapping(&args, matches,
+					      ARRAY_SIZE(matches)),
+			-EOPNOTSUPP);
+	KUNIT_EXPECT_TRUE(test, mock_match_called);
+	KUNIT_EXPECT_FALSE(test, mock_finish_called);
+
+	/* type->match() returns an error code. Stops immediately, returns code */
+	mock_match_ret = -ENOMEM;
+	KUNIT_EXPECT_EQ(test,
+			dma_buf_match_mapping(&args, matches,
+					      ARRAY_SIZE(matches)),
+			-ENOMEM);
+	KUNIT_EXPECT_TRUE(test, mock_match_called);
+	KUNIT_EXPECT_FALSE(test, mock_finish_called);
+}
+
+/*
+ * The match set records every compatible pair, in the exporter's order. The
+ * first entry is the default selection.
+ */
+static void test_match_exporter_priority(struct kunit *test)
+{
+	struct dma_buf_mapping_match exp1[2] = {
+		{ .type = &mock_type_a },
+		{ .type = &mock_type_b },
+	};
+	struct dma_buf_mapping_match exp2[] = { { .type = &mock_type_b } };
+	struct dma_buf_mapping_match imp[2] = {
+		{ .type = &mock_type_a },
+		{ .type = &mock_type_b },
+	};
+	struct dma_buf_attachment attach = {};
+	struct dma_buf_match_args args = {
+		.attach = &attach,
+		.imp_matches = imp,
+		.imp_len = ARRAY_SIZE(imp),
+	};
+
+	/* Both match, exporter order preserved, first is the default */
+	KUNIT_EXPECT_EQ(test, dma_buf_match_mapping(&args, exp1,
+						    ARRAY_SIZE(exp1)), 0);
+	KUNIT_ASSERT_EQ(test, attach.nr_matches, 2);
+	KUNIT_EXPECT_PTR_EQ(test, attach.matches[0].type, &mock_type_a);
+	KUNIT_EXPECT_PTR_EQ(test, attach.matches[1].type, &mock_type_b);
+	KUNIT_EXPECT_PTR_EQ(test, dma_buf_attach_map_type(&attach)->type,
+			    &mock_type_a);
+
+	/* Only the second importer type is offered */
+	KUNIT_EXPECT_EQ(test, dma_buf_match_mapping(&args, exp2,
+						    ARRAY_SIZE(exp2)), 0);
+	KUNIT_ASSERT_EQ(test, attach.nr_matches, 1);
+	KUNIT_EXPECT_PTR_EQ(test, attach.matches[0].type, &mock_type_b);
+	KUNIT_EXPECT_PTR_EQ(test, dma_buf_attach_map_type(&attach)->type,
+			    &mock_type_b);
+	KUNIT_EXPECT_PTR_EQ(test, mock_finish_imp_arg, &imp[1]);
+}
+
+/* The exporter's order wins over the importer's */
+static void test_match_importer_priority(struct kunit *test)
+{
+	struct dma_buf_mapping_match exp[] = {
+		{ .type = &mock_type_a },
+		{ .type = &mock_type_b },
+	};
+	struct dma_buf_mapping_match imp1[] = { { .type = &mock_type_b } };
+	struct dma_buf_mapping_match imp2[] = {
+		{ .type = &mock_type_b },
+		{ .type = &mock_type_a },
+	};
+	struct dma_buf_attachment attach = {};
+	struct dma_buf_match_args args = {
+		.attach = &attach,
+		.imp_matches = imp1,
+		.imp_len = ARRAY_SIZE(imp1),
+	};
+
+	/* Single importer type */
+	KUNIT_EXPECT_EQ(test,
+			dma_buf_match_mapping(&args, exp, ARRAY_SIZE(exp)), 0);
+	KUNIT_ASSERT_EQ(test, attach.nr_matches, 1);
+	KUNIT_EXPECT_PTR_EQ(test, attach.matches[0].type, &mock_type_b);
+	KUNIT_EXPECT_PTR_EQ(test, mock_finish_imp_arg, &imp1[0]);
+
+	/* Importer prefers B, exporter prefers A: A is the default */
+	args.imp_matches = imp2;
+	args.imp_len = ARRAY_SIZE(imp2);
+	KUNIT_EXPECT_EQ(test,
+			dma_buf_match_mapping(&args, exp, ARRAY_SIZE(exp)), 0);
+	KUNIT_ASSERT_EQ(test, attach.nr_matches, 2);
+	KUNIT_EXPECT_PTR_EQ(test, attach.matches[0].type, &mock_type_a);
+	KUNIT_EXPECT_PTR_EQ(test, attach.matches[1].type, &mock_type_b);
+	KUNIT_EXPECT_PTR_EQ(test, dma_buf_attach_map_type(&attach)->type,
+			    &mock_type_a);
+}
+
+static void mock_dmabuf_release(struct dma_buf *dmabuf)
+{
+}
+
+static struct dma_buf_sgt_mapping *
+mock_map_dma_buf(struct dma_buf_attachment *attach, enum dma_data_direction dir)
+{
+	return ERR_PTR(-ENODEV);
+}
+
+static void mock_unmap_dma_buf(struct dma_buf_attachment *attach,
+			       struct dma_buf_sgt_mapping *mapping,
+			       enum dma_data_direction dir)
+{
+}
+
+static const struct dma_buf_mapping_sgt_exp_ops mock_sgt_ops = {
+	.map_dma_buf = mock_map_dma_buf,
+	.unmap_dma_buf = mock_unmap_dma_buf,
+};
+
+static const struct dma_buf_ops mock_dmabuf_simple_sgt_ops = {
+	.release = mock_dmabuf_release,
+	DMA_BUF_SIMPLE_SGT_EXP_MATCH(mock_map_dma_buf, mock_unmap_dma_buf),
+};
+
+static int mock_dmabuf_match_mapping(struct dma_buf_match_args *args)
+{
+	struct dma_buf_mapping_match sgt_match[2];
+	unsigned int num_match = 0;
+
+	sgt_match[num_match++] =
+		(struct dma_buf_mapping_match){ .type = &mock_type_a };
+
+	sgt_match[num_match++] = DMA_BUF_EMAPPING_SGT(&mock_sgt_ops);
+
+	return dma_buf_match_mapping(args, sgt_match, ARRAY_SIZE(sgt_match));
+}
+
+static const struct dma_buf_ops mock_dmabuf_two_exp_ops = {
+	.release = mock_dmabuf_release,
+	.match_mapping = mock_dmabuf_match_mapping,
+};
+
+struct dma_exporter {
+	const struct dma_buf_ops *ops;
+	const char *desc;
+};
+
+static struct dma_buf *mock_dmabuf_export(const struct dma_buf_ops *ops)
+{
+	DEFINE_DMA_BUF_EXPORT_INFO(exp_info);
+
+	exp_info.ops = ops;
+	exp_info.size = PAGE_SIZE;
+	exp_info.priv = ERR_PTR(-EINVAL);
+	return dma_buf_export(&exp_info);
+}
+
+/*
+ * Check that a simple SGT exporter with single_exporter_match works with
+ * dma_buf_attach()
+ */
+static void test_sgt_attach(struct kunit *test)
+{
+	const struct dma_exporter *param = test->param_value;
+	struct dma_buf *dmabuf;
+	struct dma_buf_attachment *attach;
+	struct device *dev;
+
+	dev = kunit_device_register(test, "dma-buf-test");
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, dev);
+
+	dmabuf = mock_dmabuf_export(param->ops);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, dmabuf);
+
+	attach = dma_buf_attach(dmabuf, dev);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, attach);
+
+	KUNIT_EXPECT_PTR_EQ(test, dma_buf_attach_map_type(attach)->type,
+			    &dma_buf_mapping_sgt_type);
+	KUNIT_EXPECT_PTR_EQ(test, dma_buf_sgt_dma_device(attach), dev);
+
+	dma_buf_detach(dmabuf, attach);
+	dma_buf_put(dmabuf);
+}
+
+static void mock_move_notify(struct dma_buf_attachment *attach)
+{
+}
+
+/*
+ * Mock importer: declares a dma_buf_attach_ops whose supported_mapping_types
+ * table is whatever the test put in @_matches.
+ */
+#define MOCK_IMPORTER_OPS(_name, _matches)                          \
+	const struct dma_buf_attach_ops _name = {                   \
+		.invalidate_mappings = &mock_move_notify,           \
+		.supported_mapping_types = (_matches),              \
+		.nr_supported_mapping_types = ARRAY_SIZE(_matches), \
+	}
+
+/* Check a dynamic attach with a non-sgt mapping type */
+static void test_mock_attach(struct kunit *test)
+{
+	struct dma_buf_mapping_match imp[] = { { .type = &mock_type_a } };
+
+	MOCK_IMPORTER_OPS(importer_ops, imp);
+	struct dma_buf *dmabuf;
+	struct dma_buf_attachment *attach;
+	struct device *dev;
+
+	dev = kunit_device_register(test, "dma-buf-test");
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, dev);
+
+	dmabuf = mock_dmabuf_export(&mock_dmabuf_two_exp_ops);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, dmabuf);
+
+	attach = dma_buf_dynamic_attach(dmabuf, dev, &importer_ops, NULL);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, attach);
+
+	KUNIT_EXPECT_PTR_EQ(test, dma_buf_attach_map_type(attach)->type,
+			    &mock_type_a);
+	KUNIT_EXPECT_PTR_EQ(test, mock_match_dev_arg, dev);
+
+	dma_buf_detach(dmabuf, attach);
+	dma_buf_put(dmabuf);
+}
+
+static const struct dma_exporter dma_exporter_params[] = {
+	{ &mock_dmabuf_simple_sgt_ops, "simple_sgt" },
+	{ &mock_dmabuf_two_exp_ops, "two_exp" },
+};
+
+KUNIT_ARRAY_PARAM_DESC(dma_exporter, dma_exporter_params, desc);
+
+static struct kunit_case dma_mapping_cases[] = {
+	KUNIT_CASE(test_match_fail),
+	KUNIT_CASE(test_match_no_match_callback),
+	KUNIT_CASE(test_match_callback_returns),
+	KUNIT_CASE(test_match_exporter_priority),
+	KUNIT_CASE(test_match_importer_priority),
+	KUNIT_CASE_PARAM(test_sgt_attach, dma_exporter_gen_params),
+	KUNIT_CASE(test_mock_attach),
+	{}
+};
+
+static struct kunit_suite dma_mapping_test_suite = {
+	.name = "dma-buf-mapping",
+	.init = reset_mock_state,
+	.test_cases = dma_mapping_cases,
+};
+
+kunit_test_suite(dma_mapping_test_suite);
+
+MODULE_IMPORT_NS("DMA_BUF");

-- 
2.54.0

