Return-Path: <SRS0=oPJA=D6=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E585BC388F9
	for <linux-rdma@archiver.kernel.org>; Fri, 23 Oct 2020 15:48:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A1BFF21D47
	for <linux-rdma@archiver.kernel.org>; Fri, 23 Oct 2020 15:48:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S463665AbgJWPsG (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Fri, 23 Oct 2020 11:48:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:36506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S463613AbgJWPsF (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Fri, 23 Oct 2020 11:48:05 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A17C320878;
        Fri, 23 Oct 2020 15:48:04 +0000 (UTC)
Date:   Fri, 23 Oct 2020 18:48:00 +0300
From:   Leon Romanovsky <leonro@nvidia.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Dave Ertman <david.m.ertman@intel.com>,
        alsa-devel@alsa-project.org, tiwai@suse.de, broonie@kernel.org,
        linux-rdma@vger.kernel.org, jgg@nvidia.com, dledford@redhat.com,
        netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        ranjani.sridharan@linux.intel.com,
        pierre-louis.bossart@linux.intel.com, fred.oh@linux.intel.com,
        parav@mellanox.com, shiraz.saleem@intel.com,
        dan.j.williams@intel.com, kiran.patil@intel.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 00/10] Auxiliary bus implementation and SOF
 multi-client support
Message-ID: <20201023154800.GQ2611066@unreal>
References: <20201023003338.1285642-1-david.m.ertman@intel.com>
 <20201023064946.GP2611066@unreal>
 <20201023065610.GA2162757@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201023065610.GA2162757@kroah.com>
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Fri, Oct 23, 2020 at 08:56:10AM +0200, Greg KH wrote:
> On Fri, Oct 23, 2020 at 09:49:46AM +0300, Leon Romanovsky wrote:
> > On Thu, Oct 22, 2020 at 05:33:28PM -0700, Dave Ertman wrote:
> >
> > <...>
> >
> > > Dave Ertman (1):
> > >   Add auxiliary bus support
> >
> > We are in merge window now and both netdev and RDMA are closed for
> > submissions. So I'll send my mlx5 conversion patches once -rc1 will
> > be tagged.
> >
> > However, It is important that this "auxiliary bus" patch will be applied
> > to some topic branch based on Linus's -rcX. It will give us an ability
> > to pull this patch to RDMA, VDPA and netdev subsystems at the same time.
>
> I will do that, but as you said, it's the middle of the merge window and
> I can't do anything until after -rc1 is out.

Thanks a lot.
