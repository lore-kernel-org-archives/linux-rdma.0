Return-Path: <SRS0=8BIe=CP=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5637C43461
	for <linux-rdma@archiver.kernel.org>; Sun,  6 Sep 2020 07:44:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 52F702080A
	for <linux-rdma@archiver.kernel.org>; Sun,  6 Sep 2020 07:44:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599378289;
	bh=DpXKfmfXCNaSc9HmifZDTsjc/7zhA5JshWVZZTzV8yI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=sxYgwnSOGODMklXB1w8wW8z0etT7p7ehBTJnZ1JnlNrXajZPRAc24t7Zq53fnt9hY
	 S27DkMvLhGnsrmt611Blznk9koo+w0oRzYsBnUyuXWti+tAcDdOB9ZyexGodLgnWF7
	 uf1S9ACqCcTvvKboEjxWhsh8tUEFTL47HWip7beM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725497AbgIFHos (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Sun, 6 Sep 2020 03:44:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:39062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725306AbgIFHor (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Sun, 6 Sep 2020 03:44:47 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6A50520759;
        Sun,  6 Sep 2020 07:44:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599378287;
        bh=DpXKfmfXCNaSc9HmifZDTsjc/7zhA5JshWVZZTzV8yI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VZexxxcUIchIDvH8U9kILj8j0qIR1YzFRBdeNc/29r7hhzTS7n+pItFOfY9DhTChB
         bagfSwKS6TuDloGzOf05vsSM18P8VbmniOQajGxCzPREF4LrtQvMs3Dj5QqtKT1UBb
         GsMNraiRv1gzrVMtVXBpYtHLUVM0scr3FybBwGEY=
Date:   Sun, 6 Sep 2020 10:44:42 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Ka-Cheong Poon <ka-cheong.poon@oracle.com>
Cc:     Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org
Subject: Re: Finding the namespace of a struct ib_device
Message-ID: <20200906074442.GE55261@unreal>
References: <5fa7f367-49df-fb1d-22d0-9f1dd1b76915@oracle.com>
 <20200903173910.GO24045@ziepe.ca>
 <a5899aa9-4553-1307-0688-f07f3a919ce8@oracle.com>
 <20200904113244.GP24045@ziepe.ca>
 <be812cb4-4b80-5ee5-4ed8-9d44f0a06edd@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <be812cb4-4b80-5ee5-4ed8-9d44f0a06edd@oracle.com>
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Fri, Sep 04, 2020 at 10:02:10PM +0800, Ka-Cheong Poon wrote:
> On 9/4/20 7:32 PM, Jason Gunthorpe wrote:
> > On Fri, Sep 04, 2020 at 12:01:12PM +0800, Ka-Cheong Poon wrote:
> > > On 9/4/20 1:39 AM, Jason Gunthorpe wrote:
> > > > On Thu, Sep 03, 2020 at 10:02:01PM +0800, Ka-Cheong Poon wrote:
> > > > > When a struct ib_client's add() function is called. is there a
> > > > > supported method to find out the namespace of the passed in
> > > > > struct ib_device?  There is rdma_dev_access_netns() but it does
> > > > > not return the namespace.  It seems that it needs to have
> > > > > something like the following.
> > > > >
> > > > > struct net *rdma_dev_to_netns(struct ib_device *ib_dev)
> > > > > {
> > > > >          return read_pnet(&ib_dev->coredev.rdma_net);
> > > > > }
> > > > >
> > > > > Comments?
> > > >
> > > > I suppose, but why would something need this?
> > >
> > >
> > > If the client needs to allocate stuff for the namespace
> > > related to that device, it needs to know the namespace of
> > > that device.  Then when that namespace is deleted, the
> > > client can clean up those related stuff as the client's
> > > namespace exit function can be called before the remove()
> > > function is triggered in rdma_dev_exit_net().  Without
> > > knowing the namespace of that device, coordination cannot
> > > be done.
> >
> > Since each device can only be in one namespace, why would a client
> > ever need to allocate at a level more granular than a device?
>
>
> A client wants to have namespace specific info.  If the
> device belongs to a namespace, it wants to associate those
> info with that device.  When a namespace is deleted, the
> info will need to be deleted.  You can consider the info
> as associated with both a namespace and a device.

Can you be more specific about which info you are talking about?
And what is the client that is net namespace-aware from one side,
but from another separate data between them "manually"?

Thanks

>
>
> --
> K. Poon
> ka-cheong.poon@oracle.com
>
>
