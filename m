Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8560384228;
	Mon, 28 Sep 2026 18:29:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790620153; cv=none; b=IrkroB0cRnkjhASjDNmjCA18aU1PWpgJN8ph9PfhL+Ow3RX2izoteJC37fiSuuRUAqhPUSOytFOc/Uu8+VjCy4yOwEbPkGVHB8Efiptc5M5Z33DPCq1q2DtkbD/Lqx4v0nsnxVPQ0f8+hpxwxj2FJe5VWW4Ivuu49QVJYVlB7to=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790620153; c=relaxed/simple;
	bh=Osjfa/eweIpMNI1E+ykYc18hu2QCnuRqD2YPf2Mlhq4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KgFVoX8Abr0mzbQ8JLnr/xop7nBdGrzoX2BlpfkWwMu/RxAFH7xeYCnJ8iDyFC5dbP6utbNFQOgzoL6EQUXAmqJLeifyVOQxzyuypaRyBzqZIoLAyJKj3Ui5Gybte673QkBjz+62STvhqyTNdTWcB3VKdsJ3JkyAhN3G3V+FvsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YftC3OyU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YftC3OyU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB6C91F000FF;
	Mon, 28 Sep 2026 18:29:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790620151;
	bh=kj1BuamINwdjjjhJwRV+FCBk2q11iQ2TZh9fdzQcwn0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=YftC3OyUQStIa4UdGN1BE9aUd2r6Lo1h5DCsCki0FW9+Dd/XSmPmpsxQGHoSqCbwX
	 mZjlyC2wK+Z6XaMJlP/Fuj28Lu3+B3Zss11DVOscCoQufqQMN0fLxr9sp04JlO5Ncb
	 tVCOFWS9SS+ChrRJp3Ln8PnnscJnipahGb0j0PXKZLsrl3wqbKUMNmLYpAmqk4kIJY
	 K/Jsx1GaAHCse9VaWu7MGqm/3b12CbcNjcVvcs06OIM+bPABw/vJ5FFFhM5hedT2lZ
	 D3rlogLp5Tkw8CsicqKAQFHqiocUPexsIAj/R7hDOiwN6AtnlPKbK2082Fnf8+EMYh
	 YBCPv6cHztHbw==
Date: Mon, 28 Sep 2026 21:29:06 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Praveen Kumar Kannoju <praveen.kannoju@oracle.com>
Cc: jgg@ziepe.ca, saeedm@nvidia.com, tariqt@nvidia.com, mbloch@nvidia.com,
	andrew+netdev@lunn.c, davem@davemloft.net, kuba@kernel.org,
	pabeni@redhat.com, jiri@resnulli.us,
	kalesh-anakkur.purayil@broadcom.com, ynachum@amazon.com,
	kees@kernel.org, mrgolin@amazon.com, parav@nvidia.com,
	linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org, anand.a.khoje@oracle.com
Subject: Re: [PATCH] RDMA/mlx5: Add poll-EQ callback for ULP recovery
Message-ID: <20260928182906.GX563127@unreal>
References: <20260918100537.1214162-1-praveen.kannoju@oracle.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260918100537.1214162-1-praveen.kannoju@oracle.com>

On Fri, Sep 18, 2026 at 10:05:37AM +0000, Praveen Kumar Kannoju wrote:
> Some upper layer protocols, such as RDS, use mlx5 RDMA CQs whose
> completion EQs are not shared with mlx5e queues. If an EQ notification is
> missed for one of those CQs, the ULP can remain idle until another event
> arrives or a driver health recovery path polls the EQ.
> 
> mlx5e already has a recovery path that polls a completion EQ from the tx
> timeout handler through mlx5_eq_poll_irq_disabled(). That mechanism is
> internal to the mlx5 core and is not reachable from RDMA ULPs such as RDS
> when they need to recover a CQ-associated EQ.
> 
> Add an optional RDMA device operation, reap_eq, and an ib_reap_eq() helper
> so ULPs can ask the provider to poll the event queue associated with a CQ.
> Providers that do not implement the callback return -EOPNOTSUPP.

I don't think this is viable. It also seems wrong for an upper-layer protocol
(ULP) to add code to work around a bug in a kernel driver.

Thanks

> 
> Validate the device and CQ passed to ib_reap_eq() before dereferencing the
> callback table or provider-private CQ storage. The mlx5 callback also
> checks that the CQ belongs to the supplied device and that the mlx5 device
> and completion EQ are present before polling.
> 
> Implement the callback for mlx5 by mapping the ib_cq to the mlx5 CQ and
> polling the CQ's completion EQ through a new exported mlx5_eq_reap()
> helper. mlx5_eq_reap() logs the EQ state, invokes
> mlx5_eq_poll_irq_disabled(), and reports any recovered EQEs.
> 
> Serialize mlx5_eq_poll_irq_disabled() with a per-EQ mutex. The recovery
> poll path disables the IRQ, runs the EQ handler, advances the EQ consumer
> index, and updates the CI doorbell. Multiple recovery callers polling the
> same EQ concurrently could race on that state and reap the same EQ in
> parallel.
> 
> Use this only as a recovery path for missed EQ notifications. It is not a
> normal completion polling path.
> 
> Signed-off-by: Praveen Kumar Kannoju <praveen.kannoju@oracle.com>
> ---
>  drivers/infiniband/core/device.c              |  1 +
>  drivers/infiniband/hw/mlx5/main.c             | 18 ++++++++++++++
>  drivers/net/ethernet/mellanox/mlx5/core/eq.c  | 22 +++++++++++++++++
>  .../net/ethernet/mellanox/mlx5/core/lib/eq.h  |  2 ++
>  include/linux/mlx5/eq.h                       |  2 ++
>  include/rdma/ib_verbs.h                       | 24 +++++++++++++++++++
>  6 files changed, 69 insertions(+)
> 
> diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
> index 7a3ed5ecac00..a0a6e4a9ed50 100644
> --- a/drivers/infiniband/core/device.c
> +++ b/drivers/infiniband/core/device.c
> @@ -3016,6 +3016,7 @@ void ib_set_device_ops(struct ib_device *dev, const struct ib_device_ops *ops)
>  	SET_DEVICE_OP(dev_ops, rdma_netdev_get_params);
>  	SET_DEVICE_OP(dev_ops, read_counters);
>  	SET_DEVICE_OP(dev_ops, read_comp_cntr);
> +	SET_DEVICE_OP(dev_ops, reap_eq);
>  	SET_DEVICE_OP(dev_ops, reg_dm_mr);
>  	SET_DEVICE_OP(dev_ops, reg_user_mr);
>  	SET_DEVICE_OP(dev_ops, reg_user_mr_dmabuf);
> diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
> index 373ee1f42d4a..ae8d32358e82 100644
> --- a/drivers/infiniband/hw/mlx5/main.c
> +++ b/drivers/infiniband/hw/mlx5/main.c
> @@ -22,6 +22,7 @@
>  #include <rdma/ib_addr.h>
>  #include <rdma/ib_cache.h>
>  #include <linux/mlx5/port.h>
> +#include <linux/mlx5/eq.h>
>  #include <linux/mlx5/vport.h>
>  #include <linux/mlx5/fs.h>
>  #include <linux/mlx5/eswitch.h>
> @@ -3654,6 +3655,22 @@ static void get_dev_fw_str(struct ib_device *ibdev, char *str)
>  		 fw_rev_sub(dev->mdev));
>  }
>  
> +static int mlx5_ib_reap_eq(struct ib_device *ibdev, struct ib_cq *ibcq)
> +{
> +	struct mlx5_ib_dev *dev;
> +	struct mlx5_ib_cq *cq;
> +
> +	if (!ibdev || !ibcq || ibcq->device != ibdev)
> +		return -EINVAL;
> +
> +	dev = to_mdev(ibdev);
> +	if (!dev->mdev)
> +		return -ENODEV;
> +
> +	cq = to_mcq(ibcq);
> +	return mlx5_eq_reap(dev->mdev, cq->mcq.eq);
> +}
> +
>  static int lag_event(struct notifier_block *nb, unsigned long event, void *data)
>  {
>  	struct mlx5_ib_dev *dev = container_of(nb, struct mlx5_ib_dev,
> @@ -4642,6 +4659,7 @@ static const struct ib_device_ops mlx5_ib_dev_ops = {
>  	.query_ucontext = mlx5_ib_query_ucontext,
>  	.reg_user_mr = mlx5_ib_reg_user_mr,
>  	.reg_user_mr_dmabuf = mlx5_ib_reg_user_mr_dmabuf,
> +	.reap_eq = mlx5_ib_reap_eq,
>  	.req_notify_cq = mlx5_ib_arm_cq,
>  	.rereg_user_mr = mlx5_ib_rereg_user_mr,
>  	.resize_user_cq = mlx5_ib_resize_cq,
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eq.c b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
> index d11ec263d53c..b5f292c1e9a7 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/eq.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
> @@ -154,15 +154,36 @@ u32 mlx5_eq_poll_irq_disabled(struct mlx5_eq_comp *eq)
>  {
>  	u32 count_eqe;
>  
> +	mutex_lock(&eq->poll_lock);
>  	disable_irq(eq->core.irqn);
>  	count_eqe = eq->core.cons_index;
>  	mlx5_eq_comp_int(&eq->irq_nb, 0, NULL);
>  	count_eqe = eq->core.cons_index - count_eqe;
>  	enable_irq(eq->core.irqn);
> +	mutex_unlock(&eq->poll_lock);
>  
>  	return count_eqe;
>  }
>  
> +int mlx5_eq_reap(struct mlx5_core_dev *dev, struct mlx5_eq_comp *eq)
> +{
> +	u32 eqe_count;
> +
> +	if (!dev || !eq)
> +		return -EINVAL;
> +
> +	mlx5_core_dbg(dev, "EQ 0x%x: Cons = 0x%x, irqn = 0x%x\n",
> +		      eq->core.eqn, eq->core.cons_index, eq->core.irqn);
> +
> +	eqe_count = mlx5_eq_poll_irq_disabled(eq);
> +	if (eqe_count)
> +		mlx5_core_warn(dev, "Recovered %d EQEs on EQ 0x%x\n",
> +			       eqe_count, eq->core.eqn);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL(mlx5_eq_reap);
> +
>  static void mlx5_eq_async_int_lock(struct mlx5_eq_async *eq, bool recovery,
>  				   unsigned long *flags)
>  	__acquires(&eq->lock)
> @@ -1012,6 +1033,7 @@ static int create_comp_eq(struct mlx5_core_dev *dev, u16 vecidx)
>  	INIT_LIST_HEAD(&eq->tasklet_ctx.list);
>  	INIT_LIST_HEAD(&eq->tasklet_ctx.process_list);
>  	spin_lock_init(&eq->tasklet_ctx.lock);
> +	mutex_init(&eq->poll_lock);
>  	tasklet_setup(&eq->tasklet_ctx.task, mlx5_cq_tasklet_cb);
>  
>  	irq = xa_load(&table->comp_irqs, vecidx);
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/eq.h b/drivers/net/ethernet/mellanox/mlx5/core/lib/eq.h
> index b1edc71ffc6d..ca019b3019aa 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/lib/eq.h
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/eq.h
> @@ -6,6 +6,7 @@
>  #include <linux/mlx5/driver.h>
>  #include <linux/mlx5/eq.h>
>  #include <linux/mlx5/cq.h>
> +#include <linux/mutex.h>
>  
>  #define MLX5_EQE_SIZE       (sizeof(struct mlx5_eqe))
>  
> @@ -46,6 +47,7 @@ struct mlx5_eq_comp {
>  	struct notifier_block   irq_nb;
>  	struct mlx5_eq_tasklet  tasklet_ctx;
>  	struct list_head        list;
> +	struct mutex            poll_lock; /* protect recovery polling */
>  };
>  
>  static inline u32 eq_get_size(struct mlx5_eq *eq)
> diff --git a/include/linux/mlx5/eq.h b/include/linux/mlx5/eq.h
> index 3705a382276b..a053f9eb2614 100644
> --- a/include/linux/mlx5/eq.h
> +++ b/include/linux/mlx5/eq.h
> @@ -9,6 +9,7 @@
>  #define MLX5_NUM_SPARE_EQE (0x80)
>  
>  struct mlx5_eq;
> +struct mlx5_eq_comp;
>  struct mlx5_irq;
>  struct mlx5_core_dev;
>  
> @@ -29,6 +30,7 @@ void mlx5_eq_disable(struct mlx5_core_dev *dev, struct mlx5_eq *eq,
>  
>  struct mlx5_eqe *mlx5_eq_get_eqe(struct mlx5_eq *eq, u32 cc);
>  void mlx5_eq_update_ci(struct mlx5_eq *eq, u32 cc, bool arm);
> +int mlx5_eq_reap(struct mlx5_core_dev *dev, struct mlx5_eq_comp *eq);
>  
>  /* The HCA will think the queue has overflowed if we
>   * don't tell it we've been processing events.  We
> diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
> index cb3b6163961b..aa08c7a5ea22 100644
> --- a/include/rdma/ib_verbs.h
> +++ b/include/rdma/ib_verbs.h
> @@ -2542,6 +2542,7 @@ struct ib_device_ops {
>  	int (*poll_cq)(struct ib_cq *cq, int num_entries, struct ib_wc *wc);
>  	int (*peek_cq)(struct ib_cq *cq, int wc_cnt);
>  	int (*req_notify_cq)(struct ib_cq *cq, enum ib_cq_notify_flags flags);
> +	int (*reap_eq)(struct ib_device *device, struct ib_cq *cq);
>  	int (*post_srq_recv)(struct ib_srq *srq,
>  			     const struct ib_recv_wr *recv_wr,
>  			     const struct ib_recv_wr **bad_recv_wr);
> @@ -4296,6 +4297,29 @@ static inline int ib_req_notify_cq(struct ib_cq *cq,
>  	return cq->device->ops.req_notify_cq(cq, flags);
>  }
>  
> +/**
> + * ib_reap_eq - Poll the event queue associated with a CQ.
> + * @device: Device that owns the CQ.
> + * @cq: CQ whose associated event queue should be polled.
> + *
> + * Poll the device event queue associated with @cq to recover completions
> + * after a missed event queue notification. This is an optional provider
> + * callback.
> + *
> + * Return: 0 on success, %-EINVAL for invalid input, and %-EOPNOTSUPP when
> + * unsupported.
> + */
> +static inline int ib_reap_eq(struct ib_device *device, struct ib_cq *cq)
> +{
> +	if (!device || !cq || cq->device != device)
> +		return -EINVAL;
> +
> +	if (!device->ops.reap_eq)
> +		return -EOPNOTSUPP;
> +
> +	return device->ops.reap_eq(device, cq);
> +}
> +
>  struct ib_cq *ib_cq_pool_get(struct ib_device *dev, unsigned int nr_cqe,
>  			     int comp_vector_hint,
>  			     enum ib_poll_context poll_ctx);
> -- 
> 2.43.7
> 
