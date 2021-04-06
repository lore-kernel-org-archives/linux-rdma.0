Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74091C433ED
	for <linux-rdma@archiver.kernel.org>; Tue,  6 Apr 2021 08:22:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 44FD1613C7
	for <linux-rdma@archiver.kernel.org>; Tue,  6 Apr 2021 08:22:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234790AbhDFIWg (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 6 Apr 2021 04:22:36 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:15487 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234557AbhDFIWb (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Tue, 6 Apr 2021 04:22:31 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4FF0nn28ghzwRN8;
        Tue,  6 Apr 2021 16:20:13 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.498.0; Tue, 6 Apr 2021 16:22:16 +0800
From:   Weihang Li <liweihang@huawei.com>
To:     <dledford@redhat.com>, <jgg@nvidia.com>
CC:     <leon@kernel.org>, <linux-rdma@vger.kernel.org>,
        <linuxarm@huawei.com>
Subject: [PATCH for-next 0/6] RDMA/core: Correct some coding-style issues
Date:   Tue, 6 Apr 2021 16:19:38 +0800
Message-ID: <1617697184-48683-1-git-send-email-liweihang@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

Do some cleanups according to the coding-style of kernel.

Wenpeng Liang (6):
  RDMA/core: Print the function name by __func__ instead of an fixed
    string
  RDMA/core: Remove the redundant return statements
  RDMA/core: Add necessary spaces
  RDMA/core: Remove redundant spaces
  RDMA/core: Correct format of braces
  RDMA/core: Correct format of block comments

 drivers/infiniband/core/cache.c       | 13 +++----
 drivers/infiniband/core/cm.c          | 39 +++++++++++----------
 drivers/infiniband/core/cm_msgs.h     |  4 +--
 drivers/infiniband/core/cma.c         | 31 +++++++++--------
 drivers/infiniband/core/device.c      | 64 +++++++++++++++++------------------
 drivers/infiniband/core/iwcm.c        |  2 +-
 drivers/infiniband/core/iwpm_msg.c    |  3 +-
 drivers/infiniband/core/mad.c         | 45 +++++++++++-------------
 drivers/infiniband/core/mad_rmpp.c    | 10 +++---
 drivers/infiniband/core/nldev.c       |  2 +-
 drivers/infiniband/core/security.c    | 12 +++----
 drivers/infiniband/core/sysfs.c       | 15 ++++----
 drivers/infiniband/core/ucma.c        |  8 ++---
 drivers/infiniband/core/umem.c        |  4 +--
 drivers/infiniband/core/user_mad.c    | 32 ++++++++----------
 drivers/infiniband/core/uverbs_cmd.c  | 20 +++++------
 drivers/infiniband/core/uverbs_main.c |  3 +-
 drivers/infiniband/core/uverbs_uapi.c | 16 ++++-----
 drivers/infiniband/core/verbs.c       |  3 +-
 19 files changed, 159 insertions(+), 167 deletions(-)

-- 
2.8.1

