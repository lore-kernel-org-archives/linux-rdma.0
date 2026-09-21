Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 452D85013CE;
	Mon, 21 Sep 2026 18:49:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790016551; cv=none; b=kWGM1fhwHj3oBhaMwGV3bfgP6Uy7vEwCkUKWssWqKUxeibv9TViqLYhYrVrn7RLBpWGGjgBvv74zsfrlRE83K0e/tmii9+STKIpLaUUh/TiluauGFRS9ZuvUH6yldeOeNZggn2FQACYFRWWKBatTaPxIfmL6RrsCAZKp3/hAqbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790016551; c=relaxed/simple;
	bh=N9fZfr+wyq/v/hHN1nQ7X0u65vOxEznc390OpnELqJI=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=EvsQJQ5e1rMh9e7JUslsw/N+CW+nDTBVCw6s5P3mXu7+a18lGfSNXybvG0ofFXhgIvBGFsjVdzDShYmBXv85N9U3r3Az0P/8q38lRdRE3K3IuUKWJc/zkg+iTj4Xe63jr8zV67EP5qemgcB0j0/mvfWsJxW5NLxie7YvaNMrMMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IeYfPIcA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IeYfPIcA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87C841F000FF;
	Mon, 21 Sep 2026 18:49:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790016549;
	bh=8yEZmkxrmTpC52lZql8aTOrHEOQbx+Ln/+sxt67z6gE=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=IeYfPIcAyP3nP025Jemm7V1bmKj1AuIBwask5zsbOPQbVwvDHQhksJh8c3sPhmd61
	 /WRMezNs3vEwzd94VNT9cF0zQc9zvMC6KRkhXGpm0heYcuc9+sPh7uTv+MiDG8qIzY
	 TkFZrMwsNucessOGy4gklA43YcVJzhaHpljyMFhS3fRr5LJBihrih6PsAbhh2Ev6WU
	 RQGZtzUZlhOSWIJFsavtiXVEWI34rdeM7KKUUA9rc5u92nrDIeuxM/K2iR1LNbuXQk
	 uwMkICmB4Ycv8aYoTZZLdOKMQ9N87jS1Gkz8XVVr84ghy+9I8wsf54vIw0MW1S+z7W
	 ist1gV8OdiQeg==
Subject: Re: [PATCH net 4/7] net/mlx5e: macsec: Track hardware object
 ownership for SA teardown
From: netdev-bot+sashiko@kernel.org
To: tariqt@nvidia.com
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com,
 sd@queasysnail.net, borisp@nvidia.com, cjubran@nvidia.com, cratiu@nvidia.com,
 daniel.zahka@gmail.com, dtatulea@nvidia.com, ehakim@nvidia.com,
 gal@nvidia.com, jianbol@nvidia.com, leon@kernel.org,
 linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, liorna@nvidia.com,
 mbloch@nvidia.com, parav@nvidia.com, raeds@nvidia.com, rrameshbabu@nvidia.com,
 roid@nvidia.com, saeedm@nvidia.com, steffen.klassert@secunet.com
Date: Mon, 21 Sep 2026 18:49:08 +0000
Message-ID: <179001654813.2160803.1439419935536020425@kernel.org>
In-Reply-To: <20260917175433.4090878-5-tariqt@nvidia.com>
References: <20260917175433.4090878-5-tariqt@nvidia.com>
X-sashiko-severity: Low
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found more severe
issue(s) in other patches of this series. This mail is only an FYI, in case
you want to address the nit picks below when you respin.

Low priority / nit picks for your consideration:

- [Low] `mlx5e_macsec_destroy_object()`
  (drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c:303-312)…

Pre-existing issues:
- [High] TX steering rules are still programmed with an unallocated
  MACsec object ID.
- [Medium] `mlx5e_macsec_upd_txsa()` commits `tx_sa->active =
  ctx_tx_sa->active;`…

--

net/mlx5e: macsec: Track hardware object ownership for SA teardown

This adds a macsec_obj_created flag to struct mlx5e_macsec_sa, sets it after
a successful hardware MACsec object creation, and checks it in
mlx5e_macsec_cleanup_sa() before issuing the destroy command. The intent is
to avoid destroying an object the driver never allocated, or one that was
already destroyed while the driver SA kept its object ID.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
> index daff53ba7d09f..20eec345b36cd 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
> @@ -58,6 +58,7 @@ struct mlx5e_macsec_async_work {
>  
>  struct mlx5e_macsec_sa {
>  	bool active;
> +	bool macsec_obj_created;
>  	u8  assoc_num;
>  	u32 macsec_obj_id;
>  	u32 enc_key_id;
> @@ -331,7 +332,10 @@ static void mlx5e_macsec_cleanup_sa(struct mlx5e_macsec *macsec,
>  				    struct net_device *netdev, u32 fs_id)
>  {
>  	mlx5e_macsec_cleanup_sa_fs(macsec, sa, is_tx, netdev, fs_id);
> -	mlx5e_macsec_destroy_object(macsec->mdev, sa->macsec_obj_id);
> +	if (sa->macsec_obj_created) {
> +		mlx5e_macsec_destroy_object(macsec->mdev, sa->macsec_obj_id);
> +		sa->macsec_obj_created = false;
> +	}
>  }

[Severity: High]

This isn't a bug introduced by this patch, but the new flag establishes that
macsec_obj_id is only meaningful while macsec_obj_created is set, and the
paths that consume the ID do not honour that.  Should the rule creation path
check it too?

mlx5e_macsec_init_sa_fs() copies the ID with no check:

	rule_attrs.macsec_obj_id = sa->macsec_obj_id;
	rule_attrs.sci = sa->sci;
	rule_attrs.assoc_num = sa->assoc_num;

and macsec_fs_tx_setup_fte() in lib/macsec_fs.c hands that value to the
device as the crypto object of the encrypt rule:

	flow_act->crypto.obj_id = macsec_obj_id;

A TX SA can reach that point with macsec_obj_id == 0 and
macsec_obj_created == false, because mlx5e_macsec_add_txsa() keeps the SA
after creating only the key:

	macsec_device->tx_sa[assoc_num] = tx_sa;
	if (!secy->operational)
		goto out;

Nothing creates the object afterwards: mlx5e_macsec_upd_txsa() and
mlx5e_macsec_upd_secy() only call mlx5e_macsec_init_sa_fs(), never
mlx5e_macsec_init_sa().

Can the following plain configuration sequence reach that state, with no
failure injection?

  ip macsec add <dev> tx sa 0 on key ...      /* object created */
  ip macsec set <dev> tx sa 0 off             /* macsec_upd_txsa() in
                                                 drivers/net/macsec.c sets
                                                 secy->operational = false */
  ip macsec add <dev> tx sa 1 on key ...      /* assoc_num != encoding_sa, so
                                                 operational stays false and
                                                 mlx5e_macsec_add_txsa()
                                                 takes the early exit */
  ip link set <dev> type macsec encoding-sa 1 /* macsec_changelink_common()
                                                 sets secy->operational and
                                                 macsec_changelink() calls
                                                 mdo_upd_secy */

mlx5e_macsec_upd_secy() then deletes all TX rules in its first loop and, in
the second loop, matches SA 1:

		if (tx_sa->assoc_num == tx_sc->encoding_sa && tx_sa->active) {
			err = mlx5e_macsec_init_sa_fs(ctx, tx_sa, tx_sc->encrypt, true, NULL);
			if (err)
				goto out;
		}

so the encrypt rule is installed against object ID 0, which the driver never
allocated.  If firmware rejects it, the error surfaces as -ENOMEM from
mlx5e_macsec_init_sa_fs() after the previous TX rules were already removed;
if it accepts it, the SecY is operational with an encrypt rule bound to an
object the driver does not own.  Would guarding init_sa_fs() on
macsec_obj_created (or creating the object when the SecY becomes operational)
be the matching change?

The ASO event lookups have the same predicate mismatch.
get_macsec_tx_sa_from_obj_id() and get_macsec_rx_sa_from_obj_id() select SAs
by activity, not by ownership:

			macsec_sa = iter->tx_sa[i];
			if (!macsec_sa || !macsec_sa->active)
				continue;
			if (macsec_sa->macsec_obj_id == obj_id)
				return macsec_sa;

An active SA that carries an ID it does not own can be picked up for
macsec_epn_update()/mlx5e_macsec_modify_obj(), while the inactive TX SA whose
object this patch deliberately keeps alive is skipped and its EPN event is
dropped as not found.  Should these lookups test macsec_obj_created instead
of active?

[Severity: Low]

Separately, mlx5e_macsec_destroy_object() discards the command status:

	mlx5_cmd_exec(mdev, in, sizeof(in), out, sizeof(out));

and the hunk above clears sa->macsec_obj_created regardless of the result.
Before this change, a failed destroy would be retried by the next
unconditional cleanup (RX SA deactivation followed by RX SC or SecY
deletion); with the flag cleared unconditionally that retry no longer
happens, so a firmware destroy failure would leave the object allocated for
good.  The destroy_macsec_object unwind in mlx5e_macsec_init_sa() has the
same property.  Ignoring the status of a destroy command in teardown is the
existing mlx5 convention (see mlx5_destroy_ipsec_obj() and the void
mlx5_destroy_encryption_key()), so this is only about the retry that the new
flag removes.

> @@ -396,6 +400,7 @@ static int mlx5e_macsec_init_sa(struct macsec_context *ctx,
>  		if (err)
>  			goto destroy_macsec_object;
>  	}
> +	sa->macsec_obj_created = true;
>  
>  	return 0;
>  

[Severity: Medium]

This is a pre-existing issue and not something the patch changes, but while
looking at the SA activity bookkeeping next door: mlx5e_macsec_upd_txsa()
commits the new activity value before validating the deactivation
precondition, and the error exit does not undo it:

	tx_sa->active = ctx_tx_sa->active;
	if (tx_sa->assoc_num != tx_sc->encoding_sa)
		goto out;

	if (ctx_tx_sa->active) {
		err = mlx5e_macsec_init_sa_fs(ctx, tx_sa, tx_sc->encrypt, true, NULL);
		if (err)
			goto out;
	} else {
		if (!tx_sa->macsec_rule) {
			err = -EINVAL;
			goto out;
		}

The core rolls its own state back on offload error in macsec_upd_txsa():

	tx_sa->active = was_active;
	secy->operational = was_operational;

So if an earlier activation failed in mlx5e_macsec_init_sa_fs(), the driver
SA is left active with macsec_rule == NULL while the core believes it is
inactive.  A later "tx sa N on" then hits the tx_sa->active ==
ctx_tx_sa->active early return and reports success without installing a rule,
and a later "off" returns -EINVAL with the driver flag already flipped to
inactive.  Should tx_sa->active only be updated once the rule work has
succeeded?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260917175433.4090878-1-tariqt%40nvidia.com
