Return-Path: <SRS0=Wuup=WP=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95752C3A59D
	for <linux-rdma@archiver.kernel.org>; Mon, 19 Aug 2019 11:36:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 665F520851
	for <linux-rdma@archiver.kernel.org>; Mon, 19 Aug 2019 11:36:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1566214593;
	bh=8PsWZ7yMm+CYgbUN5c5O3IxCzwZSmMi1RkdT26qMK+w=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=NJI8kgLm5kk0d8REdwusChgxAisj7apjgRXZRAtoVlZT//hjHF72EWi4rB5GogJzO
	 DnnigQyD+zZelLCT6U5DbXYNabPmsYRuS9tgzxNnDHz9lOGci1Nr6BbguWA63AhuD0
	 WGgUc0sCS0kWzFY44p0VLwaHZZyEOEQVYX2MR2s8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726717AbfHSLgc (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 19 Aug 2019 07:36:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:38584 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726594AbfHSLgc (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Mon, 19 Aug 2019 07:36:32 -0400
Received: from localhost (unknown [77.137.115.125])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0CFD22063F;
        Mon, 19 Aug 2019 11:36:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566214591;
        bh=8PsWZ7yMm+CYgbUN5c5O3IxCzwZSmMi1RkdT26qMK+w=;
        h=From:To:Cc:Subject:Date:From;
        b=t6FdztyAWXbGqU3nEucPHOJTaq9YO6V8zZa2Ma+40aGeRT76hCQ9HZ2nsqfvNVjOV
         xu2iEkTEmUGsFE37xgejGkbIQ0lU+1ZkPYFtdifR/wsVGRFU8raGVKLVw4xKk7+a5B
         s8zi/CDzrLuglmQB6PGS2DQUYAQMCsEfpnLslZfo=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Mark Bloch <markb@mellanox.com>,
        Mark Zhang <markz@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: [PATCH rdma-next 0/3] RDMA RX RoCE Steering Support
Date:   Mon, 19 Aug 2019 14:36:23 +0300
Message-Id: <20190819113626.20284-1-leon@kernel.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

Hi,

This series from Mark extends mlx5 with RDMA_RX RoCE flow steering support
for DEVX and QP objects.

Thanks

Mark Zhang (3):
  net/mlx5: Add per-namespace flow table default miss action support
  net/mlx5: Create bypass and loopback flow steering namespaces for RDMA
    RX
  RDMA/mlx5: RDMA_RX flow type support for user applications

 drivers/infiniband/hw/mlx5/flow.c             |  13 +-
 drivers/infiniband/hw/mlx5/main.c             |   7 +
 drivers/infiniband/hw/mlx5/mlx5_ib.h          |   1 +
 .../net/ethernet/mellanox/mlx5/core/fs_cmd.c  |   4 +-
 .../net/ethernet/mellanox/mlx5/core/fs_core.c | 120 ++++++++++++------
 .../net/ethernet/mellanox/mlx5/core/fs_core.h |   3 +-
 .../net/ethernet/mellanox/mlx5/core/rdma.c    |   2 +-
 include/linux/mlx5/fs.h                       |   1 +
 include/uapi/rdma/mlx5_user_ioctl_verbs.h     |   1 +
 9 files changed, 107 insertions(+), 45 deletions(-)

--
2.20.1

