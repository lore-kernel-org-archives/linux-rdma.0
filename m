Return-Path: <SRS0=zqf9=YA=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDC4FC47404
	for <linux-rdma@archiver.kernel.org>; Mon,  7 Oct 2019 15:54:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B7B1A2070B
	for <linux-rdma@archiver.kernel.org>; Mon,  7 Oct 2019 15:54:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1570463681;
	bh=A6Hck1SO3IpFeLsQFU+3wiLlAr7I+9JrSXX1SV7ibHw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=1ZVa5M0KzxVbg3DJpcEg0ymSZoYR3m1lq6JWbuDil1bYe+H2ypVJC84W94kcP91sH
	 z5kK2BeQwo1K0DeTsLhx4GDw5sxVPGtg33ZaMbUZ3IIhtqZaPkJ47mOgCq2W55a1bM
	 gmx0/1Rn8wGQgWs8foU9/7v8EceRFmerOfYC+7yE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727912AbfJGPyl (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 7 Oct 2019 11:54:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:54022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727801AbfJGPyl (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Mon, 7 Oct 2019 11:54:41 -0400
Received: from localhost (unknown [77.137.89.37])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9183620679;
        Mon,  7 Oct 2019 15:54:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570463680;
        bh=A6Hck1SO3IpFeLsQFU+3wiLlAr7I+9JrSXX1SV7ibHw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YJzzUSCEdmGMe4UvckKgE4QMK2r8U3ebyLk6UQBmYTph11XzWKfbtsGEWHxjC9fPC
         VzOgMtnPIqITzdqa1AZz6PnPbLe1rCJ2sDIKgiNeNJUqP0LJP4SDuS/5t+rZzmnnQZ
         t33uW1/T+hP7FSKXQ//OtUZGdxladYzp37OE8OWk=
Date:   Mon, 7 Oct 2019 18:54:34 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Christoph Hellwig <hch@infradead.org>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Yamin Friedman <yaminf@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH mlx5-next v2 1/3] net/mlx5: Expose optimal performance
 scatter entries capability
Message-ID: <20191007155434.GY5855@unreal>
References: <20191007135933.12483-1-leon@kernel.org>
 <20191007135933.12483-2-leon@kernel.org>
 <cfae2979-1ba4-e20d-ed20-1cb8f26b78f6@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cfae2979-1ba4-e20d-ed20-1cb8f26b78f6@acm.org>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Mon, Oct 07, 2019 at 08:02:50AM -0700, Bart Van Assche wrote:
> On 10/7/19 6:59 AM, Leon Romanovsky wrote:
> > -	u8         reserved_at_c0[0x8];
> > +	u8         max_sgl_for_optimized_performance[0x8];
>
> Should the name of this member variable perhaps be changed into
> "max_sgl_for_optimal_performance"?

We don't want to force our internal HW/FW names on all uverbs users
and drivers. So, the answer is no, it is used for optimized performance,
but it is not the proper name for uverbs.

Thanks

>
> Thanks,
>
> Bart.
