Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2A2AC12002
	for <linux-rdma@archiver.kernel.org>; Wed, 21 Jul 2021 07:30:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9C636606A5
	for <linux-rdma@archiver.kernel.org>; Wed, 21 Jul 2021 07:30:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235056AbhGUGt4 (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 21 Jul 2021 02:49:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:33198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234902AbhGUGtq (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Wed, 21 Jul 2021 02:49:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 64225606A5;
        Wed, 21 Jul 2021 07:30:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626852623;
        bh=Rbm5lvlIBnYYCUcxmz56MfSjlUDSpKvcNp36/M+j+3g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OYAiveYahvTV8hATxujEm5kX0yL718tNcTInDRgIdDt3sQtJaouJlTLm2ff5W8mKM
         /fNCAmX+W7cUmJZkgAeK2FhrivU0V+mdHTRpD2U+/20M5OZpo9u9n7hVt7ieHQA+N4
         A4af++u8Hl8oVl4KNbXb+JgeSsz89rzdbajfntZEyRopAJxPvBa5H/olYnwfkV05Z6
         xK7O5+MBXMwHvVpzy/p69t3lFuFmPvwkkSxZth0b5a7hycPk8OlQQa0Cd/r8No8sGk
         PK/NfdkTr5j31Lw2wGqJnIvifSc3CRewBV/8hEp2bv+V4uNitZ2FOLnMphgsg+xnZ3
         oFM4ZvyI/gxvg==
Date:   Wed, 21 Jul 2021 10:30:19 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, Mark Zhang <markz@mellanox.com>
Subject: Re: [PATCH rdma-next 7/7] RDMA/core: Create clean QP creations
 interface for uverbs
Message-ID: <YPfNC9tbn/GRKzoi@unreal>
References: <cover.1626846795.git.leonro@nvidia.com>
 <8eaf125d3bfb463e1641b6f2794203cc93d76c90.1626846795.git.leonro@nvidia.com>
 <YPfDUN6CaOdGZLPS@infradead.org>
 <YPfHXpFtB1RJ4yjU@unreal>
 <YPfI4+M/Ula5a0KZ@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YPfI4+M/Ula5a0KZ@infradead.org>
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Wed, Jul 21, 2021 at 08:12:35AM +0100, Christoph Hellwig wrote:
> On Wed, Jul 21, 2021 at 10:06:06AM +0300, Leon Romanovsky wrote:
> > You will need to add some sort of "if qp tpye" for ib_create_qp_uverbs() callers,
> > because they always provide udata != NULL. 
> > 
> > After this series, the callers look like this:
> > 
> >  1438         qp = ib_create_qp_uverbs(device, pd, &attr, &attrs->driver_udata, obj);
> >                                                           ^^^^^^^^^ not NULL
> > 
> > So instead of bothering callers, I implemented it here with one "if".
> 
> Sorry if my mail was confusing.  I don't want it in the callers, I
> want it as deep down in the stack as possible instead of having the
> strange wrapper.

I see, will change and resend.

Thanks
