Return-Path: <linux-rdma-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6DB6C54EAA
	for <linux-rdma@archiver.kernel.org>; Thu, 26 Jan 2023 12:19:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236887AbjAZMTS (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 26 Jan 2023 07:19:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236130AbjAZMTB (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Thu, 26 Jan 2023 07:19:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2877C37F3B;
        Thu, 26 Jan 2023 04:19:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D58B2B81D88;
        Thu, 26 Jan 2023 12:18:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09BA5C433EF;
        Thu, 26 Jan 2023 12:18:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674735537;
        bh=lU2LeSFbTu1l/v/xSG9/yai4jdQ2YFJYYUAMUnfQF/Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=d1K8qIfUwJGLmWPzRZ7gyWxhUUGXgIuij8OoK/h4sejVNrjOex1UVAS1By0fFgYzS
         baJBmWC/KollN3B3f4S/WNOtzEQeNfSBFh2fW8hTJcd4tnmRHyCcJd/bV6FTPewCCK
         oaYBNY+D2nrb5PeD6nwBF9rhawxg6QnFOjHOP2jZdbRWku2Vh1xiGpVwku+F9yKnuQ
         v/vMsuYbZZH9Tl4/ICEqCvvaTksqrz3jWiRaUbk/XTaFJ6jYrUvy9icfehq4wbugrI
         tczwd6nOIA0sNdKa70SZMtXvzgmNvRQtY91kzGvLqwU0WgH8S2ua/QiArT9PlSQx/q
         6wnA9EFZ5TTcQ==
Date:   Thu, 26 Jan 2023 14:18:53 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Dan Carpenter <error27@gmail.com>
Cc:     Long Li <longli@microsoft.com>,
        Ajay Sharma <sharmaajay@microsoft.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Dexuan Cui <decui@microsoft.com>, linux-rdma@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] RDMA/mana_ib: Prevent array underflow in
 mana_ib_create_qp_raw()
Message-ID: <Y9JvrfOezthLscEP@unreal>
References: <Y8/3Vn8qx00kE9Kk@kili>
 <Y9JThu/RSCGKAnTH@unreal>
 <Y9JdXfJvGhrJeLF7@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y9JdXfJvGhrJeLF7@kadam>
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Thu, Jan 26, 2023 at 02:00:45PM +0300, Dan Carpenter wrote:
> On Thu, Jan 26, 2023 at 12:18:46PM +0200, Leon Romanovsky wrote:
> > On Tue, Jan 24, 2023 at 06:20:54PM +0300, Dan Carpenter wrote:
> > > The "port" comes from the user and if it is zero then the:
> > > 
> > > 	ndev = mc->ports[port - 1];
> > > 
> > > assignment does an out of bounds read.  I have changed the if
> > > statement to fix this and to mirror how it is done in
> > > mana_ib_create_qp_rss().
> > > 
> > > Fixes: 0266a177631d ("RDMA/mana_ib: Add a driver for Microsoft Azure Network Adapter")
> > > Signed-off-by: Dan Carpenter <error27@gmail.com>
> > > ---
> > >  drivers/infiniband/hw/mana/qp.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > diff --git a/drivers/infiniband/hw/mana/qp.c b/drivers/infiniband/hw/mana/qp.c
> > > index ea15ec77e321..54b61930a7fd 100644
> > > --- a/drivers/infiniband/hw/mana/qp.c
> > > +++ b/drivers/infiniband/hw/mana/qp.c
> > > @@ -289,7 +289,7 @@ static int mana_ib_create_qp_raw(struct ib_qp *ibqp, struct ib_pd *ibpd,
> > >  
> > >  	/* IB ports start with 1, MANA Ethernet ports start with 0 */
> > >  	port = ucmd.port;
> > > -	if (ucmd.port > mc->num_ports)
> > > +	if (port < 1 || port > mc->num_ports)
> > 
> > Why do I see port in mana_ib_create_qp? It should come from ib_qp_init_attr.
> 
> I am so confused by this question.  Are you asking me?  

I asked *@microsoft folks.

> This is the _raw function. 

_raw comes from QP type, it is not raw (basic) in a sense you imagine.

> I'm now sure what mana_ib_create_qp() has to do with it.

All create QP calls come through same verbs interface.
ib_create_qp_user->create_qp->.create_qp->mana_ib_create_qp->mana_ib_create_qp_raw

> 
> The port comes from ib_copy_from_udata() which is just a wrapper around
> copy_from_user().

Right, and it shouldn't.

> 
> regards,
> dan carpenter
> 
