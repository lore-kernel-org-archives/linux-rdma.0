Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.53.41
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792993092;
	b=sRrnVgx9D3RPyuzOK12x5P9AsVtw1p7uffDqH5XQqUIr87DxgLxV3JTQf+g2ILBfgsPS
	 vPyw/Ere+PWqSV81GaBHdrGJcUenPOL8eewGB1Wgp80zlWOjH42GIUu5/PVJSzGhmhaVb
	 kF4hKraODql0jcp+x4N4zPER4Ejp6SmZid+1XYu/Zc8PFQavSlalBxdEI2znIqUDAuAFz
	 /TvTDCjvEB62DN4Ezw8NEsJC2+RFV+s5XbI8vkm1IIwR65PdCimejUc73IIrdBPNf0pMK
	 8ZA/QReAZ+6WobpR4cgtCo+jG8pXiFtMLOlkaVxOLrdN1nF+ZrgZqF8TZZqwdXkvHfA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792993092;
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
	bh=TeESoJB+r+SIwpshRKsxhkXVtUKSxkyLATsiV/y/xmY=;
	b=L0RA4NFvEttwmGpR6bw25PmHyjA1nuCneyZsuXYWcdUcJgRbt9t9rCQgIBPh4Ftq2gl5
	 UDMElW1Reidn+HH1fPt1IrJvviLZMikzE7Vd5A5St1zitf/GOdhLltLaa7/LnQbxA/q/L
	 p9YGcAls4mM7ilQ53FVxOqmWjFIqcflSb6VYkdugymaxun3SCFexckFVJq2b62Wd9TD13
	 SHNEo0RLxMxroBwgA4rpSRf2S50Z4UUlyS59sWgt3Ur8vNS6TU3YCAqRTIiNfCk0X4Z9L
	 VD4SetEDWsrH4kwSu6cXYHR4355HeZm559h56SKRWWqoVmS720NjXSZuKrGVwaA8qBQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=qgx8czUO;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.53.41
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012041.outbound.protection.outlook.com [52.101.53.41])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DAAF606D325;
	Mon, 26 Oct 2026 05:38:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9DAAF606D325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=qgx8czUO
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=njuQ8r1bmF8dCPb0t0p9maCsjMRAphu8Un+V8qxKPRmmwcfC0aV3BlydtU7sZVrtBd2+mSB1ugYeHDRLcj8rhiMj/6cwAvDJFgfDdoyr45VUmJjhtI4EPivIbpuJsqDIJ126MNKZYKDQMwvwTlTbo9+h5O+Qb12RrjCDpCwADB4hwGaMsSF55512fprFGlE8hpXlLTMuIjjg20Wh43mdC7nBO0Fc1JrGxBoUskeCkrZPnhhsJf3DYqn8gUHF4WxoueEZmfsIHaY0Z9g8TEkXwZaaYNFc1voGj7dvdRbKN+SGSFypGv+aF60dd7jihArUwu+RWjn25l3e8/myx1JYhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TeESoJB+r+SIwpshRKsxhkXVtUKSxkyLATsiV/y/xmY=;
 b=RaDbDSlzzv8EFtalTQaOhDmmReb0jjdFQx+/+FO/HAqgcS+Y4eTqG28QQiDAoKWSHCnZniBdu9nXm9nZ9Y58XBb7gvAnq1cuR/XX2UE739WE0jDGkib30Gi+3T7b8a2+BnepJ7ZOcIc1Io57KqQrg8BSX7ifZbplAIln/AQRXydRpC46U748Z3H6+msshmKpO6oTj2+vBqtq/7e/CEP4KNJ05bwhEyCwBZCMf7q2VtmrQ2lS6YXJA2q1cQzwKaGNaz04MFn1UjvjnEjmnvSJbe21X29Q4qN1lN6f+HAKQgIQkGbQhiKEvy9c6UzLUuJ8l8c58nC8lS8Sv/2VLSBeFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TeESoJB+r+SIwpshRKsxhkXVtUKSxkyLATsiV/y/xmY=;
 b=qgx8czUOE/2OJ1S4URxiZXWn5dfJ3H6fdq8wSeZOUh6bA1V9Ly+/biGxn8Eg0QdZGbHoW8ffOojWeOSCaycjWUrqRcuqv9TlVX3j1RcT1L4TzF4koaYvBCOlnTRdjK64RLSBGvoP2m9YW+dHqy87iZGKtK/iH+YZX11gyR5rt2r/TvJQMCdPuw9jC+vgqwrQXJ0NWF8g38aN4nwHm0Mz4n12BBv03mTQNIR2mN18oFOiOd0Osz750WnrpysPNOm5eRmAsnh8gv14A9rdQ6RB9dvkQl1HpUxfMsy9G28ysWUuCJiDDCCeNEi5AhExxZpX7E4hUrWu1/mQYswMN1fPUw==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SA3PR12MB598757.namprd12.prod.outlook.com
 (2603:10b6:806:52d::14) by SA1PR12MB7442.namprd12.prod.outlook.com
 (2603:10b6:806:2b5::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Mon, 26 Oct
 2026 05:37:51 +0000
Received: from SA3PR12MB598757.namprd12.prod.outlook.com
 ([fe80::e206:100:5946:a777]) by SA3PR12MB598757.namprd12.prod.outlook.com
 ([fe80::e206:100:5946:a777%5]) with mapi id 15.21.0546.021; Mon, 26 Oct 2026
 05:37:51 +0000
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
Subject: [PATCH 15/26] vfio/pci: Change the DMA-buf exporter to use mapping_type
Date: Mon, 26 Oct 2026 16:36:06 +1100
Message-ID: <20261026053623.202642-16-apopple@nvidia.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261026053623.202642-1-apopple@nvidia.com>
References: <20261026053623.202642-1-apopple@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SY5P300CA0068.AUSP300.PROD.OUTLOOK.COM
 (2603:10c6:10:247::10) To SA3PR12MB598757.namprd12.prod.outlook.com
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
X-MS-Office365-Filtering-Correlation-Id: 88c55b40-4563-4e2b-c162-08df332346df
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|7416014|1800799024|366016|18002099003|22082099003|56012099006|11063799006|261022075727099003|261021123027099003|10067099003|261009223027099003|261021121427099003|261022105027099003;
X-Microsoft-Antispam-Message-Info:
	rwmhFQdDo+zEDQnX3AhS2qohNwoJYuDCEtE0GUbkwO0pzF3nTlHGz5+dlxVdzqwqWVNQ/IXWLNc8LlZjMZkjK9s05fHL2YCnfvKFTlYZqo/k5WSC5A3P+Fnmxy+OBKWAPBEbUXtHFcOZW47OiG+BrtGjA2ngJBa1gNrLEjN0vMjzbv3hrVY8mzjSLJKy8rs0csZi+xclkuBMxAAJTg9eZcmYi+5Y24Qsn+Y0NxeC6OMLzZ3WFyDG1J0n6QmOkHgJDYBoUl6khZWYFzpsceAXinlOx6aRRYC4tnCAyqiIa8uogdhG0A945IddIO4CJNEfCJpa2Zm0AB94ZCrVnGkmXJpN43L+csNskf3CKoio8ax7vQyvbnY4SfRjkWAyjJdCKs+9Ry+7ETA8wgl/WphUn737PFdXYX9gW/IckXASHQHtFBHuSTtm7lrfhqh+Wc/fLTAuR3QiQBS9VQsVmuWvw/GwJOVj9pckiZU+1vUDyhkWpyFu7ADC2+EjU5/l6KCxYzXoyihDDzXwfTmihCrsjkI/+/oDGEJYNGnyM4e5iE4bb1IezevkSsXoVjdEjuLez3zsyuccJZuvKgp8SIKiJKsSczgkC5b4rbUTqTwIzadyl69Bs3SmR6c8Pv2Mb9I7vfg7WEy//Y8Gwya0txXfrn2REZ45ygmwMOAWX1EnvsQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA3PR12MB598757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(7416014)(1800799024)(366016)(18002099003)(22082099003)(56012099006)(11063799006)(261022075727099003)(261021123027099003)(10067099003)(261009223027099003)(261021121427099003)(261022105027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?gB4o4Y3oz6WhXjD9NMHYuUUrAes0MGonaIAX8q0kYq0rmbJ7P41x5EUvCguz?=
 =?us-ascii?Q?9zHqusIjcKI0VXSf7bJkdqjM6+VMnjVE3RiLcIka3Lz3LURrF0lH0yUfvhmX?=
 =?us-ascii?Q?urn8e8XDt+prSdRJI6XRafVt7T8HGlcgfeKC0si+xJCBWMUVRFSr9xwIMhML?=
 =?us-ascii?Q?H4MzqpSU+e7iOSOFrEnGNI6tkkPhdOKtLQVFGUU1pecpqV3PrjCagzzREwOV?=
 =?us-ascii?Q?OiSgYsUeH/TPpWrED8jy6tc9hccdbWH/LhRukc8zrtylamXxLsWqasbKcbV1?=
 =?us-ascii?Q?AO2YVwLD3yEghQ9kb/7jdAnNhrW/5XuSS/qHczDIiaIrTbYhAKjgwq9Xmd7c?=
 =?us-ascii?Q?6WWEaUYieN/lPJNXVKFccWg0IWdMWpInP9ofVHciLk3JqMR+GmbV2i+MhSDg?=
 =?us-ascii?Q?Qtw2P9ZJ6ZeNntREmyvVQ0Iq3O4Z+b/cgT8yJzSY7qomLqdwfoYmq/jPpPsr?=
 =?us-ascii?Q?g+xql/0JFlWX/jMVr5SbThjbdQ9I3/OYoP8wL04U2Lbs6/rWDmaCbvtN1avi?=
 =?us-ascii?Q?iPDH2yEE6ki7lKjy4fRGjdInGxXb00iHcf29psHIaAayzUeRAUBHljv43uS1?=
 =?us-ascii?Q?IwOH0UrdBMoBIvhnnzyHkSL5eOrkE4qHrTGMTtqVrdAkUTBd/KXXSdBOmWW8?=
 =?us-ascii?Q?BuAovR2ZPHDWK7cm0G6qy96gZz4AZquH8VW3IDtlbZ6C2qSrsnCsMhObdrap?=
 =?us-ascii?Q?9RLMAqQLRTDbLNXPKl9T5xpQsuCu172lTo1la5ETK6rc6aZCVwWHYgBDhrmq?=
 =?us-ascii?Q?qNK1b5IJRgxQX9VFlD2Ya0bq0CTp5VL4pMBuVXvigJdGzH/0FsW0Y6XWJsUx?=
 =?us-ascii?Q?BXV1zPJSINRgs9NzWNZKC7AtgFWgDX4gZEYJvZkh0ROXX8fodS0IUwvUOL6z?=
 =?us-ascii?Q?aZGwsZ7lC2TZJ00QGb8KKNHu7GdXNbKFOhpBrI7qx/2IA/w1MPI19SbBGscY?=
 =?us-ascii?Q?pBs9rMP9gOYlKuyT0u6qGewtn2E5AkBPDcB6BwPjSVi6A5VUiklme6VEMkqv?=
 =?us-ascii?Q?MTlRnqlAp6AC8JD7krVMOnMJ0yCUgv66uvhQzbsMzcEqR3mfrrebWdc96oOB?=
 =?us-ascii?Q?gmEEU8PhDxyMlu5TatqwH6zoRKOgrLprqHcIbE3RgKEB3xGwCtnvIPBnCN6K?=
 =?us-ascii?Q?kmIWgOlKmmPzIqN67Sueez21h4H+IM7O2XNkHjEIb8uQj42lAnDpyGSFPRWY?=
 =?us-ascii?Q?GrDhH3/XX3meTbFRReY1kaxvd1smtQDUvIO+l3Z66ezhnUQ5VgPXVtcpJZ/6?=
 =?us-ascii?Q?19gjEno9rBbSrSLu8feXQw0odIk05i8kYS2PGk16Z+pNiPfgFv06FLVtLM6E?=
 =?us-ascii?Q?nv+rQ1WlihxYlMLqfKU6ZeWHXmDE0FvUGykyY9ZrC+onaLD7RjGW7HRLJ62I?=
 =?us-ascii?Q?RSRNbHfCVUqWP4cQWWm3DLDycgywI8PUwsKcExTqCpeGf0cWzH3pSKjqSDZz?=
 =?us-ascii?Q?12d2XzQ19GeZRk8B1BQoSdRNsdc1rW0RnWn5fXK+C6upgYK4Y+78avLfr2WW?=
 =?us-ascii?Q?xogc9mtWwILEeVAsqaSmZujlfqMgq3VzUbyoxNdtXLuPwnDtiNo9HMG1+SMG?=
 =?us-ascii?Q?0ISh2xql0iZx8xJmDNSlUGtPUetRh9r2IMP7msorrmsZ+INYMRgGe2m2Q7Cu?=
 =?us-ascii?Q?KC3+Xi3BzNCqrP4EVae4As7gBYJwTwQQ6v8aB/LzsCsMfVYQh5UMpWzm2Kgn?=
 =?us-ascii?Q?8YaSnpKFWSNNyDZ6qxwpClUjMIzr1QoTTaf2Z6YgEdj205xpW7tH1ixIYWPw?=
 =?us-ascii?Q?Uc1XvAMfKQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 88c55b40-4563-4e2b-c162-08df332346df
X-MS-Exchange-CrossTenant-AuthSource: SA3PR12MB598757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2026 05:37:51.7967
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VqlVr1GPwXcTXNh615eL5LVQr+qPkMBq6v5JZvxXtr4xR35BUaF1fwBHh8e4DN6qgsfKEMRCMP9RPfX71bhyJg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7442

From: Jason Gunthorpe <jgg@nvidia.com>

Simple conversion to add a match_mapping() callback that offers an
exporter SGT mapping type. Later patches will add a physical address
exporter so go straight to adding the match_mapping() function.

The check for attachment->peer2peer is replaced with setting
exporter_requires_p2p=true. VFIO always uses MMIO memory.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
[ dma_buf_mapping_attach() calls ->match_mapping() without
  holding the dma_resv lock, so the dma_resv_assert_held() in
  vfio_pci_dma_buf_match_mapping() fires under lockdep and the priv->vdev
  read it guarded was not serialised against vfio_pci_dma_buf_cleanup()
  either. Fixed as Jason proposed in
  https://lore.kernel.org/all/20260413130147.GG2588311@nvidia.com/: hold a
  pci_dev reference for the lifetime of the dmabuf and use it for the P2P
  match instead of dereferencing priv->vdev. - apopple ]
Reported-by: Baolu Lu <baolu.lu@linux.intel.com>
Closes: https://lore.kernel.org/all/f4e2171a-da58-488f-be02-26a39b5afbe3@linux.intel.com/
Signed-off-by: Alistair Popple <apopple@nvidia.com>
---
 drivers/vfio/pci/vfio_pci_dmabuf.c | 25 ++++++++++++++++++++-----
 1 file changed, 20 insertions(+), 5 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_dmabuf.c b/drivers/vfio/pci/vfio_pci_dmabuf.c
index c16f460c01d6..58e771309c5f 100644
--- a/drivers/vfio/pci/vfio_pci_dmabuf.c
+++ b/drivers/vfio/pci/vfio_pci_dmabuf.c
@@ -12,6 +12,7 @@ MODULE_IMPORT_NS("DMA_BUF");
 struct vfio_pci_dma_buf {
 	struct dma_buf *dmabuf;
 	struct vfio_pci_core_device *vdev;
+	struct pci_dev *pdev;
 	struct list_head dmabufs_elm;
 	size_t size;
 	struct phys_vec *phys_vec;
@@ -27,9 +28,6 @@ static int vfio_pci_dma_buf_attach(struct dma_buf *dmabuf,
 {
 	struct vfio_pci_dma_buf *priv = dmabuf->priv;
 
-	if (!attachment->peer2peer)
-		return -EOPNOTSUPP;
-
 	if (priv->revoked)
 		return -ENODEV;
 
@@ -95,15 +93,31 @@ static void vfio_pci_dma_buf_release(struct dma_buf *dmabuf)
 		up_write(&priv->vdev->memory_lock);
 		vfio_device_put_registration(&priv->vdev->vdev);
 	}
+	pci_dev_put(priv->pdev);
 	kfree(priv->phys_vec);
 	kfree(priv);
 }
 
-static const struct dma_buf_ops vfio_pci_dmabuf_ops = {
-	.attach = vfio_pci_dma_buf_attach,
+static const struct dma_buf_mapping_sgt_exp_ops vfio_pci_dma_buf_sgt_ops = {
 	.map_dma_buf = vfio_pci_dma_buf_map,
 	.unmap_dma_buf = vfio_pci_dma_buf_unmap,
+};
+
+static int vfio_pci_dma_buf_match_mapping(struct dma_buf_match_args *args)
+{
+	struct vfio_pci_dma_buf *priv = args->dmabuf->priv;
+	struct dma_buf_mapping_match sgt_match[1];
+
+	sgt_match[0] = DMA_BUF_EMAPPING_SGT_P2P(&vfio_pci_dma_buf_sgt_ops,
+						priv->pdev);
+
+	return dma_buf_match_mapping(args, sgt_match, ARRAY_SIZE(sgt_match));
+}
+
+static const struct dma_buf_ops vfio_pci_dmabuf_ops = {
+	.attach = vfio_pci_dma_buf_attach,
 	.release = vfio_pci_dma_buf_release,
+	.match_mapping = vfio_pci_dma_buf_match_mapping,
 };
 
 /*
@@ -300,6 +314,7 @@ int vfio_pci_core_feature_dma_buf(struct vfio_pci_core_device *vdev, u32 flags,
 		goto err_dev_put;
 	}
 
+	priv->pdev = pci_dev_get(vdev->pdev);
 	kref_init(&priv->kref);
 	init_completion(&priv->comp);
 
-- 
2.54.0

