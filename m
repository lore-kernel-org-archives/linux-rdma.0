Return-Path: <SRS0=VZhB=DV=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8508AC433DF
	for <linux-rdma@archiver.kernel.org>; Wed, 14 Oct 2020 07:53:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 312F82222A
	for <linux-rdma@archiver.kernel.org>; Wed, 14 Oct 2020 07:53:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602662000;
	bh=bcwjZ3TEl5QSPMWLEHU5bea8JB58aePgKg833OzucIk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=mch4HelTTiYI7Nuuqn5LWu4vY2Ug4BMa/reHsvlvJ+gqBqFSnJP06DOXidtY/B8jS
	 sf502NsLUhxLzhFs6D8Uj/IPRgEn1rKkJVu4K4S9suX2GmW8my6pQ7f5Nhu2lIqPdl
	 J3mlqqSrivmIDV7TgSM/EWNiLoJfJEX5iQQv9frU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727283AbgJNHxQ (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 14 Oct 2020 03:53:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:43872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727151AbgJNHxQ (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Wed, 14 Oct 2020 03:53:16 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4CD7B21582;
        Wed, 14 Oct 2020 07:53:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602661995;
        bh=bcwjZ3TEl5QSPMWLEHU5bea8JB58aePgKg833OzucIk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=A3+WWLl7HW03G++pKkyE4RfIuOQz9Qj88dO6rwuQFcI6Zp5iu45RR8Sk6xqdHsBEI
         sFhYPLtp/e/U3i6ADjJGFuxwUYYtlmpY9chHJDDyn3nAjSWX9IySKUVzhpeFfLkv1T
         6Zt6Y54Se66XquCMhZPF9XAndewNFjHaTiYXCe3g=
Date:   Wed, 14 Oct 2020 10:53:10 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>,
        Oliver Neukum <oneukum@suse.com>,
        Igor Mitsyanko <imitsyanko@quantenna.com>,
        Sergey Matyukevich <geomatsi@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Pravin B Shelar <pshelar@ovn.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        linux-rdma@vger.kernel.org,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        bridge@lists.linux-foundation.org
Subject: Re: [PATCH net-next v2 00/12] net: add and use function
 dev_fetch_sw_netstats for fetching pcpu_sw_netstats
Message-ID: <20201014075310.GG6305@unreal>
References: <d77b65de-1793-f808-66b5-aaa4e7c8a8f0@gmail.com>
 <20201013173951.25677bcc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20201014054250.GB6305@unreal>
 <3be8fd19-1c7e-0e05-6039-e5404b2682b9@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3be8fd19-1c7e-0e05-6039-e5404b2682b9@gmail.com>
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Wed, Oct 14, 2020 at 08:13:47AM +0200, Heiner Kallweit wrote:
> On 14.10.2020 07:42, Leon Romanovsky wrote:
> > On Tue, Oct 13, 2020 at 05:39:51PM -0700, Jakub Kicinski wrote:
> >> On Mon, 12 Oct 2020 10:00:11 +0200 Heiner Kallweit wrote:
> >>> In several places the same code is used to populate rtnl_link_stats64
> >>> fields with data from pcpu_sw_netstats. Therefore factor out this code
> >>> to a new function dev_fetch_sw_netstats().
> >>>
> >>> v2:
> >>> - constify argument netstats
> >>> - don't ignore netstats being NULL or an ERRPTR
> >>> - switch to EXPORT_SYMBOL_GPL
> >>
> >> Applied, thank you!
> >
> > Jakub,
> >
> > Is it possible to make sure that changelogs are not part of the commit
> > messages? We don't store previous revisions in the git repo, so it doesn't
> > give too much to anyone who is looking on git log later. The lore link
> > to the patch is more than enough.
> >
> I remember that once I did it the usual way (changelog below the ---) David
> requested the changelog to be part of the commit message. So obviously he
> sees some benefit in doing so.

Do you have a link? What is the benefit and how can we use it?

Usually such request comes to ensure that commit message is updated with
extra information (explanation) existed in changelog which is missing in
the patch.

Thanks

>
> > 44fa32f008ab ("net: add function dev_fetch_sw_netstats for fetching pcpu_sw_netstats")
> >
> > Thanks
> >
>
