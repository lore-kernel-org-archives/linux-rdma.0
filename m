Return-Path: <SRS0=r0Ci=4Q=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A23CC3F2CD
	for <linux-rdma@archiver.kernel.org>; Fri, 28 Feb 2020 16:56:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2DEA124672
	for <linux-rdma@archiver.kernel.org>; Fri, 28 Feb 2020 16:56:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="aYq15DRI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725886AbgB1Q4s (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Fri, 28 Feb 2020 11:56:48 -0500
Received: from mail-qv1-f65.google.com ([209.85.219.65]:45256 "EHLO
        mail-qv1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725876AbgB1Q4s (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Fri, 28 Feb 2020 11:56:48 -0500
Received: by mail-qv1-f65.google.com with SMTP id l14so1626555qvu.12
        for <linux-rdma@vger.kernel.org>; Fri, 28 Feb 2020 08:56:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=MnnyeN+aqLspiam8SqK6rrpg5t0J6LSdhd2Rs2BI6FM=;
        b=aYq15DRIVkBXAdhasU2vbcTpN5PyvwYjvVVvra8BBVbxNwzNRk/8Xw4jhajUo20qCh
         tWfgbx/HU4O26bCNycBovypR5ZRDR4iyTP6tK6YDFPxijlYDWi18FBwYhLpp19y8BgXy
         BKlbUUEoIu4MMPXWBUkKtlsKPFvpXSB0Xaf25A7FfQkb+qZAQF3WrLMHUxkh+MfIY6RP
         ppzs+SLOuxXiiNFJc8mtApUUjIzbXOoGr8smNcopUlRWijDMUB9QBGwlNBismIozf3WZ
         d+Od1VBNuK9PVruUqIE4D6ezD/yBCDGhJEl2aED9D5KzTus6P09ZJRFPQjqFIO7FXu3f
         I8IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=MnnyeN+aqLspiam8SqK6rrpg5t0J6LSdhd2Rs2BI6FM=;
        b=T+BZvr7dKDg2vKP9tTNR4dv7F02LU/80vbcPn5xDc5XaCqiTqSmEXjYRvdJOmcnb8m
         xFk/AnL2vKriHRSYg+dry2MIvIVkcl8RlleAe4YQoko/s3Vwj3fkFdw1sdAeBawYfw4i
         nAZo1Uw1KgQddRkO8bfGCtpflb3bxmQ6tW+PR6zyMAhHhcapZaZeEfE1oYrCJfAtEzFz
         AT8Nz0Qfv4oj+Fr7a0mc7O2kRJk3RrmwW2FRtJRVX+K8yZgpPFGiNryueMQmgefkP99V
         y/H5KJfVzjkeiJ2gYcPHrpan9xC7CiK9j3UGAWPJR9NHWaa5wv3xewZe6Yr/w55Oeqsm
         R7jw==
X-Gm-Message-State: APjAAAVR+pikdyI1hm2LAubbLuHSvQWX82fFeKttAUPJswkLJgsMWeis
        3f6z0RJvfsO/r3yGxAEulvTqL712D8fZcg==
X-Google-Smtp-Source: APXvYqxZuqEcSahNzLeN6v3bvrqtte+U9QJQ19G7ZLwzLCMamUh1xRJXcxdGPrhVEJlr4DUSq/OMjg==
X-Received: by 2002:ad4:5304:: with SMTP id y4mr4595504qvr.56.1582909006571;
        Fri, 28 Feb 2020 08:56:46 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-68-57-212.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.57.212])
        by smtp.gmail.com with ESMTPSA id z21sm5211117qka.122.2020.02.28.08.56.45
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 28 Feb 2020 08:56:46 -0800 (PST)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1j7iwP-0003Ud-JW; Fri, 28 Feb 2020 12:56:45 -0400
Date:   Fri, 28 Feb 2020 12:56:45 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Doug Ledford <dledford@redhat.com>,
        Michael Guralnik <michaelgur@mellanox.com>,
        linux-rdma@vger.kernel.org, Maor Gottlieb <maorg@mellanox.com>,
        Yishai Hadas <yishaih@mellanox.com>
Subject: Re: [PATCH rdma-rc] RDMA/mlx5: Prevent UMR usage with RO only when
 we have RO caps
Message-ID: <20200228165645.GA13387@ziepe.ca>
References: <20200227113834.94233-1-leon@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200227113834.94233-1-leon@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Thu, Feb 27, 2020 at 01:38:34PM +0200, Leon Romanovsky wrote:
> From: Michael Guralnik <michaelgur@mellanox.com>
> 
> Relaxed ordering is not supported in UMR so we are disabling UMR usage
> when user passes relaxed ordering access flag.
> 
> Enable using UMR when user requested relaxed ordering but there are no
> relaxed ordering capabilities.
> This will prevent user from unnecessarily registering a new mkey.
> 
> Fixes: d6de0bb1850f ("RDMA/mlx5: Set relaxed ordering when requested")
> Signed-off-by: Michael Guralnik <michaelgur@mellanox.com>
> Reviewed-by: Maor Gottlieb <maorg@mellanox.com>
> Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
> ---
>  drivers/infiniband/hw/mlx5/mlx5_ib.h | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)

This doesn't seem very rc-ish, applied to for-next

Thanks,
Jason
