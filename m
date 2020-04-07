Return-Path: <SRS0=YGWR=5X=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D1B5C2BB1D
	for <linux-rdma@archiver.kernel.org>; Tue,  7 Apr 2020 12:40:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E5E582078A
	for <linux-rdma@archiver.kernel.org>; Tue,  7 Apr 2020 12:40:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KAWILKHj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728146AbgDGMkB (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 7 Apr 2020 08:40:01 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:36058 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728596AbgDGMkA (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Tue, 7 Apr 2020 08:40:00 -0400
Received: by mail-qk1-f193.google.com with SMTP id l25so1400120qkk.3
        for <linux-rdma@vger.kernel.org>; Tue, 07 Apr 2020 05:39:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=REDd9q05KI702EFSQR/cgT2WpH4+rJemrcfJ/MESpiQ=;
        b=KAWILKHjC4U9jPdGMThPZYzHGsdaOtMUPXfBK3RD9JmlOj98NEM4m0KQgCBFHOy4n2
         fz1uocxz1N2G9vMJEeyZholf93xXeY1RNkHv6cTa7zlix8KDMLaEwtOetBNS4xgCG65i
         nl/kidfVBsyDg10Vb6nj662lbRm4o+KQ0OAxYFWRFZmYWbTHnP345h0tsgP/m4ka1MA1
         Y47N+uagOXchGg8ch0blRb8O8a9R0pDqCrK3bvXOzycUe0+e8e0c2zx1cOxvwkqQO6Ad
         iSD3Oz8xgI+cNYoJpa8jDIUY+efa5fjKfgWGE16NzX7q01rSH5gbyz6Uou6p83ih43tR
         g9gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=REDd9q05KI702EFSQR/cgT2WpH4+rJemrcfJ/MESpiQ=;
        b=EWejEa9oyEzTVMLLSvuCbKSO7j5IeZRAN5lg6Jf0uvdELrvDQw+CTJPQ8PDvHQFmbe
         J7Bq/g3wUK1sllCy/netI/TRstNx2jsgJGkdh0Z2ifquzR9O0mwAYb7/Pq1a8mw/QY9O
         6PZmr5WQwRopOVRWi9RO172Z+t+WXm7bhUYpzKSt+QzJITsVFoVmxA7AeKboL5qnyVSi
         +xUWCsdbAKnnkgduxmRPQjAoEDWP9dNWBi8b/nXfYr9kV/s0+3dUSUXwKJ2iBrW768GJ
         Hb0TAGfLgZ7fon8UEZKFDznY4uSdO1f+ZH8WLzI3teCzKnPu9aQUciXX1k7LNUG5CFVe
         hqDw==
X-Gm-Message-State: AGi0PuaP6oYUEy1Hu20wePW/kSleldim4ekFfp/xOrRcJ+8rYD2LAks1
        mNp0n1+dwSiIhtJMSS9SUnItlHGOUFpZGTEymsuNXQ==
X-Google-Smtp-Source: APiQypJufCd7AZpci4Y41mZ7FMY2K9lw7Nzb7z1xobj1dlFqbdAhNNzeKkI9NXFd18jF3KT1Xafx0uU+IQkz5xU0O7w=
X-Received: by 2002:a05:620a:348:: with SMTP id t8mr1690858qkm.407.1586263198896;
 Tue, 07 Apr 2020 05:39:58 -0700 (PDT)
MIME-Version: 1.0
References: <00000000000075245205a2997f68@google.com> <20200406172151.GJ80989@unreal>
 <20200406174440.GR20941@ziepe.ca> <CACT4Y+Zv_WXEn6u5a6kRZpkDJnSzeGF1L7JMw4g85TLEgAM7Lw@mail.gmail.com>
 <20200407115548.GU20941@ziepe.ca>
In-Reply-To: <20200407115548.GU20941@ziepe.ca>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Tue, 7 Apr 2020 14:39:42 +0200
Message-ID: <CACT4Y+Zy0LwpHkTMTtb08ojOxuEUFo1Z7wkMCYSVCvsVDcxayw@mail.gmail.com>
Subject: Re: WARNING in ib_umad_kill_port
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Leon Romanovsky <leon@kernel.org>,
        syzbot <syzbot+9627a92b1f9262d5d30c@syzkaller.appspotmail.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Rafael Wysocki <rafael@kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Tue, Apr 7, 2020 at 1:55 PM Jason Gunthorpe <jgg@ziepe.ca> wrote:
>
> On Tue, Apr 07, 2020 at 11:56:30AM +0200, Dmitry Vyukov wrote:
> > > I'm not sure what could be done wrong here to elicit this:
> > >
> > >  sysfs group 'power' not found for kobject 'umad1'
> > >
> > > ??
> > >
> > > I've seen another similar sysfs related trigger that we couldn't
> > > figure out.
> > >
> > > Hard to investigate without a reproducer.
> >
> > Based on all of the sysfs-related bugs I've seen, my bet would be on
> > some races. E.g. one thread registers devices, while another
> > unregisters these.
>
> I did check that the naming is ordered right, at least we won't be
> concurrently creating and destroying umadX sysfs of the same names.
>
> I'm also fairly sure we can't be destroying the parent at the same
> time as this child.
>
> Do you see the above commonly? Could it be some driver core thing? Or
> is it more likely something wrong in umad?

Mmmm... I can't say, I am looking at some bugs very briefly. I've
noticed that sysfs comes up periodically (or was it some other similar
fs?). General observation is that code frequently assumes only the
happy scenario and only, say, a single administrator doing one thing
at a time, slowly and carefully, and it is not really hardened against
armies of monkeys.
But I did not look at code abstractions, bug patterns, contracts, etc.

Greg KH may know better. Greg, as far as I remember you commented on
some of these reports along the lines of, for example, "the warning is
in sysfs code, but the bug is in the callers".
