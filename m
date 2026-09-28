Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A761418361;
	Mon, 28 Sep 2026 20:26:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790627190; cv=none; b=fLqmpw+/7S8Kx6bHjJk87JRd9eoomsild8hSNj7PD42SMPyXZ1ZJIzEmZZ/aqrDoUqRtfWFGseeCervnX91dt3x9sp1hRVRTH7zdikIE+Bt2OlS99Itro33sPKaelWuSQccJHhj6Gje1PcGb6sJDDKsYcQmKS+Xqp+FAYSJ5B0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790627190; c=relaxed/simple;
	bh=JVQLPisFWV7/QWe/4PPVIK9JaRdW26lYmiMhceDhNo4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Y4gv8j2KcAn7mNbU5PYNzru+gPIkhmUWGZmbvlBFmJIodSpsmFWtj60+Pyl/sZXTP//qLMP9msLWmnoVtGtko6Ul8s6b/GRpQtgRU71kEAuSRlj6TXzoh0yWDBMY/kZbTWaqWFoE3M4G27OGdTBijRAJ/E8Bwk7Kxvmp3zW+IhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=nIc/TJxj; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="nIc/TJxj"
Received: from CPC-mawas-YGKSX.localdomain (unknown [70.37.26.39])
	by linux.microsoft.com (Postfix) with ESMTPSA id BDA6020B7166;
	Mon, 28 Sep 2026 13:25:36 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com BDA6020B7166
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1790627136;
	bh=IB5FNYnvJGa/0ttcxLcBPf/Z+/c+Dm6Ymm3z8YZso/0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nIc/TJxjbCuc+gs/tptP7HfgjRczgubeDSLWCoDfoB4qcfPN9ckV8gpIFFZpIPo3b
	 upXQNrDRDF0B+lrqPE9rfFGfafMQ+l2vqxDUvtEidUsDGU+c6yCxGwlwKrBPRK/Tsl
	 13L+1wbKcYqI19+kgscNJuqvA14AqFHuK1HAfjN8=
From: Manish Awasthi <mawasthi@linux.microsoft.com>
To: netdev-bot+sashiko@kernel.org
Cc: kys@microsoft.com,
	haiyangz@microsoft.com,
	wei.liu@kernel.org,
	decui@microsoft.com,
	longli@microsoft.com,
	andrew+netdev@lunn.ch,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	kotaranov@microsoft.com,
	horms@kernel.org,
	linux-hyperv@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	bpf@vger.kernel.org,
	nipun.gupta@amd.com,
	nikhil.agarwal@amd.com,
	gargaditya@linux.microsoft.com,
	ernis@linux.microsoft.com,
	kees@kernel.org,
	paulros@microsoft.com,
	mawasthi@microsoft.com,
	Manish Awasthi <mawasthi@linux.microsoft.com>
Subject: Re: [PATCH net-next 4/4] net: mana: Add support for CDX device ID 0x00C2
Date: Mon, 28 Sep 2026 20:25:55 +0000
Message-ID: <20260928202555.617331-1-mawasthi@linux.microsoft.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <179035761944.2160803.12943182451050438147@kernel.org>
References: <20260924173054.589291-5-mawasthi@linux.microsoft.com> <179035761944.2160803.12943182451050438147@kernel.org>
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

thanks for review. Comments inline.

> Thank you for your contribution! Sashiko AI review found 3 potential
> issue(s) to consider.
> 
> Critical: 0 · High: 0 (1) · Medium: 1 · Low: 2
> 
> If you believe none of the issues are legitimate, please reply to each
> issue of Medium severity or higher and explain why the AI is wrong.
> If any of them are legitimate and you plan to respin, please let patchwork
> know by including "pw-bot: cr" as a separate line at the end of your reply
> (one such reply per series is enough).
> 
> - [Medium] The CDX transport installs `.dev_reset = mana_cdx_dev_reset`
>   (-> `cdx_dev_reset()`) but has no way to recover afterwards.
> - [Low] `mana_cdx_setup_hwc_irqs()` skips IRQ affinity hints.
> - [Low] The comment in `mana_gd_query_max_resources()` (gdma_main.c)
>   says: "Only reset on platforms that support dynamic MSI-X allocation;…
> 
> Pre-existing issues:
> - [High] This problem wasn't introduced by this patch, but the shared HWC
>   bootstrap path that the new CDX transport now reaches trusts a device-…
> 
> --
> 
> net: mana: Add support for CDX device ID 0x00C2
> 
> This adds a CDX bus transport for MANA, built as mana_cdx.ko on top of
> the shared gdma_core.ko, for device ID 0x00C2. It allocates the whole MSI
> pool at probe time, limits the queue count to the available vectors,
> restricts DMA to 32 bits, and adds a per-bus auxiliary device name prefix
> so the CDX auxiliary devices stay separate from the PCI ones.
> 
> > diff --git a/drivers/net/ethernet/microsoft/mana/gdma_cdx.c b/drivers/net/ethernet/microsoft/mana/gdma_cdx.c
> > new file mode 100644
> > index 0000000000000..0d01e3d2f0d96
> > --- /dev/null
> > +++ b/drivers/net/ethernet/microsoft/mana/gdma_cdx.c
> > @@ -0,0 +1,340 @@
> 
> [ ... ]
> 
> > +static int mana_cdx_dev_reset(struct gdma_context *gc)
> > +{
> > +	return cdx_dev_reset(gc->dev);
> > +}
> 
> [Severity: Medium]
> Can this reset leave the whole function unusable, with no recovery short
> of a manual rebind?
> 
> mana_dealloc_queues() calls it when a TX queue still has pending_sends
> after the drain timeout:
> 
> mana_tx_timeout()
>   -> queue_reset_work
>     -> mana_per_port_queue_reset_work_handler()
>       -> mana_dealloc_queues()
>         -> mana_gd_dev_reset()
>           -> mana_cdx_dev_reset()
>             -> cdx_dev_reset()
> 
This version of the driver doesn't support recovery after mana_cdx_dev_reset.

> The detach paths can reach mana_dealloc_queues() too.
> 
> drivers/cdx/controller/mc_cdx_pcol.h documents MC_CMD_CDX_DEVICE_RESET
> like this:
> 
>  * After this call completes, device DMA and interrupts are quiesced, devices
>  * logic is reset in a hardware-specific way and DMA bus mastering is disabled.
> 
> That resets the HWC, all EQs, the other vPorts and RDMA, but the driver
> keeps treating all of them as live. There is no re-init path on CDX:
> 
> - Bus mastering is only turned on by cdx_set_master() in
>   mana_cdx_gd_probe().
> - MSI is only enabled in mana_cdx_setup_hwc_irqs().
> - gdma_cdx_driver has no reset_prepare or reset_done callbacks.
> - mana_cdx_bus_ops has no schedule_serv_work.
> 
> So would the HWC requests that follow (mana_disable_vport_rx(), vPort
> object teardown, re-attach) all time out? And when
> mana_gf_stats_work_handler() detects the HWC timeout, would its servicing
> request just be rejected with -EOPNOTSUPP?
> 
The first HWC request after reset call will wait for default timeout and subsequent commands will fail after 1ms.
A future patch will change the tx timeout recovery to reset the timeout to 0 after dev_reset for both pci and cdx.

> On PCI, the same reset through pcie_flr() is backed by HWC-timeout
> recovery through mana_pci_schedule_serv_work().
> 
> CDX also still advertises stall-SQ recovery to firmware through the
> common GDMA_DRV_CAP_FLAGS1:
> 
> 	 GDMA_DRV_CAP_FLAG_1_HANDLE_STALL_SQ_RECOVERY | \
> 
> Without a dev_reset op, mana_gd_dev_reset() would return -EOPNOTSUPP, and
> a stall in one queue would not reset the whole function.
This flag represents the capability of the driver to support ndo_tx_timeout for cdx.
> 
> There is a second trigger. reset_store() in drivers/cdx/cdx.c calls
> cdx_dev_reset() on a bound device, and
> Documentation/ABI/testing/sysfs-bus-cdx says the driver gets notified.
> With no reset_prepare/reset_done here, wouldn't a sysfs reset leave the
> device in the same state?
> 
> [ ... ]
> 
> > +	xa_init(&gc->irq_contexts);
> > +
> > +	/* No IRQ affinity hint is applied here. The PCI transport spreads its
> > +	 * vectors over the NUMA node local to the device; the CDX platforms
> > +	 * this driver targets are single-node, so there is nothing to spread
> > +	 * over. Affinity management can be added when a multi-node CDX host
> > +	 * exists to validate it against.
> > +	 */
> 
The support for reset_prepare/reset_done will be added in future.

> [Severity: Low]
> Is the reason given in this comment accurate? The PCI transport does more
> than spread over the local node. mana_irq_setup_numa_aware() skips SMT
> siblings and puts each vector on a different physical core:
> 
> 	cpumask_andnot(cpus, cpus, topology_sibling_cpumask(cpu));
> 	...
> 	irq_set_affinity_and_hint(*irqs++, topology_sibling_cpumask(cpu));
> 
> mana_irq_setup_linear() also pins vector i to CPU i.
> 
> A single-node multi-core SoC still has cores to spread over. On CDX, the
> EQ interrupts keep the default affinity and get no per-queue CPU
> placement.
> 
> Could the comment, and the commit message, describe this difference from
> PCI accurately?
> 
> [ ... ]
> 
> > +static int mana_cdx_setup_remaining_irqs(struct gdma_context *gc)
> > +{
> > +	unsigned int max_queues_vport;
> > +
> > +	/* mana_gd_query_max_resources() may turn MSI sharing back on and round
> > +	 * the per-vPort queue count up to MANA_DEF_NUM_QUEUES. CDX sizes its
> > +	 * vector pool at probe time and cannot grow it later, and the HWC
> > +	 * vector must stay private, so give every vPort a private slice of the
> > +	 * remaining vectors instead. gc->max_num_queues is already capped at
> > +	 * num_msix_usable - 1 by the core.
> > +	 */
> > +	gc->msi_sharing = false;
> > +	max_queues_vport = (gc->num_msix_usable - 1) / gc->num_ports;
> 
> [ ... ]
> 
> > +	gc->max_num_queues_vport = min(gc->max_num_queues, max_queues_vport);
> 
> [Severity: Low]
> This isn't a bug, but after this patch the comment in
> mana_gd_query_max_resources() in gdma_main.c is no longer accurate:
> 
> 	 * not before. Only reset on platforms that support dynamic
> 	 * MSI-X allocation; on non-dyn platforms msi_sharing is
> 	 * unconditionally true (set in mana_gd_setup_hwc_irqs).
> 
> CDX leaves msix_can_alloc_dyn NULL, so it is a non-dyn bus. Even so,
> mana_cdx_setup_hwc_irqs() sets msi_sharing to false. The core may set it
> back to true, and then mana_cdx_setup_remaining_irqs() forces it to false
> again and overwrites max_num_queues_vport.
> 
> Should the core comment be updated? It may also help to document in the
> core that a transport is expected to override msi_sharing and
> max_num_queues_vport in setup_remaining_irqs.
> 
> [ ... ]
> 
> > +	/* gc->is_pf is intentionally left clear: this device uses the VF
> > +	 * register layout, and the vPort and MAC filter registration that
> > +	 * is_pf selects is not required on this bus.
> > +	 */
> > +
> > +	err = mana_gd_setup(gc);
> > +	if (err)
> > +		goto unmap_bar;
> 
> [Severity: High]
> This issue was not introduced by this patch, but the shared HWC bootstrap
> path that CDX now enters here uses a doorbell index supplied by the device
> without checking its bounds.
> 
> mana_hwc_init_event_handler() in hw_channel.c stores the 16-bit doorbell
> directly from the EQE:
> 
> 	case GDMA_EQE_HWC_INIT_EQ_ID_DB:
> 		eq_db.as_uint32 = event->details[0];
> 		hwc->cq->gdma_eq->id = eq_db.eq_id;
> 		gd->doorbell = eq_db.doorbell;
> 
> mana_hwc_establish_channel() checks cq->id against max_num_cqs, but it
> never checks the doorbell. mana_gd_ring_doorbell() then computes the MMIO
> address:
> 
> 	void __iomem *addr = gc->db_page_base + gc->db_page_size * db_index;
> 
> db_page_size is at least 4KB and the doorbell can be as large as 0xFFFF.
> Could the next mana_gd_ring_eq() or mana_gd_ring_cq() then write far past
> the ioremapped BAR0, into unmapped vmalloc space or another mapping?
> 
> mana_gd_register_device() already has this check for the regular
> doorbell:
> 
> 	if (gc->db_page_off + gc->db_page_size * ((u64)resp.db_id + 1) > gc->bar0_size) {
> 
> Should the HWC path apply the same check? This affects the PCI transport
> as well.
> 
> [ ... ]
> 
> -- 
> Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260924173054.589291-1-mawasthi%40linux.microsoft.com
