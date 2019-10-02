Return-Path: <SRS0=/rP3=X3=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9F55C35280
	for <linux-rdma@archiver.kernel.org>; Wed,  2 Oct 2019 15:15:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C0C2321920
	for <linux-rdma@archiver.kernel.org>; Wed,  2 Oct 2019 15:15:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.b="LjDUFAgR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728164AbfJBPPY (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 2 Oct 2019 11:15:24 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:35090 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725893AbfJBPPX (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Wed, 2 Oct 2019 11:15:23 -0400
Received: by mail-wm1-f65.google.com with SMTP id y21so7412896wmi.0
        for <linux-rdma@vger.kernel.org>; Wed, 02 Oct 2019 08:15:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gCeYxxWGqu4H261nZ/Kv5iczycPoUyJg2oSaDolu7gM=;
        b=LjDUFAgRLILpxmhwZg4/ZJUJ2OUU7wdxWuKZ6VUgEu7PUnsKFfCYTE9IVWyNuevkBO
         pBVqPLv0P6DE3Ai4tCIKcqsrLRTZNBQ/1rJ5clY4gikofrb68BifYJnz3N+yhO8tOnw9
         CeMkJ1PfTPjXO89D3qhU4gWsq3VTQH/mne5TYJ0+T65tXJtNn6QKMIZakcFZHNTMJXzk
         yD0UCQIVhK/e7rOP8YYKnQX89NaBvdNQW0x8bw42iVJlaGh4/3/bHWsvr7SoYN8XMt2y
         U+rV0+8MThlAWHM2QDqpUvUoIYti6hv1z9w4ZR2Eu6K7UjjBeLSf/7GRhYwlbv/6hyL+
         Sd8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gCeYxxWGqu4H261nZ/Kv5iczycPoUyJg2oSaDolu7gM=;
        b=o6/k9oRjjUsvDaetVQzmKPuSWRnU0i4JS52sx24yfiWKAct7m4DDV75DOkf2Sg7bHY
         MHQj5dQWTJOdL88qYI3KZ0RdLoYtKU4xn+RY9CgJDw1KeUfytLDCyBwSUuDCj26piskM
         HRvao/9EplA3sxB+avxDnY9h9he9MepZE1x6aqTUrMgR/isjt9UI/GYkDzRUNcxAtzub
         aCRJsCq3fhSrS+ZQGcTqkDcLFOSoiMURhTmBBsVXCNKoAxGkjZfOQ56o0SSXLeV1obf7
         UGFQkuJN52T9K99ayMbST9tupRvZgaMfm0e07CqAv0r2FY+A9kH/B7IIVe/LGDrLGeyz
         RYLQ==
X-Gm-Message-State: APjAAAXrwqCDRCYeqQn92DX/t/SxGvgeizJMl4WWpsACuoGJxcHs2G+0
        r4M2mA8G9fQMTHaPSdElPGpZx26M2It7bsiYQOyvKw==
X-Google-Smtp-Source: APXvYqwUICB5HNOgqN+UEb5CMQzWU5E3xd9myBBnnlKBSiHKqmz/8YiGf6iJyWEPRrqrDPTyauO2+yKIBwytUQD57mw=
X-Received: by 2002:a1c:4485:: with SMTP id r127mr3136949wma.59.1570029321609;
 Wed, 02 Oct 2019 08:15:21 -0700 (PDT)
MIME-Version: 1.0
References: <20190620150337.7847-1-jinpuwang@gmail.com> <20190620150337.7847-12-jinpuwang@gmail.com>
 <8477e5d5-036b-f3b5-976b-624b811baf38@acm.org>
In-Reply-To: <8477e5d5-036b-f3b5-976b-624b811baf38@acm.org>
From:   Jinpu Wang <jinpu.wang@cloud.ionos.com>
Date:   Wed, 2 Oct 2019 17:15:10 +0200
Message-ID: <CAMGffE=dBo-yZVOvyjyeauEEHzHOjmgtOjGKB+GiQiSoMX7Sig@mail.gmail.com>
Subject: Re: [PATCH v4 11/25] ibtrs: server: statistics functions
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     Jack Wang <jinpuwang@gmail.com>, linux-block@vger.kernel.org,
        linux-rdma@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Christoph Hellwig <hch@infradead.org>,
        Sagi Grimberg <sagi@grimberg.me>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Doug Ledford <dledford@redhat.com>,
        Danil Kipnis <danil.kipnis@cloud.ionos.com>, rpenyaev@suse.de
Content-Type: text/plain; charset="UTF-8"
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Tue, Sep 24, 2019 at 1:56 AM Bart Van Assche <bvanassche@acm.org> wrote:
>
> On 6/20/19 8:03 AM, Jack Wang wrote:
> > +ssize_t ibtrs_srv_stats_rdma_to_str(struct ibtrs_srv_stats *stats,
> > +                                 char *page, size_t len)
> > +{
> > +     struct ibtrs_srv_stats_rdma_stats *r = &stats->rdma_stats;
> > +     struct ibtrs_srv_sess *sess;
> > +
> > +     sess = container_of(stats, typeof(*sess), stats);
> > +
> > +     return scnprintf(page, len, "%lld %lld %lld %lld %u\n",
> > +                      (s64)atomic64_read(&r->dir[READ].cnt),
> > +                      (s64)atomic64_read(&r->dir[READ].size_total),
> > +                      (s64)atomic64_read(&r->dir[WRITE].cnt),
> > +                      (s64)atomic64_read(&r->dir[WRITE].size_total),
> > +                      atomic_read(&sess->ids_inflight));
> > +}
>
> Does this follow the sysfs one-value-per-file rule? See also
> Documentation/filesystems/sysfs.txt.
>
> Thanks,
>
> Bart.
It looks overkill to create one file for each value to me, and there
are enough stats in sysfs contain multiple values.

Thanks
Jinpu
