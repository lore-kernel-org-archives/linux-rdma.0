Return-Path: <SRS0=4vCw=5J=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E830C2BAEE
	for <linux-rdma@archiver.kernel.org>; Tue, 24 Mar 2020 06:14:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4C09E2074D
	for <linux-rdma@archiver.kernel.org>; Tue, 24 Mar 2020 06:14:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1585030483;
	bh=ulSmnmh4kn7m1GdeBTILrwANwWWSigEawgoGBikGcoA=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=LRw/qLK87I3WzGNSNiELWIC1wt/tzL7PoeyoXP01GIoN52cqXw/ALxGojpIRFpOoZ
	 /mgxbn+80F2ZUnwK4gAGSYzxOO70JSxRjba5WWlqV1A4Zlzq6OVaEP4DrUMs+V8o1V
	 0QBBWJQogFBJJdNSmEU7aFV3+uYVSlu6LB05jXig=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726212AbgCXGOm (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 24 Mar 2020 02:14:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:43096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725951AbgCXGOm (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Tue, 24 Mar 2020 02:14:42 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 53F0D20663;
        Tue, 24 Mar 2020 06:14:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585030482;
        bh=ulSmnmh4kn7m1GdeBTILrwANwWWSigEawgoGBikGcoA=;
        h=From:To:Cc:Subject:Date:From;
        b=y4kWou1twXoPTodVoFAEJFxIzujERSe/p6mT8vIGNEEtuzq6NV8oSsXLz6pD0xqX2
         VSKX65YZLUc7Gn9rDkk+yR13VjwV/3Tm+XAaAIleALGBzf5AjVewfYe8oJXAGbBeZn
         7JUgN5sHLpYYLgBKEL7wBbnZREZ7Q+QEfCmQHiMY=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>, linux-rdma@vger.kernel.org,
        Maor Gottlieb <maorg@mellanox.com>,
        Mark Bloch <markb@mellanox.com>,
        Michael Guralnik <michaelgur@mellanox.com>,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH rdma-next 0/2] RDMA TX steering support
Date:   Tue, 24 Mar 2020 08:14:23 +0200
Message-Id: <20200324061425.1570190-1-leon@kernel.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

Hi,

Those two patches from Michael extends mlx5_core and mlx5_ib flow
steering to support RDMA TX in similar way to already supported
RDMA RX.

Thanks

Michael Guralnik (2):
  net/mlx5: Add support for RDMA TX steering
  RDMA/mlx5: Add support for RDMA TX flow table

 drivers/infiniband/hw/mlx5/flow.c             |  3 ++
 drivers/infiniband/hw/mlx5/main.c             |  7 +++
 drivers/infiniband/hw/mlx5/mlx5_ib.h          |  1 +
 .../net/ethernet/mellanox/mlx5/core/fs_cmd.c  |  1 +
 .../net/ethernet/mellanox/mlx5/core/fs_core.c | 53 +++++++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/fs_core.h |  7 ++-
 include/linux/mlx5/device.h                   |  6 +++
 include/linux/mlx5/fs.h                       |  1 +
 include/linux/mlx5/mlx5_ifc.h                 |  2 +-
 include/uapi/rdma/mlx5_user_ioctl_verbs.h     |  1 +
 10 files changed, 79 insertions(+), 3 deletions(-)

--
2.24.1

