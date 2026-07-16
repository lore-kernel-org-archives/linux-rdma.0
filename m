Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B92872E7368;
	Thu, 16 Jul 2026 10:50:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784199016; cv=none; b=RrTeE+AjX1U9fZzIHCXnxcbhCH9Wb2wYe9Ug1lxR0taqZO8zq4osP9tcoSR0DCVN61BtxNp8BD0mtKJLvjz41antDiYbKg6JbLAfTptrx1JLeLF2RTN0tnHg1uE4FnQpW8VHZZLfk57HcwhpYK8HGbPKkYLTLrlU9wS9XvGSEVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784199016; c=relaxed/simple;
	bh=l/CAFPX+3wzfGA7GQQv7QLTlLECJJ2OZI0iTW/zeoSA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iyWI1MwG9zWii5ndJzj2rwalwQZjAwb6+/CHLb4fyrc3Cxabdu26rnOWXLVz3lr7ozfmleJyy5BYepuGLvaf/QGYtiOBODzZhtzXAwqJ3W1rASVh8t3Y0aS0r0Axzp7pL83kxIBU3EiRRgjqei18aG4W2EoQPGR0RjYk+2qBUu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cEM0Q00D; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cEM0Q00D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78A921F000E9;
	Thu, 16 Jul 2026 10:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784199015;
	bh=0xvySaEqarBgFceDdKkgAiCmMCUO1cbSbfqzLAmtXMs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=cEM0Q00Dl518+KV5XCLr2F+KOZAIWB40dgNb3iHaA+TE1QJ646oyPDK6CZvh3ssJX
	 IlijWAy68AU9ryANoHBmoXAOj7Nc9x2HQE5IM6fjCtLXVhzs9L9IqUVEmO/CuApQKI
	 SA5zU/kXHBFrgy/ocvpBOx4cdG3WGtXTS2xmVwCFD2Ex4FlWbAbVxhBBpHU4eJsAqn
	 mb+EBiQ6B99dsGWjRHEQ8bcZ360voOqxpKuDeCPcU3Kdkpsb/uuD7fcnhu4vNVswIk
	 1ikQN0onQ2IaONUvKkqzWizgJhtOWAWrcYrNUDcXOL+xcyopqScaA803MC4v8dZxeS
	 DuxGImKzMZlgQ==
Date: Thu, 16 Jul 2026 13:50:08 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Chenguang Zhao <chenguang.zhao@linux.dev>
Cc: jgg@ziepe.ca, andrew+netdev@lunn.ch, davem@davemloft.net,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
	linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
	tariqt@nvidia.com, mbloch@nvidia.com, dtatulea@nvidia.com,
	shayd@nvidia.com, moshe@nvidia.com,
	Chenguang Zhao <zhaochenguang@kylinos.cn>
Subject: Re: [PATCH rdma-next v3] RDMA/mlx5: quiesce CQ polling before device
 shutdown on reboot
Message-ID: <20260716105008.GD357857@unreal>
References: <20260715082307.1593915-1-chenguang.zhao@linux.dev>
 <20260716084211.GC70906@unreal>
 <c2c5dda9-3228-44a3-a4c9-89e8cc4501bc@linux.dev>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c2c5dda9-3228-44a3-a4c9-89e8cc4501bc@linux.dev>

On Thu, Jul 16, 2026 at 05:03:37PM +0800, Chenguang Zhao wrote:
> Hi, Leon
> reboot -f skips orderly shutdown and goes directly to:
> 
> kernel_restart_prepare() -> device_shutdown() -> mlx5 shutdown
> Upper layers may still hold live CQs, while ib-comp-wq keeps
> polling — a use-after-free race.

The point is that this flow is neither RDMA- nor mlx5-specific, and it
works as expected. mlx5 shutdown() stops the FW/HW, while the kernel
stops and tears down the running threads.

> 
> Normal reboot usually works because userspace has already
> torn down RDMA and called ib_free_cq().

There is no difference, from the kernel's perspective, between a
normal and a forced reboot, except that the former bypasses
userspace shutdown.

Thanks

> 
> Thanks
> 
> 在 2026/7/16 16:42, Leon Romanovsky 写道:
> > On Wed, Jul 15, 2026 at 04:23:07PM +0800, Chenguang Zhao wrote:
> >> From: Chenguang Zhao <zhaochenguang@kylinos.cn>
> >>
> >> On reboot -f with NFS over RDMA, mlx5 shutdown can tear the device
> >> down while ib-comp-wq still polls live CQs, leading to UAF in
> >> wr_cqe->done().
> >>
> >> Mark the device shutting down before teardown, flush completion
> >> workqueues so in-flight pollers observe the flag, skip SYS_ERROR
> >> completion delivery, and make poll/arm CQ a no-op under the CQ lock
> >> while shutting down.
> >>
> >> Signed-off-by: Chenguang Zhao <zhaochenguang@kylinos.cn>
> >> ---
> >> changelog:
> >>  - Fix the race on MLX5_INTERFACE_STATE_SHUTTING_DOWN: set the
> >>    flag, then flush ib-comp / mlx5_ib event workqueues via an
> >>    mlx5_ib quiesce hook before fast_unload/teardown.
> >>  - Check shutting-down under cq->lock in mlx5_ib_poll_cq/arm_cq.
> >>  - Export ib_comp_wq and ib_comp_unbound_wq so modular mlx5_ib
> >>    can flush them.
> >>
> >> v2:
> >>  https://lore.kernel.org/all/20260714075558.1420384-1-chenguang.zhao@linux.dev/
> >>
> >> v1:
> >>  https://lore.kernel.org/all/20260702073422.279820-1-chenguang.zhao@linux.dev/
> >>
> >>  drivers/infiniband/core/device.c              |  2 ++
> >>  drivers/infiniband/hw/mlx5/cq.c               | 11 ++++++++++
> >>  drivers/infiniband/hw/mlx5/main.c             | 20 +++++++++++++++++++
> >>  .../net/ethernet/mellanox/mlx5/core/health.c  |  3 +++
> >>  .../net/ethernet/mellanox/mlx5/core/main.c    | 10 ++++++++++
> >>  .../mellanox/mlx5/core/sf/dev/driver.c        |  3 +++
> >>  include/linux/mlx5/driver.h                   | 11 ++++++++++
> >>  7 files changed, 60 insertions(+)
> > <...>
> >
> >> +static void mlx5_ib_shutdown_quiesce(void)
> >> +{
> >> +	flush_workqueue(ib_comp_wq);
> >> +	flush_workqueue(ib_comp_unbound_wq);
> >> +	flush_workqueue(mlx5_ib_event_wq);
> >> +}
> > These workqueues are shared by all IB drivers and the core. Drivers
> > must not flush or destroy them.
> >
> > Why this is not FW issue?
> >
> > Thanks
