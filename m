Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795795080;
	b=KTORLsLZe9NS1X33i70oUmyfdIonhLdyXmbG7l5ACmPnDH2ufgNSsribRDcvEnXP9lMh
	 z4uNzgf3f2cGYOf219l8w1W7FHosDnYn9ngROKETAFSkEQj13VabDyezuCK72UxiE2hI9
	 34SNVbHlGRccOIETTLdE9KtxaysnzqWKlOGQuo/8QbQdOu5V/pWU6Du3e1dkFgOPSZEQs
	 tmgS17XsGCYwmDkgYT7G0XbH9RJN/rr6r4XwAeHDxufxM6fNUB3uAthkOjYxf/W2OnqjB
	 8PHU/EJbtBRBBI1Zyi2fAZEvafKfU6dMb1E8jP3qL5r0xsV8asbRQAK+JW1EUVBEciA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795795080;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=+OsaqsCkNdK9D8OyjJZhYRSnDVykyRA4x+r6AKpq0wk=;
	b=mpAnIM8zfW4gsj0mJWdwN7s5CgaqxFn/OA9I8lnU0VhZ/tdsclCgVaeIvVW0k7E5nQOy
	 7O5B+HuFeBn41hmvvdLTJMBHSlTK6GFwaX0ND73CvB/fMW+VKjo5WsDvGiOscyHw48cjL
	 15pgKFhU1aPDXT6KSGkBSGsIq8Fpndt70MCI7pDuTT0g50sntcIZLyAAW/paLaCdHmwgX
	 7ENXCvUMntJ+8Meg5s11aVUUe65fHAciSGbntTMKeGXhFUkE3DGRKacHD1+9T8KBLbHZc
	 nqgN3A1qsSHkst4pwwd5vU/RUIHp1f0cZNdQEzLd3jGRHcQafkH6yFUgEP1FICTVnFw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QGl5RZKP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B329E606A69B;
	Fri, 27 Nov 2026 15:58:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QGl5RZKP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 741181F00A21;
	Fri, 27 Nov 2026 15:57:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795795080;
	bh=+OsaqsCkNdK9D8OyjJZhYRSnDVykyRA4x+r6AKpq0wk=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=QGl5RZKPp3CqfzSCKUEx27+hGxnSyeqhLXDG3IkFsoM3N0uM4ltV/sYYQECiAnpN3
	 H6RjcAol9UcH+jyHiQhpv5W+Vb01woTiVgrNeFlBlAQwBY4YRB1dLN8dobqybHaY1P
	 KGuWNqopWDnBPZJsCwGEP/k2rGNpZPRPcT5YCIofjnlaHOv0j+Tr2msQbpftr2jCmp
	 Hx2bIDjLwTmCWMn6KUHJBKfiJ9LXv6Dg4mUEA/KjQlQU2kmhgwoHN0M9b2kXTz8DL1
	 ANhsgm6+M7K3KnSOjSkfqn9kDotMioQxy3sxd39hLEULQlBZ/lgvBe0cqDwDQBRiED
	 bHZ3rzRuDiYqg==
Subject: Re: [PATCH v2 07/11] net/xsc: add the ethernet netdev
From: netdev-bot+sashiko@kernel.org
To: tianx@yunsilicon.com
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, jgg@ziepe.ca, leon@kernel.org,
 huangjunxian6@hisilicon.com, weihg@yunsilicon.com,
 linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
 linux-rdma@vger.kernel.org, kerneljasonxing@gmail.com
Date: Fri, 27 Nov 2026 15:57:58 +0000
Message-ID: <179579507899.3135.7831191822723271418@kernel.org>
In-Reply-To: <20261126145730.70868-8-tianx@yunsilicon.com>
References: <20261126145730.70868-8-tianx@yunsilicon.com>
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

Thank you for your contribution! Sashiko AI review found 5 potential
issue(s) to consider.

Critical: 0 · High: 0 · Medium: 1 · Low: 4

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] At this commit, xsc_eth_probe() registers a netdev whose ops
  table (xsc_netdev_ops in…
- [Low] This patch adds calls to the auxiliary bus API.
- [Low] At this commit, xsc_eth_wq.h declares xsc_eth_cqwq_create(),
  xsc_eth_wq_cyc_create(), xsc_eth_wq_destroy() and…
- [Low] Several comments do not match the code.
- [Low] xsc_eth_l2_addr_init()
  (drivers/net/ethernet/yunsilicon/xsc/net/main.c:156) declares `char…

--

net/xsc: add the ethernet netdev

This patch registers an ethernet auxiliary device from the xsc PCI core and
adds an auxiliary driver that creates a netdev. The netdev queries the MAC
address, sets the hardware MTU, and implements ndo_open/ndo_stop. The queue
and data path are left to follow-up patches.

> diff --git a/drivers/net/ethernet/yunsilicon/xsc/net/Kconfig b/drivers/net/ethernet/yunsilicon/xsc/net/Kconfig
> new file mode 100644
> index 0000000000000..7428b26295b66
> --- /dev/null
> +++ b/drivers/net/ethernet/yunsilicon/xsc/net/Kconfig
> @@ -0,0 +1,17 @@

[ ... ]

> +config YUNSILICON_XSC_ETH
> +	tristate "Yunsilicon XSC ethernet driver"
> +	depends on YUNSILICON_XSC_PCI
> +	depends on NET
> +	select PAGE_POOL

[Severity: Low]

Should this entry select AUXILIARY_BUS? xsc_eth uses
module_auxiliary_driver(). xsc_pci now builds adev.o, and xsc_adev_add()
in that file calls auxiliary_device_init() and auxiliary_device_add().

AUXILIARY_BUS is a bool with no prompt in drivers/base/Kconfig:

config AUXILIARY_BUS
	bool

auxiliary.o is only built under obj-$(CONFIG_AUXILIARY_BUS), and
include/linux/auxiliary_bus.h has no stubs for the disabled case.

If nothing else in the config selects AUXILIARY_BUS, won't the link or
modpost fail with undefined references to __auxiliary_device_add() and
__auxiliary_driver_register()?

At the end of the series, neither YUNSILICON_XSC_PCI nor YUNSILICON_XSC_ETH
selects it.

> diff --git a/drivers/net/ethernet/yunsilicon/xsc/net/main.c b/drivers/net/ethernet/yunsilicon/xsc/net/main.c
> new file mode 100644
> index 0000000000000..b9e75d7e14e78
> --- /dev/null
> +++ b/drivers/net/ethernet/yunsilicon/xsc/net/main.c
> @@ -0,0 +1,263 @@

[ ... ]

> +static const struct net_device_ops xsc_netdev_ops = {
> +	.ndo_open		= xsc_eth_open,
> +	.ndo_stop		= xsc_eth_close,
> +};

[Severity: Medium]

The commit message says the netdev "must not be brought up in this state".
Does anything enforce that?

xsc_netdev_ops has no ndo_start_xmit. xsc_eth_open() always returns 0, so
the interface can be brought up once xsc_eth_probe() has called
register_netdev().

Carrier stays off at this commit, so the qdisc path drops packets. netpoll
does not check carrier, though:

__netpoll_send_skb()
    if (!npinfo || !netif_running(dev) || !netif_device_present(dev)) {
    ...
    netpoll_start_xmit()
        netdev_start_xmit()
            ops->ndo_start_xmit()    <- NULL here

__netpoll_setup() only rejects IFF_DISABLE_NETPOLL devices. Can
configuring netconsole on this interface end in a NULL function pointer
call?

Later in the series, "net/xsc: report link state changes" adds
netif_carrier_on() while xsc_netdev_ops still has no ndo_start_xmit. At
that commit, a plain "ip link set up" with the link up seems to be enough
to hit this.

"net/xsc: add the transmit path" adds .ndo_start_xmit = xsc_eth_xmit, so
the end of the series is fine. The intermediate commits are still
bisectable, though.

Would a stub ndo_start_xmit that drops the skb work until the transmit
patch lands? Failing ndo_open with an error would be another option.

[ ... ]

> +static void xsc_eth_l2_addr_init(struct xsc_adapter *adapter)
> +{
> +	struct net_device *netdev = adapter->netdev;
> +	char mac[6] = {0};
> +	int ret = 0;
> +
> +	ret = xsc_eth_get_mac(adapter->xdev, mac);

[Severity: Low]

Is mac[] guaranteed to be u16 aligned here?

xsc_eth_get_mac() fills it with ether_addr_copy(mac, out->mac). It is then
passed to is_valid_ether_addr(), which calls is_zero_ether_addr().
include/linux/etherdevice.h documents that both need u16 alignment:

 * Please note: dst & src must both be aligned to u16.

A char[6] on the stack is only 1-byte aligned. Without
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS, could these become unaligned u16
accesses?

Would u8 mac[ETH_ALEN] __aligned(2), with xsc_eth_get_mac() taking a u8 *,
avoid this? The code is unchanged at the end of the series.

[ ... ]

> diff --git a/drivers/net/ethernet/yunsilicon/xsc/net/xsc_eth_wq.h b/drivers/net/ethernet/yunsilicon/xsc/net/xsc_eth_wq.h
> new file mode 100644
> index 0000000000000..35206ddf42f46
> --- /dev/null
> +++ b/drivers/net/ethernet/yunsilicon/xsc/net/xsc_eth_wq.h
> @@ -0,0 +1,150 @@

[ ... ]

> +u32 xsc_wq_cyc_get_size(struct xsc_wq_cyc *wq);
> +
> +int xsc_eth_cqwq_create(struct xsc_core_device *xdev,
> +			struct xsc_wq_param *param,
> +			u8 q_log_size,
> +			u8 ele_log_size,
> +			struct xsc_cqwq *wq,
> +			struct xsc_wq_ctrl *wq_ctrl);
> +
> +int xsc_eth_wq_cyc_create(struct xsc_core_device *xdev,
> +			  struct xsc_wq_param *param,
> +			  u8 q_log_size,
> +			  u8 ele_log_size,
> +			  struct xsc_wq_cyc *wq,
> +			  struct xsc_wq_ctrl *wq_ctrl);
> +void xsc_eth_wq_destroy(struct xsc_wq_ctrl *wq_ctrl);

[Severity: Low]

This isn't a bug, but these prototypes have no definitions at this commit.
The net Makefile only builds main.o:

xsc_eth-y := main.o

Several other items are also unused here:

  xsc_queue.h
  the queue parameter structs
  the CQE/WQE layouts
  XSC_INVALID_LKEY and XSC_QUEUE_TYPE_RAW*
  adapter->channel
  select PAGE_POOL

Nothing calls these functions, so this commit builds and links. Later in
the series, "net/xsc: add the single TX/RX channel" adds xsc_eth_wq.c, and
the transmit and receive patches use the rest.

Could these definitions move into the patches that first use them?

[ ... ]

> diff --git a/drivers/net/ethernet/yunsilicon/xsc/pci/adev.c b/drivers/net/ethernet/yunsilicon/xsc/pci/adev.c
> new file mode 100644
> index 0000000000000..3376ed10ba6ca
> --- /dev/null
> +++ b/drivers/net/ethernet/yunsilicon/xsc/pci/adev.c
> @@ -0,0 +1,133 @@

[ ... ]

> +static void xsc_adev_del(struct xsc_core_device *xdev, int idx)
> +{

[ ... ]

> +	/* Clear the slot before teardown: the driver's remove callback runs
> +	 * synchronously inside auxiliary_device_delete() and may re-enter
> +	 * xsc_adev_add() for this index.
> +	 */
> +	xdev->xsc_adev_list[idx] = NULL;

[Severity: Low]

Is this comment accurate? xsc_adev_add() is static, and its only caller is
xsc_adev_init(). xsc_adev_init() is only called from xsc_pci_init().

xsc_eth_remove() never calls back into the PCI layer. It doesn't look like
the remove callback can re-enter xsc_adev_add(). The comment is unchanged
at the end of the series.

A couple of other descriptions don't seem to match the code at this commit
either. xsc_eth_remove() has:

	/* Runs ndo_stop(), so the queues and the HCA are shut down first. */

xsc_eth_close() only clears adapter->opened, turns the carrier off and
sends XSC_PORT_DOWN. Queue and HCA teardown only arrive in later patches.

The commit message says:

  create the device, program the MAC address and MTU

xsc_eth_l2_addr_init() only queries the MAC with XSC_CMD_OP_QUERY_ETH_MAC
and calls eth_hw_addr_set(). Nothing is written to the device.

The commit message also doesn't mention that ndo_open sets the port admin
status to up.

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261126145711.70868-1-tianx%40yunsilicon.com
