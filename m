Return-Path: <SRS0=HFDa=6S=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 495D0C3A5A9
	for <linux-rdma@archiver.kernel.org>; Mon,  4 May 2020 05:19:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 252F5206D7
	for <linux-rdma@archiver.kernel.org>; Mon,  4 May 2020 05:19:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1588569586;
	bh=4EmP+2FrxfyqR11RGq1tcyZLWtI7D3c2DFsoLAgeg8w=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=frHsfYEf/7P2J+C4FJNoqVme/+nacDexibjoPqEOpRxw4cppC1FfeqW0Ug4tEkybC
	 WibT+wT4J9Skiz7VvzgQYsm2ju0li/wZI8Qjkj359bq3dfo/KS5SGH2IT03Bl2qL/M
	 /umGG2SezXxCx4ZFxvDJM+Fnmm+GEHaLnLBoyXbI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726963AbgEDFTp (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 4 May 2020 01:19:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:56622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726509AbgEDFTo (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Mon, 4 May 2020 01:19:44 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8041020735;
        Mon,  4 May 2020 05:19:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588569584;
        bh=4EmP+2FrxfyqR11RGq1tcyZLWtI7D3c2DFsoLAgeg8w=;
        h=From:To:Cc:Subject:Date:From;
        b=aDZsuSRrEISnnDH/pGxOXte+So6f2PJ0pF5qrCaV3iwGn/xlZWMVx0cNd15M9d3Co
         ZcJdGzwGaH2OADELxYRRVvNQP5kMfTzOTThnmlbjG4JlMbN7P2BjFqaG4/NytW1yE+
         bkEqfnZJ9OnZJW0wOO8Kxo/XTrP4+ntufvo6q+5s=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        Maor Gottlieb <maorg@mellanox.com>,
        Mark Zhang <markz@mellanox.com>
Subject: [PATCH rdma-next v3 0/5] Set flow_label and RoCEv2 UDP source port for datagram QP
Date:   Mon,  4 May 2020 08:19:30 +0300
Message-Id: <20200504051935.269708-1-leon@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

Changelog:
 v3: Rebased on latest rdma-nex, which includes HCA set capability patch
 and LAG code and this is why new patch from Maor was added.
 v2: https://lore.kernel.org/linux-rdma/20200413133703.932731-1-leon@kernel.org
 Dropped patch "RDMA/cm: Set flow label of recv_wc based on primary
 flow label", because it violates IBTA 13.5.4.3/13.5.4.4 sections.
 v1: https://lore.kernel.org/lkml/20200322093031.918447-1-leon@kernel.org
 Added extra patch to reduce amount of kzalloc/kfree calls in
 the HCA set capability flow.
 v0: https://lore.kernel.org/linux-rdma/20200318095300.45574-1-leon@kernel.org
--------------------------------

From Mark:

This series provide flow label and UDP source port definition in RoCE v2.
Those fields are used to create entropy for network routes (ECMP), load
balancers and 802.3ad link aggregation switching that are not aware of
RoCE headers.

Thanks.

Maor Gottlieb (1):
  RDMA/core: Consider flow label when building skb

Mark Zhang (4):
  RDMA/core: Add hash functions to calculate RoCEv2 flowlabel and UDP
    source port
  RDMA/mlx5: Define RoCEv2 udp source port when set path
  RDMA/cma: Initialize the flow label of CM's route path record
  RDMA/mlx5: Set UDP source port based on the grh.flow_label

 drivers/infiniband/core/cma.c        | 23 +++++++++++++++
 drivers/infiniband/core/lag.c        |  6 ++--
 drivers/infiniband/hw/mlx5/ah.c      | 21 +++++++++++--
 drivers/infiniband/hw/mlx5/main.c    |  4 +--
 drivers/infiniband/hw/mlx5/mlx5_ib.h |  4 +--
 drivers/infiniband/hw/mlx5/qp.c      | 30 +++++++++++++++----
 include/rdma/ib_verbs.h              | 44 ++++++++++++++++++++++++++++
 7 files changed, 118 insertions(+), 14 deletions(-)

--
2.26.2

