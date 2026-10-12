Received: from mail-dy1-f198.google.com (mail-dy1-f198.google.com [74.125.82.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD2E844AB95
	for <linux-rdma@vger.kernel.org>; Mon, 12 Oct 2026 08:21:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791793313; cv=none; b=kAZ7g+XZz8cpazZ/gPll+hiPEN87mCXpLsYCzMjdcvXaxvjbbnIZHJuKupAb/xXNO3E6NCYEWPHpr9vZTKP+KOlX4qAjKIMBq2PM8mA7UtdX17vwGNoeA2EZqAL5K/iVixlf1jDSwVCrSgmm501tawQRh1rjgw0IFmasLBbirCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791793313; c=relaxed/simple;
	bh=pnmxBGSB7XCtcV6V09kKLM22EW6lDpcrAN/xbZBiPog=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=nEyxWO3fnTrqek2jsZlTleiSj5cO5BYdgSHli13itBCPmhpHqBffNAWSXRt71Z6WKQUtrjU1u4b0EFcK7TJ8H4rHZyXU+4jvpgS8qXdoJ+f7A9/Lip9Xq0hHlEagWchQb9v90R1eMbL+GUwZhx3taAa2YgJUnX2ItWm9x+HNpTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--almasrymina.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ebG84MkK; arc=none smtp.client-ip=74.125.82.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--almasrymina.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ebG84MkK"
Received: by mail-dy1-f198.google.com with SMTP id 5a478bee46e88-35a0c25def6so1808365eec.0
        for <linux-rdma@vger.kernel.org>; Mon, 12 Oct 2026 01:21:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791793311; x=1792398111; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mbC9X63mb8oj0NUjOWiqfc7FKNFk4qlxRdfo+sSWjTY=;
        b=ebG84MkKLAB6WVBYD42rQVQTTYcoF3jdKLqU/JhuCMMFuHInq8p5bA/A+WlJh+E2J/
         4Fl0r3Qe+3O91xvKgangCEspS02hsEKzDdib2MfRdabsoBSGrA6WNLLi3bwjpf6ZLhal
         9GnUmKEQNcOLvWS2pHraGCpCTOm9D7WSUZbCIPnmM9AYnbnmVlJmb/KENDYF65+NlVGV
         D+nxHS4WXdcHuRoy1dwhsPjYdwUneV+0E0zbb40LkxI4AUeb6MJkJOYVoNkvcdsrtZ8e
         wTnTgrM1QwxU6zkJt/VqPckcz/msHOXf7epl9sLbAqDcGPJQYMP3iq2Tcv4S34dWX5qk
         i9Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791793311; x=1792398111;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=mbC9X63mb8oj0NUjOWiqfc7FKNFk4qlxRdfo+sSWjTY=;
        b=a1eKJAnd2ZQyToq3kisuFqAtNr3dnroOPICUrwZ3Hdvo3G9MGEI0NXT8ulTJzbYZuN
         9SFpA60IV3K3LQlmFYFhKFzmtX2PRWA8nmMCRzgyV9zaLwfnM2aZvIlmPdrIjrkyAwg3
         lyxgUDEtbxHEqqXepH5xFdH74RZ5tcYqMIKtxs3Q3058WurfOOxLj6S3zj4a72Znevbc
         y+jZLW0pxM+NECpnrIarjsoyS8z6iWCSreKwN9SLPI5UpUDolkbu4YJ9G+LD2ghLnGwo
         w1+hGXiGyGNaROVcoPbFNcvh+iSBFxJW+jeMoiBG1jUA+cHXOTvWXW6J5xjRjzDY5/jf
         gxaQ==
X-Forwarded-Encrypted: i=1; AKwUvBzRFxhoZJjBpnldyxr2MlKgnc7O3uHrQKPTCTW/ixD0e2+U7YKZ0QdjKdqgtu+kjIuimwwpQcu1Md/M@vger.kernel.org
X-Gm-Message-State: AFq9FYLHKTr7C/rxh+9wS+jqq0IlxC3W1udTltqGugz/lf9VqkqBr5p7
	l55QIQ9/KZ/r4TdCl8SBqXi/Zi9gckF+dHuXx56SAuykncXl4xjg6humrrvOFYxxP5xm2IYtxk9
	kZYJUun4mVnGoQGhdeTZxpdPAoQ==
X-Received: from dyaw4-n1.prod.google.com ([2002:a05:693c:4144:10b0:35a:ef3f:64dc])
 (user=almasrymina job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7301:db84:b0:35a:15e5:2e04 with SMTP id 5a478bee46e88-35a15e52ea5mr4268378eec.21.1791793310502;
 Mon, 12 Oct 2026 01:21:50 -0700 (PDT)
Date: Mon, 12 Oct 2026 08:21:43 +0000
In-Reply-To: <20261012082148.1698596-1-almasrymina@google.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20261012082148.1698596-1-almasrymina@google.com>
X-Mailer: git-send-email 2.56.0.385.gd3acb90ef8-goog
Message-ID: <20261012082148.1698596-2-almasrymina@google.com>
Subject: [PATCH net-next v2 1/6] netmem: rename __get/__put_netmem() to get/put_net_iov()
From: Mina Almasry <almasrymina@google.com>
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-rdma@vger.kernel.org, bpf@vger.kernel.org
Cc: Mina Almasry <almasrymina@google.com>, Ayush Sawal <ayush.sawal@chelsio.com>, 
	Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Tariq Toukan <tariqt@nvidia.com>, Simon Horman <horms@kernel.org>, 
	Steffen Klassert <steffen.klassert@secunet.com>, Herbert Xu <herbert@gondor.apana.org.au>, 
	Neal Cardwell <ncardwell@google.com>, Kuniyuki Iwashima <kuniyu@google.com>, 
	John Fastabend <john.fastabend@gmail.com>, Sabrina Dubroca <sd@queasysnail.net>, 
	Eric Biggers <ebiggers@kernel.org>, Kees Cook <kees@kernel.org>, 
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>, 
	"=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig=20=28The=20Capable=20Hub=29?=" <u.kleine-koenig@baylibre.com>, Jijie Shao <shaojijie@huawei.com>, 
	Michael Grzeschik <mgr@kernel.org>, Jakub Raczynski <j.raczynski@samsung.com>
Content-Type: text/plain; charset="UTF-8"

netmems carry both a non-pp backing refcount and a page_pool
pp_ref_count. Make the non-pp layer explicit and symmetric across both
netmem types: get/put_netmem() dispatches to get/put_page() for pages
and get/put_net_iov() for net_iovs, always acquiring or releasing a
non-pp reference regardless of page_pool membership.

Warn via DEBUG_NET_WARN_ON_ONCE() for net_iov types that do not support
non-pp references.

Assisted-by: LLM
Signed-off-by: Mina Almasry <almasrymina@google.com>
---
 include/net/netmem.h | 24 ++++++++++++++++++++----
 net/core/skbuff.c    | 36 ++++++++++++++++++++++++++----------
 2 files changed, 46 insertions(+), 14 deletions(-)

diff --git a/include/net/netmem.h b/include/net/netmem.h
index 0cc8572f62caf..697d50c51a5ee 100644
--- a/include/net/netmem.h
+++ b/include/net/netmem.h
@@ -399,21 +399,37 @@ static inline bool net_is_devmem_iov(const struct net_iov *niov)
 }
 #endif
 
-void __get_netmem(netmem_ref netmem);
-void __put_netmem(netmem_ref netmem);
+void get_net_iov(struct net_iov *niov);
+void put_net_iov(struct net_iov *niov);
 
+/**
+ * get_netmem - acquire a non-page_pool reference on a netmem
+ * @netmem: netmem to reference
+ *
+ * Acquires a non-pp backing reference (page._refcount via get_page() or
+ * binding->ref via get_net_iov()) regardless of page_pool membership.
+ * Counterpart to put_netmem().
+ */
 static __always_inline void get_netmem(netmem_ref netmem)
 {
 	if (netmem_is_net_iov(netmem))
-		__get_netmem(netmem);
+		get_net_iov(netmem_to_net_iov(netmem));
 	else
 		get_page(netmem_to_page(netmem));
 }
 
+/**
+ * put_netmem - release a non-page_pool reference on a netmem
+ * @netmem: netmem to unreference
+ *
+ * Drops a non-pp backing reference (page._refcount via put_page() or
+ * binding->ref via put_net_iov()) regardless of page_pool membership.
+ * Counterpart to get_netmem().
+ */
 static __always_inline void put_netmem(netmem_ref netmem)
 {
 	if (netmem_is_net_iov(netmem))
-		__put_netmem(netmem);
+		put_net_iov(netmem_to_net_iov(netmem));
 	else
 		put_page(netmem_to_page(netmem));
 }
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index d56f4f0102f75..b459264ba5180 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -7551,23 +7551,39 @@ bool csum_and_copy_from_iter_full(void *addr, size_t bytes,
 }
 EXPORT_SYMBOL(csum_and_copy_from_iter_full);
 
-void __get_netmem(netmem_ref netmem)
+/**
+ * get_net_iov - acquire a non-page_pool reference on a net_iov
+ * @niov: net_iov to reference
+ *
+ * Acquires a non-pp backing reference (binding->ref) on @niov regardless of
+ * page_pool membership, warning if @niov does not support non-pp references.
+ * Counterpart to put_net_iov().
+ */
+void get_net_iov(struct net_iov *niov)
 {
-	struct net_iov *niov = netmem_to_net_iov(netmem);
-
 	if (net_is_devmem_iov(niov))
-		net_devmem_get_net_iov(netmem_to_net_iov(netmem));
+		net_devmem_get_net_iov(niov);
+	else
+		DEBUG_NET_WARN_ON_ONCE(true);
 }
-EXPORT_SYMBOL(__get_netmem);
+EXPORT_SYMBOL(get_net_iov);
 
-void __put_netmem(netmem_ref netmem)
+/**
+ * put_net_iov - release a non-page_pool reference on a net_iov
+ * @niov: net_iov to unreference
+ *
+ * Drops a non-pp backing reference (binding->ref) on @niov regardless of
+ * page_pool membership, warning if @niov does not support non-pp references.
+ * Counterpart to get_net_iov().
+ */
+void put_net_iov(struct net_iov *niov)
 {
-	struct net_iov *niov = netmem_to_net_iov(netmem);
-
 	if (net_is_devmem_iov(niov))
-		net_devmem_put_net_iov(netmem_to_net_iov(netmem));
+		net_devmem_put_net_iov(niov);
+	else
+		DEBUG_NET_WARN_ON_ONCE(true);
 }
-EXPORT_SYMBOL(__put_netmem);
+EXPORT_SYMBOL(put_net_iov);
 
 struct vlan_type_depth __vlan_get_protocol_offset(const struct sk_buff *skb,
 						  __be16 type,
-- 
2.56.0.385.gd3acb90ef8-goog

