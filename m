Return-Path: <SRS0=m4pY=VB=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B66AC0651F
	for <linux-rdma@archiver.kernel.org>; Thu,  4 Jul 2019 13:04:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F2F16218B6
	for <linux-rdma@archiver.kernel.org>; Thu,  4 Jul 2019 13:04:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1562245449;
	bh=ZRegd+uvYPk9sBu9hqRv2vUMo4CUYAZM4doGOlkOIJI=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=wfZeqhCZe8h2JGf/AmtcSg3OSsvmA2PH7kyGndbY8eEENqyw0sP37NePQafqFUGoG
	 ajMsRiqBfy+Pxhhb2uRYA8XtNsinENAhlpEJ1O9zGbdgDHZmq2QVdsVwKIrznisno/
	 8/x60BniPvh8g2sHo2idZJFL5P+gSSn2/h9WIp/o=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727213AbfGDNEI (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 4 Jul 2019 09:04:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:35544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725945AbfGDNEI (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Thu, 4 Jul 2019 09:04:08 -0400
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7DCA4218A6;
        Thu,  4 Jul 2019 13:04:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562245447;
        bh=ZRegd+uvYPk9sBu9hqRv2vUMo4CUYAZM4doGOlkOIJI=;
        h=From:To:Cc:Subject:Date:From;
        b=zNTsTqbIG+7cnSYjb6zrJZnH3ihodG7bSwmir3hYntgSsZ32Ue7Hr6BQfO1yaAwQB
         rJZolV1svjL7SXioTBsk2AKZBu3we30iqc1Cw289pojHrMoYqI1xYNaRXTUuWZD7Ff
         EOENvqDKycjahEwU0ByzqQRs26aNagfBnlWg4hrU=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Parav Pandit <parav@mellanox.com>,
        Steve Wise <swise@opengridcomputing.com>
Subject: [PATCH rdma-next 0/2] Allow netlink commands in non init_net net namespace
Date:   Thu,  4 Jul 2019 16:04:00 +0300
Message-Id: <20190704130402.8431-1-leon@kernel.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

Now that RDMA devices can be attached to specific net namespace,
allow netlink commands in non init_net namespace.

Parav Pandit (2):
  IB/core: Work on the caller socket net namespace in nldev_newlink()
  IB: Support netlink commands in non init_net net namespaces

 drivers/infiniband/core/addr.c      |  2 +-
 drivers/infiniband/core/core_priv.h | 19 +++++++++--
 drivers/infiniband/core/device.c    | 34 ++++++------------
 drivers/infiniband/core/iwpm_msg.c  |  8 ++---
 drivers/infiniband/core/iwpm_util.c |  6 ++--
 drivers/infiniband/core/netlink.c   | 53 ++++++++++++++++++-----------
 drivers/infiniband/core/nldev.c     | 22 ++++++------
 drivers/infiniband/core/sa_query.c  |  2 +-
 include/rdma/rdma_netlink.h         | 10 ++++--
 9 files changed, 87 insertions(+), 69 deletions(-)

--
2.20.1

