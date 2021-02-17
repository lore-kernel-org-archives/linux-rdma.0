Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4A1FC433E9
	for <linux-rdma@archiver.kernel.org>; Wed, 17 Feb 2021 06:37:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4FBEA64E2B
	for <linux-rdma@archiver.kernel.org>; Wed, 17 Feb 2021 06:37:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231444AbhBQGhl (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 17 Feb 2021 01:37:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbhBQGhj (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Wed, 17 Feb 2021 01:37:39 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31AB4C061574
        for <linux-rdma@vger.kernel.org>; Tue, 16 Feb 2021 22:36:59 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id g5so16856107ejt.2
        for <linux-rdma@vger.kernel.org>; Tue, 16 Feb 2021 22:36:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tCs6nlP9UWOg7Ku+uj0nbENM0wpT2YYYtJ2g2ZjAZKE=;
        b=Lijxsn012rt7Hw9fQx9JWl4zat589U/0bWhv1zvlGztsRFRNK2pZ62oezo2wXrkQwR
         tqIgN2tYRnnFBg9fvTDhGLQSDwsEqvyR0gQZDiFBVqpxMZ5VaJTTChUdwFE2l+2cNWos
         BZppYyHGyagdXeW1hj9gegdqkf/YNZj5wLZKUfgO7vf/obX0PjMfIq6ZwqzsfxlbrhI9
         zmhJP4aHYcak7z9v0Zd4oavSXYWrW/5fjPnloFIlhSo7+d0efT8fWzvvanVQmvMhDCZO
         Hf7coObGSePoMze4niKi/6t/TKzMiZ0MQm4S9PyL9lsI1fBEZKOgNsBUJTA32RGH7Fn6
         iVaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tCs6nlP9UWOg7Ku+uj0nbENM0wpT2YYYtJ2g2ZjAZKE=;
        b=npHuLxiIAypRXqXWHb1wwWdrQyl2pswHcRAimMx398VCAV5kqwPLkPAk+MUSA7W+YE
         MUbA9hg0HwBMw09LRqYIYPfP7eyOS02S0izaA0YZHdDqtDlj5DeL2b5QcuhzrbMlegGK
         dv84uuh7v632piZolV3SmaUdflKtlSmMbWn1Y5RXhDiVB/U6LTUecVb3cD0FkF6RSZYh
         CMD1QgzTbnHnY7LVnxLg0G1UR8izQPFYThcBARZNNsIaQ7TTko7I9/tJvBWM5MkOgmcu
         kL1uWMP0sWQfgetxvZbG44Ygv4Ggjxyt193JAvyIJz9zBx/3fAK3LByZ0p51F4HOHBbX
         W8PQ==
X-Gm-Message-State: AOAM531NqkDQSj2VKmFw/b7nUdv3KaWF9DJl2AbKZxTgyDzqCGzc6iZS
        AyAu+QJ6pAppLFXzw9gO+mjWq4wkjaimT2a9zVl/xQ==
X-Google-Smtp-Source: ABdhPJx522HRXxRCHOAypSbPKn6RzI8QMBoeyn5lfsuZch1qZdyzstuCxfcGVnmJeeTur2YXJ2RlHT9nzXwIAoqhNws=
X-Received: by 2002:a17:906:3456:: with SMTP id d22mr13955389ejb.115.1613543817725;
 Tue, 16 Feb 2021 22:36:57 -0800 (PST)
MIME-Version: 1.0
References: <20210216143807.65923-1-jinpu.wang@cloud.ionos.com> <20210216144938.GG2222@kadam>
In-Reply-To: <20210216144938.GG2222@kadam>
From:   Jinpu Wang <jinpu.wang@cloud.ionos.com>
Date:   Wed, 17 Feb 2021 07:36:47 +0100
Message-ID: <CAMGffEnRLV9cO-LE1tpfY6=dynZR50rDODPn+Be2ydWZkdNxow@mail.gmail.com>
Subject: Re: [PATCH] RDMA/rtrs-srv: Suppress warnings passing zero to 'PTR_ERR'
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     linux-rdma@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Leon Romanovsky <leon@kernel.org>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Danil Kipnis <danil.kipnis@cloud.ionos.com>,
        kernel test robot <lkp@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Tue, Feb 16, 2021 at 3:49 PM Dan Carpenter <dan.carpenter@oracle.com> wrote:
>
> On Tue, Feb 16, 2021 at 03:38:07PM +0100, Jack Wang wrote:
> > smatch warnings:
> > drivers/infiniband/ulp/rtrs/rtrs-srv.c:1805 rtrs_rdma_connect() warn: passing zero to 'PTR_ERR'
> >
> > Smatch seems confused by the refcount_read condition, the solution is
> > protect move the list_add down after full initilization of rtrs_srv.
>
> In theory if Smatch had a properly up to date DB then it would print a
> different warning "passing a valid pointer to PTR_ERR()".
That will be easier to follow :)
>
> regards,
> dan carpenter
>
Thanks!
