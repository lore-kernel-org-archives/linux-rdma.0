Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795615725;
	b=M6u1FJBG/QgPqwPDWygTXmSrU0TObSZkOC72jnz0H5Olx3AWTQN6hXncFnY1/LDO03Lx
	 BtmLLG9XWtDkEkkub7ZmJQC6bkj5nQ6knSFetyMZH/aufhbTQV8b/a/hCJU3qNv2dVcbQ
	 gtp9kd0iVu97k9FWLHAi7aXL187Y9FXLhMqv+7BYOnrmeHJ9KPq/iEmA2LFlXxW4t8PCi
	 tW3GsNZQ448dPEHzPV6wqSRdGDh4aKjqHHVnvmhaa9p2TJi8swhV20p4SwUH9o139RSX2
	 RXrzVX6dWEKuNMaBfeaVCw2WEmJEQevzB/AwAmCZmSOeox5NAiA4+C0sD7aaxRgdgpQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795615725;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=RRVqQ/YvNotErRi8roZJpO/1ObkrgRZEkTveKrsY9Mg=;
	b=48ul6Blh54268RF2QC2Ud0ABtM8+tgKrF1kPHWfbZXVLVOYCXDSpZ8NywD3okeWdLGrH
	 Uq4JAjXDOp2DrBLlHfz4a0C3fwp+P/1gLIIq3YVUJVRvKvb51DTYwXrl0ywhhPfWARCQt
	 j8CB/eOPDGkXOw8+8VhtEM5pSzwg+VlplXkrOW1F9d44vpcdS1s+cnWL+a07HLnpa173R
	 kWCUiRI6vU5ESwcNgkR5H01o3rVcafvZUQYvrJ680V89n9BlhLVjIsCuillCYucsU1cfu
	 2VWLjEfHzCZlkb3M05xz/DaT1fKFMHPS+7yeBzSH8vkNjJG3CxQHuVpuC7PHpXWt3dw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ltNUlxj8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15755606A683;
	Wed, 25 Nov 2026 14:08:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ltNUlxj8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA0081F000D3;
	Wed, 25 Nov 2026 14:08:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795615724;
	bh=RRVqQ/YvNotErRi8roZJpO/1ObkrgRZEkTveKrsY9Mg=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=ltNUlxj8cuqirxZXR/VV04SXF7HuEkG/cM6LUXeVgBjF8zYghBJzC8CgD8amIzeed
	 Lol2diHQG6NTk1NCNoBoeZNSM4i8DLZ68CBkU3AtQJAV48kREjGQPpeQsqCv6Hf8t5
	 SWie7w91GWyyz8AKsj1ZaNDfYXMwXTl3AQ6H1cE/F6rcn2+f7f6H/3ZY+/o5BW0mRC
	 vqiVzuD7CmgWyrSr+DPlhf7gNJRCZOkAJVzMLuFgQ2p2kSS0BUkq0vsi9/9x2F1Iow
	 CIONLtIVXjAEzANB4Bh/GZ0K7oHnzZUDtAI3Kl7rMl3OsdLoD4NdCuIBwdWS//e/jU
	 QtC175pF+DEWA==
Subject: Re: [PATCH net-next 15/15] Documentation: networking: Describe AF_XDP
 RX in the device's layout
From: netdev-bot+sashiko@kernel.org
To: bjorn@kernel.org
Cc: magnus.karlsson@intel.com, maciej.fijalkowski@intel.com,
 davem@davemloft.net, edumazet@kernel.org, kuba@kernel.org, pabeni@redhat.com,
 andrew+netdev@lunn.ch, ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
 john.fastabend@gmail.com, andrii@kernel.org, eddyz87@gmail.com,
 memxor@gmail.com, ilias.apalodimas@linaro.org, alexanderduyck@fb.com,
 saeedm@nvidia.com, tariqt@nvidia.com, mbloch@nvidia.com, leon@kernel.org,
 michael.chan@broadcom.com, pavan.chebbi@broadcom.com, corbet@lwn.net,
 shuah@kernel.org, bpf@vger.kernel.org, netdev@vger.kernel.org,
 stuclar@meta.com, sdf@fomichev.me, horms@kernel.org, martin.lau@linux.dev,
 almasrymina@google.com, song@kernel.org, yonghong.song@linux.dev,
 jolsa@kernel.org, emil@etsalapatis.com, ihor.solodrai@linux.dev,
 rdunlap@infradead.org, kernel-team@meta.com, dimitri.daskalakis1@gmail.com,
 bobbyeshleman@meta.com, mohsin.bashr@gmail.com, kees@kernel.org,
 leitao@debian.org, maxime.chevallier@bootlin.com, cuitao@kylinos.cn,
 vadim.fedorenko@linux.dev, mike.marciniszyn@gmail.com, kuniyu@google.com,
 jiayuan.chen@linux.dev, mkarsten@uwaterloo.ca, razor@blackwall.org,
 dw@davidwei.uk, asml.silence@gmail.com, linux-rdma@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org
Date: Wed, 25 Nov 2026 14:08:41 +0000
Message-ID: <179561572133.3135.8308590457336514597@kernel.org>
In-Reply-To: <20261124125654.183091-15-bjorn@kernel.org>
References: <20261124125654.183091-15-bjorn@kernel.org>
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

Critical: 0 · High: 0 · Medium: 2 · Low: 3

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] The new 'Receiving' text in
  Documentation/networking/af_xdp.rst (lines 860-862) says "The kernel…
- [Medium] Documentation/networking/af_xdp.rst says bpf_xdp_adjust_meta()
  and the RX metadata kfuncs "work as with pages" (lines 814-817).
- [Low] The 'Setting up' section of Documentation/networking/af_xdp.rst
  (lines 778-782 and 802-809) lists the bind requirements and errors but…
- [Low] The uAPI comment on XDP_PKT_CONTD in include/uapi/linux/if_xdp.h
  still says "For single buffer packets, every descriptor has 'options'…
- [Low] The 'Setting up' text (af_xdp.rst lines 802-804) says to bind
  "with XDP_USE_SG to receive packets that span chunks".

--

Documentation: networking: Describe AF_XDP RX in the device's layout

This adds a "Device Buffer Layout" section to
Documentation/networking/af_xdp.rst. The section covers AF_XDP RX with
the XDP_UMEM_DRV_LAYOUT UMEM flag: setup and its errors, what the XDP
program may do, and how chunks are lent and given back with
XDP_RX_CHUNK_FREE. It also covers need_wakeup, DMA syncs and TX in this
mode.

> diff --git a/Documentation/networking/af_xdp.rst b/Documentation/networking/af_xdp.rst
> index 538e71adb7593..4e37a6074a52d 100644
> --- a/Documentation/networking/af_xdp.rst
> +++ b/Documentation/networking/af_xdp.rst

[ ... ]

> @@ -761,6 +763,116 @@ processing. Note that the Tx batch API guarantees that it will provide
>  a batch of Tx descriptors that ends with full packet at the end. This
>  to facilitate extending a zero-copy driver with multi-buffer support.
>  
> +Device Buffer Layout
> +====================

[ ... ]

> +The UMEM backs the page pools of the bound queue through a memory
> +provider, so the driver needs no AF_XDP code. A driver supports the
> +mode if it runs native XDP with XDP_REDIRECT, takes its receive
> +buffers from a page pool of netmem that allows such providers, and
> +can restart a queue.

[ ... ]

> +* Bind with XDP_USE_NEED_WAKEUP, as only a wakeup restarts a queue
> +  that used up the FILL ring, and with XDP_USE_SG to receive packets
> +  that span chunks. A bind without XDP_USE_NEED_WAKEUP fails with

[Severity: Low]
Is "to receive packets that span chunks" the right condition for
XDP_USE_SG? In net/xdp/xsk_sink.c, xsk_sink_rcv() counts buffers, not
chunks:

    n = nr_frags + !!hlen;
    if (!n || (n > 1 && !xs->sg))
        goto drop;

This section also says that several buffers may share a chunk. So
without XDP_USE_SG, a multi-buffer packet is dropped even when all its
buffers sit in one chunk.

Could the text say that XDP_USE_SG is needed for any packet the device
splits into more than one buffer? The multi-buffer section already
says this.

> +  EINVAL. XDP_COPY fails with EOPNOTSUPP, as does a device
> +  without native XDP_REDIRECT or queue management. One socket per

[Severity: Low]
Is this list of bind errors complete? xsk_sink_bind() also returns
EOPNOTSUPP in cases this text doesn't mention:

    if (flags & XDP_USE_SG)
        needed |= NETDEV_XDP_ACT_RX_SG;
    if (flags & XDP_COPY || !dev->queue_mgmt_ops ||
        (dev->xdp_features & needed) != needed ||
        queue_id >= dev->real_num_rx_queues)
        return -EOPNOTSUPP;

So a bind with XDP_USE_SG, which the text recommends, also needs
NETDEV_XDP_ACT_RX_SG. The driver support paragraph above doesn't list
that.

A queue_id at or above real_num_rx_queues also fails with EOPNOTSUPP.
So do a leased queue (netif_rxq_is_leased()) and a queue without a DMA
device (netdev_queue_get_dma_dev() returning NULL).

What happens with XDP_ZEROCOPY? In xp_assign_dev(), the
XDP_UMEM_DRV_LAYOUT branch returns before force_zc is checked:

    if (pool->umem->flags & XDP_UMEM_DRV_LAYOUT) {
        err = xsk_sink_bind(pool, netdev, queue_id, flags);
        if (err)
            goto err_unbind;
        return 0;
    }

An XDP_ZEROCOPY bind therefore succeeds with umem->zc false. xsk_bind()
then sets xs->zc to false, and XDP_OPTIONS reports no
XDP_OPTIONS_ZEROCOPY.

The general text earlier in af_xdp.rst says the XDP_ZEROCOPY flag "will
force the socket into zero-copy mode or fail". Should this section
mention the exception?

[ ... ]

> +The program works on the packet in place, in the UMEM: direct packet
> +access, bpf_xdp_load_bytes(), bpf_xdp_store_bytes(), dynptrs,
> +bpf_xdp_adjust_head(), bpf_xdp_adjust_tail(), bpf_xdp_adjust_meta()
> +and the RX metadata kfuncs work as with pages, on every buffer of the
> +packet. What the program writes is in the UMEM for the application to

[ ... ]

> +A FILL entry lends a whole chunk to the kernel, by its address. Each
> +buffer of a packet becomes one RX descriptor that points at the data,
> +anywhere in a chunk, and XDP_PKT_CONTD chains the buffers of a packet
> +as described in the multi-buffer section. Metadata that the program
> +wrote is in front of the first buffer, where the program put it; a
> +packet whose metadata does not fit in front of its first buffer, in
> +the same chunk, is dropped.

[Severity: Medium]
Does this hold for buffers with an empty linear part? In
xsk_sink_rcv():

    if (!hlen) {
        /* An empty linear part, as mlx5 builds for nonlinear RQs */
        empty = niov;
        headroom = 0;
    }
    ...
    if (!xdp_data_meta_unsupported(xdp))
        metalen = xdp->data - xdp->data_meta;
    if (metalen > headroom)
        goto drop;

Because headroom is forced to 0, any non-zero metalen drops the packet.
This happens even when the metadata fit in front of the head. The room
in front of frags[0] is never considered.

This layout occurs on mlx5 nonlinear striding RQs, for example with a
jumbo MTU. When a program is attached,
mlx5e_skb_from_cqe_mpwrq_nonlinear() takes the linear part from the
page pool with:

    linear_hr = XDP_PACKET_HEADROOM;
    linear_data_len = 0;

On such queues, would every packet from a program that calls
bpf_xdp_adjust_meta() be silently dropped and counted in rx_dropped?

That contradicts both this paragraph and the earlier statement that
bpf_xdp_adjust_meta() works "as with pages". Should the documentation
describe this case, or should xsk_sink_rcv() take the room in front of
the first fragment into account?

> +
> +The kernel gives a chunk back with XDP_RX_CHUNK_FREE in the options of
> +an RX descriptor:

[Severity: Low]
The comment above XDP_PKT_CONTD in include/uapi/linux/if_xdp.h still
says:

    For single buffer packets, every descriptor has 'options' set
    to 0 and this maintains backward compatibility.

In this mode, xsk_sink_drop_buf() ORs XDP_RX_CHUNK_FREE into the
options of the only descriptor of a single-buffer packet:

    ring->desc[(xs->rx->cached_prod - 1) & xs->rx->ring_mask].options |=
        XDP_RX_CHUNK_FREE;

xsk_sink_give_back() also posts zero-length descriptors with
XDP_RX_CHUNK_FREE in options.

Should that uAPI comment be updated along with this documentation, so
the header doesn't contradict itself?

[ ... ]

> +The kernel asks for a wakeup on the FILL ring only while it has run
> +out of FILL entries; recvmsg() or poll() then restarts the queue. With
> +preferred busy polling, the application's poll runs the queue's NAPI.

[Severity: Medium]
Is "only" accurate here? xsk_sink_alloc_netmems() in
net/xdp/xsk_sink.c also sets need_wakeup while given-back chunks wait
on sink->handed:

    if (n && llist_empty(&sink->handed))
        xsk_clear_rx_need_wakeup(sink->pool);
    else
        xsk_set_rx_need_wakeup(sink->pool);

The code comment there says this is on purpose: "once a slow socket
has drained its ring, only a NAPI run posts the chunks that waited."

xsk_sink_bind() also calls xsk_set_rx_need_wakeup(pool) unconditionally
before the queue starts, whatever is on FILL.

An application that follows this text might only kick when its FILL
ring is empty. Suppose it drains a full RX ring while chunks sit on
sink->handed and FILL still has entries. Would the zero-length
XDP_RX_CHUNK_FREE descriptors for those chunks stay unposted until new
traffic makes the NAPI run?

The wording seems to come from the commit message of "xsk: Lend UMEM
chunks to the page pools of a queue" ("asking for a kick only while
FILL is empty"). The later commit "xsk: Deliver to the socket in the
device's buffer layout" changed that behaviour ("the refill asks the
socket for a kick while any chunk waits").

Could this paragraph say that the kernel also asks for a wakeup while
given-back chunks wait for room in the RX ring? It could also tell
applications to check the need_wakeup flag rather than the FILL ring.

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261124112707.118678-1-bjorn%40kernel.org
