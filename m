Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.127.231.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705113;
	b=thpvoH73Ut/BLGpyVY23qKkU7AqMyTPJ0mTbneIaqFYYJmo4KzBpKT9yHR9aSRGDrggp
	 xV/9umL34u0M33cfGSsqqgQZ2O6hscwKE+ms7lav5z1S82EMU5bYjdG8hucU7TqCNtSHB
	 5mpDNFsTrt89yNg0BUIsFEuaIz8ZZCXpWkCkCf4H0L7NkHrNwg5BatGlquviyQPuI1vlp
	 Lnclvx14QwfQ0O2h3XH8uMh+E1jx8MuNAk4XB1V9VHepKZsL9BaTvwZ7VGYPLJ+IKh5rP
	 Wh7o3AnUZCOgfrrYzWDN7uzWckvYnFtZNGumfvChtrxRhFl6VKhxMw0pay1pvwqnEpg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705113;
	h=DMARC-Filter:DKIM-Signature:From:Date:Mime-Version:In-Reply-To:
	 Message-Id:References:Received:Content-Transfer-Encoding:To:Cc:
	 Subject:X-Original-From:X-Lms-Return-Path:User-Agent:Content-Type;
	bh=C8sOYIvaojnOxWbS1cwkZXUmkHLOzB4BNnadqUooFqc=;
	b=GMmXE+GUuD2x1zqUSXOQ3Ar4weWJWybes65MSGA0jubM21i6e79hcUCCcuiIKqXPnUx4
	 iv/vcAU0CHCESileFo91J1Zz4fS0hnYL4OER+qM3QHS9psxzUt4PcneJIkgaWiTgQ0SxG
	 snH6zkB/Eqao+URj787m78ho3kYr42SOzLanAsBtyn5IBhw7kkkiQOPcildK4T6xoQ7gQ
	 XFZQJZPF8zRHaGYPoo+eVth7SN2FxuOW8H0Y11KjTmbU4wKcMKf07qo/4/2evkaLdZIJR
	 wLMqAwYITmNyS5h89avMfJ4nLsgThnYxSxmCxoUUZ6LQwjo2KgDQbfMGneJNAeuLCHw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=yunsilicon.com;
	spf=pass smtp.mailfrom=yunsilicon.com;
	dkim=pass header.d=yunsilicon.com header.i=@yunsilicon.com header.a=rsa-sha256 header.s=feishu2403070942 header.b=f5Lvj189;
	arc=none smtp.remote-ip=209.127.231.48
Received: from va-2-48.ptr.blmpb.com (va-2-48.ptr.blmpb.com [209.127.231.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAC00606A32C
	for <linux-rdma@vger.kernel.org>; Thu, 26 Nov 2026 14:58:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BAC00606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=yunsilicon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yunsilicon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yunsilicon.com header.i=@yunsilicon.com header.a=rsa-sha256 header.s=feishu2403070942 header.b=f5Lvj189
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=feishu2403070942; d=yunsilicon.com; t=1795705109; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=C8sOYIvaojnOxWbS1cwkZXUmkHLOzB4BNnadqUooFqc=;
 b=f5Lvj189As19NYI5a+r1a4EBINQR6s2ODTtlVogzJ6T6G2jdxCVH1E0FlwH1x/N/xLD4B5
 ZPFMhxjB6bBuJHrKFybBu4j1jxjyis1BP1h9KX70ib5SzQPYFAcxnF06SPIA38l7tNTKaz
 +T/B+X107yCZBjiYbK5wOgY6sw5L2C2oQmOjw/Xa8ehgBoY0c/Zxoio1z4nNlBu5Qb4yfn
 cC13MvvVzoOcbn1spWQbtK3TwC2KIr+JF8hGE68AkzSgFJJCIW16Hg/NKwKXL+1K/+FUL8
 w6AsTXLtfH3OCbsYMJdyK/+zDKRSouyKnjrauJMHw3NYfK9Sy5MuvA3j75SxxA==
From: "Xin Tian" <tianx@yunsilicon.com>
Date: Thu, 26 Nov 2026 22:58:20 +0800
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
In-Reply-To: <7bf0875f-f5c5-4894-8e26-433aa40c2e04@lunn.ch>
Message-Id: <25597ed8-a64d-4e6a-bce1-df4abd8cb302@yunsilicon.com>
References: <20261104155650.37053-1-tianx@yunsilicon.com> <20261104155705.37053-8-tianx@yunsilicon.com> <7bf0875f-f5c5-4894-8e26-433aa40c2e04@lunn.ch>
Received: from [127.0.0.1] ([183.193.56.110]) by smtp.feishu.cn with ESMTPS; Thu, 26 Nov 2026 22:58:26 +0800
Content-Transfer-Encoding: quoted-printable
To: "Andrew Lunn" <andrew@lunn.ch>
Cc: "Andrew Lunn" <andrew+netdev@lunn.ch>, 
	"David S. Miller" <davem@davemloft.net>, 
	"Eric Dumazet" <edumazet@google.com>, "Jakub Kicinski" <kuba@kernel.org>, 
	"Paolo Abeni" <pabeni@redhat.com>, "Jason Gunthorpe" <jgg@ziepe.ca>, 
	"Leon Romanovsky" <leon@kernel.org>, 
	"Junxian Huang" <huangjunxian6@hisilicon.com>, <weihg@yunsilicon.com>, 
	<linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>, 
	<linux-rdma@vger.kernel.org>
Subject: Re: [PATCH v1 07/15] net/xsc: add ethernet netdev registration
X-Original-From: Xin Tian <tianx@yunsilicon.com>
X-Lms-Return-Path: <lba+26b084913+e148d3+vger.kernel.org+tianx@yunsilicon.com>
User-Agent: Mozilla Thunderbird
Content-Type: text/plain; charset=UTF-8

Hi Andrew,

Thanks for the review.=C2=A0 I've sent a v2 that is a much smaller
ethernet-only series, and gone through your comments.

On 11/8/2026 5:03 AM, Andrew Lunn wrote:
>> @@ -1,7 +1,6 @@
>>   # SPDX-License-Identifier: GPL-2.0
>>   # Copyright (C) 2021-2026, Shanghai Yunsilicon Technology Co., Ltd.
>>   # All rights reserved.
>> -#
>>   # Yunsilicon driver configuration
>>   #
> Please don't include hunks like this. Was this added be a previous
> patch in this patchset? Then fix it back then. If this is already in
> mainline, add a patch making these 'whitespace' changed.
That Kconfig hunk is gone from v2.
>> +static int xsc_eth_open(struct net_device *netdev)
>> +{
>> +	struct xsc_adapter *adapter =3D netdev_priv(netdev);
>> +	int ret;
>> +
>> +	if (adapter->opened) {
>> +		netdev_err(adapter->netdev, "ndo_open on an already opened device\n")=
;
>> +		return 0;
>> +	}
>> +
> How does this happen?
>
> And returning 0 seems odd. Something bad has happened, so at least
> EBUSY.
The "already opened" check is unreachable - the netdev core serialises
ndo_open against the interface state under the rtnl lock.=C2=A0 I dropped t=
he
branch rather than return EBUSY.
>> +
>> +	xsc_set_default_xps_cpumasks(adapter);
>> +
>> +	ret =3D xsc_set_port_admin_status(adapter, XSC_PORT_UP);
>> +	if (ret)
>> +		netdev_err(netdev, "failed to set port admin status up, err=3D%d\n",
>> +			   ret);
>> +
>> +	return 0;
> return err?
>
I changed xsc_set_port_admin_status() to return void.=C2=A0 The open flow m=
ust
not depend on this call: it's issued after open has otherwise completed,
the firmware can legitimately reject it (VF, port_link_en, arbitration
between functions, old firmware), and the real carrier is driven by the
link events and QUERY_VPORT_STATE, not by its return value.=C2=A0 Failing o=
pen
on it would turn normal cases into errors, so we log and carry on.
>> +}
>> +
>> +static int xsc_eth_close(struct net_device *netdev)
>> +{
>> +	struct xsc_adapter *adapter =3D netdev_priv(netdev);
>> +	int ret;
>> +
>> +	if (!adapter->opened)
>> +		return 0;
> How does this happen?
>
> Is there an error code ENOTBUSY?
Same as above - unreachable, dropped the "not opened" branch.
>> +static void xsc_eth_build_nic_netdev(struct xsc_adapter *adapter)
>> +{
>> +	struct net_device *netdev =3D adapter->netdev;
>> +
>> +	/* Set up network device as normal. */
>> +	netdev->netdev_ops =3D &xsc_netdev_ops;
>> +
>> +	netdev->min_mtu =3D SW_DEFAULT_MTU;
>> +	netdev->max_mtu =3D SW_DEFAULT_MTU;
>> +	/*mtu - macheaderlen - ipheaderlen should be aligned in 8B*/
>> +	netdev->mtu =3D SW_DEFAULT_MTU;
> What has MTU got to do with alignment?
You're right, the comment made no sense.=C2=A0 Removed.
>> +static int xsc_eth_get_mac(struct xsc_core_device *xdev, char *mac)
>> +{
>> +	struct xsc_query_eth_mac_mbox_out *out;
>> +	struct xsc_query_eth_mac_mbox_in in;
>> +	int err;
>> +
>> +	out =3D kzalloc_obj(*out, GFP_KERNEL);
>> +	if (!out)
>> +		return -ENOMEM;
>> +
>> +	memset(&in, 0, sizeof(in));
>> +	in.hdr.opcode =3D cpu_to_be16(XSC_CMD_OP_QUERY_ETH_MAC);
>> +
>> +	err =3D xsc_cmd_exec(xdev, &in, sizeof(in), out, sizeof(*out));
>> +	if (err || out->hdr.status) {
>> +		netdev_warn(xsc_dev_to_netdev(xdev),
>> +			    "get mac failed! err=3D%d, out.status=3D%u\n",
>> +			    err, out->hdr.status);
>> +		err =3D -ENOEXEC;
>> +		goto exit;
>> +	}
>> +
>> +	memcpy(mac, out->mac, ETH_ALEN);
> There are helpers for copying MAC addresses around.
Now uses ether_addr_copy().
>> +static int xsc_eth_probe(struct auxiliary_device *adev,
>> +			 const struct auxiliary_device_id *adev_id)
>> +{
> ...
>
>> +	err =3D register_netdev(netdev);
>> +	if (err) {
>> +		netdev_err(netdev, "register_netdev failed, err=3D%d\n", err);
>> +		goto err_free_stats;
>> +	}
> The stack can up the interface and start sending packets before this
> function call returns. NFS root often does that.
>
>> +
>> +	xdev->netdev =3D netdev;
>
> Does anything bad happens in open and packet Rx and Tx if xdev->netdev
> =3D=3D NULL because this assignment has not happened yet.
>
>> +
>> +	xsc_irq_event_register(xdev, xsc_eth_link_event_handler);
> And does anything bad happen if the event handler is not registered?
The interface no longer keeps a xdev->netdev; it's looked up via
xdev->eth_priv, which is set before register_netdev(), so open/Rx/Tx
never see NULL.=C2=A0 The link event handler is now registered before
register_netdev(), so a port event that arrives right after
registration is not lost.
>> +static void xsc_eth_remove(struct auxiliary_device *adev)
>> +{
>> +	struct xsc_adev *xsc_adev =3D container_of(adev, struct xsc_adev, adev=
);
>> +	struct xsc_core_device *xdev =3D xsc_adev->xdev;
>> +	struct xsc_adapter *adapter;
>> +
>> +	if (!xdev)
>> +		return;
> How does that happen?
>> +
>> +	adapter =3D xdev->eth_priv;
>> +	if (!adapter)
>> +		return;
> How does that happen?
Both gone - the auxiliary bus only calls remove() for devices that
probed successfully, so the checks were dead.
>> +
>> +	/* Stop link events reaching this adapter and wait out one already in
>> +	 * flight, which would otherwise touch the memory freed below.
>> +	 */
>> +	xsc_irq_event_unregister(xdev);
>> +
>> +	/* Runs ndo_stop(), so the queues and the HCA are shut down first. */
>> +	unregister_netdev(adapter->netdev);
>> +
>> +	/* Must precede free_netdev(): the adapter lives in the netdev priv. *=
/
>> +	xsc_eth_nic_cleanup(adapter);
>> +	kvfree(adapter->stats);
>> +	free_netdev(adapter->netdev);
>> +
>> +	xdev->netdev =3D NULL;
>> +	xdev->eth_priv =3D NULL;
>> +static inline void xsc_tx_dma_unmap(struct device *dev, struct xsc_sq_d=
ma *dma)
>> +{
>> +	switch (dma->type) {
>> +	case XSC_DMA_MAP_SINGLE:
>> +		dma_unmap_single(dev, dma->addr, dma->size, DMA_TO_DEVICE);
>> +		break;
>> +	case XSC_DMA_MAP_PAGE:
>> +		dma_unmap_page(dev, dma->addr, dma->size, DMA_TO_DEVICE);
>> +		break;
>> +	default:
>> +		break;
>> +	}
> This should probably not be hiding away somewhere in a header file.
That whole tx_dma_unmap abstraction is gone in v2; TX unmaps directly
now.
>> +static inline struct xsc_cqe *xsc_cqwq_get_cqe(struct xsc_cqwq *wq)
>> +{
>> +	u32 ci =3D xsc_cqwq_get_ci(wq);
>> +	u8 cqe_ownership_bit;
>> +	struct xsc_cqe *cqe;
>> +	u8 sw_ownership_val;
>> +
>> +	cqe =3D xsc_cqwq_get_cqe_buff(wq, ci);
>> +
>> +	cqe_ownership_bit =3D !!(le32_to_cpu(cqe->data1) & XSC_CQE_DATA1_OWNER=
);
>> +	sw_ownership_val =3D xsc_cqwq_get_wrap_cnt(wq) & 1;
>> +
>> +	if (cqe_ownership_bit !=3D sw_ownership_val)
>> +		return NULL;
>> +
>> +	/* ensure cqe content is read after cqe ownership bit */
>> +	dma_rmb();
>> +
>> +	return cqe;
> This is also a bit big for an include file inline. Plus that dma_rmb()
> should not be hiding, it should be in plain sight.
xsc_cqwq_get_cqe() moved into xsc_eth_txrx.c (the header only declares
it), and dma_rmb() is now at the call sites in the poll loop, in plain=20
sight.

Thanks,

Xin
