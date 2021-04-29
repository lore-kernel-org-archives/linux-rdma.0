Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 975B3C433B4
	for <linux-rdma@archiver.kernel.org>; Thu, 29 Apr 2021 07:13:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5E11361431
	for <linux-rdma@archiver.kernel.org>; Thu, 29 Apr 2021 07:13:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237620AbhD2HO3 (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 29 Apr 2021 03:14:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:33804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237080AbhD2HO2 (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Thu, 29 Apr 2021 03:14:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 57C2761431;
        Thu, 29 Apr 2021 07:13:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619680422;
        bh=lrF04FUENMdw0IZ00PxxH9+4e5XTu/SM4i+LDIRp/I8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MSryo71rf3VLlNiLxRDx9PQb2uRHpSIsi9RG4mBhsIEh2t1ZiJUuTBP+YaeUo6i3D
         7QzFEBOrVlLZYEPJMuWJzfPe5HgbLP3+YFdlLe44ZTUlLMTSDd9CY8ijXGd/b4ia9f
         Z1K/IDSeO1HvWRXQ9zjR9qnbMZhSe3aaULo4oQ9Idyta0RSduK/AzbfLNlu743gVCG
         vPWEijkduJGgOHfFfcjHGovyKbIyFLwnx2DrG9ljwx/Dqvz6Vyd/Y/MmK+99Ec7hQ5
         0zAriAadSkWWowqFUElpwtGk+Jb0zm1uB+ZAV3NRuJyDmY230hzWcG3e8Vm5y5Kqfs
         4fNqjWu23FJng==
Date:   Thu, 29 Apr 2021 10:13:36 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Gal Pressman <galpress@amazon.com>
Cc:     David Ahern <dsahern@gmail.com>, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, Yossi Leybovich <sleybo@amazon.com>,
        Alexander Matushevsky <matua@amazon.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: Re: [PATCH iproute2-next v2 1/2] rdma: update uapi headers
Message-ID: <YIpcoDk4xMm8Llar@unreal>
References: <20210429064803.58458-1-galpress@amazon.com>
 <20210429064803.58458-2-galpress@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210429064803.58458-2-galpress@amazon.com>
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Thu, Apr 29, 2021 at 09:48:02AM +0300, Gal Pressman wrote:
> Update rdma_netlink.h file upto kernel commit
> 6cc9e215eb27 ("RDMA/nldev: Add copy-on-fork attribute to get sys command")
> 
> Signed-off-by: Gal Pressman <galpress@amazon.com>
> ---
>  rdma/include/uapi/rdma/rdma_netlink.h | 3 +++
>  1 file changed, 3 insertions(+)
> 

Thanks,
Acked-by: Leon Romanovsky <leonro@nvidia.com>
