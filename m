Return-Path: <SRS0=r0Ci=4Q=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD80DC3F2D2
	for <linux-rdma@archiver.kernel.org>; Fri, 28 Feb 2020 15:23:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 804502469F
	for <linux-rdma@archiver.kernel.org>; Fri, 28 Feb 2020 15:23:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="JQx93czA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726650AbgB1PXp (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Fri, 28 Feb 2020 10:23:45 -0500
Received: from mail-qk1-f194.google.com ([209.85.222.194]:37193 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727206AbgB1PXo (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Fri, 28 Feb 2020 10:23:44 -0500
Received: by mail-qk1-f194.google.com with SMTP id m9so3282254qke.4
        for <linux-rdma@vger.kernel.org>; Fri, 28 Feb 2020 07:23:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=vSEWPFoN9foLTFhIwGtzPMAkqyLax3f6gjEPa/FjV5Q=;
        b=JQx93czA894069N8MffJS+tPOzmAnT6XU5rtnKicdWPBr+DZu8XC/j9D45EAh/clvR
         Ow2A1tg4IXWM4otrMaT7RFMdHcQfdZQVOgW3b/K2EiPdewOryotq/lomie1Ly1D3c/A8
         Mo2mtsqnwXqAzkTc0wXmo/9qEToAGVyOgQlim9I+l7e5wckfvCowt8PTLyPTL3n5mTHf
         ktv7eS0e4NC6Dv0bblM/tAkKObaV+kUFHw7oebEwahNv3g8xP1x7bDC50I86Spnfz9Tc
         krXAwUMgYD/LFJAQBlBpn9YlrUkW2NOBO+k7w8aiO1or+ozvFtTi3x2Aai60LNYTzN88
         a60w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=vSEWPFoN9foLTFhIwGtzPMAkqyLax3f6gjEPa/FjV5Q=;
        b=WQmSe4WVEtRUU9BSB62aYmyPzEXj3XdsY2vED126u5jCPgQqiudoCXdhRS7hdzLsRH
         fFdZvKVzVYHHfU708UqRcGcQewTW0nEAUyY3xHwC85AGPibQ70bzVNL4soCd5IZBCyv8
         5QkEYzl+ckUdFT3+k8BpzuB5zK9Ou7RNglgQwTfwOwA9Vnp8Ia1PDrkuBKHExQ7qoYy8
         fNAmGT2KTJwya5DLgG+56V2a9Q1geiUJudwexkHJWBCoC+3Qn7D7zJk+4mSn57+bDsC1
         YHfU69vtjml1gSx09SnlqYyZkv0vTIX3gwEhDaGWz0Btc9IkeRR1ZUsgipundudWh5xM
         p5QQ==
X-Gm-Message-State: APjAAAUnzLDdy8/UM0Xyp9Y3o09l16Yh+KpQNmdaoJgVfXT9Mo9LCRdl
        6BydfCMik0wrFjz5XxsRtYTqMw==
X-Google-Smtp-Source: APXvYqzxWJS8zN0ckWMt/3BCRvO38NLnmxL2lOELIki77uOc3XjEnBoNmRFNkiKdrJmHd9jr6dWeVQ==
X-Received: by 2002:a05:620a:16d4:: with SMTP id a20mr2820637qkn.168.1582903422743;
        Fri, 28 Feb 2020 07:23:42 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-68-57-212.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.57.212])
        by smtp.gmail.com with ESMTPSA id k4sm5056982qtj.74.2020.02.28.07.23.42
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 28 Feb 2020 07:23:42 -0800 (PST)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1j7hUL-0007OE-Md; Fri, 28 Feb 2020 11:23:41 -0400
Date:   Fri, 28 Feb 2020 11:23:41 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Doug Ledford <dledford@redhat.com>,
        Maor Gottlieb <maorg@mellanox.com>, linux-rdma@vger.kernel.org
Subject: Re: [PATCH rdma-rc] RDMA/core: Fix pkey and port assignment in
 get_new_pps
Message-ID: <20200228152341.GA28371@ziepe.ca>
References: <20200227125728.100551-1-leon@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200227125728.100551-1-leon@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Thu, Feb 27, 2020 at 02:57:28PM +0200, Leon Romanovsky wrote:
> From: Maor Gottlieb <maorg@mellanox.com>
> 
> When port is part of the modify mask, then we should take
> it from the qp_attr and not from the old pps. Same for PKEY.
> 
> Cc: <stable@vger.kernel.org>
> Fixes: 1dd017882e01 ("RDMA/core: Fix protection fault in get_pkey_idx_qp_list")
> Signed-off-by: Maor Gottlieb <maorg@mellanox.com>
> Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
> ---
>  drivers/infiniband/core/security.c | 12 ++++++++----
>  1 file changed, 8 insertions(+), 4 deletions(-)

Applied to for-rc, thanks

Jason
