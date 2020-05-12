Return-Path: <SRS0=8X7E=62=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C22FC2D0F8
	for <linux-rdma@archiver.kernel.org>; Tue, 12 May 2020 23:10:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7AB8520747
	for <linux-rdma@archiver.kernel.org>; Tue, 12 May 2020 23:10:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="Jrztmw4k"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728314AbgELXKJ (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 12 May 2020 19:10:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725938AbgELXKI (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Tue, 12 May 2020 19:10:08 -0400
Received: from mail-qt1-x841.google.com (mail-qt1-x841.google.com [IPv6:2607:f8b0:4864:20::841])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C76BC061A0C
        for <linux-rdma@vger.kernel.org>; Tue, 12 May 2020 16:10:08 -0700 (PDT)
Received: by mail-qt1-x841.google.com with SMTP id l1so9154160qtp.6
        for <linux-rdma@vger.kernel.org>; Tue, 12 May 2020 16:10:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=+tN9adrIkhAHMMpF9B10L1UeYVc1o+NqQTH4OcbCX58=;
        b=Jrztmw4k4+XBLGtMfNVOMcDJ3urWDRsCc66wmlGZjQdgFSMxGcFHLW3HO7kY5pXEZl
         ktaztoIBpl0UVEPqLFjSBBLOY52VKaaubQHXc5snIyEJ4hfBA4kGaAybXKosh1ErHTs/
         APsw4YK9u9aid5jXat7ZLSgMevXSxq6MM+LrVMCy7WejPnjsJaPQXf3XxYscK9okkkF4
         /U9AlqvZ08xozEGTYc4io3282MxVU3gOKeBNwG1312r97U5yqqGLHfWxUwCqZmXW4X5C
         feUQ6WGTKKXAPgKjmYNPsy7azNDC3mPxbWC4o6bOkbW0GR3vZ18k6y0Dz37o6bqgoHne
         E0VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=+tN9adrIkhAHMMpF9B10L1UeYVc1o+NqQTH4OcbCX58=;
        b=beEtbCygbK7jGxeZ2dTxNQIZgbbgDr3VwyznhJh5ts4PksRkpEfsOHvgG51kLrvzHL
         +6Sbfr/LtJNKIY0vuANUQrCUlxBN6pTj15uioYgWjFVEm2R46anOHjadt5W1HBgkBb5h
         znzvHI3q1wtAjSdhQ1xPHWEdcDcm3nfRGinQbyzp5z4qyXMF+YuGKSsw0K4CyG8a6fl8
         jmx9+sVG5C6QnJizTgpyOUgBZu65wT7YVVGAFQl0O6A1j6+q91w6FEeEBLw/DX6nxSUy
         fvU0JpFeIM5ZcmJ+igdSdvt47kUDEf5znf+eHIKnW3im64yC7aqiCx/TjKTKw9eBSixp
         QUfw==
X-Gm-Message-State: AOAM530uA5dafahdLY8PBq1ovCyPcCkui/ZlvUOA/fuE6U5jFM8XdQew
        PJOxSyxxlJ8NBYPzLCwvJ8y5og==
X-Google-Smtp-Source: ABdhPJwM8cvxmJ7LPaHCTkEAHrqLpTbc3W+MZNfGUb8hCH91k8LldPiJXI/E7ON2yNfwbnjmxl85/w==
X-Received: by 2002:ac8:302e:: with SMTP id f43mr6573052qte.366.1589325007794;
        Tue, 12 May 2020 16:10:07 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-68-57-212.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.57.212])
        by smtp.gmail.com with ESMTPSA id p22sm13987077qte.2.2020.05.12.16.10.07
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 12 May 2020 16:10:07 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1jYe2I-0007qC-QO; Tue, 12 May 2020 20:10:06 -0300
Date:   Tue, 12 May 2020 20:10:06 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Doug Ledford <dledford@redhat.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        linux-rdma@vger.kernel.org, Gal Pressman <galpress@amazon.com>
Subject: Re: [PATCH rdma-next v1] RDMA/ucma: Return stable IB device index as
 identifier
Message-ID: <20200512231006.GA30083@ziepe.ca>
References: <20200504132541.355710-1-leon@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200504132541.355710-1-leon@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Mon, May 04, 2020 at 04:25:41PM +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@mellanox.com>
> 
> The librdmacm uses node_guid as identifier to correlate between
> IB devices and CMA devices. However FW resets cause to such
> "connection" to be lost and require from the user to restart
> its application.
> 
> Extend UCMA to return IB device index, which is stable identifier.
> 
> Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
> ---
> Changelog:
> v1: Fixed padding to u64 in response structures
> v0: https://lore.kernel.org/linux-rdma/20200430152939.77967-1-leon@kernel.org
> ---
>  drivers/infiniband/core/ucma.c   | 16 +++++++++-------
>  include/uapi/rdma/rdma_user_cm.h |  4 ++++
>  2 files changed, 13 insertions(+), 7 deletions(-)

Applied to for-next, thanks

Jason
