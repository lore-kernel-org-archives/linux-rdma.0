Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE955C4167B
	for <linux-rdma@archiver.kernel.org>; Wed,  9 Dec 2020 17:06:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6F95923C44
	for <linux-rdma@archiver.kernel.org>; Wed,  9 Dec 2020 17:06:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732368AbgLIRFh (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 9 Dec 2020 12:05:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:56648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732200AbgLIRF2 (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Wed, 9 Dec 2020 12:05:28 -0500
Date:   Wed, 9 Dec 2020 09:04:46 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607533488;
        bh=vyacI6hBCPa+4zZ9w1CJdPaMh1LxvOMObr+Wq4DE23I=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=Rqmfi/nOaos23JB5E1VD05smyh2qbW8+7GxX1qL8jPM7X4N7uxmxKFh4YMZr9c8fw
         ajCgsUueHfg8+JDdVIItaHwgfWd0ze9gnHW5riI/AaWwW3i6qTsQ+zEKsP7ROVI9xZ
         L3Lg2SvPoJWYlLJY4yl3td3yTv7reOQDHCRMs0hhNCUsoLkC6+AYyRRmVcMpvhQF6w
         SmOP8sLQmLK/yKE3vTxF3O1ehVk41LfyhJGXYp4jh2Kp3FsNw7i902oNMG+b21Krjb
         KxbuNmjnsiXse2LZcRQevwkaivXBE6s3lbj03sNZncol6f1/YBzTtragIgXYc6D8fo
         wP6/O/MAuIuEQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Zou Wei <zou_wei@huawei.com>, saeedm@nvidia.com,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] net/mlx5_core: remove unused including
 <generated/utsrelease.h>
Message-ID: <20201209090446.7daadd13@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201209062100.GK4430@unreal>
References: <1607343240-39155-1-git-send-email-zou_wei@huawei.com>
        <20201208112226.1bb31229@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
        <20201209062100.GK4430@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Wed, 9 Dec 2020 08:21:00 +0200 Leon Romanovsky wrote:
> On Tue, Dec 08, 2020 at 11:22:26AM -0800, Jakub Kicinski wrote:
> > On Mon, 7 Dec 2020 20:14:00 +0800 Zou Wei wrote:  
> > > Remove including <generated/utsrelease.h> that don't need it.
> > >
> > > Signed-off-by: Zou Wei <zou_wei@huawei.com>
> > > ---
> > >  drivers/net/ethernet/mellanox/mlx5/core/en_rep.c | 1 -
> > >  1 file changed, 1 deletion(-)
> > >
> > > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
> > > index 989c70c..82ecc161 100644
> > > --- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
> > > +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
> > > @@ -30,7 +30,6 @@
> > >   * SOFTWARE.
> > >   */
> > >
> > > -#include <generated/utsrelease.h>
> > >  #include <linux/mlx5/fs.h>
> > >  #include <net/switchdev.h>
> > >  #include <net/pkt_cls.h>  
> 
> Jakub,
> 
> You probably doesn't have latest net-next.
> 
> In the commit 17a7612b99e6 ("net/mlx5_core: Clean driver version and
> name"), I removed "strlcpy(drvinfo->version, UTS_RELEASE,
> sizeof(drvinfo->version));" line.
> 
> The patch is ok, but should have Fixes line.
> Fixes: 17a7612b99e6 ("net/mlx5_core: Clean driver version and name")

Hm. Pretty sure our build bot gets a fresh copy before testing. 
Must had been some timing issue, perhaps? Looks like the commit
came in with the auxbus merge.
