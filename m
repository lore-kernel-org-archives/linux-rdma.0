Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=156.67.10.101
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794085405;
	b=1octOSD9P1Tp2OZ7NIZiVowQYqsCUosVY0mqyBM3VrV6f4hZC4Xj5mJWk3OiqBJOygwE
	 CA6riCvUaH5bBzV7GCc+fjR27hjTA3+sDnWSy0GFUvHAv2bIX11OUEk/htQzOkl14QJns
	 WMGjgO2tstmusneUp0r1VIvpa3Zxp4GwBOgiezks8frmNBr3o2ufPUlgpE+mRSUGpzMmr
	 ik9VC8caikUv2v9XNJRTXon+vSOzmcqy5A62TbGnnSAEz1mFqOZD5xD0UwSigG1EHem5P
	 nTlV6zben4vgq1b75aBdRc3jqYlfkSsvBeOj815jVh6U0iFIwwYWa+esA9CMG8iWiSQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794085405;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To;
	bh=5sO1lU80ZjfwUdMSovSpngbH5Rby3bvgBLbLRv/3gAA=;
	b=MdqfK/d8LEa9benuK4c/hRXSGO5BYG49kRQR4Wwml5iCcVtckez/iezX2Q1urFMm7fw3
	 jdSK2NiRuWVkQHkZi7zFEt2Nvd7BzTFec/0mOmQ98OVcduz/HCZ/E359Tk5QDANK0JwQc
	 aQHHaaRYskREZSzKVQdBCRno1OAkTQ3+k0YOE9rNkkM+NFWYRj8LSFBZUSuo7yD7GQgZB
	 Kuiv88T1wLciGPoGDyd7V507k6OKWoYk0/rT5/sf7IdK7h3PPUeFwOxglMUV5ZnPQA682
	 tOtjhvQq3YEYSs4om02Penem/zKCKNvmw6TiTifipNhJzuguuO+fswU4KmBGPtX5S3w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=lunn.ch;
	spf=pass smtp.mailfrom=lunn.ch;
	dkim=pass header.d=lunn.ch header.i=@lunn.ch header.a=rsa-sha256 header.s=20171124 header.b=SYKUJMHL;
	arc=none smtp.remote-ip=156.67.10.101
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C6D9606A326;
	Sat,  7 Nov 2026 21:03:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3C6D9606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lunn.ch
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lunn.ch
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=lunn.ch header.i=@lunn.ch header.a=rsa-sha256 header.s=20171124 header.b=SYKUJMHL
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=5sO1lU80ZjfwUdMSovSpngbH5Rby3bvgBLbLRv/3gAA=; b=SYKUJMHLwSJPTJe73wnodG2khs
	9fKnuVmlmOEP8MTRsWeWUOAi6Ae+AnYD1Vsp7zxxcTaPXOSPQ5SSEq5mmiuH7gYBpMUz1gNrLAtdq
	WRh2M7SvMzOuh4hH/P7cXahahjCMt6Pe3TqvX2egw42jAVieBG266UPrQT9rL6pfvobs=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1xPnYz-00F0OA-Cu; Sat, 07 Nov 2026 22:03:01 +0100
Date: Sat, 7 Nov 2026 22:03:01 +0100
From: Andrew Lunn <andrew@lunn.ch>
To: Xin Tian <tianx@yunsilicon.com>
Cc: Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
	Junxian Huang <huangjunxian6@hisilicon.com>, weihg@yunsilicon.com,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org
Subject: Re: [PATCH v1 07/15] net/xsc: add ethernet netdev registration
Message-ID: <7bf0875f-f5c5-4894-8e26-433aa40c2e04@lunn.ch>
References: <20261104155650.37053-1-tianx@yunsilicon.com>
 <20261104155705.37053-8-tianx@yunsilicon.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261104155705.37053-8-tianx@yunsilicon.com>

> @@ -1,7 +1,6 @@
>  # SPDX-License-Identifier: GPL-2.0
>  # Copyright (C) 2021-2026, Shanghai Yunsilicon Technology Co., Ltd.
>  # All rights reserved.
> -#
>  # Yunsilicon driver configuration
>  #

Please don't include hunks like this. Was this added be a previous
patch in this patchset? Then fix it back then. If this is already in
mainline, add a patch making these 'whitespace' changed.

> +static int xsc_eth_open(struct net_device *netdev)
> +{
> +	struct xsc_adapter *adapter = netdev_priv(netdev);
> +	int ret;
> +
> +	if (adapter->opened) {
> +		netdev_err(adapter->netdev, "ndo_open on an already opened device\n");
> +		return 0;
> +	}
> +

How does this happen?

And returning 0 seems odd. Something bad has happened, so at least
EBUSY.

> +
> +	xsc_set_default_xps_cpumasks(adapter);
> +
> +	ret = xsc_set_port_admin_status(adapter, XSC_PORT_UP);
> +	if (ret)
> +		netdev_err(netdev, "failed to set port admin status up, err=%d\n",
> +			   ret);
> +
> +	return 0;

return err?


> +}
> +
> +static int xsc_eth_close(struct net_device *netdev)
> +{
> +	struct xsc_adapter *adapter = netdev_priv(netdev);
> +	int ret;
> +
> +	if (!adapter->opened)
> +		return 0;

How does this happen?

Is there an error code ENOTBUSY? 

> +static void xsc_eth_build_nic_netdev(struct xsc_adapter *adapter)
> +{
> +	struct net_device *netdev = adapter->netdev;
> +
> +	/* Set up network device as normal. */
> +	netdev->netdev_ops = &xsc_netdev_ops;
> +
> +	netdev->min_mtu = SW_DEFAULT_MTU;
> +	netdev->max_mtu = SW_DEFAULT_MTU;
> +	/*mtu - macheaderlen - ipheaderlen should be aligned in 8B*/
> +	netdev->mtu = SW_DEFAULT_MTU;

What has MTU got to do with alignment?

> +static int xsc_eth_get_mac(struct xsc_core_device *xdev, char *mac)
> +{
> +	struct xsc_query_eth_mac_mbox_out *out;
> +	struct xsc_query_eth_mac_mbox_in in;
> +	int err;
> +
> +	out = kzalloc_obj(*out, GFP_KERNEL);
> +	if (!out)
> +		return -ENOMEM;
> +
> +	memset(&in, 0, sizeof(in));
> +	in.hdr.opcode = cpu_to_be16(XSC_CMD_OP_QUERY_ETH_MAC);
> +
> +	err = xsc_cmd_exec(xdev, &in, sizeof(in), out, sizeof(*out));
> +	if (err || out->hdr.status) {
> +		netdev_warn(xsc_dev_to_netdev(xdev),
> +			    "get mac failed! err=%d, out.status=%u\n",
> +			    err, out->hdr.status);
> +		err = -ENOEXEC;
> +		goto exit;
> +	}
> +
> +	memcpy(mac, out->mac, ETH_ALEN);

There are helpers for copying MAC addresses around.

> +static int xsc_eth_probe(struct auxiliary_device *adev,
> +			 const struct auxiliary_device_id *adev_id)
> +{

...

> +	err = register_netdev(netdev);
> +	if (err) {
> +		netdev_err(netdev, "register_netdev failed, err=%d\n", err);
> +		goto err_free_stats;
> +	}

The stack can up the interface and start sending packets before this
function call returns. NFS root often does that.

> +
> +	xdev->netdev = netdev;


Does anything bad happens in open and packet Rx and Tx if xdev->netdev
== NULL because this assignment has not happened yet.

> +
> +	xsc_irq_event_register(xdev, xsc_eth_link_event_handler);

And does anything bad happen if the event handler is not registered?

> +static void xsc_eth_remove(struct auxiliary_device *adev)
> +{
> +	struct xsc_adev *xsc_adev = container_of(adev, struct xsc_adev, adev);
> +	struct xsc_core_device *xdev = xsc_adev->xdev;
> +	struct xsc_adapter *adapter;
> +
> +	if (!xdev)
> +		return;

How does that happen?

> +
> +	adapter = xdev->eth_priv;
> +	if (!adapter)
> +		return;

How does that happen?

> +
> +	/* Stop link events reaching this adapter and wait out one already in
> +	 * flight, which would otherwise touch the memory freed below.
> +	 */
> +	xsc_irq_event_unregister(xdev);
> +
> +	/* Runs ndo_stop(), so the queues and the HCA are shut down first. */
> +	unregister_netdev(adapter->netdev);
> +
> +	/* Must precede free_netdev(): the adapter lives in the netdev priv. */
> +	xsc_eth_nic_cleanup(adapter);
> +	kvfree(adapter->stats);
> +	free_netdev(adapter->netdev);
> +
> +	xdev->netdev = NULL;
> +	xdev->eth_priv = NULL;

> +static inline void xsc_tx_dma_unmap(struct device *dev, struct xsc_sq_dma *dma)
> +{
> +	switch (dma->type) {
> +	case XSC_DMA_MAP_SINGLE:
> +		dma_unmap_single(dev, dma->addr, dma->size, DMA_TO_DEVICE);
> +		break;
> +	case XSC_DMA_MAP_PAGE:
> +		dma_unmap_page(dev, dma->addr, dma->size, DMA_TO_DEVICE);
> +		break;
> +	default:
> +		break;
> +	}

This should probably not be hiding away somewhere in a header file.

> +static inline struct xsc_cqe *xsc_cqwq_get_cqe(struct xsc_cqwq *wq)
> +{
> +	u32 ci = xsc_cqwq_get_ci(wq);
> +	u8 cqe_ownership_bit;
> +	struct xsc_cqe *cqe;
> +	u8 sw_ownership_val;
> +
> +	cqe = xsc_cqwq_get_cqe_buff(wq, ci);
> +
> +	cqe_ownership_bit = !!(le32_to_cpu(cqe->data1) & XSC_CQE_DATA1_OWNER);
> +	sw_ownership_val = xsc_cqwq_get_wrap_cnt(wq) & 1;
> +
> +	if (cqe_ownership_bit != sw_ownership_val)
> +		return NULL;
> +
> +	/* ensure cqe content is read after cqe ownership bit */
> +	dma_rmb();
> +
> +	return cqe;

This is also a bit big for an include file inline. Plus that dma_rmb()
should not be hiding, it should be in plain sight.

	Andrew
