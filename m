Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10A92C433F5
	for <linux-rdma@archiver.kernel.org>; Fri, 29 Apr 2022 16:23:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378193AbiD2Q1L (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Fri, 29 Apr 2022 12:27:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379024AbiD2Q1K (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Fri, 29 Apr 2022 12:27:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2843CD76E4;
        Fri, 29 Apr 2022 09:23:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B8B73622C4;
        Fri, 29 Apr 2022 16:23:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7746AC385A4;
        Fri, 29 Apr 2022 16:23:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651249431;
        bh=HNDKC/6YMghVFhviIdPCkVqganM1MigQRJ602aM7nC0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=P0NOe88aD8txfErJY2XSSP1oNljZ0MZXJuep4mNfSienwctVkerL+GiZhURI7g3kL
         bbkZDakTCuQn5Rj4v4H4dYj9NCvedKbSlJMIth5huB4bLufKlppXk4PxtcL6OrOCiU
         3Lv/DvNypKUI/3qxgeLmqnHIQX4/WpXmTvHK38UxQfyLU+qv9dWE7rYBtuekQYzmlg
         D7x1iRxNzoXTr+qVqtrCj07LhcwE1wLGDylpYYlUtxSW70Q6LuLcUFFBLqjeAiCH7t
         PS5opvVPMT9UBOz1PHeszAVW3J1DLALfmnfvihckNUr+A0RTk9OnniYg8YzNfMie5+
         BqmF5MtRngkIQ==
Date:   Fri, 29 Apr 2022 19:23:46 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Olga Kornievskaia <aglo@umich.edu>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-rdma <linux-rdma@vger.kernel.org>,
        Mark Zhang <markzhang@nvidia.com>,
        Patrisious Haddad <phaddad@nvidia.com>
Subject: Re: [PATCH rdma-next 0/2] Add gratuitous ARP support to RDMA-CM
Message-ID: <YmwREnArWbBr5sdG@unreal>
References: <cover.1649075034.git.leonro@nvidia.com>
 <CAN-5tyGeGya5dW9h1uvBd6uKW-AgY1q8-UkR1kpi9Z2k6PY7jw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAN-5tyGeGya5dW9h1uvBd6uKW-AgY1q8-UkR1kpi9Z2k6PY7jw@mail.gmail.com>
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Fri, Apr 29, 2022 at 12:07:09PM -0400, Olga Kornievskaia wrote:
> Hi Leon,
> 
> Are these the 2 patches that are supposed to fix: [Bug 214523] New:
> RDMA Mellanox RoCE drivers are unresponsive to ARP updates during a
> reconnect?

Yes, you are right.

> 
> I could be wrong but I don't think they made it into the 5.18 pull, correct?

This is correct too.

Thanks

> 
> Thank you.
> 
> On Mon, Apr 4, 2022 at 8:36 AM Leon Romanovsky <leon@kernel.org> wrote:
> >
> > From: Leon Romanovsky <leonro@nvidia.com>
> >
> > In this series, Patrisious adds gratuitous ARP support to RDMA-CM, in
> > order to speed up migration failover from one node to another.
> >
> > Thanks
> >
> > Patrisious Haddad (2):
> >   RDMA/core: Add an rb_tree that stores cm_ids sorted by ifindex and
> >     remote IP
> >   RDMA/core: Add a netevent notifier to cma
> >
> >  drivers/infiniband/core/cma.c      | 260 +++++++++++++++++++++++++++--
> >  drivers/infiniband/core/cma_priv.h |   1 +
> >  2 files changed, 249 insertions(+), 12 deletions(-)
> >
> > --
> > 2.35.1
> >
