Return-Path: <SRS0=fy7m=5D=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EEC0C5ACD6
	for <linux-rdma@archiver.kernel.org>; Wed, 18 Mar 2020 09:53:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1511120770
	for <linux-rdma@archiver.kernel.org>; Wed, 18 Mar 2020 09:53:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1584525187;
	bh=8gg3tjIhkt2FJ8A0Bi3bOqZB1iaXQRhtVf8ExTCF3mo=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=FjQDJHa1l1rYWZKCjuzxSYeOgH/rQQuAZCdrzOfM2BK8oOKd+w990oc20HfA2oOH2
	 YfeZbuUWQRQF3mxrPwAgC0KkuiPDhL8ac64boQ2O56Aa/D87hAtHwUu9gTDlHP5Fab
	 XBaSAcB6Ul7VPQaayELNnyEJJu1cowBYjesu/8ZM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727281AbgCRJxG (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 18 Mar 2020 05:53:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:49042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726786AbgCRJxG (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Wed, 18 Mar 2020 05:53:06 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DDEEF2076F;
        Wed, 18 Mar 2020 09:53:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584525185;
        bh=8gg3tjIhkt2FJ8A0Bi3bOqZB1iaXQRhtVf8ExTCF3mo=;
        h=From:To:Cc:Subject:Date:From;
        b=GULeZ9sVKOoRFqUYShCmm7PrYsvTqv1IdWGpLslE3Btn3NYvT9i2Ax5VmOlflI50J
         mfBkDaShnZ2oaFjftPVbBImntHMeTgiNa4psdGgb+OqpeVw5z9ZZn6VSC3vVPWCOxb
         wub0yA4/+yANMq9qOui9wZ3aWD00wQcsF7QHscjM=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>, linux-rdma@vger.kernel.org,
        Maor Gottlieb <maorg@mellanox.com>,
        Mark Zhang <markz@mellanox.com>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH rdma-next 0/6] Set flow_label and RoCEv2 UDP source port for datagram QP
Date:   Wed, 18 Mar 2020 11:52:54 +0200
Message-Id: <20200318095300.45574-1-leon@kernel.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

From Mark:

This series provide flow label and UDP source port definition in RoCE v2.
Those fields are used to create entropy for network routes (ECMP), load
balancers and 802.3ad link aggregation switching that are not aware of
RoCE headers.

Thanks.

Mark Zhang (6):
  net/mlx5: Enable SW-defined RoCEv2 UDP source port
  RDMA/core: Add hash functions to calculate RoCEv2 flowlabel and UDP
    source port
  RDMA/mlx5: Define RoCEv2 udp source port when set path
  RDMA/cma: Initialize the flow label of CM's route path record
  RDMA/cm: Set flow label of recv_wc based on primary flow label
  RDMA/mlx5: Set UDP source port based on the grh.flow_label

 drivers/infiniband/core/cm.c                  |  7 +++
 drivers/infiniband/core/cma.c                 | 23 ++++++++++
 drivers/infiniband/hw/mlx5/ah.c               | 21 ++++++++-
 drivers/infiniband/hw/mlx5/main.c             |  4 +-
 drivers/infiniband/hw/mlx5/mlx5_ib.h          |  4 +-
 drivers/infiniband/hw/mlx5/qp.c               | 30 ++++++++++---
 .../net/ethernet/mellanox/mlx5/core/main.c    | 39 ++++++++++++++++
 include/linux/mlx5/mlx5_ifc.h                 |  5 ++-
 include/rdma/ib_verbs.h                       | 44 +++++++++++++++++++
 9 files changed, 164 insertions(+), 13 deletions(-)

--
2.24.1

