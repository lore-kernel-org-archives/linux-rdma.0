Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E70F7C433E0
	for <linux-rdma@archiver.kernel.org>; Sat, 27 Feb 2021 08:44:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AE76364E6C
	for <linux-rdma@archiver.kernel.org>; Sat, 27 Feb 2021 08:44:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229863AbhB0IoB (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Sat, 27 Feb 2021 03:44:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:46990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229835AbhB0IoB (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Sat, 27 Feb 2021 03:44:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3396964E6C;
        Sat, 27 Feb 2021 08:43:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614415399;
        bh=eL4kmD6ZecTnoKhjBIRjM7/WOzaxItlcITb74KKlquc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QZkxdxOhoRhfBMBz/7tiQUIDGF3nukPC3qVDC8CEJFNVMNyhuqTWOvZpqTmt4gkuV
         +X7h7EQtC4VEIBVTRM7izokUmMnjMRoeGWzUC/1x8vS16rhTf/i+gk4C12FLG51c3a
         UiRQgeIqPUodUvDCDwNUsFR1Bu/j0ev+cFJ+e2KcGlpbIDObAjP2vcIKLRX5Qo9Bir
         e+EtPUdms2GnoPILxXNLr9HOxXIogJ/tjxWOZbAxF3FjWDK0DnQl3wZ3f20KkQH2a6
         nH7cplQQNOwfWYwQWYeQw9328IhKzGqbuFoSmuJXDsIq5wjPxfSHcjQjw2chNsqBTm
         M7SpNsm8LYU0g==
Date:   Sat, 27 Feb 2021 10:43:16 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Bob Pearson <rpearsonhpe@gmail.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>, zyjzyj2000@gmail.com,
        linux-rdma@vger.kernel.org
Subject: Re: [PATCH for-next] RDMA/rxe: Fix ib_device reference counting
 (again)
Message-ID: <YDoGJIcB6SB/7LPj@unreal>
References: <20210214222630.3901-1-rpearson@hpe.com>
 <48dcbdc5-35a3-2fe3-3e3d-bff37c2d8053@gmail.com>
 <20210226233301.GA4247@nvidia.com>
 <3165add7-518d-9485-fa12-6d7822ed9165@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3165add7-518d-9485-fa12-6d7822ed9165@gmail.com>
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Fri, Feb 26, 2021 at 06:02:39PM -0600, Bob Pearson wrote:
> On 2/26/21 5:33 PM, Jason Gunthorpe wrote:
> > On Fri, Feb 26, 2021 at 05:28:41PM -0600, Bob Pearson wrote:
> >> Just a reminder. rxe in for-next is broken until this gets done.
> >> thanks
> >
> > I was expecting you to resend it? There seemed to be some changes
> > needed
> >
> > https://patchwork.kernel.org/project/linux-rdma/patch/20210214222630.3901-1-rpearson@hpe.com/
> >
> > Jason
> >
> OK. I see. I agreed to that complaint when the kfree was the only thing in the if {} but now I have to call ib_device_put() *only* in the error case not if there wasn't an error. So no reason to not put the kfree_skb() in there too and avoid passing a NULL pointer. It should stay the way it is.

First, I posted a diff which makes this if() redundant.
Second, the if () before kfree() is checked by coccinelle and your
"should stay the way it is" will be marked as failure in many CIs,
including ours.

Thanks

>
> bob
