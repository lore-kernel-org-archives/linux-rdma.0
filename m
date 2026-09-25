Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 754544BD7A8;
	Fri, 25 Sep 2026 17:33:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790357622; cv=none; b=brZ6PZ8rpZlzw4ViyvrfAU/TSQkD4Qp/P3UlOrd3U/vi8aA7a8VHrs4B1by6NRi/3TUl4QlwUA1KVjA46yWcb5NjRDx3ty1XYHst62bowLVlZoG48a6+68dEl5B83kjZmo/7vmROzLr5AH26Efev9h8L4OM+IQ0onwOi4rla0xI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790357622; c=relaxed/simple;
	bh=Gncmm5287QhDxao4XYCbGT8hjxtjljnwgOoK5SWxcVw=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=KoHQEcBGvR01IgZgYeTJzfxy+DrcNEWHIUf+YaUipRxN2MgQE9o4P0ydDEd7gHf3OukrX8FjOAyn8b1dtbOk+aIM2u0O8KUMmegEjz9HPvw3GhipQlh+kktDS1pJSb8mvlqu7B5rDhKbVuD9rlCHNCnR4nAkrf0Z2+nDJHUvOe8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PF8aE1Jv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PF8aE1Jv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFD421F000FF;
	Fri, 25 Sep 2026 17:33:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790357621;
	bh=ATlqTceFZq8MVlK1+CrP+fdKvFkP2XkMP/lX1zFmoo0=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=PF8aE1JvAXM1HmZJ4DqiplCDlT3SOqY2D4doJ+PdmkdtezB26+8H2toF/e42mobkW
	 AaIw2QlpmGAwZfTHBVEVjYVaDim3aTAmNwcTB/eUSTJ13rWuPnfWRNJG60fI6Vza6v
	 XiEXoJiQ/uMG5qZ83eTeC1foVsX6HJH63IN25LMez/XNUGSD9nm4cLQLqGbIC2ecu1
	 wF8T4dwx0E0ODnkYNhAzZ12fUlOYkx7R8vjaa81gHnulsMBsm9txA5lmWzpbsaYnG/
	 3Rk3bHgYggCwcAG3PcWIyUdczEsA04S/zNF2y2arLVcmwaKJSxBRJyVENioClDveaW
	 F17Ix8BUJE20w==
Subject:
 Re: [PATCH net-next 4/4] net: mana: Add support for CDX device ID 0x00C2
From: netdev-bot+sashiko@kernel.org
To: mawasthi@linux.microsoft.com
Cc: kys@microsoft.com, haiyangz@microsoft.com, wei.liu@kernel.org,
 decui@microsoft.com, longli@microsoft.com, andrew+netdev@lunn.ch,
 davem@davemloft.net, edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
 kotaranov@microsoft.com, horms@kernel.org, linux-hyperv@vger.kernel.org,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-rdma@vger.kernel.org, bpf@vger.kernel.org, nipun.gupta@amd.com,
 nikhil.agarwal@amd.com, gargaditya@linux.microsoft.com,
 ernis@linux.microsoft.com, kees@kernel.org, paulros@microsoft.com,
 mawasthi@microsoft.com
Date: Fri, 25 Sep 2026 17:33:39 +0000
Message-ID: <179035761944.2160803.12943182451050438147@kernel.org>
In-Reply-To: <20260924173054.589291-5-mawasthi@linux.microsoft.com>
References: <20260924173054.589291-5-mawasthi@linux.microsoft.com>
X-sashiko-severity: Medium
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 3 potential
issue(s) to consider.

Critical: 0 · High: 0 (1) · Medium: 1 · Low: 2

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] The CDX transport installs `.dev_reset = mana_cdx_dev_reset`
  (-> `cdx_dev_reset()`) but has no way to recover afterwards.
- [Low] `mana_cdx_setup_hwc_irqs()` skips IRQ affinity hints.
- [Low] The comment in `mana_gd_query_max_resources()` (gdma_main.c)
  says: "Only reset on platforms that support dynamic MSI-X allocation;…

Pre-existing issues:
- [High] This problem wasn't introduced by this patch, but the shared HWC
  bootstrap path that the new CDX transport now reaches trusts a device-…

--

net: mana: Add support for CDX device ID 0x00C2

This adds a CDX bus transport for MANA, built as mana_cdx.ko on top of
the shared gdma_core.ko, for device ID 0x00C2. It allocates the whole MSI
pool at probe time, limits the queue count to the available vectors,
restricts DMA to 32 bits, and adds a per-bus auxiliary device name prefix
so the CDX auxiliary devices stay separate from the PCI ones.

> diff --git a/drivers/net/ethernet/microsoft/mana/gdma_cdx.c b/drivers/net/ethernet/microsoft/mana/gdma_cdx.c
> new file mode 100644
> index 0000000000000..0d01e3d2f0d96
> --- /dev/null
> +++ b/drivers/net/ethernet/microsoft/mana/gdma_cdx.c
> @@ -0,0 +1,340 @@

[ ... ]

> +static int mana_cdx_dev_reset(struct gdma_context *gc)
> +{
> +	return cdx_dev_reset(gc->dev);
> +}

[Severity: Medium]
Can this reset leave the whole function unusable, with no recovery short
of a manual rebind?

mana_dealloc_queues() calls it when a TX queue still has pending_sends
after the drain timeout:

mana_tx_timeout()
  -> queue_reset_work
    -> mana_per_port_queue_reset_work_handler()
      -> mana_dealloc_queues()
        -> mana_gd_dev_reset()
          -> mana_cdx_dev_reset()
            -> cdx_dev_reset()

The detach paths can reach mana_dealloc_queues() too.

drivers/cdx/controller/mc_cdx_pcol.h documents MC_CMD_CDX_DEVICE_RESET
like this:

 * After this call completes, device DMA and interrupts are quiesced, devices
 * logic is reset in a hardware-specific way and DMA bus mastering is disabled.

That resets the HWC, all EQs, the other vPorts and RDMA, but the driver
keeps treating all of them as live. There is no re-init path on CDX:

- Bus mastering is only turned on by cdx_set_master() in
  mana_cdx_gd_probe().
- MSI is only enabled in mana_cdx_setup_hwc_irqs().
- gdma_cdx_driver has no reset_prepare or reset_done callbacks.
- mana_cdx_bus_ops has no schedule_serv_work.

So would the HWC requests that follow (mana_disable_vport_rx(), vPort
object teardown, re-attach) all time out? And when
mana_gf_stats_work_handler() detects the HWC timeout, would its servicing
request just be rejected with -EOPNOTSUPP?

On PCI, the same reset through pcie_flr() is backed by HWC-timeout
recovery through mana_pci_schedule_serv_work().

CDX also still advertises stall-SQ recovery to firmware through the
common GDMA_DRV_CAP_FLAGS1:

	 GDMA_DRV_CAP_FLAG_1_HANDLE_STALL_SQ_RECOVERY | \

Without a dev_reset op, mana_gd_dev_reset() would return -EOPNOTSUPP, and
a stall in one queue would not reset the whole function.

There is a second trigger. reset_store() in drivers/cdx/cdx.c calls
cdx_dev_reset() on a bound device, and
Documentation/ABI/testing/sysfs-bus-cdx says the driver gets notified.
With no reset_prepare/reset_done here, wouldn't a sysfs reset leave the
device in the same state?

[ ... ]

> +	xa_init(&gc->irq_contexts);
> +
> +	/* No IRQ affinity hint is applied here. The PCI transport spreads its
> +	 * vectors over the NUMA node local to the device; the CDX platforms
> +	 * this driver targets are single-node, so there is nothing to spread
> +	 * over. Affinity management can be added when a multi-node CDX host
> +	 * exists to validate it against.
> +	 */

[Severity: Low]
Is the reason given in this comment accurate? The PCI transport does more
than spread over the local node. mana_irq_setup_numa_aware() skips SMT
siblings and puts each vector on a different physical core:

	cpumask_andnot(cpus, cpus, topology_sibling_cpumask(cpu));
	...
	irq_set_affinity_and_hint(*irqs++, topology_sibling_cpumask(cpu));

mana_irq_setup_linear() also pins vector i to CPU i.

A single-node multi-core SoC still has cores to spread over. On CDX, the
EQ interrupts keep the default affinity and get no per-queue CPU
placement.

Could the comment, and the commit message, describe this difference from
PCI accurately?

[ ... ]

> +static int mana_cdx_setup_remaining_irqs(struct gdma_context *gc)
> +{
> +	unsigned int max_queues_vport;
> +
> +	/* mana_gd_query_max_resources() may turn MSI sharing back on and round
> +	 * the per-vPort queue count up to MANA_DEF_NUM_QUEUES. CDX sizes its
> +	 * vector pool at probe time and cannot grow it later, and the HWC
> +	 * vector must stay private, so give every vPort a private slice of the
> +	 * remaining vectors instead. gc->max_num_queues is already capped at
> +	 * num_msix_usable - 1 by the core.
> +	 */
> +	gc->msi_sharing = false;
> +	max_queues_vport = (gc->num_msix_usable - 1) / gc->num_ports;

[ ... ]

> +	gc->max_num_queues_vport = min(gc->max_num_queues, max_queues_vport);

[Severity: Low]
This isn't a bug, but after this patch the comment in
mana_gd_query_max_resources() in gdma_main.c is no longer accurate:

	 * not before. Only reset on platforms that support dynamic
	 * MSI-X allocation; on non-dyn platforms msi_sharing is
	 * unconditionally true (set in mana_gd_setup_hwc_irqs).

CDX leaves msix_can_alloc_dyn NULL, so it is a non-dyn bus. Even so,
mana_cdx_setup_hwc_irqs() sets msi_sharing to false. The core may set it
back to true, and then mana_cdx_setup_remaining_irqs() forces it to false
again and overwrites max_num_queues_vport.

Should the core comment be updated? It may also help to document in the
core that a transport is expected to override msi_sharing and
max_num_queues_vport in setup_remaining_irqs.

[ ... ]

> +	/* gc->is_pf is intentionally left clear: this device uses the VF
> +	 * register layout, and the vPort and MAC filter registration that
> +	 * is_pf selects is not required on this bus.
> +	 */
> +
> +	err = mana_gd_setup(gc);
> +	if (err)
> +		goto unmap_bar;

[Severity: High]
This issue was not introduced by this patch, but the shared HWC bootstrap
path that CDX now enters here uses a doorbell index supplied by the device
without checking its bounds.

mana_hwc_init_event_handler() in hw_channel.c stores the 16-bit doorbell
directly from the EQE:

	case GDMA_EQE_HWC_INIT_EQ_ID_DB:
		eq_db.as_uint32 = event->details[0];
		hwc->cq->gdma_eq->id = eq_db.eq_id;
		gd->doorbell = eq_db.doorbell;

mana_hwc_establish_channel() checks cq->id against max_num_cqs, but it
never checks the doorbell. mana_gd_ring_doorbell() then computes the MMIO
address:

	void __iomem *addr = gc->db_page_base + gc->db_page_size * db_index;

db_page_size is at least 4KB and the doorbell can be as large as 0xFFFF.
Could the next mana_gd_ring_eq() or mana_gd_ring_cq() then write far past
the ioremapped BAR0, into unmapped vmalloc space or another mapping?

mana_gd_register_device() already has this check for the regular
doorbell:

	if (gc->db_page_off + gc->db_page_size * ((u64)resp.db_id + 1) > gc->bar0_size) {

Should the HWC path apply the same check? This affects the PCI transport
as well.

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260924173054.589291-1-mawasthi%40linux.microsoft.com
