Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4233241D4F1
	for <linux-rdma@vger.kernel.org>; Thu,  6 Aug 2026 21:18:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786051141; cv=none; b=ZH0KHzQ46YDhjOYP8l3K+sq1K7SSliG1bsP0MWmRN9lkZgqW2xJi65yYlDn2nKLPTO2JkwZeJHsmF7AseXYvIntlZRgC4suP+n/3otZiSdoSn6Sp0edeXZzbJV1l0UmeYD/ukNcG63qHJbov5v7PWDizgpcZWpN/ZTKWfWI2U7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786051141; c=relaxed/simple;
	bh=ZqfALecxguBf5AvMMeJ84m0m1CSvaEMaSzywbObCj5U=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=hj34Jl40uZVh2DbgKcLcjYj56p8QF4lzDCKoYg6j/4VV740USN8FAYoITsmxoEgjXT/RgYZBowbYp6NvWMk2sE/HQ9Mvcb3GIfHyQ9CSGln2AnH+ndD/8Nt+hZtQQYQZzlOadIBMCunkynzNCqx/NBSJhFlRnRrE5cbHVG6gKNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com; spf=pass smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=fSCd4cyu; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="fSCd4cyu"
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-4706f016316so176041f8f.3
        for <linux-rdma@vger.kernel.org>; Thu, 06 Aug 2026 14:18:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1786051136; x=1786655936; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=MaxROpi6DTwUPsCaSniySMmojeCZ+8s8VtuCCe0FwZI=;
        b=fSCd4cyuh/6Xp5HAIRj1MeTWUVsKBpuIlqYynefgkq/ZNCCBIYWxrOWlueQzgnMTuV
         dNi41iHztr/ddPn5B0ctubjtW/zZElHR7VpUu8cZIUTEOcTBDb0seslGnRYcnffN/y00
         9N6o1MuEdTyriPouyEqFYCjmXAEkID2V7gWkuv20FdshUF0oEO9ZMuWCWmBXXuObREHO
         rfMeVpbHdJtJxZIfwbG66d5Wvc1hO6q7el3sCaia2SCYPR7wXZWwfrL6viJKcPHXhsJj
         Q+E+KUZxDt1ywTwSdziMzEW0FOh6m4bNkYQvxpG3JgwrEtTXZGtFlkZsgU10D//Cavzt
         N7fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786051136; x=1786655936;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=MaxROpi6DTwUPsCaSniySMmojeCZ+8s8VtuCCe0FwZI=;
        b=WP5IzRjf83g58TaA38JonJV19XKF+WsfwToXY6ohoYwYsC0xV2NBsPmsD56YSKIh8Y
         faAToxlnXluDXgEIWDJwFrLOGGvbhI/s9XsmrxR23ct5m3YoyXMfvdYwwmgmtJLylvl1
         XempqTaDaygLZKYpivJ0iPtnOnWgIpui2s9icUULwtGRLx+rVuK9iqzlDKeoOUNMiXpI
         QrqNRr+1OH9GPzKylXpjrMoFspcVrkLyVmUwoHshqUjLC1hL/JbIG655hRaKC/2zsDbP
         UXTGCkrZKChd0HCedoN9/inv6uT4F2OmEd1gKXn1PH/ELkwuIyUDx3JMGMWOY6GGWVNp
         wB2w==
X-Forwarded-Encrypted: i=1; AHgh+RqcTlILrSKk96/buBs6VvOIWkg4PYEPjdo9UtLV9cDrPvvhwEhjbxKlch6WkZQo6UWTwe8QFVjWl2nF@vger.kernel.org
X-Gm-Message-State: AOJu0YwKzu6shFOT8GtlLAWRkW7NZJaukXeN1dU5khQ0t/61ihINbH/d
	U2o+3W9Mz13ZKpZ17eIOKsc01TR7RmhHjrCF5DhopkkiMNq19nauQeIujegQGBqCR+w=
X-Gm-Gg: AR+sD10BMabiipmUuptAG0X/KSQO2nFciy5gZ3BQ+27jRorjSLEtZSuwEvMqVLcj4tD
	A6C4wbIRrKuSA9aB//9RcXAII/kMdSsJjZpmIuecM0cCmpG+DITdma05UAd+oe/mIu6XqNK3mal
	3D36WYJP0d6nNDFTEVY9ib2XXiL+PBSikJwcg+erXFLhGNw5/vWXwrqfTs5lTYkbTLh0wANO7rn
	Gxpnsf+hCgqGmf11UOG3k8pBAjLx+M34QW6XqHn389Ey3lc2RcPc7VS4yp8rONgELHdFsNVSf9c
	gDROAi2UT4PL5UZ/q8f6hbOcllvb3z7O3RCRgm12oHMhLt9HMxoklaRXmMz9qNsB5+GOi4AQaWi
	6FRggqDaW7PMGNX2jE+Rnb9CcZ5oY/JDRXpPgWVetNFbcNeYPiDKHH2EnyyXCVW8SVat6ShZ0b1
	CLfiANslCji8WRr5ANzYNACnQrCyacs5Gm9FxMtwTVcbrZsmEHFOx4IyyFtQkcQ7mQQdZjIqKom
	Y5ssBkKu6ugF+FX
X-Received: by 2002:a05:600c:4ecb:b0:499:59a1:96f7 with SMTP id 5b1f17b1804b1-49959a19770mr36229445e9.1.1786051136245;
        Thu, 06 Aug 2026 14:18:56 -0700 (PDT)
Received: from dev-cachen2.dev.purestorage.com ([208.88.159.128])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-4995c7a56c5sm8455405e9.3.2026.08.06.14.18.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2026 14:18:55 -0700 (PDT)
From: Casey Chen <cachen@purestorage.com>
To: linux-nvme@lists.infradead.org
Cc: kbusch@kernel.org,
	hch@lst.de,
	sagi@grimberg.me,
	axboe@kernel.dk,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] nvme-rdma: fix ib_device removal race that hangs PCI unbind
Date: Thu,  6 Aug 2026 15:18:22 -0600
Message-Id: <20260806211822.317074-1-cachen@purestorage.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

nvme_rdma_remove_one() samples nvme_rdma_ctrl_list once, then blocks in
flush_workqueue(nvme_delete_wq). A connect can publish a controller on
the same ib_device during that window: nvme_rdma_find_get_device()
matches on node GUID in nvme_rdma's private device_list and never
consults ib_core unregistration state. Such a controller is never
deleted, so its rdma_cm_ids keep a reference on the cma_device.

ib_clients are removed LIFO, so nvme_rdma_remove_one() runs before
cma_remove_one(), which then waits for that reference forever. Removing
the RDMA interface underneath live NVMe-oF connections:

  echo 1 | sudo tee /sys/bus/pci/devices/0000:2a:00.1/remove

wedges the unbind permanently:

  INFO: task tee:164872 blocked for more than 200 seconds.
  task:tee             state:D stack:0     pid:164872 ppid:164870 flags:0x00004002
  Call Trace:
   <TASK>
   __schedule+0x4b4/0xf90
   schedule+0x5a/0xc0
   schedule_timeout+0x105/0x110
   ? cma_process_remove+0x1f9/0x240 [rdma_cm]
   __wait_for_common+0xc7/0x1f0
   ? usleep_range_state+0xb0/0xb0
   cma_remove_one+0x50/0xb0 [rdma_cm]
   remove_client_context+0x88/0xc0 [ib_core]
   disable_device+0x8a/0x160 [ib_core]
   __ib_unregister_device+0x42/0xa0 [ib_core]
   ib_unregister_device+0x22/0x30 [ib_core]
   mlx5r_remove+0x39/0x60 [mlx5_ib]
   auxiliary_bus_remove+0x18/0x30
   device_release_driver_internal+0x18f/0x1f0
   bus_remove_device+0xbc/0x120
   device_del+0x154/0x3d0
   ? devl_param_driverinit_value_get+0x29/0x90
   mlx5_rescan_drivers_locked.part.0+0x78/0x1c0 [mlx5_core]
   mlx5_unregister_device+0x34/0x50 [mlx5_core]
   mlx5_uninit_one+0x45/0x110 [mlx5_core]
   remove_one+0x4e/0xc0 [mlx5_core]
   pci_device_remove+0x39/0xa0
   device_release_driver_internal+0x18f/0x1f0
   pci_stop_bus_device+0x68/0x90
   pci_stop_and_remove_bus_device_locked+0x28/0x40
   remove_store+0x75/0x90
   kernfs_fop_write_iter+0x147/0x1d0
   vfs_write+0x2af/0x410
   ksys_write+0x5f/0xe0
   do_syscall_64+0x35/0x80
   entry_SYSCALL_64_after_hwframe+0x4b/0xb5
   </TASK>

Because the unbind stalls mid-teardown the netdev is never unregistered,
so userspace keeps reconnecting over the interface and loses the race
again.

Mark the nvme_rdma_device dying before sampling nvme_rdma_ctrl_list and
test it in two places:

 - nvme_rdma_find_get_device() refuses a dying device, so later connects
   fail early. A re-probed HCA (same GUID, new ib_device) gets a fresh
   nvme_rdma_device.

 - nvme_rdma_create_ctrl() re-tests it under nvme_rdma_ctrl_mutex before
   publishing and deletes the controller instead if set, covering a
   connect that obtained the device before the flag was stored.

->dying is stored before nvme_rdma_remove_one() takes
nvme_rdma_ctrl_mutex and the publisher tests it under that same mutex,
so a publisher either lands on the list before the walk or observes
->dying. One sweep remains sufficient.

Reproduced on a 6.6 based kernel by removing and rescanning the mlx5
interface carrying the NVMe-oF RDMA connections in a loop, with IO
running and a userspace daemon reconnecting the controllers throughout.
The hang is racy: most removals complete normally, and only one that
lands while a connect is in flight leaves the sysfs write stuck in D
state with the trace above. With this patch the loop ran clean: removals
complete and the controllers reconnect after the following PCI rescan.

Fixes: e87a911fed07 ("nvme-rdma: use ib_client API to detect device removal")
Signed-off-by: Casey Chen <cachen@purestorage.com>
---
 drivers/nvme/host/core.c |  1 +
 drivers/nvme/host/rdma.c | 49 +++++++++++++++++++++++++++++++++++++++-
 2 files changed, 49 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index cb93ada4376a..374968145f56 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -277,6 +277,7 @@ void nvme_delete_ctrl_sync(struct nvme_ctrl *ctrl)
 		nvme_do_delete_ctrl(ctrl);
 	nvme_put_ctrl(ctrl);
 }
+EXPORT_SYMBOL_GPL(nvme_delete_ctrl_sync);
 
 static blk_status_t nvme_error_status(u16 status)
 {
diff --git a/drivers/nvme/host/rdma.c b/drivers/nvme/host/rdma.c
index 01743ae01466..b3ea54280e50 100644
--- a/drivers/nvme/host/rdma.c
+++ b/drivers/nvme/host/rdma.c
@@ -53,6 +53,8 @@ struct nvme_rdma_device {
 	struct list_head	entry
 		__guarded_by(&device_list_mutex);
 	unsigned int		num_inline_segments;
+	/* set under device_list_mutex when removal starts */
+	bool			dying;
 };
 
 struct nvme_rdma_qe {
@@ -378,6 +380,18 @@ nvme_rdma_find_get_device(struct rdma_cm_id *cm_id)
 
 	mutex_lock(&device_list_mutex);
 	list_for_each_entry(ndev, &device_list, entry) {
+		if (READ_ONCE(ndev->dying)) {
+			/*
+			 * Removal has already sampled nvme_rdma_ctrl_list, so
+			 * a controller created here would never be deleted.
+			 * A re-probed device with the same node GUID is a
+			 * distinct ib_device and gets a fresh
+			 * nvme_rdma_device below.
+			 */
+			if (ndev->dev == cm_id->device)
+				goto out_err;
+			continue;
+		}
 		if (ndev->dev->node_guid == cm_id->device->node_guid &&
 		    nvme_rdma_dev_get(ndev))
 			goto out_unlock;
@@ -2378,6 +2392,24 @@ static struct nvme_ctrl *nvme_rdma_create_ctrl(struct device *dev,
 		nvmf_ctrl_subsysnqn(&ctrl->ctrl), &ctrl->addr, opts->host->nqn);
 
 	mutex_lock(&nvme_rdma_ctrl_mutex);
+	if (READ_ONCE(ctrl->device->dying)) {
+		mutex_unlock(&nvme_rdma_ctrl_mutex);
+		/*
+		 * Removal already walked nvme_rdma_ctrl_list, so publishing
+		 * now would leave this controller behind and stall
+		 * cma_remove_one() forever. ->list is still empty, so
+		 * nvme_rdma_free_ctrl() leaves opts for nvmf_create_ctrl().
+		 * nvme_init_ctrl() left two references and
+		 * nvme_delete_ctrl_sync() consumes only the one that
+		 * nvme_uninit_ctrl() drops, so put the other here.
+		 */
+		dev_info(ctrl->ctrl.device,
+			 "hca %s is being removed, aborting connect\n",
+			 dev_name(ctrl->device->dev->dma_device));
+		nvme_delete_ctrl_sync(&ctrl->ctrl);
+		nvme_put_ctrl(&ctrl->ctrl);
+		return ERR_PTR(-ECONNREFUSED);
+	}
 	list_add_tail(&ctrl->list, &nvme_rdma_ctrl_list);
 	mutex_unlock(&nvme_rdma_ctrl_mutex);
 
@@ -2409,9 +2441,16 @@ static void nvme_rdma_remove_one(struct ib_device *ib_device, void *client_data)
 	struct nvme_rdma_device *ndev;
 	bool found = false;
 
+	/*
+	 * Stop handing this device out to new queues, and stop new controllers
+	 * from being published on it, before sampling nvme_rdma_ctrl_list
+	 * below. Pairs with the READ_ONCE() of ->dying in
+	 * nvme_rdma_find_get_device() and nvme_rdma_create_ctrl().
+	 */
 	mutex_lock(&device_list_mutex);
 	list_for_each_entry(ndev, &device_list, entry) {
 		if (ndev->dev == ib_device) {
+			WRITE_ONCE(ndev->dying, true);
 			found = true;
 			break;
 		}
@@ -2421,7 +2460,15 @@ static void nvme_rdma_remove_one(struct ib_device *ib_device, void *client_data)
 	if (!found)
 		return;
 
-	/* Delete all controllers using this device */
+	/*
+	 * Delete all controllers using this device. ->dying is stored before
+	 * nvme_rdma_ctrl_mutex is acquired here, and nvme_rdma_create_ctrl()
+	 * checks it while holding that same mutex, so the two orderings are
+	 * exhaustive: a publisher that got the mutex first is on the list and
+	 * is deleted below, and one that gets it afterwards observes ->dying
+	 * and tears its controller down itself. No controller can be added
+	 * behind this walk.
+	 */
 	mutex_lock(&nvme_rdma_ctrl_mutex);
 	list_for_each_entry(ctrl, &nvme_rdma_ctrl_list, list) {
 		if (ctrl->device->dev != ib_device)

base-commit: bf881dd20062db5e951a0d0703cb476df8c9fdee
-- 
2.34.1

