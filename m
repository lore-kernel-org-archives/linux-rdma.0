Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6EBEC433F5
	for <linux-rdma@archiver.kernel.org>; Sun, 27 Feb 2022 11:52:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230110AbiB0LxS (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Sun, 27 Feb 2022 06:53:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229797AbiB0LxR (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Sun, 27 Feb 2022 06:53:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A28817A82
        for <linux-rdma@vger.kernel.org>; Sun, 27 Feb 2022 03:52:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0025B60E8C
        for <linux-rdma@vger.kernel.org>; Sun, 27 Feb 2022 11:52:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E172DC340E9;
        Sun, 27 Feb 2022 11:52:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645962760;
        bh=pavVYWqJmB4534LZMpAaW8d0qLZ16kLXXJI4KMn1kTM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UT/9RT6cJKArDs7065gIGn8jud/V0yYlmLJMvJ4HKskMdysmoN5dvF6wPgtB3Lyfx
         PCUI39ngZEXvB4lMlEIPM0rhGnjZdcgzWLoFPm1YDiou0GQLs69Mk6jN0UxsaMmAVn
         +0o+UTy93jgaaZpofaDeQq8nM4ENP2tcxSX4sr1nvXrsaHlyJh0L52LiR3p13Bbcjq
         suHw9/ntGlsGEvV+A+NS2rqsnA0MDLY2HUoHMvCmHfzrGlk3aqgrnnRVe6xnrPpM8x
         Xe1AePucFDydsi/ByGqGN731JJfKJcEXPZMAiiWKAPZuX0MELTS8Uq+HJ6ixm3rwlW
         c3goOXmI0w8Xw==
Date:   Sun, 27 Feb 2022 13:52:36 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Shiraz Saleem <shiraz.saleem@intel.com>
Cc:     jgg@nvidia.com, linux-rdma@vger.kernel.org,
        Mustafa Ismail <mustafa.ismail@intel.com>
Subject: Re: [PATCH rdma-rc v1 1/3] RDMA/irdma: Fix netdev notifications for
 vlan's
Message-ID: <YhtmBKB8FyRnqN+1@unreal>
References: <20220225163211.127-1-shiraz.saleem@intel.com>
 <20220225163211.127-2-shiraz.saleem@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220225163211.127-2-shiraz.saleem@intel.com>
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Fri, Feb 25, 2022 at 10:32:09AM -0600, Shiraz Saleem wrote:
> From: Mustafa Ismail <mustafa.ismail@intel.com>
> 
> Currently, events on vlan netdevs are being ignored. Fix
> this by finding the real netdev and processing the
> notifications for vlan netdevs.
> 
> Fixes: 915cc7ac0f8e ("RDMA/irdma: Add miscellaneous utility definitions")
> Signed-off-by: Mustafa Ismail <mustafa.ismail@intel.com>
> Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
> ---
>  drivers/infiniband/hw/irdma/utils.c | 48 +++++++++++++++++++++++--------------
>  1 file changed, 30 insertions(+), 18 deletions(-)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
