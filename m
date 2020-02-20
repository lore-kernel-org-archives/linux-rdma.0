Return-Path: <SRS0=rt4E=4I=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2EE9C11D05
	for <linux-rdma@archiver.kernel.org>; Thu, 20 Feb 2020 13:44:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B764D208C4
	for <linux-rdma@archiver.kernel.org>; Thu, 20 Feb 2020 13:44:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1582206269;
	bh=vMXsVuppQGglwVUncyAvjmaRo0Q2RZhz2WiB2SCoCi8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=y9jRQjK6wmojLkwcOFrkR86dVCb8Yd4JlnEVclREyd69X95RlNQ/2kWlUGtW5/i7F
	 /DHGlwHJKvGyf09IumoH+yOdzEeafV4ARAAvhAt5o+2O91RYkHxs6x2+BGHHi6TTrR
	 qZp4DYTas7ocxzea0L0I9u0n6BMZEF9MqeWUM9c4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728139AbgBTNo2 (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 20 Feb 2020 08:44:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:60568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727943AbgBTNo2 (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Thu, 20 Feb 2020 08:44:28 -0500
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 972BA206EF;
        Thu, 20 Feb 2020 13:44:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582206268;
        bh=vMXsVuppQGglwVUncyAvjmaRo0Q2RZhz2WiB2SCoCi8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Pl0y5K2j/lwPpUSjzFf8PZhZBh/87WhrtKecwQg3jZonK/ld9JQQDZB5ByXgRmcP/
         c4JZaWH900DwER59dC0V1Oe/3+LEMsJhoCBkUzHq2v5PwZyZ8IBet/R4+Be5EPfN9X
         0nGpQoAyCoyRMlyOvgIXJLo+2Amq5iHR8RzvSwI4=
Date:   Thu, 20 Feb 2020 15:44:23 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Dennis Dalessandro <dennis.dalessandro@intel.com>
Cc:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>
Subject: Re: [PATCH rdma-next 2/2] RDMA/opa_vnic: Delete driver version
Message-ID: <20200220134423.GC209126@unreal>
References: <20200220071239.231800-1-leon@kernel.org>
 <20200220071239.231800-3-leon@kernel.org>
 <a5b477e5-1c2b-055b-b617-76351b290adf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a5b477e5-1c2b-055b-b617-76351b290adf@intel.com>
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Thu, Feb 20, 2020 at 08:32:35AM -0500, Dennis Dalessandro wrote:
> On 2/20/2020 2:12 AM, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@mellanox.com>
> >
> > The default version provided by "ethtool -i" it the correct way
> > to identify Driver version. There is no need to overwrite it.
> >
> > Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
> > ---
> >   drivers/infiniband/ulp/opa_vnic/opa_vnic_ethtool.c  | 2 --
> >   drivers/infiniband/ulp/opa_vnic/opa_vnic_internal.h | 1 -
> >   drivers/infiniband/ulp/opa_vnic/opa_vnic_vema.c     | 5 -----
> >   3 files changed, 8 deletions(-)
> >
> > diff --git a/drivers/infiniband/ulp/opa_vnic/opa_vnic_ethtool.c b/drivers/infiniband/ulp/opa_vnic/opa_vnic_ethtool.c
> > index 8ad7da989a0e..42d557dff19d 100644
> > --- a/drivers/infiniband/ulp/opa_vnic/opa_vnic_ethtool.c
> > +++ b/drivers/infiniband/ulp/opa_vnic/opa_vnic_ethtool.c
> > @@ -125,8 +125,6 @@ static void vnic_get_drvinfo(struct net_device *netdev,
> >   			     struct ethtool_drvinfo *drvinfo)
> >   {
> >   	strlcpy(drvinfo->driver, opa_vnic_driver_name, sizeof(drvinfo->driver));
> > -	strlcpy(drvinfo->version, opa_vnic_driver_version,
> > -		sizeof(drvinfo->version));
> >   	strlcpy(drvinfo->bus_info, dev_name(netdev->dev.parent),
> >   		sizeof(drvinfo->bus_info));
> >   }
>
> Is there a patch series to get rid of drvinfo->version? Seems to me if we
> don't want drivers to set it then we don't need it to begin with do we?

Unfortunately struct ethtool_drvinfo is defined in include/uapi/linux/ethtool.h
and we can't change it without breaking ethtool.

My WIP in progress branch (based on net-next) is located here:
https://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git/log/?h=ethtool

At the end of my journey, we will have checkpatch.pl patch and update of
coding style.

>
> Regardless I don't have any objections to the patch. We've been down this
> road with version numbers and I believe this was added to vnic specifically
> to fill in something for ethtool.

And now, you will be able to see real version :)

>
> Reviewed-by: Dennis Dalessandro <dennis.dalessandro@intel.com>

Thanks

>
> -Denny
