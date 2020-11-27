Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3E9EC63798
	for <linux-rdma@archiver.kernel.org>; Fri, 27 Nov 2020 13:05:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4DF89206D9
	for <linux-rdma@archiver.kernel.org>; Fri, 27 Nov 2020 13:05:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="FRKcZfqh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729820AbgK0NFY (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Fri, 27 Nov 2020 08:05:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729650AbgK0NFY (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Fri, 27 Nov 2020 08:05:24 -0500
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 003FEC0613D4
        for <linux-rdma@vger.kernel.org>; Fri, 27 Nov 2020 05:05:23 -0800 (PST)
Received: by mail-qk1-x741.google.com with SMTP id q22so4232921qkq.6
        for <linux-rdma@vger.kernel.org>; Fri, 27 Nov 2020 05:05:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=0Yf2SSd1C2wSWPwt5DssVFCCkFk2g3a7M55pr0bzd44=;
        b=FRKcZfqhbBGYtkE6CJKRlf7kPdkklbori2H2ODXk4mlAM2/hriEcdg+yBE83vHnJOD
         gtYQKwc/UbG9Wc6WDNm4G/2BNQV1+YwnPDYHMd0po6p1s2UiPFRJIdWN6rJ7q7OKoD6c
         V9avJ/KjIdwL2CNJDtF3AS9Su+j4sSfpzal+PJbCxaJwDZEcIu5QeLoIpGIt6Pg8ewmd
         C+U+iRyH3YE9qW/rUwcEmjTi4LM9n42pLGTNarF84H+HIfwyIWe7MEFtyvAE+E+dlAyV
         2gC2XTMzxRPXX5catjoNcG8kjFHr42xTeo0u0XitR9uGCEJdi2rl/FLZv1azY3NqwqJi
         WrCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=0Yf2SSd1C2wSWPwt5DssVFCCkFk2g3a7M55pr0bzd44=;
        b=U/86uOJgaS/AubcTucgyg9zWX9QjsZEYlvr0UEOL6XNckDpVHlis8Wpbooxh9MkQf5
         W/92+NSVY+RfnPMkRTGX2JT/2ap6rNbrPO58lAc0jbBcRupnVIfY85Qb8z7619xP2zof
         IGDDuQOCVT7IchCxg8C1KbAo4j6bcHFF/gs/xtvLU5L+jJhGwYVDaXXTVBuGREaPrzHn
         arNQbYGjPAm8v1ZaWuJgsFLKW6kzQIiEnQKHg3HaqbC8mqEE8O7/Aj3KzOE2oDBbN5a7
         BWwTY/RfczGC3rjadYm+Kfyk65AMzHdzIO5t8p+bUvMxRaQEeDYSzTq+uWCxwSA9whj1
         Ix6Q==
X-Gm-Message-State: AOAM531Xn4pLUZs4dnIt4aOaiHYKuQ+GNOiB2CnSzVKig7t6NV7jwfc+
        IDGHZED0dnYCFgHu6VKP93bYH8dQlID1Tv3N
X-Google-Smtp-Source: ABdhPJw4GB7wH/RB7Ds/QJZ3iZG4iZ8MA034v381ThdT18RvsYNUTgA9xqDEJgHuSNFSAJ18HEMUuA==
X-Received: by 2002:a37:a4c:: with SMTP id 73mr8342162qkk.451.1606482323145;
        Fri, 27 Nov 2020 05:05:23 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-156-34-48-30.dhcp-dynamic.fibreop.ns.bellaliant.net. [156.34.48.30])
        by smtp.gmail.com with ESMTPSA id t126sm5651244qkh.133.2020.11.27.05.05.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Nov 2020 05:05:22 -0800 (PST)
Received: from jgg by mlx with local (Exim 4.94)
        (envelope-from <jgg@ziepe.ca>)
        id 1kidRB-002XaB-FD; Fri, 27 Nov 2020 09:05:21 -0400
Date:   Fri, 27 Nov 2020 09:05:21 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Leon Romanovsky <leon@kernel.org>,
        Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] RDMA/mlx5: Fix a error code in devx_umem_reg_cmd_alloc()
Message-ID: <20201127130521.GV5487@ziepe.ca>
References: <20201127074349.GA7391@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201127074349.GA7391@mwanda>
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Fri, Nov 27, 2020 at 10:43:49AM +0300, Dan Carpenter wrote:
> This code returns PTR_ERR(NULL) which is zero or success but it should
> return -ENOMEM.
> 
> Fixes: 878f7b31c3a7 ("RDMA/mlx5: Use ib_umem_find_best_pgsz() for devx")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
>  drivers/infiniband/hw/mlx5/devx.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Not quite, it is worse, cmd->in is never NULL in the first place

https://lore.kernel.org/linux-rdma/0-v1-4d05ccc1c223+173-devx_err_ptr_jgg@nvidia.com/

Jason
