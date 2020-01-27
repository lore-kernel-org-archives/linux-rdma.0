Return-Path: <SRS0=4++I=3Q=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76ACFC2D0DB
	for <linux-rdma@archiver.kernel.org>; Mon, 27 Jan 2020 15:40:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3D21C20716
	for <linux-rdma@archiver.kernel.org>; Mon, 27 Jan 2020 15:40:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1580139602;
	bh=yxV5i/ey6aBEFwz0rjwjXdarrHeZEaWS2JsglKRvKRo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=DSKIN8unduBn2elk3tuoy8Lr3zy0vW3VsaBsoSRUdUTtyu1xtRq4KpwKMfd7d6W9/
	 6ZfcJahXGI822EZNa6YGPAKBCBf+ML7/SYJsUMU1KgBEoewT9BfeND6FYBLUYCHjny
	 41I/KlwSJf4jecZhW6U28hg4y747fIeBy06VvNzI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729213AbgA0PkB (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 27 Jan 2020 10:40:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:36944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729146AbgA0PkB (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Mon, 27 Jan 2020 10:40:01 -0500
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 57EA520716;
        Mon, 27 Jan 2020 15:40:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580139601;
        bh=yxV5i/ey6aBEFwz0rjwjXdarrHeZEaWS2JsglKRvKRo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=f+tNAc5xateSa19Y2tCNokSVsNpIpwPymhysoTNqw9biF4HPrLMyB+OVfQRaKH8b3
         X4EgzUH1fEt33iFKvIoDa+A6FT4XH/57AXZ+4zzHjXxOxSWuj/y0Om1WUinovgpro3
         32stOlwFoeUmZyU5GYFUeNlm6TAeFNKWlS8QHYYU=
Date:   Mon, 27 Jan 2020 17:39:57 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Shannon Nelson <snelson@pensando.io>,
        "David S . Miller" <davem@davemloft.net>,
        Michal Kalderon <michal.kalderon@marvell.com>,
        linux-netdev <netdev@vger.kernel.org>,
        RDMA mailing list <linux-rdma@vger.kernel.org>
Subject: Re: [PATCH net-next] net/core: Replace driver version to be kernel
 version
Message-ID: <20200127153957.GQ3870@unreal>
References: <20200123130541.30473-1-leon@kernel.org>
 <43d43a45-18db-f959-7275-63c9976fdf40@pensando.io>
 <20200126194110.GA3870@unreal>
 <20200126124957.78a31463@cakuba>
 <20200126210850.GB3870@unreal>
 <20200126133353.77f5cb7e@cakuba>
 <2a8d0845-9e6d-30ab-03d9-44817a7c2848@pensando.io>
 <20200127053433.GF3870@unreal>
 <20200127064534.GJ3870@unreal>
 <20200127062108.082c9e5e@cakuba>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200127062108.082c9e5e@cakuba>
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Mon, Jan 27, 2020 at 06:21:08AM -0800, Jakub Kicinski wrote:
> On Mon, 27 Jan 2020 08:45:34 +0200, Leon Romanovsky wrote:
> > > The thing is that we don't consider in-kernel API as stable one, so
> > > addition of new field which is not in use in upstream looks sketchy to
> > > me, but I have an idea how to solve it.
> >
> > Actually, it looks like my idea is Jakub's and Michal's idea. I will use
> > this opportunity and remove MODULE_VERSION() too.
>
> If you do please make sure DKMS works. I remember it was looking at
> that value.

I'll check, thanks.

However from reading the source, it will be unlikely to see any
issues there.

DKMS uses modversion for two things. First is to manage internal tree
where those modules will be built and it knows how to install and clean
automatically modules. Second is to list modaliases, and it handles them
perfectly with and without version [1].

In our case, modules version will be available, it just going to change
from 1.0.0. to something like 5.5.0-rc6.

[1] https://github.com/dell/dkms/blob/master/dkms_find-provides#L48

Thanks
