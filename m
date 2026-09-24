Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B25615221D2;
	Thu, 24 Sep 2026 17:45:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790271954; cv=none; b=HnxNyt+gvmYFbC4FN+Gsjh0k0UD1vTUo+f5tifLSvmEIQ9XDkLGDa+DRM5P8FukEl/xrnK6a2FtAp55SqLW66goRDswCfglciFswosVYn/VxaQ8v9B2l91wrtlZ4EKahA1A4S9ihkm0O/1hSBjG+2eSjRPLKjLEU7CauMSyVOuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790271954; c=relaxed/simple;
	bh=uW/mCIBA2+qaK4cc07xZOG0ZwLInbDHOIOaha2pyBic=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=LjUDQMDFLSQBACsPDDAOXpqJDTuyyGu3H+hxhLMS80kSLqcytBSrb5f+aQTDv5T8RRqMIAHc8ooXgYnjG4xm7oiievNcqsEi75dHz+JUrP2OaqL1UkrmQKmH2yb6zJbk6/ivXwsN4SSgn+4qj2IDipkSul5jDe/TS8f9bw9bOu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HK7Y4mRB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HK7Y4mRB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92E2C1F000FF;
	Thu, 24 Sep 2026 17:45:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790271952;
	bh=dhPG1dQdE8w4Jf44nehVnN5swpSvLRrMZuxbukNxmOA=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=HK7Y4mRBKWEYU4mT0oSFlgdJiWia8fBwHSKBh/J6qrH/VPB6wzVpxn4YxT+6dnp6I
	 wupLlZIHjHlx4VRV3pQNLDNtz21dGle91BVO6HbxNl1bXbdDcB3rjTaM92xjAz2pz5
	 KX/1QEy2NuOkaXAZ01TnJslSZg3YKCV+anOuboRCW/zMaq8u3lIvsbaWdT8P+eyPPW
	 nCjuQ3OsmUrbhMfa8+XMV8qakDzcBpSuPalHsNd8bavmI3Hx5QN8KBQJCepWTXM+I+
	 x03sJ/IyoPvHakso2AU0x0ELZwPH3vN83RFdSTwGx14VPQc+UtqxviKT34nHzXR1OL
	 dx0afhA8Wh/Tg==
Subject: Re: [PATCH net-next 01/13] net/mlx5e: Assign a random MAC to any
 netdev with a zero MAC address
From: netdev-bot+sashiko@kernel.org
To: tariqt@nvidia.com
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com,
 agoldberger@nvidia.com, cratiu@nvidia.com, gal@nvidia.com, leon@kernel.org,
 linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, mbloch@nvidia.com,
 moshe@nvidia.com, ohartoov@nvidia.com, saeedm@nvidia.com, shayd@nvidia.com
Date: Thu, 24 Sep 2026 17:45:51 +0000
Message-ID: <179027195115.2160803.12005137371690023734@kernel.org>
In-Reply-To: <20260923103830.1183-2-tariqt@nvidia.com>
References: <20260923103830.1183-2-tariqt@nvidia.com>
X-sashiko-severity: Low
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found more severe
issue(s) in other patches of this series. This mail is only an FYI, in case
you want to address the nit picks below when you respin.

Low priority / nit picks for your consideration:

- [Low] The commit message for "net/mlx5e: Assign a random MAC to any
  netdev with a zero MAC address" describes a bug ('A vport group…

Pre-existing issues:
- [Medium] In mlx5e_set_netdev_dev_addr()
  (drivers/net/ethernet/mellanox/mlx5/core/en_main.c), the local `u8…

--

net/mlx5e: Assign a random MAC to any netdev with a zero MAC address

This commit removes the vport_group_manager exception from
mlx5e_set_netdev_dev_addr(). As a result, any mlx5e netdev whose queried
MAC is all zeros gets a random MAC instead of keeping the zero address.

> mlx5e_set_netdev_dev_addr() falls back to a random MAC only when the
> queried address is all-zeros AND the device is not a vport group
> manager.  A vport group manager that comes up with a zero MAC is
> therefore left with an invalid all-zero address.
>
> The vport_group_manager exception is unnecessary: a zero MAC is always
> invalid, regardless of device type. Drop the condition and assign a
> random MAC whenever the queried address is zero, so every netdev comes
> up with a valid address.

[Severity: Low]
The message treats the old behaviour as a bug. However, it has no Fixes:
tag and doesn't say which configuration triggers it.

The check being removed was added on purpose in commit 108805fc196e
("net/mlx5e: Assign random MAC address if needed"). That commit only
covers SR-IOV VFs loaded without an admin-assigned MAC. It used
vport_group_manager (PF/ECPF, which is expected to have a burned-in MAC)
as a stand-in for "not a VF". The new message calls the exception
"unnecessary" but doesn't explain why it was there.

Another commit in the series, "net/mlx5: E-switch, correct stale VF/PF
wording in esw-allowed comments", suggests the real motivation is new FW
that lets a VF act as a nested e-switch manager. If so, this is a new
case rather than a regression.

Could the message do one of these?

  - If a zero-MAC group manager can happen with existing FW, add:

      Fixes: 108805fc196e ("net/mlx5e: Assign random MAC address if needed")

  - Otherwise, say that this is preparation for VF e-switch managers.

The message also leaves out the visible effect on affected devices.
addr_assign_type changes from NET_ADDR_PERM to NET_ADDR_RANDOM, and the
MAC changes on every driver load. Other users of mlx5_query_mac_address()
still see the firmware's zero address, for example the getpermhwaddr path
in en_dcbnl.c and the default GID in rdma.c.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> index fc110a7d16e8d..b0765f07cc3a7 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> @@ -5430,8 +5430,7 @@ static void mlx5e_set_netdev_dev_addr(struct net_device *netdev)
>  	u8 addr[ETH_ALEN];
>  
>  	mlx5_query_mac_address(priv->mdev, addr);
> -	if (is_zero_ether_addr(addr) &&
> -	    !MLX5_CAP_GEN(priv->mdev, vport_group_manager)) {
> +	if (is_zero_ether_addr(addr)) {

[Severity: Medium]
This is a pre-existing issue and was not introduced by this patch.
Since the patch rewrites this condition, though: what does addr hold if
mlx5_query_mac_address() fails?

addr has no initializer, and the return value of the query is ignored.
The path is:

  _mlx5e_probe()->mlx5e_build_nic_netdev()->mlx5e_set_netdev_dev_addr()
    ->mlx5_query_mac_address()->mlx5_query_nic_vport_mac_address()

mlx5_query_nic_vport_mac_address() in vport.c writes the caller's buffer
only when the command succeeds:

	err = mlx5_cmd_exec_inout(mdev, query_nic_vport_context, in, out);
	if (!err)
		ether_addr_copy(addr, &out_addr[2]);

	return err;

The query can fail with a bad FW status. It can also fail with -ENOLINK
during FW internal error, because mlx5_internal_err_ret_value() includes
MLX5_CMD_OP_QUERY_NIC_VPORT_CONTEXT in the opcodes it handles that way.

In that case is_zero_ether_addr() reads whatever was left on the stack.
Unless those bytes are all zero, the random fallback is skipped and
eth_hw_addr_set(netdev, addr) installs them as the MAC.

Can this give the netdev an invalid address, for example one with the
multicast bit set? Can it also expose 6 bytes of kernel stack through
RTM_GETLINK, the sysfs address file or SIOCGIFHWADDR?

With CONFIG_INIT_STACK_ALL_ZERO the buffer starts zeroed, so after this
patch the failure case gets a random MAC. With INIT_STACK_NONE, the
leftover bytes are installed instead.

The unchecked return value and the uninitialized buffer go back to
537e4d2e6fe3c5 and earlier code. No later patch in the series appears to
touch this function.

To reach the goal that "every netdev comes up with a valid address",
would it help to zero-initialize addr, check the return value, and use
something like this?

	if (err || !is_valid_ether_addr(addr))
		eth_hw_addr_random(netdev);

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260923103830.1183-1-tariqt%40nvidia.com
