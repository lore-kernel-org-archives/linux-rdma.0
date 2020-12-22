Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-21.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4597C433E0
	for <linux-rdma@archiver.kernel.org>; Tue, 22 Dec 2020 08:34:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8301C22527
	for <linux-rdma@archiver.kernel.org>; Tue, 22 Dec 2020 08:34:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725811AbgLVIeM (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 22 Dec 2020 03:34:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:44360 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725782AbgLVIeM (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Tue, 22 Dec 2020 03:34:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 65C9623127;
        Tue, 22 Dec 2020 08:33:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608626012;
        bh=md//pfLxBekOda4JZEV74M/jy+hyMopue84JfQiWigA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=L9nfZbNjO6FVU0ZuonW0b67UqhI717BH/6pEbyCcMYLAay2Y3C0Xhl+KCKf06KYUu
         9CeDbnZk+TeMEjHiPXEj972eG/dB6IjDHruBTCZ1HEujiyQ6XZryZJl5+s8NUYpZyZ
         bKaQH6ji8ScyqhgYbFPOTvjCPWSiUGhFB5OO7/G4Xl02P/aFu1reyJhXjAFjclWjry
         71xWFiKEpMZSG6t0m3AS/G1UstpdnQinx/EJOC6iRlkTop4WLkHiljywIaAYjgOnWr
         f7ovg7GTkIuYQDPa1wcKiZTCdw3DfYvsPCvS7OOr23B6uGEE2+UV9cRcMGfrHBNXfB
         MPhJN9C+HOqYw==
Date:   Tue, 22 Dec 2020 10:33:27 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Xiao Yang <yangx.jy@cn.fujitsu.com>
Cc:     linux-rdma@vger.kernel.org
Subject: Re: [PATCH v2] librdmacm: Make some functions report proper errno
Message-ID: <20201222083327.GD3128@unreal>
References: <20201216092252.155110-1-yangx.jy@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201216092252.155110-1-yangx.jy@cn.fujitsu.com>
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Wed, Dec 16, 2020 at 05:22:52PM +0800, Xiao Yang wrote:
> Some functions reports fixed ENOMEM when getting any failure, so
> it's hard for user to know which actual error happens on them.
>
> Fixes(ucma_get_device):
> 2ffda7f29913 ("librdmacm: Only allocate verbs resources when needed")
> 191c9346f335 ("librdmacm: Reference count access to verbs context")
> Fixes(ucma_create_cqs):
> f8f1335ad8d8 ("librdmacm: make CQs optional for rdma_create_qp")
> 9e33488e8e50 ("librdmacm: fix all calls to set errno")
> Fixes(rdma_create_qp_ex):
> d2efdede11f7 ("r4019: Add support for userspace RDMA connection management abstraction (CMA)")
> 4e33a4109a62 ("librdmacm: returns errors from the library consistently")
> 995eb0c90c1a ("rdmacm: Add support for XRC QPs")
>
> Signed-off-by: Xiao Yang <yangx.jy@cn.fujitsu.com>
> ---
>  librdmacm/cma.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>

Thanks, applied.
https://github.com/linux-rdma/rdma-core/pull/908
