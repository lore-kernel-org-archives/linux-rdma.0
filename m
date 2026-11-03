Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.197
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793740475;
	b=h+opILFJ6qKGxly7gRQo3CUjbBmsWBohRnpgLhQ4TnVtXvfu3K6Vqfn5m1cRA9moO6iT
	 y1P9fimkhoa2QVuOkoPs1d5AhpjM9B5hF16WBDTQmzJxXQ6lAYmrYgn0foqF7XfYaBO2c
	 9wXntbzltZaXv0mtEGBQedF1a62gNc4yF5TXfWGG2w/Y7aggUIMGLeW3U+XiBi6oDJuys
	 DQtY8rdkPpPseXw0fkW9BX6uD+LLei84qGW6EZiexqRjincmy898bVUr9UW8BHI6Hd4Yy
	 jo9sElIi7TJ/QX9yR2RLezBRsuhOw5bGgE/5tk3Oc7CAR7ObsC7EST3Q9i8IUd6Ft2Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793740475;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=VhxNkTP4QlwrLJbyIN/kMluTtRM9CY8TDQBPbQzFkwU=;
	b=mnjDGF9sbkt3Z2rEGNZCTxOnq49FHHbcXaD8wM3io7TRPQy2k5lPBeII96OxO9/OAjQR
	 lIk3oCoGKc4Z+t+PZt522PDIz3jbUAh/KsUQakCmXaOqsnRlZiQMhyyCpHblRQEiaoFjl
	 4dOtE9HV0+0y9fgExfZ5Myb07qjMYfjOmhq4kMeR5HuqxmxG09ge/fy8TdsVNH86fktag
	 6XKtrzeAqxQiG9sQzgy0cHOonmgHvNOVvsVmIKH4JeWji5VYtodRVI0yPuDPmTWTAAkDF
	 b8A7p2EFfjcsDRsWlrYDeV+Jjpc2f7FQXlVttBwTzGYd4nDDxYqwPHYmo9+5xaLOqcw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--almasrymina.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=REItYk7z;
	arc=none smtp.remote-ip=74.125.82.197
Received: from mail-dy1-f197.google.com (mail-dy1-f197.google.com [74.125.82.197])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4D0E606EEB3
	for <linux-rdma@vger.kernel.org>; Tue,  3 Nov 2026 21:14:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A4D0E606EEB3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--almasrymina.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=REItYk7z
Received: by mail-dy1-f197.google.com with SMTP id 5a478bee46e88-30bcb065bfdso8206838eec.0
        for <linux-rdma@vger.kernel.org>; Tue, 03 Nov 2026 13:14:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793740473; x=1794345273; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=VhxNkTP4QlwrLJbyIN/kMluTtRM9CY8TDQBPbQzFkwU=;
        b=REItYk7zsoCM/XT6wx5qq2ZVHIE3KAYVdKyCpF/88P2v2TaJSBxmhzif2lCju3lQq2
         c8ctsKMM2Bd6KKOrQ2cyuJhpKhlT4o4jApyN6uskUW+iBlTVUnUO47v0plLIUaVvUjrj
         gwPKMECivtiZ/YHnMUI4axgMgQJKUdBWWA7hn727xqAJJmMhgT6zRfDaeieOtXSPn57S
         5hEd14oEGPnaAwO4x1SHCYzimMhCF3T0sigbbmOWp9ms8tCbjLsBKOpZfVrcwe1NKd0k
         Ntqr2DjiSbXZxVOPy4Mx8s20dNopRsbvhk0iPwZM0nqOa3xTAGANW28gM1Y9Vun4+6Vs
         oOjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793740473; x=1794345273;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=VhxNkTP4QlwrLJbyIN/kMluTtRM9CY8TDQBPbQzFkwU=;
        b=F8YEDlyAs9sEjOGjNBx03hbOIREJWz4pQs74MntsWLhAFAdpljpqwy02X16Qh6QDM3
         MtfNY4rbQtVLQHw4AtMATxcSbUDOAarvgf4HKY9sIZRfTkrZy1rA8aFGb66hAI0lcLbA
         yCPH76ILsManJ0apBhyNUjuoSmoFVHnKzNzcPkDsm1Y+PnGXrVA2yzAIOvwCdBb0mCN5
         aq7l87jZvqkvmX5x2QkkZsZK0lf+c6gkE934JtFb0Mi8tKqkUf9O0oqLjeGryj7vVvDX
         XpX1KOZxIZo3Q4fe7paslllSOTkXEcNVnSyKLI71v2R7kFTKXI9lS71zJDACImfJoF1g
         8V7w==
X-Forwarded-Encrypted: i=1; AKwUvBxHCTr4mWxGpOIp//P3jMPqgG4FYFTbgmKmLB/y5bruSbsYW2qBZU4IsDj+JBvourj1/6GcH0JBONUK@vger.kernel.org
X-Gm-Message-State: APuU4Z+0m4yMrFbmSNcw/zD6Zj49zOMVuwWrGGXQBQzufzPh8dRzWJFd
	6hrhtE+feIYyFtUBrZafwWDdCV+IUPmYsKPnFpEQSCBpJX5El/ZekqVFsQs2/RK3YPj5nf3GhCC
	CxFB+ybH/++8+nRICaxGwtwN0eA==
X-Received: from dyiw20.prod.google.com ([2002:a05:7300:8314:b0:369:ff7f:6354])
 (user=almasrymina job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:693c:6393:10b0:35c:f667:8b9a with SMTP id 5a478bee46e88-36a423948efmr20819505eec.6.1793740471842;
 Tue, 03 Nov 2026 13:14:31 -0800 (PST)
Date: Tue,  3 Nov 2026 21:14:23 +0000
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
Message-ID: <20261103211424.127627-5-almasrymina@google.com>
Subject: [PATCH net-next v1 4/5] net: remove skb->pp_recycle and consolidate
 netmem refcounting
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

skb->pp_recycle was introduced in commit 6a5bcd84e886 ("page_pool: Allow
drivers to hint on SKB recycling") when drivers had to explicitly opt in
to page_pool SKB recycling and to avoid touching struct page on the free
path. Today every page_pool-backed netmem carries its own identity via
netmem_is_pp(), making the per-SKB skb->pp_recycle bitfield redundant
and error-prone when SKBs are cloned, split, segmented, shifted, or
coalesced across page_pool and non-page_pool buffers. For non-page_pool
pages, get_page(), put_page(), and skb_free_frag() immediately load the
same first struct page cache line (compound_head, which shares the cache
line with pp_magic), so checking netmem_is_pp() does not add an extra
cache-line load.

Remove skb->pp_recycle and check netmem_is_pp() directly via
napi_pp_get_page() and napi_pp_put_page() inside netmem_inc_ref(),
netmem_dec_ref(), and skb_pp_recycle(), dropping the now-redundant
skb_netmem_ref() and skb_netmem_unref() wrappers. Keep
skb_mark_for_recycle() as a no-op stub to remove its callers in a
separate patch.

Use READ_ONCE() and WRITE_ONCE() on pp_magic and pp because every SKB
fragment ref/unref now checks netmem_is_pp(), and page->pp_magic shares
a struct page union word with folio->lru.next which MM code may
concurrently modify on page-cache folios in TX SKBs.

To close the race where a caller holding only a struct page reference
(such as zerocopy_fill_skb_from_iter(), vmsplice() of a
TCP_ZEROCOPY_RECEIVE mapping, or sk_msg_page_add()) calls
netmem_inc_ref() -> napi_pp_get_page() while the last page_pool holder
concurrently releases its pp_ref_count:
- In page_pool_unref_netmem(), only take the non-RMW read fast path or
  reset pp_ref_count to 1 when the page_pool holds the sole page
  reference (page_ref_count == 1); when an external page reference
  exists, atomically decrement pp_ref_count to 0 and leave it at 0
  (restoring it to 1 in __page_pool_put_page() if the external page
  reference is dropped before recycling).
- In napi_pp_get_page() and napi_pp_put_page(), use
  atomic_long_inc_not_zero() and check page_pool_ref_count() so once
  pp_ref_count reaches 0, concurrent callers consistently fall back to
  get_page() and put_page().

Verified no fast-path regression with bench_page_pool_simple:
- no-softirq-page_pool01 (fast path): 37 cycles (18.7 ns) baseline vs
  36-37 cycles (18.5 ns) patched.
- no-softirq-page_pool02 (ptr_ring): 77-78 cycles (38.9 ns) baseline vs
  76-77 cycles (38.4 ns) patched.
- no-softirq-page_pool03 (slow page-allocator path with elevated
  page_ref_count): 462-467 cycles (232.2 ns) baseline vs 478-484 cycles
  (240.7 ns) patched (+3.4% due to atomic pp_ref_count -> 0 transition
  when page_ref_count > 1).

Notes:
- __frame_add_frag() in net/wireless/util.c is switched from get_page()
  to skb_frag_ref() (with a MAX_SKB_FRAGS check) so mac80211 A-MSDU
  subframe SKBs on page_pool wireless drivers (such as mt76) pair with
  skb_release_data().
- net/tls/ record and scatterlist page references in tls_device.c,
  tls_device_fallback.c, and tls_main.c are paired with
  netmem_inc_ref() and netmem_dec_ref() (with destroy_record() in
  tls_tcp_clean_acked() deferred until after dropping ctx->lock).

Caveats:
- For struct page-backed netmems, page_pool membership is identified via
  page->pp_magic, which has a pre-existing union aliasing risk with
  non-networking struct page fields if a non-page_pool page's union
  field matches PP_SIGNATURE (in particular on 32-bit architectures
  where POISON_POINTER_DELTA is 0); removing skb->pp_recycle extends
  this check from pp_recycle=1 SKBs to all netmem_inc_ref(),
  netmem_dec_ref(), and skb_pp_recycle() operations.
- netpoll_zap_completion_queue() has a pre-existing issue where
  skb_irq_freeable() does not exclude SKBs holding page_pool memory
  before calling __kfree_skb() with hardirqs disabled; TX SKBs carrying
  spliced page_pool fragments are subject to the same path.

Signed-off-by: Mina Almasry <almasrymina@google.com>
---
 drivers/net/veth.c              |   3 +-
 drivers/net/virtio_net.c        |   8 +-
 include/linux/mm.h              |   2 +-
 include/linux/skbuff.h          |   9 +-
 include/linux/skbuff_ref.h      |  60 +-------
 include/net/netmem.h            |  39 +++--
 include/net/page_pool/helpers.h |  41 +++++-
 net/core/gro.c                  |   9 --
 net/core/net_test.c             | 251 +++++++++++---------------------
 net/core/netmem_priv.h          |  23 ++-
 net/core/page_pool.c            |   8 +-
 net/core/skbuff.c               |  51 ++-----
 net/core/xdp.c                  |   2 +-
 net/ipv4/esp4.c                 |  11 +-
 net/ipv6/esp6.c                 |  11 +-
 net/tls/tls_device.c            |  14 +-
 net/tls/tls_device_fallback.c   |   6 +-
 net/tls/tls_main.c              |   4 +-
 net/wireless/util.c             |  31 +++-
 net/xfrm/trace_iptfs.h          |   6 +-
 net/xfrm/xfrm_iptfs.c           |  13 +-
 21 files changed, 246 insertions(+), 356 deletions(-)

diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index 3eca92d3dc60d..285958432ea0a 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -27,7 +27,6 @@
 #include <linux/ptr_ring.h>
 #include <linux/bpf_trace.h>
 #include <linux/net_tstamp.h>
-#include <linux/skbuff_ref.h>
 #include <net/page_pool/helpers.h>
 
 #define DRV_NAME	"veth"
@@ -746,7 +745,7 @@ static void veth_xdp_get(struct xdp_buff *xdp)
 	struct skb_shared_info *sinfo = xdp_get_shared_info_from_buff(xdp);
 	int i;
 
-	get_page(virt_to_page(xdp->data));
+	netmem_inc_ref(page_to_netmem(virt_to_page(xdp->data)));
 	if (likely(!xdp_buff_has_frags(xdp)))
 		return;
 
diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index dd2c41ef6fbe7..3453689bfd341 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -2351,9 +2351,6 @@ static struct sk_buff *virtnet_skb_append_frag(struct receive_queue *rq,
 		if (unlikely(!nskb))
 			return NULL;
 
-		if (head_skb->pp_recycle)
-			skb_mark_for_recycle(nskb);
-
 		if (curr_skb == head_skb)
 			skb_shinfo(curr_skb)->frag_list = nskb;
 		else
@@ -2371,10 +2368,7 @@ static struct sk_buff *virtnet_skb_append_frag(struct receive_queue *rq,
 
 	offset = buf - page_address(page);
 	if (skb_can_coalesce(curr_skb, num_skb_frags, page, offset)) {
-		if (head_skb->pp_recycle)
-			page_pool_put_page(rq->page_pool, page, -1, true);
-		else
-			put_page(page);
+		netmem_dec_ref(page_to_netmem(page));
 		skb_coalesce_rx_frag(curr_skb, num_skb_frags - 1,
 				     len, truesize);
 	} else {
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 9f167950926a1..f13d9f6b3ed50 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -5698,7 +5698,7 @@ int arch_lock_shadow_stack_status(struct task_struct *t, unsigned long status);
 #ifdef CONFIG_PAGE_POOL
 static inline bool page_pool_page_is_pp(const struct page *page)
 {
-	return (page->pp_magic & PP_MAGIC_MASK) == PP_SIGNATURE;
+	return (READ_ONCE(page->pp_magic) & PP_MAGIC_MASK) == PP_SIGNATURE;
 }
 #else
 static inline bool page_pool_page_is_pp(const struct page *page)
diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 6787fcf6ac3e4..4eaf4da1f7dad 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -834,8 +834,6 @@ enum skb_tstamp_type {
  *	@head_frag: skb was allocated from page fragments,
  *		not allocated by kmalloc() or vmalloc().
  *	@pfmemalloc: skbuff was allocated from PFMEMALLOC reserves
- *	@pp_recycle: mark the packet for recycling instead of freeing (implies
- *		page_pool support on driver)
  *	@active_extensions: active extensions (skb_ext_id types)
  *	@ndisc_nodetype: router type (from link layer)
  *	@ooo_okay: allow the mapping of a socket to a queue to be changed
@@ -964,8 +962,7 @@ struct sk_buff {
 				fclone:2,
 				peeked:1,
 				head_frag:1,
-				pfmemalloc:1,
-				pp_recycle:1; /* page_pool recycle indicator */
+				pfmemalloc:1;
 #ifdef CONFIG_SKB_EXTENSIONS
 	__u8			active_extensions;
 #endif
@@ -5476,11 +5473,9 @@ static inline struct kcov_common_handle_id skb_get_kcov_handle(struct sk_buff *s
 	return skb->kcov_handle;
 }
 
+/* Deprecated: page_pool recycling is now determined per netmem. */
 static inline void skb_mark_for_recycle(struct sk_buff *skb)
 {
-#ifdef CONFIG_PAGE_POOL
-	skb->pp_recycle = 1;
-#endif
 }
 
 ssize_t skb_splice_from_iter(struct sk_buff *skb, struct iov_iter *iter,
diff --git a/include/linux/skbuff_ref.h b/include/linux/skbuff_ref.h
index e94c599ce83d2..b368eb4661ed7 100644
--- a/include/linux/skbuff_ref.h
+++ b/include/linux/skbuff_ref.h
@@ -9,63 +9,21 @@
 
 #include <linux/skbuff.h>
 
-bool napi_pp_get_page(netmem_ref netmem);
-
-/**
- * skb_netmem_ref - acquire a fragment reference on a netmem
- * @netmem: netmem to reference
- * @recycle: whether page_pool recycling is enabled (e.g. skb->pp_recycle)
- *
- * Acquires pp_ref_count via napi_pp_get_page() if @recycle is true and
- * @netmem belongs to a page_pool; otherwise acquires a non-pp backing
- * reference via netmem_inc_ref(). Counterpart to skb_netmem_unref().
- */
-static __always_inline void skb_netmem_ref(netmem_ref netmem, bool recycle)
-{
-#ifdef CONFIG_PAGE_POOL
-	if (recycle && napi_pp_get_page(netmem))
-		return;
-#endif
-	netmem_inc_ref(netmem);
-}
-
 /**
  * skb_frag_ref - acquire a reference on a paged fragment of an skb
  * @skb: the buffer
  * @f: the fragment offset
  *
- * Acquires a reference on the @f'th fragment of @skb via skb_netmem_ref()
- * (pp_ref_count if skb->pp_recycle and page_pool-backed, else non-pp
- * backing refcount), skipping managed zerocopy fragments. Counterpart to
- * skb_frag_unref().
+ * Acquires a reference on the @f'th fragment of @skb via netmem_inc_ref()
+ * (pp_ref_count if page_pool-backed, else non-pp backing refcount), skipping
+ * managed zerocopy fragments. Counterpart to skb_frag_unref().
  */
 static __always_inline void skb_frag_ref(struct sk_buff *skb, int f)
 {
 	struct skb_shared_info *shinfo = skb_shinfo(skb);
 
 	if (!skb_zcopy_managed(skb))
-		skb_netmem_ref(skb_frag_netmem(&shinfo->frags[f]),
-			       skb->pp_recycle);
-}
-
-bool napi_pp_put_page(netmem_ref netmem);
-
-/**
- * skb_netmem_unref - release a fragment reference on a netmem
- * @netmem: netmem to unreference
- * @recycle: whether page_pool recycling is enabled (e.g. skb->pp_recycle)
- *
- * Drops pp_ref_count via napi_pp_put_page() if @recycle is true and @netmem
- * belongs to a page_pool; otherwise drops a non-pp backing reference via
- * netmem_dec_ref(). Counterpart to skb_netmem_ref().
- */
-static __always_inline void skb_netmem_unref(netmem_ref netmem, bool recycle)
-{
-#ifdef CONFIG_PAGE_POOL
-	if (recycle && napi_pp_put_page(netmem))
-		return;
-#endif
-	netmem_dec_ref(netmem);
+		netmem_inc_ref(skb_frag_netmem(&shinfo->frags[f]));
 }
 
 /**
@@ -73,18 +31,16 @@ static __always_inline void skb_netmem_unref(netmem_ref netmem, bool recycle)
  * @skb: the buffer
  * @f: the fragment offset
  *
- * Drops a reference on the @f'th fragment of @skb via skb_netmem_unref()
- * (pp_ref_count if skb->pp_recycle and page_pool-backed, else non-pp
- * backing refcount), skipping managed zerocopy fragments. Counterpart to
- * skb_frag_ref().
+ * Drops a reference on the @f'th fragment of @skb via netmem_dec_ref()
+ * (pp_ref_count if page_pool-backed, else non-pp backing refcount), skipping
+ * managed zerocopy fragments. Counterpart to skb_frag_ref().
  */
 static __always_inline void skb_frag_unref(struct sk_buff *skb, int f)
 {
 	struct skb_shared_info *shinfo = skb_shinfo(skb);
 
 	if (!skb_zcopy_managed(skb))
-		skb_netmem_unref(skb_frag_netmem(&shinfo->frags[f]),
-				 skb->pp_recycle);
+		netmem_dec_ref(skb_frag_netmem(&shinfo->frags[f]));
 }
 
 #endif	/* _LINUX_SKBUFF_REF_H */
diff --git a/include/net/netmem.h b/include/net/netmem.h
index fb693bc1702a4..d8ecf0ec34005 100644
--- a/include/net/netmem.h
+++ b/include/net/netmem.h
@@ -298,7 +298,7 @@ static inline struct page_pool *__netmem_get_pp(netmem_ref netmem)
 
 static inline struct page_pool *netmem_get_pp(netmem_ref netmem)
 {
-	return netmem_to_nmdesc(netmem)->pp;
+	return READ_ONCE(netmem_to_nmdesc(netmem)->pp);
 }
 
 static inline atomic_long_t *netmem_get_pp_ref_count_ref(netmem_ref netmem)
@@ -412,16 +412,34 @@ static inline bool net_is_devmem_iov(const struct net_iov *niov)
 void net_iov_inc_ref(struct net_iov *niov);
 void net_iov_dec_ref(struct net_iov *niov);
 
+#if IS_ENABLED(CONFIG_PAGE_POOL)
+bool napi_pp_get_page(netmem_ref netmem);
+bool napi_pp_put_page(netmem_ref netmem);
+#else
+static inline bool napi_pp_get_page(netmem_ref netmem)
+{
+	return false;
+}
+
+static inline bool napi_pp_put_page(netmem_ref netmem)
+{
+	return false;
+}
+#endif
+
 /**
- * netmem_inc_ref - acquire a non-page_pool reference on a netmem
+ * netmem_inc_ref - acquire a reference on a netmem
  * @netmem: netmem to reference
  *
- * Acquires a non-pp backing reference (page._refcount via get_page() or
- * binding->ref via net_iov_inc_ref()) regardless of page_pool membership.
- * Counterpart to netmem_dec_ref().
+ * Acquires pp_ref_count via napi_pp_get_page() if @netmem belongs to a
+ * page_pool; otherwise acquires a non-pp backing reference (binding->ref via
+ * net_iov_inc_ref() or page._refcount via get_page()). Counterpart to
+ * netmem_dec_ref().
  */
 static __always_inline void netmem_inc_ref(netmem_ref netmem)
 {
+	if (napi_pp_get_page(netmem))
+		return;
 	if (netmem_is_net_iov(netmem))
 		net_iov_inc_ref(netmem_to_net_iov(netmem));
 	else
@@ -429,15 +447,18 @@ static __always_inline void netmem_inc_ref(netmem_ref netmem)
 }
 
 /**
- * netmem_dec_ref - release a non-page_pool reference on a netmem
+ * netmem_dec_ref - release a reference on a netmem
  * @netmem: netmem to unreference
  *
- * Drops a non-pp backing reference (page._refcount via put_page() or
- * binding->ref via net_iov_dec_ref()) regardless of page_pool membership.
- * Counterpart to netmem_inc_ref().
+ * Drops pp_ref_count via napi_pp_put_page() if @netmem belongs to a
+ * page_pool; otherwise drops a non-pp backing reference (binding->ref via
+ * net_iov_dec_ref() or page._refcount via put_page()). Counterpart to
+ * netmem_inc_ref().
  */
 static __always_inline void netmem_dec_ref(netmem_ref netmem)
 {
+	if (napi_pp_put_page(netmem))
+		return;
 	if (netmem_is_net_iov(netmem))
 		net_iov_dec_ref(netmem_to_net_iov(netmem));
 	else
diff --git a/include/net/page_pool/helpers.h b/include/net/page_pool/helpers.h
index 28635ce9454e8..af3cb65c30416 100644
--- a/include/net/page_pool/helpers.h
+++ b/include/net/page_pool/helpers.h
@@ -242,6 +242,11 @@ page_pool_get_dma_dir(const struct page_pool *pool)
 	return pool->p.dma_dir;
 }
 
+static inline long page_pool_ref_count(netmem_ref netmem)
+{
+	return atomic_long_read(netmem_get_pp_ref_count_ref(netmem));
+}
+
 static inline void page_pool_fragment_netmem(netmem_ref netmem, long nr)
 {
 	atomic_long_set(netmem_get_pp_ref_count_ref(netmem), nr);
@@ -270,13 +275,22 @@ static inline void page_pool_fragment_page(struct page *page, long nr)
 	page_pool_fragment_netmem(page_to_netmem(page), nr);
 }
 
+static inline bool page_pool_netmem_is_exclusively_owned(netmem_ref netmem)
+{
+	if (netmem_is_net_iov(netmem))
+		return true;
+
+	return page_ref_count(__netmem_to_page(netmem)) == 1;
+}
+
 static inline long page_pool_unref_netmem(netmem_ref netmem, long nr)
 {
 	atomic_long_t *pp_ref_count = netmem_get_pp_ref_count_ref(netmem);
 	long ret;
 
-	/* If nr == pp_ref_count then we have cleared all remaining
-	 * references to the page:
+	/* If nr == pp_ref_count and the page_pool holds the sole page
+	 * reference, then we have cleared all remaining references to the
+	 * page:
 	 * 1. 'n == 1': no need to actually overwrite it.
 	 * 2. 'n != 1': overwrite it with one, which is the rare case
 	 *              for pp_ref_count draining.
@@ -288,8 +302,15 @@ static inline long page_pool_unref_netmem(netmem_ref netmem, long nr)
 	 * handling by ensuring all pages have partitioned into only 1 piece
 	 * initially, and only overwrite it when the page is partitioned into
 	 * more than one piece.
+	 *
+	 * If an external page reference exists (page_ref_count > 1), a
+	 * concurrent napi_pp_get_page() caller holding only a page reference
+	 * may attempt atomic_long_inc_not_zero(pp_ref_count), so we must
+	 * perform an atomic RMW subtraction to 0 and leave pp_ref_count at 0
+	 * while the page is released from the pool.
 	 */
-	if (atomic_long_read(pp_ref_count) == nr) {
+	if (atomic_long_read(pp_ref_count) == nr &&
+	    likely(page_pool_netmem_is_exclusively_owned(netmem))) {
 		/* As we have ensured nr is always one for constant case using
 		 * the BUILD_BUG_ON(), only need to handle the non-constant case
 		 * here for pp_ref_count draining, which is a rare case.
@@ -304,12 +325,16 @@ static inline long page_pool_unref_netmem(netmem_ref netmem, long nr)
 	ret = atomic_long_sub_return(nr, pp_ref_count);
 	WARN_ON(ret < 0);
 
-	/* We are the last user here too, reset pp_ref_count back to 1 to
-	 * ensure all pages have been partitioned into 1 piece initially,
-	 * this should be the rare case when the last two fragment users call
-	 * page_pool_unref_page() currently.
+	/* We are the last user here too. If the page_pool holds the sole
+	 * page reference, reset pp_ref_count back to 1 to ensure all pages
+	 * have been partitioned into 1 piece initially; otherwise leave
+	 * pp_ref_count at 0 so concurrent napi_pp_get_page() callers fail
+	 * atomic_long_inc_not_zero() while page_pool_return_netmem() releases
+	 * the page (__page_pool_put_page() restores pp_ref_count to 1 if the
+	 * external page reference is dropped before recycling).
 	 */
-	if (unlikely(!ret))
+	if (unlikely(!ret) &&
+	    likely(page_pool_netmem_is_exclusively_owned(netmem)))
 		atomic_long_set(pp_ref_count, 1);
 
 	return ret;
diff --git a/net/core/gro.c b/net/core/gro.c
index 1b033855a20db..124079f3eb9b0 100644
--- a/net/core/gro.c
+++ b/net/core/gro.c
@@ -100,15 +100,6 @@ int skb_gro_receive(struct sk_buff *p, struct sk_buff *skb)
 	struct sk_buff *lp;
 	int segs;
 
-	/* Do not splice page pool based packets w/ non-page pool
-	 * packets. This can result in reference count issues as page
-	 * pool pages will not decrement the reference count and will
-	 * instead be immediately returned to the pool or have frag
-	 * count decremented.
-	 */
-	if (p->pp_recycle != skb->pp_recycle)
-		return -ETOOMANYREFS;
-
 	if (skb_zcopy(p) || skb_zcopy(skb))
 		return -ETOOMANYREFS;
 
diff --git a/net/core/net_test.c b/net/core/net_test.c
index 73da75e6ca2c8..c7fef3fa12647 100644
--- a/net/core/net_test.c
+++ b/net/core/net_test.c
@@ -551,23 +551,11 @@ static void netmem_ref_test_page(struct kunit *test)
 	KUNIT_EXPECT_EQ(test, page_ref_count(page), base_ref);
 #endif
 
-	/* Layer 3: skb_netmem_ref / unref fall back to non-pp on non-PP page */
-	skb_netmem_ref(netmem, false);
-	KUNIT_EXPECT_EQ(test, page_ref_count(page), base_ref + 1);
-	skb_netmem_unref(netmem, false);
-	KUNIT_EXPECT_EQ(test, page_ref_count(page), base_ref);
-
-	skb_netmem_ref(netmem, true);
-	KUNIT_EXPECT_EQ(test, page_ref_count(page), base_ref + 1);
-	skb_netmem_unref(netmem, true);
-	KUNIT_EXPECT_EQ(test, page_ref_count(page), base_ref);
-
-	/* Layer 4: skb_frag_ref / skb_frag_unref on non-PP page */
+	/* Layer 3: skb_frag_ref / skb_frag_unref on non-PP page */
 	skb = alloc_skb(64, GFP_KERNEL);
 	KUNIT_ASSERT_NOT_NULL(test, skb);
 	skb_fill_netmem_desc(skb, 0, netmem, 0, 64);
 
-	skb->pp_recycle = 1;
 	skb_frag_ref(skb, 0);
 	KUNIT_EXPECT_EQ(test, page_ref_count(page), base_ref + 1);
 	skb_frag_unref(skb, 0);
@@ -612,47 +600,31 @@ static void netmem_ref_test_pp_page(struct kunit *test)
 	base_ref = page_ref_count(page);
 	base_pp_ref = atomic_long_read(&page->pp_ref_count);
 
-	/* Layer 1: netmem_inc/dec_ref always use non-pp refcount */
+	/* Layer 1: netmem_inc/dec_ref use pp_ref_count on PP page */
 	netmem_inc_ref(netmem);
-	KUNIT_EXPECT_EQ(test, page_ref_count(page), base_ref + 1);
-	KUNIT_EXPECT_EQ(test, atomic_long_read(&page->pp_ref_count),
-			base_pp_ref);
-	netmem_dec_ref(netmem);
-	KUNIT_EXPECT_EQ(test, page_ref_count(page), base_ref);
-
-	/* Layer 2: napi_pp_get/put_page use pp_ref_count */
-	KUNIT_EXPECT_TRUE(test, napi_pp_get_page(netmem));
 	KUNIT_EXPECT_EQ(test, atomic_long_read(&page->pp_ref_count),
 			base_pp_ref + 1);
 	KUNIT_EXPECT_EQ(test, page_ref_count(page), base_ref);
-	KUNIT_EXPECT_TRUE(test, napi_pp_put_page(netmem));
-	KUNIT_EXPECT_EQ(test, atomic_long_read(&page->pp_ref_count),
-			base_pp_ref);
-
-	/* Layer 3: skb_netmem_ref / unref obey recycle flag */
-	skb_netmem_ref(netmem, false);
-	KUNIT_EXPECT_EQ(test, page_ref_count(page), base_ref + 1);
+	netmem_dec_ref(netmem);
 	KUNIT_EXPECT_EQ(test, atomic_long_read(&page->pp_ref_count),
 			base_pp_ref);
-	skb_netmem_unref(netmem, false);
-	KUNIT_EXPECT_EQ(test, page_ref_count(page), base_ref);
 
-	skb_netmem_ref(netmem, true);
+	/* Layer 2: napi_pp_get/put_page use pp_ref_count */
+	KUNIT_EXPECT_TRUE(test, napi_pp_get_page(netmem));
 	KUNIT_EXPECT_EQ(test, atomic_long_read(&page->pp_ref_count),
 			base_pp_ref + 1);
 	KUNIT_EXPECT_EQ(test, page_ref_count(page), base_ref);
-	skb_netmem_unref(netmem, true);
+	KUNIT_EXPECT_TRUE(test, napi_pp_put_page(netmem));
 	KUNIT_EXPECT_EQ(test, atomic_long_read(&page->pp_ref_count),
 			base_pp_ref);
 
-	/* Layer 4: skb_frag_ref / skb_frag_unref match on pp_recycle=1 & 0 */
+	/* Layer 3: skb_frag_ref / skb_frag_unref use pp_ref_count on PP page */
 	skb = alloc_skb(64, GFP_KERNEL);
 	KUNIT_ASSERT_NOT_NULL(test, skb);
 	skb_fill_netmem_desc(skb, 0, netmem, 0, 64);
 	skb->len = 64;
 	skb->data_len = 64;
 
-	skb->pp_recycle = 1;
 	skb_frag_ref(skb, 0);
 	KUNIT_EXPECT_EQ(test, atomic_long_read(&page->pp_ref_count),
 			base_pp_ref + 1);
@@ -661,10 +633,9 @@ static void netmem_ref_test_pp_page(struct kunit *test)
 	KUNIT_EXPECT_EQ(test, atomic_long_read(&page->pp_ref_count),
 			base_pp_ref);
 
-	/* pskb_copy on pp_recycle=1 skb propagates pp_recycle & pp_ref_count */
+	/* pskb_copy on PP page skb propagates pp_ref_count */
 	copy = pskb_copy(skb, GFP_KERNEL);
 	KUNIT_ASSERT_NOT_NULL(test, copy);
-	KUNIT_EXPECT_TRUE(test, copy->pp_recycle);
 	KUNIT_EXPECT_EQ(test, atomic_long_read(&page->pp_ref_count),
 			base_pp_ref + 1);
 	KUNIT_EXPECT_EQ(test, page_ref_count(page), base_ref);
@@ -673,14 +644,13 @@ static void netmem_ref_test_pp_page(struct kunit *test)
 	KUNIT_EXPECT_EQ(test, atomic_long_read(&page->pp_ref_count),
 			base_pp_ref);
 
-	/* skb_zerocopy on pp_recycle=1 skb propagates pp_ref_count */
+	/* skb_zerocopy on PP page skb propagates pp_ref_count */
 	copy = alloc_skb(0, GFP_KERNEL);
 	KUNIT_ASSERT_NOT_NULL(test, copy);
 	skb_put(copy, skb_tailroom(copy));
 	skb->head_frag = 1;
 	KUNIT_ASSERT_EQ(test, skb_zerocopy(copy, skb, skb->len, 0), 0);
 	skb->head_frag = 0;
-	KUNIT_EXPECT_TRUE(test, copy->pp_recycle);
 	KUNIT_EXPECT_EQ(test, atomic_long_read(&page->pp_ref_count),
 			base_pp_ref + 1);
 	KUNIT_EXPECT_EQ(test, page_ref_count(page), base_ref);
@@ -689,11 +659,10 @@ static void netmem_ref_test_pp_page(struct kunit *test)
 	KUNIT_EXPECT_EQ(test, atomic_long_read(&page->pp_ref_count),
 			base_pp_ref);
 
-	/* skb_clone + pskb_expand_head preserves pp_recycle and pp_ref_count */
+	/* skb_clone + pskb_expand_head preserves pp_ref_count */
 	clone = skb_clone(skb, GFP_KERNEL);
 	KUNIT_ASSERT_NOT_NULL(test, clone);
 	KUNIT_ASSERT_EQ(test, pskb_expand_head(clone, 32, 0, GFP_KERNEL), 0);
-	KUNIT_EXPECT_TRUE(test, clone->pp_recycle);
 	KUNIT_EXPECT_EQ(test, atomic_long_read(&page->pp_ref_count),
 			base_pp_ref + 1);
 	KUNIT_EXPECT_EQ(test, page_ref_count(page), base_ref);
@@ -714,7 +683,6 @@ static void netmem_ref_test_pp_page(struct kunit *test)
 	split = alloc_skb(32, GFP_KERNEL);
 	KUNIT_ASSERT_NOT_NULL(test, split);
 	skb_split(skb, split, 16);
-	KUNIT_EXPECT_TRUE(test, split->pp_recycle);
 	KUNIT_EXPECT_EQ(test, atomic_long_read(&page->pp_ref_count),
 			base_pp_ref);
 	KUNIT_EXPECT_EQ(test, page_ref_count(page), base_ref);
@@ -730,7 +698,6 @@ static void netmem_ref_test_pp_page(struct kunit *test)
 	split = alloc_skb(0, GFP_KERNEL);
 	KUNIT_ASSERT_NOT_NULL(test, split);
 	skb_split(skb, split, 32);
-	KUNIT_EXPECT_TRUE(test, split->pp_recycle);
 	KUNIT_EXPECT_EQ(test, atomic_long_read(&page->pp_ref_count),
 			base_pp_ref + 1);
 	KUNIT_EXPECT_EQ(test, page_ref_count(page), base_ref);
@@ -739,14 +706,13 @@ static void netmem_ref_test_pp_page(struct kunit *test)
 	KUNIT_EXPECT_EQ(test, atomic_long_read(&page->pp_ref_count),
 			base_pp_ref);
 
-	/* skb_segment on pp_recycle=1 skb propagates pp_recycle to segments */
+	/* skb_segment on PP page skb propagates pp_ref_count to segments */
 	skb->protocol = htons(ETH_P_IP);
 	skb_reset_mac_header(skb);
 	skb_reset_network_header(skb);
 	skb_shinfo(skb)->gso_size = 16;
 	split = skb_segment(skb, NETIF_F_SG | NETIF_F_HW_CSUM);
 	KUNIT_ASSERT_FALSE(test, IS_ERR_OR_NULL(split));
-	KUNIT_EXPECT_TRUE(test, split->pp_recycle);
 	KUNIT_EXPECT_EQ(test, atomic_long_read(&page->pp_ref_count),
 			base_pp_ref + 2);
 	KUNIT_EXPECT_EQ(test, page_ref_count(page), base_ref);
@@ -765,7 +731,6 @@ static void netmem_ref_test_pp_page(struct kunit *test)
 	skb->data_len = 64;
 	split = alloc_skb(0, GFP_KERNEL);
 	KUNIT_ASSERT_NOT_NULL(test, split);
-	split->pp_recycle = 1;
 	KUNIT_EXPECT_EQ(test, skb_shift(split, skb, 16), 16);
 	KUNIT_EXPECT_EQ(test, atomic_long_read(&page->pp_ref_count),
 			base_pp_ref + 2);
@@ -782,17 +747,6 @@ static void netmem_ref_test_pp_page(struct kunit *test)
 	skb_shinfo(split)->nr_frags = 0;
 	consume_skb(split);
 	page_pool_put_full_page(pool, page, false);
-	skb_fill_netmem_desc(skb, 0, netmem, 0, 64);
-	skb->len = 64;
-	skb->data_len = 64;
-
-	skb->pp_recycle = 0;
-	skb_frag_ref(skb, 0);
-	KUNIT_EXPECT_EQ(test, page_ref_count(page), base_ref + 1);
-	KUNIT_EXPECT_EQ(test, atomic_long_read(&page->pp_ref_count),
-			base_pp_ref);
-	skb_frag_unref(skb, 0);
-	KUNIT_EXPECT_EQ(test, page_ref_count(page), base_ref);
 
 	skb_shinfo(skb)->nr_frags = 0;
 	consume_skb(skb);
@@ -800,7 +754,7 @@ static void netmem_ref_test_pp_page(struct kunit *test)
 	page_pool_destroy(pool);
 
 	/* Order-1 compound page_pool page: tail netmem resolves to head &
-	 * build_skb(head_frag=1, pp_recycle=1) skb_zerocopy uses pp_ref_count.
+	 * build_skb(head_frag=1) skb_zerocopy uses pp_ref_count.
 	 */
 	pp_params.order = 1;
 	pool = page_pool_create(&pp_params);
@@ -821,7 +775,6 @@ static void netmem_ref_test_pp_page(struct kunit *test)
 
 	skb = build_skb(page_address(page), PAGE_SIZE);
 	KUNIT_ASSERT_NOT_NULL(test, skb);
-	skb->pp_recycle = 1;
 	skb_put(skb, 64);
 	page_pool_ref_page(page);
 
@@ -829,7 +782,6 @@ static void netmem_ref_test_pp_page(struct kunit *test)
 	KUNIT_ASSERT_NOT_NULL(test, copy);
 	skb_put(copy, skb_tailroom(copy));
 	KUNIT_ASSERT_EQ(test, skb_zerocopy(copy, skb, skb->len, 0), 0);
-	KUNIT_EXPECT_TRUE(test, copy->pp_recycle);
 	KUNIT_EXPECT_EQ(test, atomic_long_read(&page->pp_ref_count),
 			base_pp_ref + 2);
 	KUNIT_EXPECT_EQ(test, page_ref_count(page), base_ref);
@@ -844,9 +796,6 @@ static void netmem_ref_test_pp_page(struct kunit *test)
 	page_pool_destroy(pool);
 }
 
-int zerocopy_fill_skb_from_iter(struct sk_buff *skb,
-				struct iov_iter *from, size_t length);
-
 static void netmem_ref_test_zerocopy_fill_skb_from_iter(struct kunit *test)
 {
 	struct page_pool_params pp_params = {
@@ -871,7 +820,9 @@ static void netmem_ref_test_zerocopy_fill_skb_from_iter(struct kunit *test)
 	base_pp_ref = atomic_long_read(&pp_page->pp_ref_count);
 
 	/* 1. Single order-0 page_pool page (simulating TCP_ZEROCOPY_RECEIVE
-	 * page forwarded into MSG_ZEROCOPY TX via zerocopy_fill_skb_from_iter).
+	 * page forwarded into MSG_ZEROCOPY TX via zerocopy_fill_skb_from_iter):
+	 * GUP _refcount from iov_iter_get_pages2() is converted to pp_ref_count
+	 * and released via netmem_dec_ref() on consume_skb().
 	 */
 	skb = alloc_skb(0, GFP_KERNEL);
 	KUNIT_ASSERT_NOT_NULL(test, skb);
@@ -880,16 +831,17 @@ static void netmem_ref_test_zerocopy_fill_skb_from_iter(struct kunit *test)
 	KUNIT_ASSERT_EQ(test, zerocopy_fill_skb_from_iter(skb, &iter, 128), 0);
 	KUNIT_EXPECT_EQ(test, skb_shinfo(skb)->nr_frags, 1);
 	KUNIT_EXPECT_EQ(test, atomic_long_read(&pp_page->pp_ref_count),
-			base_pp_ref);
-	KUNIT_EXPECT_EQ(test, page_ref_count(pp_page), base_ref + 1);
+			base_pp_ref + 1);
+	KUNIT_EXPECT_EQ(test, page_ref_count(pp_page), base_ref);
 	consume_skb(skb);
 	KUNIT_EXPECT_EQ(test, atomic_long_read(&pp_page->pp_ref_count),
 			base_pp_ref);
 	KUNIT_EXPECT_EQ(test, page_ref_count(pp_page), base_ref);
 
 	/* 2. Contiguous segments on the same page_pool page coalesce into a
-	 * single skb_frag_t while a non-contiguous segment creates a second
-	 * skb_frag_t; all 3 GUP _refcounts are dropped.
+	 * single skb_frag_t (1 pp_ref_count) while a non-contiguous segment
+	 * creates a second skb_frag_t (+1 pp_ref_count); all 3 GUP _refcounts
+	 * are dropped.
 	 */
 	skb = alloc_skb(0, GFP_KERNEL);
 	KUNIT_ASSERT_NOT_NULL(test, skb);
@@ -902,17 +854,17 @@ static void netmem_ref_test_zerocopy_fill_skb_from_iter(struct kunit *test)
 	KUNIT_EXPECT_EQ(test, skb_frag_size(&skb_shinfo(skb)->frags[0]), 128U);
 	KUNIT_EXPECT_EQ(test, skb_frag_size(&skb_shinfo(skb)->frags[1]), 64U);
 	KUNIT_EXPECT_EQ(test, atomic_long_read(&pp_page->pp_ref_count),
-			base_pp_ref);
-	KUNIT_EXPECT_EQ(test, page_ref_count(pp_page), base_ref + 2);
+			base_pp_ref + 2);
+	KUNIT_EXPECT_EQ(test, page_ref_count(pp_page), base_ref);
 	consume_skb(skb);
 	KUNIT_EXPECT_EQ(test, atomic_long_read(&pp_page->pp_ref_count),
 			base_pp_ref);
 	KUNIT_EXPECT_EQ(test, page_ref_count(pp_page), base_ref);
 
 	/* 3. Order-1 compound page_pool page spanning 2 subpages in a single
-	 * iov_iter_get_pages2() batch coalesces into 1 skb_frag_t and drops
-	 * both GUP _refcounts via batched page_ref_sub, alongside a
-	 * non-page_pool page in the same skb.
+	 * iov_iter_get_pages2() batch coalesces into 1 skb_frag_t with 1
+	 * pp_ref_count and drops both GUP _refcounts via batched page_ref_sub,
+	 * alongside a non-page_pool page in the same skb.
 	 */
 	pp_params.order = 1;
 	comp_pool = page_pool_create(&pp_params);
@@ -938,8 +890,8 @@ static void netmem_ref_test_zerocopy_fill_skb_from_iter(struct kunit *test)
 	KUNIT_EXPECT_EQ(test, skb_frag_size(&skb_shinfo(skb)->frags[0]),
 			(unsigned int)(2 * PAGE_SIZE));
 	KUNIT_EXPECT_EQ(test, atomic_long_read(&comp_page->pp_ref_count),
-			base_comp_pp_ref);
-	KUNIT_EXPECT_EQ(test, page_ref_count(comp_page), base_comp_ref + 1);
+			base_comp_pp_ref + 1);
+	KUNIT_EXPECT_EQ(test, page_ref_count(comp_page), base_comp_ref);
 	KUNIT_EXPECT_EQ(test, page_ref_count(reg_page), base_reg_ref + 1);
 	consume_skb(skb);
 	KUNIT_EXPECT_EQ(test, atomic_long_read(&comp_page->pp_ref_count),
@@ -965,12 +917,12 @@ static void netmem_ref_test_zerocopy_fill_skb_from_iter(struct kunit *test)
 						    3 * PAGE_SIZE + 64), 0);
 	KUNIT_EXPECT_EQ(test, skb_shinfo(skb)->nr_frags, 3);
 	KUNIT_EXPECT_EQ(test, atomic_long_read(&comp_page->pp_ref_count),
-			base_comp_pp_ref);
-	KUNIT_EXPECT_EQ(test, page_ref_count(comp_page), base_comp_ref + 1);
+			base_comp_pp_ref + 1);
+	KUNIT_EXPECT_EQ(test, page_ref_count(comp_page), base_comp_ref);
 	KUNIT_EXPECT_EQ(test, page_ref_count(reg_page), base_reg_ref + 1);
 	KUNIT_EXPECT_EQ(test, atomic_long_read(&pp_page->pp_ref_count),
-			base_pp_ref);
-	KUNIT_EXPECT_EQ(test, page_ref_count(pp_page), base_ref + 1);
+			base_pp_ref + 1);
+	KUNIT_EXPECT_EQ(test, page_ref_count(pp_page), base_ref);
 	consume_skb(skb);
 	KUNIT_EXPECT_EQ(test, atomic_long_read(&comp_page->pp_ref_count),
 			base_comp_pp_ref);
@@ -980,6 +932,29 @@ static void netmem_ref_test_zerocopy_fill_skb_from_iter(struct kunit *test)
 			base_pp_ref);
 	KUNIT_EXPECT_EQ(test, page_ref_count(pp_page), base_ref);
 
+	/* 5. Concurrent final pp_ref_count unref race window: when a user VMA
+	 * or GUP pin holds an external page_ref_count (> 1) and the last
+	 * page_pool holder drops pp_ref_count via page_pool_unref_page(),
+	 * pp_ref_count transitions to 0. Even before page_pool_return_netmem()
+	 * clears pp_magic, zerocopy_fill_skb_from_iter() and consume_skb()
+	 * must fall back to page_ref_count without touching pp_ref_count.
+	 */
+	get_page(pp_page);
+	KUNIT_EXPECT_EQ(test, page_pool_unref_page(pp_page, 1), 0L);
+	KUNIT_EXPECT_EQ(test, atomic_long_read(&pp_page->pp_ref_count), 0L);
+	skb = alloc_skb(0, GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, skb);
+	bvec_set_page(&bvec[0], pp_page, 128, 0);
+	iov_iter_bvec(&iter, ITER_SOURCE, bvec, 1, 128);
+	KUNIT_ASSERT_EQ(test, zerocopy_fill_skb_from_iter(skb, &iter, 128), 0);
+	KUNIT_EXPECT_EQ(test, atomic_long_read(&pp_page->pp_ref_count), 0L);
+	KUNIT_EXPECT_EQ(test, page_ref_count(pp_page), base_ref + 2);
+	consume_skb(skb);
+	KUNIT_EXPECT_EQ(test, atomic_long_read(&pp_page->pp_ref_count), 0L);
+	KUNIT_EXPECT_EQ(test, page_ref_count(pp_page), base_ref + 1);
+	put_page(pp_page);
+	atomic_long_set(&pp_page->pp_ref_count, base_pp_ref);
+
 	__free_page(reg_page);
 	page_pool_put_full_page(comp_pool, comp_page, false);
 	page_pool_destroy(comp_pool);
@@ -1027,10 +1002,10 @@ static void netmem_ref_test_net_iov(struct kunit *test)
 	KUNIT_EXPECT_FALSE(test, napi_pp_get_page(netmem));
 	KUNIT_EXPECT_FALSE(test, napi_pp_put_page(netmem));
 
-	skb_netmem_ref(netmem, true);
+	netmem_inc_ref(netmem);
 	KUNIT_EXPECT_EQ(test, atomic_long_read(&binding.ref.data->count),
 			base_ref + 1);
-	skb_netmem_unref(netmem, true);
+	netmem_dec_ref(netmem);
 	KUNIT_EXPECT_EQ(test, atomic_long_read(&binding.ref.data->count),
 			base_ref);
 
@@ -1041,7 +1016,7 @@ static void netmem_ref_test_net_iov(struct kunit *test)
 	netmem_or_pp_magic(netmem, PP_SIGNATURE);
 	atomic_long_set(&niov.desc.pp_ref_count, 2);
 
-	/* Layer 0 & 1: net_iov/netmem_inc_ref grab non-pp ref on PP */
+	/* Layer 0 & 1: net_iov_inc_ref uses binding.ref, netmem_inc_ref pp */
 	net_iov_inc_ref(&niov);
 	KUNIT_EXPECT_EQ(test, atomic_long_read(&binding.ref.data->count),
 			base_ref + 1);
@@ -1050,6 +1025,13 @@ static void netmem_ref_test_net_iov(struct kunit *test)
 	KUNIT_EXPECT_EQ(test, atomic_long_read(&binding.ref.data->count),
 			base_ref);
 
+	netmem_inc_ref(netmem);
+	KUNIT_EXPECT_EQ(test, atomic_long_read(&niov.desc.pp_ref_count), 3L);
+	KUNIT_EXPECT_EQ(test, atomic_long_read(&binding.ref.data->count),
+			base_ref);
+	netmem_dec_ref(netmem);
+	KUNIT_EXPECT_EQ(test, atomic_long_read(&niov.desc.pp_ref_count), 2L);
+
 	/* Layer 2: napi_pp_get/put_page use pp_ref_count */
 	KUNIT_EXPECT_TRUE(test, napi_pp_get_page(netmem));
 	KUNIT_EXPECT_EQ(test, atomic_long_read(&niov.desc.pp_ref_count), 3L);
@@ -1058,14 +1040,13 @@ static void netmem_ref_test_net_iov(struct kunit *test)
 	KUNIT_EXPECT_TRUE(test, napi_pp_put_page(netmem));
 	KUNIT_EXPECT_EQ(test, atomic_long_read(&niov.desc.pp_ref_count), 2L);
 
-	/* Layer 4: skb_frag_ref / skb_frag_unref on PP net_iov */
+	/* Layer 3: skb_frag_ref / skb_frag_unref on PP net_iov */
 	skb = alloc_skb(64, GFP_KERNEL);
 	KUNIT_ASSERT_NOT_NULL(test, skb);
 	skb_fill_netmem_desc(skb, 0, netmem, 0, 64);
 	skb->len = 64;
 	skb->data_len = 64;
 
-	skb->pp_recycle = 1;
 	skb_frag_ref(skb, 0);
 	KUNIT_EXPECT_EQ(test, atomic_long_read(&niov.desc.pp_ref_count), 3L);
 	KUNIT_EXPECT_EQ(test, atomic_long_read(&binding.ref.data->count),
@@ -1073,17 +1054,16 @@ static void netmem_ref_test_net_iov(struct kunit *test)
 	skb_frag_unref(skb, 0);
 	KUNIT_EXPECT_EQ(test, atomic_long_read(&niov.desc.pp_ref_count), 2L);
 
-	/* pskb_copy on pp_recycle=1 net_iov skb keeps pp_ref_count */
+	/* pskb_copy on PP net_iov skb keeps pp_ref_count */
 	copy = pskb_copy(skb, GFP_KERNEL);
 	KUNIT_ASSERT_NOT_NULL(test, copy);
-	KUNIT_EXPECT_TRUE(test, copy->pp_recycle);
 	KUNIT_EXPECT_EQ(test, atomic_long_read(&niov.desc.pp_ref_count), 3L);
 	KUNIT_EXPECT_EQ(test, atomic_long_read(&binding.ref.data->count),
 			base_ref);
 	consume_skb(copy);
 	KUNIT_EXPECT_EQ(test, atomic_long_read(&niov.desc.pp_ref_count), 2L);
 
-	/* skb_zerocopy on pp_recycle=1 net_iov skb keeps pp_ref_count */
+	/* skb_zerocopy on PP net_iov skb keeps pp_ref_count */
 	copy = alloc_skb(0, GFP_KERNEL);
 	KUNIT_ASSERT_NOT_NULL(test, copy);
 	skb_put(copy, skb_tailroom(copy));
@@ -1091,7 +1071,6 @@ static void netmem_ref_test_net_iov(struct kunit *test)
 	skb->unreadable = 1;
 	KUNIT_ASSERT_EQ(test, skb_zerocopy(copy, skb, skb->len, 0), 0);
 	skb->head_frag = 0;
-	KUNIT_EXPECT_TRUE(test, copy->pp_recycle);
 	KUNIT_EXPECT_EQ(test, atomic_long_read(&niov.desc.pp_ref_count), 3L);
 	KUNIT_EXPECT_EQ(test, atomic_long_read(&binding.ref.data->count),
 			base_ref);
@@ -1101,7 +1080,6 @@ static void netmem_ref_test_net_iov(struct kunit *test)
 	/* skb_shift balances pp_ref_count on split and merge */
 	copy = alloc_skb(0, GFP_KERNEL);
 	KUNIT_ASSERT_NOT_NULL(test, copy);
-	copy->pp_recycle = 1;
 	KUNIT_EXPECT_EQ(test, skb_shift(copy, skb, 16), 16);
 	KUNIT_EXPECT_EQ(test, atomic_long_read(&niov.desc.pp_ref_count), 3L);
 	KUNIT_EXPECT_EQ(test, atomic_long_read(&binding.ref.data->count),
@@ -1114,26 +1092,16 @@ static void netmem_ref_test_net_iov(struct kunit *test)
 	skb->len = 64;
 	skb->data_len = 64;
 
-	/* Uncloning a cloned pp_recycle=1 net_iov skb keeps pp_ref_count */
+	/* Uncloning a cloned PP net_iov skb keeps pp_ref_count */
 	clone = skb_clone(skb, GFP_KERNEL);
 	KUNIT_ASSERT_NOT_NULL(test, clone);
 	KUNIT_ASSERT_EQ(test, pskb_expand_head(skb, 32, 0, GFP_KERNEL), 0);
-	KUNIT_EXPECT_TRUE(test, skb->pp_recycle);
 	KUNIT_EXPECT_EQ(test, atomic_long_read(&niov.desc.pp_ref_count), 3L);
 	KUNIT_EXPECT_EQ(test, atomic_long_read(&binding.ref.data->count),
 			base_ref);
 	consume_skb(clone);
 	KUNIT_EXPECT_EQ(test, atomic_long_read(&niov.desc.pp_ref_count), 2L);
 
-	skb->pp_recycle = 0;
-	skb_frag_ref(skb, 0);
-	KUNIT_EXPECT_EQ(test, atomic_long_read(&binding.ref.data->count),
-			base_ref + 1);
-	KUNIT_EXPECT_EQ(test, atomic_long_read(&niov.desc.pp_ref_count), 2L);
-	skb_frag_unref(skb, 0);
-	KUNIT_EXPECT_EQ(test, atomic_long_read(&binding.ref.data->count),
-			base_ref);
-
 	skb_shinfo(skb)->nr_frags = 0;
 	consume_skb(skb);
 	netmem_clear_pp_magic(netmem);
@@ -1170,7 +1138,6 @@ static void netmem_ref_test_release_data(struct kunit *test)
 	skb = alloc_skb(64, GFP_KERNEL);
 	KUNIT_ASSERT_NOT_NULL(test, skb);
 	skb_put(skb, 32);
-	skb->pp_recycle = 1;
 	skb_fill_netmem_desc(skb, 0, netmem, 0, 64);
 	skb->len += 64;
 	skb->data_len = 64;
@@ -1183,14 +1150,11 @@ static void netmem_ref_test_release_data(struct kunit *test)
 	clone2 = skb_clone(clone1, GFP_KERNEL);
 	KUNIT_ASSERT_NOT_NULL(test, clone2);
 
-	/* Freeing head skb first leaves clone1/clone2 pp_recycle=1 intact */
+	/* Freeing head skb first leaves clone1/clone2 intact */
 	consume_skb(skb);
-	KUNIT_EXPECT_TRUE(test, clone1->pp_recycle);
-	KUNIT_EXPECT_TRUE(test, clone2->pp_recycle);
 	KUNIT_EXPECT_EQ(test, atomic_long_read(&page->pp_ref_count),
 			base_pp_ref + 1);
 	consume_skb(clone2);
-	KUNIT_EXPECT_TRUE(test, clone1->pp_recycle);
 	KUNIT_EXPECT_EQ(test, atomic_long_read(&page->pp_ref_count),
 			base_pp_ref + 1);
 	consume_skb(clone1);
@@ -1202,7 +1166,6 @@ static void netmem_ref_test_release_data(struct kunit *test)
 		skb = alloc_skb(64, GFP_KERNEL);
 		KUNIT_ASSERT_NOT_NULL(test, skb);
 		skb_put(skb, 32);
-		skb->pp_recycle = 1;
 		skb_fill_netmem_desc(skb, 0, netmem, 0, 64);
 		skb->len += 64;
 		skb->data_len = 64;
@@ -1213,8 +1176,6 @@ static void netmem_ref_test_release_data(struct kunit *test)
 		KUNIT_ASSERT_EQ(test,
 				pskb_expand_head((i & 1) ? clone1 : skb,
 						 32, 0, GFP_KERNEL), 0);
-		KUNIT_EXPECT_TRUE(test, skb->pp_recycle);
-		KUNIT_EXPECT_TRUE(test, clone1->pp_recycle);
 		KUNIT_EXPECT_EQ(test, atomic_long_read(&page->pp_ref_count),
 				base_pp_ref + 2);
 		KUNIT_EXPECT_EQ(test, page_ref_count(page), base_ref);
@@ -1241,7 +1202,6 @@ static void netmem_ref_test_release_data(struct kunit *test)
 	skb = alloc_skb(64, GFP_KERNEL);
 	KUNIT_ASSERT_NOT_NULL(test, skb);
 	skb_put(skb, 32);
-	skb->pp_recycle = 1;
 	skb_fill_netmem_desc(skb, 0, netmem, 0, 64);
 	skb->len += 64;
 	skb->data_len = 64;
@@ -1250,7 +1210,6 @@ static void netmem_ref_test_release_data(struct kunit *test)
 	/* Carve inside header keeping frag -> pp_ref_count +1 until free */
 	ext = pskb_extract(skb, 16, skb->len - 16, GFP_KERNEL);
 	KUNIT_ASSERT_NOT_NULL(test, ext);
-	KUNIT_EXPECT_TRUE(test, ext->pp_recycle);
 	KUNIT_EXPECT_EQ(test, atomic_long_read(&page->pp_ref_count),
 			base_pp_ref + 2);
 	KUNIT_EXPECT_EQ(test, page_ref_count(page), base_ref);
@@ -1261,7 +1220,6 @@ static void netmem_ref_test_release_data(struct kunit *test)
 	/* Carve + trim + skb_condense ref/unrefs pp_ref_count cleanly */
 	ext = pskb_extract(skb, 16, 48, GFP_KERNEL);
 	KUNIT_ASSERT_NOT_NULL(test, ext);
-	KUNIT_EXPECT_TRUE(test, ext->pp_recycle);
 	KUNIT_EXPECT_EQ(test, atomic_long_read(&page->pp_ref_count),
 			base_pp_ref + 1);
 	KUNIT_EXPECT_EQ(test, page_ref_count(page), base_ref);
@@ -1270,7 +1228,6 @@ static void netmem_ref_test_release_data(struct kunit *test)
 	/* Carve inside nonlinear keeping frag -> pp_ref_count +1 until free */
 	ext = pskb_extract(skb, 48, skb->len - 48, GFP_KERNEL);
 	KUNIT_ASSERT_NOT_NULL(test, ext);
-	KUNIT_EXPECT_TRUE(test, ext->pp_recycle);
 	KUNIT_EXPECT_EQ(test, atomic_long_read(&page->pp_ref_count),
 			base_pp_ref + 2);
 	KUNIT_EXPECT_EQ(test, page_ref_count(page), base_ref);
@@ -1282,12 +1239,10 @@ static void netmem_ref_test_release_data(struct kunit *test)
 	page_pool_ref_netmem(netmem);
 	clone1 = alloc_skb(64, GFP_KERNEL);
 	KUNIT_ASSERT_NOT_NULL(test, clone1);
-	clone1->pp_recycle = 1;
 	skb_fill_netmem_desc(clone1, 0, netmem, 0, 64);
 	clone1->len = 64;
 	clone1->data_len = 64;
 	skb_morph(clone1, skb);
-	KUNIT_EXPECT_TRUE(test, clone1->pp_recycle);
 	KUNIT_EXPECT_EQ(test, atomic_long_read(&page->pp_ref_count),
 			base_pp_ref + 1);
 	consume_skb(clone1);
@@ -1309,14 +1264,12 @@ static void netmem_ref_test_release_data(struct kunit *test)
 	skb = alloc_skb(64, GFP_KERNEL);
 	KUNIT_ASSERT_NOT_NULL(test, skb);
 	skb_put(skb, 32);
-	skb->pp_recycle = 1;
 	skb_fill_netmem_desc(skb, 0, netmem, 0, 64);
 	skb->len += 64;
 	skb->data_len = 64;
 
 	ext = pskb_extract(skb, 48, skb->len - 48, GFP_KERNEL);
 	KUNIT_ASSERT_NOT_NULL(test, ext);
-	KUNIT_EXPECT_TRUE(test, ext->pp_recycle);
 	KUNIT_EXPECT_EQ(test, atomic_long_read(&niov.desc.pp_ref_count), 3L);
 	consume_skb(ext);
 	KUNIT_EXPECT_EQ(test, atomic_long_read(&niov.desc.pp_ref_count), 2L);
@@ -1375,7 +1328,6 @@ static void netmem_ref_test_skb_segment(struct kunit *test)
 	/* 1. Single GSO skb with page_pool net_iov frags */
 	head = alloc_skb(64, GFP_KERNEL);
 	KUNIT_ASSERT_NOT_NULL(test, head);
-	head->pp_recycle = 1;
 	head->protocol = htons(ETH_P_IP);
 	skb_reset_mac_header(head);
 	skb_reset_network_header(head);
@@ -1386,8 +1338,6 @@ static void netmem_ref_test_skb_segment(struct kunit *test)
 
 	segs = skb_segment(head, NETIF_F_SG | NETIF_F_HW_CSUM);
 	KUNIT_ASSERT_FALSE(test, IS_ERR_OR_NULL(segs));
-	for (seg = segs; seg; seg = seg->next)
-		KUNIT_EXPECT_TRUE(test, seg->pp_recycle);
 	KUNIT_EXPECT_EQ(test, atomic_long_read(&niov.desc.pp_ref_count), 6L);
 	KUNIT_EXPECT_EQ(test, atomic_long_read(&binding.ref.data->count),
 			base_iov_ref);
@@ -1396,13 +1346,11 @@ static void netmem_ref_test_skb_segment(struct kunit *test)
 	skb_shinfo(head)->nr_frags = 0;
 	consume_skb(head);
 
-	/* 2. GRO frag_list fast path (skb_clone of pp_recycle=1 list_skb) */
+	/* 2. GRO frag_list fast path (skb_clone of list_skb) */
 	head = alloc_skb(64, GFP_KERNEL);
 	list = alloc_skb(64, GFP_KERNEL);
 	KUNIT_ASSERT_NOT_NULL(test, head);
 	KUNIT_ASSERT_NOT_NULL(test, list);
-	head->pp_recycle = 1;
-	list->pp_recycle = 1;
 	head->protocol = htons(ETH_P_IP);
 	skb_reset_mac_header(head);
 	skb_reset_network_header(head);
@@ -1425,8 +1373,6 @@ static void netmem_ref_test_skb_segment(struct kunit *test)
 
 	segs = skb_segment(head, NETIF_F_SG | NETIF_F_HW_CSUM);
 	KUNIT_ASSERT_FALSE(test, IS_ERR_OR_NULL(segs));
-	for (seg = segs; seg; seg = seg->next)
-		KUNIT_EXPECT_TRUE(test, seg->pp_recycle);
 	KUNIT_EXPECT_EQ(test, atomic_long_read(&pp_page->pp_ref_count),
 			base_pp_ref + 4);
 	KUNIT_EXPECT_EQ(test, page_ref_count(pp_page), base_pp_page_ref);
@@ -1437,17 +1383,14 @@ static void netmem_ref_test_skb_segment(struct kunit *test)
 	KUNIT_EXPECT_EQ(test, atomic_long_read(&pp_page->pp_ref_count),
 			base_pp_ref);
 
-	/* 3. Mixed GRO frag_list (head pp_recycle=1 + list pp_recycle=0):
-	 * straddling segment linearizes its pp_recycle=1 prefix before
-	 * attaching the pp_recycle=0 frag so no nskb mixes incompatible
-	 * fragment refcount types; non-straddling segments stay zero-copy SG.
+	/* 3. Mixed GRO frag_list (head PP page + list non-PP page):
+	 * straddling segment stays zero-copy SG and refs each frag by netmem
+	 * type (pp_ref_count for pp_page, page_ref_count for reg_page).
 	 */
 	head = alloc_skb(64, GFP_KERNEL);
 	list = alloc_skb(0, GFP_KERNEL);
 	KUNIT_ASSERT_NOT_NULL(test, head);
 	KUNIT_ASSERT_NOT_NULL(test, list);
-	head->pp_recycle = 1;
-	list->pp_recycle = 0;
 	head->protocol = htons(ETH_P_IP);
 	skb_reset_mac_header(head);
 	skb_reset_network_header(head);
@@ -1468,11 +1411,8 @@ static void netmem_ref_test_skb_segment(struct kunit *test)
 
 	segs = skb_segment(head, NETIF_F_SG | NETIF_F_HW_CSUM);
 	KUNIT_ASSERT_FALSE(test, IS_ERR_OR_NULL(segs));
-	KUNIT_EXPECT_TRUE(test, segs->pp_recycle);
-	KUNIT_EXPECT_FALSE(test, segs->next->pp_recycle);
-	KUNIT_EXPECT_FALSE(test, segs->next->next->pp_recycle);
 	KUNIT_EXPECT_EQ(test, atomic_long_read(&pp_page->pp_ref_count),
-			base_pp_ref + 2);
+			base_pp_ref + 3);
 	KUNIT_EXPECT_EQ(test, page_ref_count(pp_page), base_pp_page_ref);
 	KUNIT_EXPECT_EQ(test, page_ref_count(reg_page), base_reg_ref + 3);
 	kfree_skb_list(segs);
@@ -1482,16 +1422,14 @@ static void netmem_ref_test_skb_segment(struct kunit *test)
 	KUNIT_EXPECT_EQ(test, page_ref_count(pp_page), base_pp_page_ref);
 	KUNIT_EXPECT_EQ(test, page_ref_count(reg_page), base_reg_ref);
 
-	/* 4. Reverse mixed frag_list (head pp_recycle=0 + list pp_recycle=1):
-	 * Crossing from pp_recycle=0 head into pp_recycle=1 list_skb must not
-	 * elevate page_ref_count(pp_page) instead of pp_ref_count.
+	/* 4. Reverse mixed frag_list (head non-PP page + list PP page):
+	 * Crossing from non-PP head into PP list_skb increments pp_ref_count
+	 * on pp_page without elevating page_ref_count(pp_page).
 	 */
 	head = alloc_skb(64, GFP_KERNEL);
 	list = alloc_skb(0, GFP_KERNEL);
 	KUNIT_ASSERT_NOT_NULL(test, head);
 	KUNIT_ASSERT_NOT_NULL(test, list);
-	head->pp_recycle = 0;
-	list->pp_recycle = 1;
 	head->protocol = htons(ETH_P_IP);
 	skb_reset_mac_header(head);
 	skb_reset_network_header(head);
@@ -1512,13 +1450,10 @@ static void netmem_ref_test_skb_segment(struct kunit *test)
 
 	segs = skb_segment(head, NETIF_F_SG | NETIF_F_HW_CSUM);
 	KUNIT_ASSERT_FALSE(test, IS_ERR_OR_NULL(segs));
-	KUNIT_EXPECT_FALSE(test, segs->pp_recycle);
-	KUNIT_EXPECT_TRUE(test, segs->next->pp_recycle);
-	KUNIT_EXPECT_TRUE(test, segs->next->next->pp_recycle);
 	KUNIT_EXPECT_EQ(test, atomic_long_read(&pp_page->pp_ref_count),
 			base_pp_ref + 3);
 	KUNIT_EXPECT_EQ(test, page_ref_count(pp_page), base_pp_page_ref);
-	KUNIT_EXPECT_EQ(test, page_ref_count(reg_page), base_reg_ref + 2);
+	KUNIT_EXPECT_EQ(test, page_ref_count(reg_page), base_reg_ref + 3);
 	kfree_skb_list(segs);
 	consume_skb(head);
 	KUNIT_EXPECT_EQ(test, atomic_long_read(&pp_page->pp_ref_count),
@@ -1526,10 +1461,10 @@ static void netmem_ref_test_skb_segment(struct kunit *test)
 	KUNIT_EXPECT_EQ(test, page_ref_count(pp_page), base_pp_page_ref);
 	KUNIT_EXPECT_EQ(test, page_ref_count(reg_page), base_reg_ref);
 
-	/* 5. Linear head_skb (nr_frags=0) + mixed pp_recycle frag_list where
-	 * member A has linear + frag (pp_recycle=1) and tail member B has
-	 * linear len == skb_headlen(A) (pp_recycle=0): keeps SG clone path
-	 * synchronized without hitting BUG_ON(i >= nfrags).
+	/* 5. Linear head_skb (nr_frags=0) + mixed frag_list where member A has
+	 * linear + frag (PP page) and tail member B has linear len ==
+	 * skb_headlen(A): keeps SG clone path synchronized without hitting
+	 * BUG_ON(i >= nfrags).
 	 */
 	head = alloc_skb(64, GFP_KERNEL);
 	list = alloc_skb(64, GFP_KERNEL);
@@ -1537,9 +1472,6 @@ static void netmem_ref_test_skb_segment(struct kunit *test)
 	KUNIT_ASSERT_NOT_NULL(test, head);
 	KUNIT_ASSERT_NOT_NULL(test, list);
 	KUNIT_ASSERT_NOT_NULL(test, seg);
-	head->pp_recycle = 0;
-	list->pp_recycle = 1;
-	seg->pp_recycle = 0;
 	head->protocol = htons(ETH_P_IP);
 	skb_reset_mac_header(head);
 	skb_reset_network_header(head);
@@ -1558,9 +1490,6 @@ static void netmem_ref_test_skb_segment(struct kunit *test)
 
 	segs = skb_segment(head, NETIF_F_SG | NETIF_F_HW_CSUM);
 	KUNIT_ASSERT_FALSE(test, IS_ERR_OR_NULL(segs));
-	KUNIT_EXPECT_FALSE(test, segs->pp_recycle);
-	KUNIT_EXPECT_TRUE(test, segs->next->pp_recycle);
-	KUNIT_EXPECT_FALSE(test, segs->next->next->pp_recycle);
 	KUNIT_EXPECT_EQ(test, atomic_long_read(&pp_page->pp_ref_count),
 			base_pp_ref + 2);
 	KUNIT_EXPECT_EQ(test, page_ref_count(pp_page), base_pp_page_ref);
@@ -1575,7 +1504,6 @@ static void netmem_ref_test_skb_segment(struct kunit *test)
 	 */
 	head = build_skb(page_address(pp_page), PAGE_SIZE);
 	KUNIT_ASSERT_NOT_NULL(test, head);
-	head->pp_recycle = 1;
 	skb_put(head, 32);
 	page_pool_ref_netmem(pp_nm);
 	skb_fill_netmem_desc(head, 0, niov_nm, 0, 32);
@@ -1601,7 +1529,6 @@ static void netmem_ref_test_skb_segment(struct kunit *test)
 	 */
 	head = build_skb(page_address(pp_page), PAGE_SIZE);
 	KUNIT_ASSERT_NOT_NULL(test, head);
-	head->pp_recycle = 1;
 	skb_put(head, 32);
 	page_pool_ref_netmem(pp_nm);
 	skb_zcopy_init(head, &uarg);
@@ -1674,14 +1601,12 @@ static void netmem_ref_test_try_coalesce(struct kunit *test)
 	base_reg_ref = page_ref_count(reg_page);
 	base_iov_ref = atomic_long_read(&binding.ref.data->count);
 
-	/* 1. Uncloned pp_recycle=1 from: frags stolen without extra ref */
+	/* 1. Uncloned from with PP page: frags stolen without extra ref */
 	to = alloc_skb(0, GFP_KERNEL);
 	from = alloc_skb(0, GFP_KERNEL);
 	KUNIT_ASSERT_NOT_NULL(test, to);
 	KUNIT_ASSERT_NOT_NULL(test, from);
 	skb_put(to, skb_tailroom(to));
-	to->pp_recycle = 1;
-	from->pp_recycle = 1;
 	skb_add_rx_frag(from, 0, pp_page, 0, 64, PAGE_SIZE);
 	page_pool_ref_netmem(pp_nm);
 	KUNIT_EXPECT_TRUE(test, skb_try_coalesce(to, from, &fragstolen,
@@ -1694,7 +1619,7 @@ static void netmem_ref_test_try_coalesce(struct kunit *test)
 	KUNIT_EXPECT_EQ(test, atomic_long_read(&pp_page->pp_ref_count),
 			base_pp_ref);
 
-	/* 2. Cloned pp_recycle=1 from (pp_page + non-PP reg_page fallback):
+	/* 2. Cloned from with mixed pp_page + non-PP reg_page:
 	 * skb_frag_ref(from, i) increments pp_ref_count for pp_page and
 	 * page_ref_count for reg_page.
 	 */
@@ -1703,8 +1628,6 @@ static void netmem_ref_test_try_coalesce(struct kunit *test)
 	KUNIT_ASSERT_NOT_NULL(test, to);
 	KUNIT_ASSERT_NOT_NULL(test, from);
 	skb_put(to, skb_tailroom(to));
-	to->pp_recycle = 1;
-	from->pp_recycle = 1;
 	skb_add_rx_frag(from, 0, pp_page, 0, 32, PAGE_SIZE);
 	page_pool_ref_netmem(pp_nm);
 	skb_add_rx_frag(from, 1, reg_page, 0, 32, PAGE_SIZE);
@@ -1726,7 +1649,7 @@ static void netmem_ref_test_try_coalesce(struct kunit *test)
 	KUNIT_EXPECT_EQ(test, page_ref_count(pp_page), base_pp_page_ref);
 	KUNIT_EXPECT_EQ(test, page_ref_count(reg_page), base_reg_ref);
 
-	/* 3. Cloned unreadable pp_recycle=1 net_iov skb: skb_try_coalesce
+	/* 3. Cloned unreadable PP net_iov skb: skb_try_coalesce
 	 * increments niov.desc.pp_ref_count via skb_frag_ref(from, i).
 	 */
 	to = alloc_skb(0, GFP_KERNEL);
@@ -1734,9 +1657,7 @@ static void netmem_ref_test_try_coalesce(struct kunit *test)
 	KUNIT_ASSERT_NOT_NULL(test, to);
 	KUNIT_ASSERT_NOT_NULL(test, from);
 	skb_put(to, skb_tailroom(to));
-	to->pp_recycle = 1;
 	to->unreadable = 1;
-	from->pp_recycle = 1;
 	skb_add_rx_frag_netmem(from, 0, niov_nm, 0, 64, PAGE_SIZE);
 	napi_pp_get_page(niov_nm);
 
@@ -1819,7 +1740,6 @@ static void netmem_ref_test_tcp_devmem_recv(struct kunit *test)
 	/* 1. Receive via tcp_recvmsg_dmabuf -> SO_DEVMEM_DONTNEED release */
 	skb = alloc_skb(0, GFP_KERNEL);
 	KUNIT_ASSERT_NOT_NULL(test, skb);
-	skb->pp_recycle = 1;
 	skb_add_rx_frag_netmem(skb, 0, niov_nm, 0, 64, PAGE_SIZE);
 	napi_pp_get_page(niov_nm);
 	TCP_SKB_CB(skb)->seq = 0;
@@ -1850,7 +1770,6 @@ static void netmem_ref_test_tcp_devmem_recv(struct kunit *test)
 	 */
 	skb = alloc_skb(0, GFP_KERNEL);
 	KUNIT_ASSERT_NOT_NULL(test, skb);
-	skb->pp_recycle = 1;
 	skb_add_rx_frag_netmem(skb, 0, niov_nm, 0, 64, PAGE_SIZE);
 	napi_pp_get_page(niov_nm);
 	TCP_SKB_CB(skb)->seq = 64;
diff --git a/net/core/netmem_priv.h b/net/core/netmem_priv.h
index 23175cb2bd866..13c39603003e1 100644
--- a/net/core/netmem_priv.h
+++ b/net/core/netmem_priv.h
@@ -3,21 +3,30 @@
 #ifndef __NETMEM_PRIV_H
 #define __NETMEM_PRIV_H
 
+/* Use READ_ONCE() because every netmem_inc/dec_ref() checks netmem_is_pp(),
+ * and pp_magic shares a struct page union word with folio->lru.next which MM
+ * code may concurrently modify on page-cache folios in TX SKBs.
+ */
 static inline unsigned long netmem_get_pp_magic(netmem_ref netmem)
 {
-	return netmem_to_nmdesc(netmem)->pp_magic & ~PP_DMA_INDEX_MASK;
+	return READ_ONCE(netmem_to_nmdesc(netmem)->pp_magic) &
+	       ~PP_DMA_INDEX_MASK;
 }
 
 static inline void netmem_or_pp_magic(netmem_ref netmem, unsigned long pp_magic)
 {
-	netmem_to_nmdesc(netmem)->pp_magic |= pp_magic;
+	struct netmem_desc *nmdesc = netmem_to_nmdesc(netmem);
+
+	WRITE_ONCE(nmdesc->pp_magic, READ_ONCE(nmdesc->pp_magic) | pp_magic);
 }
 
 static inline void netmem_clear_pp_magic(netmem_ref netmem)
 {
-	WARN_ON_ONCE(netmem_to_nmdesc(netmem)->pp_magic & PP_DMA_INDEX_MASK);
+	struct netmem_desc *nmdesc = netmem_to_nmdesc(netmem);
+
+	WARN_ON_ONCE(READ_ONCE(nmdesc->pp_magic) & PP_DMA_INDEX_MASK);
 
-	netmem_to_nmdesc(netmem)->pp_magic = 0;
+	WRITE_ONCE(nmdesc->pp_magic, 0);
 }
 
 static inline bool netmem_is_pp(netmem_ref netmem)
@@ -27,7 +36,7 @@ static inline bool netmem_is_pp(netmem_ref netmem)
 
 static inline void netmem_set_pp(netmem_ref netmem, struct page_pool *pool)
 {
-	netmem_to_nmdesc(netmem)->pp = pool;
+	WRITE_ONCE(netmem_to_nmdesc(netmem)->pp, pool);
 }
 
 static inline void netmem_set_dma_addr(netmem_ref netmem,
@@ -43,7 +52,7 @@ static inline unsigned long netmem_get_dma_index(netmem_ref netmem)
 	if (WARN_ON_ONCE(netmem_is_net_iov(netmem)))
 		return 0;
 
-	magic = netmem_to_nmdesc(netmem)->pp_magic;
+	magic = READ_ONCE(netmem_to_nmdesc(netmem)->pp_magic);
 
 	return (magic & PP_DMA_INDEX_MASK) >> PP_DMA_INDEX_SHIFT;
 }
@@ -57,6 +66,6 @@ static inline void netmem_set_dma_index(netmem_ref netmem,
 		return;
 
 	magic = netmem_get_pp_magic(netmem) | (id << PP_DMA_INDEX_SHIFT);
-	netmem_to_nmdesc(netmem)->pp_magic = magic;
+	WRITE_ONCE(netmem_to_nmdesc(netmem)->pp_magic, magic);
 }
 #endif
diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index d7c88c0b67e53..87db2f2b72e8e 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -825,9 +825,9 @@ static bool page_pool_recycle_in_cache(netmem_ref netmem,
 
 static bool __page_pool_page_can_be_recycled(netmem_ref netmem)
 {
-	return netmem_is_net_iov(netmem) ||
-	       (page_ref_count(netmem_to_page(netmem)) == 1 &&
-		!page_is_pfmemalloc(netmem_to_page(netmem)));
+	return page_pool_netmem_is_exclusively_owned(netmem) &&
+	       (netmem_is_net_iov(netmem) ||
+		!page_is_pfmemalloc(__netmem_to_page(netmem)));
 }
 
 /* If the page refcnt == 1, this will try to recycle the page.
@@ -853,6 +853,8 @@ __page_pool_put_page(struct page_pool *pool, netmem_ref netmem,
 	 */
 	if (likely(__page_pool_page_can_be_recycled(netmem))) {
 		/* Read barrier done in page_ref_count / READ_ONCE */
+		if (unlikely(!page_pool_ref_count(netmem)))
+			page_pool_fragment_netmem(netmem, 1);
 
 		page_pool_dma_sync_for_device(pool, netmem, dma_sync_size);
 
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 32a9dcdf2cb22..e3b969e38db65 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -1032,15 +1032,16 @@ EXPORT_SYMBOL(skb_cow_data_for_xdp);
  * @netmem: netmem to unreference
  *
  * Drops a page_pool reference (pp_ref_count) on @netmem if it belongs to a
- * page_pool. Counterpart to napi_pp_get_page().
+ * page_pool and has an active pp_ref_count. Counterpart to napi_pp_get_page().
  *
- * Return: true if @netmem belongs to a page_pool, false otherwise.
+ * Return: true if @netmem's page_pool reference count was decremented, false
+ * otherwise.
  */
 bool napi_pp_put_page(netmem_ref netmem)
 {
 	netmem = netmem_compound_head(netmem);
 
-	if (unlikely(!netmem_is_pp(netmem)))
+	if (unlikely(!netmem_is_pp(netmem) || !page_pool_ref_count(netmem)))
 		return false;
 
 	page_pool_put_full_netmem(netmem_get_pp(netmem), netmem, false);
@@ -1054,9 +1055,10 @@ EXPORT_SYMBOL(napi_pp_put_page);
  * @netmem: netmem to reference
  *
  * Acquires a page_pool reference (pp_ref_count) on @netmem if it belongs to a
- * page_pool. Counterpart to napi_pp_put_page().
+ * page_pool and has an active pp_ref_count. Counterpart to napi_pp_put_page().
  *
- * Return: true if @netmem belongs to a page_pool, false otherwise.
+ * Return: true if @netmem's page_pool reference count was incremented, false
+ * otherwise.
  */
 bool napi_pp_get_page(netmem_ref netmem)
 {
@@ -1065,16 +1067,14 @@ bool napi_pp_get_page(netmem_ref netmem)
 	if (unlikely(!netmem_is_pp(netmem)))
 		return false;
 
-	page_pool_ref_netmem(netmem);
-
-	return true;
+	return atomic_long_inc_not_zero(netmem_get_pp_ref_count_ref(netmem));
 }
 EXPORT_SYMBOL(napi_pp_get_page);
 #endif
 
-static bool skb_pp_recycle(struct sk_buff *skb, void *data)
+static bool skb_pp_recycle(void *data)
 {
-	if (!IS_ENABLED(CONFIG_PAGE_POOL) || !skb->pp_recycle)
+	if (!IS_ENABLED(CONFIG_PAGE_POOL))
 		return false;
 	return napi_pp_put_page(page_to_netmem(virt_to_page(data)));
 }
@@ -1089,7 +1089,7 @@ static void skb_free_head(struct sk_buff *skb)
 	unsigned char *head = skb->head;
 
 	if (skb->head_frag) {
-		if (skb_pp_recycle(skb, head))
+		if (skb_pp_recycle(head))
 			return;
 		skb_free_frag(head);
 	} else {
@@ -1114,8 +1114,7 @@ static void skb_release_data(struct sk_buff *skb, enum skb_drop_reason reason)
 	}
 
 	for (i = 0; i < shinfo->nr_frags; i++)
-		skb_netmem_unref(skb_frag_netmem(&shinfo->frags[i]),
-				 skb->pp_recycle);
+		netmem_dec_ref(skb_frag_netmem(&shinfo->frags[i]));
 
 free_head:
 	if (shinfo->frag_list)
@@ -1613,7 +1612,6 @@ static struct sk_buff *__skb_clone(struct sk_buff *n, struct sk_buff *skb)
 	n->nohdr = 0;
 	n->peeked = 0;
 	C(pfmemalloc);
-	C(pp_recycle);
 	n->destructor = NULL;
 	C(alloc_cpu);
 	C(tail);
@@ -2251,7 +2249,6 @@ struct sk_buff *__pskb_copy_fclone(struct sk_buff *skb, int headroom,
 			n = NULL;
 			goto out;
 		}
-		n->pp_recycle = skb->pp_recycle;
 		for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
 			skb_shinfo(n)->frags[i] = skb_shinfo(skb)->frags[i];
 			skb_frag_ref(n, i);
@@ -3936,7 +3933,6 @@ skb_zerocopy(struct sk_buff *to, struct sk_buff *from, int len, int hlen)
 	if (len <= skb_tailroom(to))
 		return skb_copy_bits(from, 0, skb_put(to, len), len);
 
-	to->pp_recycle = from->pp_recycle;
 	if (hlen) {
 		ret = skb_copy_bits(from, 0, skb_put(to, hlen), hlen);
 		if (unlikely(ret))
@@ -4309,7 +4305,6 @@ void skb_split(struct sk_buff *skb, struct sk_buff *skb1, const u32 len)
 
 	skb_shinfo(skb1)->flags |= skb_shinfo(skb)->flags & zc_flags;
 	skb_zerocopy_clone(skb1, skb, 0);
-	skb1->pp_recycle = skb->pp_recycle;
 	if (len < pos)	/* Split line is inside header. */
 		skb_split_inside_header(skb, skb1, len, pos);
 	else		/* Second chunk has no header, nothing to copy. */
@@ -4359,7 +4354,6 @@ int skb_shift(struct sk_buff *tgt, struct sk_buff *skb, int shiftlen)
 	if (skb_zcopy(tgt) || skb_zcopy(skb))
 		return 0;
 
-	DEBUG_NET_WARN_ON_ONCE(tgt->pp_recycle != skb->pp_recycle);
 	DEBUG_NET_WARN_ON_ONCE(skb_cmp_decrypted(tgt, skb));
 
 	todo = shiftlen;
@@ -5103,16 +5097,6 @@ struct sk_buff *skb_segment(struct sk_buff *head_skb,
 
 		while (pos < offset + len) {
 			if (i >= nfrags) {
-				if (skb_shinfo(nskb)->nr_frags &&
-				    nskb->pp_recycle != list_skb->pp_recycle) {
-					nskb->data_len = pos - offset - hsize;
-					nskb->len += nskb->data_len;
-					nskb->truesize += nskb->data_len;
-					if (__skb_linearize(nskb))
-						goto err;
-					hsize = pos - offset;
-					nskb_frag = skb_shinfo(nskb)->frags;
-				}
 				if (skb_orphan_frags(list_skb, GFP_ATOMIC) ||
 				    skb_zerocopy_clone(nskb, list_skb,
 						       GFP_ATOMIC))
@@ -5155,8 +5139,6 @@ struct sk_buff *skb_segment(struct sk_buff *head_skb,
 				goto err;
 			}
 
-			if (!skb_shinfo(nskb)->nr_frags)
-				nskb->pp_recycle = frag_skb->pp_recycle;
 			*nskb_frag = (i < 0) ? skb_head_frag_to_page_desc(frag_skb) : *frag;
 			skb_frag_ref(nskb, skb_shinfo(nskb)->nr_frags);
 			size = skb_frag_size(nskb_frag);
@@ -6306,15 +6288,6 @@ bool skb_try_coalesce(struct sk_buff *to, struct sk_buff *from,
 	if (skb_cloned(to))
 		return false;
 
-	/* In general, avoid mixing page_pool and non-page_pool allocated
-	 * pages within the same SKB. In theory we could take full
-	 * references if @from is cloned and !@to->pp_recycle but its
-	 * tricky (due to potential race with the clone disappearing) and
-	 * rare, so not worth dealing with.
-	 */
-	if (to->pp_recycle != from->pp_recycle)
-		return false;
-
 	/* All frags in an skb must either all be struct page-backed or all
 	 * belong to the same memory provider instance; do not coalesce skbs
 	 * that would mix them.
diff --git a/net/core/xdp.c b/net/core/xdp.c
index 1d679e8fd6493..6f2b9191af9ec 100644
--- a/net/core/xdp.c
+++ b/net/core/xdp.c
@@ -445,7 +445,7 @@ void __xdp_return(netmem_ref netmem, enum xdp_mem_type mem_type,
 					  napi_direct);
 		break;
 	case MEM_TYPE_PAGE_SHARED:
-		page_frag_free(__netmem_address(netmem));
+		netmem_dec_ref(netmem);
 		break;
 	case MEM_TYPE_PAGE_ORDER0:
 		put_page(__netmem_to_page(netmem));
diff --git a/net/ipv4/esp4.c b/net/ipv4/esp4.c
index ae701561d9f12..1c37028146c98 100644
--- a/net/ipv4/esp4.c
+++ b/net/ipv4/esp4.c
@@ -96,7 +96,7 @@ static inline struct scatterlist *esp_req_sg(struct crypto_aead *aead,
 			     __alignof__(struct scatterlist));
 }
 
-static void esp_ssg_unref(struct xfrm_state *x, void *tmp, struct sk_buff *skb, bool already_unref)
+static void esp_ssg_unref(struct xfrm_state *x, void *tmp, bool already_unref)
 {
 	struct crypto_aead *aead = x->data;
 	int extralen = 0;
@@ -117,8 +117,7 @@ static void esp_ssg_unref(struct xfrm_state *x, void *tmp, struct sk_buff *skb,
 		struct scatterlist *src = already_unref ? esp_req_sg(aead, req) : req->src;
 
 		for (sg = sg_next(src); sg; sg = sg_next(sg))
-			skb_netmem_unref(page_to_netmem(sg_page(sg)),
-					 skb->pp_recycle);
+			netmem_dec_ref(page_to_netmem(sg_page(sg)));
 	}
 }
 
@@ -223,7 +222,7 @@ static void esp_output_done(void *data, int err)
 	}
 
 	tmp = ESP_SKB_CB(skb)->tmp;
-	esp_ssg_unref(x, tmp, skb, false);
+	esp_ssg_unref(x, tmp, false);
 	kfree(tmp);
 
 	if (xo && (xo->flags & XFRM_DEV_RESUME)) {
@@ -579,7 +578,7 @@ int esp_output_tail(struct xfrm_state *x, struct sk_buff *skb, struct esp_info *
 			           (unsigned char *)esph - skb->data,
 			           assoclen + ivlen + esp->clen + alen);
 		if (unlikely(err < 0)) {
-			esp_ssg_unref(x, tmp, skb, true);
+			esp_ssg_unref(x, tmp, true);
 			goto error_free;
 		}
 	}
@@ -613,7 +612,7 @@ int esp_output_tail(struct xfrm_state *x, struct sk_buff *skb, struct esp_info *
 	}
 
 	if (sg != dsg)
-		esp_ssg_unref(x, tmp, skb, false);
+		esp_ssg_unref(x, tmp, false);
 
 	if (!err && x->encap && x->encap->encap_type == TCP_ENCAP_ESPINTCP)
 		err = esp_output_tail_tcp(x, skb);
diff --git a/net/ipv6/esp6.c b/net/ipv6/esp6.c
index d654f0f442388..25dd0c01f908d 100644
--- a/net/ipv6/esp6.c
+++ b/net/ipv6/esp6.c
@@ -113,7 +113,7 @@ static inline struct scatterlist *esp_req_sg(struct crypto_aead *aead,
 			     __alignof__(struct scatterlist));
 }
 
-static void esp_ssg_unref(struct xfrm_state *x, void *tmp, struct sk_buff *skb, bool already_unref)
+static void esp_ssg_unref(struct xfrm_state *x, void *tmp, bool already_unref)
 {
 	struct crypto_aead *aead = x->data;
 	int extralen = 0;
@@ -134,8 +134,7 @@ static void esp_ssg_unref(struct xfrm_state *x, void *tmp, struct sk_buff *skb,
 		struct scatterlist *src = already_unref ? esp_req_sg(aead, req) : req->src;
 
 		for (sg = sg_next(src); sg; sg = sg_next(sg))
-			skb_netmem_unref(page_to_netmem(sg_page(sg)),
-					 skb->pp_recycle);
+			netmem_dec_ref(page_to_netmem(sg_page(sg)));
 	}
 }
 
@@ -258,7 +257,7 @@ static void esp_output_done(void *data, int err)
 	}
 
 	tmp = ESP_SKB_CB(skb)->tmp;
-	esp_ssg_unref(x, tmp, skb, false);
+	esp_ssg_unref(x, tmp, false);
 	kfree(tmp);
 
 	esp_output_encap_csum(skb);
@@ -611,7 +610,7 @@ int esp6_output_tail(struct xfrm_state *x, struct sk_buff *skb, struct esp_info
 			           (unsigned char *)esph - skb->data,
 			           assoclen + ivlen + esp->clen + alen);
 		if (unlikely(err < 0)) {
-			esp_ssg_unref(x, tmp, skb, true);
+			esp_ssg_unref(x, tmp, true);
 			goto error_free;
 		}
 	}
@@ -646,7 +645,7 @@ int esp6_output_tail(struct xfrm_state *x, struct sk_buff *skb, struct esp_info
 	}
 
 	if (sg != dsg)
-		esp_ssg_unref(x, tmp, skb, false);
+		esp_ssg_unref(x, tmp, false);
 
 	if (!err && x->encap && x->encap->encap_type == TCP_ENCAP_ESPINTCP)
 		err = esp_output_tail_tcp(x, skb);
diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
index 4cdfbb57ecff0..670fdeeeae567 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -165,6 +165,7 @@ static void tls_tcp_clean_acked(struct sock *sk, u32 acked_seq)
 	struct tls_record_info *info, *temp;
 	struct tls_offload_context_tx *ctx;
 	u64 deleted_records = 0;
+	LIST_HEAD(to_free);
 	unsigned long flags;
 
 	if (!tls_ctx)
@@ -180,14 +181,15 @@ static void tls_tcp_clean_acked(struct sock *sk, u32 acked_seq)
 	list_for_each_entry_safe(info, temp, &ctx->records_list, list) {
 		if (before(acked_seq, info->end_seq))
 			break;
-		list_del(&info->list);
-
-		destroy_record(info);
+		list_move_tail(&info->list, &to_free);
 		deleted_records++;
 	}
 
 	ctx->unacked_record_sn += deleted_records;
 	spin_unlock_irqrestore(&ctx->lock, flags);
+
+	list_for_each_entry_safe(info, temp, &to_free, list)
+		destroy_record(info);
 }
 
 /* At this point, there should be no references on this
@@ -269,7 +271,7 @@ static void tls_append_frag(struct tls_record_info *record,
 		skb_frag_fill_page_desc(frag, pfrag->page, pfrag->offset,
 					size);
 		++record->num_frags;
-		get_page(pfrag->page);
+		netmem_inc_ref(page_to_netmem(pfrag->page));
 	}
 
 	pfrag->offset += size;
@@ -302,7 +304,7 @@ static int tls_push_record(struct sock *sk,
 		sg_set_page(&offload_ctx->sg_tx_data[i], skb_frag_page(frag),
 			    skb_frag_size(frag), skb_frag_off(frag));
 		sk_mem_charge(sk, skb_frag_size(frag));
-		get_page(skb_frag_page(frag));
+		netmem_inc_ref(skb_frag_netmem(frag));
 	}
 	sg_mark_end(&offload_ctx->sg_tx_data[record->num_frags - 1]);
 
@@ -354,7 +356,7 @@ static int tls_create_new_record(struct tls_offload_context_tx *offload_ctx,
 	skb_frag_fill_page_desc(frag, pfrag->page, pfrag->offset,
 				prepend_size);
 
-	get_page(pfrag->page);
+	netmem_inc_ref(page_to_netmem(pfrag->page));
 	pfrag->offset += prepend_size;
 
 	record->num_frags = 1;
diff --git a/net/tls/tls_device_fallback.c b/net/tls/tls_device_fallback.c
index b547027cc879f..b2a43b162fdac 100644
--- a/net/tls/tls_device_fallback.c
+++ b/net/tls/tls_device_fallback.c
@@ -397,8 +397,10 @@ static struct sk_buff *tls_sw_fallback(struct sock *sk, struct sk_buff *skb)
 	nskb = tls_enc_skb(tls_ctx, sg_out, sg_in, skb, sync_size, rcd_sn);
 
 put_sg:
-	while (resync_sgs)
-		put_page(sg_page(&sg_in[--resync_sgs]));
+	while (resync_sgs) {
+		resync_sgs--;
+		netmem_dec_ref(page_to_netmem(sg_page(&sg_in[resync_sgs])));
+	}
 	kfree(sg_in);
 free_orig:
 	if (nskb)
diff --git a/net/tls/tls_main.c b/net/tls/tls_main.c
index b8d5a843f7617..51d2595ebf317 100644
--- a/net/tls/tls_main.c
+++ b/net/tls/tls_main.c
@@ -206,7 +206,7 @@ int tls_push_sg(struct sock *sk,
 			return ret;
 		}
 
-		put_page(p);
+		netmem_dec_ref(page_to_netmem(p));
 		sk_mem_uncharge(sk, sg->length);
 		sg = sg_next(sg);
 		if (!sg)
@@ -281,7 +281,7 @@ void tls_free_partial_record(struct sock *sk, struct tls_context *ctx)
 	struct scatterlist *sg;
 
 	for (sg = ctx->partially_sent_record; sg; sg = sg_next(sg)) {
-		put_page(sg_page(sg));
+		netmem_dec_ref(page_to_netmem(sg_page(sg)));
 		sk_mem_uncharge(sk, sg->length);
 	}
 	ctx->partially_sent_record = NULL;
diff --git a/net/wireless/util.c b/net/wireless/util.c
index 59912f4a93c88..493d7e4a58617 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -10,6 +10,7 @@
 #include <linux/export.h>
 #include <linux/bitops.h>
 #include <linux/etherdevice.h>
+#include <linux/skbuff_ref.h>
 #include <linux/slab.h>
 #include <linux/ieee80211.h>
 #include <net/cfg80211.h>
@@ -768,19 +769,25 @@ int ieee80211_data_to_8023_exthdr(struct sk_buff *skb, struct ethhdr *ehdr,
 }
 EXPORT_SYMBOL(ieee80211_data_to_8023_exthdr);
 
-static void
+static bool
 __frame_add_frag(struct sk_buff *skb, struct page *page,
 		 void *ptr, int len, int size)
 {
 	struct skb_shared_info *sh = skb_shinfo(skb);
+	int i = sh->nr_frags;
 	int page_offset;
 
-	get_page(page);
+	if (i >= MAX_SKB_FRAGS)
+		return false;
+
 	page_offset = ptr - page_address(page);
-	skb_add_rx_frag(skb, sh->nr_frags, page, page_offset, len, size);
+	skb_add_rx_frag(skb, i, page, page_offset, len, size);
+	skb_frag_ref(skb, i);
+
+	return true;
 }
 
-static void
+static bool
 __ieee80211_amsdu_copy_frag(struct sk_buff *skb, struct sk_buff *frame,
 			    int offset, int len)
 {
@@ -809,17 +816,22 @@ __ieee80211_amsdu_copy_frag(struct sk_buff *skb, struct sk_buff *frame,
 
 	cur_len = min(len, frag_len);
 
-	__frame_add_frag(frame, frag_page, frag_ptr, cur_len, frag_size);
+	if (!__frame_add_frag(frame, frag_page, frag_ptr, cur_len, frag_size))
+		return false;
 	len -= cur_len;
 
 	while (len > 0) {
 		frag_len = skb_frag_size(frag);
 		cur_len = min(len, frag_len);
-		__frame_add_frag(frame, skb_frag_page(frag),
-				 skb_frag_address(frag), cur_len, frag_len);
+		if (!__frame_add_frag(frame, skb_frag_page(frag),
+				      skb_frag_address(frag), cur_len,
+				      frag_len))
+			return false;
 		len -= cur_len;
 		frag++;
 	}
+
+	return true;
 }
 
 static struct sk_buff *
@@ -858,7 +870,10 @@ __ieee80211_amsdu_copy(struct sk_buff *skb, unsigned int hlen,
 		return frame;
 
 	offset += cur_len;
-	__ieee80211_amsdu_copy_frag(skb, frame, offset, len);
+	if (!__ieee80211_amsdu_copy_frag(skb, frame, offset, len)) {
+		kfree_skb(frame);
+		return NULL;
+	}
 
 	return frame;
 }
diff --git a/net/xfrm/trace_iptfs.h b/net/xfrm/trace_iptfs.h
index 74391ba244453..ecfd3f1f36d1f 100644
--- a/net/xfrm/trace_iptfs.h
+++ b/net/xfrm/trace_iptfs.h
@@ -167,7 +167,6 @@ TRACE_EVENT(iptfs_ingress_nth_add, TP_PROTO(struct sk_buff *skb, u8 share_ok),
 			     __field(u32, data_len)
 			     __field(u8, share_ok)
 			     __field(u8, head_frag)
-			     __field(u8, pp_recycle)
 			     __field(u8, cloned)
 			     __field(u8, shared)
 			     __field(u8, nr_frags)
@@ -178,15 +177,14 @@ TRACE_EVENT(iptfs_ingress_nth_add, TP_PROTO(struct sk_buff *skb, u8 share_ok),
 			   __entry->data_len = skb->data_len;
 			   __entry->share_ok = share_ok;
 			   __entry->head_frag = skb->head_frag;
-			   __entry->pp_recycle = skb->pp_recycle;
 			   __entry->cloned = skb_cloned(skb);
 			   __entry->shared = skb_shared(skb);
 			   __entry->nr_frags = skb_shinfo(skb)->nr_frags;
 			   __entry->frag_list = (bool)skb_shinfo(skb)->frag_list;
 		    ),
-	    TP_printk("INGRPSTQ: NTHADD: skb=%p len=%u data_len=%u share_ok=%u head_frag=%u pp_recycle=%u cloned=%u shared=%u nr_frags=%u frag_list=%u",
+	    TP_printk("INGRPSTQ: NTHADD: skb=%p len=%u data_len=%u share_ok=%u head_frag=%u cloned=%u shared=%u nr_frags=%u frag_list=%u",
 		      __entry->skb, __entry->skb_len, __entry->data_len, __entry->share_ok,
-		      __entry->head_frag, __entry->pp_recycle, __entry->cloned, __entry->shared,
+		      __entry->head_frag, __entry->cloned, __entry->shared,
 		      __entry->nr_frags, __entry->frag_list));
 
 DECLARE_EVENT_CLASS(iptfs_timer_event,
diff --git a/net/xfrm/xfrm_iptfs.c b/net/xfrm/xfrm_iptfs.c
index 04ef833074fc8..f441aa54dcf1f 100644
--- a/net/xfrm/xfrm_iptfs.c
+++ b/net/xfrm/xfrm_iptfs.c
@@ -310,7 +310,6 @@ static void iptfs_skb_head_to_frag(const struct sk_buff *skb, skb_frag_t *frag)
  * @nr_frags: number of fragments present in array
  * @initial_offset: the value passed in to skb_prepare_frag_walk()
  * @frags: the page fragments inc. room for head page
- * @pp_recycle: copy of skb->pp_recycle
  */
 struct iptfs_skb_frag_walk {
 	u32 fragi;
@@ -319,7 +318,6 @@ struct iptfs_skb_frag_walk {
 	u32 nr_frags;
 	u32 initial_offset;
 	skb_frag_t frags[MAX_SKB_FRAGS + 1];
-	bool pp_recycle;
 };
 
 /**
@@ -343,7 +341,6 @@ static void iptfs_skb_prepare_frag_walk(struct sk_buff *skb, u32 initial_offset,
 	walk->past = 0;
 	walk->total = 0;
 	walk->nr_frags = 0;
-	walk->pp_recycle = skb->pp_recycle;
 
 	if (skb->head_frag) {
 		if (initial_offset >= skb_headlen(skb)) {
@@ -413,7 +410,7 @@ static bool iptfs_skb_can_add_frags(const struct sk_buff *skb,
 	struct skb_shared_info *shinfo = skb_shinfo(skb);
 	u32 fragi, nr_frags, fraglen;
 
-	if (skb_has_frag_list(skb) || skb->pp_recycle != walk->pp_recycle)
+	if (skb_has_frag_list(skb))
 		return false;
 
 	/* Reject an @offset that is at or beyond the end of the walk's data
@@ -898,8 +895,7 @@ static u32 iptfs_reassem_cont(struct xfrm_iptfs_data *xtfs, u64 seq,
 
 	/* If we may have the opportunity to share prepare a fragwalk. */
 	if (!skb_has_frag_list(skb) && !skb_has_frag_list(newskb) &&
-	    (skb->head_frag || skb->len == skb->data_len) &&
-	    skb->pp_recycle == newskb->pp_recycle) {
+	    (skb->head_frag || skb->len == skb->data_len)) {
 		fragwalk = &_fragwalk;
 		iptfs_skb_prepare_frag_walk(skb, data, fragwalk);
 	}
@@ -2289,15 +2285,10 @@ static void iptfs_output_queued(struct xfrm_state *x, struct sk_buff_head *list)
 				}
 			}
 
-			/* skb->pp_recycle is passed to __skb_flag_unref for all
-			 * frag pages so we can only share pages with skb's who
-			 * match ourselves.
-			 */
 			shi2 = skb_shinfo(skb2);
 			if (share_ok &&
 			    (shi2->frag_list ||
 			     (!skb2->head_frag && skb_headlen(skb)) ||
-			     skb->pp_recycle != skb2->pp_recycle ||
 			     skb_zcopy(skb2) ||
 			     (shi->nr_frags + shi2->nr_frags + 1 > MAX_SKB_FRAGS)))
 				share_ok = false;
-- 
2.56.0.385.gac671c819a-goog

