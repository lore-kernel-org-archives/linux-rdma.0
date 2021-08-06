Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5D52C432BE
	for <linux-rdma@archiver.kernel.org>; Fri,  6 Aug 2021 10:14:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8680E60FE7
	for <linux-rdma@archiver.kernel.org>; Fri,  6 Aug 2021 10:14:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244768AbhHFKOb (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Fri, 6 Aug 2021 06:14:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231752AbhHFKO2 (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Fri, 6 Aug 2021 06:14:28 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4ED7C061798
        for <linux-rdma@vger.kernel.org>; Fri,  6 Aug 2021 03:14:12 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id c16so16940590lfc.2
        for <linux-rdma@vger.kernel.org>; Fri, 06 Aug 2021 03:14:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vs4TIodoVr6O9qONb9nVfXbYxk5hd+tAU8eckFmRfG4=;
        b=YuWdSCxQAiaBCRTLv02SEEjGL3TCKUk8ZzC5GagmEya6dQ2ISNckpjrC/Py+bw80ly
         btX3p9EfNJKRMbacyM/EJbkWBC4+0dwXUOgI3c0+xI/o3zkvhWbMXcqo/EBjQFAuVB4A
         f0Vpp4YUa9ZTbuk/qczlegMJ0X6Ds69buJrv6T1vbEvJt1bsuA/LQthsPkEcjKn0jcVk
         +RBTKfIl+aj9iz/gIUd3wdT4RlmZaF4jTbU/73NXkfSdCMl8cgymaQ2/RMM416OykhnU
         NNwDuY9BOzGUSJwoRXt/2QuTDmJwlozry1o2F5VpOmHkyTKjQENdfV7nfWeVxFzUignM
         bUYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vs4TIodoVr6O9qONb9nVfXbYxk5hd+tAU8eckFmRfG4=;
        b=e4avjj5uid17oVAOqXXu96uIeVgxJSh5mWiQWAAb43/nT56RmL+6K/phrf1hFv56zW
         DRkhM+ZEbVH7CoQ6NIDtbQ1S5wSkVnVGbJ8Gf+7cyji8sfxC1xZavPbmv9RwjcOuuPmO
         yE/sEZeHswOGInXaeitJ2bugMKNRes8I2TZ/ok4lrx00pBSI4xT+Z4bQpP+yO8CUmMBw
         Wb0JUu4c1X0LBt+IAYrDdk8eFDD3i2E8mzYu1mlhPh9AnzcxWRbynx9D9F/4aZedhBHx
         Hz1WTKWBbuAiwpsYWHKhMooBFiAK6FCCcTeCAfigOz+zwg5Qg4t1R4s/fphtUxUy/2WZ
         3sgQ==
X-Gm-Message-State: AOAM531UcDclBdjPtva/+53DM7jtQZoYtsTSvYAry2Fb9+mMNYguwLvG
        DyZ5ABGvLdeWalw14WRE2UMxN7/zs7CXG8xLyh5kmQ==
X-Google-Smtp-Source: ABdhPJyDh8+nw2436k17EGbDlEi8uDt6O2wcO1qtw930JgmgAGIOZfX9PeQ+Hle75ix2YiX65iskR2Iu//l9qtWh388=
X-Received: by 2002:ac2:4104:: with SMTP id b4mr7085975lfi.471.1628244851265;
 Fri, 06 Aug 2021 03:14:11 -0700 (PDT)
MIME-Version: 1.0
References: <20210730131832.118865-1-jinpu.wang@ionos.com> <20210730131832.118865-10-jinpu.wang@ionos.com>
 <YQee8091rXaXU4vL@unreal> <CAJpMwyj6SjO+yNsA9uMDZP1Cu2gUfXHAeRGgaGf46xbxDBrk5g@mail.gmail.com>
 <YQge6yQTILQsQECO@unreal> <CAJpMwygeu=LYdTWMHxWYHMe_==yHxB_KEsTstH3CWOaMWu0sgQ@mail.gmail.com>
 <20210806012232.GK543798@ziepe.ca>
In-Reply-To: <20210806012232.GK543798@ziepe.ca>
From:   Haris Iqbal <haris.iqbal@ionos.com>
Date:   Fri, 6 Aug 2021 12:14:00 +0200
Message-ID: <CAJpMwyhuDUZGz7uN1xuADh5+dMBZriiK44vPfEZif7Kw6WncLg@mail.gmail.com>
Subject: Re: [PATCH for-next 09/10] RDMA/rtrs: Add support to disable an IB
 port on the storage side
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Leon Romanovsky <leon@kernel.org>,
        Jack Wang <jinpu.wang@ionos.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Bart Van Assche <bvanassche@acm.org>,
        Doug Ledford <dledford@redhat.com>,
        Md Haris Iqbal <haris.iqbal@cloud.ionos.com>,
        Gioh Kim <gi-oh.kim@ionos.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Fri, Aug 6, 2021 at 3:22 AM Jason Gunthorpe <jgg@ziepe.ca> wrote:
>
> On Mon, Aug 02, 2021 at 07:43:05PM +0200, Haris Iqbal wrote:
> > On Mon, Aug 2, 2021 at 6:36 PM Leon Romanovsky <leon@kernel.org> wrote:
> > >
> > > On Mon, Aug 02, 2021 at 04:31:01PM +0200, Haris Iqbal wrote:
> > > > On Mon, Aug 2, 2021 at 9:30 AM Leon Romanovsky <leon@kernel.org> wrote:
> > > > >
> > > > > On Fri, Jul 30, 2021 at 03:18:31PM +0200, Jack Wang wrote:
> > > > > > From: Md Haris Iqbal <haris.iqbal@cloud.ionos.com>
> > > > > >
> > > > > > This commit adds support to reject connection on a specific IB port which
> > > > > > can be specified in the added sysfs entry for the rtrs-server module.
> > > > > >
> > > > > > Example,
> > > > > >
> > > > > > $ echo "mlx4_0 1" > /sys/class/rtrs-server/ctl/disable_port
> > > > > >
> > > > > > When a connection request is received on the above IB port, rtrs_srv
> > > > > > rejects the connection and notifies the client to disable reconnection
> > > > > > attempts. A manual reconnect has to be triggerred in such a case.
> > > > > >
> > > > > > A manual reconnect can be triggered by doing the following,
> > > > > >
> > > > > > echo 1 > /sys/class/rtrs-client/blya/paths/<select-path>/reconnect
> > >
> > > <...>
> > >
> > > > >
> > > > > And maybe Jason thinks differently, but I don't feel comfortable with
> > > > > such new sysfs file at all.
> > >
> > > This part is much more important and should be cleared before resending.
> >
> > Agreed. I will wait for Jason to respond.
>
> Based on some past conversation with Greg I'm skeptical he would
> approve of this kind of usage of sysfs..
>
> It is also very strange that this is under a class directory, I'm
> starting to think it was a mistake to merge the original sysfs stuff
> :(
>
> Can you do this some other way?

I understand the discomfort. I will try to see if there is another way
to do this.

In the meanwhile, I will resend the other patches which has been reviewed.

Thanks.

>
> Jason
