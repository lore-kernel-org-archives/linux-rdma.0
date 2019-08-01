Return-Path: <SRS0=ZuZ5=V5=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB488C19759
	for <linux-rdma@archiver.kernel.org>; Thu,  1 Aug 2019 12:50:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 97FF6206B8
	for <linux-rdma@archiver.kernel.org>; Thu,  1 Aug 2019 12:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1564663820;
	bh=jluW11YF7q7nMxYlk/0HEUewiZjm4hm0JLfGERDbRFg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=hk7TAx1qnNxgYUlJTtrYEqeMhx5sGvuXsmFnt1joBqUoT9NgMCbpaKMlqqzY/EWV6
	 oZUxxbwtOFMH9kgT7DWIv1n+P0c70l0F43hI0HPjTEquY/benZqRFxA0eliHTr4tU/
	 RlXG/sJ8PExdQ0VTltZGLi+7oYNBXA+q2Oqg7r80=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731508AbfHAMuU (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 1 Aug 2019 08:50:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:41002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731506AbfHAMuT (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Thu, 1 Aug 2019 08:50:19 -0400
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6886F20665;
        Thu,  1 Aug 2019 12:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564663819;
        bh=jluW11YF7q7nMxYlk/0HEUewiZjm4hm0JLfGERDbRFg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=i6l1oQJnPMNIUmKzlZp9JRysgLXrNFux0gWGR3ebo7Ls6aMzlcbKnuUArv/TERDgl
         OQ56ixzps0LsAO0WbY547LT04ShwXvgysqp9gJCYP2FdWR7GiPq2DTPXpZ/gCQSf3q
         oIkGupgyxgAiBd4tDvK2id1nFmTR8+nw6BWjX/Xo=
Date:   Thu, 1 Aug 2019 15:50:15 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Gal Pressman <galpress@amazon.com>
Cc:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Michael Guralnik <michaelgur@mellanox.com>,
        Moni Shoua <monis@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH rdma-next 2/3] IB/mlx5: Expose ODP for DC capabilities to
 user
Message-ID: <20190801125015.GM4832@mtr-leonro.mtl.com>
References: <20190801122139.25224-1-leon@kernel.org>
 <20190801122139.25224-3-leon@kernel.org>
 <12331110-ecfd-fb2f-460a-be41be13b2d3@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <12331110-ecfd-fb2f-460a-be41be13b2d3@amazon.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Thu, Aug 01, 2019 at 03:34:24PM +0300, Gal Pressman wrote:
> On 01/08/2019 15:21, Leon Romanovsky wrote:
> >  enum mlx5_user_cmds_supp_uhw {
> > @@ -147,6 +148,7 @@ struct mlx5_ib_alloc_ucontext_resp {
> >  	__u32	num_uars_per_page;
> >  	__u32	num_dyn_bfregs;
> >  	__u32	dump_fill_mkey;
> > +	__u32	dc_odp_caps;
>
> This should be padded to 64 bits.

Thanks a lot, I fixed it locally.

>
> >  };
> >
> >  struct mlx5_ib_alloc_pd_resp {
> >
