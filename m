Return-Path: <SRS0=/a3O=ZZ=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B136C432C3
	for <linux-rdma@archiver.kernel.org>; Tue,  3 Dec 2019 18:33:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E0D6F20637
	for <linux-rdma@archiver.kernel.org>; Tue,  3 Dec 2019 18:33:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LMYqa1ls"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726741AbfLCSdK (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 3 Dec 2019 13:33:10 -0500
Received: from mail-io1-f67.google.com ([209.85.166.67]:46087 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726057AbfLCSdK (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Tue, 3 Dec 2019 13:33:10 -0500
Received: by mail-io1-f67.google.com with SMTP id i11so4823932iol.13
        for <linux-rdma@vger.kernel.org>; Tue, 03 Dec 2019 10:33:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DM0ZKvBsebvlDMUIQZhcODMOVPA8hHr63fCXOyp0vS8=;
        b=LMYqa1lsSfDHXt8q0R6epQBV7toU4SVgqyP0qZ4JrvF8aU/+ynEothKpef/p3HXXGN
         Ri80793bsuvcQQyMhPZpg+trodCMEKKvJmYNgQSkp/Xygiu2S0GuVfhltB/iXDEi2lQi
         rhCw+jLOwotQKvREsBoK3a/nGeOev6u1iXL48nf1Sg2SsKW39hrlAr6Rk2vOXHEYlch7
         rpvhWPEOjOhgTjtxd4a1mZSLhyS/6FKk5osZ1DLb1Q+LdjyKGRMKZZvFveu4hj8esUqh
         9uRaa+LWihYPBvTyY9KEjufn3b8SxTXMRDUa9pxIU1G6Mb71uziR6D0t7MApINH83c6v
         c5Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DM0ZKvBsebvlDMUIQZhcODMOVPA8hHr63fCXOyp0vS8=;
        b=Nyg973MtWR3lZPnRO0t2gQftCl2BEQ3RB+5QuPH5jfRU0ZIwiyn6HB0e1JZ1TVJm7M
         YXVkSJ/KgjaQlUYlIZZhzTWEs44hZZfYjxwrbE7SXLyROXZZy4Rweg1hEKnUaRpMyTe6
         sRgQIeD7BHlEEp5okCivuSj9F0Gto3LDSO+Oul1d5A1X951ajLb8hwlkS0wnVar5w9em
         vRbvyGHuhEB1qHHDjIyRk3/YF9D1gMktXd6z8MtxgzN4s9MaA5r9X3Jsy7UfPI7zcezV
         ziOxXo7ifgNpo5e8UiLj7OxuQWKQ6ZCsZjUUdEon6JjkIX9Fff86g+RSaaK7ERYVQVLd
         zr+Q==
X-Gm-Message-State: APjAAAVB8GaJxIsUh5yDySiW7lCqv5P3wHsT6oKG2sW14i8mwglhOqQc
        Qa2HWRNyd7PryYEuk43WCaml1m6BBRNinrXwePM=
X-Google-Smtp-Source: APXvYqwnv0gEhnt2U9QrVnr8sU0NFDyCy9lXh42/KH7VEgWsL25n7Cnfgmb5SIxMA4YeGWabvd2e4qRRRvW+bIDiTC8=
X-Received: by 2002:a02:6944:: with SMTP id e65mr6653422jac.11.1575397989417;
 Tue, 03 Dec 2019 10:33:09 -0800 (PST)
MIME-Version: 1.0
References: <20191203020319.15036-1-larrystevenwise@gmail.com>
 <20191203020319.15036-2-larrystevenwise@gmail.com> <a0003c88-10f5-c14a-220d-c100fa160163@acm.org>
In-Reply-To: <a0003c88-10f5-c14a-220d-c100fa160163@acm.org>
From:   Steve Wise <larrystevenwise@gmail.com>
Date:   Tue, 3 Dec 2019 12:32:58 -0600
Message-ID: <CADmRdJfGBt-k1uXZK3Uvjkj0hyCOoPjBzxx_UmRKUq7rcQ1ouQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] rxe: correctly calculate iCRC for unaligned payloads
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     linux-rdma <linux-rdma@vger.kernel.org>,
        wangqi <3100102071@zju.edu.cn>, Leon Romanovsky <leon@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Tue, Dec 3, 2019 at 10:25 AM Bart Van Assche <bvanassche@acm.org> wrote:
>
> On 12/2/19 6:03 PM, Steve Wise wrote:
> > If RoCE PDUs being sent or received contain pad bytes, then the iCRC
> > is miscalculated resulting PDUs being emitted by RXE with an incorrect
> > iCRC, as well as ingress PDUs being dropped due to erroneously detecting
> > a bad iCRC in the PDU.  The fix is to include the pad bytes, if any,
> > in iCRC computations.
>
> Should this description mention that this patch breaks compatibility
> with SoftRoCE drivers that do not include this fix? Do we need a kernel
> module parameter that allows to select either the old or the new behavior?
>

Good point.  I defer to others on how they want to handle that.

> > CC: bvanassche@acm.org,3100102071@zju.edu.cn,leon@kernel.org
>
> Should this Cc-line perhaps be converted into three Cc-lines?

Yea I screwed this up.   I really didn't want this in the commit log
vs just CCing on the email submission, but I was having issues with
git send-email.  Pilot error. ;)


Stevo
