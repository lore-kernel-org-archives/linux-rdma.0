Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795728089;
	b=JoZFwlN85DgHz+kXQiXiR9lrpPrdZYAT70EiBte/RfMet1QOIZd1GCsed19HgI8L/fGV
	 SspPb5YysDUNjSaUxd4/1pBaPpuDq2SnXxO0qQX4hQLn+TBLNiVkmI47571qhqlsv4MLf
	 5gas/7JlUnSUfB2POu6APIcoduHy3zuSh7TaNkC4IKjBrytUOBBRejL1me1r93bq4PqY8
	 3oJcrF+kgHGDLVJE60C+ZtbNWRGKFKkml/Vot/S9Oqi9TLGg9E/a27dSmZ+0oPz1mrWLa
	 UEB1wHGESUXxoHfSKs/5zvRfhzDn6b54HzR0+1DPbI1dt88iKvmSYbalQokgZE3NGLw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795728089;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=CMLBS/cMKqlFRI7i8QNnRjnqpyCA6iH5e1dDgTgYxK0=;
	b=lwvRln1sQ97PVHYIw+08l/K2E2Kdz5n22gF+wHEfCB1LJlbGIK5F1Br/QfkY32LWdTbi
	 7HANqqGjm8T4lIjmFhKkl9JR+EotJFbT/7Z3beL5wMaQq1qGHcKVcjJYyeKjLEv9polg+
	 B8/3cFnJerkHNDINJ6Lb+OK+68ehpH/JIvHyhaGXjxvAEBYN+/qDNdcNNtWxT+PEqfysT
	 nrURC/UjUuvuENzfkqKRrGPOE2SJAOjXjlW3YHwCz056Owiqyc4QRnSdL73f7ozQZnwiK
	 4NIVXBXMcDsyw7HFRr3NeXrg8xGeckSdP7+Y38syK7cy7EGud8hqJZVU7dUU1hgBDGQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HeCYqEPE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DD95606A31C
	for <linux-rdma@vger.kernel.org>; Thu, 26 Nov 2026 21:21:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HeCYqEPE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5C331F00893;
	Thu, 26 Nov 2026 21:21:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795728088;
	bh=CMLBS/cMKqlFRI7i8QNnRjnqpyCA6iH5e1dDgTgYxK0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=HeCYqEPEBbnSjkU7eVfoZhEG5Sktb8Obn/to/4XFadxdbyw+eCBXPZXfePD0V+FSr
	 QHwBDHGgb6lLMRRF9YbGqXmZ+dTCQYC83QY8io5k8l5kKfkkcFXY4xv4T5VFenJO5I
	 GWp6X9BvbhGXNrlE7LVPdfw2Tf+mQNzLOzdLb2DHkP3s89FpDypb+kTg8KCtrp3Sxy
	 tpcw/g8mT40VY+QwgmWucpn1UVt/62cTlAlaKyUeIvlXIwqrDW9Pi/RMSmWlJH0hRs
	 pXZmNsVbDlBvfdlHm1BaatEKZ1Jf3fVvjCpRpWlMs2zLCQc9d7Po2TXtqJU/Rh6+EF
	 4QNOqvaF2WEGA==
Message-ID: <sashiko-outbox-236228@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next 2/2] net/mlx5: Add controller number for SF and
 ECVF phys_port_name
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261125212032.243064-3-tariqt@nvidia.com>
References: <20261125212032.243064-1-tariqt@nvidia.com>
 <20261125212032.243064-3-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 26 Nov 2026 21:21:26 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 5 potential
issues to consider:
- [Medium] net/mlx5: local SF state reset in
  mlx5_sf_table_esw_changed_event_handler()
- [Medium] net/mlx5: controller_num check in
  mlx5_esw_sf_controller_to_pfnum_valid()
- [Medium] net/mlx5: ECVF attrs read phys_port_cnum before
  mlx5_self_controller_set()
- [Medium] net/mlx5: unlocked phys_port_cnum race in
  mlx5_devlink_sf_port_new()
- [Medium] net/mlx5: wrong master and reset in
  mlx5_self_controller_set() for SD bond
It also noticed 1 related pre-existing issue this patch does not
introduce:
- [High] net/mlx5: LAG, NULL pointer dereference in
  mlx5_mpesw_restore_sd_fdb() [1]
--

commit 9a9846fea956014d36adcb9c4f97568dd6087252
Author: Chris Mi <cmi@nvidia.com>

net/mlx5: Add controller number for SF and ECVF phys_port_name

This commit assigns a controller number derived from QUERY_ESW_FUNCTIONS
to non-master PCI link devices in a shared-FDB topology so that their SF
and ECVF representors receive a unique controller prefix in
phys_port_name.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/devlink_port.c b=
/drivers/net/ethernet/mellanox/mlx5/core/esw/devlink_port.c
> index 8b46634203b37..fa07a571c1b99 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/esw/devlink_port.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/devlink_port.c
> @@ -83,7 +83,9 @@ static void mlx5_esw_offloads_pf_vf_devlink_port_attrs_=
set(struct mlx5_eswitch *
> =20
>  		memcpy(dl_port->attrs.switch_id.id, ppid.id, ppid.id_len);
>  		dl_port->attrs.switch_id.id_len =3D ppid.id_len;
> -		devlink_port_attrs_pci_vf_set(dl_port, 0, pfnum,
> +		controller_num =3D mlx5_esw_get_self_pf_ctrl_num(esw);
> +		pfnum =3D mlx5_esw_get_self_pf_pfnum(esw);
> +		devlink_port_attrs_pci_vf_set(dl_port, controller_num, pfnum,
>  					      vport_num - base_vport, false);
>  	} else if (mlx5_esw_is_spf_vport(esw, vport_num)) {
>  		int spf_idx =3D mlx5_esw_spf_vport_to_idx(esw, vport_num);

[Severity: Medium]
Isn't esw->esw_funcs.phys_port_cnum still 0 when ECVF devlink ports are
registered during eswitch mode transition?

In mlx5_devlink_eswitch_mode_set(), esw_offloads_start() loads and
registers existing ECVF vports before mlx5_sd_eswitch_mode_set() ->
mlx5_lag_shared_fdb_create() -> mlx5_self_controller_set() populates
phys_port_cnum.  The same ordering happens if ECVFs are enabled on a
non-master PCI link before its peer PF enters switchdev mode: the ECVF
devlink ports snapshot controller_num =3D 0 and never get the c<N> prefix in
phys_port_name once shared FDB is created.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/=
net/ethernet/mellanox/mlx5/core/eswitch.c
> index 8c2c55ba5c35e..09a29280c48e3 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
> @@ -2183,21 +2183,58 @@ u16 mlx5_esw_get_hpf_pf_num(struct mlx5_core_dev =
*dev)
>  	return PCI_FUNC(dev->pdev->devfn);
>  }
> =20
> -u16 mlx5_esw_sf_controller_to_pfnum(struct mlx5_core_dev *dev, u32 contr=
oller)
> +u32 mlx5_esw_get_self_pf_ctrl_num(struct mlx5_eswitch *esw)
> +{
> +	struct mlx5_esw_functions *esw_funcs =3D &esw->esw_funcs;
> +
> +	return esw_funcs->phys_port_cnum;
> +}
> +
> +u16 mlx5_esw_get_self_pf_pfnum(struct mlx5_eswitch *esw)
> +{
> +	struct mlx5_core_dev *dev =3D esw->dev;
> +
> +	if (mlx5_core_is_ecpf_esw_manager(dev) &&
> +	    MLX5_CAP_GEN(dev, query_host_net_function_v1))
> +		return esw->esw_funcs.self_pf_pfnum;
> +
> +	return PCI_FUNC(dev->pdev->devfn);
> +}
> +
> +bool mlx5_esw_sf_controller_to_pfnum_valid(struct mlx5_core_dev *dev,
> +					   u32 controller, u32 pfnum)
>  {
>  	struct mlx5_eswitch *esw =3D dev->priv.eswitch;
>  	struct mlx5_esw_functions *esw_funcs;
> +	bool known_controller =3D false;
>  	int i;
> =20
> -	if (!controller)
> -		return PCI_FUNC(dev->pdev->devfn);
> +	if (!MLX5_CAP_GEN(dev, query_host_net_function_v1))
> +		return pfnum =3D=3D PCI_FUNC(dev->pdev->devfn);
> =20
>  	esw_funcs =3D &esw->esw_funcs;
> -	for (i =3D 0; i < esw_funcs->num_spfs; i++)
> -		if (controller =3D=3D esw_funcs->spfs[i].host_number + 1)
> -			return esw_funcs->spfs[i].pf_num;
> +	if (!controller || controller =3D=3D esw_funcs->controller_num) {
> +		known_controller =3D true;
> +		if (mlx5_esw_get_self_pf_pfnum(esw) =3D=3D pfnum)
> +			return true;
> +	}

[Severity: Medium]
Should this check controller =3D=3D esw_funcs->phys_port_cnum instead of
esw_funcs->controller_num?

mlx5_esw_self_pf_init() sets esw_funcs->controller_num to host_number + 1
on all PFs, including the master PCI link where phys_port_cnum is 0.
When a satellite PF shares the same host_number as the master self PF,
mlx5_esw_offloads_controller_valid() also accepts that controller number
via its spfs[] loop and mlx5_sf_controller_to_hwc() maps it to
MLX5_SF_HWC_LOCAL.  A user on the master PCI link can then create a local
self-PF SF with a non-zero controller number and a c<N> prefix even though
phys_port_cnum is 0.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/shared_fdb.c b/d=
rivers/net/ethernet/mellanox/mlx5/core/lag/shared_fdb.c
> index 404278a15ef73..fb96e9c3a5d84 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/lag/shared_fdb.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/shared_fdb.c
> @@ -190,6 +190,44 @@ void mlx5_lag_destroy_single_fdb(struct mlx5_lag *ld=
ev)
>  	mlx5_lag_destroy_single_fdb_filter(ldev, MLX5_LAG_FILTER_ALL);
>  }
> =20
> +static void mlx5_self_controller_set(struct mlx5_lag *ldev, u32 filter)
> +{
> +	struct mlx5_core_dev *dev, *master_dev =3D NULL;
> +	struct mlx5_esw_functions *esw_funcs;
> +	struct mlx5_eswitch *esw;
> +	int i;
> +
> +	mlx5_lag_for_each(i, 0, ldev, filter) {
> +		dev =3D mlx5_lag_fn(ldev, i)->dev;
> +		esw =3D dev->priv.eswitch;
> +		esw_funcs =3D &esw->esw_funcs;
> +		if (!mlx5_lag_is_master(dev))
> +			esw_funcs->phys_port_cnum =3D esw_funcs->controller_num;
> +		else
> +			master_dev =3D dev;
> +	}

[Severity: Medium]
Does mlx5_lag_is_master(dev) pick the wrong master here when a bond is
created over a Socket-Direct device?

When per-group SD shared FDBs are active (fn->sd_fdb_active is true) and a
bond is created with filter =3D=3D MLX5_LAG_FILTER_ALL, mlx5_lag_is_master()
queries mlx5_lag_get_filter(ldev, dev), which returns fn->group_id instead
of MLX5_LAG_FILTER_ALL.  Every SD group's primary PF therefore returns
true from mlx5_lag_is_master(), overwriting master_dev with the last SD
group's primary PF and clearing phys_port_cnum to 0 on that group's
controller instead of on the overall LAG master dev0.

> @@ -257,6 +295,9 @@ int mlx5_lag_shared_fdb_create(struct mlx5_lag *ldev,
> =20
>  	if (filter =3D=3D MLX5_LAG_FILTER_PORTS || filter =3D=3D MLX5_LAG_FILTE=
R_ALL)
>  		mlx5_lag_set_vports_agg_speed(ldev);
> +
> +	mlx5_self_controller_set(ldev, filter);
> +
>  	return 0;

[Severity: High]
This problem wasn't introduced by this patch, but can
mlx5_lag_shared_fdb_create() trigger a NULL pointer dereference [1]
when called from mlx5_mpesw_restore_sd_fdb()?

If one port on a multi-port Socket-Direct device has been unbound
(clearing its fn->group_id to 0 in sd_lag_cleanup()) while another port
still has a non-zero group_id, mlx5_mpesw_restore_sd_fdb() iterates over
all functions and calls mlx5_lag_shared_fdb_create(ldev, NULL, 0, 0) for
the unbound port.  A zero group_id sets filter to MLX5_LAG_FILTER_ALL and
calls mlx5_activate_lag(ldev, NULL, 0, true) ->
mlx5_infer_tx_affinity_mapping(), which dereferences the NULL tracker
pointer.

> @@ -277,6 +318,21 @@ int mlx5_lag_shared_fdb_create(struct mlx5_lag *ldev,
>  	return err;
>  }
> =20
> +static void mlx5_self_controller_reset(struct mlx5_lag *ldev, u32 filter)
> +{
> +	struct mlx5_esw_functions *esw_funcs;
> +	struct mlx5_core_dev *dev;
> +	struct mlx5_eswitch *esw;
> +	int i;
> +
> +	mlx5_lag_for_each(i, 0, ldev, filter) {
> +		dev =3D mlx5_lag_fn(ldev, i)->dev;
> +		esw =3D dev->priv.eswitch;
> +		esw_funcs =3D &esw->esw_funcs;
> +		esw_funcs->phys_port_cnum =3D 0;
> +	}
> +}
> +
>  void mlx5_lag_shared_fdb_destroy(struct mlx5_lag *ldev, u32 group_id)
>  {
>  	u32 filter =3D group_id ? group_id : MLX5_LAG_FILTER_ALL;
> @@ -284,6 +340,8 @@ void mlx5_lag_shared_fdb_destroy(struct mlx5_lag *lde=
v, u32 group_id)
>  	int err;
>  	int i;
> =20
> +	mlx5_self_controller_reset(ldev, filter);
> +
>  	mlx5_lag_remove_devices_filter(ldev, filter);
> =20
>  	if (filter =3D=3D MLX5_LAG_FILTER_PORTS || filter =3D=3D MLX5_LAG_FILTE=
R_ALL) {

[Severity: Medium]
When a bond over a Socket-Direct device is destroyed with group_id =3D=3D 0
(filter =3D=3D MLX5_LAG_FILTER_ALL), doesn't mlx5_self_controller_reset() w=
ipe
phys_port_cnum to 0 across all SD groups even though the per-group SD
shared FDBs remain active?  In addition, if mlx5_deactivate_lag() fails
and returns early just below, phys_port_cnum has already been cleared to 0
while the shared-FDB LAG is still active.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sf/devlink.c b/drive=
rs/net/ethernet/mellanox/mlx5/core/sf/devlink.c
> index 2002b7f376ee6..c8aa1b0b9319d 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/sf/devlink.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/sf/devlink.c
> @@ -237,6 +237,18 @@ int mlx5_devlink_sf_port_fn_state_set(struct devlink=
_port *dl_port,
>  	return mlx5_sf_state_set(dev, table, sf, state, extack);
>  }
> =20
> +static u32
> +mlx5_sf_get_self_controller(struct mlx5_eswitch *esw,
> +			    const struct devlink_port_new_attrs *new_attr)
> +{
> +	struct mlx5_esw_functions *esw_funcs =3D &esw->esw_funcs;
> +
> +	if (!new_attr->controller_valid && esw_funcs->phys_port_cnum)
> +		return esw_funcs->phys_port_cnum;
> +
> +	return new_attr->controller;
> +}
> +
>  static int mlx5_sf_add(struct mlx5_core_dev *dev, struct mlx5_sf_table *=
table,
>  		       const struct devlink_port_new_attrs *new_attr,
>  		       struct netlink_ext_ack *extack,
> @@ -244,9 +256,11 @@ static int mlx5_sf_add(struct mlx5_core_dev *dev, st=
ruct mlx5_sf_table *table,
>  {
>  	struct mlx5_eswitch *esw =3D dev->priv.eswitch;
>  	struct mlx5_sf *sf;
> +	u32 controller;
>  	int err;
> =20
> -	sf =3D mlx5_sf_alloc(table, esw, new_attr->controller, new_attr->pfnum,
> +	controller =3D mlx5_sf_get_self_controller(esw, new_attr);
> +	sf =3D mlx5_sf_alloc(table, esw, controller, new_attr->pfnum,
>  			   new_attr->sfnum, extack);

[Severity: Medium]
Does storing a non-zero controller in sf->controller for local SFs on a
non-master PCI link cause mlx5_sf_table_esw_changed_event_handler() to
corrupt their sf->hw_state when the external host PF is disabled?

When an ESW_FUNCTIONS_CHANGED event arrives with host_pf_info.pf_disabled
set, mlx5_sf_table_esw_changed_event_handler() only skips SFs with
!sf->controller:

drivers/net/ethernet/mellanox/mlx5/core/sf/devlink.c:mlx5_sf_table_esw_chan=
ged_event_handler() {
	...
	xa_for_each(&table->function_ids, index, sf) {
		if (!sf->controller)
			continue;

		if (sf->hw_state =3D=3D MLX5_VHCA_STATE_IN_USE)
			sf->hw_state =3D MLX5_VHCA_STATE_ACTIVE;
		else if (sf->hw_state =3D=3D MLX5_VHCA_STATE_TEARDOWN_REQUEST)
			sf->hw_state =3D MLX5_VHCA_STATE_ALLOCATED;
	...
}

Because local self-PF SFs on the non-master PCI link now have a non-zero
sf->controller, a host PF reboot or driver unbind resets their
sf->hw_state.  If a local SF is in MLX5_VHCA_STATE_TEARDOWN_REQUEST and is
then deleted via mlx5_sf_dealloc(), seeing MLX5_VHCA_STATE_ALLOCATED causes
it to call mlx5_sf_free() -> mlx5_cmd_dealloc_sf() immediately instead of
mlx5_sf_hw_table_sf_deferred_free() while the local SF driver is still
detaching.

[ ... ]

> @@ -295,9 +311,16 @@ mlx5_sf_new_check_attr(struct mlx5_core_dev *dev, co=
nst struct devlink_port_new_
>  		NL_SET_ERR_MSG_MOD(extack, "External controller is unsupported");
>  		return -EOPNOTSUPP;
>  	}
> +	esw =3D dev->priv.eswitch;
> +	esw_funcs =3D &esw->esw_funcs;
> +	if (new_attr->controller_valid && !new_attr->controller &&
> +	    esw_funcs->phys_port_cnum) {
> +		NL_SET_ERR_MSG_MOD(extack, "Invalid controller supplied");
> +		return -EOPNOTSUPP;
> +	}

[Severity: Medium]
Can concurrent shared-FDB creation or teardown race with
mlx5_devlink_sf_port_new() on esw_funcs->phys_port_cnum?

mlx5_self_controller_set() and mlx5_self_controller_reset() update
esw_funcs->phys_port_cnum on non-master PCI functions under ldev->lock
(from ldev->wq or a peer PF's mode change) without holding the non-master
function's devlink lock, while mlx5_devlink_sf_port_new() reads
phys_port_cnum three times without ldev->lock:

CPU0 (non-master devl_lock)       CPU1 (ldev->lock)
mlx5_devlink_sf_port_new()
  mlx5_sf_new_check_attr()
    /* phys_port_cnum =3D=3D 4 */
  mlx5_sf_add()
    mlx5_sf_get_self_controller()
      controller =3D 4
                                  mlx5_lag_shared_fdb_destroy()
                                    mlx5_self_controller_reset()
                                      esw_funcs->phys_port_cnum =3D 0
    mlx5_sf_alloc(..., 4, ...)
      mlx5_esw_offloads_controller_valid(esw, 4)
        --> false (-EINVAL)

If the user omitted the controller attribute, the driver's own selected
controller number is rejected with -EINVAL; in the reverse direction, if
mlx5_self_controller_set() runs after mlx5_sf_new_check_attr() allows an
explicit controller 0, the SF is created with controller 0 while shared
FDB is active.

[1] https://sashiko.dev/#/bug/linux-8703abcc-6916-44c4-b3c7-fe51c61aab5f

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261125212032.2430=
64-1-tariqt@nvidia.com?part=3D2
