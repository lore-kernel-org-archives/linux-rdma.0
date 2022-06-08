Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66097CCA481
	for <linux-rdma@archiver.kernel.org>; Wed,  8 Jun 2022 07:33:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229862AbiFHHdJ (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 8 Jun 2022 03:33:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235696AbiFHG7W (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Wed, 8 Jun 2022 02:59:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AF641ABFBF;
        Tue,  7 Jun 2022 23:44:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8E750617A1;
        Wed,  8 Jun 2022 06:44:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4660C34116;
        Wed,  8 Jun 2022 06:44:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654670689;
        bh=yNnx6N3eLnUgiCl/dH4tjU5bfANtCwTJzH/dMkbQezU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IUyMOE05O5I3TVfrylQBhxOc0tWK8tktqqerIYrgQTABIVMM6yW/Ht+QVBZvoA8om
         cNHtxgiTVcjCnfqI5OTCmabiy75Y4jy0Dwfd4Lvcsadwk2jkG86Rydz6CrLYbnPLZv
         xEWok9sf7X6yfPovHfRNIcY902TkPtaP+zHuzxv8Qp/oIcnmVKuhlrCUVTHeMnC+Os
         dN1MERo7S5JZCnkwI5otQllBeMzqFLZmiij9ISKF3KiPfZBtQ2RpNvW4ftt+LGYQ/i
         sTTwNBSqQNafN4Xs64gRtfWHEWTCGv4Ub5xWhK1+tOGCiHz96zpomMrmsPaUp8djj9
         5vdIYDxSNr3+g==
Date:   Tue, 7 Jun 2022 23:44:48 -0700
From:   Saeed Mahameed <saeed@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Erez Shitrit <erezsh@mellanox.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [PATCH mlx5-next 2/3] net/mlx5: Manage ICM of type modify-header
 pattern
Message-ID: <20220608064448.inzjmsj3q33r2wif@sx1>
References: <cover.1654605768.git.leonro@nvidia.com>
 <3d76cbb6e498c23aead29359b88e07facdfe817e.1654605768.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <3d76cbb6e498c23aead29359b88e07facdfe817e.1654605768.git.leonro@nvidia.com>
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On 07 Jun 15:47, Leon Romanovsky wrote:
>From: Yevgeny Kliteynik <kliteyn@nvidia.com>
>
>Added support for managing new type of ICM for devices that
>support sw_owner_v2.
>
>Signed-off-by: Erez Shitrit <erezsh@mellanox.com>
>Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
>Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
>---
Acked-by: Saeed Mahameed <saeedm@nvidia.com>


