Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795580622;
	b=kN8TVy6JrUNnbEFLtnt1xBj0Oqopz7sQKzySwqdiSVI/gpkAbKs8UxXBZXOWIe/8tpfw
	 HVlezSKE5CzxtyS98Ru4HpL4gawSHnsKy704767ku5vYdaTUoy6jYOsnpgCtFl04XkkfQ
	 sVph/7yuiW6lq/x8eTxAHZJrkOE4o6ZvOcMA9l2rz0ZVK6xynv0O0aPMUa0ltHjpTh7Eh
	 fQ3haGEfxTr70RSQLedvgAm+ntmmiU0fyn2ubwK3FgrquWBgtiYlKzw7lE0urHg02YfAA
	 UZMTqmCd7/ZvN5iLdTYPoLYss3ExAT8FIHzb6t6el9PTJRfojBMF6ii6EeYC/eBnarQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795580622;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=va0ggwHRJKjl4TPXGJhxPFGY4MyUe0PHa151+Q/wcNI=;
	b=n7Tj0HDAnynkyT31PKKEV6TtwAgmTC/At1Lc3YCbstOqtxB1o2WbEmjNC6ECu9jiK22U
	 Ofw822/5UTKSx5oUhnnbknb85L3Z/WrULrXQAr4wCQlNiIGBYB31+1QfynsMm2Ei/dfbv
	 eMe/xISOZOzSaPCPvCt/0953AEaXYJ+uWS4NbhMAuKXI/7WBoMrnk8L0dPDtGIOtxKtMM
	 t628ahCtQv2UyyZn1Qy1LsAqcNltzWTNkyROqAUiARDi9fpFkFbrDWlZvu9d6Y+O7KiXj
	 iikC5B7Bab4I3Hta9J00mJRW0wJMeXBzwZFl1TddcQbvF9o2KSspqYLvwrvfTJL4+Gg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=MqdlJ73A;
	arc=none smtp.remote-ip=209.85.216.46
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4DE2606A323
	for <linux-rdma@vger.kernel.org>; Wed, 25 Nov 2026 04:23:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B4DE2606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=MqdlJ73A
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-3b3fff0d993so727863a91.2
        for <linux-rdma@vger.kernel.org>; Tue, 24 Nov 2026 20:23:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795580621; x=1796185421; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=va0ggwHRJKjl4TPXGJhxPFGY4MyUe0PHa151+Q/wcNI=;
        b=MqdlJ73A4xj6m67NEm2/sbs/5Pi+1Cfize3YWEEqZtl4uS1+XB3qZrP+IoezQWRk5H
         X0kWZPGewUmX97In46VFqRUWQOxyiicqb7V+RIAJ+nEY3cN9OmIZuAb9HYNbly/9P0rW
         HjjFS9SrHg5Kk2dBUTVWS/Yq2rqn/RcACUZfYcFet9xc9xBAKweckSsrzatIR5hpHhAu
         kjtIGHQpq2LUqf3UiFdbgfcSwnkIbZ0NEW+ndZQj+xYO3vkQHeAINyjltsOp0ek9vy75
         FIIA30RcuawQvZp0pWmtDsluXYS13hIfGy3B7JTlRX/c31WMKUlSKHYUyeFIZ/cXpBHc
         9dgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795580621; x=1796185421;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=va0ggwHRJKjl4TPXGJhxPFGY4MyUe0PHa151+Q/wcNI=;
        b=G3H7Sd4H0oIzIpCBnPLzAZRiZMTexNRGBL+rt7UWF0wVD5GfvXWvPSvlR/V/wmu6qY
         63oQKZN4KYIqvzbfO+oqLiwMF0+9jOtrSP294O09lToW5LH/h71jboJ5T4eKzWteWpEA
         dqBhD7H7K/XxJBVCzNKRZq6CfbeXVo5uaGo8eph9+e4OZyhxGm9M7YAsPnAKUCAS2dDz
         TkCwHbkZ26i8LSQ+lFWWRY7tnRe708JuFCyqaNISsGcjJE5Madheeos7qUacgtAH43Y4
         7dUmsvGFjqgRuKoOIT0bY0eV/zlv4vYaASIO8F0spISLcivgYTO4P4FUOxTpZLpvEaKR
         8NMA==
X-Forwarded-Encrypted: i=1; AL+hErGuNqKnbsZqJ8xy48TQXEEO36Ye92TZP+ZzIFRIBUDT4P6mObtnzuuExPqy46R9qwKA5CeaX1VkBmpj@vger.kernel.org
X-Gm-Message-State: APuU4Z++lQXb/sssLGU5R1cVFhNaQOGyPT78ZrI/e8U862QLpMfWbYWC
	ZPJUbRXocHxPuDSkT7DTjSW+wVZ0UN77QxQsuKcsaIy6KcJPwhKpfoLf
X-Gm-Gg: AZFdTZeh6ZNPUBQgBJb+oRolx+Qv5G/BsOtTojydftSHA3FkbGhBDJyQlakWCaBm1/W
	dPWnhsx+f3pl3Eo6ki1PYtsFvtf3YPsdbOyHH08M+ijHzNqd/dbTaei0HhdWhyGq5I+T0M9mFjJ
	CXybKMToM5RdrHxGdnYgiGwtCzbLWuXtTDyGeI25uXOkUyS1Iivem+FV5r0m2tdfqmQzeeRruaS
	B6cdMbvKbNDw+Hpxnq38VhFf+5yDiBBe7G5FHnl/hPoU+PWBAram+sqNSnizOXVDpfEwYwVWDac
	UHzWw+IzdSXpMcqzHwjMAmSAD6P6ewVnxHrYfxDUeVwpeiatvTT9sVZuIr5Ch2bE1b2IIXSoG0o
	gBC023w2/igEqGdm0+L25UrVxOrq88c6ZUxeUN3tME8mK4Ziayg4DHlU18l3R6yLbkJP6AuJGBl
	iBr0OQqQOSrPGk74whNCunwTOpKOaVVQiBm2oGN8Aqkaf4LCbqxGBWxecX9l0xLja2Q7dDe2r6O
	oLmemu5tkHyAgv1g4emqtgFVt6d7FUHMR5sIYpC1xHwrITIQpcUlal9XGQMMKzCnQiT70jMbbkQ
	G+X1X8ZIBBx2EJPEunF/9XJgw5rtBl93IS88eH0rWX4C
X-Received: by 2002:a17:90b:39a7:b0:3b3:cb03:8740 with SMTP id 98e67ed59e1d1-3b41c96302emr26652973a91.5.1795580620889;
        Tue, 24 Nov 2026 20:23:40 -0800 (PST)
Received: from gmail.com ([36.112.206.40])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b40a878d50sm27969788a91.11.2026.11.24.20.23.30
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 24 Nov 2026 20:23:39 -0800 (PST)
From: Ziyu Zhang <ziyuzhang201@gmail.com>
To: saeedm@nvidia.com,
	tariqt@nvidia.com,
	mbloch@nvidia.com,
	leon@kernel.org
Cc: netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	andrew+netdev@lunn.ch,
	davem@davemloft.net,
	edumazet@kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	roid@nvidia.com,
	baijiaju1990@gmail.com,
	ziyuzhang201@gmail.com
Subject: [PATCH net] net/mlx5e: Fix deadlock when parsing flow actions fails
Date: Wed, 25 Nov 2026 12:23:23 +0800
Message-Id: <20261125042323.88050-1-ziyuzhang201@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
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

Neigh and route updates take encap_tbl_lock and then wait for
flow->init_done on every flow attached to the encap entry.  The only
complete_all(&flow->init_done) sits after mlx5e_tc_add_fdb_flow(), so a
flow whose actions fail to parse is never announced to them.

Such a flow can already be visible to the updates:
alloc_flow_post_acts() runs post_process_attr() on each post action
attribute, and mlx5e_tc_tun_encap_dests_set() attaches the flow to
e->flows there.  A later failure in alloc_flow_post_acts() goes through
free_flow_post_acts() -> mlx5_free_flow_attr_actions() ->
mlx5e_tc_tun_encap_dests_unset() -> mlx5e_detach_encap(), which takes
encap_tbl_lock.  The checks parse_tc_fdb_actions() runs after
alloc_flow_post_acts() reach the same detach from mlx5e_flow_put().  An
update that holds the lock and waits for the flow then blocks the
cleanup that would have to wake it, and both sides hang.

When parsing the actions fails, first delete the post action rules
installed so far: a woken neigh update may release e->pkt_reformat,
which those rules still use.  Then mark the flow FAILED and complete
init_done, and only then detach the encap entries.  The neigh paths skip
a flow that is not OFFLOADED and the route paths skip one that is
FAILED, so a woken update leaves the flow alone.  complete_all() is
idempotent, so the second call for a failure inside
alloc_flow_post_acts() is harmless.

Commit 37c3b9fa7ccf ("net/mlx5e: Prevent encap offload when neigh update
is running") fixed the same lock cycle between the encap entries of a
single attribute.  This patch only covers a failure while parsing the
actions.  A successful setup still takes encap_tbl_lock again after a
post action attribute attached the flow, through the encap dests of the
main attribute or mlx5e_attach_decap_route() for TUN_RX flows, and a
waiting update can block it there as well.

Fixes: 8300f225268b ("net/mlx5e: Create new flow attr for multi table actions")
Signed-off-by: Ziyu Zhang <ziyuzhang201@gmail.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 40 ++++++++++++++++++-
 1 file changed, 39 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index b290beb4369a..91e04a84bf07 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -3748,6 +3748,39 @@ free_flow_post_acts(struct mlx5e_tc_flow *flow)
 	}
 }
 
+/* Neigh and route updates wait for init_done while holding
+ * encap_tbl_lock, so the waiters have to be woken before error cleanup
+ * takes that lock again.  A flow that fails here is skipped by them: the
+ * neigh paths check OFFLOADED and the route paths check FAILED.
+ */
+static void mlx5e_flow_init_failed(struct mlx5e_tc_flow *flow)
+{
+	flow_flag_set(flow, FAILED);
+	complete_all(&flow->init_done);
+}
+
+/* Remove the post action rules of a flow that failed to initialize.  A
+ * woken neigh update may release the encap header they point to, so they
+ * have to go before init_done is completed.
+ */
+static void
+del_flow_post_act_handles(struct mlx5e_tc_flow *flow)
+{
+	struct mlx5e_post_act *post_act = get_post_action(flow->priv);
+	struct mlx5_flow_attr *attr;
+
+	list_for_each_entry(attr, &flow->attrs, list) {
+		if (list_is_last(&attr->list, &flow->attrs))
+			break;
+
+		if (!attr->post_act_handle)
+			continue;
+
+		mlx5e_tc_post_act_del(post_act, attr->post_act_handle);
+		attr->post_act_handle = NULL;
+	}
+}
+
 int
 mlx5e_tc_offload_flow_post_acts(struct mlx5e_tc_flow *flow)
 {
@@ -3852,6 +3885,8 @@ alloc_flow_post_acts(struct mlx5e_tc_flow *flow, struct netlink_ext_ack *extack)
 	return 0;
 
 out_free:
+	del_flow_post_act_handles(flow);
+	mlx5e_flow_init_failed(flow);
 	free_flow_post_acts(flow);
 	return err;
 }
@@ -4579,8 +4614,11 @@ __mlx5e_add_fdb_flow(struct mlx5e_priv *priv,
 		goto err_free;
 
 	err = parse_tc_fdb_actions(priv, &rule->action, flow, extack);
-	if (err)
+	if (err) {
+		del_flow_post_act_handles(flow);
+		mlx5e_flow_init_failed(flow);
 		goto err_free;
+	}
 
 	err = mlx5e_tc_add_fdb_flow(priv, flow, extack);
 	complete_all(&flow->init_done);
-- 
2.34.1

