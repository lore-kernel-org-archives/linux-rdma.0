Return-Path: <linux-rdma-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93E6FCE79B4
	for <linux-rdma@archiver.kernel.org>; Wed, 20 Sep 2023 10:02:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234114AbjITKCK (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 20 Sep 2023 06:02:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234128AbjITKCJ (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Wed, 20 Sep 2023 06:02:09 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAC3CA3
        for <linux-rdma@vger.kernel.org>; Wed, 20 Sep 2023 03:02:03 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD92BC433C8;
        Wed, 20 Sep 2023 10:02:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695204123;
        bh=n0kaI4OSK1aLMF65oX/3THVjt4PGRIT2sGKmpF8uPMI=;
        h=From:To:Cc:Subject:Date:From;
        b=sqiQ6oUP6/sXaJLyGNHrYPdX5T9MdGPFNNWzTpfOWTXXluIZXGV3VS5AVxzdE7Tbn
         yE/2oSdjYBWBjbNutQsgp+j9RfH2EprJqgIBSXRm/LcY/gO3FtRneND1mtbh14roNI
         MPjiXXBa8LrnW1NW1D0ObFg1DBt9EKpnpCTDnJYY5aox9Y/yneX6vWQi7ycbGewKV1
         64cimgAkePnBS00UTQxr9jZ295G3nG05cJ1ZlofFrwyCJ8PAsckTG8I8xUz0XF9ISV
         YZ+MTcpld66/ePIxHmUIrPdn+oBnPRCNBo0BnYFGBU0OTs3uSNmDyF0z+F4TecVNP3
         /A+HyMMTY/4Fw==
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Edward Srouji <edwards@nvidia.com>, linux-rdma@vger.kernel.org,
        Maor Gottlieb <maorg@nvidia.com>,
        Mark Bloch <mbloch@nvidia.com>,
        Michael Guralnik <michaelgur@nvidia.com>,
        Shay Drory <shayd@nvidia.com>
Subject: [PATCH rdma-rc 0/3] Batch of mlx5_ib fixes
Date:   Wed, 20 Sep 2023 13:01:53 +0300
Message-ID: <cover.1695203958.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Hi,

This patchset is combination of various mlx5_ib fixes.

Thanks

Hamdan Igbaria (1):
  RDMA/mlx5: Fix mutex unlocking on error flow for steering anchor
    creation

Michael Guralnik (1):
  RDMA/mlx5: Fix assigning access flags to cache mkeys

Shay Drory (1):
  RDMA/mlx5: Fix NULL string error

 drivers/infiniband/hw/mlx5/fs.c   | 2 +-
 drivers/infiniband/hw/mlx5/main.c | 2 +-
 drivers/infiniband/hw/mlx5/mr.c   | 3 ++-
 3 files changed, 4 insertions(+), 3 deletions(-)

-- 
2.41.0

