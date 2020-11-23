Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F5EFC64E69
	for <linux-rdma@archiver.kernel.org>; Mon, 23 Nov 2020 22:43:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 461A6206D8
	for <linux-rdma@archiver.kernel.org>; Mon, 23 Nov 2020 22:43:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="lyrDk1VI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732120AbgKWWnv (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 23 Nov 2020 17:43:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:49056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731363AbgKWWnu (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Mon, 23 Nov 2020 17:43:50 -0500
Received: from embeddedor (187-162-31-110.static.axtel.net [187.162.31.110])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8C33E206D5;
        Mon, 23 Nov 2020 22:43:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606171430;
        bh=y7ECRIVfKd/wCJxrO8QsTJZZThS8Vsu/7i3K/imXrgw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lyrDk1VITtc6U7Djg4F6pyDPakWlTE+U7xkrqIMXrJKgHrIVIdmF6J7wl/cBjMIKV
         vvB8h6ZrtlPcacIbKJppx6t9N0Dw3lCP0tFBReHGiFmkHly7pyz06T7EpoY8tEeGH6
         NSDZHdKA2PEYsn1YE/i/gjHR7p8qgMl6qSFirZI0=
Date:   Mon, 23 Nov 2020 16:44:04 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>
Cc:     Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH 008/141] IB/hfi1: Fix fall-through warnings for Clang
Message-ID: <20201123224404.GC21644@embeddedor>
References: <cover.1605896059.git.gustavoars@kernel.org>
 <13cc2fe2cf8a71a778dbb3d996b07f5e5d04fd40.1605896059.git.gustavoars@kernel.org>
 <e9d82266-fcef-336e-df61-22d80491d91f@cornelisnetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e9d82266-fcef-336e-df61-22d80491d91f@cornelisnetworks.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Sun, Nov 22, 2020 at 09:30:25AM -0500, Mike Marciniszyn wrote:
> 
> On 11/20/2020 1:25 PM, Gustavo A. R. Silva wrote:
> > In preparation to enable -Wimplicit-fallthrough for Clang, fix multiple
> > warnings by explicitly adding multiple break statements instead of just
> > letting the code fall through to the next case.
> > 
> > Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> 
> Looks good and tested with TID rdma to cover the interlock case.
> 
> Mike
> 
> Tested-by: Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>

Thanks, Mike.
--
Gustavo
