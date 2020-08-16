Return-Path: <SRS0=BtTd=B2=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BBEAC433E1
	for <linux-rdma@archiver.kernel.org>; Sun, 16 Aug 2020 07:45:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 48F16206F4
	for <linux-rdma@archiver.kernel.org>; Sun, 16 Aug 2020 07:45:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597563927;
	bh=yrwWbReTJiMOdl6gLqgZnHv3hF7W9CVNliTxMYmKQjY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=TwyJ3GB/bJinfy9yqPIQdmTzAFZvSvX0Pg8Vq0A0Io0oI9eW124a8nG9IWqUQD6kU
	 TqXGH+TCeIY8RVrwl8JoKoKbn/tbBLSpvJKvkKzPok+l4B3pzx3UhfeZPPDLyx19KS
	 LMiPhkXH+qRloCJMcA6Uw5PViAkgxSM1ti2fIYpw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728067AbgHPHp0 (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Sun, 16 Aug 2020 03:45:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:55216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728044AbgHPHp0 (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Sun, 16 Aug 2020 03:45:26 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 062332065C;
        Sun, 16 Aug 2020 07:45:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597563925;
        bh=yrwWbReTJiMOdl6gLqgZnHv3hF7W9CVNliTxMYmKQjY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=e70F6e+A3Jeqc8qX7wB+fj2Zyyt2/t5t1DwYaWax1wVsjlTv7Poeci7AlqHelj9ay
         +V+aTF1SyjzD0HSOEFlEgMx0nv+nFtQ7OGnZK56JEqpelKez3OlB/mrvT86oettAdx
         WtIzgUwklmv+WIJAQxO5BOuZifThM5BFFpIZlSeI=
Date:   Sun, 16 Aug 2020 10:45:21 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Zhu Yanjun <yanjunz@mellanox.com>
Cc:     zyjzyj2000@gmail.com, yanjunz@nvidia.com,
        linux-rdma@vger.kernel.org, dledford@redhat.com, jgg@ziepe.ca,
        netdev@vger.kernel.org
Subject: Re: [PATCH 1/1] MAINTAINERS: SOFT-ROCE: Change Zhu Yanjun's email
 address
Message-ID: <20200816074521.GE7555@unreal>
References: <1597555550-26300-1-git-send-email-yanjunz@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1597555550-26300-1-git-send-email-yanjunz@mellanox.com>
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Sun, Aug 16, 2020 at 01:25:50PM +0800, Zhu Yanjun wrote:
> I prefer to use this email address for kernel related work.
>
> Signed-off-by: Zhu Yanjun <yanjunz@mellanox.com>
> ---
>  MAINTAINERS |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)

It was already handled.
https://lore.kernel.org/lkml/20200810091100.243932-1-leon@kernel.org/

Thanks
