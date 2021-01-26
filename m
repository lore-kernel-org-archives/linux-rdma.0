Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 079C8C4332B
	for <linux-rdma@archiver.kernel.org>; Wed, 27 Jan 2021 04:21:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BAD4620709
	for <linux-rdma@archiver.kernel.org>; Wed, 27 Jan 2021 04:21:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343656AbhA0EVa (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 26 Jan 2021 23:21:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:36024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730196AbhAZFsX (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Tue, 26 Jan 2021 00:48:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 56BD52223D;
        Tue, 26 Jan 2021 05:47:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611640056;
        bh=fdSOnwAdECsh9e4D12P2TDgGGXHWz6FhwS7h3u8oCzc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WgpeeOpc+mLw6ffnHsnXuoF8Ou4IRIxe6AQ3+TWXdw+6GnnDUPMxPlxsm5qRl3Bmf
         hEt4MEnwLsGxrjZsGmVF9TeqW/o+umnJKVj10Cw8lZcYGqwOm8pDA+f6tYvK4SoomC
         egFz53UBHKe5y2SNQ2CJiZSrjalxSsTAFio4BOupRINGkES3nyX1OWzzR2I0sodni1
         dvCZa4bTWqfwezKSAurFxJICbQVnw4jRV6cCruJrVgH2JO3tN0gP5BFpC8/5mud1hf
         zHYEW2MMDbLHo6MfM6QWvGuTTDrKiUS/JlSPfja3ICHjWkhXm3mId068Wl8RGFJUL1
         ehQpusksK6z4Q==
Date:   Tue, 26 Jan 2021 07:47:32 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Shiraz Saleem <shiraz.saleem@intel.com>, dledford@redhat.com,
        kuba@kernel.org, davem@davemloft.net, linux-rdma@vger.kernel.org,
        gregkh@linuxfoundation.org, netdev@vger.kernel.org,
        david.m.ertman@intel.com, anthony.l.nguyen@intel.com
Subject: Re: [PATCH 21/22] RDMA/irdma: Add irdma Kconfig/Makefile and remove
 i40iw
Message-ID: <20210126054732.GP579511@unreal>
References: <20210122234827.1353-1-shiraz.saleem@intel.com>
 <20210122234827.1353-22-shiraz.saleem@intel.com>
 <20210125185007.GU4147@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210125185007.GU4147@nvidia.com>
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Mon, Jan 25, 2021 at 02:50:07PM -0400, Jason Gunthorpe wrote:
> On Fri, Jan 22, 2021 at 05:48:26PM -0600, Shiraz Saleem wrote:
> > Add Kconfig and Makefile to build irdma driver.
> >
> > Remove i40iw driver and add an alias in irdma.
> > irdma is the replacement driver that supports X722.
> >
> > Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
> > ---
>
> This didn't make it to patchworks or the mailing list

It arrived - https://lore.kernel.org/linux-rdma/20210125185007.GU4147@nvidia.com/
Yesterday, VGER had some weird behaviour.

Thanks
