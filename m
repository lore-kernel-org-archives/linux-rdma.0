Return-Path: <SRS0=wxv4=55=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AD44C2BA19
	for <linux-rdma@archiver.kernel.org>; Mon, 13 Apr 2020 13:20:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 37A9320767
	for <linux-rdma@archiver.kernel.org>; Mon, 13 Apr 2020 13:20:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1586784035;
	bh=/GZbqRW4SjoQ4c+JnY5scdBcad1oJzFGRbaS5priACA=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=p4eU0NHAbDnX4wXNM50SHXR3KfA+/4pWNsjXtdgoCXOo+WmPMgOYqCVb4NQ9bIKcA
	 W+qkHWn+LZnvrM9GSP8VcdN36Iqac/X2aR/gPKZz3uHjVhXrGGtGO9YHg+NhzkpyyL
	 /+oLWC6SPhN9TMwCrPY2VuWw7HIajoLsMCDfSFCk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729268AbgDMNUe (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 13 Apr 2020 09:20:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:59204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728135AbgDMNUe (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Mon, 13 Apr 2020 09:20:34 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 15C0020692;
        Mon, 13 Apr 2020 13:20:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586784033;
        bh=/GZbqRW4SjoQ4c+JnY5scdBcad1oJzFGRbaS5priACA=;
        h=From:To:Cc:Subject:Date:From;
        b=XuYjR+XU8QEyaoJB/TJpjJNJvej7TCyHmQYF5OB/QChjn1IxP6ik/SQDZoYeBHFb0
         2SYGvwNfHrf0Qk4LG1xshEYnZ2yQPSNB51oUPjGsCW0+ne32NHiTlL8DWU+934En45
         qEO5X83M2VT87cRvDhzke7q6Qbg2tbfKfNWyPCt8=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Aharon Landau <aharonl@mellanox.com>,
        Dasaratharaman Chandramouli 
        <dasaratharaman.chandramouli@intel.com>,
        Don Hiatt <don.hiatt@intel.com>, linux-rdma@vger.kernel.org,
        Maor Gottlieb <maorg@mellanox.com>,
        Niranjana Vishwanathapura <niranjana.vishwanathapura@intel.com>,
        Sean Hefty <sean.hefty@intel.com>
Subject: [PATCH rdma-rc] RDMA/mlx5: Set GRH fields in query QP on RoCE
Date:   Mon, 13 Apr 2020 16:20:28 +0300
Message-Id: <20200413132028.930109-1-leon@kernel.org>
X-Mailer: git-send-email 2.25.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Aharon Landau <aharonl@mellanox.com>

GRH fields such as sgid_index, hop limit and etc. are set in the
QP context when QP is created/modified.

Currently, when query QP is performed, we fill the GRH fields only
if the GRH bit is set in the QP context, but this bit is not set
for RoCE. Adjust the check so we will set all relevant data for
the RoCE too.

Fixes: d8966fcd4c25 ("IB/core: Use rdma_ah_attr accessor functions")
Signed-off-by: Aharon Landau <aharonl@mellanox.com>
Reviewed-by: Maor Gottlieb <maorg@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/qp.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 1456db4b6295..a4f8e7c7ed24 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -5558,13 +5558,13 @@ static void to_rdma_ah_attr(struct mlx5_ib_dev *ibdev,
 	rdma_ah_set_path_bits(ah_attr, path->grh_mlid & 0x7f);
 	rdma_ah_set_static_rate(ah_attr,
 				path->static_rate ? path->static_rate - 5 : 0);
-	if (path->grh_mlid & (1 << 7)) {
+
+	if (path->grh_mlid & (1 << 7) ||
+	    ah_attr->type == RDMA_AH_ATTR_TYPE_ROCE) {
 		u32 tc_fl = be32_to_cpu(path->tclass_flowlabel);
 
-		rdma_ah_set_grh(ah_attr, NULL,
-				tc_fl & 0xfffff,
-				path->mgid_index,
-				path->hop_limit,
+		rdma_ah_set_grh(ah_attr, NULL, tc_fl & 0xfffff,
+				path->mgid_index, path->hop_limit,
 				(tc_fl >> 20) & 0xff);
 		rdma_ah_set_dgid_raw(ah_attr, path->rgid);
 	}
-- 
2.25.2

