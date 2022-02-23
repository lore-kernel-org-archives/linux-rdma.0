Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A2A7C433EF
	for <linux-rdma@archiver.kernel.org>; Wed, 23 Feb 2022 23:17:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235836AbiBWXRq (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 23 Feb 2022 18:17:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233832AbiBWXRp (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Wed, 23 Feb 2022 18:17:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C6C637024;
        Wed, 23 Feb 2022 15:17:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4B343619E4;
        Wed, 23 Feb 2022 23:17:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6714BC340E7;
        Wed, 23 Feb 2022 23:17:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645658235;
        bh=2j5qdLYLyNpgWNQoAqvArHfGe2FDI4NtzlDmxi4VKrw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=hGO3eS+LUGbRUyx71Fw6wqqB/YuYwgM9ciQrN3G590SW9bSZCCj+Fd3RGEI+t05Dh
         p2oqjIBucdih3pyWpD6FUzAdqyst99JU1ZRy5/ghzKW980IJH1Z6PbK3R7wOx31z8z
         IAreyj8skp49JHFYbEuo129Ta+3UYF61HIFFO+i0/j/JKmpiZH9lyr+24Bx+MCUsA7
         MOAtASDmzD/adweGprSvlVDFN/3y8akuiefpEDeHLgiqHsWJ5AW6m0Z0W3sMypDO5i
         zWqY0KH00JF8CVe5YR9LnOZNMS3MbY9FsW4F74jKG4Oq3nHIcxTDuSy12CUh9TFAsK
         ScJSYIbRsH6ww==
Date:   Wed, 23 Feb 2022 15:17:14 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [mlx5-next 01/17] mlx5: remove usused static inlines
Message-ID: <20220223151714.48bdb93d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220223050932.244668-2-saeed@kernel.org>
References: <20220223050932.244668-1-saeed@kernel.org>
        <20220223050932.244668-2-saeed@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Tue, 22 Feb 2022 21:09:16 -0800 Saeed Mahameed wrote:
> Subject: [mlx5-next 01/17] mlx5: remove usused static inlines

If you haven't sent it out anywhere, yet - s/usused/unused/
