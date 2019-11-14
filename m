Return-Path: <SRS0=+ait=ZG=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14A62C432C3
	for <linux-rdma@archiver.kernel.org>; Thu, 14 Nov 2019 15:54:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DFFA0206F4
	for <linux-rdma@archiver.kernel.org>; Thu, 14 Nov 2019 15:54:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="nzh5H/Rr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726980AbfKNPy2 (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 14 Nov 2019 10:54:28 -0500
Received: from mail-qt1-f194.google.com ([209.85.160.194]:40186 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726597AbfKNPy2 (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Thu, 14 Nov 2019 10:54:28 -0500
Received: by mail-qt1-f194.google.com with SMTP id o49so7276723qta.7
        for <linux-rdma@vger.kernel.org>; Thu, 14 Nov 2019 07:54:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=hHBp9Rngr0/24i035bFFf44VR2vxrTAay1OWpjjtXY0=;
        b=nzh5H/Rr4bG7FuXZ1Xz4g+iI0YNPS96ATAeGOknO8oj5zdPPXlt4R8PgYwVWRp6K0Y
         E1f943NVvvgL/oqVEfEQ/3uTi3qSOC6bnwnboZSY0I4OrztM+aSsFA8Tu4Q16iBh+xWJ
         TVJQbp3DGcacD7t9jV+2MggnZ7SxZI/aVoV02RgmV0IoJB8EcokprRnlOmcmyq3N6JCn
         /PwgdQpZViou3rjvQx+B1UHrh6skYu2olQUPJYobLEKtZEWM6wGmYHHLz81QqA8T65lc
         qWPmKSIx7CHXE5CzEHwGLUGl/Imp3zgExvdYC9UarSsE+G4QhgeAFueRQ7RELmL9y6LF
         hk/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=hHBp9Rngr0/24i035bFFf44VR2vxrTAay1OWpjjtXY0=;
        b=OTSi391e82Mjuqa8oWVjBnJznEvG55w5XGJQmhiEZcmc8sX4UIx27xix5704fbbXu1
         cia67VJw8chS3OyOB05z8wPY9khMfP2QynQ4w3sqfOYedVhOSdz93y+YPTdKHJCBi6nF
         tyGGFLY9Rer2QnILTSkEd1UwR+XGTN9Oa6XivJ++RnBYQ7nCJN7hv45S0ACClnKS3G50
         6IyzbFb5tg9KZEBntlYgtXtLlv8l/fGn5ic7bfsUzLVtFgJSDqW0AwOg/IlgIe/0AxT2
         zrn0QoBqeR6tEQ47aJKacJQh0qn+tOVQLRzt08SypxbxbVjEySdeIgfl5YaNSsnmc4Oq
         CVkQ==
X-Gm-Message-State: APjAAAXSl6NaQ9/fRG87U4IXDqKIHnRcZMCtV6dGpyBHeCBblhFA7Gam
        kou5B0gf1KrotajdymBQwjBKwg==
X-Google-Smtp-Source: APXvYqwpiXaK+rzDkvrMcpYhzU2ua+Ir1CVwJPJkiVyvP/2Ol1ns8TMFrdkZS8ztCtW8brsIYIbrQg==
X-Received: by 2002:ac8:2441:: with SMTP id d1mr8981400qtd.386.1573746867195;
        Thu, 14 Nov 2019 07:54:27 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-162-113-180.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.113.180])
        by smtp.gmail.com with ESMTPSA id s42sm3253153qtk.60.2019.11.14.07.54.26
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 14 Nov 2019 07:54:26 -0800 (PST)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1iVHRy-0007br-8c; Thu, 14 Nov 2019 11:54:26 -0400
Date:   Thu, 14 Nov 2019 11:54:26 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Colin King <colin.king@canonical.com>
Cc:     Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] infiniband: ocrdma: fix spelling mistake in variable name
Message-ID: <20191114155426.GB29207@ziepe.ca>
References: <20191107224855.417647-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191107224855.417647-1-colin.king@canonical.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Thu, Nov 07, 2019 at 10:48:55PM +0000, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> There is a spelling mistake in the variable nak_invalid_requst_errors,
> rename it to nak_invalid_request_errors.
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/infiniband/hw/ocrdma/ocrdma_sli.h   | 2 +-
>  drivers/infiniband/hw/ocrdma/ocrdma_stats.c | 4 ++--
>  2 files changed, 3 insertions(+), 3 deletions(-)

Applied to for-next, thanks

Jason
