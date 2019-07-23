Return-Path: <SRS0=t5r7=VU=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7004C7618E
	for <linux-rdma@archiver.kernel.org>; Tue, 23 Jul 2019 12:34:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 85B62223A1
	for <linux-rdma@archiver.kernel.org>; Tue, 23 Jul 2019 12:34:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="XGStVuHc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732235AbfGWMeG (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 23 Jul 2019 08:34:06 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:36408 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732230AbfGWMeG (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Tue, 23 Jul 2019 08:34:06 -0400
Received: by mail-qt1-f193.google.com with SMTP id z4so41734093qtc.3
        for <linux-rdma@vger.kernel.org>; Tue, 23 Jul 2019 05:34:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=4z6g9JExYRcJA0cyMB6yiS2IpKsEL90puRfSbLhNOYM=;
        b=XGStVuHcJ4wYu5EkGucnWz0qyLQPnOTtZqcARydulA7t9Ltx1lhLXGgV8Z2XduZicZ
         xd5wu0OKMXkjcax/8x3LH30ryZwpioRAwsQ3V7xMq1Ciepu12twvmW8XlTTwtYCXolge
         D91/c66cXBLOyYAMwxtWBJregnyDRwWMGle1KoOI3dX3A/2obklREelH5IVhrUXHvTw3
         8tOemeLX+4Uln09N0Cg06tdLBr/VhglARToykSGyCF2NSFuHW0gZY1pjNOzLpZiRFfnB
         uHVhv2+8uyrIUtD1uutViUZvSabCMm1x0Md5hfEA2mGZrPd1bqG1XIagtJ9qph2alxj4
         tMHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=4z6g9JExYRcJA0cyMB6yiS2IpKsEL90puRfSbLhNOYM=;
        b=l7vYnMeb+JtDtfXcQQH1h5M4/Q4CyTH45K9rQW+e8/meCbBlB3/rg+E7PJkaFbmptb
         zF4NQJqq1a//YU0N6O7F1bL4ynka4sNmtlvBpX/7qgnfG61I7QiHqOzH4leRVYhV5Vlz
         /iKMuVnDaUsaWB1oEse+10uxsrDL+K3HKOgAMd8rOPLvcW2aeCd6CbjvMLUFjRnC2sHS
         SqIb33w35AfOZerwTp6QBpEaMS88hYCUrij+bBZllFfdISdDYMhiMGArk/FGs8uu2BAx
         zmIMAAx6bSIf21L+JlXc+NcJeZse996H3xXF5fQaGuy0EP/hhZ4hfFxN+6EBiPkidnl2
         0AeQ==
X-Gm-Message-State: APjAAAUuN2DdLTE6cp2ncvc5ka6XVHDigutFwvM8gzzxjyeAaEsPNBsi
        6mHXp/eROFXnmVizZgcvQsNbLsKzZP5ZqA==
X-Google-Smtp-Source: APXvYqwgtwYpT9cg3gaUoASZePIHM0GUXAfGQxCkQc4zdvADS6YRLfKQfN5B+6njowjdg51XBm6tUg==
X-Received: by 2002:ac8:6c31:: with SMTP id k17mr51817374qtu.253.1563885245559;
        Tue, 23 Jul 2019 05:34:05 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-156-34-55-100.dhcp-dynamic.fibreop.ns.bellaliant.net. [156.34.55.100])
        by smtp.gmail.com with ESMTPSA id i62sm20099024qke.52.2019.07.23.05.34.03
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 23 Jul 2019 05:34:04 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1hptzW-0004mn-JO; Tue, 23 Jul 2019 09:34:02 -0300
Date:   Tue, 23 Jul 2019 09:34:02 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     YueHaibing <yuehaibing@huawei.com>, oulijun@huawei.com,
        xavier.huwei@huawei.com, dledford@redhat.com,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [PATCH] RDMA/hns: Fix build error for hip08
Message-ID: <20190723123402.GA15357@ziepe.ca>
References: <20190723024908.11876-1-yuehaibing@huawei.com>
 <20190723074339.GJ5125@mtr-leonro.mtl.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190723074339.GJ5125@mtr-leonro.mtl.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Tue, Jul 23, 2019 at 10:43:39AM +0300, Leon Romanovsky wrote:
> On Tue, Jul 23, 2019 at 10:49:08AM +0800, YueHaibing wrote:
> > If INFINIBAND_HNS_HIP08 is selected and HNS3 is m,
> > but INFINIBAND_HNS is y, building fails:
> >
> > drivers/infiniband/hw/hns/hns_roce_hw_v2.o: In function `hns_roce_hw_v2_exit':
> > hns_roce_hw_v2.c:(.exit.text+0xd): undefined reference to `hnae3_unregister_client'
> > drivers/infiniband/hw/hns/hns_roce_hw_v2.o: In function `hns_roce_hw_v2_init':
> > hns_roce_hw_v2.c:(.init.text+0xd): undefined reference to `hnae3_register_client'
> 
> It means that you have a problem with header files of your hns3.
> 
> >
> > Reported-by: Hulk Robot <hulkci@huawei.com>
> > Fixes: dd74282df573 ("RDMA/hns: Initialize the PCI device for hip08 RoCE")
> > Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> >  drivers/infiniband/hw/hns/Kconfig | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/infiniband/hw/hns/Kconfig b/drivers/infiniband/hw/hns/Kconfig
> > index b59da5d..4371c80 100644
> > +++ b/drivers/infiniband/hw/hns/Kconfig
> > @@ -23,7 +23,8 @@ config INFINIBAND_HNS_HIP06
> >
> >  config INFINIBAND_HNS_HIP08
> >  	bool "Hisilicon Hip08 Family RoCE support"
> > -	depends on INFINIBAND_HNS && PCI && HNS3
> > +	depends on INFINIBAND_HNS && (INFINIBAND_HNS = HNS3)
> 
> This is wrong.

It is tricky. It is asserting that the IB side is built as a module if
the ethernet side is a module..

It is kind of a weird pattern as the module config is INFINIBAND_HNS
and these others are just bool opens what to include, but I think it
is OK..

Jason
