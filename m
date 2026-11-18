Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794997914;
	b=svCMXA/ZJQgx/wugRM5ZbU1UVwgHLTE761Fsgy4ojGVN/NSRRFev6ziipkuNi2FZO/hV
	 GIdHNOD3VU9my+uApKtZM6wuw7z36OphNND22O+1ys9qh27Eekx7qPn9QKUi0qnnBCkab
	 XdC232V65hdwfRux0GJL2UW9zUHmXc7qz14g8Xnkq5VXTFr/2j1TDH8NpjWxCfgWZ7hsH
	 phjk7iMWTAUIsYu0+2MR0XEPJmubndqVodEqFzOX+AL/HH2eqqAFm3pj2Agdbl5+4mlVy
	 LrxdFcrDljsXBG34AilbURfYKXNLfkJkFVf8a1z0zqFGgfMRJN9TTMMeOX8IeMKm3wQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794997914;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=12Z/blDM1A992Y/WX9Tffx98lEKuxjToJj7Etbtn4kk=;
	b=E/jaEtQ1F56QjGoFysKvZzbQgXRbbc4N6wpTK76LAwV6r+s/CJvM9iXacvEfK20BYx+b
	 hMV3TA9bMwlk5Tn2lKiJETkf/lB73ANeqKMbC0p6dir0d+CoL2V13TYIsXBAfjcR6Zhqw
	 ktCTUXcHTTbvyX6WgPyUNMTacEmVdYPFuMPuyI+cKA6JIDfZcr/c3PuoPYeOVEigAdMpH
	 MjbV1g7KoOVNBbIe5BBAIKiwyOqM86DL7l2ut4F+b01KCBxVhLN0uuasRe74yc3BqJgLc
	 XjdHGa3WuT4WIIxJ77jHWoHsmztH9heSOPFM8V6P3j1FuMvdVWinxEwgnjiQHc7ZzlA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=S9NuUema;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96E86606A320;
	Wed, 18 Nov 2026 10:31:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=S9NuUema
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F1FB1F000C4;
	Wed, 18 Nov 2026 10:31:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794997914;
	bh=12Z/blDM1A992Y/WX9Tffx98lEKuxjToJj7Etbtn4kk=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=S9NuUemaydoWdJ9SaVZ8yadou0dGhyeD1K2t7u3fD5hUFe42lGa4Oxdcd9v2iHQPc
	 oYWIXc4vAaaEOHjhG0xiTW/O4BJjDEaxKwb9nJR4mnlDKaZh0GowJEru/qrJoPcfcD
	 9eUvIGC/bSaxN1TSw3RCgnXiYTaJH4AVpOzcZIZgNw3INZlgUyiFeEx4oTjZiUtQ9T
	 WimHqaYS0OsQHJzD7/FRXGKH5oArQhcKtC+EWTKSQgBio5H/qEeOymI2+vQhk0+tb2
	 znqqQJPwvS3wBiOR6EB3XFWf9OnnmTu8AR+swRifpME85OdldjOLd3FTkJeNeb+9HT
	 BR0aB96A7aUqg==
Subject: Re: [PATCH net-next V2 01/10] net/mlx5: Distinguish VFs/SFs in the SW
 system image GUID for LAG grouping
From: netdev-bot+sashiko@kernel.org
To: tariqt@nvidia.com
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com,
 cjubran@nvidia.com, cratiu@nvidia.com, gal@nvidia.com, leon@kernel.org,
 linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, mbloch@nvidia.com,
 moshe@nvidia.com, ohartoov@nvidia.com, phaddad@nvidia.com, saeedm@nvidia.com,
 shayd@nvidia.com, udar@nvidia.com
Date: Wed, 18 Nov 2026 10:31:52 +0000
Message-ID: <179499791273.3136.2247906810795336370@kernel.org>
In-Reply-To: <20261116103010.1129666-2-tariqt@nvidia.com>
References: <20261116103010.1129666-2-tariqt@nvidia.com>
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

Thank you for your contribution! Sashiko AI review found 1 potential
issue(s) to consider.

Critical: 0 · High: 0 · Medium: 1 · Low: 0

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] The patch changes the SW system image GUID of a VF/SF that
  passes mlx5_virt_lag_is_supported(): mlx5_sw_guid_vf() or…

--

net/mlx5: Distinguish VFs/SFs in the SW system image GUID for LAG grouping

This patch changes mlx5_query_nic_sw_system_image_guid() so that each
discriminator byte after the FW system image GUID has a fixed position,
and trailing zero fields are trimmed. It adds VF and SF marker bytes that
are only set when mlx5_virt_lag_is_supported() is true, and it raises
MLX5_SW_IMAGE_GUID_MAX_BYTES from 9 to 11.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/vport.c b/drivers/net/ethernet/mellanox/mlx5/core/vport.c
> index 78f3d15b599d0..bab43df6a7d72 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/vport.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/vport.c
> @@ -1308,10 +1308,37 @@ u64 mlx5_query_nic_system_image_guid(struct mlx5_core_dev *mdev)
>  }
>  EXPORT_SYMBOL_GPL(mlx5_query_nic_system_image_guid);
>  
> +static u8 mlx5_sw_guid_load_balance(const struct mlx5_core_dev *mdev)
> +{
> +	if (MLX5_CAP_GEN_2(mdev, load_balance_id) &&
> +	    MLX5_CAP_GEN_2(mdev, lag_per_mp_group))
> +		return MLX5_CAP_GEN_2(mdev, load_balance_id);
> +	return 0;
> +}
> +
> +static u8 mlx5_sw_guid_sf(const struct mlx5_core_dev *mdev)
> +{
> +	return mlx5_core_is_sf(mdev) && mlx5_virt_lag_is_supported(mdev);
> +}
> +
> +static u8 mlx5_sw_guid_vf(const struct mlx5_core_dev *mdev)
> +{
> +	return mlx5_core_is_vf(mdev) && mlx5_virt_lag_is_supported(mdev);
> +}

[Severity: Medium]
Does this break the same-HW check between a PF and a VF/SF that passes
mlx5_virt_lag_is_supported()?

Suppose the VF/SF's own caps report multi_uplink_eswitch=1, lag_master=1
and num_lag_ports < 2. The VF key then becomes guid + [lb|0] + 0x01, which
is 10 bytes. The SF key becomes guid + [lb|0] + 0x00 + 0x01, which is 11
bytes. A PF never sets either marker, so its key is still 8 or 9 bytes.

mlx5_same_hw_devs() requires the lengths to match:

drivers/net/ethernet/mellanox/mlx5/core/dev.c:mlx5_same_hw_devs() {
    ...
	return plen && flen && flen == plen &&
		!memcmp(fsystem_guid, psystem_guid, flen);
}

That means it now returns false for any PF paired with such a VF/SF.

mlx5e_tc_is_vf_tunnel() only reaches that comparison when out_mdev is a
PF and route_mdev is a VF/SF:

drivers/net/ethernet/mellanox/mlx5/core/en_tc.c:mlx5e_tc_is_vf_tunnel() {
    ...
	if (route_mdev->coredev_type != MLX5_COREDEV_VF &&
	    route_mdev->coredev_type != MLX5_COREDEV_SF)
		return false;

	return mlx5e_same_hw_devs(out_priv, route_priv);
}

For a virt-LAG-capable VF/SF route device, will it now always return
false? These are the paths that would be affected:

mlx5e_set_vf_tunnel()
  mlx5e_tc_is_vf_tunnel()
    mlx5e_same_hw_devs()
      mlx5_same_hw_devs()

- In mlx5e_set_vf_tunnel() the check fails and the code jumps to out with
  err = 0. The encap flow is still offloaded, but without the VF vport
  source port rewrite (MLX5_ESW_DEST_CHAIN_WITH_SRC_PORT_CHANGE plus the
  VPORT_TO_REG metadata). The encapsulated packet then goes straight to
  the uplink and skips FDB processing of the VF vport.

- mlx5e_update_vf_tunnel() returns -ENODEV on route updates.

- On decap, mlx5e_tc_tun_route_lookup() no longer sets
  rx_tun_attr->decap_vport to the VF vport.

- In mirred_nic.c, the NIC-mode redirect check

	if (priv->netdev->netdev_ops != out_dev->netdev_ops ||
	    !mlx5e_same_hw_devs(priv, netdev_priv(out_dev))) {

  now rejects redirects between a PF netdev and such a VF/SF netdev with
  "devices are not on same switch HW".

The commit message says:

  "so a VF/SF that cannot join a virt LAG keeps its current key and is
  still identified as the same HW as its PF."

That covers VFs/SFs that cannot join a virt LAG. It doesn't cover the
ones that can, and none of the consumers above are updated.

Should mlx5_same_hw_devs() compare without the VF/SF markers? Or should
the LAG grouping key be kept separate from the key used for same-HW
detection?

> +
> +static u8 (* const mlx5_sw_guid_fields[])(const struct mlx5_core_dev *mdev) = {
> +	mlx5_sw_guid_load_balance,
> +	mlx5_sw_guid_vf,
> +	mlx5_sw_guid_sf,
> +	/* New fields should be added at the end */
> +};

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261116103010.1129666-1-tariqt%40nvidia.com
