Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48B3FC433F5
	for <linux-rdma@archiver.kernel.org>; Sun, 27 Mar 2022 07:55:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229967AbiC0H5f (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Sun, 27 Mar 2022 03:57:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbiC0H5e (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Sun, 27 Mar 2022 03:57:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63BB0D2
        for <linux-rdma@vger.kernel.org>; Sun, 27 Mar 2022 00:55:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 26C6DB80BAA
        for <linux-rdma@vger.kernel.org>; Sun, 27 Mar 2022 07:55:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AC45C340EC;
        Sun, 27 Mar 2022 07:55:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648367753;
        bh=URxgxi0Qbmoazac8QM27+eWpadezro7QATAah9Iosdg=;
        h=From:To:Cc:Subject:Date:From;
        b=hV4Z9LEC8d+EjBLP3Av38m19+eQvbXm6ldtyKs83BoPFxY9jTjUbGRCT4Qk2gXRAA
         c4YVkCwjeM7CH4n2q3NVnGpEKB+kg6HDZziVmowMqeLaQrGDUuILv2Ic/YWlTkdRyM
         VtW4jvAb17WT7mwS+M3+tOi045bffAC1hNVDjOdhFWytCJPHtEyISG8AS69+z0IBpB
         YwcTo6KsiBKtOp3WhtnukRAi4cYFm8Qo+emYm2ebBRE7CJQRxeZB26WWif8ezQzVKJ
         vSlCRiqPXiypmxJZd/LKXbN6Zf52dHnJYS+Hdz/g7x6D+Yxk3JIrubYtOT3HhAQb7P
         ZI31pL88vdHpQ==
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Aharon Landau <aharonl@nvidia.com>, linux-rdma@vger.kernel.org,
        Maor Gottlieb <maorg@nvidia.com>,
        Mark Zhang <markzhang@nvidia.com>,
        Shay Drory <shayd@nvidia.com>
Subject: [PATCH rdma-rc 0/3] Fixes for v5.17
Date:   Sun, 27 Mar 2022 10:55:45 +0300
Message-Id: <cover.1648366974.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Aharon Landau (2):
  RDMA/mlx5: Don't remove cache MRs when a delay is needed
  RDMA/mlx5: Add a missing update of cache->last_add

Mark Zhang (1):
  IB/cm: Cancel mad on the DREQ event when the state is MRA_REP_RCVD

 drivers/infiniband/core/cm.c    | 3 +--
 drivers/infiniband/hw/mlx5/mr.c | 6 ++++--
 2 files changed, 5 insertions(+), 4 deletions(-)

-- 
2.35.1

