Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.71
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793740469;
	b=sKl9shvqNTl4nBG2QOtzphcqDCMY7vmBmMBl6nY4zkxa4JLpCoqdG0H7/Y1ddm/4/Y62
	 isRwvxMzdkXdQeFdpAgxTTiG9XN8A5gSkBjAKI5MKmXJg56qT4NCH66MgQ1Fs5P98oT4m
	 rTL6StGWheiRXds4Z+L7CI2JPrBQI4G1mElwNSy/VphfBijyn+8GMqfOZB2aCaH/CLDfg
	 gEsNZkBWdjqa+5PO8NXQN+fMabTSDheixA30AVRse7LNH3wZ1ov7rHz1oIc03VnaG3pWy
	 omEeaur8vmABCYEDxAfFwTH2xRRNde8U8zMoJsIbzwnY7d237lUtuTGmMbaDOR1X4vg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793740469;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=nPKrnedIiXISgzxsOwTXqr4LP+3anTVqjEfGvppRktM=;
	b=YRulLOvcOIzQWDEyOdXWVGzhGXkdbffnuJ512MM9EA/6RMv4aci+12dTtUyyUvCc59xV
	 w+hb/+FFwyPoHsI0nNe/JSRL9HqeX6JivPPCJoQkq++fZJ+OkH61qM1IlUjKGV/8mJKNd
	 GAJ9xCWM+wGVgL5ltpx78IPf86dBFixim9NlgLDH5zvU8tZSopk1yRB7nN4ucB7D9P/7N
	 mHnv7PuYVELKMZ7H6MD8OS3+yz2RQI301Y3E8gA7PrEuOpTgYX6l5u0nkipFU5AVhT8/E
	 96dDRz2FP9Mktb25+jwHeDV1MO6PaKt1Sb3xe2zHJwqiJhImMq+2Mx/r67dJGS5YJWQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--almasrymina.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=B5e1ru4B;
	arc=none smtp.remote-ip=74.125.82.71
Received: from mail-dl1-f71.google.com (mail-dl1-f71.google.com [74.125.82.71])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CDF1606D80B
	for <linux-rdma@vger.kernel.org>; Tue,  3 Nov 2026 21:14:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8CDF1606D80B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--almasrymina.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=B5e1ru4B
Received: by mail-dl1-f71.google.com with SMTP id a92af1059eb24-1ac19c6bc71so51675c88.0
        for <linux-rdma@vger.kernel.org>; Tue, 03 Nov 2026 13:14:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793740468; x=1794345268; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=nPKrnedIiXISgzxsOwTXqr4LP+3anTVqjEfGvppRktM=;
        b=B5e1ru4BBlEgA9P06iBt9pW6ULXF22qVDV1kZzrpGnEek5hLiGoeJC/s3mkLVGsEjt
         K6iSAJuNjPGc+dYhhidvpiWx7AD2+KtV9m5GKqxd7+uf3UxzYbK83bZU10c/ypPRpJo9
         dXMjZgTNLpLAoahuRfkJ6HHADPBzbfJ91mZF6j9ZTsMZ2UhSBcTDsf+sHARKb9s5HIX+
         KraxeQsqarEJI+jNHN7ABu+czMAJ5z2Cv8qgF86yAs6bt0QcXwFk/UH3PYVMr5QDXB9a
         1be7je6BdzS1ffBM8lyaC6xLmeGERYY+drIyxtyu30uaOBkb1BYkvUBDEhphAo9cp+cz
         3GJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793740468; x=1794345268;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=nPKrnedIiXISgzxsOwTXqr4LP+3anTVqjEfGvppRktM=;
        b=w/frei/9HMgtPMQdDEH9W+N8CacD8zR6/EKV84FCuwAmJT0xP8TOS1Wil/5SETT+0A
         vIx/IWU5VptocV0RcanHQ36D1c6qE7p01HqJ3N3+Su5r+D+1FAzg9VXhJLh/I28M4YNa
         c8W5ft1z5gtn2/soP8GEljr95MMkvD7mZhwvlHWzPc566ohtVlGz4ZzeXzEOsgK89t7Z
         xl+nIwxchu8nNOto2M5NKOxrlPpLgHLq2vPWLQDtHeKpss1WCfEz24jRUNxTpCqShCLc
         EDzghqKKgS9WfKeWZpG8bqetPVxquyrZD0PQQIqTM4XuApxN7Fu9LOBDlzsdZScCnvc8
         A/MQ==
X-Forwarded-Encrypted: i=1; AKwUvByZ6lQNlfDZqX7vn/g9vQxk7L3/nB7/Luh+EcLojLpI6pvH9PSh4dG86SPS5UZuRgORWQ52CDY7Et00@vger.kernel.org
X-Gm-Message-State: APuU4Z/f8PRGLZciUGTxKJ90kVMShTPm2UiU6MrVO9nMnIAZ6sW53DPI
	rWY6UyfGXqHQ0KQ3G2e4xf7oY4ifNB5bUfZyTiNaGbIEDDgDqOxjUkARYGhf8z0HySJBpsDRqw8
	25P7pDkuZk01y3BVym/rZfigzOg==
X-Received: from dlar7.prod.google.com ([2002:a05:701b:21c7:b0:195:8b4e:20b7])
 (user=almasrymina job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:701b:4517:10b0:185:fd0c:4585 with SMTP id a92af1059eb24-1ac5fb18de9mr20662974c88.33.1793740467189;
 Tue, 03 Nov 2026 13:14:27 -0800 (PST)
Date: Tue,  3 Nov 2026 21:14:20 +0000
In-Reply-To: <20261103211424.127627-1-almasrymina@google.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
References: <20261103211424.127627-1-almasrymina@google.com>
X-Mailer: git-send-email 2.56.0.385.gac671c819a-goog
Message-ID: <20261103211424.127627-2-almasrymina@google.com>
Subject: [PATCH net-next v1 1/5] net: skbuff: skip managed zerocopy frags in skb_frag_ref()
From: Mina Almasry <almasrymina@google.com>
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	virtualization@lists.linux.dev, linux-mm@kvack.org, bpf@vger.kernel.org, 
	linux-wireless@vger.kernel.org, linux-doc@vger.kernel.org, 
	bcm-kernel-feedback-list@broadcom.com, imx@lists.linux.dev, 
	linux-rdma@vger.kernel.org, linux-hyperv@vger.kernel.org, 
	linux-renesas-soc@vger.kernel.org, linux-omap@vger.kernel.org
Cc: Mina Almasry <almasrymina@google.com>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Simon Horman <horms@kernel.org>, Steffen Klassert <steffen.klassert@secunet.com>, 
	Herbert Xu <herbert@gondor.apana.org.au>, Willem de Bruijn <willemb@google.com>, 
	Stanislav Fomichev <sdf@fomichev.me>, Pavel Begunkov <asml.silence@gmail.com>, 
	Bobby Eshleman <bobbyeshleman@meta.com>, Andrew Lunn <andrew+netdev@lunn.ch>, 
	"Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowangio@gmail.com>, 
	"=?UTF-8?q?Eugenio=20P=C3=A9rez?=" <eperezma@redhat.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Jesper Dangaard Brouer <hawk@kernel.org>, Ilias Apalodimas <ilias.apalodimas@linaro.org>, 
	Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	John Fastabend <john.fastabend@gmail.com>, Sabrina Dubroca <sd@queasysnail.net>, 
	Johannes Berg <johannes@sipsolutions.net>, Byungchul Park <byungchul@sk.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Randy Dunlap <rdunlap@infradead.org>, Lorenzo Bianconi <lorenzo@kernel.org>, 
	Wen Gu <guwen@linux.alibaba.com>, Philo Lu <lulie@linux.alibaba.com>, 
	Justin Chen <justin.chen@broadcom.com>, Florian Fainelli <florian.fainelli@broadcom.com>, 
	Vikas Gupta <vikas.gupta@broadcom.com>, Michael Chan <michael.chan@broadcom.com>, 
	Pavan Chebbi <pavan.chebbi@broadcom.com>, Doug Berger <opendmb@gmail.com>, 
	Nicolai Buchwitz <nb@tipi-net.de>, Satish Kharat <satishkh@cisco.com>, Wei Fang <wei.fang@nxp.com>, 
	Frank Li <frank.li@nxp.com>, Shenwei Wang <shenwei.wang@nxp.com>, 
	Joshua Washington <joshwash@google.com>, Harshitha Ramamurthy <hramamurthy@google.com>, 
	Jijie Shao <shaojijie@huawei.com>, Jian Shen <shenjian15@huawei.com>, 
	Fan Gong <gongfan1@huawei.com>, Tony Nguyen <anthony.l.nguyen@intel.com>, 
	Przemek Kitszel <przemyslaw.kitszel@intel.com>, Marcin Wojtas <marcin.s.wojtas@gmail.com>, 
	Russell King <linux@armlinux.org.uk>, Sunil Goutham <sgoutham@marvell.com>, 
	Geetha sowjanya <gakula@marvell.com>, Ratheesh Kannoth <rkannoth@marvell.com>, 
	Subbaraya Sundeep <sbhatta@marvell.com>, Bharat Bhushan <bbhushan2@marvell.com>, 
	Felix Fietkau <nbd@nbd.name>, Matthias Brugger <matthias.bgg@gmail.com>, 
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>, Tariq Toukan <tariqt@nvidia.com>, 
	Saeed Mahameed <saeedm@nvidia.com>, Mark Bloch <mbloch@nvidia.com>, Leon Romanovsky <leon@kernel.org>, 
	Ido Schimmel <idosch@nvidia.com>, Petr Machata <petrm@nvidia.com>, 
	Horatiu Vultur <horatiu.vultur@microchip.com>, UNGLinuxDriver@microchip.com, 
	Daniel Machon <daniel.machon@microchip.com>, Steen Hegelund <Steen.Hegelund@microchip.com>, 
	Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, 
	Dexuan Cui <decui@microsoft.com>, Yibo Dong <dong100@mucse.com>, 
	Brett Creeley <brett.creeley@amd.com>, Justin Lai <justinlai0215@realtek.com>, 
	Larry Chiu <larry.chiu@realtek.com>, 
	"=?UTF-8?q?Niklas=20S=C3=B6derlund?=" <niklas.soderlund@ragnatech.se>, Paul Barker <paul@pbarker.dev>, 
	Masahisa Kojima <kojima.masahisa@socionext.com>, 
	Maxime Chevallier <maxime.chevallier@bootlin.com>, Maxime Coquelin <mcoquelin.stm32@gmail.com>, 
	Alexandre Torgue <alexandre.torgue@foss.st.com>, FUJITA Tomonori <fujita.tomonori@gmail.com>, 
	Siddharth Vadapalli <s-vadapalli@ti.com>, Roger Quadros <rogerq@kernel.org>, 
	MD Danish Anwar <danishanwar@ti.com>, Jiawen Wu <jiawenwu@trustnetic.com>, 
	Mengyuan Lou <mengyuanlou@net-swift.com>, Ronak Doshi <ronak.doshi@broadcom.com>, 
	Ryder Lee <ryder.lee@mediatek.com>, Shayne Chen <shayne.chen@mediatek.com>, 
	Sean Wang <sean.wang@mediatek.com>, Juergen Gross <jgross@suse.com>, 
	Stefano Stabellini <sstabellini@kernel.org>, 
	Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>, Jordan Rhee <jordanrhee@google.com>, 
	Ankit Garg <nktgrg@google.com>, Tim Hostetler <thostet@google.com>, 
	Erni Sri Satya Vennela <ernis@linux.microsoft.com>, Eric Joyner <eric.joyner@amd.com>, 
	Mohammad Heib <mheib@redhat.com>, Prabu Thayalan <prabu.ponrajthayalan@amd.com>, 
	Chintan Vankar <c-vankar@ti.com>, Nora Schiffer <nora.schiffer@ew.tq-group.com>, 
	Alexander Sverdlin <alex@sverdlin.org>, Kevin Hao <haokexin@gmail.com>, 
	Karl Mehltretter <kmehltretter@gmail.com>, 
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>, Meghana Malladi <m-malladi@ti.com>, 
	Jacob Keller <jacob.e.keller@intel.com>, StanleyYP Wang <StanleyYP.Wang@mediatek.com>
Content-Type: text/plain; charset="UTF-8"

skb_frag_unref() and skb_release_data() skip releasing references on
managed zerocopy fragments (SKBFL_MANAGED_FRAG_REFS), whereas
skb_frag_ref() acquires a reference unconditionally. If skb_frag_ref()
is called on a managed zerocopy SKB, the acquired reference is never
released by skb_frag_unref() or skb_release_data().

Skip acquiring a reference in skb_frag_ref() when skb_zcopy_managed(skb)
is true so skb_frag_ref() matches skb_frag_unref() and
skb_release_data(), and disable share_ok in iptfs_output_queued() when
skb_zcopy_managed(skb) is true so iptfs_consume_frags() does not append
unreferenced fragments into a managed zerocopy outer SKB.

Signed-off-by: Mina Almasry <almasrymina@google.com>
---
 include/linux/skbuff_ref.h | 10 +++++++---
 net/core/net_test.c        | 10 ++++++++++
 net/xfrm/xfrm_iptfs.c      |  3 ++-
 3 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/include/linux/skbuff_ref.h b/include/linux/skbuff_ref.h
index b6f6da556ee90..e94c599ce83d2 100644
--- a/include/linux/skbuff_ref.h
+++ b/include/linux/skbuff_ref.h
@@ -36,12 +36,16 @@ static __always_inline void skb_netmem_ref(netmem_ref netmem, bool recycle)
  *
  * Acquires a reference on the @f'th fragment of @skb via skb_netmem_ref()
  * (pp_ref_count if skb->pp_recycle and page_pool-backed, else non-pp
- * backing refcount). Counterpart to skb_frag_unref().
+ * backing refcount), skipping managed zerocopy fragments. Counterpart to
+ * skb_frag_unref().
  */
 static __always_inline void skb_frag_ref(struct sk_buff *skb, int f)
 {
-	skb_netmem_ref(skb_frag_netmem(&skb_shinfo(skb)->frags[f]),
-		       skb->pp_recycle);
+	struct skb_shared_info *shinfo = skb_shinfo(skb);
+
+	if (!skb_zcopy_managed(skb))
+		skb_netmem_ref(skb_frag_netmem(&shinfo->frags[f]),
+			       skb->pp_recycle);
 }
 
 bool napi_pp_put_page(netmem_ref netmem);
diff --git a/net/core/net_test.c b/net/core/net_test.c
index 2b5080c226636..e20059a00003c 100644
--- a/net/core/net_test.c
+++ b/net/core/net_test.c
@@ -571,6 +571,16 @@ static void netmem_ref_test_page(struct kunit *test)
 	skb_frag_unref(skb, 0);
 	KUNIT_EXPECT_EQ(test, page_ref_count(page), base_ref);
 
+	/* SKBFL_MANAGED_FRAG_REFS skips both skb_frag_ref and skb_frag_unref */
+	skb_shinfo(skb)->flags |= SKBFL_ZEROCOPY_ENABLE |
+				  SKBFL_MANAGED_FRAG_REFS;
+	skb_frag_ref(skb, 0);
+	KUNIT_EXPECT_EQ(test, page_ref_count(page), base_ref);
+	skb_frag_unref(skb, 0);
+	KUNIT_EXPECT_EQ(test, page_ref_count(page), base_ref);
+	skb_shinfo(skb)->flags &= ~(SKBFL_ZEROCOPY_ENABLE |
+				    SKBFL_MANAGED_FRAG_REFS);
+
 	skb_shinfo(skb)->nr_frags = 0;
 	consume_skb(skb);
 	__free_page(page);
diff --git a/net/xfrm/xfrm_iptfs.c b/net/xfrm/xfrm_iptfs.c
index 103cf7c5dbfb9..04ef833074fc8 100644
--- a/net/xfrm/xfrm_iptfs.c
+++ b/net/xfrm/xfrm_iptfs.c
@@ -2258,7 +2258,8 @@ static void iptfs_output_queued(struct xfrm_state *x, struct sk_buff_head *list)
 				nextp = &(*nextp)->next;
 		}
 
-		if (shi->frag_list || skb_cloned(skb) || skb_shared(skb))
+		if (shi->frag_list || skb_cloned(skb) || skb_shared(skb) ||
+		    skb_zcopy_managed(skb))
 			share_ok = false;
 
 		/* See if we have enough space to simply append.
-- 
2.56.0.385.gac671c819a-goog

