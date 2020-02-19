Return-Path: <SRS0=b7KD=4H=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3CC0C18DFF
	for <linux-rdma@archiver.kernel.org>; Wed, 19 Feb 2020 19:05:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 83DF524671
	for <linux-rdma@archiver.kernel.org>; Wed, 19 Feb 2020 19:05:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1582139128;
	bh=dWapGUItAzZ+kxCavxANaF9mCX+PEcxjTy1trvhaW50=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=dmAmAkFk5h3NY+MNK5r95GWCJeMFMPAy7Hg6zI4ls/w1RZgPHjtnR6IBE3gGmlqG1
	 kbOE77hKKQZEH7n028euOi3iOoc7/fg+ydXI6KJyl/Dt4ZXRHMTXuLAwR+7GwYmsYJ
	 6B6j9F+YH4ZCkVYBOgw6Ap3fzpiBMYAXyv7k0TmA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726851AbgBSTFZ (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 19 Feb 2020 14:05:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:41788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726613AbgBSTFZ (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Wed, 19 Feb 2020 14:05:25 -0500
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3D4DB24671;
        Wed, 19 Feb 2020 19:05:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582139124;
        bh=dWapGUItAzZ+kxCavxANaF9mCX+PEcxjTy1trvhaW50=;
        h=From:To:Cc:Subject:Date:From;
        b=mCKtPlBUeFUPh1yOweM7JD1RAy4W4btTJbJeQhTBgxHBvmTgebmdrTZL6IF8Wf1Z+
         PCko74lhsAuQsFcNOMiXPKxxyUqvzG9Dhs8JUggjv9dYESQqS+3E4U64GGTt9mXCL6
         HkQELxCA/cigE9jrZqtSaa/vJ+hbDXJYCoCwvEHs=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Yishai Hadas <yishaih@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: [PATCH rdma-next 0/2] Packet pacing DEVX API
Date:   Wed, 19 Feb 2020 21:05:16 +0200
Message-Id: <20200219190518.200912-1-leon@kernel.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

Hi,

This series from Yishai extends packet pacing to work over DEVX
interface. In first patch, he refactors the mlx5_core internal
logic. In second patch, the RDMA APIs are added.

Thanks

Yishai Hadas (2):
  net/mlx5: Expose raw packet pacing APIs
  IB/mlx5: Introduce UAPIs to manage packet pacing

 drivers/infiniband/hw/mlx5/Makefile          |   1 +
 drivers/infiniband/hw/mlx5/main.c            |   1 +
 drivers/infiniband/hw/mlx5/mlx5_ib.h         |   6 +
 drivers/infiniband/hw/mlx5/qos.c             | 136 +++++++++++++++++++
 drivers/net/ethernet/mellanox/mlx5/core/rl.c | 130 +++++++++++++-----
 include/linux/mlx5/driver.h                  |  11 +-
 include/linux/mlx5/mlx5_ifc.h                |  26 ++--
 include/uapi/rdma/mlx5_user_ioctl_cmds.h     |  17 +++
 include/uapi/rdma/mlx5_user_ioctl_verbs.h    |   4 +
 9 files changed, 287 insertions(+), 45 deletions(-)
 create mode 100644 drivers/infiniband/hw/mlx5/qos.c

--
2.24.1

