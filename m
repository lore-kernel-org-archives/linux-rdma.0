Return-Path: <SRS0=KJVK=ED=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 580AEC4363A
	for <linux-rdma@archiver.kernel.org>; Wed, 28 Oct 2020 22:22:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0317E206D5
	for <linux-rdma@archiver.kernel.org>; Wed, 28 Oct 2020 22:22:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1603923748;
	bh=oP+H2tKIIIzfompxh2yT/7z0AAWJ6eqX+XY7fexlECA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=j/8VGKDAmMQ6f/ciW4W3suwoFm7MNgtE9BTUnfEN/ZpBhuQfHgT7n6YsGxqXhymF8
	 Rkhpt30I/cuHYjG9ixWKsqo3OJA0LrA3x5ecoDDSAjT+pxcRvT9MSx9Mb9dHgWMsJU
	 JW1vfIYjVAvCmXAMyswZVOuTFenQbr3owZJvMYXg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732662AbgJ1WWZ (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 28 Oct 2020 18:22:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:36828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732646AbgJ1WWY (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Wed, 28 Oct 2020 18:22:24 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0A7052223C;
        Wed, 28 Oct 2020 05:18:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603862321;
        bh=oP+H2tKIIIzfompxh2yT/7z0AAWJ6eqX+XY7fexlECA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Js7nTTeyGXRif/jF0msULfLVT0tETc3VPiXLM+mjL6mkb5s9HwCl/x4djAbGmAQWn
         KgZ2WU0ojFMTHhM6XUMGoeTjqT82ncfaroLHabF3/BBE25OAWx/Nz/m7TZPJnUWaPa
         OIsMsJgKC9Dxpux/AuqSxKldIKpjbtm1pPnY8EJA=
Date:   Wed, 28 Oct 2020 07:18:37 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Maor Gottlieb <maorg@nvidia.com>, linux-rdma@vger.kernel.org,
        "Nicholas A. Bellinger" <nab@risingtidesystems.com>,
        target-devel@vger.kernel.org
Subject: Re: [PATCH rdma-next v1] IB/srpt: Fix memory leak in srpt_add_one
Message-ID: <20201028051837.GE1763578@unreal>
References: <20201027055920.1760663-1-leon@kernel.org>
 <1bc9ef14-4d91-6b12-f396-222cb6775ce4@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1bc9ef14-4d91-6b12-f396-222cb6775ce4@acm.org>
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Tue, Oct 27, 2020 at 08:45:11PM -0700, Bart Van Assche wrote:
> On 10/26/20 10:59 PM, Leon Romanovsky wrote:
> > +/**
> > + * srpt_unregister_mad_agent - unregister MAD callback functions
> > + * @sdev: SRPT HCA pointer.
> > + *
> > + * Note: It is safe to call this function more than once for the same device.
> > + */
> > +static void srpt_unregister_mad_agent(struct srpt_device *sdev)
> > +{
> > +	__srpt_unregister_mad_agent(sdev, sdev->device->phys_port_cnt);
> > +}
>
> As far as I can see with this patch applied srpt_unregister_mad_agent()
> has no callers. So please add an argument to srpt_unregister_mad_agent()
> instead of introducing __srpt_unregister_mad_agent().

srpt_unregister_mad_agent() is called in srpt_remove_one(), but will
change to get extra parameter.

Thanks

>
> Thanks,
>
> Bart.
