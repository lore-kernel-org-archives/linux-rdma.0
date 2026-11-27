Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795795084;
	b=escVnzD90qwBiAWyGigVv92s/paZEHbijw9oRe29398gZcmCmhrWeFEaq55ogeutbQx7
	 L2tkVl/phq/FTgh5GaoiE88Iprb7WwBkZ5AlJGamaCKQ5a3ZpaR24RIA2viZ7mKaqO63U
	 M9q+mHkBBBa7K5LAEguYrrpIfBRhSCHupar2U7oo8IAgHQTysPUzdbfjEnGR12xJstZKw
	 t3sMu0wlDbnFgbTDluTL5zHq2tm/DReQXUZAQ0QMEHriLRGE7x/mFc79gw0FYN2sOathe
	 jsme1ekp4xP4WflpYCHpZyLxn6RXrB/bZ+m8WxWH6zKAVCA8Ikj8dxQ/SeHDNeXCmrQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795795084;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=CeZRPXeRorY9T3lOBlDRy3V+DbTeNZvNb7pbJXo/C8c=;
	b=H6rMiNKMDKJMllqW+Uj/ROe80DvNy6YD6bd5h70kI3bXEFJddyX5VFCTv+K5ZvFZxxYq
	 04AvTkgLQTVdc+lNeTzmO668QZNkNSK+OmusY8uErGYP3RzZg3Y7GuU1+linP1aDab6V8
	 5RDEe6Lg11G3GNpGfGVLVaLqUAxVc2tp2EHlquc+kE8fK3naBolrfxILEYGhZRlDsKIYB
	 eJ4aPH35UlO0AAnBD4OIdcXgyFc9o/3drV8/1AZ1kbmW0gb+n2M1AVQUWXgHhkdd/Q2+p
	 CUO6ePA3VOYjCkWbWhsY98YP2xsESUajylRaXWZg/E5p8xUAM9elDeZ+WeBjK5dDe2A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=McG2s3X1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34D1C606A695;
	Fri, 27 Nov 2026 15:58:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=McG2s3X1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F21B11F00923;
	Fri, 27 Nov 2026 15:58:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795795083;
	bh=CeZRPXeRorY9T3lOBlDRy3V+DbTeNZvNb7pbJXo/C8c=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=McG2s3X1bwhR7VwyKzxxFj8/Fd2sQdClyCHEDCbRhiO8bJxebnqsTcVeF1gvttj5o
	 +JwtD73mnvcdkz0mbTHBE4imi88P9LEjd7rlUZW3z1S/jXx2hBlhnDjZ0vXdczWG25
	 au7lVMv/+jZI/N+/tWiV5xdQseUEzZkzyTqM++n16zY56SJUrwXXgwllV2az+k7khM
	 /QiDipDrYv7XlqOzTkzQ++YX5zSCE6nw8mt7yTBXptu+h+XGq9HQ+Gw65EJWnaMJAf
	 pIqQ9/ueYeZArOaN6uSxK9F22nV45XXxmJlkI/qXg2uT7eS8rMg4qvu5aMG3eTGtUI
	 p/JzqimxL1vsg==
Subject: Re: [PATCH v2 09/11] net/xsc: report link state changes
From: netdev-bot+sashiko@kernel.org
To: tianx@yunsilicon.com
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, jgg@ziepe.ca, leon@kernel.org,
 huangjunxian6@hisilicon.com, weihg@yunsilicon.com,
 linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
 linux-rdma@vger.kernel.org, kerneljasonxing@gmail.com
Date: Fri, 27 Nov 2026 15:58:02 +0000
Message-ID: <179579508256.3135.6252294453824096365@kernel.org>
In-Reply-To: <20261126145736.70868-10-tianx@yunsilicon.com>
References: <20261126145736.70868-10-tianx@yunsilicon.com>
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

Thank you for your contribution! Sashiko AI review found 4 potential
issue(s) to consider.

Critical: 0 · High: 0 · Medium: 3 · Low: 1

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] In xsc_eth_open()
  (drivers/net/ethernet/yunsilicon/xsc/net/main.c), the initial carrier…
- [Medium] xsc_eth_link_event_handler() (main.c:765-778) runs from
  xsc_event_work() on xdev->event_wq with no lock held.
- [Medium] xsc_eth_open() (main.c:883-893) samples the link state with
  xsc_eth_get_link_status() and sets the carrier before it sets…
- [Low] The comment above xsc_event_work() in
  drivers/net/ethernet/yunsilicon/xsc/pci/pci_irq.c (lines 164-169) says…

--

net/xsc: report link state changes

This commit adds xsc_core_query_vport_state() and uses it to set the
netdev carrier in xsc_eth_open(). It also registers a link event callback
with the PCI layer, so the port is re-queried and the carrier updated on
every XSC_CMD_EVENT_RESP_CHANGE_LINK event.

> diff --git a/drivers/net/ethernet/yunsilicon/xsc/net/main.c b/drivers/net/ethernet/yunsilicon/xsc/net/main.c
> index 1c7bbc27d8c4f..75a6abd6ed136 100644
> --- a/drivers/net/ethernet/yunsilicon/xsc/net/main.c
> +++ b/drivers/net/ethernet/yunsilicon/xsc/net/main.c
> @@ -721,6 +721,62 @@ static void xsc_eth_sw_deinit(struct xsc_adapter *adapter)

[ ... ]

> +static int xsc_eth_change_link_status(struct xsc_adapter *adapter)
> +{
> +	bool link_up;
> +	int err;
> +
> +	err = xsc_eth_get_link_status(adapter, &link_up);
> +	if (err) {
> +		netdev_err(adapter->netdev, "failed to query link status, err=%d\n",
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
> +	struct xsc_core_device *xdev = arg;
> +	struct xsc_adapter *adapter = xdev->eth_priv;
> +	int err;
> +
> +	if (!adapter || !adapter->opened)
> +		return;
> +
> +	err = xsc_eth_change_link_status(adapter);

[Severity: Medium]
Can this race with xsc_eth_close() and leave the carrier on for a closed
device?

The handler runs from xsc_event_work() on xdev->event_wq with no lock
held. Its only guard is a plain read of adapter->opened. After that it
sends a sleeping firmware command and then checks and sets the carrier
in two separate steps.

xsc_eth_close() writes opened and the carrier under RTNL. It does not
exclude or wait for a handler that has already passed the check:

event_wq                              ip link set down (RTNL)
xsc_eth_link_event_handler()
  adapter->opened == true
  xsc_eth_change_link_status()
    xsc_core_query_vport_state()
                                      xsc_eth_close()
                                        adapter->opened = false;
                                        netif_carrier_off()
                                        xsc_eth_sw_deinit()
                                        ...
    link_up && !netif_carrier_ok()
    netif_carrier_on()

On the next xsc_eth_open(), the "Link down" branch never calls
netif_carrier_off(). If the link is down at reopen, the interface comes
up with carrier and operstate up and stays that way until the next link
transition.

The opened bool acts as a gate guard rather than a real lock. It is also
read and written without READ_ONCE()/WRITE_ONCE().

Would it work to take rtnl_lock() in the handler, or a driver state mutex
that open and close also hold (like state_lock in
mlx5e_update_carrier_work()), and re-check opened under it? Remove and
the probe error path call xsc_irq_event_unregister() without RTNL, so
its flush_workqueue() should not deadlock against that.

> +	if (err)
> +		netdev_err(adapter->netdev, "failed to change linkstatus, err=%d\n",
> +			   err);
> +}

[Severity: Low]
This isn't a bug, but once this handler is registered, the comment above
xsc_event_work() in drivers/net/ethernet/yunsilicon/xsc/pci/pci_irq.c no
longer matches what the work does:

/*
 * Handle an asynchronous event. This runs on the PCI layer's own workqueue,
 * so it outlives any auxiliary driver: the driver only ever registers a
 * callback here, and the memory this touches belongs to xsc_core_device
 * rather than to the eth private area.
 */

xsc_event_work() calls the callback inline:

	handler = READ_ONCE(xdev->link_event_handler);
	if (handler)
		handler(xdev);

xsc_eth_link_event_handler() dereferences xdev->eth_priv,
adapter->opened and adapter->netdev. All of these live in the
alloc_etherdev() private area that free_netdev() frees.

What actually keeps this safe is that xsc_eth_remove() and the probe
error path call xsc_irq_event_unregister() before free_netdev().

Could the comment say that callbacks may touch client-owned memory, and
that clients must unregister before freeing it?

[ ... ]

> @@ -823,6 +880,16 @@ static int xsc_eth_open(struct net_device *netdev)
>  	if (ret)
>  		goto err_sw_deinit;
>  
> +	ret = xsc_eth_get_link_status(adapter, &link_up);
> +	if (ret) {
> +		netdev_warn(netdev, "failed to query link status, err=%d\n", ret);
> +	} else if (link_up) {
> +		netdev_info(netdev, "Link up\n");
> +		netif_carrier_on(adapter->netdev);
> +	} else {
> +		netdev_info(netdev, "Link down\n");
> +	}
> +
>  	adapter->opened = true;

[Severity: Medium]
Can a link change event get lost between the query and this assignment?

The link state is sampled before adapter->opened is set. While opened is
false, xsc_eth_link_event_handler() returns early and records nothing:

	if (!adapter || !adapter->opened)
		return;

Suppose the link changes after the firmware answers QUERY_VPORT_STATE,
and the CHANGE_LINK work reaches that check before adapter->opened is
set to true. The event is dropped. Nothing re-queries afterwards, so the
carrier stays wrong until the next link transition, which may never come
on a stable link. This looks reachable at least on the first open after
probe.

Also, if xsc_eth_get_link_status() fails here, for example because
xsc_cmd_exec() times out, open only warns and returns 0. The carrier
stays off and the query is never retried. A link that is up and stays
up would then be reported down indefinitely.

Would either of these close the window and let a later event correct a
failed query?

  - set opened before the query, as mlx5e_open_locked() does with
    MLX5E_STATE_OPENED before updating the carrier
  - re-query once opened and admin-up are both set

>  
>  	xsc_set_port_admin_status(adapter, XSC_PORT_UP);

[Severity: Medium]
Does the oper state read above mean anything while the port is still
admin-down?

xsc_eth_close() always ends with:

	xsc_set_port_admin_status(adapter, XSC_PORT_DOWN);

So on every re-open, xsc_eth_get_link_status() queries a port the driver
has just set admin-down. XSC_PORT_UP is only sent after the carrier has
been decided.

The reply carries separate admin and oper nibbles:

#define XSC_QUERY_VPORT_ADMIN_STATE_MASK	GENMASK(3, 0)
#define XSC_QUERY_VPORT_STATE_MASK		GENMASK(7, 4)

xsc_core_query_vport_state() returns the oper nibble.

If the firmware reports oper-down while the port is admin-down, open
takes the "Link down" branch. After that, only a later
XSC_CMD_EVENT_RESP_CHANGE_LINK event can turn the carrier on.

Does the firmware raise that event when admin-up changes the oper state?
If it does not, the netdev stays carrier-off after ip link set down
followed by ip link set up, even though the physical link is up. It
would stay that way until the link next flaps.

mlx5e queries the state before admin-up in the same way and relies on
firmware port change events. So this may be fine if the xsc firmware
behaves the same way.

Would setting opened, then sending XSC_PORT_UP, and only then sampling
the link state make the initial sample match the real link?

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261126145711.70868-1-tianx%40yunsilicon.com
