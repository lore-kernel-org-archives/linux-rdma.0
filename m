Return-Path: <SRS0=ZuZ5=V5=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50F6BC19759
	for <linux-rdma@archiver.kernel.org>; Thu,  1 Aug 2019 12:21:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1DE36214DA
	for <linux-rdma@archiver.kernel.org>; Thu,  1 Aug 2019 12:21:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1564662108;
	bh=VxGxp/zWv7jr2sJRW0NLa4SCpoKVWKDXXCeeAajpe2M=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=LhS+D5S0z+ZwIydSYcucddQUpdN0M0sbBLnlgMRN1g0YW+QT8QT6InrvLNjKLoawV
	 Dj5Pt2uQlh4joomG27vlvVVXxUQYp8xiYDuANuTvB2PW/ykQT4D4BA+l1S/Cx0HgUb
	 /gszPdCv2JwApIVDHdIDE2OUYVZEqOuZzHWr+E+c=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731067AbfHAMVp (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 1 Aug 2019 08:21:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:32826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728791AbfHAMVo (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Thu, 1 Aug 2019 08:21:44 -0400
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 51B1A214DA;
        Thu,  1 Aug 2019 12:21:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564662103;
        bh=VxGxp/zWv7jr2sJRW0NLa4SCpoKVWKDXXCeeAajpe2M=;
        h=From:To:Cc:Subject:Date:From;
        b=oTF/WcfM0zazEo00XdaN7JVtZMc4dz4rsLYIYYFZwA5ylASeq1fDpZQ5jEZCqTATl
         n7Fyb+/W9/hDFr4sbl0RNnBZDQDoUlElTd67JB5LF3QTNjFIDjvESXfTFtRtuHlmYb
         C1n0XggeiCE6MUqqyxaZM/uuY/MDCeg/LfTNKMRo=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Michael Guralnik <michaelgur@mellanox.com>,
        Moni Shoua <monis@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: [PATCH rdma-next 0/3] ODP support for mlx5 DC QPs
Date:   Thu,  1 Aug 2019 15:21:36 +0300
Message-Id: <20190801122139.25224-1-leon@kernel.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

From Michael,

The series adds support for on-demand paging for DC transport.
Adding handling of DC WQE parsing upon page faults and exposing
capabilities.

As DC is mlx-only transport, the capabilities are exposed to the user
using the direct-verbs mechanism. Namely through the mlx5dv_query_device.

Thanks

Michael Guralnik (3):
  IB/mlx5: Query ODP capabilities for DC
  IB/mlx5: Expose ODP for DC capabilities to user
  IB/mlx5: Add page fault handler for DC initiator WQE

 drivers/infiniband/hw/mlx5/main.c             |  6 +++++
 drivers/infiniband/hw/mlx5/mlx5_ib.h          |  1 +
 drivers/infiniband/hw/mlx5/odp.c              | 27 ++++++++++++++++++-
 .../net/ethernet/mellanox/mlx5/core/main.c    |  6 +++++
 include/linux/mlx5/mlx5_ifc.h                 |  4 ++-
 include/uapi/rdma/mlx5-abi.h                  |  2 ++
 6 files changed, 44 insertions(+), 2 deletions(-)

--
2.20.1

