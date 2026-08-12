Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012045.outbound.protection.outlook.com [52.101.48.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72296470E85;
	Wed, 12 Aug 2026 14:59:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786546784; cv=fail; b=WO9OTj3av9/3Py4j3P1Pale9AuRtfRBc0c160PF9nltNLoiHkWDWNNzLmceQ/Qia1hboRzyhmHftwZieYcr8xXee8SozEcYh7TdL9tnjsvnAzrm4g984IOvEtMXFq2df4wjamtu+uRweS2Fe7hnx7Bw1iCzWUgyt75utKy+uwho=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786546784; c=relaxed/simple;
	bh=PEonLIrvjNR2Y0SllC8Px7tZBZE2/JHmeJAAFuVNTS0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=EsfolWJWILuIou7DH3hZEiyCOsgaxP80yZeSTngVC08sFxUEGHxft//NUYdTKABlUu2x5IGUYiMpISIjqyxaA6wVRYEjyptbAilLlP3bDIu+oTqh+zgDFarVykgyi+pAvp4okoNEEfwPmgvn3hwcd1Bng02lmIZWWxg/0NxZrRI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=XoJEdn2E; arc=fail smtp.client-ip=52.101.48.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="XoJEdn2E"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=u5ps1KI5tQ20dXLWxvO0HCbMYZw6v5Wd7ns9F7F2o3p1rGMm61GwrVmAkgGDkcF4gLfwhj6vhr6Kb0igFfexodUxh7NOf4A48s6+Wks4J50qXxF94IAlh1u9YIWF37JQ57nLFP2Hn9mWMqMWfh5T4sdXam8jVLZKlxKrfO42ETqgrvdHJiuUpODW5itYT/aCtDjKKQfE1+vJER6Wv6MgF9QhzCKACor3z70cgMQMLKA33RzhU+u2KkvcNPIwmctChaYQ5eZB74fPm5OUEkhC1HoTe9tPANbnwgcv9ssAdVHf6uc/Riza1xhI5P4pEixdWvB9Ea6erUxyoAc+7Qpvfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mdakHkdVZr8toF2mDMoJuABxX75SF8IKZyPEoGjCN3w=;
 b=D3Q7cxbAcNO7PfovDcUw4rrVKWF9+lNVXkn4NI5TVDlNDlyUAQfx73xRQu3rGgCEGjUBgUG1AtJVYFAUGVgoUfUdojWQ9fO/PNg8s85/NyYQTVlbp7XFWg95S7/ycukEynEWtRUm8YSM+4Wn0tnG1Xo58BI0gBZU6m5KBPKuUX3HCjU3YKKL+8/a058bRqJV5OMhpB2mHBOtIKKF9J4nO+Mh+gvCvnIAI8pWElSgUj4qfqJH9TRfmQ4pEpFyGXvCKYsz2ziMlQp7EbkQcYP80Js89wTkCVmo26n50/alF0R/eFWmPcJVUWDBJ+xqfz4l6XbOLQket7WMvMagGQEbnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mdakHkdVZr8toF2mDMoJuABxX75SF8IKZyPEoGjCN3w=;
 b=XoJEdn2EaZFPHtgzyNZAlpAXuoOEkpRHv5PXXtqBTeP0GIXIWSWwI+65kdmZUyyl+qwZG7INQQE/g59f/Y7Omp4V41MdLaDrlcPSGTfmLBqmXFxTb+K5JaFQjZL4AB7Xd+7Hmxr89yt0A/GGKXgjV2lsrGtrZldNb3K1x2kyYr6XB7QoU6bGC8lgHpF5Tqiobc5W4g1UzgY7z5VVn+k9NR9v4JbHJI/W+NNce2z+cDciV4QgOkbg/JsXWtvUO4efPrgYDPufi19EIsMKVwcHvGhvEC1CmjW5zk2krOELT6wE7B7I1bkycDMy3DLo74/7lcf6CxWVNa1Mb+scVkyNNw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by CY3PR12MB9654.namprd12.prod.outlook.com (2603:10b6:930:ff::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.11; Wed, 12 Aug
 2026 14:59:18 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%4]) with mapi id 15.21.0315.011; Wed, 12 Aug 2026
 14:59:18 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: Alex Williamson <alex@shazbot.org>,
	David Matlack <dmatlack@google.com>,
	kvm@vger.kernel.org,
	Leon Romanovsky <leon@kernel.org>,
	linux-kselftest@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	Mark Bloch <mbloch@nvidia.com>,
	netdev@vger.kernel.org,
	Saeed Mahameed <saeedm@nvidia.com>,
	Shuah Khan <shuah@kernel.org>,
	Tariq Toukan <tariqt@nvidia.com>
Cc: patches@lists.linux.dev
Subject: [PATCH v4 07/10] vfio: selftests: Add dev_dbg
Date: Wed, 12 Aug 2026 11:59:05 -0300
Message-ID: <7-v4-021df3fb5a3f+98e-mlx5st_jgg@nvidia.com>
In-Reply-To: <0-v4-021df3fb5a3f+98e-mlx5st_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0909.namprd03.prod.outlook.com
 (2603:10b6:408:107::14) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|CY3PR12MB9654:EE_
X-MS-Office365-Filtering-Correlation-Id: ae12ccf5-472a-4caf-db00-08def882451b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|376014|1800799024|56012099006|11063799006|10067099003|6133799003|18002099003|22082099003|921020;
X-Microsoft-Antispam-Message-Info:
	6MZ1qdtkwNvMseF4PeqH+YLQKgcEYV5bazDkUiUib1AkNCC8SjTJYdJqBTDQ+rbJsb+0jwlsmSk9lOI3dtq+58ZEbWSRkKslFWnwfn7ifjcI8CEfCpbhu5AfGIXT7lffOdj//J3jMgUHePWwF8k4MaSweZWVmbuBkX/PraRdVU3eQua9OXwWM1MNetllMvhxiDTVRiCqhoYfMlZpfX9NvAV34XNMyLwqZLsF/2nluq2E5jSYiu3y6i8eIJnj81wC0jrdDkHKGF3/CbpkTsS80t0ZveZQ+sV3xkzgReymRbIOZUXMM2wHgUWHXrkB7a6SH/bQxRCXTSF7PoAXUKDX7a731dQyEiu3u8wyaF9IMRrbKVy5hSLdcC7GKCAY1JJdEMhFp8+kXVOD8/e6vt/kTr0JlH7UkSm0taWa/iEzzmE0iVSncXUav9NzDK8WEpjvaTcVkTVCh0utx+wS38+L4QdUp9N59lXzqwdOVtFjEnakn+cHt5fligKo9EV0KC4ptUJBDzkxWl195ol+RwDtuAnqjIiMfAWIVVTUjdCMrdpEupAzmp75KbaZ9rC5y5R5WFvr0SSgHFSObPSM2fQff5At6CA/0hOBGV8KApbmvF3QDAaDcgGr892JSvzGghNaRbBOo5IoSNr3T4NSZTiqjdUDXAy/biy4xeBC/f2MOAw7ozVcHA1zxmkZaLpqcGQ6Yrz0yP9ZVEeWiqoTAJ2MBg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(376014)(1800799024)(56012099006)(11063799006)(10067099003)(6133799003)(18002099003)(22082099003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?JNmbU3+g58QMvPqLtA9xsL+KdKlfT91nKcbb6/R4XUjWpo8lIvywo8D8WPna?=
 =?us-ascii?Q?LeEFbCm0gxJ6YR27SofQ8lAF+FtRTQTWL8xp9VbSn1vr2BySSD39FY0hwrzJ?=
 =?us-ascii?Q?ZihwQW0QndFyB+EiavoHQ4pGBuMs2C0qnwy54OKTkpdF7paL6tzJiWzBicnl?=
 =?us-ascii?Q?L2c9jRvvnVuglreRvclhmvwpXPyw8ApTyEgampmADp4mmQda+bqT6ciWU/kH?=
 =?us-ascii?Q?JYMOKryCGxa4X46GfvXu7+upGTM5EPsRJLoGINTRVAjW1Tvqynhrcn/mZou1?=
 =?us-ascii?Q?3rVJV/sdFbWBtLAz6p1CbTfgMMz4P/T68KCYvZqgBICkHjDUylNLQTybPkCS?=
 =?us-ascii?Q?RdDsicWWAtb0bBMhIrNicD36+whbPDi/aF0TM3ixx23GqRv2sW1//KZ4NEJt?=
 =?us-ascii?Q?V7uNlLEADx0KNrk9Q90zX8q0/mcQJxxRAPs58po7EG1gxXGKt/jO9WIw1neY?=
 =?us-ascii?Q?iPMNUYQ/FvxgPbDm9e5dbe1kUjGlldSzCe6smhh0QFf/lndNzu3R5gbxqKE1?=
 =?us-ascii?Q?V43sDcHhQOTPj+e9DoBIIRkDQ2M9/xs1ZnS2tJ0Qn+t9LmqnAFYE99xuiiJ7?=
 =?us-ascii?Q?yFA3pgA+PYZtDwfT7E/mpKMxtIZHwxVV8AlICBToARx9tRxvMXSfTjVFXYBJ?=
 =?us-ascii?Q?kwQ9t/33qKhGC27RXVS7bTdmqfc+OgnSDcm0XyOctvpJ52GTOGP6kKSLWCtL?=
 =?us-ascii?Q?x4CvNJDWaAtnJXVQkmPDIm6M8alOX3+mCH1ENxwVAxt9jVCuo8DROExW5+OW?=
 =?us-ascii?Q?9nczZlNNmGNLTkktYaaU8ZAu9ZvL0XDmhvXZP7vT59JUs8CRapeWCSBuePCF?=
 =?us-ascii?Q?fLUIYEVu3hGCb/tWdTy+HxOHtCHaY2rxF80rcgY54kgrxC6g6d97D4Pqt6/T?=
 =?us-ascii?Q?UdOU4Nec7rKAHyFtiJwDYj20yduweQ2IBGf4sNflpc0IExKZ+3JM7rFeSNRs?=
 =?us-ascii?Q?9QMdzCnlw2Fj+VmQlCegOG2IGAPzFMIIL36R0t2fzwV/naS1JiMSOsmHn4jR?=
 =?us-ascii?Q?Cbc9UdbDFAZ6RU8h6639fDmIY8SNyP2AcikjtnskGQGq3NemjBbGITaxEGNT?=
 =?us-ascii?Q?ZhjpnVdKt6MbETAFIcUCcOov8GEOGadrSXCV76BTXm2PF5Zk6gTuxiTg7CiA?=
 =?us-ascii?Q?1e5N6OggzBKkEzsQyvNvyUd2UtIRnM/IpVOp38/2P/YbGSbkpucPZVJkcZce?=
 =?us-ascii?Q?Amdx8bnbR3+UVjo61zylcvadDRrHMAbQYIX4dwIHUfLlj1UWLkvliq2Vl1Vl?=
 =?us-ascii?Q?kOJlskA3Me5M0kPuSoqo9ktP/jifh7rDRpcjtSKwo4zim8bMT7S4YBhr24+i?=
 =?us-ascii?Q?Vy9FHK1RBj9MI/lzARwZK633Ru3gaxZOvv/I9DMp4Cf8SlYkDRPdcsvrIdAA?=
 =?us-ascii?Q?OerdtqEtHTANmJVzdPj+e0t3WNltJNV2MKlRsT4IxaYf4imZ9gFw3hbAZuL/?=
 =?us-ascii?Q?wKp7Wq8II6PybWCDVUEEM0HiehtnP9SenxCXMi/RHzqUDbrI6tn4/AuttvR6?=
 =?us-ascii?Q?FRoeolhFZh3Svjy/eILwpyBQpc6rO27K3S9G+wFnRVqLFW4AziV7lpE0tBgj?=
 =?us-ascii?Q?AkjTKoEAxLZ9V91zcrnWFDEC081OQQ1pBcTL2lXWYBEKAoM/7xEs8zCZLaos?=
 =?us-ascii?Q?e8Vd9cygsPMVON9KgLVD0hOHBk9jW6axH/02KPYkmdfCTIV1U/hpMQ1wn+Zr?=
 =?us-ascii?Q?71AY4tGgpUPySfyrJ43x8s95zSWzDGr1tjpBi5Ex4jyWJzY4cG+CgGZoNC5S?=
 =?us-ascii?Q?s/VGrddQdQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ae12ccf5-472a-4caf-db00-08def882451b
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2026 14:59:12.3591
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: i+0HGbRGkEajhBoNy34RynaWMqvEWf6xyxJBnztCS58TWRuSLUNJ4DIi/+ig83j2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY3PR12MB9654

Enable it with a #define DEBUG at the top of the file. Allows leaving
behind debugging prints that are useful in case future changes are
required.

Assisted-by: Claude:claude-opus-4.6
Reviewed-by: David Matlack <dmatlack@google.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 .../vfio/lib/include/libvfio/vfio_pci_device.h        | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/tools/testing/selftests/vfio/lib/include/libvfio/vfio_pci_device.h b/tools/testing/selftests/vfio/lib/include/libvfio/vfio_pci_device.h
index e19bd94b8dd2ac..007adc322c1ea4 100644
--- a/tools/testing/selftests/vfio/lib/include/libvfio/vfio_pci_device.h
+++ b/tools/testing/selftests/vfio/lib/include/libvfio/vfio_pci_device.h
@@ -40,6 +40,17 @@ struct vfio_pci_device {
 
 struct vfio_pci_device *vfio_pci_device_alloc(const char *bdf, struct iommu *iommu);
 void vfio_pci_device_free(struct vfio_pci_device *device);
+
+#ifdef DEBUG
+#define dev_dbg dev_info
+#else
+#define dev_dbg(_dev, _fmt, ...)                             \
+	do {                                                 \
+		if (0)                                       \
+			dev_info(_dev, _fmt, ##__VA_ARGS__); \
+	} while (0)
+#endif
+
 struct vfio_pci_device *vfio_pci_device_init(const char *bdf, struct iommu *iommu);
 void vfio_pci_device_cleanup(struct vfio_pci_device *device);
 
-- 
2.43.0

