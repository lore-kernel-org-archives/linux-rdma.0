Received: from mail-dy1-f173.google.com (mail-dy1-f173.google.com [74.125.82.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFF4F47FAFF
	for <linux-rdma@vger.kernel.org>; Wed, 14 Oct 2026 19:17:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792005469; cv=none; b=l9hKo40V8JswokZcPJIzPiVjwaJM3cZDawad3dVlQ6uOv+wFj7b1DcL5yT8MZXNyJlIw7ZWcL/0q66nIUBshmxtkW/KcW7+hwkBAXTJBu7fZ5+xaNuzMNPsVwedvGzSA3Jr6Fj5JHAHm6IYcpUf9lsEWF1Vit9GNL3Sd2emWZEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792005469; c=relaxed/simple;
	bh=8ch9zPHrRhoJf/XXXqGGMB796PWAdgWE+lKNbAT8TaI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xr/UaSTrkznHZMTrCCwtD9CaopZ2pbj4ST7zKypiIazIMiR6GEGj1WIWKxZL6I+1sZz6BsHy3Klcmu0m7RDDZCKbav4dVZ9VOVJeqODrSAw6ZCTsbvJrAJ4zXyZ6s0u2fnrifRWtqbPaMiQb31+moK+UQdENC0kT6qQYmz1eNnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=trailofbits.com; spf=pass smtp.mailfrom=trailofbits.com; dkim=pass (2048-bit key) header.d=trailofbits.com header.i=@trailofbits.com header.b=EmRoe4N9; arc=none smtp.client-ip=74.125.82.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=trailofbits.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=trailofbits.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=trailofbits.com header.i=@trailofbits.com header.b="EmRoe4N9"
Received: by mail-dy1-f173.google.com with SMTP id 5a478bee46e88-30b6dad2382so10377857eec.0
        for <linux-rdma@vger.kernel.org>; Wed, 14 Oct 2026 12:17:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=trailofbits.com; s=google; t=1792005467; x=1792610267; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=cySd0bAdXDIqYUaxbcOqN6XcQ5s/toN0byY3dnGYBUg=;
        b=EmRoe4N9jThwm9vfwHOSSEdj+JkwFYNZbhMHqYgMssxHgmsqtGrmFhdVXGPYtTQQo+
         l86Cs5EMogZR1JYMH5mdrixdvSOApfVtzc55HQmQv5ydnehRkKuDaEMBLpRr0GqTynCo
         36RUWRZ8lzFOTaoghRUfiK4NvA7zDW3UKwzbU9bLJ2PbCtDx9ZQrgIWkk/iUEztae+6R
         ITEn589MyUn+qJhTTc0p/pXKzX6b5S1lHv820+glJ8LmNVFog/IcSzHYr1ZRwBuE7quj
         euUu8WO+E61f9ci/QWyTQ2Jp7l5BtEZUZRis3CUvOI7fTkK5TPdkQ0MqDMZR7nR6SD8n
         BgVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792005467; x=1792610267;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=cySd0bAdXDIqYUaxbcOqN6XcQ5s/toN0byY3dnGYBUg=;
        b=JntUdxEEU1i2k0Q7fa9Cki086EIIP6mvlGGI6eidBTvVWHpCLabufTZ9ZHzoKJZ2W4
         4tv3xdZFi7tmxaTRz0ULHisebgh7KKoet/3tp1GWtr1jIAnsgmm8unlON67OY/seBz1Q
         VHvW7unQ50BRekMqT6VLsyq/UlYCW//jkjmtY5+aKsvC86vrLQNV/kxjy9x1ha/cgjuS
         FvjiKeZ3TeD+SIU5/wzMhIiH4XKaF1MXe0KdYiPhb3DuJeDMUbo7xfT0UrLWB48OQg2L
         ZOXWA/TQ1/wyyJ4Vlt1FYttGC4wGKfzft7hcQAMG+N3Ax+/oWlvSSKQdv84waTM8Hm+G
         y2vg==
X-Forwarded-Encrypted: i=1; AKwUvBwuvKkYYgGMmS0E3LM5UeCadcXZJAlQV5GFR85I5fb3C4uh1nKxqw9vwH/nyV9xcovIjSnll1jXWR1r@vger.kernel.org
X-Gm-Message-State: AFq9FYJ8ilkVF4g6ulneeIFvz07b9LlEmZGETgOvKcRJacbkS8Xn5V34
	qyKIV/ajYiJBjPfB8Ko5achQpUdta7CFhleyUiJ5h8EYsSmJPQ3uE25rMvXM5OnCdCK9E2ecc5u
	n8JaJaB/3Fw==
X-Gm-Gg: AYBFou3Vn2IDzI+A/KE48T2VpK8Rxue6J2doGNEh0qNzHGqcO3uuaLlBOElno17TfI7
	4Osmbi1aMkCU1c3ZUNC1SeJT83XsTJwJvpNoKYMKeXmv9duz7s3jjZKSsRm347KMwt6AXb/hBuK
	0/loH3RLfruBVMDlbXC5ZkhhEmoTgOw2GPf6KfD5JrBxTqlKHXVjYnROedf4OTqf4RKpsB3edGX
	KaicrSpSOS0S2h2LIMsa/XoaDIck+MeqirtUVrbPKh9dKa4pHzZrzD/e8NoZqy8AqboiWJm3L52
	HujhcX0TufN1QSc3UL7BIew8fOJMs/csd8EKmMNtPaUQPBQ242nctxKP5rvzu2aXTefaUWjRn/U
	axfsUNzMc69GdDwjj9+L8GgMqbIQ6vEiJmq46UtvQs5pGdTUhOaVyPC3KyTCQggRBW1nEBLCDJy
	JMBOGN8L8g0NHmCrNzEC20J0SeGvQvShsELjCKTDYkJ7/HMEThvXn4W3wsRkjN+ML55zQfxT8gZ
	rSWA72wUuNlhskbyB0o0wYHSMhZ/Wea+0FNBaqayfZgNAUqJY9+DHKPV3U8CMzEAqE10/8=
X-Received: by 2002:a05:701b:2810:b0:143:2701:9198 with SMTP id a92af1059eb24-16a610c9c0fmr21861153c88.36.1792005466629;
        Wed, 14 Oct 2026 12:17:46 -0700 (PDT)
Received: from localhost.localdomain ([2603:8001:5f01:8bab:39d1:d8de:aae7:23dd])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1746482c978sm28966433c88.13.2026.10.14.12.17.44
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 14 Oct 2026 12:17:45 -0700 (PDT)
From: Artem Dinaburg <artem@trailofbits.com>
To: stable@vger.kernel.org
Cc: andrew+netdev@lunn.ch,
	davem@davemloft.net,
	edumazet@kernel.org,
	kuba@kernel.org,
	leon@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	mbloch@nvidia.com,
	netdev@vger.kernel.org,
	pabeni@redhat.com,
	saeedm@nvidia.com,
	shayd@nvidia.com,
	tariqt@nvidia.com
Subject: [PATCH 6.6.y 2/2] net/mlx5e: Pass netdev to mlx5e_destroy_netdev instead of priv
Date: Wed, 14 Oct 2026 15:17:37 -0400
Message-ID: <20261014191738.24034-3-artem@trailofbits.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261014191738.24034-1-artem@trailofbits.com>
References: <20261014191738.24034-1-artem@trailofbits.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Saeed Mahameed <saeedm@nvidia.com>

[ Upstream commit 4ef8512e1427111f7ba92b4a847d181ff0aeec42 ]

mlx5e_priv is an unstable structure that can be memset(0) if profile
attaching fails.

Pass netdev to mlx5e_destroy_netdev() to guarantee it will work on a
valid netdev.

On mlx5e_remove: Check validity of priv->profile, before attempting
to cleanup any resources that might be not there.

This fixes a kernel oops in mlx5e_remove when switchdev mode fails due
to change profile failure.

$ devlink dev eswitch set pci/0000:00:03.0 mode switchdev
Error: mlx5_core: Failed setting eswitch to offloads.
dmesg:
workqueue: Failed to create a rescuer kthread for wq "mlx5e": -EINTR
mlx5_core 0012:03:00.1: mlx5e_netdev_init_profile:6214:(pid 37199): mlx5e_priv_init failed, err=-12
mlx5_core 0012:03:00.1 gpu3rdma1: mlx5e_netdev_change_profile: new profile init failed, -12
workqueue: Failed to create a rescuer kthread for wq "mlx5e": -EINTR
mlx5_core 0012:03:00.1: mlx5e_netdev_init_profile:6214:(pid 37199): mlx5e_priv_init failed, err=-12
mlx5_core 0012:03:00.1 gpu3rdma1: mlx5e_netdev_change_profile: failed to rollback to orig profile, -12

$ devlink dev reload pci/0000:00:03.0 ==> oops

BUG: kernel NULL pointer dereference, address: 0000000000000370
PGD 0 P4D 0
Oops: Oops: 0000 [#1] SMP NOPTI
CPU: 15 UID: 0 PID: 520 Comm: devlink Not tainted 6.18.0-rc5+ #115 PREEMPT(voluntary)
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-2.fc40 04/01/2014
RIP: 0010:mlx5e_dcbnl_dscp_app+0x23/0x100
RSP: 0018:ffffc9000083f8b8 EFLAGS: 00010286
RAX: ffff8881126fc380 RBX: ffff8881015ac400 RCX: ffffffff826ffc45
RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff8881035109c0
RBP: ffff8881035109c0 R08: ffff888101e3e838 R09: ffff888100264e10
R10: ffffc9000083f898 R11: ffffc9000083f8a0 R12: ffff888101b921a0
R13: ffff888101b921a0 R14: ffff8881015ac9a0 R15: ffff8881015ac400
FS:  00007f789a3c8740(0000) GS:ffff88856aa59000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000370 CR3: 000000010b6c0001 CR4: 0000000000370ef0
Call Trace:
 <TASK>
 mlx5e_remove+0x57/0x110
 device_release_driver_internal+0x19c/0x200
 bus_remove_device+0xc6/0x130
 device_del+0x160/0x3d0
 ? devl_param_driverinit_value_get+0x2d/0x90
 mlx5_detach_device+0x89/0xe0
 mlx5_unload_one_devl_locked+0x3a/0x70
 mlx5_devlink_reload_down+0xc8/0x220
 devlink_reload+0x7d/0x260
 devlink_nl_reload_doit+0x45b/0x5a0
 genl_family_rcv_msg_doit+0xe8/0x140

Fixes: c4d7eb57687f ("net/mxl5e: Add change profile method")
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Reviewed-by: Shay Drori <shayd@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/20260108212657.25090-4-saeed@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Assisted-by: LLM
Signed-off-by: Artem Dinaburg <artem@trailofbits.com>
---
Hi,

Please consider this backport of the fix for CVE-2026-23035 to 6.6.y.

The code changes are identical to upstream. Apply this series after the
pending 6.6.y backport of 3d5918477f94 (net/mlx5e: Fix netif state
handling), which fixes registration-failure cleanup.

The complete fix is already present in 6.12.y, 6.18.y and 7.2.y.

Build-tested only as part of a cumulative 6.6.y series on x86_64
(allmodconfig, CONFIG_WERROR=y), changed objects only; no runtime testing.

Thanks,
Artem Dinaburg

 drivers/net/ethernet/mellanox/mlx5/core/en.h      |    2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c |   15 +++++++++------
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c  |    4 ++--
 3 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index ee671e16f344cd160a65d2a84dc82d210af339da..0b10e86b508cab9091177dec46051e3e8593ed2a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -1202,7 +1202,7 @@ struct net_device *
 mlx5e_create_netdev(struct mlx5_core_dev *mdev, const struct mlx5e_profile *profile);
 int mlx5e_attach_netdev(struct mlx5e_priv *priv);
 void mlx5e_detach_netdev(struct mlx5e_priv *priv);
-void mlx5e_destroy_netdev(struct mlx5e_priv *priv);
+void mlx5e_destroy_netdev(struct net_device *netdev);
 int mlx5e_netdev_change_profile(struct mlx5e_priv *priv,
 				const struct mlx5e_profile *new_profile, void *new_ppriv);
 void mlx5e_netdev_attach_nic_profile(struct mlx5e_priv *priv);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index a296a73771c07fa00427ea072d9f9e26379ff8d7..191a152d62b6c1f67961e37dc4ee84cd4c26f1be 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -5984,11 +5984,12 @@ void mlx5e_netdev_attach_nic_profile(struct mlx5e_priv *priv)
 	mlx5e_netdev_change_profile(priv, &mlx5e_nic_profile, NULL);
 }
 
-void mlx5e_destroy_netdev(struct mlx5e_priv *priv)
+void mlx5e_destroy_netdev(struct net_device *netdev)
 {
-	struct net_device *netdev = priv->netdev;
+	struct mlx5e_priv *priv = netdev_priv(netdev);
 
-	mlx5e_priv_cleanup(priv);
+	if (priv->profile)
+		mlx5e_priv_cleanup(priv);
 	free_netdev(netdev);
 }
 
@@ -6116,7 +6117,7 @@ err_resume:
 err_profile_cleanup:
 	profile->cleanup(priv);
 err_destroy_netdev:
-	mlx5e_destroy_netdev(priv);
+	mlx5e_destroy_netdev(netdev);
 err_devlink_port_unregister:
 	mlx5e_devlink_port_unregister(mlx5e_dev);
 err_devlink_unregister:
@@ -6134,13 +6135,15 @@ static void mlx5e_remove(struct auxiliary_device *adev)
 	pm_message_t state = {};
 
 	mlx5_core_uplink_netdev_set(mdev, NULL);
-	mlx5e_dcbnl_delete_app(priv);
+
+	if (priv->profile)
+		mlx5e_dcbnl_delete_app(priv);
 	unregister_netdev(netdev);
 	mlx5e_suspend(adev, state);
 	/* Avoid cleanup if profile rollback failed. */
 	if (priv->profile)
 		priv->profile->cleanup(priv);
-	mlx5e_destroy_netdev(priv);
+	mlx5e_destroy_netdev(netdev);
 	mlx5e_devlink_port_unregister(mlx5e_dev);
 	mlx5e_destroy_devlink(mlx5e_dev);
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index 656a7b65f4c7bb906979a4fa9f018d5567a8dfd8..380898125224e05661ebae3540c890b4248a87af 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -1539,7 +1539,7 @@ err_cleanup_profile:
 	priv->profile->cleanup(priv);
 
 err_destroy_netdev:
-	mlx5e_destroy_netdev(netdev_priv(netdev));
+	mlx5e_destroy_netdev(netdev);
 	return err;
 }
 
@@ -1594,7 +1594,7 @@ mlx5e_vport_rep_unload(struct mlx5_eswitch_rep *rep)
 	mlx5e_rep_vnic_reporter_destroy(priv);
 	mlx5e_detach_netdev(priv);
 	priv->profile->cleanup(priv);
-	mlx5e_destroy_netdev(priv);
+	mlx5e_destroy_netdev(netdev);
 free_ppriv:
 	kvfree(ppriv); /* mlx5e_rep_priv */
 }
