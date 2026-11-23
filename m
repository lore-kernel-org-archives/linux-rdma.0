Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=212.27.60.169
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795472004;
	b=F9NoCPszYxuPNJnpb/ANFoA57oEpIb2mkoWzIlvda7OLElbOb+F4/rUkgYFp3KSDNrgZ
	 JDySHxIByuk7ruhFZdQ2lilQtzfeiWswZVaIkc+bHYc62hDLfJNRh1F/RKnA8VQtrReZ+
	 a7DT/01z23P+lUWpCJcJgIIDYmOj/+G0q45PBnugGtbWoUO7uSoqMDLh61t6u0D9wVrC1
	 8Nf3ljtPrO/cSKZp2ScrbZdngHstXaLNIRy5BLQsbM8AY+r2xkF5qtFSo3mtgUs+PGOhT
	 NTMeauH5sPP8yVzxSK4PhHNrQ463Frg7EKkOOE4IouQVVef9Bbf9Z9sIYgGuw2CABtw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795472004;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=efn82r+KfBu1S0hOP1HDx+eAdvbrYXzPa6l82piTvoI=;
	b=GVekieIkQmvgzgCVtNuaSY96WZl/Iggh5DCno8LDnNnG6w43pJflcoB5YsjvPCxFD4vx
	 +B1qRmvI6dvP6NybwSFgWhtmPPCXJZCDXmsDhoPmGMZZALNyywqcA0mUZ9UiIcycVayH/
	 QBgRAka84dOztQj25+QVLx2WYHEPO/yNwWzgfbVJJ5bTUdUIFSsi2bzlJqeYqU4GKzYFv
	 sAkYU4+TfZCHJJypgOUZg9Pm8Gor/k2ezRGAGPExrigUIDPkTe4GqGjwxo9AnDDrKZ7bS
	 KipxLtmwDqE5lUAOxFtA+pykagZ4KcN1HpBIwkeB49559cCaH6zEJ1ZbRefLmbFao1Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=corp.free.fr;
	spf=pass smtp.mailfrom=corp.free.fr;
	dkim=pass header.d=corp.free.fr header.i=@corp.free.fr header.a=rsa-sha256 header.s=rcs header.b=T3dAotLr;
	arc=none smtp.remote-ip=212.27.60.169
Received: from rcs.proxad.net (rcs.proxad.net [212.27.60.169])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEADA606A321;
	Mon, 23 Nov 2026 22:13:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CEADA606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=corp.free.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=corp.free.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=corp.free.fr header.i=@corp.free.fr header.a=rsa-sha256 header.s=rcs header.b=T3dAotLr
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=corp.free.fr; s=rcs;
	t=1795471995; bh=ec7JQ3WRoKkbQyPcQyH3esPajpEWc3CRL0lLiaShQEI=;
	h=From:To:Cc:Subject:Date:From;
	b=T3dAotLrdsmHTChkjyf2lA4ywdH9YGdausbhF+IN8Fsq7R2x5/v+hwlzyXAEnaz/q
	 +MPNjX2bHpxjsc/86bbU2MRZXN/B3vfjW0jZv07rl4Sy8kG1F5yPM37Tr5LYyJWweh
	 yebCP4hfgh9a6HnW5BQlHL4v7ZUh7NG3cOSsYQaAw+L0NFQLqZjE1xz6JPbb2B8ukG
	 +v9mPr+VVUM4rXNRk0YVxz5LOqAbkwrOYTOxtMY+2f6M7QFR/CRSQQ9uvvu4o2o9Wq
	 5VjpxJ53QueiOuphPhsn0rfijqmsHa7PFtDc8emSQnoDoDiAPMwQjUHr0hLsqXgh/D
	 gYOi5pjCWfSTA==
Received: from lnxos-dev.home (82-66-150-212.subs.proxad.net [82.66.150.212])
	by rcs.proxad.net (Postfix) with ESMTPSA id 24A4044C0111;
	Mon, 23 Nov 2026 23:13:15 +0100 (CET)
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
	Vlad Dogaru <vdogaru@nvidia.com>,
	netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org
Subject: [PATCH net] net/mlx5: HWS, fix action STE double free on rule update
Date: Mon, 23 Nov 2026 23:13:08 +0100
Message-ID: <20261123221310.4045513-1-acassen@corp.free.fr>
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

An HWS rule keeps the chunk of its action STEs in rule->action_ste. An
update saves it in rule->old_action_ste and frees it once the new match
STE is written. When the new actions need no action STEs, the rule still
points to that chunk. Its next update or its deletion free it again.

Two rules can then end up with the same action STEs. A packet of one can
get the header rewrite or the meter of the other. The second free can
also dereference an action STE table that the cleanup work has freed.
Neither was observed.

The buddy allocator counts the same segment as free twice. After a few
updates of several rules, it finds no segment where it counts one:

  ICM Buddy: failed finding free mem for order 0
  WARNING: drivers/net/ethernet/mellanox/mlx5/core/steering/hws/buddy.c:93 at mlx5hws_buddy_alloc_mem+0x11a/0x140 [mlx5_core], CPU#34: tc/449154
  Call Trace:
   <TASK>
   hws_pool_buddy_db_get_chunk+0x25/0x50 [mlx5_core]
   mlx5hws_pool_chunk_alloc+0x30/0x80 [mlx5_core]
   mlx5hws_action_ste_chunk_alloc+0x85/0x480 [mlx5_core]
   hws_rule_create_hws+0x860/0x9c0 [mlx5_core]
   mlx5hws_rule_action_update+0x81/0x140 [mlx5_core]
   mlx5hws_bwc_rule_action_update+0x10d/0x200 [mlx5_core]
   mlx5_cmd_hws_update_fte+0xb0/0x140 [mlx5_core]
   del_hw_fte+0x1b2/0x390 [mlx5_core]
   mlx5_del_flow_rules+0x10f/0x270 [mlx5_core]
   __mlx5_eswitch_del_rule+0x5c/0x1b0 [mlx5_core]
   mlx5_eswitch_del_offloaded_rule+0x10/0x20 [mlx5_core]
   mlx5e_tc_rule_unoffload+0x4b/0x100 [mlx5_core]
   mlx5e_tc_unoffload_fdb_rules+0x35/0x80 [mlx5_core]
   mlx5e_tc_del_fdb_flow+0x2ca/0x310 [mlx5_core]
   mlx5e_tc_del_flow+0x63/0x610 [mlx5_core]
   mlx5e_flow_put+0x3a/0x80 [mlx5_core]
   mlx5e_delete_flower+0x29b/0x460 [mlx5_core]
   mlx5e_setup_tc_cls_flower+0x7d/0x90 [mlx5_core]
   mlx5e_setup_tc_block_cb+0x58/0x90 [mlx5_core]
   tc_setup_cb_destroy+0xcc/0x1b0
   fl_hw_destroy_filter+0xa1/0xe0 [cls_flower]
   fl_change+0x1bf1/0x20a9 [cls_flower]
   tc_new_tfilter+0x432/0xea0
   rtnetlink_rcv_msg+0x384/0x460
   netlink_rcv_skb+0x61/0x120
   rtnetlink_rcv+0x15/0x30
   netlink_unicast+0x2a1/0x3d0
   netlink_sendmsg+0x237/0x490
   ____sys_sendmsg+0x32d/0x350
   ___sys_sendmsg+0xaf/0x110
   __sys_sendmsg+0x93/0x100
   __x64_sys_sendmsg+0x1d/0x30
   x64_sys_call+0x821/0x23d0
   do_syscall_64+0xbd/0x570
   </TASK>

The pool then holds more free elements than its size at close:

  mlx5_core 0000:31:00.0: mlx5hws_pool_destroy:386:(pid 448599): Attempting to destroy non-empty pool

Forget the chunk in rule->action_ste once it is saved, as the update
flow did with the action STE index before the commit below.

Triggered during an endurance test of a 5G UPF code, on flower rules
that lose their police action in place. The reproduction below gives
the trace above on a ConnectX-7 with firmware 28.48.1000. It only
uses tc and devlink, with no kernel change. DEV is the uplink
representor and PCI its devlink handle:

  r() { for i in $(seq 128); do echo "filter $1 dev $DEV ingress prio 1 handle $i protocol ip flower skip_sw dst_ip 10.0.0.$i $2"; done | tc -b -; }
  BIG="action pedit ex munge ip ttl set 63 pipe action csum ip pipe action police rate 1mbit burst 32k conform-exceed drop/pipe action drop"
  devlink dev param set $PCI name flow_steering_mode value hmfs cmode runtime
  devlink dev eswitch set $PCI mode switchdev
  tc qdisc add dev $DEV ingress
  r add "$BIG"
  for n in 1 2 3; do r replace "action drop"; r replace "$BIG"; done
  tc filter del dev $DEV ingress prio 1
  devlink dev eswitch set $PCI mode legacy

With this fix, the reproduction runs clean on the same ConnectX-7.
It was not tested against kernel selftests.

Not addressed here and not triggered: after a successful update,
hws_rule_destroy_failed_hws() can free rule->old_action_ste again. A
failed update can leak it now also when it needs no action STEs.

Fixes: 3fc44ca44d7c ("net/mlx5: HWS, update flow - support through bigger action RTC")
Signed-off-by: Alexandre Cassen <acassen@corp.free.fr>
---
 drivers/net/ethernet/mellanox/mlx5/core/steering/hws/rule.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/rule.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/rule.c
index 0d4cb2b2393b..cc94d3149d76 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/rule.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/rule.c
@@ -243,6 +243,8 @@ static void hws_rule_create_init(struct mlx5hws_rule *rule,
 		 * new action STEs and a corresponding match STE.
 		 */
 		rule->old_action_ste = rule->action_ste;
+		/* The rule may need no action STEs once updated */
+		rule->action_ste.action_tbl = NULL;
 	}
 
 	rule->pending_wqes = 0;
-- 
2.43.0

