Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793894974;
	b=hOss1Nnh5IjypwFANnfwlBfT4EpsEW1pspmKs8eOC4SHAZNHqb0pkgYRaEeYGjVbf2Dp
	 1cgq77Eq3afzed0TH+Hwxdbms30TgN6dwgKDjgnEazLcIdtko176zhP9uVCIiQH8E5m8M
	 FgRTA1RxUGhS2ytF9PCmYpjda6VE+ZramQj1c67K5JYYrSGAfgA9j4hq+sRFX5VY4Xfnb
	 4+3fjd7gXlddRUI/QG4NayvfREJ/rZ4ak7AYv+COUQ3q3MNuZngfkA/7n2FU1hIzdmGBJ
	 dZA6S72ruylQU38zJL2bR2SjPPn5SuGa0J6fk7y/2ljbbHIuARwZzvm3WF4sfvIPYgw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793894974;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=EWiL3g5e4XfXva4HSEBtsO8pp51S5/5tmXSAcE0hzww=;
	b=SquetZerOKmxS3WD5kAVUo9ZXLWdR7zceAmF11nG/eG6jpMuf9dxXiXvlEKg8Aqniklo
	 IMfuPjDreLGD5WV0s/CRJYtgaTQBuGX1qe1Yo8TzdLvThICSQd1q9OSJ2bLcPvtxO/fsN
	 jrQOa97sA8wznvIvps7nBeeLTj9olwrV3di+E9z6aAUP81LODBiBRnZqqG/7oNkUSJBFQ
	 4KKE7VJFXZwXTijkQUjNbe9m+ACfLidUuWPtAykWnhlmPVpqQHQZ8+IIcMXZaXFym0Hw/
	 tT4rr3AwzaO+tsn5X2Nwm4Z3DeWaRT13ssUj3bOW0ADIS5AsSBposg6asbYQ7ljlLTg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=U2s3soeY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93CCC606BE83
	for <linux-rdma@vger.kernel.org>; Thu,  5 Nov 2026 16:09:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=U2s3soeY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 432171F00A15;
	Thu,  5 Nov 2026 16:09:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793894974;
	bh=EWiL3g5e4XfXva4HSEBtsO8pp51S5/5tmXSAcE0hzww=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=U2s3soeYDouMDpMtaLD4zA1EFgWZ+p2v6E60D4jSqOW5/NU5LALIjpLmOlxiOEDHm
	 8/dSqd1ZgaUbcScAsC8aL8jiGdSzxxxXqrqvbNkxlggByG5X8vjJ2Fs7cEriUm3mkd
	 AzzT3TGxB7g//kf6XD7zVYc1bwxc8SxEZLjgAXi/FRA5CyXdpknKQQEhLr++yVpatH
	 J4F00ChW/XHni1/BuXBh5mUGqsZjCk+nmUwfyugHO4aRkz4M+a/Qj8NND3GO+PYtMX
	 djG0KqOVdmHUR1zytZF/VfFFTWr6hmpGoATWTtlWfh3zxxRTUqbZOumpF0n/rZfnLC
	 bcQcrnOLtHEEg==
Message-ID: <sashiko-outbox-199429@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v1 07/15] net/xsc: add ethernet netdev registration
Reply-To: sashiko-reviews@lists.linux.dev
To: "Xin Tian" <tianx@yunsilicon.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261104155705.37053-8-tianx@yunsilicon.com>
References: <20261104155650.37053-1-tianx@yunsilicon.com>
 <20261104155705.37053-8-tianx@yunsilicon.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 16:09:33 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:
- [Medium] net/xsc: xsc_eth_open() ignores xsc_set_port_admin_status() fail=
ure
- [Medium] net/xsc: unsynchronized carrier updates in xsc_eth_change_link_s=
tatus()
- [Medium] net/xsc: missing MAC validation and signed char in xsc_eth_l2_ad=
dr_init()
- [Low] net/xsc: missing select AUXILIARY_BUS in YUNSILICON_XSC_ETH Kconfig
--

commit 9545c37957efb4f015ca5b167db9263b28b79635
Author: Xin Tian <tianx@yunsilicon.com>

net/xsc: add ethernet netdev registration

This commit adds the xsc ethernet auxiliary driver to allocate and register=
 a
net_device on top of the core device, initialize MAC address and hardware M=
TU
settings, and implement open, stop, and link status event handling along wi=
th
queue wrapper definitions.

> diff --git a/drivers/net/ethernet/yunsilicon/xsc/net/Kconfig b/drivers/ne=
t/ethernet/yunsilicon/xsc/net/Kconfig
> new file mode 100644
> index 0000000000000..7428b26295b66
> --- /dev/null
> +++ b/drivers/net/ethernet/yunsilicon/xsc/net/Kconfig
> @@ -0,0 +1,17 @@
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (C) 2021-2026, Shanghai Yunsilicon Technology Co., Ltd.
> +# All rights reserved.
> +# Yunsilicon driver configuration
> +#
> +
> +config YUNSILICON_XSC_ETH
> +	tristate "Yunsilicon XSC ethernet driver"
> +	depends on YUNSILICON_XSC_PCI
> +	depends on NET
> +	select PAGE_POOL

[Severity: Low]
Since drivers/net/ethernet/yunsilicon/xsc/net/main.c registers an
auxiliary_driver via module_auxiliary_driver(), should YUNSILICON_XSC_ETH
(or YUNSILICON_XSC_PCI) also select AUXILIARY_BUS so the build does not fail
with undefined references to __auxiliary_driver_register() and
auxiliary_driver_unregister() when no other enabled driver selects
CONFIG_AUXILIARY_BUS?

[ ... ]

> diff --git a/drivers/net/ethernet/yunsilicon/xsc/net/main.c b/drivers/net=
/ethernet/yunsilicon/xsc/net/main.c
> new file mode 100644
> index 0000000000000..21a50085fa879
> --- /dev/null
> +++ b/drivers/net/ethernet/yunsilicon/xsc/net/main.c

[ ... ]

> +static int xsc_eth_change_link_status(struct xsc_adapter *adapter)
> +{
> +	bool link_up;
> +
> +	link_up =3D xsc_eth_get_link_status(adapter);
> +
> +	if (link_up && !netif_carrier_ok(adapter->netdev)) {
> +		netdev_info(adapter->netdev, "Link up\n");
> +		netif_carrier_on(adapter->netdev);
> +	} else if (!link_up && netif_carrier_ok(adapter->netdev)) {
> +		netdev_info(adapter->netdev, "Link down\n");
> +		netif_carrier_off(adapter->netdev);
> +	}
> +
> +	return 0;
> +}
> +
> +/*
> + * Registered with the PCI layer, which runs it on its own workqueue for
> + * every XSC_CMD_EVENT_RESP_CHANGE_LINK event.
> + */
> +static void xsc_eth_link_event_handler(void *arg)
> +{
> +	struct xsc_core_device *xdev =3D arg;
> +	struct xsc_adapter *adapter =3D xdev->eth_priv;
> +	int err;
> +
> +	if (!adapter)
> +		return;
> +
> +	err =3D xsc_eth_change_link_status(adapter);
> +	if (err)
> +		netdev_err(adapter->netdev, "failed to change linkstatus, err=3D%d\n",
> +			   err);
> +}

[Severity: Medium]
How are carrier state updates in xsc_eth_link_event_handler() ->
xsc_eth_change_link_status() synchronized with xsc_eth_open() and
xsc_eth_close()?

xsc_eth_probe() registers xsc_eth_link_event_handler() via
xsc_irq_event_register() while adapter->opened is false, and xsc_eth_close()
leaves it registered after clearing adapter->opened and calling
netif_carrier_off(). When an XSC_CMD_EVENT_RESP_CHANGE_LINK event runs on
xdev->event_wq, xsc_eth_change_link_status() neither checks adapter->opened
nor serializes with xsc_eth_open() or xsc_eth_close():

1. If xsc_eth_change_link_status() runs while the device is closed (or raci=
ng
with xsc_eth_close() before XSC_PORT_DOWN completes in firmware) and sees
link_up =3D=3D true, it calls netif_carrier_on() on a closed interface. If =
the
link later goes down before or during xsc_eth_open(), the else branch in
xsc_eth_open() logs "Link down" without calling netif_carrier_off(), leaving
netif_carrier_ok() stuck true while the link is down.

2. If xsc_eth_open() sees xsc_eth_get_link_status() =3D=3D true and a concu=
rrent
link-down event runs xsc_eth_change_link_status() before xsc_eth_open() cal=
ls
netif_carrier_on(), xsc_eth_change_link_status() sees link_up =3D=3D false =
while
netif_carrier_ok() is still false and does nothing, after which
xsc_eth_open() calls netif_carrier_on() on a down link.

3. In xsc_eth_probe(), register_netdev() is called before setting
xdev->netdev =3D netdev and before calling xsc_irq_event_register(), so an
immediate open after registration can race with initialization of those
fields.

[ ... ]

> +static int xsc_eth_open(struct net_device *netdev)
> +{
> +	struct xsc_adapter *adapter =3D netdev_priv(netdev);
> +	int ret;
> +
> +	if (adapter->opened) {
> +		netdev_err(adapter->netdev, "ndo_open on an already opened device\n");
> +		return 0;
> +	}
> +
> +	if (xsc_eth_get_link_status(adapter))	{
> +		netdev_info(netdev, "Link up\n");
> +		netif_carrier_on(adapter->netdev);
> +	} else {
> +		netdev_info(netdev, "Link down\n");
> +	}
> +
> +	adapter->opened =3D true;
> +
> +	xsc_set_default_xps_cpumasks(adapter);
> +
> +	ret =3D xsc_set_port_admin_status(adapter, XSC_PORT_UP);
> +	if (ret)
> +		netdev_err(netdev, "failed to set port admin status up, err=3D%d\n",
> +			   ret);
> +
> +	return 0;
> +}

[Severity: Medium]
If xsc_set_port_admin_status(adapter, XSC_PORT_UP) fails in xsc_eth_open(),
should xsc_eth_open() roll back adapter->opened and carrier state and return
ret instead of returning 0?

Returning 0 on failure leaves the netdev marked IFF_UP with adapter->opened
set to true and potentially netif_carrier_on() active even though bringing
the port administrative state up in firmware failed. Also, querying
xsc_eth_get_link_status(adapter) before calling
xsc_set_port_admin_status(adapter, XSC_PORT_UP) reads the vport link state
while the port is still administratively down.

[ ... ]

> +static int xsc_eth_get_mac(struct xsc_core_device *xdev, char *mac)
> +{
> +	struct xsc_query_eth_mac_mbox_out *out;
> +	struct xsc_query_eth_mac_mbox_in in;
> +	int err;
> +
> +	out =3D kzalloc_obj(*out, GFP_KERNEL);
> +	if (!out)
> +		return -ENOMEM;
> +
> +	memset(&in, 0, sizeof(in));
> +	in.hdr.opcode =3D cpu_to_be16(XSC_CMD_OP_QUERY_ETH_MAC);
> +
> +	err =3D xsc_cmd_exec(xdev, &in, sizeof(in), out, sizeof(*out));
> +	if (err || out->hdr.status) {
> +		netdev_warn(xsc_dev_to_netdev(xdev),
> +			    "get mac failed! err=3D%d, out.status=3D%u\n",
> +			    err, out->hdr.status);
> +		err =3D -ENOEXEC;
> +		goto exit;
> +	}
> +
> +	memcpy(mac, out->mac, ETH_ALEN);
> +	netdev_dbg(xsc_dev_to_netdev(xdev),
> +		   "get mac %02x:%02x:%02x:%02x:%02x:%02x\n",
> +		   mac[0], mac[1], mac[2], mac[3], mac[4], mac[5]);
> +
> +exit:
> +	kfree(out);
> +	return err;
> +}
> +
> +static void xsc_eth_l2_addr_init(struct xsc_adapter *adapter)
> +{
> +	struct net_device *netdev =3D adapter->netdev;
> +	char mac[6] =3D {0};
> +	int ret =3D 0;
> +
> +	ret =3D xsc_eth_get_mac(adapter->xdev, mac);
> +	if (ret) {
> +		netdev_warn(netdev, "get mac failed %d, generate random mac...",
> +			    ret);
> +		eth_random_addr(mac);
> +		netdev->addr_assign_type =3D NET_ADDR_RANDOM;
> +	} else {
> +		netdev->addr_assign_type =3D NET_ADDR_PERM;
> +	}
> +	eth_hw_addr_set(netdev, mac);
> +
> +	if (netdev->addr_assign_type =3D=3D NET_ADDR_PERM &&
> +	    !is_valid_ether_addr(netdev->perm_addr))
> +		memcpy(netdev->perm_addr, netdev->dev_addr, netdev->addr_len);
> +}

[Severity: Medium]
In xsc_eth_l2_addr_init() and xsc_eth_get_mac(), what happens if firmware
returns an all-zero or multicast MAC address without a command error?

xsc_eth_l2_addr_init() checks !is_valid_ether_addr(netdev->perm_addr) after
eth_hw_addr_set(), which is always true on a freshly allocated net_device
because netdev->perm_addr is still zeroed, rather than checking
is_valid_ether_addr(mac) before accepting the firmware MAC address. If
firmware returns an invalid MAC address, it will be assigned to dev_addr and
perm_addr instead of falling back to eth_hw_addr_random(netdev).

Also, mac is declared as char rather than u8, which causes pointer-sign
mismatches with eth_random_addr() and eth_hw_addr_set(), and sign-extends
bytes >=3D 0x80 when promoted to int for %02x in netdev_dbg() on architectu=
res
where char is signed.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104155650.3705=
3-1-tianx@yunsilicon.com?part=3D7
