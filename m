Return-Path: <SRS0=NZET=ZN=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 643C7C432C0
	for <linux-rdma@archiver.kernel.org>; Thu, 21 Nov 2019 01:23:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 46AAA20898
	for <linux-rdma@archiver.kernel.org>; Thu, 21 Nov 2019 01:23:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727117AbfKUBXB (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 20 Nov 2019 20:23:01 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:7156 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726774AbfKUBXB (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Wed, 20 Nov 2019 20:23:01 -0500
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 2E5A687227D10FA0088C;
        Thu, 21 Nov 2019 09:22:59 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server id
 14.3.439.0; Thu, 21 Nov 2019 09:22:51 +0800
From:   Weihang Li <liweihang@hisilicon.com>
To:     <jgg@ziepe.ca>, <leon@kernel.org>
CC:     <dledford@redhat.com>, <linux-rdma@vger.kernel.org>,
        <linuxarm@huawei.com>
Subject: [PATCH rdma-core 0/7] libhns: Bugfix for hip08
Date:   Thu, 21 Nov 2019 09:19:22 +0800
Message-ID: <1574299169-31457-1-git-send-email-liweihang@hisilicon.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

Various fixes on library of hip08.

PR: https://github.com/linux-rdma/rdma-core/pull/623

Lijun Ou (4):
  libhns: Bugfix for assigning sl
  libhns: Bugfix for cleaning cq
  libhns: Bugfix for updating qp params
  libhns: Avoid null pointer operation

Weihang Li (1):
  libhns: Fix calculation errors with ilog32()

Xi Wang (1):
  libhns: Optimize bind_mw for fixing null pointer access

Yangyang Li (1):
  libhns: Return correct value of cqe num when flushing cqe failed

 providers/hns/hns_roce_u_hw_v2.c | 33 +++++++++++++++++++++++----------
 providers/hns/hns_roce_u_verbs.c | 32 +++++++++++++++++++-------------
 2 files changed, 42 insertions(+), 23 deletions(-)

-- 
2.8.1

