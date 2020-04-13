Return-Path: <SRS0=wxv4=55=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76773C2BA19
	for <linux-rdma@archiver.kernel.org>; Mon, 13 Apr 2020 13:52:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 53C1420767
	for <linux-rdma@archiver.kernel.org>; Mon, 13 Apr 2020 13:52:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1586785948;
	bh=nhmVT0khWeYtMMB036mRWCUJ2CD7Mu2zXSxXeyNsz2Q=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=RYY6R2QZQEKHEeQIWCa0nrI1k8Rb10Ll8m2rNSinGjPU3GVNs6oguU3tGeAIMTWNZ
	 o9OXW4DOgu36B++ZCvnvxK2DfztegqZAScXBPCXvNB656HReABJYkzUdyF9owROEXF
	 p8E0/Y72V+jx7UQbs9cTIArH/cDvFtyyhD+GLDag=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729422AbgDMNw1 (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 13 Apr 2020 09:52:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:43164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729275AbgDMNw0 (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Mon, 13 Apr 2020 09:52:26 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0C3182072C;
        Mon, 13 Apr 2020 13:52:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586785945;
        bh=nhmVT0khWeYtMMB036mRWCUJ2CD7Mu2zXSxXeyNsz2Q=;
        h=From:To:Cc:Subject:Date:From;
        b=eYM98ziGfcGG5AzkzIUKM6JDy+AaCfVyJ+FQ2CQKC/sGftUVUDSePUvZbO5LHnnyI
         5iezEB1Bf+OuasY73cWRqPvIgnIA/WnGgqb1kXo+GIgJZZaGdj7uxnECb7+PDMBEt3
         JU3XN2EnhTTHZathUWqrEazu0i7VzW5TkTo4gp20=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>, linux-rdma@vger.kernel.org,
        Maor Gottlieb <maorg@mellanox.com>,
        Mark Bloch <markb@mellanox.com>,
        Mark Zhang <markz@mellanox.com>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH rdma-next 0/4] Add steering support for default miss
Date:   Mon, 13 Apr 2020 16:52:16 +0300
Message-Id: <20200413135220.934007-1-leon@kernel.org>
X-Mailer: git-send-email 2.25.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

Hi,

This code from Naor refactors the fs_core and adds steering support
for default miss functionality.

Thanks

Maor Gottlieb (4):
  {IB/net}/mlx5: Simplify don't trap code
  net/mlx5: Add support in forward to namespace
  RDMA/mlx5: Refactor DV create flow
  RDMA/mlx5: Add support in steering default miss

 drivers/infiniband/hw/mlx5/flow.c             | 139 +++++++++++-------
 drivers/infiniband/hw/mlx5/main.c             |  55 ++-----
 .../net/ethernet/mellanox/mlx5/core/fs_core.c | 123 +++++++++++-----
 .../net/ethernet/mellanox/mlx5/core/fs_core.h |   2 +
 include/linux/mlx5/fs.h                       |   1 +
 include/uapi/rdma/mlx5_user_ioctl_cmds.h      |   5 +
 6 files changed, 195 insertions(+), 130 deletions(-)

--
2.25.2

