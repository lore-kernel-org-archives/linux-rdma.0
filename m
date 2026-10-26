Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.46.71
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792993105;
	b=Ag7WePRW4lKampH9a2bvNhdwUageQgQv0x82vrfU3Z1I5LcLc+IgUJNFGGXsJ9JDKzWL
	 trzvbPjKXNugy+khBfzjRCFTAawoU5SrrUtEqbxZGcsSqDNW2mHtRboYKjUvDCz9LZ1g8
	 8YLR8LTy8/7Awjm9Ca6WzmFuKdiWeO0KzznsKQFGSqPJdMxeldSj+0fSQW2tCpW1tGfL4
	 jZsEjs1ElBEzAHa8MyQHJw75Q8WhRGCP+dXMWWB9gp8Fjt1h0nRl5AAjO6Qjg2fs5YM/C
	 /LMFP6Kb57PtLxvlXqVaHr2NMZdQsYkBQjUtC+J7IZubNXWSSUcnptztIMKmkCbJCFQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792993105;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:
	 Content-Transfer-Encoding:Content-Type:X-ClientProxiedBy:MIME-Version:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=LTfFzLsIpiwTYsHEhmDseALfrqhmVVcYVOVX1c5oc54=;
	b=HRqDxDx6eNG5gKVuDzWR85pvomYarUb8sOmzfPFl14jBdKOdl4pqd1A0DPyd3jpPlFx6
	 NM0dqYZdH77DcNFSKUiFvAgDX5Y+VizGNAN7Q5a3MC+e3TTnRSNlVlNozbRaA24+3wvv7
	 8AChhUl4dwl+roBe2W/k2hnBgI307rkrYNSnAVBIU5GMo0fsyXG0tJUMfISP5rLzCKGHl
	 ngfceJv2IJSxznA2SA2ur7UwJLYhhT/7BsnWASm+dw/8rOTZOqKkyEKvjxTqhilaqrSWS
	 r6vQAu0LPYeQjYUduMx4vbuARx6cSC3Vk5BpVjMDYOAQ0qrHyVSvBJ01N+d3GuVHypA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b="L3eWL4/8";
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.46.71
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010071.outbound.protection.outlook.com [52.101.46.71])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08CB660A2628;
	Mon, 26 Oct 2026 05:38:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 08CB660A2628
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=L3eWL4/8
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=zFwTLoMkqJuq83ThT3u2SqcIW56bLbNTGZtaXYfHEHduhMaz3CDScwNkzY59gTBVXpdqBimspHWVvOOZutCPEyMYE8CT7fzCBYd9ML5mjb7XQElNgR2u8D4/MfSxvW2DXtx+hGGVxP7btLhocb4vjPQ+jLYkqxMmGECTnF23dB6fu1ebyylW3AUsKfzhIOaxO5CgX16WKGR6Y+j+p2P/nVOE1AktaZIR2MIh2YVEtIA3qg3oq5MnNogehVLg3Xp+Kivzzy2WX6gKwk7G/xiTIyHVBpX7Ady4r5CStmvS4N1oc13yw+9HPxurZaLsIBKaiI2L9gxiYRQchPvSoIJPJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LTfFzLsIpiwTYsHEhmDseALfrqhmVVcYVOVX1c5oc54=;
 b=Be6JZLc0rPNKyuK78KvcVMZgcphs2clXa/imZEOD9o2fg8bpr+6weAddCcuX17Ao25Bd1fFGRgc8f56xL3ISyWy2JA3qQyqwpO1IdT9U5zgAwEUrBsChHV9N82uMiGY8gJsIu3/Qq4VRNP7EVF+HFoiaBYdQgxtcQ/LmwSVzTuKWlX/lQSV6ApojWiLJer/vQbMonHSdZIusdfniEupzDeABDqqB7x/aYKevGyqBroBJPz6kjRye/2yGkpLY92VbzbwaBTapK4Ygg7JQ8eo/X42aAlrPKW6VkqMNI5QRccIav44LVLQq6D0YRZD6Mbm8beMycJ9e6DuglFZhDevxBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LTfFzLsIpiwTYsHEhmDseALfrqhmVVcYVOVX1c5oc54=;
 b=L3eWL4/84mEwK+0OHyR92xtZF9wBGaMnFMvy1uy1i3W/Uacuc78rfqXBf5GQG3qFLss3UpuyMr1GbZr9lq5oZXtye5Fe4QZjREx0NgZ6s+ZoR3YBbYcTXVoUxoD+ENgwvwbLW81eWkp1CK6Cx0AQe/Xzj7snvB7UofUPajHrt6JTbDjOwSPEhF7hsPTjkj1egKIEKa/ru54MVIcXWD07k5/ndGRHG5tyqT8kZQwbWd4e5irwDhqZRnO4HhINySF+kznYPKzCylFfNLoECprkIyq7EX3J6f/Ww9VXJt+1Nd8dGCB/5lRdRx9BLNe4BbTFvzfxPWHqMqDWQJzySVOCsQ==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SA3PR12MB598757.namprd12.prod.outlook.com
 (2603:10b6:806:52d::14) by SJ0PR12MB6967.namprd12.prod.outlook.com
 (2603:10b6:a03:44b::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Mon, 26 Oct
 2026 05:38:20 +0000
Received: from SA3PR12MB598757.namprd12.prod.outlook.com
 ([fe80::e206:100:5946:a777]) by SA3PR12MB598757.namprd12.prod.outlook.com
 ([fe80::e206:100:5946:a777%5]) with mapi id 15.21.0546.021; Mon, 26 Oct 2026
 05:38:20 +0000
From: Alistair Popple <apopple@nvidia.com>
To: dri-devel@lists.freedesktop.org,
	christian.koenig@amd.com,
	sumit.semwal@linaro.org,
	jgg@nvidia.com
Cc: Alistair Popple <apopple@nvidia.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Simona Vetter <simona.vetter@ffwll.ch>,
	Matthew Brost <matthew.brost@intel.com>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	Dongwon Kim <dongwon.kim@intel.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Xu Yilun <yilun.xu@linux.intel.com>,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Baolu Lu <baolu.lu@linux.intel.com>,
	Felix Kuehling <felix.kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	intel-xe@lists.freedesktop.org,
	amd-gfx@lists.freedesktop.org,
	linux-media@vger.kernel.org,
	linaro-mm-sig@lists.linaro.org,
	linux-rdma@vger.kernel.org,
	iommu@lists.linux.dev,
	Alexey Kardashevskiy <aik@amd.com>,
	zhipingz@meta.com,
	treding@nvidia.com,
	jhubbard@nvidia.com
Subject: [PATCH 21/26] treewide: Rename dma_buf_map_attachment(_unlocked) to dma_buf_sgt_
Date: Mon, 26 Oct 2026 16:36:12 +1100
Message-ID: <20261026053623.202642-22-apopple@nvidia.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261026053623.202642-1-apopple@nvidia.com>
References: <20261026053623.202642-1-apopple@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SY5P282CA0072.AUSP282.PROD.OUTLOOK.COM
 (2603:10c6:10:203::15) To SA3PR12MB598757.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA3PR12MB598757:EE_|SJ0PR12MB6967:EE_
X-MS-Office365-Filtering-Correlation-Id: c7ec2e13-2cf2-47f8-b8fb-08df33235835
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|23010399003|366016|18002099003|22082099003|6133799003|56012099006|11063799006|261022075727099003|261021121427099003|261021123027099003|10067099003|261009221727099003|261009220027099003|261009221227099003|261009223327099003|261009223027099003|261022105027099003;
X-Microsoft-Antispam-Message-Info:
	hSSoRyuZ/p11AYNIZgXitorXcSZFQwSXEDmiLTIW761Mvvfu8w3AjiDt7ruBpO6yy2T5Wg07fhtij2jwoLfX94qDo9tK5JMosXcaKM5WUVVly5fuqcfwIA5acXNupKeK4x/XGCyZ9oLgqeZV+aH7Zg/gJ4D0NhK+CMLF3tv3fyZtEVnEeF5A0Q1+XawDcqkPmhBuPf0gZXh1x8NT2vIjsM3+WMY/KDbpYGkN0r+Ggd+/I8PkxeOrK5bA1wvlfsVAtps0wNSgIeaSC23pz9HeeDYimM0CMlIeFpTWyiywwmIluOtjKpTG63iaKaV2By39wTuK+qciG24bWyH97sJ2DaGQK+63pSe89e1NC8Z+jzwfWuYHPnBrPe65EVo6gw/fXNgkwA0ADNFF1XmlP+bKqoXcjjQUUkMYvk4wqPtW0+jKLs6MDkdr4m3RIqn75fB4vOI+jKGAZ4hFoOcBecGnEQCan9jMh4n51RoSSHQXF3wn8v4WgqBFE+A3h6g9Fduiz97Z9FABxtPnixAUfiGaVK3ZCnV9yamUyASxWv6doiNIpARmMHYvytQB28eQyoQPUhjBf4zLnpi35p5TwJhprQcTAkV+2hYTHBeCJtd4VqYz1ps0K54ag/hxmKOygrADgqQMPw+LddQ5AhzWsGim4FNHI+c1OnJCpc1/YQijMHI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA3PR12MB598757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(23010399003)(366016)(18002099003)(22082099003)(6133799003)(56012099006)(11063799006)(261022075727099003)(261021121427099003)(261021123027099003)(10067099003)(261009221727099003)(261009220027099003)(261009221227099003)(261009223327099003)(261009223027099003)(261022105027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?PkhTNpU3aEpkUabg/llI1zY4N1cgI33ix9HASaQZXpm6kMTKtRuUh6ki4n+2?=
 =?us-ascii?Q?i2yaGGPaZcL/OZ0krxapr+dRchNxcKexomAodmW+W85Wy0C9xettEL0LpxgB?=
 =?us-ascii?Q?Xe05ROybqGKE7kZhi7vAc5WEYQJyDb0+AxNhEroOR8uENu3XygvIIMTIDSL6?=
 =?us-ascii?Q?B3477XEPHzlnOQSwQ+oQo/SgOSOkFxsMPC8P8Pvm9qnnr5fYp6Df7GvDR9fx?=
 =?us-ascii?Q?heU/DihefWe7XToBgIvKVcWEoySumnv4d+phuG6G4X+0tW3w8mho0+Aqq/oI?=
 =?us-ascii?Q?qo77GAhxi2hPpZ1J9pRXjXbewmQKo/N4rduxk0Ic6eE1GJtJZr0WFsE4auU9?=
 =?us-ascii?Q?nforPb+hs4T+N4fIBr/ZCc+nZXeiTMFDzrdrt5lG6AJsJg3ZgeXbOqnkztnu?=
 =?us-ascii?Q?43ivegow/o1SFMxb/vG3QQ7AHWyZKq7MxpXp5eAGyvla+JD55udHEPvKLwvm?=
 =?us-ascii?Q?tEh/SkEFPJHkcdRfiCEz5RFPe4aqoFhkhPaxdllqe6sNGkjMVx6ZeuSDwqAH?=
 =?us-ascii?Q?xXy72BsB4i+8F79FHv5/xzb+VRRzuw7f0fcshEB3l6g2pe7R1j2Ipbt9ad2v?=
 =?us-ascii?Q?8+0CSvdhHEj9DtzPSAhUTKNzGGsl0gsTclQ1USJajUH+H2P1WKYQq562L+tl?=
 =?us-ascii?Q?RWXOUTqMmYquibrCH7qAWPAEE8jODyWa3oI4h0VgB+FKpIeNQcTEDjdM/C5C?=
 =?us-ascii?Q?vkjpWymFf9PhB8+EnSGMu7ytr9c8lcVjsqouTfEwRpUu9F1NTvRCxrPLQDkr?=
 =?us-ascii?Q?0hPXjQ7fqsCu8fzN8SrsDA2iLE1GuHfPsBI+zop63o7epqqQh9cmoGKh49j8?=
 =?us-ascii?Q?OKcir5r1SLHQ+0VmuFPs4f1jljXPFt8OWuJeKWKQNpJZhQTzhDoWhHw+hGCr?=
 =?us-ascii?Q?0c39+WjzzrP1imV4xMGLPbIJ2CW3xo3giisVeoWkKNorPe2Qwa5rVvXprOZh?=
 =?us-ascii?Q?7Akc5ycq944dyEHfgp/yhRwLbvGHs8QWoRXTeWwcA5uIc3D3ngEtTr4xTasc?=
 =?us-ascii?Q?BjZ8TN9LFvI35btGnY+EqR5I6NedS564OSN+isd0SujDFl6h4D3H0zAcAxp8?=
 =?us-ascii?Q?WxvaZ1Ld4cTZT9j5QD0tAlNrNx68sQiHO8b/0YhpfvUcUADf6HOcoSYDmNVE?=
 =?us-ascii?Q?XI4fO1dUt80fwitDnLwMQ/hKO4z8smw9MMBZFMh3mxS7ZHD33321CGEnnYjm?=
 =?us-ascii?Q?JFhXMYz8XLS3upk8z9nMoqZ6XbmjvYSRZ0GdGrDilxosA6vm0Br4yCu90k2j?=
 =?us-ascii?Q?xx8wgWqa2vAkSlhWXs5LUuZbcQJm9O4pJXxJe8FsuVD5hTd/rdap4vitu1GO?=
 =?us-ascii?Q?vjIUTC5k4EYnIaPoDfnjeIGpZPPa16kjjzCn2QK7Kk+olikixAGHe+gS41nu?=
 =?us-ascii?Q?yT9/13dR9cQ+eu3GHWeeImALreU8BB41+BxqmutHUzeaNw1FqGjw0kgE/igf?=
 =?us-ascii?Q?s5DYwKV2RNOZ0FUPFUevYCFkSMZiKzXjh9Ip1PWbMcPdPbdooEKh3XkG2UZa?=
 =?us-ascii?Q?tLPF8bP27W0G85xN79290Y2Gq1B9To6152FULxIGBaI5B5ZbtbChMHJP2tJR?=
 =?us-ascii?Q?gfLJC2OiB7a1RD8bcs4z3F6mIPPdpD6bhgoaSa7a2Rzs1WxWw3bwUFIbPFY5?=
 =?us-ascii?Q?tAzrOEekajdxRtQ9+pbwkIBwyfoq6WPcwdJ65GtNllgxzEBqwOhf2H3sgu+0?=
 =?us-ascii?Q?TQ2m2DNx+hW8g9gCokrl3b4wNhmTvmLMt0rKxZTGVhpEz6j73TYSVEt5IJl8?=
 =?us-ascii?Q?QH0KkP3b9w=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c7ec2e13-2cf2-47f8-b8fb-08df33235835
X-MS-Exchange-CrossTenant-AuthSource: SA3PR12MB598757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2026 05:38:20.7495
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cF7djKcoQzPD9lKLGme/FiCMwaC8EEnOE6ZeP3UhAfSFVzhIs65TmjHzYMCjvrvX3RgBTRut/AKPgUlCOf1XyQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6967

From: Jason Gunthorpe <jgg@nvidia.com>

This map function only works with SGT importers.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
[ also rename the io_uring zcrx caller, which the unmap rename
  used to pick up, so that this commit builds with CONFIG_IO_URING_ZCRX - apopple ]
Signed-off-by: Alistair Popple <apopple@nvidia.com>
---
 drivers/accel/amdxdna/amdxdna_gem.c           |  2 +-
 drivers/accel/ivpu/ivpu_gem.c                 |  3 +-
 drivers/accel/qaic/qaic_data.c                |  4 +--
 drivers/dma-buf/dma-buf.c                     | 28 +++++++++----------
 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c       |  3 +-
 drivers/gpu/drm/armada/armada_gem.c           | 14 ++++++----
 drivers/gpu/drm/drm_prime.c                   |  2 +-
 drivers/gpu/drm/i915/gem/i915_gem_dmabuf.c    |  4 +--
 .../drm/i915/gem/selftests/i915_gem_dmabuf.c  |  3 +-
 drivers/gpu/drm/omapdrm/omap_gem_dmabuf.c     |  2 +-
 drivers/gpu/drm/tegra/gem.c                   |  6 ++--
 drivers/gpu/drm/virtio/virtgpu_prime.c        |  2 +-
 drivers/gpu/drm/xe/xe_bo.c                    |  2 +-
 drivers/iio/industrialio-buffer.c             |  2 +-
 drivers/infiniband/core/umem_dmabuf.c         |  4 +--
 .../media/common/videobuf2/videobuf2-core.c   |  2 +-
 .../common/videobuf2/videobuf2-dma-contig.c   |  2 +-
 .../media/common/videobuf2/videobuf2-dma-sg.c |  2 +-
 .../platform/nvidia/tegra-vde/dmabuf-cache.c  |  2 +-
 drivers/misc/fastrpc.c                        |  3 +-
 drivers/usb/gadget/function/f_fs.c            |  2 +-
 drivers/xen/gntdev-dmabuf.c                   |  2 +-
 include/linux/dma-buf-mapping.h               |  4 +--
 include/linux/dma-buf.h                       | 10 +++----
 io_uring/zcrx.c                               |  3 +-
 net/core/devmem.c                             |  4 +--
 26 files changed, 63 insertions(+), 54 deletions(-)

diff --git a/drivers/accel/amdxdna/amdxdna_gem.c b/drivers/accel/amdxdna/amdxdna_gem.c
index 6253a720cc22..c679ec8230ff 100644
--- a/drivers/accel/amdxdna/amdxdna_gem.c
+++ b/drivers/accel/amdxdna/amdxdna_gem.c
@@ -898,7 +898,7 @@ amdxdna_gem_prime_import(struct drm_device *dev, struct dma_buf *dma_buf)
 		goto put_buf;
 	}
 
-	sgt = dma_buf_map_attachment_unlocked(attach, DMA_BIDIRECTIONAL);
+	sgt = dma_buf_sgt_map_attachment_unlocked(attach, DMA_BIDIRECTIONAL);
 	if (IS_ERR(sgt)) {
 		ret = PTR_ERR(sgt);
 		goto fail_detach;
diff --git a/drivers/accel/ivpu/ivpu_gem.c b/drivers/accel/ivpu/ivpu_gem.c
index 4f2005a8d496..0342a3fc9185 100644
--- a/drivers/accel/ivpu/ivpu_gem.c
+++ b/drivers/accel/ivpu/ivpu_gem.c
@@ -54,7 +54,8 @@ static struct sg_table *ivpu_bo_map_attachment(struct ivpu_device *vdev, struct
 
 	sgt = bo->base.sgt;
 	if (!sgt) {
-		sgt = dma_buf_map_attachment(bo->base.base.import_attach, DMA_BIDIRECTIONAL);
+		sgt = dma_buf_sgt_map_attachment(bo->base.base.import_attach,
+						 DMA_BIDIRECTIONAL);
 		if (IS_ERR(sgt))
 			ivpu_err(vdev, "Failed to map BO in IOMMU: %ld\n", PTR_ERR(sgt));
 		else
diff --git a/drivers/accel/qaic/qaic_data.c b/drivers/accel/qaic/qaic_data.c
index ef0351b6dc9b..b8de1a1e2ab9 100644
--- a/drivers/accel/qaic/qaic_data.c
+++ b/drivers/accel/qaic/qaic_data.c
@@ -863,7 +863,7 @@ struct drm_gem_object *qaic_gem_prime_import(struct drm_device *dev, struct dma_
 
 	drm_gem_private_object_init(dev, obj, attach->dmabuf->size);
 	/*
-	 * skipping dma_buf_map_attachment() as we do not know the direction
+	 * skipping dma_buf_sgt_map_attachment() as we do not know the direction
 	 * just yet. Once the direction is known in the subsequent IOCTL to
 	 * attach slicing, we can do it then.
 	 */
@@ -889,7 +889,7 @@ static int qaic_prepare_import_bo(struct qaic_bo *bo, struct qaic_attach_slice_h
 	struct sg_table *sgt;
 	int ret;
 
-	sgt = dma_buf_map_attachment(obj->import_attach, hdr->dir);
+	sgt = dma_buf_sgt_map_attachment(obj->import_attach, hdr->dir);
 	if (IS_ERR(sgt)) {
 		ret = PTR_ERR(sgt);
 		return ret;
diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
index dc65752fb0fa..209a1dca19d0 100644
--- a/drivers/dma-buf/dma-buf.c
+++ b/drivers/dma-buf/dma-buf.c
@@ -678,7 +678,7 @@ static struct file *dma_buf_getfile(size_t size, int flags)
  *
  * 3. Once the buffer is attached to all devices userspace can initiate DMA
  *    access to the shared buffer. In the kernel this is done by calling
- *    dma_buf_map_attachment() and dma_buf_unmap_attachment().
+ *    dma_buf_sgt_map_attachment() and dma_buf_unmap_attachment().
  *
  * 4. Once a driver is done with a shared buffer it needs to call
  *    dma_buf_detach() (after cleaning up any mappings) and then release the
@@ -958,7 +958,7 @@ dma_buf_pin_on_map(struct dma_buf_attachment *attach)
  *
  *     - dma_buf_pin()
  *     - dma_buf_unpin()
- *     - dma_buf_map_attachment()
+ *     - dma_buf_sgt_map_attachment()
  *     - dma_buf_unmap_attachment()
  *     - dma_buf_vmap()
  *     - dma_buf_vunmap()
@@ -976,7 +976,7 @@ dma_buf_pin_on_map(struct dma_buf_attachment *attach)
  *     - dma_buf_mmap()
  *     - dma_buf_begin_cpu_access()
  *     - dma_buf_end_cpu_access()
- *     - dma_buf_map_attachment_unlocked()
+ *     - dma_buf_sgt_map_attachment_unlocked()
  *     - dma_buf_unmap_attachment_unlocked()
  *     - dma_buf_vmap_unlocked()
  *     - dma_buf_vunmap_unlocked()
@@ -1302,7 +1302,7 @@ __dma_buf_sgt_map_attachment(struct dma_buf_attachment *attach,
 }
 
 /**
- * dma_buf_map_attachment - Returns the scatterlist table of the attachment;
+ * dma_buf_sgt_map_attachment - Returns the scatterlist table of the attachment;
  * mapped into _device_ address space. Is a wrapper for map_dma_buf() of the
  * dma_buf_ops.
  * @attach:	[in]	attachment whose scatterlist is to be returned
@@ -1322,8 +1322,8 @@ __dma_buf_sgt_map_attachment(struct dma_buf_attachment *attach,
  * Important: Dynamic importers must wait for the exclusive fence of the struct
  * dma_resv attached to the DMA-BUF first.
  */
-struct sg_table *dma_buf_map_attachment(struct dma_buf_attachment *attach,
-					enum dma_data_direction direction)
+struct sg_table *dma_buf_sgt_map_attachment(struct dma_buf_attachment *attach,
+					    enum dma_data_direction direction)
 {
 	struct sg_table *sg_table;
 	int ret;
@@ -1346,7 +1346,7 @@ struct sg_table *dma_buf_map_attachment(struct dma_buf_attachment *attach,
 
 	return sg_table;
 }
-EXPORT_SYMBOL_NS_GPL(dma_buf_map_attachment, "DMA_BUF");
+EXPORT_SYMBOL_NS_GPL(dma_buf_sgt_map_attachment, "DMA_BUF");
 
 /* &dma_buf_mapping_type.map / .unmap for the SGT type */
 struct dma_buf_mapping *dma_buf_sgt_type_map(struct dma_buf_attachment *attach,
@@ -1382,17 +1382,17 @@ void dma_buf_sgt_type_unmap(struct dma_buf_attachment *attach,
 }
 
 /**
- * dma_buf_map_attachment_unlocked - Returns the scatterlist table of the attachment;
+ * dma_buf_sgt_map_attachment_unlocked - Returns the scatterlist table of the attachment;
  * mapped into _device_ address space. Is a wrapper for map_dma_buf() of the
  * dma_buf_ops.
  * @attach:	[in]	attachment whose scatterlist is to be returned
  * @direction:	[in]	direction of DMA transfer
  *
- * Unlocked variant of dma_buf_map_attachment().
+ * Unlocked variant of dma_buf_sgt_map_attachment().
  */
 struct sg_table *
-dma_buf_map_attachment_unlocked(struct dma_buf_attachment *attach,
-				enum dma_data_direction direction)
+dma_buf_sgt_map_attachment_unlocked(struct dma_buf_attachment *attach,
+				    enum dma_data_direction direction)
 {
 	struct sg_table *sg_table;
 
@@ -1402,12 +1402,12 @@ dma_buf_map_attachment_unlocked(struct dma_buf_attachment *attach,
 		return ERR_PTR(-EINVAL);
 
 	dma_resv_lock(attach->dmabuf->resv, NULL);
-	sg_table = dma_buf_map_attachment(attach, direction);
+	sg_table = dma_buf_sgt_map_attachment(attach, direction);
 	dma_resv_unlock(attach->dmabuf->resv);
 
 	return sg_table;
 }
-EXPORT_SYMBOL_NS_GPL(dma_buf_map_attachment_unlocked, "DMA_BUF");
+EXPORT_SYMBOL_NS_GPL(dma_buf_sgt_map_attachment_unlocked, "DMA_BUF");
 
 /**
  * dma_buf_unmap_attachment - unmaps and decreases usecount of the buffer;might
@@ -1417,7 +1417,7 @@ EXPORT_SYMBOL_NS_GPL(dma_buf_map_attachment_unlocked, "DMA_BUF");
  * @sg_table:	[in]	scatterlist info of the buffer to unmap
  * @direction:  [in]    direction of DMA transfer
  *
- * This unmaps a DMA mapping for @attached obtained by dma_buf_map_attachment().
+ * This unmaps a DMA mapping for @attached obtained by dma_buf_sgt_map_attachment().
  */
 void dma_buf_unmap_attachment(struct dma_buf_attachment *attach,
 				struct sg_table *sg_table,
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
index 016957cac1f2..169e1b27ff8e 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
@@ -954,7 +954,8 @@ static int amdgpu_ttm_backend_bind(struct ttm_device *bdev,
 			struct sg_table *sgt;
 
 			attach = gtt->gobj->import_attach;
-			sgt = dma_buf_map_attachment(attach, DMA_BIDIRECTIONAL);
+			sgt = dma_buf_sgt_map_attachment(attach,
+							 DMA_BIDIRECTIONAL);
 			if (IS_ERR(sgt))
 				return PTR_ERR(sgt);
 
diff --git a/drivers/gpu/drm/armada/armada_gem.c b/drivers/gpu/drm/armada/armada_gem.c
index 5cea1eab6e5c..506bc82f20d6 100644
--- a/drivers/gpu/drm/armada/armada_gem.c
+++ b/drivers/gpu/drm/armada/armada_gem.c
@@ -531,7 +531,7 @@ armada_gem_prime_import(struct drm_device *dev, struct dma_buf *buf)
 	get_dma_buf(buf);
 
 	/*
-	 * Don't call dma_buf_map_attachment() here - it maps the
+	 * Don't call dma_buf_sgt_map_attachment() here - it maps the
 	 * scatterlist immediately for DMA, and this is not always
 	 * an appropriate thing to do.
 	 */
@@ -542,20 +542,22 @@ int armada_gem_map_import(struct armada_gem_object *dobj)
 {
 	int ret;
 
-	dobj->sgt = dma_buf_map_attachment_unlocked(dobj->obj.import_attach,
-						    DMA_TO_DEVICE);
+	dobj->sgt = dma_buf_sgt_map_attachment_unlocked(dobj->obj.import_attach,
+							DMA_TO_DEVICE);
 	if (IS_ERR(dobj->sgt)) {
 		ret = PTR_ERR(dobj->sgt);
 		dobj->sgt = NULL;
-		DRM_ERROR("dma_buf_map_attachment() error: %d\n", ret);
+		DRM_ERROR("dma_buf_sgt_map_attachment() error: %d\n", ret);
 		return ret;
 	}
 	if (dobj->sgt->nents > 1) {
-		DRM_ERROR("dma_buf_map_attachment() returned an (unsupported) scattered list\n");
+		DRM_ERROR(
+			"dma_buf_sgt_map_attachment() returned an (unsupported) scattered list\n");
 		return -EINVAL;
 	}
 	if (sg_dma_len(dobj->sgt->sgl) < dobj->obj.size) {
-		DRM_ERROR("dma_buf_map_attachment() returned a small buffer\n");
+		DRM_ERROR(
+			"dma_buf_sgt_map_attachment() returned a small buffer\n");
 		return -EINVAL;
 	}
 	dobj->dev_addr = sg_dma_address(dobj->sgt->sgl);
diff --git a/drivers/gpu/drm/drm_prime.c b/drivers/gpu/drm/drm_prime.c
index 7792caf87883..330b64b3324a 100644
--- a/drivers/gpu/drm/drm_prime.c
+++ b/drivers/gpu/drm/drm_prime.c
@@ -1005,7 +1005,7 @@ struct drm_gem_object *drm_gem_prime_import_dev(struct drm_device *dev,
 
 	get_dma_buf(dma_buf);
 
-	sgt = dma_buf_map_attachment_unlocked(attach, DMA_BIDIRECTIONAL);
+	sgt = dma_buf_sgt_map_attachment_unlocked(attach, DMA_BIDIRECTIONAL);
 	if (IS_ERR(sgt)) {
 		ret = PTR_ERR(sgt);
 		goto fail_detach;
diff --git a/drivers/gpu/drm/i915/gem/i915_gem_dmabuf.c b/drivers/gpu/drm/i915/gem/i915_gem_dmabuf.c
index 5333e77e62e0..04c7b9a97681 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_dmabuf.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_dmabuf.c
@@ -242,8 +242,8 @@ static int i915_gem_object_get_pages_dmabuf(struct drm_i915_gem_object *obj)
 
 	assert_object_held(obj);
 
-	sgt = dma_buf_map_attachment(obj->base.import_attach,
-				     DMA_BIDIRECTIONAL);
+	sgt = dma_buf_sgt_map_attachment(obj->base.import_attach,
+					 DMA_BIDIRECTIONAL);
 	if (IS_ERR(sgt))
 		return PTR_ERR(sgt);
 
diff --git a/drivers/gpu/drm/i915/gem/selftests/i915_gem_dmabuf.c b/drivers/gpu/drm/i915/gem/selftests/i915_gem_dmabuf.c
index 2fda549dd82d..fcfa819caa38 100644
--- a/drivers/gpu/drm/i915/gem/selftests/i915_gem_dmabuf.c
+++ b/drivers/gpu/drm/i915/gem/selftests/i915_gem_dmabuf.c
@@ -293,7 +293,8 @@ static int igt_dmabuf_import_same_driver(struct drm_i915_private *i915,
 		goto out_import;
 	}
 
-	st = dma_buf_map_attachment_unlocked(import_attach, DMA_BIDIRECTIONAL);
+	st = dma_buf_sgt_map_attachment_unlocked(import_attach,
+						 DMA_BIDIRECTIONAL);
 	if (IS_ERR(st)) {
 		err = PTR_ERR(st);
 		goto out_detach;
diff --git a/drivers/gpu/drm/omapdrm/omap_gem_dmabuf.c b/drivers/gpu/drm/omapdrm/omap_gem_dmabuf.c
index 23beaeefab67..569ee2d3ab6f 100644
--- a/drivers/gpu/drm/omapdrm/omap_gem_dmabuf.c
+++ b/drivers/gpu/drm/omapdrm/omap_gem_dmabuf.c
@@ -121,7 +121,7 @@ struct drm_gem_object *omap_gem_prime_import(struct drm_device *dev,
 
 	get_dma_buf(dma_buf);
 
-	sgt = dma_buf_map_attachment_unlocked(attach, DMA_TO_DEVICE);
+	sgt = dma_buf_sgt_map_attachment_unlocked(attach, DMA_TO_DEVICE);
 	if (IS_ERR(sgt)) {
 		ret = PTR_ERR(sgt);
 		goto fail_detach;
diff --git a/drivers/gpu/drm/tegra/gem.c b/drivers/gpu/drm/tegra/gem.c
index feb783ceb0d1..fcb9308f49f0 100644
--- a/drivers/gpu/drm/tegra/gem.c
+++ b/drivers/gpu/drm/tegra/gem.c
@@ -87,7 +87,8 @@ static struct host1x_bo_mapping *tegra_bo_pin(struct device *dev, struct host1x_
 			goto free;
 		}
 
-		map->sgt = dma_buf_map_attachment_unlocked(map->attach, direction);
+		map->sgt = dma_buf_sgt_map_attachment_unlocked(map->attach,
+							       direction);
 		if (IS_ERR(map->sgt)) {
 			dma_buf_detach(buf, map->attach);
 			err = PTR_ERR(map->sgt);
@@ -480,7 +481,8 @@ static struct tegra_bo *tegra_bo_import(struct drm_device *drm,
 			goto free;
 		}
 
-		bo->sgt = dma_buf_map_attachment_unlocked(attach, DMA_TO_DEVICE);
+		bo->sgt = dma_buf_sgt_map_attachment_unlocked(attach,
+							      DMA_TO_DEVICE);
 		if (IS_ERR(bo->sgt)) {
 			err = PTR_ERR(bo->sgt);
 			goto detach;
diff --git a/drivers/gpu/drm/virtio/virtgpu_prime.c b/drivers/gpu/drm/virtio/virtgpu_prime.c
index 3d5203ac19b6..de69590b5076 100644
--- a/drivers/gpu/drm/virtio/virtgpu_prime.c
+++ b/drivers/gpu/drm/virtio/virtgpu_prime.c
@@ -164,7 +164,7 @@ int virtgpu_dma_buf_import_sgt(struct virtio_gpu_mem_entry **ents,
 	if (ret <= 0)
 		return ret < 0 ? ret : -ETIMEDOUT;
 
-	sgt = dma_buf_map_attachment(attach, DMA_BIDIRECTIONAL);
+	sgt = dma_buf_sgt_map_attachment(attach, DMA_BIDIRECTIONAL);
 	if (IS_ERR(sgt))
 		return PTR_ERR(sgt);
 
diff --git a/drivers/gpu/drm/xe/xe_bo.c b/drivers/gpu/drm/xe/xe_bo.c
index b4921a627ff3..4d93b8926ed6 100644
--- a/drivers/gpu/drm/xe/xe_bo.c
+++ b/drivers/gpu/drm/xe/xe_bo.c
@@ -771,7 +771,7 @@ static int xe_bo_move_dmabuf(struct ttm_buffer_object *ttm_bo,
 		ttm_bo->sg = NULL;
 	}
 
-	sg = dma_buf_map_attachment(attach, DMA_BIDIRECTIONAL);
+	sg = dma_buf_sgt_map_attachment(attach, DMA_BIDIRECTIONAL);
 	if (IS_ERR(sg))
 		return PTR_ERR(sg);
 
diff --git a/drivers/iio/industrialio-buffer.c b/drivers/iio/industrialio-buffer.c
index a00985c92251..619181968ff9 100644
--- a/drivers/iio/industrialio-buffer.c
+++ b/drivers/iio/industrialio-buffer.c
@@ -1730,7 +1730,7 @@ static int iio_buffer_attach_dmabuf(struct iio_dev_buffer_pair *ib,
 	priv->dir = buffer->direction == IIO_BUFFER_DIRECTION_IN
 		? DMA_FROM_DEVICE : DMA_TO_DEVICE;
 
-	priv->sgt = dma_buf_map_attachment(attach, priv->dir);
+	priv->sgt = dma_buf_sgt_map_attachment(attach, priv->dir);
 	if (IS_ERR(priv->sgt)) {
 		err = PTR_ERR(priv->sgt);
 		dev_err(&indio_dev->dev, "Unable to map attachment: %d\n", err);
diff --git a/drivers/infiniband/core/umem_dmabuf.c b/drivers/infiniband/core/umem_dmabuf.c
index 39b5564a4c35..dd584f8dcd1c 100644
--- a/drivers/infiniband/core/umem_dmabuf.c
+++ b/drivers/infiniband/core/umem_dmabuf.c
@@ -29,8 +29,8 @@ int ib_umem_dmabuf_map_pages(struct ib_umem_dmabuf *umem_dmabuf)
 	if (umem_dmabuf->sgt)
 		goto wait_fence;
 
-	sgt = dma_buf_map_attachment(umem_dmabuf->attach,
-				     DMA_BIDIRECTIONAL);
+	sgt = dma_buf_sgt_map_attachment(umem_dmabuf->attach,
+					 DMA_BIDIRECTIONAL);
 	if (IS_ERR(sgt))
 		return PTR_ERR(sgt);
 
diff --git a/drivers/media/common/videobuf2/videobuf2-core.c b/drivers/media/common/videobuf2/videobuf2-core.c
index b0a6084f1757..5cd53e06da0b 100644
--- a/drivers/media/common/videobuf2/videobuf2-core.c
+++ b/drivers/media/common/videobuf2/videobuf2-core.c
@@ -1464,7 +1464,7 @@ static int __prepare_dmabuf(struct vb2_buffer *vb)
 			vb->planes[plane].mem_priv = mem_priv;
 
 			/*
-			 * This pins the buffer(s) with dma_buf_map_attachment()). It's done
+			 * This pins the buffer(s) with dma_buf_sgt_map_attachment()). It's done
 			 * here instead just before the DMA, while queueing the buffer(s) so
 			 * userspace knows sooner rather than later if the dma-buf map fails.
 			 */
diff --git a/drivers/media/common/videobuf2/videobuf2-dma-contig.c b/drivers/media/common/videobuf2/videobuf2-dma-contig.c
index 536f839258c6..0ce643940898 100644
--- a/drivers/media/common/videobuf2/videobuf2-dma-contig.c
+++ b/drivers/media/common/videobuf2/videobuf2-dma-contig.c
@@ -706,7 +706,7 @@ static int vb2_dc_map_dmabuf(void *mem_priv)
 	}
 
 	/* get the associated scatterlist for this buffer */
-	sgt = dma_buf_map_attachment_unlocked(buf->db_attach, buf->dma_dir);
+	sgt = dma_buf_sgt_map_attachment_unlocked(buf->db_attach, buf->dma_dir);
 	if (IS_ERR(sgt)) {
 		pr_err("Error getting dmabuf scatterlist\n");
 		return -EINVAL;
diff --git a/drivers/media/common/videobuf2/videobuf2-dma-sg.c b/drivers/media/common/videobuf2/videobuf2-dma-sg.c
index fba2027e6e8d..17191373c69c 100644
--- a/drivers/media/common/videobuf2/videobuf2-dma-sg.c
+++ b/drivers/media/common/videobuf2/videobuf2-dma-sg.c
@@ -569,7 +569,7 @@ static int vb2_dma_sg_map_dmabuf(void *mem_priv)
 	}
 
 	/* get the associated scatterlist for this buffer */
-	sgt = dma_buf_map_attachment_unlocked(buf->db_attach, buf->dma_dir);
+	sgt = dma_buf_sgt_map_attachment_unlocked(buf->db_attach, buf->dma_dir);
 	if (IS_ERR(sgt)) {
 		pr_err("Error getting dmabuf scatterlist\n");
 		return -EINVAL;
diff --git a/drivers/media/platform/nvidia/tegra-vde/dmabuf-cache.c b/drivers/media/platform/nvidia/tegra-vde/dmabuf-cache.c
index 7752064be783..8f3443fa0eb5 100644
--- a/drivers/media/platform/nvidia/tegra-vde/dmabuf-cache.c
+++ b/drivers/media/platform/nvidia/tegra-vde/dmabuf-cache.c
@@ -102,7 +102,7 @@ int tegra_vde_dmabuf_cache_map(struct tegra_vde *vde,
 		goto err_unlock;
 	}
 
-	sgt = dma_buf_map_attachment_unlocked(attachment, dma_dir);
+	sgt = dma_buf_sgt_map_attachment_unlocked(attachment, dma_dir);
 	if (IS_ERR(sgt)) {
 		dev_err(dev, "Failed to get dmabufs sg_table\n");
 		err = PTR_ERR(sgt);
diff --git a/drivers/misc/fastrpc.c b/drivers/misc/fastrpc.c
index 85fed3a12f9c..fce849417eb7 100644
--- a/drivers/misc/fastrpc.c
+++ b/drivers/misc/fastrpc.c
@@ -911,7 +911,8 @@ static int fastrpc_map_attach(struct fastrpc_user *fl, int fd,
 		goto attach_err;
 	}
 
-	table = dma_buf_map_attachment_unlocked(map->attach, DMA_BIDIRECTIONAL);
+	table = dma_buf_sgt_map_attachment_unlocked(map->attach,
+						    DMA_BIDIRECTIONAL);
 	if (IS_ERR(table)) {
 		err = PTR_ERR(table);
 		goto map_err;
diff --git a/drivers/usb/gadget/function/f_fs.c b/drivers/usb/gadget/function/f_fs.c
index 09680534623e..fe3c43ba72c6 100644
--- a/drivers/usb/gadget/function/f_fs.c
+++ b/drivers/usb/gadget/function/f_fs.c
@@ -1567,7 +1567,7 @@ static int ffs_dmabuf_attach(struct file *file, int fd)
 	if (err)
 		goto err_free_priv;
 
-	sg_table = dma_buf_map_attachment(attach, dir);
+	sg_table = dma_buf_sgt_map_attachment(attach, dir);
 	dma_resv_unlock(dmabuf->resv);
 
 	if (IS_ERR(sg_table)) {
diff --git a/drivers/xen/gntdev-dmabuf.c b/drivers/xen/gntdev-dmabuf.c
index 028cd7295fd7..3bb05596920e 100644
--- a/drivers/xen/gntdev-dmabuf.c
+++ b/drivers/xen/gntdev-dmabuf.c
@@ -588,7 +588,7 @@ dmabuf_imp_to_refs(struct gntdev_dmabuf_priv *priv, struct device *dev,
 
 	gntdev_dmabuf->u.imp.attach = attach;
 
-	sgt = dma_buf_map_attachment_unlocked(attach, DMA_BIDIRECTIONAL);
+	sgt = dma_buf_sgt_map_attachment_unlocked(attach, DMA_BIDIRECTIONAL);
 	if (IS_ERR(sgt)) {
 		ret = ERR_CAST(sgt);
 		goto fail_detach;
diff --git a/include/linux/dma-buf-mapping.h b/include/linux/dma-buf-mapping.h
index 91a55cbe0bb4..02d79d5615b5 100644
--- a/include/linux/dma-buf-mapping.h
+++ b/include/linux/dma-buf-mapping.h
@@ -171,7 +171,7 @@ void dma_buf_sgt_type_unmap(struct dma_buf_attachment *attach,
  *
  * When this type is matched the map/unmap functions are:
  *
- *  dma_buf_map_attachment()
+ *  dma_buf_sgt_map_attachment()
  *  dma_buf_unmap_attachment()
  *
  * The struct sg_table returned by those functions has only the DMA portions
@@ -206,7 +206,7 @@ struct dma_buf_mapping_sgt_exp_ops {
 	/**
 	 * @map_dma_buf:
 	 *
-	 * This is called by dma_buf_map_attachment() and is used to map a
+	 * This is called by dma_buf_sgt_map_attachment() and is used to map a
 	 * shared &dma_buf into device address space, and it is mandatory. It
 	 * can only be called if @attach has been called successfully.
 	 *
diff --git a/include/linux/dma-buf.h b/include/linux/dma-buf.h
index 77a18b9817ac..ee6c97a5cecd 100644
--- a/include/linux/dma-buf.h
+++ b/include/linux/dma-buf.h
@@ -515,7 +515,7 @@ struct dma_buf_attach_ops {
  *
  * An attachment is created by calling dma_buf_attach(), and released again by
  * calling dma_buf_detach(). The DMA mapping itself needed to initiate a
- * transfer is created by dma_buf_map_attachment() and freed again by calling
+ * transfer is created by dma_buf_sgt_map_attachment() and freed again by calling
  * dma_buf_unmap_attachment().
  */
 struct dma_buf_attachment {
@@ -614,8 +614,8 @@ void dma_buf_fd_install(struct dma_buf *dmabuf, int fd);
 struct dma_buf *dma_buf_get(int fd);
 void dma_buf_put(struct dma_buf *dmabuf);
 
-struct sg_table *dma_buf_map_attachment(struct dma_buf_attachment *,
-					enum dma_data_direction);
+struct sg_table *dma_buf_sgt_map_attachment(struct dma_buf_attachment *,
+					    enum dma_data_direction);
 void dma_buf_unmap_attachment(struct dma_buf_attachment *, struct sg_table *,
 				enum dma_data_direction);
 void dma_buf_invalidate_mappings(struct dma_buf *dma_buf);
@@ -625,8 +625,8 @@ int dma_buf_begin_cpu_access(struct dma_buf *dma_buf,
 int dma_buf_end_cpu_access(struct dma_buf *dma_buf,
 			   enum dma_data_direction dir);
 struct sg_table *
-dma_buf_map_attachment_unlocked(struct dma_buf_attachment *attach,
-				enum dma_data_direction direction);
+dma_buf_sgt_map_attachment_unlocked(struct dma_buf_attachment *attach,
+				    enum dma_data_direction direction);
 void dma_buf_unmap_attachment_unlocked(struct dma_buf_attachment *attach,
 				       struct sg_table *sg_table,
 				       enum dma_data_direction direction);
diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 86d580d4410d..3f8be77a50dc 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -182,7 +182,8 @@ static int io_import_dmabuf(struct io_zcrx_ifq *ifq,
 		goto err;
 	}
 
-	mem->sgt = dma_buf_map_attachment_unlocked(mem->attach, DMA_FROM_DEVICE);
+	mem->sgt = dma_buf_sgt_map_attachment_unlocked(mem->attach,
+						       DMA_FROM_DEVICE);
 	if (IS_ERR(mem->sgt)) {
 		ret = PTR_ERR(mem->sgt);
 		mem->sgt = NULL;
diff --git a/net/core/devmem.c b/net/core/devmem.c
index f4d60654ce7f..86b3c54933bb 100644
--- a/net/core/devmem.c
+++ b/net/core/devmem.c
@@ -241,8 +241,8 @@ net_devmem_bind_dmabuf(struct net_device *dev, void *vdev,
 		goto err_exit_ref;
 	}
 
-	binding->sgt = dma_buf_map_attachment_unlocked(binding->attachment,
-						       direction);
+	binding->sgt = dma_buf_sgt_map_attachment_unlocked(binding->attachment,
+							   direction);
 	if (IS_ERR(binding->sgt)) {
 		err = PTR_ERR(binding->sgt);
 		NL_SET_ERR_MSG(extack, "Failed to map dmabuf attachment");
-- 
2.54.0

