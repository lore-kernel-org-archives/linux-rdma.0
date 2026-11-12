Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.201.6
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794490090;
	b=Iqq3XPiJKlcTySjAdFV2ixRUu4y36hVWjijHISOUacWq+H1cf2wIWJj6oAFdhpu3e4MZ
	 mHZKP1k8DgRj/qVa6dpw9eF5PznOap0VsgCasgV/UFcVhXdndnKwpr9qLwT3XFDHMXDF+
	 usjgOQaP24IRcDKPA1YayOegwD61Y7Cb22fUWZ9YZo2OxOW7e2Gwx9zwY8dprkVL+cdmD
	 vrEIrq5CqE3cMUpuxsThbqLiP+rt2ZUZqkBWxJ6h4rn2KYOp3paoqAxZs1ShHbx1v0Svw
	 V2oCTU3O7AH7PM1n0eDKMJcY2thcL/+7So45QxTIIkAt2ZO1Her1BkWRnBK9yHtLRwQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794490090;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:Received:
	 Received:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-ID:X-B4-Tracking:X-Change-ID:To:CC:
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
	bh=OwuN+LCiYj80Uw3ja1i6M7jUN+qSf4MIFyinyu/bjFs=;
	b=mfEAbu+QQ2sSfBYtD7xfz/m8If9KcAhXt4HDfzUCWa7IYOOLQl+kA7i7Wypgj1AdXvyn
	 c1UwxtqnMaC4DLgTvEnbDHOL+YlTjJP5g8dzC2pCWgEacL9cIWISf+jjC6LvrDuUSUV0H
	 J8iZTZaF7m65jDbgcrBaIujkgEiSEI0UWXsdPFFeGjLuZypv+hpR5nEN9YjzcGbmlkJZO
	 rPKnrKFG+whXql+HqT4/YwURyavvLyew3C+e+uWI77l6suxIA8ShfOkNE8RHAOzowBP1n
	 oq9H1iFjRUQvZXKjELUHqOXr3zpR3+ydIy4Z3Az00szfJHTgUgwH+ucWuJNnpCkboog==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=uLpNYM0W;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.201.6
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013006.outbound.protection.outlook.com [40.93.201.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CC0F606A31C;
	Thu, 12 Nov 2026 13:28:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0CC0F606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=uLpNYM0W
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Z4YwTknrXGW9E09+QApVFQrx1LhChJxwGQw3Ot2T+JVpxKJveT5bE71QIK/GD0D/31vp8gGpcC3yeHUDCZbcv5csKLB/5KLrE7wxs3zi+9SfEoQA9TXcLI7W2CvsEZ/wIq9+lxUvPySqjM1zgS4gjZ77YbRVyfLggamD9xdqErH3RcwHA6RuD7HlNcheESKOJXCZ17f7Iy5dfvHSmK0DNJej/+ZpUxd+Yy0Xd4df+/q3llzMqY6w224AUsp5POvS2DFotVt2Obv1jXgCi0jRgxJGPU1W7ycdjv6ywYtwi9rFd6jB7ymSUvwWTifGSC7/U0lIqzmmHLeXYZXrH6eckw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OwuN+LCiYj80Uw3ja1i6M7jUN+qSf4MIFyinyu/bjFs=;
 b=fS/ZRE9f4FQg2oTlV8GduHvEpQw2ZZuvmosKMHd3g3L/1hnNo9O2L5vCcfFe+A26QYg6SLG3mkvbDaBMrAopEG0BrqOTYPI28fPUEwCt40c2CPGRIAxPQLCix5AiAY7qiks/lt25GyfM5Q64JrhdVXoiT23xHM80+oDuStTSBsRZCky8RPn7Lts842VDbfxRhXNX5vy0WTFR0hpuAlAM/2PZ5SH21X2oobgnm621ckL6W5hRgemYKQSlimejoWMMUqbduv/rdYpsMXWi7GjZJ3WAM8zDmDfXpNs0L2Vyy9S5X3PAXED3lBe7keqXlIuLyiHn3IbqOdhxD0GDHaaQPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=cybernetics.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OwuN+LCiYj80Uw3ja1i6M7jUN+qSf4MIFyinyu/bjFs=;
 b=uLpNYM0WG4ogiTFKbzQWRIrNUCFYxbTuexk98K/2SEj6EytZyfvYV76ynNUJTya6qzZ1+wWc8KnQtFVPEqM1QlD6b9DIDgyP5yPdJ6106iDXoZjAGynHpEe8EC9knajRUZl5BLKz6gm0/keovyj6+1a2IV8ksgmZTTumDoCJfdZFtrLB0/mAlM8WdUdhPb7NwO7js2u0qSHCRs1brQnqQeVNoX5cNd2L616K6gBhrAVlCEsKhltKIhpeVi4Ly2w+GmW48qb8GZHH1BOhmUR744w5EI1AwLmNB228R8/GaM/WCUOuEG20PseOPgTxEQuU2Rz6BSXDBf/e9Oz+1HAUIw==
Received: from DS7PR05CA0044.namprd05.prod.outlook.com (2603:10b6:8:2f::10) by
 CH3PR12MB504406.namprd12.prod.outlook.com (2603:10b6:610:34b::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.9; Thu, 12 Nov
 2026 13:28:06 +0000
Received: from CH1PEPF0005BD62.namprd02.prod.outlook.com
 (2603:10b6:8:2f:cafe::80) by DS7PR05CA0044.outlook.office365.com
 (2603:10b6:8:2f::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.8 via Frontend Transport; Thu, 12
 Nov 2026 13:28:06 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.118.233) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 CH1PEPF0005BD62.mail.protection.outlook.com (10.167.244.251) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Thu, 12 Nov 2026 13:28:06 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Thu, 12 Nov
 2026 05:27:45 -0800
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Thu, 12 Nov 2026 05:27:45 -0800
Received: from [192.168.122.1] (10.127.8.10) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server id 15.2.2562.56 via Frontend
 Transport; Thu, 12 Nov 2026 05:27:43 -0800
From: Edward Srouji <edwards@nvidia.com>
Date: Thu, 12 Nov 2026 15:27:19 +0200
Subject: [PATCH rdma-rc] RDMA/mlx5: Skip vport context query on FW without
 ib_virt support
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
Message-ID: <20261112-moshe-ib-virt-guard-v1-1-6d2caf8bdb1b@nvidia.com>
X-B4-Tracking: v=1; b=H4sIALa+9WoC/x2MQQqDMBBFryKzdqBxkdJepbiIya+ZRVQmrQiSu
 zv4du/B/ydVqKDSuztJsUuVdTFxfUcxh2UGSzKn4TF4Z3BZa7Y48S764/kfNDEiEvD0L+c92XJ
 TfOW4Xz+kqQTWSGNrFxpRbgduAAAA
X-Change-ID: 20261111-moshe-ib-virt-guard-ecedee769166
To: Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, "Artemy
 Kovalyov" <artemyko@mellanox.com>
CC: <linux-rdma@vger.kernel.org>, <linux-kernel@vger.kernel.org>, "Moshe
 Shemesh" <moshe@nvidia.com>, <stable@vger.kernel.org>, Tony Battersby
	<tonyb@cybernetics.com>, Edward Srouji <edwards@nvidia.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794490062; l=2649;
 i=edwards@nvidia.com; s=20251029; h=from:subject:message-id;
 bh=nWKDCkiRsrrXYt0Uwiwt/yuZKPfda3/Ad6QnfMCDNzE=;
 b=wJTg8Lx4UFs9X6Rkn5oVbI9rvrt4ZHfXtVdXCfTl+aslB3d7bl0rsJvCZTiqsh4detAP13v3P
 zwyiT8DRpfBAPdLEe72Dqd0kog5q63A0SAJtsHjdzwMH6nvPD4x4uCd
X-Developer-Key: i=edwards@nvidia.com; a=ed25519;
 pk=VME+d2WbMZT5AY+AolKh2XIdrnXWUwwzz/XLQ3jXgDM=
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH1PEPF0005BD62:EE_|CH3PR12MB504406:EE_
X-MS-Office365-Filtering-Correlation-Id: bea03728-a2e1-4c0e-139e-08df40c0c931
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700016|376014|23010399003|18002099003|261009223027099003|5023799004|11063799006|56012099006|261028144727099003|261102123227099003|261026121527099003|261026140227099003|261021123027099003|261022105027099003|261021121427099003|260925022911599003|10067099003|260925021311599003|260925021911599003;
X-Microsoft-Antispam-Message-Info:
	FFw97NuH8SkCIu9B23CNce7DSLyUaJGhJCMZ+NlkjR87imQ+zBWy0nWue5hWWXpgxgD7mX4jXwlG0sZmmvKYUxz154SQ9BTgs7yaRdIto2qfONRc5Cm++Dg+o2tFRS8DusNYp0GPXEIdGhqeUpEXCyM3OAjGbvVBeMBkLL0kByJUC0aHRw85KmZ45uANWO7rcyoM8GHFVw0yDK7oLcGDFPD+P4cPEmo9sUKkttwydJkEp3N6STt90FHIUQYCLNtsEqr9PU2YXss2gQonFlSzK8xmLIOO5bKKKJugfpQNWY3cnLaneXxbBR4+kIm7TgM/pJOZnoQO92OeP39Qmg3YFvuuKTVu0z073/WrCTjzXB48Li7IxclB2FIkoVdHgcpqxKHCDzFRIXDHU33LGiKWNipjJ6N6YCzzUM/pSPXBjjAjTfTzqwPfpgF+nLS70hdybosapIrhpbdbpEwbFweZMsKSDDN4oaeWQc+swraEnNJVicpno83pKoH8dTWth11Ks/x6XzMfRtRTs8mlZBoyUmEITCmHWFr1TmgRFyW8BvwjODLTs/dEcTQ63yjtoLknmi9TZ0AoY0hM7I2wpWgsGMjuiwVgbqTZP5rGpAumuKz5sSuBuBZ9kXfhr12Tf1QCMGO0JgYpfiebWunp8C5bdDeQ4M+3fAH9CnJ2rYUnQU9qvTmY5SnUEriJjyeZSvNPfHacXTNBo76MZXg3LmwqkA==
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700016)(376014)(23010399003)(18002099003)(261009223027099003)(5023799004)(11063799006)(56012099006)(261028144727099003)(261102123227099003)(261026121527099003)(261026140227099003)(261021123027099003)(261022105027099003)(261021121427099003)(260925022911599003)(10067099003)(260925021311599003)(260925021911599003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	FmUcLqWcG6yqBRKGg14dUVwzfMbKCQf0jxDikvjL3cRX7AIGXFV5g7ciI6W3JiMqsHfhc9B1KAgm8VPDFS785W3JpRKUgH+SZX2/WEEbc2AIC62Zac9YLLQP81gFIPAkagaZvL2aZtiQk+08J/s5FB7vEuF6Wr88bSwbUU5Nj43zkl4XzDmeW33z0vd1jBugs+s3KtLu3DUy/5Ek52x/HqDcEnM5yn10Nx7yfk9+j5RT6ZDR73L2M3PRU8v41hsmt71GB7j5UzIoVynmx8XojBXM7+D6/bGIWi4ZfxfIabBIMCfTQ25qGr+b6PUxB4rT/q9g1pNopH0GXF5EodddtSeb4kzF1HkFVzR9w7bQsFzsvPqAUMA+WLdIImLxJANgMKu2kW9TdeD2yqV59Zxlw4oaDe8ZaIVP368LxzNNYzqq10oNI8zIIAKOwAy3qwZT
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2026 13:28:06.1764
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bea03728-a2e1-4c0e-139e-08df40c0c931
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0005BD62.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB504406

From: Moshe Shemesh <moshe@nvidia.com>

Since commit b02289b3d60f ("RDMA: Validate grh_required when handling
AVs"), mlx5_port_immutable() unconditionally issues
QUERY_HCA_VPORT_CONTEXT on InfiniBand ports to read grh_required.
Devices that do not support the InfiniBand virtualization interface
(ib_virt cleared) are not guaranteed to implement this command. For
example, Connect-IB with FW 10.10.5020 rejects it and mlx5_ib fails to
probe:

  mlx5_core 0000:01:00.0: mlx5_cmd_out_err:810:(pid 731): QUERY_HCA_VPORT_CONTEXT(0x762) op_mod(0x0) failed, status bad operation(0x2), syndrome (0x3590f5), err(-22)
  infiniband mlx5_0: Couldn't create per-port data
  mlx5_ib.rdma: probe of mlx5_core.rdma.0 failed with error -12

All other HCA vport context users in mlx5_ib are already gated on
ib_virt, either directly, as in set_has_smi_cap(),
mlx5_ib_get_plane_num() and mlx5_ib_modify_port(), or via
mlx5_use_mad_ifc(), which selects MAD_IFC for port queries when
ib_virt is not supported.

Skipping the query loses nothing. grh_required indicates a GID-based
vport, which only exists with InfiniBand virtualization. Without
ib_virt the port is always LID-based and the field is zero, even on
firmware that accepts the command. This also matches the behavior
before b02289b3d60f, when grh_required was filled in only by
mlx5_query_hca_port() and was never set on the MAD_IFC path.

Fixes: b02289b3d60f ("RDMA: Validate grh_required when handling AVs")
Cc: stable@vger.kernel.org
Reported-by: Tony Battersby <tonyb@cybernetics.com>
Closes: https://lore.kernel.org/all/064dfa67-8fd4-40f0-b925-6d1e0cd42e6a@cybernetics.com/
Tested-by: Tony Battersby <tonyb@cybernetics.com>
Signed-off-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Edward Srouji <edwards@nvidia.com>
---
 drivers/infiniband/hw/mlx5/main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 65455aedd559b6291831492e92a68b24a6bd361e..2ab38068db838880419f1f9d446c6527bc567c59 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -3536,7 +3536,8 @@ static int mlx5_port_immutable(struct ib_device *ibdev, u32 port_num,
 	if (err)
 		return err;
 
-	if (ll == IB_LINK_LAYER_INFINIBAND) {
+	if (ll == IB_LINK_LAYER_INFINIBAND &&
+	    MLX5_CAP_GEN(dev->mdev, ib_virt)) {
 		if (ibdev->type == RDMA_DEVICE_TYPE_SMI)
 			port_num = smi_to_native_portnum(dev, port_num);
 

---
base-commit: 915fb85a378e02f22c9bc3c9c9166582d276629e
change-id: 20261111-moshe-ib-virt-guard-ecedee769166

Best regards,
-- 
Edward Srouji <edwards@nvidia.com>

