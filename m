Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011005.outbound.protection.outlook.com [52.101.62.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24B394FDE5C;
	Wed, 16 Sep 2026 23:50:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.5
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789602639; cv=fail; b=lfavzVVy9/VCi61i9SH3m2uiw/uXCMviQi4UE1ARUjI5Eewcycw0U/lC2DwaWyQukN5aTR+7Akge4yqkuxaEnFLDL1nD2yVuha+ztqw60QJF4LrstN2shWJLhfGr3faLE37MNinpDW6Er6OLBTCBVnmrwyhzz5IuzTpEAxImQsY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789602639; c=relaxed/simple;
	bh=PEonLIrvjNR2Y0SllC8Px7tZBZE2/JHmeJAAFuVNTS0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=IIEVTYd4xks5VND4k1PIdBWSrOoX4yyRatQIQeOLmxtwe+pYyrTv7KGLkjnYkUWEvD9odmGeJS3mmbpe3NlcLnEX/eGWeLTQWTRYPvHax4Xa6JL2B35bbCGJsvTmMrt7NVCqb5eof4OzL/cM4KmVMQVbKayM+EQB1VxM6CGlDuU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=dHHS978S; arc=fail smtp.client-ip=52.101.62.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="dHHS978S"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=A9pXpab9SxFQiapIN7V3nKUrXj4zQK6pV0j/hd2DrlauGkMaf7kvc/E88dbgqMVr7+X4hCUPADOc7egoO3Wr2X180P3MDZdDcJwnZOqXBB7SBWUqwz1zT8oCJFFwjpcuT6hSALi3MzF2voPE4CWczhHnRxGfOwtZx4nMaS3xemT4lLR1Lu4LF8LYXY2JZYrULtld0XU4/wcrN2MFDf7uTzapm39Jv3iR4A1ZnVklt/nahKB/Pp3Kv+cPUpE+uPNVnoxVmr05iBde8GY/TrYwCr85Ekpj3/ViimgrLO2nsnRUp1mkGdcSETGxehfzkCH37IHVEerTSgOau5lT3boGBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mdakHkdVZr8toF2mDMoJuABxX75SF8IKZyPEoGjCN3w=;
 b=vMUmEZ32bkfpiQy1xxeHMkKd5MP0P/zK0GvPSriFfkHyzuehvLtW98znj2p/tQ1/AX4ljeTvv1XtoU5bOhx2yTm+OWImKYZKdbx8dyZS1fGvhULOMK/qDKA5LIzN5m/ZxEtKG7AR25mh9T/z7p4fd0seEVOLToJOpMaOWJo+4RsfY95O0AkOMyt9Eme93TyS0QT5opQtxf5PV2bay0XA7AI5QrQS8tUyMOQSMOMGMWpOezPf37MWUv7PEI4hbMr0eQg9T8Zs9mPRxtUhbwV+lkkiRecUL0uOY+yfiUS6EtsV4sx4JivxypiAIiLC1tHG8Vm2jWcPZl/AnZ1o/N3XQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mdakHkdVZr8toF2mDMoJuABxX75SF8IKZyPEoGjCN3w=;
 b=dHHS978SeNbD+JNDCqK7srvXqQjpRnVI3IFgiMuZ6dJMmOZX66naNvziwX0HkkI+yV7kpVoElcmOCkmNRk0w+CzGUCeqC/rPmf3V5TSVvjDnbaP7XZ9s4n/09p6y8eV4XEkpInKuCQQlT5bgBObh6tT3jlkir8C60uZfNcUlk3fgP7GN/PqTdKco8GgcMx7gq7ImrpgZmnOUmgRY0fxlG4JAOwZdrJz8XkeW7t9EpQj441vfLD2Kv/+zrsL6DMQvRLf8Lmz6czlsc1saA73uRK+m3GkUoid4L/wP81ZH4Ge1DGbwbR4U15pTr9HfBww43tEqJ+sDDRKrk7hlC408VQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by IA4PR12MB9787.namprd12.prod.outlook.com
 (2603:10b6:208:54d::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.9; Wed, 16 Sep
 2026 23:50:01 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0428.011; Wed, 16 Sep 2026
 23:50:01 +0000
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
Subject: [PATCH v6 07/10] vfio: selftests: Add dev_dbg
Date: Wed, 16 Sep 2026 20:49:55 -0300
Message-ID: <7-v6-8af36cf7b73f+e2-mlx5st_jgg@nvidia.com>
In-Reply-To: <0-v6-8af36cf7b73f+e2-mlx5st_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN9P220CA0027.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:408:13e::32) To CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|IA4PR12MB9787:EE_
X-MS-Office365-Filtering-Correlation-Id: 8d7f4aaf-0f59-4af3-a9fe-08df144d3837
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|23010399003|366016|921020|6133799003|10067099003|11063799006|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	OJrUGg1OC+zb9Y4+LLVhUBJFqWqtBQOt/gCEouG8O1Ts6zPZ8ukCVPeaOu46JDTqToiZRQChUnoI/BIHWK5kxNHY6/6yxftpQyTs9iAP7JG3dSGJqlBO21WhutEhRmq0e5575/2kKgA6XAMMuiencgwm1uqCAbHJhwbR8bvPrcXseHug8NhPLfkf0OybOMl1vg+/Iw8bCdksIpb3NpgGUTgeyHgUWjaA1JATa0l4Km+TROLzHpF1SKlfBbFtsvNrFL26ferTAQZpdU+6TK0VAeeTeAiBZTG4CgkGxhPJiJvB0Mf773W+ffNl3ejW3pBFz6AF5gafHvb3vUQwDKnqpzoiNGs911bvOwS8/jqhWJKd4sOAlshY6v9fGFDRO+3NDpV0MTMYw2j4Dd+LdOTiTgZD2ww1mE9DFNlYnnEOdCzA7M1el8mJ5V8Xl9Ovk2Xs4SXZ1EZQ6X2a9QHT/ze0Df4IsyUrCn0YohwqBFPhN46yfXBYErMsFZrvLY1xmVq2j0lSX5b1XoriRLnSyFZ2ibnSGLDSOfalZ1dgptkPS0OSYz7XafR/Dx3H4wQmSdXDjWH8TRaJziYWe3xSyuHh8NeweG707ZkY6BTR+2MRrwe48yKPbLilMfg0zGbnupFQxQoLxdx7lHZAjrjTcksEKoe6SBBGF9IcPnz9MGIcqGZ/cRYKV0NIjDKaYjZN6sfK6kRtaLpUGbzFHkncXglrvw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(23010399003)(366016)(921020)(6133799003)(10067099003)(11063799006)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?5enakl6C2vKECDKuNrIQjbdkPurAhu3MJOo3/eFTUK3SPFdTryYam9GSKzCS?=
 =?us-ascii?Q?masLqqh76QqNN07xvHbQpNJkXFnp2XTI5opCp0OA2ASwRv4A8HxTyoJCnddf?=
 =?us-ascii?Q?PgCEZwNHnGZ5y9wBZ8pvEMfWCOhLwVrxnGiKw+6treF3EnG4w/0xdc253BfB?=
 =?us-ascii?Q?abx9c/XPz3h3xg3em59egx/yxjx+n54XGARWDcY+5VfwZONUK0NGfZx+075G?=
 =?us-ascii?Q?0n5RQVdSKqPFNKcngkDiX1BSUuRw9p6UISMfU2Yxrtyf2o8Vy2UdILixszHz?=
 =?us-ascii?Q?6S1oAZQnVfEIvcJHnaSc0YCpUNaoTJzXHjRYVYFkX1jc++/Xj7nCy4fiScI5?=
 =?us-ascii?Q?ty8E9Vw/M+dJaCRDC57qgMYJaaIunxHXJ5uIabaSQRKtispqI+mkb4zcgaqV?=
 =?us-ascii?Q?V8O/zLw2jL/DgEy7LajJRxg5+r0wkewg4s6umTbqxgMq9BB7QbGFirlXnM0j?=
 =?us-ascii?Q?TCCM3snQpyH8F+jyeJ36L+eMwn/x3aA2PMBB5jAuvysJAq8zB++YlykcNrHy?=
 =?us-ascii?Q?iF/9wgTutbzCTmRddfnEfbfcYR45G1kEM1Bz60tLv1TmnWjvkIPBaqyyzPXT?=
 =?us-ascii?Q?TeI8u+hJ6yggk2hjTKE/vkeQoKJrILKqzx8moOd0m/diSezBKOXGlPNAZ+Rn?=
 =?us-ascii?Q?VrrOEDu8BuGZ/adtm6/8XrYEef/WQC9lbOSmo7jc1HGS+MCzyXAoXS30NBw2?=
 =?us-ascii?Q?/dcZ0BJx5LdHlPenge7EM8sfpfPbiYWIabc5CrhzRksbmLxUjFAufrK7TWNH?=
 =?us-ascii?Q?QreS5JQiv3bq5/iR4xEvqZ3Rw3p9hZTkCVX8ZTMp70BJr1lAzvHQ7kuHPRyx?=
 =?us-ascii?Q?iKWH0StCMJjnEFXVjgCrQO0VKJjaqJU8uPe8N4JvSK3pPk+1wIQ0GJYhNZTU?=
 =?us-ascii?Q?Q73W2nXTwUma2XphfWNgS8WwiVuZ7Evyoeh6E1cl5IiHoevJXkE6Vu5dhj9p?=
 =?us-ascii?Q?XIhctVc47UgYcWM+pFpgUKfHv93nj0M8qz3I9bowh3A5Go98171OHpo3hS1/?=
 =?us-ascii?Q?zrwAq1yDv3SO6m1+rnNLGnBP/ne3NVCWa3qQWXxBdA1UPlcbx/ptbD9I+ffn?=
 =?us-ascii?Q?VQ1UgWjLmzmE4tBNuulcBdQ20wqsSEuYM7b5jGU3g8N9MPLgY1lL8DAP4Lsk?=
 =?us-ascii?Q?UUPlOK5TTHEf/Fj0o0V0XzdDlDhsHG7+5t1yQ+qW3rl/vot1VFqgX9qs3KVI?=
 =?us-ascii?Q?qiy5Kvj+nmz4V5MEu+icwlyTk5sLWbaGEoT+STd3nAtLH4N0ZSGS+FG+bGu+?=
 =?us-ascii?Q?sTMiCKW/p3aFZXw+q8LHOjOmlIMv49mU8wJY4S30Gujm5pIz4D/icml/hpfp?=
 =?us-ascii?Q?1+qbYcDvpHTaHAMMJmDspcEMo+MGQ4YINQuKYHN9uhN+ERbn4FPrQVoSrmD9?=
 =?us-ascii?Q?tnspHnznebK5SyT/936VBg5UMtLKOtVQlMP4XjG7LnzrFaPL2AZVlWhGC+4d?=
 =?us-ascii?Q?1NeWmErou+kNgFYL2aSsfSJ01yh7NGW4pengNFcIcITDrPDdaHDrIOFPpK5t?=
 =?us-ascii?Q?6q8745tJRG36l5UCeWYtjtg12bndwm1xltcx4Ocnos1eOnSi8hArdkuotkrK?=
 =?us-ascii?Q?qqtX6BsYFQKymC2KVcpjD+m0VnMnF2QI7zLFdF5r57ZUOiArTxm2C5jfE02c?=
 =?us-ascii?Q?H+auh4vqCqPcjs4cDd7Qzzf4BBoO1rL5TQTmFWybblBcu3n4X/B3KsvGL7qV?=
 =?us-ascii?Q?QrCn8SUJqhvICsUjHHDVVP7o9lXqMH3swv+qK6Mf4prIfc6J?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d7f4aaf-0f59-4af3-a9fe-08df144d3837
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2026 23:49:59.8711
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HVAcTOIrd2pUCx5hgJbzWDLM4DvyujIGJ9c6n10aeB//0baZhQiwWXnzTiHa4DMa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR12MB9787

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

