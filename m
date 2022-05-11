Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D2F7C433EF
	for <linux-rdma@archiver.kernel.org>; Wed, 11 May 2022 16:24:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344703AbiEKQYV (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 11 May 2022 12:24:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240020AbiEKQYV (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Wed, 11 May 2022 12:24:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50CF76A42E;
        Wed, 11 May 2022 09:24:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D974C61C77;
        Wed, 11 May 2022 16:24:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE4CAC340EE;
        Wed, 11 May 2022 16:24:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652286259;
        bh=41kHDcKCUtsjErhh6LBF6+Fk65WUSvEWpX5q5DpBFig=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=I7hFY6qbCdUXqPiXBiWkDmwm8Fmi5U1mi15yZNMXM8nVcGr4hlgIfj0FQxtoWzbRk
         D9tEpd942lA+tS1JiDK47eMFx75sV0YYAk2/Ujd1RBJaZXLmM436n0dNd5TXXwckTJ
         t+xIaKLkAjjZfpex2A483jABfprDO3kqZjaOohTWfLrYtosdvOrloDLdL2M/RvyGkS
         jcXpPWxWondlP4z/Ujx4Wo0hnv4/4imOqbR7wMIH7CLcZXlYi3jrlJ+VWSjb2fapM5
         EJXoLarWaNQAfPhMaycHxcjPUQ45fZyAdX/G0a4yrxhPqMEFmMZdSLLEtdVqHBov4G
         Q11tSOPraBBOg==
Date:   Wed, 11 May 2022 09:24:17 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Kees Cook <keescook@chromium.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Coco Li <lixiaoyan@google.com>,
        Tariq Toukan <tariqt@nvidia.com>, netdev@vger.kernel.org,
        linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: Re: [PATCH] fortify: Provide a memcpy trap door for sharp corners
Message-ID: <20220511092417.3c1c60d9@kernel.org>
In-Reply-To: <20220511025301.3636666-1-keescook@chromium.org>
References: <20220511025301.3636666-1-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Tue, 10 May 2022 19:53:01 -0700 Kees Cook wrote:
> As we continue to narrow the scope of what the FORTIFY memcpy() will
> accept and build alternative APIs that give the compiler appropriate
> visibility into more complex memcpy scenarios, there is a need for
> "unfortified" memcpy use in rare cases where combinations of compiler
> behaviors, source code layout, etc, result in cases where the stricter
> memcpy checks need to be bypassed until appropriate solutions can be
> developed (i.e. fix compiler bugs, code refactoring, new API, etc). The
> intention is for this to be used only if there's no other reasonable
> solution, for its use to include a justification that can be used
> to assess future solutions, and for it to be temporary.
> 
> Example usage included, based on analysis and discussion from:
> https://lore.kernel.org/netdev/CANn89iLS_2cshtuXPyNUGDPaic=sJiYfvTb_wNLgWrZRyBxZ_g@mail.gmail.com

Saeed, ack for taking this in directly? Or do you prefer to take this
plus Eric's last BIG TCP patch via your tree?
