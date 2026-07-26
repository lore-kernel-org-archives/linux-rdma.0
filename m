Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010002.outbound.protection.outlook.com [52.101.46.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55DB53815CE;
	Sun, 26 Jul 2026 09:31:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.46.2
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785058283; cv=fail; b=DAT5TBuTPEBWRa31ykqNiJ8yc1qsZT33ifYsGhBpB3Vlnp98+isa2gtSi427TglMm5QasmlOU9e+A99mIZ/L8Gz2kaB1Nkcy/J9dD65USDBDWwGs6UCX0YvKa/9Nu7F58P9YA5e+HK187ZUUIQXrur1p3ci7/Wh88A1V226UUWc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785058283; c=relaxed/simple;
	bh=ZM2EAxE5tAggjyEJp3BfQoDh6jvRYRoeiYoWMUfdTlc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Br0u5UYKl59FoxrYuHpG/NDFAX9sEur31RDkZPqAL64g5ZPnuR3qyptEXZkKvhD3DcfmH7EBh2rmoGlkoG1LSkSi7nR2y6Yq5P8ZHVMrWgYRaZikR1mumoCZP+iLz41/l76uQel+XiBfLOMWtox1h+0FaTxYn5DQ1bfFQHeJPR8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=AZxKwpyX; arc=fail smtp.client-ip=52.101.46.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="AZxKwpyX"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OgsA8ADMSszLv5Efs9YJA+F+N9LUzW7+LzvNSwRZlhmNeeVFhEINNolXdLFLofMYzQb9BahrImfCpAyjDYNI96Am/cyAEsO77z+a+BbSGja5J+gESNe6GTY+M/DdPDaiaztoc7ZHGYaWydyVWNOw/zv7UqA3CV7K48Vv6LAE5+l76Ri0anGk6Z9kWqwoWclizKQ4p0azNousoQZW4z5u0Rp0F5zpVK7uGZCdsye1+ywO/r/4wrtL8elJugxsOuaZwbQv2VBiG5+5unVwBUW1+kNAmZwYYScvyy5UdkWIANMtyROq2C+tIY5kqhTQzXT8CDdHx7xXGRPNd8droBEUlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1uDImLbutbMauoEFyeMLsingHSc7vgmM0YKNHmvh524=;
 b=VmWzxHh5HaTI8PygpQRwLpFc5PM8L/Seqjzn+zzBmJpDkn5c0Rle7uM/MbC1MYpgTpzNj/OYrFZO60Gq+4qIdnTWFYurY6mRYMKWkbMOg6h0HvIAvZJ3h0dSpQpVWtN714Ka40f1VGj8YttX/Uzlus1i2PXIkhjVqqv2jL5b3zTYDezcZcpis+A4hSolTl566FCRXOrikDvgDvYyLPpBdJLRn1PDBoBVdVBn7LmSu1nGtuR6WPsNkq2D9nIh1il3+UpUeWdum5iqKmcde1BGyRKqwIhRmPOlzCGAgI6lC1RkXiLPLLVHX3L4gKyJozv8FpZToXtdziZRso2n6TgWtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1uDImLbutbMauoEFyeMLsingHSc7vgmM0YKNHmvh524=;
 b=AZxKwpyXe+0Wg/TqVVsV1dVsl8+pjRDYMQqzj2ytCJUtFnp336yTI/FqizKx9Ba3nMFu8EwfF2f6/GyfxLLUOFPtElQi75o7t8xVgJucYhO783goiDm6QWL2ZCd2pqk+12r4yDSkCM+JqVk7CzA5bGuU6pek7b8ufuM6fMuhvMXoTLZ7pI325mZNUda7jcqFKYLS4WDm4gdN1TUFkSfUtQT9Iz9aGQ8f54sTlqn7LkucmqONaAPo77unMzHQDsyRXntCQBmlNVs2eeEkK+gjBgkg98u+rMgZ11pgMj9q2yIPWWRqo0mlGguf+MAHbyNIJBZOGaHvR3Vez9JsSQJC/A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9715.namprd12.prod.outlook.com (2603:10b6:408:2a0::7)
 by CY8PR12MB7611.namprd12.prod.outlook.com (2603:10b6:930:9b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.13; Sun, 26 Jul
 2026 09:31:17 +0000
Received: from LV8PR12MB9715.namprd12.prod.outlook.com
 ([fe80::e74f:2cf8:cf2c:142]) by LV8PR12MB9715.namprd12.prod.outlook.com
 ([fe80::e74f:2cf8:cf2c:142%6]) with mapi id 15.21.0245.012; Sun, 26 Jul 2026
 09:31:17 +0000
From: Michael Gur <michaelgur@nvidia.com>
To: jgg@ziepe.ca,
	leon@kernel.org
Cc: linux-rdma@vger.kernel.org,
	netdev@vger.kernel.org,
	Edward Srouji <edwards@nvidia.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Michael Gur <michaelgur@nvidia.com>,
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH rdma-next 15/15] RDMA/mlx5: Enforce relaxed ordering when HW requires it
Date: Sun, 26 Jul 2026 12:29:29 +0300
Message-ID: <20260726092943.2880176-16-michaelgur@nvidia.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260726092943.2880176-1-michaelgur@nvidia.com>
References: <20260726092943.2880176-1-michaelgur@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR4P281CA0400.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:cf::20) To LV8PR12MB9715.namprd12.prod.outlook.com
 (2603:10b6:408:2a0::7)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9715:EE_|CY8PR12MB7611:EE_
X-MS-Office365-Filtering-Correlation-Id: ed2f330c-41af-4af7-a8d5-08deeaf8a4d9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|366016|1800799024|10067099003|18002099003|22082099003|56012099006|5023799004|11063799006|6133799003;
X-Microsoft-Antispam-Message-Info:
	XYBHzJpoV1t8TzBYgdRM40IM7uy2DJzIncRA2yOBSqxeuKVeCmuFoAUt1eA0SalNB28N2d0GjQkyGXID8W492kFirP4azi+xX75oAM+rYtTVlETiYJ0UOtqTFvkt6fVeJ+l8ufSCDrMTJbW9iAjh8EtLrPZ63xtEsevXxFRtzQAft8kirtCi+J+0HE+e+GJQ7pc+Cmsrubdw1s4TjCddYK2L04plN78eXl1NuASXoO4txU71l2gVM1ETWdx91T6fGHFqsXTv6bG+Lm9aHlqtwXogeYzF9JTRReATsJO7Rxp3Z4umaSX6ls8vlhCS8LteB2OpkYz8AqzBo7J6C8pf8I5fgsv81+ADcNsXcJGTL0dkapLmpxOFzdVtyrfh+KQHSB7kBunQKLnh8Npk1bg+y4aAKP8cFpqSWprSkw33uCvLAuUPw35VT0trWIyIb1hLqXo/sN3ett8N8CD4KOC2H6Sktck7NSnNw8QjTSx2s/3Cb373lCjTQ12GvSE1TVqHtYOL7XcnNjQvoahkS6dZnWoP6boYKfyzBVosmerfRjIV2yZaX9vLPou8CZr8PgYw4be0fhMWexZgKzb/Wd46MEVy37Lk81EsQL5TDg2TljseRF8C4cvwJr60zgxBJ6rUDO2Mvi1AlDrGICRVpAjxek8LY1pJS02w1Jr6kvWgSfY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9715.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(366016)(1800799024)(10067099003)(18002099003)(22082099003)(56012099006)(5023799004)(11063799006)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?euF7A7UEzxABKFl/nZzFr9YZtNbp4P35X45pXkGlGl09XRloGZHeMhF1LR/Y?=
 =?us-ascii?Q?dOKlda38EFSU5MtDIzsyCxHk0Hey69eHuw2ZX6UmOCOVfKCe6h+s8PhCD6jY?=
 =?us-ascii?Q?2dwoG567/otPGInrQxDfYZQOVe0jAGg9p4KpzGMUTaLuq9RudVeOC3Weqw3r?=
 =?us-ascii?Q?uyL3lts54kwoHuZAXncBncVJoHWRcc1WzNCyk42kVfcISOju5JmCuqRKngs4?=
 =?us-ascii?Q?gQWmrLXBY6VAGxNF5mzCrD9TA5DFPFpMdyNTs6YWrB31vM3qJCX5b1iBi8re?=
 =?us-ascii?Q?WzuHsMgAWTzA0tP3gya0qQq2LG3lTH8PCGH98aRcGuHCiSG+EwZ12Lrzk0q9?=
 =?us-ascii?Q?OPqdrZVBcUevys0gUpqRlEfkPQYFQaB6BHAsycB1DYm+Y6KZQykRCdkI7qhi?=
 =?us-ascii?Q?onomvKA7a0pGehqP8hGfjyG4cqDMf6BpO1aBRtU4TtnWYKqBlTVO/K7Lr6iU?=
 =?us-ascii?Q?4A9Le55XhD6AgMq+LF64Beli7Kqxarwup5kRcdL4/bXhuhZcYyQnviv3T43+?=
 =?us-ascii?Q?Ighyv0cHyAKDAJbMgPXR6+q4EnjbOoWVexlp0yn61sEY8SZ8/x63FciZ0kvJ?=
 =?us-ascii?Q?O4bcIrvvMaFSRac8U0uF+DYQ5Mt7bmdOJH50o0i5MbIZTQLU/V7HliXw8aH5?=
 =?us-ascii?Q?Y8OQuL7X0eygEihL9e8pgYKP/4e53XC1fvdOhCTK6mTSDvuMnzZ/P4VsTv5x?=
 =?us-ascii?Q?3vrJg7cmdEZIB367FPyk0Ix/ufQvz3JKlgoMDNmkZ2HVhnanOT/RhO+mxxMY?=
 =?us-ascii?Q?M92J+Eik6Q26Z4qDht0agXlNju52qTqDsYMTe70TGUrs3oOwIDRd6ieGunhz?=
 =?us-ascii?Q?oA6TclfBbFcmdKvT9FS8pD+oZiptRI+NsaIT0+liSdCd8xVbolT0oBF4fcgo?=
 =?us-ascii?Q?ySy3UaawKtmG3VVyIyC/4+s2CFebLOWNYneLTHf0Z1dcECx2wzaX+TPNb1XM?=
 =?us-ascii?Q?tDYktitZrZCUJoiydGcADgPnzwp9Yx1/8VeUxItcChjMIhdb+O11Jb9L+qI7?=
 =?us-ascii?Q?ygdLdnnijHYIkUaI7QRCS1IPwcsU0ffyOjpx2fMxJnrtLU4wwVko7Z3O9lh+?=
 =?us-ascii?Q?l7XyPhzJ/zARNSiqhZ8kVAeP1MFVrnuI10ZlMA9GNShaRSjl/82Hy8WF8Vft?=
 =?us-ascii?Q?C09vUYJYY8hWKXF09OqO3P/GbM3IRVD4dGxbH4nxxmXn6XqYh/MFKf7zaryy?=
 =?us-ascii?Q?Hmk+Xi/TZjP3et9CPm6DidfekuxmiA1VJQEl1dCZ/+X3vBeV5jRlrJ25saNh?=
 =?us-ascii?Q?nz4NAjInrkY2yaykP6gKgdyQGTYUt9JTEBQzXIEDqFSwq+Yx0kpjp20OlIZm?=
 =?us-ascii?Q?dn/QpecYnPHPv7QxDQG/EEg/FXtc35IbDpCyLkBvJRv6SP9d9qy9OE9vY6HA?=
 =?us-ascii?Q?akI8dKQuQrBFrEgrO+l/LwAp16nr52JfzdiGQY6L4c66m29IP+/6gLx2SdhU?=
 =?us-ascii?Q?aVzmJ/6pvdyDLeXS49IaW1KPeHgzn0fENueYaTPg2wTmhGrTQOC6pvxSjk8g?=
 =?us-ascii?Q?510ZKHZgIf+cxbhtur28pqPROpcDcDK43ecqiwBT9bSa6D9s9py+5/8UUH+i?=
 =?us-ascii?Q?FREEJ6D3CwNYkPi6jAyl8NZ4nxODIpf8/Q/Fc1zITW0r1JdrZeNQDiJOmHmy?=
 =?us-ascii?Q?BqpF+H6k9EbQEgNdaHY9xxUH8sGhyQPEwc7zPNWPbZJ+OvCh+HI+CNZCIxCz?=
 =?us-ascii?Q?N8RfmSCebkbRs2WnvciDeJThCIzjtKqP5PjJg8oUY5XlJ9+2CCZC36bMheDD?=
 =?us-ascii?Q?vIXy6M5+UQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ed2f330c-41af-4af7-a8d5-08deeaf8a4d9
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9715.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jul 2026 09:31:17.2453
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZRPF0A55RLVgi6++EE9pKkByjD9H37kgLc/Zt3uj6ftWl8r2oWfTdeqvCJrhbp/bGLjuM3+dtxa4fj/1ul+h2w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7611

Add relaxed ordering validation (relaxed or unordered) to enforce no
strong ordered mkeys are created when the HW disallows it.
Reject MR registrations that do not request IB_ACCESS_RELAXED_ORDERING
or IB_ACCESS_UNORDERED.

Invoke the validator from all user-facing MR registration paths,
including the Device Memory path (mlx5_ib_reg_dm_mr).

Reviewed-by: Yishai Hadas <yishaih@nvidia.com>
Signed-off-by: Michael Gur <michaelgur@nvidia.com>
---
 drivers/infiniband/hw/mlx5/mr.c | 29 ++++++++++++++++++++++++++++-
 1 file changed, 28 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index 31879c0ecfb3..5a7bec0d7edd 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -84,6 +84,16 @@ static void set_mkc_access_pd_addr_fields(void *mkc, int acc, u64 start_addr,
 	MLX5_SET64(mkc, mkc, start_addr, start_addr);
 }
 
+static int validate_ordering_access(struct mlx5_ib_dev *dev, int acc)
+{
+	/* If HW disallows Strong Ordered writes, RO/UNORDERED must be set */
+	if (MLX5_CAP_GEN(dev->mdev, mkc_order_write_after_write_ro_only)) {
+		if (!(acc & (IB_ACCESS_RELAXED_ORDERING | IB_ACCESS_UNORDERED)))
+			return -EOPNOTSUPP;
+	}
+	return 0;
+}
+
 static void assign_mkey_variant(struct mlx5_ib_dev *dev, u32 *mkey, u32 *in)
 {
 	u8 key = atomic_inc_return(&dev->mkey_var);
@@ -679,8 +689,13 @@ struct ib_mr *mlx5_ib_reg_dm_mr(struct ib_pd *pd, struct ib_dm *dm,
 {
 	struct mlx5_ib_dm *mdm = to_mdm(dm);
 	struct mlx5_core_dev *dev = to_mdev(dm->device)->mdev;
+	struct mlx5_ib_dev *ib_dev = to_mdev(dm->device);
 	u64 start_addr = mdm->dev_addr + attr->offset;
-	int mode;
+	int mode, err;
+
+	err = validate_ordering_access(ib_dev, attr->access_flags);
+	if (err)
+		return ERR_PTR(err);
 
 	switch (mdm->type) {
 	case MLX5_IB_UAPI_DM_TYPE_MEMIC:
@@ -843,6 +858,10 @@ struct ib_mr *mlx5_ib_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 	mlx5_ib_dbg(dev, "start 0x%llx, iova 0x%llx, length 0x%llx, access_flags 0x%x\n",
 		    start, iova, length, access_flags);
 
+	err = validate_ordering_access(dev, access_flags);
+	if (err)
+		return ERR_PTR(err);
+
 	err = mlx5r_umr_resource_init(dev);
 	if (err)
 		return ERR_PTR(err);
@@ -1034,6 +1053,10 @@ struct ib_mr *mlx5_ib_reg_user_mr_dmabuf(struct ib_pd *pd, u64 offset,
 		    "offset 0x%llx, virt_addr 0x%llx, length 0x%llx, fd %d, access_flags 0x%x, mlx5_access_flags 0x%x\n",
 		    offset, virt_addr, length, fd, access_flags, mlx5_access_flags);
 
+	err = validate_ordering_access(dev, access_flags);
+	if (err)
+		return ERR_PTR(err);
+
 	/* dmabuf requires xlt update via umr to work. */
 	if (!mlx5r_umr_can_load_pas(dev, length))
 		return ERR_PTR(-EINVAL);
@@ -1167,6 +1190,10 @@ struct ib_mr *mlx5_ib_rereg_user_mr(struct ib_mr *ib_mr, int flags, u64 start,
 	if (!(flags & IB_MR_REREG_PD))
 		new_pd = ib_mr->pd;
 
+	err = validate_ordering_access(dev, new_access_flags);
+	if (err)
+		return ERR_PTR(err);
+
 	if (mr->is_odp_implicit && !(flags & IB_MR_REREG_TRANS)) {
 		if (!(new_access_flags & IB_ACCESS_ON_DEMAND))
 			return ERR_PTR(-EOPNOTSUPP);
-- 
2.52.0

