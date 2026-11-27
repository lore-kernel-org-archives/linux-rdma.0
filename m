Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795791493;
	b=dGQuQu5E00cXHLEdwKEq7adh5pdYKkf1ZXGDTcIxoa3AZl3c5GQRIoPRzE70WoAcDbWM
	 2RkFVIUWXM+lPDaVyq+/KnMEJS7r8/PfIU+HS0KHv6SO/+MXw0+WHye2S0aA2ulZeg79+
	 keoZ0EnIoZix7G4uxPyr7sB9ieIlLTZ8JBL77K9B3Uuatqe5vrnaqIzpAhx5CRQ5PRInY
	 v9rcaMEGzg5KbiNFIbS1n4yqf+uywCn5IwYcfq0F0xvoFidYGgwYkq/+o0whrvcadfqbL
	 4syw22kTTUn80NXOAJDcGqu7texGAtjeWBjR4cniw5mWNaFa1275etDLcPrZSxg2VFQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795791493;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=U1pS98C1MYYaPn+zo1XszYOPAQGN7aWYQw4m45Wj/A4=;
	b=fj2LMys9ZV4lNMixBP6CJDPppXeX7zKJ93HXSvdLUe4idj9BjMFGpCuh8LfKcfURzuHE
	 LolpL1C5oiXygmVI4oxkKLELVc2OfKgOMday4/JMuMzZZvYBcPe4GuFbeURpnSfpHMZvS
	 ZkVkRkr44B6mnLfamh+2wDm0sMU3XJ/Ia7CvZ8Qb6XFhoBCnXBLUloQ95kyndjV2jMOgc
	 Ws6wpDmPz6oMIfKktyggqmMTTaUKskZgrSCUBtNtWuPx7+lm7IQy2uc3u8zuD/AvYURVQ
	 5w8sJF0GMOMU5lTO3Zjw/AK6JFsUD15CJP+zWKhxIuUHcvmmnaB/qtSAXYhMkCeR/hg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OuogaF2f;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D94EC606A31F
	for <linux-rdma@vger.kernel.org>; Fri, 27 Nov 2026 14:58:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OuogaF2f
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB3941F00897;
	Fri, 27 Nov 2026 14:58:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795791493;
	bh=U1pS98C1MYYaPn+zo1XszYOPAQGN7aWYQw4m45Wj/A4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=OuogaF2fqaFC2N8JGxBaVai7VIEGrfjC8v2emwX0seLk6RX+U+Bj5CcPejHR8qL4F
	 i6fH6rmYmi/t/6yOvaJJTMmY2eI26Gt/uPrPELexKCeEdyCXaHd+G4d8lSgQBwaVtu
	 4+vn6kFKGrwP95ik4hbDFNKtGkIx2xkUcioXXzOxdFkyFX+LtCP4An3sryB15K659A
	 02FxLMa1cfMbSUVKsArRot0U6pV9gyQ4zkZXpFtNiwawzf2bsIVO4iIbICwGdxwk/E
	 E2eH/3Dp2eXSI/Iu6mnLlwZKkd59KtkSWItFv+U4iS7CGC3vyL09U6cX11YyQuwHOT
	 xFZYhh6odCidQ==
Message-ID: <sashiko-outbox-237642@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 09/11] net/xsc: report link state changes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Xin Tian" <tianx@yunsilicon.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261126145736.70868-10-tianx@yunsilicon.com>
References: <20261126145711.70868-1-tianx@yunsilicon.com>
 <20261126145736.70868-10-tianx@yunsilicon.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 27 Nov 2026 14:58:11 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Medium] net/xsc: unsynchronized carrier updates in
  xsc_eth_link_event_handler()
--

commit e468bd52287d3b4539c22501cb440d036af1c666
Author: Xin Tian <tianx@yunsilicon.com>

net/xsc: report link state changes

This commit queries virtual port state to update the netdev carrier and
registers an event handler for PCI link state change notifications.

> diff --git a/drivers/net/ethernet/yunsilicon/xsc/net/main.c b/drivers/net=
/ethernet/yunsilicon/xsc/net/main.c
> index 1c7bbc27d8c4f..75a6abd6ed136 100644
> --- a/drivers/net/ethernet/yunsilicon/xsc/net/main.c
> +++ b/drivers/net/ethernet/yunsilicon/xsc/net/main.c
> @@ -721,6 +721,62 @@ static void xsc_eth_sw_deinit(struct xsc_adapter *ad=
apter)
>  	xsc_eth_close_channels(adapter);
>  }
> =20
> +static int xsc_eth_get_link_status(struct xsc_adapter *adapter, bool *li=
nk_up)
> +{
> +	struct xsc_core_device *xdev =3D adapter->xdev;
> +	u8 state;
> +	int err;
> +
> +	err =3D xsc_core_query_vport_state(xdev, 0, &state);
> +	if (err)
> +		return err;
> +
> +	*link_up =3D state;
> +	return 0;
> +}
> +
> +static int xsc_eth_change_link_status(struct xsc_adapter *adapter)
> +{
> +	bool link_up;
> +	int err;
> +
> +	err =3D xsc_eth_get_link_status(adapter, &link_up);
> +	if (err) {
> +		netdev_err(adapter->netdev, "failed to query link status, err=3D%d\n",
> +			   err);
> +		return err;
> +	}
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
> +	if (!adapter || !adapter->opened)
> +		return;
> +
> +	err =3D xsc_eth_change_link_status(adapter);
> +	if (err)
> +		netdev_err(adapter->netdev, "failed to change linkstatus, err=3D%d\n",
> +			   err);
> +}
> +
>  static bool xsc_get_pct_drop_config(struct xsc_core_device *xdev)
>  {
>  	return (xdev->pdev->device =3D=3D XSC_MC_PF_DEV_ID) ||
> @@ -813,6 +869,7 @@ static void xsc_set_port_admin_status(struct xsc_adap=
ter *adapter,
>  static int xsc_eth_open(struct net_device *netdev)
>  {
>  	struct xsc_adapter *adapter =3D netdev_priv(netdev);
> +	bool link_up;
>  	int ret;
> =20
>  	ret =3D xsc_eth_sw_init(adapter);
> @@ -823,6 +880,16 @@ static int xsc_eth_open(struct net_device *netdev)
>  	if (ret)
>  		goto err_sw_deinit;
> =20
> +	ret =3D xsc_eth_get_link_status(adapter, &link_up);
> +	if (ret) {
> +		netdev_warn(netdev, "failed to query link status, err=3D%d\n", ret);
> +	} else if (link_up) {
> +		netdev_info(netdev, "Link up\n");
> +		netif_carrier_on(adapter->netdev);
> +	} else {
> +		netdev_info(netdev, "Link down\n");
> +	}
> +
>  	adapter->opened =3D true;
> =20
>  	xsc_set_port_admin_status(adapter, XSC_PORT_UP);

[Severity: Medium]
Can xsc_eth_link_event_handler() race with xsc_eth_close() and
xsc_eth_open() and leave the netdev carrier state out of sync?

xsc_eth_link_event_handler() checks adapter->opened without locking and
then sleeps in xsc_core_query_vport_state() -> xsc_cmd_exec(), while
xsc_eth_close() clears adapter->opened and calls netif_carrier_off()
without waiting for in-flight link event work:

drivers/net/ethernet/yunsilicon/xsc/net/main.c:xsc_eth_close() {
	adapter->opened =3D false;

	netif_carrier_off(adapter->netdev);
    ...
}

CPU0 (event_wq)                   CPU1
xsc_eth_link_event_handler()
  if (!adapter->opened)
  xsc_eth_change_link_status()
    xsc_eth_get_link_status()
      /* sleeps in cmd exec */
                                  xsc_eth_close()
                                    adapter->opened =3D false;
                                    netif_carrier_off(netdev);
    netif_carrier_on(netdev);
      /* carrier enabled while closed */

Because xsc_eth_open() only calls netif_carrier_on() when link_up is true
and does not call netif_carrier_off() in the else branch, if the physical
link goes down while the interface is closed, a subsequent xsc_eth_open()
logs "Link down" but leaves netif_carrier_ok() true.

Also in xsc_eth_open(), xsc_eth_get_link_status() runs before
adapter->opened =3D true and before xsc_set_port_admin_status(adapter,
XSC_PORT_UP).  That queries the vport while it is still administratively
down from a prior close, and any link change event arriving between
xsc_eth_get_link_status() and adapter->opened =3D true is dropped by
xsc_eth_link_event_handler().

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261126145711.7086=
8-1-tianx@yunsilicon.com?part=3D9
