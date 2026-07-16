Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013037.outbound.protection.outlook.com [40.93.201.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C355B43634C;
	Thu, 16 Jul 2026 17:03:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.201.37
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784221418; cv=fail; b=qgJf03RK2Xn9Au5wQPSa/zaEqOY3cbnCwu1YfVtEcDNFnvlET74ugApQ6KmOYv0J3gpMW562sB/DVjXIr/8iUCpsXfkq62jtBGP27pMmXmr0vHDsUqXFWm95oipepID2KCL+6Ayaxbp4ZvDgNUb59Pv7SGGSeyWI5GQdPQcN8lo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784221418; c=relaxed/simple;
	bh=RNxftcYAWrzxIPfWdt0hRQcyqXniFFAC9b+HROvlWlU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=hj1G3KoKfFeKQCNRyG4fkDKkjr+AOW6QBIASLAk3e442gH0zrfzz6lss3arrqH8v65rc2iD+XNuKQGQ8zHC6YSE0QAm5mNI/lSHVXR1q/saSlMuFExIuMEHNjv0urAhxMfILsT4oidLXeYqxxyvqqYBRKeexWcZ4qgyfjVDAajw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=EKLPFww+; arc=fail smtp.client-ip=40.93.201.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="EKLPFww+"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Lu8oQjOR+Rs5B3NyemSSxJkJ26eUmw7NhcfEWzt0fngaYDB3iHe/IL3MOjZKMypNcIhlOY3m0KlRSHIaHZjEzZcLa5LIB+PTJEq1H+Lydw5NXQJRIjLv/kjZHqJHn6UFBH0xrcrH7fTywQfd1BwSTVlU3JNP0FeLdfOWHAwqdRsN3rBWFDwsrm6YZv0azXdRWC8ceUhs7oFmBExebkkBz3DT6knxNTKZSKgLNm+mjHOKCitJYDHSJPiZbmRMsaFrne/TC1pnXF+rG0usjt5l9uEjS4FKkB0ldEZV8vcy0Im/up0gv0POXXphcfFSkkGDB5GjpJ4qg7kvvK6+HPUJdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TUN/a6w8yIfp6SLHmD687iLllmRcYxz7sJAAt6wpeDg=;
 b=U8yBoBt1zy15oDRDQRK2/MUGnyMZG+oYtvxTPOmD9OPE52C82ntyx3XakxPglzhyLxjl+E/7tqMNr15xXiqL9SpT+7MJ87dDnhsqXfEc+YsHK1AEld2fNtPOwHR+0SopGd3aEn1MNhRKyzRdArDvUVBXHhXGH+TSMXO9/kxflg65Qso08RN1lHNWRLfGgUSFWyrDziTfhdRhM8tOmPqtosFU7bHJ7kmxEQ7caZhAF0F/2jgOQo1tYGG2oghKvXkSK1HaW8GkY/yZSlGkZNgS+1gZ0oC/JPphtVsIVupK02wSfNr8dpdhBb11yQ0zsxL0Fn22JyvI/4Z2mHbOk6v1iw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TUN/a6w8yIfp6SLHmD687iLllmRcYxz7sJAAt6wpeDg=;
 b=EKLPFww+k1hYXpelwZiaocxJ9ZjzkUwhEP/LC6Xsa2RjiFDQJSyWiNL/EKtAXaOGFxpB1LAZqLCsaplUTAFWR5wnkqi1rcSiaNrVCbuzfOoBqSJqE0SmKlCQGFxG8jmXdqHMk5KIqc/16pi/Jnwuq8n9VFNPdvw2XlAraxQRB9ZGs7VZOcCtaIsgPZ81YPWjoTTzccYXX7L5TEhryNOlxQkwNrjcMf9tTqWbSkVKqoYGdOK8t4bTZCUESD6uqfa1NhNCfFhA9ZNTZTfQpGNkxJ1PsUacRxhD6C5ms0C4SGeAoBaMhhCX5NJiNi/LeMV+Aq3Ldd4pO61sqEsVbSzknw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by CH3PR12MB9731.namprd12.prod.outlook.com (2603:10b6:610:253::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.202.18; Thu, 16 Jul
 2026 17:03:28 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%4]) with mapi id 15.21.0202.014; Thu, 16 Jul 2026
 17:03:28 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: Alex Williamson <alex@shazbot.org>,
	David Matlack <dmatlack@google.com>,
	Justin Stitt <justinstitt@google.com>,
	kvm@vger.kernel.org,
	Leon Romanovsky <leon@kernel.org>,
	linux-kselftest@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	llvm@lists.linux.dev,
	Mark Bloch <mbloch@nvidia.com>,
	Bill Wendling <morbo@google.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	netdev@vger.kernel.org,
	Saeed Mahameed <saeedm@nvidia.com>,
	Shuah Khan <shuah@kernel.org>,
	Tariq Toukan <tariqt@nvidia.com>
Cc: patches@lists.linux.dev
Subject: [PATCH v3 01/11] net/mlx5: Add IFC structures for CQE and WQE
Date: Thu, 16 Jul 2026 14:03:17 -0300
Message-ID: <1-v3-76f117ad04f1+28a90-mlx5st_jgg@nvidia.com>
In-Reply-To: <0-v3-76f117ad04f1+28a90-mlx5st_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT3PR01CA0108.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:85::25) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|CH3PR12MB9731:EE_
X-MS-Office365-Filtering-Correlation-Id: 53c17132-d676-4438-5bdc-08dee35c2852
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|7416014|366016|23010399003|921020|22082099003|18002099003|10067099003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
	2+dvNkawpC1In216huTQFtNviVBJ2cYpRCwphQXepHbh1HKJJAtHqZOZA7+2mgQuCuI140ajaMFl1rBJeQrDBoA0boNyKMLMxgt3U358/SCvZLJD3XkDk3FP3L/AByx8pLxIgovyGLbBnfs4cJRaeYEUJNV2Fcyzi0GItSkBW1g8X4fj7+gEnkmwPwfnCYopGaHxer2IeFR+tJ71xQwL+R93CeiYTekfckmCw2kl/QARA7YNokOvmJlPnc3ITZWbzWiIKUNfY115CSu3utEPaJvzx3AyHdLx1NdpEeh+bfkT+Wp7goDfbM3Qqjtrs8vTf2q+h4H520DNeRE15B8IZJPsi0uaK2aw6AKWkQrPXV09jh7949vOOJYrVqMiK6kVTzZzrHNHLDqnsrwDMirV+LCHe9CVeEp5URHwThI6HwlKSnPBdyrPpRF2n6u7+AuL6ykgmfKd8tM30iq9bAlStyGyOeNvvFmTOO0hemMKZa43o7w0fzAfCC3EZWjcMhn/jvGLapIkPb5FbxQVPKGTXGO/QjY6PXlkH/x+r4m+CTNLwbpm6CZK/J3XwKmVhpPQZ2bqftdBYFsp9Crtr9NJKAZmAcBC8G9dcHc6EICBytphN10w9nSNmAO30q6KYw3/eGqCuMIIUpq2RcXrLsSLVpvCk+0fl9RiE3Czd4yTrcKo8GrlI1dn81WEWv/sPM6qzmpSO56jKSe5Jkq0Oop3CQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(366016)(23010399003)(921020)(22082099003)(18002099003)(10067099003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?K33BfoEqmktm4bL6FfpfPvxozURw6JqJiaxBMllroexPUcZ0K6u3fQ+IPpA0?=
 =?us-ascii?Q?lTGL0+0KZRkGzJmeC3liUkvK3MowkEPQ5Bbq2BK0DHVy60fDz4YyXlb96C6K?=
 =?us-ascii?Q?Bh3Em6jcZFSV5wKCEMIB76phqcgG2eVMUCFQ/q01HtdbBBDSf0uFSwXo+UEI?=
 =?us-ascii?Q?65MOvm8QWInKq678p346yC8k2rIOXyvy59uDg2FXnD4RXR0qnip4yPVjnf7x?=
 =?us-ascii?Q?i5ZVaCPtLtrrf+8WVWvOZrsfZXytBfS5I/w5YTxlvmsJF4ouu0hxL0jzxDLB?=
 =?us-ascii?Q?lHe1E3z8nfuqUE7TO2JcVSPLaFOyc3mpzw/0ds4OAF+/lVP9T2d6e+4SX8Qb?=
 =?us-ascii?Q?5/fvrLs8s4LImIlCZIAZ2E/vdn8cX91SbV8VX+MGTvDQis4jzxW5HlyuXL9z?=
 =?us-ascii?Q?yTKMXCeN3D0UBpKJqF6Bqa3VYldeH9Jf5q50HIeFJklGv+syaMt3IG/fPRMt?=
 =?us-ascii?Q?+6lygL1ML7uA9hh36y3HCdQuR5iUlaT68NcdXS/3uUqgoaJ0elUwpDwaS0Ma?=
 =?us-ascii?Q?BU0qnFP95CD0QY285cpohdjfe1qj0nZQjKmVfXex+uqWIb9g3okgiNgTf8j8?=
 =?us-ascii?Q?BnlOwutPdZL5CKMg8I3fWbWXgyu5iTKP0wrINwwfVMztTLeCnYgSWmnBuXP0?=
 =?us-ascii?Q?QyF+jMQRus6G4XiBONtrIKkH+P9EuC0mnSYi/Mdjuu+GflQQcyUW8lcpd8/3?=
 =?us-ascii?Q?0RLuKWOGc7gAKxqqwdNoif/VlGJPn/15umxyuKIn+Eul/cWvR78belDvQ+Mj?=
 =?us-ascii?Q?J2wYiFl2JvvROrnAEoOYP8cs01GViVX4THfqwbns/dalfRgAabYdWjamPDbA?=
 =?us-ascii?Q?7/qHcI+tzVfjP3/PQfKidaPiNSJj/4xIGAUQnr2koRuP0DzGZ3Xmtlh0SC6g?=
 =?us-ascii?Q?IZaqfRRXQFBrhnfzs9ujXQEYwnRKjMDvyc4mv0yYTbodvesrE8c+4UqxgTyE?=
 =?us-ascii?Q?gHX9Q1QJhKKJNvemkSnIP0edRv9OmY66gRH/vzLRQGIGY6HkNYrOu0wDjSvm?=
 =?us-ascii?Q?fKKN92YWod+c1QHjcby+GGRD6rDdEsECfuu2HJEiRhfbm7u9V2rzUo7brO20?=
 =?us-ascii?Q?Es0XaXq2SGjSmLKGFum9gRmRin2jAK5oIPWu3/5paiLlKWinIwgMZpzhJDYM?=
 =?us-ascii?Q?/aVhCfSdpgZJKE0T/V3T9GQmmrAUO7e2JrmOpC5prUqUbhFJkP8gDc474uxX?=
 =?us-ascii?Q?umxoUeBiOlc1rok7pa1wdrg+4+YPx2qHhois0+JYelVWZKmSS8Xfa78D576D?=
 =?us-ascii?Q?p9VssoxWEevlYd77ZaR7J1nr/+GlRbnnPMp6NedPNHMDFhw4AV4jmf1QyKYR?=
 =?us-ascii?Q?TEbhOfZkMEGSetW/BNNhUPxj4m49ANDlpEuUiDj5EiOrApFIdO9tHb7CRxR9?=
 =?us-ascii?Q?3ORbLtKRRw9iDDlCjly1LKy9PsyEmT/qFrilnHzb+tvaXnO8nDB+0f1sONmf?=
 =?us-ascii?Q?JJcOyBmY+uLljgHqVFoyDtmY4kZvhzzn4I1HXmI6+VyuLDiGy/dkc22/vhfA?=
 =?us-ascii?Q?jctXy3lWZkSRnb/bCFRUVqIOweSGheIJrnR3dDt+iF/rRBKx722GMfEjaoq9?=
 =?us-ascii?Q?q7KtDkuBfv25txkiH7kRi5hWXN2wni6Fv1+vEGFUloK7HXy0hfkk4axNbeV/?=
 =?us-ascii?Q?Aq9gasNyS7dskq1zXtenBkwjABEK0lynx80diZ1Nm/OAF+J6EAfTssFpeQX5?=
 =?us-ascii?Q?7rtAL8sEyBwG3EvhANC1p2ehmBDyULhh9Zjg7HHCEBoF1kWl?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 53c17132-d676-4438-5bdc-08dee35c2852
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2026 17:03:28.7705
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OryPv0QLFTtY/TwVmrBitvPEdes9WUSG+mlgn5a9HI3REPMSLEQSpRj39IsOF+yO
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9731

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
index 695c86ee6d7a3f..a83eb731764a0f 100644
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

