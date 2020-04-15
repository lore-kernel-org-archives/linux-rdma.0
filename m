Return-Path: <SRS0=HR9Y=57=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08E54C2BB55
	for <linux-rdma@archiver.kernel.org>; Wed, 15 Apr 2020 12:31:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DBD622074F
	for <linux-rdma@archiver.kernel.org>; Wed, 15 Apr 2020 12:31:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1586953867;
	bh=7XeeStrCK5kGavojARUQVC9UvgsLzqP+H2GH7ek/uyM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=1Rf6dy5TNJcUU88QCbVxg1khtqe6ezBJMiMK5fEGYR9wu+S28rX0h0O3VtMUlEBWE
	 nga/t1M1d5J1keHA/oSiCaNrpaCI6rSe6+RQO/hLMmGIweUhPsIuaayQZ1BwySbiqi
	 GbR+ZKs8HBIyhCY7HkI7/3FqAmbpMSg0bA1jBezo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S369500AbgDOMal (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 15 Apr 2020 08:30:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:37802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2409104AbgDOLou (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Wed, 15 Apr 2020 07:44:50 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A1A9820737;
        Wed, 15 Apr 2020 11:44:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586951087;
        bh=7XeeStrCK5kGavojARUQVC9UvgsLzqP+H2GH7ek/uyM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qlfe7J/NcvT4OzRyBOy1dJejv1E1XiP8///BmeDwf7MtTIJt8mmhOxaMLgaZjhRXJ
         2yG8Kwp/F/+Xs5PD6Sorx9SGdDnrVOfujDrAvQTm/hjYOJ24LJ26tSFQ25VCemzfym
         FSemuJ2Apr/cdLrQkj+IC5KgVH5svv4qqqG6ECk4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Aya Levin <ayal@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 04/84] net/mlx5e: Enforce setting of a single FEC mode
Date:   Wed, 15 Apr 2020 07:43:21 -0400
Message-Id: <20200415114442.14166-4-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200415114442.14166-1-sashal@kernel.org>
References: <20200415114442.14166-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Aya Levin <ayal@mellanox.com>

[ Upstream commit 4bd9d5070b92da012f2715cf8e4859acb78b8f35 ]

Ethtool command allow setting of several FEC modes in a single set
command. The driver can only set a single FEC mode at a time. With this
patch driver will reply not-supported on setting several FEC modes.

Signed-off-by: Aya Levin <ayal@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
index c6776f308d5e6..ce63f9bd10fa8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -1554,6 +1554,10 @@ static int mlx5e_set_fecparam(struct net_device *netdev,
 	int mode;
 	int err;
 
+	if (bitmap_weight((unsigned long *)&fecparam->fec,
+			  ETHTOOL_FEC_BASER_BIT + 1) > 1)
+		return -EOPNOTSUPP;
+
 	for (mode = 0; mode < ARRAY_SIZE(pplm_fec_2_ethtool); mode++) {
 		if (!(pplm_fec_2_ethtool[mode] & fecparam->fec))
 			continue;
-- 
2.20.1

