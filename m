Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA951C433DB
	for <linux-rdma@archiver.kernel.org>; Wed, 24 Mar 2021 09:47:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7E433619B4
	for <linux-rdma@archiver.kernel.org>; Wed, 24 Mar 2021 09:47:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229779AbhCXJqa (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 24 Mar 2021 05:46:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229935AbhCXJqA (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Wed, 24 Mar 2021 05:46:00 -0400
Received: from mail-oi1-x233.google.com (mail-oi1-x233.google.com [IPv6:2607:f8b0:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 182ADC061763
        for <linux-rdma@vger.kernel.org>; Wed, 24 Mar 2021 02:46:00 -0700 (PDT)
Received: by mail-oi1-x233.google.com with SMTP id i81so18675018oif.6
        for <linux-rdma@vger.kernel.org>; Wed, 24 Mar 2021 02:46:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rOw8BSt+dZww3seElXKf/WKP9Juo2c7PRU4NCeAiicg=;
        b=kn4FK5UvNiXxyFgFR6ywmJGmdKfB8yyGHGsltzgKJHKELEDSOxcK2/tbAfAtJsK74c
         0SqXvAUIJSwEQtRVPuDIkDmjar9KBuOHIA84dO6pkgG5G40wfccC9Hh2aRCSDfdKBwhi
         Rw0E/K7JViKvcQYl/alhEGZU++7W6OXSa743qt4eET4SRKhqpI3x50XCGhRRuVOq3Meq
         c6KQP08NI/nl0TLQ5ME7HRdD+fBtDo0N4nA7HVH70iH3/hOCe1o3WEkCNUmrtQg9XOYp
         /YlIlz8T4LltZPD10qDmK3Fl2C53TRci2/axXNZ5fLmG/u0A0K+rJdSo/QaJMICUhbob
         wpXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rOw8BSt+dZww3seElXKf/WKP9Juo2c7PRU4NCeAiicg=;
        b=kIsZI6GHqDFcFAIFnMbIScHmcVPpnxDeGqVp4A9s3+Cz7gHzI7taZmHzNGN517QEql
         daO7EuzyeJ6NvekzLuMCvuZF7Bb2Ke4TqiCqDnHmtHJn54InXZLT3Xpa4n1zzPdbJUEl
         +DCgBWkFru99liG8tNbby+mNDVtgCxXS2VW8CsMa5jqG78wDXtgA78hmJEJjKAEVsieM
         alEPObFi+JatRhJUOVarB+FPt1cjycdplx0uzsKbx0aWEID7PpUfpUfx9W3CA8fPvVXU
         +GlnjpomUvtmkky12gQlzOw4ODSMsycsEKxPGgP8XDLUIcbnhJWDM7jtfQB6L/CLg/46
         4SxA==
X-Gm-Message-State: AOAM53066Tmkx608QBYzsKSPDPDY4fqnDf6rlj1jE7UfWkwwEFT+F7N9
        p+/l9S0z2rKf1x98sGBnCU1CME+GSQamr9DQkcg=
X-Google-Smtp-Source: ABdhPJyk4P87DmIzoK/iFcQptwNhR52rvGEsSNXmDBy2kOoaYfkHbGDyaafsvrzzuYkIY19m3dJN11XjK6HPrSvnw/0=
X-Received: by 2002:aca:4785:: with SMTP id u127mr1672438oia.163.1616579159480;
 Wed, 24 Mar 2021 02:45:59 -0700 (PDT)
MIME-Version: 1.0
References: <20210307004256.7082-1-yanjun.zhu@intel.com> <CAD=hENeugBS6mGMwqMV+zXrOMSZFk_num3wAYRyD6YJhkfXDcw@mail.gmail.com>
 <20210323195334.GA398506@nvidia.com>
In-Reply-To: <20210323195334.GA398506@nvidia.com>
From:   Zhu Yanjun <zyjzyj2000@gmail.com>
Date:   Wed, 24 Mar 2021 17:45:48 +0800
Message-ID: <CAD=hENekc4+3Rv6Q1X1TQ1kD5fyckfRRk5CqqgGQOPMeT6W82A@mail.gmail.com>
Subject: Re: Fwd: [PATCHv2 1/1] RDMA/rxe: Disable ipv6 features when
 ipv6.disable set in cmdline
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Yi Zhang <yi.zhang@redhat.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Wed, Mar 24, 2021 at 3:53 AM Jason Gunthorpe <jgg@nvidia.com> wrote:
>
> On Sun, Mar 07, 2021 at 12:59:07AM +0800, Zhu Yanjun wrote:
> > From: Zhu Yanjun <zyjzyj2000@gmail.com>
> >
> > When ipv6.disable=1 is set in cmdline, ipv6 is actually disabled
> > in the stack. As such, the operations of ipv6 in RXE will fail.
> > So ipv6 features in RXE should also be disabled in RXE.
> >
> > Fixes: 8700e3e7c4857 ("Soft RoCE driver")
> > Reported-by: Yi Zhang <yi.zhang@redhat.com>
> > Signed-off-by: Zhu Yanjun <zyjzyj2000@gmail.com>
> > Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
> > Tested-by: Yi Zhang <yi.zhang@redhat.com>
> > V1->V2: Modify the pr_info messages
> >  drivers/infiniband/sw/rxe/rxe_net.c | 9 +++++++++
> >  1 file changed, 9 insertions(+)
> >
> > diff --git a/drivers/infiniband/sw/rxe/rxe_net.c
> > b/drivers/infiniband/sw/rxe/rxe_net.c
> > index 0701bd1ffd1a..6ef092cb575e 100644
> > +++ b/drivers/infiniband/sw/rxe/rxe_net.c
> > @@ -72,6 +72,11 @@ static struct dst_entry *rxe_find_route6(struct
> > net_device *ndev,
> >         struct dst_entry *ndst;
> >         struct flowi6 fl6 = { { 0 } };
> >
> > +       if (!ipv6_mod_enabled()) {
> > +               pr_info("IPv6 is disabled");
> > +               return NULL;
> > +       }
>
> Why doesn't a similar touch of ipv6_stub in
> drivers/infiniband/core/addr.c need a similar protection?

Got it. This patch is for RXE.

I will make a similar commit of ipv6_stub in
drivers/infiniband/core/addr.c soon.

>
> Also do not print.

I will remove print in the next patch.

Zhu Yanjun

>
> Jason
