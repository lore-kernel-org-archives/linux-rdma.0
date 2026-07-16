Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E15043F7898
	for <linux-rdma@vger.kernel.org>; Thu, 16 Jul 2026 09:03:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784192645; cv=none; b=E34Rj5g/PuMIjvt05gsatuzPtac1WlVFmfWyb/G5c13w7j/VdbCixDmAcxNMClKplRMfKLcP7wra4A7f0dDVvVwuy0bN6p00oCKStaWXE5A+1WqQgog3sUH8K8K/jh6sVZfcriTvHu5p4nO+dLyNU5F5r6CN7s5zMbfPYJr3zu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784192645; c=relaxed/simple;
	bh=mePOACTNJbHmjr20jrDxPJ6i5qDMXY7jQB43hJWaqsw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Qmj8FZxka/LclWzvAuF/fFsmhY3e8OM+ReAlXpkXmrhs8FNhRMdzf+vMkjTeHN7xpcsXtYyQQ4XdzkBmRHaDjaRgnWHGzpdf9dzcKfydnWAbLgW60xz4ghuocf0dKmUPuZUXu7MvEYzO14bqEAaaLs4EXZm6HXn9UaoHlksXQtQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=qb1m1X3s; arc=none smtp.client-ip=91.218.175.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="qb1m1X3s"
Message-ID: <c2c5dda9-3228-44a3-a4c9-89e8cc4501bc@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784192635;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JVeydxlq98P61v43DHGkYvt2cLW0HCqExvqi1fRdk9o=;
	b=qb1m1X3s4pSW0gBrM1CbDf5MXLbXJSwvcpYHa2u6B5utr9ncP9NqkL9xHiIbuVLqvYBkP4
	vXWTjd/6xuhGH7BtOH/0iuvdBZ/qrADVHb/rU5TRPnTQf8A84qSVMxopGhqgB6A+NEplIM
	B8xskyhiHRZkc6dRl+Aws6foK0FSOpQ=
Date: Thu, 16 Jul 2026 17:03:37 +0800
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH rdma-next v3] RDMA/mlx5: quiesce CQ polling before device
 shutdown on reboot
To: Leon Romanovsky <leon@kernel.org>
Cc: jgg@ziepe.ca, andrew+netdev@lunn.ch, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
 linux-rdma@vger.kernel.org, netdev@vger.kernel.org, tariqt@nvidia.com,
 mbloch@nvidia.com, dtatulea@nvidia.com, shayd@nvidia.com, moshe@nvidia.com,
 Chenguang Zhao <zhaochenguang@kylinos.cn>
References: <20260715082307.1593915-1-chenguang.zhao@linux.dev>
 <20260716084211.GC70906@unreal>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Chenguang Zhao <chenguang.zhao@linux.dev>
In-Reply-To: <20260716084211.GC70906@unreal>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Hi, Leon
reboot -f skips orderly shutdown and goes directly to:

kernel_restart_prepare() -> device_shutdown() -> mlx5 shutdown
Upper layers may still hold live CQs, while ib-comp-wq keeps
polling — a use-after-free race.

Normal reboot usually works because userspace has already
torn down RDMA and called ib_free_cq().

Thanks

在 2026/7/16 16:42, Leon Romanovsky 写道:
> On Wed, Jul 15, 2026 at 04:23:07PM +0800, Chenguang Zhao wrote:
>> From: Chenguang Zhao <zhaochenguang@kylinos.cn>
>>
>> On reboot -f with NFS over RDMA, mlx5 shutdown can tear the device
>> down while ib-comp-wq still polls live CQs, leading to UAF in
>> wr_cqe->done().
>>
>> Mark the device shutting down before teardown, flush completion
>> workqueues so in-flight pollers observe the flag, skip SYS_ERROR
>> completion delivery, and make poll/arm CQ a no-op under the CQ lock
>> while shutting down.
>>
>> Signed-off-by: Chenguang Zhao <zhaochenguang@kylinos.cn>
>> ---
>> changelog:
>>  - Fix the race on MLX5_INTERFACE_STATE_SHUTTING_DOWN: set the
>>    flag, then flush ib-comp / mlx5_ib event workqueues via an
>>    mlx5_ib quiesce hook before fast_unload/teardown.
>>  - Check shutting-down under cq->lock in mlx5_ib_poll_cq/arm_cq.
>>  - Export ib_comp_wq and ib_comp_unbound_wq so modular mlx5_ib
>>    can flush them.
>>
>> v2:
>>  https://lore.kernel.org/all/20260714075558.1420384-1-chenguang.zhao@linux.dev/
>>
>> v1:
>>  https://lore.kernel.org/all/20260702073422.279820-1-chenguang.zhao@linux.dev/
>>
>>  drivers/infiniband/core/device.c              |  2 ++
>>  drivers/infiniband/hw/mlx5/cq.c               | 11 ++++++++++
>>  drivers/infiniband/hw/mlx5/main.c             | 20 +++++++++++++++++++
>>  .../net/ethernet/mellanox/mlx5/core/health.c  |  3 +++
>>  .../net/ethernet/mellanox/mlx5/core/main.c    | 10 ++++++++++
>>  .../mellanox/mlx5/core/sf/dev/driver.c        |  3 +++
>>  include/linux/mlx5/driver.h                   | 11 ++++++++++
>>  7 files changed, 60 insertions(+)
> <...>
>
>> +static void mlx5_ib_shutdown_quiesce(void)
>> +{
>> +	flush_workqueue(ib_comp_wq);
>> +	flush_workqueue(ib_comp_unbound_wq);
>> +	flush_workqueue(mlx5_ib_event_wq);
>> +}
> These workqueues are shared by all IB drivers and the core. Drivers
> must not flush or destroy them.
>
> Why this is not FW issue?
>
> Thanks
