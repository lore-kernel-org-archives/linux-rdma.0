Return-Path: <SRS0=EqZ5=VM=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F135FC7618F
	for <linux-rdma@archiver.kernel.org>; Mon, 15 Jul 2019 15:08:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C8EE52054F
	for <linux-rdma@archiver.kernel.org>; Mon, 15 Jul 2019 15:08:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1563203335;
	bh=VZ5dWzfU6DSYKWxr1/oUs1EfkFOuTXkKsTHfV3kSy6k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=WsK80KwyuZV2ASbSQQ+BSjHKfNOye2+5eCFAJIl286rr2HqdkxGYP8Gi4eeLKtqc8
	 WGMmx/anAsQC2wOi9jDkiutQsuPSGdn1iVq4UFq6czpuq8kqYABRweA9VX7bhciavO
	 jbQhDtCPudHy9AeGwlt7NxSc5niK4UZPd8DBZ7jg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732666AbfGON54 (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 15 Jul 2019 09:57:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:36680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731845AbfGON5y (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Mon, 15 Jul 2019 09:57:54 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E709621537;
        Mon, 15 Jul 2019 13:57:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563199073;
        bh=VZ5dWzfU6DSYKWxr1/oUs1EfkFOuTXkKsTHfV3kSy6k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bByhmE0Oobrh4dDymk3I6KpP/uK4sJ1CwolFfwxqBomof7zKDZNTK+kESYWua7yqD
         mW2LWm0dgtkNpoyU70d41GtXudZ1beleMAHTkJhIR38tS7TPBqWVw3ibbnL9GFvxT7
         MkeaBXToZidQ977/Cgv2ulb3aN+Ai/omQ4+mh5/A=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jianbo Liu <jianbol@mellanox.com>, Oz Shlomo <ozsh@mellanox.com>,
        Eli Britstein <elibr@mellanox.com>,
        Roi Dayan <roid@mellanox.com>, Mark Bloch <markb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 181/249] net/mlx5: Get vport ACL namespace by vport index
Date:   Mon, 15 Jul 2019 09:45:46 -0400
Message-Id: <20190715134655.4076-181-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715134655.4076-1-sashal@kernel.org>
References: <20190715134655.4076-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Jianbo Liu <jianbol@mellanox.com>

[ Upstream commit f53297d67800feb5fafd94abd926c889aefee690 ]

The ingress and egress ACL root namespaces are created per vport and
stored into arrays. However, the vport number is not the same as the
index. Passing the array index, instead of vport number, to get the
correct ingress and egress acl namespace.

Fixes: 9b93ab981e3b ("net/mlx5: Separate ingress/egress namespaces for each vport")
Signed-off-by: Jianbo Liu <jianbol@mellanox.com>
Reviewed-by: Oz Shlomo <ozsh@mellanox.com>
Reviewed-by: Eli Britstein <elibr@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Reviewed-by: Mark Bloch <markb@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index 6a921e24cd5e..acab26b88261 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -939,7 +939,7 @@ int esw_vport_enable_egress_acl(struct mlx5_eswitch *esw,
 		  vport->vport, MLX5_CAP_ESW_EGRESS_ACL(dev, log_max_ft_size));
 
 	root_ns = mlx5_get_flow_vport_acl_namespace(dev, MLX5_FLOW_NAMESPACE_ESW_EGRESS,
-						    vport->vport);
+			mlx5_eswitch_vport_num_to_index(esw, vport->vport));
 	if (!root_ns) {
 		esw_warn(dev, "Failed to get E-Switch egress flow namespace for vport (%d)\n", vport->vport);
 		return -EOPNOTSUPP;
@@ -1057,7 +1057,7 @@ int esw_vport_enable_ingress_acl(struct mlx5_eswitch *esw,
 		  vport->vport, MLX5_CAP_ESW_INGRESS_ACL(dev, log_max_ft_size));
 
 	root_ns = mlx5_get_flow_vport_acl_namespace(dev, MLX5_FLOW_NAMESPACE_ESW_INGRESS,
-						    vport->vport);
+			mlx5_eswitch_vport_num_to_index(esw, vport->vport));
 	if (!root_ns) {
 		esw_warn(dev, "Failed to get E-Switch ingress flow namespace for vport (%d)\n", vport->vport);
 		return -EOPNOTSUPP;
-- 
2.20.1

