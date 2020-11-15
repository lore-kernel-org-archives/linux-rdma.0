Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D55CC2D0E4
	for <linux-rdma@archiver.kernel.org>; Sun, 15 Nov 2020 11:16:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 181C024137
	for <linux-rdma@archiver.kernel.org>; Sun, 15 Nov 2020 11:16:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="K5ceQwBs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726537AbgKOLPs (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Sun, 15 Nov 2020 06:15:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:49568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726510AbgKOLPs (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Sun, 15 Nov 2020 06:15:48 -0500
Received: from localhost (thunderhill.nvidia.com [216.228.112.22])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1296924137;
        Sun, 15 Nov 2020 11:15:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605438947;
        bh=5biriYSF3jcr9AsEXYh9NL1qyp33vyPN0dvDynjjYE8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=K5ceQwBsLFIZYrUZejdzDAPbZdjk2zVTGN/Pz9r/VrycFhEaJCQATyccAc6WpSsUE
         aRWJxy3eTwJUBG4lfaK00yZhO01zKBYOpxtSBOitjo8hElDOKwTD93l9oNUf3oqbBk
         wWhlt1W2311JXTzs8s0xWoVsA/Xw2sr5w0NIUNCc=
Date:   Sun, 15 Nov 2020 13:15:43 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Gal Pressman <galpress@amazon.com>
Cc:     Jason Gunthorpe <jgg@ziepe.ca>, Doug Ledford <dledford@redhat.com>,
        linux-rdma@vger.kernel.org
Subject: Re: [PATCH for-next 1/2] RDMA/core: Check .create_ah is not NULL
 only in case it's needed
Message-ID: <20201115111543.GC47002@unreal>
References: <20201115103404.48829-1-galpress@amazon.com>
 <20201115103404.48829-2-galpress@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201115103404.48829-2-galpress@amazon.com>
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Sun, Nov 15, 2020 at 12:34:02PM +0200, Gal Pressman wrote:
> Drivers now expose two callbacks for address handle creation, one for
> uverbs and one for kverbs. The function pointer NULL check in
> _rdma_create_ah() should only happen if !udata.
>
> A NULL check for .create_user_ah is not needed as it is validated by the
> uverbs uapi definitions.
>
> Fixes: 676a80adba01 ("RDMA: Remove AH from uverbs_cmd_mask")
> Signed-off-by: Gal Pressman <galpress@amazon.com>
> ---
>  drivers/infiniband/core/verbs.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
