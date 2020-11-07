Return-Path: <SRS0=60yH=EN=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F965C388F9
	for <linux-rdma@archiver.kernel.org>; Sat,  7 Nov 2020 20:26:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C74D320B1F
	for <linux-rdma@archiver.kernel.org>; Sat,  7 Nov 2020 20:26:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1604780779;
	bh=YXvXkW38HfeyGfVedt2xstjkWzg0BS9FrUKV2L8Lu4I=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:List-ID:From;
	b=emrEKmpPjSRvUdK6PHXltGn9dpq9nWqLAgSzGOj038jJYtVwxJB39fY91D5hmIS0/
	 cS8zdZKGKvRPC6Bf5c+Fi0beuAc+uFFXGtYT++FNArBD38HsH11A9Sr2yzQ+TrIkSt
	 7vnIEYZTfxibyywfWIN75T4zso0KcL62k5ZhW6nc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725846AbgKGU0S (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Sat, 7 Nov 2020 15:26:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:53076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725836AbgKGU0S (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Sat, 7 Nov 2020 15:26:18 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2F2C720885;
        Sat,  7 Nov 2020 20:26:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604780778;
        bh=YXvXkW38HfeyGfVedt2xstjkWzg0BS9FrUKV2L8Lu4I=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=xbUkiyWoKX8bEbqrp2VgX5Qi0zA7zP4/NtyNf804JmzwZcsOoI5p8hwNX9EmUBDiq
         Vd1J2EC+cWmuWa265ZXALpbqlt1xC510vIdxrAiwqYH/pJSAG6t31tu+GDaMSDNH/Y
         VIquRLZonVgidWUHVWjWdMM3DR47ypU0/JK7/Fs8=
Date:   Sat, 7 Nov 2020 12:26:17 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Zhu Yanjun <yanjunz@nvidia.com>
Cc:     dledford@redhat.com, jgg@ziepe.ca, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH 1/1] RDMA/rxe: Fetch skb packets from ethernet layer
Message-ID: <20201107122617.55d0909c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1604574721-2505-1-git-send-email-yanjunz@nvidia.com>
References: <1604574721-2505-1-git-send-email-yanjunz@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Thu,  5 Nov 2020 19:12:01 +0800 Zhu Yanjun wrote:
> In the original design, in rx, skb packet would pass ethernet
> layer and IP layer, eventually reach udp tunnel.
> 
> Now rxe fetches the skb packets from the ethernet layer directly.
> So this bypasses the IP and UDP layer. As such, the skb packets
> are sent to the upper protocals directly from the ethernet layer.
> 
> This increases bandwidth and decreases latency.
> 
> Signed-off-by: Zhu Yanjun <yanjunz@nvidia.com>

Nope, no stealing UDP packets with some random rx handlers.

The tunnel socket is a correct approach.
