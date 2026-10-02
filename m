Received: from mail-dl2-f12.google.com (mail-dl2-f12.google.com [74.125.229.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B147739FCBC
	for <linux-rdma@vger.kernel.org>; Fri,  2 Oct 2026 20:44:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.229.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790973887; cv=none; b=mruNFtNCDKwYUad1tlZx05+uk5oHjGGH0ldYl+5nIB6hBSvBIxLTg6j3gvcGE3XXoUEtqOtPXzi3eka0gr8u1PQBLRBzmiBEP2M+xFVn1kB1RLEgGzRjN7SlxpfYySdEXkkeEg9KiSCHwdQdZxiDPsm1vui6ApV/GoR8vCYy574=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790973887; c=relaxed/simple;
	bh=hSIz4fihW3br2vB9KwOROSdJNfpPnljc28909L6iTQc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=u6lyqcb0x7jmNCxbye41X74uWmad6xkAMixJChwjAWdVbwlf3DISSDJ23iWL6eLO6bkN7TYTeMepQQ1H3/X5Hl1Cq/xhJAwShEW2/vNzEpvjCdcaDrFbm1rJ0MbgKC8i4zGckGzehOr7ipQkqYubZTav0oETNJpYrGEXcPGMDow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=trailofbits.com; spf=pass smtp.mailfrom=trailofbits.com; dkim=pass (2048-bit key) header.d=trailofbits.com header.i=@trailofbits.com header.b=jQsVdQsV; arc=none smtp.client-ip=74.125.229.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=trailofbits.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=trailofbits.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=trailofbits.com header.i=@trailofbits.com header.b="jQsVdQsV"
Received: by mail-dl2-f12.google.com with SMTP id a92af1059eb24-142dd04f7f2so19440c88.0
        for <linux-rdma@vger.kernel.org>; Fri, 02 Oct 2026 13:44:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=trailofbits.com; s=google; t=1790973884; x=1791578684; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=OEUMUqkSZXNw7bjqr2r2LczcRXo92A7RQr8KDcVvERk=;
        b=jQsVdQsVWc3c8yE2thqgmluoZvBX2TrWNc3UO05+/MpwQXaOvTRttMWO8ZMPg974qM
         9rOnxQDlZvHaGyO55KM60gMyQdBe8zEoQ3H1Qd0iEnK//WFts6Jd1AIqpcL0hy/QP0ol
         2TSuJBbivop5R90MX5n09dsmqjC4t+OhdjN3U6P6jTyCnSQdUJZDU4WdEejFLLJsbZpE
         ArxDrkgAgjVVfvc2ZTsUsObJNfgV5Bba90gcm4/JpTI0GrGc9G12QxyM4u80CpcrxJ6W
         nIBp/OAb3M9hU9+SEuGmcY+O/wO6QJwoTkRKXX/HbarQ77WaiyzBGt/GXK2bE4UCaD8E
         LpIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790973884; x=1791578684;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=OEUMUqkSZXNw7bjqr2r2LczcRXo92A7RQr8KDcVvERk=;
        b=2Ijiwx9egjbdqsMbxUvzT/kZdBiq0+iD3qTT5oU91Jo8tgeefGsw1Ly1Qnfi8ANTfE
         XZAN0A2gFfEX9WMISmjCyWYvbNUd8NTq0ZYdGZmWph7wh+Y6EYufgKox1A123Fl1eHeq
         luXQ3lBzi90QxE+CkzO8l0n1s1MEHMA2iK6H4PAthC7zHFYfSudmGuRD0s8iLgY+waFX
         bo1qp1Q4pKctgQd5wwv1nzB8KElryikSMD49PAIM8iiK3IA8XipS1VxN8wKvrVfj0Ucu
         DN11P/KRZIQrNyQTDjTgrv+HpZR5nXm6XIGtQ/wFDB+nToNbnYXfw5tyreC5TGDCzzGX
         ZYSw==
X-Forwarded-Encrypted: i=1; AKwUvBxXK09ZPpfFnYDnXFXhjOXS4GPiS6VcPLO6rXolD0zM8G4w5IbgbqnmDCUziDBL7RWCFJx6R/XHkHWE@vger.kernel.org
X-Gm-Message-State: AFq9FYLFzBUVURTYAIQyoM0k66yq1NBCRDBzmrRcXmRiLm5kpp77pOHz
	Mb5/tjaYI7rOiImghw067Y9/d4U9E4jy63WPV1mAuxRWbErecWiMJowVAw9iJZ6yFRo=
X-Gm-Gg: AYBFou20++DxBZNDgRarSJ2qBiGvJynBvO2fzeKt9oUE9KMLjQtw7UFnWYT43R/jSDR
	0onc/c3W8Qkl+gFUnHCEfu9xALAwtAV6RWcOpph2Qwp2AX2QiaOoevmzJkJk7rFVvvdLXBbSRBh
	ZieklF64dTiRnu5QGRAdrDdV9EhqAfmomrv2GlEe9jVwDb9aO+1Pr0j782cEMgnH5h0ErbZDAtX
	QRJKqeSVUcw9ce2JSQVZSzpsWg8/PU0FiRdgS0RFkPpfbw3iTMPap2fd0ke2IkygJXZQVRo+GjF
	tD9r+X50OOU1P21SjUd5Njn+NWaJWDC/QTLP4xvFNWpYY0ZxujlDQoz+X/I5BSDGMIf+CXfdDjj
	rgvJaASXAZ4bFTzPLv+U9o/qKw0IYhOAD9eAFss/w3GVDpFfJR1f4q/JWoXOkNZfS9XBJ9H7Sjv
	hLUqq3hVGtzX1jbWfUNvmMFPgqmTFeLw0Q7E584t1jLiRdoEFNAnEcqpN8MXOUm7Ee1kgT0Iyb/
	+iFzczswAWJC19tOPBRhUldlbf8ihBFfBBNQ5btB59VcFTOlO5lTFA4TDPrYbkTP2xY3Jg=
X-Received: by 2002:a05:701b:4190:10b0:148:dfc9:425d with SMTP id a92af1059eb24-14f5d1b9c76mr4478202c88.46.1790973883634;
        Fri, 02 Oct 2026 13:44:43 -0700 (PDT)
Received: from localhost.localdomain ([2603:8001:5f01:8bab:a1e3:ffe2:b35a:69a4])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-151fa74fa1csm23201c88.1.2026.10.02.13.44.42
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 02 Oct 2026 13:44:43 -0700 (PDT)
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
	Eric Dumazet <edumazet@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Mark Bloch <mbloch@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Andrew Lunn <andrew+netdev@lunn.ch>
Subject: [PATCH 6.1.y] net/mlx5e: Fix netif state handling
Date: Fri,  2 Oct 2026 16:44:37 -0400
Message-ID: <20261002204438.26168-1-artem@trailofbits.com>
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

[ Backport to 6.1.y: added an internal suspend helper so probe unwind
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

I am working through the small CVE backports still missing from 6.1.y.
This one addresses CVE-2024-38608. It releases probe resources even when
register_netdev() failed before device-present state.

The corresponding 6.6.y backport is already in the 6.6.y stable queue.
The fix is already present in 6.12.y, 6.18.y, and 7.2.y, but not
in 6.1.y.
The target-specific adjustment is recorded in the bracketed note above.

Could you please queue it for 6.1.y?

CVE: CVE-2024-38608
Upstream: 3d5918477f94e4c2f064567875c475468e264644

AI assistance: An LLM helped identify, adapt, and validate this backport; I
reviewed the resulting code and validation evidence.

Thanks,
Artem Dinaburg

 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 2d0b57583ea35c..d26c36479ee915 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -5896,13 +5896,14 @@ static int mlx5e_resume(struct auxiliary_device *adev)
 	return 0;
 }
 
-static int mlx5e_suspend(struct auxiliary_device *adev, pm_message_t state)
+static int mlx5e_suspend_common(struct auxiliary_device *adev,
+				bool pre_netdev_reg)
 {
 	struct mlx5e_priv *priv = auxiliary_get_drvdata(adev);
 	struct net_device *netdev = priv->netdev;
 	struct mlx5_core_dev *mdev = priv->mdev;
 
-	if (!netif_device_present(netdev)) {
+	if (!pre_netdev_reg && !netif_device_present(netdev)) {
 		if (test_bit(MLX5E_STATE_DESTROYING, &priv->state))
 			mlx5e_destroy_mdev_resources(mdev);
 		return -ENODEV;
@@ -5913,6 +5914,11 @@ static int mlx5e_suspend(struct auxiliary_device *adev, pm_message_t state)
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
@@ -5920,7 +5926,6 @@ static int mlx5e_probe(struct auxiliary_device *adev,
 	const struct mlx5e_profile *profile = &mlx5e_nic_profile;
 	struct mlx5_core_dev *mdev = edev->mdev;
 	struct net_device *netdev;
-	pm_message_t state = {};
 	struct mlx5e_priv *priv;
 	int err;
 
@@ -5969,7 +5974,7 @@ static int mlx5e_probe(struct auxiliary_device *adev,
 	return 0;
 
 err_resume:
-	mlx5e_suspend(adev, state);
+	mlx5e_suspend_common(adev, true);
 err_profile_cleanup:
 	profile->cleanup(priv);
 err_devlink_cleanup:
-- 
2.39.5

