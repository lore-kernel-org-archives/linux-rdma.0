Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.195.7
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792993048;
	b=p2ht7rqwECXjGIWCTCKvUUNfWAnYvh9V1braaXozppBtAbg+Mjh6v4ipLshiXdp4weDB
	 34HH9MddIYb/Zfbnu/MMuBfO+o1+4qyI0TKe4+xSwOtCRjWAGAut4mxfx6/Fau9y6asMk
	 ZntkC2jxu7MByIO5M3xX066cH0NoR700DlJonddxQyoiPblX9gn1ildy6nW2TFC6g5pz9
	 CLJkvFpsHrHUq6Z7xl+b041nHIqIpjtwCp24H+cTEimGCGiPOOHPZaYMiKOi2BEUKOl7+
	 1WFT9GByCLiFSHl3FSppxWyt4Z45QuZFvhFXvXX3B5l0Jm90wPbDJVxuti0kVf9RkrQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792993048;
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
	bh=ibJdaxhxiBH/BarJL3RRqj1POXUzQYYufraBze7TE8g=;
	b=ODDcKd4U+GJb/ef6vl6XcflQRHgZfmpH9u/fdskVJePpzPoLyBaTQkRDxW1qQhHQC09m
	 8DuECJDBYwCpFg1YDULXWp2rWt5WbrCc+MctZ5tuWnuDVvhGtgA6PKDambcuR/Ud16RdR
	 0NfgwaDOlth/bQsmkVcMRYovsG8ceY1CciVaT0F6DjiKgJokg2/pfXDqunVGBmqEBJUR9
	 G9X7IIKCR5m3IdOu3290NbugOQz5UkxS8C+t4dzNcDxNiwBtkkH7inlKUfDWdsRTkV/1W
	 rKKSvayCgKEO4U71KkyqNQ0N2Mzf56XP8297mb5aVgGSuJJaUJE1S0eqhL3FUe5HT7g==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=iFfF+2Ox;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.195.7
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012007.outbound.protection.outlook.com [40.93.195.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0742B60A261D;
	Mon, 26 Oct 2026 05:37:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0742B60A261D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=iFfF+2Ox
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HlqXX3dtYIKG7ZdnWSaXC1Bcf6WHDMJgxxXYxJYwa9oTSGTsYpsotO3VZAqr5sNqkfLen7aI/sPZ7OZYyZkR/6yk5uw0p2tS9PNqkJiHxvbGDIBeXEZFgbJZTfU+gHOw3aHct71Jkg++iEvs/P3Nw+1nv4MNZzjHx8wN+4EtGl78SyWG4L17Vx/ktcaGu721NjdFfYpN4R4TDEgfCXVZTEjMnuZB1lSUxzyrQ/bdSwrex5liQ01m2J72oFTvPZ1V8i0iNzYycAcRsaV5afRQOQWk6/xxD9objsjUSigwxfqjyRNys3+wJBjyOdOLA1lBgl12VRoTPxfGbP5hJ/e0RA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ibJdaxhxiBH/BarJL3RRqj1POXUzQYYufraBze7TE8g=;
 b=HtuZ+fcmCfNeJf548N4DzMK0ljkoZCHCwD6raJ+Pe9EBGEmyJW7+EP+0PGkxCY2/pBCscqJeKJUMENo3uWapbbPZEtsEeU5oy/ymxWbu8aLz62b4TLfvwSvoRWrWTF+5vJ6qyR+bUyUQ64EEROvBrLllch5RJVF8q9SyhceTyoz1C+FL58Yf2wwfcJjoaD/HKcZe7jOHddQ9CeqyiFutEu5uT9aq1Hgl/UeNtmFFxrCPEoWs5gQghgXBCgERz9O2nrlYav3PpKYyoVI2+6Zs5V5vcMIenZDJFaZMEOfH6oU5QbplVHOyy6b+a58u4HB2XHLWMhMFBXCufQUhsSwpaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ibJdaxhxiBH/BarJL3RRqj1POXUzQYYufraBze7TE8g=;
 b=iFfF+2OxOudwgF6s2weFZmu9rkYoJfbSUisj75dQxw43kLyt937ue9GdV+b2qU2WwcKt2E2W93nHD/HbZgoYNYx/mwwSpPLFYk7Z3c3fXAaJuYdxK/FiIF2+ugpmRjHa/D7tXpjVs6S84WC35A8Q5FZrjdck3Gm8er1LVS1BTdDIOPqJAXX1wOi9LLpF1pC9o2dT8XCqp6GDPd0BkHWr8oyApGO5LQXyc7nDalW+nAaE29vdPK1C7jhrVpiH9m+PBkrndFAgrFYaGGTm3TYKZgiBXOEWQwkOOk+KwvUAA0bgx/Bt9MUd7xPdXPuBXsq0q4GEetOYWvlvuzWku5vvrA==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SA3PR12MB598757.namprd12.prod.outlook.com
 (2603:10b6:806:52d::14) by SA1PR12MB7442.namprd12.prod.outlook.com
 (2603:10b6:806:2b5::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Mon, 26 Oct
 2026 05:36:59 +0000
Received: from SA3PR12MB598757.namprd12.prod.outlook.com
 ([fe80::e206:100:5946:a777]) by SA3PR12MB598757.namprd12.prod.outlook.com
 ([fe80::e206:100:5946:a777%5]) with mapi id 15.21.0546.021; Mon, 26 Oct 2026
 05:36:59 +0000
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
Subject: [PATCH 05/26] dma-buf: Let the exporter select mapping type at pin/map
Date: Mon, 26 Oct 2026 16:35:56 +1100
Message-ID: <20261026053623.202642-6-apopple@nvidia.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261026053623.202642-1-apopple@nvidia.com>
References: <20261026053623.202642-1-apopple@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SY5P300CA0084.AUSP300.PROD.OUTLOOK.COM
 (2603:10c6:10:247::22) To SA3PR12MB598757.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA3PR12MB598757:EE_|SA1PR12MB7442:EE_
X-MS-Office365-Filtering-Correlation-Id: 6f668949-c7e5-4ec7-a8b7-08df332327fb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|7416014|1800799024|366016|18002099003|6133799003|22082099003|56012099006|11063799006|5023799004|261022075727099003|261021123027099003|10067099003|261009223027099003|261021121427099003|261022105027099003;
X-Microsoft-Antispam-Message-Info:
	9HTGuhwqhc0/dYL5YxpCKdUzrnw05OY80/s0lqQTW+uUkR2WgwVTvlahb50kyN616OfdNdqfliMsfgCn+0IZJsWDjWorEHjwV9HRtXqe7fnZUckvuWJSDU5VLwe1fy5YdvlE12p0dKDy7BVQpYq7YxALDAq4u40lDBlN6sXJRsFFgw+4lM1Ge4Z52jB2+Ydcgr6S5MnERVDbOFdXT2YKz9zVRVzcPwoRUB2rqkfLBfRqvpRX3j9cM/tV7IIdmDnGkVoDFqvYSD5YoudQgC3R0gTDb4mdsMJF01Z/jDtzyH1Ixne9ubVTwHs2Gx5gylI9VhNhpmAfK9/D7gWIEBORuZQWCSwkhpV7qrhx7tj87stz3tl6UMv2Gjko29VWg9p6Pp6L9xStVZCdVOBOnQPWawDL5cfNpNQF+aQB3rLQk/XyEecJTO9eul0Cos2XiCv7Crl2PEwbza3DoeNLZOCfp4svo3+/1aqbTB7/AhZo8iJT6nlD5YOTWrOhy4ro76xIvuOKepmJesjzsY7rOOQsFUeulcYsCGI1d9e2hqox78UyDXjfQq889tq0AbsIJMnoJrzgPzWuqdJS4GiUQzBt+VrfRMr1v24eG/EL+f4jro2QP2nltfe/jcSa5dxbjSgh7y+z8hjrsTs24ndiHNynqhYRKWu/rNp2Z9IJhQAu6Jw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA3PR12MB598757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(7416014)(1800799024)(366016)(18002099003)(6133799003)(22082099003)(56012099006)(11063799006)(5023799004)(261022075727099003)(261021123027099003)(10067099003)(261009223027099003)(261021121427099003)(261022105027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?KhQ8fHI0AjU8pleuxtRVfCA+xgvYz11qvkhiv6VvEy201/9DgFjsYmq/U/dd?=
 =?us-ascii?Q?iw0l8GTbRCg6VcfHnIPvAmTv+Goe8b0SCfbrYpQNeMX15dIVMJmHMMYPAAeU?=
 =?us-ascii?Q?VX8ObvCZFy4O+JcZ87aTDuH0SDRj/hhlKBdPMhKoAEyls1Fy7QB/8/PJoRSs?=
 =?us-ascii?Q?vss0QePYk7Q7jVXnJXcqbq/XBmzfjM7NPujxvp2wI+Ss2l2JIlL8tdaSxhAC?=
 =?us-ascii?Q?n+mA2j7NkynyVsdcNmADS56ifucunTbOq1bz7VLY8mIcFWexiZhThUQQAOya?=
 =?us-ascii?Q?knZFAtqVpndtPbxAw+IqdA2ykQ1Z0VH05TS/MheE9XINaQWjSmKkqZB43MUa?=
 =?us-ascii?Q?ByF5gQXAJ9J9LiK3kgpNHVX53KYGtU76WCOsVRzZMEfXdfLh1hWpjx4nwQ6W?=
 =?us-ascii?Q?fMduBTFN07AA/GAF5iLbUeArjL4jeNlqlaXSrEH6w1C6C2Fkyt93MzfvXke+?=
 =?us-ascii?Q?5O96fc5wUQF6zMncK0jjfc1mEx+acbLEBOXWVOwLbZMttcdMeaNQnUitMFIY?=
 =?us-ascii?Q?TK51Llkw4XQltc9L2CiCHJrf9pbwLvUQqf+OjeAm7h6n4xiltDtMord3H7sX?=
 =?us-ascii?Q?3xA3laegLAK8qAI0rALEK2b/iKSmMJcWsysKGz2zdJSMBjw3JmgHACSX5hX5?=
 =?us-ascii?Q?nLC52713CiTr8de6ELsejQrmCMdt+UcxB7bPPk/H9K6/xfelkQ4NWdHPellO?=
 =?us-ascii?Q?lxm+msoahUzrqjQpc+3oLMfzzHCQEZg3ngiJ6vMg56aQ986vfReTSNuhCrl9?=
 =?us-ascii?Q?0dfp/3N5ahJLhhgF1D/5HUkKGWm7q3PU/XtD+aeht+2gJi8+gOdl0dHDiJtw?=
 =?us-ascii?Q?JXxfhYLaCEa6UHnA1nIspSG/W5Mpgw6vF+sXZ3aBVbaHm15hR5OO9ZPqe/KI?=
 =?us-ascii?Q?DsVli2pMKFJwVSndwMhPGf7fRpi0Xvxmc6CbjRxBvSRyN0Ro4Rgm09gct56g?=
 =?us-ascii?Q?hew2K5o+0WjpbKR1txZAk5UWsQLlMOJEvO6OxJE4wfVaVqRaVkk8/IuEbf5d?=
 =?us-ascii?Q?7/G9YlmWJiz86baW0lQTkhOwmA9vPTcffifoPyeTYsXp5NwddOGc/pE3aEpZ?=
 =?us-ascii?Q?h8FUuE1CZntNtczsKUm2q+sVLDAJQrOvEXKWpHlpWOrcURjFv7mjuj2iOUft?=
 =?us-ascii?Q?zrgpOlf0qOUgBn/yeL8gyXIQHJZxK4kyzdsi2KGxhIBp32IrQdjVuz7+afoY?=
 =?us-ascii?Q?OXYqVNwbaoYpOd2ymdxZcjQ9MnlfBJYhNVZK2mRV67ctLD9hsdqZorZR93zW?=
 =?us-ascii?Q?nJR6RenBF6NODQU/jSzlLMuEoHjaWcbAc4n6IrLdvsovLUVJ+u02h2NN7obL?=
 =?us-ascii?Q?XshAXfJuiRJmMPy0kolLlx9VC5/PyyQ+A7ntWLumXFrH5C9XnMTsocSy2FZO?=
 =?us-ascii?Q?yHaGp0zHs9gIRHbNRT8/O61rSuKd6htV3U8AzLp1iFFwS/E4Ie1Yj4ry0awm?=
 =?us-ascii?Q?GbISQED53S+UWB3xRpVoJ8+MaZE5ohCY3rjhR84/7bR1QL53YMR7+eTK08/5?=
 =?us-ascii?Q?koRuNR/fWZL3vgcn5KtdPGcN7BmiqBB/qsAALsGpQYOm48isXqyQulLhSTLY?=
 =?us-ascii?Q?3aMh6fl7lrg/q9J6vNIFpSBh1UMxxGUdWPdSCZ2gV3LpIRrVr2hte55kAlZJ?=
 =?us-ascii?Q?rEsq8E9/BErKjh3IrvJ/yuXimn+aYGqua7yUr7IFlCKvkf22XoJ/Zh/gb2wa?=
 =?us-ascii?Q?pt6c43Fw28BnunWqXmKcP7we8CGKIJN/odqJOjRcUT7vIjVKv3ikhvYWw22I?=
 =?us-ascii?Q?sdgE5qfPpQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f668949-c7e5-4ec7-a8b7-08df332327fb
X-MS-Exchange-CrossTenant-AuthSource: SA3PR12MB598757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2026 05:36:59.8385
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: co+6KZpNDYJ8m29hPgNsl7lpNEYkPuVrEzTzTO/uCmE6oucYXVwVM9uuPEq5PDGRL43wsKoUGPCAVlEMk1P9bw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7442

The match set negotiated at attach determines which types an attachment
could possibly be served with. Which one should actually be served
depends on where the buffer is and other attachments when an importer
first pins or maps. So far the first entry was used unconditionally,
even if it cannot be served to some importers.

Add dma_buf_ops.select_mapping() under dma_resv from both pin and map
paths before the type's map callback to let the exporter choose which to
serve based on the current placement and list of attachments.

The choice is recorded in attach->selected and does not call
select_mapping again across any number of unmaps and remaps, until
dma_buf_invalidate_mappings() has been delivered to the attachment.

This prevents importer remap from bouncing a buffer between placements
- the type cannot change without the exporter explicitly invalidating
first. In other words attachments that are never invalidated keep the
initially selected type for the life of the attachment.

A failed select or map establishes nothing and leaves the choice open.

Importers never select. The importer's list order is a preference the
exporter may weigh or ignore, and an importer must accept any type it
listed.

Assisted-by: LLM
Signed-off-by: Alistair Popple <apopple@nvidia.com>
---
 drivers/dma-buf/dma-buf-mapping.c | 49 ++++++++++++++-
 drivers/dma-buf/dma-buf.c         | 99 +++++++++++++++++++++----------
 include/linux/dma-buf-mapping.h   |  6 ++
 include/linux/dma-buf.h           | 39 +++++++++++-
 4 files changed, 156 insertions(+), 37 deletions(-)

diff --git a/drivers/dma-buf/dma-buf-mapping.c b/drivers/dma-buf/dma-buf-mapping.c
index d30c0e9ef038..dbcd83b6dcff 100644
--- a/drivers/dma-buf/dma-buf-mapping.c
+++ b/drivers/dma-buf/dma-buf-mapping.c
@@ -270,8 +270,9 @@ EXPORT_SYMBOL_NS_GPL(dma_buf_free_sgt, "DMA_BUF");
  * Walk the exporter's list in order and, for each entry, find the first
  * importer entry of the same type that the type's match() callback accepts.
  * Every such pair is recorded in @args->attach->matches, so the match set
- * preserves the exporter's priority. The first entry becomes the default in
- * @args->attach->map_type.
+ * preserves the exporter's priority. The first entry becomes the default
+ * selection in @args->attach->map_type until &dma_buf_ops.select_mapping
+ * chooses otherwise at pin or map time.
  *
  * Because the exporter list is walked in order, the exporter controls the
  * priority of mapping types.
@@ -321,6 +322,50 @@ int dma_buf_match_mapping(struct dma_buf_match_args *args,
 }
 EXPORT_SYMBOL_NS_GPL(dma_buf_match_mapping, "DMA_BUF");
 
+/**
+ * dma_buf_mapping_select - Let the exporter choose the type to map with
+ * @attach: Attachment about to be pinned or mapped
+ *
+ * Called with the dma_resv lock held by dma_buf_pin() and the map functions.
+ * The first call after attach, and after each dma_buf_invalidate_mappings(),
+ * asks &dma_buf_ops.select_mapping to pick an entry of the match set given
+ * the buffer's placement and the other live mappings; exporters without the
+ * callback get the first entry. Every other call returns the previous choice
+ * unchanged, so the mapping type cannot change between unmap and remap without
+ * the exporter having explicitly invalidated.
+ *
+ * Returns: 0 on success or the exporter's error, typically -EBUSY when the
+ * attachment cannot be served without disturbing a mapping that cannot be
+ * invalidated.
+ */
+int dma_buf_mapping_select(struct dma_buf_attachment *attach)
+{
+	const struct dma_buf_mapping_match *match;
+
+	dma_resv_assert_held(attach->dmabuf->resv);
+
+	if (attach->selected)
+		return 0;
+
+	if (WARN_ON(!attach->nr_matches))
+		return -EINVAL;
+
+	if (attach->dmabuf->ops->select_mapping) {
+		match = attach->dmabuf->ops->select_mapping(attach);
+		if (IS_ERR(match))
+			return PTR_ERR(match);
+		if (WARN_ON(match < attach->matches ||
+			    match >= attach->matches + attach->nr_matches))
+			return -EINVAL;
+	} else {
+		match = &attach->matches[0];
+	}
+
+	attach->map_type = *match;
+	attach->selected = true;
+	return 0;
+}
+
 static int dma_buf_sgt_match(struct dma_buf *dmabuf,
 			     const struct dma_buf_mapping_match *exp,
 			     const struct dma_buf_mapping_match *imp)
diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
index 348b47f266b4..03f06c4b957c 100644
--- a/drivers/dma-buf/dma-buf.c
+++ b/drivers/dma-buf/dma-buf.c
@@ -1201,6 +1201,10 @@ int dma_buf_pin(struct dma_buf_attachment *attach)
 
 	dma_resv_assert_held(dmabuf->resv);
 
+	ret = dma_buf_mapping_select(attach);
+	if (ret)
+		return ret;
+
 	if (dmabuf->ops->pin)
 		ret = dmabuf->ops->pin(attach);
 
@@ -1229,42 +1233,19 @@ void dma_buf_unpin(struct dma_buf_attachment *attach)
 }
 EXPORT_SYMBOL_NS_GPL(dma_buf_unpin, "DMA_BUF");
 
-/**
- * dma_buf_map_attachment - Returns the scatterlist table of the attachment;
- * mapped into _device_ address space. Is a wrapper for map_dma_buf() of the
- * dma_buf_ops.
- * @attach:	[in]	attachment whose scatterlist is to be returned
- * @direction:	[in]	direction of DMA transfer
- *
- * Returns sg_table containing the scatterlist to be returned; returns ERR_PTR
- * on error. May return -EINTR if it is interrupted by a signal.
- *
- * On success, the DMA addresses and lengths in the returned scatterlist are
- * PAGE_SIZE aligned.
- *
- * A mapping must be unmapped by using dma_buf_unmap_attachment(). Note that
- * the underlying backing storage is pinned for as long as a mapping exists,
- * therefore users/importers should not hold onto a mapping for undue amounts of
- * time.
- *
- * Important: Dynamic importers must wait for the exclusive fence of the struct
- * dma_resv attached to the DMA-BUF first.
- */
-struct sg_table *dma_buf_map_attachment(struct dma_buf_attachment *attach,
-					enum dma_data_direction direction)
+/* The SGT type must have been selected into attach->map_type already */
+static struct sg_table *
+__dma_buf_sgt_map_attachment(struct dma_buf_attachment *attach,
+			     enum dma_data_direction direction)
 {
 	const struct dma_buf_mapping_sgt_exp_ops *sgt_exp_ops =
 		dma_buf_get_sgt_ops(attach);
 	struct sg_table *sg_table;
 	signed long ret;
 
-	might_sleep();
-
-	if (WARN_ON(!attach || !attach->dmabuf || !sgt_exp_ops))
+	if (WARN_ON(!sgt_exp_ops))
 		return ERR_PTR(-EINVAL);
 
-	dma_resv_assert_held(attach->dmabuf->resv);
-
 	if (dma_buf_pin_on_map(attach)) {
 		ret = attach->dmabuf->ops->pin(attach);
 		/*
@@ -1324,6 +1305,52 @@ struct sg_table *dma_buf_map_attachment(struct dma_buf_attachment *attach,
 
 	return sg_table;
 }
+
+/**
+ * dma_buf_map_attachment - Returns the scatterlist table of the attachment;
+ * mapped into _device_ address space. Is a wrapper for map_dma_buf() of the
+ * dma_buf_ops.
+ * @attach:	[in]	attachment whose scatterlist is to be returned
+ * @direction:	[in]	direction of DMA transfer
+ *
+ * Returns sg_table containing the scatterlist to be returned; returns ERR_PTR
+ * on error. May return -EINTR if it is interrupted by a signal.
+ *
+ * On success, the DMA addresses and lengths in the returned scatterlist are
+ * PAGE_SIZE aligned.
+ *
+ * A mapping must be unmapped by using dma_buf_unmap_attachment(). Note that
+ * the underlying backing storage is pinned for as long as a mapping exists,
+ * therefore users/importers should not hold onto a mapping for undue amounts of
+ * time.
+ *
+ * Important: Dynamic importers must wait for the exclusive fence of the struct
+ * dma_resv attached to the DMA-BUF first.
+ */
+struct sg_table *dma_buf_map_attachment(struct dma_buf_attachment *attach,
+					enum dma_data_direction direction)
+{
+	struct sg_table *sg_table;
+	int ret;
+
+	might_sleep();
+
+	if (WARN_ON(!attach || !attach->dmabuf))
+		return ERR_PTR(-EINVAL);
+
+	dma_resv_assert_held(attach->dmabuf->resv);
+
+	ret = dma_buf_mapping_select(attach);
+	if (ret)
+		return ERR_PTR(ret);
+
+	sg_table = __dma_buf_sgt_map_attachment(attach, direction);
+	if (IS_ERR(sg_table))
+		/* Nothing was established, so the choice may be made afresh */
+		attach->selected = false;
+
+	return sg_table;
+}
 EXPORT_SYMBOL_NS_GPL(dma_buf_map_attachment, "DMA_BUF");
 
 /**
@@ -1465,6 +1492,10 @@ EXPORT_SYMBOL_NS_GPL(dma_buf_attach_revocable, "DMA_BUF");
  *
  * Importers are free to request a new mapping in parallel as this function
  * returns.
+ *
+ * This is also the only point at which an attachment's mapping type
+ * may change after a pin/map: the core keeps the type chosen by
+ * &dma_buf_ops.select_mapping until the attachment has been invalidated here.
  */
 void dma_buf_invalidate_mappings(struct dma_buf *dmabuf)
 {
@@ -1472,10 +1503,14 @@ void dma_buf_invalidate_mappings(struct dma_buf *dmabuf)
 
 	dma_resv_assert_held(dmabuf->resv);
 
-	list_for_each_entry(attach, &dmabuf->attachments, node)
-		if (attach->importer_ops &&
-		    attach->importer_ops->invalidate_mappings)
-			attach->importer_ops->invalidate_mappings(attach);
+	list_for_each_entry(attach, &dmabuf->attachments, node) {
+		if (!attach->importer_ops ||
+		    !attach->importer_ops->invalidate_mappings)
+			continue;
+
+		attach->selected = false;
+		attach->importer_ops->invalidate_mappings(attach);
+	}
 }
 EXPORT_SYMBOL_NS_GPL(dma_buf_invalidate_mappings, "DMA_BUF");
 
diff --git a/include/linux/dma-buf-mapping.h b/include/linux/dma-buf-mapping.h
index f9b749af362b..c04fac71726a 100644
--- a/include/linux/dma-buf-mapping.h
+++ b/include/linux/dma-buf-mapping.h
@@ -96,6 +96,12 @@ int dma_buf_match_mapping(struct dma_buf_match_args *args,
 			  const struct dma_buf_mapping_match *exp_mappings,
 			  size_t exp_len);
 
+/*
+ * Internal: Selection is made by exporters through &dma_buf_ops.select_mapping
+ * in dma_buf_pin() or map paths. Importers never call this.
+ */
+int dma_buf_mapping_select(struct dma_buf_attachment *attach);
+
 /*
  * DMA Mapped Scatterlist Type
  *
diff --git a/include/linux/dma-buf.h b/include/linux/dma-buf.h
index 83ab2902a23b..8bd5026eb642 100644
--- a/include/linux/dma-buf.h
+++ b/include/linux/dma-buf.h
@@ -337,6 +337,34 @@ struct dma_buf_ops {
 	 * any time until the final location is resolved during map/pin.
 	 */
 	int (*match_mapping)(struct dma_buf_match_args *args);
+
+	/**
+	 * @select_mapping:
+	 *
+	 * Called with the dma_resv lock held from dma_buf_pin() and from the
+	 * map functions, before the type's map callback, to choose which
+	 * entry of &dma_buf_attachment.matches this attachment is mapped
+	 * with. The exporter settles the buffer's placement here, taking all
+	 * live mappings and pinned attachments into account, and returns the
+	 * entry that placement can serve.
+	 *
+	 * The core records the choice and does not ask again, across any
+	 * number of unmaps and remaps, until the exporter has delivered
+	 * &dma_buf_attach_ops.invalidate_mappings to this attachment. The
+	 * exporter must therefore keep the recorded type servable: moving the
+	 * buffer somewhere that type cannot be produced from requires
+	 * invalidating first. Attachments that cannot be invalidated keep
+	 * their first choice for life.
+	 *
+	 * Optional. Without it the first entry of the match set, the
+	 * exporter's most preferred, is used.
+	 *
+	 * Returns: a pointer into &dma_buf_attachment.matches, or an ERR_PTR.
+	 * -EBUSY means the attachment cannot be served without disturbing a
+	 * mapping that cannot be invalidated.
+	 */
+	const struct dma_buf_mapping_match *(*select_mapping)(
+		struct dma_buf_attachment *attach);
 };
 
 /**
@@ -532,12 +560,16 @@ struct dma_buf_attach_ops {
  * @importer_ops: importer operations for this attachment, if provided
  * dma_buf_map/unmap_attachment() must be called with the dma_resv lock held.
  * @importer_priv: importer specific attachment data.
- * @map_type: The match this attachment is mapped with. Until the exporter
- *            selects otherwise it holds the exporter's default, the first
- *            entry of @matches.
+ * @map_type: The match this attachment is mapped with. Chosen by
+ *            &dma_buf_ops.select_mapping at the first pin or map and kept,
+ *            enforced by the core, until &dma_buf_attach_ops.invalidate_mappings
+ *            is delivered to this attachment. Before the first selection it
+ *            holds the exporter's default, the first entry of @matches.
  * @matches: The match set negotiated at attach time: every mapping type both
  *           sides accept, in the exporter's order of preference.
  * @nr_matches: Number of valid entries in @matches.
+ * @selected: True once @map_type has been chosen by the exporter; cleared
+ *            only by dma_buf_invalidate_mappings().
  *
  * This structure holds the attachment information between the dma_buf buffer
  * and its user device(s). The list contains one attachment struct per device
@@ -559,6 +591,7 @@ struct dma_buf_attachment {
 	struct dma_buf_mapping_match map_type;
 	struct dma_buf_mapping_match matches[DMA_BUF_MAX_MATCHES];
 	unsigned int nr_matches;
+	bool selected;
 };
 
 /**
-- 
2.54.0

