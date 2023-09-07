Return-Path: <linux-rdma-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 468BCEC8743
	for <linux-rdma@archiver.kernel.org>; Thu,  7 Sep 2023 17:16:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242144AbjIGRQY (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 7 Sep 2023 13:16:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242174AbjIGRQW (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Thu, 7 Sep 2023 13:16:22 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B90C41FF6;
        Thu,  7 Sep 2023 10:15:56 -0700 (PDT)
Received: by linux.microsoft.com (Postfix, from userid 1174)
        id A8211212B5B7; Thu,  7 Sep 2023 09:52:43 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com A8211212B5B7
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxonhyperv.com;
        s=default; t=1694105563;
        bh=TnGfHgFY2Wfj2kjLKNZBPWtx90U/cn7fzLxE5pjtgEg=;
        h=From:To:Cc:Subject:Date:From;
        b=LykX1xyY1FrqxXvWRblMUan79w9CJexO5EW1rLHes1keB3oypqLlC4BGtfVFrfl5w
         F8kff+mOMAGdTI24vkiPWQoEIm4xWlDXpYo/NzyL94sSG0EZRmjf7v/WjqH6IMFaxW
         sEVz5W+uY4jJxrOr6JbG4I+QqL4wtkjABuezPBkQ=
From:   sharmaajay@linuxonhyperv.com
To:     Long Li <longli@microsoft.com>, Jason Gunthorpe <jgg@ziepe.ca>,
        Leon Romanovsky <leon@kernel.org>,
        Dexuan Cui <decui@microsoft.com>, Wei Liu <wei.liu@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     linux-rdma@vger.kernel.org, linux-hyperv@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ajay Sharma <sharmaajay@microsoft.com>
Subject: [Patch v5 0/5] RDMA/mana_ib
Date:   Thu,  7 Sep 2023 09:52:34 -0700
Message-Id: <1694105559-9465-1-git-send-email-sharmaajay@linuxonhyperv.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Ajay Sharma <sharmaajay@microsoft.com>

Change from v4:
Send qp fatal error event to the context that
created the qp. Add lookup table for qp.

Ajay Sharma (5):
  RDMA/mana_ib : Rename all mana_ib_dev type variables to mib_dev
  RDMA/mana_ib : Register Mana IB  device with Management SW
  RDMA/mana_ib : Create adapter and Add error eq
  RDMA/mana_ib : Query adapter capabilities
  RDMA/mana_ib : Send event to qp

 drivers/infiniband/hw/mana/cq.c               |  12 +-
 drivers/infiniband/hw/mana/device.c           |  81 +++--
 drivers/infiniband/hw/mana/main.c             | 288 +++++++++++++-----
 drivers/infiniband/hw/mana/mana_ib.h          | 102 ++++++-
 drivers/infiniband/hw/mana/mr.c               |  42 ++-
 drivers/infiniband/hw/mana/qp.c               |  86 +++---
 drivers/infiniband/hw/mana/wq.c               |  21 +-
 .../net/ethernet/microsoft/mana/gdma_main.c   | 152 +++++----
 drivers/net/ethernet/microsoft/mana/mana_en.c |   3 +
 include/net/mana/gdma.h                       |  16 +-
 10 files changed, 545 insertions(+), 258 deletions(-)

-- 
2.25.1

