Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795469675;
	b=RvTPa54PQmW6+1zweR0/AFRZygaZEqSXsjEhC505eVvWpppd6HTiwvfekdCJEwrun8rS
	 9WFUM+1h3AzvQtuFh4AmWIIMzWlRUckgfHE/9+XY9pVQoahfhy87Wjn2lFnG4agfkZrCz
	 DLCvb4/tdBxIFR1cd9/53rwrz+/g7sw+LPvTkKpPvhrxLAyiAFV5rZ9SrnM14yDqm1NgA
	 lixgUtirIUOUhJNjZV9ifKxjlaX6Eh3WpSHx2XECudHHXB0t06ATd4kueSSmtFvQFHOuD
	 hN3zymFPEezEbFKkqn94cuJTuiQVZEHR6L0cFF0+q4uPOpv/QT5+IWL+QS/I0xxKEGA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795469675;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=9/No1l1Kc63z3bylzGTqguL7lglbI2czanvjCA3a2mY=;
	b=iKfkvpmzEqybNxjQWVRuS60dQl5BOHunmyvI1WoLdtwFnlnFiIA2JdOdu+vPYXwccfft
	 zRbNx6osJ4a3B3UlctkEJ75HHTzDGA2JBE6XkIwXmmFea0CSu0tHwZIFWltcRbTyM9+hQ
	 6xHlFXFZ05e0CSrv7WXK9Yv+f5UHGvjx4B01NyBssPWTu2Zf8fm1J2IfxsbpI1zk4UT5t
	 vvHy+FeMHuvjNhMJBrqYtfzwnSbOx1Ra3Yn/ChYCgzq7zUTknmTsgP7IgEgBT5tKsynFX
	 yPibzMxDDv3Stoy8VxAjJqX92j6YoLj5Oa6zOBPrUgYPtQfK2sJVR+qPktdMdBXbfNQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dkTUJ8k4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79C87606A327;
	Mon, 23 Nov 2026 21:34:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dkTUJ8k4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 993141F000E1;
	Mon, 23 Nov 2026 21:34:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795469675;
	bh=9/No1l1Kc63z3bylzGTqguL7lglbI2czanvjCA3a2mY=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=dkTUJ8k4dnEXI3c187Ferhu/z9D7afOKibujKNvAH3gBnHsNU14B8dRif9zh2eIyz
	 WiU6eKdKAG3KZ9j8CYeKUz9X9JpUiyqlUn6iAUjCyiNzqRUZLgiseyjVAYMp+ZJbA/
	 Byz3QkVetyMQUQjJplfguXV1iLal9Pf7cLhk+Y7NQ46BQkrGLDEdcxZ5zq3zrtDcyt
	 WgjdCfIRdXXkxABUXXnLESji/9h6K8K+WO7+NmyDHoGFAQfAMl6Rdk8D9dWhI36Ov9
	 gblfc6EP1WO7xm2KTEgR4pmpFfcA08deaHa11Nd43K0U/1a+ddezgba54TZgLZz/gW
	 HNVCI8EXznn9w==
Subject: Re: [PATCH net-next v3 09/11] net/mlx5e: TC, reject tunnel keys
 without a tunnel device
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
Date: Mon, 23 Nov 2026 21:34:33 +0000
Message-ID: <179546967317.3135.11320901240553136005@kernel.org>
In-Reply-To: <20261122213200.3207385-10-acassen@corp.free.fr>
References: <20261122213200.3207385-10-acassen@corp.free.fr>
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

- [Low] The new rejection in __parse_cls_flower()
  (drivers/net/ethernet/mellanox/mlx5/core/en_tc.c) returns the extack…

--

net/mlx5e: TC, reject tunnel keys without a tunnel device

This commit rejects flower rules that use enc_* dissector keys when
filter_dev is not a tunnel device. It applies to both NIC and eswitch
flows. Before this change those keys were silently dropped from the
hardware match.

Link: https://github.com/acassen/research/tree/main/UPF-flow-steering [1]

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> index 2326fb21da66b..eab4d5417ce24 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> @@ -2786,6 +2786,17 @@ static int __parse_cls_flower(struct mlx5e_priv *priv,
>  		err = mlx5e_tc_verify_tunnel_ecn(priv, f, &match_inner_ecn);
>  		if (err)
>  			return err;
> +	} else if (dissector->used_keys &
> +		   (BIT_ULL(FLOW_DISSECTOR_KEY_ENC_KEYID) |
> +		    BIT_ULL(FLOW_DISSECTOR_KEY_ENC_IPV4_ADDRS) |
> +		    BIT_ULL(FLOW_DISSECTOR_KEY_ENC_IPV6_ADDRS) |
> +		    BIT_ULL(FLOW_DISSECTOR_KEY_ENC_PORTS) |
> +		    BIT_ULL(FLOW_DISSECTOR_KEY_ENC_CONTROL) |
> +		    BIT_ULL(FLOW_DISSECTOR_KEY_ENC_IP) |
> +		    BIT_ULL(FLOW_DISSECTOR_KEY_ENC_OPTS))) {
> +		NL_SET_ERR_MSG_MOD(extack,
> +				   "Tunnel keys are only supported on tunnel devices");

[Severity: Low]
Is this extack message accurate for NIC mode flows?

In NIC mode the filter_dev passed down is always the mlx5e netdev itself:

mlx5e_setup_tc_cls_flower()
    return mlx5e_configure_flower(priv->netdev, priv, cls_flower,
                                  flags);

The only indirect block registration in mlx5 is the
flow_indr_dev_register() call in mlx5e_rep_tc_netdevice_event_register(),
and only the uplink representor init path calls it. So tunnel filter_devs
only exist in switchdev mode.

In NIC mode, a rule such as "tc filter add dev <mlx5 netdev> ingress
flower skip_sw enc_dst_ip ..." takes this path:

mlx5e_setup_tc_cls_flower()->mlx5e_configure_flower()->mlx5e_tc_add_flow()
    ->mlx5e_add_nic_flow()->parse_cls_flower()->__parse_cls_flower()

The rule is still rejected with -EOPNOTSUPP. However, the message tells
the user to use a tunnel device, and a rule added on a vxlan or gretap
device would never reach mlx5 in NIC mode.

The follow-up patch "net/mlx5e: TC, match the tunnel key without a tunnel
device" changes this string to "Tunnel keys other than enc_key_id require
a tunnel device". Wouldn't that wording mislead NIC mode users in the
same way for the remaining enc_* keys?

Could the message say that these keys need switchdev mode and a tunnel
device, or use a different message for NIC flows?

> +		return -EOPNOTSUPP;
>  	}
>  
>  	err = mlx5e_flower_parse_meta(filter_dev, f);

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261122213200.3207385-1-acassen%40corp.free.fr
