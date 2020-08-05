Return-Path: <SRS0=TZef=BP=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DE9DC433E0
	for <linux-rdma@archiver.kernel.org>; Wed,  5 Aug 2020 20:07:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0E5FB22B42
	for <linux-rdma@archiver.kernel.org>; Wed,  5 Aug 2020 20:07:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596658078;
	bh=okWTVxMfAqTmrUhAjOtDYoVejP3q8+sYEO8cV9chVeQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=0Ffcg6LlTmmaJApxwWjSUG/Ruw884SMYHS/VL3lqpsb9NFGrEzfKRYwVhAUEnpzAR
	 i5OM9mpUtIf9zE2hyOP1rI/cJqezmiV6GllVQEuBNQ4hM+/zPVETIc0y6FmptRGt7y
	 PtjcNtoTn/ZacxW686OIeHieH5U/wOOgIdHM4/rc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727022AbgHEUHg (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 5 Aug 2020 16:07:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:49794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726027AbgHEQdC (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Wed, 5 Aug 2020 12:33:02 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A84C722D2B;
        Wed,  5 Aug 2020 13:09:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596632971;
        bh=okWTVxMfAqTmrUhAjOtDYoVejP3q8+sYEO8cV9chVeQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AjmdkCxYBX7bd1u1RaAYgTa3u4WjLgV9S2nQMuvE9dGYFQjf4EWiohmsh2tHEgF1h
         m8+0ElK0CewY6pPmjbON/4Mn1knP3OEQfNLd1wHOnl2qwBYf9v25MgDpascHaHUiSq
         QVHI/a0GYmn8tv6CItsiucCBmsC2OteHEiltYa5g=
Date:   Wed, 5 Aug 2020 16:09:26 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Danil Kipnis <danil.kipnis@cloud.ionos.com>
Cc:     Md Haris Iqbal <haris.iqbal@cloud.ionos.com>,
        Jinpu Wang <jinpu.wang@cloud.ionos.com>,
        linux-rdma@vger.kernel.org, linux-block@vger.kernel.org,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        "Chen, Rong A" <rong.a.chen@intel.com>
Subject: Re: [PATCH v2] RDMA/rtrs-srv: Incorporate ib_register_client into
 rtrs server init
Message-ID: <20200805130926.GH4432@unreal>
References: <20200623172321.GC6578@ziepe.ca>
 <20200804133759.377950-1-haris.iqbal@cloud.ionos.com>
 <20200805055712.GE4432@unreal>
 <CAHg0HuzmfrKqy_SfwEqRh33Ymx8j6DhkLC0=11T7Djrc7z-SWQ@mail.gmail.com>
 <20200805091644.GG4432@unreal>
 <CAHg0Huy-xXopLpdU1Bx1een2vuDv6o27YZz+x-zN_enChESsQw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHg0Huy-xXopLpdU1Bx1een2vuDv6o27YZz+x-zN_enChESsQw@mail.gmail.com>
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Wed, Aug 05, 2020 at 01:18:05PM +0200, Danil Kipnis wrote:
> On Wed, Aug 5, 2020 at 11:16 AM Leon Romanovsky <leon@kernel.org> wrote:
> >
> > On Wed, Aug 05, 2020 at 11:09:00AM +0200, Danil Kipnis wrote:
> > > Hi Leon,
> > >
> > > On Wed, Aug 5, 2020 at 7:57 AM Leon Romanovsky <leon@kernel.org> wrote:
> > > >
> > > > On Tue, Aug 04, 2020 at 07:07:58PM +0530, Md Haris Iqbal wrote:
> > > > > The rnbd_server module's communication manager (cm) initialization depends
> > > > > on the registration of the "network namespace subsystem" of the RDMA CM
> > > > > agent module. As such, when the kernel is configured to load the
> > > > > rnbd_server and the RDMA cma module during initialization; and if the
> > > > > rnbd_server module is initialized before RDMA cma module, a null ptr
> > > > > dereference occurs during the RDMA bind operation.
> > > > >
> > > > > Call trace below,
> > > > >
> > > > > [    1.904782] Call Trace:
> > > > > [    1.904782]  ? xas_load+0xd/0x80
> > > > > [    1.904782]  xa_load+0x47/0x80
> > > > > [    1.904782]  cma_ps_find+0x44/0x70
> > > > > [    1.904782]  rdma_bind_addr+0x782/0x8b0
> > > > > [    1.904782]  ? get_random_bytes+0x35/0x40
> > > > > [    1.904782]  rtrs_srv_cm_init+0x50/0x80
> > > > > [    1.904782]  rtrs_srv_open+0x102/0x180
> > > > > [    1.904782]  ? rnbd_client_init+0x6e/0x6e
> > > > > [    1.904782]  rnbd_srv_init_module+0x34/0x84
> > > > > [    1.904782]  ? rnbd_client_init+0x6e/0x6e
> > > > > [    1.904782]  do_one_initcall+0x4a/0x200
> > > > > [    1.904782]  kernel_init_freeable+0x1f1/0x26e
> > > > > [    1.904782]  ? rest_init+0xb0/0xb0
> > > > > [    1.904782]  kernel_init+0xe/0x100
> > > > > [    1.904782]  ret_from_fork+0x22/0x30
> > > > > [    1.904782] Modules linked in:
> > > > > [    1.904782] CR2: 0000000000000015
> > > > > [    1.904782] ---[ end trace c42df88d6c7b0a48 ]---
> > > > >
> > > > > All this happens cause the cm init is in the call chain of the module init,
> > > > > which is not a preferred practice.
> > > > >
> > > > > So remove the call to rdma_create_id() from the module init call chain.
> > > > > Instead register rtrs-srv as an ib client, which makes sure that the
> > > > > rdma_create_id() is called only when an ib device is added.
> > > > >
> > > > > Fixes: 9cb837480424 ("RDMA/rtrs: server: main functionality")
> > > > > Reported-by: kernel test robot <rong.a.chen@intel.com>
> > > > > Signed-off-by: Md Haris Iqbal <haris.iqbal@cloud.ionos.com>
> > > > > ---
> > > > >  drivers/infiniband/ulp/rtrs/rtrs-srv.c | 77 +++++++++++++++++++++++++-
> > > > >  drivers/infiniband/ulp/rtrs/rtrs-srv.h |  7 +++
> > > > >  2 files changed, 81 insertions(+), 3 deletions(-)
> > > >
> > > > Please don't send vX patches as reply-to in "git send-email" command.
> > >
> > > I thought vX + in-reply-to makes it clear that a new version of a
> > > patch is proposed in response to a mail reporting a problem in the
> > > first version. Why is that a bad idea?
> >
> > It looks very messy in e-mail client. It is hard to follow and requires
> > multiple iterations to understand if the reply is on previous variant or
> > on new one.
> >
> > See attached print screen or see it in lore, where thread view is used.
> > https://lore.kernel.org/linux-rdma/20200623172321.GC6578@ziepe.ca/T/#t
>
> I see, thanks. Just a related question: In this particular case the
> commit message changed in the second version of the patch. Should one
> still use v2 in that case, or should the second version be submitted
> without the vX tag at all?

It depends on the change itself. If title wasn't changed, the vX would
help to distinguish between versions. Once title changes and the commit
message too, the vX is not really needed (IMHO).

Thanks

>
> >
> > Thanks
