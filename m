Return-Path: <SRS0=q+lP=53=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C6BBC2BB86
	for <linux-rdma@archiver.kernel.org>; Sat, 11 Apr 2020 23:31:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4C4692051A
	for <linux-rdma@archiver.kernel.org>; Sat, 11 Apr 2020 23:31:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1586647908;
	bh=m348qOhnTJm9aP0rL0NRNSQn6HW9mV5fzC4rOHsQH/U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=1fy/Q0u4IKAeQNkZQgvjPFXGgRuJarVZmzEoCUyr5FvP58JXPe9Ahck90MDSI/Ve5
	 I82SXuTsXeos4VBiE5WQ25ZAZ7noxfo93npUAGTjYBSCwx1spW+IR7pF9YK8QPBl5Y
	 uAqdNKe5KZ6wwPlyu05IEQrd7jIqR6xygNV2mh5A=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728496AbgDKXbm (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Sat, 11 Apr 2020 19:31:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:48390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728961AbgDKXKO (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Sat, 11 Apr 2020 19:10:14 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B40C42173E;
        Sat, 11 Apr 2020 23:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586646614;
        bh=m348qOhnTJm9aP0rL0NRNSQn6HW9mV5fzC4rOHsQH/U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tn1zsgXZJiVcdaHiok4YJ1HQdTlrVq0Lm0IWrzvUoTx8AC8GlFc/6D2nz03Ib6Eax
         OF9h2L+Di32pHouE0q7gUkYFNn/wcJEF7trI0uE0ehhD1/LQ42pGs+wXCVsOn9UL61
         wARuKl7nyjmH7ARA5Pud44RMUeS0LYctMLSXdmbc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vlad Buslov <vladbu@mellanox.com>, Roi Dayan <roid@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 025/108] net/mlx5e: Init ethtool steering for representors
Date:   Sat, 11 Apr 2020 19:08:20 -0400
Message-Id: <20200411230943.24951-25-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200411230943.24951-1-sashal@kernel.org>
References: <20200411230943.24951-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Vlad Buslov <vladbu@mellanox.com>

[ Upstream commit 6783e8b29f636383af293a55336f036bc7ad5619 ]

During transition to uplink representors the code responsible for
initializing ethtool steering functionality wasn't added to representor
init rx routine. This causes NULL pointer dereference during configuration
of network flow classification rule with ethtool (only possible to
reproduce with next commit in this series which registers necessary ethtool
callbacks).

Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index cd9bb7c7b3413..397b70fb23e23 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -1590,6 +1590,8 @@ static int mlx5e_init_rep_rx(struct mlx5e_priv *priv)
 	if (err)
 		goto err_destroy_ttc_table;
 
+	mlx5e_ethtool_init_steering(priv);
+
 	return 0;
 
 err_destroy_ttc_table:
-- 
2.20.1

