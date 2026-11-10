Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=212.27.60.169
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794332086;
	b=iBH5i4Mq/Qb0ZuVKol/3hZpV/r3zcK0ibUOu8u+5pHK1xoUqXfJ8wxddpZAWy7jmLpBG
	 oSxVWKKa2BnXvUN+KWGspdIqdgGTr1j/0EFVAk/iLlthjklvZ3+p0xt76AW0zWahrxhfo
	 aNBtkt+ypTkiBeHyJ/lwzBWeA1iRgbeq7PYeVnUYXrJAAZf9xHirPVNMd6OPeRduGKZjG
	 TTh37TIyP4j4QRZPqiyrZWBAFqxLKPqXbzSCNNefOMB/n6MrIxROVEPXuZyFqIOyrB814
	 ZeXUkVvk3rQnosY8Epa7NAvfNrt0CFbFU/ehOMiXLgO2tIXK2ym74Ze445PndwPAScA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794332086;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=vO4Tn7QTnDU4Km+72Kp44nY2tcnUGHk5KPbCb+YdRi0=;
	b=rNNHMwipP8BjxXVtzq7SACDEI31DV7e9MIN5fTC7BhXetYiOadd8mJm7VWipKNU7fqPj
	 70IW3yQGRcaP6N6aAF3D5Uj0Wg7v+6XptS6mDJlt5wiFHBaOyCAAsEyCVTITtHybYZxFw
	 WmLO2EKpsDxbZ4LcJB5RrDELLdfr9R27vbIljon3jvhYTEzZDLfdf8IVucGehnV4iuoBZ
	 jwdJsdBPrAJp/57tIeWORqbfQSmTLAXb8+6y6h0mPqoQiVsRSiccbS4Yg6viWA7+0zSng
	 gVrmCNTC/6kwnVe1B2TtBM4nv1JYgjy+5K7wa7JDKLclf2PjtL1PWh6N5dTvhVz/2tA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=corp.free.fr;
	spf=pass smtp.mailfrom=corp.free.fr;
	dkim=pass header.d=corp.free.fr header.i=@corp.free.fr header.a=rsa-sha256 header.s=rcs header.b=E2PCJCDX;
	arc=none smtp.remote-ip=212.27.60.169
Received: from rcs.proxad.net (rcs.proxad.net [212.27.60.169])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B1CE606A325;
	Tue, 10 Nov 2026 17:34:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3B1CE606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=corp.free.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=corp.free.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=corp.free.fr header.i=@corp.free.fr header.a=rsa-sha256 header.s=rcs header.b=E2PCJCDX
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=corp.free.fr; s=rcs;
	t=1794332083; bh=0KFQezqHua8jJzNGEJztS+jhr4cMmggMzR70HI1cxrg=;
	h=From:To:Cc:Subject:Date:From;
	b=E2PCJCDXjLRpAzkObSGZoobU3qvwq7qhI6bSmbNXq9Kn87kzOlio8e9UAgDhkZNpE
	 mNQQ/GKhN6aJFRzCKI4Emhq8AwjLBJqArkeWC9/IciflVS4TvJ3yx2nEjY0KSW/RnJ
	 xIv9+Cx6zv0pCmTSUCoLRwJWat1Cs0iYa+nnjXiE6tiQQKrmh3saep3sqF9ZVVPQwK
	 1CXeWtObFOVmjtQn7F6DVXO72/b86Ovarj+rU7wXEHEt3vG/rqyxcSi+3oH1yyiqpR
	 0JcZSr0Hd0r1DTGJ+toN8m3YSzmgqXUjWNgQmNfMzTpHzNZd0oKO4/jC7sGCgyCtpo
	 0UefUl3UbOWWw==
Received: from lnxos-dev.home (82-66-150-212.subs.proxad.net [82.66.150.212])
	by rcs.proxad.net (Postfix) with ESMTPSA id B87FF44C1371;
	Tue, 10 Nov 2026 18:34:42 +0100 (CET)
From: Alexandre Cassen <acassen@corp.free.fr>
To: Saeed Mahameed <saeedm@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Tariq Toukan <tariqt@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>
Cc: Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Moshe Shemesh <moshe@nvidia.com>,
	Yevgeny Kliteynik <kliteyn@nvidia.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Gal Pressman <gal@nvidia.com>,
	Ethan Nelson-Moore <enelsonmoore@gmail.com>,
	netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org
Subject: [PATCH net] net/mlx5: HWS, fix flow meter release on FTE update
Date: Tue, 10 Nov 2026 18:34:35 +0100
Message-ID: <20261110173437.2471233-1-acassen@corp.free.fr>
X-Mailer: git-send-email 2.43.0
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

HWS has no duplicate match. When a flower filter is replaced in place,
its new rule waits as the pending duplicate of the old FTE. Once the
old rule goes, switch_to_pending_act_dests() copies the pending actions
over the FTE before update_fte() releases the actions of the old rule.
An HWS rule reads the base id of its meter action through a pointer to
the exe_aso of the FTE. That release takes the meter action of the new
rule instead.

When the two meters sit in different ASO objects, the old meter action
leaks. It keeps its ASO object referenced. The firmware then fails to
destroy that object and to free the PD of the meters, and its STC is
still in the pool when the context closes. The new meter action is
destroyed one release early, while a rule still points to it, and the
last release underflows its refcount:

  mlx5_core 0000:b1:00.1: mlx5_cmd_out_err:822:(pid 2641): DESTROY_GENERAL_OBJECT(0xa03) op_mod(0x24) failed, status bad resource(0x5), syndrome (0xeeda5c), err(-22)
  refcount_t: underflow; use-after-free.
  WARNING: lib/refcount.c:96 at refcount_dec_not_one+0x3f/0x60, CPU#43: tc/2641
  Call Trace:
   <TASK>
   mlx5_fs_put_hws_action.part.0+0x1a/0xa0 [mlx5_core]
   mlx5_fs_destroy_fs_actions+0xa8/0x110 [mlx5_core]
   mlx5_cmd_hws_delete_fte+0x49/0x90 [mlx5_core]
   del_hw_fte+0x209/0x320 [mlx5_core]
   mlx5_del_flow_rules+0x10b/0x260 [mlx5_core]
   __mlx5_eswitch_del_rule+0x5c/0x1b0 [mlx5_core]
   mlx5_eswitch_del_offloaded_rule+0x10/0x20 [mlx5_core]
   mlx5e_tc_rule_unoffload+0x4b/0x100 [mlx5_core]
   mlx5e_tc_unoffload_fdb_rules+0x35/0x80 [mlx5_core]
   mlx5e_tc_del_fdb_flow+0x2ca/0x310 [mlx5_core]
   mlx5e_tc_del_flow+0x5d/0x2d0 [mlx5_core]
   mlx5e_flow_put+0x3a/0x80 [mlx5_core]
   mlx5e_delete_flower+0x291/0x460 [mlx5_core]
   mlx5e_setup_tc_block_cb+0xc4/0x110 [mlx5_core]
   tc_setup_cb_destroy+0xcc/0x1b0
   fl_hw_destroy_filter+0xa1/0xe0 [cls_flower]
   __fl_delete+0x2d0/0x3d0 [cls_flower]
   fl_destroy+0xbd/0x160 [cls_flower]
   tcf_proto_destroy+0x3b/0x110
   tcf_proto_put+0x3d/0x70
   tc_del_tfilter+0x362/0x8f0
   rtnetlink_rcv_msg+0x384/0x460
   netlink_rcv_skb+0x61/0x120
   rtnetlink_rcv+0x15/0x30
   netlink_unicast+0x2a1/0x3d0
   netlink_sendmsg+0x237/0x490
   ____sys_sendmsg+0x33b/0x360
   ___sys_sendmsg+0x99/0xf0
   __sys_sendmsg+0x93/0x100
   __x64_sys_sendmsg+0x1d/0x30
   x64_sys_call+0x821/0x23d0
   do_syscall_64+0xba/0x550
   entry_SYSCALL_64_after_hwframe+0x76/0x7e
   </TASK>
  mlx5_core 0000:b1:00.1: mlx5_cmd_out_err:822:(pid 2642): DEALLOC_PD(0x801) op_mod(0x0) failed, status bad resource state(0x9), syndrome (0xef0c8a), err(-22)
  mlx5_core 0000:b1:00.1: mlx5hws_pool_destroy:386:(pid 2642): Attempting to destroy non-empty pool

Keep the base id in the rule action, as the sampler id is.

Discovered while stress testing a 5G UPF kernel code. Without this fix,
the reproduction below gives the trace above on a ConnectX-7 with
firmware 28.48.1000. It only uses tc and devlink, with no kernel
change. 129 meters cannot fit in one ASO object. DEV is the uplink
representor and PCI its devlink handle:

  r() { echo "filter $1 dev $DEV ingress prio 1 handle $2 protocol ip flower skip_sw dst_ip 10.0.0.$2 action police index $3 rate 1mbit burst 32k conform-exceed drop/pipe action drop"; }
  devlink dev param set $PCI name flow_steering_mode value hmfs cmode runtime
  devlink dev eswitch set $PCI mode switchdev
  tc qdisc add dev $DEV ingress
  for i in $(seq 129); do r add $i $i; done | tc -b -
  r replace 1 1000 | tc -b -
  tc filter del dev $DEV ingress prio 1
  devlink dev eswitch set $PCI mode legacy

With this fix, the reproduction runs clean on the same ConnectX-7.
It was not tested against kernel selftests.

Fixes: 82d3639ef7dc ("net/mlx5: fs, add support for flow meters HWS action")
Signed-off-by: Alexandre Cassen <acassen@corp.free.fr>
---
 .../net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.c | 8 ++++----
 .../net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.h | 2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.c
index 812b2f3cddcf..cbcbc2b62809 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.c
@@ -523,13 +523,13 @@ mlx5_fs_get_action_aso_meter(struct mlx5_fs_hws_context *fs_ctx,
 }
 
 static void mlx5_fs_put_action_aso_meter(struct mlx5_fs_hws_context *fs_ctx,
-					 struct mlx5_exe_aso *exe_aso)
+					 u32 base_id)
 {
 	struct mlx5_fs_hws_data *meter_hws_data;
 	struct xarray *meters_xa;
 
 	meters_xa = &fs_ctx->hws_pool.aso_meters;
-	meter_hws_data = xa_load(meters_xa, exe_aso->base_id);
+	meter_hws_data = xa_load(meters_xa, base_id);
 	if (!meter_hws_data)
 		return;
 	return mlx5_fs_put_hws_action(meter_hws_data);
@@ -704,7 +704,7 @@ static void mlx5_fs_destroy_fs_action(struct mlx5_flow_root_namespace *ns,
 		mlx5_fc_put_hws_action(fs_action->counter);
 		break;
 	case MLX5HWS_ACTION_TYP_ASO_METER:
-		mlx5_fs_put_action_aso_meter(fs_ctx, fs_action->exe_aso);
+		mlx5_fs_put_action_aso_meter(fs_ctx, fs_action->aso_base_id);
 		break;
 	case MLX5HWS_ACTION_TYP_SAMPLER:
 		mlx5_fs_put_dest_action_sampler(fs_ctx, fs_action->sampler_id);
@@ -937,7 +937,7 @@ static int mlx5_fs_fte_get_hws_actions(struct mlx5_flow_root_namespace *ns,
 			fte_action->exe_aso.flow_meter.init_color;
 		(*ractions)[num_actions++].action = tmp_action;
 		fs_actions[num_fs_actions].action = tmp_action;
-		fs_actions[num_fs_actions++].exe_aso = &fte_action->exe_aso;
+		fs_actions[num_fs_actions++].aso_base_id = fte_action->exe_aso.base_id;
 	}
 
 	if (fte_action->action & MLX5_FLOW_CONTEXT_ACTION_DROP) {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.h
index cf068fb5bdbf..4fdeea9fdd12 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.h
@@ -57,7 +57,7 @@ struct mlx5_fs_hws_rule_action {
 	struct mlx5hws_action *action;
 	union {
 		struct mlx5_fc *counter;
-		struct mlx5_exe_aso *exe_aso;
+		u32 aso_base_id;
 		u32 sampler_id;
 	};
 };
-- 
2.43.0

