Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.62.62
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792993048;
	b=ZOAP740Ge0UFLv8PkCoN69RJGZpMRqoXMu9EKMbg9SLWVS5bKqc502R2RvfPZciPDNnA
	 3ssyHhcWHUgO9Fz0VZZGcRfdx1NqglVWdMgMkepxCIxIznRh4lBXDhjVtVNqFoyq6uZsJ
	 zHah6GJ38ELInIsLWUB3KV96H8WZ/brI35glHnSRJem+m6aKtvSnV3s4Cgt6RPQXXXJyS
	 nmonR/qkFqtKcE0KADcqALSgOkOa3O+m2qJr7YshdeyKIJGlpeuIyFgfhaOwCzHBmNxKJ
	 hheF8R/UtZfyWztbIa8Ie4mMD7NrWahMa1EC0zD4hqxYjX1XOswJ2ss3NUL0fk5IYFQ==
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
	bh=oPPITXFIZaRmVG9kQ3w8kqEdlgiHeFDCv4AzjpuZVcg=;
	b=xz3r9sR76RQaC2SUhWytRI7OhziFdL5IIshwuR2HVpjxCf7LEqWCQVqpyGw7VBXwBHUp
	 uB4amd3VM/KmVBy0tBolpHlufalXen38sJMGaGuKHZOVYX3ASDQOD0I//OfpID1GHygOz
	 mtkmr5K1mPQa5wcE/dnYajVnCHv0UK6cvm7PdnnA537EEYiJShWwYsuAjBY4BvCRiU3b5
	 DIIshJMPRjCkzVJaOkzssavokp8wIHIltqrxe1PSFQWI3a6NaVcTpgdZUnMh253Bl/Mc3
	 LT1GdCyjNCs10E3jXfwSHkGHHXjtNtJ6MUEx4vTINTIY7QKHet7jctmZjbQb8jyePiQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=jfeBVI9n;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.62.62
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011062.outbound.protection.outlook.com [52.101.62.62])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54FB160A2623;
	Mon, 26 Oct 2026 05:37:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 54FB160A2623
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=jfeBVI9n
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=U2ir8XDIF0pscpCPjvcQPKaHDhbGZFjFns+36R23BwUb/kHLypgJQBriyUYvmZbFMa942CI+VZy4vYVgBPnzDRVv0D4Zhs7H+AQ3hwT2lOE3c22LZqnSp08jwQDbiiLaj9aUJ7pcgYaqbVgyKGADCngdxdQUFARYqmvBenukrDw0/8jKy46v7pSiKVPDg/sZoMyk5CLNhEnaBNuPMLlvuFokit8AHSW/RzSrAxgfcXUGkvIEkfQ/i9yut8WCuFDef917XL21DFW6TPOFfDSf47qZ+bBP6jq/z9lieEl77txJdiZvQg9hhua9KptjBw9xdFuK9TszYaExE8qtC3Ujtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oPPITXFIZaRmVG9kQ3w8kqEdlgiHeFDCv4AzjpuZVcg=;
 b=o5i4ZTAaV7o5W+iYjq72qk6QnDyFmXLK75i2WyZ20dP7TERcHh8+56GoU2/ocmVJw8tjiQUfw3vWbrLzGk2/b5SbasDO32gxXC/jtpydg4Helet42NT0eSwSLHbRPxv7wWFQpCscZDRzFEr0FgbGBJgXcgLd9Ro87uEKR/0nUZ2dA9i0/q/PPPmsJAzPp8mQpDUblzkAhM6jBL2HY5oE9qoRCaDGng+L+zo2MsPno5xeWPXZaw9i0MqzlQG5z00QfpNeXbbWzH13/yhxe0x00RsTepb5UO8Uvu4W8vNN7xl4LrCdmMEf6QLz1RMY4Ab8GY6BwijIIa89vx8Rj0ElUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oPPITXFIZaRmVG9kQ3w8kqEdlgiHeFDCv4AzjpuZVcg=;
 b=jfeBVI9nKZx7pBFJSIxycQ+yEIV5dBXN0BCbjtVuutDlmJf64JwNgGM/pRkC+Um5g+mGuXeq+N6vpMMvznZp+S/RLlsqqtm6mi0oZCqeLgbUFT/KjojblE4Crc+YsuoV9i3LVXLDWxn6vLRQknuaVuUPua0ABvyDrww3bEYWi1BIUqRpjDq2Jy7v9b020t2K0YRTCLARY4F87/Xkb+PpW5k9IZteBwdw3i8WKQZgAgDvv9l6gxiiAbMqfBOcv4e9wYpJp4tf83SBjxT/XXHUQxFW5FPU3HU5WsDjT/1Iw6+XzMz2tLICzvYjJxQ4C4N3vnNMomfLaYLvsT1xJoSudw==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SA3PR12MB598757.namprd12.prod.outlook.com
 (2603:10b6:806:52d::14) by SA1PR12MB7442.namprd12.prod.outlook.com
 (2603:10b6:806:2b5::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Mon, 26 Oct
 2026 05:36:55 +0000
Received: from SA3PR12MB598757.namprd12.prod.outlook.com
 ([fe80::e206:100:5946:a777]) by SA3PR12MB598757.namprd12.prod.outlook.com
 ([fe80::e206:100:5946:a777%5]) with mapi id 15.21.0546.021; Mon, 26 Oct 2026
 05:36:55 +0000
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
Subject: [PATCH 04/26] dma-buf: Route SGT related actions through attach->map_type
Date: Mon, 26 Oct 2026 16:35:55 +1100
Message-ID: <20261026053623.202642-5-apopple@nvidia.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261026053623.202642-1-apopple@nvidia.com>
References: <20261026053623.202642-1-apopple@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SY5P282CA0088.AUSP282.PROD.OUTLOOK.COM
 (2603:10c6:10:201::14) To SA3PR12MB598757.namprd12.prod.outlook.com
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
X-MS-Office365-Filtering-Correlation-Id: b2a7747b-235d-4993-2e05-08df33232504
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|7416014|1800799024|366016|18002099003|6133799003|22082099003|56012099006|11063799006|261022075727099003|261021123027099003|10067099003|261009223027099003|261021121427099003|261022105027099003;
X-Microsoft-Antispam-Message-Info:
	/lxLIFfMULIVi4gMQOnJ6AgAqjUmaa2o0HRyAOfAJXDKo+n5pqNI1jLBmuT6rJYFYXNCGIfADJ6pkk4SHANMFgiW6UOY0Bmfh/9njW5Ivw521X4tQs28QtgIOv8NobvBeyy7t7VrP6OlBRl7DzEKMqcyU3NZ2TAawUOIde6AOB+14tHH49rMUZ3Py7sJSP6bd954gzOLYdnDH5o55TU6ZOuR25pUKg2jbnUioEOiuEOOAj91tRypIY9uHt5VPqqFab8yqBU/heBsQsyNQXIz/jOVFlnYWWWRQgNvUQnqFLEDb07acb/Vf5yhKk2zo6SiErS72lxBM6YFQL+Rvdwdq271tY51BaDgL1dVtnl6KBHH8115ALfCbelg97UZWkIVwz6aKi4cHIDEXTJECGz9Iv811sKcjGmCk0OAXO8hhFeBVVIyVv0CwOcCzIu9tZLEfqeNgWsnhnCg4FrdoauwkndbbGMJv+co/2c0gwnMVbq1I9emlr6Nlz/0MHgIE7YpWqeXCrESlbhoS3o7pApITTYGuJFx4fMAznDgbxCL9VtDqegtO1LRObk1zAvLx4UrVkk/FPZupNe9ao38R9766MLvt30gP+XVmItxb2NirhgHEK4a4A4jSPQOb+Dl2JO2dgORLyllEsT4ejAsxw9/qZJ5lntVxXgyGLHdAEwpKi8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA3PR12MB598757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(7416014)(1800799024)(366016)(18002099003)(6133799003)(22082099003)(56012099006)(11063799006)(261022075727099003)(261021123027099003)(10067099003)(261009223027099003)(261021121427099003)(261022105027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?fG8WGZ1k2yCq5MSSiWLKgG4mDoMQiptfOQiw4hwv7ApBpSzsTAg7I1R7h1Sy?=
 =?us-ascii?Q?oMu2Loe8TQLZOIxOH5LxDSgwZ257pgsNXUxTsrQu8FwY+3SiuGJkXleFrZxU?=
 =?us-ascii?Q?UiSJ0L7ot/mIj2gLUO3pyT5L71oz9e8WH9Qco3dZlBsR9rRVE3BcAFLDx1DZ?=
 =?us-ascii?Q?X9gqmAS/kNLlSVtYe/u3kXGlS4aUUgnit2DMY1YXlpI2iBM0WYC8hkGCGhyk?=
 =?us-ascii?Q?EqGv2G/Us8b86riMV8xNGGGfNCjStiAD1M7n1q+X2XsSJhAzEH7zki8oijg+?=
 =?us-ascii?Q?ok/JrNcVKSWI6TbqPlWNIL/nCJ4TsF6TeMblwoOA8vgTQ3eOdQQxnac3hfIg?=
 =?us-ascii?Q?KdPJd8r3lFckC2tHnD0j7latx2vVtOnuOT5FVVaEfJujjOVAb6NMfk0WjrS3?=
 =?us-ascii?Q?T0Eh+alKgeHMDntvN0j94Xi5ijeEB5va1igcDhuvL9SeU1d807BeuKQrrMPY?=
 =?us-ascii?Q?X6f/H9XrsFTqEZPfJ7hpQaNol+SDol2fIBZdv64z/d0XWWIbENmX893z/crG?=
 =?us-ascii?Q?A5Z4We5Qs9bhHH5wg6Bjwf9a3K18xo8nOLJRFxlcnXWraMmogwsAABI0KKEy?=
 =?us-ascii?Q?GYXzFYcb+ERQZMvmZX6XlQ41/K8bwEKlwFbhLMoWw6xavxD+88dvELUGVY5+?=
 =?us-ascii?Q?PIBgJTEXKME92BTJavfkcZzgd9gLvlxjs1tbMK2qhyalXMHt63HET9oEQ9Wm?=
 =?us-ascii?Q?7aefAnjLZqfWkY+uBXiy9qKOiCRFWVSCTBAkSUPWovBzEOl9DDyI+TMQiXMc?=
 =?us-ascii?Q?v8tZTgFDgkvFaKgANlBHWqOeDmUdA5VE2BN6hy1n9DaO4EnsbKf1SvEX6+tF?=
 =?us-ascii?Q?NfcgZdoXbF59SIoZQWfTw2E3HS0ru576YZr6cWBBYXiAFhxIwsXyELXAbKN6?=
 =?us-ascii?Q?Kuf9iFOMduR1qlo9y4woa8jfJdx6ASyOepEK5sjUtL5P5+tIeheRTav4GDUY?=
 =?us-ascii?Q?KeWZ6qgVaLI1g1gEpXY6XeL+E3Iw9JZaOo9AwJqQ5aFh3d7y7fjI70WEg4iw?=
 =?us-ascii?Q?7WHsc4gortIjojXtcXGOvy6NCUZRUPCittX3jn144XqBIBWVgy1C2AtRbNaa?=
 =?us-ascii?Q?sR/MhippfiNzX1nD8gRQUOeCQs5tSJnPkEWT9bEiIdb2ANzFzjs/+Mhpro+R?=
 =?us-ascii?Q?bt5g9If3lwVXuYBUxqytS4xZHZt8/G1HMhXXMqe01h3FidTOZ48sl1go6sxP?=
 =?us-ascii?Q?4xtlG/OJsz0N1MaYq5SvnNQZr4eXKzXFk1/DObYsQ5G8xPPeVcjpQ2icClyb?=
 =?us-ascii?Q?Foz4iVeg2Cea/gT4JkPy/0qJlEq8MLaN34JDZiwXBTSR9MEdCHzfH379I9/3?=
 =?us-ascii?Q?XJ3TDPVaT1KwkmLYnPcLB3nMTQ1iD1mABNPW5G6iXt0A6taZSYF4vWr7qMY6?=
 =?us-ascii?Q?c0qjIrYJ4S+pEhi2rgVWgr7nD/QRBCucgmm48vtzwvH+8WKD8BaGAjjG96oi?=
 =?us-ascii?Q?TG8cNR/LRFKcGahoh2kc+dgqc882RBlC68/M0sYG9CKl1L96YwLYJpTMjvrJ?=
 =?us-ascii?Q?zWKNYOfKO39hDKWZ1Gd7Z4FklqDZOkQQoz+uX18Qu0WB+NwHb6HIIdOZfH07?=
 =?us-ascii?Q?K2KfQzDfvIe8cYZKqJ6bUEj8TedbliEBlL6tBnQ+jnesJWIp4tKfXU5ya47V?=
 =?us-ascii?Q?wx79wj3V88dYO4V6XDFYpIXt1yR4E0XydkJpIC5tKgefBRTynTnyy1z0B6dX?=
 =?us-ascii?Q?CxnX7wzhX619enMrf6+0vPtIpuxmtbMReXSvZDeoZIlIcBzH/FJete2DT6ik?=
 =?us-ascii?Q?jdG2hi9Eog=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b2a7747b-235d-4993-2e05-08df33232504
X-MS-Exchange-CrossTenant-AuthSource: SA3PR12MB598757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2026 05:36:54.9961
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4HzE5Hs3d+dt8Zz3TA2bvErqbYEEyfZbPFwISEA7BXVn4E6x/h83KdwLdvp3YaWj3JZQEVEBBkOYHQigxMth0Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7442

From: Jason Gunthorpe <jgg@nvidia.com>

Now that dma_buf_mapping_attach() ensures a mapping_type exists, even for
exporters and importers that don't provide it, route operations through the
map_type.

For map/unmap this will go through dma_buf_sgt_compat_map_dma_buf() which
calls the same attach->dmabuf->ops->map_dma_buf().

Move the debugfs processing unique to SGT into a callback too.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
[ minor context change rebasing as dma_buf_unwrap_sg_table() replaced mangle_sg_table() in 51db5336e16d - apopple ]
Signed-off-by: Alistair Popple <apopple@nvidia.com>
---
 drivers/dma-buf/dma-buf.c | 21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
index 16a7fbb8aaab..348b47f266b4 100644
--- a/drivers/dma-buf/dma-buf.c
+++ b/drivers/dma-buf/dma-buf.c
@@ -1253,12 +1253,14 @@ EXPORT_SYMBOL_NS_GPL(dma_buf_unpin, "DMA_BUF");
 struct sg_table *dma_buf_map_attachment(struct dma_buf_attachment *attach,
 					enum dma_data_direction direction)
 {
+	const struct dma_buf_mapping_sgt_exp_ops *sgt_exp_ops =
+		dma_buf_get_sgt_ops(attach);
 	struct sg_table *sg_table;
 	signed long ret;
 
 	might_sleep();
 
-	if (WARN_ON(!attach || !attach->dmabuf))
+	if (WARN_ON(!attach || !attach->dmabuf || !sgt_exp_ops))
 		return ERR_PTR(-EINVAL);
 
 	dma_resv_assert_held(attach->dmabuf->resv);
@@ -1274,7 +1276,7 @@ struct sg_table *dma_buf_map_attachment(struct dma_buf_attachment *attach,
 			return ERR_PTR(ret);
 	}
 
-	sg_table = attach->dmabuf->ops->map_dma_buf(attach, direction);
+	sg_table = sgt_exp_ops->map_dma_buf(attach, direction);
 	if (!sg_table)
 		sg_table = ERR_PTR(-ENOMEM);
 	if (IS_ERR(sg_table))
@@ -1313,7 +1315,7 @@ struct sg_table *dma_buf_map_attachment(struct dma_buf_attachment *attach,
 	return sg_table;
 
 error_unmap:
-	attach->dmabuf->ops->unmap_dma_buf(attach, sg_table, direction);
+	sgt_exp_ops->unmap_dma_buf(attach, sg_table, direction);
 	sg_table = ERR_PTR(ret);
 
 error_unpin:
@@ -1366,15 +1368,18 @@ void dma_buf_unmap_attachment(struct dma_buf_attachment *attach,
 				struct sg_table *sg_table,
 				enum dma_data_direction direction)
 {
+	const struct dma_buf_mapping_sgt_exp_ops *sgt_exp_ops =
+		dma_buf_get_sgt_ops(attach);
+
 	might_sleep();
 
-	if (WARN_ON(!attach || !attach->dmabuf || !sg_table))
+	if (WARN_ON(!attach || !attach->dmabuf || !sg_table || !sgt_exp_ops))
 		return;
 
 	dma_resv_assert_held(attach->dmabuf->resv);
 
 	dma_buf_unwrap_sg_table(&sg_table);
-	attach->dmabuf->ops->unmap_dma_buf(attach, sg_table, direction);
+	sgt_exp_ops->unmap_dma_buf(attach, sg_table, direction);
 
 	if (dma_buf_pin_on_map(attach))
 		attach->dmabuf->ops->unpin(attach);
@@ -1855,7 +1860,11 @@ static int dma_buf_debug_show(struct seq_file *s, void *unused)
 		attach_count = 0;
 
 		list_for_each_entry(attach_obj, &buf_obj->attachments, node) {
-			seq_printf(s, "\t%s\n", dev_name(attach_obj->dev));
+			seq_printf(s, "\t%s:", attach_obj->map_type.type->name);
+			if (attach_obj->map_type.type->debugfs_dump)
+				attach_obj->map_type.type->debugfs_dump(
+					s, attach_obj);
+			seq_putc(s, '\n');
 			attach_count++;
 		}
 		dma_resv_unlock(buf_obj->resv);
-- 
2.54.0

