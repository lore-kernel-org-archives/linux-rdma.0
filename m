Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.46.42
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792993115;
	b=EPne1NjmsORWa+8LIyY1Tkc3JmYQm/VBRcgrdA/1OqjbcuSin8BHsi0mpL+Erkm4MqcX
	 5UGdVbofaQBP8Px+QaPL5ODrOOz8Ep6CJ12RoGaqWCiLIRZZtRP0bUqO88b1jKDCRmZt/
	 AUE7vbeH78chIaGIWpRyI8skW8ClMbRiRhIzlLvUO+eQHpwQR4S/JmfQZB+VzESiA9+Nh
	 NRSIVosmVY4mm14HAxbadAbSXj+Oia3+p+5INm2IahIRCh81Ua6Dxh+wcHmJFxBvomvj0
	 SAzKLdJ3N+MZUdtQnCfeqXcyOwutXdtcTIW5BvT2gVtv8QcY86/loqYUu2XdFJ5BG/g==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792993115;
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
	bh=8MtgLXXAM8CtxU6lCGwC9GELh5M2r11tf6kN1j4N/1E=;
	b=rd9P6A6J4fJ0snV03koknIacnGG7DAKpt1YeQwvXVUe9EX9aOGc4oqyR3Bdy2I32LXcy
	 221aVJ6d8o+g7697slDLuhaucM3GfEYP5Ob3ehyp+vCAxoD5sZMDR7Gy7bt2fw352C1Do
	 GO0lCOzXL6EXoz9IMQmTZ+aoe1DwRDmDgR+nZr3GbxNZE5Th4koy2sGVmjlVuZjwaO/Gs
	 vYqjrJvZJY2tg15vB7J1Usp6cytuqqd6wb/3JZWv0m/B8ukBAkBZDlg+fbFLsSj9TCyHU
	 0tWqLzMI9DNZaQHSlyi9VGyLoY2G3F2MilNil2wJrheD0z6Yz70dCwjkxkLJlAcOceA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=ksyHb4Zw;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.46.42
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010042.outbound.protection.outlook.com [52.101.46.42])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B396B60A261F;
	Mon, 26 Oct 2026 05:38:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B396B60A261F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=ksyHb4Zw
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=g1QYZGNaNz7KBKhm2C0RtYUVGP4Vxo71RUDCKnwIERVlOaBzEx8K5XrgHm8BtPfPz4Bo6cctn/1RXuQ3+WSUti6VHvqwH+yaLAQzbz6jPwJFWkckLB1lXunJS0uOhX0eAC5BtJpw90N5FDV9V+x+DFXWCpObqi7nmvimlEphARsvm78iVCyrBFHxjrUrVd2vIjwj32HRLTwtM/q3Q6qm50fy2/I3tCtEgF7Y1vpYf7JB01yB1kAlTeMCbgi69iwP0ND+trxER9mo+MVScwMVkENKM7LqIIAIloO7ptl86fcITrXYm2pIcukt1S2h9ldqxGzg3Ji3FIXa0JtJbD0gCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8MtgLXXAM8CtxU6lCGwC9GELh5M2r11tf6kN1j4N/1E=;
 b=vOz0adWBG9PZamkU9Lt3ZZHG4GwIbcwbMkMMWTG8i+2O1eQMFo1XNc83IIdsoWiZSQUlPdu0vNftf96I4VawEcwImbGkOp39T9Yi4Odl8IgDN8ZTU3ofFmWQweNwVoKYJ1ONzi6UqZyN96dlMLTFjBIQntNrHJnjcumiff9rIt9unkIj7xQD81g1FBEse9+7S9YK+Wp+oYwJfVXE+m6B3Je8TN/CKuG6YsAe4cj19Gg4cMki81qf4W5WhWMrANFd3bhF/eV1QgIk1GrE1p5RCH+F53Gl51q9NAFqc6oQh4C+XiRY6dtvrloYwHhd6/PT2ygxm7lFu7YZVfHbOddGpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8MtgLXXAM8CtxU6lCGwC9GELh5M2r11tf6kN1j4N/1E=;
 b=ksyHb4Zwh0Y+ha4+EseeBLOIFexkpBeZX8z3FRNG8J4osGtBkP7lvMlIVdqiSFyukDdAtprHFgUrBL59ZwrL32o2izPzn5ZeBZ3nM9oG0ov5Btp1mJUYdsbJRzV4pIf8My7nn47dqj1IfQimfvW+sj8ArlD+LcUIgHhmkIbEGIPI6fhB9x9lmTnYw6jWvk5QUTmr9wvndyKhyXlnSL9JTAazCxBkcGwAemagyTMRsbWgUwsSTqoW+08BoVYrfvrpRZgqxskOuhS9bbYKyX4bidwGU8Rp6+aiCz+NZOcze1GLRWTJBJxUra9rEVM0o5PeExSn8uaEvZFbTVMqSjbhbA==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SA3PR12MB598757.namprd12.prod.outlook.com
 (2603:10b6:806:52d::14) by SJ0PR12MB6967.namprd12.prod.outlook.com
 (2603:10b6:a03:44b::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Mon, 26 Oct
 2026 05:38:31 +0000
Received: from SA3PR12MB598757.namprd12.prod.outlook.com
 ([fe80::e206:100:5946:a777]) by SA3PR12MB598757.namprd12.prod.outlook.com
 ([fe80::e206:100:5946:a777%5]) with mapi id 15.21.0546.021; Mon, 26 Oct 2026
 05:38:31 +0000
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
Subject: [PATCH 23/26] treewide: Rename dma_buf_attach() to dma_buf_sgt_attach()
Date: Mon, 26 Oct 2026 16:36:14 +1100
Message-ID: <20261026053623.202642-24-apopple@nvidia.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261026053623.202642-1-apopple@nvidia.com>
References: <20261026053623.202642-1-apopple@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SY6PR01CA0028.ausprd01.prod.outlook.com
 (2603:10c6:10:eb::15) To SA3PR12MB598757.namprd12.prod.outlook.com
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
X-MS-Office365-Filtering-Correlation-Id: f1554dac-4739-4237-0d5c-08df33235e9e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|23010399003|366016|18002099003|22082099003|6133799003|56012099006|11063799006|261022075727099003|261021121427099003|261021123027099003|10067099003|261009221227099003|261009223027099003|261022105027099003;
X-Microsoft-Antispam-Message-Info:
	tnd+prnQfzUstLeRtQyAriO/SADqweMlLrOC1XHI+FJ9sTZEh8MZWwgUfyOK2hrWbqcdPmnIh0xd9VvOP9xVT7Rb0dYjynbNGZYCZ2pSxqJ2oRTf22y5woZaPXDHEuYVyzwEf85M2CdcDGhHmF+56IUqraxL19nxa2MZ0JgdWXNPx2pw+EP9xBtJMRKGb6QC6ZnCb5rXOz3AR3gybyD9bEwuxFyd6Ww6PtSOJCABDxoOo4fnP/yCEcIejeJ9aeHh1dveFM/roAufBTthAw5zwnk5yBlfIgaZtQ9AkJGHD/5NEqkna/Lz9IJwYlWXwGMrnOoDQCTW+JPXWKS4sTnWEF4hpDcJBX6Ge4Mb9vx2yaTGkBqQyME0IljHnc6bqB+mQKM4hnO05ejLm74k5xk6YeNPdlYGt0o+pm+L5KlzqJQ83GdR6U2DzR9iiuBdyoON+V56hvMCRN9oCH5UI712vOIEHCPTKN1h8zHqs98+8zj+3H5IoruIAw7MEi9FO4dA26iAmggYNbLxr/m2jKmm5Vv5ehO0DBj83izeSLFp4iSW4y44prG6PGPvoqraLdfnaHAEeid9BsYKCCYn0bQb4JgL4NF8tqKn3+w2iXc59+3qIMtdnH1HJXQKlT8GacQPOfbJGNdt48b9yXQTQlEkKuuz6IXmEs/BjDm3dPwfflc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA3PR12MB598757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(23010399003)(366016)(18002099003)(22082099003)(6133799003)(56012099006)(11063799006)(261022075727099003)(261021121427099003)(261021123027099003)(10067099003)(261009221227099003)(261009223027099003)(261022105027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?6zrvdrPzIxA4nWmj/PK5biIvbcGmD3fk3VOqo0YjXy6vulNr6NHp/G+2K36G?=
 =?us-ascii?Q?LiHO0nUzpidsDUp+UPuaVAFf4GlkcSgUNI9Ou8nnz/+Ov4Yt9JqtHIeWVzlF?=
 =?us-ascii?Q?qlo4dQrBSiCrMKvvHLpxCEDrTxcLU405nIcFDWJ986pCCw05ekyGmCV8LL9d?=
 =?us-ascii?Q?eLITPbhm2k7RW8lcmoLO7Vd7SfZgnMDBpWPTuT3ObyUkNZYD2ryCAF164/MH?=
 =?us-ascii?Q?hJlVRofXaHc8QDKBRqAFhDbroldsRE9wN1z+fX/VZ3kf6DeLIPdHLhV7bAOM?=
 =?us-ascii?Q?I1KLua+HpWkb14K94IQqlomG4+4Ey23JQ6ZSFNdRHFEGzGjXqMG07KHJM/US?=
 =?us-ascii?Q?CNkksYuZfQ8/AulvbolTj1Rw2u9SsyK6p3PkNlzDpkjqKgvhA5Mjndjipf3G?=
 =?us-ascii?Q?cC/oKEkDo9g6WoVjlCuPwQe1H6yhM301yN5aQMPmp752YaVHnk6E7YAYfXiX?=
 =?us-ascii?Q?A2YBGa9KwpRDz2MAkshpqiPGaqZnxKpsPHlw5FLAydMhPrFY1epB5c7AC8JU?=
 =?us-ascii?Q?ymXUQfEAXIYe/K/jVnWxYX9lV+f4KJKMKYkRBB+3WFkKkib0CP6qVhhheuky?=
 =?us-ascii?Q?srYfYq9e5gTFRulzSeEhTu/Lkp9E+QzoM+LCHh9sotNRMGpm94yaUYSoqujE?=
 =?us-ascii?Q?Vm2/f0XG9vwEDZv1CyoOduJUNupPIN158cvgP39tL2MOsnmMLRN7FNpPgqho?=
 =?us-ascii?Q?hBkO9qI6+oywQ1sIKDeAocGHV1jwxaYRik1ZndGRLZguEww7ZKL9xL9QC8qF?=
 =?us-ascii?Q?bQvcQV71t9I0ssn/13Ev4EBy7mroMMHHWSNizr6FrnI0sEy3gJswKfUzGpip?=
 =?us-ascii?Q?GSBZLManN8T0KNzHdH6CHcwGFSZlwwRgFWgOmnwEfTTyrti48B04qScNhPXi?=
 =?us-ascii?Q?kCuElj56JqMZF1JErrQ5PAwySjQq/LfXGbuY5ztnpsPQ80Kc8TQWYlDgi6CW?=
 =?us-ascii?Q?Z5t6ii7DdNwO3aJc8V0nabJ2jupoWLIvHwAQyiNxB+rP5f8vXwjpD8kwPgUX?=
 =?us-ascii?Q?UteW75y8KDPJuavXbcKDdoo4D4AwAfvnk0c5eExPVYS6FNVZJfDqbuCj0BA+?=
 =?us-ascii?Q?f2uuJxJgrWqg4wzb8g36WzrNNlloChL+bl1vfZDR+PFusTB3l8RkQHeoV33t?=
 =?us-ascii?Q?p2t2mzifzXLw4TCXbZzeQewVZPWHXKudEaE5ZVIfoysggz6iSte7oCUXSuY9?=
 =?us-ascii?Q?+E/E3i5tz/dLxLV+gY13SgtPlC9nHAXDAMEuk0v9ph6XyiYgPrETNVj3bt0n?=
 =?us-ascii?Q?a1qwdVrxrVOCmFylmkjCDlYMqf0vm9EFq3v14JPmsB2378aFEBedcL3EWRiJ?=
 =?us-ascii?Q?XegU20fH8pMZpTr8y44SwGsWQJQM7Z0C0PrLs2OqFldikQkGmOPtYNzSW9S6?=
 =?us-ascii?Q?bGnpCWj7uz9t4iZy/jiJr2yzDfDyD3WJgLU263NU2K0u55VhnErQQ8Ul9e4I?=
 =?us-ascii?Q?unBaI+8IfIxA/XCEQQgjqqK3M8DiAsYyoi1u99cGifLG4NqvBdCK9aGarhPw?=
 =?us-ascii?Q?44WPQTULy3KahKSISULIhy+6Zkln0wHWrqms+OzCn7RIKGSpY69suy6EUpYu?=
 =?us-ascii?Q?y/WNxh8NaP3rINwiPcW52PM5PnQvX2dnOM2Tizm1F2msr5d8KJk0id/vK73V?=
 =?us-ascii?Q?/l2mSSAMQG6OMbmbC1ymAeIN0PsP0znNdoPFoOKESzJV9FqCOZBhuCNB/Tej?=
 =?us-ascii?Q?SvCXffTTrq5WrixcPqNO0Xi5U077AEOaI5uhhLHDBSTTkINJDIjJazseEwc3?=
 =?us-ascii?Q?ZOCscDN0eA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f1554dac-4739-4237-0d5c-08df33235e9e
X-MS-Exchange-CrossTenant-AuthSource: SA3PR12MB598757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2026 05:38:31.4959
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jGqfJqIyGgAJVpzhDrMaND/KcpCn/8qJXODxA3YQkSulCx7prsSz0qnwM+b09wsG+oaRbUz0GwJTTRckBgWEMA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6967

From: Jason Gunthorpe <jgg@nvidia.com>

This attach function always creates a SGT mapping type importer.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 Documentation/gpu/todo.rst                         |  2 +-
 drivers/accel/amdxdna/amdxdna_gem.c                |  2 +-
 drivers/accel/ivpu/ivpu_gem.c                      |  2 +-
 drivers/accel/qaic/qaic_data.c                     |  2 +-
 drivers/dma-buf/dma-buf.c                          | 14 +++++++-------
 drivers/gpu/drm/armada/armada_gem.c                |  2 +-
 drivers/gpu/drm/drm_gem_shmem_helper.c             |  2 +-
 drivers/gpu/drm/drm_prime.c                        |  2 +-
 drivers/gpu/drm/i915/gem/i915_gem_dmabuf.c         |  2 +-
 .../gpu/drm/i915/gem/selftests/i915_gem_dmabuf.c   |  2 +-
 drivers/gpu/drm/omapdrm/omap_gem_dmabuf.c          |  2 +-
 drivers/gpu/drm/tegra/gem.c                        |  4 ++--
 drivers/iio/industrialio-buffer.c                  |  2 +-
 .../media/common/videobuf2/videobuf2-dma-contig.c  |  2 +-
 drivers/media/common/videobuf2/videobuf2-dma-sg.c  |  2 +-
 .../media/platform/nvidia/tegra-vde/dmabuf-cache.c |  2 +-
 drivers/misc/fastrpc.c                             |  2 +-
 drivers/usb/gadget/function/f_fs.c                 |  2 +-
 drivers/xen/gntdev-dmabuf.c                        |  2 +-
 include/linux/dma-buf.h                            | 10 +++++-----
 io_uring/zcrx.c                                    |  2 +-
 net/core/devmem.c                                  |  2 +-
 22 files changed, 33 insertions(+), 33 deletions(-)

diff --git a/Documentation/gpu/todo.rst b/Documentation/gpu/todo.rst
index 14cf37590fc7..be0397c197f1 100644
--- a/Documentation/gpu/todo.rst
+++ b/Documentation/gpu/todo.rst
@@ -633,7 +633,7 @@ Remove automatic page mapping from dma-buf importing
 
 When importing dma-bufs, the dma-buf and PRIME frameworks automatically map
 imported pages into the importer's DMA area. drm_gem_prime_fd_to_handle() and
-drm_gem_prime_handle_to_fd() require that importers call dma_buf_attach()
+drm_gem_prime_handle_to_fd() require that importers call dma_buf_sgt_attach()
 even if they never do actual device DMA, but only CPU access through
 dma_buf_vmap(). This is a problem for USB devices, which do not support DMA
 operations.
diff --git a/drivers/accel/amdxdna/amdxdna_gem.c b/drivers/accel/amdxdna/amdxdna_gem.c
index a7e759bb0460..2b2f1e9fb9ec 100644
--- a/drivers/accel/amdxdna/amdxdna_gem.c
+++ b/drivers/accel/amdxdna/amdxdna_gem.c
@@ -893,7 +893,7 @@ amdxdna_gem_prime_import(struct drm_device *dev, struct dma_buf *dma_buf)
 
 	get_dma_buf(dma_buf);
 
-	attach = dma_buf_attach(dma_buf, dev->dev);
+	attach = dma_buf_sgt_attach(dma_buf, dev->dev);
 	if (IS_ERR(attach)) {
 		ret = PTR_ERR(attach);
 		goto put_buf;
diff --git a/drivers/accel/ivpu/ivpu_gem.c b/drivers/accel/ivpu/ivpu_gem.c
index 8d6ed95ccc7c..d1c99b974a34 100644
--- a/drivers/accel/ivpu/ivpu_gem.c
+++ b/drivers/accel/ivpu/ivpu_gem.c
@@ -219,7 +219,7 @@ struct drm_gem_object *ivpu_gem_prime_import(struct drm_device *dev,
 	struct ivpu_bo *bo;
 	int ret;
 
-	attach = dma_buf_attach(dma_buf, attach_dev);
+	attach = dma_buf_sgt_attach(dma_buf, attach_dev);
 	if (IS_ERR(attach))
 		return ERR_CAST(attach);
 
diff --git a/drivers/accel/qaic/qaic_data.c b/drivers/accel/qaic/qaic_data.c
index 92d49448df72..88331028b7bf 100644
--- a/drivers/accel/qaic/qaic_data.c
+++ b/drivers/accel/qaic/qaic_data.c
@@ -850,7 +850,7 @@ struct drm_gem_object *qaic_gem_prime_import(struct drm_device *dev, struct dma_
 	obj = &bo->base;
 	get_dma_buf(dma_buf);
 
-	attach = dma_buf_attach(dma_buf, dev->dev);
+	attach = dma_buf_sgt_attach(dma_buf, dev->dev);
 	if (IS_ERR(attach)) {
 		ret = PTR_ERR(attach);
 		goto attach_fail;
diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
index 12604c60122e..06bc25eff079 100644
--- a/drivers/dma-buf/dma-buf.c
+++ b/drivers/dma-buf/dma-buf.c
@@ -671,7 +671,7 @@ static struct file *dma_buf_getfile(size_t size, int flags)
  * 2. Userspace passes this file-descriptors to all drivers it wants this buffer
  *    to share with: First the file descriptor is converted to a &dma_buf using
  *    dma_buf_get(). Then the buffer is attached to the device using
- *    dma_buf_attach().
+ *    dma_buf_sgt_attach().
  *
  *    Up to this stage the exporter is still free to migrate or reallocate the
  *    backing storage.
@@ -966,7 +966,7 @@ dma_buf_pin_on_map(struct dma_buf_attachment *attach)
  * 2. Importers must not hold the dma-buf reservation lock when calling these
  *    functions:
  *
- *     - dma_buf_attach()
+ *     - dma_buf_sgt_attach()
  *     - dma_buf_dynamic_attach()
  *     - dma_buf_detach()
  *     - dma_buf_export()
@@ -1100,15 +1100,15 @@ struct dma_buf_attachment *dma_buf_mapping_attach(
 EXPORT_SYMBOL_NS_GPL(dma_buf_mapping_attach, "DMA_BUF");
 
 /**
- * dma_buf_attach - Wrapper for dma_buf_mapping_attach
+ * dma_buf_sgt_attach - Wrapper for dma_buf_mapping_attach
  * @dmabuf:	[in]	buffer to attach device to.
  * @dev:	[in]	device to be attached.
  *
  * Wrapper to call dma_buf_mapping_attach() for drivers which still use a static
  * mapping.
  */
-struct dma_buf_attachment *dma_buf_attach(struct dma_buf *dmabuf,
-					  struct device *dev)
+struct dma_buf_attachment *dma_buf_sgt_attach(struct dma_buf *dmabuf,
+					      struct device *dev)
 {
 	struct dma_buf_mapping_match sgt_match[] = {
 		DMA_BUF_IMAPPING_SGT(dev, DMA_SGT_NO_P2P),
@@ -1117,7 +1117,7 @@ struct dma_buf_attachment *dma_buf_attach(struct dma_buf *dmabuf,
 	return dma_buf_mapping_attach(dmabuf, sgt_match, ARRAY_SIZE(sgt_match),
 				      NULL, NULL);
 }
-EXPORT_SYMBOL_NS_GPL(dma_buf_attach, "DMA_BUF");
+EXPORT_SYMBOL_NS_GPL(dma_buf_sgt_attach, "DMA_BUF");
 
 /**
  * dma_buf_dynamic_attach - Add the device to dma_buf's attachments list
@@ -1149,7 +1149,7 @@ EXPORT_SYMBOL_NS_GPL(dma_buf_dynamic_attach, "DMA_BUF");
  * @dmabuf:	[in]	buffer to detach from.
  * @attach:	[in]	attachment to be detached; is free'd after this call.
  *
- * Clean up a device attachment obtained by calling dma_buf_attach().
+ * Clean up a device attachment obtained by calling dma_buf_sgt_attach().
  *
  * Optionally this calls &dma_buf_ops.detach for device-specific detach.
  */
diff --git a/drivers/gpu/drm/armada/armada_gem.c b/drivers/gpu/drm/armada/armada_gem.c
index 72c7cd2b3fb9..438f33304eab 100644
--- a/drivers/gpu/drm/armada/armada_gem.c
+++ b/drivers/gpu/drm/armada/armada_gem.c
@@ -518,7 +518,7 @@ armada_gem_prime_import(struct drm_device *dev, struct dma_buf *buf)
 		}
 	}
 
-	attach = dma_buf_attach(buf, dev->dev);
+	attach = dma_buf_sgt_attach(buf, dev->dev);
 	if (IS_ERR(attach))
 		return ERR_CAST(attach);
 
diff --git a/drivers/gpu/drm/drm_gem_shmem_helper.c b/drivers/gpu/drm/drm_gem_shmem_helper.c
index d654a22a30de..9e937af2ee73 100644
--- a/drivers/gpu/drm/drm_gem_shmem_helper.c
+++ b/drivers/gpu/drm/drm_gem_shmem_helper.c
@@ -964,7 +964,7 @@ struct drm_gem_object *drm_gem_shmem_prime_import_no_map(struct drm_device *dev,
 		return obj;
 	}
 
-	attach = dma_buf_attach(dma_buf, dev->dev);
+	attach = dma_buf_sgt_attach(dma_buf, dev->dev);
 	if (IS_ERR(attach))
 		return ERR_CAST(attach);
 
diff --git a/drivers/gpu/drm/drm_prime.c b/drivers/gpu/drm/drm_prime.c
index 3ffbe3d28929..3084e8c28e53 100644
--- a/drivers/gpu/drm/drm_prime.c
+++ b/drivers/gpu/drm/drm_prime.c
@@ -999,7 +999,7 @@ struct drm_gem_object *drm_gem_prime_import_dev(struct drm_device *dev,
 	if (!dev->driver->gem_prime_import_sg_table)
 		return ERR_PTR(-EINVAL);
 
-	attach = dma_buf_attach(dma_buf, attach_dev);
+	attach = dma_buf_sgt_attach(dma_buf, attach_dev);
 	if (IS_ERR(attach))
 		return ERR_CAST(attach);
 
diff --git a/drivers/gpu/drm/i915/gem/i915_gem_dmabuf.c b/drivers/gpu/drm/i915/gem/i915_gem_dmabuf.c
index 7f939c281308..9865a7a9ad8f 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_dmabuf.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_dmabuf.c
@@ -306,7 +306,7 @@ struct drm_gem_object *i915_gem_prime_import(struct drm_device *dev,
 		return ERR_PTR(-E2BIG);
 
 	/* need to attach */
-	attach = dma_buf_attach(dma_buf, dev->dev);
+	attach = dma_buf_sgt_attach(dma_buf, dev->dev);
 	if (IS_ERR(attach))
 		return ERR_CAST(attach);
 
diff --git a/drivers/gpu/drm/i915/gem/selftests/i915_gem_dmabuf.c b/drivers/gpu/drm/i915/gem/selftests/i915_gem_dmabuf.c
index 6b6d235fd3e9..3c193e6d9d11 100644
--- a/drivers/gpu/drm/i915/gem/selftests/i915_gem_dmabuf.c
+++ b/drivers/gpu/drm/i915/gem/selftests/i915_gem_dmabuf.c
@@ -287,7 +287,7 @@ static int igt_dmabuf_import_same_driver(struct drm_i915_private *i915,
 		goto out_import;
 
 	/* Now try a fake an importer */
-	import_attach = dma_buf_attach(dmabuf, obj->base.dev->dev);
+	import_attach = dma_buf_sgt_attach(dmabuf, obj->base.dev->dev);
 	if (IS_ERR(import_attach)) {
 		err = PTR_ERR(import_attach);
 		goto out_import;
diff --git a/drivers/gpu/drm/omapdrm/omap_gem_dmabuf.c b/drivers/gpu/drm/omapdrm/omap_gem_dmabuf.c
index c549b94b2e8a..ca0962a99509 100644
--- a/drivers/gpu/drm/omapdrm/omap_gem_dmabuf.c
+++ b/drivers/gpu/drm/omapdrm/omap_gem_dmabuf.c
@@ -115,7 +115,7 @@ struct drm_gem_object *omap_gem_prime_import(struct drm_device *dev,
 		}
 	}
 
-	attach = dma_buf_attach(dma_buf, dev->dev);
+	attach = dma_buf_sgt_attach(dma_buf, dev->dev);
 	if (IS_ERR(attach))
 		return ERR_CAST(attach);
 
diff --git a/drivers/gpu/drm/tegra/gem.c b/drivers/gpu/drm/tegra/gem.c
index f06826fe8366..803409824711 100644
--- a/drivers/gpu/drm/tegra/gem.c
+++ b/drivers/gpu/drm/tegra/gem.c
@@ -81,7 +81,7 @@ static struct host1x_bo_mapping *tegra_bo_pin(struct device *dev, struct host1x_
 	if (obj->dma_buf) {
 		struct dma_buf *buf = obj->dma_buf;
 
-		map->attach = dma_buf_attach(buf, dev);
+		map->attach = dma_buf_sgt_attach(buf, dev);
 		if (IS_ERR(map->attach)) {
 			err = PTR_ERR(map->attach);
 			goto free;
@@ -475,7 +475,7 @@ static struct tegra_bo *tegra_bo_import(struct drm_device *drm,
 	 * domain, map it first to the DRM device to get an sgt.
 	 */
 	if (tegra->domain) {
-		attach = dma_buf_attach(buf, drm->dev);
+		attach = dma_buf_sgt_attach(buf, drm->dev);
 		if (IS_ERR(attach)) {
 			err = PTR_ERR(attach);
 			goto free;
diff --git a/drivers/iio/industrialio-buffer.c b/drivers/iio/industrialio-buffer.c
index f81154642bcd..abffbcc76c4c 100644
--- a/drivers/iio/industrialio-buffer.c
+++ b/drivers/iio/industrialio-buffer.c
@@ -1717,7 +1717,7 @@ static int iio_buffer_attach_dmabuf(struct iio_dev_buffer_pair *ib,
 		goto err_free_priv;
 	}
 
-	attach = dma_buf_attach(dmabuf, dma_dev);
+	attach = dma_buf_sgt_attach(dmabuf, dma_dev);
 	if (IS_ERR(attach)) {
 		err = PTR_ERR(attach);
 		goto err_dmabuf_put;
diff --git a/drivers/media/common/videobuf2/videobuf2-dma-contig.c b/drivers/media/common/videobuf2/videobuf2-dma-contig.c
index e13521b5c0e8..c7fa86cba8ad 100644
--- a/drivers/media/common/videobuf2/videobuf2-dma-contig.c
+++ b/drivers/media/common/videobuf2/videobuf2-dma-contig.c
@@ -789,7 +789,7 @@ static void *vb2_dc_attach_dmabuf(struct vb2_buffer *vb, struct device *dev,
 	buf->vb = vb;
 
 	/* create attachment for the dmabuf with the user device */
-	dba = dma_buf_attach(dbuf, buf->dev);
+	dba = dma_buf_sgt_attach(dbuf, buf->dev);
 	if (IS_ERR(dba)) {
 		pr_err("failed to attach dmabuf\n");
 		kfree(buf);
diff --git a/drivers/media/common/videobuf2/videobuf2-dma-sg.c b/drivers/media/common/videobuf2/videobuf2-dma-sg.c
index 59e346a5d48b..4c93b7f58e1f 100644
--- a/drivers/media/common/videobuf2/videobuf2-dma-sg.c
+++ b/drivers/media/common/videobuf2/videobuf2-dma-sg.c
@@ -638,7 +638,7 @@ static void *vb2_dma_sg_attach_dmabuf(struct vb2_buffer *vb, struct device *dev,
 
 	buf->dev = dev;
 	/* create attachment for the dmabuf with the user device */
-	dba = dma_buf_attach(dbuf, buf->dev);
+	dba = dma_buf_sgt_attach(dbuf, buf->dev);
 	if (IS_ERR(dba)) {
 		pr_err("failed to attach dmabuf\n");
 		kfree(buf);
diff --git a/drivers/media/platform/nvidia/tegra-vde/dmabuf-cache.c b/drivers/media/platform/nvidia/tegra-vde/dmabuf-cache.c
index 55d58a4dbbe2..d80282ebe4b4 100644
--- a/drivers/media/platform/nvidia/tegra-vde/dmabuf-cache.c
+++ b/drivers/media/platform/nvidia/tegra-vde/dmabuf-cache.c
@@ -96,7 +96,7 @@ int tegra_vde_dmabuf_cache_map(struct tegra_vde *vde,
 		goto ref;
 	}
 
-	attachment = dma_buf_attach(dmabuf, dev);
+	attachment = dma_buf_sgt_attach(dmabuf, dev);
 	if (IS_ERR(attachment)) {
 		dev_err(dev, "Failed to attach dmabuf\n");
 		err = PTR_ERR(attachment);
diff --git a/drivers/misc/fastrpc.c b/drivers/misc/fastrpc.c
index 375ce39c78c9..24ae1038b634 100644
--- a/drivers/misc/fastrpc.c
+++ b/drivers/misc/fastrpc.c
@@ -904,7 +904,7 @@ static int fastrpc_map_attach(struct fastrpc_user *fl, int fd,
 		goto get_err;
 	}
 
-	map->attach = dma_buf_attach(map->buf, sess->dev);
+	map->attach = dma_buf_sgt_attach(map->buf, sess->dev);
 	if (IS_ERR(map->attach)) {
 		dev_err(sess->dev, "Failed to attach dmabuf\n");
 		err = PTR_ERR(map->attach);
diff --git a/drivers/usb/gadget/function/f_fs.c b/drivers/usb/gadget/function/f_fs.c
index 4016edfa4c02..bfa24bcfe84c 100644
--- a/drivers/usb/gadget/function/f_fs.c
+++ b/drivers/usb/gadget/function/f_fs.c
@@ -1549,7 +1549,7 @@ static int ffs_dmabuf_attach(struct file *file, int fd)
 	if (IS_ERR(dmabuf))
 		return PTR_ERR(dmabuf);
 
-	attach = dma_buf_attach(dmabuf, gadget->dev.parent);
+	attach = dma_buf_sgt_attach(dmabuf, gadget->dev.parent);
 	if (IS_ERR(attach)) {
 		err = PTR_ERR(attach);
 		goto err_dmabuf_put;
diff --git a/drivers/xen/gntdev-dmabuf.c b/drivers/xen/gntdev-dmabuf.c
index cd851eb04a69..e7ffb546e717 100644
--- a/drivers/xen/gntdev-dmabuf.c
+++ b/drivers/xen/gntdev-dmabuf.c
@@ -580,7 +580,7 @@ dmabuf_imp_to_refs(struct gntdev_dmabuf_priv *priv, struct device *dev,
 	gntdev_dmabuf->priv = priv;
 	gntdev_dmabuf->fd = fd;
 
-	attach = dma_buf_attach(dma_buf, dev);
+	attach = dma_buf_sgt_attach(dma_buf, dev);
 	if (IS_ERR(attach)) {
 		ret = ERR_CAST(attach);
 		goto fail_free_obj;
diff --git a/include/linux/dma-buf.h b/include/linux/dma-buf.h
index b264e1c4a9df..208752eb93d9 100644
--- a/include/linux/dma-buf.h
+++ b/include/linux/dma-buf.h
@@ -77,7 +77,7 @@ struct dma_buf_ops {
 	/**
 	 * @attach:
 	 *
-	 * This is called from dma_buf_attach() to make sure that a given
+	 * This is called from dma_buf_sgt_attach() to make sure that a given
 	 * &dma_buf_attachment.dev can access the provided &dma_buf. Exporters
 	 * which support buffer objects in special locations like VRAM or
 	 * device-specific carveout areas should check whether the buffer could
@@ -125,7 +125,7 @@ struct dma_buf_ops {
 	 * exclusive with @cache_sgt_mapping.
 	 *
 	 * This is called automatically for non-dynamic importers from
-	 * dma_buf_attach().
+	 * dma_buf_sgt_attach().
 	 *
 	 * Note that similar to non-dynamic exporters in their @map_dma_buf
 	 * callback the driver must guarantee that the memory is available for
@@ -513,7 +513,7 @@ struct dma_buf_attach_ops {
  * and its user device(s). The list contains one attachment struct per device
  * attached to the buffer.
  *
- * An attachment is created by calling dma_buf_attach(), and released again by
+ * An attachment is created by calling dma_buf_sgt_attach(), and released again by
  * calling dma_buf_detach(). The DMA mapping itself needed to initiate a
  * transfer is created by dma_buf_sgt_map_attachment() and freed again by calling
  * dma_buf_sgt_unmap_attachment().
@@ -591,8 +591,8 @@ static inline bool dma_buf_is_dynamic(struct dma_buf *dmabuf)
 	return !!dmabuf->ops->pin;
 }
 
-struct dma_buf_attachment *dma_buf_attach(struct dma_buf *dmabuf,
-					  struct device *dev);
+struct dma_buf_attachment *dma_buf_sgt_attach(struct dma_buf *dmabuf,
+					      struct device *dev);
 struct dma_buf_attachment *
 dma_buf_dynamic_attach(struct dma_buf *dmabuf, struct device *dev,
 		       const struct dma_buf_attach_ops *importer_ops,
diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 67f74ce4f096..2cbf65b29f89 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -175,7 +175,7 @@ static int io_import_dmabuf(struct io_zcrx_ifq *ifq,
 		goto err;
 	}
 
-	mem->attach = dma_buf_attach(mem->dmabuf, ifq->dev);
+	mem->attach = dma_buf_sgt_attach(mem->dmabuf, ifq->dev);
 	if (IS_ERR(mem->attach)) {
 		ret = PTR_ERR(mem->attach);
 		mem->attach = NULL;
diff --git a/net/core/devmem.c b/net/core/devmem.c
index f30fa375c9ab..d7c08da306cf 100644
--- a/net/core/devmem.c
+++ b/net/core/devmem.c
@@ -234,7 +234,7 @@ net_devmem_bind_dmabuf(struct net_device *dev, void *vdev,
 	binding->dmabuf = dmabuf;
 	binding->direction = direction;
 
-	binding->attachment = dma_buf_attach(binding->dmabuf, dma_dev);
+	binding->attachment = dma_buf_sgt_attach(binding->dmabuf, dma_dev);
 	if (IS_ERR(binding->attachment)) {
 		err = PTR_ERR(binding->attachment);
 		NL_SET_ERR_MSG(extack, "Failed to bind dmabuf to device");
-- 
2.54.0

