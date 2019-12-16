Return-Path: <SRS0=2bwt=2G=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92BD6C43603
	for <linux-rdma@archiver.kernel.org>; Mon, 16 Dec 2019 12:51:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6D518206D3
	for <linux-rdma@archiver.kernel.org>; Mon, 16 Dec 2019 12:51:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727641AbfLPMvN (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 16 Dec 2019 07:51:13 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:8130 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727553AbfLPMvN (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Mon, 16 Dec 2019 07:51:13 -0500
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 85797E5434FBF8E94350;
        Mon, 16 Dec 2019 20:51:11 +0800 (CST)
Received: from [127.0.0.1] (10.74.223.196) by DGGEMS404-HUB.china.huawei.com
 (10.3.19.204) with Microsoft SMTP Server id 14.3.439.0; Mon, 16 Dec 2019
 20:51:03 +0800
Subject: Re: [PATCH v3 for-next 0/2] Fix crash due to sleepy mutex while
 holding lock in post_{send|recv|poll}
From:   "Liuyixian (Eason)" <liuyixian@huawei.com>
To:     <dledford@redhat.com>, <jgg@ziepe.ca>, <leon@kernel.org>
CC:     <linux-rdma@vger.kernel.org>, <linuxarm@huawei.com>
References: <1574335200-34923-1-git-send-email-liuyixian@huawei.com>
Message-ID: <c6d0f4bb-aca6-86f6-f909-d91ed9e58216@huawei.com>
Date:   Mon, 16 Dec 2019 20:51:03 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.1.1
MIME-Version: 1.0
In-Reply-To: <1574335200-34923-1-git-send-email-liuyixian@huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.74.223.196]
X-CFilter-Loop: Reflected
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

Hi Jason,

I want to make sure that is there any further comments on this patch set?

Thanks!
Eason

On 2019/11/21 19:19, Yixian Liu wrote:
> Earlier Background:
> HiP08 RoCE hardware lacks ability(a known hardware problem) to flush
> outstanding WQEs if QP state gets into errored mode for some reason.
> To overcome this hardware problem and as a workaround, when QP is
> detected to be in errored state during various legs like post send,
> post receive etc [1], flush needs to be performed from the driver.
> 
> These data-path legs might get called concurrently from various context,
> like thread and interrupt as well (like NVMe driver). Hence, these need
> to be protected with spin-locks for the concurrency. This code exists
> within the driver.
> 
> Problem:
> Earlier The patch[1] sent to solve the hardware limitation explained
> in the background section had a bug in the software flushing leg. It
> acquired mutex while modifying QP state to errored state and while
> conveying it to the hardware using the mailbox. This caused leg to
> sleep while holding spin-lock and caused crash.
> 
> Suggested Solution:
> In this patch, we have proposed to defer the flushing of the QP in
> Errored state using the workqueue.
> 
> We do understand that this might have an impact on the recovery times
> as scheduling of the wqorkqueue handler depends upon the occupancy of
> the system. Therefore to roughly mitigate this affect we have tried
> to use Concurrency Managed workqueue to give worker thread (and
> hence handler) a chance to run over more than one core.
> 
> 
> [1] https://patchwork.kernel.org/patch/10534271/
> 
> 
> This patch-set consists of:
> [Patch 001] Introduce workqueue based WQE Flush Handler
> [Patch 002] Call WQE flush handler in post {send|receive|poll}
> 
> v3 changes:
> 1. Fall back to dynamically allocate flush_work.
> 
> v2 changes:
> 1. Remove new created workqueue according to Jason's comment
> 2. Remove dynamic allocation for flush_work according to Jason's comment
> 3. Change current irq singlethread workqueue to concurrency management
>    workqueue to ensure work unblocked.
> 
> Yixian Liu (2):
>   RDMA/hns: Add the workqueue framework for flush cqe handler
>   RDMA/hns: Delayed flush cqe process with workqueue
> 
>  drivers/infiniband/hw/hns/hns_roce_device.h |  2 +
>  drivers/infiniband/hw/hns/hns_roce_hw_v2.c  | 88 +++++++++++++----------------
>  drivers/infiniband/hw/hns/hns_roce_qp.c     | 43 ++++++++++++++
>  3 files changed, 85 insertions(+), 48 deletions(-)
> 

