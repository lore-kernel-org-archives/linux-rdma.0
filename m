Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010030.outbound.protection.outlook.com [52.101.201.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8480937E2E6;
	Sun, 26 Jul 2026 09:30:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.30
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785058256; cv=fail; b=tZH2lvWCaFAu+0Bfwool303TI02yaYeQz7AEQP/mI1FTfegnlouEQmHXVgX+mUu6DW2mY0U5Etlbtgtcb2wecqjZebHfvhqZmnMHW3mR0jDzY8wr9e+6vI/cwu4xn0iKW4E1ud+p6hzO4ZiJQcoXON4dD4/KgN4gDC4GhSZ6510=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785058256; c=relaxed/simple;
	bh=25p2+tzPd2yiKWi28X75QLZ6FZOYo6YDIRq7oWt3C4c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=rMNzkyry2I85XOmCVk9iZT6Nns2H9/2TWSEm5BYs97LiSoOXHjAuQBObmQ3cl+y32d+yZRJiHVxsexD0ZjzywU2o746aWPuBoTjh1gpWPce4MceDGbOn94mNNQT4kMdBGBgtzTKsUE9YsK8Fglc/y4ihqfbslwqRePuQyDFnL7A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=moZSYL7D; arc=fail smtp.client-ip=52.101.201.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="moZSYL7D"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=e+70287Kij3FJkZ5zWzQHKJuDKg1FKbYwNWp+We0wJ6+Y52cTwyNSQYHdm1VCRvhJePBcQgGuzmYJltqxRPeBpXZ3QToJ2QbjdHXk/PcRjX0ZmxTy8QiNuzTYJIVz8I101JdhEOeRZQ+pDQfNCG6LWe8aPF2Fr/mVBuP9lmRRRzrM0fS8JeJctcwUu/IUKbHMsP1XcuW4zPKXh8Dyt+P2sdlVjXkT/n40KWNJZ+2VKJUpNcGKBub4CLbPsW4DE/7xdmTJbDBbj4Rp7CJ7J4X8IHbaclXg0drCuKwnqZgkPboqRQeX87ux1OhtM24VeWnY+LvxXDk9AZiEiNgnqPqlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kuMhBRcQ114W0AsCOf0wX2aWxtGLDf4g4wPvFPhISNo=;
 b=IAkXaJQEcEXB2bJHlCHrZhpKHLykO/zOFrg0L8MPJrVazfW4b7jQfWxYS1+D1qwSZKo1O7CAemHSewABgP8cGyZoydUEuHzeUgHgZJteW48BOlRLLf4vnlu2XVJq5lpjipK/13M5NbKdlWKk5Mz85ga4wydBdd2O4Zp4oLrYlhS+xgvq7RigRCif3aojL8EtEgwi9hNpZlG4360b5EtUJrLJdY96JRqB9JdmbNQt4ewAJjZThjUJskDVl1gaeAAbJbjjcvzHEu6E3YJooGQcbvSVPc+puUnJWKm3+2WWaZH76Tf4DV6INuBqifUmBz6CAz54uHziKI0vK3FzHEPETA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kuMhBRcQ114W0AsCOf0wX2aWxtGLDf4g4wPvFPhISNo=;
 b=moZSYL7D8hMl09gvKmgIuF6GTTOw+V2JiMitAi6XQLYv+obk+m8V+z6LkrwciNOYbz04HcElW1GyNw2xQLlNAw6QNTN/H+/bw6Auef+qzcK/q9JZDVWjehCra9y8t8uUWRPAq946NeNRD7ql63wVGkcHSmllpwntqJM9GbANog/6g0dSkcyt8+bfA/6tq1gMkM+1wK54jZCqjfBtvbuUdQ1mxFYLIjJPX3eLuJEore0gSn7E6D2CoBTduzg2syfIYgP1+9Af7kUoU8DT8iBiG5wP2kXxqDdYBLn2Sd93OfAmDMsxmwZlwmDSnoRsYPLYZywgJS3c731/P40r6STwRQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9715.namprd12.prod.outlook.com (2603:10b6:408:2a0::7)
 by CY8PR12MB7611.namprd12.prod.outlook.com (2603:10b6:930:9b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.13; Sun, 26 Jul
 2026 09:30:52 +0000
Received: from LV8PR12MB9715.namprd12.prod.outlook.com
 ([fe80::e74f:2cf8:cf2c:142]) by LV8PR12MB9715.namprd12.prod.outlook.com
 ([fe80::e74f:2cf8:cf2c:142%6]) with mapi id 15.21.0245.012; Sun, 26 Jul 2026
 09:30:52 +0000
From: Michael Gur <michaelgur@nvidia.com>
To: jgg@ziepe.ca,
	leon@kernel.org
Cc: linux-rdma@vger.kernel.org,
	netdev@vger.kernel.org,
	Edward Srouji <edwards@nvidia.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Michael Gur <michaelgur@nvidia.com>,
	Shameer Kolothum <skolothumtho@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Alex Williamson <alex@shazbot.org>,
	kvm@vger.kernel.org (open list:VFIO MLX5 PCI DRIVER),
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH rdma-next 09/15] vfio/mlx5: Enable relaxed ordering on the live migration data mkey
Date: Sun, 26 Jul 2026 12:29:23 +0300
Message-ID: <20260726092943.2880176-10-michaelgur@nvidia.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260726092943.2880176-1-michaelgur@nvidia.com>
References: <20260726092943.2880176-1-michaelgur@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR4P281CA0118.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:bb::9) To LV8PR12MB9715.namprd12.prod.outlook.com
 (2603:10b6:408:2a0::7)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9715:EE_|CY8PR12MB7611:EE_
X-MS-Office365-Filtering-Correlation-Id: 4287942c-5ec9-48de-dd2e-08deeaf895f8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|366016|1800799024|10067099003|18002099003|22082099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	UhhSGaTdlQbcHCI6sLVEdbo2FsoEPYG51qD3eae/EUNBecPbfBPwyhUsCdIko6TIFAvmShNCtdnfpGcPkdsvCGc52J9fQ0ZeQXQEZNI6QbHI7CSNGIdMnFW9iGfWnrhaW8UAHHQNYrEiY1QjAbIzl3v6hvM77IlhNYJoghWLwxibGtZhcyYUaGINs48pzXSuAT00g3/4JLOJ37ugbJ76U84FEbdNT5shbEevz3S2q8kl5S3hAv0Tn8M6chC7AeugP5rNdq1t3Y1nfoLAzfXhtOz1XkPtWJFSmZ3Qu65auFAbsBiKYC/D4QEw5SY/9JhaT+3yH03bVZYTwg3dhtKGzWiDjZ2Mj85wJaYvpyh1/Z4WoVQ/fAiSeBfbHlGLdlQ5WE9jwZRdQEuDdKxHsiCyUSsprabVEQpjPooJ5uKNKpAOfYiR/lxfMbEMRLu3J820SkJFe+vT7Vm70fKfgtZ9TZxke8pL6XiS+lbDyqex82TpbtGv3dMc7cd5Ab6Zh44rY6FMPRDtu7laRkA/XeSMIFDydRIWSVBWqwud0nm0Y1PAEigaIT1e+wu3wXbKGWmjxGClAiuXlt2BPxLDjHuu8x0D3CJitluwg0nxZXErNjhWoc+rwfPyvaScbj/xfDC3rYAO3OxAF1ADEZlRlJ0nTnCiKVPPzfaSCpFJAAGYyfM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9715.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(366016)(1800799024)(10067099003)(18002099003)(22082099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?IO1Wj8BTugT+HkXyR1HSMbHsUgEuUmu3ukrnNYB1FY7gtYGPE0D9xNHbqT0p?=
 =?us-ascii?Q?t9Aq/mfWPGR7e5LdCBRijfnZRNun5gwhahbglNmV/11dCAB8qzASGamvFlPq?=
 =?us-ascii?Q?apLir0JeB+znxUkArMTZg9UNEAy8i8nONqF8WUzYEFGB/aV3VNpbTTjkvXqB?=
 =?us-ascii?Q?9pJsTdHPwKLneY4GDXV8y7wSFQpgW7/qSld2xRJaYB+CqPew+6PicOrTwc+g?=
 =?us-ascii?Q?WXIONTpkUJvgCwkBHvUBbYPmHDJG4Hk7uG6hNJAW5GlmtFecuW0ofvfQx9/w?=
 =?us-ascii?Q?BbVT7HfJnLEiBKpdFGV3VSsBEJHWu1Haxd7do4EOqBeXgZX8oRwUzPcgehnX?=
 =?us-ascii?Q?FLH2HgJc/Jdn6rrgfREhuJOPLiE9nTLsecbrnCirwDW7QXcHP9qUg3/6tZbJ?=
 =?us-ascii?Q?C/T6E8k8fb6sUbX4860JqgEWRpP4XYUG/oZNgTUO60JonN236089zKqjXaXu?=
 =?us-ascii?Q?0Jy0Cx00V7OokF6SBKaLV3Xu4WP1li4rVhd79XQM0g89FmoqXramdnWbD6hJ?=
 =?us-ascii?Q?Cv2X0MyWeqEzAJVjKQLTVK3YZCWutOnJsgK/wo//UtZbjvu8MpoAHiXvVsdZ?=
 =?us-ascii?Q?gOApeZSbrCOmKnbndlwsYIUEJBU75hxPolLX+NRwc7FpZWtIfKPj7TXC7mve?=
 =?us-ascii?Q?j4ERBl4x1SmzTn7JUBpbvJTtogaumK5R5SxqjL+xnDjZ+Ts7aqJGWsQGBETt?=
 =?us-ascii?Q?wVNGqlNTLTkKY4sPdeS0fmHmxt+z7HRXlIUQs2Lte9jIs4JxCbWyL/++Rsdc?=
 =?us-ascii?Q?09Kuf/pJLb1H1+V6G5hZC0a162giPDvu3aN8GAmDN3cIzCLh/PfeVMerdkDv?=
 =?us-ascii?Q?uB7KG8X/dibs3WxePt8glLJoj4nJMpadW9WOmWJJ7M0mhHExfXPYM+baY2L9?=
 =?us-ascii?Q?kCdftZCAmGjfSy+gGPT+tPTxyPrqBWuL29XNitJCOXs9fM0toqhiivSvk/GF?=
 =?us-ascii?Q?tmAa/q43RlKsImCqIyxDebrFB5V0e2kaG5ccD+AXnOyMg4dlrzC6yQQuL0cu?=
 =?us-ascii?Q?I2/H7NQjK7q45rPBb+1nq+nMHBS8ZrLWcgPz0uDUCsDpaAwf64cXlzwMsIwk?=
 =?us-ascii?Q?Olk4kl+0H6wlHZkyte/iHXZyYIZZXMZoFkDXvDEEn5K50WqZielO+YvVF9IB?=
 =?us-ascii?Q?chPLNxePenhk4495hybj7HcfF5UFRsNkIa4dBeHcWZXav3sLg8lUPyisacHg?=
 =?us-ascii?Q?tPUQYH7qhhd8u1KusMZuunFR3f2pLSsC2CSjAXQBcT72uE1vWM55a/gVlznv?=
 =?us-ascii?Q?a4MxrzW0LsCOe93jqVslWQ4L1ri525di+K3N9TJoYrVrznFj6UU+QqKx9pxK?=
 =?us-ascii?Q?1eW9Bj2kTJogGpblfSaCzqVOJJHRN/Q0vMt7dyD3BJoVX3GvlnLU0bF/syKc?=
 =?us-ascii?Q?dWeJk1UDVLlczauyCvfMzROIWQJ5Aatnqt71wIyS+4Pw0HNdGp/Tbsl4odKw?=
 =?us-ascii?Q?gQP1x7+VhVGc8cpmzwEYjFhpixHq+8Zi3PqhADy1c6urKvSqew/BbBp18K6l?=
 =?us-ascii?Q?5728yJuCCZv7yKRrd2JBWzxn3LCGIWQeTt70mlU1aN1PyYjQgKMEaMJeAdm6?=
 =?us-ascii?Q?ITBCqsdFhsxbnp0DQfp3LA1KjV4ov9OSltNFw3cdRMo9C0bZhT82LdnMfZB/?=
 =?us-ascii?Q?8R6qAjmwg+m1/ps4xUC5K4BUkhRPHJNOkORBcRfMBdqxn/EMRO9du1R+g141?=
 =?us-ascii?Q?AUuJywM5ayeU354BSp1vMqDUolgavP+7n0KZXJzGYai/GR6gC303FRt9vSUd?=
 =?us-ascii?Q?yQhGR09r/g=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4287942c-5ec9-48de-dd2e-08deeaf895f8
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9715.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jul 2026 09:30:52.3060
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5mnsU/cqHTzUXOJZMovzY7yvAflGaSZhiqq6d22Cs+XZLE2rDe46iJJfxBwNp11wddN3p4sAFXVx6uwLhjb3Xw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7611

As firmware guarantees that all device-issued data writes complete before
posting of CQE, there is no need for strong ordering of memory accesses
on the live migration data mkey.
Enable relaxed ordering on the mkey via the mlx5_core RO setter.

This allows better performance and supporting vfio live migration on HW
that restricts memory registration with strict ordering.

Reviewed-by: Yishai Hadas <yishaih@nvidia.com>
Signed-off-by: Michael Gur <michaelgur@nvidia.com>
---
 drivers/vfio/pci/mlx5/cmd.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/vfio/pci/mlx5/cmd.c b/drivers/vfio/pci/mlx5/cmd.c
index 5fe0621b5fbd..f534c27597bc 100644
--- a/drivers/vfio/pci/mlx5/cmd.c
+++ b/drivers/vfio/pci/mlx5/cmd.c
@@ -320,7 +320,7 @@ static int mlx5vf_cmd_get_vhca_id(struct mlx5_core_dev *mdev, u16 function_id,
 	return ret;
 }
 
-static u32 *alloc_mkey_in(u32 npages, u32 pdn)
+static u32 *alloc_mkey_in(struct mlx5_core_dev *mdev, u32 npages, u32 pdn)
 {
 	int inlen;
 	void *mkc;
@@ -348,6 +348,7 @@ static u32 *alloc_mkey_in(u32 npages, u32 pdn)
 	MLX5_SET(mkc, mkc, log_page_size, PAGE_SHIFT);
 	MLX5_SET(mkc, mkc, translations_octword_size, DIV_ROUND_UP(npages, 2));
 	MLX5_SET64(mkc, mkc, len, npages * PAGE_SIZE);
+	mlx5_core_mkey_set_relaxed_ordering(mdev, mkc);
 
 	return in;
 }
@@ -439,7 +440,7 @@ static int mlx5vf_dma_data_buffer(struct mlx5_vhca_data_buffer *buf)
 	if (buf->mkey_in || !buf->npages)
 		return -EINVAL;
 
-	buf->mkey_in = alloc_mkey_in(buf->npages, buf->migf->pdn);
+	buf->mkey_in = alloc_mkey_in(mdev, buf->npages, buf->migf->pdn);
 	if (!buf->mkey_in)
 		return -ENOMEM;
 
@@ -1439,7 +1440,7 @@ static int mlx5vf_alloc_qp_recv_resources(struct mlx5_core_dev *mdev,
 
 	recv_buf->npages = npages;
 
-	recv_buf->mkey_in = alloc_mkey_in(npages, pdn);
+	recv_buf->mkey_in = alloc_mkey_in(mdev, npages, pdn);
 	if (!recv_buf->mkey_in) {
 		err = -ENOMEM;
 		goto end;
-- 
2.52.0

