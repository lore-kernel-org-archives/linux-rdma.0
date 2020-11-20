Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47D66C64E90
	for <linux-rdma@archiver.kernel.org>; Fri, 20 Nov 2020 23:04:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 16D442240B
	for <linux-rdma@archiver.kernel.org>; Fri, 20 Nov 2020 23:04:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=nvidia.com header.i=@nvidia.com header.b="HG9v5ukD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728623AbgKTXEL (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Fri, 20 Nov 2020 18:04:11 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:1184 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728054AbgKTXEK (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Fri, 20 Nov 2020 18:04:10 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fb84b5f0000>; Fri, 20 Nov 2020 15:03:59 -0800
Received: from sx1.mtl.com (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 20 Nov
 2020 23:03:59 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leonro@mellanox.com>
CC:     <netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        Meir Lichtinger <meirl@nvidia.com>,
        Eran Ben Elisha <eranbe@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH mlx5-next 07/16] net/mlx5: Update the list of the PCI supported devices
Date:   Fri, 20 Nov 2020 15:03:30 -0800
Message-ID: <20201120230339.651609-8-saeedm@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201120230339.651609-1-saeedm@nvidia.com>
References: <20201120230339.651609-1-saeedm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1605913439; bh=jk2egcnsKlHDEDPsFQbMR+WG+6rVRdRXUH9kjvqYhN0=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=HG9v5ukDE+5IOUw53KZOLOsBIP7fa3RXfISPzvHtDK+zPdvtVXT3tMsvzK5uXUrIc
         6e42cOeL1NjphIaOq66U6ph4fOc34DqT3ZJ9NN1lr9KmoLRh8SGIfq3Xp6APVWPyWf
         YB8l4zV0gE1RWzhz31J7RSTliPxspiu3fy7l2NW7SbWZJ1HchHu7AaUM7TTTuz47WX
         Vdrqr0NfPQi8t6AbFHmb2dIO0aaVqCP+aNjJDzS5rQ+ATFhz2kfVnkYAFF7sUv2TfE
         5lboXEulnjPYQM0UMZ6EbBrU13h1ysvVN8ITQBao+//bojGQ98MQpPtMJkT7OV48WQ
         M7RIpGsBggi8w==
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Meir Lichtinger <meirl@nvidia.com>

Add the upcoming BlueField-3 device ID.

Signed-off-by: Meir Lichtinger <meirl@nvidia.com>
Reviewed-by: Eran Ben Elisha <eranbe@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/e=
thernet/mellanox/mlx5/core/main.c
index 8ff207aa1479..a9757ccb9d16 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1594,6 +1594,7 @@ static const struct pci_device_id mlx5_core_pci_table=
[] =3D {
 	{ PCI_VDEVICE(MELLANOX, 0xa2d2) },			/* BlueField integrated ConnectX-5 n=
etwork controller */
 	{ PCI_VDEVICE(MELLANOX, 0xa2d3), MLX5_PCI_DEV_IS_VF},	/* BlueField integr=
ated ConnectX-5 network controller VF */
 	{ PCI_VDEVICE(MELLANOX, 0xa2d6) },			/* BlueField-2 integrated ConnectX-6=
 Dx network controller */
+	{ PCI_VDEVICE(MELLANOX, 0xa2dc) },			/* BlueField-3 integrated ConnectX-7=
 network controller */
 	{ 0, }
 };
=20
--=20
2.26.2

