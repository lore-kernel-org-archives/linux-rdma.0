Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.197
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793740472;
	b=0zif5SgpMuOWzXRa0U7q/MoIarXqOq3roA48du97ul+V+eW6WOv5+C07JPcNiJfXM7YO
	 tDrQmx+ixVJdlraRaMrhONbCUqlH03JkpJimbdtpeYMI094yL78Y4/GdVNXhrXmD0RaG/
	 TP5v3aAOLFVNOV+BdcKaqk0jttb5/pLER3K35Qz6HHyKoVb95310reV14E+iW1e9Cc8Vh
	 7D1zVeJobl3GX8r9yC0G/ajBnXKTlanWXfskHQKQ0EVF4hN1qfSNmPeTW9/GIjq2AF3/l
	 g83U4bS/b1G3bK1qck2aAa+JC4OqMTfs46s2DtaVU9XJoathcYLBquZt+6R+Y35SgLA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793740472;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=+2yCJaGEbyCpc4GPm4MdejLrIvWaF/SQGhmWy+Wu8aI=;
	b=AtDAJWodorzDvLOMiE/VvnNrONI+h2m8vtcILRlQnlj+j+ltqiaRr3arswTciwiIdCur
	 0EQWBxAuDYllVorHOgKuonvkxgx0jwX/D77b/lRmanhOFWTHEMrEMzdM8ApTnBphVhytO
	 7s3N48hbpiLmehGFuFNHKdSbfSPP13AbVyAjRqzMa8zv7y/s7W/8fbZOAdQNF+w8j/M70
	 2JVQOwQmY7GNVcqbJ70KiwrC34RXWUh9PW5jZsJbbujJAvY7XAIYv/0gwaQn8bQ+G2UTz
	 5f88Y9Ehs6/Sy1HZMV0p6+fJgDdHeX15sn3r57Yo8GKvUoKLF1EthQNgU7ASvbWJobA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--almasrymina.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=J0GTklSJ;
	arc=none smtp.remote-ip=74.125.82.197
Received: from mail-dy1-f197.google.com (mail-dy1-f197.google.com [74.125.82.197])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB2BD606EE95
	for <linux-rdma@vger.kernel.org>; Tue,  3 Nov 2026 21:14:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BB2BD606EE95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--almasrymina.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=J0GTklSJ
Received: by mail-dy1-f197.google.com with SMTP id 5a478bee46e88-30bcb065bfdso8206753eec.0
        for <linux-rdma@vger.kernel.org>; Tue, 03 Nov 2026 13:14:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793740471; x=1794345271; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+2yCJaGEbyCpc4GPm4MdejLrIvWaF/SQGhmWy+Wu8aI=;
        b=J0GTklSJA0yPK2BwCTAjrh9eqi5L3NgNqWDz3qWwHvFAKjuw260KypyEmWMZHb8zpQ
         4g53u+aqrx7AhHkDvpATs7i2/vmEWInSfCx9tDXP8qTyqK6I+V4keW/5NkamP7Vf+maW
         y27HLk7d4vqhxNompL8ALUuNpOyDgHI8EGkgu6WK/R/fin39qMbZc6ODbIqS8utfqPoQ
         cCBJMVtE0c/FYOuCjqhHjAyzFs1P51xbWZYILfE9CzZkglJU8u1JpAaov5qOJloEcGvi
         Wc+RgAJeTXEot7KayINFeiN6WVP2QWc2ouNKaShXUpts1teJX3yrpS8WDvF8BkeVJz9N
         gudg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793740471; x=1794345271;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+2yCJaGEbyCpc4GPm4MdejLrIvWaF/SQGhmWy+Wu8aI=;
        b=z7fwdz3DZdw2PVxSnktytWYDShIOk+SqpvwKYG3GWDPnPlUNPkJEJfrUjigR7YPpD5
         BdDEZZ5bDXQ7HfUo5FmsjY29ETe08PG/4OJWMhk4Vsd5UWN4Tcd80BWm6DEGVrtciaCy
         g50Tsd3ZZNhduo2ygk7sj30+RUd3SnvHtX6/8SohNwmHd5TvfVCxB+k4g7vrrYpZwEvh
         0KMccLTrYtNtEvUXuoljUEHR9Pi0QIxyo/QCm1CxV6JFr40YWgFlFjSZ1NhhDPBKc5ww
         F3jsQdYeQjVxejYOwDiCKFF01f5rfQuu8u6A5wmCu2hr6e74O/1mIJtTBwCJeLw48Ota
         hpMQ==
X-Forwarded-Encrypted: i=1; AKwUvBxvVAOzJSUzMXGDDNF6Lj//ocEI2SdH18ZuV8uXNM+K/AWtRIAcs6m87Q5zZ+kXSRXhZECqf+PAJb/7@vger.kernel.org
X-Gm-Message-State: APuU4Z8h7ZO5oq1PIgGRAoKb6rZAasgte71CX7PLmn/qNzynoBDGyOjY
	nxsPyiBMHUN8kPnvJkuBk2J7CTp7xv8edWoQeA6N8fCkjKEGSjKOLElfy97ApqzSJdcmO7TyRxa
	ZPS+blq9MO7Oedx96clZQD+ib8w==
X-Received: from dyvj18-n1.prod.google.com ([2002:a05:693c:87d2:10b0:368:2c6d:de10])
 (user=almasrymina job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:693c:8959:20b0:369:f5f6:36a7 with SMTP id 5a478bee46e88-36a423d1cc5mr22095354eec.16.1793740470274;
 Tue, 03 Nov 2026 13:14:30 -0800 (PST)
Date: Tue,  3 Nov 2026 21:14:22 +0000
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
Message-ID: <20261103211424.127627-4-almasrymina@google.com>
Subject: [PATCH net-next v1 3/5] net: datagram: refcount page_pool frags in zerocopy_fill_skb_from_iter()
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

When an application maps order-0 page_pool RX fragments into user space
via TCP_ZEROCOPY_RECEIVE and forwards that mapped address into TX
sendmsg(MSG_ZEROCOPY), zerocopy_fill_skb_from_iter() pins the pages via
iov_iter_get_pages2() (which increments page->_refcount) while
skb_release_data() releases fragments via netmem_dec_ref().

Acquire each fragment reference via netmem_inc_ref() when attaching a
fragment in zerocopy_fill_skb_from_iter() and release the corresponding
GUP page->_refcount reference via the existing batched page_ref_sub()
path so the TX SKB fragment reference pairs with netmem_dec_ref() in
skb_release_data() once netmem_inc_ref() and netmem_dec_ref() handle
page_pool netmems.

Signed-off-by: Mina Almasry <almasrymina@google.com>
---
 net/core/datagram.c |   5 ++
 net/core/net_test.c | 146 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 151 insertions(+)

diff --git a/net/core/datagram.c b/net/core/datagram.c
index ecc30a6f83023..f2d6d1d7be2b6 100644
--- a/net/core/datagram.c
+++ b/net/core/datagram.c
@@ -34,6 +34,7 @@
  *
  */
 
+#include <kunit/visibility.h>
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
@@ -696,12 +697,16 @@ int zerocopy_fill_skb_from_iter(struct sk_buff *skb,
 				refs = 0;
 			}
 			skb_fill_page_desc_noacc(skb, frag++, head, start, size);
+			netmem_inc_ref(page_to_netmem(head));
+			last_head = head;
+			refs++;
 		}
 		if (refs)
 			page_ref_sub(last_head, refs);
 	}
 	return 0;
 }
+EXPORT_SYMBOL_IF_KUNIT(zerocopy_fill_skb_from_iter);
 
 static int
 zerocopy_fill_skb_from_devmem(struct sk_buff *skb, struct iov_iter *from,
diff --git a/net/core/net_test.c b/net/core/net_test.c
index e20059a00003c..73da75e6ca2c8 100644
--- a/net/core/net_test.c
+++ b/net/core/net_test.c
@@ -515,7 +515,9 @@ static void ip_tunnel_flags_test_run(struct kunit *test)
 
 /* Netmem & SKB fragment refcounting */
 
+#include <linux/folio_queue.h>
 #include <linux/skbuff_ref.h>
+#include <linux/uio.h>
 #include <net/netmem.h>
 #include <net/netdev_rx_queue.h>
 #include <net/page_pool/helpers.h>
@@ -841,6 +843,149 @@ static void netmem_ref_test_pp_page(struct kunit *test)
 	page_pool_put_full_page(pool, page, false);
 	page_pool_destroy(pool);
 }
+
+int zerocopy_fill_skb_from_iter(struct sk_buff *skb,
+				struct iov_iter *from, size_t length);
+
+static void netmem_ref_test_zerocopy_fill_skb_from_iter(struct kunit *test)
+{
+	struct page_pool_params pp_params = {
+		.order = 0,
+		.pool_size = 4,
+		.nid = NUMA_NO_NODE,
+	};
+	struct page *pp_page, *comp_page, *reg_page;
+	struct page_pool *pool, *comp_pool;
+	int base_ref, base_comp_ref, base_reg_ref;
+	long base_pp_ref, base_comp_pp_ref;
+	struct folio_queue folioq;
+	struct bio_vec bvec[3];
+	struct iov_iter iter;
+	struct sk_buff *skb;
+
+	pool = page_pool_create(&pp_params);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, pool);
+	pp_page = page_pool_dev_alloc_pages(pool);
+	KUNIT_ASSERT_NOT_NULL(test, pp_page);
+	base_ref = page_ref_count(pp_page);
+	base_pp_ref = atomic_long_read(&pp_page->pp_ref_count);
+
+	/* 1. Single order-0 page_pool page (simulating TCP_ZEROCOPY_RECEIVE
+	 * page forwarded into MSG_ZEROCOPY TX via zerocopy_fill_skb_from_iter).
+	 */
+	skb = alloc_skb(0, GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, skb);
+	bvec_set_page(&bvec[0], pp_page, 128, 0);
+	iov_iter_bvec(&iter, ITER_SOURCE, bvec, 1, 128);
+	KUNIT_ASSERT_EQ(test, zerocopy_fill_skb_from_iter(skb, &iter, 128), 0);
+	KUNIT_EXPECT_EQ(test, skb_shinfo(skb)->nr_frags, 1);
+	KUNIT_EXPECT_EQ(test, atomic_long_read(&pp_page->pp_ref_count),
+			base_pp_ref);
+	KUNIT_EXPECT_EQ(test, page_ref_count(pp_page), base_ref + 1);
+	consume_skb(skb);
+	KUNIT_EXPECT_EQ(test, atomic_long_read(&pp_page->pp_ref_count),
+			base_pp_ref);
+	KUNIT_EXPECT_EQ(test, page_ref_count(pp_page), base_ref);
+
+	/* 2. Contiguous segments on the same page_pool page coalesce into a
+	 * single skb_frag_t while a non-contiguous segment creates a second
+	 * skb_frag_t; all 3 GUP _refcounts are dropped.
+	 */
+	skb = alloc_skb(0, GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, skb);
+	bvec_set_page(&bvec[0], pp_page, 64, 0);
+	bvec_set_page(&bvec[1], pp_page, 64, 64);
+	bvec_set_page(&bvec[2], pp_page, 64, 256);
+	iov_iter_bvec(&iter, ITER_SOURCE, bvec, 3, 192);
+	KUNIT_ASSERT_EQ(test, zerocopy_fill_skb_from_iter(skb, &iter, 192), 0);
+	KUNIT_EXPECT_EQ(test, skb_shinfo(skb)->nr_frags, 2);
+	KUNIT_EXPECT_EQ(test, skb_frag_size(&skb_shinfo(skb)->frags[0]), 128U);
+	KUNIT_EXPECT_EQ(test, skb_frag_size(&skb_shinfo(skb)->frags[1]), 64U);
+	KUNIT_EXPECT_EQ(test, atomic_long_read(&pp_page->pp_ref_count),
+			base_pp_ref);
+	KUNIT_EXPECT_EQ(test, page_ref_count(pp_page), base_ref + 2);
+	consume_skb(skb);
+	KUNIT_EXPECT_EQ(test, atomic_long_read(&pp_page->pp_ref_count),
+			base_pp_ref);
+	KUNIT_EXPECT_EQ(test, page_ref_count(pp_page), base_ref);
+
+	/* 3. Order-1 compound page_pool page spanning 2 subpages in a single
+	 * iov_iter_get_pages2() batch coalesces into 1 skb_frag_t and drops
+	 * both GUP _refcounts via batched page_ref_sub, alongside a
+	 * non-page_pool page in the same skb.
+	 */
+	pp_params.order = 1;
+	comp_pool = page_pool_create(&pp_params);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, comp_pool);
+	comp_page = page_pool_dev_alloc_pages(comp_pool);
+	KUNIT_ASSERT_NOT_NULL(test, comp_page);
+	base_comp_ref = page_ref_count(comp_page);
+	base_comp_pp_ref = atomic_long_read(&comp_page->pp_ref_count);
+
+	reg_page = alloc_page(GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, reg_page);
+	base_reg_ref = page_ref_count(reg_page);
+
+	skb = alloc_skb(0, GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, skb);
+	bvec_set_page(&bvec[0], comp_page, 2 * PAGE_SIZE, 0);
+	bvec_set_page(&bvec[1], reg_page, 64, 0);
+	iov_iter_bvec(&iter, ITER_SOURCE, bvec, 2, 2 * PAGE_SIZE + 64);
+	KUNIT_ASSERT_EQ(test,
+			zerocopy_fill_skb_from_iter(skb, &iter,
+						    2 * PAGE_SIZE + 64), 0);
+	KUNIT_EXPECT_EQ(test, skb_shinfo(skb)->nr_frags, 2);
+	KUNIT_EXPECT_EQ(test, skb_frag_size(&skb_shinfo(skb)->frags[0]),
+			(unsigned int)(2 * PAGE_SIZE));
+	KUNIT_EXPECT_EQ(test, atomic_long_read(&comp_page->pp_ref_count),
+			base_comp_pp_ref);
+	KUNIT_EXPECT_EQ(test, page_ref_count(comp_page), base_comp_ref + 1);
+	KUNIT_EXPECT_EQ(test, page_ref_count(reg_page), base_reg_ref + 1);
+	consume_skb(skb);
+	KUNIT_EXPECT_EQ(test, atomic_long_read(&comp_page->pp_ref_count),
+			base_comp_pp_ref);
+	KUNIT_EXPECT_EQ(test, page_ref_count(comp_page), base_comp_ref);
+	KUNIT_EXPECT_EQ(test, page_ref_count(reg_page), base_reg_ref);
+
+	/* 4. Single-batch mixed folios via ITER_FOLIOQ: order-1 compound
+	 * page_pool folio (2 subpages) + non-page_pool folio + order-0
+	 * page_pool folio returned in a single iov_iter_get_pages2() call.
+	 */
+	folioq_init(&folioq, 0);
+	folioq_append(&folioq, page_folio(comp_page));
+	folioq_append(&folioq, page_folio(reg_page));
+	folioq_append(&folioq, page_folio(pp_page));
+	iov_iter_folio_queue(&iter, ITER_SOURCE, &folioq, 0, 0,
+			     3 * PAGE_SIZE + 64);
+
+	skb = alloc_skb(0, GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, skb);
+	KUNIT_ASSERT_EQ(test,
+			zerocopy_fill_skb_from_iter(skb, &iter,
+						    3 * PAGE_SIZE + 64), 0);
+	KUNIT_EXPECT_EQ(test, skb_shinfo(skb)->nr_frags, 3);
+	KUNIT_EXPECT_EQ(test, atomic_long_read(&comp_page->pp_ref_count),
+			base_comp_pp_ref);
+	KUNIT_EXPECT_EQ(test, page_ref_count(comp_page), base_comp_ref + 1);
+	KUNIT_EXPECT_EQ(test, page_ref_count(reg_page), base_reg_ref + 1);
+	KUNIT_EXPECT_EQ(test, atomic_long_read(&pp_page->pp_ref_count),
+			base_pp_ref);
+	KUNIT_EXPECT_EQ(test, page_ref_count(pp_page), base_ref + 1);
+	consume_skb(skb);
+	KUNIT_EXPECT_EQ(test, atomic_long_read(&comp_page->pp_ref_count),
+			base_comp_pp_ref);
+	KUNIT_EXPECT_EQ(test, page_ref_count(comp_page), base_comp_ref);
+	KUNIT_EXPECT_EQ(test, page_ref_count(reg_page), base_reg_ref);
+	KUNIT_EXPECT_EQ(test, atomic_long_read(&pp_page->pp_ref_count),
+			base_pp_ref);
+	KUNIT_EXPECT_EQ(test, page_ref_count(pp_page), base_ref);
+
+	__free_page(reg_page);
+	page_pool_put_full_page(comp_pool, comp_page, false);
+	page_pool_destroy(comp_pool);
+	page_pool_put_full_page(pool, pp_page, false);
+	page_pool_destroy(pool);
+}
 #endif
 
 #if defined(CONFIG_PAGE_POOL) && defined(CONFIG_NET_DEVMEM)
@@ -1738,6 +1883,7 @@ static struct kunit_case net_test_cases[] = {
 	KUNIT_CASE(netmem_ref_test_page),
 #ifdef CONFIG_PAGE_POOL
 	KUNIT_CASE(netmem_ref_test_pp_page),
+	KUNIT_CASE(netmem_ref_test_zerocopy_fill_skb_from_iter),
 #endif
 #if defined(CONFIG_PAGE_POOL) && defined(CONFIG_NET_DEVMEM)
 	KUNIT_CASE(netmem_ref_test_net_iov),
-- 
2.56.0.385.gac671c819a-goog

