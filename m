Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795509173;
	b=gBT9XlqeXkl1A0WqwJXQn1rzunB79qn6CJBh4mgvEjUL76gYoMLw1upfoUpIKTfgOyML
	 aKhB7aDxMNtjObHoqBBYrTWo1hR7iunIA+Pmp5jabv7DoMCBFdpve05XSsBQhzWSDtvvh
	 tZ7jlglqicE1+bVrCy5G4u9fwg7lNZOcViGzSrmjfgreOC5UKQD9uN2q9r4ksNwVF95UY
	 RT5nB5MissF82EVxdz9p+41fyKfPpVrqGXOhPVQfJj7Gy9tu3n93YHPB8FnnehfJgfMKz
	 V165BhFoMutJC+kHpch1NSncPmzE8SHM9T4lx+PrmrtPHUKxN0V/bbr9rWN4l/hIRZw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795509173;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=/ItIR3u3IAZKinHI/Kt2n31M5TXyRHqKKC1RLcMClSA=;
	b=Nu+ti3ABpSoSycZGEcVqy4xJ9HMGZZzWUC9nGMUqIiudj0QOP4nE/E1J+edpl+q48Pr8
	 DagpjyJ7hjnKCeIHxXLecgKoqja7I+rhOjkvhdHtNf7vaolDEGkenwexVaksKDCfdSpOF
	 OBB9KzEVtp7nNMDkNiS5swfrZscjJUNLfmErib0uo3prCRpJBDCrhQ3m7Dqnbqk358QZg
	 dgcw1+N2jfibxfMb4lCKnTuoIOHGcHx9EjFR/rpDdw3HtahIVUqG3azeh/132M75bQAzv
	 lkbaL2EVTMggulbhIW8eQjShsS/bC24UTRHns98dkUNmLc1Gp1fUvA+e34lB+jdDM+g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="c4h94k0/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB387606A32C;
	Tue, 24 Nov 2026 08:32:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=c4h94k0/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59C571F000EC;
	Tue, 24 Nov 2026 08:32:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795509173;
	bh=/ItIR3u3IAZKinHI/Kt2n31M5TXyRHqKKC1RLcMClSA=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=c4h94k0/VEqZ/yHQFGSXTeM0S+IS7lYAX9Vot+uQdwyzFkPhpmLIKLkqCKO5ULBt9
	 8CwCBXJS2UfcYjylaPYW/9ayBp0GYH6IRiKkkM10z/eBnZ6OfQ66WupUaO7eQobc2L
	 32Rrdy+BThZmlkqMs8Cr4RBviDvICxEdbKo2AkkQLEY/yhFBssbVRTcEXOCD4zZU8b
	 Jn/YiavN9jLZk+nCO/xK4K+7szupIi+ZzfiwdEpWX5Rnj8xvbBmOv8lNJD74VF+Yld
	 RjGmyXTP4XFjH2hNdibo5kZhuFI0rY6lnlABJkAnHPCoBHPacMsR5Ddjm1QBq4+Mqt
	 rwCH/d2hR17ZA==
Subject: Re: [PATCH net-next V2 4/5] net/mlx5e: Register eswitch-manager VF/SF
 self-port with switch-id
From: netdev-bot+sashiko@kernel.org
To: tariqt@nvidia.com
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com,
 agoldberger@nvidia.com, gal@nvidia.com, jgg@ziepe.ca, leon@kernel.org,
 linux-rdma@vger.kernel.org, mbloch@nvidia.com, moshe@nvidia.com,
 ohartoov@nvidia.com, saeedm@nvidia.com, shayd@nvidia.com
Date: Tue, 24 Nov 2026 08:32:51 +0000
Message-ID: <179550917191.3135.3268324102399128656@kernel.org>
In-Reply-To: <20261120075959.2533702-5-tariqt@nvidia.com>
References: <20261120075959.2533702-5-tariqt@nvidia.com>
X-sashiko-severity: Low
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

Thank you for your contribution! Sashiko AI review found more severe
issue(s) in other patches of this series. This mail is only an FYI, in case
you want to address the nit picks below when you respin.

Low priority / nit picks for your consideration:

- [Low] In mlx5e_devlink_port_register()
  (drivers/net/ethernet/mellanox/mlx5/core/en/devlink.c, new lines…
- [Low] The commit message says the self-port 'was always registered with
  DEVLINK_PORT_FLAVOUR_VIRTUAL, which doesn't carries switch_id' (also a…

--

net/mlx5e: Register eswitch-manager VF/SF self-port with switch-id

This patch makes a non-PF function (VF or SF) that is an eswitch manager
register its self-port with a switch_id. The switch_id comes from the SW
system image GUID. As a result, the uplink netdev reports a
phys_switch_id and can be grouped with the representors it manages.

> A non-PF function's self-port (its own uplink netdev) was always
> registered with DEVLINK_PORT_FLAVOUR_VIRTUAL, which doesn't carries
> switch_id.

[Severity: Low]
Is this description accurate? In net/devlink/port.c, switch_port depends
only on whether a switch_id was supplied. The port flavour plays no part:

net/devlink/port.c:__devlink_port_attrs_set() {
    ...
	if (attrs->switch_id.id_len) {
		devlink_port->switch_port = true;
		...
	} else {
		devlink_port->switch_port = false;
	}
}

devlink_compat_switch_id_get() checks only switch_port. A VIRTUAL port
can carry a switch_id, and this patch relies on that: it keeps
DEVLINK_PORT_FLAVOUR_VIRTUAL and only fills attrs.switch_id.

The phys_switch_id was missing because mlx5e_devlink_port_register()
never filled attrs.switch_id for non-PF functions. The flavour was not
the cause.

The message also mentions only grouping with representors. Could it say
that the uplink netdev now passes netdev_port_same_parent_id() checks it
used to fail? Examples are tc_act_can_offload_mirred(),
tc_act_parse_mirred() and the check in en/tc_tun.c.

There is also a grammar slip: "doesn't carries" should be
"doesn't carry".

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/en/devlink.c
> index 8818f65d1fbc4..79adb1ecc4506 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/devlink.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/devlink.c
> @@ -63,6 +63,11 @@ int mlx5e_devlink_port_register(struct mlx5e_dev *mlx5e_dev,
>  		dl_port_index = mlx5_esw_vport_to_devlink_port_index(mdev,
>  								     MLX5_VPORT_UPLINK);
>  	} else {
> +		if (MLX5_ESWITCH_MANAGER(mdev)) {
> +			mlx5e_devlink_get_port_parent_id(mdev, &ppid);
> +			memcpy(attrs.switch_id.id, ppid.id, ppid.id_len);
> +			attrs.switch_id.id_len = ppid.id_len;
> +		}

[Severity: Low]
Is this switch_id unique to the nested eswitch? The value comes from
mlx5_query_nic_sw_system_image_guid(). That is the device-wide FW GUID
followed by capability-only bytes, with trailing zero bytes trimmed:

drivers/net/ethernet/mellanox/mlx5/core/vport.c:
static u8 mlx5_sw_guid_sf(const struct mlx5_core_dev *mdev)
{
	return mlx5_core_is_sf(mdev) && mlx5_virt_lag_is_supported(mdev);
}

static u8 mlx5_sw_guid_vf(const struct mlx5_core_dev *mdev)
{
	return mlx5_core_is_vf(mdev) && mlx5_virt_lag_is_supported(mdev);
}

mlx5_query_nic_sw_system_image_guid() {
    ...
	for (i = 0; i < ARRAY_SIZE(mlx5_sw_guid_fields); i++) {
		u8 val = mlx5_sw_guid_fields[i](mdev);

		buf[(*len)++] = val;
		if (val)
			trim_len = *len;
	}

	*len = trim_len;
}

Commit c25049685e16 ("Distinguish VFs/SFs in the SW system image
GUID...") says a PF and its VFs/SFs share the same FW system image GUID.
It also says a VF/SF that cannot join a virt LAG "keeps its current key
and is still identified as the same HW as its PF". This leads to two
cases.

In the first case, a VF/SF eswitch manager lacks the virt-LAG caps
(multi_uplink_eswitch, lag_master, num_lag_ports < 2). It then gets
exactly the PF's switch_id. The PF uplink carries that same ID, and so
do the PF-eswitch PCI_VF/PCI_SF representors set up by
mlx5_esw_offloads_pf_vf_devlink_port_attrs_set(), including the
representor of this VF/SF itself.

In the second case, every virt-LAG-capable VF (or SF) eswitch manager on
one HCA gets the same ID, whether or not they share an FDB. That
includes a standalone late joiner that mlx5_esw_offloads_devcom_init()
refuses to pair.

After this patch, devlink_compat_switch_id_get() reports this ID as the
phys_switch_id of the VF/SF uplink netdev.
Documentation/networking/switchdev.rst says the switch ID must be unique
between switches on the same system.

The nested-eswitch representors already used this ID before the patch,
and the PF uplinks of one HCA already share a switch_id. The in-kernel
mlx5 TC forwarding path re-checks the real eswitch/LAG relationship in
mlx5e_is_valid_eswitch_fwd_dev(). What changes is that the uplink netdev
itself now reports the colliding ID.

Should this check also require mlx5_virt_lag_is_supported(), or the
nested-eswitch condition used elsewhere in the series, rather than only
MLX5_ESWITCH_MANAGER(mdev)? If not, should the limitation be documented?

>  		attrs.flavour = DEVLINK_PORT_FLAVOUR_VIRTUAL;
>  		dl_port_index = mlx5_esw_vport_to_devlink_port_index(mdev, 0);
>  	}

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261120075959.2533702-1-tariqt%40nvidia.com
