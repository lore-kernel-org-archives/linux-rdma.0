Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011005.outbound.protection.outlook.com [52.101.62.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D087521206;
	Wed, 16 Sep 2026 23:50:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.5
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789602652; cv=fail; b=YDroQKoSNgTTFMOueSLw9Jyb7vRvxh8UcucNYIMzrF+nJDUuG2eyrOCoFZdYuQAFLumnVF5MDS91OSd3LKCPj+8adHTkaAzpAGCD1y57WxBtiDbfr9NcMi+6y+07aqX76sTIoZjWeUnnLe6sRJqfeh2D9p2IQQgHyqcJWGGSYj8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789602652; c=relaxed/simple;
	bh=/w+ngRnd1kH+SxFgZw2c2bZ/bFKePf8Urop53h8Au7s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=s3UY6U3/ZyeKaKYfT9yMdF3pNkOMV3Lof5AQ+vQWbbYfLu3ImupV/pA4ClZUcMqjODyRRLfB71d3F4fYsY6FqxbVEt/EyLn4x2on/T6jLUfmObCDv+65Fd4fQkSuQ1XNZuUJG3rOu08xM6gKp5fHiSp7SSipB6klwV7Jrg/JLl4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=WVA1KXhF; arc=fail smtp.client-ip=52.101.62.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="WVA1KXhF"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cbLMe4IH1RpqdnoYCMicy0CFQijYTH63GYBK9C78OAqiQu6+35geEa1c0Kz8UnZaoPSCmOahXLpuhuuTTzAj/HyT1zj9d7P0uZZlhid+Q2jJMx8SEnKwlLgT8mHUs/J8zOA9Fj5gG+4gfcixmZZgRoWwQYbDiQwknqBxw0/T6Z87VWVsimpNuoKWz4Ev+Xw2wk+jPRAIqiDZqouXEYLdIST4W/7YEouXx6o2evQdwFgij/DwWpjZpb6qx5SnxLbOd7QVvxXZPpTi2jd3B34jtypbFxIY0cHYqxN6nN1NjnlQle/VpHbWqEWDw21qzvyngswBRehTnUGr8p7K5KSaVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Jfe01UndmrkEcZk8OgwaUlUkfvz8EN6XhxiCIShyxKs=;
 b=laYpEyPMCvM8R+2nhCkLIpTOo1V9QXjc2oCMQij0m1M7P4eTI/fDPf5ine4p5eaLqlfgLpOTB2mAXPlqIPmEiKgnPKdgtlsdJtyPsr4Afc2GGyJSo6naWVPKobFJiFz0sCCde2poOUt0/Ml9nO0sCs+Q8kWgAvjXqdHZWvKvPqVUFVlUUiOBXlL7fszI4vj/tWWkNb9Nk9vESp0bVGOzSVG8bwMaJdNz8l1ugRBAm31zUOtbiLlwpr9jw46d7yOHtml+pCJg3mUL/4Fb3wI9tQHe37aGCa3EC8ADNmM9Xz+rMZdZ+vJnzecVqlReH3c31xb4xg8ETwqKYpxSbEq/4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Jfe01UndmrkEcZk8OgwaUlUkfvz8EN6XhxiCIShyxKs=;
 b=WVA1KXhFH2PI3byvHm3Flp1M9Sl9OgehNDGV4g34HwZNLqanwbxvyjSN2cd8b+X6wb2Ehm2QL61GMu15NMMRqVjPgPgQ8hmpXggzGJqpneVK90Cn7TNRhB0Vdg0HPSIHah2QZ5LoT0lPvKF27Mfr+Z/rkyxH7opALp2ah3jAjx95KSBsrwHZk3zY3AK7IPgDHUtXvE3npjNoKR5tzVKxHbVu9goX4XGrS63jEA6oc6ExzqXSIQldhz+XBHviByCL59fXulX6GpEixorUdsaSRh0s7MBjsPCdww2Gw0ezTiPcxlHyGVR0HNdPgLF+OEDW2N+/N/K1q/cR7XWKvxCBRw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by IA4PR12MB9787.namprd12.prod.outlook.com
 (2603:10b6:208:54d::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.9; Wed, 16 Sep
 2026 23:50:03 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0428.011; Wed, 16 Sep 2026
 23:50:03 +0000
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
Subject: [PATCH v6 01/10] net/mlx5: Add IFC structures for CQE and WQE
Date: Wed, 16 Sep 2026 20:49:49 -0300
Message-ID: <1-v6-8af36cf7b73f+e2-mlx5st_jgg@nvidia.com>
In-Reply-To: <0-v6-8af36cf7b73f+e2-mlx5st_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN0PR04CA0025.namprd04.prod.outlook.com
 (2603:10b6:208:52d::24) To CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|IA4PR12MB9787:EE_
X-MS-Office365-Filtering-Correlation-Id: adce13d1-562c-481d-2192-08df144d38c5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|23010399003|366016|921020|10067099003|11063799006|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	nkA9lPgMK6nabG7Jk+JmTVBipd0V4SXXYH6HDp0j+1mSVWceByCjvBJbXpSmt1rWshbQPCrUCLaUwd44RBJ+CW9a0n262ibOy8TC46JcdRyf/okHRxIUyubj2AHfCRGNYTW+0uhmweDdRFzJOLqbuFFZG33Km2MBivkBlwgMFHbTTxeYYdGnx9sC8qYq/W8YgfhspAR1HzV2JcGIPSHaw8T4nQ4/0C4oMokI6RVh84pJVciCpB2xXQIHcF84DyBskROwz/U8LyjzeZpnteN9XDm9a3T84D71uvn9kx6oRMpg/HPPg6F8XdiibMAvSs59yd2TyWtK8e31QZR3ZZ7cpCNu54prjmEn5ESTCBKYcyXsULGTC5ot2QpHCjgHmIZYMA77ejvjvsXNGuNdpoIpzwkpbDjDK6ffMsKyd0btih/uf87V1QALJdY/GvxAt2la4VJO3xVeZr9j21xsNeETFa3VY+PxZF2/d34QlUQZYPqYxBO2Bg+HZh8yFo4OmOftgMNAejVAsgFjRUF7oDzG2SBd7G7wYMGFvuhz/velfILjZ2yynFAIA5ICiNLGjs/qY1MRkESWAm6/tr5XPAAMEuYm0MApdfgZRqZpVaiDz+PgY4zNPWNsuuRsF5OOTFKv7//g2Q1OPxxFDQJI2qy7p7oQ9NxU+nA9Z2ny1PH5/Br1t4GKyx6+4KulPl0I4kbeojePAYO9iF2rEtp2B/81PA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(23010399003)(366016)(921020)(10067099003)(11063799006)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?QrjvgPsLIPo0ZNugrZakyi6fk6vIuUGNJ4k7xeafedllDrgkrO9/dtqduHhx?=
 =?us-ascii?Q?rUsPuPD0LsgrTchqB4km3XZBbGsQoZnnIEmTXsaLJLDRZBRXLHSH6Nfu6ctd?=
 =?us-ascii?Q?dFuYZ/i3kwW/TD6oz84qjAHDUpWqaDk9+j0oqzEgf6JKO3hLcEMecXYrCzMJ?=
 =?us-ascii?Q?DMe63MjDWZkZJ1kisrkrNzEycoSsMbA6bl3qYZIPUp7Kii0+VyRat3Va1sfb?=
 =?us-ascii?Q?iunYaqZ66hEE1IlJnBnqVPGMBtQUUBR2TMw/qGMgte7BNDd94ewEx4hjHnuw?=
 =?us-ascii?Q?NPxbPwUxHWcHGQm6Ntm2JywluZEnj9TeSw9A8Zbx87zJP9G2zfGkslOTZ/Qz?=
 =?us-ascii?Q?SK29F7wGkyixYCuHRlXAwRaGUvuiWSSPyM7Oe7Q/5bgYt+RowYDtNjcMv2z0?=
 =?us-ascii?Q?8i2O1eyfSEhJteJ7D6HdV1Jrz0gKHSeDeSkFkDDMeNBNBvM9t/YwXKZ/f+D2?=
 =?us-ascii?Q?uP7hToPw/0MKdTse5Vl4U3n5C3jluHvNphjGzmf42z/tvhBIsEWIYAAgom1V?=
 =?us-ascii?Q?k6Hjs1Y7XrALy+JqUSwQOxpGgud0rQV3tt+KS1PtTbOV2Z+yh2o0cZ/6R4cw?=
 =?us-ascii?Q?0+4iECoP585xPZx+59bSxmrsw3nAMhBneJcgTn+BBZW9ui8R9jutzCdNh3dW?=
 =?us-ascii?Q?WcmlG9RoYrifN8Hy3gBabZUGSNhUhzmHx9syKkWQjSmdIeKdH1eXgPG9RqZL?=
 =?us-ascii?Q?McZylUOYFQ/SSKp6APeeAoRiCDiWjrrk5IB6oek9Ypv5ELFL/mRyH08FBarL?=
 =?us-ascii?Q?nAxYg3miwzSN/lDsxqfmtrvwWZg0m1d/Wyr494yPUwgYLCj2h7XxVxgTCCQv?=
 =?us-ascii?Q?pSoZBq6Drz+lwzJHacQRwJs1FNMHSR4lbDOd8zv9KIKBY2sFbxOE5I9hsa4N?=
 =?us-ascii?Q?609PKBaLxjeq03TnuRq4humfJmEBvCcmuSQAXfAlD0eoZ4o7//ukrrkF8cpZ?=
 =?us-ascii?Q?CQcA4ofYlgcQpln9gXgvEBlT1EiO192ryHUZcoz8jLGNkBe7OA5ak/dFraZG?=
 =?us-ascii?Q?KQihV8QSvpHbQgA+hl+W+smzfRv/vI9MfSjDx3VE7tKBUQdAs50p8fDgWFvT?=
 =?us-ascii?Q?1+NFMdIPMm9iHy7fDU7eK1frBz43H9CLieJZoh2SSv7AwBig1pzK5q77ogFm?=
 =?us-ascii?Q?JEydivL2OBqNLo59W5RyQfBCi6r7wT6WQW3MWWIyxWG5z1MZinRdWWLAQ+1v?=
 =?us-ascii?Q?ki4mIx3K8RdBVIjd9MgGNnHQy/HAucxUU/RD7j+aDYa5LeIWq+wmMqgpPl0x?=
 =?us-ascii?Q?8MUcTE9fwxCtux/Ki6Yffk2KOL7UfZpuhkxV3dxwI5rtThtTRhV24yWvbA59?=
 =?us-ascii?Q?N7V0fMjRvLTSj5wVtK6TDMur0JsasIIjBrpcnPaVYqLablfA57b/6n+jmqd0?=
 =?us-ascii?Q?faYc3ki142gS9FO4Z2Q+yHkwqkGY2Lc7HtCVqSaeXwkx/mJKMRha6hcJ6F61?=
 =?us-ascii?Q?ABTaJTo4KnDRtaAf0h6u9ITgDTw7XdNV5suw8MZin8cfo+h2wS/fq19+/jTD?=
 =?us-ascii?Q?yf4glSb0Bc15DHo915Tkris2EYRUJSVKYgNqRxwvf1o9pwPoM4uVV6cm6I7b?=
 =?us-ascii?Q?JlOCZdnhjvu4hZDx/czw4hmCPpcxXTLj7riZGeP0SaLTKaO7Qy6gtt8OMWpv?=
 =?us-ascii?Q?0et32PRoTmwrhA9NZV2Qpd/O4MQ/p9zDTl+MgJFtE8u7HOrFQmrVG+YwmYlh?=
 =?us-ascii?Q?uKzIwvrsV+lewAj3AgrZxwSb+O4dUXVPpmi/0n3lMg/L2U7I?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: adce13d1-562c-481d-2192-08df144d38c5
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2026 23:50:00.8077
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Pa/U4qAQSRf/VQWqoWG2/0J4H4jP174Mh1JdEWLaZitAn7NDtfkqHQakywLPi5vz
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR12MB9787

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

