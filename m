Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 057D83624A8
	for <linux-rdma@vger.kernel.org>; Tue, 28 Jul 2026 03:43:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785210187; cv=none; b=PcvEaeFmmcotXpNFMBs+yxxBZB4o8chYQhUr+AUrb0c9wuTYp0vKnnNXsAbaKH3YJD2FDJiljNND25pUO82dP516rKI4aGs6vzvqWpIi3XOhfArs4d3ljI75HSAZoXYxng0mXHIJKJHqDOS1hpuvNXFyY9qengMm5Mys7KF0GA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785210187; c=relaxed/simple;
	bh=fyqvdyUtzbGrcFUiUwdNcNec15TSzu0Bhf7s5ubnQSo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mL35CsMktcLqfS0Z3oKd9YIU5cpteBCVCJQuq97L6rhFvYM3eNCDmChbdAG0GMTyeK9IH0m9mW14D6W3VMQq9f1R6N7/s3x1hdkLMtsvEt2TBF+yCznzXDEqiZRuhC7wPA3QxfiSYWRntHxsTmofk3KEsrvxeNX1rDZgCAJQFQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Ryzi+WFq; arc=none smtp.client-ip=91.218.175.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Ryzi+WFq"
Message-ID: <95b8e484-c0d1-4973-b752-c93fb4cae1f4@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785210171;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WFpxFaOxkYFI9NE7mVhHV4GeGovOkSIrDEM/enz8GA8=;
	b=Ryzi+WFq/tU6M1CX1qsxGTvA5QEDJTuuxniezA+1K+EnnbwXRx8o7jznolP0YJUz++/nM/
	GKVP/BGmDz//Amcx9T6X5DpaLapAt01L4elmzvOtnKNW1589fuClYHZchhGG5Bf/xM2vxf
	hHGQ7oWRl2C37lrme9Y9r147BedBMS8=
Date: Mon, 27 Jul 2026 20:42:07 -0700
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [RFC PATCH 1/2] RDMA/rxe: drive UDP tunnel socket lifetime from
 the GID table
To: Serhat Kumral <serhatkumral1@gmail.com>,
 "yanjun.zhu@linux.dev" <yanjun.zhu@linux.dev>
Cc: zyjzyj2000@gmail.com, xiongwm2026@163.com, jgg@ziepe.ca, leon@kernel.org,
 dsahern@kernel.org, linux-rdma@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 syzbot+8c9eede336e3a843750e@syzkaller.appspotmail.com
References: <20260726140253.26870-1-serhatkumral1@gmail.com>
 <20260727195521.34907-1-serhatkumral1@gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Zhu Yanjun <yanjun.zhu@linux.dev>
In-Reply-To: <20260727195521.34907-1-serhatkumral1@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

在 2026/7/27 12:55, Serhat Kumral 写道:
> I was pointed at Weimin Xiong's "RDMA/rxe: Hold netdev reference for
> transmit skbs" (v3, 20260716055255.157674-1-xiongwm2026@163.com) and
> tested with it applied.
> 
> That patch and this series conflict in rxe_notify(). Its hunk carries
> "rxe_net_del(&rxe->ib_dev);" as a context line, and this series removes
> that call together with the function, so neither order applies with a
> plain git apply. I resolved it by keeping both rxe_flush_qps() calls and
> dropping the rxe_net_del() line:
> 
> 	case NETDEV_GOING_DOWN:
> 		/* Start draining TX queues before the netdev disappears. */
> 		rxe_flush_qps(rxe);
> 		break;
> 	case NETDEV_UNREGISTER:
> 		rxe_flush_qps(rxe);
> 		ib_unregister_device_queued(&rxe->ib_dev);
> 		break;
> 
> If the tree where the crash appears resolves it differently, that
> difference is worth seeing.

[root@fedora linux]# git log --oneline f2ec6312bf..HEAD
c7b5816e800a (HEAD -> master) Merge branch 'master' of 
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux
668b9a3b586c RDMA/rxe: Hold netdev reference for transmit skbs

This is the command line
"
[    0.000000] Command line: 
BOOT_IMAGE=(hd0,gpt2)/vmlinuz-7.2.0-rc3-rxe-l2+ 
root=UUID=511002c6-ecb8-4356-bd0b-7c54cc92384f ro rootflags=subvol=root 
rhgb quiet crashkernel=2G
"

Zhu Yanjun

> 
> Four kernels on f2ec6312bf71, same config and toolchain as before, 120
> runs of rxe_rping_between_netns.sh each:
> 
>    f2ec6312bf71                            120/120
>    + this series                           120/120
>    + the netdev reference patch            120/120
>    + the netdev reference patch + series   120/120
> 
> No KASAN report, GPF, Oops, refcount warning, lockdep splat, hung task or
> RCU stall in any of them. The module symbol tables confirm each kernel
> carries what it should: rxe_flush_qps only in the two with the netdev
> reference patch, rxe_add_gid and rxe_del_gid only in the two with this
> series.
> 
> Four kernels reporting nothing made me doubt the setup rather than the
> result, so I checked that it reports faults at all: a deliberate NULL
> pointer dereference injected into the rxe transmit path, during the same
> selftest, gives
> 
>    [   69.131350] Oops: general protection fault, kernel NULL pointer
>      dereference 0x39: 0000 [#1] SMP KASAN NOPTI
>    [   69.141660] Workqueue: rxe_wq do_work [rdma_rxe]
> 
> It reaches the console I capture, my filters count it, and the iteration
> is recorded as failed. From userspace the selftest just hangs.
> 
> So it still does not reproduce here.
> 
> thanks,
> serhat

