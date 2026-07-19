Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E73353B42EF
	for <linux-rdma@vger.kernel.org>; Sun, 19 Jul 2026 18:00:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784484037; cv=none; b=lCghiFOzRf0IaCiw1872VSXhSrtPkk6JkqXFM6fwBG73b6B40kvQNMha/lpuoGDq2PoCgObnpUGMcbLyXRiH9ELdLdK4qSixqYEcXXRaNws78zsM/ftz7w+4HuqeSmJ/8u3sglCJnNf9BtYEXNNCGV4UC+LvF4K0/7AiK0zYoPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784484037; c=relaxed/simple;
	bh=64dr6/EhjExhAai+doRKHdZG800ipBjWqecG8I8FlME=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jl5DoksTdGM/0NUGXphi19LpqmPmcTEmdjInnSVRUElRAhqIreCBJr+yOBjOWsQcC2IK7fwdj6/Jky6S6R5tppTfpUrBfWhps3kCPMvT05XzWBQwngLPbP/NQTOd6l9IwXaeLTvJOescZp6nNCGySP2V4LL+zBzcuCdrvfQ8DWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KjBPSF+5; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KjBPSF+5"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2cab973140bso115377105ad.3
        for <linux-rdma@vger.kernel.org>; Sun, 19 Jul 2026 11:00:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784484026; x=1785088826; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=Oa/inmGTRuGYQ1CvN1g/UdrfMqnsy164WzZKu4NRiN8=;
        b=KjBPSF+5ZQMdu/70C3DvJm+cM7b5mmWWXenGKJ5RDjgOFF+FPZNRwDXTl2yS6kHChv
         8MtWrbC5rSwXGIAQMfuun58H6OKgKnTvt6SSw0GijSE2x5F0/pzadjtkp9PgUzYf8I8J
         DU7ror25SbH3EGF14+Ht0I3KXm44AzH2SPAWa7oo7y0V2QMJQ2QUpNAiHtbaOgtYHrcC
         XTK/4yGomcXYjqq4tvaXCzWCEMsfbJIIyNuErl1ePVbRM1dEanSYh/qSXMI8gyQEolje
         D/lDmTyUB2wODad7UT4KxwfdB19wR2J39/doAlw/zy7APttxnQh3QdUUERTcPXrvyvRQ
         6Fdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784484026; x=1785088826;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=Oa/inmGTRuGYQ1CvN1g/UdrfMqnsy164WzZKu4NRiN8=;
        b=IjPG5lrACMoSKYIAY7Dae8Yh5yZa8AP4gq/olY6KoT9WY1s6NGygrCvcVll9KSgvYW
         tY/d8YkldGRI/DDcYFFdy4JGkQNvgTbmvc+U+TGdhhyT0OqQEEkgs0DnJ7Yem1I0qk5c
         xWGR8VEE2h/G7fD8XEUMGusgYazLH25FqpsoNu7tXVvdMs7ClnfnbFsVCZnYYzbVtXgY
         m2mbKlz9+6+GDBpYwQkSQn8l8RWG+NxuXuPYgFLIX3enKvMDDT3HmnvThgJspMk23sPz
         THEa/FTHutKmmcmJ0fpbbctETLnmn7qwbU+tJrDLieH2vJzr0TqayyzBVyo9EsVoFpJa
         2vWw==
X-Forwarded-Encrypted: i=1; AHgh+RqDR5sNmp+eiCvmnFr6qPOjQ/kK2AwVZnc/Nhml9cui1kXIaHewcTGvyaHmRaVjRtb2ECKCsmPu5aq5@vger.kernel.org
X-Gm-Message-State: AOJu0YySk2kzC+KxmnCznWPgkRQfvnzCH2udy1ykHRRIPwpGo81bsjs+
	n5it9NfDfBNXYQSe3e8rgOws59IG1xa0cd1z2dV0I3Q9GYHQ21YpShss
X-Gm-Gg: AfdE7cm65hCP6uXK1nKHmiCPzpSRI43t7+JgD7tNgk9SXjgiPh3iaMGar71cgNOIqcb
	EORdckw83nJibFQpd/WzZ4qJthlz6YwHSS0cvvGU+Abz9EjjGxHBZtP90r/RQGKQ7FR5fO3hiq3
	mtljVSyIv0snl0qPeTdF925WlC/GsiE7kL9cWhdtIWW4fc6hF94r1H7vkRmRyicVZjuQN8USAvv
	h09PdmyhNtgimYlxyZfRPT2+P8wMo5uRZ5svHSKoiG4ch0k7IfD0Oks7II+2BGsKugsDkPdpYwZ
	tAzc0CNpSsmJhby8kbcOF3DJfVaUujS6/5WAFSGSUudI1MmVa6cqAWRxCcqwAogh1P0KpR4dX7e
	3DW3ziJKd+vcclcRsA+No6eRhe3TuK3Ruz3D3B/sjPQVtUtTn5v6vACoLVHZSL1Bi3Q==
X-Received: by 2002:a17:902:d490:b0:2ce:faa6:7cbb with SMTP id d9443c01a7336-2cf348325bdmr124065555ad.4.1784484025887;
        Sun, 19 Jul 2026 11:00:25 -0700 (PDT)
Received: from ap.. ([182.213.254.91])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cf34769bd6sm43511065ad.74.2026.07.19.11.00.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Jul 2026 11:00:25 -0700 (PDT)
From: Taehee Yoo <ap420073@gmail.com>
To: Alex Deucher <alexander.deucher@amd.com>,
	Alexei Starovoitov <ast@kernel.org>,
	amd-gfx@lists.freedesktop.org,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	Andrii Nakryiko <andrii@kernel.org>,
	Bill Wendling <morbo@google.com>,
	bpf@vger.kernel.org,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	David Airlie <airlied@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Donald Hunter <donald.hunter@gmail.com>,
	dri-devel@lists.freedesktop.org,
	Eduard Zingerman <eddyz87@gmail.com>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Eric Dumazet <edumazet@google.com>,
	Felix Kuehling <Felix.Kuehling@amd.com>,
	Hoyeon Lee <hoyeon.rhee@gmail.com>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>,
	John Fastabend <john.fastabend@gmail.com>,
	Justin Stitt <justinstitt@google.com>,
	Kees Cook <kees@kernel.org>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Leon Romanovsky <leon@kernel.org>,
	linaro-mm-sig@lists.linaro.org,
	linux-hardening@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-media@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	llvm@lists.linux.dev,
	Mark Bloch <mbloch@nvidia.com>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Michael Chan <michael.chan@broadcom.com>,
	Nathan Chancellor <nathan@kernel.org>,
	netdev@vger.kernel.org,
	Nick Desaulniers <ndesaulniers@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Pavan Chebbi <pavan.chebbi@broadcom.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Shuah Khan <shuah@kernel.org>,
	Simona Vetter <simona@ffwll.ch>,
	Simon Horman <horms@kernel.org>,
	Song Liu <song@kernel.org>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Taehee Yoo <ap420073@gmail.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Yonghong Song <yonghong.song@linux.dev>
Subject: [RFC PATCH net-next 04/13] net: knod: add offload device core and control plane
Date: Sun, 19 Jul 2026 17:58:48 +0000
Message-ID: <20260719175857.4071636-5-ap420073@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260719175857.4071636-1-ap420073@gmail.com>
References: <20260719175857.4071636-1-ap420073@gmail.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add the KNOD core framework and its genetlink control plane.

The core maintains three object types - a NIC-side netdev, an
accelerator, and a dynamically created offload device that binds them -
and drives the RX data path over per-queue SPSC rings backed by a
page_pool of accelerator memory.

The genetlink family ("knod") exposes attach/detach, device/nic/accel
inventory, and per-accelerator feature selection as a stable uAPI.

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
(cherry picked from commit f17f82a39be852aa8c520aea7177ce0086f7e811)
---
 net/Kconfig            |    2 +
 net/Makefile           |    1 +
 net/knod/Kconfig       |    5 +
 net/knod/Makefile      |    8 +
 net/knod/knod-nl-gen.c |  121 ++++
 net/knod/knod-nl-gen.h |   31 +
 net/knod/knod.h        |   26 +
 net/knod/knod_core.c   | 1231 ++++++++++++++++++++++++++++++++++++++++
 net/knod/knod_nl.c     |  406 +++++++++++++
 9 files changed, 1831 insertions(+)
 create mode 100644 net/knod/Kconfig
 create mode 100644 net/knod/Makefile
 create mode 100644 net/knod/knod-nl-gen.c
 create mode 100644 net/knod/knod-nl-gen.h
 create mode 100644 net/knod/knod.h
 create mode 100644 net/knod/knod_core.c
 create mode 100644 net/knod/knod_nl.c

diff --git a/net/Kconfig b/net/Kconfig
index e38477393551..e7a2200e92cc 100644
--- a/net/Kconfig
+++ b/net/Kconfig
@@ -72,6 +72,8 @@ config NET_DEVMEM
 	depends on DMA_SHARED_BUFFER
 	depends on PAGE_POOL
 
+source "net/knod/Kconfig"
+
 config NET_SHAPER
 	bool
 
diff --git a/net/Makefile b/net/Makefile
index 5b2dd7f07a85..ea4ef5c5906d 100644
--- a/net/Makefile
+++ b/net/Makefile
@@ -19,6 +19,7 @@ obj-$(CONFIG_TLS)		+= tls/
 obj-$(CONFIG_XFRM)		+= xfrm/
 obj-$(CONFIG_UNIX)		+= unix/
 obj-$(CONFIG_INET_PSP)		+= psp/
+obj-$(CONFIG_KNOD)	+= knod/
 obj-y				+= ipv6/
 obj-$(CONFIG_PACKET)		+= packet/
 obj-$(CONFIG_NET_KEY)		+= key/
diff --git a/net/knod/Kconfig b/net/knod/Kconfig
new file mode 100644
index 000000000000..d5a6d76d33e3
--- /dev/null
+++ b/net/knod/Kconfig
@@ -0,0 +1,5 @@
+# SPDX-License-Identifier: GPL-2.0-or-later
+
+config KNOD
+	def_bool y
+	depends on NET_DEVMEM
diff --git a/net/knod/Makefile b/net/knod/Makefile
new file mode 100644
index 000000000000..73abe5c99f8c
--- /dev/null
+++ b/net/knod/Makefile
@@ -0,0 +1,8 @@
+# SPDX-License-Identifier: GPL-2.0-or-later
+#
+# Makefile for the KNOD (KFD network offload) control plane.
+#
+
+obj-$(CONFIG_KNOD) += knod.o
+
+knod-y := knod_core.o knod_nl.o knod-nl-gen.o
diff --git a/net/knod/knod-nl-gen.c b/net/knod/knod-nl-gen.c
new file mode 100644
index 000000000000..96042f0c15c9
--- /dev/null
+++ b/net/knod/knod-nl-gen.c
@@ -0,0 +1,121 @@
+// SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-3-Clause)
+/* Do not edit directly, auto-generated from: */
+/*	Documentation/netlink/specs/knod.yaml */
+/* YNL-GEN kernel source */
+/* To regenerate run: tools/net/ynl/ynl-regen.sh */
+
+#include <net/netlink.h>
+#include <net/genetlink.h>
+
+#include "knod-nl-gen.h"
+
+#include <uapi/linux/knod.h>
+
+/* KNOD_CMD_ACCEL_GET - do */
+static const struct nla_policy knod_accel_get_nl_policy[KNOD_A_ACCEL_ID + 1] = {
+	[KNOD_A_ACCEL_ID] = NLA_POLICY_MIN(NLA_U32, 1),
+};
+
+/* KNOD_CMD_ACCEL_SET - do */
+static const struct nla_policy knod_accel_set_nl_policy[KNOD_A_ACCEL_FEATURE_ENA + 1] = {
+	[KNOD_A_ACCEL_ID] = NLA_POLICY_MIN(NLA_U32, 1),
+	[KNOD_A_ACCEL_FEATURE_ENA] = NLA_POLICY_MAX(NLA_U32, 2),
+};
+
+/* KNOD_CMD_NIC_GET - do */
+static const struct nla_policy knod_nic_get_nl_policy[KNOD_A_NIC_IFINDEX + 1] = {
+	[KNOD_A_NIC_IFINDEX] = NLA_POLICY_MIN(NLA_U32, 1),
+};
+
+/* KNOD_CMD_ATTACH - do */
+static const struct nla_policy knod_attach_nl_policy[KNOD_A_DEV_ACCEL_ID + 1] = {
+	[KNOD_A_DEV_NIC_IFINDEX] = NLA_POLICY_MIN(NLA_U32, 1),
+	[KNOD_A_DEV_ACCEL_ID] = NLA_POLICY_MIN(NLA_U32, 1),
+};
+
+/* KNOD_CMD_DETACH - do */
+static const struct nla_policy knod_detach_nl_policy[KNOD_A_DEV_NIC_IFINDEX + 1] = {
+	[KNOD_A_DEV_NIC_IFINDEX] = NLA_POLICY_MIN(NLA_U32, 1),
+};
+
+/* KNOD_CMD_DEV_GET - do */
+static const struct nla_policy knod_dev_get_nl_policy[KNOD_A_DEV_NIC_IFINDEX + 1] = {
+	[KNOD_A_DEV_NIC_IFINDEX] = NLA_POLICY_MIN(NLA_U32, 1),
+};
+
+/* Ops table for knod */
+static const struct genl_split_ops knod_nl_ops[] = {
+	{
+		.cmd		= KNOD_CMD_ACCEL_GET,
+		.doit		= knod_nl_accel_get_doit,
+		.policy		= knod_accel_get_nl_policy,
+		.maxattr	= KNOD_A_ACCEL_ID,
+		.flags		= GENL_CMD_CAP_DO,
+	},
+	{
+		.cmd	= KNOD_CMD_ACCEL_GET,
+		.dumpit	= knod_nl_accel_get_dumpit,
+		.flags	= GENL_CMD_CAP_DUMP,
+	},
+	{
+		.cmd		= KNOD_CMD_ACCEL_SET,
+		.doit		= knod_nl_accel_set_doit,
+		.policy		= knod_accel_set_nl_policy,
+		.maxattr	= KNOD_A_ACCEL_FEATURE_ENA,
+		.flags		= GENL_ADMIN_PERM | GENL_CMD_CAP_DO,
+	},
+	{
+		.cmd		= KNOD_CMD_NIC_GET,
+		.doit		= knod_nl_nic_get_doit,
+		.policy		= knod_nic_get_nl_policy,
+		.maxattr	= KNOD_A_NIC_IFINDEX,
+		.flags		= GENL_CMD_CAP_DO,
+	},
+	{
+		.cmd	= KNOD_CMD_NIC_GET,
+		.dumpit	= knod_nl_nic_get_dumpit,
+		.flags	= GENL_CMD_CAP_DUMP,
+	},
+	{
+		.cmd		= KNOD_CMD_ATTACH,
+		.doit		= knod_nl_attach_doit,
+		.policy		= knod_attach_nl_policy,
+		.maxattr	= KNOD_A_DEV_ACCEL_ID,
+		.flags		= GENL_ADMIN_PERM | GENL_CMD_CAP_DO,
+	},
+	{
+		.cmd		= KNOD_CMD_DETACH,
+		.doit		= knod_nl_detach_doit,
+		.policy		= knod_detach_nl_policy,
+		.maxattr	= KNOD_A_DEV_NIC_IFINDEX,
+		.flags		= GENL_ADMIN_PERM | GENL_CMD_CAP_DO,
+	},
+	{
+		.cmd		= KNOD_CMD_DEV_GET,
+		.doit		= knod_nl_dev_get_doit,
+		.policy		= knod_dev_get_nl_policy,
+		.maxattr	= KNOD_A_DEV_NIC_IFINDEX,
+		.flags		= GENL_CMD_CAP_DO,
+	},
+	{
+		.cmd	= KNOD_CMD_DEV_GET,
+		.dumpit	= knod_nl_dev_get_dumpit,
+		.flags	= GENL_CMD_CAP_DUMP,
+	},
+};
+
+static const struct genl_multicast_group knod_nl_mcgrps[] = {
+	[KNOD_NLGRP_MGMT] = { "mgmt", },
+};
+
+struct genl_family knod_nl_family __ro_after_init = {
+	.name		= KNOD_FAMILY_NAME,
+	.version	= KNOD_FAMILY_VERSION,
+	.netnsok	= true,
+	.parallel_ops	= true,
+	.module		= THIS_MODULE,
+	.split_ops	= knod_nl_ops,
+	.n_split_ops	= ARRAY_SIZE(knod_nl_ops),
+	.mcgrps		= knod_nl_mcgrps,
+	.n_mcgrps	= ARRAY_SIZE(knod_nl_mcgrps),
+};
diff --git a/net/knod/knod-nl-gen.h b/net/knod/knod-nl-gen.h
new file mode 100644
index 000000000000..a12b6a174bed
--- /dev/null
+++ b/net/knod/knod-nl-gen.h
@@ -0,0 +1,31 @@
+/* SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-3-Clause) */
+/* Do not edit directly, auto-generated from: */
+/*	Documentation/netlink/specs/knod.yaml */
+/* YNL-GEN kernel header */
+/* To regenerate run: tools/net/ynl/ynl-regen.sh */
+
+#ifndef _LINUX_KNOD_GEN_H
+#define _LINUX_KNOD_GEN_H
+
+#include <net/netlink.h>
+#include <net/genetlink.h>
+
+#include <uapi/linux/knod.h>
+
+int knod_nl_accel_get_doit(struct sk_buff *skb, struct genl_info *info);
+int knod_nl_accel_get_dumpit(struct sk_buff *skb, struct netlink_callback *cb);
+int knod_nl_accel_set_doit(struct sk_buff *skb, struct genl_info *info);
+int knod_nl_nic_get_doit(struct sk_buff *skb, struct genl_info *info);
+int knod_nl_nic_get_dumpit(struct sk_buff *skb, struct netlink_callback *cb);
+int knod_nl_attach_doit(struct sk_buff *skb, struct genl_info *info);
+int knod_nl_detach_doit(struct sk_buff *skb, struct genl_info *info);
+int knod_nl_dev_get_doit(struct sk_buff *skb, struct genl_info *info);
+int knod_nl_dev_get_dumpit(struct sk_buff *skb, struct netlink_callback *cb);
+
+enum {
+	KNOD_NLGRP_MGMT,
+};
+
+extern struct genl_family knod_nl_family;
+
+#endif /* _LINUX_KNOD_GEN_H */
diff --git a/net/knod/knod.h b/net/knod/knod.h
new file mode 100644
index 000000000000..eaff0e82ca23
--- /dev/null
+++ b/net/knod/knod.h
@@ -0,0 +1,26 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/* Copyright (c) 2021 Taehee Yoo <ap420073@gmail.com>
+ * Copyright (c) 2021 Hoyeon Lee <hoyeon.rhee@gmail.com>
+ */
+
+#ifndef _NET_KNOD_KNOD_H
+#define _NET_KNOD_KNOD_H
+
+#include <net/knod.h>
+
+#include "knod-nl-gen.h"
+
+struct net_device;
+
+/* knod_core.c */
+struct knod_netdev *knod_netdev_lookup(struct net_device *dev);
+struct knod_dev *knod_dev_lookup(struct net_device *dev);
+struct knod_accel *knod_accel_lookup(int id);
+int knod_dev_attach(struct knod_netdev *knetdev,
+			   struct knod_accel *accel);
+int knod_dev_detach(struct knod_dev *knodev);
+
+/* knod_nl.c */
+void knod_nl_notify_dev(struct knod_dev *knodev, u32 cmd);
+
+#endif /* _NET_KNOD_KNOD_H */
diff --git a/net/knod/knod_core.c b/net/knod/knod_core.c
new file mode 100644
index 000000000000..af50a69bca65
--- /dev/null
+++ b/net/knod/knod_core.c
@@ -0,0 +1,1231 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/* Copyright (c) 2021 Taehee Yoo <ap420073@gmail.com>
+ * Copyright (c) 2021 Hoyeon Lee <hoyeon.rhee@gmail.com>
+ */
+
+#include <net/knod.h>
+#include <net/spsc_ring.h>
+#include <net/page_pool/types.h>
+#include <net/page_pool/helpers.h>
+#include <net/page_pool/memory_provider.h>
+#include <net/xfrm.h>
+#include <linux/genalloc.h>
+#include <trace/events/page_pool.h>
+#include <net/devmem.h>
+
+#include "knod.h"
+
+DEFINE_MUTEX(knod_lock);
+LIST_HEAD(knod_dev_list);
+EXPORT_SYMBOL_GPL(knod_dev_list);
+LIST_HEAD(knod_netdev_list);
+EXPORT_SYMBOL_GPL(knod_netdev_list);
+LIST_HEAD(knod_accel_list);
+EXPORT_SYMBOL_GPL(knod_accel_list);
+
+void knod_dev_lock(void)
+{
+	mutex_lock(&knod_lock);
+}
+EXPORT_SYMBOL_GPL(knod_dev_lock);
+
+void knod_dev_unlock(void)
+{
+	mutex_unlock(&knod_lock);
+}
+EXPORT_SYMBOL_GPL(knod_dev_unlock);
+
+void knod_netdev_register(struct knod_netdev *knetdev)
+{
+	mutex_lock(&knod_lock);
+	knetdev->status = KNOD_STATUS_FREE;
+	list_add(&knetdev->list, &knod_netdev_list);
+	mutex_unlock(&knod_lock);
+}
+EXPORT_SYMBOL(knod_netdev_register);
+
+void knod_netdev_unregister(struct knod_netdev *knetdev)
+{
+	mutex_lock(&knod_lock);
+	list_del(&knetdev->list);
+	mutex_unlock(&knod_lock);
+}
+EXPORT_SYMBOL(knod_netdev_unregister);
+
+void knod_accel_register(struct knod_accel *accel)
+{
+	mutex_lock(&knod_lock);
+	accel->status = KNOD_STATUS_FREE;
+	list_add(&accel->list, &knod_accel_list);
+	mutex_unlock(&knod_lock);
+}
+EXPORT_SYMBOL(knod_accel_register);
+
+void knod_accel_unregister(struct knod_accel *accel)
+{
+	mutex_lock(&knod_lock);
+	list_del(&accel->list);
+	mutex_unlock(&knod_lock);
+}
+EXPORT_SYMBOL(knod_accel_unregister);
+
+struct knod_netdev *knod_netdev_lookup(struct net_device *dev)
+{
+	struct knod_netdev *knetdev;
+
+	list_for_each_entry(knetdev, &knod_netdev_list, list)
+		if (knetdev->dev == dev)
+			return knetdev;
+
+	return NULL;
+}
+
+struct knod_dev *knod_dev_lookup(struct net_device *dev)
+{
+	struct knod_dev *knodev;
+
+	list_for_each_entry(knodev, &knod_dev_list, list)
+		if (knodev->netdev == dev)
+			return knodev;
+
+	return NULL;
+}
+
+struct knod_accel *knod_accel_lookup(int id)
+{
+	struct knod_accel *accel;
+
+	list_for_each_entry(accel, &knod_accel_list, list)
+		if (accel->id == id)
+			return accel;
+
+	return NULL;
+}
+
+void knod_dev_start(struct knod_dev *knodev)
+{
+	/* Interface up: start the active feature's worker. */
+	knodev->started = true;
+	if (knodev->accel_ops->dev_start)
+		knodev->accel_ops->dev_start(knodev);
+}
+EXPORT_SYMBOL(knod_dev_start);
+
+void knod_dev_stop(struct knod_dev *knodev)
+{
+	/* Interface down: stop the worker + drain the GPU in-flight. */
+	if (knodev->accel_ops->dev_stop)
+		knodev->accel_ops->dev_stop(knodev);
+	knodev->started = false;
+}
+EXPORT_SYMBOL(knod_dev_stop);
+
+int knod_dev_xdp_install(struct knod_dev *knodev, struct netdev_bpf *xdp)
+{
+	if (!knodev->accel_ops->xdp_ops ||
+	    !knodev->accel_ops->xdp_ops->xdp_install)
+		return -EOPNOTSUPP;
+	return knodev->accel_ops->xdp_ops->xdp_install(knodev, xdp);
+}
+EXPORT_SYMBOL(knod_dev_xdp_install);
+
+void knod_dev_get_stats64(struct knod_dev *knodev,
+			  struct rtnl_link_stats64 *stats)
+{
+	struct knod_dev_stats *p;
+	u32 tx_dropped = 0, tx_errors = 0;
+	u64 tx_packets, tx_bytes;
+	unsigned int start;
+	int i;
+
+	for_each_possible_cpu(i) {
+		p = per_cpu_ptr(knodev->stats, i);
+		do {
+			start = u64_stats_fetch_begin(&p->syncp);
+			tx_packets      = u64_stats_read(&p->tx_packets);
+			tx_bytes        = u64_stats_read(&p->tx_bytes);
+		} while (u64_stats_fetch_retry(&p->syncp, start));
+
+		stats->tx_packets       += tx_packets;
+		stats->tx_bytes         += tx_bytes;
+		tx_dropped      += READ_ONCE(p->tx_dropped);
+		tx_errors	+= READ_ONCE(p->tx_errors);
+	}
+	stats->tx_dropped       += tx_dropped;
+	stats->tx_errors	+= tx_errors;
+}
+EXPORT_SYMBOL(knod_dev_get_stats64);
+
+/*
+ * Wrap a delivery-pool page as a zero-copy head_frag skb: the packet sits at
+ * @off (preserved headroom) for @len bytes.  Building it linear keeps
+ * skb->data on the packet so callers can edit headers in place.  The page
+ * recycles to @pool when the skb is freed.  On oversize or alloc failure the
+ * page is returned to @pool and NULL is returned.  @napi selects the NAPI skb
+ * cache; callers outside softirq pass false.
+ */
+struct sk_buff *knod_pass_build_skb(netmem_ref netmem, u16 off, u16 len,
+				    struct page_pool *pool, bool napi)
+{
+	struct page *pg = netmem_to_page(netmem);
+	struct sk_buff *skb;
+
+	/* Must fit alongside skb_shared_info at the page tail; MTU is capped
+	 * below this, so drop the rare oversized outlier.
+	 */
+	if (off + len > SKB_WITH_OVERHEAD(PAGE_SIZE)) {
+		if (pool)
+			page_pool_put_full_netmem(pool, netmem, false);
+		return NULL;
+	}
+
+	if (napi)
+		skb = napi_build_skb(page_address(pg), PAGE_SIZE);
+	else
+		skb = build_skb(page_address(pg), PAGE_SIZE);
+	if (unlikely(!skb)) {
+		if (pool)
+			page_pool_put_full_netmem(pool, netmem, false);
+		return NULL;
+	}
+
+	skb_mark_for_recycle(skb);
+	skb_reserve(skb, off);
+	skb_put(skb, len);
+	return skb;
+}
+EXPORT_SYMBOL(knod_pass_build_skb);
+
+/*
+ * Device->host copy: the NIC DD hands the PASS bds it accumulated during its
+ * single act traversal.  Allocate a delivery page per packet, issue the accel
+ * SDMA (GPU -> page) asynchronously, and queue a descriptor on the per-queue
+ * pending ring tagged with this batch's fence; knod_d2h_drain delivers them
+ * once the fence lands and recycles the source.  Sources that cannot be queued
+ * (bad len / ring full / pool empty) are recycled here.  Returns the count
+ * queued.  Producer and the drain consumer run on the same per-queue NAPI, so
+ * the ring is single-threaded; @d2h_lock only guards the shared SDMA submit.
+ */
+int knod_d2h_copy(struct knod_dev *knodev, int napi_index,
+		  struct spsc_pass_bd *bds, int cnt)
+{
+	struct knod_accel_ops *ops = knodev->accel_ops;
+	struct knod_work_priv *wpriv;
+	struct page_pool *pool;
+	bool submitted = false;
+	int i, produced = 0;
+
+	if (napi_index < 0 || napi_index >= KNOD_SPSC_MAX || !ops->d2h_submit)
+		goto drop_all;
+	wpriv = &knodev->wpriv[napi_index];
+	pool = READ_ONCE(wpriv->pass_pool);
+	if (!pool || !wpriv->pass_pending.slots)
+		goto drop_all;
+
+	spin_lock(&knodev->d2h_lock);
+
+	for (i = 0; i < cnt; i++) {
+		netmem_ref src = bds[i].netmem;
+		struct knod_pass_desc *desc;
+		netmem_ref dst;
+		void *ptr;
+		u32 fv;
+		u16 off = bds[i].off;
+		u16 len = bds[i].len;
+
+		if (!len || off + len > SKB_WITH_OVERHEAD(PAGE_SIZE))
+			goto drop;
+		if (spsc_produce(&wpriv->pass_pending, &ptr))
+			goto drop;
+		dst = page_pool_dev_alloc_netmems(pool);
+		if (!dst)
+			goto drop;	/* slot left uncommitted, reused next */
+
+		fv = ops->d2h_submit(knodev,
+				     page_pool_get_dma_addr_netmem(dst) + off,
+				     napi_index, bds[i].page_idx, off, len);
+		if (!fv) {		/* SDMA ring full: backpressure drop */
+			page_pool_put_full_netmem(pool, dst, false);
+			goto drop;
+		}
+		submitted = true;
+
+		desc = ptr;
+		desc->netmem = dst;
+		desc->src = src;
+		desc->off = off;
+		desc->len = len;
+		desc->fence_val = fv;
+		desc->sdma_idx = 0;
+		spsc_produce_commit(&wpriv->pass_pending);
+		produced++;
+		continue;
+drop:
+		page_pool_recycle_direct_netmem(netmem_get_pp(src), src);
+	}
+
+	if (submitted)
+		ops->d2h_kick(knodev);
+	spin_unlock(&knodev->d2h_lock);
+
+	/* The copies are async; re-arm the NAPI so the drain runs once the
+	 * SDMA lands -- at low rate, RX traffic alone may not poll again soon.
+	 */
+	if (submitted)
+		knod_napi_kick(wpriv);
+	return produced;
+
+drop_all:
+	for (i = 0; i < cnt; i++)
+		page_pool_recycle_direct_netmem(netmem_get_pp(bds[i].netmem),
+						bds[i].netmem);
+	return 0;
+}
+EXPORT_SYMBOL(knod_d2h_copy);
+
+/*
+ * Drain the per-queue pending ring: deliver every descriptor whose batch
+ * fence has landed (accel_ops->d2h_fence) as a zero-copy head_frag skb from
+ * the delivery page, recycling the source RX page.  Stops at the first
+ * not-yet-landed descriptor -- the ring is in fence order.  Runs on the NIC
+ * NAPI, the same thread as the knod_d2h_copy producer.
+ */
+int knod_d2h_drain(struct knod_dev *knodev, int napi_index,
+		   struct napi_struct *napi, int budget)
+{
+	void *ptrs[KNOD_DEFAULT_PASS_SLOTS];
+	struct knod_work_priv *wpriv;
+	struct knod_pass_desc *d0;
+	struct page_pool *pool;
+	LIST_HEAD(deliver_list);
+	unsigned int got = 0, i, n = 0;
+	int delivered = 0;
+	u32 cur_fence;
+
+	if (napi_index < 0 || napi_index >= KNOD_SPSC_MAX ||
+	    !knodev->accel_ops->d2h_fence)
+		return 0;
+	wpriv = &knodev->wpriv[napi_index];
+	if (!wpriv->pass_pending.slots)
+		return 0;
+	pool = READ_ONCE(wpriv->pass_pool);
+
+	if (spsc_peek(&wpriv->pass_pending, ptrs,
+		      min_t(unsigned int, budget, KNOD_DEFAULT_PASS_SLOTS),
+		      &got) < 0 || got == 0)
+		return 0;
+
+	d0 = ptrs[0];
+	cur_fence = knodev->accel_ops->d2h_fence(knodev, d0->sdma_idx);
+
+	for (i = 0; i < got; i++) {
+		struct knod_pass_desc *desc = ptrs[i];
+		struct sk_buff *skb;
+
+		if ((s32)(cur_fence - desc->fence_val) < 0)
+			break;	/* not landed yet; later descs are newer */
+
+		/* bpf carries the RX page as src for post-copy recycle; ipsec
+		 * leaves it 0 (the NIC act handler recycles via the bd).
+		 */
+		if (desc->src)
+			page_pool_recycle_direct_netmem(
+				netmem_get_pp(desc->src), desc->src);
+		skb = knod_pass_build_skb(desc->netmem, desc->off, desc->len,
+					  pool, true);
+		n++;
+		if (!skb)
+			continue;
+		if (knodev->post_copy) {
+			if (!knodev->post_copy(knodev, skb, desc, napi_index)) {
+				kfree_skb(skb);
+				continue;
+			}
+		} else if (likely(skb->len >= ETH_HLEN)) {
+			skb->protocol = eth_type_trans(skb, knodev->netdev);
+		} else {
+			kfree_skb(skb);
+			continue;
+		}
+		list_add_tail(&skb->list, &deliver_list);
+		delivered++;
+	}
+
+	if (n) {
+		spsc_acquire(&wpriv->pass_pending, NULL, n, NULL);
+		spsc_release_commit(&wpriv->pass_pending, n);
+	}
+
+	/* Descriptors whose copy has not landed yet remain queued; re-arm so
+	 * we poll again instead of waiting for the next RX event.
+	 */
+	if (spsc_count(&wpriv->pass_pending))
+		knod_napi_kick(wpriv);
+
+	if (!list_empty(&deliver_list))
+		netif_receive_skb_list(&deliver_list);
+	return delivered;
+}
+EXPORT_SYMBOL(knod_d2h_drain);
+
+/* ======================================================================
+ * NOD IPsec proxy - bridges standard kernel xfrmdev_ops to
+ * knod_accel_ipsec_ops on the GPU accelerator.
+ * ======================================================================
+ */
+#if IS_ENABLED(CONFIG_XFRM_OFFLOAD)
+
+static struct knod_dev *knod_ipsec_find_xdev(struct net_device *dev)
+{
+	struct knod_dev *knodev;
+
+	list_for_each_entry(knodev, &knod_dev_list, list) {
+		if (knodev->netdev == dev)
+			return knodev;
+	}
+	return NULL;
+}
+
+static int knod_ipsec_xdo_state_add(struct net_device *dev,
+				    struct xfrm_state *x,
+				    struct netlink_ext_ack *extack)
+{
+	struct knod_dev *knodev = knod_ipsec_find_xdev(dev);
+
+	if (!knodev || !knodev->accel_ops->ipsec_ops ||
+	    !knodev->accel_ops->ipsec_ops->xdo_dev_state_add)
+		return -EOPNOTSUPP;
+	return knodev->accel_ops->ipsec_ops->xdo_dev_state_add(knodev, x,
+							       extack);
+}
+
+static void knod_ipsec_xdo_state_delete(struct net_device *dev,
+					struct xfrm_state *x)
+{
+	struct knod_dev *knodev = knod_ipsec_find_xdev(dev);
+
+	if (!knodev || !knodev->accel_ops->ipsec_ops ||
+	    !knodev->accel_ops->ipsec_ops->xdo_dev_state_delete)
+		return;
+	knodev->accel_ops->ipsec_ops->xdo_dev_state_delete(knodev, x);
+}
+
+static void knod_ipsec_xdo_state_free(struct net_device *dev,
+				      struct xfrm_state *x)
+{
+	struct knod_dev *knodev = knod_ipsec_find_xdev(dev);
+
+	if (!knodev || !knodev->accel_ops->ipsec_ops ||
+	    !knodev->accel_ops->ipsec_ops->xdo_dev_state_free)
+		return;
+	knodev->accel_ops->ipsec_ops->xdo_dev_state_free(knodev, x);
+}
+
+static bool knod_ipsec_xdo_offload_ok(struct sk_buff *skb,
+				      struct xfrm_state *x)
+{
+	struct knod_dev *knodev = knod_ipsec_find_xdev(x->xso.dev);
+
+	if (!knodev || !knodev->accel_ops->ipsec_ops ||
+	    !knodev->accel_ops->ipsec_ops->xdo_dev_offload_ok)
+		return false;
+	return knodev->accel_ops->ipsec_ops->xdo_dev_offload_ok(knodev, skb, x);
+}
+
+static void knod_ipsec_xdo_state_advance_esn(struct xfrm_state *x)
+{
+	struct knod_dev *knodev;
+
+	if (!x->xso.dev)
+		return;
+	knodev = knod_ipsec_find_xdev(x->xso.dev);
+	if (!knodev || !knodev->accel_ops->ipsec_ops ||
+	    !knodev->accel_ops->ipsec_ops->xdo_dev_state_advance_esn)
+		return;
+	knodev->accel_ops->ipsec_ops->xdo_dev_state_advance_esn(knodev, x);
+}
+
+static void knod_ipsec_xdo_state_update_stats(struct xfrm_state *x)
+{
+	struct knod_dev *knodev;
+
+	if (!x->xso.dev)
+		return;
+	knodev = knod_ipsec_find_xdev(x->xso.dev);
+	if (!knodev || !knodev->accel_ops->ipsec_ops ||
+	    !knodev->accel_ops->ipsec_ops->xdo_dev_state_update_stats)
+		return;
+	knodev->accel_ops->ipsec_ops->xdo_dev_state_update_stats(knodev, x);
+}
+
+static int knod_ipsec_xdo_policy_add(struct xfrm_policy *xp,
+				     struct netlink_ext_ack *extack)
+{
+	struct knod_dev *knodev;
+
+	if (!xp->xdo.dev)
+		return -EOPNOTSUPP;
+	knodev = knod_ipsec_find_xdev(xp->xdo.dev);
+	if (!knodev || !knodev->accel_ops->ipsec_ops ||
+	    !knodev->accel_ops->ipsec_ops->xdo_dev_policy_add)
+		return -EOPNOTSUPP;
+	return knodev->accel_ops->ipsec_ops->xdo_dev_policy_add(knodev, xp,
+								extack);
+}
+
+static void knod_ipsec_xdo_policy_delete(struct xfrm_policy *xp)
+{
+	struct knod_dev *knodev;
+
+	if (!xp->xdo.dev)
+		return;
+	knodev = knod_ipsec_find_xdev(xp->xdo.dev);
+	if (!knodev || !knodev->accel_ops->ipsec_ops ||
+	    !knodev->accel_ops->ipsec_ops->xdo_dev_policy_delete)
+		return;
+	knodev->accel_ops->ipsec_ops->xdo_dev_policy_delete(knodev, xp);
+}
+
+static void knod_ipsec_xdo_policy_free(struct xfrm_policy *xp)
+{
+	struct knod_dev *knodev;
+
+	if (!xp->xdo.dev)
+		return;
+	knodev = knod_ipsec_find_xdev(xp->xdo.dev);
+	if (!knodev || !knodev->accel_ops->ipsec_ops ||
+	    !knodev->accel_ops->ipsec_ops->xdo_dev_policy_free)
+		return;
+	knodev->accel_ops->ipsec_ops->xdo_dev_policy_free(knodev, xp);
+}
+
+static const struct xfrmdev_ops knod_ipsec_xfrmdev_ops = {
+	.xdo_dev_state_add          = knod_ipsec_xdo_state_add,
+	.xdo_dev_state_delete       = knod_ipsec_xdo_state_delete,
+	.xdo_dev_state_free         = knod_ipsec_xdo_state_free,
+	.xdo_dev_offload_ok         = knod_ipsec_xdo_offload_ok,
+	.xdo_dev_state_advance_esn  = knod_ipsec_xdo_state_advance_esn,
+	.xdo_dev_state_update_stats = knod_ipsec_xdo_state_update_stats,
+	.xdo_dev_policy_add         = knod_ipsec_xdo_policy_add,
+	.xdo_dev_policy_delete      = knod_ipsec_xdo_policy_delete,
+	.xdo_dev_policy_free        = knod_ipsec_xdo_policy_free,
+};
+
+int knod_dev_xdp_drain_pass(struct knod_dev *knodev, struct napi_struct *napi,
+			    int queue_idx, int budget)
+{
+	if (!knodev || !knodev->accel_ops)
+		return 0;
+	/* Common device->host delivery drain.  PASS bds were SDMA-copied by
+	 * knod_d2h_copy from the NIC act handler; deliver the ones whose copy
+	 * has landed.
+	 */
+	return knod_d2h_drain(knodev, queue_idx, napi, budget);
+}
+EXPORT_SYMBOL_GPL(knod_dev_xdp_drain_pass);
+
+int knod_ipsec_attach(struct knod_dev *knodev)
+{
+	struct knod_accel_ipsec_ops *ops;
+
+	if (!knodev->accel_ops->ipsec_ops)
+		return 0;
+
+	ops = knodev->accel_ops->ipsec_ops;
+	if (ops->activate) {
+		int err = ops->activate(knodev);
+
+		if (err) {
+			pr_err("nod: IPsec activate failed on %s (%d)\n",
+			       netdev_name(knodev->netdev), err);
+			return err;
+		}
+	}
+
+	/* Take over xfrmdev_ops, saving the NIC's original so detach can
+	 * restore it (and only clear NETIF_F_HW_ESP if we added it).
+	 */
+	knodev->ipsec_orig_xfrmdev_ops = knodev->netdev->xfrmdev_ops;
+	knodev->ipsec_added_hw_esp =
+		!(knodev->netdev->features & NETIF_F_HW_ESP);
+	knodev->netdev->xfrmdev_ops = &knod_ipsec_xfrmdev_ops;
+	knodev->netdev->features |= NETIF_F_HW_ESP;
+	knodev->netdev->hw_enc_features |= NETIF_F_HW_ESP;
+
+	pr_info("nod: IPsec offload enabled on %s\n",
+		netdev_name(knodev->netdev));
+	return 0;
+}
+EXPORT_SYMBOL(knod_ipsec_attach);
+
+void knod_ipsec_detach(struct knod_dev *knodev)
+{
+	struct knod_accel_ipsec_ops *ops = knodev->accel_ops->ipsec_ops;
+
+	if (!ops)
+		return;
+	if (knodev->netdev->xfrmdev_ops != &knod_ipsec_xfrmdev_ops)
+		return;
+
+	if (knodev->ipsec_added_hw_esp) {
+		knodev->netdev->features &= ~NETIF_F_HW_ESP;
+		knodev->netdev->hw_enc_features &= ~NETIF_F_HW_ESP;
+	}
+	knodev->netdev->xfrmdev_ops = knodev->ipsec_orig_xfrmdev_ops;
+
+	if (ops->deactivate)
+		ops->deactivate(knodev);
+
+	pr_info("nod: IPsec offload disabled on %s\n",
+		netdev_name(knodev->netdev));
+}
+EXPORT_SYMBOL(knod_ipsec_detach);
+
+#endif /* CONFIG_XFRM_OFFLOAD */
+
+/*
+ * Host-page page_pool memory provider for GPU->host delivery (NOD-private).
+ * Unlike the devmem/dma-buf providers (which hand out unreadable net_iov), this
+ * returns real host-readable pages (a GPU GTT buffer also mapped into system
+ * memory), so delivered data becomes skbs on the normal receive path.  The
+ * pages stay owned by the accel and are never returned to the buddy; the
+ * gen_pool is only the slow-path backing store (page_pool's cache/ring absorb
+ * the per-packet churn), and the device address it hands out doubles as the
+ * netmem dma_addr (the worker's SDMA destination).  Selected via
+ * page_pool_params.mp_ops in knod_pass_attach().
+ */
+static int hostmem_pp_init(struct page_pool *pool)
+{
+	struct page_pool_hostmem *hm = pool->mp_priv;
+	int err;
+
+	if (pool->p.order != 0)
+		return -E2BIG;
+	if (!hm || !hm->pages || !hm->count)
+		return -EINVAL;
+
+	hm->genpool = gen_pool_create(PAGE_SHIFT, NUMA_NO_NODE);
+	if (!hm->genpool)
+		return -ENOMEM;
+
+	err = gen_pool_add(hm->genpool, (unsigned long)hm->base_addr,
+			   (size_t)hm->count * PAGE_SIZE, NUMA_NO_NODE);
+	if (err) {
+		gen_pool_destroy(hm->genpool);
+		hm->genpool = NULL;
+		return err;
+	}
+
+	/* Device addresses are pre-set; page_pool must not DMA-sync them. */
+	pool->dma_sync = false;
+	pool->dma_sync_for_cpu = false;
+
+	return 0;
+}
+
+static netmem_ref hostmem_pp_alloc_netmems(struct page_pool *pool, gfp_t gfp)
+{
+	struct page_pool_hostmem *hm = pool->mp_priv;
+	unsigned long addr;
+	netmem_ref netmem;
+	unsigned int idx;
+
+	addr = gen_pool_alloc(hm->genpool, PAGE_SIZE);
+	if (!addr)
+		return 0;
+
+	idx = (addr - hm->base_addr) >> PAGE_SHIFT;
+	if (WARN_ON_ONCE(idx >= hm->count)) {
+		gen_pool_free(hm->genpool, addr, PAGE_SIZE);
+		return 0;
+	}
+
+	netmem = page_to_netmem(hm->pages[idx]);
+	page_pool_provider_set_netmem(pool, netmem, addr);
+
+	pool->pages_state_hold_cnt++;
+	trace_page_pool_state_hold(pool, netmem, pool->pages_state_hold_cnt);
+
+	return netmem;
+}
+
+static bool hostmem_pp_release_netmem(struct page_pool *pool, netmem_ref netmem)
+{
+	struct page_pool_hostmem *hm = pool->mp_priv;
+	unsigned long addr = page_pool_get_dma_addr_netmem(netmem);
+
+	page_pool_clear_pp_info(netmem);
+	gen_pool_free(hm->genpool, addr, PAGE_SIZE);
+
+	/* Pages are accel-owned: never put_page() them to the buddy. */
+	return false;
+}
+
+static void hostmem_pp_destroy(struct page_pool *pool)
+{
+	struct page_pool_hostmem *hm = pool->mp_priv;
+
+	gen_pool_destroy(hm->genpool);
+	hm->genpool = NULL;
+
+	/* The pool has fully drained (inflight == 0); tell the owner it may now
+	 * release the backing pages.  The struct itself is owner-allocated.
+	 */
+	if (hm->freed)
+		hm->freed(hm->arg);
+}
+
+static int hostmem_pp_nl_fill(void *mp_priv, struct sk_buff *rsp,
+			      struct netdev_rx_queue *rxq)
+{
+	/* Nothing provider-specific to report; page_pool_user.c calls this
+	 * unconditionally once mp_ops is set, so it must not be NULL.
+	 */
+	return 0;
+}
+
+static const struct memory_provider_ops page_pool_hostmem_ops = {
+	.init		= hostmem_pp_init,
+	.alloc_netmems	= hostmem_pp_alloc_netmems,
+	.release_netmem	= hostmem_pp_release_netmem,
+	.destroy	= hostmem_pp_destroy,
+	.nl_fill	= hostmem_pp_nl_fill,
+	/*
+	 * .uninstall is only invoked for rxq-bound pools and is
+	 * NULL-checked.
+	 */
+};
+
+/* Provider drain callback: fires once a delivery pool has no inflight pages. */
+static void knod_pass_drained(void *arg)
+{
+	struct knod_dev *knodev = arg;
+
+	if (atomic_dec_and_test(&knodev->pp_live))
+		complete(&knodev->pp_drained);
+}
+
+/*
+ * Create one GPU->host delivery page_pool per RX queue, backed by a single
+ * accel-allocated GTT buffer.  Mirrors the spsc-pool setup: alloc_mem() hands
+ * back the buffer (kaddr/gaddr/pages/priv); the framework owns the page_pools
+ * and the drain barrier.  The hostmem provider hands out the real GTT pages
+ * with their device address as dma_addr, so the worker's SDMA lands directly
+ * in the page that later becomes the skb frag.  page_pool inflight accounting
+ * then keeps the buffer alive until every delivered skb has drained.
+ */
+static int knod_pass_attach(struct knod_dev *knodev)
+{
+	struct page_pool_params pp = {
+		.order		= 0,
+		.pool_size	= KNOD_PASS_SLOTS,
+		.nid		= NUMA_NO_NODE,
+		.dev		= knodev->netdev->dev.parent,
+		.dma_dir	= DMA_FROM_DEVICE,
+		.max_len	= PAGE_SIZE,
+		.flags		= PP_FLAG_DMA_MAP | PP_FLAG_DMA_SYNC_DEV |
+				  PP_FLAG_CUSTOM_MEMORY_PROVIDER,
+		.mp_ops		= &page_pool_hostmem_ops,
+	};
+	unsigned int nqueues = min(knodev->netdev->num_rx_queues,
+				   KNOD_SPSC_MAX);
+	struct page **pages;
+	void *pass_priv;
+	u64 base_gaddr;
+	size_t total;
+	void *kaddr;
+	int qi;
+
+	/* Accels without GPU memory simply run without zero-copy delivery. */
+	if (!knodev->accel_ops->alloc_mem)
+		return 0;
+
+	total = nqueues * KNOD_PASS_SLOTS * PAGE_SIZE;
+	kaddr = knodev->accel_ops->alloc_mem(knodev, total, &base_gaddr, &pages,
+					   &pass_priv);
+	if (!kaddr) {
+		pr_err("%s: delivery alloc_mem failed\n", __func__);
+		return -ENOMEM;
+	}
+	if (!pages) {
+		knodev->accel_ops->free_mem(knodev, pass_priv);
+		return -ENOMEM;
+	}
+
+	init_completion(&knodev->pp_drained);
+	atomic_set(&knodev->pp_live, 0);
+	spin_lock_init(&knodev->d2h_lock);
+
+	for (qi = 0; qi < nqueues; qi++) {
+		struct knod_work_priv *wpriv = &knodev->wpriv[qi];
+		int base = qi * KNOD_PASS_SLOTS;
+
+		if (spsc_init(&wpriv->pass_pending,
+			      sizeof(struct knod_pass_desc),
+			      KNOD_PASS_SLOTS, GFP_KERNEL))
+			goto err_destroy;
+
+		wpriv->pass_hm.pages	 = &pages[base];
+		wpriv->pass_hm.count	 = KNOD_PASS_SLOTS;
+		wpriv->pass_hm.base_addr = base_gaddr + (u64)base * PAGE_SIZE;
+		wpriv->pass_hm.freed	 = knod_pass_drained;
+		wpriv->pass_hm.arg	 = knodev;
+		pp.mp_priv		 = &wpriv->pass_hm;
+
+		wpriv->pass_pool = page_pool_create(&pp);
+		if (IS_ERR(wpriv->pass_pool)) {
+			wpriv->pass_pool = NULL;
+			spsc_destroy(&wpriv->pass_pending);
+			goto err_destroy;
+		}
+		atomic_inc(&knodev->pp_live);
+	}
+
+	knodev->pass_priv = pass_priv;
+	return 0;
+
+err_destroy:
+	while (qi-- > 0) {
+		spsc_destroy(&knodev->wpriv[qi].pass_pending);
+		page_pool_destroy(knodev->wpriv[qi].pass_pool);
+		knodev->wpriv[qi].pass_pool = NULL;
+	}
+	if (atomic_read(&knodev->pp_live))
+		wait_for_completion_timeout(&knodev->pp_drained,
+					    msecs_to_jiffies(5000));
+	knodev->accel_ops->free_mem(knodev, pass_priv);
+	return -ENOMEM;
+}
+
+/*
+ * Drain a queue's pass_pending ring on teardown.  The interface is down so no
+ * new copies are submitted; wait for each queued copy to land, then return its
+ * pages to the pool instead of delivering.  Without this, page_pool_destroy()
+ * stalls on the pages a detach raced against in-flight d2h copies.
+ */
+static void knod_pass_flush(struct knod_dev *knodev, unsigned int qi)
+{
+	struct knod_work_priv *wpriv = &knodev->wpriv[qi];
+	struct page_pool *pool = wpriv->pass_pool;
+	void *ptrs[KNOD_DEFAULT_PASS_SLOTS];
+	unsigned int got, i;
+
+	if (!wpriv->pass_pending.slots || !pool)
+		return;
+
+	while (spsc_peek(&wpriv->pass_pending, ptrs,
+			 KNOD_DEFAULT_PASS_SLOTS, &got) >= 0 && got) {
+		for (i = 0; i < got; i++) {
+			struct knod_pass_desc *desc = ptrs[i];
+			int spins = 1000000;
+
+			while (knodev->accel_ops->d2h_fence && spins-- &&
+			       (s32)(knodev->accel_ops->d2h_fence(knodev,
+					desc->sdma_idx) - desc->fence_val) < 0)
+				cpu_relax();
+
+			WARN_ONCE(knodev->accel_ops->d2h_fence &&
+				  (s32)(knodev->accel_ops->d2h_fence(knodev,
+					desc->sdma_idx) - desc->fence_val) < 0,
+				  "knod: d2h fence timeout on pass flush q%u idx%u\n",
+				  qi, desc->sdma_idx);
+
+			if (desc->src) {
+				struct page_pool *src_pp =
+					netmem_get_pp(desc->src);
+
+				page_pool_recycle_direct_netmem(src_pp,
+								desc->src);
+			}
+			page_pool_put_full_netmem(pool, desc->netmem, false);
+		}
+		spsc_acquire(&wpriv->pass_pending, NULL, got, NULL);
+		spsc_release_commit(&wpriv->pass_pending, got);
+	}
+}
+
+/*
+ * Tear down the delivery pools and free the backing buffer.  page_pool_destroy
+ * is async, so wait for every pool to drain (knod_pass_drained) before handing
+ * the buffer back to the accel -- otherwise an inflight skb frag would outlive
+ * the BO.  Idempotent: a no-op for accels that never allocated.
+ */
+static void knod_pass_detach(struct knod_dev *knodev)
+{
+	unsigned int qi;
+
+	if (!knodev->pass_priv)
+		return;
+
+	/* Iterate the full array (like the spsc teardown): destroy every pool
+	 * that was created, so the drain barrier is guaranteed to reach zero.
+	 */
+	for (qi = 0; qi < KNOD_SPSC_MAX; qi++) {
+		if (!knodev->wpriv[qi].pass_pool)
+			continue;
+		/* Return any queued (now-landed) d2h pages before destroying
+		 * the pool, or page_pool_destroy() stalls on the inflight
+		 * count a detach raced against in-flight d2h copies.
+		 */
+		knod_pass_flush(knodev, qi);
+		spsc_destroy(&knodev->wpriv[qi].pass_pending);
+		page_pool_destroy(knodev->wpriv[qi].pass_pool);
+		knodev->wpriv[qi].pass_pool = NULL;
+	}
+	if (atomic_read(&knodev->pp_live))
+		wait_for_completion_timeout(&knodev->pp_drained,
+					    msecs_to_jiffies(5000));
+	knodev->accel_ops->free_mem(knodev, knodev->pass_priv);
+	knodev->pass_priv = NULL;
+}
+
+static void knod_dmabuf_move_notify(struct dma_buf_attachment *attach)
+{
+}
+
+static const struct dma_buf_attach_ops knod_dmabuf_attach_ops = {
+	.allow_peer2peer = true,
+	.invalidate_mappings = knod_dmabuf_move_notify,
+};
+
+static int knod_dmabuf_attach(struct knod_dev *knodev)
+{
+	struct net_device *dev = knodev->netdev;
+	struct net_devmem_dmabuf_binding *binding;
+	struct dma_buf *dmabuf;
+	int i, err;
+
+	for (i = 0; i < min(dev->num_rx_queues, KNOD_SPSC_MAX); i++) {
+		dmabuf = knodev->wpriv[i].dmabuf;
+		if (!dmabuf)
+			continue;
+
+		/* The binding owns a dmabuf reference that
+		 * __net_devmem_dmabuf_binding_free() drops on unbind, mirroring
+		 * the dma_buf_get(fd) in the fd-based net_devmem_bind_dmabuf().
+		 * We hand it the BO's dmabuf directly, so take that reference
+		 * here -- otherwise the unbind put races the BO free's put and
+		 * underflows the dmabuf file refcount.
+		 */
+		get_dma_buf(dmabuf);
+		binding = __net_devmem_binding_create(dev, dev->dev.parent,
+						      dmabuf, DMA_BIDIRECTIONAL,
+						      &knod_dmabuf_attach_ops,
+						      NULL);
+		if (IS_ERR(binding)) {
+			dma_buf_put(dmabuf);
+			err = PTR_ERR(binding);
+			goto err_unwind;
+		}
+
+		err = net_devmem_bind_dmabuf_to_queue_direct(dev, i, binding);
+		if (err) {
+			net_devmem_unbind_dmabuf_direct(binding);
+			goto err_unwind;
+		}
+
+		knodev->bindings[i] = binding;
+	}
+
+	return 0;
+
+err_unwind:
+	while (i-- > 0) {
+		if (knodev->bindings[i]) {
+			net_devmem_unbind_dmabuf_direct(knodev->bindings[i]);
+			knodev->bindings[i] = NULL;
+		}
+	}
+	return err;
+}
+
+static void knod_dmabuf_detach(struct knod_dev *knodev)
+{
+	int i;
+
+	for (i = 0; i < KNOD_SPSC_MAX; i++) {
+		if (!knodev->bindings[i])
+			continue;
+
+		net_devmem_unbind_dmabuf_direct(knodev->bindings[i]);
+		knodev->bindings[i] = NULL;
+	}
+}
+
+int knod_dev_attach(struct knod_netdev *knetdev, struct knod_accel *accel)
+{
+	struct knod_dev *knodev;
+	int err = -EINVAL, i;
+
+	if (knetdev->status == KNOD_STATUS_USED ||
+	    accel->status == KNOD_STATUS_USED) {
+		pr_err("knod: %s already attached\n",
+		       netdev_name(knetdev->dev));
+		return -EINVAL;
+	}
+
+	knodev = kzalloc(sizeof(struct knod_dev), GFP_KERNEL);
+	if (!knodev)
+		return -ENOMEM;
+
+	if (!try_module_get(knetdev->owner)) {
+		pr_err("knod: NIC driver for %s is unloading\n",
+		       netdev_name(knetdev->dev));
+		kfree(knodev);
+		return -ENODEV;
+	}
+	if (!try_module_get(accel->owner)) {
+		pr_err("knod: accelerator driver is unloading\n");
+		module_put(knetdev->owner);
+		kfree(knodev);
+		return -ENODEV;
+	}
+
+	knetdev->accel = accel;
+	knetdev->knodev = knodev;
+	accel->knetdev = knetdev;
+	accel->knodev = knodev;
+	knodev->knetdev = knetdev;
+	knodev->accel = accel;
+	knodev->netdev = knetdev->dev;
+	knodev->accel_ops = accel->accel_ops;
+	knodev->nic_ops = knetdev->nic_ops;
+	mutex_init(&knodev->lock);
+
+	knodev->stats = netdev_alloc_pcpu_stats(struct knod_dev_stats);
+	if (!knodev->stats) {
+		err = -ENOMEM;
+		pr_err("knod: failed to allocate stats for %s\n",
+		       netdev_name(knetdev->dev));
+		goto free_xdev;
+	}
+
+	knodev->wpriv = kmalloc_array(KNOD_SPSC_MAX,
+				    sizeof(struct knod_work_priv),
+				    GFP_KERNEL | __GFP_ZERO);
+	if (!knodev->wpriv) {
+		pr_err("knod: failed to allocate work priv for %s\n",
+		       netdev_name(knetdev->dev));
+		err = -ENOMEM;
+		goto free_percpu;
+	}
+
+	netdev_lock(knodev->netdev);
+	err = knodev->nic_ops->attach(knodev);
+	if (err) {
+		err = -ENOMEM;
+		pr_err("knod: NIC attach failed on %s\n",
+		       netdev_name(knetdev->dev));
+		goto unlock;
+	}
+
+	err = knodev->accel_ops->attach(knodev);
+	if (err) {
+		err = -ENOMEM;
+		pr_err("knod: accelerator attach failed on %s\n",
+		       netdev_name(knetdev->dev));
+		goto nic_detach;
+	}
+
+	{
+		unsigned int nqueues = min(knodev->netdev->num_rx_queues,
+					  KNOD_SPSC_MAX);
+		unsigned int stride = ALIGN(sizeof(struct spsc_bd),
+					    SMP_CACHE_BYTES);
+		unsigned int cap = roundup_pow_of_two(KNOD_SPSC_ELEMS_MAX);
+		size_t pool_size = (size_t)stride * cap;
+
+		if (knodev->accel_ops->alloc_mem) {
+			size_t total = pool_size * nqueues;
+			u64 base_gaddr;
+			void *base_pool;
+			void *pool_priv;
+
+			base_pool = knodev->accel_ops->alloc_mem(knodev, total,
+					&base_gaddr, NULL, &pool_priv);
+			if (!base_pool) {
+				err = -ENOMEM;
+				pr_err("%s: alloc_mem failed\n", __func__);
+				goto free_spsc;
+			}
+			memset(base_pool, 0, total);
+
+			/* First queue owns the BO, others reference it */
+			knodev->wpriv[0].spsc_pool_priv = pool_priv;
+			for (i = 0; i < nqueues; i++) {
+				void *pool = base_pool +
+					     (unsigned long)i * pool_size;
+
+				knodev->wpriv[i].spsc_pool_gaddr =
+					base_gaddr + (u64)i * pool_size;
+				err = __spsc_init(&knodev->wpriv[i].spsc_bds,
+						  sizeof(struct spsc_bd),
+						  KNOD_SPSC_ELEMS_MAX, pool,
+						  GFP_KERNEL);
+				if (err) {
+					pr_err("%s: spsc_init failed q%d\n",
+					       __func__, i);
+					goto free_spsc;
+				}
+			}
+		} else {
+			for (i = 0; i < nqueues; i++) {
+				err = spsc_init(&knodev->wpriv[i].spsc_bds,
+						sizeof(struct spsc_bd),
+						KNOD_SPSC_ELEMS_MAX,
+						GFP_KERNEL);
+				if (err) {
+					pr_err("%s: spsc_init failed q%d\n",
+					       __func__, i);
+					goto free_spsc;
+				}
+			}
+		}
+	}
+	goto spsc_done;
+
+free_spsc:
+	for (i--; i >= 0; i--)
+		spsc_destroy(&knodev->wpriv[i].spsc_bds);
+	if (knodev->wpriv[0].spsc_pool_priv)
+		knodev->accel_ops->free_mem(knodev,
+				knodev->wpriv[0].spsc_pool_priv);
+	knodev->accel_ops->detach(knodev);
+	goto nic_detach;
+spsc_done:
+
+	err = knod_pass_attach(knodev);
+	if (err) {
+		pr_err("%s: knod_pass_attach failed (%d)\n", __func__, err);
+		goto accel_detach;
+	}
+
+	err = knod_dmabuf_attach(knodev);
+	if (err) {
+		err = -ENOMEM;
+		pr_err("knod: dmabuf attach failed on %s\n",
+		       netdev_name(knetdev->dev));
+		goto accel_detach;
+	}
+
+	pr_info("knod: %s attached to accel %d\n",
+		netdev_name(knodev->netdev), accel->id);
+	list_add(&knodev->list, &knod_dev_list);
+	knetdev->status = KNOD_STATUS_USED;
+	accel->status = KNOD_STATUS_USED;
+
+	if (knodev->accel_ops->xdp_ops && knodev->accel_ops->xdp_ops->init) {
+		err = knodev->accel_ops->xdp_ops->init(knodev);
+		if (err) {
+			pr_err("knod: XDP init failed on %s\n",
+			       netdev_name(knetdev->dev));
+			goto xdp_err;
+		}
+	}
+
+	/*
+	 * Feature offloads (BPF, IPsec) allocate their GPU resources and
+	 * advertise their netdev capabilities only when the feature is
+	 * selected via knod_accel_feature_set(), not at attach.
+	 */
+	netdev_unlock(knodev->netdev);
+
+	if (knodev->accel_ops->mp_map) {
+		err = knodev->accel_ops->mp_map(knodev);
+		if (err) {
+			pr_err("knod: mp_map failed (%d)\n", err);
+			goto dmabuf_detach;
+		}
+	}
+
+	return err;
+
+dmabuf_detach:
+	netdev_lock(knodev->netdev);
+xdp_err:
+	list_del(&knodev->list);
+	knetdev->status = KNOD_STATUS_FREE;
+	accel->status = KNOD_STATUS_FREE;
+	knod_dmabuf_detach(knodev);
+accel_detach:
+	knod_pass_detach(knodev);
+	for (i = 0; i < KNOD_SPSC_MAX; i++)
+		spsc_destroy(&knodev->wpriv[i].spsc_bds);
+	if (knodev->wpriv[0].spsc_pool_priv)
+		knodev->accel_ops->free_mem(knodev,
+				knodev->wpriv[0].spsc_pool_priv);
+	knodev->accel_ops->detach(knodev);
+nic_detach:
+	knodev->nic_ops->detach(knodev);
+unlock:
+	netdev_unlock(knodev->netdev);
+	kfree(knodev->wpriv);
+free_percpu:
+	free_percpu(knodev->stats);
+free_xdev:
+	/* Drop the accel<->knetdev<->knodev links set above before freeing
+	 * knodev, or a reader (e.g. knod_default_worker via accel->knodev)
+	 * dereferences a dangling pointer after a failed attach.
+	 */
+	accel->knodev = NULL;
+	accel->knetdev = NULL;
+	knetdev->knodev = NULL;
+	knetdev->accel = NULL;
+	module_put(accel->owner);
+	module_put(knetdev->owner);
+	kfree(knodev);
+	return err;
+}
+
+int knod_dev_detach(struct knod_dev *knodev)
+{
+	struct knod_accel *accel = knodev->accel;
+	struct knod_netdev *knetdev = knodev->knetdev;
+	int i;
+
+	if (netif_running(knodev->netdev)) {
+		pr_err("knod_dev: interface is up\n");
+		return -EINVAL;
+	}
+
+	netdev_lock(knodev->netdev);
+	/*
+	 * pre_detach() runs knod_feature_stop()+knod_feature_deactivate(),
+	 * which tears down whatever feature is active and frees its
+	 * resources, so no per-feature teardown is needed here.
+	 */
+	if (knodev->accel_ops->pre_detach)
+		knodev->accel_ops->pre_detach(knodev);
+	list_del(&knodev->list);
+	knod_dmabuf_detach(knodev);
+	knod_pass_detach(knodev);
+	for (i = 0; i < KNOD_SPSC_MAX; i++)
+		spsc_destroy(&knodev->wpriv[i].spsc_bds);
+	if (knodev->wpriv[0].spsc_pool_priv)
+		knodev->accel_ops->free_mem(knodev,
+				knodev->wpriv[0].spsc_pool_priv);
+	knodev->nic_ops->detach(knodev);
+	knodev->accel_ops->detach(knodev);
+	netdev_unlock(knodev->netdev);
+	knetdev->status = KNOD_STATUS_FREE;
+	knetdev->accel = NULL;
+	knetdev->knodev = NULL;
+	accel->knetdev = NULL;
+	accel->knodev = NULL;
+	accel->status = KNOD_STATUS_FREE;
+	kfree(knodev->wpriv);
+	free_percpu(knodev->stats);
+	kfree(knodev);
+
+	module_put(accel->owner);
+	module_put(knetdev->owner);
+	return 0;
+}
+
+static int __init knod_dev_init(void)
+{
+	return genl_register_family(&knod_nl_family);
+}
+
+core_initcall(knod_dev_init);
+
diff --git a/net/knod/knod_nl.c b/net/knod/knod_nl.c
new file mode 100644
index 000000000000..77799202abcf
--- /dev/null
+++ b/net/knod/knod_nl.c
@@ -0,0 +1,406 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/* Copyright (c) 2021 Taehee Yoo <ap420073@gmail.com>
+ * Copyright (c) 2021 Hoyeon Lee <hoyeon.rhee@gmail.com>
+ */
+
+#include <linux/netdevice.h>
+#include <linux/rtnetlink.h>
+#include <net/genetlink.h>
+#include <net/knod.h>
+#include <net/sock.h>
+
+#include "knod-nl-gen.h"
+#include "knod.h"
+
+/* ---- accel ---- */
+
+static int knod_nl_accel_fill(struct knod_accel *accel,
+			      struct sk_buff *rsp, const struct genl_info *info)
+{
+	u32 ena = 0, cap = 0;
+	void *hdr;
+
+	if (accel->accel_ops->feature_get)
+		accel->accel_ops->feature_get(accel, &ena, &cap);
+
+	hdr = genlmsg_iput(rsp, info);
+	if (!hdr)
+		return -EMSGSIZE;
+
+	if (nla_put_u32(rsp, KNOD_A_ACCEL_ID, accel->id) ||
+	    nla_put_string(rsp, KNOD_A_ACCEL_NAME, accel->name) ||
+	    nla_put_u32(rsp, KNOD_A_ACCEL_TYPE, accel->type) ||
+	    nla_put_u32(rsp, KNOD_A_ACCEL_FEATURE_CAP, cap) ||
+	    nla_put_u32(rsp, KNOD_A_ACCEL_FEATURE_ENA, ena)) {
+		genlmsg_cancel(rsp, hdr);
+		return -EMSGSIZE;
+	}
+
+	genlmsg_end(rsp, hdr);
+	return 0;
+}
+
+int knod_nl_accel_get_doit(struct sk_buff *skb, struct genl_info *info)
+{
+	struct knod_accel *accel;
+	struct sk_buff *rsp;
+	int err;
+
+	if (GENL_REQ_ATTR_CHECK(info, KNOD_A_ACCEL_ID))
+		return -EINVAL;
+
+	rsp = genlmsg_new(GENLMSG_DEFAULT_SIZE, GFP_KERNEL);
+	if (!rsp)
+		return -ENOMEM;
+
+	mutex_lock(&knod_lock);
+	accel = knod_accel_lookup(nla_get_u32(info->attrs[KNOD_A_ACCEL_ID]));
+	if (!accel) {
+		mutex_unlock(&knod_lock);
+		err = -ENODEV;
+		goto err_free;
+	}
+	err = knod_nl_accel_fill(accel, rsp, info);
+	mutex_unlock(&knod_lock);
+	if (err)
+		goto err_free;
+
+	return genlmsg_reply(rsp, info);
+
+err_free:
+	nlmsg_free(rsp);
+	return err;
+}
+
+int knod_nl_accel_get_dumpit(struct sk_buff *rsp, struct netlink_callback *cb)
+{
+	struct knod_accel *accel;
+	int idx = 0, s_idx = cb->args[0];
+
+	mutex_lock(&knod_lock);
+	list_for_each_entry(accel, &knod_accel_list, list) {
+		if (idx < s_idx)
+			goto cont;
+		if (knod_nl_accel_fill(accel, rsp, genl_info_dump(cb)) < 0)
+			break;
+cont:
+		idx++;
+	}
+	mutex_unlock(&knod_lock);
+
+	cb->args[0] = idx;
+	return rsp->len;
+}
+
+int knod_nl_accel_set_doit(struct sk_buff *skb, struct genl_info *info)
+{
+	struct knod_accel *accel;
+	u32 feature;
+	int err;
+
+	if (GENL_REQ_ATTR_CHECK(info, KNOD_A_ACCEL_ID) ||
+	    GENL_REQ_ATTR_CHECK(info, KNOD_A_ACCEL_FEATURE_ENA))
+		return -EINVAL;
+
+	feature = nla_get_u32(info->attrs[KNOD_A_ACCEL_FEATURE_ENA]);
+
+	/*
+	 * rtnl serialises the feature switch against attach/detach (which
+	 * also take rtnl) and against the NIC driver's interface up/down
+	 * (knod_dev_start/stop), and lets feature_set touch netdev->features
+	 * and run an expedited synchronize_net().  knod_lock still guards the
+	 * accel list walk (lock order: rtnl -> knod_lock).
+	 */
+	rtnl_lock();
+	mutex_lock(&knod_lock);
+	accel = knod_accel_lookup(nla_get_u32(info->attrs[KNOD_A_ACCEL_ID]));
+	if (!accel) {
+		err = -ENODEV;
+		goto unlock;
+	}
+	if (!accel->accel_ops->feature_set) {
+		err = -EOPNOTSUPP;
+		goto unlock;
+	}
+	err = accel->accel_ops->feature_set(accel, feature, info->extack);
+unlock:
+	mutex_unlock(&knod_lock);
+	rtnl_unlock();
+	return err;
+}
+
+/* ---- nic ---- */
+
+static int knod_nl_nic_fill(struct knod_netdev *knetdev,
+			    struct sk_buff *rsp, const struct genl_info *info)
+{
+	void *hdr;
+
+	hdr = genlmsg_iput(rsp, info);
+	if (!hdr)
+		return -EMSGSIZE;
+
+	if (nla_put_u32(rsp, KNOD_A_NIC_IFINDEX, knetdev->dev->ifindex) ||
+	    nla_put_string(rsp, KNOD_A_NIC_NAME, netdev_name(knetdev->dev))) {
+		genlmsg_cancel(rsp, hdr);
+		return -EMSGSIZE;
+	}
+
+	genlmsg_end(rsp, hdr);
+	return 0;
+}
+
+int knod_nl_nic_get_doit(struct sk_buff *skb, struct genl_info *info)
+{
+	struct knod_netdev *knetdev;
+	struct net_device *dev;
+	struct sk_buff *rsp;
+	int err;
+
+	if (GENL_REQ_ATTR_CHECK(info, KNOD_A_NIC_IFINDEX))
+		return -EINVAL;
+
+	rsp = genlmsg_new(GENLMSG_DEFAULT_SIZE, GFP_KERNEL);
+	if (!rsp)
+		return -ENOMEM;
+
+	rtnl_lock();
+	mutex_lock(&knod_lock);
+	dev = __dev_get_by_index(genl_info_net(info),
+				 nla_get_u32(info->attrs[KNOD_A_NIC_IFINDEX]));
+	knetdev = dev ? knod_netdev_lookup(dev) : NULL;
+	if (!knetdev) {
+		mutex_unlock(&knod_lock);
+		rtnl_unlock();
+		err = -ENODEV;
+		goto err_free;
+	}
+	err = knod_nl_nic_fill(knetdev, rsp, info);
+	mutex_unlock(&knod_lock);
+	rtnl_unlock();
+	if (err)
+		goto err_free;
+
+	return genlmsg_reply(rsp, info);
+
+err_free:
+	nlmsg_free(rsp);
+	return err;
+}
+
+int knod_nl_nic_get_dumpit(struct sk_buff *rsp, struct netlink_callback *cb)
+{
+	struct net *net = sock_net(rsp->sk);
+	struct knod_netdev *knetdev;
+	int idx = 0, s_idx = cb->args[0];
+
+	rtnl_lock();
+	mutex_lock(&knod_lock);
+	list_for_each_entry(knetdev, &knod_netdev_list, list) {
+		if (idx < s_idx)
+			goto cont;
+		if (dev_net(knetdev->dev) != net)
+			goto cont;
+		if (knod_nl_nic_fill(knetdev, rsp, genl_info_dump(cb)) < 0)
+			break;
+cont:
+		idx++;
+	}
+	mutex_unlock(&knod_lock);
+	rtnl_unlock();
+
+	cb->args[0] = idx;
+	return rsp->len;
+}
+
+/* ---- dev (NIC <-> accel binding) ---- */
+
+static int knod_nl_dev_fill(struct knod_dev *knodev, struct sk_buff *rsp,
+			    const struct genl_info *info)
+{
+	void *hdr;
+
+	hdr = genlmsg_iput(rsp, info);
+	if (!hdr)
+		return -EMSGSIZE;
+
+	if (nla_put_u32(rsp, KNOD_A_DEV_NIC_IFINDEX, knodev->netdev->ifindex) ||
+	    nla_put_u32(rsp, KNOD_A_DEV_ACCEL_ID, knodev->accel->id)) {
+		genlmsg_cancel(rsp, hdr);
+		return -EMSGSIZE;
+	}
+
+	genlmsg_end(rsp, hdr);
+	return 0;
+}
+
+void knod_nl_notify_dev(struct knod_dev *knodev, u32 cmd)
+{
+	struct net *net = dev_net(knodev->netdev);
+	struct genl_info info;
+	struct sk_buff *ntf;
+
+	if (!genl_has_listeners(&knod_nl_family, net, KNOD_NLGRP_MGMT))
+		return;
+
+	ntf = genlmsg_new(GENLMSG_DEFAULT_SIZE, GFP_KERNEL);
+	if (!ntf)
+		return;
+
+	genl_info_init_ntf(&info, &knod_nl_family, cmd);
+	if (knod_nl_dev_fill(knodev, ntf, &info)) {
+		nlmsg_free(ntf);
+		return;
+	}
+
+	genlmsg_multicast_netns(&knod_nl_family, net, ntf, 0,
+				KNOD_NLGRP_MGMT, GFP_KERNEL);
+}
+
+int knod_nl_attach_doit(struct sk_buff *skb, struct genl_info *info)
+{
+	struct knod_netdev *knetdev;
+	struct knod_accel *accel;
+	struct net_device *dev;
+	int err;
+
+	if (GENL_REQ_ATTR_CHECK(info, KNOD_A_DEV_NIC_IFINDEX) ||
+	    GENL_REQ_ATTR_CHECK(info, KNOD_A_DEV_ACCEL_ID))
+		return -EINVAL;
+
+	rtnl_lock();
+	mutex_lock(&knod_lock);
+
+	dev = __dev_get_by_index(genl_info_net(info),
+				 nla_get_u32(
+				 info->attrs[KNOD_A_DEV_NIC_IFINDEX]));
+	if (!dev) {
+		NL_SET_ERR_MSG(info->extack, "no such netdevice");
+		err = -ENODEV;
+		goto unlock;
+	}
+
+	knetdev = knod_netdev_lookup(dev);
+	if (!knetdev) {
+		NL_SET_ERR_MSG(info->extack, "netdevice not registered with knod");
+		err = -ENODEV;
+		goto unlock;
+	}
+
+	if (netif_running(dev)) {
+		NL_SET_ERR_MSG(info->extack, "bring the netdevice down first");
+		err = -EBUSY;
+		goto unlock;
+	}
+
+	accel = knod_accel_lookup(
+			nla_get_u32(info->attrs[KNOD_A_DEV_ACCEL_ID]));
+	if (!accel) {
+		NL_SET_ERR_MSG(info->extack, "no such accelerator");
+		err = -ENODEV;
+		goto unlock;
+	}
+
+	err = knod_dev_attach(knetdev, accel);
+	if (!err)
+		knod_nl_notify_dev(knetdev->knodev, KNOD_CMD_DEV_ADD_NTF);
+
+unlock:
+	mutex_unlock(&knod_lock);
+	rtnl_unlock();
+	return err;
+}
+
+int knod_nl_detach_doit(struct sk_buff *skb, struct genl_info *info)
+{
+	struct knod_dev *knodev;
+	struct net_device *dev;
+	int err;
+
+	if (GENL_REQ_ATTR_CHECK(info, KNOD_A_DEV_NIC_IFINDEX))
+		return -EINVAL;
+
+	rtnl_lock();
+
+	dev = __dev_get_by_index(genl_info_net(info),
+				 nla_get_u32(
+				 info->attrs[KNOD_A_DEV_NIC_IFINDEX]));
+	knodev = dev ? knod_dev_lookup(dev) : NULL;
+	if (!knodev) {
+		NL_SET_ERR_MSG(info->extack, "netdevice not attached");
+		err = -ENODEV;
+		goto unlock;
+	}
+
+	if (netif_running(dev)) {
+		NL_SET_ERR_MSG(info->extack, "bring the netdevice down first");
+		err = -EBUSY;
+		goto unlock;
+	}
+
+	knod_nl_notify_dev(knodev, KNOD_CMD_DEV_DEL_NTF);
+	err = knod_dev_detach(knodev);
+
+unlock:
+	rtnl_unlock();
+	return err;
+}
+
+int knod_nl_dev_get_doit(struct sk_buff *skb, struct genl_info *info)
+{
+	struct knod_dev *knodev;
+	struct net_device *dev;
+	struct sk_buff *rsp;
+	int err;
+
+	if (GENL_REQ_ATTR_CHECK(info, KNOD_A_DEV_NIC_IFINDEX))
+		return -EINVAL;
+
+	rsp = genlmsg_new(GENLMSG_DEFAULT_SIZE, GFP_KERNEL);
+	if (!rsp)
+		return -ENOMEM;
+
+	rtnl_lock();
+	dev = __dev_get_by_index(genl_info_net(info),
+				 nla_get_u32(
+				 info->attrs[KNOD_A_DEV_NIC_IFINDEX]));
+	knodev = dev ? knod_dev_lookup(dev) : NULL;
+	if (!knodev) {
+		rtnl_unlock();
+		err = -ENODEV;
+		goto err_free;
+	}
+	err = knod_nl_dev_fill(knodev, rsp, info);
+	rtnl_unlock();
+	if (err)
+		goto err_free;
+
+	return genlmsg_reply(rsp, info);
+
+err_free:
+	nlmsg_free(rsp);
+	return err;
+}
+
+int knod_nl_dev_get_dumpit(struct sk_buff *rsp, struct netlink_callback *cb)
+{
+	struct net *net = sock_net(rsp->sk);
+	struct knod_dev *knodev;
+	int idx = 0, s_idx = cb->args[0];
+
+	rtnl_lock();
+	list_for_each_entry(knodev, &knod_dev_list, list) {
+		if (idx < s_idx)
+			goto cont;
+		if (dev_net(knodev->netdev) != net)
+			goto cont;
+		if (knod_nl_dev_fill(knodev, rsp, genl_info_dump(cb)) < 0)
+			break;
+cont:
+		idx++;
+	}
+	rtnl_unlock();
+
+	cb->args[0] = idx;
+	return rsp->len;
+}
-- 
2.43.0

