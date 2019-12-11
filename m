Return-Path: <SRS0=YjSL=2B=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D495C43603
	for <linux-rdma@archiver.kernel.org>; Wed, 11 Dec 2019 06:07:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1F287208C3
	for <linux-rdma@archiver.kernel.org>; Wed, 11 Dec 2019 06:07:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1576044459;
	bh=ltXmRoOtGxpgBjIm2UR3qK/Vo+/qTfNv38dHDjf+8W4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=1TVQeRnXuGSOmsRCk48O2MmEib0vlK5K8PBp2t+lnMtRrCaCOrITbOOSvqy1u/+qp
	 R3jvAz3M2c4SfcnOFsT+lgNKeFz4d6K2OLPNWIbCe8EyQ58G1r8VJuyciG+Sz5b7+J
	 mThidGSLJ9Df+inxc2Chs+ODD4ddHBsyOVPwwXdw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726082AbfLKGHg (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 11 Dec 2019 01:07:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:41454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725800AbfLKGHg (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Wed, 11 Dec 2019 01:07:36 -0500
Received: from localhost (unknown [5.29.147.182])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5163B208C3;
        Wed, 11 Dec 2019 06:07:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576044456;
        bh=ltXmRoOtGxpgBjIm2UR3qK/Vo+/qTfNv38dHDjf+8W4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=M9G6U7WXXcw6Z9UgjN8MZUYtndGqSPk3JHUJ+Jk7iF3uXRJbbUWsCk/9yUwIQrFUH
         tEevlbnXeo6XVqKtaXplJPiI1J7igfWu0ac9LSTIKmeuRr/dqb2T89C+EZCvcg2ba8
         cj69HEK0+I9Ko/mM1OBslDoONX4FrzOzpTrBYBXQ=
Date:   Wed, 11 Dec 2019 08:07:32 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>, davem@davemloft.net,
        gregkh@linuxfoundation.org,
        Mustafa Ismail <mustafa.ismail@intel.com>,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com, parav@mellanox.com,
        Shiraz Saleem <shiraz.saleem@intel.com>
Subject: Re: [PATCH v3 05/20] RDMA/irdma: Add driver framework definitions
Message-ID: <20191211060732.GR67461@unreal>
References: <20191209224935.1780117-1-jeffrey.t.kirsher@intel.com>
 <20191209224935.1780117-6-jeffrey.t.kirsher@intel.com>
 <20191210190438.GF46@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191210190438.GF46@ziepe.ca>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Tue, Dec 10, 2019 at 03:04:38PM -0400, Jason Gunthorpe wrote:
> On Mon, Dec 09, 2019 at 02:49:20PM -0800, Jeff Kirsher wrote:
> > +{
> > +	struct i40e_info *ldev = (struct i40e_info *)rf->ldev.if_ldev;
>
> Why are there so many casts in this file? Is this really container of?
>
> > +	hdl = kzalloc((sizeof(*hdl) + sizeof(*iwdev)), GFP_KERNEL);
> > +	if (!hdl)
> > +		return -ENOMEM;
> > +
> > +	iwdev = (struct irdma_device *)((u8 *)hdl + sizeof(*hdl));
>
> Yikes, use structs and container of for things like this please.
>
> > +	iwdev->param_wq = alloc_ordered_workqueue("l2params", WQ_MEM_RECLAIM);
> > +	if (!iwdev->param_wq)
> > +		goto error;
>
> Leon usually asks why another work queue at this point, at least have
> a comment justifying why. Shouldn't it have a better name?

Yeah, combination of WQ_MEM_RECLAIM flag and "params" in the name raises
eyebrows immediately.

Thanks
