Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.195.53
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792993110;
	b=Jx+9CTl7/IKSePcq35UJcsHiQC1Os8QZt3/lHEmIUwS/01B0pTn/i4unD+/mrenDeXcv
	 hUmA1O8F96iPU40S+nDEiSfNVpwMvyK4KhjrKRUFr3yu/ST2Qk72OE+VboLAYlUXhhp2z
	 Ka1Di8zgOIxZX1nohPJNh/uxlRy4v30lzppK5ua+zCam83J0gvWfgfslO+u5aqNMdoxNK
	 oTmsOLIQbwlph+7zSpQlmkv8aQUyjlTbrWE6r66jSJ+p10oYrjBZr+9G3cRIDfxG+LarJ
	 OGJMOt/IJt0GqFyQxsHMZ7hp8ixIRIsQ+yiN9rOwkOPaCUadY0sRT5ex00fFeKalmKg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792993110;
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
	bh=VHPGAoGgdSJ7Duqi7J96CXhDkAIaHCziOBi6V5n0vrQ=;
	b=L+USss7KrudvZCaGEyZ2puXzoOQQy1jvCh7PPkBE4opyo4aXmFYTKmJGKXPgnOSt81fI
	 a3kpOWJ/yIOGx93z/W9yMswrHFl0r5qngI2t5XE1WL3u0eH5trJwcV/kBnlVANfcvpiY2
	 waAcgRFUCXJjron1PRp8vYakEty7X0h9RuD8RM9plxfsIaJ0OXawWPjsaeko3LH3zwfcj
	 9HbmDFiI/FOBXie6OYSchG6k+umOO66vXiILggMeLPTiyGT0NdTukEtULFEZ2eA7hKWYs
	 JM65CScVOSznoq+0Xh+JSpFKLR0tnGNoHLV4yFrWpRzDz7KM5SpHe/i+HjJaZfKpvFA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=aZvuYwCy;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.195.53
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012053.outbound.protection.outlook.com [40.93.195.53])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A97F60A2604;
	Mon, 26 Oct 2026 05:38:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9A97F60A2604
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=aZvuYwCy
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cO4tnwSksAKMtRhy/Delz9mqrmkrAvk4qgGdBIwyWRWyy95vKxwKd67k23nadUw+HmCb69GxX1upWLfciaCF+xIz3+zICWUA79iDH2pYW+AptMBaIg2ssW83+l77Bsl3hWiecExfQdqje/a3GRaQNG9P+74aodaBhnKaFLVtFssr+sstBAGYCxOcbjQaQFu9GDiVwRX+DZFaKCxfLKQm9M+5v+5j1qdUh8xTvy1rG4NlCZGPRq6dk507uyY5KdVsPw9LD7QESthBBFklxwmuFIVw0IM+iFTZjBCIFXvLNfT4JTuEwnApgW99IZ3R4NVcqpZ25p/QF8bz7xPSAgtfLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VHPGAoGgdSJ7Duqi7J96CXhDkAIaHCziOBi6V5n0vrQ=;
 b=smT85LsDHmYnn39T0h0RPmHcaaVlELYe+sLIenkDaEGSAhoOpUAd5RBILvHwrOoNkuD2vuyLiEwhPmIGFz3rh+roeGvFlqiEfZLnDYpFwHVmglunT5+txSpl2ln9Khq3xCXHOJ0cKTq8568tx/D8BUL2o+e0C5nJghTKxk31dqzOrp1HtHX7+3MX3vANZ0Y49fzKxE5fLMVqcc/SbmZOUi7u+ytXuJAzwGPOKcVs2Vm7kHbxTZZ1srrQM926ol0GyqZ6rfaja+26Fdr2Z9Yu6iM5LUcJqiUlSrPU7S8ufeZ41cLypSrjENfnuqITr+UOjZKSJYR2WZcndYlrdDHV7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VHPGAoGgdSJ7Duqi7J96CXhDkAIaHCziOBi6V5n0vrQ=;
 b=aZvuYwCyL89iTJSYsd29MCLZPJDupFmGcrcWJRYt+eJBbuUbLgcbOMf5zzHEbWLOyE/i1kt0mcd6Nom3GScdHpvcCZAqErR0fByYRM7jiO1+5cHLYXpJoTL2sRl5qOk4FOsWX420IDcxUSwfYE6NxLe3R2kg4+qYKbIWZskMlmiqbeT+Qlk0hu7NMRdG24h4oRrWFTQf6TVTl30zJnziKExofrUS56UYVLS41FPtk6tnIztgb11wEP/Ph0i4yV4mdAAGQ6EfgSUz9++joheTMjFGV6FXmUlL/ZySf40lijpF5UWjyJVgtvbMl/Vy7s9g6tnNZ9ZK8mMKwtR+nItIRw==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SA3PR12MB598757.namprd12.prod.outlook.com
 (2603:10b6:806:52d::14) by SJ0PR12MB6967.namprd12.prod.outlook.com
 (2603:10b6:a03:44b::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Mon, 26 Oct
 2026 05:38:25 +0000
Received: from SA3PR12MB598757.namprd12.prod.outlook.com
 ([fe80::e206:100:5946:a777]) by SA3PR12MB598757.namprd12.prod.outlook.com
 ([fe80::e206:100:5946:a777%5]) with mapi id 15.21.0546.021; Mon, 26 Oct 2026
 05:38:25 +0000
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
Subject: [PATCH 22/26] treewide: Rename dma_buf_unmap_attachment(_unlocked) to dma_buf_sgt_*
Date: Mon, 26 Oct 2026 16:36:13 +1100
Message-ID: <20261026053623.202642-23-apopple@nvidia.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261026053623.202642-1-apopple@nvidia.com>
References: <20261026053623.202642-1-apopple@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SY5P300CA0091.AUSP300.PROD.OUTLOOK.COM
 (2603:10c6:10:248::9) To SA3PR12MB598757.namprd12.prod.outlook.com
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
X-MS-Office365-Filtering-Correlation-Id: 772c7939-2145-4a1d-6b8b-08df33235b04
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|23010399003|366016|18002099003|22082099003|6133799003|56012099006|5023799004|11063799006|261022075727099003|261021121427099003|261021123027099003|10067099003|261009221727099003|261009220027099003|261009221227099003|261009223327099003|261009223027099003|261022105027099003;
X-Microsoft-Antispam-Message-Info:
	MmZy+ofMpkcmEylBS5T2CURZHxIgrHuPpBvL8KgWgQSAA3uY1IvirsdVY8IK6UpTdqaUGL6bTD+0Usx6eWeu5T6IXR9JqoZH89jc9uc7LoUZeFoucM6cgJ6ndndWfHuiBCnVWua8+Mri7af+oziyjiBVcFOLxSsNIe/APrSMWvK74WA4MvbXhfGoFZFyL0sTvCRSN6e9Eli3h+Wl79nZNOY8plwvV5S5ZRqj8t+QXDMzPxd/Y6h4JWRt55OnuRM9UFxgXS56L8AbmbRV4xsSRXyP8VSF3sV9LB3d/c9k+kJGVmT6kpjU4FQ9RA8QOwApvvDmdovkvOCojNwEI5TRN9wg++rgsg32QFYJbFtMYChyYkJwWpuAcF9x2RaL2v6+lDtOgTjVFoKQy3UtcDcl4ax8oRbMsG8S1uLJLl7Xlzo4fm/KdeOSWUkHk470tdgst0xmbA9/VIsPRHVdDjEXe+SbeKm2Zs0syl/dfEpwS8j1/wmt6gAJZqnE4Cvd1OS6khPiFEXOn+H5INoxP3nSwaDDxInXzJNAxSJCoHkbE3jnPihOUd/IWhwiOL0lwzHmDwPFtPveOdHo75TabSHrNuRlEvTDepiybB4f+QP4ccOxSh/ZNRmmgQs5hHRmwSSZ5+L4jGHv/9sHlIraYYQNUl9DiBd1Zvozu3U9BHEZync=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA3PR12MB598757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(23010399003)(366016)(18002099003)(22082099003)(6133799003)(56012099006)(5023799004)(11063799006)(261022075727099003)(261021121427099003)(261021123027099003)(10067099003)(261009221727099003)(261009220027099003)(261009221227099003)(261009223327099003)(261009223027099003)(261022105027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?aAJ7yilszx/SJ4AI85sr7Omh/dvs73v9iqyVfmUim5JBxDlSeH6m3jYCQbcw?=
 =?us-ascii?Q?Xay4ZbsWUN16cf5yKTF33tS8lHctrXel6MgF7lQ+OhE3EZieugC0K2ZoT0GY?=
 =?us-ascii?Q?wd25HDlBKCYOEx6GNKuSL3ISduAzd4sBpXyxlFORPglZwHutp+Kn0xiHVsKa?=
 =?us-ascii?Q?JJ7Xqeisi/OljzGxQGvjPMIA5lxI1QVWPAolKs84WhJh4T3QdSnn+ENsa3YO?=
 =?us-ascii?Q?A7Ddt4zloNGefa/kBGfmxA9d3Obq7Ot9MWrO88Hxu2VahykZXZ4NXA3IAkRp?=
 =?us-ascii?Q?1L8scSdSgUdtzbvY58HZQ96EbCv8umEoLVw+3JzgcvEVh4ub4go4uKyrko1N?=
 =?us-ascii?Q?ulVbBO+k6LgtBZudxmn5D8YwGdB80tdVjkoTEkJ1R8rs6n8UuKdrbD/D866K?=
 =?us-ascii?Q?ZqDywXBTyGLJvmDxwY3fcXA9juaLbNTbLDWS2KaLgi6I5q5HCb/8fJ/KnvFf?=
 =?us-ascii?Q?iDGMbl189tDOyzZPkp+DesKTNUQJSAgUV0Ig1wYDMFSgkEmiflLiueV6+LOG?=
 =?us-ascii?Q?nx2j6T8/IA/VUDrfJGzr7w+yAilnb27pr8Ici8ADikL7gEZf6AmYspIeBg48?=
 =?us-ascii?Q?AEqzsjcIpPx4vn5rSp+cDEeJRqGG2bpeeZz2elAXlPI8PX7VMM4A/csGIyL4?=
 =?us-ascii?Q?DKTydR/hZ/FDmo4NXo7m51HKp98TCSsVq8Dmaux+99CUfjJEDWPwy+nTM5w3?=
 =?us-ascii?Q?ZtYfkeXPVvLyxjgdBzIAPcbhEaJ259fu0B23uBqjy0v3jF/Ujglisk7Evi7d?=
 =?us-ascii?Q?0S/0HVo6I6E3n7JGJ08PkH5YGX9i96/wHelGqvRTRK8AaFDaxFvAixa9LJzy?=
 =?us-ascii?Q?GfDF3sRb1AfJYvAsL9WtWtqE3/iypwKOh0P35bGWUtIZDpJ5Ph6g82qZb0yc?=
 =?us-ascii?Q?ankhF7AVIV7iPLZt83c1dPQverw7+ywyqqliVj3fnOKFqoLSpOBtqDjUy37k?=
 =?us-ascii?Q?qPrG7/8JGxhNoPvTtfP8Gun8ha6BNfK/vbqI6AE0DWultKe7/lJ4wAFD+jX8?=
 =?us-ascii?Q?99x6gJ3VXrpcmTwUhBb3Q5o7qshqrUcHZ3A3XVM23U7D6jB2iGRDn69p/BPO?=
 =?us-ascii?Q?Qz+KAiwCyREDRnP2HjYvIOQmeady2B7C25knKF83qfJmj7k65cNE8K1h7Wjk?=
 =?us-ascii?Q?7kRXtar9KKFb4KfERqCY1zYD0bexMJVIB9HIWKETOGhx/eidOen/0XihXlNN?=
 =?us-ascii?Q?CQCsN5zym8CE1DMLyY/QwJ150RC7VA0ugCVgm/PJUhWhOI32GOqLzG30LuPz?=
 =?us-ascii?Q?e6yrBS4h/kCe7nCpDqJbMgi/w6CqwXrdXHYOl0dqqGSUhVeHBuTuBegYFDDO?=
 =?us-ascii?Q?hvLFjcYTj38MP4H+olQ4PRqn9eMgd6YXZnpxH6Z7MmDulEAqiNEaNXpDc8HC?=
 =?us-ascii?Q?Po/8l6Nh4UGuBHi1PvbyKDnZJ5rlk1a5twZFHgD4PADTW9XR2ezgjAJeZ7+C?=
 =?us-ascii?Q?FHQGxQ8CEb++jKN/Gnfg3GCERnPHIzDI6msBhZuUzGbu7bMY+k6theaVnDdG?=
 =?us-ascii?Q?YuQhUNGP4f8E56DQ26ohQDzz2lxe0TCtaN13dYqxQq72G4DnJI4Eb3JQzTPN?=
 =?us-ascii?Q?r5NOcj2S4c4UhyJgv6G+YgMEHNd64VSKlVvdgRgisSICLZZ6r3J0WNvoJkWB?=
 =?us-ascii?Q?jjsBJD2Q1LQohrFBF3me1Ge308kLFKOXyICOnePwUdUbe1uKJ1zctZ9D9PH+?=
 =?us-ascii?Q?CD+UjAIysuVdCH7bQAm/TaAnUYoz4U7uDDB9lMy134j6c3otdarpDN+ePpcT?=
 =?us-ascii?Q?sFlI/RT2cQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 772c7939-2145-4a1d-6b8b-08df33235b04
X-MS-Exchange-CrossTenant-AuthSource: SA3PR12MB598757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2026 05:38:25.5924
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XIeEHPz7L818z1ImUkMWyZjN6wg5b8LXHvNkbzsIenqcyjSCc/j07vU/5mMmyzyDJd69F8QwXPiPuUN83CO80A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6967

From: Jason Gunthorpe <jgg@nvidia.com>

This unmap function only works with SGT importers.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/accel/amdxdna/amdxdna_gem.c           |  5 +--
 drivers/accel/ivpu/ivpu_gem.c                 |  5 +--
 drivers/accel/qaic/qaic_data.c                |  2 +-
 drivers/dma-buf/dma-buf.c                     | 34 +++++++++----------
 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c       |  3 +-
 drivers/gpu/drm/armada/armada_gem.c           |  5 +--
 drivers/gpu/drm/drm_prime.c                   |  5 +--
 drivers/gpu/drm/i915/gem/i915_gem_dmabuf.c    |  4 +--
 drivers/gpu/drm/i915/gem/i915_gem_object.c    |  2 +-
 .../drm/i915/gem/selftests/i915_gem_dmabuf.c  |  3 +-
 drivers/gpu/drm/omapdrm/omap_gem_dmabuf.c     |  2 +-
 drivers/gpu/drm/tegra/gem.c                   | 11 +++---
 drivers/gpu/drm/virtio/virtgpu_prime.c        |  6 ++--
 drivers/gpu/drm/xe/xe_bo.c                    | 16 +++++----
 drivers/iio/industrialio-buffer.c             |  4 +--
 drivers/infiniband/core/umem_dmabuf.c         |  4 +--
 .../common/videobuf2/videobuf2-dma-contig.c   |  7 ++--
 .../media/common/videobuf2/videobuf2-dma-sg.c |  3 +-
 .../platform/nvidia/tegra-vde/dmabuf-cache.c  |  5 +--
 drivers/misc/fastrpc.c                        |  4 +--
 drivers/usb/gadget/function/f_fs.c            |  2 +-
 drivers/xen/gntdev-dmabuf.c                   |  6 ++--
 include/linux/dma-buf-mapping.h               |  4 +--
 include/linux/dma-buf.h                       | 12 +++----
 io_uring/zcrx.c                               |  4 +--
 net/core/devmem.c                             |  8 ++---
 26 files changed, 89 insertions(+), 77 deletions(-)

diff --git a/drivers/accel/amdxdna/amdxdna_gem.c b/drivers/accel/amdxdna/amdxdna_gem.c
index c679ec8230ff..a7e759bb0460 100644
--- a/drivers/accel/amdxdna/amdxdna_gem.c
+++ b/drivers/accel/amdxdna/amdxdna_gem.c
@@ -592,7 +592,8 @@ static struct dma_buf *amdxdna_gem_prime_export(struct drm_gem_object *gobj, int
 
 static void amdxdna_imported_obj_free(struct amdxdna_gem_obj *abo)
 {
-	dma_buf_unmap_attachment_unlocked(abo->attach, abo->base.sgt, DMA_BIDIRECTIONAL);
+	dma_buf_sgt_unmap_attachment_unlocked(abo->attach, abo->base.sgt,
+					      DMA_BIDIRECTIONAL);
 	dma_buf_detach(abo->dma_buf, abo->attach);
 	dma_buf_put(abo->dma_buf);
 	drm_gem_object_release(to_gobj(abo));
@@ -919,7 +920,7 @@ amdxdna_gem_prime_import(struct drm_device *dev, struct dma_buf *dma_buf)
 	return gobj;
 
 fail_unmap:
-	dma_buf_unmap_attachment_unlocked(attach, sgt, DMA_BIDIRECTIONAL);
+	dma_buf_sgt_unmap_attachment_unlocked(attach, sgt, DMA_BIDIRECTIONAL);
 fail_detach:
 	dma_buf_detach(dma_buf, attach);
 put_buf:
diff --git a/drivers/accel/ivpu/ivpu_gem.c b/drivers/accel/ivpu/ivpu_gem.c
index 0342a3fc9185..8d6ed95ccc7c 100644
--- a/drivers/accel/ivpu/ivpu_gem.c
+++ b/drivers/accel/ivpu/ivpu_gem.c
@@ -159,8 +159,9 @@ static void ivpu_bo_unbind_locked(struct ivpu_bo *bo)
 
 	if (bo->base.sgt) {
 		if (drm_gem_is_imported(&bo->base.base)) {
-			dma_buf_unmap_attachment(bo->base.base.import_attach,
-						 bo->base.sgt, DMA_BIDIRECTIONAL);
+			dma_buf_sgt_unmap_attachment(
+				bo->base.base.import_attach, bo->base.sgt,
+				DMA_BIDIRECTIONAL);
 		} else {
 			dma_unmap_sgtable(vdev->drm.dev, bo->base.sgt, DMA_BIDIRECTIONAL, 0);
 			sg_free_table(bo->base.sgt);
diff --git a/drivers/accel/qaic/qaic_data.c b/drivers/accel/qaic/qaic_data.c
index b8de1a1e2ab9..92d49448df72 100644
--- a/drivers/accel/qaic/qaic_data.c
+++ b/drivers/accel/qaic/qaic_data.c
@@ -930,7 +930,7 @@ static int qaic_prepare_bo(struct qaic_device *qdev, struct qaic_bo *bo,
 
 static void qaic_unprepare_import_bo(struct qaic_bo *bo)
 {
-	dma_buf_unmap_attachment(bo->base.import_attach, bo->sgt, bo->dir);
+	dma_buf_sgt_unmap_attachment(bo->base.import_attach, bo->sgt, bo->dir);
 	bo->sgt = NULL;
 }
 
diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
index 209a1dca19d0..12604c60122e 100644
--- a/drivers/dma-buf/dma-buf.c
+++ b/drivers/dma-buf/dma-buf.c
@@ -678,7 +678,7 @@ static struct file *dma_buf_getfile(size_t size, int flags)
  *
  * 3. Once the buffer is attached to all devices userspace can initiate DMA
  *    access to the shared buffer. In the kernel this is done by calling
- *    dma_buf_sgt_map_attachment() and dma_buf_unmap_attachment().
+ *    dma_buf_sgt_map_attachment() and dma_buf_sgt_unmap_attachment().
  *
  * 4. Once a driver is done with a shared buffer it needs to call
  *    dma_buf_detach() (after cleaning up any mappings) and then release the
@@ -959,7 +959,7 @@ dma_buf_pin_on_map(struct dma_buf_attachment *attach)
  *     - dma_buf_pin()
  *     - dma_buf_unpin()
  *     - dma_buf_sgt_map_attachment()
- *     - dma_buf_unmap_attachment()
+ *     - dma_buf_sgt_unmap_attachment()
  *     - dma_buf_vmap()
  *     - dma_buf_vunmap()
  *
@@ -977,7 +977,7 @@ dma_buf_pin_on_map(struct dma_buf_attachment *attach)
  *     - dma_buf_begin_cpu_access()
  *     - dma_buf_end_cpu_access()
  *     - dma_buf_sgt_map_attachment_unlocked()
- *     - dma_buf_unmap_attachment_unlocked()
+ *     - dma_buf_sgt_unmap_attachment_unlocked()
  *     - dma_buf_vmap_unlocked()
  *     - dma_buf_vunmap_unlocked()
  *
@@ -1314,7 +1314,7 @@ __dma_buf_sgt_map_attachment(struct dma_buf_attachment *attach,
  * On success, the DMA addresses and lengths in the returned scatterlist are
  * PAGE_SIZE aligned.
  *
- * A mapping must be unmapped by using dma_buf_unmap_attachment(). Note that
+ * A mapping must be unmapped by using dma_buf_sgt_unmap_attachment(). Note that
  * the underlying backing storage is pinned for as long as a mapping exists,
  * therefore users/importers should not hold onto a mapping for undue amounts of
  * time.
@@ -1377,7 +1377,7 @@ void dma_buf_sgt_type_unmap(struct dma_buf_attachment *attach,
 	struct dma_buf_sgt_mapping *mapping =
 		container_of(base, struct dma_buf_sgt_mapping, base);
 
-	dma_buf_unmap_attachment(attach, mapping->sgt, dir);
+	dma_buf_sgt_unmap_attachment(attach, mapping->sgt, dir);
 	kfree(mapping);
 }
 
@@ -1410,7 +1410,7 @@ dma_buf_sgt_map_attachment_unlocked(struct dma_buf_attachment *attach,
 EXPORT_SYMBOL_NS_GPL(dma_buf_sgt_map_attachment_unlocked, "DMA_BUF");
 
 /**
- * dma_buf_unmap_attachment - unmaps and decreases usecount of the buffer;might
+ * dma_buf_sgt_unmap_attachment - unmaps and decreases usecount of the buffer;might
  * deallocate the scatterlist associated. Is a wrapper for unmap_dma_buf() of
  * dma_buf_ops.
  * @attach:	[in]	attachment to unmap buffer from
@@ -1419,9 +1419,9 @@ EXPORT_SYMBOL_NS_GPL(dma_buf_sgt_map_attachment_unlocked, "DMA_BUF");
  *
  * This unmaps a DMA mapping for @attached obtained by dma_buf_sgt_map_attachment().
  */
-void dma_buf_unmap_attachment(struct dma_buf_attachment *attach,
-				struct sg_table *sg_table,
-				enum dma_data_direction direction)
+void dma_buf_sgt_unmap_attachment(struct dma_buf_attachment *attach,
+				  struct sg_table *sg_table,
+				  enum dma_data_direction direction)
 {
 	const struct dma_buf_mapping_sgt_exp_ops *sgt_exp_ops =
 		dma_buf_get_sgt_ops(attach);
@@ -1439,21 +1439,21 @@ void dma_buf_unmap_attachment(struct dma_buf_attachment *attach,
 	if (dma_buf_pin_on_map(attach))
 		attach->dmabuf->ops->unpin(attach);
 }
-EXPORT_SYMBOL_NS_GPL(dma_buf_unmap_attachment, "DMA_BUF");
+EXPORT_SYMBOL_NS_GPL(dma_buf_sgt_unmap_attachment, "DMA_BUF");
 
 /**
- * dma_buf_unmap_attachment_unlocked - unmaps and decreases usecount of the buffer;might
+ * dma_buf_sgt_unmap_attachment_unlocked - unmaps and decreases usecount of the buffer;might
  * deallocate the scatterlist associated. Is a wrapper for unmap_dma_buf() of
  * dma_buf_ops.
  * @attach:	[in]	attachment to unmap buffer from
  * @sg_table:	[in]	scatterlist info of the buffer to unmap
  * @direction:	[in]	direction of DMA transfer
  *
- * Unlocked variant of dma_buf_unmap_attachment().
+ * Unlocked variant of dma_buf_sgt_unmap_attachment().
  */
-void dma_buf_unmap_attachment_unlocked(struct dma_buf_attachment *attach,
-				       struct sg_table *sg_table,
-				       enum dma_data_direction direction)
+void dma_buf_sgt_unmap_attachment_unlocked(struct dma_buf_attachment *attach,
+					   struct sg_table *sg_table,
+					   enum dma_data_direction direction)
 {
 	might_sleep();
 
@@ -1461,10 +1461,10 @@ void dma_buf_unmap_attachment_unlocked(struct dma_buf_attachment *attach,
 		return;
 
 	dma_resv_lock(attach->dmabuf->resv, NULL);
-	dma_buf_unmap_attachment(attach, sg_table, direction);
+	dma_buf_sgt_unmap_attachment(attach, sg_table, direction);
 	dma_resv_unlock(attach->dmabuf->resv);
 }
-EXPORT_SYMBOL_NS_GPL(dma_buf_unmap_attachment_unlocked, "DMA_BUF");
+EXPORT_SYMBOL_NS_GPL(dma_buf_sgt_unmap_attachment_unlocked, "DMA_BUF");
 
 /**
  * dma_buf_attach_revocable - check if a DMA-buf importer implements
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
index 169e1b27ff8e..e22dbd2e43b9 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
@@ -1076,7 +1076,8 @@ static void amdgpu_ttm_backend_unbind(struct ttm_device *bdev,
 		struct dma_buf_attachment *attach;
 
 		attach = gtt->gobj->import_attach;
-		dma_buf_unmap_attachment(attach, ttm->sg, DMA_BIDIRECTIONAL);
+		dma_buf_sgt_unmap_attachment(attach, ttm->sg,
+					     DMA_BIDIRECTIONAL);
 		ttm->sg = NULL;
 	}
 
diff --git a/drivers/gpu/drm/armada/armada_gem.c b/drivers/gpu/drm/armada/armada_gem.c
index 506bc82f20d6..72c7cd2b3fb9 100644
--- a/drivers/gpu/drm/armada/armada_gem.c
+++ b/drivers/gpu/drm/armada/armada_gem.c
@@ -68,8 +68,9 @@ void armada_gem_free_object(struct drm_gem_object *obj)
 	if (dobj->obj.import_attach) {
 		/* We only ever display imported data */
 		if (dobj->sgt)
-			dma_buf_unmap_attachment_unlocked(dobj->obj.import_attach,
-							  dobj->sgt, DMA_TO_DEVICE);
+			dma_buf_sgt_unmap_attachment_unlocked(
+				dobj->obj.import_attach, dobj->sgt,
+				DMA_TO_DEVICE);
 		drm_prime_gem_destroy(&dobj->obj, NULL);
 	}
 
diff --git a/drivers/gpu/drm/drm_prime.c b/drivers/gpu/drm/drm_prime.c
index 330b64b3324a..3ffbe3d28929 100644
--- a/drivers/gpu/drm/drm_prime.c
+++ b/drivers/gpu/drm/drm_prime.c
@@ -1023,7 +1023,7 @@ struct drm_gem_object *drm_gem_prime_import_dev(struct drm_device *dev,
 	return obj;
 
 fail_unmap:
-	dma_buf_unmap_attachment_unlocked(attach, sgt, DMA_BIDIRECTIONAL);
+	dma_buf_sgt_unmap_attachment_unlocked(attach, sgt, DMA_BIDIRECTIONAL);
 fail_detach:
 	dma_buf_detach(dma_buf, attach);
 	dma_buf_put(dma_buf);
@@ -1121,7 +1121,8 @@ void drm_prime_gem_destroy(struct drm_gem_object *obj, struct sg_table *sg)
 
 	attach = obj->import_attach;
 	if (sg)
-		dma_buf_unmap_attachment_unlocked(attach, sg, DMA_BIDIRECTIONAL);
+		dma_buf_sgt_unmap_attachment_unlocked(attach, sg,
+						      DMA_BIDIRECTIONAL);
 	dma_buf = attach->dmabuf;
 	dma_buf_detach(attach->dmabuf, attach);
 	/* remove the reference */
diff --git a/drivers/gpu/drm/i915/gem/i915_gem_dmabuf.c b/drivers/gpu/drm/i915/gem/i915_gem_dmabuf.c
index 04c7b9a97681..7f939c281308 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_dmabuf.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_dmabuf.c
@@ -270,8 +270,8 @@ static int i915_gem_object_get_pages_dmabuf(struct drm_i915_gem_object *obj)
 static void i915_gem_object_put_pages_dmabuf(struct drm_i915_gem_object *obj,
 					     struct sg_table *sgt)
 {
-	dma_buf_unmap_attachment(obj->base.import_attach, sgt,
-				 DMA_BIDIRECTIONAL);
+	dma_buf_sgt_unmap_attachment(obj->base.import_attach, sgt,
+				     DMA_BIDIRECTIONAL);
 }
 
 static const struct drm_i915_gem_object_ops i915_gem_object_dmabuf_ops = {
diff --git a/drivers/gpu/drm/i915/gem/i915_gem_object.c b/drivers/gpu/drm/i915/gem/i915_gem_object.c
index 9e01f8b2079a..510d914494de 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_object.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_object.c
@@ -367,7 +367,7 @@ void __i915_gem_object_pages_fini(struct drm_i915_gem_object *obj)
 	atomic_set(&obj->mm.pages_pin_count, 0);
 
 	/*
-	 * dma_buf_unmap_attachment() requires reservation to be
+	 * dma_buf_sgt_unmap_attachment() requires reservation to be
 	 * locked. The imported GEM shouldn't share reservation lock
 	 * and ttm_bo_cleanup_memtype_use() shouldn't be invoked for
 	 * dma-buf, so it's safe to take the lock.
diff --git a/drivers/gpu/drm/i915/gem/selftests/i915_gem_dmabuf.c b/drivers/gpu/drm/i915/gem/selftests/i915_gem_dmabuf.c
index fcfa819caa38..6b6d235fd3e9 100644
--- a/drivers/gpu/drm/i915/gem/selftests/i915_gem_dmabuf.c
+++ b/drivers/gpu/drm/i915/gem/selftests/i915_gem_dmabuf.c
@@ -307,7 +307,8 @@ static int igt_dmabuf_import_same_driver(struct drm_i915_private *i915,
 		timeout = -ETIME;
 	}
 	err = timeout > 0 ? 0 : timeout;
-	dma_buf_unmap_attachment_unlocked(import_attach, st, DMA_BIDIRECTIONAL);
+	dma_buf_sgt_unmap_attachment_unlocked(import_attach, st,
+					      DMA_BIDIRECTIONAL);
 out_detach:
 	dma_buf_detach(dmabuf, import_attach);
 out_import:
diff --git a/drivers/gpu/drm/omapdrm/omap_gem_dmabuf.c b/drivers/gpu/drm/omapdrm/omap_gem_dmabuf.c
index 569ee2d3ab6f..c549b94b2e8a 100644
--- a/drivers/gpu/drm/omapdrm/omap_gem_dmabuf.c
+++ b/drivers/gpu/drm/omapdrm/omap_gem_dmabuf.c
@@ -138,7 +138,7 @@ struct drm_gem_object *omap_gem_prime_import(struct drm_device *dev,
 	return obj;
 
 fail_unmap:
-	dma_buf_unmap_attachment_unlocked(attach, sgt, DMA_TO_DEVICE);
+	dma_buf_sgt_unmap_attachment_unlocked(attach, sgt, DMA_TO_DEVICE);
 fail_detach:
 	dma_buf_detach(dma_buf, attach);
 	dma_buf_put(dma_buf);
diff --git a/drivers/gpu/drm/tegra/gem.c b/drivers/gpu/drm/tegra/gem.c
index fcb9308f49f0..f06826fe8366 100644
--- a/drivers/gpu/drm/tegra/gem.c
+++ b/drivers/gpu/drm/tegra/gem.c
@@ -164,8 +164,8 @@ static struct host1x_bo_mapping *tegra_bo_pin(struct device *dev, struct host1x_
 static void tegra_bo_unpin(struct host1x_bo_mapping *map)
 {
 	if (map->attach) {
-		dma_buf_unmap_attachment_unlocked(map->attach, map->sgt,
-						  map->direction);
+		dma_buf_sgt_unmap_attachment_unlocked(map->attach, map->sgt,
+						      map->direction);
 		dma_buf_detach(map->attach->dmabuf, map->attach);
 	} else {
 		dma_unmap_sgtable(map->dev, map->sgt, map->direction, 0);
@@ -502,7 +502,8 @@ static struct tegra_bo *tegra_bo_import(struct drm_device *drm,
 
 detach:
 	if (!IS_ERR_OR_NULL(bo->sgt))
-		dma_buf_unmap_attachment_unlocked(attach, bo->sgt, DMA_TO_DEVICE);
+		dma_buf_sgt_unmap_attachment_unlocked(attach, bo->sgt,
+						      DMA_TO_DEVICE);
 
 	dma_buf_detach(buf, attach);
 	dma_buf_put(buf);
@@ -523,8 +524,8 @@ void tegra_bo_free_object(struct drm_gem_object *gem)
 		tegra_bo_iommu_unmap(tegra, bo);
 
 		if (drm_gem_is_imported(gem)) {
-			dma_buf_unmap_attachment_unlocked(gem->import_attach, bo->sgt,
-							  DMA_TO_DEVICE);
+			dma_buf_sgt_unmap_attachment_unlocked(
+				gem->import_attach, bo->sgt, DMA_TO_DEVICE);
 			dma_buf_detach(gem->import_attach->dmabuf, gem->import_attach);
 		}
 	}
diff --git a/drivers/gpu/drm/virtio/virtgpu_prime.c b/drivers/gpu/drm/virtio/virtgpu_prime.c
index de69590b5076..2faa22875a51 100644
--- a/drivers/gpu/drm/virtio/virtgpu_prime.c
+++ b/drivers/gpu/drm/virtio/virtgpu_prime.c
@@ -170,7 +170,7 @@ int virtgpu_dma_buf_import_sgt(struct virtio_gpu_mem_entry **ents,
 
 	*ents = kvmalloc_objs(struct virtio_gpu_mem_entry, sgt->nents);
 	if (!(*ents)) {
-		dma_buf_unmap_attachment(attach, sgt, DMA_BIDIRECTIONAL);
+		dma_buf_sgt_unmap_attachment(attach, sgt, DMA_BIDIRECTIONAL);
 		return -ENOMEM;
 	}
 
@@ -195,8 +195,8 @@ static void virtgpu_dma_buf_unmap(struct virtio_gpu_object *bo)
 		virtio_gpu_detach_object_fenced(bo);
 
 		if (bo->sgt)
-			dma_buf_unmap_attachment(attach, bo->sgt,
-						 DMA_BIDIRECTIONAL);
+			dma_buf_sgt_unmap_attachment(attach, bo->sgt,
+						     DMA_BIDIRECTIONAL);
 
 		bo->sgt = NULL;
 	}
diff --git a/drivers/gpu/drm/xe/xe_bo.c b/drivers/gpu/drm/xe/xe_bo.c
index 4d93b8926ed6..be7cfd8725fe 100644
--- a/drivers/gpu/drm/xe/xe_bo.c
+++ b/drivers/gpu/drm/xe/xe_bo.c
@@ -759,7 +759,8 @@ static int xe_bo_move_dmabuf(struct ttm_buffer_object *ttm_bo,
 	    ttm_bo->sg) {
 		dma_resv_wait_timeout(ttm_bo->base.resv, DMA_RESV_USAGE_BOOKKEEP,
 				      false, MAX_SCHEDULE_TIMEOUT);
-		dma_buf_unmap_attachment(attach, ttm_bo->sg, DMA_BIDIRECTIONAL);
+		dma_buf_sgt_unmap_attachment(attach, ttm_bo->sg,
+					     DMA_BIDIRECTIONAL);
 		ttm_bo->sg = NULL;
 	}
 
@@ -767,7 +768,8 @@ static int xe_bo_move_dmabuf(struct ttm_buffer_object *ttm_bo,
 		goto out;
 
 	if (ttm_bo->sg) {
-		dma_buf_unmap_attachment(attach, ttm_bo->sg, DMA_BIDIRECTIONAL);
+		dma_buf_sgt_unmap_attachment(attach, ttm_bo->sg,
+					     DMA_BIDIRECTIONAL);
 		ttm_bo->sg = NULL;
 	}
 
@@ -1639,9 +1641,9 @@ int xe_bo_dma_unmap_pinned(struct xe_bo *bo)
 		struct xe_ttm_tt *xe_tt = container_of(tt, typeof(*xe_tt), ttm);
 
 		if (ttm_bo->type == ttm_bo_type_sg && ttm_bo->sg) {
-			dma_buf_unmap_attachment(ttm_bo->base.import_attach,
-						 ttm_bo->sg,
-						 DMA_BIDIRECTIONAL);
+			dma_buf_sgt_unmap_attachment(ttm_bo->base.import_attach,
+						     ttm_bo->sg,
+						     DMA_BIDIRECTIONAL);
 			ttm_bo->sg = NULL;
 			xe_tt->sg = NULL;
 		} else if (xe_tt->sg) {
@@ -1756,8 +1758,8 @@ static void xe_ttm_bo_delete_mem_notify(struct ttm_buffer_object *ttm_bo)
 		struct xe_ttm_tt *xe_tt = container_of(ttm_bo->ttm,
 						       struct xe_ttm_tt, ttm);
 
-		dma_buf_unmap_attachment(ttm_bo->base.import_attach, ttm_bo->sg,
-					 DMA_BIDIRECTIONAL);
+		dma_buf_sgt_unmap_attachment(ttm_bo->base.import_attach,
+					     ttm_bo->sg, DMA_BIDIRECTIONAL);
 		ttm_bo->sg = NULL;
 		xe_tt->sg = NULL;
 	}
diff --git a/drivers/iio/industrialio-buffer.c b/drivers/iio/industrialio-buffer.c
index 619181968ff9..f81154642bcd 100644
--- a/drivers/iio/industrialio-buffer.c
+++ b/drivers/iio/industrialio-buffer.c
@@ -1590,7 +1590,7 @@ static void iio_buffer_dmabuf_release(struct kref *ref)
 	struct iio_buffer *buffer = priv->buffer;
 	struct dma_buf *dmabuf = attach->dmabuf;
 
-	dma_buf_unmap_attachment_unlocked(attach, priv->sgt, priv->dir);
+	dma_buf_sgt_unmap_attachment_unlocked(attach, priv->sgt, priv->dir);
 
 	buffer->access->detach_dmabuf(buffer, priv->block);
 
@@ -1778,7 +1778,7 @@ static int iio_buffer_attach_dmabuf(struct iio_dev_buffer_pair *ib,
 	return 0;
 
 err_dmabuf_unmap_attachment:
-	dma_buf_unmap_attachment(attach, priv->sgt, priv->dir);
+	dma_buf_sgt_unmap_attachment(attach, priv->sgt, priv->dir);
 err_resv_unlock:
 	dma_resv_unlock(dmabuf->resv);
 err_dmabuf_detach:
diff --git a/drivers/infiniband/core/umem_dmabuf.c b/drivers/infiniband/core/umem_dmabuf.c
index dd584f8dcd1c..950db165d9c7 100644
--- a/drivers/infiniband/core/umem_dmabuf.c
+++ b/drivers/infiniband/core/umem_dmabuf.c
@@ -106,8 +106,8 @@ void ib_umem_dmabuf_unmap_pages(struct ib_umem_dmabuf *umem_dmabuf)
 		umem_dmabuf->last_sg_trim = 0;
 	}
 
-	dma_buf_unmap_attachment(umem_dmabuf->attach, umem_dmabuf->sgt,
-				 DMA_BIDIRECTIONAL);
+	dma_buf_sgt_unmap_attachment(umem_dmabuf->attach, umem_dmabuf->sgt,
+				     DMA_BIDIRECTIONAL);
 
 	umem_dmabuf->sgt = NULL;
 }
diff --git a/drivers/media/common/videobuf2/videobuf2-dma-contig.c b/drivers/media/common/videobuf2/videobuf2-dma-contig.c
index 0ce643940898..e13521b5c0e8 100644
--- a/drivers/media/common/videobuf2/videobuf2-dma-contig.c
+++ b/drivers/media/common/videobuf2/videobuf2-dma-contig.c
@@ -717,8 +717,8 @@ static int vb2_dc_map_dmabuf(void *mem_priv)
 	if (contig_size < buf->size) {
 		pr_err("contiguous chunk is too small %lu/%lu\n",
 		       contig_size, buf->size);
-		dma_buf_unmap_attachment_unlocked(buf->db_attach, sgt,
-						  buf->dma_dir);
+		dma_buf_sgt_unmap_attachment_unlocked(buf->db_attach, sgt,
+						      buf->dma_dir);
 		return -EFAULT;
 	}
 
@@ -749,7 +749,8 @@ static void vb2_dc_unmap_dmabuf(void *mem_priv)
 		dma_buf_vunmap_unlocked(buf->db_attach->dmabuf, &map);
 		buf->vaddr = NULL;
 	}
-	dma_buf_unmap_attachment_unlocked(buf->db_attach, sgt, buf->dma_dir);
+	dma_buf_sgt_unmap_attachment_unlocked(buf->db_attach, sgt,
+					      buf->dma_dir);
 
 	buf->dma_addr = 0;
 	buf->dma_sgt = NULL;
diff --git a/drivers/media/common/videobuf2/videobuf2-dma-sg.c b/drivers/media/common/videobuf2/videobuf2-dma-sg.c
index 17191373c69c..59e346a5d48b 100644
--- a/drivers/media/common/videobuf2/videobuf2-dma-sg.c
+++ b/drivers/media/common/videobuf2/videobuf2-dma-sg.c
@@ -601,7 +601,8 @@ static void vb2_dma_sg_unmap_dmabuf(void *mem_priv)
 		dma_buf_vunmap_unlocked(buf->db_attach->dmabuf, &map);
 		buf->vaddr = NULL;
 	}
-	dma_buf_unmap_attachment_unlocked(buf->db_attach, sgt, buf->dma_dir);
+	dma_buf_sgt_unmap_attachment_unlocked(buf->db_attach, sgt,
+					      buf->dma_dir);
 
 	buf->dma_sgt = NULL;
 }
diff --git a/drivers/media/platform/nvidia/tegra-vde/dmabuf-cache.c b/drivers/media/platform/nvidia/tegra-vde/dmabuf-cache.c
index 8f3443fa0eb5..55d58a4dbbe2 100644
--- a/drivers/media/platform/nvidia/tegra-vde/dmabuf-cache.c
+++ b/drivers/media/platform/nvidia/tegra-vde/dmabuf-cache.c
@@ -38,7 +38,8 @@ static void tegra_vde_release_entry(struct tegra_vde_cache_entry *entry)
 	if (entry->vde->domain)
 		tegra_vde_iommu_unmap(entry->vde, entry->iova);
 
-	dma_buf_unmap_attachment_unlocked(entry->a, entry->sgt, entry->dma_dir);
+	dma_buf_sgt_unmap_attachment_unlocked(entry->a, entry->sgt,
+					      entry->dma_dir);
 	dma_buf_detach(dmabuf, entry->a);
 	dma_buf_put(dmabuf);
 
@@ -152,7 +153,7 @@ int tegra_vde_dmabuf_cache_map(struct tegra_vde *vde,
 err_free:
 	kfree(entry);
 err_unmap:
-	dma_buf_unmap_attachment_unlocked(attachment, sgt, dma_dir);
+	dma_buf_sgt_unmap_attachment_unlocked(attachment, sgt, dma_dir);
 err_detach:
 	dma_buf_detach(dmabuf, attachment);
 err_unlock:
diff --git a/drivers/misc/fastrpc.c b/drivers/misc/fastrpc.c
index fce849417eb7..375ce39c78c9 100644
--- a/drivers/misc/fastrpc.c
+++ b/drivers/misc/fastrpc.c
@@ -400,8 +400,8 @@ static void fastrpc_free_map(struct kref *ref)
 				return;
 			}
 		}
-		dma_buf_unmap_attachment_unlocked(map->attach, map->table,
-						  DMA_BIDIRECTIONAL);
+		dma_buf_sgt_unmap_attachment_unlocked(map->attach, map->table,
+						      DMA_BIDIRECTIONAL);
 		dma_buf_detach(map->buf, map->attach);
 		dma_buf_put(map->buf);
 	}
diff --git a/drivers/usb/gadget/function/f_fs.c b/drivers/usb/gadget/function/f_fs.c
index fe3c43ba72c6..4016edfa4c02 100644
--- a/drivers/usb/gadget/function/f_fs.c
+++ b/drivers/usb/gadget/function/f_fs.c
@@ -1366,7 +1366,7 @@ static void ffs_dmabuf_release(struct kref *ref)
 	struct dma_buf *dmabuf = attach->dmabuf;
 
 	pr_vdebug("FFS DMABUF release\n");
-	dma_buf_unmap_attachment_unlocked(attach, priv->sgt, priv->dir);
+	dma_buf_sgt_unmap_attachment_unlocked(attach, priv->sgt, priv->dir);
 
 	dma_buf_detach(attach->dmabuf, attach);
 	dma_buf_put(dmabuf);
diff --git a/drivers/xen/gntdev-dmabuf.c b/drivers/xen/gntdev-dmabuf.c
index 3bb05596920e..cd851eb04a69 100644
--- a/drivers/xen/gntdev-dmabuf.c
+++ b/drivers/xen/gntdev-dmabuf.c
@@ -651,7 +651,7 @@ dmabuf_imp_to_refs(struct gntdev_dmabuf_priv *priv, struct device *dev,
 fail_end_access:
 	dmabuf_imp_end_foreign_access(gntdev_dmabuf->u.imp.refs, count);
 fail_unmap:
-	dma_buf_unmap_attachment_unlocked(attach, sgt, DMA_BIDIRECTIONAL);
+	dma_buf_sgt_unmap_attachment_unlocked(attach, sgt, DMA_BIDIRECTIONAL);
 fail_detach:
 	dma_buf_detach(dma_buf, attach);
 fail_free_obj:
@@ -701,8 +701,8 @@ static int dmabuf_imp_release(struct gntdev_dmabuf_priv *priv, u32 fd)
 	attach = gntdev_dmabuf->u.imp.attach;
 
 	if (gntdev_dmabuf->u.imp.sgt)
-		dma_buf_unmap_attachment_unlocked(attach, gntdev_dmabuf->u.imp.sgt,
-						  DMA_BIDIRECTIONAL);
+		dma_buf_sgt_unmap_attachment_unlocked(
+			attach, gntdev_dmabuf->u.imp.sgt, DMA_BIDIRECTIONAL);
 	dma_buf = attach->dmabuf;
 	dma_buf_detach(attach->dmabuf, attach);
 	dma_buf_put(dma_buf);
diff --git a/include/linux/dma-buf-mapping.h b/include/linux/dma-buf-mapping.h
index 02d79d5615b5..ffb7503781a8 100644
--- a/include/linux/dma-buf-mapping.h
+++ b/include/linux/dma-buf-mapping.h
@@ -172,7 +172,7 @@ void dma_buf_sgt_type_unmap(struct dma_buf_attachment *attach,
  * When this type is matched the map/unmap functions are:
  *
  *  dma_buf_sgt_map_attachment()
- *  dma_buf_unmap_attachment()
+ *  dma_buf_sgt_unmap_attachment()
  *
  * The struct sg_table returned by those functions has only the DMA portions
  * available. The caller must not try to use the struct page * information.
@@ -264,7 +264,7 @@ struct dma_buf_mapping_sgt_exp_ops {
 	/**
 	 * @unmap_dma_buf:
 	 *
-	 * This is called by dma_buf_unmap_attachment() and should unmap and
+	 * This is called by dma_buf_sgt_unmap_attachment() and should unmap and
 	 * release the &sg_table allocated in @map_dma_buf, and it is mandatory.
 	 * For static dma_buf handling this might also unpin the backing
 	 * storage if this is the last mapping of the DMA buffer.
diff --git a/include/linux/dma-buf.h b/include/linux/dma-buf.h
index ee6c97a5cecd..b264e1c4a9df 100644
--- a/include/linux/dma-buf.h
+++ b/include/linux/dma-buf.h
@@ -516,7 +516,7 @@ struct dma_buf_attach_ops {
  * An attachment is created by calling dma_buf_attach(), and released again by
  * calling dma_buf_detach(). The DMA mapping itself needed to initiate a
  * transfer is created by dma_buf_sgt_map_attachment() and freed again by calling
- * dma_buf_unmap_attachment().
+ * dma_buf_sgt_unmap_attachment().
  */
 struct dma_buf_attachment {
 	struct dma_buf *dmabuf;
@@ -616,8 +616,8 @@ void dma_buf_put(struct dma_buf *dmabuf);
 
 struct sg_table *dma_buf_sgt_map_attachment(struct dma_buf_attachment *,
 					    enum dma_data_direction);
-void dma_buf_unmap_attachment(struct dma_buf_attachment *, struct sg_table *,
-				enum dma_data_direction);
+void dma_buf_sgt_unmap_attachment(struct dma_buf_attachment *,
+				  struct sg_table *, enum dma_data_direction);
 void dma_buf_invalidate_mappings(struct dma_buf *dma_buf);
 bool dma_buf_attach_revocable(struct dma_buf_attachment *attach);
 int dma_buf_begin_cpu_access(struct dma_buf *dma_buf,
@@ -627,9 +627,9 @@ int dma_buf_end_cpu_access(struct dma_buf *dma_buf,
 struct sg_table *
 dma_buf_sgt_map_attachment_unlocked(struct dma_buf_attachment *attach,
 				    enum dma_data_direction direction);
-void dma_buf_unmap_attachment_unlocked(struct dma_buf_attachment *attach,
-				       struct sg_table *sg_table,
-				       enum dma_data_direction direction);
+void dma_buf_sgt_unmap_attachment_unlocked(struct dma_buf_attachment *attach,
+					   struct sg_table *sg_table,
+					   enum dma_data_direction direction);
 
 int dma_buf_mmap(struct dma_buf *, struct vm_area_struct *,
 		 unsigned long);
diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 3f8be77a50dc..67f74ce4f096 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -132,8 +132,8 @@ static void io_unmap_dmabuf(struct io_zcrx_mem *mem)
 	if (!IS_ENABLED(CONFIG_DMA_SHARED_BUFFER))
 		return;
 	if (mem->sgt)
-		dma_buf_unmap_attachment_unlocked(mem->attach, mem->sgt,
-						  DMA_FROM_DEVICE);
+		dma_buf_sgt_unmap_attachment_unlocked(mem->attach, mem->sgt,
+						      DMA_FROM_DEVICE);
 	if (mem->attach)
 		dma_buf_detach(mem->dmabuf, mem->attach);
 	mem->sgt = NULL;
diff --git a/net/core/devmem.c b/net/core/devmem.c
index 86b3c54933bb..f30fa375c9ab 100644
--- a/net/core/devmem.c
+++ b/net/core/devmem.c
@@ -74,8 +74,8 @@ void __net_devmem_dmabuf_binding_free(struct work_struct *wq)
 		  size, avail))
 		gen_pool_destroy(binding->chunk_pool);
 
-	dma_buf_unmap_attachment_unlocked(binding->attachment, binding->sgt,
-					  binding->direction);
+	dma_buf_sgt_unmap_attachment_unlocked(binding->attachment, binding->sgt,
+					      binding->direction);
 	dma_buf_detach(binding->dmabuf, binding->attachment);
 	dma_buf_put(binding->dmabuf);
 	xa_destroy(&binding->bound_rxqs);
@@ -343,8 +343,8 @@ net_devmem_bind_dmabuf(struct net_device *dev, void *vdev,
 err_tx_vec:
 	kvfree(binding->tx_vec);
 err_unmap:
-	dma_buf_unmap_attachment_unlocked(binding->attachment, binding->sgt,
-					  direction);
+	dma_buf_sgt_unmap_attachment_unlocked(binding->attachment, binding->sgt,
+					      direction);
 err_detach:
 	dma_buf_detach(dmabuf, binding->attachment);
 err_exit_ref:
-- 
2.54.0

