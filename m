Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0470C5A79B
	for <linux-rdma@vger.kernel.org>; Sun, 23 Aug 2026 00:37:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787445432; cv=none; b=sKMa+v6qUbeK1Y0YuWsieu0rm//Lx7dTnSR975TZ2lHRkS11la7GsGRFFdgHVgPJd83dIVH24mZK14rNYx9RvvEFeoE+bVWRzqQ285bfcZokbvgLT00dptmeDiaXPJSpIyXEWO166n559K6ysHDHHt3l5EE9lx8Cuoh21y2DLP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787445432; c=relaxed/simple;
	bh=xI4TUiXci0IIcqaXWZV2801XoLNnBgNbbnC00Lj7pmY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BnK+obLZzcGuKQbAKsdzDPhc4Zi63x0IhKX/W6lPWOkQx4yDwVYE/Uxv1PfJf4UDwZ0BLckCeWRfoFMUWieTGxMutWk3qCfhcCwaTWg3VK7rUEkmhhbXj51lSnqZfjLUYl7GriD98RyLSJ0B/K4Rp4F3Pd/NjK8/D8BPS5uT/ZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=grimberg.me; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=grimberg.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-6a10d02ff43so4707052a12.0
        for <linux-rdma@vger.kernel.org>; Sat, 22 Aug 2026 17:37:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787445429; x=1788050229;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4Sumuq7XF9L8e+DVLhwpykgWETOyOmaRyOkiLPlP+mQ=;
        b=MUCQDa8FH3D9zEeAnrHCTCoZktP2dbpZPmC7FpbR28OR/rvn2gKfo4hJxuiVXPZVDa
         RoMyWfSSoGHstOs/xm4B5omYm/7mbjnQXEw5ERo+IU4Ef6KYc3iij/ldIRUWlUCnzzN1
         af6B3fJuCu5w7F6Uwsiw6rgvww9NRjwssORfvaL+joXlxWeDZcgaec6My9stXLUX7Kqv
         VeR1CxE7TEqsfqUK4Dc68ySfTfQSbRRe/m0G0jivQxbVa026ZLVrv6Tgrf+pTZtEJYdc
         7H86KyCPwBhdlqMeNKzUEqArbpiNJTZtFgg3L+zjiSS7hnhg3a8M35vVuTfRK+ZoBbJW
         rGGg==
X-Forwarded-Encrypted: i=1; AHgh+RoeilUf2MQs1+kRhz+4lm3iKMX89TMHS/P1gTIRUz1wxNRGSnHc3+t9b5GMRPQrOVQ4ymNTY1Ukvsms@vger.kernel.org
X-Gm-Message-State: AFuF++mO7/COohuBwBrvOO5W6ngIuas44zy218GiTeRkxD7mA/zjat8T
	OP9wqr8rk/kH+3e0KS0nWgL429+zGjAEd7ek7/yD/R/qfTBqsXQWnRvc
X-Gm-Gg: AR+sD114pBI2B+zblM06Ov1NMbvVUKp3vqNIwDBCywYjjF/cQnB1lwbdHcdWqlQeNGB
	AaoWicSTkxZ0odLqqQiXDrEL2PeUGqBSlv+O954nM8fQ4jWqIdnHtxioIYLYRxEQhI6euAawQOX
	qOvGmjV+Guc0HvtY+/BoiTQgFjzrmNz9MZqbzyHRD7SJpfjr6KczALjiT22TAg2c+V1MR7K4w05
	7ZAmBbr8Fjz4XAUP2FgUVykunMMJlR5wAfdmdBPx1gumL/TMAGdg8YYo/kCMllEfwP1LL8tqsKk
	JRay9i1EHLS3DPfNJI7ovDZLb3/t4tIc+ze1v3o92vZMlHbhQhTVzgUdigDAA63O5O3PSe+m1Xk
	3gzgMVMKhIwdfvViQyPkOqacKpWQ9kBhoV3ljqsk0gSGvqvXKxLWxS/iCFfZDI8BpV9Efwxf/g+
	OXuKPnqTOrQIwT6xdpdCQUwhmneOl6ERHguFT3vm+XYi6gGyJ9hYRdNsdkIOZVdVRFX9SKD55mL
	HsVOlS6QZvvDB2dA297Wdc=
X-Received: by 2002:a05:6402:3547:b0:6a3:6b8f:94ce with SMTP id 4fb4d7f45d1cf-6a42f13c1a1mr17933590a12.3.1787445428993;
        Sat, 22 Aug 2026 17:37:08 -0700 (PDT)
Received: from [10.100.102.74] (89-138-65-240.bb.netvision.net.il. [89.138.65.240])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6a59e1ccf69sm460504a12.25.2026.08.22.17.37.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 22 Aug 2026 17:37:08 -0700 (PDT)
Message-ID: <23bfe700-6692-4785-9de4-b46845b9e271@grimberg.me>
Date: Sun, 23 Aug 2026 03:37:07 +0300
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] nvme-rdma: fix ib_device removal race that hangs PCI
 unbind
To: Casey Chen <cachen@purestorage.com>, linux-nvme@lists.infradead.org
Cc: kbusch@kernel.org, hch@lst.de, axboe@kernel.dk,
 linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260806211822.317074-1-cachen@purestorage.com>
Content-Language: en-US
From: Sagi Grimberg <sagi@grimberg.me>
In-Reply-To: <20260806211822.317074-1-cachen@purestorage.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 07/08/2026 0:18, Casey Chen wrote:
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
>    echo 1 | sudo tee /sys/bus/pci/devices/0000:2a:00.1/remove
>
> wedges the unbind permanently:
>
>    INFO: task tee:164872 blocked for more than 200 seconds.
>    task:tee             state:D stack:0     pid:164872 ppid:164870 flags:0x00004002
>    Call Trace:
>     <TASK>
>     __schedule+0x4b4/0xf90
>     schedule+0x5a/0xc0
>     schedule_timeout+0x105/0x110
>     ? cma_process_remove+0x1f9/0x240 [rdma_cm]
>     __wait_for_common+0xc7/0x1f0
>     ? usleep_range_state+0xb0/0xb0
>     cma_remove_one+0x50/0xb0 [rdma_cm]
>     remove_client_context+0x88/0xc0 [ib_core]
>     disable_device+0x8a/0x160 [ib_core]
>     __ib_unregister_device+0x42/0xa0 [ib_core]
>     ib_unregister_device+0x22/0x30 [ib_core]
>     mlx5r_remove+0x39/0x60 [mlx5_ib]
>     auxiliary_bus_remove+0x18/0x30
>     device_release_driver_internal+0x18f/0x1f0
>     bus_remove_device+0xbc/0x120
>     device_del+0x154/0x3d0
>     ? devl_param_driverinit_value_get+0x29/0x90
>     mlx5_rescan_drivers_locked.part.0+0x78/0x1c0 [mlx5_core]
>     mlx5_unregister_device+0x34/0x50 [mlx5_core]
>     mlx5_uninit_one+0x45/0x110 [mlx5_core]
>     remove_one+0x4e/0xc0 [mlx5_core]
>     pci_device_remove+0x39/0xa0
>     device_release_driver_internal+0x18f/0x1f0
>     pci_stop_bus_device+0x68/0x90
>     pci_stop_and_remove_bus_device_locked+0x28/0x40
>     remove_store+0x75/0x90
>     kernfs_fop_write_iter+0x147/0x1d0
>     vfs_write+0x2af/0x410
>     ksys_write+0x5f/0xe0
>     do_syscall_64+0x35/0x80
>     entry_SYSCALL_64_after_hwframe+0x4b/0xb5
>     </TASK>
>
> Because the unbind stalls mid-teardown the netdev is never unregistered,
> so userspace keeps reconnecting over the interface and loses the race
> again.
>
> Mark the nvme_rdma_device dying before sampling nvme_rdma_ctrl_list and
> test it in two places:
>
>   - nvme_rdma_find_get_device() refuses a dying device, so later connects
>     fail early. A re-probed HCA (same GUID, new ib_device) gets a fresh
>     nvme_rdma_device.
>
>   - nvme_rdma_create_ctrl() re-tests it under nvme_rdma_ctrl_mutex before
>     publishing and deletes the controller instead if set, covering a
>     connect that obtained the device before the flag was stored.
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
>   drivers/nvme/host/core.c |  1 +
>   drivers/nvme/host/rdma.c | 49 +++++++++++++++++++++++++++++++++++++++-
>   2 files changed, 49 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
> index cb93ada4376a..374968145f56 100644
> --- a/drivers/nvme/host/core.c
> +++ b/drivers/nvme/host/core.c
> @@ -277,6 +277,7 @@ void nvme_delete_ctrl_sync(struct nvme_ctrl *ctrl)
>   		nvme_do_delete_ctrl(ctrl);
>   	nvme_put_ctrl(ctrl);
>   }
> +EXPORT_SYMBOL_GPL(nvme_delete_ctrl_sync);
>   
>   static blk_status_t nvme_error_status(u16 status)
>   {
> diff --git a/drivers/nvme/host/rdma.c b/drivers/nvme/host/rdma.c
> index 01743ae01466..b3ea54280e50 100644
> --- a/drivers/nvme/host/rdma.c
> +++ b/drivers/nvme/host/rdma.c
> @@ -53,6 +53,8 @@ struct nvme_rdma_device {
>   	struct list_head	entry
>   		__guarded_by(&device_list_mutex);
>   	unsigned int		num_inline_segments;
> +	/* set under device_list_mutex when removal starts */
> +	bool			dying;

No need for the comment IMO.

>   };
>   
>   struct nvme_rdma_qe {
> @@ -378,6 +380,18 @@ nvme_rdma_find_get_device(struct rdma_cm_id *cm_id)
>   
>   	mutex_lock(&device_list_mutex);
>   	list_for_each_entry(ndev, &device_list, entry) {
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

Again, code is self explanatory.

>   		if (ndev->dev->node_guid == cm_id->device->node_guid &&
>   		    nvme_rdma_dev_get(ndev))
>   			goto out_unlock;
> @@ -2378,6 +2392,24 @@ static struct nvme_ctrl *nvme_rdma_create_ctrl(struct device *dev,
>   		nvmf_ctrl_subsysnqn(&ctrl->ctrl), &ctrl->addr, opts->host->nqn);
>   
>   	mutex_lock(&nvme_rdma_ctrl_mutex);
> +	if (READ_ONCE(ctrl->device->dying)) {
> +		mutex_unlock(&nvme_rdma_ctrl_mutex);
> +		/*
> +		 * Removal already walked nvme_rdma_ctrl_list, so publishing
> +		 * now would leave this controller behind and stall
> +		 * cma_remove_one() forever. ->list is still empty, so
> +		 * nvme_rdma_free_ctrl() leaves opts for nvmf_create_ctrl().
> +		 * nvme_init_ctrl() left two references and
> +		 * nvme_delete_ctrl_sync() consumes only the one that
> +		 * nvme_uninit_ctrl() drops, so put the other here.
> +		 */
> +		dev_info(ctrl->ctrl.device,
> +			 "hca %s is being removed, aborting connect\n",
> +			 dev_name(ctrl->device->dev->dma_device));
> +		nvme_delete_ctrl_sync(&ctrl->ctrl);
> +		nvme_put_ctrl(&ctrl->ctrl);
> +		return ERR_PTR(-ECONNREFUSED);
> +	}

I think that this check can be called in nvme_rdma_setup_ctrl() before 
calling
nvme_start_ctrl() which already has an error path no?

Again, I don't think that the commends are helpful. You are checking 
"dying" and
failing if it is set, its kinda make sense. The explanations can stay in 
the commit msg.

>   	list_add_tail(&ctrl->list, &nvme_rdma_ctrl_list);
>   	mutex_unlock(&nvme_rdma_ctrl_mutex);
>   
> @@ -2409,9 +2441,16 @@ static void nvme_rdma_remove_one(struct ib_device *ib_device, void *client_data)
>   	struct nvme_rdma_device *ndev;
>   	bool found = false;
>   
> +	/*
> +	 * Stop handing this device out to new queues, and stop new controllers
> +	 * from being published on it, before sampling nvme_rdma_ctrl_list
> +	 * below. Pairs with the READ_ONCE() of ->dying in
> +	 * nvme_rdma_find_get_device() and nvme_rdma_create_ctrl().
> +	 */

Same comment for code comments.

>   	mutex_lock(&device_list_mutex);
>   	list_for_each_entry(ndev, &device_list, entry) {
>   		if (ndev->dev == ib_device) {
> +			WRITE_ONCE(ndev->dying, true);
>   			found = true;
>   			break;
>   		}
> @@ -2421,7 +2460,15 @@ static void nvme_rdma_remove_one(struct ib_device *ib_device, void *client_data)
>   	if (!found)
>   		return;
>   
> -	/* Delete all controllers using this device */
> +	/*
> +	 * Delete all controllers using this device. ->dying is stored before
> +	 * nvme_rdma_ctrl_mutex is acquired here, and nvme_rdma_create_ctrl()
> +	 * checks it while holding that same mutex, so the two orderings are
> +	 * exhaustive: a publisher that got the mutex first is on the list and
> +	 * is deleted below, and one that gets it afterwards observes ->dying
> +	 * and tears its controller down itself. No controller can be added
> +	 * behind this walk.
> +	 */

same comment.

>   	mutex_lock(&nvme_rdma_ctrl_mutex);
>   	list_for_each_entry(ctrl, &nvme_rdma_ctrl_list, list) {
>   		if (ctrl->device->dev != ib_device)
>
> base-commit: bf881dd20062db5e951a0d0703cb476df8c9fdee

