Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA5D44AD7FF;
	Mon, 31 Aug 2026 13:48:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184101; cv=none; b=ONBiBhU+8kxUdPYvSpej9PnySjARBXNKfzlylQk7zcYZZG5yvGYu3LqXLpACYraPPGCxbmE/HgbWY4kXVML7p26wSaLyvx5D+LGk8/edOBMbCCQjcPL0XePCa6yEoRkrSSfajY+Q/IPoCLatCQbMeRXreOu8SUHZFEDFCA/XZK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184101; c=relaxed/simple;
	bh=TAiQ7r/7xnu7xKb4vLQeLMIXM1OVfwNRTZ5NXrUayJQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TExOGbKG51gxNBgM0zvR6EsPPLlwEWwT/vkKFNjsg3/fNMBlRxU7hEjg8mXHDz5lKsS/6G/n60GFfY4pfuKrpQU0xEVzu0BtTCql2bo7HUv0652LUAr1tWClXMqsy/JuzZPqGztUcMF5h/534ZQC/DpKd1/J3QqG/TXvNuIFOOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TD4bzXbW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TD4bzXbW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED7E41F00A3D;
	Mon, 31 Aug 2026 13:48:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184099;
	bh=ONJkj7i+yNOLzKtS+gnGpMcgnhwwlHOAttLSUWjpYI0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TD4bzXbWs/ZlPqsOtDOIS9OJFT9EvuyaXtz8ZWjaRyLGx7C33FsabE5vAXjNGB3jV
	 0VTJhjUZpsvIeUuB5qJdTK8Jwkau9N43zd3v8UNjrL5yP5ZZXylTDog2h/INVlBksU
	 NOSMO8pET4rXfg8VooacDsvMnCxjhvNqDzaXTIzhLr0H47shlCIx+oXii8sRBfQAuC
	 QusMv0mBt9QVcJXLQ1fpxVrjA+zkhcpFrlQ6zZijohwxSHvdj4tGdZNz9RfTdTLPYK
	 Uwz1vyLtJnFfzhZ3uzv9uDhHvxnfOfwIGNRTEr5Efktz13YuAbZJQIe7XEMA2beR/N
	 wU82sZVlmYWiA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Moshe Shemesh <moshe@nvidia.com>,
	Akiva Goldberger <agoldberger@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	saeedm@nvidia.com,
	andrew+netdev@lunn.ch,
	davem@davemloft.net,
	edumazet@google.com,
	pabeni@redhat.com,
	netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] net/mlx5: Relax capability check for eswitch query paths
Date: Mon, 31 Aug 2026 09:28:38 -0400
Message-ID: <20260831133314.4125787-490-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Moshe Shemesh <moshe@nvidia.com>

[ Upstream commit 8ca32460815f6876095be8798adcf5ab982e94de ]

Several eswitch functions that only query other functions' HCA
capabilities or read cached vport state are guarded by the
vhca_resource_manager capability. This capability is required for
set_hca_cap operations but query_hca_cap of other functions only
requires the vport_group_manager capability.

Relax the capability check from vhca_resource_manager to
vport_group_manager in the following query-only paths:
- mlx5_esw_vport_caps_get() - queries other function general caps
- esw_ipsec_vf_query_generic() - queries other function ipsec cap
- mlx5_devlink_port_fn_migratable_get() - reads cached vport state
- mlx5_devlink_port_fn_roce_get() - reads cached vport state
- mlx5_devlink_port_fn_max_io_eqs_get() - queries other function caps
- mlx5_esw_vport_enable/disable() - vhca_id map/unmap

Functions that perform also set_hca_cap (migratable_set, roce_set,
max_io_eqs_set, esw_ipsec_vf_set_generic, esw_ipsec_vf_set_bytype)
retain the vhca_resource_manager requirement.

Signed-off-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Akiva Goldberger <agoldberger@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/20260506133239.276237-2-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The `git log -S` search finished, but it wasn’t very informative: for
both `mlx5_devlink_port_fn_max_io_eqs_get` and
`esw_ipsec_vf_query_generic`, the only hits were merge commits (e.g.
`5d324e5159d9e`), not the commits that originally added those functions
or the wrong `vhca_resource_manager` checks.

That fits the shallow checkout — we still can’t pin down when the bug
was introduced. What we do know is unchanged: both code paths are
present in 6.18.43 with the incorrect guards, and the fix exists on
other branches but not on current HEAD. The **YES** backport
recommendation still stands.

 .../net/ethernet/mellanox/mlx5/core/esw/ipsec.c    |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c  |  6 +++---
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c | 14 ++++++++------
 3 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/ipsec.c
index da10e04777cf7..1dbafeddd4b2f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/ipsec.c
@@ -12,7 +12,7 @@ static int esw_ipsec_vf_query_generic(struct mlx5_core_dev *dev, u16 vport_num,
 	void *hca_cap, *query_cap;
 	int err;
 
-	if (!MLX5_CAP_GEN(dev, vhca_resource_manager))
+	if (!MLX5_CAP_GEN(dev, vport_group_manager))
 		return -EOPNOTSUPP;
 
 	if (!mlx5_esw_ipsec_vf_offload_supported(dev)) {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index c38deabcb7b96..132592faaca60 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -799,7 +799,7 @@ static int mlx5_esw_vport_caps_get(struct mlx5_eswitch *esw, struct mlx5_vport *
 	void *hca_caps;
 	int err;
 
-	if (!MLX5_CAP_GEN(esw->dev, vhca_resource_manager))
+	if (!MLX5_CAP_GEN(esw->dev, vport_group_manager))
 		return 0;
 
 	query_ctx = kzalloc(query_out_sz, GFP_KERNEL);
@@ -934,7 +934,7 @@ int mlx5_esw_vport_enable(struct mlx5_eswitch *esw, struct mlx5_vport *vport,
 		vport->info.trusted = true;
 
 	if (!mlx5_esw_is_manager_vport(esw, vport_num) &&
-	    MLX5_CAP_GEN(esw->dev, vhca_resource_manager)) {
+	    MLX5_CAP_GEN(esw->dev, vport_group_manager)) {
 		ret = mlx5_esw_vport_vhca_id_map(esw, vport);
 		if (ret)
 			goto err_vhca_mapping;
@@ -978,7 +978,7 @@ void mlx5_esw_vport_disable(struct mlx5_eswitch *esw, struct mlx5_vport *vport)
 		arm_vport_context_events_cmd(esw->dev, vport_num, 0);
 
 	if (!mlx5_esw_is_manager_vport(esw, vport_num) &&
-	    MLX5_CAP_GEN(esw->dev, vhca_resource_manager))
+	    MLX5_CAP_GEN(esw->dev, vport_group_manager))
 		mlx5_esw_vport_vhca_id_unmap(esw, vport);
 
 	if (vport->vport != MLX5_VPORT_PF &&
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 8be0961cb6c7e..7a1c9ff6766e8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -4344,8 +4344,9 @@ int mlx5_devlink_port_fn_migratable_get(struct devlink_port *port, bool *is_enab
 		return -EOPNOTSUPP;
 	}
 
-	if (!MLX5_CAP_GEN(esw->dev, vhca_resource_manager)) {
-		NL_SET_ERR_MSG_MOD(extack, "Device doesn't support VHCA management");
+	if (!MLX5_CAP_GEN(esw->dev, vport_group_manager)) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Device doesn't support vport group management");
 		return -EOPNOTSUPP;
 	}
 
@@ -4420,8 +4421,9 @@ int mlx5_devlink_port_fn_roce_get(struct devlink_port *port, bool *is_enabled,
 	struct mlx5_eswitch *esw = mlx5_devlink_eswitch_nocheck_get(port->devlink);
 	struct mlx5_vport *vport = mlx5_devlink_port_vport_get(port);
 
-	if (!MLX5_CAP_GEN(esw->dev, vhca_resource_manager)) {
-		NL_SET_ERR_MSG_MOD(extack, "Device doesn't support VHCA management");
+	if (!MLX5_CAP_GEN(esw->dev, vport_group_manager)) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Device doesn't support vport group management");
 		return -EOPNOTSUPP;
 	}
 
@@ -4685,9 +4687,9 @@ mlx5_devlink_port_fn_max_io_eqs_get(struct devlink_port *port, u32 *max_io_eqs,
 	int err;
 
 	esw = mlx5_devlink_eswitch_nocheck_get(port->devlink);
-	if (!MLX5_CAP_GEN(esw->dev, vhca_resource_manager)) {
+	if (!MLX5_CAP_GEN(esw->dev, vport_group_manager)) {
 		NL_SET_ERR_MSG_MOD(extack,
-				   "Device doesn't support VHCA management");
+				   "Device doesn't support vport group management");
 		return -EOPNOTSUPP;
 	}
 
-- 
2.53.0

