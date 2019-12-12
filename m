Return-Path: <SRS0=BWFQ=2C=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23227C43603
	for <linux-rdma@archiver.kernel.org>; Thu, 12 Dec 2019 11:09:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DF435227BF
	for <linux-rdma@archiver.kernel.org>; Thu, 12 Dec 2019 11:09:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1576148974;
	bh=7ENS/89lnbwcbC/C0h3w4lNBwZWoUvb8BYPBh1lMWQs=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=Vr0fCnFqtpGgPLiBwiMDfW7vKMQjkRu53BZ3ULeNm3BAJ6DqOM484tWM+ZNfe5Ql4
	 hHoai0IYMoEmR/38eB0hdjt0xKKdu9Et0afcOOIZ6WVIYI2Q0nNIBMXcCoaR6V9Jch
	 UWWhNQ7WnuUFEiKYpCDRuBPRYFa5UrZMS6OyXsHw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728848AbfLLLJd (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 12 Dec 2019 06:09:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:56724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728613AbfLLLJd (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Thu, 12 Dec 2019 06:09:33 -0500
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F365C2173E;
        Thu, 12 Dec 2019 11:09:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576148972;
        bh=7ENS/89lnbwcbC/C0h3w4lNBwZWoUvb8BYPBh1lMWQs=;
        h=From:To:Cc:Subject:Date:From;
        b=LAPqzh13mWxSkMRKlVpsS85wM5Xp6y6z1po2liHkZaSZzJaMRTvL8yBFxEToLzwpj
         ALkQcsx8vve5RI3Mxeek46mc6mmhpubbMbhSMWzNpRPUk/tzDKPDtYpJ5XEKZGDQ8k
         wEejDfpKG2JCXBgccAYqoSuawAEGri8BAVVoQHKc=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Shahaf Shuler <shahafs@mellanox.com>,
        Yishai Hadas <yishaih@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: [PATCH rdma-next 0/5] VIRTIO_NET Emulation Offload
Date:   Thu, 12 Dec 2019 13:09:23 +0200
Message-Id: <20191212110928.334995-1-leon@kernel.org>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

Hi,

In this series, we introduce VIRTIO_NET_Q HW offload capability, so SW will
be able to create special general object with relevant virtqueue properties.

This series is based on -rc patches:
https://lore.kernel.org/linux-rdma/20191212100237.330654-1-leon@kernel.org

Thanks

Yishai Hadas (5):
  net/mlx5: Add Virtio Emulation related device capabilities
  net/mlx5: Expose vDPA emulation device capabilities
  IB/mlx5: Extend caps stage to handle VAR capabilities
  IB/mlx5: Introduce VAR object and its alloc/destroy methods
  IB/mlx5: Add mmap support for VAR

 drivers/infiniband/hw/mlx5/main.c            | 202 ++++++++++++++++++-
 drivers/infiniband/hw/mlx5/mlx5_ib.h         |  17 ++
 drivers/net/ethernet/mellanox/mlx5/core/fw.c |   7 +
 include/linux/mlx5/device.h                  |   9 +
 include/linux/mlx5/mlx5_ifc.h                |  15 ++
 include/uapi/rdma/mlx5_user_ioctl_cmds.h     |  17 ++
 6 files changed, 264 insertions(+), 3 deletions(-)

--
2.20.1

