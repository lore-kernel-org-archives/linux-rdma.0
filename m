Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.46.4
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794405467;
	b=ZR6gkesT5zfOlBrU8NSteOjddyRaEzdF/WclbDfBdiaMYdgZbLefS3saPof3paVgZde/
	 +Afx2iiO6I+55Nrkk4EwmjGat2lUY6hlzUdXqym0JqOpHEEHGcikbE9nV8L27HZOZRZbx
	 jEI76g7t28RwY1GL8wUe1335o3nah8xYxHTR0KoV0bV4TkgzkZsgvtkd5fc7slyQs2Es/
	 ZLZVy1L9QSuNAj1D/TuMHKeQ66FxWnHkfcz2GIzphT+VesZdGbV1uclGETFiIcOZRGZpB
	 okvLsM1GP/nPah786y8nibXGeTOOlmXggZxSvkEuuF8R7Da4yFdDKThJwpNDTau3Y1g==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794405467;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:Received:
	 Received:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-ID:References:In-Reply-To:To:CC:
	 X-Mailer:X-Developer-Signature:X-Developer-Key:X-NV-OnPremToCloud:
	 X-EOPAttributedMessage:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-Id:
	 X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=NG0FhpsQ5OF7/HFSI03WANzhs/+DE4ECO4shGIbY+So=;
	b=eHV7vM7LM67G0/0Yr+H9QiW1WxMJhaeO4CZpaCLKXMqkh0JqCuz4K9aAJ27sVZNEpCMr
	 h1lLD90ipeVE3wXveg+crQgOi57dQ5SJKYiE+DiAnLHBxjfWgUTmDLr4vnWzR6ENm7kyq
	 z+q2CwD7dpQwWhLkl60WhD55M6hDlAMqkwNeIo2vmlOz5/ngZEkt8jDXPdYMTQsAt8XFu
	 DSvNqiDMLgv9bHfMebsVO3MWPD63FxYzBpX1LwPw0nSj8IdfNxWP+AHHc1j3zV4ihWAhM
	 hVbLznHKlBILVmY/A2Q+qA+OTkt6XL7Y4rdIxMuIQnsUQHky6OrlvIRV2Hmsn6XJtmg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=VMzgpd2N;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.46.4
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010004.outbound.protection.outlook.com [52.101.46.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF6E5606A321;
	Wed, 11 Nov 2026 13:57:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DF6E5606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=VMzgpd2N
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HNdeI8DsWkCvzUk6c7wGRBZFszKVbz4lOROgZ96UNyzYur5E7cat+RZWoSmRtbzjm6smZgG674KfVndumQbpMXQRfFRbA4juYQgRGCgqE2Nvui4S1VtuH7W6uYLx+CUESIvhWhBJJ0h9UCozpMTQvvEXYRg0toKftza/k4AKdWTuKIFask37KXOx372M4CI6XoXqmyGGkFHoNJCCe1SDLsA9wG5Stu+wjKBPoFEGffaIPKTX2h9nfl5II0V6GVy1JnLhNKLZhBrlEraVNdVNfuYjbytySPunBqlJtLGiNrPC53leuptDAieo9lxFchT5Wtlq0ASX45CqMCdCgN0zew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NG0FhpsQ5OF7/HFSI03WANzhs/+DE4ECO4shGIbY+So=;
 b=eAOuzmvF8W78JAf3bd3GP1Bw/kL+D6Q0cKyUdZLEApb+yqPNANtdb6nN/9lUnu3mxtwhOK1r7gAR8X0Q6ibJo6XfR+Ew9E77n0pRd5jvtYlNEu2Tir+LT+wmtmgcoA0IUmi2QyP1osl2nqYZhsqZzFKQY4Hef/x6e4ckQ3IAZi7RnRCI7bkjUBPM0s3FFlfr3TxdNd0o/z88VTsJ0q/X8x4L9XNBZwWZNIIx19oRSumt/CA6GQ8fgsJsP9R16CqqKjCKkc25gzRD+dTNgxKXCMIsqg/VYwS8cmDYS3fZlD1SfXQjQ5fOsdnpzlBQ+nrZirB1NpUP161PhvnwQaYOHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NG0FhpsQ5OF7/HFSI03WANzhs/+DE4ECO4shGIbY+So=;
 b=VMzgpd2N9O8/PBNC6YsDF4nYGjJXt+hVROFQj48rPQVqNpRETM7bJitH8AtJer3miWzGkE/qkWmhDt+fClXfbGmi2JmSVJIOtlYyEHHh+SdcMgGM/LivSjj+M9JG7+j4EFlJzbgVPA1DOqGhwzDAplsbhgdQ1bGU4BWE6sGiEk3ae4AR2H7rz8NBlcEZYyStCh4v9c0uMWqh1glqPMH+7L88rIVsF7LuX3XHfzLvjizeejEnh8ZJkMGnxQZAwA5W6bNf3M4t1MGLZC0IgPlcUlxOMcVAWb86XUK98E+GuJWr+77o5SSjJpe6d3r3W7YljYBNFybmyyAgvgw8lEMUew==
Received: from MW4PR04CA0279.namprd04.prod.outlook.com (2603:10b6:303:89::14)
 by PH8PR12MB7373.namprd12.prod.outlook.com (2603:10b6:510:217::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.9; Wed, 11 Nov
 2026 13:57:39 +0000
Received: from PH7PEPF00000009.namprd04.prod.outlook.com
 (2603:10b6:303:89:cafe::70) by MW4PR04CA0279.outlook.office365.com
 (2603:10b6:303:89::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.8 via Frontend Transport; Wed, 11
 Nov 2026 13:57:39 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.160) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 PH7PEPF00000009.mail.protection.outlook.com (10.167.243.40) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Wed, 11 Nov 2026 13:57:38 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Wed, 11 Nov
 2026 05:57:18 -0800
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Wed, 11 Nov
 2026 05:57:17 -0800
Received: from [192.168.122.1] (10.127.8.10) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server id 15.2.2562.56 via Frontend Transport; Wed, 11
 Nov 2026 05:57:15 -0800
From: Edward Srouji <edwards@nvidia.com>
Date: Wed, 11 Nov 2026 15:57:02 +0200
Subject: [PATCH rdma-next v2 1/3] RDMA/mlx5: Respect pgsz_bitmap when
 reducing the DEVX UMEM page size
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20261111-devx-umem-mailbox-overflow-v2-1-1e7ca8237b58@nvidia.com>
References: <20261111-devx-umem-mailbox-overflow-v2-0-1e7ca8237b58@nvidia.com>
In-Reply-To: <20261111-devx-umem-mailbox-overflow-v2-0-1e7ca8237b58@nvidia.com>
To: Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, "Yishai
 Hadas" <yishaih@nvidia.com>, Yishai Hadas <yishaih@mellanox.com>
CC: <linux-rdma@vger.kernel.org>, <linux-kernel@vger.kernel.org>, "Edward
 Srouji" <edwards@nvidia.com>, Sashiko <sashiko-bot@kernel.org>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794405431; l=1775;
 i=edwards@nvidia.com; s=20251029; h=from:subject:message-id;
 bh=EoDVl33Y0n8MJolTUJsZmZw0HajioAsycPEyPzIgM38=;
 b=B2MgD9y/YjPsVoxqxVqazIxXSKnchIg6zWyPq1PGr991AxgTPZhJLlFg4oNVrb24pNPZ1eVLc
 L1jkYto86xwBs7YoNSg2PGLxvY4Xtvr2PZ0s6SLZmjQdbPCLB2m7IYu
X-Developer-Key: i=edwards@nvidia.com; a=ed25519;
 pk=VME+d2WbMZT5AY+AolKh2XIdrnXWUwwzz/XLQ3jXgDM=
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PEPF00000009:EE_|PH8PR12MB7373:EE_
X-MS-Office365-Filtering-Correlation-Id: 360d0561-eba9-425a-8f94-08df3ffbbf5a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|36860700016|1800799024|82310400026|10067099003|11063799006|56012099006|261021123027099003|261021121427099003|261009223027099003|261102123227099003|261026140227099003|261026121527099003|261022105027099003|261028144727099003|18002099003|22082099003|6133799003|13003099007;
X-Microsoft-Antispam-Message-Info:
	Gtn5v016jLSf5SshoWELl7FvlRquQWUnTwSCvIztoy6KS6CD/kjnJFjWhwagfkkCCHb6a9cGYaqYTY0ZampFT6q6egvrz2EmrlztzLQWjEj7ERgN7Zfokij1EuHLa7tJGvMIcyq6mjHtOVzfk19XI7vLboh8a+/3EFer4cnNoYEsQ+2HuaWW1QefA4hWqnQxOF4lannIo7h4tSJAIUtBK3pMCjXf6505GsG/dllEZvTzjNUmW+9qsJENSA4E6yyMOfyoA/EEWZGd+TISfJ3Ww6VZyC8KL1pnLc8bE3xK/po8tD6BLX2Y1AUXCSnlvMpgmqw9+mOG7pvRJlVSh2SscdopXTIZbJzX6+oDdakx11sW8SAFTjGNUrrFFtr88aeLCAnM44dW3FzcCc1JeQLDnCMHgk3aHb4ZMeYJnB8z3oRZ0Ys9iYUa91LKfFHl4VTi6V01BnJZbKHSwn+5f5D2hlwv6OTvsHDQ1+YxjNIcnHO92l+U6Q7RaBDtHPYaxb0owc6YZi9G1AwaQlDQLqJ8S6CyCYGSqAlou1sxLdPx1J9bvmRDqnjCW8Lx59kUWXtc1xH7AuV844vaEWabarmwLO+4lLoK4sDon3fH5IajK/icp7GhS5kcYgRlRbU5AajDN8QIK6+cs0VzUwVm8CsISd7aZmp/Rsqv2D3RCeJ21ChWhkj78HIgx4qKTUASq93tIRReXBLoy0xJDUBQqWb5bQ==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(23010399003)(36860700016)(1800799024)(82310400026)(10067099003)(11063799006)(56012099006)(261021123027099003)(261021121427099003)(261009223027099003)(261102123227099003)(261026140227099003)(261026121527099003)(261022105027099003)(261028144727099003)(18002099003)(22082099003)(6133799003)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	TTnwzaZVE1m+4ihYrErud8MVaqEenkNFr3xdGvKXUmZul9xOa+NosM7ZRTYn4RYvZNwI+3PksaT0nMhwju03Xa46A/AHxYzvqM37/4RK1tJMgWrpYFb6h7O0N8lC25ieoreX4Y2j8S84ET8/6GkFtk3WMG6efwDwKZ0wK5e1Cmr3S6p239ManUPYXNN7JklHpL1BILOq/TGl7tCqYaldwzocjXNEqYkLCippq1NvqfSQboMtMlmw6CVCfh9D8isSBkJZ//lYK9mY8+SxzPMW7XT/1z4H6vfMnfFGAi+wpFtNYhNLvxBCPfyJq0/pDH0mZrcz6yhj9/FypwL6iFeCibL7aOLCKdsVuUeFqsR0zx64BOocoarLMTgwL5oj+PvN3Qg8MD1PmyvTCLLToXVZ+V63esEyVq1M3CoguUdZEw6d5Tk07hH/Nua/+p6hRqp1
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2026 13:57:38.8281
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 360d0561-eba9-425a-8f94-08df3ffbbf5a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	PH7PEPF00000009.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7373

devx_umem_find_best_pgsize() starts from the largest usable page size
allowed by the user's pgsz_bitmap and halves it until the umem starts
on a page boundary and its length is a multiple of the page size. The
halving ignores pgsz_bitmap, so the umem can be created with a page
size userspace did not allow, although the bitmap is meant to reflect
the HW limits of the intended use of the umem.

Step down to the next smaller size in pgsz_bitmap instead, and fail
the registration if none is left. The default bitmap includes every
power-of-two page size from 4K up, so the result is unchanged when
userspace does not pass one.

The Sashiko AI reviewer found this while reviewing another DEVX UMEM
patch.

Fixes: 7610ab57de56 ("RDMA/mlx5: Allow larger pages in DevX umem")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/linux-rdma/sashiko-outbox-205134@kernel.org/
Signed-off-by: Edward Srouji <edwards@nvidia.com>
---
 drivers/infiniband/hw/mlx5/devx.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/devx.c b/drivers/infiniband/hw/mlx5/devx.c
index fc6f793dcc6584e6a22b40c57e2df8f24579eb14..6c34f2c2a91d0be26352100c243f24789feab3db 100644
--- a/drivers/infiniband/hw/mlx5/devx.c
+++ b/drivers/infiniband/hw/mlx5/devx.c
@@ -2320,8 +2320,12 @@ static unsigned int devx_umem_find_best_pgsize(struct ib_umem *umem,
 	 */
 	while ((ib_umem_dma_offset(umem, page_size) != 0 ||
 		(umem->length % page_size) != 0) &&
-		page_size > PAGE_SIZE)
-		page_size /= 2;
+		page_size > PAGE_SIZE) {
+		pgsz_bitmap &= page_size - 1;
+		if (!pgsz_bitmap)
+			return 0;
+		page_size = rounddown_pow_of_two(pgsz_bitmap);
+	}
 
 	return page_size;
 }

-- 
2.49.0

