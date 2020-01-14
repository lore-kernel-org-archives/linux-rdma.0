Return-Path: <SRS0=Cfzb=3D=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A162C33CB1
	for <linux-rdma@archiver.kernel.org>; Tue, 14 Jan 2020 08:12:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 037472053B
	for <linux-rdma@archiver.kernel.org>; Tue, 14 Jan 2020 08:12:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RDPiGTBl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729139AbgANIMr (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 14 Jan 2020 03:12:47 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:38206 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729049AbgANIMr (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Tue, 14 Jan 2020 03:12:47 -0500
Received: by mail-wm1-f65.google.com with SMTP id u2so12550897wmc.3
        for <linux-rdma@vger.kernel.org>; Tue, 14 Jan 2020 00:12:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=SEpnDRI89gGGNgu2NCaw6hW5qAyoZVZkfxOR0zVvtxg=;
        b=RDPiGTBlSV6TtsyNr56YFAd8XDnrGV5Hq5yqvkdsLysodcV+LWrMQcmstmRjr5rp+0
         QrQhsn7W6l+fChpD4DNHUBcorwGwbUGNWoTEjiazuvM/QWx9Mau16AKhBOZykKT8e+kJ
         v2aQmv0EASS6UFmGgLAuJ39csJ7EI2SyyAnSz6qwPeduv5pZ35qRlyibhEF074BAWKyL
         EjFg1XC0PJBftyinvYI7Ol8UPngYM5euEI+KgSsS2ydUVgQ3tpw5uqQYBLVcYAu6wDyh
         vUGeBoUtge+GX6Zs20FKugBFMlWCxwQeBL1jdFvi2FT4iD8KdVoSfJQ0lafHAZTbk/7E
         ZpzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=SEpnDRI89gGGNgu2NCaw6hW5qAyoZVZkfxOR0zVvtxg=;
        b=Z2fdbmswIjtPQ+PBeTExpWYi0ebfNHWSN4uT9Xbbj/DNWLVQ7iY7v7u4JeHmkK78MX
         Q/58sdf2hPPsFf9HtCXCRLTbWWZkRkddqGxDb0I7TMQChqb5dZ9/XXl44ay0e+6Latjz
         B4TbBv5tRmXp0Iy+DwH/15pdPbl9Pq4PnJbksmrle4pvdYJIPexcxZxlxOrZCOFf6q/4
         jzJVHFydrRcMPcxjHzxnRAUJt61P7TcAKMfOAhBzM2cXx7SoP9KHGrd9JSZWfTxOj6RQ
         9bd2DBgNFrJQFJt3mYk5OHlwzUePxeNP7aMwPVxMmiW/K7dSrcAaTi+FJwlSy+YCLzuz
         4fxw==
X-Gm-Message-State: APjAAAVJLMYnafrYZFoZrxhCfBRwGg/G/c6WcQMNKfptW1YKhMzQKwMJ
        FqclUdF9648SwSGlC99ywWy62cDq
X-Google-Smtp-Source: APXvYqwaVsazVZ5Jk7fQtZapBKq3Hf1vnUGW9A/NUURuImNrebFOEPL6EPdHO3a5kpA2nr6A6hO8xQ==
X-Received: by 2002:a1c:7901:: with SMTP id l1mr25005232wme.67.1578989565404;
        Tue, 14 Jan 2020 00:12:45 -0800 (PST)
Received: from kheib-workstation (bzq-79-181-7-148.red.bezeqint.net. [79.181.7.148])
        by smtp.gmail.com with ESMTPSA id q68sm18805843wme.14.2020.01.14.00.12.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jan 2020 00:12:44 -0800 (PST)
Date:   Tue, 14 Jan 2020 10:12:38 +0200
From:   Kamal Heib <kamalheib1@gmail.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     linux-rdma@vger.kernel.org, Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH for-next] RDMA/core: Fix storing node description
Message-ID: <20200114081238.GA1028@kheib-workstation>
References: <20200113191226.14903-1-kamalheib1@gmail.com>
 <20200113201642.GC9861@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200113201642.GC9861@ziepe.ca>
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Mon, Jan 13, 2020 at 04:16:42PM -0400, Jason Gunthorpe wrote:
> On Mon, Jan 13, 2020 at 09:12:26PM +0200, Kamal Heib wrote:
> > Make sure to return -EINVAL when the supplied string is bigger then
> > IB_DEVICE_NODE_DESC_MAX.
> > 
> > Fixes: c5bcbbb9fe00 ("IB: Allow userspace to set node description")
> > Signed-off-by: Kamal Heib <kamalheib1@gmail.com>
> >  drivers/infiniband/core/sysfs.c | 5 ++++-
> >  1 file changed, 4 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/infiniband/core/sysfs.c b/drivers/infiniband/core/sysfs.c
> > index 087682e6969e..55f4d7c1fcc9 100644
> > +++ b/drivers/infiniband/core/sysfs.c
> > @@ -1265,10 +1265,13 @@ static ssize_t node_desc_store(struct device *device,
> >  	struct ib_device_modify desc = {};
> >  	int ret;
> >  
> > +	if (count > IB_DEVICE_NODE_DESC_MAX)
> > +		return -EINVAL;
> > +
> >  	if (!dev->ops.modify_device)
> >  		return -EOPNOTSUPP;
> >  
> > -	memcpy(desc.node_desc, buf, min_t(int, count, IB_DEVICE_NODE_DESC_MAX));
> > +	memcpy(desc.node_desc, buf, count);
> 
> I think this should just be written as
> 
> if (strscpy(desc.node_desc, buf, sizeof(desc.node_desc)) == -E2BIG)
>     return -EINVAL;
>

OK, I'll send a V2 soon.

> Jason
