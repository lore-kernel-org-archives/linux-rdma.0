Return-Path: <linux-rdma-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BEC6EED61F
	for <linux-rdma@archiver.kernel.org>; Fri, 15 Sep 2023 18:25:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234869AbjIOSY5 (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Fri, 15 Sep 2023 14:24:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233822AbjIOSYl (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Fri, 15 Sep 2023 14:24:41 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0D28F1FD7;
        Fri, 15 Sep 2023 11:24:36 -0700 (PDT)
Received: by linux.microsoft.com (Postfix, from userid 1174)
        id 7A8BC212BE76; Fri, 15 Sep 2023 11:24:35 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 7A8BC212BE76
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxonhyperv.com;
        s=default; t=1694802275;
        bh=B/5omYi3NMx7LhZ02tzamkjg2YG+tTuPu1ZrPCF6Ks4=;
        h=From:To:Cc:Subject:Date:From;
        b=gCcS07miBSR7haO7qHEEdgKzu2BtS7fOefTXK5BX6HcIhbEdN9pgNqxMMllTdoPyN
         zfBRpOrDqnqBD1yQVH83JUsZa+1fp0jgkDk8Su/pBeeKL6EXSZtgAUdznq52tT2cTW
         KUojN81/rHw4C3SvXFXqcbOQqW9vicbIE3s+HK04=
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
Subject: [Patch v6 0/5] RDMA/mana_ib
Date:   Fri, 15 Sep 2023 11:24:25 -0700
Message-Id: <1694802270-17452-1-git-send-email-sharmaajay@linuxonhyperv.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Ajay Sharma <sharmaajay@microsoft.com>

Change from v5:
Use xarray for qp lookup.

Ajay Sharma (5):
  RDMA/mana_ib : Rename all mana_ib_dev type variables to mib_dev
  RDMA/mana_ib : Register Mana IB  device with Management SW
  RDMA/mana_ib : Create adapter and Add error eq
  RDMA/mana_ib : Query adapter capabilities
  RDMA/mana_ib : Send event to qp

 drivers/infiniband/hw/mana/cq.c               |  12 +-
 drivers/infiniband/hw/mana/device.c           |  78 +++--
 drivers/infiniband/hw/mana/main.c             | 290 +++++++++++++-----
 drivers/infiniband/hw/mana/mana_ib.h          | 102 +++++-
 drivers/infiniband/hw/mana/mr.c               |  42 ++-
 drivers/infiniband/hw/mana/qp.c               |  86 +++---
 drivers/infiniband/hw/mana/wq.c               |  21 +-
 .../net/ethernet/microsoft/mana/gdma_main.c   | 152 +++++----
 drivers/net/ethernet/microsoft/mana/mana_en.c |   3 +
 include/net/mana/gdma.h                       |  16 +-
 10 files changed, 543 insertions(+), 259 deletions(-)

-- 
2.25.1

