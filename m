Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A832C433DB
	for <linux-rdma@archiver.kernel.org>; Tue, 23 Feb 2021 21:28:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 514B764E3F
	for <linux-rdma@archiver.kernel.org>; Tue, 23 Feb 2021 21:28:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233185AbhBWV1s (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 23 Feb 2021 16:27:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:37808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233276AbhBWV1m (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Tue, 23 Feb 2021 16:27:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CE2C164E83;
        Tue, 23 Feb 2021 21:27:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614115621;
        bh=EfUNP2AiE2R8hKeiVKEby/oXfZUFA9AajQ+rTdBr9gY=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=YSNs3ZOpXab0qGYTB4bDkblaSduF/xXHpu+onkPM0DcnRdE/QTsMl+KvL7U+wvDC7
         WAlyEeEYTYM1NnBp3/7gyivwXaUocDwBxcjncIEGGoGaGGJbqOqWn+spidlM+K+088
         zxG2Bzo/rgWThd0J82NnziSYxV6psBelhwARIVs7i04hBif4TYL6Eg6Zm8P2rN348B
         JJptdMQUZxfRYRBhOSVk/Uny2BU6XXk4M4WtZBijFn/KvPGsWBWLE9zQNa+gETezyn
         16ipv3xbc3CQKArOjqdhMSkzDApjDqCIgoDPi17PvhGdpiQ6mjR5C5jAvm6W/SjLtn
         dSNa3VVL38SjA==
Received: by mail-ot1-f49.google.com with SMTP id k13so54735otn.13;
        Tue, 23 Feb 2021 13:27:01 -0800 (PST)
X-Gm-Message-State: AOAM531iqiY3ADUBYjLKiZ3Prc5g0U1Z60mszIMTha694SG9B0+QVxnd
        IIbc73o82Ed9mhXGNftT4QHV8DkaBZlIBZnWP8s=
X-Google-Smtp-Source: ABdhPJy+i5F7YGOrUCLLGqQ7EWD7xWfYepw8dw5t8BytmydtEqoHcHz0L8jp7i7eLX5sDUv0Zm4mZBjdNVFJt1dcT4I=
X-Received: by 2002:a9d:6b8b:: with SMTP id b11mr2916711otq.210.1614115621057;
 Tue, 23 Feb 2021 13:27:01 -0800 (PST)
MIME-Version: 1.0
References: <21525878.NYvzQUHefP@ubuntu-mate-laptop> <YDICM3SwwGZfE+Sg@unreal>
 <CAD=hENeCXGtKrXxLof=DEZjxpKyYBFS80pAX20nnJBuP_s-GBA@mail.gmail.com>
 <YDOq060TvAwLgknl@unreal> <20210222155845.GI2643399@ziepe.ca>
 <e1e3bec7-0350-4bdd-50c3-41b21388fc71@infradead.org> <20210222164645.GK2643399@ziepe.ca>
 <850d8bf2-c5a0-9fee-f95f-2dfc7d22a528@infradead.org> <CAK8P3a3z0_TNWP7TAVcZC8+MDJKhAZMbQoEH8tgfLQy2MJmG0Q@mail.gmail.com>
 <CAK8P3a194XrKArryJbL+FQoza08xB3FOepyXxBxZAF7ChYkLZQ@mail.gmail.com> <CAJ-ZY99xZEsS5pCbZ7evi_ohozQBpHcNHDcXxfoeaLzuWRzyzw@mail.gmail.com>
In-Reply-To: <CAJ-ZY99xZEsS5pCbZ7evi_ohozQBpHcNHDcXxfoeaLzuWRzyzw@mail.gmail.com>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Tue, 23 Feb 2021 22:26:44 +0100
X-Gmail-Original-Message-ID: <CAK8P3a1jRS=QyTxJzSxfEsaAuF5HnOXbv4MOu8b5EZWEhUep=Q@mail.gmail.com>
Message-ID: <CAK8P3a1jRS=QyTxJzSxfEsaAuF5HnOXbv4MOu8b5EZWEhUep=Q@mail.gmail.com>
Subject: Re: [PATCH] drivers: infiniband: sw: rxe: fix kconfig dependency on CRYPTO
To:     Julian Braha <julianbraha@gmail.com>
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Leon Romanovsky <leon@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Zhu Yanjun <zyjzyj2000@gmail.com>,
        Doug Ledford <dledford@redhat.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Tue, Feb 23, 2021 at 9:46 PM Julian Braha <julianbraha@gmail.com> wrote:
>
> I have other similar patches that I intend to submit. What should I do,
> going forward? Should I use "depends on CRYPTO" for cases like these?
> Should I resubmit this patch with that change?

No, we should not mix the two methods, that just leads to circular dependencies.

How many more patches do you have that need to get merged?

If it's only a few, I'd suggest merging them first before we consider a
broader change. If the problem is very common, we may want to
think about alternative approaches first, and then change everything
at once.

       Arnd
