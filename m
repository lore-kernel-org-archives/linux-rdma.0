Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=212.27.60.169
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794229851;
	b=oCVR3FvmE9LOOYki2Bz1hVC3kchWPMX0vWCSi7jyMYvyGlDpKYPnYUIWzb2WH+BkqU53
	 aNz6t+zqYpt8ydqJAVrFXP/l1AyReaFnz9JUW3oHCV9WQLntyd6qy1rzkRsHbyOCE3swl
	 jb1MEYOsM/CqVAJB3tO0sIh4rm2EyNzgl+2CberVSocrvOVVH3M02+Y5bRTpBj1n/PVe2
	 KKgMzAz3/lxb8djVyiyHGQJ8ecL1mb+dx0fvROgFFevZb84vcFt4duR6o3T7PVdtn1TdK
	 IV3vfTNc99+aIDhFhcheIcVbSttYft1Tzo2ixLFSjnJA5X48xK3vM3MaGButu1y5OKw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794229851;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=A3yAH5h3g2Pti7IAaF+jwJJqscRI/6K/NBiUoKCaD1Y=;
	b=f99j9amMdBWXIMfpmxhEmAOWN0bNwLzNuMlgzAQ423U+GSXHDN2dZlN2qdnZnumNALd2
	 +IiWb60SziHqMkJXbcdmuJmziGJEzAS5RWDlVG30MgdisKgQ1tBSYT998w1X6TXZbIrk6
	 txJjHK8hzl1YKc5Zfr6BNZuS5xJ9YavDmN8ZPxcCYZA2BPteIaojSYCCZy3/lEYlq6s+m
	 HEcN2efLLU1NYXPlSbiMVUEBGb3LfMY+chPVLVyyXceHkvk3cLcvLykeFDcbcsAhH9FXP
	 oU6aHOjBkjoEL/9Jl18jwTzmXwvhpu6XlEoxuSnaLdpKnsKZJ3DG/cSF+5v8EA8X6eg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=corp.free.fr;
	spf=pass smtp.mailfrom=corp.free.fr;
	dkim=pass header.d=corp.free.fr header.i=@corp.free.fr header.a=rsa-sha256 header.s=rcs header.b="VoQk9b/s";
	arc=none smtp.remote-ip=212.27.60.169
Received: from rcs.proxad.net (rcs.proxad.net [212.27.60.169])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDCA2606EE90;
	Mon,  9 Nov 2026 13:10:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DDCA2606EE90
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=corp.free.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=corp.free.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=corp.free.fr header.i=@corp.free.fr header.a=rsa-sha256 header.s=rcs header.b=VoQk9b/s
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=corp.free.fr; s=rcs;
	t=1794229849; bh=xZoQ+486byQ7fMwqV6pT7InUOBPmODFGr1KhFM9u6Gc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VoQk9b/sklXhEJ5wiehkqzPfH24J+XMHwQM+Urv2loWfdav1zuwl3LoehVXBMLejv
	 h1DgqWVLZ6AG1/tcpzOQAD+/yCVcHDCyodZGoJwfMWvXUu7WVSkeOxF+Ce4GCm1BIs
	 074kjgA7vgzNefHWtwO8+agZGvmO9itO/S1gCTty8u+GhzkId448EIBCE+ykswj6Rj
	 0+G25I6wKac+pQsZvfJHU0J0W5uowKBqiXNu2gAXnb2HIsBa1jjNK0+soUxaiiRxYz
	 29HU4pWTivbwR01KSFB1xAegvDIKdHGh5KOSlzMc/d9MornxkXiTyP4Jn3zWIO2HGM
	 5shx5JaBZG+hQ==
Received: from lnxos-dev.home (82-66-150-212.subs.proxad.net [82.66.150.212])
	by rcs.proxad.net (Postfix) with ESMTPSA id 2F11444C11DE;
	Mon,  9 Nov 2026 14:10:49 +0100 (CET)
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
Subject: [PATCH net-next 08/10] net/mlx5e: TC, offload RX queue mapping in NIC flows
Date: Mon,  9 Nov 2026 14:10:34 +0100
Message-ID: <20261109131039.959438-9-acassen@corp.free.fr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261109131039.959438-1-acassen@corp.free.fr>
References: <20261109131039.959438-1-acassen@corp.free.fr>
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
come last and cannot follow goto or mirred. A goto would also unbalance
the reference count of its chain table.

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
 .../mellanox/mlx5/core/en/tc/act/rx_queue.c   | 49 +++++++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   |  4 ++
 .../net/ethernet/mellanox/mlx5/core/en_tc.h   |  1 +
 6 files changed, 58 insertions(+), 1 deletion(-)
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
index 000000000000..869da3cb703a
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/rx_queue.c
@@ -0,0 +1,49 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+
+#include "act.h"
+#include "en/tc_priv.h"
+#include "en/rx_res.h"
+
+static bool
+tc_act_can_offload_rx_queue(struct mlx5e_tc_act_parse_state *parse_state,
+			    const struct flow_action_entry *act,
+			    int act_index,
+			    struct mlx5_flow_attr *attr)
+{
+	struct netlink_ext_ack *extack = parse_state->extack;
+	struct mlx5e_tc_flow *flow = parse_state->flow;
+
+	/* The direct TIR takes over the destination of the rule */
+	if (!flow_action_is_last_entry(parse_state->flow_action, act) ||
+	    attr->dest_chain || flow_flag_test(flow, HAIRPIN)) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "RX queue mapping must be the last action and cannot follow goto or mirred");
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
index 28f09d234835..3823ccc60dd3 100644
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

