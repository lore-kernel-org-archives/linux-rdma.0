Return-Path: <SRS0=iZOS=3S=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6C3EC33CB2
	for <linux-rdma@archiver.kernel.org>; Wed, 29 Jan 2020 08:29:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9526F20720
	for <linux-rdma@archiver.kernel.org>; Wed, 29 Jan 2020 08:29:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="GWIfLJ4h"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726140AbgA2I3n (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 29 Jan 2020 03:29:43 -0500
Received: from mail-il1-f193.google.com ([209.85.166.193]:32775 "EHLO
        mail-il1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726068AbgA2I3m (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Wed, 29 Jan 2020 03:29:42 -0500
Received: by mail-il1-f193.google.com with SMTP id s18so12815896iln.0
        for <linux-rdma@vger.kernel.org>; Wed, 29 Jan 2020 00:29:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=C6JLgzdoXCSW5HUJ2Gm55NrEIWy1xHAL1605qJJ9+XE=;
        b=GWIfLJ4hpopQqIq4iqUZHV8f9pdsdkNmbe77kVxKaOgIr1BVCvD1vG5RuhZbUlzLFK
         H1QZqkQwsAk6Bpr4prsFN4G7/Xhx01Rp24S7SSJ5c6sbFGxLV7NwJnoQTLXyuaqrqDsz
         E+bjY9iKRHF4l3rmqwMHCzNKEHjLdPbizzgqU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=C6JLgzdoXCSW5HUJ2Gm55NrEIWy1xHAL1605qJJ9+XE=;
        b=iTzIAarbop+UwswaR+ugqURYtpnzX7FgzhBk74ST5mRnBNCWz2go8xuW+Hnyq5tP+V
         o9nFhnQNXkYiGQepL9T5qN4OzNV5pfpGvOpzwjhk4np/9zbJPglxFQMUdabQYaze8NG3
         ssW3OJDo5Grhctnj5qr/fsPEseHf4lG2VeIibKEpnItWXvIVyfbFmHY8+0OERkTknxKx
         5mhAYgxTpUW7/Fnasl94NByzH4RnHttzEs/31yRFQFathUIJYqMPq5bfywVd3k5nWuE5
         YACvRdu+S4bqCfIb0chr41AtXq9uYoYN4FKBZ9Pd5QhNuTgSaHqzWDH4VdgYpDJgCkVl
         FvnA==
X-Gm-Message-State: APjAAAXwWZ1ihPqnsJbsIBvYHaC1lRYZKksqPZon59JpeRyxeINzi4L7
        okHZr/YxcrsbQ29QR5O0AoXRepLevfyja89ZdMkqqd6f
X-Google-Smtp-Source: APXvYqxhQ4KMJsxEacmKDjpzg3IKwv+tWMh+lfvpsD9fW5JCzTP/UUSUXF3LH4w/oNJiQSzIth0dhYAWtwNy9utbPqk=
X-Received: by 2002:a92:9ac5:: with SMTP id c66mr16058601ill.232.1580286582002;
 Wed, 29 Jan 2020 00:29:42 -0800 (PST)
MIME-Version: 1.0
References: <1579845165-18002-1-git-send-email-devesh.sharma@broadcom.com>
 <1579845165-18002-5-git-send-email-devesh.sharma@broadcom.com>
 <20200126142928.GG2993@unreal> <CANjDDBhxVC0ps8ee5NTW3QrN9bFNVdEcwxS2=Kfn1uOfDR2v_A@mail.gmail.com>
 <20200128003537.GD21192@mellanox.com> <CANjDDBiKijeKZHr7uRO0gO9B+MPOwFBx6F+EDBdGF1QEXc+seQ@mail.gmail.com>
 <20200128180927.GM21192@mellanox.com>
In-Reply-To: <20200128180927.GM21192@mellanox.com>
From:   Devesh Sharma <devesh.sharma@broadcom.com>
Date:   Wed, 29 Jan 2020 13:59:05 +0530
Message-ID: <CANjDDBiB30O8tEE8YswL11uyquDozp3hxjvRgsDhXHHE8yTevA@mail.gmail.com>
Subject: Re: [PATCH for-next 4/7] RDMA/bnxt_re: Refactor net ring allocation function
To:     Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leon@kernel.org>,
        linux-rdma <linux-rdma@vger.kernel.org>,
        Doug Ledford <dledford@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Tue, Jan 28, 2020 at 11:39 PM Jason Gunthorpe <jgg@mellanox.com> wrote:
>
> On Tue, Jan 28, 2020 at 08:13:31AM +0530, Devesh Sharma wrote:
> > On Tue, Jan 28, 2020 at 6:05 AM Jason Gunthorpe <jgg@mellanox.com> wrote:
> > >
> > > On Mon, Jan 27, 2020 at 01:10:10PM +0530, Devesh Sharma wrote:
> > > > > >  static int bnxt_re_alloc_res(struct bnxt_re_dev *rdev)
> > > > > >  {
> > > > > > +     struct bnxt_qplib_ctx *qplib_ctx;
> > > > > > +     struct bnxt_re_ring_attr rattr;
> > > > > >       int num_vec_created = 0;
> > > > > > -     dma_addr_t *pg_map;
> > > > > >       int rc = 0, i;
> > > > > > -     int pages;
> > > > > >       u8 type;
> > > > > >
> > > > > > +     memset(&rattr, 0, sizeof(rattr));
> > > > >
> > > > > Initialize rattr to zero from the beginning and save call to memset.
> > > > I moved from static initialization to memset due to some sparse/smatch
> > > > warnings, rattr has a "pointer member".
> > >
> > > That is why you need to use = {} not the weird '= {0}' version
> > >
> > > 0 initializes the first member to zero and default initializes the rest
> > > which doesn't work properly if the first member is not an integral
> > > value.
>
> > So should I remove memset(s) in v2?
>
> I would
>
Doing it already :-)
> Jason
