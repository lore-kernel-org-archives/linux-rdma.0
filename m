Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2E1CC4743E
	for <linux-rdma@archiver.kernel.org>; Tue,  8 Jun 2021 05:33:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A0AA96127A
	for <linux-rdma@archiver.kernel.org>; Tue,  8 Jun 2021 05:33:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230251AbhFHFe7 (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 8 Jun 2021 01:34:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:54156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230184AbhFHFe7 (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Tue, 8 Jun 2021 01:34:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9BBD761263;
        Tue,  8 Jun 2021 05:33:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623130387;
        bh=aawTrLXXzizd9z6P2vOIOF9OjWxeNztIwf2vXccGvIY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QmM63uNuRkMcsNULVF7oNl0o1DS24o7q1Dnwacb+RvZvomfaiV33vHo3OGZE+I/qb
         IsFAt5Z1qsFYjpHiREN6nTddsw8AL6FxOh4CavYQkI/3FArxhurFjEQ5q3jz5LZCYx
         RRaOWptZyVGDWeeIX/4TukzY65EhbhmBC/b7LY0+ram2If18CJD8DLQIRq/U57CKH2
         sVcXGqa/DkzbBCBfVzfr8DEuFrSf+a/wjq66CNfeVjVXybB+/PUgDvv/M4N1TRHe7d
         8fNPJFWKVw92Nc/s8luZv/Vj08i0AQ05c5dn7SMbHBaGt8xZ0/oZo56MsxRzyvllpw
         gU99OLriX8AhQ==
Date:   Tue, 8 Jun 2021 08:33:03 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Pavel Skripkin <paskripkin@gmail.com>, dledford@redhat.com,
        shayd@nvidia.com, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] infiniband: core: fix memory leak
Message-ID: <YL8BDyMQKym5v7ob@unreal>
References: <20210605202051.14783-1-paskripkin@gmail.com>
 <YLxbbwcSli9bCec6@unreal>
 <20210607234449.GP1096940@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210607234449.GP1096940@ziepe.ca>
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Mon, Jun 07, 2021 at 08:44:49PM -0300, Jason Gunthorpe wrote:
> On Sun, Jun 06, 2021 at 08:21:51AM +0300, Leon Romanovsky wrote:
>  
> > I think that better fix is:
> > https://lore.kernel.org/linux-rdma/f72e27d5c82cd9beec7670141afa62786836c569.1622956637.git.leonro@nvidia.com/T/#u
> 
> Can you resend that with the bug report in the comment?

Done,
https://lore.kernel.org/linux-rdma/e2eed941f912b2068e371fd37f43b8cf5082a0e6.1623129597.git.leonro@nvidia.com/T/#u

>  
> What is the issue? Some error path missed a restrack_del? which one?

All paths that called to rdma_restrack_new(), but didn't set "id_priv->cma_dev" yet.
For example, cma_ib_new_conn_id() -> __rdma_create_id() -> do something -> exit on
error -> miss call to rdma_restrack_del()

> 
> And I still dislike that patch for adding restrack_del and undoing the
> previous patch which was trying to get rid of it, but if it actually
> fixes a bug...

And I didn't like the previous patch :).

Thanks

> 
> Jason
