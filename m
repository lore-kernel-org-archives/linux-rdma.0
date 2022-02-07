Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 613F9C433F5
	for <linux-rdma@archiver.kernel.org>; Mon,  7 Feb 2022 10:13:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233052AbiBGKNG (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 7 Feb 2022 05:13:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352102AbiBGKAD (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Mon, 7 Feb 2022 05:00:03 -0500
Received: from out30-44.freemail.mail.aliyun.com (out30-44.freemail.mail.aliyun.com [115.124.30.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9E71C043181;
        Mon,  7 Feb 2022 02:00:01 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R481e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=tonylu@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0V3okuPA_1644227998;
Received: from localhost(mailfrom:tonylu@linux.alibaba.com fp:SMTPD_---0V3okuPA_1644227998)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 07 Feb 2022 17:59:59 +0800
Date:   Mon, 7 Feb 2022 17:59:58 +0800
From:   Tony Lu <tonylu@linux.alibaba.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     kgraul@linux.ibm.com, kuba@kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        RDMA mailing list <linux-rdma@vger.kernel.org>
Subject: Re: [PATCH net-next] net/smc: Allocate pages of SMC-R on ibdev NUMA
 node
Message-ID: <YgDtnk8g7y5oRKXB@TonyMac-Alibaba>
Reply-To: Tony Lu <tonylu@linux.alibaba.com>
References: <20220130190259.94593-1-tonylu@linux.alibaba.com>
 <YfeN1BfPqhVz8mvy@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YfeN1BfPqhVz8mvy@unreal>
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Mon, Jan 31, 2022 at 09:20:52AM +0200, Leon Romanovsky wrote:
> On Mon, Jan 31, 2022 at 03:03:00AM +0800, Tony Lu wrote:
> > Currently, pages are allocated in the process context, for its NUMA node
> > isn't equal to ibdev's, which is not the best policy for performance.
> > 
> > Applications will generally perform best when the processes are
> > accessing memory on the same NUMA node. When numa_balancing enabled
> > (which is enabled by most of OS distributions), it moves tasks closer to
> > the memory of sndbuf or rmb and ibdev, meanwhile, the IRQs of ibdev bind
> > to the same node usually. This reduces the latency when accessing remote
> > memory.
> 
> It is very subjective per-specific test. I would expect that
> application will control NUMA memory policies (set_mempolicy(), ...)
> by itself without kernel setting NUMA node.
> 
> Various *_alloc_node() APIs are applicable for in-kernel allocations
> where user can't control memory policy.
> 
> I don't know SMC-R enough, but if I judge from your description, this
> allocation is controlled by the application.

The original design of SMC doesn't handle the memory allocation of
different NUMA node, and the application can't control the NUMA policy
in SMC.

It allocates memory according to the NUMA node based on the process
context, which is determined by the scheduler. If application process
runs on NUMA node 0, SMC allocates on node 0 and so on, it all depends
on the scheduler. If RDMA device is attached to node 1, the process runs
on node 0, it allocates memory on node 0.

This patch tries to allocate memory on the same NUMA node of RDMA
device. Applications can't know the current node of RDMA device. The
scheduler knows the node of memory, and can let applications run on the
same node of memory and RDMA device.

Thanks,
Tony Lu
