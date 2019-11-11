Return-Path: <SRS0=ofNZ=ZD=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14F89C17446
	for <linux-rdma@archiver.kernel.org>; Mon, 11 Nov 2019 15:06:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D40A32184C
	for <linux-rdma@archiver.kernel.org>; Mon, 11 Nov 2019 15:06:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1573484779;
	bh=RnU7EhNtsKfI5SyL/eXczq/SFi0l5xumSz4ogi4SWJ0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=SuhC+OlKtz/vQjAkJmqIImldCGZZM2kzGJfdHgMKGg1BxKKUMIU4kC9www/lcpfVL
	 cKZIbGJmJHl+IVg4KGj8W4gIjpc+myAtALt08rAtKKHc7lVKprDS8cRbB3E8rVb0GU
	 5ZjUIBw63XD09/LZgM/K4TsNzckqDYFqp9tMXI4I=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726913AbfKKPGS (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 11 Nov 2019 10:06:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:53484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726857AbfKKPGS (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Mon, 11 Nov 2019 10:06:18 -0500
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 84A042084F;
        Mon, 11 Nov 2019 15:06:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573484778;
        bh=RnU7EhNtsKfI5SyL/eXczq/SFi0l5xumSz4ogi4SWJ0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=0MF3ViTIYnB7zOp41dx8J5jhuTZPdc9doVwjXxiyTAJKlA9fsUEGdC2RzIphtQfZj
         IovZ7ZYmNwDHSY7gnDyVSjKt5ObEViTIYnxcC5zo/TyROb35yt/PTvjD0iGLyTivXt
         fq+GAoZ7uP9KFDARf83mEDZoVlmflp9YhRZC+cpg=
Date:   Mon, 11 Nov 2019 17:06:15 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     "Marciniszyn, Mike" <mike.marciniszyn@intel.com>
Cc:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Ralph Campbell <ralph.campbell@qlogic.com>
Subject: Re: [PATCH rdma-next 16/16] RDMA: Change MAD processing function to
 remove extra casting and parameter
Message-ID: <20191111150615.GV6763@unreal>
References: <20191029062745.7932-1-leon@kernel.org>
 <20191029062745.7932-17-leon@kernel.org>
 <32E1700B9017364D9B60AED9960492BC74671E3A@ORSMSX160.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <32E1700B9017364D9B60AED9960492BC74671E3A@ORSMSX160.amr.corp.intel.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Mon, Nov 11, 2019 at 01:33:57PM +0000, Marciniszyn, Mike wrote:
> > Subject: [PATCH rdma-next 16/16] RDMA: Change MAD processing function
> > to remove extra casting and parameter
> >
> > From: Leon Romanovsky <leonro@mellanox.com>
> >
> > All users of process_mad() converts input pointers from ib_mad_hdr
> > to be ib_mad, update the function declaration to use ib_mad directly.
> >
> > Also remove not used input MAD size parameter.
> >
> > Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
> > ---
>
> One workqueue failure we have been fighting  for a while, so the mad stuff looks fine.
>
> Tested-By: Mike Marciniszyn <mike.marciniszyn@intel.com>

Thanks a lot.
