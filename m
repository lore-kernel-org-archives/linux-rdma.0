Received: from mail-dl1-f52.google.com (mail-dl1-f52.google.com [74.125.82.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CDE847A883
	for <linux-rdma@vger.kernel.org>; Wed, 14 Oct 2026 19:17:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792005467; cv=none; b=QRIG1XdbgRy3YJGco3qjnF071inP8JK5AqnMK9osSrOxvlSQUxMjsBasFz4J8SCwHEtJK2UqefpvVN7ts+tWlRDAX217LJSdzWU6EsJFf54d5f/+OF8jhd3k2SKM+6gqR9JzJ3vNw1ZnH0xAD0rXKsNWj0CKFqpn1hw1P4WffSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792005467; c=relaxed/simple;
	bh=BzvXDsUbUrOErUuhtGlLs+1T+RiijvGHxMTJGVit9j8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oKhLn7hSwSLy/6/ZAlX3AgXr1FYQbFj7ZZ6RJBrECo1ib3/2i4OXsizc4BiYmPCiK2wQZK+6k18/N/inwu9gvtgjJlsFTKf7FA9a4g7ufwM/aGdX93cBzf5CWNuSoh36pe0E8xYn2dEnx/253HbNFOvFNvjaJM+ZmJowcNiu9II=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=trailofbits.com; spf=pass smtp.mailfrom=trailofbits.com; dkim=pass (2048-bit key) header.d=trailofbits.com header.i=@trailofbits.com header.b=TK/lsanZ; arc=none smtp.client-ip=74.125.82.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=trailofbits.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=trailofbits.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=trailofbits.com header.i=@trailofbits.com header.b="TK/lsanZ"
Received: by mail-dl1-f52.google.com with SMTP id a92af1059eb24-1438d9363fbso412515c88.0
        for <linux-rdma@vger.kernel.org>; Wed, 14 Oct 2026 12:17:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=trailofbits.com; s=google; t=1792005465; x=1792610265; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xfWnkTj9bNHP7QujAsZEILR3pC3x+cnZQ9Gzj4eqTsM=;
        b=TK/lsanZQcqIf5je98ZeO0FvvY35gx2vsfanUfxCe24vyxsC5Al+QPQLCLuRBREqtB
         8gjJbRjbzkTfrBbfTj9AWileoh0Vs/fH93REdQ7gVWa0FbvhRCccEAV04MZ+i6YAL4u4
         pA6UwBiTdgwzPlmZsmEjCmQ6wQYZ6W/lnFaPetQZjfGEe1oxf3CuEQOVrr0SvaBMxZAY
         9+hwtNANGYLkqsOfsAfjUEJgpxBR7ou2TD8DadWX0CGUuUDOR8CdwcVE3raY1FD7TPp4
         IOrnALZB74j5yYcuSB/66ZvyjIp8n5LHANUPseobv1ETBRZO1dnCCHlp4TWsShVjnD2P
         oncA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792005465; x=1792610265;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=xfWnkTj9bNHP7QujAsZEILR3pC3x+cnZQ9Gzj4eqTsM=;
        b=Q0my0jpSmlCQYJ+jk2uUsOjfC/l/9q2PjnKq4v9Dy29Fv4k2NtyLgtIhc4c+qmWoJs
         C8O18qVZlv3zcFiHNLu0NR8/1RuqpIOUMJxfSSaUbycdDg1Aex49tF3ZRrGrvkQwgXan
         vG5xm16TKi6ir3PI7kAqxs1dSMvjfr7Giaguikdsqc2v5IZeXK+A+T3+NUr9t2WZWUPR
         lEXv8ZZvCS3ET2cRnQfhJEefx+9qVsAvW2QdFK8yRfzC8mx7DICunaNh72AxJhiyQx7w
         uVQEUlSnsJLEPtHlUuiCkBcP5bXBwI8p8ScpU9AbBJBG/MwOGIs7WFxTO5HAJHnWofWp
         Pj0Q==
X-Forwarded-Encrypted: i=1; AKwUvBxAmEVxIgjOq8Ps24Lnqr5FZwlCuNFS0prSqQvdp5fDNoTAh9IEzfCxKYu5Lgy6aleyNmntHYcZnL+3@vger.kernel.org
X-Gm-Message-State: AFq9FYLoj/Gm5rZHX6xtqClDNUoM3aFQ4ZAuZex2MPxvpdHX+ozr/fOk
	YKcDXXXp7/b/uGX3jmsZpmUVPDELFwejfw52qOPJ/7iY3N9+8s1SHDndKj6fsLszZpE=
X-Gm-Gg: AYBFou3Yr6SJrgddtpBd9OT3M/3CkXDlTGSAIY+2sfx7C4VIG0uJYnmqOf5BKtWWnrR
	9I/lxCMT+IVSIwa0V5FoZd4YJKzqwPdfa3c6nIySlMnCUKm/hJHT9i3k2+7fYFD4b4L0vxyKjZh
	GHtsHYZ/Mh1SFD8HEsvPVT9xidfwFvapAGHrLTPhWxRm4cWpCGRLoUOp/AsJoWyJZiC/wYWSsiP
	FqFKIh1id0wSLtUrkJLZG+9sjEqb+edHCrIZrKG0i3Zz4S2SdiaHSrriBs3wj3Csw0hTAdSuTwb
	sYpobjTD2OWWFAzl1tHde2Z2TWswGYSEjCBKB1fHXINUQfz66DwJvsMn90QHU+pGF0ed7wx4qDJ
	tNfKegoWHybPY93SrhKqopfYIquJB3A3mDoO3HnxHFVvU/PNJCAe0ameGB1BGUbH0Ch7f/dXj8z
	pVa09OMgn3vLFRCjJnr/8PlHFbZ5k9Zr+N4KDy3oWJDK3uL2GEMX2IEkva5Q9zju1QqnSKIGYkE
	AuGvMrNoAymvrh1boEIfjrEWZfzZLbY6U+Cm8QTotQzHD48X5hLZ8H+ETJ+YZE4XWuLT50Ozig3
	/s4f2A==
X-Received: by 2002:a05:7022:b0c6:b0:16c:d83b:a72d with SMTP id a92af1059eb24-16cd83ba76bmr17326351c88.0.1792005464593;
        Wed, 14 Oct 2026 12:17:44 -0700 (PDT)
Received: from localhost.localdomain ([2603:8001:5f01:8bab:39d1:d8de:aae7:23dd])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1746482c978sm28966433c88.13.2026.10.14.12.17.42
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 14 Oct 2026 12:17:43 -0700 (PDT)
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
	tariqt@nvidia.com
Subject: [PATCH 6.6.y 1/2] net/mlx5e: Don't store mlx5e_priv in mlx5e_dev devlink priv
Date: Wed, 14 Oct 2026 15:17:36 -0400
Message-ID: <20261014191738.24034-2-artem@trailofbits.com>
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

[ Upstream commit 123eda2e5b1638e298e3a66bb1e64a8da92de5e1 ]

mlx5e_priv is an unstable structure that can be memset(0) if profile
attaching fails, mlx5e_priv in mlx5e_dev devlink private is used to
reference the netdev and mdev associated with that struct. Instead,
store netdev directly into mlx5e_dev and get mdev from the containing
mlx5_adev aux device structure.

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

BUG: kernel NULL pointer dereference, address: 0000000000000520
 #PF: supervisor read access in kernel mode
 #PF: error_code(0x0000) - not-present page
PGD 0 P4D 0
Oops: Oops: 0000 [#1] SMP NOPTI
CPU: 3 UID: 0 PID: 521 Comm: devlink Not tainted 6.18.0-rc5+ #117 PREEMPT(voluntary)
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-2.fc40 04/01/2014
RIP: 0010:mlx5e_remove+0x68/0x130
RSP: 0018:ffffc900034838f0 EFLAGS: 00010246
RAX: ffff88810283c380 RBX: ffff888101874400 RCX: ffffffff826ffc45
RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000000
RBP: ffff888102d789c0 R08: ffff8881007137f0 R09: ffff888100264e10
R10: ffffc90003483898 R11: ffffc900034838a0 R12: ffff888100d261a0
R13: ffff888100d261a0 R14: ffff8881018749a0 R15: ffff888101874400
FS:  00007f8565fea740(0000) GS:ffff88856a759000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000520 CR3: 000000010b11a004 CR4: 0000000000370ef0
Call Trace:
 <TASK>
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

Fixes: ee75f1fc44dd ("net/mlx5e: Create separate devlink instance for ethernet auxiliary device")
Fixes: c4d7eb57687f ("net/mxl5e: Add change profile method")
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Link: https://patch.msgid.link/20260108212657.25090-3-saeed@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Assisted-by: LLM
[ Backport to 6.6.y: Derive mdev from the auxiliary device in the
  older remove path. The auxiliary device only binds after successful
  netdev registration, and the target uplink profile-switch paths
  retain that registration, so remove performs one unregister without
  upstream's NETREG_REGISTERED conditional. Use that hardware owner
  when clearing the uplink pointer if profile rollback clears priv.
  Apply after the pending 6.6.y backport of 3d5918477f94 (net/mlx5e:
  Fix netif state handling), which makes probe registration-failure
  unwind release resources even before netif_device_attach(). Patch 2
  of this series ("net/mlx5e: Pass netdev to mlx5e_destroy_netdev instead
  of priv") uses netdev-based destruction. ]
Signed-off-by: Artem Dinaburg <artem@trailofbits.com>
---
Hi,

Please consider this backport of the fix for CVE-2026-22996 to 6.6.y.

The code changes follow upstream, except the older remove path derives
mdev from the auxiliary device and omits the newer registration-state
branches; see the backport note.

The complete fix is already present in 6.12.y, 6.18.y and 7.2.y.

Build-tested only as part of a cumulative 6.6.y series on x86_64
(allmodconfig, CONFIG_WERROR=y), changed objects only; no runtime testing.

Thanks,
Artem Dinaburg

 drivers/net/ethernet/mellanox/mlx5/core/en.h      |    2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c |   22 ++++++++++++---------
 2 files changed, 14 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -947,3 +947,3 @@
 struct mlx5e_dev {
-	struct mlx5e_priv *priv;
+	struct net_device *netdev;
 	struct devlink_port dl_port;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -5998,4 +5998,4 @@
 	struct mlx5e_dev *mlx5e_dev = auxiliary_get_drvdata(adev);
-	struct mlx5e_priv *priv = mlx5e_dev->priv;
-	struct net_device *netdev = priv->netdev;
+	struct mlx5e_priv *priv = netdev_priv(mlx5e_dev->netdev);
+	struct net_device *netdev = mlx5e_dev->netdev;
 	struct mlx5_core_dev *mdev = edev->mdev;
@@ -6022,6 +6022,7 @@
 {
+	struct mlx5_adev *edev = container_of(adev, struct mlx5_adev, adev);
 	struct mlx5e_dev *mlx5e_dev = auxiliary_get_drvdata(adev);
-	struct mlx5e_priv *priv = mlx5e_dev->priv;
-	struct net_device *netdev = priv->netdev;
-	struct mlx5_core_dev *mdev = priv->mdev;
+	struct mlx5e_priv *priv = netdev_priv(mlx5e_dev->netdev);
+	struct net_device *netdev = mlx5e_dev->netdev;
+	struct mlx5_core_dev *mdev = edev->mdev;
 
@@ -6072,2 +6073,3 @@
 	SET_NETDEV_DEVLINK_PORT(netdev, &mlx5e_dev->dl_port);
+	mlx5e_dev->netdev = netdev;
 
@@ -6076,3 +6078,2 @@
 	priv = netdev_priv(netdev);
-	mlx5e_dev->priv = priv;
 
@@ -6127,9 +6128,12 @@
 {
+	struct mlx5_adev *edev = container_of(adev, struct mlx5_adev, adev);
 	struct mlx5e_dev *mlx5e_dev = auxiliary_get_drvdata(adev);
-	struct mlx5e_priv *priv = mlx5e_dev->priv;
+	struct net_device *netdev = mlx5e_dev->netdev;
+	struct mlx5e_priv *priv = netdev_priv(netdev);
+	struct mlx5_core_dev *mdev = edev->mdev;
 	pm_message_t state = {};
 
-	mlx5_core_uplink_netdev_set(priv->mdev, NULL);
+	mlx5_core_uplink_netdev_set(mdev, NULL);
 	mlx5e_dcbnl_delete_app(priv);
-	unregister_netdev(priv->netdev);
+	unregister_netdev(netdev);
 	mlx5e_suspend(adev, state);
