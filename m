Return-Path: <linux-rdma-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EE91C7EE25
	for <linux-rdma@archiver.kernel.org>; Mon, 15 May 2023 19:12:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242689AbjEOTMa (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 15 May 2023 15:12:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242402AbjEOTM3 (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Mon, 15 May 2023 15:12:29 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FBCE1FC8
        for <linux-rdma@vger.kernel.org>; Mon, 15 May 2023 12:11:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1684177906;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Bc3bM+IKl3uDxaFTLDFgTzHtRKHVmALpY8tRGdV5cNQ=;
        b=Kpook+HmBbjUe+ybGsCZDVBy/vDNvml6xY46Tq7DD3ZWllYSNbVmGJzH5k9dL1JAmNxyso
        3pdFZSJ6HUQ53gGS+wNn55AcXAUTEcZziEIJ9FMNwhwbaqoZJKqJGtdV8fR99dFW3vOEZs
        gjkAqnoGay5J1wp0DuVL6rNqeo1+1ZA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-253-aLuOi84yMPWhNcHLLwZpWw-1; Mon, 15 May 2023 15:11:45 -0400
X-MC-Unique: aLuOi84yMPWhNcHLLwZpWw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DE48285C069;
        Mon, 15 May 2023 19:11:44 +0000 (UTC)
Received: from fedora-x1.redhat.com (unknown [10.22.32.238])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 583FC63F84;
        Mon, 15 May 2023 19:11:44 +0000 (UTC)
From:   Kamal Heib <kheib@redhat.com>
To:     linux-rdma@vger.kernel.org
Cc:     Mustafa Ismail <mustafa.ismail@intel.com>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Leon Romanovsky <leon@kernel.org>,
        Kamal Heib <kheib@redhat.com>
Subject: [PATCH v2 0/3] RDMA/irdma: Cleanups and improvements
Date:   Mon, 15 May 2023 15:11:39 -0400
Message-Id: <20230515191142.413633-1-kheib@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

This series includes a few cleanup patches for the irdma driver.

v2:
- all: Fix subject.
- patch1: Make checkpatch.pl happy.

Kamal Heib (3):
  RDMA/irdma: Return void from irdma_init_iw_device()
  RDMA/irdma: Return void from irdma_init_rdma_device()
  RDMA/irdma: Move iw device ops initialization

 drivers/infiniband/hw/irdma/verbs.c | 41 +++++++++++------------------
 1 file changed, 16 insertions(+), 25 deletions(-)

-- 
2.40.1

