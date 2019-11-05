Return-Path: <SRS0=rIHD=Y5=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53CD7CA9EDB
	for <linux-rdma@archiver.kernel.org>; Tue,  5 Nov 2019 07:24:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 27AC3217F5
	for <linux-rdma@archiver.kernel.org>; Tue,  5 Nov 2019 07:24:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1572938670;
	bh=2/27uEOZoTHe7dXYgpVVeEFZrEjzn3Ai+nbej1SEAfI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=YSqq59cYfTg2iZLax/Ox5VT1iX5L0BAWHXRanEBNjEaV5LDGj3OQvAoTr8SM9ll2T
	 l/gEbWY/iZmmuQ+n36oh4h984l+uKL2Nxtj3oUhekwLCbM9jEoYTHaFm5P2tLhlZAC
	 pBGA3ofKV60/mbu3jWjfuA/C0O12LCWC0SJPz6wc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387499AbfKEHY3 (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 5 Nov 2019 02:24:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:39848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387482AbfKEHY3 (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Tue, 5 Nov 2019 02:24:29 -0500
Received: from localhost (host6-102.lan-isdn.imaginet.fr [195.68.6.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0F6F2206BA;
        Tue,  5 Nov 2019 07:24:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572938668;
        bh=2/27uEOZoTHe7dXYgpVVeEFZrEjzn3Ai+nbej1SEAfI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=goBtmMCUQDGZB8aEkC5HYAZSiW/upaQt9Xfyj0Vwfj8lhfqRUOPfXd9ydXQl1M5C3
         sEhj8/FXasLAy/RRr9hQq97/pOf0xWmAAOIATC/A2PfgYo3+OZbFyCiKkKReT/qPbi
         e1o32ZCE494aW4pxz9h7zFTwbo2sbFbNGN5u98Zw=
Date:   Tue, 5 Nov 2019 08:24:25 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Mark Bloch <markb@mellanox.com>
Cc:     Leon Romanovsky <leon@kernel.org>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] IB: mlx5: no need to check return value of
 debugfs_create functions
Message-ID: <20191105072425.GD2587462@kroah.com>
References: <20191104074141.GA1292396@kroah.com>
 <50a30aa3-3924-4fd1-f644-2fd2b184ec0e@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50a30aa3-3924-4fd1-f644-2fd2b184ec0e@mellanox.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Tue, Nov 05, 2019 at 12:48:16AM +0000, Mark Bloch wrote:
> 
> 
> On 11/3/19 11:41 PM, Greg Kroah-Hartman wrote:
> > When calling debugfs functions, there is no need to ever check the
> > return value.  The function can work or not, but the code logic should
> > never do something different based on this.
> > 
> > Cc: Leon Romanovsky <leon@kernel.org>
> > Cc: Doug Ledford <dledford@redhat.com>
> > Cc: Jason Gunthorpe <jgg@ziepe.ca>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > ---
> >  drivers/infiniband/hw/mlx5/main.c    | 62 +++++++---------------------
> >  drivers/infiniband/hw/mlx5/mlx5_ib.h |  9 +---
> >  2 files changed, 16 insertions(+), 55 deletions(-)
> > 
> > Note, I kind of need to take this through my tree now as I broke the
> > build due to me changing the use of debugfs_create_atomic_t() in my
> > tree and not noticing this being used here.  Sorry about that, any
> > objections?
> > 
> > And 0-day seems really broken to have missed this for the past months,
> > ugh, I need to stop relying on it...
> > 
> > 
> > diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
> > index 831539419c30..059db0610445 100644
> > --- a/drivers/infiniband/hw/mlx5/main.c
> > +++ b/drivers/infiniband/hw/mlx5/main.c
> > @@ -5710,11 +5710,10 @@ static int mlx5_ib_rn_get_params(struct ib_device *device, u8 port_num,
> >  
> >  static void delay_drop_debugfs_cleanup(struct mlx5_ib_dev *dev)
> >  {
> > -	if (!dev->delay_drop.dbg)
> > +	if (!dev->delay_drop.dir_debugfs)
> 
> Shouldn't this be:
> if (IS_ERR(dev->delay_drop.dir_debugfs))
> 	return;
> ?

No, really there should not be any check at all as there is no problem
taking the result of a debugfs call and feeding it back into another
call.  There is no need to check these return values at all.

So the code should just be dropped, I can do that as a follow-on if you
want me to.

> >  		return;
> > -	debugfs_remove_recursive(dev->delay_drop.dbg->dir_debugfs);
> > -	kfree(dev->delay_drop.dbg);
> > -	dev->delay_drop.dbg = NULL;
> > +	debugfs_remove_recursive(dev->delay_drop.dir_debugfs);
> > +	dev->delay_drop.dir_debugfs = NULL;
> 
> Thinking about this more, we already do something like this:
> if (IS_ERR_OR_NULL(dentry))
> 		return;
> inside debugfs_remove_recursive(), so this entire function can be reduced
> to just calling debugfs_remove_recursive().

Very true, I was trying to keep the patch simple :)

thanks,

greg k-h
