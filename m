Return-Path: <SRS0=8+f9=6E=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 087EFC3815B
	for <linux-rdma@archiver.kernel.org>; Mon, 20 Apr 2020 06:52:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D2A5322247
	for <linux-rdma@archiver.kernel.org>; Mon, 20 Apr 2020 06:52:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.b="VqkENRhP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725991AbgDTGw1 (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 20 Apr 2020 02:52:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725815AbgDTGw0 (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>);
        Mon, 20 Apr 2020 02:52:26 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D480C061A0C
        for <linux-rdma@vger.kernel.org>; Sun, 19 Apr 2020 23:52:25 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id b18so8714370ilf.2
        for <linux-rdma@vger.kernel.org>; Sun, 19 Apr 2020 23:52:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/F/zV1JGwLIRMB54WRyhqQKlp9+/VLvBYQvEIujoXX4=;
        b=VqkENRhPB9R/kCQ3O9qvUQESenmhBXdb6yly7yyPmcdrsC5lrFQVEdRRFRJX7n/y98
         34oY7kyHqjlgCXTMiBVq3bQ70NULShByzn8HaVLRcR2oDinnnFheRxwILRCaO9yYtIyE
         wJ9W6cZpw4X0mGtZS1jvENMV+nYER/WHX9YoD82ld0gm6o43LNZoqjfJuTo0MgPAYpZj
         W+nSD3gZH8vZmujvmM8fKds3CJL3pRbnrtNFY+qyoyAz7KJ94BCELylu291z7mgpEmlh
         fGdpQh0rWDAvcUEOcBfQlI+UumV81sR2+jB4Slsh2AbxgOAL/J2h4Cxf6tv4hpNHYgWe
         h4uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/F/zV1JGwLIRMB54WRyhqQKlp9+/VLvBYQvEIujoXX4=;
        b=fDdbCJza1j6Z+017d51EfGvmOXaAHLHagmzQqaZu1NpOxbjR1cE2+Y2Tsp/zDvH3ZD
         yKHKosFqvy/vLRbSUtkiycAByPs2ViHuRxgBhce3CJXW/nGNwmMvvX5Yln6uSoAEtkJi
         KcHM68afycp2V0jPrD80klpjVLF+5kjqc5T9PckPA3r7OHnLnkSmuYWgf4HfxT74Nf+B
         WISnW8HJVy5yoil+I5vsfkZwzpJGssieuj9sLamCxUxqWzHLN6M87cHrVM08Dm4GRFGN
         X77Psix4ik+HBx5qJH2oct/kPElnEjqR8Ji06Su+MUjFqV44YY5KOCtN3Az1GNQx7cw3
         w4fw==
X-Gm-Message-State: AGi0PubHWvdt5m4jWsk/q4Nlh6aX6IoUwiyiKCMpAHfD4b4VGSTbCbtQ
        UkSshy+QbZo7XjGR2VbB6VIulhK70FTb2ZXg0WBjuw==
X-Google-Smtp-Source: APiQypIEgyNRuGxSxsUssAa3+zhYUa9Oi/Adhns9pj8iPzaFLdOgsPi7M3ozljhEiupcojPDlg+/yDBQTnALfcYfsY4=
X-Received: by 2002:a92:485b:: with SMTP id v88mr14338041ila.271.1587365544816;
 Sun, 19 Apr 2020 23:52:24 -0700 (PDT)
MIME-Version: 1.0
References: <20200415092045.4729-1-danil.kipnis@cloud.ionos.com>
 <20200415092045.4729-21-danil.kipnis@cloud.ionos.com> <e6c0d434-2dac-4a41-912b-bf09d5d98a0c@acm.org>
In-Reply-To: <e6c0d434-2dac-4a41-912b-bf09d5d98a0c@acm.org>
From:   Jinpu Wang <jinpu.wang@cloud.ionos.com>
Date:   Mon, 20 Apr 2020 08:52:16 +0200
Message-ID: <CAMGffEnjR52Km-SNp5NNSYXVLzEobU0pdwTTo4u0oe57GdEUQg@mail.gmail.com>
Subject: Re: [PATCH v12 20/25] block/rnbd: server: main functionality
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     Danil Kipnis <danil.kipnis@cloud.ionos.com>,
        linux-block@vger.kernel.org, linux-rdma@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>,
        Christoph Hellwig <hch@infradead.org>,
        Sagi Grimberg <sagi@grimberg.me>,
        Leon Romanovsky <leon@kernel.org>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Pankaj Gupta <pankaj.gupta@cloud.ionos.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Sun, Apr 19, 2020 at 1:34 AM Bart Van Assche <bvanassche@acm.org> wrote:
>
> On 4/15/20 2:20 AM, Danil Kipnis wrote:
> > This is main functionality of rnbd-server module, which handles RTRS
> > events and rnbd protocol requests, like map (open) or unmap (close)
> > device.  Also server side is responsible for processing incoming IBTRS
> > IO requests and forward them to local mapped devices.
>
> Reviewed-by: Bart Van Assche <bvanassche@acm.org>
>
Thanks Bart!
