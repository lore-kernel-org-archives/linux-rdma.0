Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DE303B9DA1;
	Thu, 16 Jul 2026 08:42:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784191339; cv=none; b=cF5erCRCgboTkrk/6o/trCgAZm0S2CkiigIoLYK7tbZGzTE1hvVcogb3WgLS0SGgsnvnnh3HeT6TMA6SxAwsbJ/5AkvZxVcC3mwfdaX2NRnPd6mSFBaYwt7aoCkqNVXkx9KFypVK4DYKGUfmvM0m/2/nvgnRpdD0+rwEtQ1LHjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784191339; c=relaxed/simple;
	bh=/WJ6v8OiP1dG88iZG6/FmNP2+uNq82s7SuBsLJmN47I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CCLTjaGuiglLWNJJqG6GPIbYOu4gv0ARAHQ/gTGa708/ONtgLUWk4zrP6VaeS8ajsgfr6fGW9EjmeEoES5/KRajmajyqbI0ijjWt8RfdXjj/C3uH3vm+Q7qZMRjTrzCDAlqgr87nKOjXVmWQjV8vmA1fSrCxvVwoCqmKnvXAlfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MUXF49ry; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MUXF49ry"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC0901F000E9;
	Thu, 16 Jul 2026 08:42:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784191338;
	bh=3ToGe4A0EsTBqwccr1e+Ux9VSyh42DWrvI/hBctj49w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=MUXF49rybLPh7K6d88bginMe/FijhXGqMyyHVJ6vqwyBMJ9VYU3wmSKilhoGBSWxw
	 ziNplZtyVe+mrfElDH9fIVQ0Nm28C5h2MAp/UI5jw4kPFEHID9umZM5QKsfP2ZwSBq
	 1Tn9/hgzBTqa/tHiULuYLCdDanMf3/8/Ag8ScTpLYPiqy6zH5GWag5E/7w+NtjeZeU
	 Oy80sdYn0x8EBkHVA/3vRxBXOpLga9UX1XvRY9cON/uhHJD+MDLaBgueG7QgQ144ja
	 cV0b2L7AA1SQdpZVj536KCH6qX8aL6oAGZIqRAClg9Ynq/gI54ifUvvufcVUMwtn22
	 cC8vtIVQGop4Q==
Date: Thu, 16 Jul 2026 11:42:11 +0300
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
Message-ID: <20260716084211.GC70906@unreal>
References: <20260715082307.1593915-1-chenguang.zhao@linux.dev>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260715082307.1593915-1-chenguang.zhao@linux.dev>

On Wed, Jul 15, 2026 at 04:23:07PM +0800, Chenguang Zhao wrote:
> From: Chenguang Zhao <zhaochenguang@kylinos.cn>
> 
> On reboot -f with NFS over RDMA, mlx5 shutdown can tear the device
> down while ib-comp-wq still polls live CQs, leading to UAF in
> wr_cqe->done().
> 
> Mark the device shutting down before teardown, flush completion
> workqueues so in-flight pollers observe the flag, skip SYS_ERROR
> completion delivery, and make poll/arm CQ a no-op under the CQ lock
> while shutting down.
> 
> Signed-off-by: Chenguang Zhao <zhaochenguang@kylinos.cn>
> ---
> changelog:
>  - Fix the race on MLX5_INTERFACE_STATE_SHUTTING_DOWN: set the
>    flag, then flush ib-comp / mlx5_ib event workqueues via an
>    mlx5_ib quiesce hook before fast_unload/teardown.
>  - Check shutting-down under cq->lock in mlx5_ib_poll_cq/arm_cq.
>  - Export ib_comp_wq and ib_comp_unbound_wq so modular mlx5_ib
>    can flush them.
> 
> v2:
>  https://lore.kernel.org/all/20260714075558.1420384-1-chenguang.zhao@linux.dev/
> 
> v1:
>  https://lore.kernel.org/all/20260702073422.279820-1-chenguang.zhao@linux.dev/
> 
>  drivers/infiniband/core/device.c              |  2 ++
>  drivers/infiniband/hw/mlx5/cq.c               | 11 ++++++++++
>  drivers/infiniband/hw/mlx5/main.c             | 20 +++++++++++++++++++
>  .../net/ethernet/mellanox/mlx5/core/health.c  |  3 +++
>  .../net/ethernet/mellanox/mlx5/core/main.c    | 10 ++++++++++
>  .../mellanox/mlx5/core/sf/dev/driver.c        |  3 +++
>  include/linux/mlx5/driver.h                   | 11 ++++++++++
>  7 files changed, 60 insertions(+)

<...>

> +static void mlx5_ib_shutdown_quiesce(void)
> +{
> +	flush_workqueue(ib_comp_wq);
> +	flush_workqueue(ib_comp_unbound_wq);
> +	flush_workqueue(mlx5_ib_event_wq);
> +}

These workqueues are shared by all IB drivers and the core. Drivers
must not flush or destroy them.

Why this is not FW issue?

Thanks
