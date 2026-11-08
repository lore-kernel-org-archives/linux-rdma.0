Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.197
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794117627;
	b=meVQGRsipKCtWIa9V9XV3FgqbZL9lNTlcxbHv6xAq959YpG63zJBMjN2NW0s38hXUG0K
	 +CkIau0G+zr9mgoCe3ztKFVIv8Y0cTRYbMyKtBgfiDvpeTv18NUz3Y2Ihg3VQxLW8Y9VK
	 kpNa8+NxJy0Te3iiGLsb4PgDf2Zk0gwZS5hzcj46F9ryiEQxWDCnJOjdjwy2GbFxsXErl
	 9VEmUrj2hNfQY+gVxCESuKzVs5rH/SE29BLB+9h5Sw1RlfXplA0Oei3ulGjeNLsZzgDH3
	 jy2fLJNpyddj8AHkFO2FShSFuSEU4RN04dD+JIpSO+3JbkwMTk8/Iitn5uUTqppYHRg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794117627;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=38vhMtcYtSaxNCCcBpdS7x+l8Ry6ZXqSrekSBQ31f4s=;
	b=VFeKWC5grAOBx/1dm/1PIwTSFKcJfyccCBGSvPIpPmyZxb/EieoQ8p3XBCzjrCjoC//0
	 56QGXsoi08yCkjgxQAlg7Vg0SasTQ/TqABnogc3A+n+yUgUepnb8x7PIq9Ktu52sEGwt/
	 5/pf98HDYZOnfbtNXaB77s1zn4KH/pzFu425yjJ1rOdQ2654kG10ZSI8TZcN68cilzGMG
	 dAiCTMVRQh6LndpLPq4DE1J7/oG1ONno+0CXZjpZWyVqtpKwQMYlK/ERcD1CUTj7HhHhd
	 d7/xVeP/jrLEu5xY5PBlMuaoIjGT+UH94AsSQUIT2lmQD2YlKmHW53uo0seOSrm/06w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--almasrymina.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b="kZN/+EQg";
	arc=none smtp.remote-ip=74.125.82.197
Received: from mail-dy1-f197.google.com (mail-dy1-f197.google.com [74.125.82.197])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB2366082BED
	for <linux-rdma@vger.kernel.org>; Sun,  8 Nov 2026 06:00:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AB2366082BED
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--almasrymina.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=kZN/+EQg
Received: by mail-dy1-f197.google.com with SMTP id 5a478bee46e88-33c35f5ca6cso652084eec.1
        for <linux-rdma@vger.kernel.org>; Sat, 07 Nov 2026 22:00:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794117625; x=1794722425; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=38vhMtcYtSaxNCCcBpdS7x+l8Ry6ZXqSrekSBQ31f4s=;
        b=kZN/+EQgjIAHf3RXT+Sp5qz0MPylvhkhSnoZuws7Cd0ghOdFekgmVLUQusDCjQJQ6c
         Da0WXCN0gKNvrtiAEO2NPqAHsxyb8sqNpG+V5Z+HPgvauf8jnf02Voxug+5i9Hq0HlfR
         OSt/rm4kltvloUZQLrvPhEc62yFhwbYckIzL3L/+Xco2FYb5TaTInTmf32meF87Hm+8+
         Dz3dt9ocoHRCxhAl7TxjV2aGnHrQ8oYw4HovsFunl6ALCgrrH7/ncl6vrq3i2HgeERjD
         U+YDd1+UT4hzD1krPACa994N4v8RXuZckVB5rGdyupr+jepZ9UsdGxEmg/l7W9pM3T07
         MPEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794117625; x=1794722425;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=38vhMtcYtSaxNCCcBpdS7x+l8Ry6ZXqSrekSBQ31f4s=;
        b=l1v0xAWdPaPY2LzxxuNCSsV1YXPWTqAwOpczls5qNQms4mmccuz+JlPSTHUHZk/twD
         2bmd+4dyw4+KeMqDyR9AqOS4wqpYA8S77CTbh/fU2QC0cBnoo05Dgg3y+XlhGjY0bDG2
         yjw5Aupvv/Vfq0lbNLUeftrx6Nysir4WPf1wgzZas8me74uuiHI/ELPvWmwYfgU7cdLz
         68fRc2cXBZboKInuijKTY7XuAvD2NGuUFexf9jr9Jds62Ne8A4qX7lLikPaw19fJLXkA
         3Vp6oOSBm1QUiW4fh0749YF5BnuPHF6PdFa4cWFPBVzB2FLfyAPpxwtXx45577FgKBmF
         nTxQ==
X-Forwarded-Encrypted: i=1; AKwUvBxLVlc2SlksaXvXPgTPBv8lPmwaQ2I0a2VrMOxzxQ8Hvb/iXVTg+fXzymqv7IexYTGOtRO1LIyhfBAS@vger.kernel.org
X-Gm-Message-State: APuU4Z/QrFNPrhh7XrVhCCSQu2RTEY371VDYrLzBU8qomF4vlI4Ek81m
	ZOqPdZpnguY1ES+yLZFKetkP4gRkd4bAAJUE82Epg5H1rsnrWvKwggVtll5zRB2LC9UmEcfy3dv
	Ody2NBobKXX9eOgpRZDsoJW22Hg==
X-Received: from dlx13.prod.google.com ([2002:a05:7022:8d:b0:199:f7f6:16f2])
 (user=almasrymina job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:701b:450c:10b0:192:fd91:c567 with SMTP id a92af1059eb24-1b39fe87361mr1177802c88.11.1794117623580;
 Sat, 07 Nov 2026 22:00:23 -0800 (PST)
Date: Sun,  8 Nov 2026 06:00:15 +0000
In-Reply-To: <20261108060016.2131509-1-almasrymina@google.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
References: <20261108060016.2131509-1-almasrymina@google.com>
X-Mailer: git-send-email 2.56.0.455.g6c5a503b38-goog
Message-ID: <20261108060016.2131509-5-almasrymina@google.com>
Subject: [PATCH net-next v2 4/5] net: remove skb->pp_recycle and consolidate
 netmem refcounting
From: Mina Almasry <almasrymina@google.com>
To: netdev@vger.kernel.org
Cc: Mina Almasry <almasrymina@google.com>, Jesper Dangaard Brouer <hawk@kernel.org>, 
	Ilias Apalodimas <ilias.apalodimas@linaro.org>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Simon Horman <horms@kernel.org>, Neal Cardwell <ncardwell@google.com>, 
	Kuniyuki Iwashima <kuniyu@google.com>, Pavel Begunkov <asml.silence@gmail.com>, 
	Bobby Eshleman <bobbyeshleman@meta.com>, Stanislav Fomichev <sdf@fomichev.me>, linux-kernel@vger.kernel.org, 
	Steffen Klassert <steffen.klassert@secunet.com>, Herbert Xu <herbert@gondor.apana.org.au>, 
	Willem de Bruijn <willemb@google.com>, John Fastabend <john.fastabend@gmail.com>, 
	Sabrina Dubroca <sd@queasysnail.net>, Andrew Lunn <andrew+netdev@lunn.ch>, 
	"Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowangio@gmail.com>, 
	"=?UTF-8?q?Eugenio=20P=C3=A9rez?=" <eperezma@redhat.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	Johannes Berg <johannes@sipsolutions.net>, Byungchul Park <byungchul@sk.com>, Zi Yan <ziy@nvidia.com>, 
	virtualization@lists.linux.dev, linux-mm@kvack.org, bpf@vger.kernel.org, 
	linux-wireless@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, Randy Dunlap <rdunlap@infradead.org>, 
	Lorenzo Bianconi <lorenzo@kernel.org>, Wen Gu <guwen@linux.alibaba.com>, 
	Philo Lu <lulie@linux.alibaba.com>, Justin Chen <justin.chen@broadcom.com>, 
	Florian Fainelli <florian.fainelli@broadcom.com>, Vikas Gupta <vikas.gupta@broadcom.com>, 
	Michael Chan <michael.chan@broadcom.com>, Pavan Chebbi <pavan.chebbi@broadcom.com>, 
	Doug Berger <opendmb@gmail.com>, Nicolai Buchwitz <nb@tipi-net.de>, 
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>, Satish Kharat <satishkh@cisco.com>, 
	Wei Fang <wei.fang@nxp.com>, Frank Li <frank.li@nxp.com>, Shenwei Wang <shenwei.wang@nxp.com>, 
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
	Eric Joyner <eric.joyner@amd.com>, Prabu Thayalan <prabu.ponrajthayalan@amd.com>, 
	"Nikhil P. Rao" <nikhil.rao@amd.com>, Chintan Vankar <c-vankar@ti.com>, 
	Nora Schiffer <nora.schiffer@ew.tq-group.com>, Alexander Sverdlin <alex@sverdlin.org>, 
	Kevin Hao <haokexin@gmail.com>, Karl Mehltretter <kmehltretter@gmail.com>, 
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>, Meghana Malladi <m-malladi@ti.com>, 
	Jacob Keller <jacob.e.keller@intel.com>, StanleyYP Wang <StanleyYP.Wang@mediatek.com>, 
	linux-doc@vger.kernel.org, imx@lists.linux.dev, linux-rdma@vger.kernel.org, 
	linux-hyperv@vger.kernel.org, linux-renesas-soc@vger.kernel.org, 
	linux-omap@vger.kernel.org
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

Use READ_ONCE() and WRITE_ONCE() on pp_magic because every SKB fragment
ref/unref now checks netmem_is_pp(), and page->pp_magic shares a struct
page union word with folio->lru.next which MM code may concurrently
modify on page-cache folios in TX SKBs.

Because pp_ref_count is only incremented by callers that already hold an
active pp_ref_count (>= 1) on that netmem and tcp_zerocopy_receive()
detaches page_pool pages before mapping them into userspace, a raw
page_ref_count is never converted into a pp_ref_count and
page_pool_unref_netmem() keeps its non-RMW fast path unchanged.

bench_page_pool_simple results (5-iteration interleaved UML runs):
- no-softirq-page_pool01 (fast-path cache recycle): 40 cycles (20.3 ns)
  baseline vs 30-31 cycles (15.3 ns) patched (~9-10 cycles / -24.7%
  improvement: using __netmem_to_page() in
  page_pool_netmem_is_exclusively_owned() and
  __page_pool_page_can_be_recycled() after checking netmem_is_net_iov()
  eliminates two redundant WARN_ON_ONCE() expansions and out-of-line
  netmem_to_page() calls per recycle).
- no-softirq-page_pool02 (ptr_ring recycle): 81 cycles (40.7 ns)
  baseline vs 74 cycles (37.2 ns) patched (~7 cycles / -8.6%
  improvement for the same reason).
- no-softirq-page_pool03 (slow page-allocator path with elevated
  page_ref_count): 458-461 cycles (230.0 ns) baseline vs 454-455 cycles
  (227.6 ns) patched (~5 cycles / -1.0% improvement).

Notes:
- __frame_add_frag() in net/wireless/util.c is switched from get_page()
  to skb_frag_ref() (with a MAX_SKB_FRAGS check) so mac80211 A-MSDU
  subframe SKBs on page_pool wireless drivers (such as mt76) pair with
  skb_release_data().
- destroy_record() in net/tls/tls_device.c and fill_sg_in() in
  net/tls/tls_device_fallback.c are switched from netmem_dec_ref() and
  netmem_inc_ref() to put_page() and get_page() so kTLS record->frags[]
  and fallback scatterlists stay on struct page references matching
  tls_create_new_record(), tls_append_frag(), tls_sw_fallback(), and
  mlx5 tx_sync_info_get().
- __xdp_return(MEM_TYPE_PAGE_SHARED) in net/core/xdp.c, veth_xdp_get()
  in drivers/net/veth.c, and virtnet_skb_append_frag() in
  drivers/net/virtio_net.c are switched to netmem_inc_ref() and
  netmem_dec_ref() so page_pool-backed XDP and virtio_net buffers pair
  with netmem_dec_ref().

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
 include/net/netmem.h            |  37 ++++-
 include/net/page_pool/helpers.h |  15 ++
 net/core/gro.c                  |   9 --
 net/core/net_test.c             | 264 ++++++++++++++------------------
 net/core/netmem_priv.h          |  21 ++-
 net/core/page_pool.c            |   6 +-
 net/core/skbuff.c               |  42 ++---
 net/core/xdp.c                  |   2 +-
 net/ipv4/esp4.c                 |  11 +-
 net/ipv6/esp6.c                 |  11 +-
 net/tls/tls_device.c            |   2 +-
 net/tls/tls_device_fallback.c   |   2 +-
 net/wireless/util.c             |  31 +++-
 net/xfrm/trace_iptfs.h          |   6 +-
 net/xfrm/xfrm_iptfs.c           |  13 +-
 20 files changed, 243 insertions(+), 311 deletions(-)

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
index fb693bc1702a4..75c26c8997431 100644
--- a/include/net/netmem.h
+++ b/include/net/netmem.h
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
index c814ce95282eb..fdbb1a4fe11f5 100644
--- a/include/net/page_pool/helpers.h
+++ b/include/net/page_pool/helpers.h
@@ -275,6 +275,14 @@ static inline void page_pool_fragment_page(struct page *page, long nr)
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
@@ -293,6 +301,13 @@ static inline long page_pool_unref_netmem(netmem_ref netmem, long nr)
 	 * handling by ensuring all pages have partitioned into only 1 piece
 	 * initially, and only overwrite it when the page is partitioned into
 	 * more than one piece.
+	 *
+	 * This non-RMW fast path is safe because pp_ref_count is only ever
+	 * incremented by callers that already hold an active pp_ref_count
+	 * (>= 1) on @netmem; a raw page_ref_count is never converted into a
+	 * pp_ref_count. Thus when pp_ref_count == nr, the caller holds all
+	 * remaining pp_ref_count references and no concurrent
+	 * page_pool_ref_netmem() / napi_pp_get_page() can occur.
 	 */
 	if (atomic_long_read(pp_ref_count) == nr) {
 		/* As we have ensured nr is always one for constant case using
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
index e20059a00003c..788aa57c63418 100644
--- a/net/core/net_test.c
+++ b/net/core/net_test.c
@@ -516,6 +516,7 @@ static void ip_tunnel_flags_test_run(struct kunit *test)
 /* Netmem & SKB fragment refcounting */
 
 #include <linux/skbuff_ref.h>
+#include <linux/uio.h>
 #include <net/netmem.h>
 #include <net/netdev_rx_queue.h>
 #include <net/page_pool/helpers.h>
@@ -549,23 +550,11 @@ static void netmem_ref_test_page(struct kunit *test)
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
@@ -610,47 +599,31 @@ static void netmem_ref_test_pp_page(struct kunit *test)
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
@@ -659,10 +632,9 @@ static void netmem_ref_test_pp_page(struct kunit *test)
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
@@ -671,14 +643,13 @@ static void netmem_ref_test_pp_page(struct kunit *test)
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
@@ -687,11 +658,10 @@ static void netmem_ref_test_pp_page(struct kunit *test)
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
@@ -712,7 +682,6 @@ static void netmem_ref_test_pp_page(struct kunit *test)
 	split = alloc_skb(32, GFP_KERNEL);
 	KUNIT_ASSERT_NOT_NULL(test, split);
 	skb_split(skb, split, 16);
-	KUNIT_EXPECT_TRUE(test, split->pp_recycle);
 	KUNIT_EXPECT_EQ(test, atomic_long_read(&page->pp_ref_count),
 			base_pp_ref);
 	KUNIT_EXPECT_EQ(test, page_ref_count(page), base_ref);
@@ -728,7 +697,6 @@ static void netmem_ref_test_pp_page(struct kunit *test)
 	split = alloc_skb(0, GFP_KERNEL);
 	KUNIT_ASSERT_NOT_NULL(test, split);
 	skb_split(skb, split, 32);
-	KUNIT_EXPECT_TRUE(test, split->pp_recycle);
 	KUNIT_EXPECT_EQ(test, atomic_long_read(&page->pp_ref_count),
 			base_pp_ref + 1);
 	KUNIT_EXPECT_EQ(test, page_ref_count(page), base_ref);
@@ -737,14 +705,13 @@ static void netmem_ref_test_pp_page(struct kunit *test)
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
@@ -763,7 +730,6 @@ static void netmem_ref_test_pp_page(struct kunit *test)
 	skb->data_len = 64;
 	split = alloc_skb(0, GFP_KERNEL);
 	KUNIT_ASSERT_NOT_NULL(test, split);
-	split->pp_recycle = 1;
 	KUNIT_EXPECT_EQ(test, skb_shift(split, skb, 16), 16);
 	KUNIT_EXPECT_EQ(test, atomic_long_read(&page->pp_ref_count),
 			base_pp_ref + 2);
@@ -780,17 +746,6 @@ static void netmem_ref_test_pp_page(struct kunit *test)
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
@@ -798,7 +753,7 @@ static void netmem_ref_test_pp_page(struct kunit *test)
 	page_pool_destroy(pool);
 
 	/* Order-1 compound page_pool page: tail netmem resolves to head &
-	 * build_skb(head_frag=1, pp_recycle=1) skb_zerocopy uses pp_ref_count.
+	 * build_skb(head_frag=1) skb_zerocopy uses pp_ref_count.
 	 */
 	pp_params.order = 1;
 	pool = page_pool_create(&pp_params);
@@ -819,7 +774,6 @@ static void netmem_ref_test_pp_page(struct kunit *test)
 
 	skb = build_skb(page_address(page), PAGE_SIZE);
 	KUNIT_ASSERT_NOT_NULL(test, skb);
-	skb->pp_recycle = 1;
 	skb_put(skb, 64);
 	page_pool_ref_page(page);
 
@@ -827,7 +781,6 @@ static void netmem_ref_test_pp_page(struct kunit *test)
 	KUNIT_ASSERT_NOT_NULL(test, copy);
 	skb_put(copy, skb_tailroom(copy));
 	KUNIT_ASSERT_EQ(test, skb_zerocopy(copy, skb, skb->len, 0), 0);
-	KUNIT_EXPECT_TRUE(test, copy->pp_recycle);
 	KUNIT_EXPECT_EQ(test, atomic_long_read(&page->pp_ref_count),
 			base_pp_ref + 2);
 	KUNIT_EXPECT_EQ(test, page_ref_count(page), base_ref);
@@ -841,6 +794,78 @@ static void netmem_ref_test_pp_page(struct kunit *test)
 	page_pool_put_full_page(pool, page, false);
 	page_pool_destroy(pool);
 }
+
+static void netmem_ref_test_tcp_zerocopy_receive_pp(struct kunit *test)
+{
+	struct page_pool_params pp_params = {
+		.order = 0,
+		.pool_size = 4,
+		.nid = NUMA_NO_NODE,
+	};
+	struct sk_buff *rx_skb, *tx_skb;
+	struct page_pool *pool;
+	struct bio_vec bvec;
+	struct iov_iter iter;
+	struct page *pp_page;
+
+	pool = page_pool_create(&pp_params);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, pool);
+	pp_page = page_pool_dev_alloc_pages(pool);
+	if (!pp_page) {
+		page_pool_destroy(pool);
+		KUNIT_ASSERT_NOT_NULL(test, pp_page);
+	}
+
+	rx_skb = alloc_skb(0, GFP_KERNEL);
+	if (!rx_skb) {
+		page_pool_put_full_page(pool, pp_page, false);
+		page_pool_destroy(pool);
+		KUNIT_ASSERT_NOT_NULL(test, rx_skb);
+	}
+	skb_add_rx_frag(rx_skb, 0, pp_page, 0, PAGE_SIZE, PAGE_SIZE);
+	KUNIT_EXPECT_TRUE(test, page_pool_page_is_pp(pp_page));
+	KUNIT_EXPECT_EQ(test, page_pool_ref_count(page_to_netmem(pp_page)), 1L);
+	KUNIT_EXPECT_EQ(test, page_ref_count(pp_page), 1);
+
+	/* Simulate tcp_zerocopy_receive() detaching an order-0 page_pool RX
+	 * fragment before vm_insert_pages() maps it into userspace:
+	 * get_page() + napi_pp_put_page() converts the fragment's sole
+	 * pp_ref_count into a regular page reference and releases the page
+	 * from the page_pool.
+	 */
+	get_page(pp_page);
+	KUNIT_EXPECT_TRUE(test, napi_pp_put_page(page_to_netmem(pp_page)));
+	KUNIT_EXPECT_FALSE(test, page_pool_page_is_pp(pp_page));
+	KUNIT_EXPECT_EQ(test, page_ref_count(pp_page), 1);
+
+	/* Forwarding the detached page into MSG_ZEROCOPY TX via
+	 * zerocopy_fill_skb_from_iter() (where iov_iter_get_pages2() pins
+	 * the page via get_page()) now operates on a normal non-page_pool
+	 * page and balances page_ref_count across TX and RX SKB release.
+	 */
+	tx_skb = alloc_skb(0, GFP_KERNEL);
+	if (!tx_skb) {
+		consume_skb(rx_skb);
+		page_pool_destroy(pool);
+		KUNIT_ASSERT_NOT_NULL(test, tx_skb);
+	}
+	bvec_set_page(&bvec, pp_page, 128, 0);
+	iov_iter_bvec(&iter, ITER_SOURCE, &bvec, 1, 128);
+	KUNIT_EXPECT_EQ(test, zerocopy_fill_skb_from_iter(tx_skb, &iter, 128),
+			0);
+	KUNIT_EXPECT_EQ(test, skb_shinfo(tx_skb)->nr_frags, 1);
+	KUNIT_EXPECT_EQ(test, page_ref_count(pp_page), 2);
+	consume_skb(tx_skb);
+	KUNIT_EXPECT_EQ(test, page_ref_count(pp_page), 1);
+
+	/* Extra ref so we can inspect page_ref_count after freeing rx_skb */
+	get_page(pp_page);
+	consume_skb(rx_skb);
+	KUNIT_EXPECT_EQ(test, page_ref_count(pp_page), 1);
+	put_page(pp_page);
+
+	page_pool_destroy(pool);
+}
 #endif
 
 #if defined(CONFIG_PAGE_POOL) && defined(CONFIG_NET_DEVMEM)
@@ -882,10 +907,10 @@ static void netmem_ref_test_net_iov(struct kunit *test)
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
 
@@ -896,7 +921,7 @@ static void netmem_ref_test_net_iov(struct kunit *test)
 	netmem_or_pp_magic(netmem, PP_SIGNATURE);
 	atomic_long_set(&niov.desc.pp_ref_count, 2);
 
-	/* Layer 0 & 1: net_iov/netmem_inc_ref grab non-pp ref on PP */
+	/* Layer 0 & 1: net_iov_inc_ref uses binding.ref, netmem_inc_ref pp */
 	net_iov_inc_ref(&niov);
 	KUNIT_EXPECT_EQ(test, atomic_long_read(&binding.ref.data->count),
 			base_ref + 1);
@@ -905,6 +930,13 @@ static void netmem_ref_test_net_iov(struct kunit *test)
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
@@ -913,14 +945,13 @@ static void netmem_ref_test_net_iov(struct kunit *test)
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
@@ -928,17 +959,16 @@ static void netmem_ref_test_net_iov(struct kunit *test)
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
@@ -946,7 +976,6 @@ static void netmem_ref_test_net_iov(struct kunit *test)
 	skb->unreadable = 1;
 	KUNIT_ASSERT_EQ(test, skb_zerocopy(copy, skb, skb->len, 0), 0);
 	skb->head_frag = 0;
-	KUNIT_EXPECT_TRUE(test, copy->pp_recycle);
 	KUNIT_EXPECT_EQ(test, atomic_long_read(&niov.desc.pp_ref_count), 3L);
 	KUNIT_EXPECT_EQ(test, atomic_long_read(&binding.ref.data->count),
 			base_ref);
@@ -956,7 +985,6 @@ static void netmem_ref_test_net_iov(struct kunit *test)
 	/* skb_shift balances pp_ref_count on split and merge */
 	copy = alloc_skb(0, GFP_KERNEL);
 	KUNIT_ASSERT_NOT_NULL(test, copy);
-	copy->pp_recycle = 1;
 	KUNIT_EXPECT_EQ(test, skb_shift(copy, skb, 16), 16);
 	KUNIT_EXPECT_EQ(test, atomic_long_read(&niov.desc.pp_ref_count), 3L);
 	KUNIT_EXPECT_EQ(test, atomic_long_read(&binding.ref.data->count),
@@ -969,26 +997,16 @@ static void netmem_ref_test_net_iov(struct kunit *test)
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
@@ -1025,7 +1043,6 @@ static void netmem_ref_test_release_data(struct kunit *test)
 	skb = alloc_skb(64, GFP_KERNEL);
 	KUNIT_ASSERT_NOT_NULL(test, skb);
 	skb_put(skb, 32);
-	skb->pp_recycle = 1;
 	skb_fill_netmem_desc(skb, 0, netmem, 0, 64);
 	skb->len += 64;
 	skb->data_len = 64;
@@ -1038,14 +1055,11 @@ static void netmem_ref_test_release_data(struct kunit *test)
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
@@ -1057,7 +1071,6 @@ static void netmem_ref_test_release_data(struct kunit *test)
 		skb = alloc_skb(64, GFP_KERNEL);
 		KUNIT_ASSERT_NOT_NULL(test, skb);
 		skb_put(skb, 32);
-		skb->pp_recycle = 1;
 		skb_fill_netmem_desc(skb, 0, netmem, 0, 64);
 		skb->len += 64;
 		skb->data_len = 64;
@@ -1068,8 +1081,6 @@ static void netmem_ref_test_release_data(struct kunit *test)
 		KUNIT_ASSERT_EQ(test,
 				pskb_expand_head((i & 1) ? clone1 : skb,
 						 32, 0, GFP_KERNEL), 0);
-		KUNIT_EXPECT_TRUE(test, skb->pp_recycle);
-		KUNIT_EXPECT_TRUE(test, clone1->pp_recycle);
 		KUNIT_EXPECT_EQ(test, atomic_long_read(&page->pp_ref_count),
 				base_pp_ref + 2);
 		KUNIT_EXPECT_EQ(test, page_ref_count(page), base_ref);
@@ -1096,7 +1107,6 @@ static void netmem_ref_test_release_data(struct kunit *test)
 	skb = alloc_skb(64, GFP_KERNEL);
 	KUNIT_ASSERT_NOT_NULL(test, skb);
 	skb_put(skb, 32);
-	skb->pp_recycle = 1;
 	skb_fill_netmem_desc(skb, 0, netmem, 0, 64);
 	skb->len += 64;
 	skb->data_len = 64;
@@ -1105,7 +1115,6 @@ static void netmem_ref_test_release_data(struct kunit *test)
 	/* Carve inside header keeping frag -> pp_ref_count +1 until free */
 	ext = pskb_extract(skb, 16, skb->len - 16, GFP_KERNEL);
 	KUNIT_ASSERT_NOT_NULL(test, ext);
-	KUNIT_EXPECT_TRUE(test, ext->pp_recycle);
 	KUNIT_EXPECT_EQ(test, atomic_long_read(&page->pp_ref_count),
 			base_pp_ref + 2);
 	KUNIT_EXPECT_EQ(test, page_ref_count(page), base_ref);
@@ -1116,7 +1125,6 @@ static void netmem_ref_test_release_data(struct kunit *test)
 	/* Carve + trim + skb_condense ref/unrefs pp_ref_count cleanly */
 	ext = pskb_extract(skb, 16, 48, GFP_KERNEL);
 	KUNIT_ASSERT_NOT_NULL(test, ext);
-	KUNIT_EXPECT_TRUE(test, ext->pp_recycle);
 	KUNIT_EXPECT_EQ(test, atomic_long_read(&page->pp_ref_count),
 			base_pp_ref + 1);
 	KUNIT_EXPECT_EQ(test, page_ref_count(page), base_ref);
@@ -1125,7 +1133,6 @@ static void netmem_ref_test_release_data(struct kunit *test)
 	/* Carve inside nonlinear keeping frag -> pp_ref_count +1 until free */
 	ext = pskb_extract(skb, 48, skb->len - 48, GFP_KERNEL);
 	KUNIT_ASSERT_NOT_NULL(test, ext);
-	KUNIT_EXPECT_TRUE(test, ext->pp_recycle);
 	KUNIT_EXPECT_EQ(test, atomic_long_read(&page->pp_ref_count),
 			base_pp_ref + 2);
 	KUNIT_EXPECT_EQ(test, page_ref_count(page), base_ref);
@@ -1137,12 +1144,10 @@ static void netmem_ref_test_release_data(struct kunit *test)
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
@@ -1164,14 +1169,12 @@ static void netmem_ref_test_release_data(struct kunit *test)
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
@@ -1230,7 +1233,6 @@ static void netmem_ref_test_skb_segment(struct kunit *test)
 	/* 1. Single GSO skb with page_pool net_iov frags */
 	head = alloc_skb(64, GFP_KERNEL);
 	KUNIT_ASSERT_NOT_NULL(test, head);
-	head->pp_recycle = 1;
 	head->protocol = htons(ETH_P_IP);
 	skb_reset_mac_header(head);
 	skb_reset_network_header(head);
@@ -1241,8 +1243,6 @@ static void netmem_ref_test_skb_segment(struct kunit *test)
 
 	segs = skb_segment(head, NETIF_F_SG | NETIF_F_HW_CSUM);
 	KUNIT_ASSERT_FALSE(test, IS_ERR_OR_NULL(segs));
-	for (seg = segs; seg; seg = seg->next)
-		KUNIT_EXPECT_TRUE(test, seg->pp_recycle);
 	KUNIT_EXPECT_EQ(test, atomic_long_read(&niov.desc.pp_ref_count), 6L);
 	KUNIT_EXPECT_EQ(test, atomic_long_read(&binding.ref.data->count),
 			base_iov_ref);
@@ -1251,13 +1251,11 @@ static void netmem_ref_test_skb_segment(struct kunit *test)
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
@@ -1280,8 +1278,6 @@ static void netmem_ref_test_skb_segment(struct kunit *test)
 
 	segs = skb_segment(head, NETIF_F_SG | NETIF_F_HW_CSUM);
 	KUNIT_ASSERT_FALSE(test, IS_ERR_OR_NULL(segs));
-	for (seg = segs; seg; seg = seg->next)
-		KUNIT_EXPECT_TRUE(test, seg->pp_recycle);
 	KUNIT_EXPECT_EQ(test, atomic_long_read(&pp_page->pp_ref_count),
 			base_pp_ref + 4);
 	KUNIT_EXPECT_EQ(test, page_ref_count(pp_page), base_pp_page_ref);
@@ -1292,17 +1288,14 @@ static void netmem_ref_test_skb_segment(struct kunit *test)
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
@@ -1323,11 +1316,8 @@ static void netmem_ref_test_skb_segment(struct kunit *test)
 
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
@@ -1337,16 +1327,14 @@ static void netmem_ref_test_skb_segment(struct kunit *test)
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
@@ -1367,13 +1355,10 @@ static void netmem_ref_test_skb_segment(struct kunit *test)
 
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
@@ -1381,10 +1366,10 @@ static void netmem_ref_test_skb_segment(struct kunit *test)
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
@@ -1392,9 +1377,6 @@ static void netmem_ref_test_skb_segment(struct kunit *test)
 	KUNIT_ASSERT_NOT_NULL(test, head);
 	KUNIT_ASSERT_NOT_NULL(test, list);
 	KUNIT_ASSERT_NOT_NULL(test, seg);
-	head->pp_recycle = 0;
-	list->pp_recycle = 1;
-	seg->pp_recycle = 0;
 	head->protocol = htons(ETH_P_IP);
 	skb_reset_mac_header(head);
 	skb_reset_network_header(head);
@@ -1413,9 +1395,6 @@ static void netmem_ref_test_skb_segment(struct kunit *test)
 
 	segs = skb_segment(head, NETIF_F_SG | NETIF_F_HW_CSUM);
 	KUNIT_ASSERT_FALSE(test, IS_ERR_OR_NULL(segs));
-	KUNIT_EXPECT_FALSE(test, segs->pp_recycle);
-	KUNIT_EXPECT_TRUE(test, segs->next->pp_recycle);
-	KUNIT_EXPECT_FALSE(test, segs->next->next->pp_recycle);
 	KUNIT_EXPECT_EQ(test, atomic_long_read(&pp_page->pp_ref_count),
 			base_pp_ref + 2);
 	KUNIT_EXPECT_EQ(test, page_ref_count(pp_page), base_pp_page_ref);
@@ -1430,7 +1409,6 @@ static void netmem_ref_test_skb_segment(struct kunit *test)
 	 */
 	head = build_skb(page_address(pp_page), PAGE_SIZE);
 	KUNIT_ASSERT_NOT_NULL(test, head);
-	head->pp_recycle = 1;
 	skb_put(head, 32);
 	page_pool_ref_netmem(pp_nm);
 	skb_fill_netmem_desc(head, 0, niov_nm, 0, 32);
@@ -1456,7 +1434,6 @@ static void netmem_ref_test_skb_segment(struct kunit *test)
 	 */
 	head = build_skb(page_address(pp_page), PAGE_SIZE);
 	KUNIT_ASSERT_NOT_NULL(test, head);
-	head->pp_recycle = 1;
 	skb_put(head, 32);
 	page_pool_ref_netmem(pp_nm);
 	skb_zcopy_init(head, &uarg);
@@ -1529,14 +1506,12 @@ static void netmem_ref_test_try_coalesce(struct kunit *test)
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
@@ -1549,7 +1524,7 @@ static void netmem_ref_test_try_coalesce(struct kunit *test)
 	KUNIT_EXPECT_EQ(test, atomic_long_read(&pp_page->pp_ref_count),
 			base_pp_ref);
 
-	/* 2. Cloned pp_recycle=1 from (pp_page + non-PP reg_page fallback):
+	/* 2. Cloned from with mixed pp_page + non-PP reg_page:
 	 * skb_frag_ref(from, i) increments pp_ref_count for pp_page and
 	 * page_ref_count for reg_page.
 	 */
@@ -1558,8 +1533,6 @@ static void netmem_ref_test_try_coalesce(struct kunit *test)
 	KUNIT_ASSERT_NOT_NULL(test, to);
 	KUNIT_ASSERT_NOT_NULL(test, from);
 	skb_put(to, skb_tailroom(to));
-	to->pp_recycle = 1;
-	from->pp_recycle = 1;
 	skb_add_rx_frag(from, 0, pp_page, 0, 32, PAGE_SIZE);
 	page_pool_ref_netmem(pp_nm);
 	skb_add_rx_frag(from, 1, reg_page, 0, 32, PAGE_SIZE);
@@ -1581,7 +1554,7 @@ static void netmem_ref_test_try_coalesce(struct kunit *test)
 	KUNIT_EXPECT_EQ(test, page_ref_count(pp_page), base_pp_page_ref);
 	KUNIT_EXPECT_EQ(test, page_ref_count(reg_page), base_reg_ref);
 
-	/* 3. Cloned unreadable pp_recycle=1 net_iov skb: skb_try_coalesce
+	/* 3. Cloned unreadable PP net_iov skb: skb_try_coalesce
 	 * increments niov.desc.pp_ref_count via skb_frag_ref(from, i).
 	 */
 	to = alloc_skb(0, GFP_KERNEL);
@@ -1589,9 +1562,7 @@ static void netmem_ref_test_try_coalesce(struct kunit *test)
 	KUNIT_ASSERT_NOT_NULL(test, to);
 	KUNIT_ASSERT_NOT_NULL(test, from);
 	skb_put(to, skb_tailroom(to));
-	to->pp_recycle = 1;
 	to->unreadable = 1;
-	from->pp_recycle = 1;
 	skb_add_rx_frag_netmem(from, 0, niov_nm, 0, 64, PAGE_SIZE);
 	napi_pp_get_page(niov_nm);
 
@@ -1674,7 +1645,6 @@ static void netmem_ref_test_tcp_devmem_recv(struct kunit *test)
 	/* 1. Receive via tcp_recvmsg_dmabuf -> SO_DEVMEM_DONTNEED release */
 	skb = alloc_skb(0, GFP_KERNEL);
 	KUNIT_ASSERT_NOT_NULL(test, skb);
-	skb->pp_recycle = 1;
 	skb_add_rx_frag_netmem(skb, 0, niov_nm, 0, 64, PAGE_SIZE);
 	napi_pp_get_page(niov_nm);
 	TCP_SKB_CB(skb)->seq = 0;
@@ -1705,7 +1675,6 @@ static void netmem_ref_test_tcp_devmem_recv(struct kunit *test)
 	 */
 	skb = alloc_skb(0, GFP_KERNEL);
 	KUNIT_ASSERT_NOT_NULL(test, skb);
-	skb->pp_recycle = 1;
 	skb_add_rx_frag_netmem(skb, 0, niov_nm, 0, 64, PAGE_SIZE);
 	napi_pp_get_page(niov_nm);
 	TCP_SKB_CB(skb)->seq = 64;
@@ -1738,6 +1707,7 @@ static struct kunit_case net_test_cases[] = {
 	KUNIT_CASE(netmem_ref_test_page),
 #ifdef CONFIG_PAGE_POOL
 	KUNIT_CASE(netmem_ref_test_pp_page),
+	KUNIT_CASE(netmem_ref_test_tcp_zerocopy_receive_pp),
 #endif
 #if defined(CONFIG_PAGE_POOL) && defined(CONFIG_NET_DEVMEM)
 	KUNIT_CASE(netmem_ref_test_net_iov),
diff --git a/net/core/netmem_priv.h b/net/core/netmem_priv.h
index 23175cb2bd866..e229a1ac87a30 100644
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
index d7c88c0b67e53..33c625b850e33 100644
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
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 19d4ce347c41b..a695c3f64dfd9 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -1056,6 +1056,13 @@ EXPORT_SYMBOL(napi_pp_put_page);
  * Acquires a page_pool reference (pp_ref_count) on @netmem if it belongs to a
  * page_pool. Counterpart to napi_pp_put_page().
  *
+ * If @netmem belongs to a page_pool, the caller MUST already hold an active
+ * pp_ref_count (>= 1) on @netmem (e.g. via an existing skb_frag_t in
+ * skb_frag_ref() or a spliced pipe buffer in skb_pipe_buf_ops). A raw
+ * page_ref_count is never converted into a pp_ref_count (in particular,
+ * tcp_zerocopy_receive() detaches page_pool pages before mapping them into
+ * userspace so GUP callers never observe page_pool pages).
+ *
  * Return: true if @netmem belongs to a page_pool, false otherwise.
  */
 bool napi_pp_get_page(netmem_ref netmem)
@@ -1072,9 +1079,9 @@ bool napi_pp_get_page(netmem_ref netmem)
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
@@ -1089,7 +1096,7 @@ static void skb_free_head(struct sk_buff *skb)
 	unsigned char *head = skb->head;
 
 	if (skb->head_frag) {
-		if (skb_pp_recycle(skb, head))
+		if (skb_pp_recycle(head))
 			return;
 		skb_free_frag(head);
 	} else {
@@ -1114,8 +1121,7 @@ static void skb_release_data(struct sk_buff *skb, enum skb_drop_reason reason)
 	}
 
 	for (i = 0; i < shinfo->nr_frags; i++)
-		skb_netmem_unref(skb_frag_netmem(&shinfo->frags[i]),
-				 skb->pp_recycle);
+		netmem_dec_ref(skb_frag_netmem(&shinfo->frags[i]));
 
 free_head:
 	if (shinfo->frag_list)
@@ -1613,7 +1619,6 @@ static struct sk_buff *__skb_clone(struct sk_buff *n, struct sk_buff *skb)
 	n->nohdr = 0;
 	n->peeked = 0;
 	C(pfmemalloc);
-	C(pp_recycle);
 	n->destructor = NULL;
 	C(alloc_cpu);
 	C(tail);
@@ -2251,7 +2256,6 @@ struct sk_buff *__pskb_copy_fclone(struct sk_buff *skb, int headroom,
 			n = NULL;
 			goto out;
 		}
-		n->pp_recycle = skb->pp_recycle;
 		for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
 			skb_shinfo(n)->frags[i] = skb_shinfo(skb)->frags[i];
 			skb_frag_ref(n, i);
@@ -3941,7 +3945,6 @@ skb_zerocopy(struct sk_buff *to, struct sk_buff *from, int len, int hlen)
 	if (len <= skb_tailroom(to))
 		return skb_copy_bits(from, 0, skb_put(to, len), len);
 
-	to->pp_recycle = from->pp_recycle;
 	if (hlen) {
 		ret = skb_copy_bits(from, 0, skb_put(to, hlen), hlen);
 		if (unlikely(ret))
@@ -4314,7 +4317,6 @@ void skb_split(struct sk_buff *skb, struct sk_buff *skb1, const u32 len)
 
 	skb_shinfo(skb1)->flags |= skb_shinfo(skb)->flags & zc_flags;
 	skb_zerocopy_clone(skb1, skb, 0);
-	skb1->pp_recycle = skb->pp_recycle;
 	if (len < pos)	/* Split line is inside header. */
 		skb_split_inside_header(skb, skb1, len, pos);
 	else		/* Second chunk has no header, nothing to copy. */
@@ -4364,7 +4366,6 @@ int skb_shift(struct sk_buff *tgt, struct sk_buff *skb, int shiftlen)
 	if (skb_zcopy(tgt) || skb_zcopy(skb))
 		return 0;
 
-	DEBUG_NET_WARN_ON_ONCE(tgt->pp_recycle != skb->pp_recycle);
 	DEBUG_NET_WARN_ON_ONCE(skb_cmp_decrypted(tgt, skb));
 
 	todo = shiftlen;
@@ -5108,16 +5109,6 @@ struct sk_buff *skb_segment(struct sk_buff *head_skb,
 
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
@@ -5160,8 +5151,6 @@ struct sk_buff *skb_segment(struct sk_buff *head_skb,
 				goto err;
 			}
 
-			if (!skb_shinfo(nskb)->nr_frags)
-				nskb->pp_recycle = frag_skb->pp_recycle;
 			*nskb_frag = (i < 0) ? skb_head_frag_to_page_desc(frag_skb) : *frag;
 			skb_frag_ref(nskb, skb_shinfo(nskb)->nr_frags);
 			size = skb_frag_size(nskb_frag);
@@ -6311,15 +6300,6 @@ bool skb_try_coalesce(struct sk_buff *to, struct sk_buff *from,
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
index 05abf8e23f78a..3aa1557f107dd 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -143,7 +143,7 @@ static void destroy_record(struct tls_record_info *record)
 	int i;
 
 	for (i = 0; i < record->num_frags; i++)
-		netmem_dec_ref(skb_frag_netmem(&record->frags[i]));
+		put_page(skb_frag_page(&record->frags[i]));
 	kfree(record);
 }
 
diff --git a/net/tls/tls_device_fallback.c b/net/tls/tls_device_fallback.c
index b547027cc879f..7d26546f11eb5 100644
--- a/net/tls/tls_device_fallback.c
+++ b/net/tls/tls_device_fallback.c
@@ -256,7 +256,7 @@ static int fill_sg_in(struct scatterlist *sg_in,
 	for (i = 0; remaining > 0; i++) {
 		skb_frag_t *frag = &record->frags[i];
 
-		netmem_inc_ref(skb_frag_netmem(frag));
+		get_page(skb_frag_page(frag));
 		sg_set_page(sg_in + i, skb_frag_page(frag),
 			    skb_frag_size(frag), skb_frag_off(frag));
 
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
2.56.0.455.g6c5a503b38-goog

