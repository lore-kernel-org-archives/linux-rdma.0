Return-Path: <SRS0=lM3/=BN=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58E87C433E1
	for <linux-rdma@archiver.kernel.org>; Mon,  3 Aug 2020 05:58:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2D6EA206F6
	for <linux-rdma@archiver.kernel.org>; Mon,  3 Aug 2020 05:58:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596434335;
	bh=62DyfZVI/tE2AV8v/cnpysnfgi7K425vJAZCp31eFII=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=Gpxxc0tiyIYB14dmqOkrhy9vT6mAyMj9Yqz9g2/0dcvAHCKUWb8+4o2IHxD1agmBf
	 JmjKUsNYNNjwIXVu9XOUWqaxat1Noi7ZXNj8N+LYi5F9EJ/EWQRbIpKdsm0WCYs5+r
	 D2k+EFZpNzU27Bh0VUKBzLg//esjhE9uZBO353BI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727773AbgHCF6z (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 3 Aug 2020 01:58:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:52230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726986AbgHCF6z (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Mon, 3 Aug 2020 01:58:55 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 755A220678;
        Mon,  3 Aug 2020 05:58:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596434334;
        bh=62DyfZVI/tE2AV8v/cnpysnfgi7K425vJAZCp31eFII=;
        h=From:To:Cc:Subject:Date:From;
        b=sHlaPWfYDF604Tz4b/5IwQaEaglz4rURQXpVndg653UAPAbuRasY5Laeg8AR+txmG
         xPmGYap2whNjwUzZRTskXJ0wvvLM+eWtThjB+5165nVDeLCZk2Y4TnH0AxjNZ1CpVl
         ug3CEtADHOHYg3N5eu+/O8ertG6RlAzZQbUKKYgQ=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Michael Guralnik <michaelgur@mellanox.com>,
        linux-rdma@vger.kernel.org, Maor Gottlieb <maorg@mellanox.com>,
        Mark Bloch <markb@mellanox.com>
Subject: [PATCH rdma-rc] RDMA/mlx5: Fix flow destination setting for RDMA TX flow table
Date:   Mon,  3 Aug 2020 08:58:49 +0300
Message-Id: <20200803055849.14947-1-leon@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Michael Guralnik <michaelgur@mellanox.com>

For RDMA TX flow table, set destination type to be 'port' and prevent
creation of flows with TIR destination.

As RDMA TX is an egress flow table the rules on this flow table should
not forward traffic back to the NIC and should set the destination to be
the port.

Without the setting of this destination type flow rules on the RDMA TX
flow tables are not created as FW invokes a syndrome for undefined
destination for the rule.

Fixes: 24670b1a3166 ("net/mlx5: Add support for RDMA TX steering")
Signed-off-by: Michael Guralnik <michaelgur@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/fs.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/fs.c b/drivers/infiniband/hw/mlx5/fs.c
index fbbb1adac273..d75f461eba50 100644
--- a/drivers/infiniband/hw/mlx5/fs.c
+++ b/drivers/infiniband/hw/mlx5/fs.c
@@ -1866,12 +1866,14 @@ static int get_dests(struct uverbs_attr_bundle *attrs,
 		else
 			*dest_id = mqp->raw_packet_qp.rq.tirn;
 		*dest_type = MLX5_FLOW_DESTINATION_TYPE_TIR;
-	} else if (fs_matcher->ns_type == MLX5_FLOW_NAMESPACE_EGRESS) {
+	} else if (fs_matcher->ns_type == MLX5_FLOW_NAMESPACE_EGRESS ||
+		   fs_matcher->ns_type == MLX5_FLOW_NAMESPACE_RDMA_TX) {
 		*dest_type = MLX5_FLOW_DESTINATION_TYPE_PORT;
 	}

 	if (*dest_type == MLX5_FLOW_DESTINATION_TYPE_TIR &&
-	    fs_matcher->ns_type == MLX5_FLOW_NAMESPACE_EGRESS)
+	    (fs_matcher->ns_type == MLX5_FLOW_NAMESPACE_EGRESS ||
+	     fs_matcher->ns_type == MLX5_FLOW_NAMESPACE_RDMA_TX))
 		return -EINVAL;

 	return 0;
--
2.26.2

