Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794424333;
	b=MX2UpHj/APqebhErC+DqxxqsX78/9gyB65tCXBPEQbh6UJFfUbMctxjSxayhR8Xk/DeV
	 AtOa2J2z3DpU38+Q0vKZpqB5VQXXybsSRzzZ5RvCPxC/gjDqps+t9nOGCq0mgd9KOhodh
	 Vb6GQS98mQ0tAA69ywuFyyyQO090kQBBPzRelwwYjJ6QTJ4rdYSXwUhgVGx9B12U2zSLO
	 4gld+n75tnFBHCoaST5OxCc/LiGfeGEbfnFAeTUzrps0bmJN8NVMR+BdTx8XBhn19xlYu
	 kiDijgCp/nQEDB7k4q4om4X81PuX1ATm9M3A1dXmrhwio92ylXKHYXjJkSkX2S84m7A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794424333;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=9jTV1cU8eRCsu/cOln8DSW5YMovrmFKMV7huP79WNyk=;
	b=yB5aJn/U7Vw8l6gOrCtkSDJzwPgFnFoM0umxvZ6qedcJxLK5o6SA9gN4MrsZDfQOPpZX
	 pyLDn2xuOWNY2Iz1eqD2oBNV4U1MQfdU/Xxa3mdsq6dAkGC2syLyiinB2SexEfk1qHd1S
	 5pFT8QJnNPxXI85x5vwMqRC7Kg8FfcTD3PVLY4Ih37I+FrlsVn2+rRYLPaNaz3swRkj10
	 P7+ooKFz4bZ4lXffLdmredLprxhD2DXgFW+d4+XDmevG9PXxrH64imHwnQppWRjPdg0aY
	 D1SZ7kA7BKKwGoLw1w0gJIBPA86lMTzVtiLhtl83DIfkkJTcoI2ik/MPzHXJbeyO0dw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QhS5rO7q;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB558606A89F;
	Wed, 11 Nov 2026 19:12:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QhS5rO7q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63D671F00A09;
	Wed, 11 Nov 2026 19:12:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794424333;
	bh=9jTV1cU8eRCsu/cOln8DSW5YMovrmFKMV7huP79WNyk=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=QhS5rO7q7Kkwt5pgyQUSnaeRTvuxOkKq0LhVvckZ5oa8yBhmvAja8xok+1xdRVW9l
	 88A/GInH3A015FrOBWehEs6vmLkvXqzpzH3884CSjQSy8/H/P3DonNYR5Uw6Q7+ak/
	 ZUkHfN73KzLR7XOgK9i5zdjSb5jn8d4sFPqyv+2yEzaKkS53AoxLctTf0k/0wrDrgV
	 aeREkyS/FCK8MNZZoo7578L0RHG4M79zjCWOwwNsTKrE1L2TbVIKh/zhMRmveW05kN
	 SArqPYH9B8/VkDiMwfPBgwKxYghVMM6/GolvCOaHoAhbI3WGAMH8xgQzc3wQp99bcw
	 hW9W0fiHOS9ww==
Subject: Re: [PATCH net-next 08/10] net/mlx5e: TC, offload RX queue mapping in
 NIC flows
From: netdev-bot+sashiko@kernel.org
To: acassen@corp.free.fr
Cc: saeedm@nvidia.com, leon@kernel.org, tariqt@nvidia.com, mbloch@nvidia.com,
 jhs@mojatatu.com, jiri@resnulli.us, andrew+netdev@lunn.ch,
 davem@davemloft.net, edumazet@kernel.org, kuba@kernel.org, pabeni@redhat.com,
 horms@kernel.org, michael.chan@broadcom.com, pavan.chebbi@broadcom.com,
 bharat@chelsio.com, donald.hunter@gmail.com, corbet@lwn.net,
 skhan@linuxfoundation.org, rdunlap@infradead.org, dsahern@kernel.org,
 idosch@nvidia.com, shuah@kernel.org, netdev@vger.kernel.org,
 linux-rdma@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kselftest@vger.kernel.org, oss-drivers@corigine.com
Date: Wed, 11 Nov 2026 19:12:11 +0000
Message-ID: <179442433199.2199510.1112413550328435081@kernel.org>
In-Reply-To: <20261109131039.959438-9-acassen@corp.free.fr>
References: <20261109131039.959438-9-acassen@corp.free.fr>
X-sashiko-severity: Medium
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

Thank you for your contribution! Sashiko AI review found 2 potential
issue(s) to consider.

Critical: 0 · High: 0 · Medium: 1 · Low: 1

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] The terminating-action guard in tc_act_can_offload_rx_queue()
  (drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/rx_queue.c) is…
- [Low] tc_act_can_offload_rx_queue() reads
  `flow->priv->channels.params.num_channels` (a u16) with no lock and no…

--

net/mlx5e: TC, offload RX queue mapping in NIC flows

This commit offloads the tc skbedit queue_mapping action for mlx5e NIC
flows. Matching traffic goes to the direct TIR of the selected channel,
the same way ethtool steering rules do it. The action must be last and
cannot follow goto or mirred.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/rx_queue.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/rx_queue.c
> new file mode 100644
> index 0000000000000..869da3cb703a8
> --- /dev/null
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/rx_queue.c
> @@ -0,0 +1,49 @@

[ ... ]

> +static bool
> +tc_act_can_offload_rx_queue(struct mlx5e_tc_act_parse_state *parse_state,
> +			    const struct flow_action_entry *act,
> +			    int act_index,
> +			    struct mlx5_flow_attr *attr)
> +{
> +	struct netlink_ext_ack *extack = parse_state->extack;
> +	struct mlx5e_tc_flow *flow = parse_state->flow;
> +
> +	/* The direct TIR takes over the destination of the rule */
> +	if (!flow_action_is_last_entry(parse_state->flow_action, act) ||
> +	    attr->dest_chain || flow_flag_test(flow, HAIRPIN)) {
> +		NL_SET_ERR_MSG_MOD(extack,
> +				   "RX queue mapping must be the last action and cannot follow goto or mirred");
> +		return false;
> +	}

[Severity: Medium]

Does this guard catch every earlier terminating action whose destination
the direct TIR would override? It only checks attr->dest_chain on the
current attr and the HAIRPIN flag.

A preceding gact ok seems to get through. mlx5e_tc_act_accept has
is_terminating_action set, but tc_act_parse_accept() only does:

	attr->action |= MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
	attr->flags |= MLX5_ATTR_FLAG_ACCEPT;

Nothing on the NIC path reads MLX5_ATTR_FLAG_ACCEPT, and dest_chain and
HAIRPIN are not changed. So a filter like this passes the check:

  tc filter add dev eth0 ingress protocol ip flower skip_sw ... \
      action ok action skbedit queue_mapping 3

verify_attr_actions() accepts it too, because it only rejects FWD_DEST
combined with DROP. In mlx5e_add_offloaded_nic_rule(), the new branch
then wins over the default forward to the VLAN table:

	} else if (nic_attr->rx_tirn) {
		dest[dest_ix].type = MLX5_FLOW_DESTINATION_TYPE_TIR;
		dest[dest_ix].tir_num = nic_attr->rx_tirn;

As a result, hardware sends the flow to direct TIR 3. In tc, the action
list ends at ok, so the queue mapping should never apply.

Can a goto in an earlier split attr get past the check in the same way?
Take goto chain N, then a non-clear ct, then skbedit queue_mapping Q.
tc_act_is_multi_table_act_ct() returns true for the ct, so
parse_tc_actions() splits after it. mlx5e_clone_flow_attr_for_post_act()
then clears the new attr:

	attr2->dest_chain = 0;

When the rx_queue action is checked against attr2, attr->dest_chain is
0, so the rule is accepted. Hardware would then steer to queue Q instead
of processing chain N.

This second case assumes NIC CT offload is available and that goto
followed by ct is accepted on the first attr.

> +
> +	if (act->rx_queue >= flow->priv->channels.params.num_channels) {

[Severity: Low]

Is this read of priv->channels.params.num_channels meant to be lockless?

mlx5e_setup_tc() sets f->unlocked_driver_cb = true, so this path can run
without rtnl:

mlx5e_configure_flower()->parse_tc_actions()->tc_act_can_offload_rx_queue()

At the same time, mlx5e_switch_priv_channels() overwrites the whole
struct under rtnl and priv->state_lock:

	priv->channels = *new_chs;

That leaves a plain write racing a plain read, which KCSAN can report.

The commit message already accepts the functional result. No out of
bounds access is possible either: num_channels never exceeds max_nch,
and direct TIRs exist for every index up to max_nch.

For comparison, the similar ring_cookie check in validate_flow() in
en_fs_ethtool.c runs under rtnl, so it is serialized with set_channels.

Should this read use READ_ONCE(), or should the check take
priv->state_lock?

> +		NL_SET_ERR_MSG_MOD(extack, "RX queue index out of range");
> +		return false;
> +	}

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261109131039.959438-1-acassen%40corp.free.fr
