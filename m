Return-Path: <SRS0=Q7jl=2S=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FE8AC3F68F
	for <linux-rdma@archiver.kernel.org>; Sat, 28 Dec 2019 03:28:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E588820CC7
	for <linux-rdma@archiver.kernel.org>; Sat, 28 Dec 2019 03:28:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725957AbfL1D26 (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Fri, 27 Dec 2019 22:28:58 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:8637 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726359AbfL1D25 (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Fri, 27 Dec 2019 22:28:57 -0500
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 99D495325DF5659DA89E;
        Sat, 28 Dec 2019 11:28:55 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.439.0; Sat, 28 Dec 2019 11:28:45 +0800
From:   Yixian Liu <liuyixian@huawei.com>
To:     <dledford@redhat.com>, <jgg@ziepe.ca>, <leon@kernel.org>
CC:     <linux-rdma@vger.kernel.org>, <linuxarm@huawei.com>
Subject: [PATCH v5 for-next 0/2] RDMA/hns: Add the workqueue framework for flush cqe handler
Date:   Sat, 28 Dec 2019 11:28:53 +0800
Message-ID: <1577503735-26685-1-git-send-email-liuyixian@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

Earlier Background:
HiP08 RoCE hardware lacks ability(a known hardware problem) to flush
outstanding WQEs if QP state gets into errored mode for some reason.
To overcome this hardware problem and as a workaround, when QP is
detected to be in errored state during various legs like post send,
post receive etc [1], flush needs to be performed from the driver.

These data-path legs might get called concurrently from various context,
like thread and interrupt as well (like NVMe driver). Hence, these need
to be protected with spin-locks for the concurrency. This code exists
within the driver.

Problem:
Earlier The patch[1] sent to solve the hardware limitation explained
in the background section had a bug in the software flushing leg. It
acquired mutex while modifying QP state to errored state and while
conveying it to the hardware using the mailbox. This caused leg to
sleep while holding spin-lock and caused crash.

Suggested Solution:
In this patch, we have proposed to defer the flushing of the QP in
Errored state using the workqueue.

We do understand that this might have an impact on the recovery times
as scheduling of the workqueue handler depends upon the occupancy of
the system. Therefore to roughly mitigate this affect we have tried
to use Concurrency Managed workqueue to give worker thread (and
hence handler) a chance to run over more than one core.


[1] https://patchwork.kernel.org/patch/10534271/


This patch-set consists of:
[Patch 001] Introduce workqueue based WQE Flush Handler
[Patch 002] Call WQE flush handler in post {send|receive|poll}

v5 changes:
1. Remove WQ_MEM_RECLAIM flag according to Leon's suggestion.
2. Change to ordered workqueue for the requirement of flush work.

v4 changes:
1. Add flag for PI is being pushed according to Jason's suggestion
   to reduce unnecessary works submitted to workqueue.

v3 changes:
1. Fall back to dynamically allocate flush_work.

v2 changes:
1. Remove new created workqueue according to Jason's comment
2. Remove dynamic allocation for flush_work according to Jason's comment
3. Change current irq singlethread workqueue to concurrency management
   workqueue to ensure work unblocked.

Yixian Liu (2):
  RDMA/hns: Add the workqueue framework for flush cqe handler
  RDMA/hns: Delayed flush cqe process with workqueue

 drivers/infiniband/hw/hns/hns_roce_device.h |  4 ++
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c  | 97 +++++++++++++++--------------
 drivers/infiniband/hw/hns/hns_roce_qp.c     | 45 +++++++++++++
 3 files changed, 98 insertions(+), 48 deletions(-)

-- 
2.7.4

