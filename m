Return-Path: <SRS0=fy7m=5D=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 418D2C10DCE
	for <linux-rdma@archiver.kernel.org>; Wed, 18 Mar 2020 12:43:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0654B2076D
	for <linux-rdma@archiver.kernel.org>; Wed, 18 Mar 2020 12:43:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1584535418;
	bh=/EPNFAe7/7mGCp7zLP2uohFvZkzaU4incXI5NEe8P1w=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=eGDBDogrMkG7q92fKUbvZ55FsiFVauovjN++UFTHZwyNnNLRrdYdWjciqIQXLRVtk
	 DEAvrIRN4sktQVAj8C6sRKUhujfblny3zTfCiUE3JYi27A5Tlv36Uk9cliPNMEoqGN
	 1nFALRXTe4WWVsUCOkWgYKMHxhfqwAC2YPxm+AY0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726722AbgCRMnh (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 18 Mar 2020 08:43:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:52570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726550AbgCRMnh (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Wed, 18 Mar 2020 08:43:37 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EA81A20768;
        Wed, 18 Mar 2020 12:43:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584535416;
        bh=/EPNFAe7/7mGCp7zLP2uohFvZkzaU4incXI5NEe8P1w=;
        h=From:To:Cc:Subject:Date:From;
        b=PvCWYRhoRdB4cCFGR5hCeRWmZL8nyGpyurzHb5buFamfoHRyDSqUV1O7g1FIMrcVH
         cdcIZKjIGOhi6sfQA2Gk+6c10p9YdW7mjovOQqhjYoXx+e4NZqW5Ggqnx/1NiiYUPD
         4SCui9Vsx2xL4houhahuw2THRi9/ihE/6RutmxCw=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>, linux-rdma@vger.kernel.org,
        Michael Guralnik <michaelgur@mellanox.com>,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>,
        Yishai Hadas <yishaih@mellanox.com>
Subject: [PATCH rdma-next 0/4] Introduce dynamic UAR allocation mode
Date:   Wed, 18 Mar 2020 14:43:25 +0200
Message-Id: <20200318124329.52111-1-leon@kernel.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

From Yishai,

This series exposes API to enable a dynamic allocation and management of a
UAR which now becomes to be a regular uobject.

Moving to that mode enables allocating a UAR only upon demand and drop the
redundant static allocation of UARs upon context creation.

In addition, it allows master and secondary processes that own the same command
FD to allocate and manage UARs according to their needs, this can’t be achieved
today.

As part of this option, QP & CQ creation flows were adapted to support this
dynamic UAR mode once asked by user space.

Once this mode is asked by mlx5 user space driver on a given context, it will
be mutual exclusive, means both the static and legacy dynamic modes for using
UARs will be blocked.

The legacy modes are supported for backward compatible reasons, looking
forward we expect this new mode to be the default.

Thanks

Yishai Hadas (4):
  IB/mlx5: Expose UAR object and its alloc/destroy commands
  IB/mlx5: Extend CQ creation to get uar page index from user space
  IB/mlx5: Extend QP creation to get uar page index from user space
  IB/mlx5: Move to fully dynamic UAR mode once user space supports it

 drivers/infiniband/hw/mlx5/cq.c           |  21 ++-
 drivers/infiniband/hw/mlx5/main.c         | 185 ++++++++++++++++++++--
 drivers/infiniband/hw/mlx5/mlx5_ib.h      |   2 +
 drivers/infiniband/hw/mlx5/qp.c           |  33 ++--
 include/linux/mlx5/driver.h               |   1 +
 include/rdma/uverbs_ioctl.h               |   2 +-
 include/uapi/rdma/mlx5-abi.h              |   6 +
 include/uapi/rdma/mlx5_user_ioctl_cmds.h  |  18 +++
 include/uapi/rdma/mlx5_user_ioctl_verbs.h |   5 +
 9 files changed, 246 insertions(+), 27 deletions(-)

--
2.24.1

