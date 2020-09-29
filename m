Return-Path: <SRS0=QnZA=DG=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D71D2C4727C
	for <linux-rdma@archiver.kernel.org>; Tue, 29 Sep 2020 12:37:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 89EFD2075F
	for <linux-rdma@archiver.kernel.org>; Tue, 29 Sep 2020 12:37:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1601383073;
	bh=S4wNT1s618zBR49BGhVX+tQF2CHbKbCGsPdgXgyr3UY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=keqVVQ40/ho6Hr11/+dcXHBvTOyLf5KlDlFTwEyG+8+JjtsLGf1P+2lcec3TJEXFw
	 bF3f7+8ez5g++WjXwIgJ319k1fpZyiuA5j4vjHjs57QcZuZhKENbwa2FHE5j8nMuwg
	 j6JNtHfE9dKrzEzXAvRdeRqrkxIIv1kIh8ZGaRa4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732977AbgI2Mhw (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 29 Sep 2020 08:37:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:48736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732170AbgI2MhT (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Tue, 29 Sep 2020 08:37:19 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5B9B92075F;
        Tue, 29 Sep 2020 12:37:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601383038;
        bh=S4wNT1s618zBR49BGhVX+tQF2CHbKbCGsPdgXgyr3UY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lmsXpnI7r0iwkDdjZ5+XzKl8hLcq4E7KTAWur2JExI4C/hTf9CpOt5hyaa0x7EoMJ
         Pp1FqhwKzdYR9lulHDWiKIuXkZFw6mv9oQQXYWV2mVxtwLZiEnaW1tG7tQnKaIOiia
         LkLIAxj7nlzosaz27eG8yAvY4EhGbsR8lzEMxgmA=
Date:   Tue, 29 Sep 2020 15:37:13 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Alex Dewar <alex.dewar90@gmail.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Roi Dayan <roid@mellanox.com>, Oz Shlomo <ozsh@mellanox.com>,
        Paul Blakey <paulb@mellanox.com>,
        Eli Britstein <elibr@mellanox.com>,
        Ariel Levkovich <lariel@nvidia.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net/mlx5e: Fix use of freed pointer
Message-ID: <20200929123713.GG3094@unreal>
References: <20200928074301.GC3094@unreal>
 <20200929101554.8963-1-alex.dewar90@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200929101554.8963-1-alex.dewar90@gmail.com>
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Tue, Sep 29, 2020 at 11:15:49AM +0100, Alex Dewar wrote:
> If the call to mlx5_fc_create() fails, then shared_counter will be freed
> before its member, shared_counter->counter, is accessed to retrieve the
> error code. Fix by using an intermediate variable.
>
> Addresses-Coverity: CID 1497153: Memory - illegal accesses (USE_AFTER_FREE)
> Fixes: 1edae2335adf ("net/mlx5e: CT: Use the same counter for both directions")
> Signed-off-by: Alex Dewar <alex.dewar90@gmail.com>
> ---
> v2:
> 	- Add Fixes tag (Leon)
> 	- Use ERR_CAST (Leon)
>
> Hi Leon,
>
> I've made the suggested changes. Let me know if there's anything else
> you need :)

Hi Alex,

Saeed already picked Dan's patch.
https://lore.kernel.org/linux-rdma/1017ab3724b83818c03dfa7661b3f31827a7f62f.camel@kernel.org/T/#t

>
> There is also this patch in the series which doesn't seem to have been
> reviewed yet: https://lore.kernel.org/lkml/20200927113254.362480-4-alex.dewar90@gmail.com/

Ariel is handling this internally.
https://lore.kernel.org/linux-rdma/64f6a3eaaac505c341f996df0b0877ee9af56c00.camel@kernel.org/T/#t

Thanks
