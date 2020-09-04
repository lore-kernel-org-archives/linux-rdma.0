Return-Path: <SRS0=ARbL=CN=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAB3FC43461
	for <linux-rdma@archiver.kernel.org>; Fri,  4 Sep 2020 20:07:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7C6B7208C7
	for <linux-rdma@archiver.kernel.org>; Fri,  4 Sep 2020 20:07:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599250042;
	bh=tC93TGtaDQM93OQriniKSPv5JE92vdfZO7SvX6MPeNI=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=vWbCkrHCMqCNwL5h5vocLp0VYVUwAFgT5e5orPy7V9B502GWQsyVTb8s+Z6I7EGF3
	 WNeVeuvVl9zWmDMHZ3BJ/A0rvcnv6Qd3guWSj7csZz2gZj7cGSTE3deYa1931k1ZHT
	 5euSJjRExa5UeLVJkE8o6f+XdAvjCKvdBA0b6uFA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726948AbgIDUHV (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Fri, 4 Sep 2020 16:07:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:50738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726317AbgIDUHU (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Fri, 4 Sep 2020 16:07:20 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EC79720665;
        Fri,  4 Sep 2020 20:07:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599250040;
        bh=tC93TGtaDQM93OQriniKSPv5JE92vdfZO7SvX6MPeNI=;
        h=From:To:Cc:Subject:Date:From;
        b=rOjRaX/q/KjaZB5zeWyxfKGCvcdokq8XImwMNSVKSluJvT1JHcteAkvUlksI/T1xx
         jAJaIWFQeSCrhrp53PeV/Qk/NZzYiJT+Y54P3qe3rWpfQYzrZIX32PxB9hkKENMTL2
         1NeCmib94DBlDP3WttFNMyY8SL3qNllsjqMuyvDo=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kernel-team@fb.com, tariqt@mellanox.com,
        yishaih@mellanox.com, linux-rdma@vger.kernel.org, jiri@resnulli.us,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next] mlx4: make sure to always set the port type
Date:   Fri,  4 Sep 2020 13:06:21 -0700
Message-Id: <20200904200621.2407839-1-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

Even tho mlx4_core registers the devlink ports, it's mlx4_en
and mlx4_ib which set their type. In situations where one of
the two is not built yet the machine has ports of given type
we see the devlink warning from devlink_port_type_warn() trigger.

Having ports of a type not supported by the kernel may seem
surprising, but it does occur in practice - when the unsupported
port is not plugged in to a switch anyway users are more than happy
not to see it (and potentially allocate any resources to it).

Set the type in mlx4_core if type-specific driver is not built.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx4/main.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx4/main.c b/drivers/net/ethernet/mellanox/mlx4/main.c
index 258c7a96f269..70cf24ba71e4 100644
--- a/drivers/net/ethernet/mellanox/mlx4/main.c
+++ b/drivers/net/ethernet/mellanox/mlx4/main.c
@@ -3031,6 +3031,17 @@ static int mlx4_init_port_info(struct mlx4_dev *dev, int port)
 	if (err)
 		return err;
 
+	/* Ethernet and IB drivers will normally set the port type,
+	 * but if they are not built set the type now to prevent
+	 * devlink_port_type_warn() from firing.
+	 */
+	if (!IS_ENABLED(CONFIG_MLX4_EN) &&
+	    dev->caps.port_type[port] == MLX4_PORT_TYPE_ETH)
+		devlink_port_type_eth_set(&info->devlink_port, NULL);
+	else if (!IS_ENABLED(CONFIG_MLX4_INFINIBAND) &&
+		 dev->caps.port_type[port] == MLX4_PORT_TYPE_IB)
+		devlink_port_type_ib_set(&info->devlink_port, NULL);
+
 	info->dev = dev;
 	info->port = port;
 	if (!mlx4_is_slave(dev)) {
-- 
2.26.2

