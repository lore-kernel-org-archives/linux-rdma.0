Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795111941;
	b=CqPUPOcuu6sH7wiAUzz1a/Y5i6YQkLkYmc/MoG/CcsSQGVTZFW3mZyBl1mjEi2hGjgmZ
	 f6WIAYfbZG1is9Ym2b4IvmRgE4Z1U6LmSsVoVU1zwg5Zqkwks7auvM2QIR3dzb18CgF6A
	 i+LUua4BxJCmy9vlQwgdpy7EFbPLHbMBdlD3HngyOp7FZY772eiIRnS93ptWOBSk1aSX9
	 ZE5vyiYRHut1BX1JKfsMPIqUeNv0JfWbkTetH0Wv19NyBYeyPt9pHjaQxP2rhFfBAHs3G
	 U1WF+t2uQQNJTxrOEOdfBvZ/3A/1+ZUHJ3188JY23sDGQJrXDEVv4Uu/igOBZ8l64Uw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795111941;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=4e2HuHD/hZyeap1cGN0CJrCN90KJdJBuqz0gHrAK16I=;
	b=VlOLxqQ9YojSDcZutEqhc7lsKuy3a3+cGgkkbcRCmOvVDVz9sBDsc7keiWLTD0+y3LGH
	 v8/FqVVf7/lRXGRj8uguPV+izXn/Md2zoDOKSX9yGRI10Zkv5P3g3uDpl0zcETQOBgFwE
	 JjXRLSJsdZLBJr2f+CusBQ0FNHaO7jMHZxG8llN64+K9BUbzKuEpZrGVzfeW9do/NWoqE
	 zEi1jAarOMxvf2KI/iLdXzomDuG2Jyxake6kuyvyAEH2q4a9cngHLfThDB8plE4aTA32G
	 OG4XYD9l+1z5JN7q8vAJxXzSVkBtpY17hAKbWgWpVzvBNXstk0Xe3X6ZerPuGyQXNPw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=W1bTUmEs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 284DD606A325;
	Thu, 19 Nov 2026 18:12:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=W1bTUmEs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E97A21F000C5;
	Thu, 19 Nov 2026 18:12:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795111940;
	bh=4e2HuHD/hZyeap1cGN0CJrCN90KJdJBuqz0gHrAK16I=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=W1bTUmEsUU+AZ9Fa2ihmIBrYutwwHK7rx8OPlAY+/12gvsimcTBVcfr+wB7kgwnIq
	 MHxiBSdxHuOb14y8a4+CzUFwR5gwuuVObp4/ndfXCzSqSOlCxXtUqXdxwaXqiOPYX3
	 dFIIt88JJhBWHpatEP/2BQlBkhTRObk79shCrIFJpBqVDuSoVFlX5Z6rLZ3kLxiY/k
	 B8YTyAe3p/kvYzunWxODuEWevXTKhV824pVoEhMNBHCNvczMMeIdaK32PlrWTXSibm
	 6jHV5Sk/eyDDFxpwsl41gwG8LKDlwW0BYRh2MKjkvTH0rwjcBFF2YkAJxupnyWC21H
	 5XKlI8cUMQVMg==
Subject: Re: [PATCH net] net/mlx5: SF, remove probed SF devices when arming
 vhca events fails
From: netdev-bot+sashiko@kernel.org
To: lcy8047@gmail.com
Cc: saeedm@nvidia.com, leon@kernel.org, tariqt@nvidia.com, mbloch@nvidia.com,
 andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, pabeni@redhat.com, parav@nvidia.com, shayd@nvidia.com,
 netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
 linux-kernel@vger.kernel.org
Date: Thu, 19 Nov 2026 18:12:19 +0000
Message-ID: <179511193949.3136.322606706504855990@kernel.org>
In-Reply-To: <20261117031141.1720619-1-lcy8047@gmail.com>
References: <20261117031141.1720619-1-lcy8047@gmail.com>
X-sashiko-severity: High
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 1 potential
issue(s) to consider.

Critical: 0 · High: 1 (2) · Medium: 0 · Low: 0

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] The patch adds a mlx5_sf_dev_destroy_all() call to the arm_err
  path of mlx5_sf_dev_table_create().

Pre-existing issues:
- [High] This problem wasn't introduced by this patch, but it sits on the
  path the patch changes.
- [High] This problem wasn't introduced by this patch, but it is the same
  synchronization gap the patch relies on.

--

net/mlx5: SF, remove probed SF devices when arming vhca events fails

This patch adds a mlx5_sf_dev_destroy_all() call to the arm_err path of
mlx5_sf_dev_table_create(). The goal is to remove SF auxiliary devices
that the active-SF probe work already added. It also moves the helper
above its new caller.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/dev.c b/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/dev.c
> index e75cbf333898d..44f6292ad59ec 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/dev.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/dev.c

[ ... ]

> @@ -360,6 +371,7 @@ void mlx5_sf_dev_table_create(struct mlx5_core_dev *dev)
>  arm_err:
>  	mlx5_sf_dev_destroy_active_works(table);
>  	mlx5_vhca_event_work_queues_flush(dev);
> +	mlx5_sf_dev_destroy_all(table);

[Severity: High]

Is it safe to call mlx5_sf_dev_destroy_all() here while VHCA state change
events are still being delivered?

mlx5_load() calls mlx5_vhca_event_start(), which registers the VHCA EQ
notifier, before it calls mlx5_sf_dev_table_create(). sf_dev_nb was
registered even earlier. The arm_err path unregisters neither of them.
mlx5_vhca_event_work_queues_flush() only drains work that is already
queued.

mlx5_sf_dev_vhca_arm_all() also returns on the first failure, so the
functions armed before it stay armed. mlx5_vhca_event_notify() re-arms a
function every time it delivers an event:

mlx5_vhca_event_notify()
    mlx5_vhca_event_arm(dev, event->function_id);
    ...
    blocking_notifier_call_chain(&dev->priv.vhca_state_n_head, 0, event);

dev->priv.sf_dev_table is still set at this point, so
mlx5_sf_dev_state_change_handler() gets past its only check:

	if (!table)
		return 0;
	...
	sf_dev = xa_load(&table->devices, sf_index);

Could the handler's xa_load() and the xa_for_each() in
mlx5_sf_dev_destroy_all() both return the same sf_dev before either
xa_erase() runs? If so, both would call mlx5_sf_dev_remove_aux(). That
runs auxiliary_device_delete() and auxiliary_device_uninit() twice, and
the second caller uses sf_dev after mlx5_sf_dev_release() has freed it.

An MLX5_VHCA_STATE_ACTIVE event could also be handled while the loop runs,
or after it ends but before kfree(table). In that case mlx5_sf_dev_add()
can xa_insert() at an index the loop has already passed. Wouldn't that SF
stay on the auxiliary bus with parent_mdev pointing at the parent device?
That is the same leak the commit message says this patch fixes. If the
insert happens after kfree(table), it writes into a freed xarray.

The commit message says this matches mlx5_sf_dev_table_destroy(), but that
function depends on this:

	/* Now that event handler is not running, it is safe to destroy
	 * the sf device without race.
	 */

That holds in mlx5_unload() because mlx5_vhca_event_stop() runs first and
does both the unregister and the flush. This path only does the flush.

Should the handler be quiesced before the table is walked and freed, for
example by stopping event delivery or adding real locking? Setting
dev->priv.sf_dev_table to NULL earlier would not be enough on its own,
because an mlx5_sf_dev_add() that is already running still uses the table.

>  add_active_err:
>  	kfree(table);
>  	dev->priv.sf_dev_table = NULL;

[Severity: High]

This is a pre-existing issue that was not introduced by this patch. Can
mlx5_sf_dev_state_change_handler() still use the table after this
kfree()?

The handler reads dev->priv.sf_dev_table once, with no lock and no RCU,
and only checks it for NULL. If a handler loads the pointer before the
NULL store, it can then call xa_load(), xa_erase() or xa_insert() on the
freed table->devices. mlx5_sf_dev_add() also reads freed table fields:

	sf_dev->bar_base_addr = table->base_address + (sf_index * table->sf_bar_length);

Swapping the kfree() and the NULL store would not close this, because a
handler may already hold the old pointer.

This patch also widens the window: the slow mlx5_sf_dev_destroy_all() now
runs between the flush and kfree(table).

[Severity: High]

This isn't a bug introduced by this patch, but the mlx5_load() error
unwind has the same ordering problem. The err_traps_reg label destroys the
table before VHCA events are stopped:

drivers/net/ethernet/mellanox/mlx5/core/main.c:mlx5_load() {
    ...
err_traps_reg:
	mlx5_sf_dev_table_destroy(dev);
	mlx5_sriov_detach(dev);
err_sriov:
	mlx5_lag_remove_mdev(dev);
	mlx5_ec_cleanup(dev);
err_ec:
	mlx5_vhca_event_stop(dev);
    ...
}

mlx5_unload() uses the opposite order:

	mlx5_vhca_event_stop(dev);
	mlx5_sf_dev_table_destroy(dev);

Suppose mlx5_devlink_traps_register() or mlx5_data_direct_init() fails
after mlx5_sf_dev_table_create() succeeded. Won't
mlx5_sf_dev_table_destroy() then run mlx5_sf_dev_destroy_all() and
kfree(table) while the EQ notifier is still registered and the vhca event
workqueues have not been flushed?

That breaks the "event handler is not running" precondition in the comment
in mlx5_sf_dev_table_destroy(). It opens the same races described above:
double removal of an sf_dev, a leaked SF, and use of the freed table.

A mlx5_sf_dev_add_active_work() item that already passed its
stop_active_wq check could also still be inside mlx5_sf_dev_add() while
mlx5_sf_dev_destroy_all() runs. Nothing on this path flushes the vhca
event workqueues first.

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261117031141.1720619-1-lcy8047%40gmail.com
