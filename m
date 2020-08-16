Return-Path: <SRS0=BtTd=B2=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8F33C433DF
	for <linux-rdma@archiver.kernel.org>; Sun, 16 Aug 2020 07:58:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CBDE4206DA
	for <linux-rdma@archiver.kernel.org>; Sun, 16 Aug 2020 07:58:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726560AbgHPH6H (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Sun, 16 Aug 2020 03:58:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:59130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725986AbgHPH6H (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Sun, 16 Aug 2020 03:58:07 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 020002065C;
        Sun, 16 Aug 2020 07:58:05 +0000 (UTC)
Date:   Sun, 16 Aug 2020 10:58:03 +0300
From:   Leon Romanovsky <leonro@nvidia.com>
To:     Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@gmail.com>
Cc:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        linux-netdev <netdev@vger.kernel.org>,
        RDMA mailing list <linux-rdma@vger.kernel.org>
Subject: Re: [PATCH iproute2-rc v1 0/2] Fix rdmatool JSON conversion
Message-ID: <20200816075803.GF7555@unreal>
References: <20200811073201.663398-1-leon@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200811073201.663398-1-leon@kernel.org>
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Tue, Aug 11, 2020 at 10:31:59AM +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
>
> Changelog:
> v1:
>  * Added extra patch
>  * Don't print [] in owner name in JSON output
> v0:
> https://lore.kernel.org/linux-rdma/20200811063304.581395-1-leon@kernel.org
> ---------------------------------------------------------------------------
>
> Two fixes to RDMAtool JSON/CLI prints.
>
> Leon Romanovsky (2):
>   rdma: Fix owner name for the kernel resources
>   rdma: Properly print device and link names in CLI output
>
>  rdma/res.c | 24 +++++++++++++++++-------
>  1 file changed, 17 insertions(+), 7 deletions(-)

Stephen, David

Is anything expected from me before merging the fixes?

Thanks

>
> --
> 2.26.2
>
