Return-Path: <SRS0=HFDa=6S=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07990C3A5A9
	for <linux-rdma@archiver.kernel.org>; Mon,  4 May 2020 05:30:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D17AE20735
	for <linux-rdma@archiver.kernel.org>; Mon,  4 May 2020 05:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1588570220;
	bh=RYnjuqBCpZUV812Kq6/ADNF0lBPZCRIxPis0i8Olqgs=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=w0ElWrXYb2aI7/U4LQGOtP5OD+UJbc+HhLkqJQX4TIFzMNl5naLt2flR2aLfIjSQk
	 EJWSs4dOa392z3gIKn/cxb8mtxdW66qAH7bQerzV3H/JjPY6WA+efmOxCMUyvemsoW
	 8T8ITlTQz7EU42lJYH5Q9EzUMBWLqo7Qb+N0pcz4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726411AbgEDFaU (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 4 May 2020 01:30:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:36714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725859AbgEDFaT (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Mon, 4 May 2020 01:30:19 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B892520643;
        Mon,  4 May 2020 05:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588570219;
        bh=RYnjuqBCpZUV812Kq6/ADNF0lBPZCRIxPis0i8Olqgs=;
        h=From:To:Cc:Subject:Date:From;
        b=nycO2+deY1LO/TY/Ba+9GZbXcyEJfsznLyx1GKSgCuFetVJ1JH3a5gn/hleSrf2xM
         O6mOPn5Zmiv7DLFBYuL81c3MYR5fUw2Z3IOFRFoi6Dl/NLTv3lqTVBOY+9BlP9vn2o
         mk6rUGJJW+SdGhv3PLSoQIGDKYIza9r+FuGRAa2o=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>, linux-rdma@vger.kernel.org,
        Maor Gottlieb <maorg@mellanox.com>,
        Mark Bloch <markb@mellanox.com>,
        Mark Zhang <markz@mellanox.com>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH rdma-next v1 0/4] Add steering support for default miss
Date:   Mon,  4 May 2020 08:30:08 +0300
Message-Id: <20200504053012.270689-1-leon@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

Changelog
v1:
 * Rebased on latest rdma-next
 * Removed attr_is_valid() check from flags
v0: https://lore.kernel.org/linux-rdma/20200413135220.934007-1-leon@kernel.org

-------------------------------------------------------------------------
Hi,

This code from Naor refactors the fs_core and adds steering support
for default miss functionality.

Thanks

Maor Gottlieb (4):
  {IB/net}/mlx5: Simplify don't trap code
  net/mlx5: Add support in forward to namespace
  RDMA/mlx5: Refactor DV create flow
  RDMA/mlx5: Add support in steering default miss

 drivers/infiniband/hw/mlx5/flow.c             | 136 +++++++++++-------
 drivers/infiniband/hw/mlx5/main.c             |  55 ++-----
 .../net/ethernet/mellanox/mlx5/core/fs_core.c | 123 +++++++++++-----
 .../net/ethernet/mellanox/mlx5/core/fs_core.h |   2 +
 include/linux/mlx5/fs.h                       |   1 +
 include/uapi/rdma/mlx5_user_ioctl_cmds.h      |   5 +
 6 files changed, 192 insertions(+), 130 deletions(-)

--
2.26.2

