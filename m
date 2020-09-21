Return-Path: <SRS0=5Yt0=C6=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0486AC4363C
	for <linux-rdma@archiver.kernel.org>; Mon, 21 Sep 2020 21:20:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B906E2067D
	for <linux-rdma@archiver.kernel.org>; Mon, 21 Sep 2020 21:20:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600723257;
	bh=GlBPaFzBIxEkg12pusbeqtX3pDY74vujJw62VERkgEs=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:List-ID:From;
	b=jgKY3JlZH9scNF7Z9ApydheWSuR/CP/4R/P7ZJHwF+1/OXEGOOUU2FEhjWOgdmtR9
	 +nLJ66qKDvognUPuir0SGKauNvsANx1SeZQLio5GWZ1iQYHlAQrcNTbUe96jMqXb8d
	 4Mjz6whkQb1QluQB5qQCqvT/EBytRfbq9E072Na4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727499AbgIUVU4 (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 21 Sep 2020 17:20:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:49588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726497AbgIUVU4 (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Mon, 21 Sep 2020 17:20:56 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6AB9720888;
        Mon, 21 Sep 2020 21:20:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600723255;
        bh=GlBPaFzBIxEkg12pusbeqtX3pDY74vujJw62VERkgEs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ezbQzmjLFSfxTFwhX6cTl3+LkvUoQiafEYBg7asJ9Ns9HYPUgfNvrZf6UZOVZ+t6i
         vPye2wKRgkAHNLMhlsRPJKpn78zvfZLFodEF2aQqR8pdR4UAsgiIbN8nRf/lY8I1qS
         eghXK7r6mN4Uq/Uw9mGKXm5iTB82Gk374RoKfIz0=
Date:   Mon, 21 Sep 2020 14:20:53 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Oded Gabbay <oded.gabbay@gmail.com>
Cc:     Jason Gunthorpe <jgg@ziepe.ca>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Leon Romanovsky <leon@kernel.org>,
        Gal Pressman <galpress@amazon.com>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, SW_Drivers <SW_Drivers@habana.ai>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-rdma@vger.kernel.org
Subject: Re: [PATCH v3 00/14] Adding GAUDI NIC code to habanalabs driver
Message-ID: <20200921142053.1d2310f6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200921115239.GC8409@ziepe.ca>
References: <20200918120340.GT869610@unreal>
        <CAFCwf12VPuyGFqFJK5D19zcKFQJ=fmzjwscdPG82tfR_v_h3Kg@mail.gmail.com>
        <20200918121905.GU869610@unreal>
        <20200919064020.GC439518@kroah.com>
        <20200919082003.GW869610@unreal>
        <20200919083012.GA465680@kroah.com>
        <CAFCwf122V-ep44Kqk1DgRJN+tq3ctxE9uVbqYL07apLkLe2Z7g@mail.gmail.com>
        <20200919172730.GC2733595@kroah.com>
        <20200919192235.GB8409@ziepe.ca>
        <20200920084702.GA533114@kroah.com>
        <20200921115239.GC8409@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Mon, 21 Sep 2020 08:52:39 -0300 Jason Gunthorpe wrote:
> I don't like this idea of backdooring a bunch of proprietary closed
> source RDMA userspace through drivers/misc, and if you don't have a
> clear idea how to get something equal for drivers/misc you should not
> accept the H_IOCTL_NIC.
> 
> Plus RoCE is complicated, there is a bunch of interaction with netdev
> and rules related to that that really needs to be respected.

+1

To me this code quite clearly fits the description of vendor SDK which
runs proprietary stuff on top. It's such an vendor SDK thing to do to
pick the parts of our infrastructure they like and "simplify the rest"
with its own re-implementation.

I'd wager the only reason you expose the netdevs at all is for link
settings, stats, packet capture and debug. You'd never run TCP traffic
over those links. And you're fighting against using Linux APIs for the
only real traffic that runs on those links - RDMA(ish) traffic.

Greg - I'm probably the least experience of the folks involved in this
conversation - could you ELI5 what's the benefit to the community from
merging this code?
