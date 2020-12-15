Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19925C19425
	for <linux-rdma@archiver.kernel.org>; Tue, 15 Dec 2020 05:39:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C8DAB22509
	for <linux-rdma@archiver.kernel.org>; Tue, 15 Dec 2020 05:39:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725958AbgLOFik (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 15 Dec 2020 00:38:40 -0500
Received: from smtprelay0245.hostedemail.com ([216.40.44.245]:35184 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725966AbgLOFib (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>);
        Tue, 15 Dec 2020 00:38:31 -0500
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay04.hostedemail.com (Postfix) with ESMTP id 85076180A8CBE;
        Tue, 15 Dec 2020 05:37:37 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: wire01_4f04bab27421
X-Filterd-Recvd-Size: 2020
Received: from XPS-9350.home (unknown [47.151.137.21])
        (Authenticated sender: joe@perches.com)
        by omf12.hostedemail.com (Postfix) with ESMTPA;
        Tue, 15 Dec 2020 05:37:36 +0000 (UTC)
Message-ID: <19198242da4d01804dc20cb41e870b05041bede2.camel@perches.com>
Subject: Re: [PATCH v2] net/mlx4: Use true,false for bool variable
From:   Joe Perches <joe@perches.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Vasyl Gomonovych <gomonovych@gmail.com>, tariqt@nvidia.com,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Mon, 14 Dec 2020 21:37:34 -0800
In-Reply-To: <20201215051838.GH5005@unreal>
References: <20201212090234.0362d64f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <20201214103008.14783-1-gomonovych@gmail.com>
         <20201214111608.GE5005@unreal>
         <20201214110351.29ae7abb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <1113d2d634d46adb9384e09c3f70cb8376a815c4.camel@perches.com>
         <20201215051838.GH5005@unreal>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.38.1-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Tue, 2020-12-15 at 07:18 +0200, Leon Romanovsky wrote:
> On Mon, Dec 14, 2020 at 11:15:01AM -0800, Joe Perches wrote:
> > I prefer revisions to single patches (as opposed to large patch series)
> > in the same thread.
> 
> It depends which side you are in that game. From the reviewer point of
> view, such submission breaks flow very badly. It unfolds the already
> reviewed thread, messes with the order and many more little annoying
> things.

This is where I disagree with you.  I am a reviewer here.

Not having context to be able to inspect vN -> vN+1 is made
more difficult not having the original patch available and
having to search history for it.

Almost no one adds URL links to older submissions below the ---.

Were that a standard mechanism below the --- line, then it would
be OK.

