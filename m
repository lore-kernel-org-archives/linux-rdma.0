Return-Path: <SRS0=3B/L=YR=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DE18CA9EAF
	for <linux-rdma@archiver.kernel.org>; Thu, 24 Oct 2019 16:13:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 515952166E
	for <linux-rdma@archiver.kernel.org>; Thu, 24 Oct 2019 16:13:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1571933590;
	bh=O3p+jfTVvKhy0rJ4AQs5aB4bvLCcq0qw8rRUIQByXeI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=1li4f9e9zwFiiY7oEVsksAj8RWOsT861ccP1qVaiesejl6aUetiAuYsldDKkXA9Pj
	 WGKiSbmnEzQhTO2lPzA5ysn2fNEReWmaqJJf2VXXfnoUNDnklWgtbFj0tUsUJUSUJP
	 AlPWbUYskbK5MhZceUrpNnNxNThrOECYXYYO1JV0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405953AbfJXQNJ (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 24 Oct 2019 12:13:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:51796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405661AbfJXQNJ (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Thu, 24 Oct 2019 12:13:09 -0400
Received: from localhost (unknown [77.137.89.37])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7D42320659;
        Thu, 24 Oct 2019 16:13:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571933589;
        bh=O3p+jfTVvKhy0rJ4AQs5aB4bvLCcq0qw8rRUIQByXeI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PEvbnJWqD0/2ODAmyYfizl1otx14YZWr9GGv8sw4S4ykt/CgBo2kQZgynxv3d2n8B
         pFCQUE5U2ywZyE5UTyRv+eAkBvsOBCQ0Ae/SVxFRBXjJOYOwa4OMCmhX2vHHYUTYEn
         j2tipkLXkt8HCC16ADjFJIRdAtsmXAYwG5+Jchvs=
Date:   Thu, 24 Oct 2019 19:13:05 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Doug Ledford <dledford@redhat.com>,
        Parav Pandit <parav@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>
Subject: Re: [PATCH rdma-next] IB/core: Avoid deadlock during netlink message
 handling
Message-ID: <20191024161305.GU4853@unreal>
References: <20191015080733.18625-1-leon@kernel.org>
 <20191024131743.GA24174@ziepe.ca>
 <20191024132607.GR4853@unreal>
 <20191024135017.GT23952@ziepe.ca>
 <20191024160252.GS4853@unreal>
 <20191024160810.GV23952@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191024160810.GV23952@ziepe.ca>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Thu, Oct 24, 2019 at 01:08:10PM -0300, Jason Gunthorpe wrote:
> On Thu, Oct 24, 2019 at 07:02:52PM +0300, Leon Romanovsky wrote:
> > On Thu, Oct 24, 2019 at 10:50:17AM -0300, Jason Gunthorpe wrote:
> > > On Thu, Oct 24, 2019 at 04:26:07PM +0300, Leon Romanovsky wrote:
> > > > On Thu, Oct 24, 2019 at 10:17:43AM -0300, Jason Gunthorpe wrote:
> > > > > On Tue, Oct 15, 2019 at 11:07:33AM +0300, Leon Romanovsky wrote:
> > > > >
> > > > > > diff --git a/drivers/infiniband/core/netlink.c b/drivers/infiniband/core/netlink.c
> > > > > > index 81dbd5f41bed..a3507b8be569 100644
> > > > > > +++ b/drivers/infiniband/core/netlink.c
> > > > > > @@ -42,9 +42,12 @@
> > > > > >  #include <linux/module.h>
> > > > > >  #include "core_priv.h"
> > > > > >
> > > > > > -static DEFINE_MUTEX(rdma_nl_mutex);
> > > > > >  static struct {
> > > > > > -	const struct rdma_nl_cbs   *cb_table;
> > > > > > +	const struct rdma_nl_cbs __rcu *cb_table;
> > > > > > +	/* Synchronizes between ongoing netlink commands and netlink client
> > > > > > +	 * unregistration.
> > > > > > +	 */
> > > > > > +	struct srcu_struct unreg_srcu;
> > > > >
> > > > > A srcu in every index is serious overkill for this. Lets just us a
> > > > > rwsem:
> > > >
> > > > I liked previous variant more than rwsem, but it is Parav's patch.
> > >
> > > Why? srcu is a huge data structure and slow on unregister
> >
> > The unregister time is not so important for those IB/core modules.
> > I liked SRCU because it doesn't have *_ONCE() macros and smb_* calls.
>
> It does, they are just hidden under other macros..
>
> > Maybe wrong here, but the extra advantage of SRCU is that we are already
> > using that mechanism in uverbs and my assumption that SRCU will greatly
> > enjoy shared grace period.
>
> Hm, I'm not sure it works like that, the grace periods would be consecutive

Whatever, the most important part of Parav's patch that we removed
global lock from RDMA netlink interface.

Thanks

>
> Jason
