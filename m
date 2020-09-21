Return-Path: <SRS0=5Yt0=C6=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6951DC43463
	for <linux-rdma@archiver.kernel.org>; Mon, 21 Sep 2020 11:49:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 35E3721531
	for <linux-rdma@archiver.kernel.org>; Mon, 21 Sep 2020 11:49:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600688982;
	bh=n1OD4gxQ5esgX0DlKCNLeHJa8+g0RS/7Xu1Waz3iE6U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=MCQd3Q1OysBmTK2PoT8WxE4HaDZZ564nv1cyGfATgQ90XQCsHES4OR8BNPdM+CK/i
	 EkgTZv0M+FfG7z2zyOO4PFYKrqC41HAr6J+NdZ3iqy1dj91KEkHlBRDxv2LDFT2vMl
	 8SZcxgegZjmdFnae4jIURc8/P2MpdzIXwZc86z/w=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726623AbgIULtl (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 21 Sep 2020 07:49:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:34726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726522AbgIULtl (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Mon, 21 Sep 2020 07:49:41 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 038AB20EDD;
        Mon, 21 Sep 2020 11:49:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600688980;
        bh=n1OD4gxQ5esgX0DlKCNLeHJa8+g0RS/7Xu1Waz3iE6U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DzJcLW3vVCG7qHSxxD1XGno5q7ANeGZiCm8Q6UBlZL+gA+JexYf+ksgg7rKssJmSi
         MMDd5aCRKZ/0ZfvM03Qjgfjh8Vg80C6unFek43M0Y5m36G6b9J4xuswV9JkjaS4CIi
         ZUZt+M2vvY3RhRhCanBdGvff2NmzTYuzldYd9WcI=
Date:   Mon, 21 Sep 2020 14:49:36 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Gal Pressman <galpress@amazon.com>
Cc:     Jason Gunthorpe <jgg@ziepe.ca>,
        Oded Gabbay <oded.gabbay@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        izur@habana.ai, Jakub Kicinski <kuba@kernel.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, SW_Drivers <SW_Drivers@habana.ai>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-rdma@vger.kernel.org, Olof Johansson <olof@lixom.net>
Subject: Re: [PATCH v3 00/14] Adding GAUDI NIC code to habanalabs driver
Message-ID: <20200921114936.GC1223944@unreal>
References: <20200918132645.GS8409@ziepe.ca>
 <CAFCwf109t5=GuNvqTqLUCiYbjLC6o2xVoLY5C-SBqbN66f6wxg@mail.gmail.com>
 <20200918135915.GT8409@ziepe.ca>
 <CAFCwf13rJgb4=as7yW-2ZHvSnUd2NK1GP0UKKjyMfkB3vsnE5w@mail.gmail.com>
 <20200918141909.GU8409@ziepe.ca>
 <CAFCwf121_UNivhfPfO6uFoHbF+2Odeb1c3+482bOXeOZUsEnug@mail.gmail.com>
 <20200918150735.GV8409@ziepe.ca>
 <CAFCwf13y1VVy90zAoBPC-Gfj6mwMVbefh3fxKDVneuscp4esqA@mail.gmail.com>
 <20200918152852.GW8409@ziepe.ca>
 <b0721756-d323-b95e-b2d2-ca3ce8d4a660@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b0721756-d323-b95e-b2d2-ca3ce8d4a660@amazon.com>
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Mon, Sep 21, 2020 at 02:22:02PM +0300, Gal Pressman wrote:
> On 18/09/2020 18:28, Jason Gunthorpe wrote:
> > On Fri, Sep 18, 2020 at 06:15:52PM +0300, Oded Gabbay wrote:
> >
> >> I'm sorry, but you won't be able to convince me here that I need to
> >> "enslave" my entire code to RDMA, just because my ASIC "also" has some
> >> RDMA ports.
> >
> > You can't recreate common shared subsystems in a driver just because
> > you don't want to work with the subsystem.
> >
> > I don't care what else the ASIC has. In Linux the netdev part is
> > exposed through netdev, the RDMA part through RDMA, the
> > totally-not-a-GPU part through drivers/misc.
> >
> > It is always been this way. Chelsio didn't get to rebuild the SCSI
> > stack in their driver just because "storage is a small part of their
> > device"
> >
> > Drivers are not allowed to re-implement I2C/SPI/etc without re-using
> > the comon code for that just because "I2C is a small part of their
> > device"
> >
> > Exposing to userspace the creation of RoCE QPs and their related
> > objects are unambiguously a RDMA subsystem task. I don't even know how
> > you think you can argue it is not. It is your company proudly claiming
> > the device has 100G RoCE ports in all the marketing literature, after
> > all.
> >
> > It is too bad the device has a non-standards compliant implementation
> > of RoCE so this will be a bit hard for you. Oh well.
>
> What is considered a RoCE port in this case if it's not compliant with RoCE?

They claim that it is RoCE v2.
https://www.hotchips.org/hc31/HC31_1.14_HabanaLabs.Eitan_Medina.v9.pdf

Thanks
