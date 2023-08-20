Return-Path: <linux-rdma-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03346EE49AA
	for <linux-rdma@archiver.kernel.org>; Sun, 20 Aug 2023 09:36:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230205AbjHTJgw (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Sun, 20 Aug 2023 05:36:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230187AbjHTJgw (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Sun, 20 Aug 2023 05:36:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 946DC135
        for <linux-rdma@vger.kernel.org>; Sun, 20 Aug 2023 02:32:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 29C5B60ED0
        for <linux-rdma@vger.kernel.org>; Sun, 20 Aug 2023 09:32:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03928C433C7;
        Sun, 20 Aug 2023 09:32:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1692523947;
        bh=Gzr0S1lSWJjV2e9l4OOoPcqUREH58nLIEROpldRGbKY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kIcfQW7sdvRF6/jACXbrBhs7HHWwusUXeTZMcZWsmWWVoZvUhMo8kbJDVmQSICWVA
         M0O7LHtIN4lTPiOwwWjgZXhKq8YPOIhyIsiyUpKCZ1CMYgovlAIZjx8/Mpv/lX5o2C
         F/UoW+49ELfosvD2jpon8i7gf8Q2h/VSVY6217bAtFWHHjcEHBgRjTz0d2n9bz1jjW
         SdszXeNlUWGZzVxJxAeWJd7KEhinLIFMCTZAJ4CrEtA68H2FS3ykonfsRphXpNIV4d
         l9seemmnjb6Jfw+hhvzv2ECS6wAOo/Jl0BJLg0hV3PCOi1Dp6ZECnSgGgeSvJUFql+
         ccS8U3DX8qnuw==
Date:   Sun, 20 Aug 2023 12:32:23 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Selvin Xavier <selvin.xavier@broadcom.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>, linux-rdma@vger.kernel.org,
        andrew.gospodarek@broadcom.com,
        Kashyap Desai <kashyap.desai@broadcom.com>
Subject: Re: [PATCH for-next 2/2] RDMA/bnxt_re: Protect the PD table bitmap
Message-ID: <20230820093223.GB1562474@unreal>
References: <1692032419-21680-1-git-send-email-selvin.xavier@broadcom.com>
 <1692032419-21680-2-git-send-email-selvin.xavier@broadcom.com>
 <ZN+aZiK+BJY98vmb@nvidia.com>
 <CA+sbYW29xcfBWxkXDS7BhMUCXOFo2KznVnRRPwd0=+E3KFpoYA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+sbYW29xcfBWxkXDS7BhMUCXOFo2KznVnRRPwd0=+E3KFpoYA@mail.gmail.com>
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Sun, Aug 20, 2023 at 01:34:17AM +0530, Selvin Xavier wrote:
> On Fri, Aug 18, 2023 at 9:50 PM Jason Gunthorpe <jgg@nvidia.com> wrote:
> >
> > On Mon, Aug 14, 2023 at 10:00:19AM -0700, Selvin Xavier wrote:
> > > Syncrhonization is required to avoid simultaneous allocation
> > > of the PD. Add a new mutex lock to handle allocation from
> > > the PD table.
> > >
> > > Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
> > > Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
> > > ---
> > >  drivers/infiniband/hw/bnxt_re/ib_verbs.c  |  2 +-
> > >  drivers/infiniband/hw/bnxt_re/qplib_res.c | 26 ++++++++++++++++++++------
> > >  drivers/infiniband/hw/bnxt_re/qplib_res.h |  4 +++-
> > >  3 files changed, 24 insertions(+), 8 deletions(-)
> >
> > This needs a fixes line, it seems like a serious bug??
> Yes. It is a critical fix. Will add fixes line and post a v2.

We already applied v1 and tagged for-next with it. Unless Jason wants to
rebase that branch, it is too late for v2.

Thanks
