Return-Path: <SRS0=b7KD=4H=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5ABBBC34031
	for <linux-rdma@archiver.kernel.org>; Wed, 19 Feb 2020 01:13:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3A36224656
	for <linux-rdma@archiver.kernel.org>; Wed, 19 Feb 2020 01:13:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726863AbgBSBNe (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 18 Feb 2020 20:13:34 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:45342 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726757AbgBSBNe (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Tue, 18 Feb 2020 20:13:34 -0500
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 41652542FF67A9A28705;
        Wed, 19 Feb 2020 09:13:32 +0800 (CST)
Received: from [127.0.0.1] (10.74.191.121) by DGGEMS408-HUB.china.huawei.com
 (10.3.19.208) with Microsoft SMTP Server id 14.3.439.0; Wed, 19 Feb 2020
 09:13:24 +0800
Subject: Re: [RFC rdma-next] RDMA/core: Add attribute WQ_MEM_RECLAIM to
 workqueue "infiniband"
To:     Jason Gunthorpe <jgg@ziepe.ca>, Lang Cheng <chenglang@huawei.com>
CC:     <dledford@redhat.com>, <leon@kernel.org>, <davem@davemloft.net>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <netdev@vger.kernel.org>,
        <linux-rdma@vger.kernel.org>
References: <1581996935-46507-1-git-send-email-chenglang@huawei.com>
 <20200218153156.GD31668@ziepe.ca>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <212eda31-cc86-5487-051b-cb51c368b6fe@huawei.com>
Date:   Wed, 19 Feb 2020 09:13:23 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <20200218153156.GD31668@ziepe.ca>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.74.191.121]
X-CFilter-Loop: Reflected
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On 2020/2/18 23:31, Jason Gunthorpe wrote:
> On Tue, Feb 18, 2020 at 11:35:35AM +0800, Lang Cheng wrote:
>> The hns3 driver sets "hclge_service_task" workqueue with
>> WQ_MEM_RECLAIM flag in order to guarantee forward progress
>> under memory pressure.
> 
> Don't do that. WQ_MEM_RECLAIM is only to be used by things interlinked
> with reclaimed processing.
> 
> Work on queues marked with WQ_MEM_RECLAIM can't use GFP_KERNEL
> allocations, can't do certain kinds of sleeps, can't hold certain
> kinds of locks, etc.

From mlx5 driver, it seems that there is GFP_KERNEL allocations
on wq marked with WQ_MEM_RECLAIM too:

mlx5e_tx_timeout_work() -> mlx5e_safe_reopen_channels() ->
mlx5e_safe_switch_channels() -> mlx5e_open_channels()

kcalloc() is called with GFP_KERNEL in mlx5e_open_channels(),
and mlx5e_tx_timeout_work() is queued with priv->wq, which is
allocated with WQ_MEM_RECLAIM flags. see:

mlx5e_netdev_init() -> create_singlethread_workqueue()


From the comment in kernel/workqueue.c, the work queued with
wq with WQ_MEM_RECLAIM flag set seems to be executed without
blocking under some rare case. I still not quite understand
the comment, and I can not find any doc that point out the
GFP_KERNEL allocations can not be done in wq with WQ_MEM_RECLAIM
yet. Is there any doc that mentions that GFP_KERNEL allocations
can not be done in wq with WQ_MEM_RECLAIM?


/**
 * rescuer_thread - the rescuer thread function
 * @__rescuer: self
 *
 * Workqueue rescuer thread function.  There's one rescuer for each
 * workqueue which has WQ_MEM_RECLAIM set.
 *
 * Regular work processing on a pool may block trying to create a new
 * worker which uses GFP_KERNEL allocation which has slight chance of
 * developing into deadlock if some works currently on the same queue
 * need to be processed to satisfy the GFP_KERNEL allocation.  This is
 * the problem rescuer solves.
 *
 * When such condition is possible, the pool summons rescuers of all
 * workqueues which have works queued on the pool and let them process
 * those works so that forward progress can be guaranteed.
 *
 * This should happen rarely.
 *
 * Return: 0
 */


The below is the reason we add the sets "hclge_service_task" workqueue
with WQ_MEM_RECLAIM through analysing why other ethernet drivers has
allocated wq with WQ_MEM_RECLAIM flag, I may be wrong about that:

hns3 ethernet driver may be used as the low level transport of a
network file system, memory reclaim data path may depend on the
worker in hns3 driver to bring back the ethernet link so that it flush
the some cache to network based disk.

> 
> Jason
> 
> 

