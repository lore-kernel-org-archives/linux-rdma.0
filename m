Return-Path: <SRS0=3BW3=YQ=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07064CA9EAE
	for <linux-rdma@archiver.kernel.org>; Wed, 23 Oct 2019 05:48:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C7343214B2
	for <linux-rdma@archiver.kernel.org>; Wed, 23 Oct 2019 05:48:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1571809686;
	bh=V5EEbrWPtx+bFnAIK4lpwVA1Qr2oCaXBjrpcAWLPkpY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=mK61AIIMbIPV4CmZ+tvyq3jj0DyMjI30V5Hf72MPpKxfJVpCkQdiqZ9DXp8pPxwLl
	 I7OsaimgJ9BkswthOmiwPL8ThozuPfXVe95CjCQHxjebDjVaU+ZHSZLj5CY9BoPzc3
	 PpQi4Agp+l4tblMxsoHi0AstgzakTvlY41tPF6z4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732066AbfJWFsG (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 23 Oct 2019 01:48:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:43710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727850AbfJWFsG (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Wed, 23 Oct 2019 01:48:06 -0400
Received: from localhost (unknown [77.137.89.37])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EBE0321872;
        Wed, 23 Oct 2019 05:48:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571809685;
        bh=V5EEbrWPtx+bFnAIK4lpwVA1Qr2oCaXBjrpcAWLPkpY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=j5nrA/nE3XlsNQisjwFgZkuc2zINYHj4bzNkjKAnIzVgmWfzRopGqv4RLDazWNruV
         OrXhE9EIIhuz5E0Kl7+ezk0PA+OnrPidN/NIxYIhX+UvDr2bG1m783JvmPyaRxvFYp
         5AYBDQxZ2w8pAGV2CB2QmzWt87aYnVfoygFe/YaY=
Date:   Wed, 23 Oct 2019 08:48:02 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Doug Ledford <dledford@redhat.com>,
        Yuval Shaia <yuval.shaia@oracle.com>, bharat@chelsio.com,
        linux-rdma@vger.kernel.org
Subject: Re: [PATCH] iw_cxgb3: Remove the iw_cxgb3 provider code
Message-ID: <20191023054802.GI4853@unreal>
References: <20191022174710.12758-1-yuval.shaia@oracle.com>
 <ba91bb6c42e18e72cd6eaa705067a9cb30a02853.camel@redhat.com>
 <20191022175821.GB23952@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191022175821.GB23952@ziepe.ca>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Tue, Oct 22, 2019 at 02:58:21PM -0300, Jason Gunthorpe wrote:
> On Tue, Oct 22, 2019 at 01:57:18PM -0400, Doug Ledford wrote:
> > On Tue, 2019-10-22 at 20:47 +0300, Yuval Shaia wrote:
> > > diff --git a/kernel-headers/rdma/rdma_user_ioctl_cmds.h b/kernel-
> > > headers/rdma/rdma_user_ioctl_cmds.h
> > > index b8bb285f..b2680051 100644
> > > +++ b/kernel-headers/rdma/rdma_user_ioctl_cmds.h
> > > @@ -88,7 +88,6 @@ enum rdma_driver_id {
> > >         RDMA_DRIVER_UNKNOWN,
> > >         RDMA_DRIVER_MLX5,
> > >         RDMA_DRIVER_MLX4,
> > > -       RDMA_DRIVER_CXGB3,
> > >         RDMA_DRIVER_CXGB4,
> > >         RDMA_DRIVER_MTHCA,
> > >         RDMA_DRIVER_BNXT_RE,
> >
> > This is the same bug the kernel patch had.  We can't change that enum.
>
> This patch shouldn't touch the kernel headers, delete the driver, then
> we will get the kernel header changes on the next resync.

If you are doing that, can you please delete nes provider too?
Maybe ipathverbs too?

Thanks

>
> Jason
>
