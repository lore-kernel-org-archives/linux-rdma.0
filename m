Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795145444;
	b=QIbOKwRmlyB8zhmuO+1Hhdmj8pYQO2n6vzF0FI3O0wsz4CU3k8JnqnG6uHcAwXOw9J15
	 grx8RqJZSWbyca53ffBXdPCmpsYwSiCXDm0WVb6P6QKoTQWAMPdRCMoSlWWvFO2tGrvBL
	 ruBxzjuvwnYIimHr/E0jQg6A9N1cRn+41rn/mqk+9PbfdXnaVlP4M2nb40cEDB5SozSO6
	 mYwhI7osZv5Dhl5Nrte5+fndoQibBgUJK8GYPeQFPFMafoz2Ss8PvzhJPwT2AvC5lE2Pl
	 kGfHE/ruMO1OhgZkbubMslno/xa9zJ3Hv/q1Qst7/MP0OMRIayAO3eaW39Q/TjXr6UA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795145444;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=JEbsS3L/h/hHVQUZ7EK4zXodUkr5QxYRn1luefQLwmg=;
	b=rG+jzZ9TjA+U8HRxohWLL2ugK5hMso8yzKR6qyN7UOg/uOBzxOf/EwBs+iUOXtozlr7S
	 sdFCCSEL2Kq5swfiUdx4pUk9we2ZmcEBHYWWp86Gy3LZ2BkP8DHnHCMQjyt4Ao7m/LppU
	 Q1Gy3XbijitbKAhlfJgX878JKCk4LLEJJSWWuahBIMibhXi+N5o5qL1tzWEAGiQewxaAF
	 EX2lKUIV1rNIHZ5WLIo97m/LIFLFUy9yeLJcnys0WzRKcpF1r+1ucRNqc/Qgwi9sOsDiK
	 z+xcECgWyr3UyJqxB3ZHTgvs1uYH9X8N4BMOX8//6K8Az8wgzdgNQntmd6cO8nmHhIQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jx3xeSU5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74D10606A333;
	Fri, 20 Nov 2026 03:30:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jx3xeSU5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B55791F000C4;
	Fri, 20 Nov 2026 03:30:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795145444;
	bh=JEbsS3L/h/hHVQUZ7EK4zXodUkr5QxYRn1luefQLwmg=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=jx3xeSU59jyKOaAlGzeSDm71p9gj7Az9FVVDrXrm2MJX+NlhKqPzjESpPLEL+Kt3z
	 kHW191e+JLfpXatl/5wyG+GLrYn5Xum0afORLWn37zFS7h1Z06glVmBAhKjOXfc+b8
	 5uyzUEWVZYmNWFRqz8TtYFsYvkx0Jgo+TlGroPNRkVUxlKnxJy6iLPxfSeZANNIMbS
	 gPNFADV/UAzJaGK47M5AVuN6CHC0d3Bxh7l/CGG3cVRPt+mc68rFcxRia83qKyYPzu
	 UspIWMjCNXuv6w0NSvaZ7MKmO4KjHthVehFDS3MioUJ2NApFRcG978XnuV7VVbw5X8
	 +9ulhGBrZaRIw==
Subject: Re: [PATCH net-next v2 08/10] net/mlx5e: TC, offload RX queue mapping
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
Date: Fri, 20 Nov 2026 03:30:42 +0000
Message-ID: <179514544232.3136.10984795533608621568@kernel.org>
In-Reply-To: <20261117092915.255194-9-acassen@corp.free.fr>
References: <20261117092915.255194-9-acassen@corp.free.fr>
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

- [Medium] A TC rule that maps a flow to an RX queue keeps a hardware
  destination that turns into a silent blackhole once the channel count…
- [Low] tc_act_can_offload_rx_queue()
  (drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/rx_queue.c:42)…

--

net/mlx5e: TC, offload RX queue mapping in NIC flows

This adds offload of the skbedit queue_mapping action to mlx5e NIC TC
flows. The rule's destination becomes the direct TIR of the requested
channel. The action must be the last one and must not follow a
terminating action.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/rx_queue.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/rx_queue.c
> new file mode 100644
> index 0000000000000..32598a2163009
> --- /dev/null
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/rx_queue.c

[ ... ]

> +static bool
> +tc_act_can_offload_rx_queue(struct mlx5e_tc_act_parse_state *parse_state,
> +			    const struct flow_action_entry *act,
> +			    int act_index,
> +			    struct mlx5_flow_attr *attr)
> +{

[ ... ]

> +	if (act->rx_queue >= flow->priv->channels.params.num_channels) {
> +		NL_SET_ERR_MSG_MOD(extack, "RX queue index out of range");
> +		return false;
> +	}

[Severity: Medium]
The queue index is only checked against num_channels here, when the rule
is inserted. What happens to the offloaded rule after a later
"ethtool -L combined N" with N <= rx_queue?

tc_act_parse_rx_queue() stores the direct TIR number in nic_attr->rx_tirn.
mlx5e_add_offloaded_nic_rule() then programs it as a TIR destination.

On the channel switch:

mlx5e_switch_priv_channels()
  mlx5e_deactivate_priv_channels()
    mlx5e_rx_res_channels_deactivate()
      mlx5e_rx_res_channel_deactivate_direct()
        mlx5e_rqt_redirect_direct(&res->channels[ix].direct_rqt,
                                  res->drop_rqn, NULL);

mlx5e_rx_res_channels_activate() then re-points the direct RQTs only for
indices below the new channel count. The FTE still points at the direct
TIR for rx_queue, and that TIR's RQT now points at the drop RQ. Hardware
drops the matched flow, but tc still reports the filter as in_hw.

The ethtool core check (ethtool_get_max_rxnfc_channel() and
ethtool_get_max_rxfh_channel() in net/ethtool/common.c) only knows about
ntuple and RSS users. So the reduction is allowed, and nothing
re-validates, reprograms or removes the TC rule.

The drops are counted on priv->drop_rq_q_counter, and
mlx5e_grp_q_update_stats() reports them as rx_if_down_packets even though
the interface is up.

The commit message acknowledges this:

  "Reducing the channel count below the queue of a rule drops its traffic
  until the channel returns."

Could the driver track the queues used by TC rules, so that set_channels
can refuse the change as it does for ethtool's own rules? Alternatively,
could it reprogram the affected rules so they don't keep dropping
traffic?

[Severity: Low]
Is it safe to read priv->channels.params.num_channels here without a lock?

mlx5e_setup_tc() sets f->unlocked_driver_cb = true, so this path can run
without rtnl:

mlx5e_configure_flower()->...->parse_tc_nic_actions()->parse_tc_actions()
  ->tc_act_can_offload_rx_queue()

This path doesn't take priv->state_lock either. Meanwhile,
mlx5e_switch_priv_params() and mlx5e_switch_priv_channels() overwrite the
structures with plain struct copies under state_lock:

    priv->channels.params = *new_params;
    ...
    priv->channels = *new_chs;

The two sides share no lock, so this is an unannotated data race that
KCSAN would likely report.

The check is also check-then-act:

CPU0 (tc filter add)           CPU1 (ethtool -L combined 4)
reads num_channels == 8
accepts rx_queue == 7
                               switches channels, direct RQT 7 now
                               points at the drop RQ
installs FTE to direct TIR 7

The filter add succeeds, but its traffic is silently dropped. Direct TIRs
exist for all max_nch indices, so the rule still references a valid TIR.

The commit message mentions this window too ("A channel change racing
with the range check of a new rule has the same result").

If the channel reduction issue above is fixed by tracking TC queue usage,
would this check also need to run under priv->state_lock?

> +
> +	return true;
> +}

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261117092915.255194-1-acassen%40corp.free.fr
