Return-Path: <SRS0=kv28=YD=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8082C4360C
	for <linux-rdma@archiver.kernel.org>; Thu, 10 Oct 2019 07:11:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7B12F2190F
	for <linux-rdma@archiver.kernel.org>; Thu, 10 Oct 2019 07:11:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1570691472;
	bh=r/mFFrrlxrGO1ec5Hem4Oi307PNQ2cteuQds9Y44S6E=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=IWpGaRVHHflYlic1ljR9HuWbWEymMjk/RWdWifK9xHxOuGxBHo781A8ZljvUibk+S
	 64T2ZXsxJiUb/xR1I/1sl/lkZIQb8IOpvthVTNSJUNM8oS/cS2y/zbEQ4lvtuG40Io
	 Nd7mKoxeo6WDIzlGO9h1hQoq3MTmW+tddCq5ZvL8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732882AbfJJHLL (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 10 Oct 2019 03:11:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:53348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726864AbfJJHLL (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Thu, 10 Oct 2019 03:11:11 -0400
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A152B20B7C;
        Thu, 10 Oct 2019 07:11:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570691471;
        bh=r/mFFrrlxrGO1ec5Hem4Oi307PNQ2cteuQds9Y44S6E=;
        h=From:To:Cc:Subject:Date:From;
        b=Qtw4rZM4WowouDeds+T6cNOUyoWnnHRHmjpwLXrvjUeKm6UQnEbAoulZ4N0d1jQmm
         mCE6nUNnCOaEs2fkaFoS6TRgVIputah6HdeOTkdwfcKa1No3XoevgkJKNpYAPci4ZS
         slw9XN2P/mA24GEKVzO0HwSIIAysU2iTeOvGCfzo=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>
Subject: [PATCH rdma-next v1 0/2] Remove PID namespaces support from restrack
Date:   Thu, 10 Oct 2019 10:11:03 +0300
Message-Id: <20191010071105.25538-1-leon@kernel.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

Changelog
 v0 -> v1: https://lore.kernel.org/linux-rdma/20191002123245.18153-1-leon@kernel.org
 * Beatify code as Parav suggested (patch #2)

----------------------------------------------------------------------------------------
Hi,

Please see individual commit messages for more details.

Thanks

Leon Romanovsky (2):
  RDMA/restrack: Remove PID namespace support
  RDMA/core: Check that process is still alive before sending it to the
    users

 drivers/infiniband/core/counters.c | 28 +++++++++-----------
 drivers/infiniband/core/nldev.c    | 41 ++++++++++++++++--------------
 drivers/infiniband/core/restrack.c | 20 +--------------
 drivers/infiniband/core/restrack.h |  1 -
 4 files changed, 35 insertions(+), 55 deletions(-)

--
2.20.1

