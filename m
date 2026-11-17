Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=212.27.60.169
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794907774;
	b=uN5iEk2ghRNRHZ9ZphV+WElLq9kA66fLfxSiGWKCdHa0PCPcbP0e225wRN6ywo+k9rTs
	 izRWOTnh+eOawTAFo0489M75lz/g2ckZvMsSUo9pXWTutisOk2JdLm5jK8zh5pASzK37q
	 nK+HO+zNMjX/r4GfCOI1RiLw35tP1gssHqqoT2IKJU+glgvIQg5KaOecKz07zoMy2BuR8
	 zYVx0lKNdjpBZuFt4ArwxTOsqd8yfKnkmbfQjwfIeQsJomv6ZvCCl6C3ABGylGMsgS4AZ
	 RC0MUsfd8BfUBzVG4RQ0PCAP7yz9tNW3//Um8ZiPEdnGlQBFt5Z4fiR8/p7USgUdFFg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794907774;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=uj1e2akn2qsyRZEvnz2C69jZ6R01/xhn0vkqiFnsCAE=;
	b=c57qfvyVqZn6JYwZYfc4umUHmjJH9zzAwXoiPeB5P+syODWLho9dT+PoPLeycAjx02vs
	 p5fcnYKeRj3hWvf9sEr6JUzshYOzCvazBj+jvqJbVrZowsD/MN7/xetFKjn711yQqCbHw
	 FHec6NFGipo1L+pqoB9liFktEfieXrQubzOfNWW+Y89X/Hmt5GoB2d+NOrLRRYXT3NP58
	 9ilZWQKVBYRUjJ8vy34DwhF70j0g1beIAm151XNxsutRIYKf10NkubJfkMQQdeJuRZT+p
	 FF583t3bO8jOusQDxmLxxrH85bU7ibWOoVdNa5i7WWtA4jAILc2l6GKv++frpWu7gFA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=corp.free.fr;
	spf=pass smtp.mailfrom=corp.free.fr;
	dkim=pass header.d=corp.free.fr header.i=@corp.free.fr header.a=rsa-sha256 header.s=rcs header.b=ZCZtTGwI;
	arc=none smtp.remote-ip=212.27.60.169
Received: from rcs.proxad.net (rcs.proxad.net [212.27.60.169])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36960606A8A9;
	Tue, 17 Nov 2026 09:29:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 36960606A8A9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=corp.free.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=corp.free.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=corp.free.fr header.i=@corp.free.fr header.a=rsa-sha256 header.s=rcs header.b=ZCZtTGwI
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=corp.free.fr; s=rcs;
	t=1794907766; bh=026vuuHh/T9A1Eft9SNnKsLEY3/cuC4z+0Un1kIxXPM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZCZtTGwIEYsQNdGBApZ5ARweBEiyH9BOyj2a0Q67Ebt/4Vti+V5q31P8M8d0g12X8
	 jstWkmJZpgxWbN5KwSmgLnVMTgeOcWYCDI2pyP4jgFmgRQEoU3cySQbql7fydIbFz3
	 9gr3SSiZ53iOn2iJWATCSwLKp8LhEctvuB1RMg5q1XMNCV9xtHltpU9jRCrWrfKpcl
	 XRy6sd3Vex/f1UWX/xiik4qyuBgSN5FJ/kEzBmnTMECbBjxvZa9ycKvgwL5XgvsEU4
	 0ItHdE/zmHdV8x7t2ZiKqaDmwPV2sO1ssxSNqhtRRElTqjqyK5TfIMc6jgfatSaEH6
	 Wgq6LsuhzZcNg==
Received: from lnxos-dev.home (82-66-150-212.subs.proxad.net [82.66.150.212])
	by rcs.proxad.net (Postfix) with ESMTPSA id 8DF5D44C0B80;
	Tue, 17 Nov 2026 10:29:25 +0100 (CET)
From: Alexandre Cassen <acassen@corp.free.fr>
To: Saeed Mahameed <saeedm@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Tariq Toukan <tariqt@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Jiri Pirko <jiri@resnulli.us>
Cc: Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Michael Chan <michael.chan@broadcom.com>,
	Pavan Chebbi <pavan.chebbi@broadcom.com>,
	Potnuri Bharat Teja <bharat@chelsio.com>,
	Donald Hunter <donald.hunter@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	David Ahern <dsahern@kernel.org>,
	Ido Schimmel <idosch@nvidia.com>,
	Shuah Khan <shuah@kernel.org>,
	netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	oss-drivers@corigine.com
Subject: [PATCH net-next v2 08/10] net/mlx5e: TC, offload RX queue mapping in NIC flows
Date: Tue, 17 Nov 2026 10:29:11 +0100
Message-ID: <20261117092915.255194-9-acassen@corp.free.fr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261117092915.255194-1-acassen@corp.free.fr>
References: <20261117092915.255194-1-acassen@corp.free.fr>
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

skbedit queue_mapping steers a flow to one RX queue. ice, hns3 and
octeontx2 already offload it. Add it to mlx5e NIC flows. The rule points
to the direct TIR of the channel like ethtool steering rules.

The direct TIR takes over the destination of the rule. The action must
come last and cannot follow a terminating action such as ok, goto or
mirred. A goto would also unbalance the reference count of its chain
table.

Reducing the channel count below the queue of a rule drops its traffic
until the channel returns. The direct RQT of an inactive channel points to
the drop RQ. ethtool refuses such a change for its own rules but nothing
tracks the queues of TC rules. A channel change racing with the range
check of a new rule has the same result. Direct TIRs exist up to the
maximum channel count. The rule always points to a valid one.

Tested on ConnectX-7 with firmware 28.48.1000.

Signed-off-by: Alexandre Cassen <acassen@corp.free.fr>
---
 .../net/ethernet/mellanox/mlx5/core/Makefile  |  3 +-
 .../mellanox/mlx5/core/en/tc/act/act.c        |  1 +
 .../mellanox/mlx5/core/en/tc/act/act.h        |  1 +
 .../mellanox/mlx5/core/en/tc/act/rx_queue.c   | 67 +++++++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   |  4 ++
 .../net/ethernet/mellanox/mlx5/core/en_tc.h   |  1 +
 6 files changed, 76 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/rx_queue.c

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Makefile b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
index a1871259210d..f8d1696ab5eb 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Makefile
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
@@ -56,7 +56,8 @@ mlx5_core-$(CONFIG_MLX5_CLS_ACT)     += en/tc/act/act.o en/tc/act/drop.o en/tc/a
 					en/tc/act/vlan.o en/tc/act/vlan_mangle.o en/tc/act/mpls.o \
 					en/tc/act/mirred.o en/tc/act/mirred_nic.o \
 					en/tc/act/ct.o en/tc/act/sample.o en/tc/act/ptype.o \
-					en/tc/act/redirect_ingress.o en/tc/act/police.o
+					en/tc/act/redirect_ingress.o en/tc/act/police.o \
+					en/tc/act/rx_queue.o
 
 ifneq ($(CONFIG_MLX5_TC_CT),)
 	mlx5_core-y			     += en/tc_ct.o en/tc/ct_fs_dmfs.o
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.c
index 0380a04c3691..9b5d7d5ee271 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.c
@@ -41,6 +41,7 @@ static struct mlx5e_tc_act *tc_acts_nic[NUM_FLOW_ACTIONS] = {
 	[FLOW_ACTION_ADD] = &mlx5e_tc_act_pedit,
 	[FLOW_ACTION_CSUM] = &mlx5e_tc_act_csum,
 	[FLOW_ACTION_MARK] = &mlx5e_tc_act_mark,
+	[FLOW_ACTION_RX_QUEUE_MAPPING] = &mlx5e_tc_act_rx_queue,
 	[FLOW_ACTION_CT] = &mlx5e_tc_act_ct,
 };
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.h b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.h
index 2e528b2c34d6..e6df5f0f27a7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.h
@@ -94,6 +94,7 @@ extern struct mlx5e_tc_act mlx5e_tc_act_sample;
 extern struct mlx5e_tc_act mlx5e_tc_act_ptype;
 extern struct mlx5e_tc_act mlx5e_tc_act_redirect_ingress;
 extern struct mlx5e_tc_act mlx5e_tc_act_police;
+extern struct mlx5e_tc_act mlx5e_tc_act_rx_queue;
 
 struct mlx5e_tc_act *
 mlx5e_tc_act_get(enum flow_action_id act_id,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/rx_queue.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/rx_queue.c
new file mode 100644
index 000000000000..32598a216300
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/rx_queue.c
@@ -0,0 +1,67 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+
+#include "act.h"
+#include "en/tc_priv.h"
+#include "en/rx_res.h"
+
+/* No action runs after a terminating one */
+static bool
+tc_act_rx_queue_is_reachable(struct flow_action *flow_action, int act_index)
+{
+	struct mlx5e_tc_act *tc_act;
+	int i;
+
+	for (i = 0; i < act_index; i++) {
+		tc_act = mlx5e_tc_act_get(flow_action->entries[i].id,
+					  MLX5_FLOW_NAMESPACE_KERNEL);
+		if (tc_act->is_terminating_action)
+			return false;
+	}
+
+	return true;
+}
+
+static bool
+tc_act_can_offload_rx_queue(struct mlx5e_tc_act_parse_state *parse_state,
+			    const struct flow_action_entry *act,
+			    int act_index,
+			    struct mlx5_flow_attr *attr)
+{
+	struct flow_action *flow_action = parse_state->flow_action;
+	struct netlink_ext_ack *extack = parse_state->extack;
+	struct mlx5e_tc_flow *flow = parse_state->flow;
+
+	/* The direct TIR takes over the destination of the rule */
+	if (!flow_action_is_last_entry(flow_action, act) ||
+	    !tc_act_rx_queue_is_reachable(flow_action, act_index)) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "RX queue mapping must be the last action and cannot follow a terminating action");
+		return false;
+	}
+
+	if (act->rx_queue >= flow->priv->channels.params.num_channels) {
+		NL_SET_ERR_MSG_MOD(extack, "RX queue index out of range");
+		return false;
+	}
+
+	return true;
+}
+
+static int
+tc_act_parse_rx_queue(struct mlx5e_tc_act_parse_state *parse_state,
+		      const struct flow_action_entry *act,
+		      struct mlx5e_priv *priv,
+		      struct mlx5_flow_attr *attr)
+{
+	attr->nic_attr->rx_tirn = mlx5e_rx_res_get_tirn_direct(priv->rx_res,
+							       act->rx_queue);
+	attr->action |= MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
+
+	return 0;
+}
+
+struct mlx5e_tc_act mlx5e_tc_act_rx_queue = {
+	.can_offload = tc_act_can_offload_rx_queue,
+	.parse_action = tc_act_parse_rx_queue,
+	.is_terminating_action = true,
+};
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index ba3aef3c8063..2326fb21da66 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -1267,6 +1267,10 @@ mlx5e_add_offloaded_nic_rule(struct mlx5e_priv *priv,
 		dest[dest_ix].type = MLX5_FLOW_DESTINATION_TYPE_TIR;
 		dest[dest_ix].tir_num = nic_attr->hairpin_tirn;
 		dest_ix++;
+	} else if (nic_attr->rx_tirn) {
+		dest[dest_ix].type = MLX5_FLOW_DESTINATION_TYPE_TIR;
+		dest[dest_ix].tir_num = nic_attr->rx_tirn;
+		dest_ix++;
 	} else if (attr->action & MLX5_FLOW_CONTEXT_ACTION_FWD_DEST) {
 		dest[dest_ix].type = MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE;
 		if (attr->dest_chain) {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
index e1b8cb78369f..254ea76fcbe9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
@@ -66,6 +66,7 @@ struct mlx5e_tc_update_priv {
 struct mlx5_nic_flow_attr {
 	u32 flow_tag;
 	u32 hairpin_tirn;
+	u32 rx_tirn;
 	struct mlx5_flow_table *hairpin_ft;
 };
 
-- 
2.43.0

