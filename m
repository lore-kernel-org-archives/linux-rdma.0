Return-Path: <SRS0=wa48=XW=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D14CCC4360C
	for <linux-rdma@archiver.kernel.org>; Fri, 27 Sep 2019 04:50:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9E5DC2146E
	for <linux-rdma@archiver.kernel.org>; Fri, 27 Sep 2019 04:50:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1569559834;
	bh=JVEnk9tinPjTGLJ3dFKeOM+IowNE8SvIlokdPK+hW08=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=r1j3WdS1T91QcdeAqZb9m7ROnHW6suCb4oqUS/ez4JpwOaZ3fei21r2+AYSP0rPRN
	 8QX16St+C0SaOVC9VUA4IotXOYPG1zkPCbkhBN9FQL0seIgftP6AI885PFkI6iORMf
	 iE+8aS42yZdgwldEhck8DqxTbDPvQ7AhuG1DmIYo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726365AbfI0Eue (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Fri, 27 Sep 2019 00:50:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:42032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726144AbfI0Eue (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Fri, 27 Sep 2019 00:50:34 -0400
Received: from localhost (unknown [77.137.89.37])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6A45720872;
        Fri, 27 Sep 2019 04:50:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569559833;
        bh=JVEnk9tinPjTGLJ3dFKeOM+IowNE8SvIlokdPK+hW08=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=anTuyJfN6AOmQhVHlw9SPneEDj1Tj+pbQ1vpXawgaSgXf4aWoBgdvS2/yh60NMv09
         FNq1528w7YOKKNiTtSzJTPxKX8pARpKLnK+i8G0UhntwZMJopXsvqDRdryGVDVYqXw
         NBYWTXRqdF5C92mU3Sh+1qzjGcke+6Y/xotNWtHA=
Date:   Fri, 27 Sep 2019 07:50:29 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     "Saleem, Shiraz" <shiraz.saleem@intel.com>
Cc:     "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "dledford@redhat.com" <dledford@redhat.com>,
        "jgg@mellanox.com" <jgg@mellanox.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "Ismail, Mustafa" <mustafa.ismail@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: Re: [RFC 12/20] RDMA/irdma: Implement device supported verb APIs
Message-ID: <20190927045029.GG14368@unreal>
References: <20190926164519.10471-1-jeffrey.t.kirsher@intel.com>
 <20190926164519.10471-13-jeffrey.t.kirsher@intel.com>
 <20190926173710.GC14368@unreal>
 <9DD61F30A802C4429A01CA4200E302A7AC702BEA@fmsmsx123.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9DD61F30A802C4429A01CA4200E302A7AC702BEA@fmsmsx123.amr.corp.intel.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Thu, Sep 26, 2019 at 07:49:52PM +0000, Saleem, Shiraz wrote:
> > Subject: Re: [RFC 12/20] RDMA/irdma: Implement device supported verb APIs
> >
> > On Thu, Sep 26, 2019 at 09:45:11AM -0700, Jeff Kirsher wrote:
> > > From: Mustafa Ismail <mustafa.ismail@intel.com>
> > >
> > > Implement device supported verb APIs. The supported APIs vary based on
> > > the underlying transport the ibdev is registered as (i.e. iWARP or
> > > RoCEv2).
> > >
> > > Signed-off-by: Mustafa Ismail <mustafa.ismail@intel.com>
> > > Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
> > > ---
> > >  drivers/infiniband/hw/irdma/verbs.c      | 4346 ++++++++++++++++++++++
> > >  drivers/infiniband/hw/irdma/verbs.h      |  199 +
> > >  include/uapi/rdma/rdma_user_ioctl_cmds.h |    1 +
> > >  3 files changed, 4546 insertions(+)
> > >  create mode 100644 drivers/infiniband/hw/irdma/verbs.c
> > >  create mode 100644 drivers/infiniband/hw/irdma/verbs.h
> > >
> > > diff --git a/drivers/infiniband/hw/irdma/verbs.c
> > > b/drivers/infiniband/hw/irdma/verbs.c
> > > new file mode 100644
> > > index 000000000000..025c21c722e2
> > > --- /dev/null
> > > +++ b/drivers/infiniband/hw/irdma/verbs.c
> > > @@ -0,0 +1,4346 @@
> > > +// SPDX-License-Identifier: GPL-2.0 or Linux-OpenIB
> > > +/* Copyright (c) 2019, Intel Corporation. */
> >
> > <...>
> >
> > > +
> > > +	size = sqdepth * sizeof(struct irdma_sq_uk_wr_trk_info) +
> > > +	       (rqdepth << 3);
> > > +	iwqp->kqp.wrid_mem = kzalloc(size, GFP_KERNEL);
> > > +	if (!iwqp->kqp.wrid_mem)
> > > +		return -ENOMEM;
> > > +
> > > +	ukinfo->sq_wrtrk_array = (struct irdma_sq_uk_wr_trk_info *)
> > > +				 iwqp->kqp.wrid_mem;
> > > +	if (!ukinfo->sq_wrtrk_array)
> > > +		return -ENOMEM;
> >
> > You are leaking resources here, forgot to do proper error unwinding.
> >
>
> irdma_free_qp_rsrc() will free up that memory in case of an error.

I'm talking about kqp.wrid_mem you allocated a couple of lines above and
didn't free in case of sq_wrtrk_array allocation failed.

Thanks
