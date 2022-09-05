Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B20B7ECAAD3
	for <linux-rdma@archiver.kernel.org>; Mon,  5 Sep 2022 17:19:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229456AbiIERTw (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 5 Sep 2022 13:19:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231463AbiIERTv (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Mon, 5 Sep 2022 13:19:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E83F91D309
        for <linux-rdma@vger.kernel.org>; Mon,  5 Sep 2022 10:19:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 851236137C
        for <linux-rdma@vger.kernel.org>; Mon,  5 Sep 2022 17:19:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62B0AC433D6;
        Mon,  5 Sep 2022 17:19:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662398388;
        bh=+ctvraZzAFo6p05hukY0B0JACk7Ku8ybNaQef/KfVVQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ldzd24OuzMg5IFkPa1qfrgZjhKMn23gGZggw8r+hEdyeit1o7y1MoFRVcwJwYRtj2
         ZybTwPol9iSeohegcUZ4CURgDo8BfmM1ai+yhtRM5BXIySMxyi7yg5K1rvinxMZr+6
         FJ5/uEL0qEOAJLHXo4kW0mq2cpqINt9r7NTz8EDwXJyjYd08sAXTNX+Dxp8iyMdiLf
         wD6oymCGfQ4DDOjk3ClxDMX3vWtSYWa/B+0nsr6jsA0hUGqitFEN+3dek8PHWns+ZL
         Zg8mXdjwSSPjZX0o9V3seylQ3KHVJ/M+XoPJ7DfsqhBQ4JXYYOB58/GNCUp7tCkW3k
         D2muZNAzBS0CA==
Date:   Mon, 5 Sep 2022 20:19:44 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     Bernard Metzler <BMT@zurich.ibm.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: Re: Re: [PATCH v3] RDMA/siw: Pass a pointer to virt_to_page()
Message-ID: <YxYvsO086ga2rP55@unreal>
References: <SA0PR15MB3919314166F86C36B564961E997F9@SA0PR15MB3919.namprd15.prod.outlook.com>
 <CACRpkdYRvncv=CL_Jrsy5enTvaOeMpwCG+ssq17J_=2xrg0mWQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdYRvncv=CL_Jrsy5enTvaOeMpwCG+ssq17J_=2xrg0mWQ@mail.gmail.com>
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Mon, Sep 05, 2022 at 02:07:34PM +0200, Linus Walleij wrote:
> On Mon, Sep 5, 2022 at 2:02 PM Bernard Metzler <BMT@zurich.ibm.com> wrote:
> 
> > Can we easily fix the two line wraps introduced by this
> > patch? Without sending an explicit patch on top --
> 
> Yeah Lean can just augment it when applying.

I already promoted that patch to non-rebasable for-next.

> 
> > I'd
> > suggest adding just two line breaks to it. I'd be happy
> > to see siw code continues to adhere to the 80 char's
> > per line style.
> 
> You will be fighting an uphill battle since checkpatch (which is
> what we use to check syntax) now accepts 100 chars/line.
> commit bdc48fa11e46f867ea4d75fa59ee87a7f48be144
> "checkpatch/coding-style: deprecate 80-column warning"
> 
> If there is infiniband consensus to stay with 80 chars per
> line, you should send a patch to checkpatch so that it
> warns for this for patches to drivers/rdma.

It is not infiniband specific, many other subsystems and reviewers
continue to use 80-char limit.

The change to checkpatch came after Linus said that authors should
use their best judgment while dealing with line lengths. Unfortunately,
it was vague enough to apply it to checkpatch.

We continue to use 80 char limit, because clang formatter continues
to wrap everything to 80 chars.

Thanks

> 
> Yours,
> Linus Walleij
