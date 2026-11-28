Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795883991;
	b=s5X3Dsj0Z+G2O3P0D5wmolKcdYpkxIv46bHYNhqB3KPwBDEuSLnV343h0I1xMVSrBHYb
	 biERHqaXrx5XpnC7kRDaKHmdwAtjEDljAl9RnJs3iuxkuInH647mslbssmerkw3GxBMvx
	 ErDfJ5zDu9ITxIXjtlzS0KharUOOx5WcZxKxLtTmstCAz17xWTZRNp9jGGedGEDlsiFkx
	 xvo0Q8M2BQQ6u+Gqqv5LCwXZ7QySnZFCiSeK5/r5SdKFgeDeLj4Po1saNAAn8I2O2TgtM
	 ZsKPfJYsH9kmUEa/DN87+NTWGs/gwI01AmwMqIDZJjHW/FJ90pmDND4cgM84wo73rkA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795883991;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=imwxGAVPqjiGt3LMeZ6JHCKUgqOrEulTf5ZhM/xKTTA=;
	b=IzhNNPWjbtTVoThpt6r6wyJwX7e8WyDEWAUqhtBtz1huoZfSqT9l6fGVxgLd8xIOEaKF
	 lrkuSF7wh4iuZvp42YBeVF9WM7rLVDRZUmU0G/nIleySumA7pTSkIBNfNPZdRMzlyqfX0
	 hLJxhti+gIDhYFHGJ4YWIzOcAhwpqaOliH1h4TTVVeKiw4dexNcXmOH9so3BCDX139GY9
	 rnmUcIxIZzDs9lWYoo4AvxYysd/wCg1txWK2H81EKG2Cmp8D2vSfG+AShb0jmOYzOuC0f
	 p9t9gwk6r81kH8+iZEsNtWXFQmKMkoq3y42ahWLnrF9qPihh+Aiz81EslMDItn49npw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZwXOUKPk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30225606A321;
	Sat, 28 Nov 2026 16:39:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZwXOUKPk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF17B1F00899;
	Sat, 28 Nov 2026 16:39:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795883990;
	bh=imwxGAVPqjiGt3LMeZ6JHCKUgqOrEulTf5ZhM/xKTTA=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=ZwXOUKPksaS2rX6kspCOCvuIt7cKTgi+KJAZSLHSYmyKphE2OEcUE96l+uALP2W+d
	 B+6jfPuPiBZMPPkqKLeUQq1WKrobqM34Vx9X801pSewcIPzctH5/R4T0pslnlFkWO0
	 wzzkje3Icu244RwNHUAsWm9MFYjFHCbogpvHGAusF0sBSRXA+dt3Y7WYdevoW8ZhJ1
	 lsQmdc+YjDzM1hzCRiiX0xkLnLlbJr7LVg2vIc7P3lxTCFy5H2TNXiEdSNhVVF3YQj
	 KBmZE347y9iawznXvOWdJphogQ5DNPkrz+tEFjm9exV85Vbgqcuf3VMtJHD2p9qlxu
	 jCMLsZ0Xlk+iA==
Subject: Re: [PATCH net-next v12 2/5] net: mana: keep HWC queues until the PF
 acknowledges teardown
From: netdev-bot+sashiko@kernel.org
To: weh@linux.microsoft.com
Cc: longli@kernel.org, kotaranov@microsoft.com, kuba@kernel.org,
 davem@davemloft.net, pabeni@redhat.com, edumazet@google.com,
 andrew+netdev@lunn.ch, jgg@ziepe.ca, leon@kernel.org, haiyangz@microsoft.com,
 wei.liu@kernel.org, decui@microsoft.com, shradhagupta@linux.microsoft.com,
 horms@kernel.org, ernis@linux.microsoft.com, stephen@networkplumber.org,
 netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
 linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
 gargaditya@linux.microsoft.com, kees+treewide@kernel.org, kees@kernel.org,
 mawasthi@linux.microsoft.com, weh@microsoft.com, edumazet@kernel.org,
 shacharr@microsoft.com
Date: Sat, 28 Nov 2026 16:39:48 +0000
Message-ID: <179588398847.3135.906138429587218178@kernel.org>
In-Reply-To: <hwc-v12.91ec3eff9cb647d5bc5cc932b3c6f60c.2@linux.microsoft.com>
References: <hwc-v12.91ec3eff9cb647d5bc5cc932b3c6f60c.2@linux.microsoft.com>
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

Thank you for your contribution! Sashiko AI review found 8 potential
issue(s) to consider.

Critical: 0 · High: 0 · Medium: 5 · Low: 3

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] After this patch, a DESTROY_HWC that the PF does not
  acknowledge leaves the NIC bound but permanently dead, and nothing in…
- [Medium] The unbound-sibling veto on the FPGA path of
  mana_serv_rescan() is too broad.
- [Medium] On the FPGA path, mana_serv_rescan() now calls
  pci_walk_bus(target->subordinate, mana_check_unbound, ...) while…
- [Medium] The unbound-sibling check in mana_serv_rescan() is not atomic
  with the bridge removal it is meant to guard.
- [Medium] The patch treats every failed DESTROY_HWC as "the PF may still
  DMA into these buffers", even when the function is gone.
- [Low] The commit message does not describe several user-visible changes
  to PCI service and recovery in gdma_pci.c and gdma_main.c: -…
- [Low] The comment on the new prototype in include/net/mana/gdma.h says
  mana_gd_fence_eq() "Remove[s] an EQ from interrupt dispatch without…
- [Low] Two new functions mix scope-based cleanup with goto-based cleanup
  labels, which include/linux/cleanup.h and the subsystem guide say not…

--

net: mana: keep HWC queues until the PF acknowledges teardown

This patch serializes HWC setup and teardown over the shared memory
channel. When DESTROY_HWC fails, it fences the HWC EQ and keeps the queues
and their DMA memory instead of freeing them. It also changes how the
cq_table is published and torn down, and changes PCI probe, resume and
service recovery so that a function with a retained HWC is not probed
again.

> A failed PCI probe has no context left to retry the destroy. Do not
> start another automatic probe that could lose another set of coherent
> allocations. A failed resume can keep the binding and retry in place.

[Severity: Low]
The changelog doesn't mention several behaviour changes in gdma_pci.c and
gdma_main.c:

- mana_serv_fpga() is folded into mana_serv_rescan(). FPGA-reconfig
  recovery is now skipped entirely when any MANA-ID function under the
  upstream bridge has no driver bound.

- The new global mana_rescan_task lets mana_gd_remove() veto the
  pci_rescan_bus() that follows removal. When the veto fires, the removed
  device is never re-enumerated. On the FPGA path that is the whole bridge
  subtree.

- Both service paths now take the device lock.

- mana_gd_process_eqe() drops the WARN_ON_ONCE() checks for an
  out-of-range cq_id and for a NULL cq. This applies to every CQ, not only
  the HWC, so those EQEs are now silently discarded.

Could the changelog describe these as well?

> diff --git a/drivers/net/ethernet/microsoft/mana/gdma_pci.c b/drivers/net/ethernet/microsoft/mana/gdma_pci.c
> index 208dadbcf977c..cec2e548f36ea 100644
> --- a/drivers/net/ethernet/microsoft/mana/gdma_pci.c
> +++ b/drivers/net/ethernet/microsoft/mana/gdma_pci.c

[ ... ]

> +static int mana_check_unbound(struct pci_dev *pdev, void *data)
> +{
> +	bool *unbound = data;
>  
> -	pci_stop_and_remove_bus_device(pdev);
> -	pci_rescan_bus(parent);
> +	if (READ_ONCE(pdev->driver) ||
> +	    !pci_match_id(mana_driver.id_table, pdev))
> +		return 0;

[Severity: Medium]
Is this check atomic with the bridge removal it guards?
mana_check_unbound() reads each sibling's pdev->driver while holding only
pci_rescan_remove_lock and the serviced device's device lock. It does not
hold the sibling's device lock.

local_pci_probe() sets pdev->driver before calling ->probe() and clears it
if the probe fails:

drivers/pci/pci-driver.c:local_pci_probe() {
    ...
	pci_dev->driver = pci_drv;
	rc = pci_drv->probe(pci_dev, ddi->id);
    ...
}

Sysfs bind and async probing don't take pci_rescan_remove_lock. So a
sibling that is still inside mana_gd_probe() looks bound to this walk.

Suppose that probe then fails with a retained HWC and returns
-ENOTRECOVERABLE. The sibling ends up unbound. When
pci_stop_and_remove_bus_device(target) reaches it, there is no driver, so
no ->remove() runs to clear mana_rescan_task. pci_rescan_bus() then
probes the sibling again.

Doesn't that start the extra automatic probe that the commit message says
must be avoided? That probe could abandon another set of HWC coherent
allocations.

[ ... ]

> -static void mana_serv_fpga(struct pci_dev *pdev)
> +static void mana_serv_rescan(struct pci_dev *pdev,
> +			     enum mana_rescan_reason reason)
>  {
> -	struct pci_bus *bus, *parent;
> +	struct pci_dev *target = pdev;
> +	struct pci_bus *parent;
> +	bool unbound = false;
>  
>  	pci_lock_rescan_remove();
> -
> -	bus = pdev->bus;
> -	if (!bus) {
> -		dev_err(&pdev->dev, "MANA service: no bus\n");
> +	if (!device_is_registered(&pdev->dev))
>  		goto out;
> +
> +	scoped_guard(device, &pdev->dev) {
> +		if (reason == MANA_RESCAN_PROBE) {
> +			if (pdev->dev.driver)
> +				goto out;

[Severity: Low]
This isn't a bug, but this function and mana_serv_reset() both mix
guard()/scoped_guard() with goto-based cleanup labels.
include/linux/cleanup.h asks to avoid that.

Here pci_lock_rescan_remove() is taken by hand and the device lock is a
scoped_guard. Three goto out exits leave the guard to reach
pci_unlock_rescan_remove() at the label.

In mana_serv_reset(), guard(device) is at function scope. Its out label
runs clear_bit(GC_IN_SERVICE, &gc->flags), and the early return false and
return true exits skip that label.

Would it be clearer to convert each function to a single style? That would
make it obvious which exits unlock and which clear GC_IN_SERVICE.

> +		} else if (pdev->driver != &mana_driver) {
> +			goto out;
> +		} else if (reason == MANA_RESCAN_FPGA) {
> +			struct gdma_context *gc = pci_get_drvdata(pdev);
> +
> +			/* An unbound sibling cannot veto the bridge rescan in
> +			 * ->remove(). Its last probe may have lost HWC DMA.
> +			 */
> +			target = pci_upstream_bridge(pdev);
> +			if (target)
> +				pci_walk_bus(target->subordinate,
> +					     mana_check_unbound, &unbound);

[Severity: Medium]
Can this deadlock against PCIe error recovery? pci_walk_bus() takes
down_read(&pci_bus_sem) while scoped_guard(device, &pdev->dev) holds the
MANA device lock.

AER recovery takes the two locks in the opposite order:

pcie_do_recovery()
  pci_walk_bridge()
    pci_walk_bus()                <- pci_bus_sem held for read
      report_frozen_detected()
        report_error_detected()
          device_lock(&dev->dev)

rwsem readers queue behind a waiting writer. Some pci_bus_sem writers
don't take pci_rescan_remove_lock. One example is
pci_register_host_bridge(), reached through pci_scan_root_bus_bridge()
from create_root_hv_pci_bus() in pci-hyperv.c.

With such a writer queued:

AER thread:   holds pci_bus_sem (read), waits for the MANA device lock
writer:       waits in down_write(&pci_bus_sem) for the AER reader
MANA service: holds the device lock, waits in down_read() behind writer

Lockdep won't report this, because device mutexes are novalidate. The old
code never held a device lock across a bus walk.

pci_rescan_remove_lock is already held at this point. Could the walk be
done outside the device lock?

> +			if (unbound) {
> +				dev_err(&pdev->dev,
> +					"Unbound MANA function, skipping bridge rescan\n");
> +				clear_bit(GC_IN_SERVICE, &gc->flags);
> +				goto out;
> +			}

[Severity: Medium]
Is this veto broader than intended? mana_check_unbound() flags any MANA-ID
function under the upstream bridge that has no driver. It can't tell a
function whose probe lost HWC DMA from one that is unbound for other
reasons, for example:

- an administrator unbound it through sysfs
- SR-IOV VFs that weren't autoprobed, or whose probe failed
- a sibling whose probe failed with -ENOMEM or a DMA mask error
- a sibling that failed with -ETIMEDOUT or -EPROTO and is waiting for the
  delayed recovery re-probe

pci_walk_bus() also descends into VF virtual buses, so PF hosts with
unbound VFs can hit this.

In each of these cases, a GDMA_EQE_HWC_FPGA_RECONFIG event on a bound
function now logs, clears GC_IN_SERVICE and returns. mana_serv_fpga()
always did the bridge remove, sleep and rescan here.

Doesn't that leave the bound function with stale hardware state after the
FPGA reconfiguration, with nothing retrying recovery?

> +		}
>  	}
>  
> -	parent = bus->parent;
> -	if (!parent) {
> +	if (!target || !target->bus) {
>  		dev_err(&pdev->dev, "MANA service: no parent bus\n");
>  		goto out;
>  	}
>  
> -	pci_stop_and_remove_bus_device(bus->self);
> +	parent = target->bus;
> +	WRITE_ONCE(mana_rescan_task, current);
> +	pci_stop_and_remove_bus_device(target);
> +	if (!READ_ONCE(mana_rescan_task))
> +		goto out;
> +	WRITE_ONCE(mana_rescan_task, NULL);

[ ... ]

> @@ -682,11 +723,16 @@ static void mana_gd_remove(struct pci_dev *pdev)
>  
>  	mana_gd_cleanup(gc);
>  
> +	if (gc->hwc.driver_data && READ_ONCE(mana_rescan_task) == current) {
> +		dev_err(gc->dev, "HWC teardown failed, skipping PCI rescan\n");
> +		WRITE_ONCE(mana_rescan_task, NULL);
> +	}
> +
>  	xa_destroy(&gc->irq_contexts);
>  
>  	pci_iounmap(pdev, gc->bar0_va);
>  
> -	vfree(gc);
> +	mana_gd_free_context(gc);

[Severity: Medium]
What happens here when the function has been surprise removed, or is
otherwise unreachable?

Every SMC read returns 0xFFFFFFFF, and mana_smc_teardown_hwc() is called
with reset_vf=false. mana_smc_poll_register() therefore spins for the
whole poll window (20-40 seconds) before DESTROY fails.

mana_gd_free_context() then calls mana_hwc_free_retained_channel(), which
only frees the software wrappers:

mana_hwc_free_retained_wq() {
	...
	kfree(wq->msg_buf);
	kfree(wq->gdma_wq);
	kfree(wq);
}

Doesn't that permanently leak the coherent DMA allocations for the
EQ/CQ/RQ/SQ rings and the message buffers? A disconnected device can't
DMA into them, but nothing checks pci_dev_is_disconnected() or
pci_channel_offline() before deciding to keep them.

On the FPGA_RECONFIG path, the same failure clears mana_rescan_task here.
mana_serv_rescan() then takes this exit:

	if (!READ_ONCE(mana_rescan_task))
		goto out;

That skips both the reconfiguration wait and pci_rescan_bus(). Would the
reconfigured function, and every sibling under the removed bridge, then
stay gone until a manual rescan or a reboot?

[ ... ]

> @@ -728,6 +774,10 @@ static int mana_gd_resume(struct pci_dev *pdev)
>  
>  cleanup_gd:
>  	mana_gd_cleanup(gc);
> +check_hwc:
> +	/* Keep the binding and DMA handles for a later DESTROY retry. */
> +	if (gc->hwc.driver_data)
> +		return -ENOTRECOVERABLE;
>  	return err;
>  }

[Severity: Medium]
Is anything left to do the "retry in place"?

Only a successful DESTROY response clears hwc->setup_active. Teardown
passes reset_vf=false, so during a reset an all-ones aperture is treated
as PF ownership until mana_smc_poll_register() times out.

For a GDMA_EQE_HWC_RESET_REQUEST where DESTROY is not acknowledged:

mana_serv_reset()
  mana_gd_suspend()
    mana_gd_cleanup()
      mana_hwc_destroy_channel()   <- fails, fences HWC EQ, keeps hwc
  msleep(10 s)
  mana_gd_resume()
    mana_gd_setup()
      mana_hwc_create_channel()
        mana_hwc_destroy_channel() <- single retry fails, -ETIMEDOUT
      gc->bus_ops->remove_irqs()
    check_hwc: return -ENOTRECOVERABLE

mana_serv_reset() only escalates on these errors:

	if (ret == -ETIMEDOUT || ret == -EPROTO) {

so it just logs and clears GC_IN_SERVICE. Before this patch, this path
went on to mana_serv_rescan() and re-enumerated the function.

No IRQs are registered now, so no later RESET_REQUEST or FPGA_RECONFIG
event can arrive. No work item or timer retries DESTROY either. Does the
NIC then stay bound but dead until a PM cycle, a manual unbind or a
reboot?

The probe path is similar. The free_gc label in mana_gd_probe() turns
-ETIMEDOUT/-EPROTO into -ENOTRECOVERABLE. So the delayed recovery work,
which the comment below reserves for the case where "Hardware could be in
recovery mode", is never scheduled.

[ ... ]

> diff --git a/include/net/mana/gdma.h b/include/net/mana/gdma.h
> index bde68d6a99f01..2da086a3b8f72 100644
> --- a/include/net/mana/gdma.h
> +++ b/include/net/mana/gdma.h
> @@ -600,6 +600,9 @@ int mana_gd_create_mana_wq_cq(struct gdma_dev *gd,
>  
>  void mana_gd_destroy_queue(struct gdma_context *gc, struct gdma_queue *queue);
>  
> +/* Remove an EQ from interrupt dispatch without freeing its queue memory. */
> +void mana_gd_fence_eq(struct gdma_context *gc, struct gdma_queue *queue);

[Severity: Low]
This doesn't break anything today, but does the comment match what
mana_gd_fence_eq() does? The function is just
mana_gd_destroy_eq(gc, false, queue), and that does more than remove the
EQ from dispatch:

- It sets queue->eq.msix_index to INVALID_PCI_MSIX_INDEX. A later
  mana_gd_destroy_queue() on the same EQ then returns early.

- It calls mana_gd_disable_queue() when queue->eq.disable_needed is set.

disable_needed is true for every EQ created through
mana_gd_create_hw_eq(), which covers all the data-path EQs. Both current
callers pass HWC EQs, where disable_needed is false, so the mismatch is
latent for now. A future caller that relies on the comment would disable
the hardware EQ without meaning to.

Could the comment say what the helper actually does?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/hwc-v12.91ec3eff9cb647d5bc5cc932b3c6f60c.0%40linux.microsoft.com
