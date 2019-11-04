Return-Path: <SRS0=M/HP=Y4=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EE52CA9EB5
	for <linux-rdma@archiver.kernel.org>; Mon,  4 Nov 2019 21:08:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D9CAB20659
	for <linux-rdma@archiver.kernel.org>; Mon,  4 Nov 2019 21:08:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1572901729;
	bh=AsWyQOHofbH8ShY+WCtcEmbwctFgrCfEBc+mq1J9PtQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=khqVT+dp5zT7t3778oXX7kmE8dECbO18GBf4pE5STjlFuoQg9jbi7/DoAwr4UMQxk
	 OzngjSV0VscwXRscbI0ylHxd2tBNsZQ4jdC7ADroLX0FJRoJE2pSfGlC//mS0Rav5L
	 h1z3/nstQCTi1kJLmcB6/ce7JT7Z5h8+nkjs2psk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728510AbfKDVIs (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 4 Nov 2019 16:08:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:52398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728409AbfKDVIs (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Mon, 4 Nov 2019 16:08:48 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AE07320659;
        Mon,  4 Nov 2019 21:08:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572901727;
        bh=AsWyQOHofbH8ShY+WCtcEmbwctFgrCfEBc+mq1J9PtQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uHC04ocJT79j3m0aBOrUal1yRw+UW4GSI1qiYzbvckjTJByrpr6KKc7TE+y1iPjg+
         J/tgaZz3aztDmUPof2+Xedov5C2IbPgI0xyJCz9Y23nZ+3xrU28Q2Vn+S7oaWask7o
         6utgpTFD+U3qAQGBAagsvBvkX2cnjrIxRTx9oev0=
Date:   Mon, 4 Nov 2019 22:08:44 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Leon Romanovsky <leon@kernel.org>,
        Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] IB: mlx5: no need to check return value of
 debugfs_create functions
Message-ID: <20191104210844.GB2460177@kroah.com>
References: <20191104074141.GA1292396@kroah.com>
 <20191104205914.GI30938@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191104205914.GI30938@ziepe.ca>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Mon, Nov 04, 2019 at 04:59:14PM -0400, Jason Gunthorpe wrote:
> On Mon, Nov 04, 2019 at 08:41:41AM +0100, Greg Kroah-Hartman wrote:
> > When calling debugfs functions, there is no need to ever check the
> > return value.  The function can work or not, but the code logic should
> > never do something different based on this.
> > 
> > Cc: Leon Romanovsky <leon@kernel.org>
> > Cc: Doug Ledford <dledford@redhat.com>
> > Cc: Jason Gunthorpe <jgg@ziepe.ca>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> >  drivers/infiniband/hw/mlx5/main.c    | 62 +++++++---------------------
> >  drivers/infiniband/hw/mlx5/mlx5_ib.h |  9 +---
> >  2 files changed, 16 insertions(+), 55 deletions(-)
> > 
> > Note, I kind of need to take this through my tree now as I broke the
> > build due to me changing the use of debugfs_create_atomic_t() in my
> > tree and not noticing this being used here.  Sorry about that, any
> > objections?
> 
> I think it is fine, I don't forsee conflicts here at this point.

Thanks!

> To be clear, the build is broken in your tree and in linux-next?

Yeah, my fault :(

> > And 0-day seems really broken to have missed this for the past months,
> > ugh, I need to stop relying on it...
> 
> Yes, I've noticed it missing a lot of stuff now too. Not sure why

It is very hit-or-miss these days :(

thanks,

greg k-h
