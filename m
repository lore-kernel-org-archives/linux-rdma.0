Return-Path: <SRS0=BvA6=ZR=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AE2EC432C3
	for <linux-rdma@archiver.kernel.org>; Mon, 25 Nov 2019 04:22:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D1FF820748
	for <linux-rdma@archiver.kernel.org>; Mon, 25 Nov 2019 04:22:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="oSYS3VI3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727678AbfKYEWP (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Sun, 24 Nov 2019 23:22:15 -0500
Received: from mail-vs1-f67.google.com ([209.85.217.67]:45615 "EHLO
        mail-vs1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727745AbfKYEWF (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Sun, 24 Nov 2019 23:22:05 -0500
Received: by mail-vs1-f67.google.com with SMTP id n9so9085977vsa.12
        for <linux-rdma@vger.kernel.org>; Sun, 24 Nov 2019 20:22:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fKFKnaeIlLx+vPJbcVtgRm36ls2EQPJQQwy3QE3ijRk=;
        b=oSYS3VI3OWBGlZJ5kA0BfXZdPQmXdC8w8uEeVEmX5ic7ob7papI87hMNFGlKOkd8DE
         LJ+kj8TP74iRaco9XUNasXEi1ENuXTFSqLkdtXa4/3SH30b84kpQKOguYTvQAPuxwRc+
         okUiQiSYjmXCN4QlOn1zFKanLt6Um/Usqek6dUwGwCtkcizHlQD98tvHtptqVcs5tjdQ
         6Of+X3VBlA9mkhWs+uyitkhEc7D9ZTV76huTiyzqeuD1eDQzKF7h2lE/1wAtiW9R/Y4d
         gjEQMXe0ZLFkbVrWBuHWJWjYHFqC0fZlevzzTts+ols6vfRdvm0ep7wcNW3Ch3tzHjA5
         q6EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fKFKnaeIlLx+vPJbcVtgRm36ls2EQPJQQwy3QE3ijRk=;
        b=pSaE8BXK6lNd1rqt3q3gkXJr52iFeysSsMTrppFeL0yxJnytx04EVNqUjKiRyjVh/1
         EHCaN2GrkuLz0FCdY7mlMCkwEeaF938IjsWtJt3BOsI8eQ/Sn0lxbfkvI4tIBJJvy/TB
         w4CxWUV8OjkSfnQdEJsVg8uLfjpvuOaJQt030ju9d8T+ISIgDOG08UKiGhG+VEfJAO7n
         Tbrc4qEATu0L0hzS3rhCJU1DZzsvb8zzSnpXYszZlXS0U+VDR78bkt4M9tLvxsoNmIpc
         3Q2YubcsqyLRBaOgbKA3yNyIEV/Hxc0t3G6gMlAN2k+R+1MQfkTA79ZXHiAFEwY/Z+jr
         HFMQ==
X-Gm-Message-State: APjAAAUdsFmi71ghtn8p56Eu8EukzD7MXbbBHc4wG2GNdpWOg/YNXiQL
        UyEzCE/n+mqoMaL9kXR9RUs5BEPkrxtc3gk582Q=
X-Google-Smtp-Source: APXvYqyn2S2+Mjn560PtKO+YRnLIn1axWKkbKjERoNNtxrzM6vzSSVNVx+HiIJBfIqCue/pi3Icpzi/fix+Pg6EgWwM=
X-Received: by 2002:a05:6102:1261:: with SMTP id q1mr4841830vsg.182.1574655724239;
 Sun, 24 Nov 2019 20:22:04 -0800 (PST)
MIME-Version: 1.0
References: <1574655875-3475-1-git-send-email-yanjun.zhu@oracle.com>
In-Reply-To: <1574655875-3475-1-git-send-email-yanjun.zhu@oracle.com>
From:   zhuyj <zyjzyj2000@gmail.com>
Date:   Mon, 25 Nov 2019 12:29:20 +0800
Message-ID: <CAD=hENes-VVPBOWk87ok4ipsnK83Esb6CtCTwzJrLOf_3NSZVQ@mail.gmail.com>
Subject: Re: [PATCHv2 1/1] RDMA/core: avoid kernel NULL pointer error
To:     Zhu Yanjun <yanjun.zhu@oracle.com>
Cc:     dledford@redhat.com, jgg@ziepe.ca, michael.j.ruhl@intel.com,
        ira.weiny@intel.com, rostedt@goodmis.org, leon@kernel.org,
        kamalheib1@gmail.com, linux-rdma@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

Probably this problem is caused by IB HW/FW. When IB device is set to down/up

for several times or IB HW/FW is bad, this similar prolem will appear.

In the future, when the developer confronts this similar problem, he can use

this patch to have a try.

Zhu Yanjun

On Mon, Nov 25, 2019 at 12:14 PM Zhu Yanjun <yanjun.zhu@oracle.com> wrote:
>
> When the interface related with IB device is set to down/up over and
> over again, the following call trace will pop out.
> "
>  Call Trace:
>   [<ffffffffa039ff8d>] ib_mad_completion_handler+0x7d/0xa0 [ib_mad]
>   [<ffffffff810a1a41>] process_one_work+0x151/0x4b0
>   [<ffffffff810a1ec0>] worker_thread+0x120/0x480
>   [<ffffffff810a709e>] kthread+0xce/0xf0
>   [<ffffffff816e9962>] ret_from_fork+0x42/0x70
>
>  RIP  [<ffffffffa039f926>] ib_mad_recv_done_handler+0x26/0x610 [ib_mad]
> "
> From vmcore, we can find the following:
> "
> crash7lates> struct ib_mad_list_head ffff881fb3713400
> struct ib_mad_list_head {
>   list = {
>     next = 0xffff881fb3713800,
>     prev = 0xffff881fe01395c0
>   },
>   mad_queue = 0x0
> }
> "
>
> Before the call trace, a lot of ib_cancel_mad is sent to the sender.
> So it is necessary to check mad_queue in struct ib_mad_list_head to avoid
> "kernel NULL pointer" error.
>
> From the new customer report, when there is something wrong with IB HW/FW,
> the above call trace will appear. It seems that bad IB HW/FW will cause
> this problem.
>
> Signed-off-by: Zhu Yanjun <yanjun.zhu@oracle.com>
> ---
> V1->V2: Add new bug symptoms.
> ---
>  drivers/infiniband/core/mad.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
>
> diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c
> index 9947d16..43f596c 100644
> --- a/drivers/infiniband/core/mad.c
> +++ b/drivers/infiniband/core/mad.c
> @@ -2279,6 +2279,17 @@ static void ib_mad_recv_done(struct ib_cq *cq, struct ib_wc *wc)
>                 return;
>         }
>
> +       if (unlikely(!mad_list->mad_queue)) {
> +               /*
> +                * When the interface related with IB device is set to down/up,
> +                * a lot of ib_cancel_mad packets are sent to the sender. In
> +                * sender, the mad packets are cancelled.  The receiver will
> +                * find mad_queue NULL. If the receiver does not test mad_queue,
> +                * the receiver will crash with "kernel NULL pointer" error.
> +                */
> +               return;
> +       }
> +
>         qp_info = mad_list->mad_queue->qp_info;
>         dequeue_mad(mad_list);
>
> --
> 2.7.4
>
