Return-Path: <SRS0=Cmar=EB=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4342BC4363A
	for <linux-rdma@archiver.kernel.org>; Mon, 26 Oct 2020 11:19:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CDB6522277
	for <linux-rdma@archiver.kernel.org>; Mon, 26 Oct 2020 11:19:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1603711142;
	bh=rDc4LrhNla/X0Y0kVRg1oVTgFH8K5B4hmP11PJqBBvs=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=ZY39zsb/VyVu2w287NZ5t+2JyHsAkL9IJcicYRmit1IkhRK927sAmxo4iLlCZKg3j
	 ++o794FOE1ldMs/2ymKtYdu3XXQhksLpRfQTiQ8g4mvR8z2dl3rShhN/Yq0vFPNYo8
	 Zz+eqfzKH+/y1853KSw537+7zHtS+dV3c8SBqBCg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1772345AbgJZLTB (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 26 Oct 2020 07:19:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:47768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1771082AbgJZLTB (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Mon, 26 Oct 2020 07:19:01 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 216BE22263;
        Mon, 26 Oct 2020 11:19:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603711140;
        bh=rDc4LrhNla/X0Y0kVRg1oVTgFH8K5B4hmP11PJqBBvs=;
        h=From:To:Cc:Subject:Date:From;
        b=jMwOk3RgdhNUiWW4vSv8C+tkoK9jrhnfZlLVnFH4/yrDSi0BFjfdwx9xFJfFoQ6HG
         MVuO1jOvrBOxoJXb3F485USFw1jEu193MJNCftrahGqOp2U+dMSKdc5CfL9kyfocju
         YKGfd0vkg5xqjtm1C4Sv9oaGfuoCMzdKLC7lsJ7A=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Wang <jasowang@redhat.com>, linux-rdma@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>, netdev@vger.kernel.org,
        Parav Pandit <parav@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        virtualization@lists.linux-foundation.org,
        alsa-devel@alsa-project.org, tiwai@suse.de, broonie@kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        ranjani.sridharan@linux.intel.com,
        pierre-louis.bossart@linux.intel.com, fred.oh@linux.intel.com,
        shiraz.saleem@intel.com, dan.j.williams@intel.com,
        kiran.patil@intel.com, linux-kernel@vger.kernel.org
Subject: [PATCH mlx5-next 00/11] Convert mlx5 to use auxiliary bus
Date:   Mon, 26 Oct 2020 13:18:38 +0200
Message-Id: <20201026111849.1035786-1-leon@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Hi,

This patch set converts mlx5 driver to use auxiliary bus [1].

In this series, we are connecting three subsystems (VDPA, netdev and
RDMA) through mlx5_core PCI driver. That driver is responsible to create
proper devices based on supported firmware.

First four patches are preparitions and fixes that were spotted during
code development, rest is the conversion itself.

Thanks

[1] https://lore.kernel.org/lkml/20201023003338.1285642-1-david.m.ertman@intel.com

Leon Romanovsky (11):
  net/mlx5: Don't skip vport check
  net/mlx5: Properly convey driver version to firmware
  net/mlx5_core: Clean driver version and name
  vdpa/mlx5: Make hardware definitions visible to all mlx5 devices
  net/mlx5: Register mlx5 devices to auxiliary virtual bus
  vdpa/mlx5: Connect mlx5_vdpa to auxiliary bus
  net/mlx5e: Connect ethernet part to auxiliary bus
  RDMA/mlx5: Convert mlx5_ib to use auxiliary bus
  net/mlx5: Delete custom device management logic
  net/mlx5: Simplify eswitch mode check
  RDMA/mlx5: Remove IB representors dead code

 drivers/infiniband/hw/mlx5/counters.c         |   7 -
 drivers/infiniband/hw/mlx5/ib_rep.c           | 113 ++--
 drivers/infiniband/hw/mlx5/ib_rep.h           |  45 +-
 drivers/infiniband/hw/mlx5/main.c             | 148 +++--
 drivers/infiniband/hw/mlx5/mlx5_ib.h          |   4 +-
 .../net/ethernet/mellanox/mlx5/core/Kconfig   |   1 +
 drivers/net/ethernet/mellanox/mlx5/core/dev.c | 504 ++++++++++--------
 .../net/ethernet/mellanox/mlx5/core/devlink.c |   4 +-
 .../ethernet/mellanox/mlx5/core/en_ethtool.c  |   4 +-
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 135 ++---
 .../net/ethernet/mellanox/mlx5/core/en_rep.c  |  42 +-
 .../net/ethernet/mellanox/mlx5/core/en_rep.h  |   6 +-
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   |   8 +-
 .../mellanox/mlx5/core/esw/devlink_port.c     |   2 +-
 .../net/ethernet/mellanox/mlx5/core/eswitch.c |  28 +-
 .../mellanox/mlx5/core/eswitch_offloads.c     |   6 +
 .../mellanox/mlx5/core/ipoib/ethtool.c        |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/lag.c |  58 +-
 .../net/ethernet/mellanox/mlx5/core/main.c    |  43 +-
 .../ethernet/mellanox/mlx5/core/mlx5_core.h   |  28 +-
 drivers/vdpa/mlx5/Makefile                    |   2 +-
 drivers/vdpa/mlx5/net/main.c                  |  76 ---
 drivers/vdpa/mlx5/net/mlx5_vnet.c             |  55 +-
 drivers/vdpa/mlx5/net/mlx5_vnet.h             |  24 -
 include/linux/mlx5/driver.h                   |  36 +-
 include/linux/mlx5/eswitch.h                  |   8 +-
 .../linux/mlx5/mlx5_ifc_vdpa.h                |   6 +-
 27 files changed, 731 insertions(+), 664 deletions(-)
 delete mode 100644 drivers/vdpa/mlx5/net/main.c
 delete mode 100644 drivers/vdpa/mlx5/net/mlx5_vnet.h
 rename drivers/vdpa/mlx5/core/mlx5_vdpa_ifc.h => include/linux/mlx5/mlx5_ifc_vdpa.h (97%)

--
2.26.2

