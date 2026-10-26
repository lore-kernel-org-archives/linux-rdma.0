Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.53.41
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792993092;
	b=SkGZj59RX85T6v2HcXjkuy7WfYchCdf4Lw3KZHIEHNcIraXbGatfu9Ah9+PPQW+zCUuJ
	 ccCpc24swZFBr89dd5IrOvxyR0wbjiG7tsRqMJ+3QgM3APLZ9pVLYC6atod2RtNwHTXyD
	 /TWDfuPoC3DpwR4i+blmRT45qzSCzvNSwQww3K6Dv2WRW8Ygj+brC3SrVeHkAtmXiWRCl
	 yodDRo6/h1PL48qk6qK8Y2OVUAolA8npsNCyp6QzsrJkjwUresGDFvimQMzCEQ0LHdX7f
	 RJ929UYLGtj7HkNb4h7w9QclUeXPskDAHWF7kEO04x4/zvCPdxsRHw1EhLT9idzmsZQ==
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
	bh=KT+XJOHSlhLO2JBkkA8kqEN/FBB2VZUzkKUvgWIh1m8=;
	b=qHda1vL3eSZjslK7tSvHBo30dBVtXR0WyzP0Kz6ItYjMZbmMm/GsVtHUCGMVo/WKUKVN
	 ABzuqE+cQnPEct7kJGq9hQlJCz2FcqPhXP/xT1lNTnSTUYF2cVz45BVE0e055DmQ8+Cwf
	 z9FViLNu/zthXH8YULjT5ohmCBf/CH+Uy6//WXgva8xKlyYBfXVED5DZfwdaRlsEoY3R4
	 nNU9wUPQ3/lVb5jH2e2WxIWpqnlcDZsS9RVb3AUkr3qnZteHE3bB7eTYCTzfIAGids9pn
	 9Eaft0DlZUJiDQ9/E5YKA/QbhQCdz+BbPNVL8z2Lbsi37EEgpwDAuj+mt74uxideJVg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=Qccqbsl1;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.53.41
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012041.outbound.protection.outlook.com [52.101.53.41])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 541F4606D32C;
	Mon, 26 Oct 2026 05:38:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 541F4606D32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=Qccqbsl1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=waamBSvwWtheqn9QQrCJSyriWZNXX2dzPcRDgDzJSLrn8VMJ5k9rEC08OXNkywUs87/b5QLmGpuq8M+FeP6mpUjLQQdRXZ/0p3xOljo/aMeF5Fq0ORLvWkXucUKZ/Nemlq0DuihnonySfb+MWLQPzyGIerT60g+SVWGAiz2xPUo7zGvPtbvTVEhXtUs1GSK9akU0vgMqKZkzwfy+xIK+0wnjMAV8BLMxcr3qOqROX3RbnD254PvdF+g5Ok0qagR8egK5oB2I0mJ6GlVzfJHs8W5saaNcC1pBAI/y0ezmZTFLFQTpVbK7lh9wWrThLG1UOLDUOio6FnnEt4dYjvSzlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KT+XJOHSlhLO2JBkkA8kqEN/FBB2VZUzkKUvgWIh1m8=;
 b=XOyUUOSxHPOTfxMxW9uIoreIGG8Gw9S8tWAcJDpF131VWWKO9FusIEFPPBE2XUp8oF8YqhJq9MNzx+ZHFUptli239BoSxT90Jb7SlrzUH/MJPJRM1gqruDI2Fn9ssCL9b8PwSrTgXbBEwtggNXNjOxbzs1hFdbSiHmIFX9UO47VwRUusJAfH3V8Wg8YPNpQ+l54zFedW+v2+Qf01l4kmbVsHPbgPWpMdLMPZ1N/CTRwbSEhIbhdkBBfBKes256hMHJnKmNfAJnPg3+66EOr5CKaIYCTGaoabf7JPW2hph9Lo1jmtU+QFgEiRsoTrycHvW2HHIQPeI75wjNYCnF9wZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KT+XJOHSlhLO2JBkkA8kqEN/FBB2VZUzkKUvgWIh1m8=;
 b=Qccqbsl19dQz9oTIDX5COIvs7T2/RjFMsqoZ3YZsTel5Uz4yHd9M/k17zbmM3HstOAkuo3xDS7S8wYuGq+vOSEKfm/lMZig0I+0sEmZadqB5Js0zWlnqYYmH9B+EpXFK7mnEr0BHztF4opQhUsOrKHfqWpKFYtrtYTivkqi7EspAcOsZK7cQ1OgcvkFcm+pUazc9sszsEb3eBmCzYO7nJPPoXR1J4xJvHnIpcN2xw78xHUQQUxU+yVW6zEJ8RYhpfyFtn7CgH6HxLEgib9/MCksE8zdUcvmvqga6s0/QlC+JZZCmZQ0YsRd05jNxKZ8weQcclmB4NOmqzopm+jU+zg==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SA3PR12MB598757.namprd12.prod.outlook.com
 (2603:10b6:806:52d::14) by SA1PR12MB7442.namprd12.prod.outlook.com
 (2603:10b6:806:2b5::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Mon, 26 Oct
 2026 05:37:57 +0000
Received: from SA3PR12MB598757.namprd12.prod.outlook.com
 ([fe80::e206:100:5946:a777]) by SA3PR12MB598757.namprd12.prod.outlook.com
 ([fe80::e206:100:5946:a777%5]) with mapi id 15.21.0546.021; Mon, 26 Oct 2026
 05:37:57 +0000
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
Subject: [PATCH 16/26] RDMA/uverbs: Use the SGT_P2P mapping type
Date: Mon, 26 Oct 2026 16:36:07 +1100
Message-ID: <20261026053623.202642-17-apopple@nvidia.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261026053623.202642-1-apopple@nvidia.com>
References: <20261026053623.202642-1-apopple@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SY5P282CA0165.AUSP282.PROD.OUTLOOK.COM
 (2603:10c6:10:24a::15) To SA3PR12MB598757.namprd12.prod.outlook.com
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
X-MS-Office365-Filtering-Correlation-Id: de13d9ce-b77c-42fc-7ae1-08df332349fc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|7416014|1800799024|366016|18002099003|22082099003|56012099006|11063799006|261022075727099003|261021123027099003|10067099003|261009223027099003|261021121427099003|261022105027099003;
X-Microsoft-Antispam-Message-Info:
	B3blOrLDZcLwhikOWwFULOY98+pc7X6bKZyHFWhjrRfaJ8pSNdLDA3rr7ZDeC5xSlMuaQPGxWfJlIrdCzwZw3Q5p/Bz71I7BbzxTQZh35U1V1xHl75U4kDZVbzsNWib4XCFQmVoWecykcBdnBD/f1KtgTbBYtGfuDX10RXOoeirsqtKzPBiAbTBt2d3Qbx7ImN2uW90CeS2lQWjwhws+AWNYFf28HRFTgleHw8IJfkoTisT0oQruMUuMxvJvTitSxLW8AIsotsoe1GyHfnFFBi+TA75T16vgQ//i5ZqRCBukZ1lZf5PKuZPaqGVcHpSvCvuppQaX/i6ufZXL0UoSblVolZmHuNbHtaa2fxUXXAeZVPjFvE54bdTpf7+JBAP02EBPIk0YiPha0uuBijsQ2bn6Uwt+gpqWHRRurJFL+gNc/bgo/jkqhiV2h5MSuf+ElWEZKL+fWtXxLGe32Up3koo4QMDLQeGTIMVzcV9spu6ku3cqhVPubj5tJR3iThwpuEguDYcTPdAIk34avLRdbpz/t3S/6Ve51qcl5S8KAU3JRxDDzNH6c5TxDE5Bf3+w3fj3ECucIphozIzHIHpBltZfx+/XrsptquWDAV0l1KU2Nb9Pg8S6lfzZd1+3xrAja1Ok69TvrCr6HfgI602Tp+YmEqN/mgw+h7PHYjnhPpc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA3PR12MB598757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(7416014)(1800799024)(366016)(18002099003)(22082099003)(56012099006)(11063799006)(261022075727099003)(261021123027099003)(10067099003)(261009223027099003)(261021121427099003)(261022105027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?i2iK6wFMla0BDRV2HJmXB98b90SjuDGJPJvcQKNvtRP843WNYJO2pBDY5Pwt?=
 =?us-ascii?Q?aBqHjZFB0roS31Fk8IzqGYB9edaAsncgCFwmghtaY77H6GU3t5jeC+lbbOff?=
 =?us-ascii?Q?mebL/d1TsFdfv1WPtahyhwi4dt8hLmKMb4bS0oBDw6M76b8rZ85JIvDdAhbZ?=
 =?us-ascii?Q?fOUcsN05gN1o7fXF3gCQ7E8bwi88swv6lN2KLQzOx2kZvzaGIUZirTl0PUOA?=
 =?us-ascii?Q?irWvOJCYpqV4edxAMYEabaX8wT/hnDwzpc+t+rer72xoXC7VCFon+2OD2zG2?=
 =?us-ascii?Q?LGzG8tKjbTUvmoXz0zM9UOFYqG5HGy46EAOHtVhBMv7nObvvjjITdw5nFuSn?=
 =?us-ascii?Q?dUZk28cozYd1DQA4DkhE5WgwfGdvRlxIrotvjWW0Ba9ja0hgkWuiKTZ2dCla?=
 =?us-ascii?Q?JPK7bmOKt9quXAtcZbum9tFm8b+9Ee11cb8yCHID0Uu3gzOliLo3J8JXDBkk?=
 =?us-ascii?Q?4o+mmo4adSTlUiXUTtuoFuMucl7KQHTXe75p4EEQauS3Ydz8FREwQQnfFHbj?=
 =?us-ascii?Q?wXWmHfIUEwE+993gYGezyQIWWWOhIMQvGh6OsGwYkOz8/iBp4bt7dUtkoa5Y?=
 =?us-ascii?Q?kI2yF0EuBfmXuAW1J/iQZ9LiSZ3DSqn7yZUDyTSpv3s/PNv2i+u2DWHsVy4c?=
 =?us-ascii?Q?l0mm8chcDkYk4Z79OECGix4dv93PL9VhceoGJrvuQbaWFRt5wwSFJOkMyckb?=
 =?us-ascii?Q?1KdDtpx1s9TM8YCZiLUJ4yyAqjPeo+RztFE6XzMqY52uZI+l43iiJznNYYDB?=
 =?us-ascii?Q?EU0kMq6tBXzbUJKbOthoz/Bv9CGkOeu+jQAPvlR4jBn2w8IhP87+MJC9ubiL?=
 =?us-ascii?Q?20t3mdeJFqt9DRHXviie43RcyIezbiCpJfp405lbAz0p4BY3nPQn/vfOpoDY?=
 =?us-ascii?Q?CXLFabJ/uMn6KH/Nh60S1TTEfE436SfvUUrtNJtH5lPcqsZT37q4v832o+H3?=
 =?us-ascii?Q?ElFBpoqkthAoyyngX+xiHcGWEJppCZmNwUYfoq84+ANA98zC+NXGDqmA0d5Y?=
 =?us-ascii?Q?zYkbQVThdF/5au50TjiJ/q1kFZm7xxV3J/UMlwqwgVug+c4nGkKQRI06RwXY?=
 =?us-ascii?Q?ILu1k8ois1TIscorQhjtc/Idm/3NCEboM2OyGNU8BaFsNjuUF+Rv8Px4e8l+?=
 =?us-ascii?Q?yrcgKEth3bn0JztSGDeuFE1qeZTO2w6Gb3OJGxiQzNbVwTLRgqZCtX3PR/Qt?=
 =?us-ascii?Q?GPP7Ao2VpUzZjesX8L2wh4T2pkh8qwIzyriX1zpiSkDGuxE8PtQfGSuh4Pbk?=
 =?us-ascii?Q?Zcjy6SrncmLDXoAmVu5evEz5Qgx3IxOS9wj4IBiDHq96vkPKM6c/QQxQyYkE?=
 =?us-ascii?Q?xJ7ImMzaVF6eWb1reKzV/TQPKBexqt8fsq0kV9TnkjZAemyip3/FGepIWFOv?=
 =?us-ascii?Q?zHwaKnAwwQVuMG0za32BmR6ggChmUVQPam3m0xN1WtMOF8PiKhY8TxDdZ/JS?=
 =?us-ascii?Q?wI6jnC41zrxmn/X+ZC5gEzJLIG+13/kon7IpDmxN4XpsefPk8MoTjvLWwmuT?=
 =?us-ascii?Q?ij7HG9nXBeiuT+TQjqGuM680aNeu1c6T2IlIIOP03T2pQr/ScT1q8AcrAQM0?=
 =?us-ascii?Q?w+QZBfZzF1Ywjpbu7p0w6iP5pZUwBRYwVG05kCr6jW+R1oJ2zPGo+BnvBuxE?=
 =?us-ascii?Q?BJ9HE6bmLGI9qUfCG/Ba/MDjVt0ujjT6Jewo3+oYFiysOI/coKm4ZImETd1e?=
 =?us-ascii?Q?z+sYzdLcBigNdbXZ7Z13EiPjPXXjIDDe/+FsgkkVmW+o8lPRfJNeB2eSVsrj?=
 =?us-ascii?Q?sFOkrizXDQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: de13d9ce-b77c-42fc-7ae1-08df332349fc
X-MS-Exchange-CrossTenant-AuthSource: SA3PR12MB598757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2026 05:37:57.0163
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: No6aOKAbSYl/M9F7hXH/DdfXQ7j+TzNbNtZfW259OR+EzapMWjzok/mbeaVeI7b+zlbIFpMzbV50WifJ0gu0/g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7442

From: Jason Gunthorpe <jgg@nvidia.com>

Very similar to habana, except the rejection of unsupported
pci_p2p_dma_distance() is done inside map not attach via
dma_buf_phys_vec_to_sgt().

Convert this directly to a SGT_P2P match which will prevent matching if
dma_buf_phys_vec_to_sgt() would fail.

Remove the now empty attach function.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
[ rebase context change, upstream added MODULE_IMPORT_NS("DMA_BUF") - apopple ]
Signed-off-by: Alistair Popple <apopple@nvidia.com>
---
 .../infiniband/core/uverbs_std_types_dmabuf.c | 30 ++++++++++++-------
 1 file changed, 19 insertions(+), 11 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_std_types_dmabuf.c b/drivers/infiniband/core/uverbs_std_types_dmabuf.c
index 2411ebee69e2..3c5c3ea2cf55 100644
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
@@ -76,13 +67,30 @@ static void uverbs_dmabuf_release(struct dma_buf *dmabuf)
 	uverbs_uobject_release(&priv->uobj);
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
+	struct ib_uverbs_dmabuf_file *priv = args->dmabuf->priv;
+	struct dma_buf_mapping_match sgt_match[1];
+
+	if (WARN_ON(!dev_is_pci(priv->provider->owner)))
+		return -EINVAL;
+
+	sgt_match[0] = DMA_BUF_EMAPPING_SGT_P2P(
+		&uverbs_dma_buf_sgt_ops, to_pci_dev(priv->provider->owner));
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

