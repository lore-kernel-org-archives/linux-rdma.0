Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795731016;
	b=Bv0KtJPZWknzdKFpX8nBLe6QkIMzcPp3sP8ZNUh6hg5Wc70eY3aqgpVG6mAFFvW/+YVn
	 hcx1lDZoqKw6ByDSCL0oelRfx9LEiOGbU+3V+nqHZ/9AJqynHaZbP3TOnYP0fr9i13Tv5
	 U5qIo3hNnIEIociwiYg1PJ3kpxon0YVHvqE5FNM/a/J6FDAYV45ym5j0e7jAN5dpRQwzg
	 FbEp/fjJQvOg2JKR2RwVG7L4A2HqMnq+qJ9YnMSAT2ikYLeT6g6ERDr3aj1e2I2yip+dF
	 zmE4ms4pZhZVYs1+R0rye01YnJPndQ6aNnuipQcVIHZy+apTNJKwOBQv+TEDzQyC26Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795731016;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=XXGep82Zdw9pDfzZhrZHSfxim7KEgQkccoa4MLC4KXg=;
	b=Ojku98wNwcPFUsJ1nXKQL6Ug2bVF8pBbbhor1J4GLDT7XLuJnVHWr9+qaPT4cDUYnr+8
	 hwcolVX1BMsNKPK6pDicHZ8lHSAr3uda/+H+nsOovaa1xtwvlLvKCmyXcjnK8LFPo/UwB
	 1mr1YXEv/R0aNwk/Iv7/Xf/VQy3yr2a/p1mfT0+4DK8F4fuXRdoTuOGk0cOitKZP+FUYg
	 Lt3lvZ4DmXQ7p1K82pUuxGYBWhP5d5E/97FXOlZuRtIsPQX9QV5/1ubdRc028c2T+wOSg
	 Qmts2CexQAxX+7JzMfRxG6E7mEykH/EOJALRvsLxAGTGQFPBvny1m8MWxhZmyxJw8zw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=e9wy9LkY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 949A8606A31E;
	Thu, 26 Nov 2026 22:10:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=e9wy9LkY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BA4B1F000C1;
	Thu, 26 Nov 2026 22:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795731016;
	bh=XXGep82Zdw9pDfzZhrZHSfxim7KEgQkccoa4MLC4KXg=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=e9wy9LkYVjdJtnSeFD2icGT5SmcQt+sSCbrTbGMrQuPX7YMhgs6qFfMH7tZeT/ELo
	 sXqcs1dAAUgsmxMwJaqicd5b+wNR9xHMs5RYu0z2iLWdC7ln2kKJNGtp07d6rrNBCs
	 Y8oU3YTI3uKzWCXKx3KKTQeecd0EucsiT6xJbGnIriaClB4nc2kwBtWhCv3W+XjYeN
	 hSELLBX4DjW/1xQBoOxB9EU+pDzZOaCaDsWlYQDNkTDsu2KhhnZNcFqDz/9dSwjngj
	 N4k2Uhku8zmwt3yvINYTiZkEdN5NU+Z7P+U+pDksG0zJhjPlZMf/cB39jEQPWfFUu7
	 +bFD6+qNR7H/A==
Subject: Re: [PATCH net-next 2/2] net/mlx5: Add controller number for SF and
 ECVF phys_port_name
From: netdev-bot+sashiko@kernel.org
To: tariqt@nvidia.com
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com,
 cjubran@nvidia.com, cmi@nvidia.com, gal@nvidia.com, kees+treewide@kernel.org,
 leon@kernel.org, linux-rdma@vger.kernel.org, mbloch@nvidia.com,
 moshe@nvidia.com, ohartoov@nvidia.com, parav@nvidia.com, saeedm@nvidia.com,
 shayd@nvidia.com
Date: Thu, 26 Nov 2026 22:10:14 +0000
Message-ID: <179573101472.3135.6016882066220406695@kernel.org>
In-Reply-To: <20261125212032.243064-3-tariqt@nvidia.com>
References: <20261125212032.243064-3-tariqt@nvidia.com>
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

Thank you for your contribution! Sashiko AI review found 6 potential
issue(s) to consider.

Critical: 0 · High: 1 · Medium: 5 · Low: 0

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] The controller prefix only reaches devlink ports created while
  the shared FDB is active, so phys_port_names can still collide.
- [Medium] The SF-add validators disagree on what the 'self controller'
  is.
- [Medium] Local SFs on the non-master link now carry a non-zero
  sf->controller (phys_port_cnum, via mlx5_sf_get_self_controller() ->…
- [Medium] Nothing serialises esw_funcs->phys_port_cnum between its
  writers and the devlink SF port_new readers.
- [Medium] mlx5_esw_sf_controller_to_pfnum_valid() now accepts any
  satellite PF whose (host_number+1, pf_num) matches the request.
- [Medium] The patch gives the self PF controller_num = QUERY_PF
  host_number + 1.

--

net/mlx5: Add controller number for SF and ECVF phys_port_name

This commit gives the non-master PCI link in a BlueField-4 Socket-Direct
shared FDB a non-zero controller number (QUERY_PF host_number + 1). SFs
and EC VFs on that link then get a cN prefix in phys_port_name. It tracks
the self PF controller and pfnum in the eswitch, sets and resets
phys_port_cnum on shared FDB create and destroy, and updates SF
validation and hwc table selection.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/devlink_port.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/devlink_port.c
> index 8b46634203b37..fa07a571c1b99 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/esw/devlink_port.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/devlink_port.c
> @@ -83,7 +83,9 @@ static void mlx5_esw_offloads_pf_vf_devlink_port_attrs_set(struct mlx5_eswitch *
>  
>  		memcpy(dl_port->attrs.switch_id.id, ppid.id, ppid.id_len);
>  		dl_port->attrs.switch_id.id_len = ppid.id_len;
> -		devlink_port_attrs_pci_vf_set(dl_port, 0, pfnum,
> +		controller_num = mlx5_esw_get_self_pf_ctrl_num(esw);
> +		pfnum = mlx5_esw_get_self_pf_pfnum(esw);
> +		devlink_port_attrs_pci_vf_set(dl_port, controller_num, pfnum,
>  					      vport_num - base_vport, false);

[Severity: High]
Are these attrs ever refreshed after phys_port_cnum changes?

mlx5_esw_get_self_pf_ctrl_num() reads phys_port_cnum here only once, when
the EC VF vport is loaded. Only mlx5_self_controller_set() sets
phys_port_cnum, and it runs as the last step of
mlx5_lag_shared_fdb_create().

In the SD flow, mlx5_devlink_eswitch_mode_set() runs esw_offloads_start()
first:

esw_offloads_start()
  mlx5_eswitch_enable_pf_vf_vports()
    mlx5_eswitch_load_ec_vf_vports()
      mlx5_eswitch_load_pf_vf_vport()
        mlx5_esw_offloads_init_pf_vf_rep()
          mlx5_esw_offloads_pf_vf_devlink_port_attrs_set()

Only after that does it run:

mlx5_sd_eswitch_mode_set()
  mlx5_sd_activate_shared_fdb()
    mlx5_lag_shared_fdb_create()
      mlx5_self_controller_set()

The later rep reload paths (mlx5_eswitch_reload_reps_blocked() and the IB
rep reload) reuse the existing vport->dl_port, so the attrs keep
controller 0.

Would EC VFs that exist at switchdev entry still be named pf0vf0 and
collide with the master's ports? The same question applies to SFs added
through mlx5_sf_get_self_controller() before the shared FDB exists, which
would still be named pf0sf0.

In the other direction, mlx5_self_controller_reset() clears phys_port_cnum
on destroy. Ports that are already registered keep the cN prefix, while
new ones get none. Does phys_port_name then depend on the order of
operations?

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
> index 8c2c55ba5c35e..09a29280c48e3 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c

[ ... ]

> +bool mlx5_esw_sf_controller_to_pfnum_valid(struct mlx5_core_dev *dev,
> +					   u32 controller, u32 pfnum)
>  {
>  	struct mlx5_eswitch *esw = dev->priv.eswitch;
>  	struct mlx5_esw_functions *esw_funcs;
> +	bool known_controller = false;
>  	int i;
>  
> -	if (!controller)
> -		return PCI_FUNC(dev->pdev->devfn);
> +	if (!MLX5_CAP_GEN(dev, query_host_net_function_v1))
> +		return pfnum == PCI_FUNC(dev->pdev->devfn);
>  
>  	esw_funcs = &esw->esw_funcs;
> -	for (i = 0; i < esw_funcs->num_spfs; i++)
> -		if (controller == esw_funcs->spfs[i].host_number + 1)
> -			return esw_funcs->spfs[i].pf_num;
> +	if (!controller || controller == esw_funcs->controller_num) {
> +		known_controller = true;
> +		if (mlx5_esw_get_self_pf_pfnum(esw) == pfnum)
> +			return true;
> +	}

[Severity: Medium]
Does this check agree with mlx5_esw_offloads_controller_valid()?

This function accepts controller_num with the self pfnum on every device,
whatever the LAG or master state. mlx5_sf_controller_to_hwc() also maps
(controller_num, self pfnum) to hwc[MLX5_SF_HWC_LOCAL] on any device.

mlx5_esw_offloads_controller_valid(), however, accepts the self controller
only when it equals a non-zero phys_port_cnum.

mlx5_sf_new_check_attr() rejects an explicit controller 0 when
phys_port_cnum is set. It has no matching rejection of an explicit
controller_num when phys_port_cnum is 0, which is the case on the master,
on a standalone device, or after mlx5_lag_shared_fdb_destroy().

On such a device, "devlink port add ... pfnum <self> controller
<controller_num>" passes mlx5_sf_new_check_attr() and this function. After
that, it either fails in mlx5_sf_alloc() with "Invalid controller number",
or it succeeds if an SPF shares that host_number.

In the success case, would a local SF taken from the LOCAL hwc be labelled
cNpfXsfY on the master?

The commit message says:

    But if user specifies other controller number, command fails.

Does that still hold for this case?

The "Local controller is always valid" comment in
mlx5_esw_offloads_controller_valid() also looks stale now, because an
explicit controller 0 is rejected earlier when phys_port_cnum is set.

[ ... ]

> +static int mlx5_esw_self_pf_init(struct mlx5_eswitch *esw)
> +{
> +	struct mlx5_esw_functions *esw_funcs = &esw->esw_funcs;
> +	struct mlx5_core_dev *dev = esw->dev;

[ ... ]

> +	entry = MLX5_ADDR_OF(query_esw_functions_out, out, net_function_params);
> +	for (i = 0; i < num_entries; i++) {
> +		int pf_type;
> +
> +		pf_type = MLX5_GET(network_function_params, entry, pci_pf_type);
> +		if (pf_type != MLX5_PCI_PF_TYPE_QUERY_PF) {
> +			entry += MLX5_UN_SZ_BYTES(net_function_params);
> +			continue;
> +		}
> +
> +		esw_funcs->controller_num =
> +			MLX5_GET(network_function_params,
> +				 entry, host_number) + 1;
> +		esw_funcs->self_pf_pfnum =
> +			MLX5_GET(network_function_params,
> +				 entry, pci_device_function);

[Severity: Medium]
Is pci_device_function enough to tell the self PF apart from a satellite
PF?

The commit message says the self PF and the satellite PFs share a
controller number, so self_pf_pfnum is the only tie-breaker. Neither this
function nor mlx5_esw_spfs_init() records pci_bus from
network_function_params, and pci_device_function is only unique per bus.

Suppose a self PF and an SPF of the same host both report function 0 on
different buses, like 0002:01:00.0 and 0006:01:00.0 in the commit example.
mlx5_sf_controller_to_hwc() would then return hwc[MLX5_SF_HWC_LOCAL]
before it scans the SPF tables. mlx5_esw_sf_controller_to_pfnum_valid()
would also accept the request as a self PF SF before it checks the SPFs.

Would an SF requested on the SPF then be allocated from the self PF's
function ID range via mlx5_sf_sw_to_hw_id()? If so, the SPF's hwc table
could not be reached for that controller/pfnum pair.

[ ... ]

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/shared_fdb.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/shared_fdb.c
> index 404278a15ef73..fb96e9c3a5d84 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/lag/shared_fdb.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/shared_fdb.c
> @@ -190,6 +190,44 @@ void mlx5_lag_destroy_single_fdb(struct mlx5_lag *ldev)
>  	mlx5_lag_destroy_single_fdb_filter(ldev, MLX5_LAG_FILTER_ALL);
>  }
>  
> +static void mlx5_self_controller_set(struct mlx5_lag *ldev, u32 filter)
> +{
> +	struct mlx5_core_dev *dev, *master_dev = NULL;
> +	struct mlx5_esw_functions *esw_funcs;
> +	struct mlx5_eswitch *esw;
> +	int i;
> +
> +	mlx5_lag_for_each(i, 0, ldev, filter) {
> +		dev = mlx5_lag_fn(ldev, i)->dev;
> +		esw = dev->priv.eswitch;
> +		esw_funcs = &esw->esw_funcs;
> +		if (!mlx5_lag_is_master(dev))
> +			esw_funcs->phys_port_cnum = esw_funcs->controller_num;
> +		else
> +			master_dev = dev;
> +	}
> +
> +	if (!master_dev)
> +		return;
> +
> +	mlx5_lag_for_each(i, 0, ldev, filter) {

[ ... ]

> +		if (host_ctrl_num == master_host_ctrl_num)
> +			esw_funcs->phys_port_cnum = 0;
> +	}
> +}

[Severity: Medium]
What serializes phys_port_cnum against the devlink port_new path?

mlx5_self_controller_set() and mlx5_self_controller_reset() run under
ldev->lock, called from bond work or mlx5_sd_activate_shared_fdb(). They
write this field for every eswitch in the group, including peers whose
devlink lock isn't held.

mlx5_devlink_sf_port_new() holds only the PF devlink instance lock. It
reads phys_port_cnum three separate times:

mlx5_sf_new_check_attr()
mlx5_sf_add()
  mlx5_sf_get_self_controller()
  mlx5_sf_alloc()
    mlx5_esw_offloads_controller_valid()

Suppose mlx5_sf_new_check_attr() sees 0 and accepts an explicit controller
0, and the shared FDB is then created with phys_port_cnum set to 4. Can
the SF be created as pf0sf0 and collide with the master?

In the reverse order, mlx5_sf_get_self_controller() returns 4 and a
concurrent destroy then resets the field. Can
mlx5_esw_offloads_controller_valid(4) then fail with a spurious "Invalid
controller number"?

This function also writes in two passes. It first sets controller_num on
every non-master, then zeroes the ones that match the master. Can a
concurrent reader see the transient non-zero value?

The EC VF read in mlx5_esw_get_self_pf_ctrl_num() is not synchronized
either.

[ ... ]

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sf/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/sf/devlink.c
> index 2002b7f376ee6..c8aa1b0b9319d 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/sf/devlink.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/sf/devlink.c
> @@ -237,6 +237,18 @@ int mlx5_devlink_sf_port_fn_state_set(struct devlink_port *dl_port,
>  	return mlx5_sf_state_set(dev, table, sf, state, extack);
>  }
>  
> +static u32
> +mlx5_sf_get_self_controller(struct mlx5_eswitch *esw,
> +			    const struct devlink_port_new_attrs *new_attr)
> +{
> +	struct mlx5_esw_functions *esw_funcs = &esw->esw_funcs;
> +
> +	if (!new_attr->controller_valid && esw_funcs->phys_port_cnum)
> +		return esw_funcs->phys_port_cnum;
> +
> +	return new_attr->controller;
> +}

[Severity: Medium]
Local SFs on the non-master link now carry a non-zero sf->controller.
Existing code treats any non-zero controller as an external host SF. Does
that code handle these local SFs correctly?

When the external host PF is disabled, esw_vfs_changed_event_handler()
calls mlx5_sf_table_esw_changed_event_handler(). That handler only skips
SFs whose sf->controller is 0:

    if (!sf->controller)
        continue;

    if (sf->hw_state == MLX5_VHCA_STATE_IN_USE)
        sf->hw_state = MLX5_VHCA_STATE_ACTIVE;
    else if (sf->hw_state == MLX5_VHCA_STATE_TEARDOWN_REQUEST)
        sf->hw_state = MLX5_VHCA_STATE_ALLOCATED;

Take a deactivated local SF that gets rolled back from TEARDOWN_REQUEST to
ALLOCATED. A later port del goes through mlx5_sf_dealloc() ->
mlx5_sf_free() -> mlx5_sf_hw_table_sf_free() and skips
mlx5_sf_hw_table_sf_deferred_free().

Could the function ID then be reused while firmware still holds it, and
would opstate report the wrong value?

Also, mlx5_sf_hw_table_sf_alloc() arms vhca events under "if
(controller)", and its comment says that is for external controllers. Is
it intended to arm them for these local SFs too?

The same applies to SFs created on the master with an explicit
controller_num, as described above.

[ ... ]

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sf/hw_table.c b/drivers/net/ethernet/mellanox/mlx5/core/sf/hw_table.c
> index d8d0616834978..b7e8a8d7cc646 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/sf/hw_table.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/sf/hw_table.c
> @@ -40,8 +40,18 @@ static struct mlx5_sf_hwc_table *
>  mlx5_sf_controller_to_hwc(struct mlx5_core_dev *dev, u32 controller, u32 pfnum)
>  {
>  	struct mlx5_sf_hw_table *table = dev->priv.sf_hw_table;
> +	struct mlx5_eswitch *esw = dev->priv.eswitch;
> +	struct mlx5_esw_functions *esw_funcs;
>  	int i;
>  
> +	/* If shared fdb is destroyed, phys_port_cnum is reset to 0.
> +	 * So use controller_num directly which is read from firmware.
> +	 */
> +	esw_funcs = &esw->esw_funcs;
> +	if (controller == esw_funcs->controller_num &&
> +	    pfnum == mlx5_esw_get_self_pf_pfnum(esw))
> +		return &table->hwc[MLX5_SF_HWC_LOCAL];
> +
>  	for (i = MLX5_SF_HWC_FIRST_SPF; i < table->num_hwc; i++) {
>  		if (table->hwc[i].controller == controller)
>  			return &table->hwc[i];

[Severity: Medium]
mlx5_esw_sf_controller_to_pfnum_valid() now accepts any SPF whose
host_number + 1 and pf_num both match. This loop, however, still picks
the SPF hwc by controller alone.

Suppose two SPFs on one eswitch share a host_number. Could a request for
the second SPF's pfnum pass validation and then be allocated from the
first SPF's hwc range? Both mlx5_sf_hw_table_id_alloc() and
mlx5_sf_sw_to_hw_id() take the first match, while the devlink port would
report the second pfnum.

Before this patch, mlx5_esw_sf_controller_to_pfnum() returned only the
first matching SPF's pf_num, so validation and hwc selection agreed.

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261125212032.243064-1-tariqt%40nvidia.com
