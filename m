Return-Path: <SRS0=u4AL=46=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E7EEC10DCE
	for <linux-rdma@archiver.kernel.org>; Fri, 13 Mar 2020 13:50:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 517AD20724
	for <linux-rdma@archiver.kernel.org>; Fri, 13 Mar 2020 13:50:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1584107435;
	bh=yq0mLM7Cu6dyAHy6xUiFmPbfHhSohVZ5wPsB4GB3IYs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=D2quZJXgDBOL340lBJfTUoN9htW9pQoYRYZfbF1GQGgnim637raGZkELl8vuk+TAZ
	 L/a7u9SzvTxcPgBx1mxIT/Fla91o77hEy4Rc7RL8/PK80J3iAYkYn4G/2dUNC3Ov0M
	 nm7WreSqPi/+C8bAszGIrhAZyEIcuAty9om3fxT4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726327AbgCMNue (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Fri, 13 Mar 2020 09:50:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:51150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726323AbgCMNue (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Fri, 13 Mar 2020 09:50:34 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 34157206B7;
        Fri, 13 Mar 2020 13:50:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584107434;
        bh=yq0mLM7Cu6dyAHy6xUiFmPbfHhSohVZ5wPsB4GB3IYs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=E3KReQa4aHu0n6nX2N7Ax6F9z9imyqdE9DFdmk9Dcqz/eVw67NyEpH5K7ImOjcp3x
         gYFazp12vGnKyi92e99HrykRhGdKIaVwx4O9XmmohZTnQ/RGZWOgnylOkw08uGNc0M
         F4vrVGaKX3FHOyPD9VonHznDuE3XsoBtOulbaeiE=
Date:   Fri, 13 Mar 2020 15:50:26 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Doug Ledford <dledford@redhat.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>
Subject: Re: [PATCH rdma-next v1 00/12] MR cache fixes and refactoring
Message-ID: <20200313135026.GG31504@unreal>
References: <20200310082238.239865-1-leon@kernel.org>
 <20200310083531.GA242734@unreal>
 <20200313134138.GA24090@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200313134138.GA24090@ziepe.ca>
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Fri, Mar 13, 2020 at 10:41:38AM -0300, Jason Gunthorpe wrote:
> On Tue, Mar 10, 2020 at 10:35:31AM +0200, Leon Romanovsky wrote:
> > + RDMA
> >
> > On Tue, Mar 10, 2020 at 10:22:26AM +0200, Leon Romanovsky wrote:
> > > From: Leon Romanovsky <leonro@mellanox.com>
> > >
> > > Changelog:
> > >  * v1: Added Saeed's patches.
> > >  * v0: https://lore.kernel.org/linux-rdma/20200227123400.97758-1-leon@kernel.org
> > >
> > > Hi,
> > >
> > > This series fixes various corner cases in the mlx5_ib MR
> > > cache implementation, see specific commit messages for more
> > > information.
> > >
> > > Thanks
> > >
> > >
> > > Jason Gunthorpe (8):
> > >   RDMA/mlx5: Rename the tracking variables for the MR cache
> > >   RDMA/mlx5: Simplify how the MR cache bucket is located
> > >   RDMA/mlx5: Always remove MRs from the cache before destroying them
> > >   RDMA/mlx5: Fix MR cache size and limit debugfs
> > >   RDMA/mlx5: Lock access to ent->available_mrs/limit when doing
> > >     queue_work
> > >   RDMA/mlx5: Fix locking in MR cache work queue
> > >   RDMA/mlx5: Revise how the hysteresis scheme works for cache filling
> > >   RDMA/mlx5: Allow MRs to be created in the cache synchronously
> > >
> > > Michael Guralnik (1):
> > >   {IB,net}/mlx5: Move asynchronous mkey creation to mlx5_ib
> > >
> > > Saeed Mahameed (3):
> > >   {IB,net}/mlx5: Setup mkey variant before mr create command invocation
> > >   {IB,net}/mlx5: Assign mkey variant in mlx5_ib only
> > >   IB/mlx5: Replace spinlock protected write with atomic var
>
> These seem fine, can you update the shared branch please

Thanks, applied to mlx5-next
a3cfdd392811 {IB,net}/mlx5: Move asynchronous mkey creation to mlx5_ib
fc6a9f86f08a {IB,net}/mlx5: Assign mkey variant in mlx5_ib only
54c62e13ad76 {IB,net}/mlx5: Setup mkey variant before mr create command invocation

>
> Thanks,
> Jason
