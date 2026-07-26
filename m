Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010020.outbound.protection.outlook.com [52.101.201.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3FEB3806BD;
	Sun, 26 Jul 2026 09:30:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785058249; cv=fail; b=aHCHtQa9dfvk5IerzNXmGyscQPZgS8N2zbwVZjz9PtNIudFEGmhB8EIvIBThC6KUOIciPuXshoyIo/KTHLsX9bBcyBPznxpV/yO1Uwb41CXmQi93BYvY10JKKxVuPi8h4o/S5pMPieYUqeUmOZtDj1ip+gS8n+PwRH3fgceErgM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785058249; c=relaxed/simple;
	bh=qGGsO+PpAq8CbjH4i1o73cDKAAwyqgZyrlUnKsPsWHc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=kAe5W9X3FXQqblGFbtnzbeJzdb+mbWUEOfZ0vZ8pV+o/0FSAXQORFhn4d+Y01c+Fzh2ZDpU6nVL77LFwJMvQjvGMlnOBxV4ubO+TjFypshkMn9BbG3MwfmkV1ER/m8vLHdeFuXbbYgUzqBdARvHdogAxLfqxShEYxrlah+Ed7j0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=LfguJw2j; arc=fail smtp.client-ip=52.101.201.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="LfguJw2j"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=U83mFzv8QYVDho2GQF/3x5OuQ1PxREDB6GiQFvcqhAboGqBxofIPksu02wJHrTPMa8urA4lbKsEofdUj7QPNUCrb4Z1e5yRyxEHoxGqkfqdivOr+vv1ynCIJhY9EnPL76KWf5SpHHviqeqkh0ZwVylEqtMNV+OsI+lF3kAhQOD+7+PZgm0LYuPt6CjZoQdGsRFCEH3hm9MgKggY+hcaEz9e0MrydQofxIr+vCZ9UoGxcJMIhhgr1IHU3KWTAlft/F9Pp3EAAsWDyQLtBp7hjgCG7f6lss/Z/UktneA5NMdbeNAkHsGuBuIRGyw+Pc06pg6lpR8wB5WRbABswYcPgkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bLnEMiGQ56Zfib2cCb8GDrI+qt0Hjr3ivBam/aPddSE=;
 b=WiVDuDwJuECsJ1A+bsX8gkMoNEoR6V/psY9sxP+5VPMHFHENpyI4aDDY2ApPsFoh5bBh4zo/n/R4DLxlfp9KMuJ93yqwUXVf8DUAc2+ULWZrt2URrNcXvcpoWtDhx4r0RUaCGFQrpruk52+VTM8NMielIh9b3OD5uxE2PgyEeX3Uiw73tRwP/rNos3lTr6nx8KplbHkGFTp2TK4LBwbGr/8/La4JqAls3DvfkqXf7PmgjzgiGf2sDp8nhZNAgHNGirGV+bqlafJBL3kUNhR9MmdM3e8ZxhyClIB9MT6RSRXi9qQV2b4gN1UVe6TI3APLomDMV4OGWPdXwGj7P3QeAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bLnEMiGQ56Zfib2cCb8GDrI+qt0Hjr3ivBam/aPddSE=;
 b=LfguJw2jVpBBbztysywQJnx4yGLSo29QR7BjlT1AMdrCEVOTsVvEsMa3ExVeguRGQpCVqGhpyVx0R5EC2ODoJOnUNE2/mfD471XLzEByJV4X1Ca+szfofclfJLruNa+QqiwacDJT+IPUm8wnMJpc20clZ6M5d1AFKZGAicQEe3++EOEb+aGPr6sFFKEmPtyZjALtU/XyhQ2Oki12o7pgwIEjF8g3fggv032cPbRjrCrnqBD3TNDCyhGhJ99kNvL4wUgY/Nj22XYnDj5uqY9ME6j1fx1kmKbIdg/WkXlM89dKAGmdww2h4+O0OesT+FdiTHkJbVpW1iDa72tGZLwG0Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9715.namprd12.prod.outlook.com (2603:10b6:408:2a0::7)
 by CY8PR12MB7611.namprd12.prod.outlook.com (2603:10b6:930:9b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.13; Sun, 26 Jul
 2026 09:30:44 +0000
Received: from LV8PR12MB9715.namprd12.prod.outlook.com
 ([fe80::e74f:2cf8:cf2c:142]) by LV8PR12MB9715.namprd12.prod.outlook.com
 ([fe80::e74f:2cf8:cf2c:142%6]) with mapi id 15.21.0245.012; Sun, 26 Jul 2026
 09:30:43 +0000
From: Michael Gur <michaelgur@nvidia.com>
To: jgg@ziepe.ca,
	leon@kernel.org
Cc: linux-rdma@vger.kernel.org,
	netdev@vger.kernel.org,
	Edward Srouji <edwards@nvidia.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Michael Gur <michaelgur@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH rdma-next 07/15] mlx5: Move RO setting helper to core and consolidate mlx5 consumers
Date: Sun, 26 Jul 2026 12:29:21 +0300
Message-ID: <20260726092943.2880176-8-michaelgur@nvidia.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260726092943.2880176-1-michaelgur@nvidia.com>
References: <20260726092943.2880176-1-michaelgur@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TL2P290CA0027.ISRP290.PROD.OUTLOOK.COM
 (2603:1096:950:3::11) To LV8PR12MB9715.namprd12.prod.outlook.com
 (2603:10b6:408:2a0::7)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9715:EE_|CY8PR12MB7611:EE_
X-MS-Office365-Filtering-Correlation-Id: 9f251a74-be0e-473a-1aa2-08deeaf890d9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|23010399003|366016|1800799024|10067099003|18002099003|22082099003|56012099006|5023799004|11063799006|6133799003;
X-Microsoft-Antispam-Message-Info:
	hVFxFV/pn/wgzsyFdVGPV5LXfie7iBgoGUjkH0GHkSQW8fHJh0N0zgJNYiUCPBU5Wfxo5d9imLuJKM8KPISAp+PjNzQW2KUEIyb4lNwPsZC91NEYZ2g010rIsO+MBexk4RhPZPlTbCcG/s/riobXATwWOzcmgn3Lcda6QbfhszCOs+zN9f52s0Af8OQpU/PBlpq0wyv81Roqb28tx4yuaEMrX0WnZ+5zzNtSGsGtzrIfUaM9q2mh8Ybu2+kzmjAyRgV1HJHZgSXrXVpTWFhnfhXYZrY1Su2Syurjk50pZyLHFY0bANhT016KAMJYTnkbPdxMbxvoWqR+13wbBRCv1KN+hlFEgdl+UYR6Q8lJJli4HGF61qlUiDpujVmNySskvUJGOG00SC379REGjacik1eIFHejT8y3QPzmbcrX9jKw3mF2F3+f8y13sBNUQEsoprh8xiLQmXyB3O0mCMyuSbGGW/uepe9wbLOFHsmsTnomAJvXWhDmls+C1ZSb7KUc5XMaK3ebCONPCzMgWgje3VD4T6hEP9sbepkmO4IVidQ2L+e9upXGqEicOKlyqsMy0upaiCVeizN2ibuZEK1E44vAECEiaw5NwloVz828YMxhtbbLW+zC1D0etIb9gv3VPQNxOT2cEn0MNWnJB1Jk2LDwkMrPvo9fW+jKJOlralQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9715.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(366016)(1800799024)(10067099003)(18002099003)(22082099003)(56012099006)(5023799004)(11063799006)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?MItB2WBWOIxKId22MApvR2m3bRjblTdRffwBBh76OxzKydPts7GnlMmR0NrP?=
 =?us-ascii?Q?C2zYyWLVGeHmflGlIEM13adBnphHzfBF8qFhoWZdXL+eQfMgi/SnYRQ3wGgA?=
 =?us-ascii?Q?MLsnUqZjtAM71inLNI08AQOShrSXG3oFxSL1iJ/AwXvv5B21VBUURAbaRXFK?=
 =?us-ascii?Q?ayuNPwxD0H4zmeQQKcZGYKRV7oCZAdRR3vNQDdHMY7TZ3tREDtIC1YhnMqcj?=
 =?us-ascii?Q?mba7rQ+gXnPw1yqvmW8NtttF8+2ZVQCxdTKGJ14Tvq/mFfaBxOKTxIgPyn5A?=
 =?us-ascii?Q?pk3CuLrFD04Dka+rQQSWtGyVnB4pWMteDtsP16fuygYFDUZd48MO3q697pHV?=
 =?us-ascii?Q?OtMayygx+CO4yyVNRGPqxoGofFtSqzCrZpE4xcyPfeZSrUDVwhf4b0RTJl1M?=
 =?us-ascii?Q?5pa1bki0ni1pI3PzCmEONvTq1RIRlXVVm2NQqfpdnrlBkgDo0Q2fT2ffoMEX?=
 =?us-ascii?Q?tcfg6d/RMlelXheVAxbunbV5RJGBfm2X4Xpv+H+EGVCLoZ8DdzV9P21LrZLL?=
 =?us-ascii?Q?5f86voOca2/iNQp3A2/Cs0EyFdPEj8HdvVwclx5UmDsK3bvuFJqPEkkMD9hF?=
 =?us-ascii?Q?jXEClnSPKUerfA9BDKKLXKnMel5gNJ52xLm8pnw5L9v+5JpLD05DY5UxqZo2?=
 =?us-ascii?Q?fes80DrA8OjWy1YtDKVfkoOTwNHakxPiJfuo9GstGFc3MrWVpjgKVif6IFTC?=
 =?us-ascii?Q?auy3bCe+9UFKtf3oPOWd1Qas4+Bo61biXcTCgir6Y8v64iaizPmlcOMt+H60?=
 =?us-ascii?Q?Sk/MaeGuwVMYMc+ndTWffmQZp1enrdFKVYqsA7tluyVsneq2sby4CLMjnubK?=
 =?us-ascii?Q?2p4wwL0lak3Er4oiLxEeDH+Ahu1dy76FzP/mt7cu8t9r3rLpHIq/Wl7pCVGG?=
 =?us-ascii?Q?zoKRPeTS1J/dXHS3TRBRjs4iBsg8pCMxMCUKFUtQIG/SvEEQSeTm0fhCCxwl?=
 =?us-ascii?Q?VhCn10yZV38NL4KZTgFOj1w7LxdqnT22MR3lD13y4zSyLE9tXk0vqzg3IVFF?=
 =?us-ascii?Q?atWc6E5mARWUOSGPffJwb99GUsQbjJqVfWS4xjVfYS7urqEWeiaoCKIzmp7I?=
 =?us-ascii?Q?BQk93l4mXcWV9r2xDX39KRLnGjyZtKigShaUCQOqYguRnWed1NHusQoGrWch?=
 =?us-ascii?Q?XpKCa/hn/sKzY0wnvCLyZVOFAxO2UzkBsgo5wMOnDjr4p2xPbah511WTpO9o?=
 =?us-ascii?Q?efNdYntMDXI/VR4evRvFbzMzhwdhqv8qW7k4Kh900SYDqChA+PpBRENDEElj?=
 =?us-ascii?Q?n53AoaswMWLSu3pppBvr4Ss7+5k1nc0B+N70qdNGVziivtUxZ8pEcy19VdgV?=
 =?us-ascii?Q?nHgSqdDshBeTa6p+FtyUveP+b/+uDRH2dCw5l1gUzWUosEIjx/FTKLJeV17S?=
 =?us-ascii?Q?hJ7zDuCpl6qBWxfAD7w/K9vyM9ZUMB+VxPTzGn74Katq4Oqv3qYHdoIddPun?=
 =?us-ascii?Q?rWVQitoN0BQin4PpB0cySA81ADoImksAZM4W3Ys+IEkz7sRiNUTrMLK5OI+a?=
 =?us-ascii?Q?e5aDt3FGab3ytP7pbtl2R7PdifjZOEwMpbuZQWjWhKza2YUur5XT/2hk/svV?=
 =?us-ascii?Q?ZRJEqGdw2wdY2oCdsdu1RbOehRX7AxsM8mQu6GypvHNLyovO1dkFG46i3Bnh?=
 =?us-ascii?Q?oRr+nBkWA/Ts/ewISCna6LrYgnnJkIVhXuyrf6mbRRj45yZiDhl2JKg7aK/l?=
 =?us-ascii?Q?2j4M1zIXWpw9SvXzVxiTXUbQVnUyuf9BvvioYpa+lgtlVHWqMCjVfS9Yn7eI?=
 =?us-ascii?Q?EzBuBm+doA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f251a74-be0e-473a-1aa2-08deeaf890d9
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9715.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jul 2026 09:30:43.8146
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NmcHLILW4JOFS16s6PjTKnKGOyNyeeFOC7isq5agH768Gf2lqD6v9IT5U2B/SsPfUU/LcniEmrlmTWxD4iKmng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7611

Move mlx5e_mkey_set_relaxed_ordering() from en_common.c to core/mr.c
as mlx5_core_mkey_set_relaxed_ordering() and export it. The helper
centralizes the cap gating for order_write_after_write and
pci_relaxed_ordered_read so each consumer no longer has to open-code
the same dance.

Switch the static MR creation path (set_mkc_access_pd_addr_fields)
and the UMR access-modify path (mlx5r_umr_set_access_flags) over to
the new helper. Both call it inside the IB_ACCESS_RELAXED_ORDERING
gate, preserving their existing conditional semantics: RO bits are
only written when the caller actually requested RO. The Ethernet
path already uses the helper unconditionally on every internal mkey
it creates.

Consolidating onto the helper has two benefits beyond the
deduplication itself:
  * pcie_relaxed_ordering_enabled() is now invoked only when the
    caller requests RO, avoiding pci_lock contention on every MR
    registration.
  * Reorder the inner AND so the cheap cap check short-circuits the
    slow pcie_relaxed_ordering_enabled() call on HW that lacks the
    relaxed_ordering_read_pci_enabled cap.

Reviewed-by: Yishai Hadas <yishaih@nvidia.com>
Signed-off-by: Michael Gur <michaelgur@nvidia.com>
---
 drivers/infiniband/hw/mlx5/mr.c               | 12 ++---------
 drivers/infiniband/hw/mlx5/umr.c              | 10 +++------
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |  1 -
 .../ethernet/mellanox/mlx5/core/en_common.c   | 13 +-----------
 .../net/ethernet/mellanox/mlx5/core/en_main.c |  4 ++--
 drivers/net/ethernet/mellanox/mlx5/core/mr.c  | 21 +++++++++++++++++++
 include/linux/mlx5/driver.h                   |  1 +
 7 files changed, 30 insertions(+), 32 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index 53bc844a7fc8..683099333563 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -71,16 +71,8 @@ static void set_mkc_access_pd_addr_fields(void *mkc, int acc, u64 start_addr,
 	MLX5_SET(mkc, mkc, lw, !!(acc & IB_ACCESS_LOCAL_WRITE));
 	MLX5_SET(mkc, mkc, lr, 1);
 
-	if (acc & IB_ACCESS_RELAXED_ORDERING) {
-		if (MLX5_CAP_GEN(dev->mdev, mkc_order_write_after_write_ro))
-			MLX5_SET(mkc, mkc, order_write_after_write, 1);
-
-		if (MLX5_CAP_GEN(dev->mdev, pci_relaxed_ordered_read) ||
-		    (MLX5_CAP_GEN(dev->mdev,
-				  relaxed_ordering_read_pci_enabled) &&
-		     pcie_relaxed_ordering_enabled(dev->mdev->pdev)))
-			MLX5_SET(mkc, mkc, pci_relaxed_ordered_read, 1);
-	}
+	if (acc & IB_ACCESS_RELAXED_ORDERING)
+		mlx5_core_mkey_set_relaxed_ordering(dev->mdev, mkc);
 
 	MLX5_SET(mkc, mkc, pd, to_mpd(pd)->pdn);
 	MLX5_SET(mkc, mkc, qpn, 0xffffff);
diff --git a/drivers/infiniband/hw/mlx5/umr.c b/drivers/infiniband/hw/mlx5/umr.c
index 05ab0a32ded6..b0799f86994d 100644
--- a/drivers/infiniband/hw/mlx5/umr.c
+++ b/drivers/infiniband/hw/mlx5/umr.c
@@ -445,18 +445,14 @@ static void mlx5r_umr_set_access_flags(struct mlx5_ib_dev *dev,
 				       struct mlx5_mkey_seg *seg,
 				       unsigned int access_flags)
 {
-	bool ro_read = (access_flags & IB_ACCESS_RELAXED_ORDERING) &&
-		       (MLX5_CAP_GEN(dev->mdev, pci_relaxed_ordered_read) ||
-			pcie_relaxed_ordering_enabled(dev->mdev->pdev));
-
 	MLX5_SET(mkc, seg, a, !!(access_flags & IB_ACCESS_REMOTE_ATOMIC));
 	MLX5_SET(mkc, seg, rw, !!(access_flags & IB_ACCESS_REMOTE_WRITE));
 	MLX5_SET(mkc, seg, rr, !!(access_flags & IB_ACCESS_REMOTE_READ));
 	MLX5_SET(mkc, seg, lw, !!(access_flags & IB_ACCESS_LOCAL_WRITE));
 	MLX5_SET(mkc, seg, lr, 1);
-	MLX5_SET(mkc, seg, order_write_after_write,
-		 !!(access_flags & IB_ACCESS_RELAXED_ORDERING));
-	MLX5_SET(mkc, seg, pci_relaxed_ordered_read, ro_read);
+
+	if (access_flags & IB_ACCESS_RELAXED_ORDERING)
+		mlx5_core_mkey_set_relaxed_ordering(dev->mdev, seg);
 }
 
 int mlx5r_umr_rereg_pd_access(struct mlx5_ib_mr *mr, struct ib_pd *pd,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 2270e2e550dd..4a0ef2757981 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -1192,7 +1192,6 @@ int mlx5e_modify_tirs_lb(struct mlx5_core_dev *mdev, bool enable_uc_lb,
 			 bool enable_mc_lb);
 int mlx5e_refresh_tirs(struct mlx5_core_dev *mdev, bool enable_uc_lb,
 		       bool enable_mc_lb);
-void mlx5e_mkey_set_relaxed_ordering(struct mlx5_core_dev *mdev, void *mkc);
 
 /* common netdev helpers */
 void mlx5e_create_q_counters(struct mlx5e_priv *priv);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_common.c b/drivers/net/ethernet/mellanox/mlx5/core/en_common.c
index 2dbcf6673916..62b40a73ba77 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_common.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_common.c
@@ -38,17 +38,6 @@
  * Global resources are common to all the netdevices created on the same nic.
  */
 
-void mlx5e_mkey_set_relaxed_ordering(struct mlx5_core_dev *mdev, void *mkc)
-{
-	bool ro_write = MLX5_CAP_GEN(mdev, mkc_order_write_after_write_ro);
-	bool ro_read = MLX5_CAP_GEN(mdev, pci_relaxed_ordered_read) ||
-		       (pcie_relaxed_ordering_enabled(mdev->pdev) &&
-			MLX5_CAP_GEN(mdev, relaxed_ordering_read_pci_enabled));
-
-	MLX5_SET(mkc, mkc, pci_relaxed_ordered_read, ro_read);
-	MLX5_SET(mkc, mkc, order_write_after_write, ro_write);
-}
-
 int mlx5e_create_mkey(struct mlx5_core_dev *mdev, u32 pdn, u32 *mkey)
 {
 	int inlen = MLX5_ST_SZ_BYTES(create_mkey_in);
@@ -64,7 +53,7 @@ int mlx5e_create_mkey(struct mlx5_core_dev *mdev, u32 pdn, u32 *mkey)
 	MLX5_SET(mkc, mkc, access_mode_1_0, MLX5_MKC_ACCESS_MODE_PA);
 	MLX5_SET(mkc, mkc, lw, 1);
 	MLX5_SET(mkc, mkc, lr, 1);
-	mlx5e_mkey_set_relaxed_ordering(mdev, mkc);
+	mlx5_core_mkey_set_relaxed_ordering(mdev, mkc);
 	MLX5_SET(mkc, mkc, pd, pdn);
 	MLX5_SET(mkc, mkc, length64, 1);
 	MLX5_SET(mkc, mkc, qpn, 0xffffff);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 775f0c6e55c9..6a486e6fd9cb 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -462,7 +462,7 @@ static int mlx5e_create_umr_mkey(struct mlx5_core_dev *mdev,
 	MLX5_SET(mkc, mkc, lw, 1);
 	MLX5_SET(mkc, mkc, lr, 1);
 	MLX5_SET(mkc, mkc, access_mode_1_0, mlx5e_mpwrq_access_mode(umr_mode));
-	mlx5e_mkey_set_relaxed_ordering(mdev, mkc);
+	mlx5_core_mkey_set_relaxed_ordering(mdev, mkc);
 	MLX5_SET(mkc, mkc, qpn, 0xffffff);
 	MLX5_SET(mkc, mkc, pd, mdev->mlx5e_res.hw_objs.pdn);
 	MLX5_SET64(mkc, mkc, len, npages << page_shift);
@@ -801,7 +801,7 @@ static int mlx5e_create_rq_hd_mkey(struct mlx5_core_dev *mdev,
 	MLX5_SET(mkc, mkc, lw, 1);
 	MLX5_SET(mkc, mkc, lr, 1);
 	MLX5_SET(mkc, mkc, access_mode_1_0, MLX5_MKC_ACCESS_MODE_MTT);
-	mlx5e_mkey_set_relaxed_ordering(mdev, mkc);
+	mlx5_core_mkey_set_relaxed_ordering(mdev, mkc);
 	MLX5_SET(mkc, mkc, qpn, 0xffffff);
 	MLX5_SET(mkc, mkc, pd, mdev->mlx5e_res.hw_objs.pdn);
 	MLX5_SET64(mkc, mkc, len, shampo->hd_buf_size);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/mr.c b/drivers/net/ethernet/mellanox/mlx5/core/mr.c
index 678f0be81375..c615a6ea1a04 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/mr.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/mr.c
@@ -35,6 +35,27 @@
 #include <linux/mlx5/qp.h>
 #include "mlx5_core.h"
 
+/**
+ * mlx5_core_mkey_set_relaxed_ordering - Set RO flags in mkey context
+ * @dev: MLX5 core device
+ * @mkc: Memory key context buffer
+ *
+ * Sets order_write_after_write and pci_relaxed_ordered_read in @mkc
+ * based on device caps. Call when creating or modifying a memory key to have
+ * relaxed ordering.
+ */
+void mlx5_core_mkey_set_relaxed_ordering(struct mlx5_core_dev *dev, void *mkc)
+{
+	bool ro_write = MLX5_CAP_GEN(dev, mkc_order_write_after_write_ro);
+	bool ro_read = MLX5_CAP_GEN(dev, pci_relaxed_ordered_read) ||
+		       (MLX5_CAP_GEN(dev, relaxed_ordering_read_pci_enabled) &&
+			pcie_relaxed_ordering_enabled(dev->pdev));
+
+	MLX5_SET(mkc, mkc, pci_relaxed_ordered_read, ro_read);
+	MLX5_SET(mkc, mkc, order_write_after_write, ro_write);
+}
+EXPORT_SYMBOL(mlx5_core_mkey_set_relaxed_ordering);
+
 int mlx5_core_create_mkey(struct mlx5_core_dev *dev, u32 *mkey, u32 *in,
 			  int inlen)
 {
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index b1871c0821d0..bc449b26be56 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -1035,6 +1035,7 @@ void mlx5_trigger_health_work(struct mlx5_core_dev *dev);
 int mlx5_frag_buf_alloc_node(struct mlx5_core_dev *dev, int size,
 			     struct mlx5_frag_buf *buf, int node);
 void mlx5_frag_buf_free(struct mlx5_core_dev *dev, struct mlx5_frag_buf *buf);
+void mlx5_core_mkey_set_relaxed_ordering(struct mlx5_core_dev *dev, void *mkc);
 int mlx5_core_create_mkey(struct mlx5_core_dev *dev, u32 *mkey, u32 *in,
 			  int inlen);
 int mlx5_core_destroy_mkey(struct mlx5_core_dev *dev, u32 mkey);
-- 
2.52.0

