Return-Path: <SRS0=b7KD=4H=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D5B2C34047
	for <linux-rdma@archiver.kernel.org>; Wed, 19 Feb 2020 09:33:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D59A724656
	for <linux-rdma@archiver.kernel.org>; Wed, 19 Feb 2020 09:33:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1582104832;
	bh=smWYeO6ACuMNi1MtbWEfiPLPNo188PfYYAAQ8cCCNeY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=azY0W57MXnu1kWBTDGc52LRWFwUVjusYW/r4pAV2ZViU+r412UTDjWIq77eNDGpEd
	 /VJS+ZuflypUdPKW6ICOVA4KuC9bBRrfsx+9FYqCHKkF1fQLfwNIZiQGf+I3sxnbpx
	 QMdOUwCVdiygiS5FI8Jte03MdIsNNW1VQhYoXtWg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726297AbgBSJdw (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 19 Feb 2020 04:33:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:53992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726270AbgBSJdw (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Wed, 19 Feb 2020 04:33:52 -0500
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2A115207FD;
        Wed, 19 Feb 2020 09:33:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582104831;
        bh=smWYeO6ACuMNi1MtbWEfiPLPNo188PfYYAAQ8cCCNeY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Asv/MFfMu5TNFKEck+4H3NUWiktcuKO5exMGvm85FXyFMtKheMQnOJCN1NeZSqb/+
         yiMs+eza9DEgixoomAK7QKauQt8yaibFMq2DLxtBQkd7xyuNtKhWKr5cpxXGIBDaaU
         seFL4IUNGH+jHBewopwViAUdY74qmj5PX7VTJ9Ic=
Date:   Wed, 19 Feb 2020 11:33:21 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Kamal Heib <kamalheib1@gmail.com>
Cc:     linux-rdma@vger.kernel.org, Jason Gunthorpe <jgg@ziepe.ca>,
        Doug Ledford <dledford@redhat.com>,
        Bernard Metzler <bmt@zurich.ibm.com>
Subject: Re: [PATCH for-next v2] RDMA/siw: Fix setting active_{speed, width}
 attributes
Message-ID: <20200219093321.GI15239@unreal>
References: <20200218095911.26614-1-kamalheib1@gmail.com>
 <20200218165847.GA15239@unreal>
 <20200219084359.GA12296@kheib-workstation>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200219084359.GA12296@kheib-workstation>
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Wed, Feb 19, 2020 at 10:43:59AM +0200, Kamal Heib wrote:
> On Tue, Feb 18, 2020 at 06:58:47PM +0200, Leon Romanovsky wrote:
> > On Tue, Feb 18, 2020 at 11:59:11AM +0200, Kamal Heib wrote:
> > > Make sure to set the active_{speed, width} attributes to avoid reporting
> > > the same values regardless of the underlying device.
> > >
> > > Fixes: 303ae1cdfdf7 ("rdma/siw: application interface")
> > > Signed-off-by: Kamal Heib <kamalheib1@gmail.com>
> > > ---
> > > V2: Change rc to rv.
> > > ---
> > >  drivers/infiniband/sw/siw/siw_verbs.c | 7 ++++---
> > >  1 file changed, 4 insertions(+), 3 deletions(-)
> > >
> > > diff --git a/drivers/infiniband/sw/siw/siw_verbs.c b/drivers/infiniband/sw/siw/siw_verbs.c
> > > index 73485d0da907..d5390d498c61 100644
> > > --- a/drivers/infiniband/sw/siw/siw_verbs.c
> > > +++ b/drivers/infiniband/sw/siw/siw_verbs.c
> > > @@ -165,11 +165,12 @@ int siw_query_port(struct ib_device *base_dev, u8 port,
> > >  		   struct ib_port_attr *attr)
> > >  {
> > >  	struct siw_device *sdev = to_siw_dev(base_dev);
> > > +	int rv;
> > >
> > >  	memset(attr, 0, sizeof(*attr));
> >
> > This line should go too. IB/core clears attr prior to call driver.
> >
> > Thanks
> >
>
> This can be done in a separate patch as this patch fixes a specific issue.

Whatever works for you, if you don't value your own time, go for it,
do separate patch for every line you are changing. It just looks crazy
to see changes like this:
 * changed line
 * line to be changed, but not changed
 * another changed line

Thanks

>
> Thanks,
> Kamal
>
> > >
> > > -	attr->active_speed = 2;
> > > -	attr->active_width = 2;
> > > +	rv = ib_get_eth_speed(base_dev, port, &attr->active_speed,
> > > +			 &attr->active_width);
> > >  	attr->gid_tbl_len = 1;
> > >  	attr->max_msg_sz = -1;
> > >  	attr->max_mtu = ib_mtu_int_to_enum(sdev->netdev->mtu);
> > > @@ -192,7 +193,7 @@ int siw_query_port(struct ib_device *base_dev, u8 port,
> > >  	 * attr->subnet_timeout = 0;
> > >  	 * attr->init_type_repy = 0;
> > >  	 */
> > > -	return 0;
> > > +	return rv;
> > >  }
> > >
> > >  int siw_get_port_immutable(struct ib_device *base_dev, u8 port,
> > > --
> > > 2.21.1
> > >
