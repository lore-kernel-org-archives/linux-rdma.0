Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C747BC433B4
	for <linux-rdma@archiver.kernel.org>; Mon, 10 May 2021 10:23:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7E14961424
	for <linux-rdma@archiver.kernel.org>; Mon, 10 May 2021 10:23:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230093AbhEJKYn (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 10 May 2021 06:24:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:57592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229684AbhEJKYn (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Mon, 10 May 2021 06:24:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A387861075;
        Mon, 10 May 2021 10:23:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620642218;
        bh=1FVwkz36LxkUdmIh7WeFFF0pPJatWUn8mzK4JRy+3sk=;
        h=From:To:Cc:Subject:Date:From;
        b=PIHywmyz0IIfHReCXzM+UTwmrxwcU69A4mxGbmqiVd84y+VHM3xXVgSp/XYc4Xdee
         N2IT5ZbXoBl6emmg6jCAyN3v6rqPL5qegcdYjYNm562zKVUyqZ4+LYN6YaIA5iTEG3
         dGkYpO0j5e+T8m2SzrG52ryWwiQBFCbGzaFOt0Zzs0XEEiwCvynBG1f6geJMOQ2gbf
         /Or4ovc4ru5no77710euGI9gyh3KnC+FJ2aUFG/U0dJuEIZKBViOR3iYJsK89Ky0k3
         wOhZrcFktmUIKdD3QI9t0/Y0j9qHSVm+Y3+oARK/Vjn3UHgXHMrkG7bCfKo2KJX+Ya
         LiFSHR/Nx6Nxg==
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Evgenii Kochetov <evgeniik@nvidia.com>,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        Sergey Gorenko <sergeygo@nvidia.com>
Subject: [PATCH rdma-next 0/2] Add support to SQD2RTS transition
Date:   Mon, 10 May 2021 13:23:31 +0300
Message-Id: <cover.1620641808.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

The IBTA specification allows SQD2RTS QP transition, however the mlx5_ib
driver didn't have needed implementation. 

This patchset from Sergey adds the needed functionality for this modify QP
transition state and adds extra flag to mark supported kernel.

Thanks

Sergey Gorenko (2):
  RDMA/mlx5: Support SQD2RTS for modify QP
  RDMA/mlx5: Add SQD2RTS bit to the alloc ucontext response

 drivers/infiniband/hw/mlx5/main.c |  4 ++++
 drivers/infiniband/hw/mlx5/qp.c   | 12 ++++++++++++
 drivers/infiniband/hw/mlx5/qpc.c  |  6 ++++++
 include/uapi/rdma/mlx5-abi.h      |  1 +
 4 files changed, 23 insertions(+)

-- 
2.31.1

