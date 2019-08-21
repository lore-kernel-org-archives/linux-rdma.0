Return-Path: <SRS0=E+a+=WR=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4239C3A59E
	for <linux-rdma@archiver.kernel.org>; Wed, 21 Aug 2019 16:32:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8AE5A22DA7
	for <linux-rdma@archiver.kernel.org>; Wed, 21 Aug 2019 16:32:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1566405126;
	bh=sK8IIqMsa2wlfVEuse3FVJDTnTyvDGPnWidreRUMK6k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=i8twfAIO8GTPvux/Z3fI2We9G4oZfXiC1/HpTv82hsRZNzuQ91sDuYT+fo2AALhUv
	 JbxkyFF0dYH7qt1zQjTAUWeKW/dCjWfGwsyfBtTA4Yttzu/pcyPJNbduToYNsd8v4w
	 yFQx2yONIFOtHpBAXGX6fkvn6uqPliIKCsl92gEE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727874AbfHUQcG (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 21 Aug 2019 12:32:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:54590 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727822AbfHUQcF (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Wed, 21 Aug 2019 12:32:05 -0400
Received: from localhost (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 52488216F4;
        Wed, 21 Aug 2019 16:32:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566405124;
        bh=sK8IIqMsa2wlfVEuse3FVJDTnTyvDGPnWidreRUMK6k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=yYcdbhuPVpaFDfaoO5VgoW2abCcs4gO7psJX0B+tEGSmjnX3wY37Fd6UAKBT8o2/l
         7Z7sgZl2CT/MWbvhG9yGYXVKvEqbKWQn3d4XVJTN5VZvdrZJ/AaQi54ghcCozKrISv
         p9RWQN9nk14SCszCoJc4R5sWmMPH3fejcoHs9gkc=
Date:   Wed, 21 Aug 2019 19:30:59 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Doug Ledford <dledford@redhat.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Bernard Metzler <bmt@zurich.ibm.com>,
        linux-rdma@vger.kernel.org
Subject: Re: [PATCH] siw: Fix potential NULL pointer in siw_connect().
Message-ID: <20190821163059.GH4459@mtr-leonro.mtl.com>
References: <20190819140257.19319-1-bmt@zurich.ibm.com>
 <30814d3ca3b06c83b31f9255f140fdf2115e83e5.camel@redhat.com>
 <20190821125645.GE3964@kadam>
 <adc716f5d2105a3cc7978873cd0f14503ae323d8.camel@redhat.com>
 <20190821141225.GB8653@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190821141225.GB8653@ziepe.ca>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Wed, Aug 21, 2019 at 11:12:25AM -0300, Jason Gunthorpe wrote:
> On Wed, Aug 21, 2019 at 09:39:50AM -0400, Doug Ledford wrote:
> > On Wed, 2019-08-21 at 15:56 +0300, Dan Carpenter wrote:
> > > On Tue, Aug 20, 2019 at 12:05:33PM -0400, Doug Ledford wrote:
> > > > Please take a look (I pushed it out to my wip/dl-for-rc branch) so
> > > > you
> > > > can see what I mean about how to make both a simple subject line and
> > > > a
> > > > decent commit message.  Also, no final punctuation on the subject
> > > > line,
> > > > and try to keep the subject length <= 50 chars total.  If you have
> > > > to go
> > > > over to have a decent subject, then so be it, but we strive for that
> > > > 50
> > > > char limit to make a subject stay on one line when displayed using
> > > > git
> > > > log --oneline.
> > >
> > > 50 is really small.
> >
> > 50 is the vim syntax highlighting suggested limit.  You can go over,
> > which is why I indicated it was a soft limit, but there you are.  It
> > leaves room for the displayed hash length to grow as well.
>
> I use 75 for all text in the commit message, as per
> Documentation/process/submitting-patches.rst

checkpatch.pl will give warning if you have subject line above 75 chars.

>
> People using 'git log --oneline' should have terminals wider than 80
> :)

I like small terminals :(, it fits nicely with tiled WM on
my laptop screen.

>
> The bigger question is if the first character after the subject tag
> should be uppper case or lower case <hum>

It doesn't matter as long as person submitting patches is consistent.

Thanks

>
> Jason
