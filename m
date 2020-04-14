Return-Path: <SRS0=4UEG=56=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FE7BC2BB1D
	for <linux-rdma@archiver.kernel.org>; Tue, 14 Apr 2020 23:25:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7A4932076C
	for <linux-rdma@archiver.kernel.org>; Tue, 14 Apr 2020 23:25:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="ZyIx622+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392125AbgDNXZl (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 14 Apr 2020 19:25:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731159AbgDNXZi (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>);
        Tue, 14 Apr 2020 19:25:38 -0400
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEC19C061A0C
        for <linux-rdma@vger.kernel.org>; Tue, 14 Apr 2020 16:25:36 -0700 (PDT)
Received: by mail-qk1-x742.google.com with SMTP id x66so15349646qkd.9
        for <linux-rdma@vger.kernel.org>; Tue, 14 Apr 2020 16:25:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=01FhJZSkiAajc/QWMbWLZMuQXLtpiZ7LIV7bWz1kZ/U=;
        b=ZyIx622+ephtl2XUgYNHD+2c2T4dqzejn1LMrfWolRG1O3grzzFkigVa6N3AfPlHKw
         BBSzkUyQggE7LwhlukwhD+DFVXk94p2Nne3RTyze/D8wXAHNZY2YsoTObwC53mjOVOkG
         1C1fUJKvvFl22aE7bZtcp+A3BNpTs+K6oFnmEaqZaK01lpnvUEHBQC+RXD5mFpxP1NLC
         b1cjLK/QtFZcQD4Lh0sBnZJeqSB81hCznwaY3P3wYM5xFltYQCVZhXr+5jFMlBQXW5GZ
         I1EKFYCHYmOjLRdmjd0X22bkZpJ/ZvEnFOfr95TDaT+cR54DAnn9TwLOW2gEoWJesrzc
         nzJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=01FhJZSkiAajc/QWMbWLZMuQXLtpiZ7LIV7bWz1kZ/U=;
        b=lE8l5iNrd9UThban4ASZCKU8+A09aFZuOZplGy6vBVa7bMo31LhLJ9mRhRwPLjhApu
         KbWib56QwOzwfegQ7t/+ZoFdQvGhXkc8v73O/mcBFr6gb13TClWMlFYf+jDkHBLT5gn/
         8CGoLV9yPnkqgBD+CmINlODHyezWHFFUo2bqG9Xj1VzGQMeDfMZfNzdWUpnDXpHIPixC
         5nqzV0NRoboyoQpomrMrcOCOnK77PIAJiUgoEbyoCSHYaiUo7rIcsBGW/RhKHU6kbndw
         LX34UjVhzyD3v/nmp18HidwDL7zWQSph6aGngT9xf/ezYh59NfkjcOm27r/AwQuumyN2
         0ALw==
X-Gm-Message-State: AGi0PuYvyei36icA+zvKkkIsjl2FKQmKX21za3FH+Zo25FYOOItAgqU9
        EP8m2/y2pRwKAh5v2CVSF5I75w==
X-Google-Smtp-Source: APiQypLIndMM8QI5p3mSdjThZNprOtcQIDD9RjDMiG7JK+cduUDAjt/OUikzv6Hw0ArskMDaahFXpw==
X-Received: by 2002:a37:278c:: with SMTP id n134mr24535021qkn.348.1586906736061;
        Tue, 14 Apr 2020 16:25:36 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-68-57-212.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.57.212])
        by smtp.gmail.com with ESMTPSA id m66sm11594151qkf.42.2020.04.14.16.25.35
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 14 Apr 2020 16:25:35 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1jOUvv-0003eM-45; Tue, 14 Apr 2020 20:25:35 -0300
Date:   Tue, 14 Apr 2020 20:25:35 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Doug Ledford <dledford@redhat.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        linux-rdma@vger.kernel.org, Maor Gottlieb <maorg@mellanox.com>
Subject: Re: [PATCH rdma-rc] RDMA/cma: Limit the scope of
 rdma_is_consumer_reject function
Message-ID: <20200414232535.GA14001@ziepe.ca>
References: <20200413132323.930869-1-leon@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200413132323.930869-1-leon@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Mon, Apr 13, 2020 at 04:23:23PM +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@mellanox.com>
> 
> The function is local to cma.c, so let's limit its scope.
> 
> Reviewed-by: Maor Gottlieb <maorg@mellanox.com>
> Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
> ---
>  drivers/infiniband/core/cma.c | 3 +--
>  include/rdma/rdma_cm.h        | 8 --------
>  2 files changed, 1 insertion(+), 10 deletions(-)

Applied to for-next, thanks

Jason
