Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=212.27.60.169
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794229852;
	b=IF7copkQdnPoxnS5LnH+pWhYUspYm1peWVssCu7AV+zma2/kFUbzp3amZWIMUxZfQIrX
	 H/6zFccVaz3a3ZpDHQBnqLtdcPhKbAPb0qlRt44X+ClmAk4CGSp+hTBby9X2ygetwUyFP
	 lbxtjf2aB2+9ndJsB1ovq64un6jxrrXAzh3eiRT8EjIWNJUOdeD9VIJ1fqvdoayhUFyp9
	 TKpFHDd14OsM+50ojZjKzVoORg2/fLpzMbT9WDpIn+lFXrfrIifiV0933fUfjoOoqlz4H
	 4xHUygswcHbURnqY/s0wNkILiiwLl/s0ozpFFWjxcqc95ifcD9iHjbUwQfsp+lxaiVg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794229852;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=ZpXwRCLZAYWb9oX/dO5BRqiJRofMbLBhf7wjIB2wQ3o=;
	b=gss3j9jmOTrf1NZqS6Pvu2SiUjVS2SmcOl2XIIsmbluuddgJVx13mWFSn8LBzng/V328
	 Qm1XNIDpNdFB01gNRrGx1ErXdtvz/U+Iq8dXfEVvRuyr58eZEKlE9o1DLNO8/8btMDOq6
	 GLhwnmvqH26yfsa8fwsEXNV/7OmnZ/HTGCKg0yzn+6BaWpC69VwxtvEq65AFJ7AwuKBFg
	 GP3EApPjtTt5ocefFV1SnyTszgNQkG9mlhRf1sE9rghit7WhT2u4HPz+ukrkvCXDuYzjG
	 V3gJjZ1pIzmd3tBBLgMp0ad2Wv3WX1Nz4Vh1BVOWc92KTCLk3wcly1dan8ms56XKyXA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=corp.free.fr;
	spf=pass smtp.mailfrom=corp.free.fr;
	dkim=pass header.d=corp.free.fr header.i=@corp.free.fr header.a=rsa-sha256 header.s=rcs header.b=rLKtKJX6;
	arc=none smtp.remote-ip=212.27.60.169
Received: from rcs.proxad.net (rcs.proxad.net [212.27.60.169])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA498606EEB2;
	Mon,  9 Nov 2026 13:10:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AA498606EEB2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=corp.free.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=corp.free.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=corp.free.fr header.i=@corp.free.fr header.a=rsa-sha256 header.s=rcs header.b=rLKtKJX6
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=corp.free.fr; s=rcs;
	t=1794229850; bh=hO5HGk6clXlqO/yQ+ISkhCkctQ1nmXWJvI+vrTLv7dg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rLKtKJX6ZTZBgndepQi6u4+aGftHDLadT5zSL88lyIi+nMaGGvsdxyQ/yQG2SQlRd
	 5CLMyu/0PdmnQijoGcWp39fU9TldOoyL05SUmuDW5YzZAK02U1ejhvP8+B8021IQUb
	 lk4pFHx27p6S4JrL/0+cz44Rxzh57AkRNKGmzya2qxmVdgJHJzy1QBaxZ9fZfGqyHE
	 H6VxDCvhLIN3XipOQX+fdg62MfMj9P99nDHlLCY1nx7lHOzL+Jui0vNEgt4anxzvUI
	 OvqcbDHMzeGWQiw/pHEi7CLKO99i1hS21QqmZr3qP0GqxKtnNWCg2DaqgQtLC0XuMt
	 mrMWh36hSJQGg==
Received: from lnxos-dev.home (82-66-150-212.subs.proxad.net [82.66.150.212])
	by rcs.proxad.net (Postfix) with ESMTPSA id A9E7144C11E6;
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
Subject: [PATCH net-next 09/10] net/mlx5e: TC, match the tunnel key without a tunnel device
Date: Mon,  9 Nov 2026 14:10:35 +0100
Message-ID: <20261109131039.959438-10-acassen@corp.free.fr>
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

RSS can't spread GTP-U traffic between a few endpoints. The outer headers
barely vary and the TEID is not hashed. A masked tunnel key partitions
this traffic into RX queues. Other tunnels spread better under RSS. The
same match still gives a block of tenants its own queue.

Without a tunnel device nothing decapsulates. enc_key_id reads the tunnel
header on the wire like cxgb4 and hns3 do on a physical port. The plain
ip_proto and dst_port keys select the match register and its capability:

  GRE     ip_proto 0x2f   misc.gre_key     ft_field_support
  VXLAN   dst_port 4789   misc.vxlan_vni   ft_field_support
  GENEVE  dst_port 6081   misc.geneve_vni  flex parser and
                                           ft_field_support
  GTP-U   dst_port 2152   misc3.gtpu_teid  flex parser

These keys stay in the match. Without them a rule on a masked TEID of zero
also catches all other IPv4 traffic on ConnectX-7. The port must be exact
to name a tunnel. Only the default VXLAN port qualifies. The hardware can
stop parsing any other while the rule stays. A keyless GRE packet reads as
key zero like in software.

The parse_tunnel ops can't serve these flows. The VXLAN and GENEVE ones
check eswitch capabilities. The GRE one only matches gretap frames. A new
op keeps each register in the file of its tunnel.

This covers NIC and eswitch flows. A rule on the uplink representor used
to accept enc_key_id without matching on it. It caught all the traffic of
its other keys. It now matches the key or gets refused.

Software only has tunnel metadata after decapsulation. Refuse the offload
without skip_sw to keep both datapaths from diverging. Such a rule stays in
software. There a physical port reads key zero. Refuse a decap action too.
In software it only releases metadata and such a flow has none.

  tc filter add dev <dev> ingress protocol ip flower skip_sw \
      ip_proto udp dst_port 2152 enc_key_id <teid>/<mask>    \
      action skbedit queue_mapping <q> skip_sw

  tc filter add dev <dev> ingress protocol ip flower skip_sw \
      ip_proto 0x2f enc_key_id <key>/<mask>                  \
      action skbedit queue_mapping <q> skip_sw

Tested on ConnectX-7 with firmware 28.48.1000 on NIC flows. Also tested on
the uplink and VF representors in dmfs, smfs and hmfs. This includes
redirect to a VF. GTP-U needs flex parser profile 3 and GENEVE profile 0.
GRE and VXLAN work on both.

Signed-off-by: Alexandre Cassen <acassen@corp.free.fr>
---
 .../net/ethernet/mellanox/mlx5/core/Makefile  |  3 +-
 .../ethernet/mellanox/mlx5/core/en/tc_tun.c   | 88 +++++++++++++++++++
 .../ethernet/mellanox/mlx5/core/en/tc_tun.h   | 11 +++
 .../mellanox/mlx5/core/en/tc_tun_geneve.c     | 38 ++++++++
 .../mellanox/mlx5/core/en/tc_tun_gre.c        | 31 +++++++
 .../mellanox/mlx5/core/en/tc_tun_gtp.c        | 36 ++++++++
 .../mellanox/mlx5/core/en/tc_tun_vxlan.c      | 37 ++++++++
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   |  4 +
 8 files changed, 247 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_gtp.c

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Makefile b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
index f8d1696ab5eb..5d42c681dc7b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Makefile
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
@@ -46,7 +46,8 @@ mlx5_core-$(CONFIG_MLX5_CLS_ACT)     += en_tc.o en/rep/tc.o en/rep/neigh.o \
 					lib/fs_chains.o en/tc_tun.o \
 					esw/indir_table.o en/tc_tun_encap.o \
 					en/tc_tun_vxlan.o en/tc_tun_gre.o en/tc_tun_geneve.o \
-					en/tc_tun_mplsoudp.o diag/en_tc_tracepoint.o \
+					en/tc_tun_mplsoudp.o en/tc_tun_gtp.o \
+					diag/en_tc_tracepoint.o \
 					en/tc/post_act.o en/tc/int_port.o en/tc/meter.o \
 					en/tc/post_meter.o en/tc/act_stats.o
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
index de74dbfe7b20..921af801d4d4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
@@ -7,6 +7,7 @@
 #include <net/gre.h>
 #include <net/geneve.h>
 #include <net/bareudp.h>
+#include <net/gtp.h>
 #include "en/tc_tun.h"
 #include "en/tc_priv.h"
 #include "en_tc.h"
@@ -996,3 +997,90 @@ int mlx5e_tc_tun_parse_udp_ports(struct mlx5e_priv *priv,
 
 	return 0;
 }
+
+/* Without a tunnel device the outer headers name the tunnel */
+static struct mlx5e_tc_tunnel *
+mlx5e_tc_tun_outer_lookup(struct flow_rule *rule)
+{
+	struct flow_match_basic basic;
+	struct flow_match_ports ports;
+
+	if (!flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_BASIC))
+		return NULL;
+
+	flow_rule_match_basic(rule, &basic);
+	if (basic.key->ip_proto == IPPROTO_GRE)
+		return &gre_tunnel;
+
+	if (basic.key->ip_proto != IPPROTO_UDP ||
+	    !flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_PORTS))
+		return NULL;
+
+	flow_rule_match_ports(rule, &ports);
+	/* Only an exact port names a tunnel */
+	if (ports.mask->dst != htons(U16_MAX))
+		return NULL;
+
+	switch (ntohs(ports.key->dst)) {
+	case GTP1U_PORT:
+		return &gtp_tunnel;
+	case IANA_VXLAN_UDP_PORT:
+		return &vxlan_tunnel;
+	case GENEVE_UDP_PORT:
+		return &geneve_tunnel;
+	default:
+		return NULL;
+	}
+}
+
+static bool
+mlx5e_tc_tun_has_decap(struct flow_rule *rule)
+{
+	const struct flow_action_entry *act;
+	int i;
+
+	flow_action_for_each(i, act, &rule->action) {
+		if (act->id == FLOW_ACTION_TUNNEL_DECAP)
+			return true;
+	}
+
+	return false;
+}
+
+/* Without a tunnel device only the hardware can read the tunnel key */
+int
+mlx5e_tc_tun_parse_outer_key(struct mlx5e_priv *priv,
+			     struct mlx5_flow_spec *spec,
+			     struct flow_cls_offload *f,
+			     enum fs_flow_table_type fs_type)
+{
+	struct flow_rule *rule = flow_cls_offload_flow_rule(f);
+	struct netlink_ext_ack *extack = f->common.extack;
+	struct flow_match_enc_keyid enc_keyid;
+	struct mlx5e_tc_tunnel *tunnel;
+
+	if (!f->common.skip_sw) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "enc_key_id without a tunnel device requires skip_sw");
+		return -EOPNOTSUPP;
+	}
+
+	if (mlx5e_tc_tun_has_decap(rule)) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "enc_key_id without a tunnel device cannot decap");
+		return -EOPNOTSUPP;
+	}
+
+	tunnel = mlx5e_tc_tun_outer_lookup(rule);
+	if (!tunnel) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "enc_key_id needs ip_proto 0x2f or the exact dst_port of a supported tunnel");
+		return -EOPNOTSUPP;
+	}
+
+	flow_rule_match_enc_keyid(rule, &enc_keyid);
+	return tunnel->parse_outer_key(priv, spec, extack,
+				       be32_to_cpu(enc_keyid.key->keyid),
+				       be32_to_cpu(enc_keyid.mask->keyid),
+				       fs_type);
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.h b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.h
index d7c778bbb2ef..8eccaecb70b2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.h
@@ -52,6 +52,11 @@ struct mlx5e_tc_tunnel {
 			    struct flow_cls_offload *f,
 			    void *headers_c,
 			    void *headers_v);
+	int (*parse_outer_key)(struct mlx5e_priv *priv,
+			       struct mlx5_flow_spec *spec,
+			       struct netlink_ext_ack *extack,
+			       u32 key, u32 mask,
+			       enum fs_flow_table_type fs_type);
 	bool (*encap_info_equal)(struct mlx5e_encap_key *a,
 				 struct mlx5e_encap_key *b);
 	int (*get_remote_ifindex)(struct net_device *mirred_dev);
@@ -61,6 +66,7 @@ extern struct mlx5e_tc_tunnel vxlan_tunnel;
 extern struct mlx5e_tc_tunnel geneve_tunnel;
 extern struct mlx5e_tc_tunnel gre_tunnel;
 extern struct mlx5e_tc_tunnel mplsoudp_tunnel;
+extern struct mlx5e_tc_tunnel gtp_tunnel;
 
 struct mlx5e_tc_tunnel *mlx5e_get_tc_tun(struct net_device *tunnel_dev);
 
@@ -115,6 +121,11 @@ int mlx5e_tc_tun_parse_udp_ports(struct mlx5e_priv *priv,
 				 void *headers_c,
 				 void *headers_v);
 
+int mlx5e_tc_tun_parse_outer_key(struct mlx5e_priv *priv,
+				 struct mlx5_flow_spec *spec,
+				 struct flow_cls_offload *f,
+				 enum fs_flow_table_type fs_type);
+
 bool mlx5e_tc_tun_encap_info_equal_generic(struct mlx5e_encap_key *a,
 					   struct mlx5e_encap_key *b);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_geneve.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_geneve.c
index ee04fcdca6ff..9a2f7a409a82 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_geneve.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_geneve.c
@@ -4,6 +4,7 @@
 #include <net/geneve.h>
 #include "lib/geneve.h"
 #include "en/tc_tun.h"
+#include "fs_core.h"
 
 #define MLX5E_GENEVE_VER 0
 
@@ -350,6 +351,42 @@ static bool mlx5e_tc_tun_encap_info_equal_geneve(struct mlx5e_encap_key *a,
 						     IP_TUNNEL_GENEVE_OPT_BIT);
 }
 
+static int
+mlx5e_tc_tun_parse_outer_key_geneve(struct mlx5e_priv *priv,
+				    struct mlx5_flow_spec *spec,
+				    struct netlink_ext_ack *extack,
+				    u32 key, u32 mask,
+				    enum fs_flow_table_type fs_type)
+{
+	void *misc_c, *misc_v;
+
+	if (key >= MLX5E_TC_TUN_N_VNI) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Tunnel key does not fit the 24 bit VNI");
+		return -EOPNOTSUPP;
+	}
+
+	if (!mlx5e_tc_tun_can_offload_geneve(priv) ||
+	    !MLX5_CAP_FLOWTABLE_TYPE(priv->mdev,
+				     ft_field_support.outer_geneve_vni,
+				     fs_type)) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Matching on GENEVE VNI is not supported");
+		return -EOPNOTSUPP;
+	}
+
+	misc_c = MLX5_ADDR_OF(fte_match_param, spec->match_criteria,
+			      misc_parameters);
+	misc_v = MLX5_ADDR_OF(fte_match_param, spec->match_value,
+			      misc_parameters);
+
+	MLX5_SET(fte_match_set_misc, misc_c, geneve_vni, mask);
+	MLX5_SET(fte_match_set_misc, misc_v, geneve_vni, key);
+	spec->match_criteria_enable |= MLX5_MATCH_MISC_PARAMETERS;
+
+	return 0;
+}
+
 struct mlx5e_tc_tunnel geneve_tunnel = {
 	.tunnel_type          = MLX5E_TC_TUNNEL_TYPE_GENEVE,
 	.match_level          = MLX5_MATCH_L4,
@@ -359,5 +396,6 @@ struct mlx5e_tc_tunnel geneve_tunnel = {
 	.generate_ip_tun_hdr  = mlx5e_gen_ip_tunnel_header_geneve,
 	.parse_udp_ports      = mlx5e_tc_tun_parse_udp_ports_geneve,
 	.parse_tunnel         = mlx5e_tc_tun_parse_geneve,
+	.parse_outer_key      = mlx5e_tc_tun_parse_outer_key_geneve,
 	.encap_info_equal     = mlx5e_tc_tun_encap_info_equal_geneve,
 };
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_gre.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_gre.c
index 579eda89fc76..1a3d329408f4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_gre.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_gre.c
@@ -3,6 +3,7 @@
 
 #include <net/gre.h>
 #include "en/tc_tun.h"
+#include "fs_core.h"
 
 static bool mlx5e_tc_tun_can_offload_gretap(struct mlx5e_priv *priv)
 {
@@ -89,6 +90,35 @@ static int mlx5e_tc_tun_parse_gretap(struct mlx5e_priv *priv,
 	return 0;
 }
 
+static int
+mlx5e_tc_tun_parse_outer_key_gre(struct mlx5e_priv *priv,
+				 struct mlx5_flow_spec *spec,
+				 struct netlink_ext_ack *extack,
+				 u32 key, u32 mask,
+				 enum fs_flow_table_type fs_type)
+{
+	void *misc_c, *misc_v;
+
+	if (!MLX5_CAP_FLOWTABLE_TYPE(priv->mdev,
+				     ft_field_support.outer_gre_key,
+				     fs_type)) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Matching on GRE key is not supported");
+		return -EOPNOTSUPP;
+	}
+
+	misc_c = MLX5_ADDR_OF(fte_match_param, spec->match_criteria,
+			      misc_parameters);
+	misc_v = MLX5_ADDR_OF(fte_match_param, spec->match_value,
+			      misc_parameters);
+
+	MLX5_SET(fte_match_set_misc, misc_c, gre_key.key, mask);
+	MLX5_SET(fte_match_set_misc, misc_v, gre_key.key, key);
+	spec->match_criteria_enable |= MLX5_MATCH_MISC_PARAMETERS;
+
+	return 0;
+}
+
 struct mlx5e_tc_tunnel gre_tunnel = {
 	.tunnel_type          = MLX5E_TC_TUNNEL_TYPE_GRETAP,
 	.match_level          = MLX5_MATCH_L3,
@@ -98,5 +128,6 @@ struct mlx5e_tc_tunnel gre_tunnel = {
 	.generate_ip_tun_hdr  = mlx5e_gen_ip_tunnel_header_gretap,
 	.parse_udp_ports      = NULL,
 	.parse_tunnel         = mlx5e_tc_tun_parse_gretap,
+	.parse_outer_key      = mlx5e_tc_tun_parse_outer_key_gre,
 	.encap_info_equal     = mlx5e_tc_tun_encap_info_equal_generic,
 };
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_gtp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_gtp.c
new file mode 100644
index 000000000000..19c9bc1a30f5
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_gtp.c
@@ -0,0 +1,36 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+
+#include "en/tc_tun.h"
+
+static int
+mlx5e_tc_tun_parse_outer_key_gtp(struct mlx5e_priv *priv,
+				 struct mlx5_flow_spec *spec,
+				 struct netlink_ext_ack *extack,
+				 u32 key, u32 mask,
+				 enum fs_flow_table_type fs_type)
+{
+	void *misc3_c, *misc3_v;
+
+	if (!(MLX5_CAP_GEN(priv->mdev, flex_parser_protocols) &
+	      MLX5_FLEX_PARSER_GTPU_TEID_ENABLED)) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Matching on GTP-U TEID is not supported");
+		return -EOPNOTSUPP;
+	}
+
+	misc3_c = MLX5_ADDR_OF(fte_match_param, spec->match_criteria,
+			       misc_parameters_3);
+	misc3_v = MLX5_ADDR_OF(fte_match_param, spec->match_value,
+			       misc_parameters_3);
+
+	MLX5_SET(fte_match_set_misc3, misc3_c, gtpu_teid, mask);
+	MLX5_SET(fte_match_set_misc3, misc3_v, gtpu_teid, key);
+	spec->match_criteria_enable |= MLX5_MATCH_MISC_PARAMETERS_3;
+
+	return 0;
+}
+
+/* The driver offloads no GTP device so this only matches on the wire */
+struct mlx5e_tc_tunnel gtp_tunnel = {
+	.parse_outer_key = mlx5e_tc_tun_parse_outer_key_gtp,
+};
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_vxlan.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_vxlan.c
index 33911e72d20d..610e2bbc21f1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_vxlan.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_vxlan.c
@@ -5,6 +5,7 @@
 #include <net/vxlan.h>
 #include "lib/vxlan.h"
 #include "en/tc_tun.h"
+#include "fs_core.h"
 
 static bool mlx5e_tc_tun_can_offload_vxlan(struct mlx5e_priv *priv)
 {
@@ -261,6 +262,41 @@ static int mlx5e_tc_tun_get_remote_ifindex(struct net_device *mirred_dev)
 	return ifindex;
 }
 
+static int
+mlx5e_tc_tun_parse_outer_key_vxlan(struct mlx5e_priv *priv,
+				   struct mlx5_flow_spec *spec,
+				   struct netlink_ext_ack *extack,
+				   u32 key, u32 mask,
+				   enum fs_flow_table_type fs_type)
+{
+	void *misc_c, *misc_v;
+
+	if (key >= MLX5E_TC_TUN_N_VNI) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Tunnel key does not fit the 24 bit VNI");
+		return -EOPNOTSUPP;
+	}
+
+	if (!MLX5_CAP_FLOWTABLE_TYPE(priv->mdev,
+				     ft_field_support.outer_vxlan_vni,
+				     fs_type)) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Matching on VXLAN VNI is not supported");
+		return -EOPNOTSUPP;
+	}
+
+	misc_c = MLX5_ADDR_OF(fte_match_param, spec->match_criteria,
+			      misc_parameters);
+	misc_v = MLX5_ADDR_OF(fte_match_param, spec->match_value,
+			      misc_parameters);
+
+	MLX5_SET(fte_match_set_misc, misc_c, vxlan_vni, mask);
+	MLX5_SET(fte_match_set_misc, misc_v, vxlan_vni, key);
+	spec->match_criteria_enable |= MLX5_MATCH_MISC_PARAMETERS;
+
+	return 0;
+}
+
 struct mlx5e_tc_tunnel vxlan_tunnel = {
 	.tunnel_type          = MLX5E_TC_TUNNEL_TYPE_VXLAN,
 	.match_level          = MLX5_MATCH_L4,
@@ -270,6 +306,7 @@ struct mlx5e_tc_tunnel vxlan_tunnel = {
 	.generate_ip_tun_hdr  = mlx5e_gen_ip_tunnel_header_vxlan,
 	.parse_udp_ports      = mlx5e_tc_tun_parse_udp_ports_vxlan,
 	.parse_tunnel         = mlx5e_tc_tun_parse_vxlan,
+	.parse_outer_key      = mlx5e_tc_tun_parse_outer_key_vxlan,
 	.encap_info_equal     = mlx5e_tc_tun_encap_info_equal_vxlan,
 	.get_remote_ifindex   = mlx5e_tc_tun_get_remote_ifindex,
 };
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 3823ccc60dd3..6780e54a0cb9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -2786,6 +2786,10 @@ static int __parse_cls_flower(struct mlx5e_priv *priv,
 		err = mlx5e_tc_verify_tunnel_ecn(priv, f, &match_inner_ecn);
 		if (err)
 			return err;
+	} else if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_ENC_KEYID)) {
+		err = mlx5e_tc_tun_parse_outer_key(priv, spec, f, fs_type);
+		if (err)
+			return err;
 	}
 
 	err = mlx5e_flower_parse_meta(filter_dev, f);
-- 
2.43.0

