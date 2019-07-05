Return-Path: <SRS0=E/Z5=VC=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 307B7C4649E
	for <linux-rdma@archiver.kernel.org>; Fri,  5 Jul 2019 16:22:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EF38B21721
	for <linux-rdma@archiver.kernel.org>; Fri,  5 Jul 2019 16:22:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1562343734;
	bh=YCTH1m+YXQxysIthQnVXOPdUy504nE0Iej34IIZxUwI=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=NVNbFv0+48SQ7tgDyGMkpLDsNNTcwQ5w3E+vVP0bJSEY9nMemk8QnyayVfKDEK0Ux
	 DdtNlbrv1Bey9IHu3i/kAIbi+BzhGdZo1xFNCsUiT8i8LllpDh3aYUsRtVbOPNbEaW
	 WffGeHjjAyNCvcCSFx1yvEsX9T5K7/X+sBv1i0pw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727188AbfGEQWN (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Fri, 5 Jul 2019 12:22:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:48482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725788AbfGEQWN (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Fri, 5 Jul 2019 12:22:13 -0400
Received: from localhost (unknown [37.142.3.125])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 18FA4216E3;
        Fri,  5 Jul 2019 16:22:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562343732;
        bh=YCTH1m+YXQxysIthQnVXOPdUy504nE0Iej34IIZxUwI=;
        h=From:To:Cc:Subject:Date:From;
        b=zwq06Qsypx/PzfYdG4QflthZHxfviLf9vOdMx2yFcOYBP981zneJORUwFQXSGUdPW
         C63S1hKXGmByB4lQA1IWA+ppSLyRczjgSYjpPsdZItMTloEDBQPuDpMWH/SWpbi6Ue
         2zgBiEtmIs2Hg77rWWIlTuSWjFbore9Jev1hxPbI=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Danit Goldberg <danitg@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Artemy Kovalyov <artemyko@mellanox.com>,
        Yishai Hadas <yishaih@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>
Subject: [PATCH rdma-next] IB/mlx5: Report correctly tag matching rendezvous capability
Date:   Fri,  5 Jul 2019 19:21:57 +0300
Message-Id: <20190705162157.17336-1-leon@kernel.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Danit Goldberg <danitg@mellanox.com>

Tag matching with rendezvous offload for RC transport is controlled
by FW and before this change, it was advertised to user as supported
without any relation to FW.

Separate tag matching for rendezvous and eager protocols, so users
will see real capabilities.

Cc: <stable@vger.kernel.org> # 4.13
Fixes: eb761894351d ("IB/mlx5: Fill XRQ capabilities")
Signed-off-by: Danit Goldberg <danitg@mellanox.com>
Reviewed-by: Yishai Hadas <yishaih@mellanox.com>
Reviewed-by: Artemy Kovalyov <artemyko@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/main.c | 8 ++++++--
 include/rdma/ib_verbs.h           | 4 ++--
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 07a05b0b9e42..c2a5780cb394 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -1046,15 +1046,19 @@ static int mlx5_ib_query_device(struct ib_device *ibdev,
 	}
 
 	if (MLX5_CAP_GEN(mdev, tag_matching)) {
-		props->tm_caps.max_rndv_hdr_size = MLX5_TM_MAX_RNDV_MSG_SIZE;
 		props->tm_caps.max_num_tags =
 			(1 << MLX5_CAP_GEN(mdev, log_tag_matching_list_sz)) - 1;
-		props->tm_caps.flags = IB_TM_CAP_RC;
 		props->tm_caps.max_ops =
 			1 << MLX5_CAP_GEN(mdev, log_max_qp_sz);
 		props->tm_caps.max_sge = MLX5_TM_MAX_SGE;
 	}
 
+	if (MLX5_CAP_GEN(mdev, tag_matching) &&
+	    MLX5_CAP_GEN(mdev, rndv_offload_rc)) {
+		props->tm_caps.flags = IB_TM_CAP_RNDV_RC;
+		props->tm_caps.max_rndv_hdr_size = MLX5_TM_MAX_RNDV_MSG_SIZE;
+	}
+
 	if (MLX5_CAP_GEN(dev->mdev, cq_moderation)) {
 		props->cq_caps.max_cq_moderation_count =
 						MLX5_MAX_CQ_COUNT;
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 30eb68f36109..c5f8a9f17063 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -308,8 +308,8 @@ struct ib_rss_caps {
 };
 
 enum ib_tm_cap_flags {
-	/*  Support tag matching on RC transport */
-	IB_TM_CAP_RC		    = 1 << 0,
+	/*  Support tag matching with rendezvous offload for RC transport */
+	IB_TM_CAP_RNDV_RC = 1 << 0,
 };
 
 struct ib_tm_caps {
-- 
2.20.1

