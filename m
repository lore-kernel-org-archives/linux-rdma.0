Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B87233508E;
	Thu, 13 Aug 2026 10:08:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786615682; cv=none; b=UXWsq+Q6vsbuT3rizEuunbvUFxvpeXQ2Wq85lqZfYYn6hBwuTac6EGGQY90aV0+3ygqXGj36X4lBbfe7iuDzXNSWfjZP5CXjXwuKcXL8Oy/8aY/4hZu7rXpZrKD75jOU5lWkHZdDczRtaMoi7RQOGxC6LoOSsDLOBC/f8WluObI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786615682; c=relaxed/simple;
	bh=ejBNkzzBFdzAKxY+9jO2O9xZ/oWUnSLl29/ztGP+VNA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s/7xuHmHYEmmcDQlWuh6+JQnua+6G+RdvKRg6J6Xp6YqjmgFxvoy251yMxl8x9p2LFWMcNcsm0bNmw+ygcQNoUe1TKUIpV85pLC7BofS2OLaXk/3Hlio5DSP69UVXGzw9WUXieU2IZLhUBgNH72WSe5tFIYeFCIVj7/gVB0HBTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=E0KcB2z+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="E0KcB2z+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA39B1F000E9;
	Thu, 13 Aug 2026 10:07:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786615681;
	bh=gnXqlixQHylh3L5CjO1pDDvJipuJC+KiyCtJ020LaBI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=E0KcB2z+/WRc2Lhls1F1Vl+JeDNo+jJDfimdiVK/eMqHYl63wihH9mS16+4QjPWra
	 XhcGQzYH1ZpLYvSEtPf7tlRz5F3tXMbLs3w6DwnLdQIiEpfm9MyXFFIqMY13jBx9pD
	 220z1VwdjMrPTxuR6Pbi3ZXW3OI6WDcD4zUIO4B+XwdyIBmnO627jCXbuZmAo60Yrz
	 xApWdEDBmRXTvcUYMm4N+kRYuMyURl6ZyjhcJl+z4E3Mp+JXxP/lho2Ujdvzkg9rM2
	 pGDFz7NjDaBqOy1rvZmEN5q4tbhX9k9mKiUn+ge6e2ZOfuYRHcScjnjhzSe4KgdzFr
	 qYP6xYLIzcXlA==
Date: Thu, 13 Aug 2026 13:07:53 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Casey Chen <cachen@purestorage.com>
Cc: linux-nvme@lists.infradead.org, kbusch@kernel.org, hch@lst.de,
	sagi@grimberg.me, axboe@kernel.dk, linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] nvme-rdma: fix ib_device removal race that hangs PCI
 unbind
Message-ID: <20260813100753.GA79153@unreal>
References: <20260806211822.317074-1-cachen@purestorage.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260806211822.317074-1-cachen@purestorage.com>

On Thu, Aug 06, 2026 at 03:18:22PM -0600, Casey Chen wrote:
> nvme_rdma_remove_one() samples nvme_rdma_ctrl_list once, then blocks in
> flush_workqueue(nvme_delete_wq). A connect can publish a controller on
> the same ib_device during that window: nvme_rdma_find_get_device()
> matches on node GUID in nvme_rdma's private device_list and never
> consults ib_core unregistration state. Such a controller is never
> deleted, so its rdma_cm_ids keep a reference on the cma_device.
> 
> ib_clients are removed LIFO, so nvme_rdma_remove_one() runs before
> cma_remove_one(), which then waits for that reference forever. Removing
> the RDMA interface underneath live NVMe-oF connections:
> 
>   echo 1 | sudo tee /sys/bus/pci/devices/0000:2a:00.1/remove
> 
> wedges the unbind permanently:
> 
>   INFO: task tee:164872 blocked for more than 200 seconds.
>   task:tee             state:D stack:0     pid:164872 ppid:164870 flags:0x00004002
>   Call Trace:
>    <TASK>
>    __schedule+0x4b4/0xf90
>    schedule+0x5a/0xc0
>    schedule_timeout+0x105/0x110
>    ? cma_process_remove+0x1f9/0x240 [rdma_cm]
>    __wait_for_common+0xc7/0x1f0
>    ? usleep_range_state+0xb0/0xb0
>    cma_remove_one+0x50/0xb0 [rdma_cm]
>    remove_client_context+0x88/0xc0 [ib_core]
>    disable_device+0x8a/0x160 [ib_core]
>    __ib_unregister_device+0x42/0xa0 [ib_core]
>    ib_unregister_device+0x22/0x30 [ib_core]
>    mlx5r_remove+0x39/0x60 [mlx5_ib]
>    auxiliary_bus_remove+0x18/0x30
>    device_release_driver_internal+0x18f/0x1f0
>    bus_remove_device+0xbc/0x120
>    device_del+0x154/0x3d0
>    ? devl_param_driverinit_value_get+0x29/0x90
>    mlx5_rescan_drivers_locked.part.0+0x78/0x1c0 [mlx5_core]
>    mlx5_unregister_device+0x34/0x50 [mlx5_core]
>    mlx5_uninit_one+0x45/0x110 [mlx5_core]
>    remove_one+0x4e/0xc0 [mlx5_core]
>    pci_device_remove+0x39/0xa0
>    device_release_driver_internal+0x18f/0x1f0
>    pci_stop_bus_device+0x68/0x90
>    pci_stop_and_remove_bus_device_locked+0x28/0x40
>    remove_store+0x75/0x90
>    kernfs_fop_write_iter+0x147/0x1d0
>    vfs_write+0x2af/0x410
>    ksys_write+0x5f/0xe0
>    do_syscall_64+0x35/0x80
>    entry_SYSCALL_64_after_hwframe+0x4b/0xb5
>    </TASK>
> 
> Because the unbind stalls mid-teardown the netdev is never unregistered,
> so userspace keeps reconnecting over the interface and loses the race
> again.
> 
> Mark the nvme_rdma_device dying before sampling nvme_rdma_ctrl_list and
> test it in two places:
> 
>  - nvme_rdma_find_get_device() refuses a dying device, so later connects
>    fail early. A re-probed HCA (same GUID, new ib_device) gets a fresh
>    nvme_rdma_device.
> 
>  - nvme_rdma_create_ctrl() re-tests it under nvme_rdma_ctrl_mutex before
>    publishing and deletes the controller instead if set, covering a
>    connect that obtained the device before the flag was stored.
> 
> ->dying is stored before nvme_rdma_remove_one() takes
> nvme_rdma_ctrl_mutex and the publisher tests it under that same mutex,
> so a publisher either lands on the list before the walk or observes
> ->dying. One sweep remains sufficient.
> 
> Reproduced on a 6.6 based kernel by removing and rescanning the mlx5
> interface carrying the NVMe-oF RDMA connections in a loop, with IO
> running and a userspace daemon reconnecting the controllers throughout.
> The hang is racy: most removals complete normally, and only one that
> lands while a connect is in flight leaves the sysfs write stuck in D
> state with the trace above. With this patch the loop ran clean: removals
> complete and the controllers reconnect after the following PCI rescan.
> 
> Fixes: e87a911fed07 ("nvme-rdma: use ib_client API to detect device removal")
> Signed-off-by: Casey Chen <cachen@purestorage.com>
> ---
>  drivers/nvme/host/core.c |  1 +
>  drivers/nvme/host/rdma.c | 49 +++++++++++++++++++++++++++++++++++++++-
>  2 files changed, 49 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
> index cb93ada4376a..374968145f56 100644
> --- a/drivers/nvme/host/core.c
> +++ b/drivers/nvme/host/core.c
> @@ -277,6 +277,7 @@ void nvme_delete_ctrl_sync(struct nvme_ctrl *ctrl)
>  		nvme_do_delete_ctrl(ctrl);
>  	nvme_put_ctrl(ctrl);
>  }
> +EXPORT_SYMBOL_GPL(nvme_delete_ctrl_sync);
>  
>  static blk_status_t nvme_error_status(u16 status)
>  {
> diff --git a/drivers/nvme/host/rdma.c b/drivers/nvme/host/rdma.c
> index 01743ae01466..b3ea54280e50 100644
> --- a/drivers/nvme/host/rdma.c
> +++ b/drivers/nvme/host/rdma.c
> @@ -53,6 +53,8 @@ struct nvme_rdma_device {
>  	struct list_head	entry
>  		__guarded_by(&device_list_mutex);
>  	unsigned int		num_inline_segments;
> +	/* set under device_list_mutex when removal starts */
> +	bool			dying;
>  };
>  
>  struct nvme_rdma_qe {
> @@ -378,6 +380,18 @@ nvme_rdma_find_get_device(struct rdma_cm_id *cm_id)
>  
>  	mutex_lock(&device_list_mutex);
>  	list_for_each_entry(ndev, &device_list, entry) {
> +		if (READ_ONCE(ndev->dying)) {
> +			/*
> +			 * Removal has already sampled nvme_rdma_ctrl_list, so
> +			 * a controller created here would never be deleted.
> +			 * A re-probed device with the same node GUID is a
> +			 * distinct ib_device and gets a fresh
> +			 * nvme_rdma_device below.
> +			 */
> +			if (ndev->dev == cm_id->device)
> +				goto out_err;
> +			continue;
> +		}
>  		if (ndev->dev->node_guid == cm_id->device->node_guid &&
>  		    nvme_rdma_dev_get(ndev))
>  			goto out_unlock;
> @@ -2378,6 +2392,24 @@ static struct nvme_ctrl *nvme_rdma_create_ctrl(struct device *dev,
>  		nvmf_ctrl_subsysnqn(&ctrl->ctrl), &ctrl->addr, opts->host->nqn);
>  
>  	mutex_lock(&nvme_rdma_ctrl_mutex);
> +	if (READ_ONCE(ctrl->device->dying)) {

"The write to ->dying is protected by &device_list_mutex, whereas
this path relies on &nvme_rdma_ctrl_mutex.

I did not look closely enough to suggest a complete fix for this
function, but for the removal path it would be better to remove the
dying IB device from the device list and move it to a local removal
list. That would eliminate the need for ->dying, at least in this
path.

Thanks
