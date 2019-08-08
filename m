Return-Path: <SRS0=Pj7p=WE=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47C67C433FF
	for <linux-rdma@archiver.kernel.org>; Thu,  8 Aug 2019 08:44:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1AF75217F4
	for <linux-rdma@archiver.kernel.org>; Thu,  8 Aug 2019 08:44:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1565253844;
	bh=kbqEIM+7GxsWTJxchB8fEDZj9Pe0yz77PAypHzu+v5g=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=mMb41kCvuQO1zGXKC4jibv8Id1PcSuCzS3DtutrUq5ojpDinwwN3ZfGXXsclyMPwh
	 L8k3kuPNos6yYmkAPjBAcakjA+r5M5WBIYfsRidfV6N9mVBLex585WnY1OKRrFvhTN
	 yFVJ0ADY36GK0p343JIJqy/vAa5Mky8rpt4X9Isw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731122AbfHHIoD (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 8 Aug 2019 04:44:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:50606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730678AbfHHIoD (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Thu, 8 Aug 2019 04:44:03 -0400
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B358D217D7;
        Thu,  8 Aug 2019 08:44:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565253842;
        bh=kbqEIM+7GxsWTJxchB8fEDZj9Pe0yz77PAypHzu+v5g=;
        h=From:To:Cc:Subject:Date:From;
        b=D0d/ELeb1HM8W1sgjJvA1fS4WfsUoBojpIycrFBYgaZXeQMdGWvTY6IkpxBN2PJr4
         h5/UszestI5Sx3msi0/xc21oiC91MyDa4Dp6dvt8Xe7If9Y7CIZTP3J23G2o8pnQnT
         EOycOGl2e7NoSf3SSEDpQzW0b7juc7iCNTYugGyc=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Edward Srouji <edwards@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Yishai Hadas <yishaih@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: [PATCH rdma-next 0/4] Add XRQ and SRQ support to DEVX interface
Date:   Thu,  8 Aug 2019 11:43:54 +0300
Message-Id: <20190808084358.29517-1-leon@kernel.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

Hi,

This small series extends DEVX interface with SRQ and XRQ legacy commands.

Thanks

Yishai Hadas (4):
  net/mlx5: Use debug message instead of warn
  net/mlx5: Add XRQ legacy commands opcodes
  IB/mlx5: Add legacy events to DEVX list
  IB/mlx5: Expose XRQ legacy commands over the DEVX interface

 drivers/infiniband/hw/mlx5/devx.c             | 12 ++++++++++++
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c |  4 ++++
 drivers/net/ethernet/mellanox/mlx5/core/qp.c  |  2 +-
 include/linux/mlx5/device.h                   |  9 +++++++++
 include/linux/mlx5/mlx5_ifc.h                 |  2 ++
 5 files changed, 28 insertions(+), 1 deletion(-)

--
2.20.1

