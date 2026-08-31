Received: from mail-oa1-f47.google.com (mail-oa1-f47.google.com [209.85.160.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9BF839023C
	for <linux-rdma@vger.kernel.org>; Mon, 31 Aug 2026 22:14:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788214447; cv=none; b=Rk8BIgFe0qF7rgVTryxset+NwUfs1GPOo+pMiCkpboHsDzaMacWYItd8EyVx9obD5WmAYpX1/qQAFnLHzZ8FDh+6d5e6QPVj4xV8JR5OXg4lgiNfH66Kx+7PbGnyCN1JwQX9IejTmUQlSKqJQUu5l3dlVBebnt6urCbSeCT/SvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788214447; c=relaxed/simple;
	bh=HHZ8OqfGxJUimeSOkOvYaFhVcE5zxiEPsMMx08L3GR8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=SAyaTSgiq95gtH2/l50BbowcR+3Ca8x/E62TiiaN4MHCIeMoTYk3PaTiK2tQm4exHX4t3aXKwG5FsbtjPmyuiTbXqsn7LQ4TAm1J0X+guFERjt7iW0wOm+dJjl8TQo4PDEaBqp6pGuXIPRcErXQJq9jXYRrApC335E5YubJ9JjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=pass smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=FYbuFdIo; arc=none smtp.client-ip=209.85.160.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="FYbuFdIo"
Received: by mail-oa1-f47.google.com with SMTP id 586e51a60fabf-46ac1963663so397825fac.0
        for <linux-rdma@vger.kernel.org>; Mon, 31 Aug 2026 15:14:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1788214444; x=1788819244; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1wuT3KA8guOepoCsoUIKjVLNC1Aqj3NCJ3PXMyK/yd8=;
        b=FYbuFdIoYzy4uvWO+yC0mLQO7fsGk+dThZF/vvxNU+qvWYXRMvVidtEhABotDfbteB
         Yzb7kCflFIqVB0Upm9Mm16G7x2odyJLpCSt356KXkb0QC2Sp74InA+Uni8nclYBZJaZq
         rswBRhB71mwDFn4jADWJolYSzycHLyNWeyoBZVvZJJ0j9nTx1+gUrbBYJcu8QeMruJ80
         4zZcMMfVhVW0VDDPuJR2MsT1781fXklN5ZWtnUtjcOQIXofUXSITTO/8F61WfIwEsi6/
         l4hZQBr93/cEWZ1PXghIOEQIQ+HjGbCKzEUsjZqnuSNTXFHLZG2xwDmmo8piOKgLjVOo
         5Xug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788214444; x=1788819244;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=1wuT3KA8guOepoCsoUIKjVLNC1Aqj3NCJ3PXMyK/yd8=;
        b=V/Hwqr5shHAsP1WiSzzQfyuMsZAd2vZc9fpysqzgrsBEq2xQVGBBdJTIW/EovWIzb9
         2ccjWINvsfIv2JjKmYvjnd8eYshNPtPKgQTqAGgW5sOMtWMMkH+oL0w+xkc8QmIqjTLf
         6VHhZlM4u6GWb5KPL8/J0GHObhhcqHBsHT4+F5xEdIQDxwml5emcZazG8wICaVzsUGMu
         qEP1fevl36ipMzCnT9GACbUR19cBOeO63rx9fJ9fw7P3zxasa2Sgoash5OA41H5aR5dl
         pPdR+Vuu4SLDjBn5DqEsfv5jpbrMT9uy40NA5Oa0Pla2+G7sSaKtP0pna5R28lYSFGal
         4ivA==
X-Forwarded-Encrypted: i=1; AHgh+Rr8ENZM8hYwtYoZ7rkCn0myXmRC8WaLRco4rS9cmYzHwg91I8j3xDOHRO35zo4Qy5FgA/L06DSqKqmq@vger.kernel.org
X-Gm-Message-State: AFuF++ky1SXy1cGXsdxjX4rVECxPPXOhxWFfacGjiyPpwZSJ5WZRbqgm
	G5HuNVOQcNo7bEbmERvMYoz9/rEQVaAZVerhgN1e0PEbg65uzC2ZlCrJgmFO8N1zH9w=
X-Gm-Gg: AR+sD102tpkWW4DPVEWKKN9iASRyueIiJBNu69tuGH+s1V/S809fjaxX2dWW9XgpHqd
	HWnBQ2mnSPrIWsY6NwnhpMHg+G9i4u1IfV0G0PlxI2ccJ8ln65hiVVw1+nXWC7jgH3yt9oljIbL
	74NMfmLg0yKCBHQEERFS2hSOYXToJ6EQmYEVU6UT1FJx+nz6ZCVu1cxLxYu2xboBrSvBTc9EjGo
	degWCO5P72zcwr2vd1h3Wc9QO9AumyZUz+dWnbt5CjVL2xTulaYdQzJM1rJbzlUPgUzJ7BGmkE6
	P4fT/KY00qDxzHL2zrEFJoqpDqeGGQSEViOBgHxGSAimz/DD8SeIQdQcDt6soAj80AehwS7ibcg
	wmSC2SLZdKQaRbPOm/BRauN8pdXmnWUv/fpE8o/uQpZL7imNeG9gVjSq41l6RCy5P2bScANd4jK
	nyVfZhxUFbs4E/Zj3aZMVuMB/symBAUqIQNKgYB5K5KuxdYFWxYRhkUpCCAC4nDwi/kELRsT2/k
	fcYwCAmeiMe8hHz
X-Received: by 2002:a05:6808:2228:b0:4a4:866:c2c0 with SMTP id 5614622812f47-4b57889dd5cmr10099078b6e.4.1788214443969;
        Mon, 31 Aug 2026 15:14:03 -0700 (PDT)
Received: from dev-cachen2.dev.purestorage.com ([208.88.159.129])
        by smtp.googlemail.com with ESMTPSA id 5614622812f47-4b3a16259f5sm8888807b6e.3.2026.08.31.15.14.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Aug 2026 15:14:03 -0700 (PDT)
From: Casey Chen <cachen@purestorage.com>
To: linux-nvme@lists.infradead.org
Cc: leon@kernel.org,
	sagi@grimberg.me,
	kbusch@kernel.org,
	hch@lst.de,
	axboe@kernel.dk,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3] nvme-rdma: fix ib_device removal race that hangs PCI unbind
Date: Mon, 31 Aug 2026 16:13:55 -0600
Message-Id: <20260831221355.1715088-1-cachen@purestorage.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260828232436.270184-1-cachen@purestorage.com>
References: <20260828232436.270184-1-cachen@purestorage.com>
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

nvme_rdma has no ->add callback, so its client_data is unused. Use it as
a per-ib_device liveness token: ->add stores the ib_device itself,
nvme_rdma_remove_one() clears it before doing anything else, and ib_core
erases it once ->remove has returned. ib_get_client_data() returning
NULL therefore means "this device is being removed, or already has
been", which is exactly the span over which nvme_rdma must refuse it.
The token needs no allocation, so ->add cannot fail and leave a device
attached with no ->remove to follow.

Two sites test it:

 - nvme_rdma_find_get_device() refuses a device that is going away, so a
   connect starting after removal begins never builds a PD, CQ or QP on
   it, and no stale nvme_rdma_device is handed out by the node GUID
   match.

 - nvme_rdma_create_ctrl() tests it under nvme_rdma_ctrl_mutex
   immediately before publishing, which covers a connect that was
   already in flight. The token is cleared before
   nvme_rdma_remove_one() acquires that mutex, so the two orderings are
   exhaustive: a publisher that takes the mutex first is on the list and
   is deleted by the walk, and one that takes it afterwards observes
   NULL and deletes its own controller. No controller can be added
   behind the walk, so a single sweep suffices.

Keying on the ib_device rather than on nvme_rdma_device matters: the
lookup matches on node GUID while the removal matches on the ib_device
pointer, so the two are not one to one, and the token also outlives the
nvme_rdma_device, which is freed as soon as its last queue is torn down.

The controller is fully live at the point the connect is refused, so it
is torn down with nvme_delete_ctrl_sync(). ->list is still empty there,
leaving opts to nvmf_create_ctrl(), and nvme_init_ctrl() left two
references while nvme_delete_ctrl_sync() consumes only the one that
nvme_uninit_ctrl() drops, so the other is put explicitly.

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

Changes since v2:
https://lore.kernel.org/all/20260828232436.270184-1-cachen@purestorage.com/

 - Drop ->dying, nvme_rdma_removing_list and struct
   nvme_rdma_removing_device entirely (Sagi, Leon). The state is now a
   per-ib_device liveness token in client_data, which nvme_rdma was not
   using, so there is no new field, list or struct and nothing to reset
   on re-probe.
 - The test is keyed on the ib_device rather than on nvme_rdma_device.
   That also fixes something v2 got wrong: the lookup matches on node
   GUID while the removal matches on the ib_device pointer, so the two
   are not one to one, and a flag on nvme_rdma_device can be set on an
   ndev shared with a device that is not being removed.
 - This closes the window v2 documented as knowingly open. Once
   nvme_rdma_remove_one() returned, v2 had no state left, so a connect
   arriving before cma_remove_one() unlinks the cma_device could still
   strand a controller. remove_client_context() erases client_data after
   ->remove returns, so the token stays NULL and that path is refused.

Why the test cannot move to nvme_rdma_setup_ctrl(), and the alternatives
to this approach, are discussed in the reply to Sagi on v2:
https://lore.kernel.org/all/20260831220754.1714514-1-cachen@purestorage.com/

Two side effects of adding ->add, neither of which I think is a problem
but both worth naming:

 - A device with !kverbs_provider never gets ->add
   (add_client_context() returns early), so nvme_rdma now refuses it in
   nvme_rdma_find_get_device() rather than failing later at QP creation.
   nvme_rdma cannot use such a device either way.

 - Clients are added FIFO and rdma_cm registers before nvme_rdma, so
   during ib_register_device() cma_add_one() runs before
   nvme_rdma_add_one(). A connect resolving in that gap is refused with
   -ECONNREFUSED until ->add has run. Self correcting on retry, but a
   real transient at probe time.

Note ib_get_client_data()'s kernel-doc says it "can only be called while
the client is registered to the device, once the ib_client remove()
callback returns this cannot be called", and this uses it precisely to
detect that state. It works, since it is a bare xa_load() and xa_erase()
runs after ->remove, but it is outside what the API documents. Leon, if
you would rather ib_core grew something explicit for this, or if you
prefer the flag based variant, say so and I will respin.

The ->add path is new in this version and has not run on the setup that
reproduced the hang, so this wants a fresh soak before it is applied.
 drivers/nvme/host/core.c |  1 +
 drivers/nvme/host/rdma.c | 28 ++++++++++++++++++++++++++++
 2 files changed, 29 insertions(+)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 758245c799a1..bede16fe1ff5 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -282,6 +282,7 @@ void nvme_delete_ctrl_sync(struct nvme_ctrl *ctrl)
 		nvme_do_delete_ctrl(ctrl);
 	nvme_put_ctrl(ctrl);
 }
+EXPORT_SYMBOL_GPL(nvme_delete_ctrl_sync);
 
 static blk_status_t nvme_error_status(u16 status)
 {
diff --git a/drivers/nvme/host/rdma.c b/drivers/nvme/host/rdma.c
index 29ecbe71bb2e..04687fe22804 100644
--- a/drivers/nvme/host/rdma.c
+++ b/drivers/nvme/host/rdma.c
@@ -46,6 +46,19 @@ static LIST_HEAD_GUARDED(device_list, device_list_mutex);
 static DEFINE_MUTEX(nvme_rdma_ctrl_mutex);
 static LIST_HEAD_GUARDED(nvme_rdma_ctrl_list, nvme_rdma_ctrl_mutex);
 
+static struct ib_client nvme_rdma_ib_client;
+
+static int nvme_rdma_add_one(struct ib_device *ib_device)
+{
+	ib_set_client_data(ib_device, &nvme_rdma_ib_client, ib_device);
+	return 0;
+}
+
+static bool nvme_rdma_device_removing(struct ib_device *ib_device)
+{
+	return !ib_get_client_data(ib_device, &nvme_rdma_ib_client);
+}
+
 struct nvme_rdma_device {
 	struct ib_device	*dev;
 	struct ib_pd		*pd;
@@ -377,6 +390,9 @@ nvme_rdma_find_get_device(struct rdma_cm_id *cm_id)
 	struct nvme_rdma_device *ndev;
 
 	mutex_lock(&device_list_mutex);
+	if (nvme_rdma_device_removing(cm_id->device))
+		goto out_err;
+
 	list_for_each_entry(ndev, &device_list, entry) {
 		if (ndev->dev->node_guid == cm_id->device->node_guid &&
 		    nvme_rdma_dev_get(ndev))
@@ -2380,6 +2396,15 @@ static struct nvme_ctrl *nvme_rdma_create_ctrl(struct device *dev,
 		nvmf_ctrl_subsysnqn(&ctrl->ctrl), &ctrl->addr, opts->host->nqn);
 
 	mutex_lock(&nvme_rdma_ctrl_mutex);
+	if (nvme_rdma_device_removing(ctrl->device->dev)) {
+		mutex_unlock(&nvme_rdma_ctrl_mutex);
+		dev_info(ctrl->ctrl.device,
+			 "hca %s is being removed, aborting connect\n",
+			 dev_name(ctrl->device->dev->dma_device));
+		nvme_delete_ctrl_sync(&ctrl->ctrl);
+		nvme_put_ctrl(&ctrl->ctrl);
+		return ERR_PTR(-ECONNREFUSED);
+	}
 	list_add_tail(&ctrl->list, &nvme_rdma_ctrl_list);
 	mutex_unlock(&nvme_rdma_ctrl_mutex);
 
@@ -2411,6 +2436,8 @@ static void nvme_rdma_remove_one(struct ib_device *ib_device, void *client_data)
 	struct nvme_rdma_device *ndev;
 	bool found = false;
 
+	ib_set_client_data(ib_device, &nvme_rdma_ib_client, NULL);
+
 	mutex_lock(&device_list_mutex);
 	list_for_each_entry(ndev, &device_list, entry) {
 		if (ndev->dev == ib_device) {
@@ -2437,6 +2464,7 @@ static void nvme_rdma_remove_one(struct ib_device *ib_device, void *client_data)
 
 static struct ib_client nvme_rdma_ib_client = {
 	.name   = "nvme_rdma",
+	.add    = nvme_rdma_add_one,
 	.remove = nvme_rdma_remove_one
 };
 

base-commit: 9eabc91952f9821824ca0288a76b3aba57961c6b
-- 
2.34.1

