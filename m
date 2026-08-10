Received: from out-186.mta1.migadu.com (mta1.migadu.com [37.59.57.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48E20430CFD
	for <linux-rdma@vger.kernel.org>; Mon, 10 Aug 2026 23:59:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=37.59.57.117
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786406382; cv=none; b=VzbvceVuoiY2U2XUxGPVleAqUlG3VFhGOVH/9V9ZAhVxzQAQNMoKXHmAU1DiZSgJHTfgr7YreEMIfO5mRIWbjOa7ol3ZmuUOyyvGVuPGKQ+mSvQ+5H0BvgmXJwf7HrIrsXmjZBj06+bSUh4XYNQgAJdQeJVpaDT9b5JHTO9JU5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786406382; c=relaxed/simple;
	bh=7IZn59rBNGwbt77OqSdIuLVnL/FtY7VX9mpxFRQoOjY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XHK0dbub8ZbiIhrvZJVZd4KwT/PCFZqJDupLr2Gh2yfj5LTjYx+peMGM+BuhELRJjtXxl1nXyxWAo0vgtNmJjRQQUziMhUXO3LVNmed0Ze6dCrEoeAHkSwP84Z/iG2/jwX8G8Br/YX44bauxbcXPHPh6TsxBVIflLL8sogeOcfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=aOX938ll; arc=none smtp.client-ip=37.59.57.117
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="aOX938ll"
Message-ID: <97968741-23d0-47cd-9d5b-0eeefd43dd0d@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1786406376;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GW9wDeFh37CH1KHPFpZI4MD8T0uHITur9PWLzK9xbTY=;
	b=aOX938llyWTMgx2cTa1H4Pf+/UaOT3cmNV8tJgpJwGKZ1qdsjigGVmFDmEJ97nH69qoO6i
	cW9w5T7JrwfCb87NxQ4f1keALidja0tyWOxzk1wUcoJFtXf9cXIiz1iJ1Pb2kr41fm0YRY
	weXNdHCt2q/J4rGFnJxjWWGjtc63k84=
Date: Mon, 10 Aug 2026 16:59:26 -0700
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v2 1/1] RDMA/cma: Fix WARNING in res_to_rt
To: jgg@ziepe.ca, leon@kernel.org, linux-rdma@vger.kernel.org
Cc: syzbot+72eddfbadda3e3928e72@syzkaller.appspotmail.com
References: <20260810220123.191696-1-yanjun.zhu@linux.dev>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Zhu Yanjun <yanjun.zhu@linux.dev>
In-Reply-To: <20260810220123.191696-1-yanjun.zhu@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

在 2026/8/10 15:01, Zhu Yanjun 写道:
> syzbot reported a WARN_ON(!res->dev) in res_to_rt() triggered via
> addr_handler() during asynchronous address resolution:
> 
> "
> WARNING: drivers/infiniband/core/restrack.c:138 at res_to_rt+0x1c4/0x230
> CPU#1: kworker/u8:4/59
> Modules linked in:
> CPU: 1 UID: 0 PID: 59 Comm: kworker/u8:4 Not tainted syzkaller #0 PREEMPT(full)
> Hardware name: Google Compute Engine, BIOS Google 07/24/2026
> Workqueue: ib_addr process_one_req
> RIP: 0010:res_to_rt+0x1c4/0x230 drivers/infiniband/core/restrack.c:138
> RSP: 0018:ffffc9000201f850 EFLAGS: 00010293
> RAX: ffffffff88d00ce5 RBX: ffff88807f0fd4f8 RCX: ffff88801e6e0000
> RDX: 0000000000000000 RSI: ffffffff8fd996f0 RDI: 0000000000000003
> RBP: 0000000000000000 R08: ffff88801e6e0000 R09: 000000000000000a
> R10: 0000000000000009 R11: 0000000000000000 R12: dffffc0000000000
> R13: 1ffff1100fe1fa9f R14: 0000000000000000 R15: 0000000000000003
> FS:  0000000000000000(0000) GS:ffff888125012000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00001d559c3d2000 CR3: 0000000077c4c000 CR4: 00000000003526f0
> Call Trace:
>   <TASK>
>   rdma_restrack_add+0x5a/0x8a0 drivers/infiniband/core/restrack.c:236
>   addr_handler+0x41a/0x5a0 drivers/infiniband/core/cma.c:3534
>   process_one_req+0x2eb/0x540 drivers/infiniband/core/addr.c:624
>   process_one_work kernel/workqueue.c:3375 [inline]
>   process_scheduled_works+0xc4e/0x1630 kernel/workqueue.c:3458
>   worker_thread+0xa47/0xfb0 kernel/workqueue.c:3539
>   kthread+0x388/0x470 kernel/kthread.c:436
>   ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
>   ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
>   </TASK>
> "
> 
> In addr_handler(), cma_acquire_dev_by_src_ip() is called to populate
> id_priv->cma_dev and bind the associated ib_device to id_priv->id.device.
> If cma_acquire_dev_by_src_ip() returns an error (non-zero status), the ID
> remains unassociated with any RDMA device.
> 
> Previously, rdma_restrack_add(&id_priv->res) was invoked unconditionally
> even when cma_acquire_dev_by_src_ip() failed, passing a resource with a
> NULL dev pointer and triggering the WARN_ON assertion in res_to_rt().
> 
> Fix this by only adding the resource to restrack when acquiring the device
> succeeds.
> 
> Reported-by: syzbot+72eddfbadda3e3928e72@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=72eddfbadda3e3928e72
> Tested-by: syzbot+72eddfbadda3e3928e72@syzkaller.appspotmail.com
> Fixes: cb5cd0ea4eb3 ("RDMA/core: Add CM to restrack after successful attachment to a device")
> 
> Signed-off-by: Zhu Yanjun <yanjun.zhu@linux.dev>
> ---
> V1 -> V2: Follow Jason's advice to use if/else to handle this problem.

Thanks, Jason.
I have sent this commit to syzbot. From the reply, this commit can also 
fix the problem in the commit log.

Zhu Yanjun

> ---
>   drivers/infiniband/core/cma.c | 6 ++++--
>   1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
> index cc24fddf9aaa..73170b15fc3d 100644
> --- a/drivers/infiniband/core/cma.c
> +++ b/drivers/infiniband/core/cma.c
> @@ -3528,10 +3528,12 @@ static void addr_handler(int status, struct sockaddr *src_addr,
>   	memcpy(addr, src_addr, rdma_addr_size(src_addr));
>   	if (!status && !id_priv->cma_dev) {
>   		status = cma_acquire_dev_by_src_ip(id_priv);
> -		if (status)
> +		if (status) {
>   			pr_debug_ratelimited("RDMA CM: ADDR_ERROR: failed to acquire device. status %d\n",
>   					     status);
> -		rdma_restrack_add(&id_priv->res);
> +		} else {
> +			rdma_restrack_add(&id_priv->res);
> +		}
>   	} else if (status) {
>   		pr_debug_ratelimited("RDMA CM: ADDR_ERROR: failed to resolve IP. status %d\n", status);
>   	}

