Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012069.outbound.protection.outlook.com [52.101.53.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C132F524B1D;
	Mon, 21 Sep 2026 22:36:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.53.69
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790030176; cv=fail; b=n7HNX8PsKn6ifNxi7Fa5tsue08YBs2XPRXOLPC6yYqpzm1wG8qzOZXRXENTzexvj5kRGYz0dow7E/p8wuWhqB4CPkBXriDczPzDqIjpUYlp6NvbtLL+ZrLkLuqu1tgZPFuSC1rjZO9Ub4ZvH9nXV8g4/kLgCAqkSRbn4YJht+jc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790030176; c=relaxed/simple;
	bh=PEonLIrvjNR2Y0SllC8Px7tZBZE2/JHmeJAAFuVNTS0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=E/sHzgt6sS52GGvj26R5GnNJWNWWcbDN3M9e9krzsrYfCEvZRDI/kbBhn544g3KRcgarf2kVz3RhVa5KTKpAY2syft8nBXa39XprUnCVFgdmdbTKTWO3EeF7c8xmZwupNNOFG5JYunuyoAwwZW8dir0Nknlyyvs8ORU/kQ2rMBI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=hqWP6ZvC; arc=fail smtp.client-ip=52.101.53.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="hqWP6ZvC"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aeG/X8MPahcKmwNT7fu9LMmY93kbNTCDsu1O6uPjZ4wUUktaiEPDfgTd6OcwdO7yZfpGFTerbpIqgvpReazlEwYhLzYssyCL+bhjadnqp5xQ4OccwlF3qkuhyTCYP4aJDFSgcnu5t1m9zFwVWLn55lw4juAVna9V8lJ6jlrB1fsZE4Ul1Lo0ENu0sje/bT9Dyve7EQswL3SIQarAe3pqjao506E1zLOi7klDHVGTbd/gW05YA/MV4sOuOY0rxKCzWG7pl+kg7ngE2CrPyFPKy2D+XHe1NEtaX222oP83QFMLGQdX4LQ536Jdr0EXHx4cDA+XOwnQui7sWEDyQmuQEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mdakHkdVZr8toF2mDMoJuABxX75SF8IKZyPEoGjCN3w=;
 b=LT4BTSGSEekMr3NabyaMvg5TqK+gGKWnv1Sdc4VPk6vg7NvUgTKdkUI1YFRN6nFCCyqMgjJ+UoNkoUh6olucG3I2vulu9Fx0Y0eZtVHAWyk1gE7dpMD8+5lZAqqtktYDYVWL+MuQpcSxxT7lBY5ilBEB17MGz+HlTX+7r9r0CgD8NtooucY747s7DrjfAZotVqcuX3f/3YEeirdNwqzylE7vGOWuM2o2rU2hkqUyAVVMoyp5KRzXHmqHcM8xIvVBKk+QxzqpC6kwrlEPfIG0iuXd2/iGQlfgpOWlZV+RQ67+UfxxcYnPeJDWlZlwwFUnxSNGPMfqDOGR4TkPzdH8Ww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mdakHkdVZr8toF2mDMoJuABxX75SF8IKZyPEoGjCN3w=;
 b=hqWP6ZvCNvIsr8EDTd9rdmbzWVQou6bymFlgyuGWMQCk5w0pwLZZmMfuPVdjzvpaedP7IBmN6ZPAalJg4x9Gt7zBeYmO27IrXvdWk6jj9KUfZl+UuwObBhy6qaK85cDhbpyK55w73thDwsLIC+x1Sfqf1fEnVhQbeRdMThn61uNHr+g5nU5oVH94Bs5zuigdn0E97USRD6jPxAAEr6MJFKviX7MTKcVZka86dKuSd1FaTi1b07IYjAWVzUtbnG8MNViWCYa5hRFgpoC4RiyE7zZ6zeT0yJlXakRXL8KKFZePu8IzZlkVhkA8f0kFLFK5w8nVYPL2Az6oDBq7iMqhUg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by LV3PR12MB9144.namprd12.prod.outlook.com
 (2603:10b6:408:19d::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.16; Mon, 21 Sep
 2026 22:35:58 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0428.015; Mon, 21 Sep 2026
 22:35:58 +0000
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
Subject: [PATCH v7 07/10] vfio: selftests: Add dev_dbg
Date: Mon, 21 Sep 2026 19:35:47 -0300
Message-ID: <7-v7-c6d30e8ce1e4+3dfa6-mlx5st_jgg@nvidia.com>
In-Reply-To: <0-v7-c6d30e8ce1e4+3dfa6-mlx5st_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR08CA0044.namprd08.prod.outlook.com
 (2603:10b6:5:1e0::18) To CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|LV3PR12MB9144:EE_
X-MS-Office365-Filtering-Correlation-Id: 6aed9da4-eb47-4142-007e-08df1830b234
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|366016|1800799024|7416014|921020|56012099006|6133799003|10067099003|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	1zrtYD47qJBbnxc0ukxOkCGFZQSS4ZSPors0Vu/d4kS9QU6J/W3F6WEZCtbgNqqP1k2MsE5ki7uvjs0MlQLH0ZushSP4q8JT0qKmJqI/qMcPMFg5BnLk4sKT6i05mG+lF7TrSPfQs+UCIWCzLdFRq5Y3WHcxNBzHxATlX80egIxNfHrqZYh1ZsuV8bViexJ4Lpmu3NajeRS64bleDoADxgVtVm1sIdJEsq/Z+PYEQZApgvy7WcahRxWj6KUFXi9m29lTT3JvdTNq8NhdHs3SaQyc+S7KBki9KS1O3+iZ525tO3JubOX9aaycVZOTH4DUkJFjRqd6XYmP2JgDcUJmXKLPrhdUHpa9ra0tZ3ARkeqYUzFBwTa0r4X5ljqJv2Jdeg1nD8GnbndfEbbOrrtlW2tg7wQFGgIu4yDMUqj4fRihyr7h7YWbdoIC/10/eur9EGL6MOIGSQTXYIQ8bWusONjB7Sb6bnS4mwuz+iDteUbRc242wMMNnxTmdtsFepV3V8pwpHBPCZv+5WeMFvydssccET8Jq5Drpwz0J/8dULpMefZYA37NJiqUmfBG4EARfjKfmLAp6NpfvAtHrMZnuO/Va6T5upXDBVK+/xJhgxLjTpm+4vBEhAt7zJhsBNouFU4wOFxVlPFYCUD63tRYtCCJoY/OKaL9YgjsNHSGScQ4Yng/VhVQrEITwKhhRsY7UdqdlFlRdaGxjvogdkQAXQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(366016)(1800799024)(7416014)(921020)(56012099006)(6133799003)(10067099003)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?uHHI2GObNwwELCuL3ZPzQivLXDOLm44Cp2KBWdEtdoih8w1x34sjDt5kdZIE?=
 =?us-ascii?Q?3JiGxt+f+egdKFF/Lbth+ynKAFeG5RbdDKPo5ciC61NfcM7snoAja+W8eeyf?=
 =?us-ascii?Q?QbqMPGNpS1y6PUdy9afuaDTtLhBdmxI1Re+Sw0DPKTf1g674RlqTImY6A8zX?=
 =?us-ascii?Q?boWe2QEwJ3QmkOtjIG7qo8Wx3d08GUQ2hAK2Oq1Y6wC1Zwq/q+xq7w8xoFPV?=
 =?us-ascii?Q?NSEJgu29ncJni6w0a8w5Jrto6olarg4Gg374Ti7vzn43PcbZVdvQ/oV2giji?=
 =?us-ascii?Q?FLh3Ab5DpY+Lhz31ipC9a6byH0vJC5YNWLLFDpF2zjIs3tKMnbY9f07FY+bs?=
 =?us-ascii?Q?WZs9U6hCCgAKsQPhcWhsHdZtmzdWrjT9Ad7ub5C726dKf9nWcv5h1IFJELmz?=
 =?us-ascii?Q?C2C5242qHp2Iyxfv/hHWrb1kH7QXtb/QPXGIOVGYt/3jNsJQhMR8o8mnlHuP?=
 =?us-ascii?Q?kEsA6YUWEYvHi6o/Kd8MKwluQEMicvDWCsmsLf+kgkFXcKu7FYfLjA3Yc9mC?=
 =?us-ascii?Q?OJwO7/RU5RVrM+q1RewTg1qz3OIQ9OzqndDhaJBHp5Hj+QxHYmz80sN/5Lv2?=
 =?us-ascii?Q?JkLpIngYLT4Z0dAQko2tKaBhdl9Cj1t4H83ng/sE7HhcDl/88cBpe10H00G/?=
 =?us-ascii?Q?sx8sPw+RR6arRrgth94V7CC1TXF32MpqJBvdAmWxV40MZjhTwnGScqsbJ+MM?=
 =?us-ascii?Q?TDnAv37DqKN5qd4dD9LqyxcLzqwGI4SPWYPvu/+AyAAYV0kUg1IK5ZmgxlY3?=
 =?us-ascii?Q?Wgwn16uS5JNSNT9s9pydgDR4F5P9b02FFGoH3LA4moXlUQDoX6X/mLakBqaW?=
 =?us-ascii?Q?mGSD/tQKw5BR9kOGqFJxrPCKWkbmnfuON8Wm5wKXUspVaJrp73Uu+sqMcmiv?=
 =?us-ascii?Q?MEy7k+SSo+PYoDQlyYlpKEN5UgjDbbEGexUIX3IKZOFSm0caB7QPjDyJ8s/1?=
 =?us-ascii?Q?nDqd2+rVazVD4gYv7tTIXl1AdxTpimXUOTDa1rkSTm4R0WJMPkQgGZySqsMS?=
 =?us-ascii?Q?bypZwlmP5l/Au2bvXvi/fxI+JlSBsQAd/jRXpMDSqNytkcbfc/9tOiG6dUIr?=
 =?us-ascii?Q?zKhnp7oLg1CCZEoSNHFz6mBzFlWq5DczKRUT552FQSa+P5HiKZSwVMGbLzx0?=
 =?us-ascii?Q?IdS6ueQDSQuwRTBYrPjG/i5IM4+79lNO4Wqqug00JhNEgSafQMBchQ6nxeC4?=
 =?us-ascii?Q?IlgvnoMzVeFxnp5/qMe/X0qAJt6NC+ATUnJt671tqBhUuCLZiLVQT07Xvnts?=
 =?us-ascii?Q?kHJ+7M4xQO66OM02QSkqJQ6cp2S/4xPF70fICOpOJY2sHmwyiJhsw1vHqS5o?=
 =?us-ascii?Q?n2oBOmBqZvPwlU4YkFi2h3VaB1HP4HG1sb+YEGbUBHyfMpQtIfZZ0PfozRHF?=
 =?us-ascii?Q?UdQFrJU3Y4gH0MmoULz7t+p1SmydlEC9fe6p4S9GLpiohg6PJslWsrhLvy0G?=
 =?us-ascii?Q?6QQsGbDEjJeTEqcsnxLeJUqogH8D7PXCSdDTrHsA5Pef8emMttiUjKmkyiKP?=
 =?us-ascii?Q?fBWWewNRg+g4YU/1soXJzMKjjbXitslr0JoDSd3niGsTWKeDXfYP1HL2x3sl?=
 =?us-ascii?Q?H/vDnoMz1Q3vt0K6aG8IFLcI5G57kDCnhCh+rgDHj5inZWEvYZM27M1Is8af?=
 =?us-ascii?Q?Z353Mc2lqScjM011+qggG5qyVslk3JC53IjvyAEjpt+jTXWKY6pO7Fx2eGX0?=
 =?us-ascii?Q?q+s7j7eQqFl7XhUHj99VVjkoagiIFd+eiCyctroUFDPea/bw?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6aed9da4-eb47-4142-007e-08df1830b234
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2026 22:35:53.8070
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: An1DUX92XcN9+7eeAQxYUVe/4FY7njDwRqM1GbYjDimB/njpL/K4brBfSrBa/IE5
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9144

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

