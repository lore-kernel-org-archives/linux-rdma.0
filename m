Return-Path: <SRS0=nLh4=YL=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44080CA9EA1
	for <linux-rdma@archiver.kernel.org>; Fri, 18 Oct 2019 09:41:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 13FCE20820
	for <linux-rdma@archiver.kernel.org>; Fri, 18 Oct 2019 09:41:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hOTU91GD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729219AbfJRJld (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Fri, 18 Oct 2019 05:41:33 -0400
Received: from mail-wr1-f51.google.com ([209.85.221.51]:41874 "EHLO
        mail-wr1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732590AbfJRJld (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Fri, 18 Oct 2019 05:41:33 -0400
Received: by mail-wr1-f51.google.com with SMTP id p4so5487515wrm.8
        for <linux-rdma@vger.kernel.org>; Fri, 18 Oct 2019 02:41:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=c/pkC3/TmHcGGrC1+7lLQieYz2Wx9vAVd/sX3T8lrRo=;
        b=hOTU91GDPv4sWl1HyOpdVJn36ms7MjfIW/th/sBO0CHLV3d9TFQoz7q0ii5jFRCBkP
         RqaJMnGMgNukohwDL6fRoxxefOxAjZNyaSSlN07rkV6wsfN416khM7bL3ZNrgEISfKjm
         kyioCGptUtAHSfyrWsxg4PZ7uz9TGPvcMPHnsgOGqD06d5v0ksNz0sZwInwvOialxwp1
         jXHhHckurTj1/d2Gg0ANkQbG953acxesd+0UY740SoA4EgW0X2ktFoWVfv0LN2/rxJD/
         URYIarv5kbP+ilyujZ/ebyNSJxYIN2PeU5q/G1UDyenc6l+pZu++pVUuj087eO13uKc2
         DlkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=c/pkC3/TmHcGGrC1+7lLQieYz2Wx9vAVd/sX3T8lrRo=;
        b=g0E0QXxiWfLrzCCqiWerH880bo+sSPBpA2yxi4pT6h304v3DUg2gdz8WXH3G84hoOu
         gjfWLhoKaQA4DvIyAZPq2fo4mXwOHESvCXWgneoBE+MXM2w3I5zsCp5OhaybITCCDblK
         JwyNuskeO7cepqkY9WyzTJfn8b/9eEtg77/PSdtXjFgV1e5chkfLoLZW5XnRyXGwmZPB
         onP6NYENWj2cQP9/w5+yWeLs5of09iB23AFSSyg7c0xjAsNwB3axCQCf0N1oW5ZvzCdL
         xHZ/AHfazAhBLJ2diBmvA+l4p+VjVFeihw9Km4/BqI66+RD60gSL0bjwfqXJWB50YoWX
         ST1A==
X-Gm-Message-State: APjAAAUB2KMNWqey0AIEmDwBq0QQRAY378MCY93m1iIXV28mE5MW0Riq
        15ed6BPNXEaeou7rWj7tDWIGxQJ1
X-Google-Smtp-Source: APXvYqzJA5hgXH+y05JATCzzAKb7MVkqewiIwWRvPaq24rLaTTY7t62I8krCLvcHNKtHbfSKAbFfsA==
X-Received: by 2002:adf:db0e:: with SMTP id s14mr2475035wri.341.1571391690786;
        Fri, 18 Oct 2019 02:41:30 -0700 (PDT)
Received: from kheib-workstation.redhat.com (bzq-79-179-0-252.red.bezeqint.net. [79.179.0.252])
        by smtp.gmail.com with ESMTPSA id 126sm2186111wma.48.2019.10.18.02.41.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Oct 2019 02:41:30 -0700 (PDT)
From:   Kamal Heib <kamalheib1@gmail.com>
To:     linux-rdma@vger.kernel.org
Cc:     Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>,
        Lijun Ou <oulijun@huawei.com>,
        Selvin Xavier <selvin.xavier@broadcom.com>,
        Michal Kalderon <mkalderon@marvell.com>,
        Kamal Heib <kamalheib1@gmail.com>
Subject: [PATCH for-next v3 0/4] RDMA: modify_port improvements
Date:   Fri, 18 Oct 2019 12:41:11 +0300
Message-Id: <20191018094115.13167-1-kamalheib1@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

Changelog:
v3: Improve [patch 1/4]. 
v2: Include fixes lines.

This series includes three patches which fix the return values from
modify_port() callbacks when they aren't supported.

Kamal Heib (4):
  RDMA/core: Fix return code when modify_port isn't supported
  RDMA/hns: Remove unsupported modify_port callback
  RDMA/ocrdma: Remove unsupported modify_port callback
  RDMA/qedr: Remove unsupported modify_port callback

 drivers/infiniband/core/device.c            | 2 +-
 drivers/infiniband/hw/hns/hns_roce_main.c   | 7 -------
 drivers/infiniband/hw/ocrdma/ocrdma_main.c  | 1 -
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c | 6 ------
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.h | 2 --
 drivers/infiniband/hw/qedr/main.c           | 1 -
 drivers/infiniband/hw/qedr/verbs.c          | 6 ------
 drivers/infiniband/hw/qedr/verbs.h          | 2 --
 8 files changed, 1 insertion(+), 26 deletions(-)

-- 
2.20.1

