Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.153
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794977592;
	b=F+AMMJvYtIZ8koVagF12kwe9BDNbjpF0H2MyztQeS/o/UDWEp19Mm90cGKEAl1lHDnKa
	 spC+/2IieJS+pGyeTSw9EWStVoGzFnp5zfIGFcjWvENDwwll3fa7Lt7BtFPiq+dyd5kUE
	 9wvv0xkPvRsbNRJmQRn1YQA8t/qaezSPt23DqC0NSD4ulYMKd94QFE1C7YMShWHMNJa6I
	 +vPjJSFWacWp9Vli1rL3UAT2V0jrRV6C1qm8L569CwSDeU2/bAFkdIUuHfu0TWw/4/1//
	 8jm0974IwKxSc5CbZ2HxwKMuzIs/iPlAiF+66SEBnc985+0bXHde0NXDncCmmUXLCXQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794977592;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=dfNLbacQpeCP9V7ARMtB3mHLNA/CeSn46T1tiJGybkE=;
	b=xTvyVAiTe9SuFf/UeRHXjEk4ib54qHh4Q/cbvCfakREPij/EotNMKYCvpd5r09wtRpnb
	 +adIqvFK1I9hTzxebUzCucAFIeoZysNTpkbw1RchX3/XAutosR7gPtB4lEpeo7dW14Bys
	 aM0mvDQU2u5dKesgOL1qTWXrIHoDpVqv7DlxcP5wqyREMzDkGRg3/I9CT9H4T00yKrUFH
	 z2YCKrSxcxCLdb+ZOb2xSV9ZKKMa61Qjxw92dQEacDtAip73D94g9cnX1VOA9BsH0rqfd
	 /muZFXaXtGEssLFRPDn/rrLuMs6aX9UZm613d3jxVmxHxI05SMk/Clt0kDIgt0I4Ijg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Z+pYA8lC;
	arc=none smtp.remote-ip=95.215.58.153
Received: from mta1.migadu.com (out-153.mta1.migadu.com [95.215.58.153])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30718606A332
	for <linux-rdma@vger.kernel.org>; Wed, 18 Nov 2026 04:53:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 30718606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Z+pYA8lC
X-Envelope-To: linux-rdma@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=pimkfTf7KWmZ9ukf7SpjNm4OlwXVKfh/c74kfTUZWcA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794977590; v=1; x=1795582390;
 b=Z+pYA8lCGZJl7FhnqHLKM7HiMX5V6PSDihI/GaK9Ak/wZ1PXT3I5YMkHjAYhGsZOzl+KT3Vl
 /Pd1WsffGSIuXS3T8IhC0y9e0XQXTqP0mUb8Wsik8IJwlw6hykKC8t/6V/zzXfNc3aNgiv0vZ9l
 PKeZ7IzGsdEpf43mQHVuWGBg=
X-Envelope-To: linux-rdma@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 349b7f36ee0d7b85;
	Wed, 18 Nov 2026 04:53:10 +0000
X-Mizu-Trace-ID: 349b7f36ee0d7b85
X-Migadu-Flow: FLOW_OUT
From: Jiayuan Chen <jiayuan.chen@linux.dev>
To: netdev@vger.kernel.org
Cc: Jiayuan Chen <jiayuan.chen@linux.dev>,
	Dust Li <dust.li@linux.alibaba.com>,
	David Ahern <dsahern@kernel.org>,
	Ido Schimmel <idosch@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Matthieu Baerts <matttbe@kernel.org>,
	Mat Martineau <martineau@kernel.org>,
	Geliang Tang <geliang@kernel.org>,
	Allison Henderson <achender@kernel.org>,
	"D. Wythe" <alibuda@linux.alibaba.com>,
	Sidraya Jayagond <sidraya@linux.ibm.com>,
	Mahanta Jambigi <mjambigi@linux.ibm.com>,
	Tony Lu <tonylu@linux.alibaba.com>,
	Wen Gu <guwen@linux.alibaba.com>,
	linux-kernel@vger.kernel.org,
	mptcp@lists.linux.dev,
	linux-rdma@vger.kernel.org,
	rds-devel@oss.oracle.com,
	linux-s390@vger.kernel.org
Subject: [PATCH net-next v2 5/5] net/smc: annotate data-races around smc sysctls
Date: Wed, 18 Nov 2026 12:51:20 +0800
Message-ID: <20261118045137.174026-6-jiayuan.chen@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261118045137.174026-1-jiayuan.chen@linux.dev>
References: <20261118045137.174026-1-jiayuan.chen@linux.dev>
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

autocorking_size, smcr_buf_type, smcr_max_links_per_lgr,
smcr_max_conns_per_lgr and limit_smc_hs are read without any lock while
their sysctl handlers update them with WRITE_ONCE(), and the SMC netlink
handlers toggle limit_smc_hs with plain writes. Add READ_ONCE() to the
readers and WRITE_ONCE() to those handlers.

Signed-off-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Acked-by: Dust Li <dust.li@linux.alibaba.com>
---
 net/smc/af_smc.c   | 8 ++++----
 net/smc/smc_clc.c  | 8 ++++----
 net/smc/smc_core.c | 2 +-
 net/smc/smc_tx.c   | 2 +-
 4 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index bfc0c7e71a12b..1d3eae064fe0d 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -88,7 +88,7 @@ int smc_nl_dump_hs_limitation(struct sk_buff *skb, struct netlink_callback *cb)
 		return -ENOMEM;
 
 	if (nla_put_u8(skb, SMC_NLA_HS_LIMITATION_ENABLED,
-		       sock_net(skb->sk)->smc.limit_smc_hs))
+		       READ_ONCE(sock_net(skb->sk)->smc.limit_smc_hs)))
 		goto err;
 
 	genlmsg_end(skb, hdr);
@@ -102,13 +102,13 @@ int smc_nl_dump_hs_limitation(struct sk_buff *skb, struct netlink_callback *cb)
 
 int smc_nl_enable_hs_limitation(struct sk_buff *skb, struct genl_info *info)
 {
-	sock_net(skb->sk)->smc.limit_smc_hs = true;
+	WRITE_ONCE(sock_net(skb->sk)->smc.limit_smc_hs, true);
 	return 0;
 }
 
 int smc_nl_disable_hs_limitation(struct sk_buff *skb, struct genl_info *info)
 {
-	sock_net(skb->sk)->smc.limit_smc_hs = false;
+	WRITE_ONCE(sock_net(skb->sk)->smc.limit_smc_hs, false);
 	return 0;
 }
 
@@ -411,7 +411,7 @@ void smc_sk_init(struct net *net, struct sock *sk, int protocol)
 	spin_lock_init(&smc->conn.send_lock);
 	mutex_init(&smc->clcsock_release_lock);
 	smc_init_saved_callbacks(smc);
-	smc->limit_smc_hs = net->smc.limit_smc_hs;
+	smc->limit_smc_hs = READ_ONCE(net->smc.limit_smc_hs);
 	smc->use_fallback = false; /* assume rdma capability first */
 	smc->fallback_rsn = 0;
 	smc_close_init(smc);
diff --git a/net/smc/smc_clc.c b/net/smc/smc_clc.c
index 014d527d5462d..df0afeef67cbd 100644
--- a/net/smc/smc_clc.c
+++ b/net/smc/smc_clc.c
@@ -990,8 +990,8 @@ int smc_clc_send_proposal(struct smc_sock *smc, struct smc_init_info *ini)
 	}
 	if (smcr_indicated(ini->smc_type_v2)) {
 		memcpy(v2_ext->roce, ini->smcrv2.ib_gid_v2, SMC_GID_SIZE);
-		v2_ext->max_conns = net->smc.sysctl_max_conns_per_lgr;
-		v2_ext->max_links = net->smc.sysctl_max_links_per_lgr;
+		v2_ext->max_conns = READ_ONCE(net->smc.sysctl_max_conns_per_lgr);
+		v2_ext->max_links = READ_ONCE(net->smc.sysctl_max_links_per_lgr);
 	}
 
 	pclc_base->hdr.length = htons(plen);
@@ -1272,12 +1272,12 @@ int smc_clc_srv_v2x_features_validate(struct smc_sock *smc,
 
 	if (ini->smcr_version & SMC_V2) {
 		ini->max_conns = min_t(u8, pclc_v2_ext->max_conns,
-				       net->smc.sysctl_max_conns_per_lgr);
+				       READ_ONCE(net->smc.sysctl_max_conns_per_lgr));
 		if (ini->max_conns < SMC_CONN_PER_LGR_MIN)
 			return SMC_CLC_DECL_MAXCONNERR;
 
 		ini->max_links = min_t(u8, pclc_v2_ext->max_links,
-				       net->smc.sysctl_max_links_per_lgr);
+				       READ_ONCE(net->smc.sysctl_max_links_per_lgr));
 		if (ini->max_links < SMC_LINKS_ADD_LNK_MIN)
 			return SMC_CLC_DECL_MAXLINKERR;
 	}
diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index a3164201c1420..2db3a87054835 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -1010,7 +1010,7 @@ static int smc_lgr_create(struct smc_sock *smc, struct smc_init_info *ini)
 		lgr->net = smc_ib_net(lnk->smcibdev);
 		lgr_list = &smc_lgr_list.list;
 		lgr_lock = &smc_lgr_list.lock;
-		lgr->buf_type = lgr->net->smc.sysctl_smcr_buf_type;
+		lgr->buf_type = READ_ONCE(lgr->net->smc.sysctl_smcr_buf_type);
 		atomic_inc(&lgr_cnt);
 	}
 	smc->conn.lgr = lgr;
diff --git a/net/smc/smc_tx.c b/net/smc/smc_tx.c
index 0f0c6df3bf2ce..30bffe79d06a3 100644
--- a/net/smc/smc_tx.c
+++ b/net/smc/smc_tx.c
@@ -148,7 +148,7 @@ static bool smc_should_autocork(struct smc_sock *smc)
 	int corking_size;
 
 	corking_size = min_t(unsigned int, conn->sndbuf_desc->len >> 1,
-			     sock_net(&smc->sk)->smc.sysctl_autocorking_size);
+			     READ_ONCE(sock_net(&smc->sk)->smc.sysctl_autocorking_size));
 
 	if (atomic_read(&conn->cdc_pend_tx_wr) == 0 ||
 	    smc_tx_prepared_sends(conn) > corking_size)
-- 
2.43.0

