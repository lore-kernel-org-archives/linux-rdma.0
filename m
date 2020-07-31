Return-Path: <SRS0=cwSi=BK=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8AF9C433E1
	for <linux-rdma@archiver.kernel.org>; Fri, 31 Jul 2020 14:22:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C3B6C208E4
	for <linux-rdma@archiver.kernel.org>; Fri, 31 Jul 2020 14:22:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596205328;
	bh=xOTUdTDtgFUE4tg3a96EHIpYVqLyrjXL2vfmrZmnmXk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=ZXUyPnMINtgEvP25fDINhwWTeBP+fvFIJh+S4Q6Dn1E+DufInbcAEhos8fjToyOIx
	 cVaqUqMbTOP192cj/E75j/kJiotVleaV2BBc1YrBIKhQgpwcYjUcmv+eOE4RAYRWjZ
	 PKgmYpt6xGPBahVVQQ6vKXG7KW1syjju3byp0kX0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728713AbgGaOWD (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Fri, 31 Jul 2020 10:22:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:33314 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728697AbgGaOWD (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Fri, 31 Jul 2020 10:22:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DF1D2208E4;
        Fri, 31 Jul 2020 14:22:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596205322;
        bh=xOTUdTDtgFUE4tg3a96EHIpYVqLyrjXL2vfmrZmnmXk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=A4AXijssIn9cJbmiigc2HnNHygj6LDX7SwRcO35y32gJ28dLyviyTLEowdbRQMFJH
         BICWi9NGqq7lv+plJy4BfbNlrvKnXbC3cv6D8jG5Iz7ArVn3YkA56UJKbZaespigHT
         izydEL7WKrOkda8awf2v5WwNko1uMTUmGdcPFhDk=
Date:   Fri, 31 Jul 2020 16:21:48 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Leon Romanovsky <leon@kernel.org>,
        Peilin Ye <yepeilin.cs@gmail.com>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Arnd Bergmann <arnd@arndb.de>,
        linux-kernel-mentees@lists.linuxfoundation.org,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        rds-devel@oss.oracle.com, linux-kernel@vger.kernel.org
Subject: Re: [Linux-kernel-mentees] [PATCH net] rds: Prevent kernel-infoleak
 in rds_notify_queue_get()
Message-ID: <20200731142148.GA1718799@kroah.com>
References: <20200730192026.110246-1-yepeilin.cs@gmail.com>
 <20200731045301.GI75549@unreal>
 <20200731053306.GA466103@kroah.com>
 <20200731053333.GB466103@kroah.com>
 <20200731140452.GE24045@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200731140452.GE24045@ziepe.ca>
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Fri, Jul 31, 2020 at 11:04:52AM -0300, Jason Gunthorpe wrote:
> On Fri, Jul 31, 2020 at 07:33:33AM +0200, Greg Kroah-Hartman wrote:
> > On Fri, Jul 31, 2020 at 07:33:06AM +0200, Greg Kroah-Hartman wrote:
> > > On Fri, Jul 31, 2020 at 07:53:01AM +0300, Leon Romanovsky wrote:
> > > > On Thu, Jul 30, 2020 at 03:20:26PM -0400, Peilin Ye wrote:
> > > > > rds_notify_queue_get() is potentially copying uninitialized kernel stack
> > > > > memory to userspace since the compiler may leave a 4-byte hole at the end
> > > > > of `cmsg`.
> > > > >
> > > > > In 2016 we tried to fix this issue by doing `= { 0 };` on `cmsg`, which
> > > > > unfortunately does not always initialize that 4-byte hole. Fix it by using
> > > > > memset() instead.
> > > > 
> > > > Of course, this is the difference between "{ 0 }" and "{}" initializations.
> > > 
> > > Really?  Neither will handle structures with holes in it, try it and
> > > see.
> > 
> > And if true, where in the C spec does it say that?
> 
> The spec was updated in C11 to require zero'ing padding when doing
> partial initialization of aggregates (eg = {})
> 
> """if it is an aggregate, every member is initialized (recursively)
> according to these rules, and any padding is initialized to zero
> bits;"""

But then why does the compilers not do this?

> The difference between {0} and the {} extension is only that {}
> reliably triggers partial initialization for all kinds of aggregates,
> while {0} has a number of edge cases where it can fail to compile.
> 
> IIRC gcc has cleared the padding during aggregate initialization for a
> long time.

Huh?  Last we checked a few months ago, no, it did not do that.

> Considering we have thousands of aggregate initializers it
> seems likely to me Linux also requires a compiler with this C11
> behavior to operate correctly.

Note that this is not an "operate correctly" thing, it is a "zero out
stale data in structure paddings so that data will not leak to
userspace" thing.

> Does this patch actually fix anything? My compiler generates identical
> assembly code in either case.

What compiler version?

thanks,

greg k-h
