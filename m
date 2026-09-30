Received: from mail-dl2-f36.google.com (mail-dl2-f36.google.com [74.125.229.164])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC6932BEC5E
	for <linux-rdma@vger.kernel.org>; Wed, 30 Sep 2026 01:21:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.229.164
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790731309; cv=none; b=EuShQsV36tYcoGWcIHk/e7W5+pzrp+NisEiA0x5Fu20slaNyMjOEAy66EN21+X8ZKJ1k752TQrm0UvVv5dMxcqIE6B4HhJh63VAP8G1mzBOLkSt08Ybw4AvSHoRrqxViaCxd/Nbyu/8xXgmAG0o5T+qnk3j5+Z/NNT56mKopw7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790731309; c=relaxed/simple;
	bh=8o4yDv5RQ+5JMyU0vbJZW45I+t4vGLfP47O8jop1ogU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=UFXr53/bRDg0otfOdrCksdSrbDVLm4dsvA0FNe9M4DlAs3GleoeIcwdLIfHI5PO0bOwek4EmmBGx65UCu0HonenaDDiPF2eriARtgzoJ1BhnHlQwUqBp1o7u5mcW3U9vsC+pzN4Axz3daoJzLaNVa0HmlzPovXU5jxps1/1sWZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=trailofbits.com; spf=pass smtp.mailfrom=trailofbits.com; dkim=pass (2048-bit key) header.d=trailofbits.com header.i=@trailofbits.com header.b=e8upj1lX; arc=none smtp.client-ip=74.125.229.164
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=trailofbits.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=trailofbits.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=trailofbits.com header.i=@trailofbits.com header.b="e8upj1lX"
Received: by mail-dl2-f36.google.com with SMTP id a92af1059eb24-14373bcc010so4355601c88.1
        for <linux-rdma@vger.kernel.org>; Tue, 29 Sep 2026 18:21:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=trailofbits.com; s=google; t=1790731307; x=1791336107; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=lU5LfXchs/1FIbUOgbOr4A41Fr7KaZiMt7DIhG7bJWM=;
        b=e8upj1lXrfAdF+D3qYl9gMxaaP4KbVxlM9R0f6XKSfQSSxw+ewZHnNdlzCjPUxsjss
         /ct7rYYdoeLb5vv3uIpYAd0suplyoOTF6m97YbRQQfHcRko+rFwUHR9/R7wxZAWb/gBC
         OU6oXn2vkMKihZKxPBPZI5XG8eiyUyg/qQVDOOc17vtE7iqSQ9rnUjceqq9CZr9EvU8v
         aeF5zHx2eoRJSt03uyn0ENipsC4iczvmmcoG/FwWZ1NfkCdM4nQbmnMdnsJd30ofpoGm
         DNKdGz8ZFCGntbQWLZE74OUI9l6P6gowQXTmMu+oRKDEcypMMit+91Z0F1E3vUDrD/Vu
         AdyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790731307; x=1791336107;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=lU5LfXchs/1FIbUOgbOr4A41Fr7KaZiMt7DIhG7bJWM=;
        b=us0q9EPMJzF9dZIiAeGzFXwDcuqouexEAoeLvGtscquoMg+gNvZNjTwQmWmKm63EX3
         ij35rXg4AwBId5bvedX8AsLGc0l8rRtloZCkwNNgI3mUymB/0mxIWBpzguZazpelwDzi
         HuNALZBqFprAJBC8qM4e9DrtfwAAvK+cZqRoAnGIa2zflOEWuQTy2+i1uwzBTA/XgAMg
         /6lieYLeFWZCjoj6IWmX15cHFmAncS8U+il9OsLBSqMUN+1OTYdHa7I/6sb8Tb2JKlsZ
         U6Rzd28521IYmp20q5Cl1blOaRknI9LAhKiP3vUNszD6d1+Y5QsKQwboW6iNNSMwede8
         jzjg==
X-Forwarded-Encrypted: i=1; AKwUvBzGsX73BGIJh7+kDdXY0W1ocBhUbzXz01TKuA1U0ZuAnp9bdDeKKpCSeQBkjWMITZEZXwOfW6e9bcV7@vger.kernel.org
X-Gm-Message-State: AFuF++muVMFkfAuMeP0RRPa7YdrWOKNmx7xPEPOBtahePG+JjTtyb9qm
	wHH6a5jVbSJ03KsvDT0/0pG5moQOWOORcBW95aQXFsXZNGCQ7USWlsMYzvtI0cmzrso=
X-Gm-Gg: AYBFou3nNVjUhhz2y+4klNW6Ke2rsrueL23geMUaFFq7WLi96RJV3cNRV3tc6qg/QCn
	VehAodzZKedZTt2+llbbnugQQ8VKdhqymghgsI3v3gG3NvvctVoCStdJrPjzNwKJcY07+6E4jRW
	KfIu3jYrQgPZ58Tvv3E7Zxe6xDEGK4TPAAo6T3QXQZh/WEnTPUSUVj1qq0mBfPz0Zo7mqxLL6h4
	kbRl+5prMP64+WMZmWGB0DOaH+mHd7WxODYqfFX5P4kMBqhzF+Fcpg0dC3R86FGMtkywr+zyzcg
	mc3uTFVWIbxRi4l1ViHRE7WRXZKKLv8Xw0kL337HPgqoOgC7zqxlDJ3cDQ3KlbOweWqHnLE8r5T
	glB2D49CJggwbdmRrBxJRGfgvYu8n5WgA2pkh1GwEvzU+T6x9vAZ6JBt5DSYiett1glWpAXN8dP
	O/nyKvqa0spIBvdFL683qiu7FJ5AliVVlPDiO53kcpw+ClwOhAKJKCPiOGY2rCLIY/RF1/HlNma
	cyMdKcRe+V8HH44Aumy7PB4TLVvhZmwTBZdvQykocOHnLiF1cq/d6uTQMYeIQ7e4YNlZF0=
X-Received: by 2002:a05:701a:c90a:b0:143:298e:459f with SMTP id a92af1059eb24-14c9e76fc1amr1287094c88.42.1790731306892;
        Tue, 29 Sep 2026 18:21:46 -0700 (PDT)
Received: from localhost.localdomain ([2603:8001:5f01:8bab:3481:cbb6:f339:9e4e])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-14c5dd65a45sm2334704c88.0.2026.09.29.18.21.45
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 29 Sep 2026 18:21:45 -0700 (PDT)
From: Artem Dinaburg <artem@trailofbits.com>
To: stable@vger.kernel.org
Cc: Artem Dinaburg <artem@trailofbits.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	Shay Drory <shayd@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Mark Bloch <mbloch@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	erezsh@mellanox.com
Subject: [PATCH 6.6.y] net/mlx5e: Fix netif state handling
Date: Tue, 29 Sep 2026 21:21:41 -0400
Message-ID: <20260930012143.95721-1-artem@trailofbits.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Shay Drory <shayd@nvidia.com>

[ Upstream commit 3d5918477f94e4c2f064567875c475468e264644 ]

mlx5e_suspend cleans resources only if netif_device_present() returns
true. However, mlx5e_resume changes the state of netif, via
mlx5e_nic_enable, only if reg_state == NETREG_REGISTERED.
In the below case, the above leads to NULL-ptr Oops[1] and memory
leaks:

mlx5e_probe
 _mlx5e_resume
  mlx5e_attach_netdev
   mlx5e_nic_enable  <-- netdev not reg, not calling netif_device_attach()
  register_netdev <-- failed for some reason.
ERROR_FLOW:
 _mlx5e_suspend <-- netif_device_present return false, resources aren't freed :(

Hence, clean resources in this case as well.

[1]
BUG: kernel NULL pointer dereference, address: 0000000000000000
PGD 0 P4D 0
Oops: 0010 [#1] SMP
CPU: 2 PID: 9345 Comm: test-ovs-ct-gen Not tainted 6.5.0_for_upstream_min_debug_2023_09_05_16_01 #1
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.13.0-0-gf21b5a4aeb02-prebuilt.qemu.org 04/01/2014
RIP: 0010:0x0
Code: Unable to access opcode bytes at0xffffffffffffffd6.
RSP: 0018:ffff888178aaf758 EFLAGS: 00010246
Call Trace:
 <TASK>
 ? __die+0x20/0x60
 ? page_fault_oops+0x14c/0x3c0
 ? exc_page_fault+0x75/0x140
 ? asm_exc_page_fault+0x22/0x30
 notifier_call_chain+0x35/0xb0
 blocking_notifier_call_chain+0x3d/0x60
 mlx5_blocking_notifier_call_chain+0x22/0x30 [mlx5_core]
 mlx5_core_uplink_netdev_event_replay+0x3e/0x60 [mlx5_core]
 mlx5_mdev_netdev_track+0x53/0x60 [mlx5_ib]
 mlx5_ib_roce_init+0xc3/0x340 [mlx5_ib]
 __mlx5_ib_add+0x34/0xd0 [mlx5_ib]
 mlx5r_probe+0xe1/0x210 [mlx5_ib]
 ? auxiliary_match_id+0x6a/0x90
 auxiliary_bus_probe+0x38/0x80
 ? driver_sysfs_add+0x51/0x80
 really_probe+0xc9/0x3e0
 ? driver_probe_device+0x90/0x90
 __driver_probe_device+0x80/0x160
 driver_probe_device+0x1e/0x90
 __device_attach_driver+0x7d/0x100
 bus_for_each_drv+0x80/0xd0
 __device_attach+0xbc/0x1f0
 bus_probe_device+0x86/0xa0
 device_add+0x637/0x840
 __auxiliary_device_add+0x3b/0xa0
 add_adev+0xc9/0x140 [mlx5_core]
 mlx5_rescan_drivers_locked+0x22a/0x310 [mlx5_core]
 mlx5_register_device+0x53/0xa0 [mlx5_core]
 mlx5_init_one_devl_locked+0x5c4/0x9c0 [mlx5_core]
 mlx5_init_one+0x3b/0x60 [mlx5_core]
 probe_one+0x44c/0x730 [mlx5_core]
 local_pci_probe+0x3e/0x90
 pci_device_probe+0xbf/0x210
 ? kernfs_create_link+0x5d/0xa0
 ? sysfs_do_create_link_sd+0x60/0xc0
 really_probe+0xc9/0x3e0
 ? driver_probe_device+0x90/0x90
 __driver_probe_device+0x80/0x160
 driver_probe_device+0x1e/0x90
 __device_attach_driver+0x7d/0x100
 bus_for_each_drv+0x80/0xd0
 __device_attach+0xbc/0x1f0
 pci_bus_add_device+0x54/0x80
 pci_iov_add_virtfn+0x2e6/0x320
 sriov_enable+0x208/0x420
 mlx5_core_sriov_configure+0x9e/0x200 [mlx5_core]
 sriov_numvfs_store+0xae/0x1a0
 kernfs_fop_write_iter+0x10c/0x1a0
 vfs_write+0x291/0x3c0
 ksys_write+0x5f/0xe0
 do_syscall_64+0x3d/0x90
 entry_SYSCALL_64_after_hwframe+0x46/0xb0
 CR2: 0000000000000000
 ---[ end trace 0000000000000000  ]---

[ Backport to 6.6.y: added an internal suspend helper so probe unwind
  cleans resources without changing the registered-device suspend path. ]

Fixes: 2c3b5beec46a ("net/mlx5e: More generic netdev management API")
Signed-off-by: Shay Drory <shayd@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://lore.kernel.org/r/20240509112951.590184-2-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Assisted-by: LLM
Signed-off-by: Artem Dinaburg <artem@trailofbits.com>
---
Hi Greg, Sasha, and net maintainers,

I am working through the small CVE backports still missing from 6.6.y.
This one addresses CVE-2024-38608. It releases probe resources even when
register_netdev() failed before device-present state.

The fix is already present in 6.12.y, 6.18.y, and 7.2.y, but not in 6.6.y.
This fix also affects 6.1.y, which will need a separate backport; this
submission contains only the 6.6.y patch.
The target-specific adjustment is recorded in the bracketed note above.

Could you please queue it for 6.6.y?

CVE: CVE-2024-38608
Upstream: 3d5918477f94e4c2f064567875c475468e264644

AI assistance: An LLM helped identify, adapt, and validate this backport; I
reviewed the resulting code and validation evidence.

Thanks,
Artem Dinaburg

 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 97fa2095498cc8..bfccdcd7928be0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -6018,14 +6018,15 @@ static int mlx5e_resume(struct auxiliary_device *adev)
 	return 0;
 }
 
-static int mlx5e_suspend(struct auxiliary_device *adev, pm_message_t state)
+static int mlx5e_suspend_common(struct auxiliary_device *adev,
+				bool pre_netdev_reg)
 {
 	struct mlx5e_dev *mlx5e_dev = auxiliary_get_drvdata(adev);
 	struct mlx5e_priv *priv = mlx5e_dev->priv;
 	struct net_device *netdev = priv->netdev;
 	struct mlx5_core_dev *mdev = priv->mdev;
 
-	if (!netif_device_present(netdev)) {
+	if (!pre_netdev_reg && !netif_device_present(netdev)) {
 		if (test_bit(MLX5E_STATE_DESTROYING, &priv->state))
 			mlx5e_destroy_mdev_resources(mdev);
 		return -ENODEV;
@@ -6036,6 +6037,11 @@ static int mlx5e_suspend(struct auxiliary_device *adev, pm_message_t state)
 	return 0;
 }
 
+static int mlx5e_suspend(struct auxiliary_device *adev, pm_message_t state)
+{
+	return mlx5e_suspend_common(adev, false);
+}
+
 static int mlx5e_probe(struct auxiliary_device *adev,
 		       const struct auxiliary_device_id *id)
 {
@@ -6044,7 +6050,6 @@ static int mlx5e_probe(struct auxiliary_device *adev,
 	struct mlx5_core_dev *mdev = edev->mdev;
 	struct mlx5e_dev *mlx5e_dev;
 	struct net_device *netdev;
-	pm_message_t state = {};
 	struct mlx5e_priv *priv;
 	int err;
 
@@ -6107,7 +6112,7 @@ static int mlx5e_probe(struct auxiliary_device *adev,
 	return 0;
 
 err_resume:
-	mlx5e_suspend(adev, state);
+	mlx5e_suspend_common(adev, true);
 err_profile_cleanup:
 	profile->cleanup(priv);
 err_destroy_netdev:
-- 
2.39.5

