Return-Path: <linux-rdma-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B160C61DB3
	for <linux-rdma@archiver.kernel.org>; Fri,  6 Jan 2023 21:17:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230281AbjAFVRl (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Fri, 6 Jan 2023 16:17:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236366AbjAFVR0 (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Fri, 6 Jan 2023 16:17:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8910F26D;
        Fri,  6 Jan 2023 13:17:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 23D1861F7B;
        Fri,  6 Jan 2023 21:17:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5924DC433EF;
        Fri,  6 Jan 2023 21:17:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673039844;
        bh=QB5AwjKeWWhvw5Z1NuNuVpQZGGr6CYrqmnve8NpIVyw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=elZczKUQRrJ3dkqc5wWtldwvl7x3DeQPutmAeT3w2YFxPjRlGTxrBwyuoQ92waHGv
         +Ekb+7jZA0JZjN2+riwEcogycF2cbig/9K0D4dZhIbVUXNc4yKDYTMPqfa48P/1R/P
         DbWRyDexx4nZAKLQ0XZIkeze4sP3MJ8JmNxk7aSXxOFFALmvih+vUQ5+dLXwEeQ1Yj
         U9UdQITaiql0AmW7v0tqFXeixGTV25v1+CzvgJVujDNVYaRhAHrnIt1hbqUyPzVn1K
         q+DECpXQClIKqhKzPmoliu6Iwwvd2ITYybNnri/lG7asAumr4F5E2pTXHZlchdlQe3
         fH0uKmHTXekzA==
Date:   Fri, 6 Jan 2023 13:17:23 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH mlx5-next 0/8] mlx5 IPsec RoCEv2 support and netdev
 events fixes in RDMA
Message-ID: <20230106131723.2c7596e3@kernel.org>
In-Reply-To: <Y7h4Cl/69g2yQzKh@x130>
References: <20230105041756.677120-1-saeed@kernel.org>
        <20230105103846.6dc776a3@kernel.org>
        <Y7h4Cl/69g2yQzKh@x130>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Fri, 6 Jan 2023 11:35:38 -0800 Saeed Mahameed wrote:
> On 05 Jan 10:38, Jakub Kicinski wrote:
> >On Wed,  4 Jan 2023 20:17:48 -0800 Saeed Mahameed wrote:  
> >>   net/mlx5: Configure IPsec steering for ingress RoCEv2 traffic
> >>   net/mlx5: Configure IPsec steering for egress RoCEv2 traffic  
> >
> >How is the TC forwarding coming along?  
> 
> Not aware of such effort, can you please elaborate ? 

When Leon posted the IPsec patches I correctly guessed that it's for
RDMA and expressed my strong preference for RDMA to stop using netdev
interfaces for configuration. He made the claim that the full IPsec
offload will be used for eswitch offload as well, so I'm asking how 
is that work going.
