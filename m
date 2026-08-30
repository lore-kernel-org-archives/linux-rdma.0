Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D24831F9A4
	for <linux-rdma@vger.kernel.org>; Sun, 30 Aug 2026 21:15:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788124523; cv=none; b=NgjN0MsWEOARRBq8pa3IUKAivjdbIeXHUDXcEhCJvYQ0hwTmR9iCJ00ccu/OFNGaCm1xdHwMPkjm4RXDIp9cwnRhy0l+xSok1mhaZ2G977Pzm43Xcp2N/fHGsG3PgXYLJzu+OH4wVN/duD2g8RQBmpS+x5HZzsjot4EMuWpzIsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788124523; c=relaxed/simple;
	bh=FLwo1+FaXzNYG5Q+NjnzdZsc1BXESxavMoMgcG6tDSo=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=hlKSkuq1zdcR5dTRmUrqTqFLQ2oOvwoZVQjWuLLYygAWvkcehblcFDNPeBIDtMRXDuBtar6QKY6lKRE2w0a6XAypLgxRXIZ1peXPmoGZQPucNhvJvAY6FVEu3a49iL1guPdFL4gGhTsZXyYcGeGCHIv/asH24y7KU4IRPEVSipc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=grimberg.me; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=grimberg.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4956869750eso17702755e9.2
        for <linux-rdma@vger.kernel.org>; Sun, 30 Aug 2026 14:15:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788124519; x=1788729319;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=WZDd3fKvSvDiMXNU50jYFnGaYMDc3Gcyf1+x2PhHemA=;
        b=bVEWxZe2Od2SCHNw/ETMPmQmUBeb+5FXYjCcG6NoZ99TIJS7RjOK9BtCwApJWEAuWt
         vX8rNT3kz/tNgg2q21CBMmSv1ar1sQniguHkDmmwTlm42e77x4bekVbCT2SZCwU4Ots2
         U1Mb9p6Y+PnkaP6LA4j+S/KcXSMdntRiF9YjF+tm2locu5HFzxKvsKpfbLGZmOP5B5bD
         AuGcEYw1/329aSlasM4k2Uh/wylBPkalnzeozRNhOE+X0WCEmHEzuo5DOzy7nMgkCxfp
         Z3O/iO4jG+K3SwUzqjtsUAsOBh9z2qHyXaW698KaP6J8kBs/btOBmIW6AEHJjCqwK7Mf
         zRkA==
X-Forwarded-Encrypted: i=1; AHgh+RoCI9GA8+aLZegUKTEZt+LXNx85cZvEJNryNNs3mjWmDbgeddAY0MXD2vzyUz1v8WiKJK1GEl7S4BJv@vger.kernel.org
X-Gm-Message-State: AFuF++mAPD+wnXLcqOSd1kVQYhP/V/Uxp+mO8qd091HFBbOy6UyihHyJ
	SJO7vmJErKaPeDMZZJjGIWglEk30NX+1NQWXsjKsFvzmbscafDiZGwSB
X-Gm-Gg: AR+sD13se7rNe+80lVuYsaXiUbPYfyZV8eT/dn77SLG2qWwOUPxUilGdb/3r5eGLFM3
	Xshu3/L46ItxAkgBpiOrB0UGPsmOWL/tCzidIGynAgeqH0WaHd4G9E5NkfWg3NG1k5DM6K1qOVe
	vDjqYQ7cH+jhq7lGXPrhAZpSaSjexsDWMVVN3RZJ4scvz1Yp1bnxe7hLXhZyj0G1Kd8ez+PO7VA
	fiMqq8ijSSXhWyFZcMT4h18dXwpp4pCmdx7BjKZE9oLu0nyzJM99khM6tiJEHZh4pLP8sHmRaeB
	ACLRxT37t5fEgDENmkbL0FpRdX6SGbQZw3tbSTwchKAwJkMwRbVSnRzmVWCyp5qw6WApYjyupad
	5gJOIsdy5UEnsU5mxX6sbLUroH4zglvY04BqyTV0zaUJOYMGy0Fae48fXbkrrouY8cHl5YfvEav
	A6V29UdPeXzNAiMQ2KGUtOOh/7OLJWUaiJbVghqxxHyGQz2/zDVAO1iyd5Nd6RN36dh03dGrw50
	snF4RsYOrrm0j8rLXDi6bPqyEAgfNUU
X-Received: by 2002:a05:600c:c178:b0:499:872b:abd4 with SMTP id 5b1f17b1804b1-49b91c21b86mr290614645e9.6.1788124519135;
        Sun, 30 Aug 2026 14:15:19 -0700 (PDT)
Received: from [10.100.102.74] (89-138-77-243.bb.netvision.net.il. [89.138.77.243])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49b94dcaf61sm217332485e9.4.2026.08.30.14.15.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 30 Aug 2026 14:15:18 -0700 (PDT)
Message-ID: <1ad637b8-3727-4d60-9086-b213e61ae872@grimberg.me>
Date: Mon, 31 Aug 2026 00:15:17 +0300
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] nvme-rdma: fix ib_device removal race that hangs PCI
 unbind
From: Sagi Grimberg <sagi@grimberg.me>
To: Casey Chen <cachen@purestorage.com>, linux-nvme@lists.infradead.org
Cc: leon@kernel.org, kbusch@kernel.org, hch@lst.de, axboe@kernel.dk,
 linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260806211822.317074-1-cachen@purestorage.com>
 <20260828232436.270184-1-cachen@purestorage.com>
 <0d9ea3ed-b164-4f99-8484-87041ddffaa6@grimberg.me>
Content-Language: en-US
In-Reply-To: <0d9ea3ed-b164-4f99-8484-87041ddffaa6@grimberg.me>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 31/08/2026 0:10, Sagi Grimberg wrote:
>
>
> On 29/08/2026 2:24, Casey Chen wrote:
>> nvme_rdma_remove_one() samples nvme_rdma_ctrl_list once, then blocks in
>> flush_workqueue(nvme_delete_wq). A connect can publish a controller on
>> the same ib_device during that window: nvme_rdma_find_get_device()
>> matches on node GUID in nvme_rdma's private device_list and never
>> consults ib_core unregistration state. Such a controller is never
>> deleted, so its rdma_cm_ids keep a reference on the cma_device.
>>
>> ib_clients are removed LIFO, so nvme_rdma_remove_one() runs before
>> cma_remove_one(), which then waits for that reference forever. Removing
>> the RDMA interface underneath live NVMe-oF connections:
>>
>>    echo 1 | sudo tee /sys/bus/pci/devices/0000:2a:00.1/remove
>>
>> wedges the unbind permanently:
>>
>>    INFO: task tee:164872 blocked for more than 200 seconds.
>>    task:tee             state:D stack:0     pid:164872 ppid:164870 
>> flags:0x00004002
>>    Call Trace:
>>     <TASK>
>>     __schedule+0x4b4/0xf90
>>     schedule+0x5a/0xc0
>>     schedule_timeout+0x105/0x110
>>     ? cma_process_remove+0x1f9/0x240 [rdma_cm]
>>     __wait_for_common+0xc7/0x1f0
>>     ? usleep_range_state+0xb0/0xb0
>>     cma_remove_one+0x50/0xb0 [rdma_cm]
>>     remove_client_context+0x88/0xc0 [ib_core]
>>     disable_device+0x8a/0x160 [ib_core]
>>     __ib_unregister_device+0x42/0xa0 [ib_core]
>>     ib_unregister_device+0x22/0x30 [ib_core]
>>     mlx5r_remove+0x39/0x60 [mlx5_ib]
>>     auxiliary_bus_remove+0x18/0x30
>>     device_release_driver_internal+0x18f/0x1f0
>>     bus_remove_device+0xbc/0x120
>>     device_del+0x154/0x3d0
>>     ? devl_param_driverinit_value_get+0x29/0x90
>>     mlx5_rescan_drivers_locked.part.0+0x78/0x1c0 [mlx5_core]
>>     mlx5_unregister_device+0x34/0x50 [mlx5_core]
>>     mlx5_uninit_one+0x45/0x110 [mlx5_core]
>>     remove_one+0x4e/0xc0 [mlx5_core]
>>     pci_device_remove+0x39/0xa0
>>     device_release_driver_internal+0x18f/0x1f0
>>     pci_stop_bus_device+0x68/0x90
>>     pci_stop_and_remove_bus_device_locked+0x28/0x40
>>     remove_store+0x75/0x90
>>     kernfs_fop_write_iter+0x147/0x1d0
>>     vfs_write+0x2af/0x410
>>     ksys_write+0x5f/0xe0
>>     do_syscall_64+0x35/0x80
>>     entry_SYSCALL_64_after_hwframe+0x4b/0xb5
>>     </TASK>
>>
>> Because the unbind stalls mid-teardown the netdev is never unregistered,
>> so userspace keeps reconnecting over the interface and loses the race
>> again.
>>
>> Close the window at both ends, each with state guarded by the lock that
>> already covers the list it belongs to:
>>
>>   - nvme_rdma_device gains ->dying, set and tested under
>>     device_list_mutex. nvme_rdma_find_get_device() refuses a device that
>>     is going away, so no new queues, PD or QP are created on it once
>>     nvme_rdma_remove_one() has started. A re-probed HCA with the same 
>> node
>>     GUID is a distinct ib_device and gets a fresh nvme_rdma_device.
>>
>>   - nvme_rdma_remove_one() records the ib_device on 
>> nvme_rdma_removing_list
>>     in the same nvme_rdma_ctrl_mutex section that walks
>>     nvme_rdma_ctrl_list, and nvme_rdma_create_ctrl() tests that list 
>> under
>>     the same mutex immediately before publishing. A connect that took 
>> the
>>     mutex first is on the list and is deleted by the walk; one that 
>> takes
>>     it afterwards sees the entry and deletes its own controller. No
>>     controller can be added behind the walk, so a single sweep suffices.
>>
>> The controller is fully live at the point the connect is refused, so it
>> is torn down with nvme_delete_ctrl_sync(). ->list is still empty there,
>> leaving opts to nvmf_create_ctrl(), and nvme_init_ctrl() left two
>> references while nvme_delete_ctrl_sync() consumes only the one that
>> nvme_uninit_ctrl() drops, so the other is put explicitly.
>>
>> Reproduced on a 6.6 based kernel by removing and rescanning the mlx5
>> interface carrying the NVMe-oF RDMA connections in a loop, with IO
>> running and a userspace daemon reconnecting the controllers throughout.
>> The hang is racy: most removals complete normally, and only one that
>> lands while a connect is in flight leaves the sysfs write stuck in D
>> state with the trace above. With this patch the loop ran clean: removals
>> complete and the controllers reconnect after the following PCI rescan.
>>
>> Fixes: e87a911fed07 ("nvme-rdma: use ib_client API to detect device 
>> removal")
>> Signed-off-by: Casey Chen <cachen@purestorage.com>
>> ---
>>
>> Changes since v1:
>> https://lore.kernel.org/all/20260806211822.317074-1-cachen@purestorage.com/ 
>>
>>
>>   - ->dying is no longer read under nvme_rdma_ctrl_mutex (Leon). It 
>> stays
>>     guarded by device_list_mutex and is only tested in
>>     nvme_rdma_find_get_device(), which already holds that mutex. The 
>> test at
>>     the publish point now uses a separate nvme_rdma_removing_list 
>> guarded by
>>     nvme_rdma_ctrl_mutex, so each piece of state is accessed only 
>> under the
>>     lock that declares it and the READ_ONCE()/WRITE_ONCE() pair is 
>> gone. The
>>     two mutexes are still never held at the same time.
>>   - Drop the code comments; the reasoning lives in the commit message 
>> (Sagi).
>>
>> Leon, on moving the dying device off device_list onto a local removal 
>> list
>> instead of keeping ->dying: that does remove the flag, but it also 
>> lets a
>> connect racing the removal allocate a fresh nvme_rdma_device and call
>> ib_alloc_pd() on the device being unregistered, since
>> nvme_rdma_find_get_device() would no longer see anything to refuse. That
>> exposure exists upstream today, so unlinking is not a regression, but
>> keeping ->dying closes it as well, which seemed worth the one bool 
>> now that
>> it is no longer read across locks. A local (on-stack) removal list also
>> needs care: nvme_rdma_free_dev() does list_del() whenever the last kref
>> drops, and a connect holding a reference can outlive 
>> nvme_rdma_remove_one(),
>> so the list head would have to be static rather than on the stack. 
>> Happy to
>> switch to unlinking if you prefer it.
>>
>> Sagi, on moving the test into nvme_rdma_setup_ctrl() before
>> nvme_start_ctrl(): that would let the existing destroy_io path do the
>> unwind, which is nicer, but I do not think it closes the race on its 
>> own.
>> setup_ctrl() returns before nvme_rdma_create_ctrl() takes
>> nvme_rdma_ctrl_mutex and calls list_add_tail(), so a removal landing 
>> in that
>> gap still walks nvme_rdma_ctrl_list before the controller is 
>> published. The
>> test has to be atomic with the publish, which is why it stayed under the
>> mutex. Happy to be told I am missing something.
>>
>> One window is knowingly left open. Once nvme_rdma_remove_one() has 
>> returned,
>> the removal entry is gone and the nvme_rdma_device it marked has usually
>> been freed by the last nvme_rdma_dev_put(), taking ->dying with it. A
>> connect arriving between that point and cma_remove_one() unlinking the
>> cma_device allocates a fresh nvme_rdma_device and can still publish a
>> controller that nothing will delete. ib_clients are removed LIFO, so 
>> that
>> gap spans every remaining client's remove callback. It exists 
>> upstream today
>> and is strictly narrower with this patch, so I did not try to cover 
>> it here.
>> Closing it needs a test keyed on ib_core state rather than 
>> nvme_rdma's, for
>> example an ->add callback storing a token so that
>> ib_get_client_data(cm_id->device, &nvme_rdma_ib_client) == NULL 
>> identifies
>> "our remove callback has already returned". That reads client_data 
>> outside
>> what its kernel-doc permits, so it seemed better kept as a separate 
>> patch.
>>   drivers/nvme/host/core.c |  1 +
>>   drivers/nvme/host/rdma.c | 41 ++++++++++++++++++++++++++++++++++++++++
>>   2 files changed, 42 insertions(+)
>>
>> diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
>> index 758245c799a1..bede16fe1ff5 100644
>> --- a/drivers/nvme/host/core.c
>> +++ b/drivers/nvme/host/core.c
>> @@ -282,6 +282,7 @@ void nvme_delete_ctrl_sync(struct nvme_ctrl *ctrl)
>>           nvme_do_delete_ctrl(ctrl);
>>       nvme_put_ctrl(ctrl);
>>   }
>> +EXPORT_SYMBOL_GPL(nvme_delete_ctrl_sync);
>>     static blk_status_t nvme_error_status(u16 status)
>>   {
>> diff --git a/drivers/nvme/host/rdma.c b/drivers/nvme/host/rdma.c
>> index 29ecbe71bb2e..63453d902619 100644
>> --- a/drivers/nvme/host/rdma.c
>> +++ b/drivers/nvme/host/rdma.c
>> @@ -45,6 +45,24 @@ static LIST_HEAD_GUARDED(device_list, 
>> device_list_mutex);
>>     static DEFINE_MUTEX(nvme_rdma_ctrl_mutex);
>>   static LIST_HEAD_GUARDED(nvme_rdma_ctrl_list, nvme_rdma_ctrl_mutex);
>> +static LIST_HEAD_GUARDED(nvme_rdma_removing_list, 
>> nvme_rdma_ctrl_mutex);
>> +
>> +struct nvme_rdma_removing_device {
>> +    struct list_head    entry
>> +        __guarded_by(&nvme_rdma_ctrl_mutex);
>> +    struct ib_device    *dev;
>> +};
>
> I don't understand why this is needed.
>
>> +
>> +static bool nvme_rdma_device_removing(struct ib_device *ib_device)
>> +    __must_hold(&nvme_rdma_ctrl_mutex)
>> +{
>> +    struct nvme_rdma_removing_device *removing;
>> +
>> +    list_for_each_entry(removing, &nvme_rdma_removing_list, entry)
>> +        if (removing->dev == ib_device)
>> +            return true;
>> +    return false;
>> +}
>>     struct nvme_rdma_device {
>>       struct ib_device    *dev;
>> @@ -53,6 +71,8 @@ struct nvme_rdma_device {
>>       struct list_head    entry
>>           __guarded_by(&device_list_mutex);
>>       unsigned int        num_inline_segments;
>> +    bool            dying
>> +        __guarded_by(&device_list_mutex);

This should probably be a flag.

>>   };
>>     struct nvme_rdma_qe {
>> @@ -378,6 +398,11 @@ nvme_rdma_find_get_device(struct rdma_cm_id *cm_id)
>>         mutex_lock(&device_list_mutex);
>>       list_for_each_entry(ndev, &device_list, entry) {
>> +        if (ndev->dying) {
>> +            if (ndev->dev == cm_id->device)
>> +                goto out_err;
>> +            continue;
>> +        }
>>           if (ndev->dev->node_guid == cm_id->device->node_guid &&
>>               nvme_rdma_dev_get(ndev))
>>               goto out_unlock;
>> @@ -2380,6 +2405,15 @@ static struct nvme_ctrl 
>> *nvme_rdma_create_ctrl(struct device *dev,
>>           nvmf_ctrl_subsysnqn(&ctrl->ctrl), &ctrl->addr, 
>> opts->host->nqn);
>>         mutex_lock(&nvme_rdma_ctrl_mutex);
>> +    if (nvme_rdma_device_removing(ctrl->device->dev)) {
>> +        mutex_unlock(&nvme_rdma_ctrl_mutex);
>> +        dev_info(ctrl->ctrl.device,
>> +             "hca %s is being removed, aborting connect\n",
>> +             dev_name(ctrl->device->dev->dma_device));
>> +        nvme_delete_ctrl_sync(&ctrl->ctrl);
>> +        nvme_put_ctrl(&ctrl->ctrl);
>> +        return ERR_PTR(-ECONNREFUSED);
>> +    }
>
> Why not instead of this, simply do in nvme_rdma_setup_ctrl:

diff --git a/drivers/nvme/host/rdma.c b/drivers/nvme/host/rdma.c
index b606565c2d85..58dedb57214c 100644
--- a/drivers/nvme/host/rdma.c
+++ b/drivers/nvme/host/rdma.c
@@ -1108,6 +1108,11 @@ static int nvme_rdma_setup_ctrl(struct 
nvme_rdma_ctrl *ctrl, bool new)
                 goto destroy_io;
         }

+       if (nvme_rdma_device_dying(ctrl->device->dev)) {
+               nvme_change_ctrl_state(&ctrl->ctrl, NVME_CTRL_DELETING);
+               goto destroy_io;
+       }
+
         nvme_start_ctrl(&ctrl->ctrl);
         return 0;

>
>>       list_add_tail(&ctrl->list, &nvme_rdma_ctrl_list);
>>       mutex_unlock(&nvme_rdma_ctrl_mutex);
>>   @@ -2407,6 +2441,7 @@ static struct nvmf_transport_ops 
>> nvme_rdma_transport = {
>>     static void nvme_rdma_remove_one(struct ib_device *ib_device, 
>> void *client_data)
>>   {
>> +    struct nvme_rdma_removing_device removing = { .dev = ib_device };
>>       struct nvme_rdma_ctrl *ctrl;
>>       struct nvme_rdma_device *ndev;
>>       bool found = false;
>> @@ -2414,6 +2449,7 @@ static void nvme_rdma_remove_one(struct 
>> ib_device *ib_device, void *client_data)
>>       mutex_lock(&device_list_mutex);
>>       list_for_each_entry(ndev, &device_list, entry) {
>>           if (ndev->dev == ib_device) {
>> +            ndev->dying = true;
>>               found = true;
>>               break;
>>           }

I'm wandering why not remove it from the list here?

I cannot see why this additional list with a dedicated struct is needed?

>> @@ -2425,6 +2461,7 @@ static void nvme_rdma_remove_one(struct 
>> ib_device *ib_device, void *client_data)
>>         /* Delete all controllers using this device */
>>       mutex_lock(&nvme_rdma_ctrl_mutex);
>> +    list_add(&removing.entry, &nvme_rdma_removing_list);
>>       list_for_each_entry(ctrl, &nvme_rdma_ctrl_list, list) {
>>           if (ctrl->device->dev != ib_device)
>>               continue;
>> @@ -2433,6 +2470,10 @@ static void nvme_rdma_remove_one(struct 
>> ib_device *ib_device, void *client_data)
>>       mutex_unlock(&nvme_rdma_ctrl_mutex);
>>         flush_workqueue(nvme_delete_wq);
>> +
>> +    mutex_lock(&nvme_rdma_ctrl_mutex);
>> +    list_del(&removing.entry);
>> +    mutex_unlock(&nvme_rdma_ctrl_mutex);
>>   }
>>     static struct ib_client nvme_rdma_ib_client = {
>>
>> base-commit: 9eabc91952f9821824ca0288a76b3aba57961c6b
>

