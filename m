Return-Path: <SRS0=nyJA=VT=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F4FDC7618F
	for <linux-rdma@archiver.kernel.org>; Mon, 22 Jul 2019 17:52:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 08C0821903
	for <linux-rdma@archiver.kernel.org>; Mon, 22 Jul 2019 17:52:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1563817963;
	bh=lowikvgBPYO/PqTGk2Dy7ShWmKDAgzY23Dii4ML7CuY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=W5RiZuwYxwXUmPBv1yOpBMmvNrg9yirz8qN30XBOcs0i9hoepMHiby+/xjP/+m339
	 sNWqx+xY3WcLrI992ot9d3PQ24t1Zs7cjcjTxO54Ww/Ngkicw2rXnx1mIK0NHmho8Q
	 i3ycLfY5/bMQ1rOp+wmty0eqAMD3opOBhNHiOXJM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730445AbfGVRwm (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 22 Jul 2019 13:52:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:49792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727021AbfGVRwm (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Mon, 22 Jul 2019 13:52:42 -0400
Received: from localhost (unknown [37.142.3.125])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 610572182B;
        Mon, 22 Jul 2019 17:52:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563817961;
        bh=lowikvgBPYO/PqTGk2Dy7ShWmKDAgzY23Dii4ML7CuY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SW8ySg7O83HvaIPP1AJI62mzEyFCiH6nJDnxmSBgIJYqLJMfTZV22Bmoh7xRiqPjF
         Xx0V+nQFly+DQ6INQJrStd/9zUtw4zd7riI0y5sMnZ1iTsWtbQYI0HbwSusnEUXjPw
         AMHCWXW0e8TV/PMcgWwVTQ6TyjnrgUp8Lx34nl+I=
Date:   Mon, 22 Jul 2019 20:52:36 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Gal Pressman <galpress@amazon.com>
Cc:     Jason Gunthorpe <jgg@ziepe.ca>, Mark Zhang <markz@mellanox.com>,
        Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org
Subject: Re: BUG: KASAN: null-ptr-deref in
 rdma_counter_get_hwstat_value+0x19d/0x260 in for-next branch
Message-ID: <20190722175236.GF5125@mtr-leonro.mtl.com>
References: <137e1a30-1c78-27f7-2466-070867b97256@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <137e1a30-1c78-27f7-2466-070867b97256@amazon.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Mon, Jul 22, 2019 at 06:10:01PM +0300, Gal Pressman wrote:
> Hi,
>
> I pulled the latest for-next branch (5.3-rc1) which includes the new stats stuff
> and applied a patch to enable EFA stats [1], and I'm getting the following trace
> [2]. The EFA patch isn't merged yet so it could cause some extra noise, but this
> did not happen before the core statistics patches were merged.
>
> From a quick look it seems that 'port_counter->hstats' is only initialized for
> ports 1..num_ports (i.e not initialized for port 0, device stats) in
> rdma_counter_init rdma_for_each_port loop.
>
> As a result, rdma_counter_get_hwstat_value hits a NULL pointer dereference when
> querying device statistics as it tries to access an uninitialized hstats field in:
> sum += port_counter->hstats->value[index];
>
> I'm thinking of adding a check similar to the one that exists in
> counter_history_stat_update and return 0 in case of !port_counter->hstats.
> What do you guys think?

It is in my queue, I waited for -rc1 to start sending.

https://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git/commit/?h=rdma-next&id=32f6bc477e9432776d6938beeda1905198485f5e

Thanks
