Return-Path: <SRS0=bifO=63=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 230A6CA90AF
	for <linux-rdma@archiver.kernel.org>; Wed, 13 May 2020 10:21:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EB1D6206D6
	for <linux-rdma@archiver.kernel.org>; Wed, 13 May 2020 10:21:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1589365299;
	bh=/m78hhUVz6galaByImJTbbKYbWhchd6RPPZC4AjuCdI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=EF0dbCBzoyBgIQQ+Xw2VVhVE51JIoNhUgFvykhFGXBlFOyvQjKAbptUOuBb7p9cfB
	 4Xk7OgD2b6gAYBY9UXvA+o6YEV5lqZiCLPCN/Na29AONM8HpmCRdQETFt1ilBWxnd7
	 HZdteKp6fYs77viAV8RRNLHTxo4hOa/nqrOy1tvo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732382AbgEMKVh (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 13 May 2020 06:21:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:47904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726345AbgEMKVh (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Wed, 13 May 2020 06:21:37 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DC554205ED;
        Wed, 13 May 2020 10:21:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589365296;
        bh=/m78hhUVz6galaByImJTbbKYbWhchd6RPPZC4AjuCdI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QnzejKypt1eSn4jfQ34F++74a8ZHAyKSKLMldtnKNE1Pc+AnelOyMavk3awfSuwK1
         MEDvnzeRkD2VxDnMyCnVNbrWhhwEvM9f8h0vSQ/iZVTtNSUOX/zgVTv/saDT7mKzZQ
         Gsx/7v7eWqxgjGnMtTqSer8w2zfOvkCnojLXrI8w=
Date:   Wed, 13 May 2020 13:21:32 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Kamal Heib <kamalheib1@gmail.com>
Cc:     linux-rdma@vger.kernel.org, Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH for-rc] RDMA/srpt: Fix disabling device management
Message-ID: <20200513102132.GW4814@unreal>
References: <20200511222918.62576-1-kamalheib1@gmail.com>
 <20200513072203.GR4814@unreal>
 <20200513100204.GA92901@kheib-workstation>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200513100204.GA92901@kheib-workstation>
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Wed, May 13, 2020 at 01:02:04PM +0300, Kamal Heib wrote:
> On Wed, May 13, 2020 at 10:22:03AM +0300, Leon Romanovsky wrote:
> > On Tue, May 12, 2020 at 01:29:18AM +0300, Kamal Heib wrote:
> > > Avoid disabling device management for devices that don't support
> > > Management datagrams (MADs) by checking if the "mad_agent" pointer is
> > > initialized before calling ib_modify_port, also change the error message
> > > to a warning and make it more informative.
> > >
> > > Fixes: 09f8a1486dca ("RDMA/srpt: Fix handling of SR-IOV and iWARP ports")
> > > Signed-off-by: Kamal Heib <kamalheib1@gmail.com>
> > > ---
> > >  drivers/infiniband/ulp/srpt/ib_srpt.c | 8 ++++++--
> > >  1 file changed, 6 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
> > > index 7ed38d1cb997..7b21792ab6f7 100644
> > > --- a/drivers/infiniband/ulp/srpt/ib_srpt.c
> > > +++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
> > > @@ -625,14 +625,18 @@ static void srpt_unregister_mad_agent(struct srpt_device *sdev)
> > >  		.clr_port_cap_mask = IB_PORT_DEVICE_MGMT_SUP,
> > >  	};
> > >  	struct srpt_port *sport;
> > > +	int ret;
> > >  	int i;
> > >
> > >  	for (i = 1; i <= sdev->device->phys_port_cnt; i++) {
> > >  		sport = &sdev->port[i - 1];
> > >  		WARN_ON(sport->port != i);
> > > -		if (ib_modify_port(sdev->device, i, 0, &port_modify) < 0)
> > > -			pr_err("disabling MAD processing failed.\n");
> > >  		if (sport->mad_agent) {
> > > +			ret = ib_modify_port(sdev->device, i, 0, &port_modify);
> > > +			if (ret < 0)
> > > +				pr_warn("%s-%d: disabling device management failed (%d). Note: this is expected if SR-IOV is enabled.\n",
> > > +					dev_name(&sport->sdev->device->dev),
> >
> > The ib_modify_port() shouldn't be called if it expected to fail.
> >
> > Thanks
>
> OK, Do you know if there is a way to check if the created ib device is
> for VF to avoid calling ib_modify_port()?

The "is_virtfn" field inside pci_dev will give this information,
but I don't know why it is expected to fail here.

Thanks

>
> Thanks,
> Kamal
>
> >
> > > +					sport->port, ret);
> > >  			ib_unregister_mad_agent(sport->mad_agent);
> > >  			sport->mad_agent = NULL;
> > >  		}
> > > --
> > > 2.25.4
> > >
