Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1DAAC636C8
	for <linux-rdma@archiver.kernel.org>; Tue, 20 Jul 2021 08:36:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BBB8A611F2
	for <linux-rdma@archiver.kernel.org>; Tue, 20 Jul 2021 08:36:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229872AbhGTHzZ (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 20 Jul 2021 03:55:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:58918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234420AbhGTHyc (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Tue, 20 Jul 2021 03:54:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CFB3C611EF;
        Tue, 20 Jul 2021 08:35:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626770110;
        bh=vNxMCTznwpbJiAUJa7hf9jYlEIb/HWnfH0bHXTkY6mk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cxxH0ysLvCEQiQ21zHOTlgwbCv5MDJ+DAr1Bbx32hRq4sMs1LTyxXil2sAq6EUeFM
         xGo92BzY3o3I3dHibAv//UeZ0j5HmSgeXpP36InStUXHZt+sVpCCzoLOKaZx6SU2L9
         WRmUwlTFuALS/7+agLOpSxEwi9IH4pTum4u/t4PybjNeJ70Urd7JhTwn5WN1JceF9D
         RbUs3luPZLKFFoxPn5bpqd3VdCui+8mYoWFB2YYGczwhbEnwe99R/Dc5UuYdZ93CUQ
         GvAo6SpYTrBwqN26i1SNjFjU5EuwhKlLAe7RhHvv9doVjedJFobezj2hWFWv/9Z3ZB
         KmKJl3zWs7m9w==
Date:   Tue, 20 Jul 2021 11:35:07 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Gal Pressman <galpress@amazon.com>
Cc:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Adit Ranadive <aditr@vmware.com>,
        Ariel Elior <aelior@marvell.com>,
        Bernard Metzler <bmt@zurich.ibm.com>,
        Christian Benvenuti <benve@cisco.com>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        Michal Kalderon <mkalderon@marvell.com>,
        Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>,
        Mustafa Ismail <mustafa.ismail@intel.com>,
        Naresh Kumar PBS <nareshkumar.pbs@broadcom.com>,
        Nelson Escobar <neescoba@cisco.com>,
        Potnuri Bharat Teja <bharat@chelsio.com>,
        Selvin Xavier <selvin.xavier@broadcom.com>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        Steve Wise <larrystevenwise@gmail.com>,
        VMware PV-Drivers <pv-drivers@vmware.com>,
        Weihang Li <liweihang@huawei.com>,
        Wenpeng Liang <liangwenpeng@huawei.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Zhu Yanjun <zyjzyj2000@gmail.com>
Subject: Re: [PATCH rdma-next 8/9] RDMA: Globally allocate and release QP
 memory
Message-ID: <YPaKu4ppS0Bz6fW1@unreal>
References: <cover.1626609283.git.leonro@nvidia.com>
 <5b3bff16da4b6f925c872594262cd8ed72b301cd.1626609283.git.leonro@nvidia.com>
 <abfc0d32-eab8-97d4-5734-508b6c46fe98@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <abfc0d32-eab8-97d4-5734-508b6c46fe98@amazon.com>
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Mon, Jul 19, 2021 at 04:42:11PM +0300, Gal Pressman wrote:
> On 18/07/2021 15:00, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@nvidia.com>
> > 
> > Convert QP object to follow IB/core general allocation scheme.
> > That change allows us to make sure that restrack properly kref
> > the memory.
> > 
> > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> 
> EFA and core parts look good to me.
> Reviewed-by: Gal Pressman <galpress@amazon.com>
> Tested-by: Gal Pressman <galpress@amazon.com>

Thanks a lot.

> 
> > +static inline void *rdma_zalloc_obj(struct ib_device *dev, size_t size,
> > +				    gfp_t gfp, bool is_numa_aware)
> > +{
> > +	if (is_numa_aware && dev->ops.get_numa_node)
> 
> Honestly I think it's better to return an error if a numa aware allocation is
> requested and get_numa_node is not provided.

We don't want any driver to use and implement ".get_numa_node()" callback.

Initially, I thought about adding WARN_ON(driver_id != HFI && .get_numa_node)
to the device.c, but decided to stay with comment in ib_verbs.h only.

> 
> > +		return kzalloc_node(size, gfp, dev->ops.get_numa_node(dev));
> > +
> > +	return kzalloc(size, gfp);
> > +}
