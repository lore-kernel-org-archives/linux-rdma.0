Return-Path: <SRS0=wa48=XW=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AABEEC4360C
	for <linux-rdma@archiver.kernel.org>; Fri, 27 Sep 2019 04:46:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7CD992146E
	for <linux-rdma@archiver.kernel.org>; Fri, 27 Sep 2019 04:46:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1569559619;
	bh=EPT3zGbtRqn79oR32c1eVmG3w/XUOJfAFeauxOq7yf4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=gwHnheNkzGtGPjzXX9AFOcawR7ZO58sKp4UYquzr3N8WY7fA8qyIMbeBwYOJeiPCB
	 9C2zmbHtQ7LEuDK3wGAwiwl5mm6ZyRbbH7ltjK5erfsNSaXdCZxRYNy6YVu5+b6ivz
	 yFNzzqT1bvNCuvce5ywbXyEmJg9JsLxk0R/jwg80=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727899AbfI0Eq6 (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Fri, 27 Sep 2019 00:46:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:39408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725268AbfI0Eq6 (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Fri, 27 Sep 2019 00:46:58 -0400
Received: from localhost (unknown [77.137.89.37])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1ACA520872;
        Fri, 27 Sep 2019 04:46:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569559617;
        bh=EPT3zGbtRqn79oR32c1eVmG3w/XUOJfAFeauxOq7yf4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AqTI9bQXWGB+/SrwTVbVuG9BG2CL+g48eAn3ENCR8wgw4Y5plARt1DZRfHMAVzTWj
         twSTzPgKWzrw+cERPk2oZYtfLN48STvO6ns9pe2E3eR6lwKj+p8OOgykoLe6CIpcsN
         dzRWNV3gIilTon0oSrWJNzZ88rgFyRgvGTOjpHt8=
Date:   Fri, 27 Sep 2019 07:46:53 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     "Saleem, Shiraz" <shiraz.saleem@intel.com>
Cc:     "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "dledford@redhat.com" <dledford@redhat.com>,
        "jgg@mellanox.com" <jgg@mellanox.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "Ismail, Mustafa" <mustafa.ismail@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: Re: [RFC 15/20] RDMA/irdma: Add miscellaneous utility definitions
Message-ID: <20190927044653.GF14368@unreal>
References: <20190926164519.10471-1-jeffrey.t.kirsher@intel.com>
 <20190926164519.10471-16-jeffrey.t.kirsher@intel.com>
 <20190926174948.GE14368@unreal>
 <9DD61F30A802C4429A01CA4200E302A7AC702BC6@fmsmsx123.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9DD61F30A802C4429A01CA4200E302A7AC702BC6@fmsmsx123.amr.corp.intel.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Thu, Sep 26, 2019 at 07:49:33PM +0000, Saleem, Shiraz wrote:
> > Subject: Re: [RFC 15/20] RDMA/irdma: Add miscellaneous utility definitions
> >
> > On Thu, Sep 26, 2019 at 09:45:14AM -0700, Jeff Kirsher wrote:
> > > From: Mustafa Ismail <mustafa.ismail@intel.com>
> > >
> > > Add miscellaneous utility functions and headers.
> > >
> > > Signed-off-by: Mustafa Ismail <mustafa.ismail@intel.com>
> > > Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
> > > ---
> > >  drivers/infiniband/hw/irdma/osdep.h  |  108 ++
> > >  drivers/infiniband/hw/irdma/protos.h |   96 ++
> > >  drivers/infiniband/hw/irdma/status.h |   70 +
> > >  drivers/infiniband/hw/irdma/utils.c  | 2333
> > > ++++++++++++++++++++++++++
> > >  4 files changed, 2607 insertions(+)
> > >  create mode 100644 drivers/infiniband/hw/irdma/osdep.h
> > >  create mode 100644 drivers/infiniband/hw/irdma/protos.h
> > >  create mode 100644 drivers/infiniband/hw/irdma/status.h
> > >  create mode 100644 drivers/infiniband/hw/irdma/utils.c
> > >
> > > diff --git a/drivers/infiniband/hw/irdma/osdep.h
> > > b/drivers/infiniband/hw/irdma/osdep.h
> > > new file mode 100644
> > > index 000000000000..5885b6fa413d
> > > --- /dev/null
> > > +++ b/drivers/infiniband/hw/irdma/osdep.h
> > > @@ -0,0 +1,108 @@
> > > +/* SPDX-License-Identifier: GPL-2.0 or Linux-OpenIB */
> > > +/* Copyright (c) 2019, Intel Corporation. */
> > > +
> > > +#ifndef IRDMA_OSDEP_H
> > > +#define IRDMA_OSDEP_H
> > > +
> > > +#include <linux/version.h>
> > > +#include <linux/kernel.h>
> > > +#include <linux/vmalloc.h>
> > > +#include <linux/string.h>
> > > +#include <linux/bitops.h>
> > > +#include <linux/pci.h>
> > > +#include <net/tcp.h>
> > > +#include <crypto/hash.h>
> > > +/* get readq/writeq support for 32 bit kernels, use the low-first
> > > +version */ #include <linux/io-64-nonatomic-lo-hi.h>
> > > +
> > > +#define MAKEMASK(m, s) ((m) << (s))
> >
> > It is a little bit over-macro.
> >
>
> Why is this a problem?
> We are not translating any basic kernel construct here.

See BIT() definition.

Thanks
