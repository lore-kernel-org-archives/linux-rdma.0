Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794055189;
	b=TDp0C0H9KKlUxKlpwVU94P4NUkvnLi9PIzSL9gPJrSA6K0b/w82NjEhIshxeJXY0XNW4
	 Aq8dJAwa7YnRTUNQsDhzKaOLeHoGbUCiLQSFC2/9OpNOSnDdB0ozi+d/5LXJ5mRo5jHbm
	 UP78w4TjT6bWBM4WdOhPEgx/oBgD75Jf++sh9J42dKhBkwvrxao07pOURZfmlXtbfQru7
	 +GVY41Q1278kvZnwanoOGfuAZXl+c4r5vqL8h4YOjmRbLBOgexIsXOZAwxizpw/yedGSo
	 O4DJSKQfxtLMuhxdI/Mrmb8XnN/zedIRv3Fmk2016nla87gBa8vDMXlxyA7U5Brtn8A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794055189;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=nnRIRVpmyOxPn9cQiaY6f7wCllCPsuFLZMS83RLzOhE=;
	b=NQCX/2Xf6FEWLFf7pZe0uwt+/WkArSTjXEDEBerF3zhUerAv3T1PFSFwne6jhH/VjJDS
	 5n8XV8jDABkbHDPfY0TbbrnQ1vYoxW3IR+KpUAL7XI5ztkiE2jDcqvW06m4+gJbcqC/Gw
	 OYmTZ5Y12HHNSd69O/ZwTB6rBhva8jh9dJ2nFYUvJ8/KpZpyGMdMprIDTIDc5DuG/U+ip
	 GjpB0iPHtnEIyUAe7RJDrc7DYlHRMsyfgVg/EKb+VnAA8lBibu/2lWzxb9IYg8Es/k2Mu
	 gqlTi50T5SHYe9mdFdf9g8OCt/2wlQOOpdt4VLsQs1Xb9WJxHOFJLRcW6VdRZ6nTgHA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DKVuKFXg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D07A0606A330;
	Sat,  7 Nov 2026 12:39:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DKVuKFXg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 958311F0089F;
	Sat,  7 Nov 2026 12:39:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794055188;
	bh=nnRIRVpmyOxPn9cQiaY6f7wCllCPsuFLZMS83RLzOhE=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=DKVuKFXg8vilbbYppeRcvOtMuXayBXBRSMpjyBAMN7Xb09Ea7s1ZwnzwN3H+B+F1i
	 hNn5+eGKofV5r6+md1AZ1z1h8CTBbGLjfRuaaNdsWGjCIybOjE0FkIBGjqCTIzh5oR
	 eEp0VfPkHvOBlNktnx46At7nr7KyGKwioI1QBHpWZZx6vgDF6Ld4ayALJkhLnmOjge
	 XX5sLa01+Zt2XHN0fggvl3JInJeYXFd9uUUTrFViZYWn+40s0/abLvzk8mWtJnAYug
	 U9fxBaZP6y1HWMXQwB7v3wFl34akstszIa8JSa5LFkK6KYilimEs2q4NwZzwJ7hm3H
	 2DOnpJZ/kq3vQ==
Subject:
 Re: [PATCH] net/mlx5e: TC, fix internal port leak when a flow is reoffloaded
From: netdev-bot+sashiko@kernel.org
To: vulab@iscas.ac.cn
Cc: saeedm@nvidia.com, tariqt@nvidia.com, mbloch@nvidia.com, leon@kernel.org,
 andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
 linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
Date: Sat, 07 Nov 2026 12:39:47 +0000
Message-ID: <179405518707.994134.3869617957663198262@kernel.org>
In-Reply-To: <20261103102855.1340650-1-vulab@iscas.ac.cn>
References: <20261103102855.1340650-1-vulab@iscas.ac.cn>
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

Critical: 0 · High: 1 (1) · Medium: 0 · Low: 0

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] The fix is incomplete: internal-port references still leak when
  a flow is reoffloaded, through other writers in the same retry path…

Pre-existing issues:
- [High] This problem wasn't introduced by this patch, but
  mlx5e_tc_add_fdb_flow() does not undo the resources it attached when…

--

net/mlx5e: TC, fix internal port leak when a flow is reoffloaded

This patch makes mlx5e_tc_add_fdb_flow() skip the internal port lookup
for OVS master filter devices when esw_attr->int_port is already set. The
goal is that a retry from mlx5e_tc_reoffload_flows_work() does not take a
second reference and overwrite the stored pointer.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> index 708b7987ea4cd..fba4b7b97d2e4 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> @@ -1998,17 +1998,19 @@ mlx5e_tc_add_fdb_flow(struct mlx5e_priv *priv,
>  			goto err_out;
>  		}
>  
> -		int_port = mlx5e_tc_int_port_get(mlx5e_get_int_port_priv(priv),
> -						 parse_attr->filter_dev->ifindex,
> -						 flow_flag_test(flow, EGRESS) ?
> -						 MLX5E_TC_INT_PORT_EGRESS :
> -						 MLX5E_TC_INT_PORT_INGRESS);
> -		if (IS_ERR(int_port)) {
> -			err = PTR_ERR(int_port);
> -			goto err_out;
> -		}
> +		if (!esw_attr->int_port) {
> +			int_port = mlx5e_tc_int_port_get(mlx5e_get_int_port_priv(priv),
> +							 parse_attr->filter_dev->ifindex,
> +							 flow_flag_test(flow, EGRESS) ?
> +							 MLX5E_TC_INT_PORT_EGRESS :
> +							 MLX5E_TC_INT_PORT_INGRESS);
> +			if (IS_ERR(int_port)) {
> +				err = PTR_ERR(int_port);
> +				goto err_out;
> +			}
>  
> -		esw_attr->int_port = int_port;
> +			esw_attr->int_port = int_port;
> +		}

[Severity: High]
Does this fully close the leak on the reoffload path? The new guard only
covers the writer used when filter_dev is an OVS master. The same retry
path has two other writers that are not guarded.

For a TUN_RX flow, mlx5e_tc_add_fdb_flow() calls
mlx5e_attach_decap_route() before this block. That function always calls
mlx5e_tc_tun_route_lookup():

drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c:mlx5e_tc_tun_route_lookup() {
    ...
	} else if (netif_is_ovs_master(attr.route_dev) && mlx5e_tc_int_port_supported(esw)) {
		int_port = mlx5e_tc_int_port_get(mlx5e_get_int_port_priv(priv),
						 attr.route_dev->ifindex,
						 MLX5E_TC_INT_PORT_INGRESS);
		...
		esw_attr->int_port = int_port;
	}
    ...
}

On that branch decap_vport stays 0, so mlx5e_attach_decap_route()
returns 0 and the flow continues. Suppose a later encap lookup in
post_process_attr() fails with -ENETUNREACH. __mlx5e_add_fdb_flow() then
keeps the flow on the unready list. Each run of
mlx5e_tc_reoffload_flows_work() takes another int_port reference here and
overwrites the previous one.

For TUN_RX flows filter_dev is the tunnel netdev, so the guard added by
this patch never runs for this case.

In multipath mode, mlx5e_route_lookup_ipv4_get() forces flowi4_oif to the
uplink rep. mlx5e_route_lookup_ipv6_get() does not, so an IPv6 decap
route through an OVS internal port such as br-phy seems to reach this
path.

The encap side does the same thing with dest_int_port. Take several
encap destinations where dest 0 attaches and a later one fails with
-ENETUNREACH. The retry goes through:

post_process_attr()
  mlx5e_tc_tun_encap_dests_set()
    mlx5e_attach_encap()
      mlx5e_set_int_port_tunnel()
        mlx5e_set_fwd_to_int_port_actions()

mlx5e_set_fwd_to_int_port_actions() then does:

	dest_int_port = mlx5e_tc_int_port_get(int_port_priv, ifindex, type);
	...
	esw_attr->dest_int_port = dest_int_port;

It does not check or release an existing value. is_duplicated_encap_entry()
only looks at indices below out_index, so it does not catch this case
either.

mlx5_free_flow_attr_actions() puts only the last stored int_port and
dest_int_port. The earlier references keep the int port, its rx rule and
its metadata mappings alive until the driver is torn down.

The commit message says "the reference is released together with the
flow attributes". That only holds for the writer guarded here.

Could the writers in mlx5e_tc_tun_route_lookup() and
mlx5e_set_fwd_to_int_port_actions() be handled as well? Another option
would be to unwind the partial state before the flow is retried.

>  	}
>  
>  	err = post_process_attr(flow, attr, extack);

[Severity: High]
This is a pre-existing issue, not one introduced by this patch. The
int_port leak looks like one symptom of mlx5e_tc_add_fdb_flow() not being
idempotent across reoffload retries. When it fails with -ENETUNREACH,
nothing attached before the failure is undone. mlx5e_tc_reoffload_flows_work()
then runs it again on the same flow.

Several of those attach steps take a reference and list_add() a node that
is still linked from the previous attempt.

mlx5e_attach_decap_route(), for a VF-tunnel TUN_RX flow:

	flow->decap_route = r;
	list_add(&flow->decap_routes, &r->decap_flows);

mlx5e_attach_decap(), for L3_TO_L2_DECAP:

	flow->decap_reformat = d;
	attr->decap_pkt_reformat = d->pkt_reformat;
	list_add(&flow->l3_to_l2_reformat, &d->flows);

mlx5e_attach_encap(), for an encap dest that attached in an earlier
attempt:

	flow->encaps[out_index].e = e;
	list_add(&flow->encaps[out_index].list, &e->flows);

In the encap case, mlx5e_encap_get() bumps the entry refcount again.
is_duplicated_encap_entry() only checks indices below out_index, so it
misses the earlier attachment at the same index.

Can the repeated list_add() corrupt e->flows, r->decap_flows or d->flows?
With CONFIG_DEBUG_LIST it is reported as a double add. Without it, the
list_del() at flow teardown seems to leave the list pointing at the freed
flow. The next neigh or route update that walks the list would then be a
use-after-free.

The extra references on r, d and e are never dropped either, because
teardown puts each one only once.

The VPORT_TO_REG set action in the TUN_RX branch of
mlx5e_tc_add_fdb_flow() is also appended to parse_attr->mod_hdr_acts again
on every retry.

Would unwinding the partially attached state in __mlx5e_add_fdb_flow(),
before the flow goes on the unready list, fix both this and the int_port
leak?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261103102855.1340650-1-vulab%40iscas.ac.cn
