Return-Path: <SRS0=Njt3=7F=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9A34C433E0
	for <linux-rdma@archiver.kernel.org>; Sat, 23 May 2020 13:23:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BF8422072C
	for <linux-rdma@archiver.kernel.org>; Sat, 23 May 2020 13:23:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1590240196;
	bh=vf9EEogZW22dAl00s6gxoiXE+NY6RK/Hk+djbeb+FdM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=eY/eiAtBad2wXSY3VZOf31NxW1kTe6BlMqDp58PPLpsc0m+gt//RZaNKg17nplQWm
	 5Yupd0FXH77G7lWCSbTpyOZMhBHRf/lZ6nDmvKp/5DnZgu61U9gQvLIveP7laVeFzg
	 vwjyXuZQDv3oVudY7670k/3yfqoeM37TMe5BNyXA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387863AbgEWNXQ (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Sat, 23 May 2020 09:23:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:56866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387763AbgEWNXQ (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Sat, 23 May 2020 09:23:16 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0408B20727;
        Sat, 23 May 2020 13:23:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590240195;
        bh=vf9EEogZW22dAl00s6gxoiXE+NY6RK/Hk+djbeb+FdM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PKSukDs4UcKz2ZNrJIBK//pi/wmDF6CSTOcf26g3FBolWGPk+Rr56nxUlSZH6em26
         HVOo6ZXxy38PJPEb3XOjQZbcwFzH7D4Vog6RfZHR9HwhP6Rn/YutKE8qW9V9fViNZe
         0wv6UzE4adbuyfKvkNN1ExMfsFBFY4Bcd1HhMpQk=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>, linux-rdma@vger.kernel.org
Subject: [PATCH rdma-next v1 7/9] RDMA/mlx5: Advertise ECE support
Date:   Sat, 23 May 2020 16:22:41 +0300
Message-Id: <20200523132243.817936-8-leon@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200523132243.817936-1-leon@kernel.org>
References: <20200523132243.817936-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

The ECE bits are configured through create_qp and modify_qp commands.
While the create_qp() can be easily extended, it is not an easy task
for the modify_qp().

The new bit in the comp_mask is needed to mark that kernel supports
ECE and can receive data instead of "reserved" field in the
struct mlx5_ib_modify_qp.

Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/main.c | 3 +++
 include/uapi/rdma/mlx5-abi.h      | 1 +
 2 files changed, 4 insertions(+)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 6094ab2f4cd7..570c519ca530 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -1971,6 +1971,9 @@ static int mlx5_ib_alloc_ucontext(struct ib_ucontext *uctx,
 		resp.response_length += sizeof(resp.dump_fill_mkey);
 	}
 
+	if (MLX5_CAP_GEN(dev->mdev, ece_support))
+		resp.comp_mask |= MLX5_IB_ALLOC_UCONTEXT_RESP_MASK_ECE;
+
 	err = ib_copy_to_udata(udata, &resp, resp.response_length);
 	if (err)
 		goto out_mdev;
diff --git a/include/uapi/rdma/mlx5-abi.h b/include/uapi/rdma/mlx5-abi.h
index bc9d9e3cb369..90ea1e5aa291 100644
--- a/include/uapi/rdma/mlx5-abi.h
+++ b/include/uapi/rdma/mlx5-abi.h
@@ -100,6 +100,7 @@ struct mlx5_ib_alloc_ucontext_req_v2 {
 enum mlx5_ib_alloc_ucontext_resp_mask {
 	MLX5_IB_ALLOC_UCONTEXT_RESP_MASK_CORE_CLOCK_OFFSET = 1UL << 0,
 	MLX5_IB_ALLOC_UCONTEXT_RESP_MASK_DUMP_FILL_MKEY    = 1UL << 1,
+	MLX5_IB_ALLOC_UCONTEXT_RESP_MASK_ECE               = 1UL << 2,
 };
 
 enum mlx5_user_cmds_supp_uhw {
-- 
2.26.2

