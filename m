Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C39D25B0A5;
	Fri, 25 Sep 2026 03:38:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790307487; cv=none; b=na8sjDepEGwZR/z2YOeUnaJi5/POdnaNP2rYo4sJ7u94lPdut4xmXPNZ5UO8/luA/pbQBXBQU/aFwtb2VGljcV73pXMBfV6e7mimjMJgZyI0OfGdGU/hZskJfM3TrwgngCyLD6qGSncCq0aPO+MmwUtOY1NXKGXD+jncsejNcsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790307487; c=relaxed/simple;
	bh=cYD0dkhGY/S6V/zMpmaqgX4TAFhISlhwydmGYMJp+bU=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=toBM9DlQULk5LLtclcyvHbsiJAbTEKICGmGYZCjJmmYg0FJwXukThVBhTldcg82gLt08UN8iaiPUYRqgNcF49UNCZC1MXRFneQpRk1ObqW6MQxiFjfTrWNOLbQr1yWDGPZKEa1fKlL9nuauFfq9EMhN6J4yygdDpEEFzspof35Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=muA8BqR9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="muA8BqR9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7146C1F000FF;
	Fri, 25 Sep 2026 03:38:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790307485;
	bh=/MTkTfu9PEPASvRDnq+fDAQla1IX6E41ay0A3ltvGFs=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=muA8BqR9PWn2Rzrh6AagBqISJQDTnvWwdKHJnSD9dE1/fpr/BSCgEDQgEoD0Sz+8n
	 glXByVgf+8ATaJJ2t4ye8wY+mw2r5QSduTlzFjRX4737x+OGXpKa65h6xizNIqPDti
	 sQYhrMnrOORAtrNf1M60BaeTNFbhr4D5BZoDG6uIVI9vujWwqSD0mKqAWmZ7BNVOWU
	 qAHZd90F3g+Zp7tOTm32fPhEcq1/fMConVrK+fSMwo1nSXLf8up13EpwqS3py6NSmg
	 Gq1m/k3XvCYFSovH+iqU1qvvonP+nwMaux030WArfjHiYG24dzZjri0NmizWIwmYaf
	 UVsfy9LwzuiAw==
Message-ID: <0a141f59b37b9055764c97dddfdf9506fc4d7fa0.camel@kernel.org>
Subject: Re: [PATCH net-next v2] net/rds: replace tasklets with workqueue
From: Allison Henderson <achender@kernel.org>
To: Sunny Tiwari <sunnytiwari@google.com>, Santosh Shilimkar
	 <santosh.shilimkar@oracle.com>, netdev@vger.kernel.org, 
	linux-rdma@vger.kernel.org
Cc: rds-devel@oss.oracle.com, "David S . Miller" <davem@davemloft.net>, Eric
 Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo
 Abeni <pabeni@redhat.com>,  Simon Horman <horms@kernel.org>
Date: Thu, 24 Sep 2026 20:38:04 -0700
In-Reply-To: <20cbfc32678019daadd3c67fd75262b8264aa180.1790178801.git.sunnytiwari@google.com>
References: 
	<20cbfc32678019daadd3c67fd75262b8264aa180.1790178801.git.sunnytiwari@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.3-0ubuntu1.1 
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Thu, 2026-09-24 at 06:26 +0000, Sunny Tiwari wrote:
> Convert the deprecated send and receive completion tasklets in
> net/rds/ib to BH work items queued on system_bh_wq.
>=20
> In rds_ib_conn_path_shutdown(), replace tasklet_kill() with
> disable_work_sync(), and call enable_work() after destroying the CQs so
> the work items can be used again when the connection reconnects.
>=20
> Assisted-by: Gemini
> Signed-off-by: Sunny Tiwari <sunnytiwari@google.com>

Hi Sunny,

Thanks for the patch.  This looks like a straight forward conversion to me.
I've also run it through the rds selftests on my end, and everything came
up clean.

Reviewed-by: Allison Henderson <achender@kernel.org>
Tested-by: Allison Henderson <achender@kernel.org>

Thanks!
Allison
=20
> ---
> Changes in v2:
> - Use system_bh_wq instead of allocating a custom rds_ib_wq workqueue,
>   dropping the net/rds/ib.c changes.
> - Use from_work() and disable_work_sync() / enable_work() instead of
>   cancel_work_sync().
> - Link to v1: https://lore.kernel.org/linux-rdma/6b07af04b3ba66a09009e1a0=
a7b98ec5ec85d3a0.1790109248.git.sunnytiwari@google.com/
>=20
>  net/rds/ib.h    |  4 ++--
>  net/rds/ib_cm.c | 29 +++++++++++++++--------------
>  2 files changed, 17 insertions(+), 16 deletions(-)
>=20
> diff --git a/net/rds/ib.h b/net/rds/ib.h
> index 5ff346a1e..190122636 100644
> --- a/net/rds/ib.h
> +++ b/net/rds/ib.h
> @@ -159,8 +159,8 @@ struct rds_ib_connection {
>  	atomic_t		i_fastreg_inuse_count;
> =20
>  	/* interrupt handling */
> -	struct tasklet_struct	i_send_tasklet;
> -	struct tasklet_struct	i_recv_tasklet;
> +	struct work_struct	i_send_work;
> +	struct work_struct	i_recv_work;
> =20
>  	/* tx */
>  	struct rds_ib_work_ring	i_send_ring;
> diff --git a/net/rds/ib_cm.c b/net/rds/ib_cm.c
> index 6e3110a04..3ebe13d00 100644
> --- a/net/rds/ib_cm.c
> +++ b/net/rds/ib_cm.c
> @@ -253,7 +253,7 @@ static void rds_ib_cq_comp_handler_recv(struct ib_cq =
*cq, void *context)
> =20
>  	rds_ib_stats_inc(s_ib_evt_handler_call);
> =20
> -	tasklet_schedule(&ic->i_recv_tasklet);
> +	queue_work(system_bh_wq, &ic->i_recv_work);
>  }
> =20
>  static void poll_scq(struct rds_ib_connection *ic, struct ib_cq *cq,
> @@ -279,9 +279,9 @@ static void poll_scq(struct rds_ib_connection *ic, st=
ruct ib_cq *cq,
>  	}
>  }
> =20
> -static void rds_ib_tasklet_fn_send(unsigned long data)
> +static void rds_ib_send_worker(struct work_struct *work)
>  {
> -	struct rds_ib_connection *ic =3D (struct rds_ib_connection *)data;
> +	struct rds_ib_connection *ic =3D from_work(ic, work, i_send_work);
>  	struct rds_connection *conn =3D ic->conn;
> =20
>  	rds_ib_stats_inc(s_ib_tasklet_call);
> @@ -319,9 +319,9 @@ static void poll_rcq(struct rds_ib_connection *ic, st=
ruct ib_cq *cq,
>  	}
>  }
> =20
> -static void rds_ib_tasklet_fn_recv(unsigned long data)
> +static void rds_ib_recv_worker(struct work_struct *work)
>  {
> -	struct rds_ib_connection *ic =3D (struct rds_ib_connection *)data;
> +	struct rds_ib_connection *ic =3D from_work(ic, work, i_recv_work);
>  	struct rds_connection *conn =3D ic->conn;
>  	struct rds_ib_device *rds_ibdev =3D ic->rds_ibdev;
>  	struct rds_ib_ack_state state;
> @@ -381,7 +381,7 @@ static void rds_ib_cq_comp_handler_send(struct ib_cq =
*cq, void *context)
> =20
>  	rds_ib_stats_inc(s_ib_evt_handler_call);
> =20
> -	tasklet_schedule(&ic->i_send_tasklet);
> +	queue_work(system_bh_wq, &ic->i_send_work);
>  }
> =20
>  static inline int ibdev_get_unused_vector(struct rds_ib_device *rds_ibde=
v)
> @@ -1099,12 +1099,12 @@ void rds_ib_conn_path_shutdown(struct rds_conn_pa=
th *cp)
>  		while (!wait_event_timeout(rds_ib_ring_empty_wait,
>  					   rds_ib_conn_path_shutdown_check_wait(cp) =3D=3D 0,
>  					   msecs_to_jiffies(1000))) {
> -			tasklet_schedule(&ic->i_send_tasklet);
> -			tasklet_schedule(&ic->i_recv_tasklet);
> +			queue_work(system_bh_wq, &ic->i_send_work);
> +			queue_work(system_bh_wq, &ic->i_recv_work);
>  		}
> =20
> -		tasklet_kill(&ic->i_send_tasklet);
> -		tasklet_kill(&ic->i_recv_tasklet);
> +		disable_work_sync(&ic->i_send_work);
> +		disable_work_sync(&ic->i_recv_work);
> =20
>  		atomic_set(&ic->i_cq_quiesce, 1);
> =20
> @@ -1123,6 +1123,9 @@ void rds_ib_conn_path_shutdown(struct rds_conn_path=
 *cp)
>  			ib_destroy_cq(ic->i_recv_cq);
>  		}
> =20
> +		enable_work(&ic->i_send_work);
> +		enable_work(&ic->i_recv_work);
> +
>  		if (ic->rds_ibdev) {
>  			/* then free the resources that ib callbacks use */
>  			if (ic->i_send_hdrs) {
> @@ -1234,10 +1237,8 @@ int rds_ib_conn_alloc(struct rds_connection *conn,=
 gfp_t gfp)
>  	}
> =20
>  	INIT_LIST_HEAD(&ic->ib_node);
> -	tasklet_init(&ic->i_send_tasklet, rds_ib_tasklet_fn_send,
> -		     (unsigned long)ic);
> -	tasklet_init(&ic->i_recv_tasklet, rds_ib_tasklet_fn_recv,
> -		     (unsigned long)ic);
> +	INIT_WORK(&ic->i_send_work, rds_ib_send_worker);
> +	INIT_WORK(&ic->i_recv_work, rds_ib_recv_worker);
>  	mutex_init(&ic->i_recv_mutex);
>  #ifndef KERNEL_HAS_ATOMIC64
>  	spin_lock_init(&ic->i_ack_lock);

