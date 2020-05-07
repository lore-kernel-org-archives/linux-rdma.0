Return-Path: <SRS0=2Aje=6V=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C38F6C38A24
	for <linux-rdma@archiver.kernel.org>; Thu,  7 May 2020 06:33:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9C5412083B
	for <linux-rdma@archiver.kernel.org>; Thu,  7 May 2020 06:33:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1588833234;
	bh=vfeI8t4LWeVIIhBlmAndQdNRlFDKem4d8yBPociSWp0=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=nKHMGaTFu6viN8ahiaGe8vvz611vfLfUCEy2/DqKWMGo3SBhpwZ+jbazSr/EjtdCw
	 ERBUKubfEjS/4h8DvjUAphy9zy9OVQREwX7OY8eSZnQ1fOED15Gyqwd2vKQcq6uCwB
	 OELEpcq6VK/ouK15gHgw/h4Z801B++OumKFJtzY8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725783AbgEGGdx (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 7 May 2020 02:33:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:45690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725440AbgEGGdx (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Thu, 7 May 2020 02:33:53 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7DFCD2078C;
        Thu,  7 May 2020 06:33:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588833233;
        bh=vfeI8t4LWeVIIhBlmAndQdNRlFDKem4d8yBPociSWp0=;
        h=From:To:Cc:Subject:Date:From;
        b=GkznQw4kCS90drFocWDoRpo3vDJxXKG+r09zg2xr+LrK5VydCNEFDql+1ytSQYpDO
         5EJ2aShYyYBe5EHvGiG8Ov4hP4kf9YQ2bn908sZPqi4Ylv4AfWr8JyqMH+GFY67OY2
         6u82ojNlzetrPNdCWKbI0w/3/If2S3+DXGMnBdfA=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        Yishai Hadas <yishaih@mellanox.com>
Subject: [PATCH rdma-rc 0/2] Fixes to IB_EVENT_DEVICE_FATAL logic
Date:   Thu,  7 May 2020 09:33:46 +0300
Message-Id: <20200507063348.98713-1-leon@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

Hi,

Two changes, pretty straightforward.

Thanks

Jason Gunthorpe (2):
  RDMA/uverbs: Do not discard the IB_EVENT_DEVICE_FATAL event
  RDMA/uverbs: Move IB_EVENT_DEVICE_FATAL to destroy_uobj

 drivers/infiniband/core/rdma_core.c           |  3 +-
 drivers/infiniband/core/uverbs.h              |  4 +++
 drivers/infiniband/core/uverbs_main.c         | 12 +++-----
 .../core/uverbs_std_types_async_fd.c          | 30 ++++++++++++++++++-
 4 files changed, 39 insertions(+), 10 deletions(-)

--
2.26.2

