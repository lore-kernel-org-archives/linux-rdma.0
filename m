Return-Path: <SRS0=Oc65=6W=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0F69C35280
	for <linux-rdma@archiver.kernel.org>; Fri,  8 May 2020 00:01:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 944D82082E
	for <linux-rdma@archiver.kernel.org>; Fri,  8 May 2020 00:01:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="HV9ScAOB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726476AbgEHABZ (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 7 May 2020 20:01:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726464AbgEHABY (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Thu, 7 May 2020 20:01:24 -0400
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94C8DC05BD43
        for <linux-rdma@vger.kernel.org>; Thu,  7 May 2020 17:01:24 -0700 (PDT)
Received: by mail-qk1-x742.google.com with SMTP id b188so168691qkd.9
        for <linux-rdma@vger.kernel.org>; Thu, 07 May 2020 17:01:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=3dzEt0rYaBt6J/hmb9V3fKnuX7aM6OLrzLqbT9l3mHQ=;
        b=HV9ScAOBaYp4M2s23zgUmy4Eg0IzQcaAyZInrJbIA96DNcG6QmS46oKtnH8ewsuS28
         m6ugnjPLWVw98ZXswN1WBHsaNm4LwReauV7CVAfZaytLWN7ZeZkcz9XpZPWZ40+Phq0v
         SE5j5QMf3yE1el22LTPSyHBWW4YX5QS38CXiUQUBTT/8rxfZg1NTScXZuxlevJwsGn6J
         zIwsz/3OrxMBLBLJd23GrplrIPvGw1TolSZT7kQZIGgfEazHd7wIilIfB5R2A9DDaujK
         9BYmdxGCXNbofEM45OWA/YiyBhhoxY9ZAtwnt6XxWNWmULbLi8pVJQ3P2e0qdx8RHZ0l
         Oj3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=3dzEt0rYaBt6J/hmb9V3fKnuX7aM6OLrzLqbT9l3mHQ=;
        b=bm3GzXyM6aBshQKJkv8dvmoVrUsx10X4/tRWLI0Hssvv8GOHhbTWDDS+Nxo2SCKxAA
         lCKnSfoEc0Tvbtm8vHus+3Oun3yP9kIvIt4VkY3sEkxaAb+A4FDocJ7aZywygLMzn9MP
         S+WAI0LVlOZr3SEJEzlWZXmfnd+XGIkgrK902HXeO9lxW2zJR6XL0LMXogydFr/A/PKC
         JiqAp5LRoEloiGiOfeCL7EOnISJV1NiHRuDpJ3bTLildwOYb5biKYXz7zTYUx6Zx8cHE
         sHL/N/o338K1w1H1Gz7w7ifDrSXx5oFJdWRAQdzkPYyjCjiWM5siinw7Gc8cRHFHtR9j
         DQpg==
X-Gm-Message-State: AGi0PuZ7r+2MRBVKdgjWCuPxyLrcVCMMK3MgNt6iM8qD1chqXyXBOQ/g
        EQmXkiEsY2jpZc5q08hhL662cw==
X-Google-Smtp-Source: APiQypJN5wwd0O2HwOpL8SsDFu75HG1lVnuK2Cu2Kq5fbxer10FxDdLQSvKcggYnfhOuPMR3HEJPHw==
X-Received: by 2002:a37:7b83:: with SMTP id w125mr37436qkc.420.1588896083749;
        Thu, 07 May 2020 17:01:23 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-68-57-212.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.57.212])
        by smtp.gmail.com with ESMTPSA id n31sm71424qtc.36.2020.05.07.17.01.22
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 07 May 2020 17:01:22 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1jWqSA-0008Pb-Bh; Thu, 07 May 2020 21:01:22 -0300
Date:   Thu, 7 May 2020 21:01:22 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Doug Ledford <dledford@redhat.com>,
        Jack Morgenstein <jackm@dev.mellanox.co.il>,
        linux-rdma@vger.kernel.org
Subject: Re: [PATCH rdma-rc v2] IB/core: Fix potential NULL pointer
 dereference in pkey cache
Message-ID: <20200508000122.GA32249@ziepe.ca>
References: <20200507071012.100594-1-leon@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200507071012.100594-1-leon@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Thu, May 07, 2020 at 10:10:12AM +0300, Leon Romanovsky wrote:
> From: Jack Morgenstein <jackm@dev.mellanox.co.il>
> 
> The IB core pkey cache is populated by procedure ib_cache_update().
> Initially, the pkey cache pointer is NULL. ib_cache_update allocates
> a buffer and populates it with the device's pkeys, via repeated calls
> to procedure ib_query_pkey().
> 
> If there is a failure in populating the pkey buffer via ib_query_pkey(),
> ib_cache_update does not replace the old pkey buffer cache with the
> updated one -- it leaves the old cache as is.
> 
> Since initially the pkey buffer cache is NULL, when calling
> ib_cache_update the first time, a failure in ib_query_pkey() will cause
> the pkey buffer cache pointer to remain NULL.
> 
> In this situation, any calls subsequent to ib_get_cached_pkey(),
> ib_find_cached_pkey(), or ib_find_cached_pkey_exact() will try to
> dereference the NULL pkey cache pointer, causing a kernel panic.
> 
> Fix this by checking the ib_cache_update() return value.
> 
> Fixes: 8faea9fd4a39 ("RDMA/cache: Move the cache per-port data into the main ib_port_data")
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Signed-off-by: Jack Morgenstein <jackm@dev.mellanox.co.il>
> Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
> ---
> Changelog:
> v2: Removed error unwinding
> v1: https://lore.kernel.org/linux-rdma/20200506053213.566264-1-leon@kernel.org
>  I rewrote the patch to take care of ib_cache_update() return value.
> v0: https://lore.kernel.org/linux-rdma/20200426075811.129814-1-leon@kernel.org
> ---
>  drivers/infiniband/core/cache.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)

Applied to for-rc

Thanks,
Jason
