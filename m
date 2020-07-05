Return-Path: <SRS0=uC3E=AQ=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C895C433E0
	for <linux-rdma@archiver.kernel.org>; Sun,  5 Jul 2020 13:19:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 06A232075D
	for <linux-rdma@archiver.kernel.org>; Sun,  5 Jul 2020 13:19:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1593955199;
	bh=2iIeteUImKkLRExE44WTMmmp+Iwl829VzHHqaslXvIo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=vktZWKitfvlWSzr+nd0zvIfQXeMy3y83hhD2Ihq8uBfLkv51L2l9xsMyBY9A7p0kO
	 KGGcuVAUKOe5trXzRDiiH6XdIKdEeoGVL2DtwvaC8kxSbaK0sRbski+AOeIAtL2a+0
	 2JY7oB1R/u1YazKu5DX9Ln+mdophm1VWVNwA3TjQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726933AbgGENT6 (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Sun, 5 Jul 2020 09:19:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:52478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726898AbgGENT6 (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Sun, 5 Jul 2020 09:19:58 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2FB5520739;
        Sun,  5 Jul 2020 13:19:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593955197;
        bh=2iIeteUImKkLRExE44WTMmmp+Iwl829VzHHqaslXvIo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=D4gEc0xyxhEMdqjzngq3KDXUZjdQcAQl8SJ/T1NBpBgK9z/lDwZ5bVlYv9ojQtJCE
         a67T3/ud/3DQmGZ0TRu5gvDxWQ5sBAqCTWCUp4VdkDMEIMkt5JI+z2wgq+Ck5XnEDR
         XjG0WqutQhKmyaYXhShcEANmzrPgjCMubr2JWEcU=
Date:   Sun, 5 Jul 2020 16:19:53 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        Saeed Mahameed <saeedm@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, tglx@linutronix.de
Subject: Re: [PATCH net] net/mlx5e: Do not include rwlock.h directly
Message-ID: <20200705131953.GC5149@unreal>
References: <20200703164432.qp6pkukrbua3yyhl@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200703164432.qp6pkukrbua3yyhl@linutronix.de>
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Fri, Jul 03, 2020 at 06:44:32PM +0200, Sebastian Andrzej Siewior wrote:
> rwlock.h should not be included directly. Instead linux/splinlock.h
> should be included. Including it directly will break the RT build.
>
> Fixes: 549c243e4e010 ("net/mlx5e: Extract neigh-specific code from en_rep.c to rep/neigh.c")
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> ---
> It would be nice if this could get into v5.8 since this include has been
> added in v5.8-rc1.
>
>  drivers/net/ethernet/mellanox/mlx5/core/en/rep/neigh.c | 1 -
>  1 file changed, 1 deletion(-)
>

Thanks,
Reviewed-by: Leon Romanovsky <leonro@mellanox.com>
