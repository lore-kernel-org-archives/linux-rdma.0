Return-Path: <SRS0=fphg=CI=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7EA4C2BB56
	for <linux-rdma@archiver.kernel.org>; Sun, 30 Aug 2020 08:40:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 86CE920720
	for <linux-rdma@archiver.kernel.org>; Sun, 30 Aug 2020 08:40:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1598776859;
	bh=/Ok6EOxBXX5c0FyexeUKSuc+06fEIwUImbMlHxP1/18=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=LWZREiMcuy1F/5wbTH+WwZxw/OfNSBGydhy8eG9vB1QG95zwLcqeYMs/ivwmq9fm3
	 Ia8jF7pqhwZeSxxKMhN1Z2nUbJO+quQMv2hGpkj/m6QlbRwif2EHrjCCWayQDP9Fk6
	 PMsmYR6DL0JKaEPXjsgWI4G6IEtmYBaCMkVb/w3A=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728645AbgH3Ik6 (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Sun, 30 Aug 2020 04:40:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:44852 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728653AbgH3Ikl (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Sun, 30 Aug 2020 04:40:41 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2C4962145D;
        Sun, 30 Aug 2020 08:40:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598776840;
        bh=/Ok6EOxBXX5c0FyexeUKSuc+06fEIwUImbMlHxP1/18=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J3CIpVQim5ByBXbwyEUwXipj4emVlwvDbgUwXPchO1j1L5l20xtrCwKesEnTmMiux
         co7dz3z44s2gTC2TxpNl1AEbP4fmFBMdgDuoBXvMcX9n3L8hxi5OaQcqTWwTwOFPAn
         9Tnph8jIciHguUxVy0oDhSPBvvzYll70MoAKetJU=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        Eli Cohen <eli@mellanox.com>,
        Jack Morgenstein <jackm@dev.mellanox.co.il>,
        linux-rdma@vger.kernel.org, Or Gerlitz <ogerlitz@mellanox.com>,
        Roland Dreier <roland@purestorage.com>
Subject: [PATCH rdma-next v1 04/10] RDMA/mlx5: Fix potential race between destroy and CQE poll
Date:   Sun, 30 Aug 2020 11:40:04 +0300
Message-Id: <20200830084010.102381-5-leon@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200830084010.102381-1-leon@kernel.org>
References: <20200830084010.102381-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

The SRQ can be destroyed right before mlx5_cmd_get_srq is called.
In such case the latter will return NULL instead of expected SRQ.

Fixes: e126ba97dba9 ("mlx5: Add driver for Mellanox Connect-IB adapters")
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/cq.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/cq.c b/drivers/infiniband/hw/mlx5/cq.c
index 34c2cd57d994..2bac246b9fef 100644
--- a/drivers/infiniband/hw/mlx5/cq.c
+++ b/drivers/infiniband/hw/mlx5/cq.c
@@ -168,7 +168,7 @@ static void handle_responder(struct ib_wc *wc, struct mlx5_cqe64 *cqe,
 {
 	enum rdma_link_layer ll = rdma_port_get_link_layer(qp->ibqp.device, 1);
 	struct mlx5_ib_dev *dev = to_mdev(qp->ibqp.device);
-	struct mlx5_ib_srq *srq;
+	struct mlx5_ib_srq *srq = NULL;
 	struct mlx5_ib_wq *wq;
 	u16 wqe_ctr;
 	u8  roce_packet_type;
@@ -180,7 +180,8 @@ static void handle_responder(struct ib_wc *wc, struct mlx5_cqe64 *cqe,
 
 		if (qp->ibqp.xrcd) {
 			msrq = mlx5_cmd_get_srq(dev, be32_to_cpu(cqe->srqn));
-			srq = to_mibsrq(msrq);
+			if (msrq)
+				srq = to_mibsrq(msrq);
 		} else {
 			srq = to_msrq(qp->ibqp.srq);
 		}
-- 
2.26.2

