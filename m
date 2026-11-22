Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=212.27.60.169
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795380190;
	b=Cn9rb3LKS02bz/ODrhcVGeTN50ZS7dy6ib+RX6K1FYpyfUOLHjUPvKtPsTUlfrEGB4Y/
	 vBla3IrESb8NobXDAdT2AXpnSKKn2MClvChcNUbbqNShwK66tUPecILRvftnnCu0/Gws+
	 i/eAY8rkq0T6WdACnpLPhwWmOozrjbov3dzzolpcmGqq/nW7EDwNDEwbvnkOsdjkbyqIH
	 VgqqOeqzdObQ5fmiUbytP5zZrWZlaDUkQtYnSxG1aGGXJyluYZW2zu6+itUrIZ0Ukybk2
	 gqV+u/RjVK98s9tld9bZbrKTDBAMwjk8ONZnPlnWeigYZsVhYIfr2zwuq7wjtkS57AQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795380190;
	h=DMARC-Filter:DKIM-Signature:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=f3WCN5DK2nraEF7E6NFOd/Lnddtr3bK2epIP1vkXLx8=;
	b=1ELGF/r8CK8fBZAzuDUdV+0kTLvdUAn94LzDPiimUR5+KFEcDT8tg1mDvRRY8s/xbm3W
	 8uxq/+RbSig99ETA6mXLpTi8QgNNka2xlyUC+BpsJMV4DC4yqbC2S1ixIDOtwe0cahBw1
	 FpvkeQ/lyvYUkF+HxP91dUZ4rvmXVTJHHfRn2isiPTh+JAxeGsH2EUo5k7RKITX5nqPHs
	 XfwRirQ8zvKYx6Z/EZV63Px6NJazgQYZ+gPiA5AVq0MrcLRNw5NQfrG00xzM6tQ5a/59d
	 ZJKcAdcy+i1HZzfUsZTfMWE7kFQDiFF1KceZJA1WHwqLdblc2gytf6Ciy4zCYZYRJXQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=corp.free.fr;
	spf=pass smtp.mailfrom=corp.free.fr;
	dkim=pass header.d=corp.free.fr header.i=@corp.free.fr header.a=rsa-sha256 header.s=rcs header.b=qmEXXjbL;
	arc=none smtp.remote-ip=212.27.60.169
Received: from rcs.proxad.net (rcs.proxad.net [212.27.60.169])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17411606A31A;
	Sun, 22 Nov 2026 20:43:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 17411606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=corp.free.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=corp.free.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=corp.free.fr header.i=@corp.free.fr header.a=rsa-sha256 header.s=rcs header.b=qmEXXjbL
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=corp.free.fr; s=rcs;
	t=1795380188; bh=YiA403p8mPlqP8u3u6soZWq/iuKhibw6d6FJkg8XKC8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=qmEXXjbLtA0Fs08Bf3JJqdbeFGFTO/66kTjgQybHUcZVMHcZWKkUWR3omqyuq6yoO
	 fgbuwKh/F6Mo3w3jzNFCrl+jmTznzWMla7WKxnEmHnNSliWDSWR69mshSl7F6O4IKR
	 Y9ICJ+jgnEHmQOe4lepBn/HxMszHwV+dwPzWlvF4dIojEGeFFxbF8Xsfdh9R+FQLqK
	 g1R7QKKsGsCVIzqOnvZCMZKyiA+f49jJ2R/Z6/buDOzVF5Wa5aIsLyNcc4guIA42kD
	 udp/scXvBIssJkrkcEZegirFhpvVExCLquH2R1/B9KuOtdrd/4vTZYlTZ9UOmYi5qt
	 OL1xNhp81Go8A==
Received: from [0.0.0.0] (unknown [213.228.1.188])
	by rcs.proxad.net (Postfix) with ESMTPSA id 4AE9D44C026E;
	Sun, 22 Nov 2026 21:43:06 +0100 (CET)
Message-ID: <9e26c923-381e-4b2f-a267-d5dcfc4cbb4f@corp.free.fr>
Date: Sun, 22 Nov 2026 21:43:05 +0100
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v2 08/10] net/mlx5e: TC, offload RX queue mapping
 in NIC flows
To: netdev-bot+sashiko@kernel.org
Cc: saeedm@nvidia.com, leon@kernel.org, tariqt@nvidia.com, mbloch@nvidia.com,
 jhs@mojatatu.com, jiri@resnulli.us, andrew+netdev@lunn.ch,
 davem@davemloft.net, edumazet@kernel.org, kuba@kernel.org,
 pabeni@redhat.com, horms@kernel.org, michael.chan@broadcom.com,
 pavan.chebbi@broadcom.com, bharat@chelsio.com, donald.hunter@gmail.com,
 corbet@lwn.net, skhan@linuxfoundation.org, rdunlap@infradead.org,
 dsahern@kernel.org, idosch@nvidia.com, shuah@kernel.org,
 netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org,
 oss-drivers@corigine.com
References: <20261117092915.255194-9-acassen@corp.free.fr>
 <179514544232.3136.10984795533608621568@kernel.org>
Content-Language: en-US
From: Alexandre Cassen <acassen@corp.free.fr>
In-Reply-To: <179514544232.3136.10984795533608621568@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 11/20/26 04:30, netdev-bot+sashiko@kernel.org wrote:
> [Severity: Medium]
> The queue index is only checked against num_channels here, when the rule
> is inserted. What happens to the offloaded rule after a later
> "ethtool -L combined N" with N <= rx_queue?
>
> tc_act_parse_rx_queue() stores the direct TIR number in nic_attr->rx_tirn.
> mlx5e_add_offloaded_nic_rule() then programs it as a TIR destination.
>
> On the channel switch:
>
> mlx5e_switch_priv_channels()
>    mlx5e_deactivate_priv_channels()
>      mlx5e_rx_res_channels_deactivate()
>        mlx5e_rx_res_channel_deactivate_direct()
>          mlx5e_rqt_redirect_direct(&res->channels[ix].direct_rqt,
>                                    res->drop_rqn, NULL);
>
> mlx5e_rx_res_channels_activate() then re-points the direct RQTs only for
> indices below the new channel count. The FTE still points at the direct
> TIR for rx_queue, and that TIR's RQT now points at the drop RQ. Hardware
> drops the matched flow, but tc still reports the filter as in_hw.
>
> The ethtool core check (ethtool_get_max_rxnfc_channel() and
> ethtool_get_max_rxfh_channel() in net/ethtool/common.c) only knows about
> ntuple and RSS users. So the reduction is allowed, and nothing
> re-validates, reprograms or removes the TC rule.
>
> The drops are counted on priv->drop_rq_q_counter, and
> mlx5e_grp_q_update_stats() reports them as rx_if_down_packets even though
> the interface is up.
>
> The commit message acknowledges this:
>
>    "Reducing the channel count below the queue of a rule drops its traffic
>    until the channel returns."
>
> Could the driver track the queues used by TC rules, so that set_channels
> can refuse the change as it does for ethtool's own rules? Alternatively,
> could it reprogram the affected rules so they don't keep dropping
> traffic?


Not in this series. The commit message and the documentation describe 
the drop.
ice behaves the same. It checks the queue of a TC rule when the rule 
goes in and
its set_channels ignores TC rules. Tracking the queues of TC rules would 
help
every driver that offloads queue mapping. That is a separate change.



> [Severity: Low]
> Is it safe to read priv->channels.params.num_channels here without a lock?
>
> mlx5e_setup_tc() sets f->unlocked_driver_cb = true, so this path can run
> without rtnl:
>
> mlx5e_configure_flower()->...->parse_tc_nic_actions()->parse_tc_actions()
>    ->tc_act_can_offload_rx_queue()
>
> This path doesn't take priv->state_lock either. Meanwhile,
> mlx5e_switch_priv_params() and mlx5e_switch_priv_channels() overwrite the
> structures with plain struct copies under state_lock:
>
>      priv->channels.params = *new_params;
>      ...
>      priv->channels = *new_chs;
>
> The two sides share no lock, so this is an unannotated data race that
> KCSAN would likely report.
>
> The check is also check-then-act:
>
> CPU0 (tc filter add)           CPU1 (ethtool -L combined 4)
> reads num_channels == 8
> accepts rx_queue == 7
>                                 switches channels, direct RQT 7 now
>                                 points at the drop RQ
> installs FTE to direct TIR 7
>
> The filter add succeeds, but its traffic is silently dropped. Direct TIRs
> exist for all max_nch indices, so the rule still references a valid TIR.
>
> The commit message mentions this window too ("A channel change racing
> with the range check of a new rule has the same result").
>
> If the channel reduction issue above is fixed by tracking TC queue usage,
> would this check also need to run under priv->state_lock?


The first part is the question of v1 [1]. The count can change right 
after the
check with or without the lock and the rule always points to a valid TIR.
Tracking would need its own locking in that separate change.

[1] 
https://lore.kernel.org/netdev/5c2301d9-d62a-49f7-9d0b-87a7c254a514@corp.free.fr/


