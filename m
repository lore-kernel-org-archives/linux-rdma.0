Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795795077;
	b=UmkK/w0JRHWgssum+Buea+oB98hscKlsyva14xP4oFbEAx85s53MR9ybrmUkSKPqVx7P
	 7DXxPnJvYoXHjXnhxv9uApAJzq1NTIXK19SPWUfimVatzirltAwR1dOvIQDT/rgYeNdgY
	 h7eHV/oUiWvr0OjZ6Pnqrbwh92kBoiuydtvXh9Y7fBUER+Wc8FKn7ARDgBK3GI3N9NJ7g
	 pzz1Y31b8Xk3wHCVpnLaIyhHcpUFM42sl0/lS8eGZs6HCxdXhg6djayi0lm4KLB/cDfyY
	 opw0elwmmyMTmRiKN9jUDmNYDijfJFoxQCvecDA3wuUzwhn5T5LbOIF9AKFFSDA4NUA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795795077;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=cf7JuS+NnYETCz1KEqiSGwMRPJ8xUkXHOo7gTQoqojQ=;
	b=SCGPblUW2lJ15U4XNVn8/08VDZDf8XAN2pk5o08JVWrvrwFmIKo+24nEuMJsZf48cKQK
	 UsJr2FWH1ustRHR1EcEd39oqbbEit2MlWqlvJ+FKpsB/EihfRTKz6PG2fIVivT52gGDrI
	 wL1vrSguX/OThiWI4xV11Su8jJEWVWOs1/9dTkVy8NsPZLT/tApEdtBb0IvfAII8sAD4c
	 d35s4T0Jbx44vXj7O00VrJU30NBMA8lgB2ZuQCD3jW0CVi6arZc5T/LrGcS+hmXoTzVTc
	 Ug592dvtDXQ5sHaoj8LyXev8tELSASWpXFHwLiDJMbLKdXLbgJiRwGFvWGcTt4XnFHw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=V4McVQhf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E080E606A688;
	Fri, 27 Nov 2026 15:57:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=V4McVQhf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 907C21F00925;
	Fri, 27 Nov 2026 15:57:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795795076;
	bh=cf7JuS+NnYETCz1KEqiSGwMRPJ8xUkXHOo7gTQoqojQ=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=V4McVQhfgwt1jXjagDkL9X1Mn+1hwbvI28ENHwCEC5bOc8m3YiUOk//vRCSfEqRYM
	 cI4GIrENwEZZjNUdNAE8JY12JSwCCJCGYLSSSZRoCAw5u7FmbeQjhjdBrBu6YH16CZ
	 +oTBbXA7Pn4guVY9qVcv/shg+xlmr4i0LoTiRT6A971S3qIbaudXvZWvFgNZ1RJFMA
	 N3AOJs1uBW8m5rg73B4RQej0wsvokUArc4J420Fa7SjzkJxBthajLkG03h+4aeHzA7
	 KVGy31GgYk+x7qQHpgr22Z+5savaEdokclZWmem8GNgmLTJq8FelCcCudlHUHj+yjj
	 DT1CmnwAOlAFw==
Subject: Re: [PATCH v2 05/11] net/xsc: add event queues and MSI-X
From: netdev-bot+sashiko@kernel.org
To: tianx@yunsilicon.com
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, jgg@ziepe.ca, leon@kernel.org,
 huangjunxian6@hisilicon.com, weihg@yunsilicon.com,
 linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
 linux-rdma@vger.kernel.org, kerneljasonxing@gmail.com
Date: Fri, 27 Nov 2026 15:57:55 +0000
Message-ID: <179579507511.3135.1874125473034318876@kernel.org>
In-Reply-To: <20261126145724.70868-6-tianx@yunsilicon.com>
References: <20261126145724.70868-6-tianx@yunsilicon.com>
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

Thank you for your contribution! Sashiko AI review found 7 potential
issue(s) to consider.

Critical: 0 · High: 0 · Medium: 2 · Low: 5

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] xsc_buf_alloc()
  (drivers/net/ethernet/yunsilicon/xsc/pci/alloc.c) handles buffers…
- [Medium] xsc_create_map_eq()
  (drivers/net/ethernet/yunsilicon/xsc/pci/eq.c) frees the EQ ring for…
- [Low] In xsc_destroy_unmap_eq() (eq.c), the u32 eq->eqn is printed with
  "%d", a signed specifier.
- [Low] struct xsc_eq::index gets two different meanings.
- [Low] The exported link-event callback API publishes the handler with a
  plain WRITE_ONCE() in xsc_irq_event_register().
- [Low] The EQ consumer-index doorbell field is only 11 bits wide
  (XSC_EQ_DB_DATA0_NEXT_CID_MASK = GENMASK(10, 0), with eqn in…
- [Low] xsc_irq_eq_destroy() tears down the async EQ (xsc_stop_eqs)
  before the completion EQs (free_comp_eqs).

--

net/xsc: add event queues and MSI-X

This commit creates the asynchronous and completion event queues,
allocates MSI-X vectors, and dispatches link events from a dedicated
workqueue. The command queue remains polling-only.

> diff --git a/drivers/net/ethernet/yunsilicon/xsc/pci/alloc.c b/drivers/net/ethernet/yunsilicon/xsc/pci/alloc.c
> new file mode 100644
> index 0000000000000..46eb0b031511d
> --- /dev/null
> +++ b/drivers/net/ethernet/yunsilicon/xsc/pci/alloc.c
> @@ -0,0 +1,123 @@

[ ... ]

> +		for (i = 0; i < buf->nbufs; i++) {
> +			buf->page_list[i].buf =
> +				dma_alloc_coherent(&xdev->pdev->dev, PAGE_SIZE,
> +						   &t, GFP_KERNEL);

[ ... ]

> +		for (i = 0; i < buf->nbufs; i++) {
> +			void *addr = buf->page_list[i].buf;
> +
> +			if (is_vmalloc_addr(addr))
> +				pages[i] = vmalloc_to_page(addr);
> +			else
> +				pages[i] = virt_to_page(addr);
> +		}
> +		buf->direct.buf = vmap(pages, buf->nbufs, VM_MAP, PAGE_KERNEL);

[Severity: Medium]
Is it valid to call virt_to_page()/vmalloc_to_page() on memory returned by
dma_alloc_coherent() and then vmap() it with PAGE_KERNEL?

The DMA API doesn't guarantee that a coherent allocation sits behind a
linear-map address with a valid struct page. It can be an uncached remap,
memory from a memremap'd per-device or restricted pool, or a decrypted page
on SEV/TDX guests. In those cases the derived struct page is wrong, or the
new cacheable alias has attributes that don't match. vmap() can also fail,
and then EQ creation fails.

On 4K-page systems this path runs on every probe. Each completion EQ has
nent = roundup_pow_of_two(1024 + 0x80) = 2048 entries of 8 bytes. That is
16 KiB, which is more than the max_direct = PAGE_SIZE passed by
xsc_create_map_eq().

The vmap'd buffer also seems to be unused. xsc_buf_offset() in xsc_core.h
never reads direct.buf when nbufs != 1:

    if (likely(buf->nbufs == 1))
        return buf->direct.buf + offset;
    else
        return buf->page_list[offset >> PAGE_SHIFT].buf +
            (offset & (PAGE_SIZE - 1));

So direct.buf is only ever passed to vunmap().

Upstream removed the same pattern from mlx4_buf_alloc(). The current mlx4
alloc.c uses per-page dma_alloc_coherent() fragments and no vmap.

Could the vmap() step be dropped here too?

[ ... ]

> diff --git a/drivers/net/ethernet/yunsilicon/xsc/pci/eq.c b/drivers/net/ethernet/yunsilicon/xsc/pci/eq.c
> new file mode 100644
> index 0000000000000..875a277a83cb8
> --- /dev/null
> +++ b/drivers/net/ethernet/yunsilicon/xsc/pci/eq.c
> @@ -0,0 +1,217 @@

[ ... ]

> +int xsc_create_map_eq(struct xsc_core_device *xdev,
> +		      struct xsc_eq *eq, u16 vecidx,
> +		      u32 nent, const char *name)
> +{

[ ... ]

> +	eq->nent = roundup_pow_of_two(nent + XSC_NUM_SPARE_EQE);
> +	err = xsc_buf_alloc(xdev, eq->nent * XSC_EQE_SIZE, PAGE_SIZE, &eq->buf);

[ ... ]

> +	in->hdr.opcode = cpu_to_be16(XSC_CMD_OP_CREATE_EQ);
> +	in->ctx.log_eq_sz = ilog2(eq->nent);

[Severity: Low]
Can the consumer index doorbell describe a 2048-entry EQ? The CID field in
doorbell.c is only 11 bits wide:

    #define XSC_EQ_DB_DATA0_NEXT_CID_MASK	GENMASK(10, 0)
    #define XSC_EQ_DB_DATA0_EQ_ID_MASK	GENMASK(21, 11)

xsc_update_eq_ci() fills that field from the free-running eq->cons_index
using FIELD_PREP(), which silently masks non-constant values.

The comp EQs have nent = 2048 (log_eq_sz = 11), so their doorbell carries
only the slot index. Bit 11, the wrap/phase bit that next_eqe_sw() uses
for ownership, is lost. The 512-entry async EQ keeps its index bits plus
two wrap bits.

Whether this matters depends on how the hardware reads CID, which the
source doesn't show, and EQ occupancy is small today.

Should the driver check the firmware-reported log_max_eq_sz before asking
for a 2^11 EQ? The field is in the hca_cap layout in xsc_cmd.h, but it is
not stored in xsc_caps.

> +	in->ctx.vecidx = cpu_to_be16(msix_vec_offset);
> +	in->ctx.pa_num = cpu_to_be16(hw_npages);
> +	in->ctx.glb_func_id = cpu_to_be16(xdev->glb_func_id);
> +	in->ctx.is_async_eq = (vecidx == XSC_EQ_VEC_ASYNC ? 1 : 0);
> +
> +	err = xsc_cmd_exec(xdev, in, inlen, &out, sizeof(out));
> +	if (err)
> +		goto err_free_in;

[Severity: Medium]
What happens to the EQ ring when xsc_cmd_exec() returns -ETIMEDOUT here?

The command layer treats a timeout as a command that is still in flight.
In xsc_cmd_invoke():

    if (!wait_for_completion_timeout(&ent->done, timeout)) {
        cmd->cmd_status = XSC_CMD_STATUS_TIMEDOUT;
        ...
        /* the entry stays registered for the completion handler */
        return -ETIMEDOUT;
    }

and _xsc_cmd_exec() keeps the mailboxes alive on a timeout:

    if (err == -ETIMEDOUT)
        /* the command owns both mailboxes now */
        return err;

Here the error path goes to err_free_in and then err_free_eq_buf, so
xsc_buf_free() returns the ring pages with dma_free_coherent(). Their bus
addresses were already passed to firmware in in->pas[].

If the firmware completes the late CREATE_EQ, can it end up with an armed
EQ that DMAs into freed pages? Once cmd_status is TIMEDOUT, every later
xsc_cmd_exec() returns -ETIMEDOUT at once, so a DESTROY_EQ can never be
sent to recover.

The err_destroy_eq path and xsc_destroy_unmap_eq() already leak the buffer
for this reason when DESTROY_EQ fails. Should a CREATE_EQ timeout leak
eq->buf as well, instead of freeing it?

[ ... ]

> +	eq->index = vecidx;

[ ... ]

> +int xsc_destroy_unmap_eq(struct xsc_core_device *xdev, struct xsc_eq *eq)
> +{
> +	int err;
> +
> +	free_irq(eq->irqn, eq);
> +	err = xsc_cmd_destroy_eq(xdev, eq->eqn);
> +	if (err) {
> +		pci_err(xdev->pdev, "failed to destroy a previously created eq: eqn %d\n",
> +			eq->eqn);

[Severity: Low]
This isn't a bug, but eq->eqn is a u32 and is printed with %d. The caller
free_comp_eqs() logs the same failure again as "failed to destroy EQ
0x%x". A single DESTROY_EQ failure therefore produces two error lines,
with the same EQ number shown once in decimal and once in hex.

Could one of the messages be dropped, or both use the same format?

[ ... ]

> diff --git a/drivers/net/ethernet/yunsilicon/xsc/pci/pci_irq.c b/drivers/net/ethernet/yunsilicon/xsc/pci/pci_irq.c
> new file mode 100644
> index 0000000000000..accc3e56ba46c
> --- /dev/null
> +++ b/drivers/net/ethernet/yunsilicon/xsc/pci/pci_irq.c
> @@ -0,0 +1,345 @@

[ ... ]

> +int xsc_core_vector2eqn(struct xsc_core_device *xdev, int vector, u32 *eqn,
> +			unsigned int *irqn)
> +{

[ ... ]

> +	list_for_each_entry_safe(eq, n, &table->comp_eqs_list, list) {
> +		if (eq->index == vector) {

[ ... ]

> +		snprintf(name, XSC_MAX_IRQ_NAME, "xsc_comp%d", i);
> +		err = xsc_create_map_eq(xdev, eq,
> +					i + table->eq_vec_comp_base,
> +					nent, name);
> +		if (err) {
> +			kfree(eq);
> +			goto err_free;
> +		}
> +
> +		eq->index = i;

[Severity: Low]
This isn't a bug, but struct xsc_eq::index ends up with two meanings.
xsc_create_map_eq() sets eq->index = vecidx, which is the absolute MSI-X
table entry: 0 for async, and comp EQs starting at
XSC_EQ_VEC_COMP_BASE = 4. This line then immediately overwrites it with
the comp-relative i.

The exported xsc_core_vector2eqn() compares vector against this field.
That makes the store in xsc_create_map_eq() dead for comp EQs, and the API
does not say that vector is comp-relative.

The in-tree callers added later in the series, xsc_eth_open_channel() and
xsc_eth_set_cq(), pass comp-relative indices and work today.

Could the field or the vector argument of xsc_core_vector2eqn() be
documented, or split into two fields, so that a caller expecting MSI-X
numbering is not misled?

[ ... ]

> +static void xsc_event_work(struct work_struct *work)
> +{

[ ... ]

> +			handler = READ_ONCE(xdev->link_event_handler);
> +			if (handler)
> +				handler(xdev);

[ ... ]

> +void xsc_irq_event_register(struct xsc_core_device *xdev,
> +			    void (*handler)(void *xdev))
> +{
> +	WRITE_ONCE(xdev->link_event_handler, handler);
> +}

[Severity: Low]
Is there enough ordering between xsc_irq_event_register() and
xsc_event_work()?

The handler is published with a plain WRITE_ONCE(), read with a plain
READ_ONCE(), and called right away. It reaches the registrant's state
through xdev (for example xdev->eth_priv), and that access has no address
dependency on the function pointer.

There is no smp_store_release()/smp_load_acquire() pair, lock, or RCU
here. A worker on another CPU could therefore see the new handler together
with state written before the register call that is still stale.

The in-tree user in xsc_eth_probe() happens to get a wmb() on the writer
side from the xsc_cmd_exec() calls in between. Also,
xsc_eth_link_event_handler() returns early when !adapter ||
!adapter->opened, so at worst a link event is ignored today.

The header comment describes a register/unregister contract, but nothing
in the code orders it. Would release/acquire semantics be worth using
here?

[ ... ]

> +void xsc_irq_eq_destroy(struct xsc_core_device *xdev)
> +{
> +	xsc_stop_eqs(xdev);
> +	free_comp_eqs(xdev);

[Severity: Low]
Should this teardown run in reverse creation order?
xsc_irq_eq_create() creates the async EQ first and the comp EQs after it.
Its own error unwind gets the order right:

    err_free_comp_eqs:
        free_comp_eqs(xdev);
    err_stop_eqs:
        xsc_stop_eqs(xdev);

Here, the async EQ (is_async_eq = 1, where firmware reports CQ/QP error
events) is destroyed while the comp EQs are still live in firmware.

Later in the series xsc_pci_fini() calls xsc_adev_uninit() before this, so
no concrete failure is known. The normal teardown and the error unwind
still disagree.

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261126145711.70868-1-tianx%40yunsilicon.com
