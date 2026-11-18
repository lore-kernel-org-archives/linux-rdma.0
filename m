Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794971518;
	b=as3cw/648W13taEm1Sbjn7QYjP1HHsj8fhnwPQXlizdNBoraEwI7nmXO27wtIQ0mnc4t
	 7EeKCwH10/exTMqW71xOPLC3LbHeaUcxDh1F7IFh+xrj9SoQz2//ZEByr1lJbRt+xNm8b
	 wRAA5THN83lDejenWYOXqrgQ075Q7mgWueurffZvIR42KGdYPBirpRwZRjDCXhY3EcyCv
	 0gYkG1wGqrbRb92L2gb4VPcggGt6B0P0cz5WJzYnwKgo4ukzVR5b0fALgIFgmi9G0ZjXB
	 96QqXRa7DME7G6rgW0/vK8nwX+aBKD1/qeerIaJYIGxeU9K38ulbDVBl3CGZ9bx9AHQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794971518;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=lRCPzGCgJcXKUTvuwiTTReiFN+gbWXlzDRiLReosUSs=;
	b=jftRTm/9zRcL11TzczmmiPqIo6EMKZJaZVg7mAGpaBN3Xg934O8TZhXN6zYifOMskQD5
	 LRw5b4/uumC/x3OB4HtVbRh6qWjECbxfS8gZn9hLNBao6/GEzyvddqISMYwQ5OmFOOkce
	 QfbX0iO+mLqYLhwdps22rqQgzO7BB1+CIgqMbbpgRQMoiebjhsoI1xFsSqdpk7PQiwJaQ
	 5cLLV736Jja/Lh35/ONlRnDXbQj73Er+KTKGwrPDTNvNPmUzV+j/u6PZqZ10pFiW7fsul
	 EpYEMR3N7qbTQoZunlY0napnqw+cFSkeq+6qGH5wxdmd+9T4oI8hLut8KD3YZ6LQtvg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=l3LwxCBl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 588AF606A31C
	for <linux-rdma@vger.kernel.org>; Wed, 18 Nov 2026 03:11:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=l3LwxCBl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B45041F000C4;
	Wed, 18 Nov 2026 03:11:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794971517;
	bh=lRCPzGCgJcXKUTvuwiTTReiFN+gbWXlzDRiLReosUSs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=l3LwxCBlYzVQqGj+ip/0gBlJGQKR7HZiGngJn4hu6FpXOV2orfquYzQRSR4czFlOB
	 VKWe3MYQzb8EJbC5HXsr8RYg5VkqAlVUeeVm1DhyXX+8RfOf6NJ+T38brZA1Wxf5/V
	 1XQfn4MCs3d/YU7HeVLclPk9LeEj3y3aUWYxbXULNPcfvDfTGKE+6zZ2DTfOK6i7tZ
	 kbpMpXMRsxDJi6l1Mljp3VWFhUFkaTqjYccCUa3HDTCj3GZA5wy9HoQ/Oz4WC4DmBl
	 QEc9UfVuwMW85iWX2EyPGSTU2EWQbO8xqdAGncfbVnxYStZRmRipWhJTJ3TeJLLcgq
	 N4t8FgwumWSiw==
Message-ID: <sashiko-outbox-220006@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net] net/mlx5: SF, remove probed SF devices when arming
 vhca events fails
Reply-To: sashiko-reviews@lists.linux.dev
To: "Changyul Lee" <lcy8047@gmail.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261117031141.1720619-1-lcy8047@gmail.com>
References: <20261117031141.1720619-1-lcy8047@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 18 Nov 2026 03:11:57 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Medium] net/mlx5: race and UAF in mlx5_sf_dev_table_create() arm_err
  cleanup
--

commit a5d70bb82124aa0963c3bb188af6126f523476a3
Author: Changyul Lee <lcy8047@gmail.com>

net/mlx5: SF, remove probed SF devices when arming vhca events fails

This commit calls mlx5_sf_dev_destroy_all() on the arm_err error path in
mlx5_sf_dev_table_create() so that SF auxiliary devices probed by the
active work are removed if arming VHCA events fails.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/dev.c b/drive=
rs/net/ethernet/mellanox/mlx5/core/sf/dev/dev.c
> index e75cbf333898d..44f6292ad59ec 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/dev.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/dev.c
[ ... ]
> @@ -360,6 +371,7 @@ void mlx5_sf_dev_table_create(struct mlx5_core_dev *d=
ev)
>  arm_err:
>  	mlx5_sf_dev_destroy_active_works(table);
>  	mlx5_vhca_event_work_queues_flush(dev);
> +	mlx5_sf_dev_destroy_all(table);
>  add_active_err:
>  	kfree(table);
>  	dev->priv.sf_dev_table =3D NULL;

[Severity: Medium]
Can mlx5_sf_dev_state_change_handler() race with mlx5_sf_dev_destroy_all()
and kfree(table) on the arm_err path?

If mlx5_sf_dev_vhca_arm_all() fails after arming one or more SF functions,
those functions remain armed in firmware while dev->priv.sf_dev_nb is still
registered and dev->priv.sf_dev_table still points to table.  Unlike
mlx5_sf_dev_table_destroy(), which runs after mlx5_sf_dev_notifier_cleanup()
has unregistered the notifier, arm_err runs with the notifier active.

When mlx5_sf_dev_destroy_all() removes an already-probed SF, tearing down
its HCA transitions the function from MLX5_VHCA_STATE_IN_USE back to
MLX5_VHCA_STATE_ACTIVE, which can queue a new VHCA state event after
mlx5_vhca_event_work_queues_flush() has already returned:

CPU0                                  CPU1 (vhca_events wq)
mlx5_sf_dev_table_create()
  mlx5_sf_dev_vhca_arm_all()
    /* arms SF 0, fails on SF 1 */
  mlx5_sf_dev_destroy_active_works()
  mlx5_vhca_event_work_queues_flush()
  mlx5_sf_dev_destroy_all(table)
    xa_erase(&table->devices, 0)
    mlx5_sf_dev_remove_aux()
      /* SF 0 becomes ACTIVE,
         fires VHCA event */
                                      mlx5_sf_dev_state_change_handler()
                                        table =3D dev->priv.sf_dev_table;
  kfree(table)
                                        xa_load(&table->devices, 0)
                                          <-- use-after-free
  dev->priv.sf_dev_table =3D NULL;

Even if the handler runs before kfree(table), seeing MLX5_VHCA_STATE_ACTIVE
after xa_erase() causes mlx5_sf_dev_add() to re-add the SF auxiliary device
that mlx5_sf_dev_destroy_all() just removed, and a state change to
ALLOCATED or TEARDOWN_REQUEST can call mlx5_sf_dev_del() concurrently with
mlx5_sf_dev_destroy_all().

Clearing dev->priv.sf_dev_table before mlx5_vhca_event_work_queues_flush()
(with a barrier or WRITE_ONCE/READ_ONCE pair) would ensure no handler runs
against table while mlx5_sf_dev_destroy_all() and kfree(table) execute.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261117031141.1720=
619-1-lcy8047@gmail.com?part=3D1
