Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A866D4AFE14;
	Fri, 25 Sep 2026 17:33:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790357621; cv=none; b=Elhn5gGVM4P8qWf3gKeS/xiLD6M0bTh2HOO4kPN9WWcSv6r+8QTXCPamS6kXzQnALlBMhvszTI3eNGOAOfZwxZmB7S8UiUrrby2lXVOLoziAHYZLcS5sWEPn79eKOTBEUvgE0FO1+rUbkFPZJNcvJXmwn4e0o0zhXy4QfxB8TGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790357621; c=relaxed/simple;
	bh=Gs5ku4OXG29At0bM6JrLfDc557h9eEiAl/ZTxqziH2A=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=h2mVoBpAZeBm8C4cMtZtxabkDbFot0K3KuuSL5hbZPFvZo0fJlzUUZYkAiCfQw+Q4paOgvtSKVLJ8NpLTLoacQVHXzAGZKq1GDoRQmtr2VmMt7ZwQYmAl0fHVGNuVnYJ3kd4weVXVbdNQ4likl5U3UzU4i9wE2Zc/DvJi7GzVdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aRe17dhv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aRe17dhv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F7E41F00893;
	Fri, 25 Sep 2026 17:33:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790357619;
	bh=06iDAVHU/eCeO/pYVB8XzXYJZwn6jZB7Utaw4mvxmms=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=aRe17dhv4JQ5KfTRGu2NRqgxFNP/mAJp7bjD6POKhPtiR+XF8/1W2R+YJxOrfZbNk
	 WJW6JDLm+gTE8imCiZzphm+THN2V8EYPdLAXeeP3cPwjNcsH60a7HbgIj2wJNy+L/b
	 V0SZBGBeYW7qyM25mlBzaWn5lnsz1WKkWkgMaPd35CQAqwk9xjJsaAOTSEOWYXDIMs
	 G89mvkbmlaRSghS2qHrAOhZpWLxrpqBcCAmui6XJk9wSB0443okE47AvE6zqTl5qvr
	 rzYmkQTWpK80aEd+4REFGoh+fvZTbXKpQybarSVxkEnQ+CZitw0Sxqu+ys0hVLrhic
	 usbaPuJiaYObg==
Subject:
 Re: [PATCH net-next 2/4] net: mana: Move PCI transport code into gdma_pci.c
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
Date: Fri, 25 Sep 2026 17:33:37 +0000
Message-ID: <179035761764.2160803.7364659426133894116@kernel.org>
In-Reply-To: <20260924173054.589291-3-mawasthi@linux.microsoft.com>
References: <20260924173054.589291-3-mawasthi@linux.microsoft.com>
X-sashiko-severity: Low
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found more severe
issue(s) in other patches of this series. This mail is only an FYI, in case
you want to address the nit picks below when you respin.

Low priority / nit picks for your consideration:

- [Low] The include lists no longer match what each file uses.

Pre-existing issues:
- [High] This problem wasn't introduced by this patch, but it is moved
  verbatim into gdma_pci.c and is still present at the end of the series.
- [High] This problem wasn't introduced by this patch, but it is moved
  verbatim and still present at the end of the series.
- [Medium] This problem wasn't introduced by this patch, but it is
  carried over verbatim.
- [Medium] This problem wasn't introduced by this patch, but it is
  carried over verbatim.
- [Low] This problem wasn't introduced by this patch, but it is carried
  over verbatim.

--

net: mana: Move PCI transport code into gdma_pci.c

This commit moves the PCI transport code, the MSI-X setup, the recovery
work and the pci_driver callbacks out of gdma_main.c and into a new file,
gdma_pci.c. mana_pci_driver_register() and mana_pci_driver_unregister()
are now exported through gdma.h, and the Makefile builds gdma_pci.o.

> diff --git a/drivers/net/ethernet/microsoft/mana/gdma_main.c b/drivers/net/ethernet/microsoft/mana/gdma_main.c
> index b076760b2dc50..531170e58a62d 100644
> --- a/drivers/net/ethernet/microsoft/mana/gdma_main.c
> +++ b/drivers/net/ethernet/microsoft/mana/gdma_main.c
> @@ -2,10 +2,7 @@
>  /* Copyright (c) 2021, Microsoft Corporation. */
>  
>  #include <linux/bitfield.h>
> -#include <linux/cpumask.h>
>  #include <linux/debugfs.h>
> -#include <linux/delay.h>
> -#include <linux/list.h>
>  #include <linux/module.h>
>  #include <linux/sizes.h>
>  #include <linux/utsname.h>
> @@ -13,11 +10,7 @@
>  #include <linux/msi.h>
>  #include <linux/irqdomain.h>
>  #include <linux/export.h>
> -#include <linux/pci.h>
> -#include <linux/slab.h>
> -#include <linux/topology.h>
>  #include <linux/uaccess.h>
> -#include <linux/xarray.h>

[Severity: Low]
The code that stays in gdma_main.c still uses APIs from several of the
headers removed here:

  - xa_load()/xa_store()/xa_erase()/xa_err(), for example in
    mana_gd_get_gic() and mana_gd_put_gic()
  - kzalloc()/kzalloc_obj()/kfree()
  - list_add_rcu()/list_del_rcu()
  - num_online_cpus()

Does gdma_main.c now build only because <net/mana/gdma.h> pulls in
list.h, slab.h, xarray.h and cpumask.h indirectly, through netdevice.h
and dma-mapping.h?

It also looks like the includes are unbalanced the other way.
<linux/msi.h> and <linux/irqdomain.h> are still included here, but no
msi or irq_domain users are left after the MSI-X code moved out. The new
gdma_pci.c includes <linux/debugfs.h> but does not use any debugfs API.

The commit message doesn't mention the include changes. Could gdma_main.c
keep direct includes for what it still uses, and could the unused
includes be dropped?

[ ... ]

> diff --git a/drivers/net/ethernet/microsoft/mana/gdma_pci.c b/drivers/net/ethernet/microsoft/mana/gdma_pci.c
> new file mode 100644
> index 0000000000000..4f6a77f55e5a7
> --- /dev/null
> +++ b/drivers/net/ethernet/microsoft/mana/gdma_pci.c
> @@ -0,0 +1,909 @@

[ ... ]

> +static void mana_serv_reset(struct pci_dev *pdev)
> +{
> +	struct gdma_context *gc = pci_get_drvdata(pdev);
> +	struct hw_channel_context *hwc;
> +	int ret;

[ ... ]

> +	dev_info(&pdev->dev, "MANA reset cycle start\n");
> +
> +	mana_gd_suspend(pdev, PMSG_SUSPEND);
> +
> +	msleep(MANA_SERVICE_PERIOD * 1000);
> +
> +	ret = mana_gd_resume(pdev);

[ ... ]

> +out:
> +	clear_bit(GC_IN_SERVICE, &gc->flags);
> +}

[Severity: High]
This isn't a bug introduced by this patch, since the code moves over
unchanged, but what keeps gc alive across this 10 second window?

mana_pci_schedule_serv_work() queues mana_serv_func() on the system
workqueue. It holds only a pci_dev reference and a module reference.
mana_serv_reset() holds neither device_lock(&pdev->dev) nor
pci_lock_rescan_remove() across the suspend/msleep/resume sequence.
mana_gd_remove() never cancels or flushes this work, and it ignores
GC_IN_SERVICE.

If a sysfs unbind or a Hyper-V vPCI eject overlaps the sleep:

CPU0 (mana_serv_func)               CPU1 (unbind / eject)
mana_serv_reset()
  mana_gd_suspend()
  msleep()
                                    mana_gd_remove()
                                      mana_gd_cleanup(gc)  /* again */
                                      vfree(gc)
                                    driver core clears drvdata
  mana_gd_resume(pdev)
    mana_gd_setup(gc)  /* NULL or freed */
  clear_bit(GC_IN_SERVICE, &gc->flags)

Could this cause a NULL dereference in mana_gd_setup(), or a write to
vfree'd memory from clear_bit()?

HWC reset and FPGA events in mana_gd_process_eqe() can schedule this
work, and so can HWC timeouts in mana_gf_stats_work_handler().

> +static void mana_do_service(enum gdma_eqe_type type, struct pci_dev *pdev)
> +{

[ ... ]

> +static void mana_recovery_delayed_func(struct work_struct *w)
> +{
> +	struct mana_dev_recovery_work *work;
> +	struct mana_dev_recovery *dev;
> +	unsigned long flags;
> +
> +	work = container_of(w, struct mana_dev_recovery_work, work.work);
> +
> +	spin_lock_irqsave(&work->lock, flags);
> +
> +	while (!list_empty(&work->dev_list)) {
> +		dev = list_first_entry(&work->dev_list,
> +				       struct mana_dev_recovery, list);
> +		list_del(&dev->list);
> +		spin_unlock_irqrestore(&work->lock, flags);
> +
> +		mana_do_service(dev->type, dev->pdev);

[Severity: Medium]
This is a pre-existing issue, but can this loop keep running without
ever returning while the device keeps failing probe?

For an entry queued by a failed probe, drvdata is NULL, so the call
chain is:

mana_recovery_delayed_func()
  mana_do_service()
    mana_serv_reset()          /* gc == NULL */
      mana_serv_rescan()
        pci_stop_and_remove_bus_device()
        pci_rescan_bus()
          mana_gd_probe()      /* synchronous, fails again */
            list_add_tail(&dev->list, &mana_dev_recovery_work.dev_list);
            schedule_delayed_work(...);

mana_driver sets no async probe_type, so the re-probe happens inside
this work item.

Because the while loop re-checks the live dev_list, it picks up the new
entry right away and skips the MANA_SERVICE_PERIOD back-off. If the
hardware stays unresponsive, would disable_delayed_work_sync() in
mana_pci_driver_unregister() then wait on this work indefinitely?

> +		pci_dev_put(dev->pdev);
> +		kfree(dev);
> +
> +		spin_lock_irqsave(&work->lock, flags);
> +	}
> +
> +	spin_unlock_irqrestore(&work->lock, flags);
> +}

[ ... ]

> +static int mana_irq_setup_numa_aware(unsigned int *irqs, unsigned int len,
> +				     int node, bool skip_first_cpu)
> +{
> +	const struct cpumask *next, *prev = cpu_none_mask;
> +	cpumask_var_t cpus __free(free_cpumask_var);
> +	int cpu, weight;
> +
> +	if (!alloc_cpumask_var(&cpus, GFP_KERNEL))
> +		return -ENOMEM;
> +
> +	rcu_read_lock();
> +	for_each_numa_hop_mask(next, node) {
> +		weight = cpumask_weight_andnot(next, prev);
> +		while (weight > 0) {
> +			cpumask_andnot(cpus, next, prev);
> +			for_each_cpu(cpu, cpus) {
> +				cpumask_andnot(cpus, cpus, topology_sibling_cpumask(cpu));
> +				--weight;

[Severity: Low]
This is a pre-existing issue, but only the outer while loop checks
weight > 0. The inner for_each_cpu() loop can keep assigning IRQs after
the hop's budget is used up.

Take five online CPUs. The local node has sibling groups {0,1} and {2},
after an SMT sibling went offline, and the remote node has {4,5}. On the
dynamic path, num_msix_usable=5 and skip_first_cpu=true:

  local hop, weight = 3
    pass 1: skip {0,1}, assign {2}      weight = 1
    pass 2: assign {0,1}                weight = 0
            assign {2}                  weight = -1
  remote hop, weight = 2
            assign {4,5}

That puts 4 vectors, including the HWC one, on the 3 local CPUs and only
1 on the 2 remote CPUs. Should the inner loop also stop once weight
reaches zero?

[ ... ]

> +static int mana_gd_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
> +{

[ ... ]

> +	err = mana_rdma_probe(&gc->mana_ib);
> +	if (err)
> +		goto cleanup_mana;
> +
> +	/*
> +	 * If a hardware reset event has occurred over HWC during probe,
> +	 * rollback and perform hardware reset procedure.
> +	 */
> +	if (test_and_set_bit(GC_PROBE_SUCCEEDED, &gc->flags)) {
> +		err = -EPROTO;
> +		goto cleanup_mana_rdma;
> +	}
> +
> +	return 0;
> +
> +cleanup_mana_rdma:
> +	mana_rdma_remove(&gc->mana_ib);
> +cleanup_mana:
> +	mana_remove(&gc->mana, false);
> +cleanup_gd:
> +	mana_gd_cleanup(gc);
> +unmap_bar:
> +	xa_destroy(&gc->irq_contexts);
> +	pci_iounmap(pdev, bar0_va);
> +free_gc:
> +	pci_set_drvdata(pdev, NULL);
> +	vfree(gc);

[Severity: High]
This is a pre-existing issue, but can service work start while this probe
is still running?

In mana_gd_process_eqe(), the first GDMA_EQE_HWC_FPGA_RECONFIG or
GDMA_EQE_HWC_RESET_REQUEST event during probe sets GC_PROBE_SUCCEEDED.
A second event then finds the bit already set and queues service work:

mana_gd_process_eqe() {
    ...
	if (!test_and_set_bit(GC_PROBE_SUCCEEDED, &gc->flags)) {
		...
		break;
	}
	mana_schedule_serv_work(gc, type);
    ...
}

GC_IN_SERVICE is still clear at that point, so mana_serv_func() gets
queued.

A single HWC fault is enough on another path. mana_probe() schedules
gf_stats_work, and mana_gf_stats_work_handler() calls
mana_schedule_serv_work(gc, GDMA_EQE_HWC_RESET_REQUEST) on -ETIMEDOUT.
mana_rdma_probe() may still be running when that happens.

The worker's mana_serv_reset() finds gc through pci_get_drvdata(), which
probe sets early. It then runs mana_gd_suspend() while probe is still
initialising. If probe instead fails with -EPROTO here, or with
-ETIMEDOUT, the labels above run mana_gd_cleanup() and vfree(gc). The
worker is still using gc at that point and finishes with
clear_bit(GC_IN_SERVICE, &gc->flags).

Is anything supposed to synchronize this error path with a service work
item that has already been queued?

[ ... ]

> +void mana_pci_driver_unregister(void)
> +{
> +	struct mana_dev_recovery *dev;
> +	unsigned long flags;
> +
> +	disable_delayed_work_sync(&mana_dev_recovery_work.work);
> +
> +	spin_lock_irqsave(&mana_dev_recovery_work.lock, flags);
> +	while (!list_empty(&mana_dev_recovery_work.dev_list)) {
> +		dev = list_first_entry(&mana_dev_recovery_work.dev_list,
> +				       struct mana_dev_recovery, list);
> +		list_del(&dev->list);
> +		pci_dev_put(dev->pdev);
> +		kfree(dev);
> +	}
> +	spin_unlock_irqrestore(&mana_dev_recovery_work.lock, flags);
> +
> +	pci_unregister_driver(&mana_driver);
> +}

[Severity: Medium]
This is a pre-existing issue, but can a recovery entry leak here?

The delayed work is disabled and dev_list is drained before
pci_unregister_driver() is called. The driver is still registered in
between, so a probe can still run from a sysfs bind or an external
rescan or hotplug.

If that probe fails with -ETIMEDOUT or -EPROTO, mana_gd_probe() allocates
a mana_dev_recovery entry, takes pci_dev_get(pdev) and adds the entry to
dev_list. Its schedule_delayed_work() call is a no-op on the disabled
work, and nothing drains the list again.

Would that leak both the mana_dev_recovery allocation and the pci_dev
reference?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260924173054.589291-1-mawasthi%40linux.microsoft.com
