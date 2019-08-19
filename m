Return-Path: <SRS0=Wuup=WP=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AC2BC3A59D
	for <linux-rdma@archiver.kernel.org>; Mon, 19 Aug 2019 12:08:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 06B9820851
	for <linux-rdma@archiver.kernel.org>; Mon, 19 Aug 2019 12:08:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1566216506;
	bh=lXZsojdv4RlfhyVDjM7oCq2p4qIXcHkpMuGjOCJen/U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=Yp2CU1Be2pMd8TrT2Pyz2917rqyRYPm1yMJIZEV4/5ZQ81yX09ZdJujRlNjmBPCVZ
	 GoEeNPC3SjFGkP4HQRARyeNuNspn8+EFGfp/zO+JGxZdnQs+AgI9d1tQOY7IEfiJ82
	 ZWNdqQN59RDTgLOUTRHDSOEsceq5Yfvlfeispj6E=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727084AbfHSMIZ (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 19 Aug 2019 08:08:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:47116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726987AbfHSMIZ (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Mon, 19 Aug 2019 08:08:25 -0400
Received: from localhost (unknown [77.137.115.125])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9BA9B2085A;
        Mon, 19 Aug 2019 12:08:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566216504;
        bh=lXZsojdv4RlfhyVDjM7oCq2p4qIXcHkpMuGjOCJen/U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j5F+ujeQ5WhG4ymaKNw5vpJ9WP+Saf8Bwy/UHe775j83fxf20hKI7FmRjM806P/uQ
         F4YsY2DGDEYxeO+W3vMjIiaVB27xo/ISw4AjmTKq9kPMVoAl4u9mo9zcPQKlLCaVE2
         OlSeapTWeSRlWrU5URFdbd9KCPEZjcPhASeyMUDg=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Michael Guralnik <michaelgur@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: [PATCH mlx5-next v3 1/3] net/mlx5: Set ODP capabilities for DC transport to max
Date:   Mon, 19 Aug 2019 15:08:13 +0300
Message-Id: <20190819120815.21225-2-leon@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190819120815.21225-1-leon@kernel.org>
References: <20190819120815.21225-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Michael Guralnik <michaelgur@mellanox.com>

In mlx5_core initialization, query max ODP capabilities for DC transport
from FW and set as current capabilities.

Signed-off-by: Michael Guralnik <michaelgur@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/main.c | 6 ++++++
 include/linux/mlx5/mlx5_ifc.h                  | 4 +++-
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index fa0e991f1983..7f70ecb1db6d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -495,6 +495,12 @@ static int handle_hca_cap_odp(struct mlx5_core_dev *dev)
 	ODP_CAP_SET_MAX(dev, xrc_odp_caps.write);
 	ODP_CAP_SET_MAX(dev, xrc_odp_caps.read);
 	ODP_CAP_SET_MAX(dev, xrc_odp_caps.atomic);
+	ODP_CAP_SET_MAX(dev, dc_odp_caps.srq_receive);
+	ODP_CAP_SET_MAX(dev, dc_odp_caps.send);
+	ODP_CAP_SET_MAX(dev, dc_odp_caps.receive);
+	ODP_CAP_SET_MAX(dev, dc_odp_caps.write);
+	ODP_CAP_SET_MAX(dev, dc_odp_caps.read);
+	ODP_CAP_SET_MAX(dev, dc_odp_caps.atomic);
 
 	if (do_set)
 		err = set_caps(dev, set_ctx, set_sz,
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index ab6ae723aae6..f037f8d5970e 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -946,7 +946,9 @@ struct mlx5_ifc_odp_cap_bits {
 
 	struct mlx5_ifc_odp_per_transport_service_cap_bits xrc_odp_caps;
 
-	u8         reserved_at_100[0x700];
+	struct mlx5_ifc_odp_per_transport_service_cap_bits dc_odp_caps;
+
+	u8         reserved_at_120[0x6E0];
 };
 
 struct mlx5_ifc_calc_op {
-- 
2.20.1

