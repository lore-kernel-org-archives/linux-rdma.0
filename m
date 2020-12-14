Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4C3FC2BB9A
	for <linux-rdma@archiver.kernel.org>; Mon, 14 Dec 2020 19:17:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8DE0022286
	for <linux-rdma@archiver.kernel.org>; Mon, 14 Dec 2020 19:17:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502260AbgLNTQB (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 14 Dec 2020 14:16:01 -0500
Received: from smtprelay0041.hostedemail.com ([216.40.44.41]:34594 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2502176AbgLNTPz (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>);
        Mon, 14 Dec 2020 14:15:55 -0500
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay07.hostedemail.com (Postfix) with ESMTP id B8D39181D303A;
        Mon, 14 Dec 2020 19:15:04 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: list62_47160c62741d
X-Filterd-Recvd-Size: 2570
Received: from XPS-9350.home (unknown [47.151.137.21])
        (Authenticated sender: joe@perches.com)
        by omf14.hostedemail.com (Postfix) with ESMTPA;
        Mon, 14 Dec 2020 19:15:03 +0000 (UTC)
Message-ID: <1113d2d634d46adb9384e09c3f70cb8376a815c4.camel@perches.com>
Subject: Re: [PATCH v2] net/mlx4: Use true,false for bool variable
From:   Joe Perches <joe@perches.com>
To:     Jakub Kicinski <kuba@kernel.org>, Leon Romanovsky <leon@kernel.org>
Cc:     Vasyl Gomonovych <gomonovych@gmail.com>, tariqt@nvidia.com,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Mon, 14 Dec 2020 11:15:01 -0800
In-Reply-To: <20201214110351.29ae7abb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20201212090234.0362d64f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <20201214103008.14783-1-gomonovych@gmail.com>
         <20201214111608.GE5005@unreal>
         <20201214110351.29ae7abb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.38.1-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Mon, 2020-12-14 at 11:03 -0800, Jakub Kicinski wrote:
> On Mon, 14 Dec 2020 13:16:08 +0200 Leon Romanovsky wrote:
> > On Mon, Dec 14, 2020 at 11:30:08AM +0100, Vasyl Gomonovych wrote:
> > > It is fix for semantic patch warning available in
> > > scripts/coccinelle/misc/boolinit.cocci
> > > Fix en_rx.c:687:1-17: WARNING: Assignment of 0/1 to bool variable
> > > Fix main.c:4465:5-13: WARNING: Comparison of 0/1 to bool variable
> > > 
> > > Signed-off-by: Vasyl Gomonovych <gomonovych@gmail.com>
> > > ---
> > >  - Add coccicheck script name
> > >  - Simplify if condition
> > > ---
> > >  drivers/net/ethernet/mellanox/mlx4/en_rx.c | 2 +-
> > >  drivers/net/ethernet/mellanox/mlx4/main.c  | 2 +-
> > >  2 files changed, 2 insertions(+), 2 deletions(-)  
> > 
> > Please refrain from sending new version of patches as reply-to to
> > previous variants. It makes to appear previous patches out-of-order
> > while viewing in threaded mode.
> 
> Yes, please! I'm glad I'm not the only one who feels this way! :)

I'm the other way.

I prefer revisions to single patches (as opposed to large patch series)
in the same thread.

There is no other easy way for changes to a patch to be tracked AFAIK.

Most email clients use both In-Reply-To: and References: headers as
the mechanism to thread replies.

Keeping the latest messages at the bottom of a thread works well
to see revision sequences.


