Return-Path: <SRS0=RN5a=V6=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 383E1C433FF
	for <linux-rdma@archiver.kernel.org>; Fri,  2 Aug 2019 18:17:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0F7E320880
	for <linux-rdma@archiver.kernel.org>; Fri,  2 Aug 2019 18:17:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406627AbfHBSRl (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Fri, 2 Aug 2019 14:17:41 -0400
Received: from smtprelay0075.hostedemail.com ([216.40.44.75]:42912 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2406482AbfHBSRl (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Fri, 2 Aug 2019 14:17:41 -0400
X-Greylist: delayed 488 seconds by postgrey-1.27 at vger.kernel.org; Fri, 02 Aug 2019 14:17:40 EDT
Received: from smtprelay.hostedemail.com (10.5.19.251.rfc1918.com [10.5.19.251])
        by smtpgrave02.hostedemail.com (Postfix) with ESMTP id 5ADC71802505E
        for <linux-rdma@vger.kernel.org>; Fri,  2 Aug 2019 18:09:33 +0000 (UTC)
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay01.hostedemail.com (Postfix) with ESMTP id 7C446100E86C4;
        Fri,  2 Aug 2019 18:09:31 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: print78_35d552e2a8f3a
X-Filterd-Recvd-Size: 1809
Received: from XPS-9350.home (cpe-23-242-196-136.socal.res.rr.com [23.242.196.136])
        (Authenticated sender: joe@perches.com)
        by omf19.hostedemail.com (Postfix) with ESMTPA;
        Fri,  2 Aug 2019 18:09:29 +0000 (UTC)
Message-ID: <f2b2559865e8bd59202e14b837a522a801d498e2.camel@perches.com>
Subject: Re: [PATCH V2] mlx5: Fix formats with line continuation whitespace
From:   Joe Perches <joe@perches.com>
To:     Doug Ledford <dledford@redhat.com>,
        Leon Romanovsky <leon@kernel.org>
Cc:     Saeed Mahameed <saeedm@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Fri, 02 Aug 2019 11:09:28 -0700
In-Reply-To: <ac8361beee5dd80ad6546328dd7457bb6ee1ca5a.camel@redhat.com>
References: <f14db3287b23ed8af9bdbf8001e2e2fe7ae9e43a.camel@perches.com>
         <20181101073412.GQ3974@mtr-leonro.mtl.com>
         <ac8361beee5dd80ad6546328dd7457bb6ee1ca5a.camel@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.30.5-0ubuntu0.18.10.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Tue, 2018-11-06 at 16:34 -0500, Doug Ledford wrote:
> On Thu, 2018-11-01 at 09:34 +0200, Leon Romanovsky wrote:
> > On Thu, Nov 01, 2018 at 12:24:08AM -0700, Joe Perches wrote:
> > > The line continuations unintentionally add whitespace so
> > > instead use coalesced formats to remove the whitespace.
> > > 
> > > Signed-off-by: Joe Perches <joe@perches.com>
> > > ---
> > > 
> > > v2: Remove excess space after %u
> > > 
> > >  drivers/net/ethernet/mellanox/mlx5/core/rl.c | 6 ++----
> > >  1 file changed, 2 insertions(+), 4 deletions(-)
> > > 
> > 
> > Thanks,
> > Reviewed-by: Leon Romanovsky <leonro@mellanox.com>
> 
> Applied, thanks.

Still not upstream.  How long does it take?

