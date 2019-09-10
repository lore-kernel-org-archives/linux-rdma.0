Return-Path: <SRS0=TySp=XF=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41D00C3A5A2
	for <linux-rdma@archiver.kernel.org>; Tue, 10 Sep 2019 07:52:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 162E121479
	for <linux-rdma@archiver.kernel.org>; Tue, 10 Sep 2019 07:52:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1568101942;
	bh=rro0X943d5kflYduQusALX12vyeN7KJ3DLA8AUF6cvk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=1O7d2s3JhHxWsZ7CqqVgm4OeVb7MIfNK8cC2se+uHTd7Bb+9HIMY5/TfyhRbq4/jz
	 SsYjkIJOBmKL1C9du/3sNdUT+URi8eHAPbKn7/GcKbdkv+Dl+s8b/7ro0VPWTorznM
	 FveKPa6r+TP07e2HEOpuv/OVgAEPi4uhD64JVqes=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726529AbfIJHwV (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 10 Sep 2019 03:52:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:51154 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726317AbfIJHwV (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Tue, 10 Sep 2019 03:52:21 -0400
Received: from localhost (unknown [148.69.85.38])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 14FCE2084D;
        Tue, 10 Sep 2019 07:52:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568101940;
        bh=rro0X943d5kflYduQusALX12vyeN7KJ3DLA8AUF6cvk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KMhyC6/X/EIikgVz9gBBlwh39Poj+u0ypVW1I/K2QdD/L+vq/8ML9bfxVwaafI/9X
         8v+SspSQVvwqsMdJu+/rLNBD8H0Wh8SYA9t5F9w455Bih4LcSBcLzqJByyIA7Q4tRY
         /ZkdlpRhBkm+bYH+303m//c69fODUjCmRFooYkCg=
Date:   Tue, 10 Sep 2019 10:52:16 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     "Liuyixian (Eason)" <liuyixian@huawei.com>
Cc:     Weihang Li <liweihang@hisilicon.com>, linux-rdma@vger.kernel.org,
        jgg@ziepe.ca, dledford@redhat.com, linuxarm@huawei.com
Subject: Re: [PATCH for-next] RDMA/hns: Bugfix for flush cqe in case softirq
 and multi-process
Message-ID: <20190910075216.GX6601@unreal>
References: <1567686671-4331-1-git-send-email-liweihang@hisilicon.com>
 <20190908080303.GC26697@unreal>
 <f8f29a6a-b473-6c89-8ec7-092fd53aea16@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f8f29a6a-b473-6c89-8ec7-092fd53aea16@huawei.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Tue, Sep 10, 2019 at 02:40:20PM +0800, Liuyixian (Eason) wrote:
>
>
> On 2019/9/8 16:03, Leon Romanovsky wrote:
> > On Thu, Sep 05, 2019 at 08:31:11PM +0800, Weihang Li wrote:
> >> From: Yixian Liu <liuyixian@huawei.com>
> >>
> >> Hip08 has the feature flush cqe, which help to flush wqe in workqueue
> >> (sq and rq) when error happened by transmitting producer index with
> >> mailbox to hardware. Flush cqe is emplemented in post send and recv
> >> verbs. However, under NVMe cases, these verbs will be called under
> >> softirq context, and it will lead to following calltrace with
> >> current driver as mailbox used by flush cqe can go to sleep.
> >>
> >> This patch solves this problem by using workqueue to do flush cqe,
> >
> > Unbelievable, almost every bug in this driver is solved by introducing
> > workqueue. You should fix "sleep in flush path" issue and not by adding
> > new workqueue.
> >
> Hi Leon,
>
> Thanks for the comment.
> Up to now, for hip08, only one place use workqueue in hns_roce_hw_v2.c
> where for irq prints.

Thanks to our lack of desire to add more workqueues and previous patches
which removed extra workqueues from the driver.

>
> The solution for flush cqe in this patch is as follow:
> While flush cqe should be implement, the driver should modify qp to error state
> through mailbox with the newest product index of sq and rq, the hardware then
> can flush all outstanding wqes in sq and rq.
>
> That's the whole mechanism of flush cqe, also is the flush path. We can't
> change neither mailbox sleep attribute or flush cqe occurred in post send/recv.
> To avoid the calltrace of flush cqe in post verbs under NVMe softirq,
> use workqueue for flush cqe seems reasonable.
>
> As far as I know, there is no other alternative solution for this situation.
> I will be very grateful if you reminder me more information.

ib_drain_rq/ib_drain_sq/ib_drain_qp????

>
> Thanks
>
> > _______________________________________________
> > Linuxarm mailing list
> > Linuxarm@huawei.com
> > http://hulk.huawei.com/mailman/listinfo/linuxarm
> >
> >
>
