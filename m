Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FB0CC352A1
	for <linux-rdma@archiver.kernel.org>; Wed, 30 Nov 2022 19:13:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229516AbiK3TNZ (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 30 Nov 2022 14:13:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbiK3TNY (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Wed, 30 Nov 2022 14:13:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AEBC578E2;
        Wed, 30 Nov 2022 11:13:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 53617B81CA9;
        Wed, 30 Nov 2022 19:13:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 536A0C433D6;
        Wed, 30 Nov 2022 19:13:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669835601;
        bh=5a0Wi1tTOl2eI+PZ0VBS9tDcKn+vlFyK3kLgB4S5xpE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GuPHEYHd/50QpxiURBEqLIgUpcIx7xsMsnsYOQzTO/MBnEWZa5Uead+1cWLzYy9ii
         H58urSlqsgIRN1Zi4tQbKtyW0UVaQoeMvTKIa4iMtpICAX31mE4k9tI7YGNm/UR0Kl
         IrM4IxySVYQY/mH0Dh2uit2JUnDc4NuxYGTwGMNBUOkaUFpNe/sHc8/wWW6o2p95Hx
         Qnz038wBIm9GOWLUwuo5tQijFpPnt61xR+yq4gU9ss7qIPeM77IkzCh020dVC9MzlQ
         u+DRiesz9kkSJ9N5qXpVsCtTnX8Iv/xHodRcVqW761qRsOSxQ94Lt02FU8h6pgMVKP
         9juN6uYWUSNzg==
Date:   Wed, 30 Nov 2022 21:13:16 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     zhang.songyi@zte.com.cn, saeedm@nvidia.com, pabeni@redhat.com,
        davem@davemloft.net, edumazet@google.com, mbloch@nvidia.com,
        maorg@nvidia.com, elic@nvidia.com, jerrliu@nvidia.com,
        cmi@nvidia.com, vladbu@nvidia.com, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net/mlx5: remove NULL check before dev_{put,
 hold}
Message-ID: <Y4erTPSg44sGU6S4@unreal>
References: <202211301541270908055@zte.com.cn>
 <Y4cbssiTgsGGNHlh@unreal>
 <20221130092516.024873db@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221130092516.024873db@kernel.org>
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Wed, Nov 30, 2022 at 09:25:16AM -0800, Jakub Kicinski wrote:
> On Wed, 30 Nov 2022 11:00:34 +0200 Leon Romanovsky wrote:
> > On Wed, Nov 30, 2022 at 03:41:27PM +0800, zhang.songyi@zte.com.cn wrote:
> > > From: zhang songyi <zhang.songyi@zte.com.cn>
> > > 
> > > The call netdev_{put, hold} of dev_{put, hold} will check NULL,
> > > so there is no need to check before using dev_{put, hold}.
> > > 
> > > Fix the following coccicheck warning:
> > > /drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c:1450:2-10:
> > > WARNING:
> > > WARNING  NULL check before dev_{put, hold} functions is not needed.
> > > 
> > > Signed-off-by: zhang songyi <zhang.songyi@zte.com.cn>
> > > ---
> > >  drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c | 3 +--
> > >  1 file changed, 1 insertion(+), 2 deletions(-)  
> > 
> > Please change all places in mlx5 in one patch.
> 
> Your call as a mlx5 maintainer, but I'd say don't change them at all.

I'm fine with one patch per-driver, I'm not fine with one patch per-line :).

> All these trivial patches are such a damn waste of time.

IMHO, it is valuable changes for actively developed code.

Thanks
