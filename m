Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.170
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793710840;
	b=X+I3QkkN0lAMUG5R3o4GDCDW6SUL/KksRIzsIKYIFuOIo36YX/g7ToxLqKAdTwOj2lg2
	 cll70UVoKCv29Rol4qBw6ITm2axiV/+QRS07xoUhnPGpNhiMPRguX1UFoVw3uWkepudVZ
	 4VgOQNo1kjNq8k/rIzlOU33NOpkJ9pxJcbwGaDV7QV2Qhs11Sg4xkXjmqjQE/DAIi3AQZ
	 9gHeqVmeNB/WRsHMlkpeIYEF1nfJ/jLo3oq8LnH76aSTjyTe+qt29uwnACxoxuWCe0qGP
	 2pt18PYAIhYR0kRVpe40SXNoAPxIOLDfVTSCOlNxq7TU+SFBjgs+jJQXL7fHZ7fLYgQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793710840;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MdQG3hmNpVxhna+J3pEZThNVALe2g0N/xInoV/Apu7U=;
	b=Umwusv0TmCjW7+JryXnZ12dyoIe5IjgcMbm0RiTXamMOO+tr7mi7ytpsd31gSgr91pPc
	 qN+FeSXGoNuQPDHCWcTcxppS82xF8cGPyV+embo8x/vlExgMswVWYCpds5te3XkmjIs1d
	 GYENZTTa+Z99GdGGEbaKlYzTtDzYsrN5kxhWXUBagBvn/az/EG8dLAYYuDyGoTtGpt8z4
	 vydWglsvAwqNEU2x/BLO36dFtEMyzO8l75m1x7TJNGnmMg3D7ZryaXq3teVL5J6FwTswt
	 bHlwb5CC0DnDy+vjneNSj//8tgIUzWGyd2Ez1I/1EB+stRRXl/9z5kClV8fFT90oS2w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=H6nzIGeq;
	arc=none smtp.remote-ip=74.125.82.170
Received: from mail-dy1-f170.google.com (mail-dy1-f170.google.com [74.125.82.170])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36117606D812
	for <linux-rdma@vger.kernel.org>; Tue,  3 Nov 2026 13:00:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 36117606D812
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=H6nzIGeq
Received: by mail-dy1-f170.google.com with SMTP id 5a478bee46e88-3550c917fd3so5646727eec.0
        for <linux-rdma@vger.kernel.org>; Tue, 03 Nov 2026 05:00:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1793710839; x=1794315639; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=MdQG3hmNpVxhna+J3pEZThNVALe2g0N/xInoV/Apu7U=;
        b=H6nzIGeqdhdqN5A8RqscIYgEiNJjaAM0Wia4n9eNeLlB/pk1XIESzVZSi8ZqDT+ds6
         ob58XYMeim/vOr4C3YVNDObzNn0FGkR064A5CXdQV23fhfAm+5dq9IfbKFVTZ5Ikjn81
         BnEtGWb/YpCs3tNOQ+ngrB1O20g7DxHjJ+EoccCgVuvbUb+vk5LqAGpwCS7rKbwT772V
         5KFKp/MBAXdOxkVMKcDejYlgfFGWnMtXKCukd6KEYnYoa+oCILXyW5RgJrIDbm9Viob3
         izaJIWXiRnPCa0MBDhkbDra59NQ880PITmllHp3hZJXOojDqcravlSjl/ZcOJWpzK7MG
         HsMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793710839; x=1794315639;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=MdQG3hmNpVxhna+J3pEZThNVALe2g0N/xInoV/Apu7U=;
        b=0sUBPoY78GhUWf4kRg4XMnaExCLMi+6nBssswzQXv0PoJgt/WAUVIMHEhVwlnmhAPB
         zYSlFl97EFHApyKw9Xo39Tq6P6h6FdikIEWMEMLthuFC1hkAjrym9lAKhwbwtuPXUM89
         QJn2tPkcvnrM1nmnLGYx3BFTNaMlYT2P5kES0p8GbObxwESzl1RSLzUMjp193DkZ9RDV
         4jJNBxjg43moJvBpirJpgIj1WhkKbHV0P0LmSNGY0vvXq8uiV4ZWFt9MTpcBx9C335Sh
         rYREP9k4ezReGO8+RF3Ilz5tlpJ4mQ30A1V7b8w7kaSnegvjjtqlhIGaP/rqQwC4fUJV
         52Yg==
X-Forwarded-Encrypted: i=1; AKwUvBynTcssn0m8SSI1ysa8Awgy3zO087JtqNKwozaNAeRtpwfC1+eh+Now8NS7wuwEB4EYu1FM1Nfhwo4B@vger.kernel.org
X-Gm-Message-State: APuU4Z8TSEUFLy5nHJbk/Hw308heoY+PiczTW/dJ3dleJCPACu92PoOl
	NbBeW0P5FBfZysz4Cjo2dGnPPWOmBLFwtWtUIE0R5iMXlXwmDyjIbRwxU0DC23jlLpo=
X-Gm-Gg: AYBFou0ENig/jij+kqjZQLoXl56ylAeo4aS8nkwgU/heLjqZKXGzZfRCe7GvSk7dXxn
	5yoljKG7swKHQvYnSTMzzPOLWDyUFJiFZ/gSVT1BG5qc+Zd+tG8CuQDJ/gRxS0WPjkpKbdasbvf
	yYzS2r/GJtiIgNDgM9EBYcp8b2dWRvqWjn4N1wJUhrTXyxFN1FHLjt+w61r9lBoD5pGTdTmV3Rp
	cA4RKUxL7BenTQDGajKcM1POPn7GWSXNeZw4Tv1b8IhlVACobMEFsx2ETAYlmFLmEby07Bq9WJJ
	anYtLUd4pr3T+rtR4CFEs5dzeQ9aB3bqxuUYS7nvhUaBHLtwKEoXWzu/cLSwJ6Suv9AZ5pX/bDP
	cVJQpukfR0+TTuqDtI8hmjAjJuptHfbyBADHCjE9rX6yArsXxzOf/Pg5Bm3mAGu73SaDWuLS2Jj
	TRwYu58Wz06RcbK0hJWHkJbxUuy63LCzrJBSxjQ5185O17T/Ss2CPfcK09Fm6DRW0wyl/IQUiil
	GoTPZ4AwVY0U/ywP+C/X4WfF7EYA1QwXkaBPmtr68fBoFKDYmFWJZZRobRDP6hffLuNSi9j10Dm
	9mCABWkVERthefwWCMmRXB+z9Nzk+0pStWnysBxE+y0oEZGX/WLjh69nAtygxgYPHa0WXy+5M17
	I+k/r1T6odip4VqIuGZZa8EziFEEuSt9wkISjXTqGPTov8SIOfjYxTkgzflM=
X-Received: by 2002:a05:7300:cd90:b0:34b:4b99:24ab with SMTP id 5a478bee46e88-36a42454b8emr29561341eec.22.1793710838294;
        Tue, 03 Nov 2026 05:00:38 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:2da3:4696:4c5e:89c1])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36a42669128sm50806107eec.3.2026.11.03.05.00.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 05:00:37 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: Sagi Grimberg <sagi@grimberg.me>,
	Max Gurtovoy <mgurtovoy@nvidia.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
	Mike Christie <michael.christie@oracle.com>,
	linux-rdma@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yehyeong Lee <yhlee@isslab.korea.ac.kr>,
	stable@vger.kernel.org
Subject: [PATCH v5 5/5] IB/isert: do not build a new isert_device for a device being removed
Date: Tue,  3 Nov 2026 21:59:55 +0900
Message-ID: <20261103125955.1530355-6-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261103125955.1530355-1-yhlee@isslab.korea.ac.kr>
References: <20261103125955.1530355-1-yhlee@isslab.korea.ac.kr>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

isert_device_get() looks the device up by node_guid and has no reason to
refuse one.  A CONNECT_REQUEST arriving while isert_remove_one() runs
therefore builds a new isert_device on an ib_device the core is about to
free, and nothing waits for its QP, CQ or PD.  cma_process_remove() waits
only for id destruction, and the core takes no device reference for them,
so ib_dealloc_device() can run while they are still being released.

Keep the struct as a marker when the last reference of a device being
removed goes away, refuse isert_device_get() for an ib_device that has one,
and clear it from an ib_client add callback.  The lookup runs in two
passes, so a marker cannot hide a live device whose ib_device pointer was
reused.  The marker uses __GFP_NOFAIL because isert_remove_one() cannot
fail, and preallocating in the add callback does not work:
add_client_context() erases the client data and never calls remove on a
failed add.

A test-only delay before isert_device_get() opens the window.  It opened in
one of twelve runs of patches 1 to 4 of this series, and that run built a
second isert_device and took the ten warnings below.  It opened in six of
twelve runs with this patch, which built none and took none.

  WARNING: drivers/infiniband/core/cq.c:370 at ib_cq_pool_cleanup+0x189/0x250, CPU#1: rdma/201
  Modules linked in:
  CPU: 1 UID: 0 PID: 201 Comm: rdma Not tainted 7.4.0-rc1-NW4-00006-ga65579195c15 #125 PREEMPT(full)
  Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
  RIP: 0010:ib_cq_pool_cleanup+0x189/0x250
  Code: 85 19 ff ff ff 48 8b 04 24 49 83 c4 10 49 39 c4 0f 85 cd fe ff ff 48 83 c4 18 5b 5d 41 5c 41 5d 41 5e 41 5f c3 cc cc cc cc 90 <0f> 0b 90 e9 20 ff ff ff 48 89 44 24 08 e8 15 16 0b fe 48 8b 44 24
  RSP: 0018:ffff88810b867308 EFLAGS: 00010206
  RAX: ffff888109a7ec40 RBX: ffff888109ac5c00 RCX: 0000000000000007
  RDX: 000000000000010c RSI: 0000000000000000 RDI: ffff888109ac5c2c
  RBP: dffffc0000000000 R08: 0000000000000001 R09: 00000000000000bf
  R10: 0000000000000003 R11: 000000000a739171 R12: ffff888104954ad0
  R13: dead000000000122 R14: dead000000000100 R15: ffff888109a7ec00
  FS:  00007f9437ecb740(0000) GS:ffff88818cade000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: 00007f5331739000 CR3: 0000000109a19004 CR4: 0000000000770ef0
  PKRU: 55555554
  Call Trace:
   <TASK>
   ? remove_client_context+0xb7/0xf0
   disable_device+0x13c/0x240
   ? __pfx_disable_device+0x10/0x10
   ? __pfx_mutex_lock+0x10/0x10
   __ib_unregister_device+0x226/0x3f0
   ? __pfx_mutex_unlock+0x10/0x10
   ib_unregister_device_and_put+0x50/0x70
   nldev_dellink+0x28e/0x3d0
   ? kernel_text_address+0xa7/0x130
   ? __pfx_nldev_dellink+0x10/0x10
   ? __pfx_down_read+0x10/0x10
   rdma_nl_rcv_msg+0x29c/0x4e0
   ? __pfx_rdma_nl_rcv_msg+0x10/0x10
   rdma_nl_rcv_skb.constprop.0.isra.0+0x21d/0x370
   ? __pfx_rdma_nl_rcv_skb.constprop.0.isra.0+0x10/0x10
   netlink_unicast+0x68f/0x940
   ? __pfx_selinux_socket_getpeersec_dgram+0x10/0x10
   ? __pfx_netlink_unicast+0x10/0x10
   netlink_sendmsg+0x810/0xf20
   ? __pfx_netlink_sendmsg+0x10/0x10
   ? __pfx__raw_spin_lock_irqsave+0x10/0x10
   ? selinux_socket_sendmsg+0x8c/0x270
   ? __sys_sendto+0x337/0x390
   __sys_sendto+0x337/0x390
   ? __pfx___sys_sendto+0x10/0x10
   ? fdget+0x53/0x3b0
   __x64_sys_sendto+0xdb/0x1b0
   ? fpregs_assert_state_consistent+0x56/0xe0
   do_syscall_64+0xdd/0x4a0
   entry_SYSCALL_64_after_hwframe+0x77/0x7f
  RIP: 0033:0x7f9437ffa0d7
  Code: c7 c0 ff ff ff ff eb be 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 80 3d 75 ef 0d 00 00 41 89 ca 74 10 b8 2c 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 69 c3 55 48 89 e5 53 48 83 ec 38 44 89 4d d0
  RSP: 002b:00007ffd602e2628 EFLAGS: 00000202 ORIG_RAX: 000000000000002c
  RAX: ffffffffffffffda RBX: 0000561d7b001390 RCX: 00007f9437ffa0d7
  RDX: 0000000000000018 RSI: 0000561d7b0002a0 RDI: 0000000000000004
  RBP: 00007ffd602e2660 R08: 00007f94380f1200 R09: 000000000000000c
  R10: 0000000000000000 R11: 0000000000000202 R12: 00007ffd602e2850
  R13: 00007ffd602e2634 R14: 00007ffd602e2870 R15: 00007ffd602e2850
   </TASK>

Fixes: 63b268d232b8 ("IB/isert: Properly release resources on DEVICE_REMOVAL")
Cc: stable@vger.kernel.org
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
---
 drivers/infiniband/ulp/isert/ib_isert.c | 73 +++++++++++++++++++++----
 1 file changed, 61 insertions(+), 12 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index 712d6165150e3c..4bcd14f5045ac6 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -260,10 +260,12 @@ isert_device_put(struct isert_device *device)
 	isert_info("device %p refcount %d\n", device, device->refcount);
 	if (!device->refcount) {
 		isert_free_device_ib_res(device);
-		list_del(&device->dev_node);
-		if (device->removal_comp)
+		if (device->removing) {
 			complete(device->removal_comp);
-		kfree(device);
+		} else {
+			list_del(&device->dev_node);
+			kfree(device);
+		}
 	}
 	mutex_unlock(&device_list_mutex);
 }
@@ -276,14 +278,21 @@ isert_device_get(struct rdma_cm_id *cma_id)
 
 	mutex_lock(&device_list_mutex);
 	list_for_each_entry(device, &device_list, dev_node) {
-		if (device->ib_device->node_guid == cma_id->device->node_guid) {
-			device->refcount++;
-			isert_info("Found iser device %p refcount %d\n",
-				   device, device->refcount);
+		if (device->removing && device->ib_device == cma_id->device) {
 			mutex_unlock(&device_list_mutex);
-			return device;
+			return ERR_PTR(-ENODEV);
 		}
 	}
+	list_for_each_entry(device, &device_list, dev_node) {
+		if (device->removing ||
+		    device->ib_device->node_guid != cma_id->device->node_guid)
+			continue;
+		device->refcount++;
+		isert_info("Found iser device %p refcount %d\n",
+			   device, device->refcount);
+		mutex_unlock(&device_list_mutex);
+		return device;
+	}
 
 	device = kzalloc_obj(struct isert_device);
 	if (!device) {
@@ -2792,20 +2801,29 @@ isert_remove_one(struct ib_device *ib_device, void *client_data)
 
 	mutex_lock(&device_list_mutex);
 	list_for_each_entry(device, &device_list, dev_node) {
-		if (device->ib_device != ib_device)
+		if (device->ib_device != ib_device || device->removing)
 			continue;
 		device->refcount++;
 		device->removal_comp = &removal_comp;
 		found = device;
 		break;
 	}
-	mutex_unlock(&device_list_mutex);
-
-	if (!found)
+	if (!found) {
+		device = kzalloc_obj(struct isert_device,
+				     GFP_KERNEL | __GFP_NOFAIL);
+		INIT_LIST_HEAD(&device->dev_node);
+		device->ib_device = ib_device;
+		device->removing = true;
+		list_add_tail(&device->dev_node, &device_list);
+		mutex_unlock(&device_list_mutex);
 		return;
+	}
+	mutex_unlock(&device_list_mutex);
 
 	mutex_lock(&isert_conn_mutex);
+	mutex_lock(&device_list_mutex);
 	found->removing = true;
+	mutex_unlock(&device_list_mutex);
 	list_for_each_entry(isert_conn, &isert_conn_list, conn_list) {
 		if (isert_conn->device != found)
 			continue;
@@ -2828,8 +2846,38 @@ isert_remove_one(struct ib_device *ib_device, void *client_data)
 	wait_for_completion(&removal_comp);
 }
 
+static int isert_add_one(struct ib_device *ib_device)
+{
+	struct isert_device *device, *tmp;
+
+	mutex_lock(&device_list_mutex);
+	list_for_each_entry_safe(device, tmp, &device_list, dev_node) {
+		if (device->ib_device != ib_device || !device->removing ||
+		    device->refcount)
+			continue;
+		list_del(&device->dev_node);
+		kfree(device);
+	}
+	mutex_unlock(&device_list_mutex);
+
+	return 0;
+}
+
+static void isert_free_markers(void)
+{
+	struct isert_device *device, *tmp;
+
+	mutex_lock(&device_list_mutex);
+	list_for_each_entry_safe(device, tmp, &device_list, dev_node) {
+		list_del(&device->dev_node);
+		kfree(device);
+	}
+	mutex_unlock(&device_list_mutex);
+}
+
 static struct ib_client isert_ib_client = {
 	.name   = "isert",
+	.add    = isert_add_one,
 	.remove = isert_remove_one,
 };
 
@@ -2881,6 +2929,7 @@ static int __init isert_init(void)
 static void __exit isert_exit(void)
 {
 	ib_unregister_client(&isert_ib_client);
+	isert_free_markers();
 	flush_workqueue(isert_login_wq);
 	destroy_workqueue(isert_release_wq);
 	destroy_workqueue(isert_comp_wq);
-- 
2.43.0

