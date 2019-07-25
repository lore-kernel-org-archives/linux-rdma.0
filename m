Return-Path: <SRS0=3z7h=VW=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46A07C76194
	for <linux-rdma@archiver.kernel.org>; Thu, 25 Jul 2019 17:25:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1D16B229F3
	for <linux-rdma@archiver.kernel.org>; Thu, 25 Jul 2019 17:25:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="XQB2M3j4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389959AbfGYRZF (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 25 Jul 2019 13:25:05 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:34140 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388580AbfGYRZE (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Thu, 25 Jul 2019 13:25:04 -0400
Received: by mail-qt1-f193.google.com with SMTP id k10so49926323qtq.1
        for <linux-rdma@vger.kernel.org>; Thu, 25 Jul 2019 10:25:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=nZjOlksO4JfZTterdNUKxdfIQ3C9AyMyEwJzZEQ23H8=;
        b=XQB2M3j4R1J+0cNz1XBeQH1R6mTaI7/RAN6MbHYypmvkz3DCsgO/t9tH4sLzf3fsAT
         O0OgmsC1zr/Kjr5S5eKnd2Iz4alKer8ULIlrDZaeDiIiXaDo+LndR2O3xXlfWHHy2dpz
         5yhU286whGZq2LaW42b2wp/Tlk60ost3DlJ8sp6/ObNYM1OMjgG1GOxdZlni5BvGro6M
         gOEDsGhhgQ3fgtcgomw8k7awgkvj1+eEznBM8ydZXM3YedjTA/uPDRe+/XpU05EMiSv0
         yziBOb7rKuv/XrZwEgEK5o4wGNNFE+AYyqOdI0MolvjBS3wAood7hnphAUssMeUnUql6
         GT4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=nZjOlksO4JfZTterdNUKxdfIQ3C9AyMyEwJzZEQ23H8=;
        b=ifiVdIDQ5EL078YWvhiJp8Glg8A7SaJQq46kY+vfNjKPq4Ly7fOXZEmp3bYSI54gnm
         pO+c2tNg5a2/ogyMx59u+Jejdv+5eyusYlv/igeXGwCrPOUNBO5/1CxmpsZJHAohrLiG
         ynIQ2OKbrwA8BaO3H1sb1joSfN7ZcxYjNrLfvNI1j7JZeMb/rUepYSqayxX9sNpYUJv5
         n/+FkMbGq2zqMmEt4KogDTHMLuA9npgLdgrY6Y+pmpk7GvGs1A6Mir+6S966bEcAXoxj
         14Qc1CLbrQcZ9lAq3ydtR63ctz7J4lhNJKx5XGQUwnMtcUjJVUZeJ+ZWJyvsAVtZDIjs
         iRXA==
X-Gm-Message-State: APjAAAXM/xejrKeVDN8acSu75W/2gC/WKDvWH4YY+cFuFh3/EprlsWYQ
        337PmPTdgOVuWYErVuGFk4b8qodfD56pag==
X-Google-Smtp-Source: APXvYqyROF7pK0dkFH6MQYJwo0fLRKBJENFNs3W+E1fYJvhG0X2y3kuhHMwcDRdM6Dg4WpyW3ndAhA==
X-Received: by 2002:ac8:2d19:: with SMTP id n25mr63091009qta.180.1564075503903;
        Thu, 25 Jul 2019 10:25:03 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-156-34-55-100.dhcp-dynamic.fibreop.ns.bellaliant.net. [156.34.55.100])
        by smtp.gmail.com with ESMTPSA id u4sm22388219qkb.16.2019.07.25.10.25.03
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 25 Jul 2019 10:25:03 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1hqhUF-0004rH-2E; Thu, 25 Jul 2019 14:25:03 -0300
Date:   Thu, 25 Jul 2019 14:25:03 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Doug Ledford <dledford@redhat.com>,
        Max Gurtovoy <maxg@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Leon Romanovsky <leonro@mellanox.com>
Subject: Re: [PATCH rdma-next] IB/mlx5: Add CREATE_PSV/DESTROY_PSV for devx
 interface
Message-ID: <20190725172503.GA18649@ziepe.ca>
References: <20190723070412.6385-1-leon@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190723070412.6385-1-leon@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Tue, Jul 23, 2019 at 10:04:12AM +0300, Leon Romanovsky wrote:
> From: Max Gurtovoy <maxg@mellanox.com>
> 
> Limit the number of PSV's created through devx to 1, to create a symmetry
> between create/destroy cmds. In the kernel, one can create up to 4 PSV's
> using CREATE_PSV cmd but the destruction is one by one. Add a protection
> for this a-symmetric definition for devx.
> 
> Signed-off-by: Max Gurtovoy <maxg@mellanox.com>
> Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
> ---
>  drivers/infiniband/hw/mlx5/devx.c | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
 
Applied to for-next, thanks

Jason
