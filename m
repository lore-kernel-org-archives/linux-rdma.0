Return-Path: <SRS0=kLQv=CM=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26DF9C433E7
	for <linux-rdma@archiver.kernel.org>; Thu,  3 Sep 2020 07:39:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DAE9A20775
	for <linux-rdma@archiver.kernel.org>; Thu,  3 Sep 2020 07:39:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599118744;
	bh=cjlxWmM6Ottze3mRshI/5dFtWbYL3pf2ctBrY8YTTj8=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=zJMdgMQ7zG0EBPPPC9E7ycQ3GHKoeAt4JONRnouhRu1JLmuZLlQsFpZY8eeactHhu
	 B55o3JY6YVeE1xKzDDl+QDEz3/l7z3emIHlhc6gxqSkA6i5DF5V7KvY9ds82ndgu08
	 xkXISTdVMgXF0eTiT7hNiUZun66C3Gr0eLaW82Ms=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726528AbgICHjE (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 3 Sep 2020 03:39:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:58744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726109AbgICHjD (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Thu, 3 Sep 2020 03:39:03 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 649D32071B;
        Thu,  3 Sep 2020 07:39:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599118743;
        bh=cjlxWmM6Ottze3mRshI/5dFtWbYL3pf2ctBrY8YTTj8=;
        h=From:To:Cc:Subject:Date:From;
        b=RLVt2hOaTRtvGeaWczjXt3BTfAI7YByFiKLjZiaX7P/DiFXjlvf6Wz8IO0jX6n/DN
         SeAnfxxQHfAybqWUJ9hmHLVhEkxGPUbAdXUXuYIHsSrVs5i9cohWXE/0kMnh6gBF3T
         sz33+B6+Q27Rtiv/yjB/jNRXDd1Xdl43sOSlsWW4=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Alex Vesker <valex@nvidia.com>, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH rdma-next 0/3] Extend mlx5_ib software steering interface
Date:   Thu,  3 Sep 2020 10:38:54 +0300
Message-Id: <20200903073857.1129166-1-leon@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

This series from Alex extends software steering interface to support
devices with extra capability "sw_owner_2" which will replace existing
"sw_owner".

Thanks

Alex Vesker (3):
  RDMA/mlx5: Add sw_owner_v2 bit capability
  RDMA/mlx5: Allow DM allocation for sw_owner_v2 enabled devices
  RDMA/mlx5: Expose TIR and QP ICM address for sw_owner_v2 devices

 drivers/infiniband/hw/mlx5/main.c | 4 +++-
 drivers/infiniband/hw/mlx5/qp.c   | 6 ++++--
 include/linux/mlx5/mlx5_ifc.h     | 3 ++-
 3 files changed, 9 insertions(+), 4 deletions(-)

--
2.26.2

