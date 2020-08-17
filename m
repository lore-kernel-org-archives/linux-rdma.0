Return-Path: <SRS0=H3r4=B3=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EA48C433E1
	for <linux-rdma@archiver.kernel.org>; Mon, 17 Aug 2020 01:05:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 113DF206F4
	for <linux-rdma@archiver.kernel.org>; Mon, 17 Aug 2020 01:05:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="G+F+gn4A"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726340AbgHQBFS (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Sun, 16 Aug 2020 21:05:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726315AbgHQBFR (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Sun, 16 Aug 2020 21:05:17 -0400
Received: from mail-oi1-x244.google.com (mail-oi1-x244.google.com [IPv6:2607:f8b0:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 752F2C061786;
        Sun, 16 Aug 2020 18:05:17 -0700 (PDT)
Received: by mail-oi1-x244.google.com with SMTP id u63so13454400oie.5;
        Sun, 16 Aug 2020 18:05:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HzYop1XmyTCgbyOk5qIfQelbPJHN1NZbmzUN2Oj/Kk0=;
        b=G+F+gn4A7SR4aPjKnrQt48BT6CgKQygvaKOfEwRa6pRwQcinAxU5CBaNfA2hrulnAw
         rfGUWAgSP0CmasQkMzDaM4SEnpoJOuuqWxQOz+NrEZB85ZZCpZ8vvsKzKSqP5EURrGzC
         Bvusokb+dA2yW2EMMaBHgoKgU6/aUdQ9i8GLA2KcVq2JkBSWCqOHiyacKIFj8KyL9lZf
         YhmrrPcGBqpXGo08eWTxyRfdHq0UY8BSYVAWFKSZAGFfT3RZlnVXqEWuY3loq6jRp1HX
         jYkBJKwBHxehcYP571PLl9jF7Vx+DLWk3SnQ19+htVp4XKZrHxHZ53ynE9+ZplPIFeX8
         37Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HzYop1XmyTCgbyOk5qIfQelbPJHN1NZbmzUN2Oj/Kk0=;
        b=drG3cN4TOllSbF2rwecFQ5KEJ/xuQfi65Nq+wtY6oZYb7i91kugwiQcaJOh/GMZD6Z
         6eagmsu3vO3qRH4tSXD7eJzIMubJBZ3xna7y6u7vH8Bq4jCtc4FCcwnIopNT8Rt4+0rF
         0nWSGGehRfwjdBdIjzHy7kyDS2D961bALWvfwcPb2b8XHkMmMgMHgQNVgbnuKB5BVeMg
         1XSzyXCWA2+D7wYfOCrP6Lc/oMc3mVteAfaAxeWlxoxxzuD+ytqr4KBx1jYxoQFkc6mg
         1Kbz0pA9E21J0qcUfMoEOY9PHyE+FR2ld+ne06fI3pwraMxXHb6BxWx5Ejwq7AO/dz9i
         c4OQ==
X-Gm-Message-State: AOAM533gnbRgpt4plQOKOOJ08jorlGvfK8Uza5OVzXzaW/97JQ6Ch8si
        /5hrM7HosyQSGoc2+4stf0PNybFIp2VuSbqQDTE=
X-Google-Smtp-Source: ABdhPJyaXeGbXej2pBVF1NwUHSB6OMzkVnBYSQd07EBYYbu4npJ0BEEZ+FomGJ+X1rn0Ncsqv5iD47VMQhP72buJSE8=
X-Received: by 2002:aca:b286:: with SMTP id b128mr8239548oif.89.1597626315495;
 Sun, 16 Aug 2020 18:05:15 -0700 (PDT)
MIME-Version: 1.0
References: <1597555550-26300-1-git-send-email-yanjunz@mellanox.com> <20200816074521.GE7555@unreal>
In-Reply-To: <20200816074521.GE7555@unreal>
From:   Zhu Yanjun <zyjzyj2000@gmail.com>
Date:   Mon, 17 Aug 2020 09:05:04 +0800
Message-ID: <CAD=hENdbsLD+YKHqw4=hiTeLz3S-1_1pL9=PbpnkHKed2pDuOg@mail.gmail.com>
Subject: Re: [PATCH 1/1] MAINTAINERS: SOFT-ROCE: Change Zhu Yanjun's email address
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Zhu Yanjun <yanjunz@mellanox.com>, yanjunz@nvidia.com,
        linux-rdma@vger.kernel.org, Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>, netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Sun, Aug 16, 2020 at 3:45 PM Leon Romanovsky <leon@kernel.org> wrote:
>
> On Sun, Aug 16, 2020 at 01:25:50PM +0800, Zhu Yanjun wrote:
> > I prefer to use this email address for kernel related work.
> >
> > Signed-off-by: Zhu Yanjun <yanjunz@mellanox.com>
> > ---
> >  MAINTAINERS |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
>
> It was already handled.
> https://lore.kernel.org/lkml/20200810091100.243932-1-leon@kernel.org/

Cool!

>
> Thanks
