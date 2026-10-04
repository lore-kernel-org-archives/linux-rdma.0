Received: from mail-ed2-f32.google.com (mail-ed2-f32.google.com [74.125.228.96])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FB66471276
	for <linux-rdma@vger.kernel.org>; Sun,  4 Oct 2026 17:16:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.96
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791134205; cv=none; b=ZodesHVMnF3gSX53pyCPA5HxDR9G2TpGEQugsBWcS3qX6W2OQJyNM7SfR8nr/btm0V9VMKzxSS38N5rr0Y5fLC+5nywXfJ51P9h964XpMv//sqHiWgGj3UJ/6uT/Ba8PQ95SYAVJSp01tYyNXGH5P1lV73iHTyb0NVG+TWOI7Q0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791134205; c=relaxed/simple;
	bh=nXd/4LFPlNEFAa0PUcYz+6AQtYlG+zgB4vefordwf/g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RsxUZOval/t6pBNRLz3xvK0sk56KK6Jc+kQbd9Ef7Z+tetvYl627rOmXtUEGjzbjZ8j03fOALYPBtFb5JqMCU6IvRjgvvbNYgILE1hiZo2gffDHIdkDzKIPF5IYJdPDSrdxYATePRLbgYkXzbRJOXanKg88J24aSxIdRGXM486s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de; spf=pass smtp.mailfrom=bairaktaris.de; dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b=DswtWeql; arc=none smtp.client-ip=74.125.228.96
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b="DswtWeql"
Received: by mail-ed2-f32.google.com with SMTP id 4fb4d7f45d1cf-6af7d702c76so1313736a12.1
        for <linux-rdma@vger.kernel.org>; Sun, 04 Oct 2026 10:16:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bairaktaris.de; s=google; t=1791134200; x=1791739000; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=aLYtPbQjZgcuVs2CGURwKTgeknAxIQmlp31jFys2sGU=;
        b=DswtWeqlhhaRjYDSnFlxmYoIL1ItD9tb4pm9l9TAY00Zmv3jmmlCQVvDTXg5805Ixj
         GgQIQvTeN5irSsyHpCvsPnYDMP0GFpzujovHF8ISuNRtEZhl+qDZYI0EzTjRCYY0FJe3
         11itbIg+ZDnArcUEfqme1OefcMlC7VR6rMnaT3iFlYXI+S9OlppROZRcfGe1n9itSZb3
         +cY2Kk1tA+0FqRv3PxJ2ioOkPEa0vTq/kdpP+eIKyL6Nin4MXYLyZy9cWuAjcKq2QKhq
         b5HZCTXouGYcopBpbEnNG/DR6+UZl9R1+md9IsJiD8Do4ycE0q5DlnXZwgEdcXLlon3f
         coeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791134200; x=1791739000;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=aLYtPbQjZgcuVs2CGURwKTgeknAxIQmlp31jFys2sGU=;
        b=TqL/r++WqhISY2QNPVE1oO1nttz/dWZOnK0Awv3X2QJwNT3wTkgYC4emuBEH6rTfb/
         S6SGiQaRIS54S7aYE8+rwUpdQt0Rtrw+QwkQFe2dCZAm9JrFJmrijYnDg0vDSsW4Bbvi
         jJokBb5VL6oulwZl2OxRUxvtfadLSwUrKMr834vIuVlnAl1pC7q8n2JVVFGmHp6TnGWC
         P+nse6pe+d7sTt2F2FonjDHChyDnGhRl7T67w5xrmLgMiUDvQ8EU2zYLsQlLdNb0fm10
         AZ3QfTad2PrIvLuf66t2oxvc+RX5Zt4JJy5lSAVWImjcNJ+8pRRn4n4czO+/jL2rrNYq
         Bp+g==
X-Forwarded-Encrypted: i=1; AKwUvByp75nKJn80ylQaYbHb/0vQuuo8V/DrfcfaSgfU5oEJ0ATkE97U3snDHR/BEfsfRpcZmrfX9pPR/hGj@vger.kernel.org
X-Gm-Message-State: AFq9FYKNpixGIKfcnC/7jicju9NSr/q8+ffyQaYGXH+9+5hJf8yRK2JX
	OFpxfs6d1jnK11WgKxpDj5cYWKQSFzOSReMCnO9t7HOiCsZmkRSwt5ENFnmq/iP3Tg==
X-Gm-Gg: AYBFou01JAKHekUO85dE/Zm+jPwkyP2qYysrLC7kGYaodYuvj8yUHHTQoOLsxju0Sxi
	HxjbRa/ajM+PLHH+BktdAj4KGxFG3dRxRdAx4gU65WCAdhStV5yot/wLHBNxkQfA3Qkjjmkwpue
	IHsd4pdpe7TP8W1BucKhheMYr9VCYZwOVbRG+EskrDZmtp/PzS+YS3R5qLBg9dC59DY7qm0DRgh
	Tnk1rhAUEwiKlJiqVRiWlh2/vhebMXrc0oRLhHzFhl/H/aSsz4IerqbfmDjl2j45xE2imufA0zr
	RaKccrpE3UHmxOY/BbVO/68J6iPxo1OMpevis48FQ7opuW3+3uOflEdtDI/JkU9WkdoecMc+Qbp
	BjcQWiJTW/yh+HgKqK8zYTeVLj9SiEeI2kg72zCBiY79vOy0UdQEQTIN8SrUH+ExLq1jWk/hQzs
	McENrhsuOr+XLEDuDH+QjyDaPg7mr+/wxUr9ZlPXr+Wt4HuaVqsPyNfnnDlaUs8TDoU9oWaJ4xz
	/EDJhrmPrDTXkuLq2vKKyP8sGPepcNmyOp4FkvEEv52PcPEtKxd4B5N5BwEfuBvFuMTa/yrxT0q
	BAZGYyjNcpQuQveXC5HcUG2/Bxz2NFlSb7kvWEcxseZraho2nUOwQ3SJT+eos/RC8BDCTLuSPT2
	IHi4cWwDfoU73AO+AgXsDi3cQeoFrhkAibzeUBWt77ozUY3bzWdtF/xCMpskYrSWDIuQwIi0gLA
	F5pwhAADflLgrN5yqF29aKhRGC
X-Received: by 2002:a05:6402:3905:b0:6aa:e46b:2ca with SMTP id 4fb4d7f45d1cf-6af9e2fe4ddmr6623554a12.30.1791134200443;
        Sun, 04 Oct 2026 10:16:40 -0700 (PDT)
Received: from Desktop (pd9513667.dip0.t-ipconnect.de. [217.81.54.103])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6afb014784bsm2256819a12.3.2026.10.04.10.16.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Oct 2026 10:16:39 -0700 (PDT)
From: Julius Bairaktaris <julius@bairaktaris.de>
To: pablo@netfilter.org,
	fw@strlen.de
Cc: phil@nwl.cc,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	lorenzo@kernel.org,
	nbd@nbd.name,
	matthias.bgg@gmail.com,
	angelogioacchino.delregno@collabora.com,
	andrew+netdev@lunn.ch,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org,
	corbet@lwn.net,
	rdunlap@infradead.org,
	skhan@linuxfoundation.org,
	linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org,
	saeedm@nvidia.com,
	leon@kernel.org,
	tariqt@nvidia.com,
	mbloch@nvidia.com,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH nf-next v3 1/3] net/mlx5e: Ignore FLOW_ACTION_PRIORITY on flowtable offload
Date: Sun,  4 Oct 2026 19:16:34 +0200
Message-ID: <20261004171636.3545085-2-julius@bairaktaris.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261004171636.3545085-1-julius@bairaktaris.de>
References: <20261004171636.3545085-1-julius@bairaktaris.de>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The next patch makes the flowtable emit FLOW_ACTION_PRIORITY for flows
with a non-zero skb->priority, which on IPv4 includes the priority
ip_forward() derives from the TOS by default. mlx5 would reject these
rules and stop offloading flows it offloads today.

The eswitch does not use skb->priority for these flows, so accept the
action on flowtable flows and ignore it. tc flower rules with skbedit
priority are still rejected.

Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Julius Bairaktaris <julius@bairaktaris.de>
---
 .../net/ethernet/mellanox/mlx5/core/Makefile  |  2 +-
 .../mellanox/mlx5/core/en/tc/act/act.c        |  1 +
 .../mellanox/mlx5/core/en/tc/act/act.h        |  1 +
 .../mellanox/mlx5/core/en/tc/act/prio.c       | 22 +++++++++++++++++++
 4 files changed, 25 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/prio.c

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Makefile b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
index 19e50f0d55af..8bd352e7f20d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Makefile
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
@@ -54,7 +54,7 @@ mlx5_core-$(CONFIG_MLX5_CLS_ACT)     += en/tc/act/act.o en/tc/act/drop.o en/tc/a
 					en/tc/act/accept.o en/tc/act/mark.o en/tc/act/goto.o \
 					en/tc/act/tun.o en/tc/act/csum.o en/tc/act/pedit.o \
 					en/tc/act/vlan.o en/tc/act/vlan_mangle.o en/tc/act/mpls.o \
-					en/tc/act/mirred.o en/tc/act/mirred_nic.o \
+					en/tc/act/mirred.o en/tc/act/mirred_nic.o en/tc/act/prio.o \
 					en/tc/act/ct.o en/tc/act/sample.o en/tc/act/ptype.o \
 					en/tc/act/redirect_ingress.o en/tc/act/police.o
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.c
index 0380a04c3691..91a3bab5e498 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.c
@@ -23,6 +23,7 @@ static struct mlx5e_tc_act *tc_acts_fdb[NUM_FLOW_ACTIONS] = {
 	[FLOW_ACTION_ADD] = &mlx5e_tc_act_pedit,
 	[FLOW_ACTION_CSUM] = &mlx5e_tc_act_csum,
 	[FLOW_ACTION_PTYPE] = &mlx5e_tc_act_ptype,
+	[FLOW_ACTION_PRIORITY] = &mlx5e_tc_act_prio,
 	[FLOW_ACTION_SAMPLE] = &mlx5e_tc_act_sample,
 	[FLOW_ACTION_POLICE] = &mlx5e_tc_act_police,
 	[FLOW_ACTION_CT] = &mlx5e_tc_act_ct,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.h b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.h
index 2e528b2c34d6..bacbc862970e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.h
@@ -81,6 +81,7 @@ extern struct mlx5e_tc_act mlx5e_tc_act_goto;
 extern struct mlx5e_tc_act mlx5e_tc_act_tun_encap;
 extern struct mlx5e_tc_act mlx5e_tc_act_tun_decap;
 extern struct mlx5e_tc_act mlx5e_tc_act_csum;
+extern struct mlx5e_tc_act mlx5e_tc_act_prio;
 extern struct mlx5e_tc_act mlx5e_tc_act_pedit;
 extern struct mlx5e_tc_act mlx5e_tc_act_vlan;
 extern struct mlx5e_tc_act mlx5e_tc_act_vlan_mangle;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/prio.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/prio.c
new file mode 100644
index 000000000000..2a047059574b
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/prio.c
@@ -0,0 +1,22 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+
+#include "act.h"
+#include "en/tc_priv.h"
+
+static int
+tc_act_parse_prio(struct mlx5e_tc_act_parse_state *parse_state,
+		  const struct flow_action_entry *act,
+		  struct mlx5e_priv *priv,
+		  struct mlx5_flow_attr *attr)
+{
+	/* The eswitch does not apply skb->priority to flowtable flows. */
+	if (mlx5e_is_ft_flow(parse_state->flow))
+		return 0;
+
+	NL_SET_ERR_MSG_MOD(parse_state->extack, "skbedit priority is not supported");
+	return -EOPNOTSUPP;
+}
+
+struct mlx5e_tc_act mlx5e_tc_act_prio = {
+	.parse_action = tc_act_parse_prio,
+};
-- 
2.53.0

