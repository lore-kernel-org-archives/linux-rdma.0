Return-Path: <SRS0=tA3/=WD=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE0A0C31E40
	for <linux-rdma@archiver.kernel.org>; Wed,  7 Aug 2019 03:17:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C19342173C
	for <linux-rdma@archiver.kernel.org>; Wed,  7 Aug 2019 03:17:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1565147853;
	bh=6+4LzktwvLiiZsXR5dAoM1MwMXyVEPFtN6KSyIYk9QI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=H/pwDqGeIpim3yp2NM/njrb9O9I/QJCXjdruLDG0EUQAkTlUuzWiZOYBaLtqSOq9R
	 FpawbCDQfOLmC0G5k28D34dgzApP+hDJueNOHkLncoS9+M0ubmtA+06/VZ1rXzY9lM
	 tbvjcO/YDqVEWQz7CrVhoBdofnh+YFp78OshGxtk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727566AbfHGDRd (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 6 Aug 2019 23:17:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:60182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726334AbfHGDRc (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Tue, 6 Aug 2019 23:17:32 -0400
Received: from localhost (unknown [77.137.115.125])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5E4DD214C6;
        Wed,  7 Aug 2019 03:17:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565147852;
        bh=6+4LzktwvLiiZsXR5dAoM1MwMXyVEPFtN6KSyIYk9QI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qxvDb6VbHFau5ksd8dvNrBr1fsolVTYOGD7+DxUW2y6PrAd77CQ02zirUGyB+vj9T
         MI0gvD1LeJ77LuEBmbX5fPDhtBZamrBCkw+BfbfWBA7gC8vxgrkGXjCTfDyLlrgpe7
         1p3si5sZOfKFy0r7EiqmPXi/GGhr6uREwHbmjIEQ=
Date:   Wed, 7 Aug 2019 06:17:17 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     "hslester96@gmail.com" <hslester96@gmail.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "jgg@ziepe.ca" <jgg@ziepe.ca>,
        "dledford@redhat.com" <dledford@redhat.com>
Subject: Re: [PATCH v3] mlx5: Use refcount_t for refcount
Message-ID: <20190807031717.GB4832@mtr-leonro.mtl.com>
References: <20190806015950.18167-1-hslester96@gmail.com>
 <cbea99e74a1f70b1a67357aaf2afdb55655cd2bd.camel@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cbea99e74a1f70b1a67357aaf2afdb55655cd2bd.camel@mellanox.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Tue, Aug 06, 2019 at 08:40:11PM +0000, Saeed Mahameed wrote:
> On Tue, 2019-08-06 at 09:59 +0800, Chuhong Yuan wrote:
> > Reference counters are preferred to use refcount_t instead of
> > atomic_t.
> > This is because the implementation of refcount_t can prevent
> > overflows and detect possible use-after-free.
> > So convert atomic_t ref counters to refcount_t.
> >
> > Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
> > ---
> > Changes in v3:
> >   - Merge v2 patches together.
> >
> >  drivers/infiniband/hw/mlx5/srq_cmd.c         | 6 +++---
> >  drivers/net/ethernet/mellanox/mlx5/core/qp.c | 6 +++---
> >  include/linux/mlx5/driver.h                  | 3 ++-
> >  3 files changed, 8 insertions(+), 7 deletions(-)
> >
>
> LGTM, Leon, let me know if you are happy with this version,
> this should go to mlx5-next.

Thanks,
Acked-by: Leon Romanovsky <leonro@mellanox.com>
