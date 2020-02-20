Return-Path: <SRS0=rt4E=4I=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 383D6C11D05
	for <linux-rdma@archiver.kernel.org>; Thu, 20 Feb 2020 13:46:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F30BB208C4
	for <linux-rdma@archiver.kernel.org>; Thu, 20 Feb 2020 13:46:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1582206400;
	bh=hke2W/055DtN42w9onfIVqHTrL/plem7DKsLQUZGUWs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=RZqXHTfWWR4YUn2kgQPmMDV/Synzau7MBlZuU8RFCn2IvXTAh1rJwM3KiS+2McZmM
	 t9c4a8Wd3NCAM5x+Bi+6d57LR9rjqQk6W2CHWcbK0T6W0jundZ4Wi9Yxm82RD5EOo4
	 Gadmc4WwpSoWE9dm/Rw2JMWxSLTWyT3NQwEXK6Bc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728145AbgBTNqj (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 20 Feb 2020 08:46:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:32796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726959AbgBTNqj (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Thu, 20 Feb 2020 08:46:39 -0500
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2D3B2207FD;
        Thu, 20 Feb 2020 13:46:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582206398;
        bh=hke2W/055DtN42w9onfIVqHTrL/plem7DKsLQUZGUWs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=z3pNu3Nz31+xrf4Htiij0h6pH1zctiWJzu+Udrul3Wr1oceZo20QUoFfDOGcZ7BvQ
         xhoYCvuR4MLEQ4/1BBJoLltx9gx7Lsk48MG1ZZWufZvtl7sxA4SbRdXz1XNrtuuenK
         rxNYTjPAcboh9NYjI84KxSvkdUw0tB44wybeFgM8=
Date:   Thu, 20 Feb 2020 15:46:35 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Dennis Dalessandro <dennis.dalessandro@intel.com>
Cc:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>
Subject: Re: [PATCH rdma-next 1/2] RDMA/ipoib: Don't set constant driver
 version
Message-ID: <20200220134635.GD209126@unreal>
References: <20200220071239.231800-1-leon@kernel.org>
 <20200220071239.231800-2-leon@kernel.org>
 <dc3541f9-720c-7f6c-2073-df5f2b446fa3@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dc3541f9-720c-7f6c-2073-df5f2b446fa3@intel.com>
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Thu, Feb 20, 2020 at 08:34:00AM -0500, Dennis Dalessandro wrote:
> On 2/20/2020 2:12 AM, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@mellanox.com>
> >
> > There is no need to set driver version in in-tree kernel code.
> >
> > Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
> > ---
> >   drivers/infiniband/ulp/ipoib/ipoib.h         | 2 --
> >   drivers/infiniband/ulp/ipoib/ipoib_ethtool.c | 3 ---
> >   drivers/infiniband/ulp/ipoib/ipoib_main.c    | 4 ----
> >   3 files changed, 9 deletions(-)
> >
>
> Same comments as the other patch, can we just remove the field from the
> drvinfo struct altogether.

Ahh, and extra thing.

I put default version in ->version before calling to the driver. It
allows for out-of-tree drivers overwrite that field and continue to
manage their internal versions.

Thanks

>
> Reviewed-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
>
