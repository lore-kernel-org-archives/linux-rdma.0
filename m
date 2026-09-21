Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012033.outbound.protection.outlook.com [40.107.209.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DF7D51A135;
	Mon, 21 Sep 2026 22:36:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.209.33
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790030162; cv=fail; b=OyhsHmKH9fqs6UKWaM6w78F2onMO2AcY3FatS8yzeMjzT3QrZiNMIqQUsVzN0RpiN7Q644lj63CciC8gOgS8pf1lTtbVCnszbEUeRn/gBJSZT/LOxtTXCvQMrHGIBJ7sLCIFpn8h7vtG9h2SFZdmPZ6tp817b5SxhppsGNyqGDE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790030162; c=relaxed/simple;
	bh=/w+ngRnd1kH+SxFgZw2c2bZ/bFKePf8Urop53h8Au7s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=bta9sXhLHoN9TnutnhfCMJYQ7psz6pLdP4V0odVmzu+gkGMiERmJNic2ox0uue+ZKSCC4hKrJiwJaQw2Vf/3j6dj/IQ2OpLyi2l2+36rNv+HNeX4djC3H8LktDBc//Yp/fVVH8aPmZT4lPyqhRFlYOpV8XAeZeLHpZSCN0b/7ns=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=NkPMZ6cp; arc=fail smtp.client-ip=40.107.209.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="NkPMZ6cp"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ciVvnL+8tTElKhlx5ysbOtKYO9H5Xi+qD/ZEG8XMjPMPfabjL1pn5h56zf5Yt4vSfjmQX5Mb3vVhUsTDSeIcduZk9j88PVPN7pyO5G2MeJ6S4r5b6Xg+NuBAd3NPUbYFYfm2K9DfGo7uka3NjyFMuMi9+/HV7nSd4JRyTdudQCPqY3i6chWr6ywudOUrxUxMntlZr/mZbobUIB/O+VxWSvnA3YnEUHyMKh1hlAfsVmBvW4e+LP9sQfm0Mv5bjPkcSBRr/GeY4FIyuj9l4BcVqsDwZP6lZvq679/EoxALoVF6BNgQt7lgS1slDlNAkNmzbNP61m+NJki66nLF4/HlJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Jfe01UndmrkEcZk8OgwaUlUkfvz8EN6XhxiCIShyxKs=;
 b=MfJ1lSXkrj28B4LvnQfI+3PgNddMyzSknrRvmyErxpcdY/0rC5/U85V8sx2bUzP+9z58Ls0TAVQbNavQcqK1V0qvG+yEUA7Qvyw1Aa6AG7Ve2MyDC0stJumaCkvmAEJTlNwCxyB53yhZbWT4MhzrpaB70Ly5nHHzcClKSHoAf7Fy8Nu2rTpuRTU391LHXs4Edm3zcHJfepdN8o4upFcZMgEDWhilcY47LWpHbsZ4bENLR8gXf7G3wbsBvTWKQYuLAo4ih6vYsi5Nx4Uug7qKTxXOvQYX1UU06jTr6xkf37kfoXr+gQ0n+FKxGQFLMW/APMA6JhKreJAtKrUaVmxgmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Jfe01UndmrkEcZk8OgwaUlUkfvz8EN6XhxiCIShyxKs=;
 b=NkPMZ6cpZV4wY42BsoqSEkeXowvwqX3Laj6xOgG0+kGgJNtDB5n26wJA104r8rbNRNy/wcqsOyaDpSG+mBfXw7XBiJaehQvlbPSKcvzQ9NPxYLuenZTa7+HCZiEiBmN7AHYhgcpED2hB3hytq06W62o2KlPoy1AjQWcWJdBeh+FpFoOUgt2TwkpiLFco2AOhTnMJHCkn1cXXeStqlpLqyazSsEWuCa9o4+wO+EoRPwRWWG2qNvX7YY7kUZF3z/nQpNEPfWcM4JazH6JKBnr7FXCKxAhiwNwK+BstFljEvYvIWNKJdAcHMt57V33irv3bXj+IHiH8tYqopL/mrRWZoQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by LV3PR12MB9144.namprd12.prod.outlook.com
 (2603:10b6:408:19d::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.16; Mon, 21 Sep
 2026 22:35:52 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0428.015; Mon, 21 Sep 2026
 22:35:52 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: Alex Williamson <alex@shazbot.org>,
	David Matlack <dmatlack@google.com>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	Leon Romanovsky <leon@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	linux-kselftest@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>,
	Mark Bloch <mbloch@nvidia.com>,
	netdev@vger.kernel.org,
	Oliver Upton <oupton@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sean Christopherson <seanjc@google.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Shuah Khan <shuah@kernel.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Cc: patches@lists.linux.dev
Subject: [PATCH v7 01/10] net/mlx5: Add IFC structures for CQE and WQE
Date: Mon, 21 Sep 2026 19:35:41 -0300
Message-ID: <1-v7-c6d30e8ce1e4+3dfa6-mlx5st_jgg@nvidia.com>
In-Reply-To: <0-v7-c6d30e8ce1e4+3dfa6-mlx5st_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DSSP220CA0009.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:8:3d3::17) To CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|LV3PR12MB9144:EE_
X-MS-Office365-Filtering-Correlation-Id: 959c8d67-4769-4ade-43b1-08df1830b128
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|366016|1800799024|7416014|921020|56012099006|10067099003|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	6lPCpVEq+A+tP+g28E8hBx/4VZTk3D/nXPP9Ot3pkT1Lb7T96lxyub2opqJnTFRjro/tKDWpJaMrVBkzgRbrY+jnYtYESUXd9miKZGFepTQKK0vdKphO4Hvef0a1iCzZBwKwh2RuQ2rrZIaHUxPrv4o40iEjyHUV4T7eE+KRpuuadmqwPS+CEjkWXwlEyY+PL418kulFLOtnEYVfoUL1vpu2LGeeIOjMXy4BOa8+DqqaVjuJsGeEUav9XemROnebEeSS0C1HBaWqoqDYLyBVnm4MB4/eFXcIkLplDukzR9RBgFXP/LwpvBJrnDW0t5EaaxRQ9dxuKVADODxqY5YqFtoF/U9bSAyaS98JOtfUnNlkB6tlG1N4THytfBkIBqr1D9Whg6piRv4f1rCU3NL7j3h+Ep5u7YzgMPbjIXXk+3OweCz1lhzonN17Y8Fvu1pnAMpMtDqSxyewZW3xLSuIca0jVPK0Tx89XOipLyM+yyFS8WbHvhw/rZoFFDUUC9bNVAwX43/gQdk59WCI+1pWiTJojKZk5A3jklVpZ61qeAHho33xysOJ6xwrxWAzvryxI+1hQ9A/OcCTvYVTYqQdfA9X0OSI5z6Y7dms2ATvePt725ZJPB/l1TbnIeUdpl0Ge0ImnO8ShWQd8/OqjfhgR157tPtLz6XxSv9XipS2GfiGIeqE3MhYfOk3o9R9xc4YowkKYq06dM8kqxWfbKE/nA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(366016)(1800799024)(7416014)(921020)(56012099006)(10067099003)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?xt283Z5jAcY9t3pbl6iOgWgsexsrTIsM7p/9yebkk0VhZP66aORaN+705P0M?=
 =?us-ascii?Q?Nt1h9td7SHH0uK5nFwUTOiHMU16OrYu+7K0UcvrupAim/PWAAaf/5kxkzF+x?=
 =?us-ascii?Q?J/QWEMTo4xyu3V6vxrY0ZNteOYmoCQd9GOtC68aUoXpb9QgVAJ1JBz0t/PKJ?=
 =?us-ascii?Q?pZpworZ9CsdjjWjH3/HG5hdDMHl0vhoo7vu91t+lN20QnN2NnTpVHUu+W7D9?=
 =?us-ascii?Q?zmz5M1Bd+9CSt1ehQFlciPsBPyd5JZ13NJGCsHNEElA4leEZdrsxgEoNpilb?=
 =?us-ascii?Q?yFbTngsv09OBaBfTDLmUMrDJYOq2i87U5OFf/LZfQ5ErAN/KIMOIFvW172dl?=
 =?us-ascii?Q?pqZou66MFDrGugwe9M9sG80+XvAd8vNUnSLIADWQPni8Qeolbcm1vQ78GgZM?=
 =?us-ascii?Q?kYP+WoAaQKBUgum+rfkAwr+J30wVmZsjAfodz3UJGE81mSsZ+sWXpDUDY4Zg?=
 =?us-ascii?Q?J6sDADBveHZhP84n/DYG92PShL3rpL7wnVkeGvWUJSYzicobUwyEvz+CdkoA?=
 =?us-ascii?Q?vgb1vDJSkXEH2laFfqq5wB42jM9Oq5xlC/Mis390xEVZHRlU8GRSTXYUrtxC?=
 =?us-ascii?Q?OoPBKxBe6GKudBBf4aF0hsyd+915Or3fZ1zx7dGDsxsn7LqlKxZmp9sYB78j?=
 =?us-ascii?Q?1tfaJ0vzGr6AKJabeIZvyzFcSfRVBhhUHbctgMq+tO3nuxSdtVCXJNR6YvKF?=
 =?us-ascii?Q?HxgSOxmdldsEKJbct+Upk/UJ1cg1ZCS8aMZ/9dTNCWon8Kj4QNx67Ngjeuga?=
 =?us-ascii?Q?8bfCVQxaHRhWHRYT2FZg2QAMKadSHpQPJmYVzzl/9DW9AiwUS2eJnWTE2k+G?=
 =?us-ascii?Q?wokqn+QedP+g3PRf14BvKBzohkETUt5G2iBOD1GsUV8EjPiJuCfWFXA8jdk4?=
 =?us-ascii?Q?B74E1WZM82ogIP7WtJKN+niiwcUcvShPVMb5GlwKLolE7M3lwL2aw9vAPEVw?=
 =?us-ascii?Q?baR/qBchBOUv5Mya5tmDfOXCGbJmCpsSplJGOBIzVdqdCEcJ6hclQ04QYKss?=
 =?us-ascii?Q?GZ0oY3ERiOz6saTCHweAks7JDFHgt0vvQ+WHBFx1NYRvItNurHCoL96l9aqs?=
 =?us-ascii?Q?Oc6Li80CMENWO3MZ2EePeSZUh9iMMHeTAToraB39j0L5rIhFL6TsGPDNh2E8?=
 =?us-ascii?Q?UcHZEfoNmdfnt+qO0p+CORygVh7dd+oZzsksuYlsy0CyjXL6OG7NDMC2EpPF?=
 =?us-ascii?Q?dGfHKE257PRB9qpn4ugHJg6nuEw70csZ5EHau/SA7VOZdNudPP+7ib8jfirD?=
 =?us-ascii?Q?P4lk2YnAMhOkm7xdYa241jpM9NJmgdhjyDdEmlAzVvixEH+YMjxosXpAPtq3?=
 =?us-ascii?Q?rRU+8SDQnQuPtKiEF3EKAdbxA8FCjACHKIvx/KIPGfU7HbSf1B+pINOdaANW?=
 =?us-ascii?Q?DBxNbndNAz3Y5duSnns7FdDDWLK9NEnDKKwRLTnIYhCvBRxUhE2XMLAVmNkr?=
 =?us-ascii?Q?02n5ieh+mtkrrWYPtZnVMbfPCgus0qqoq74UrD1inEpf6CFrZcoJb538qtB1?=
 =?us-ascii?Q?q6slJrk8RZRGJIeuBDYyS3Opws40jGP/17ytm24oY5Ay0ECISGDJtS2Ri2ki?=
 =?us-ascii?Q?4OGN+tfDk93QXPlE6usTRUlN1pq7CcIo3vRsF+8TaMPWa4OdzOBgQThi7REN?=
 =?us-ascii?Q?ttqfXBuyfNHOVeEk7iZ59v6m1qi70XUL3/htDruSpOxWA1obiLYDfQX5EK9G?=
 =?us-ascii?Q?4AJZmyiHNt034KAfAayjYWb6Rpi3gm2pThR8B5bIEAJm0mfw?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 959c8d67-4769-4ade-43b1-08df1830b128
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2026 22:35:52.0834
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: O1pjLqgfxJJzC+U+hHAWK7+g58G9Xt/zu5n7guHudXbZR0T68DFBo/67htydR9Ij
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9144

Building the WQE and CQE using the IFC system is easier than with a
C layout struct. Add definitions for their layout. Structs for:

  - wqe_ctrl_seg_bits (16B): WQE control segment
  - wqe_raddr_seg_bits (16B): RDMA remote address segment
  - wqe_data_seg_bits (16B): data segment
  - cqe64_bits (64B): 64-byte CQE with error syndrome union

The VFIO mlx5 selftest will use these.

Assisted-by: Claude:claude-opus-4.6
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 include/linux/mlx5/mlx5_ifc.h | 55 +++++++++++++++++++++++++++++++++++
 1 file changed, 55 insertions(+)

diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 12b9a81e562146..a3edc5ba1cd4f1 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -5979,6 +5979,61 @@ struct mlx5_ifc_cqe_error_syndrome_bits {
 	u8         syndrome[0x8];
 };
 
+struct mlx5_ifc_wqe_ctrl_seg_bits {
+	u8         opmod[0x8];
+	u8         wqe_index[0x10];
+	u8         opcode[0x8];
+
+	u8         qp_or_sq[0x18];
+	u8         reserved_at_38[0x2];
+	u8         ds[0x6];
+
+	u8         signature[0x8];
+	u8         reserved_at_48[0x10];
+	u8         fm[0x3];
+	u8         reserved_at_5b[0x1];
+	u8         ce[0x2];
+	u8         se[0x1];
+	u8         reserved_at_5f[0x1];
+
+	u8         imm[0x20];
+};
+
+struct mlx5_ifc_wqe_raddr_seg_bits {
+	u8         raddr[0x40];
+
+	u8         rkey[0x20];
+	u8         reserved_at_60[0x20];
+};
+
+struct mlx5_ifc_wqe_data_seg_bits {
+	u8         reserved_at_0[0x1];
+	u8         byte_count[0x1f];
+
+	u8         lkey[0x20];
+
+	u8         addr[0x40];
+};
+
+struct mlx5_ifc_cqe64_bits {
+	u8         reserved_at_0[0x1a0];
+
+	union {
+		u8         reserved_at_1a0[0x20];
+		struct mlx5_ifc_cqe_error_syndrome_bits error_syndrome;
+	};
+
+	u8         send_wqe_opcode[0x8];
+	u8         qpn_or_dctn_or_flow_tag[0x18];
+
+	u8         wqe_counter[0x10];
+	u8         signature[0x8];
+	u8         opcode[0x4];
+	u8         cqe_format[0x2];
+	u8         se[0x1];
+	u8         owner[0x1];
+};
+
 struct mlx5_ifc_qp_context_extension_bits {
 	u8         reserved_at_0[0x60];
 
-- 
2.43.0

