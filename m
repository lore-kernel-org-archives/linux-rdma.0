Return-Path: <SRS0=BWFQ=2C=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 809B5C2D0C8
	for <linux-rdma@archiver.kernel.org>; Thu, 12 Dec 2019 09:12:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 571882465B
	for <linux-rdma@archiver.kernel.org>; Thu, 12 Dec 2019 09:12:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1576141950;
	bh=KAOU8UALTv0liYW62+FKsszLXqpqfDTGypfeC6CD/iA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=U7NAMZfV/r2YCyxNaiPvDYifkv1eKZhBXyBisy3aqgpLKGnUYCnfeJfX54RPuHcMx
	 wcoArrmCvZUez817Yh5BqyuvU3WXBYk8o2znsha2XzpyrRHYPtLSh5a9Rz+O8ZUJ80
	 NJVMGwA1BINiTAHrh43lkbTcWFGQDb7vJASLnSU0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728303AbfLLJM3 (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 12 Dec 2019 04:12:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:49128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728147AbfLLJM3 (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Thu, 12 Dec 2019 04:12:29 -0500
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F10D524671;
        Thu, 12 Dec 2019 09:12:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576141948;
        bh=KAOU8UALTv0liYW62+FKsszLXqpqfDTGypfeC6CD/iA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uI5NQ1alcFfJpKTaz00z7CkB4GJZy6OQiWuSBIeSjxobKvSi9VEHcnB69X16EGEtb
         ZjyrtP8JuHhPOXnvFOdlntewX5y6OPd/aaTkuO066Tfiy57+TtqzrzsedtBmbUynL+
         5UbMx0LxZAY9Kyv3XMyIVa7SCrIWLczfLHmnJKBU=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Eli Cohen <eli@mellanox.co.il>, Ido Kalir <idok@mellanox.com>,
        Maor Gottlieb <maorg@mellanox.com>,
        Mark Zhang <markz@mellanox.com>,
        Parav Pandit <parav@mellanox.com>,
        Raed Salem <raeds@mellanox.com>
Subject: [PATCH rdma-rc 3/3] IB/mlx5: Fix steering rule of drop and count
Date:   Thu, 12 Dec 2019 11:12:14 +0200
Message-Id: <20191212091214.315005-4-leon@kernel.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191212091214.315005-1-leon@kernel.org>
References: <20191212091214.315005-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Maor Gottlieb <maorg@mellanox.com>

There are two flow rule destinations: QP and packet. While users are
setting DROP packet rule, the QP should not be set as a destination.

Fixes: 3b3233fbf02e ("IB/mlx5: Add flow counters binding support")
Signed-off-by: Maor Gottlieb <maorg@mellanox.com>
Reviewed-by: Raed Salem <raeds@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/main.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 51100350b688..2f5a159cbe1c 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -3544,10 +3544,6 @@ static struct mlx5_ib_flow_handler *_create_flow_rule(struct mlx5_ib_dev *dev,
 	}
 
 	INIT_LIST_HEAD(&handler->list);
-	if (dst) {
-		memcpy(&dest_arr[0], dst, sizeof(*dst));
-		dest_num++;
-	}
 
 	for (spec_index = 0; spec_index < flow_attr->num_of_specs; spec_index++) {
 		err = parse_flow_attr(dev->mdev, spec,
@@ -3560,6 +3556,11 @@ static struct mlx5_ib_flow_handler *_create_flow_rule(struct mlx5_ib_dev *dev,
 		ib_flow += ((union ib_flow_spec *)ib_flow)->size;
 	}
 
+	if (dst && !(flow_act.action & MLX5_FLOW_CONTEXT_ACTION_DROP)) {
+		memcpy(&dest_arr[0], dst, sizeof(*dst));
+		dest_num++;
+	}
+
 	if (!flow_is_multicast_only(flow_attr))
 		set_underlay_qp(dev, spec, underlay_qpn);
 
@@ -3600,10 +3601,8 @@ static struct mlx5_ib_flow_handler *_create_flow_rule(struct mlx5_ib_dev *dev,
 	}
 
 	if (flow_act.action & MLX5_FLOW_CONTEXT_ACTION_DROP) {
-		if (!(flow_act.action & MLX5_FLOW_CONTEXT_ACTION_COUNT)) {
+		if (!dest_num)
 			rule_dst = NULL;
-			dest_num = 0;
-		}
 	} else {
 		if (is_egress)
 			flow_act.action |= MLX5_FLOW_CONTEXT_ACTION_ALLOW;
-- 
2.20.1

