Return-Path: <SRS0=Cmar=EB=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62C83C4363A
	for <linux-rdma@archiver.kernel.org>; Mon, 26 Oct 2020 13:37:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1141A21BE5
	for <linux-rdma@archiver.kernel.org>; Mon, 26 Oct 2020 13:37:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1603719479;
	bh=t5TU/1vxkveC2aImL7QPjnZoDBMmNSTzRfYvX8f3vNA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=tUi5fLmzoOSEWgO1IsOgNs3OP9z0akiDTyqEhwW+G0xmQLFpKKSWE/1DD2VUpKsr+
	 Po4CAmYyqwuTyNCr271GMhqh42XmJ0gR64OBRH3IlYXkOkWCxAtVKlPQjXsewPsOrz
	 +rq+tAc2UaYw7st8VrC06EyNgU/pV8WXqrcTzRkQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1775726AbgJZNhy (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 26 Oct 2020 09:37:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:39080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1775618AbgJZNhx (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Mon, 26 Oct 2020 09:37:53 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0E2DA21BE5;
        Mon, 26 Oct 2020 13:37:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603719472;
        bh=t5TU/1vxkveC2aImL7QPjnZoDBMmNSTzRfYvX8f3vNA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AM/cD8GMSlfOGDcox378TIQt8sfHFquilP651dN8nQpD1wpkd4/sUkhTDDRZBBteC
         Y51LG6Ux75Ovs0ixV0dkajXBB9uwpAKPbp1uwI0gBY5Ol/bNDegmWbJnHwhRvvGvA3
         v0rwmnxHUQzxhkz6tmyzo0uXBqPrXXEKkldKSEyg=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Meir Lichtinger <meirl@mellanox.com>, linux-rdma@vger.kernel.org
Subject: [PATCH rdma-next 2/2] IB/mlx5: Add support for NDR link speed
Date:   Mon, 26 Oct 2020 15:37:38 +0200
Message-Id: <20201026133738.1340432-3-leon@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201026133738.1340432-1-leon@kernel.org>
References: <20201026133738.1340432-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Meir Lichtinger <meirl@mellanox.com>

The IBTA specification has new speed - NDR. That speed supports signaling
rate of 100Gb. mlx5 IB driver translates link modes reported by ConnectX
device to IB speed and width. Added translation of new 100Gb, 200Gb and
400Gb link modes to NDR IB type and width of x1, x2 or x4 respectively.

Signed-off-by: Meir Lichtinger <meirl@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/infiniband/hw/mlx5/main.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index bcee10c9d9a8..2dbd879bf841 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -419,10 +419,22 @@ static int translate_eth_ext_proto_oper(u32 eth_proto_oper, u16 *active_speed,
 		*active_width = IB_WIDTH_2X;
 		*active_speed = IB_SPEED_HDR;
 		break;
+	case MLX5E_PROT_MASK(MLX5E_100GAUI_1_100GBASE_CR_KR):
+		*active_width = IB_WIDTH_1X;
+		*active_speed = IB_SPEED_NDR;
+		break;
 	case MLX5E_PROT_MASK(MLX5E_200GAUI_4_200GBASE_CR4_KR4):
 		*active_width = IB_WIDTH_4X;
 		*active_speed = IB_SPEED_HDR;
 		break;
+	case MLX5E_PROT_MASK(MLX5E_200GAUI_2_200GBASE_CR2_KR2):
+		*active_width = IB_WIDTH_2X;
+		*active_speed = IB_SPEED_NDR;
+		break;
+	case MLX5E_PROT_MASK(MLX5E_400GAUI_4_400GBASE_CR4_KR4):
+		*active_width = IB_WIDTH_4X;
+		*active_speed = IB_SPEED_NDR;
+		break;
 	default:
 		return -EINVAL;
 	}
-- 
2.26.2

