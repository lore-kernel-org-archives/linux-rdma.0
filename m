Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B884C433B4
	for <linux-rdma@archiver.kernel.org>; Thu,  1 Apr 2021 08:13:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F2C7D610A0
	for <linux-rdma@archiver.kernel.org>; Thu,  1 Apr 2021 08:13:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233599AbhDAINC (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 1 Apr 2021 04:13:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:48538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233527AbhDAIMr (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Thu, 1 Apr 2021 04:12:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 15EFC610A0;
        Thu,  1 Apr 2021 08:12:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617264766;
        bh=fRzP41BaiQHS3n+rjzagFHbLt9hz85fuauhbnUAA9Zg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IOquNj24Un07HRSMTKd0dhG7s5sLkwJGM4wDvZVK/SsoVMAZ6Tf2itU0qHmKU16Ef
         juFpoBMkjijUpaXhaSeIvD+fbv0ehI55MAoAQHO25m8C9j+hZ/nHm4JbX7xyYBiCjd
         g8EAW1QzsabsZDcyhRXzN3vF80sA29tIXg3/Ae1QGP4Yob5xVPPfjGL5snt2Wh5uqv
         whJjq/V4hVPfv9FsCJ0ilhh6jpwlTh23fEd7kOq2EE52bKaRlpBcRccsH0lyr/awMo
         5kKTvAu8gR5wC33CKeP8Lhke290e/jZ4TQsi1ZGNtZ54fboUrv4gAWNCWpGAoWAU61
         kTS+uctSpcFgQ==
Date:   Thu, 1 Apr 2021 11:12:43 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Doug Ledford <dledford@redhat.com>,
        Mark Zhang <markzhang@nvidia.com>, linux-rdma@vger.kernel.org
Subject: Re: [PATCH rdma-next 3/6] IB/cm: Remove "mad_agent" parameter of
 ib_modify_mad
Message-ID: <YGWAexN7nZx5ac9J@unreal>
References: <20210318100309.670344-1-leon@kernel.org>
 <20210318100309.670344-4-leon@kernel.org>
 <20210329124101.GA887238@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210329124101.GA887238@nvidia.com>
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Mon, Mar 29, 2021 at 09:41:01AM -0300, Jason Gunthorpe wrote:
> On Thu, Mar 18, 2021 at 12:03:06PM +0200, Leon Romanovsky wrote:
> 
> > +static void cm_send_free_msg(struct ib_mad_send_buf *msg)
> > +{
> > +	struct cm_id_private *cm_id_priv;
> > +
> > +	cm_id_priv = msg->context[0];
> > +	if (!cm_id_priv || cm_id_priv->msg != msg) {
> > +		cm_free_msg(msg);
> > +		return;
> > +	}
> > +
> > +	spin_lock_irq(&cm_id_priv->lock);
> > +	cm_free_msg(msg);
> > +	cm_id_priv->msg = NULL;
> > +	spin_unlock_irq(&cm_id_priv->lock);
> > +}
> 
> Either the whole sequence should be inside the lock or nothing should
> be in the lock..

I see the race now, thanks for pointing it.

> 
> Oh this is all messed up and needs a big fix. Review and include this
> in the series and drop the above function.
> 
> https://github.com/jgunthorpe/linux/commits/for-markz

We will take a look on it.

Thanks

> 
> Jason
