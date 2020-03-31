Return-Path: <SRS0=zI+0=5Q=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00B56C2D0E8
	for <linux-rdma@archiver.kernel.org>; Tue, 31 Mar 2020 09:25:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CBB6720658
	for <linux-rdma@archiver.kernel.org>; Tue, 31 Mar 2020 09:25:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.b="JZYOLuFq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729950AbgCaJZt (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 31 Mar 2020 05:25:49 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:41441 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730333AbgCaJZt (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Tue, 31 Mar 2020 05:25:49 -0400
Received: by mail-io1-f66.google.com with SMTP id b12so4751003ion.8
        for <linux-rdma@vger.kernel.org>; Tue, 31 Mar 2020 02:25:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dgvMDDhThjaROj+XyCbfwyfC/pKcEAvrZy4EYNbMoJg=;
        b=JZYOLuFqtdxwwa61K5jEn89fE3mnfJ4zOEC1+/RZ2Za+wdY7J26+x5TKJhVx+8Pbr3
         M544KBicEgBE5cG2UFME1O8+sndbtBz7U4PDMj0Ut098A0Wc98ioZtkNUnXR6aHzvGtx
         ZO2xF+jLA/+4MbYDFUMObKlWgaBb/5ys1SgcLp+DLBbnRxugynraYrxkOWjcqrP+WIio
         TtRaqSVjlwMA9Yr65cgWNYJEqnc1sQhmqr6d649Dk5vhY+KPINDZahU9w8qbzhgW/yXk
         0nbrehJH1xFa+mZuoRmYdMH7uBT77JhH+JKdRs6PWIUxTFk6lwqUkxrFJE5YkN12W5G7
         7RaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dgvMDDhThjaROj+XyCbfwyfC/pKcEAvrZy4EYNbMoJg=;
        b=lO9tRei7Lj/xzzQ0yZi49qo61mqkzcy+o0Un2BHrP+lPgbRdz6axrHdn4mFfhKXHuj
         uBKKYAtWda1rWVhytzlb1XTUB0fpyVmhShQ4WyAziOg3hLNYwAyrXTnJKT+R9v2wMJFT
         coXcZXvYHttnB6Kd/B/jB4HqdyvfSZnaxODV4j/beV10JSiZgWDdW+1DhmHmCInKPC74
         CMht1aEfFxacfPBUuKQ/l2dDBB8YGFcoTSU/ALjkPgJRgu5lgsqbQeVSkOKaZo40WJNe
         T8CggjLKraiTMnjtmx4CHOIPMqfdPmQZAFp6iNkUeruiN2mVxp5u4Mg6u8rqol2n1nWm
         LoKw==
X-Gm-Message-State: ANhLgQ2oTBJV60/LDlyo1t6JKGqK4qS7Dq6x+GG11ZgbV3xvKFqQgFbM
        0aoPabPQ4zFKx5R32MQ7Iu4X3UqjVUSrGoZVrDQi2A==
X-Google-Smtp-Source: ADFU+vu4TdmyEcsfEHMn5Mag9Mq/Yq+eZYHJ7KcexkzThTebIOzew33m4dkOJdQloFfnQ2D8sLIeIzz3vHVjNiDL4AQ=
X-Received: by 2002:a02:3b0d:: with SMTP id c13mr15197757jaa.85.1585646746793;
 Tue, 31 Mar 2020 02:25:46 -0700 (PDT)
MIME-Version: 1.0
References: <20200320121657.1165-1-jinpu.wang@cloud.ionos.com>
 <20200320121657.1165-19-jinpu.wang@cloud.ionos.com> <27b4e9a5-826f-d323-3d19-3f64c79e03eb@acm.org>
In-Reply-To: <27b4e9a5-826f-d323-3d19-3f64c79e03eb@acm.org>
From:   Jinpu Wang <jinpu.wang@cloud.ionos.com>
Date:   Tue, 31 Mar 2020 11:25:36 +0200
Message-ID: <CAMGffEmWPyBAHWJpkVvWuptgoX0tw4rs4jJH1TuJ0jRrkMBdYQ@mail.gmail.com>
Subject: Re: [PATCH v11 18/26] block/rnbd: client: main functionality
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     linux-block@vger.kernel.org, linux-rdma@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>,
        Christoph Hellwig <hch@infradead.org>,
        Sagi Grimberg <sagi@grimberg.me>,
        Leon Romanovsky <leon@kernel.org>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Danil Kipnis <danil.kipnis@cloud.ionos.com>,
        Roman Penyaev <rpenyaev@suse.de>,
        Pankaj Gupta <pankaj.gupta@cloud.ionos.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Sat, Mar 28, 2020 at 5:59 AM Bart Van Assche <bvanassche@acm.org> wrote:
>
> On 2020-03-20 05:16, Jack Wang wrote:
> > +     /*
> > +      * Nothing was found, establish rtrs connection and proceed further.
> > +      */
> > +     sess->rtrs = rtrs_clt_open(&rtrs_ops, sessname,
> > +                                  paths, path_cnt, RTRS_PORT,
> > +                                  sizeof(struct rnbd_iu),
> > +                                  RECONNECT_DELAY, BMAX_SEGMENTS,
> > +                                  MAX_RECONNECTS);
>
> Is the server port number perhaps hardcoded in the above code?
Yes, we should have introduced a module parameter for rnbd-clt too, so
if admin changes port_nr, it's possible to change it also on rnbd-clt.

Thanks Bart!
