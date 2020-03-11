Return-Path: <SRS0=rL3z=44=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FF53C10F27
	for <linux-rdma@archiver.kernel.org>; Wed, 11 Mar 2020 07:01:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 48C5021655
	for <linux-rdma@archiver.kernel.org>; Wed, 11 Mar 2020 07:01:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1583910069;
	bh=fhVasLP32gPRfCMLa0oRLJIRKWwKu2qcOk0J+oh3nh0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=m8pexMkguL6CtAqMKp8li9SUJjanGw4XxhSSoLxiQe8YiyDMAWJsc1IUxFrYhJwm2
	 uQ4cRl33N5rYnkKt9chnRuW/Qr2UwV7gJxtQ0kQ/r5C3BvOsAWM86KSIuLB4KkNosD
	 e+No9Zwydid0UT6HMCKn1uhxycoYGry5ipO/1rRk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728374AbgCKHBI (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 11 Mar 2020 03:01:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:33216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728255AbgCKHBI (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Wed, 11 Mar 2020 03:01:08 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D8D4A2146E;
        Wed, 11 Mar 2020 07:01:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583910067;
        bh=fhVasLP32gPRfCMLa0oRLJIRKWwKu2qcOk0J+oh3nh0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aWw3bOCgVQOJtfHVZXCMvIOeTA6PQFRA5MvM3CE5HvCYasump4362ewq84Gxep2F6
         Bux9LJqlI9Hu9c/Hlp1MXEWq3/M32JK/1Z/969ayX3o1ofGHEpONy4pOif25DkY19o
         1aH2I8OIDNkoy44R3zD6Q+oLEZtZLilikDxSrROc=
Date:   Wed, 11 Mar 2020 09:01:03 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Joe Perches <joe@perches.com>
Cc:     Boris Pismenny <borisp@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next 001/491] MELLANOX ETHERNET INNOVA DRIVERS: Use
 fallthrough;
Message-ID: <20200311070103.GF4215@unreal>
References: <cover.1583896344.git.joe@perches.com>
 <605f5d4954fcb254fe6fc5c22dc707f29b3b7405.1583896347.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <605f5d4954fcb254fe6fc5c22dc707f29b3b7405.1583896347.git.joe@perches.com>
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Tue, Mar 10, 2020 at 09:51:15PM -0700, Joe Perches wrote:
> Convert the various uses of fallthrough comments to fallthrough;
>
> Done via script
> Link: https://lore.kernel.org/lkml/b56602fcf79f849e733e7b521bb0e17895d390fa.1582230379.git.joe.com/
>
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c | 2 +-
>  drivers/net/ethernet/mellanox/mlx5/core/fpga/conn.c        | 4 ++--
>  2 files changed, 3 insertions(+), 3 deletions(-)
>

Thanks,
Reviewed-by: Leon Romanovsky <leonro@mellanox.com>
