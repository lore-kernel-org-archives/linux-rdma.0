Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795469673;
	b=SIU4ywRDaZYE9ZNOOgxYhXr6ChqPt81OlVg4EIv4LOtQ/wDPsyK2jFgJsN7XOG54yJBz
	 VSaA10lhVAWuGrdkZ2Yn1wtlVWpYWm0syGtt7Kv1QHFiegbTQKPRIZ4Xbi7wUcwOxo8sV
	 bvI7XkveZRuVAq4roEaNZXyRHhUIzKcTszujSDz3rlkn3BRdCLJSgvIs4dptI/2tg0b+T
	 qF+bNtJqDrqmKeqh56cQzInK48l2vJxwhaaWTanlzZNSEfvWSX09LcK7mO0ozG2glcuEc
	 XoCLQd+UZc8EwcuN06ynPmi+YunK7uWhdtS+6XP0MiIHH28tvPVWuPmFT5we2/ge9hg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795469673;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=ZeKQ14LjWbrBOwF34ZwIHkM7l1+rx5qTxWiWJLrmWQk=;
	b=E6c1XL9LeekRGyaGckgMVfpdgX2iCndFj6mWCqBjE4Gf+Mt+4F8fxeFP7vkONJYZobQx
	 Gw7QrGNtbXeUPAxyt3mi6CwqJrkgxa2qpBLL9nFsQrymn/Bq+x2TkaSmaDBl5KNKWhRli
	 LWD8oqwlq62zQvcdr2waKGxtQupyAPwD1Ad09OjTh2YGOa5pdXyvD+dOnDgUkXiD0RY6F
	 JXev6Z/864WCOtNeRXaHlmQ0/Ok1SjuP3H2/1ZBSTzkDTmHNBLlcztbOmUV2XF9Le/WEL
	 zNCvBIOVJf5xnDXVrFfyHxNyJXluCzk18KtY/DIu4tDy6f15dTyLebTvhc9u8P4bp6A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mPesezdj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EF50606A31E;
	Mon, 23 Nov 2026 21:34:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mPesezdj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E5CC1F000D8;
	Mon, 23 Nov 2026 21:34:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795469672;
	bh=ZeKQ14LjWbrBOwF34ZwIHkM7l1+rx5qTxWiWJLrmWQk=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=mPesezdjcoLgb6a+8xflRctT8RCs/SR6BDgG7TMB52zm36Uc4MpUA736ZAcGID7MU
	 cG2t6qZ83jF0taKsDvTqn047oPGx1YiMDtsCpGW5I4IteyoiHdt6C+tY/tLFwQDFNL
	 5NTIZLj2OG3TJtHH8EmI09x8KeI/Rj7S6lIEGw7bjhgJMpXYAHygkcRaQ3Q9qrbO8R
	 /L8K2OA3rw6x+RXH43oS+rf1MZnDO3gDikYkrlZqz6d1Rk6U6sGXSjGvM5tLwHvzos
	 F+zw+JKHb0zqUiPRv3Uwi7YRQN39s5gIroBrCW1zpWk595bqdCCocpCwiCv2ksWW84
	 boywKXzuTHPBQ==
Subject: Re: [PATCH net-next v3 08/11] net/mlx5e: TC, offload RX queue mapping
 in NIC flows
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
Date: Mon, 23 Nov 2026 21:34:30 +0000
Message-ID: <179546967077.3135.3838730458941932181@kernel.org>
In-Reply-To: <20261122213200.3207385-9-acassen@corp.free.fr>
References: <20261122213200.3207385-9-acassen@corp.free.fr>
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

- [Medium] TC skbedit rx_queue rules are not protected when the channel
  count is reduced, so their traffic is dropped without any warning.
- [Low] tc_act_can_offload_rx_queue() reads
  flow->priv->channels.params.num_channels without a lock and without…

--

net/mlx5e: TC, offload RX queue mapping in NIC flows

This adds offload of TC skbedit queue_mapping to mlx5e NIC flows. The
rule's destination is set to the channel's direct TIR, the same way
ethtool steering rules work. The action must be the last one and cannot
follow a terminating action.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/rx_queue.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/rx_queue.c
> new file mode 100644
> index 0000000000000..32598a2163009
> --- /dev/null
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/rx_queue.c
> @@ -0,0 +1,67 @@

[ ... ]

> +static bool
> +tc_act_can_offload_rx_queue(struct mlx5e_tc_act_parse_state *parse_state,
> +			    const struct flow_action_entry *act,
> +			    int act_index,
> +			    struct mlx5_flow_attr *attr)
> +{

[ ... ]

> +	if (act->rx_queue >= flow->priv->channels.params.num_channels) {

[Severity: Low]

Is this read of priv->channels.params.num_channels safe against a
concurrent channel change?

The NIC flower offload path runs without RTNL, because mlx5e_setup_tc()
sets:

	f->unlocked_driver_cb = true;

and mlx5e_configure_flower()->parse_tc_actions() does not take
priv->state_lock either.

Meanwhile, ethtool set_channels rewrites the whole struct in
mlx5e_switch_priv_channels() while holding state_lock and RTNL:

	priv->channels = *new_chs;

So a "tc filter add" that races with "ethtool -L" is a plain data race
on num_channels, which KCSAN would report.

The commit message says:

  "Direct TIRs exist up to the maximum channel count. The rule always
  points to a valid one."

That claim depends on this unannotated read always returning a value
<= max_nch. This check is the only bound applied before
tc_act_parse_rx_queue() indexes res->channels[] through
mlx5e_rx_res_get_tirn_direct().

Would it make sense to use READ_ONCE() here, or to also check
act->rx_queue against mlx5e_rx_res_get_max_nch(priv->rx_res)?

> +		NL_SET_ERR_MSG_MOD(extack, "RX queue index out of range");
> +		return false;
> +	}
> +
> +	return true;
> +}
> +
> +static int
> +tc_act_parse_rx_queue(struct mlx5e_tc_act_parse_state *parse_state,
> +		      const struct flow_action_entry *act,
> +		      struct mlx5e_priv *priv,
> +		      struct mlx5_flow_attr *attr)
> +{
> +	attr->nic_attr->rx_tirn = mlx5e_rx_res_get_tirn_direct(priv->rx_res,
> +							       act->rx_queue);

[Severity: Medium]

The rx_queue range check in tc_act_can_offload_rx_queue() runs only when
the rule is added. Nothing looks at the TIR number stored here again.

What happens to this rule if the channel count is later reduced, for
example with "ethtool -L <dev> combined N" where N <= rx_queue?

mlx5e_add_offloaded_nic_rule() installs nic_attr->rx_tirn as the FTE
destination. When the channel becomes inactive, the RQT behind that TIR
is redirected to the drop RQ in
mlx5e_rx_res_channel_deactivate_direct():

	err = mlx5e_rqt_redirect_direct(&res->channels[ix].direct_rqt, res->drop_rqn, NULL);

The hardware rule keeps matching, so all matching traffic is dropped.
The rule is not rejected and the user is not told.

ethtool ntuple rules use the same direct TIRs, and the ethtool core
protects them: it refuses the reduction through
ethtool_get_max_rxnfc_channel() in net/ethtool/common.c.
mlx5e_ethtool_set_channels() has no equivalent check for TC rules.

The commit message notes this:

  "ethtool refuses such a change for its own rules but nothing tracks
  the queues of TC rules."

Could the driver track the highest rx_queue used by TC rules and refuse
a channel reduction below it in mlx5e_ethtool_set_channels(), the same
way ethtool rules are handled?

> +	attr->action |= MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
> +
> +	return 0;
> +}

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261122213200.3207385-1-acassen%40corp.free.fr
