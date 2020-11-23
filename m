Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-22.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECD8DC6379D
	for <linux-rdma@archiver.kernel.org>; Mon, 23 Nov 2020 22:50:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A6725206D8
	for <linux-rdma@archiver.kernel.org>; Mon, 23 Nov 2020 22:50:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="usF0T6Ew"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733006AbgKWWtz (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 23 Nov 2020 17:49:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:50526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731246AbgKWWty (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Mon, 23 Nov 2020 17:49:54 -0500
Received: from embeddedor (187-162-31-110.static.axtel.net [187.162.31.110])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 89F3B206D8;
        Mon, 23 Nov 2020 22:49:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606171794;
        bh=vAETzlCrj0FL/49B6d1jXGllqdttTDxM90vnCFzTjuo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=usF0T6EwoBHtax6w0roOcR7ufY9s9fNMSnSnW5i5DFiGYCg7c86Q3QaW1o5qKashs
         w2v1Qn9K2CbCa5xuEg5r0bKOrddoxzV8ZGjPwmjlxdx7GVOfb/z/RfnMxEjSAQIoj+
         Eta2mc2wHdwrcpJM4tNTIVygIQEYR78dhhZBms9I=
Date:   Mon, 23 Nov 2020 16:50:08 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH 050/141] RDMA/mlx5: Fix fall-through warnings for Clang
Message-ID: <20201123225008.GN21644@embeddedor>
References: <cover.1605896059.git.gustavoars@kernel.org>
 <2b0c87362bc86f6adfe56a5a6685837b71022bbf.1605896059.git.gustavoars@kernel.org>
 <20201123083332.GC3159@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201123083332.GC3159@unreal>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Mon, Nov 23, 2020 at 10:33:32AM +0200, Leon Romanovsky wrote:
> On Fri, Nov 20, 2020 at 12:31:49PM -0600, Gustavo A. R. Silva wrote:
> > In preparation to enable -Wimplicit-fallthrough for Clang, fix a warning
> > by explicitly adding the new pseudo-keyword fallthrough; instead of
> > letting the code fall through to the next case.
> >
> > Link: https://github.com/KSPP/linux/issues/115
> > Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> > ---
> >  drivers/infiniband/hw/mlx5/qp.c | 1 +
> >  1 file changed, 1 insertion(+)
> >
> 
> Thanks,
> Acked-by: Leon Romanovsky <leonro@nvidia.com>

Thanks, Leon.
--
Gustavo
