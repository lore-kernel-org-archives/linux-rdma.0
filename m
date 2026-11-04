Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.178
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793755369;
	b=NlpPwbJj5ooDThzUDOUKHIocZtcIv3VCKemH8TH3xg1clcLEE9sBAPRb76cWg/snS/d+
	 THxlZy8T+l0M/UAtvtmFmlp+aQSZurJh/4iWPunxu0vGT5nFhB2Ot54xK6sjweNguhKce
	 OGd+NFMN6ANNB5ljotE0t/t5MRYpRfMNAG5RsRqg91FWoVi0IFLiGYhgFhLpico3eSAqa
	 Lf+115q3uJl01vSVcqfWI/sBH+DOd2KLT4Z0oNjmCMvtw109hPBOioldPtwEtRAQdlWeR
	 gLJPOQQx8H0hY8+C0yB9SxzI/0rmzi4hmVMweY3QWrSwrWKGpkrkV97X9W3O23IAkBg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793755369;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=f3lqT1BOFqxncMnyMiSJ1zK4TtV8GO2GzPZbCl8ZrDI=;
	b=B6yLWhrA8Phuai/kTTVt0sHPAxhaUKn6XNB/IZ+nwMYJ/jsTSPQYsey6R2MAMYzmouzY
	 zud+KdvCqIBLxwEbKr0npTTId0iuR5x0OUW2WOQdR/tIA2cAIE2BF0Dzao67WodUPnrk9
	 5UNFpAZY6i3u279s+DN1VSeL1zgWY/5VIXupRQWZt+7jADw9bwfqLKCWgZRuajtbmhO6C
	 ntQqF+ZtCpzxMDgeruJg0CXE9Uu+ouB4VFwfK/04wZzYa5ShL5MMatSgGdLVfORgqO3VJ
	 IXjgkcQjwMnhEK2jaag4K4Lamasfv3iHnmfRZ3flb9BAgYYqE3PAdHsrD6I192KMlJQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=tljyW5J5;
	arc=none smtp.remote-ip=209.85.215.178
Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFADD606A32E
	for <linux-rdma@vger.kernel.org>; Wed,  4 Nov 2026 01:22:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CFADD606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=tljyW5J5
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-cc758830601so132543a12.2
        for <linux-rdma@vger.kernel.org>; Tue, 03 Nov 2026 17:22:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1793755368; x=1794360168; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=f3lqT1BOFqxncMnyMiSJ1zK4TtV8GO2GzPZbCl8ZrDI=;
        b=tljyW5J5nNVL009zvXk6jIIq8indtdeKOqQmgAT2nIJQk7Aj510p5mt1/0b3E8xUAW
         Dy+CV8UO7buCLZHq5CWRMuvcYXEyvFmK7Bosd5pbOAhsegVefX/vr6HphSl9c6L/s+Zd
         ItiDOA9LkDFGJMVw8g/2skBckl6XC9Gk4LPAiNX1R9DA6Gc2FFbgNmIeCKx/0XmiFlBV
         cK8VDzZkYADNJJZ5XUH/WNQeObcN7RUc1/+CbyAR376Z4/VISSEQzvv3XuwilV857G08
         V/FbmZCxD6AhFe8XICFnlvhvdjf1AiODGhx75QGiFap4o2HrVsJp2sW3HPZy3YVjtu+6
         d4bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793755368; x=1794360168;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=f3lqT1BOFqxncMnyMiSJ1zK4TtV8GO2GzPZbCl8ZrDI=;
        b=mx1p6QvpqFn/J1xrJoN3+rtJ8c8MRn/1y2e+g0Wjwo5cQSXtVtNVlNlTFbUM7HNE1Y
         SGPIutYCCcjeMD0mb3iNLPEHuomeyxOrxcXOtNxtn+EYQcgK1H3NOZvPHMi+lxD+3i6E
         Y5LRQgZ304XWomaxd/WE67kFvy7jLyFLaM3pmXZJXcT1/pY2Q7+3ahNlY2qLKPuQL3xm
         0L2kaPXr+N7hdqesqA7LN/xlAfy0k8E+ktUPwYr3P0UUApm36EWu3m88LP7+sfNqK4uc
         TfabW2ZBnVU5sypRAffGXLIxLDfLeMF8TMbLJrBilJPiqz6daFD03bqBmiOL6MZRHJuf
         NH4A==
X-Forwarded-Encrypted: i=1; AKwUvBwR3lFQL3Xz9AFIRNMzvkrlJOTMVrXEBWfonWZxjSPmlrCAsxdOxv2hpXYwmkeE/7NAXcLj3SSaXBeM@vger.kernel.org
X-Gm-Message-State: APuU4Z+/spdNYTwK6ranT4dV5Xs5X75pc9FPUgyXT9T8MtSAK9LMMk9p
	Wbjdx8UPRpIh2hLE1o6DwvBHoS0UFyP2DAfXvvrQzkF5DAS+vhd/TdFU543qA5nKX0I=
X-Gm-Gg: AYBFou0k9ms6RdH3NFY1T3Yst/lrmYbqQJy6v5W7LoRvfUPqWgpZrnejUE3UTeBUTqX
	h953dsNa7nGiwbImBNRet26C2PrBnsWA8TTEfOpBuNkrd7QrXSowo0o8903sbkTRAWZ1xblrkYu
	oSHU1RBd3VVJSXQedys9WP/hJQU62HU70JKQaXRdLl7yQf12gM5D971O6XIHOAlm1jgvWKjyGsB
	1yViqxzdWCMtg81xS9Npm/5eUGQ3jY8S04WsJ4E8YQJ1HAdCZA2Rrh48X3qmq8fFWmjoInX8Af1
	AWGJNHF4m6l39iQDbndLb8gOHvRmp40OaTxOKL6fnjyEnNb7xvrKdP3V7ImBuE5/sWqDaRqjBbI
	q7Z7NTpQSK4SVU51X7hAlFS6swqGAjEzrSUxxFrAGmSbhbn/1gaVEL7oCY1vP63zAdO+XEQZyKf
	83jBpqRelHmtm/SYTykat5ZN2CPWyPraab/YvUMrzC+jKCPJJYpKORdeTHm7fXgBonNa3BM02nb
	c1rbXq2Lctdyuq47nEDycGv5NBF6WdNQFure+Jt5N7UhYNhlhUVeoHcPejkRDrJEc2RQflJnZ5t
	hXXDLRr6P38rkf93i4+OGDLv2HxM8PbxU+zYq/5j7emBgt7mZrCt88Im3yQ/kpnEBt6a2tJyFAm
	hzvLiP38QA0BkXNvlZliww4AI9sUymwUVOksG
X-Received: by 2002:a17:90b:2882:b0:3ac:8897:7b9d with SMTP id 98e67ed59e1d1-3ae89574cd6mr13009623a91.1.1793755368252;
        Tue, 03 Nov 2026 17:22:48 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:744:cf40:a7b2:e78f])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b09452d89bsm678045a91.0.2026.11.03.17.22.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 17:22:47 -0800 (PST)
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
Subject: [PATCH v7 5/6] IB/isert: do not build a new isert_device for a device being removed
Date: Wed,  4 Nov 2026 10:22:18 +0900
Message-ID: <20261104012219.1759523-6-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261104012219.1759523-1-yhlee@isslab.korea.ac.kr>
References: <20261104012219.1759523-1-yhlee@isslab.korea.ac.kr>
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

Let the ib_client data say whether a device may be used.  isert_add_one()
stores a non-NULL value, isert_remove_one() clears it, and
isert_device_get() refuses a device whose data is NULL.  The clear, the
lookup, the reference and the removing flag are one device_list_mutex
section, taken under isert_conn_mutex as in 3/6, so a device sharing a
node_guid cannot raise the reference count of one being removed.

A test-only delay before isert_device_get() opens the window.  It opened
in three of fifteen runs of patches 1 to 4, which built a second
isert_device and took ten or eleven core warnings, and in six of eighteen
runs with this patch, which built one device and took none.  Parking
isert_remove_one() after the lookup and connecting on a device sharing its
node_guid gave it two more references without this patch and none with it.

  WARNING: drivers/infiniband/core/cq.c:370 at ib_cq_pool_cleanup+0x189/0x250, CPU#0: rdma/202
  Modules linked in:
  CPU: 0 UID: 0 PID: 202 Comm: rdma Not tainted 7.4.0-rc1-NW4-00006-ga65579195c15 #125 PREEMPT(full)
  Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
  RIP: 0010:ib_cq_pool_cleanup+0x189/0x250
  Code: 85 19 ff ff ff 48 8b 04 24 49 83 c4 10 49 39 c4 0f 85 cd fe ff ff 48 83 c4 18 5b 5d 41 5c 41 5d 41 5e 41 5f c3 cc cc cc cc 90 <0f> 0b 90 e9 20 ff ff ff 48 89 44 24 08 e8 15 16 0b fe 48 8b 44 24
  RSP: 0018:ffff88810c737308 EFLAGS: 00010206
  RAX: ffff88810a03fc40 RBX: ffff888104b5c000 RCX: 0000000000000007
  RDX: 000000000000010c RSI: 0000000000000000 RDI: ffff888104b5c02c
  RBP: dffffc0000000000 R08: 0000000000000001 R09: 00000000000000bf
  R10: 0000000000000003 R11: 00000000d3012b20 R12: ffff8881047f0ad0
  R13: dead000000000122 R14: dead000000000100 R15: ffff88810a03fc00
  FS:  00007f8b74df1740(0000) GS:ffff888189e5e000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: 00007f9e81f41000 CR3: 0000000105f2b002 CR4: 0000000000770ef0
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
  RIP: 0033:0x7f8b74f200d7
  Code: c7 c0 ff ff ff ff eb be 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 80 3d 75 ef 0d 00 00 41 89 ca 74 10 b8 2c 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 69 c3 55 48 89 e5 53 48 83 ec 38 44 89 4d d0
  RSP: 002b:00007ffd34f4ef18 EFLAGS: 00000202 ORIG_RAX: 000000000000002c
  RAX: ffffffffffffffda RBX: 0000556b747c4390 RCX: 00007f8b74f200d7
  RDX: 0000000000000018 RSI: 0000556b747c32a0 RDI: 0000000000000004
  RBP: 00007ffd34f4ef50 R08: 00007f8b75017200 R09: 000000000000000c
  R10: 0000000000000000 R11: 0000000000000202 R12: 00007ffd34f4f140
  R13: 00007ffd34f4ef24 R14: 00007ffd34f4f160 R15: 00007ffd34f4f140
   </TASK>

Fixes: 63b268d232b8 ("IB/isert: Properly release resources on DEVICE_REMOVAL")
Cc: stable@vger.kernel.org
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
---
 drivers/infiniband/ulp/isert/ib_isert.c | 41 +++++++++++++++++++------
 1 file changed, 31 insertions(+), 10 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index 712d6165150e3c..1b388075cc6332 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -41,6 +41,11 @@ module_param_cb(sg_tablesize, &sg_tablesize_ops, &isert_sg_tablesize, 0644);
 MODULE_PARM_DESC(sg_tablesize,
 		 "Number of gather/scatter entries in a single scsi command, should >= 128 (default: 128, max: 4096)");
 
+static struct ib_client isert_ib_client;
+
+/* Non-NULL client data on a device means it may be used. */
+static char isert_device_enabled;
+
 static DEFINE_MUTEX(device_list_mutex);
 static LIST_HEAD(device_list);
 static DEFINE_MUTEX(isert_conn_mutex);
@@ -275,14 +280,19 @@ isert_device_get(struct rdma_cm_id *cma_id)
 	int ret;
 
 	mutex_lock(&device_list_mutex);
+	if (!ib_get_client_data(cma_id->device, &isert_ib_client)) {
+		mutex_unlock(&device_list_mutex);
+		return ERR_PTR(-ENODEV);
+	}
 	list_for_each_entry(device, &device_list, dev_node) {
-		if (device->ib_device->node_guid == cma_id->device->node_guid) {
-			device->refcount++;
-			isert_info("Found iser device %p refcount %d\n",
-				   device, device->refcount);
-			mutex_unlock(&device_list_mutex);
-			return device;
-		}
+		if (device->removing ||
+		    device->ib_device->node_guid != cma_id->device->node_guid)
+			continue;
+		device->refcount++;
+		isert_info("Found iser device %p refcount %d\n",
+			   device, device->refcount);
+		mutex_unlock(&device_list_mutex);
+		return device;
 	}
 
 	device = kzalloc_obj(struct isert_device);
@@ -2790,22 +2800,25 @@ isert_remove_one(struct ib_device *ib_device, void *client_data)
 	struct isert_conn *isert_conn, *tmp;
 	LIST_HEAD(removal_list);
 
+	mutex_lock(&isert_conn_mutex);
 	mutex_lock(&device_list_mutex);
+	ib_set_client_data(ib_device, &isert_ib_client, NULL);
 	list_for_each_entry(device, &device_list, dev_node) {
 		if (device->ib_device != ib_device)
 			continue;
 		device->refcount++;
 		device->removal_comp = &removal_comp;
+		device->removing = true;
 		found = device;
 		break;
 	}
 	mutex_unlock(&device_list_mutex);
 
-	if (!found)
+	if (!found) {
+		mutex_unlock(&isert_conn_mutex);
 		return;
+	}
 
-	mutex_lock(&isert_conn_mutex);
-	found->removing = true;
 	list_for_each_entry(isert_conn, &isert_conn_list, conn_list) {
 		if (isert_conn->device != found)
 			continue;
@@ -2828,8 +2841,16 @@ isert_remove_one(struct ib_device *ib_device, void *client_data)
 	wait_for_completion(&removal_comp);
 }
 
+static int isert_add_one(struct ib_device *ib_device)
+{
+	ib_set_client_data(ib_device, &isert_ib_client, &isert_device_enabled);
+
+	return 0;
+}
+
 static struct ib_client isert_ib_client = {
 	.name   = "isert",
+	.add    = isert_add_one,
 	.remove = isert_remove_one,
 };
 
-- 
2.43.0

